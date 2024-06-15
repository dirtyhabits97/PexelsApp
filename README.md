# Pexels App

## Requirements

Functional requirements
* The user should be able to see a list of curated images
* The user should be able to see the detail of the image and a high res image
* The user should be able to play a random video in the image detail screen

Non Functional requirements
* Support offline mode

Out of scope
* Realtime video play

## High Level Diagram
Architecture overview of the app:

![Overview](./images/high_level_design.png)

Network overview:
![Network Overview](./images/network_design.png)

## Low Level Design
In order to support offline mode and hide complexity, we will be consuming 
the images and video through the `Repository Layer`.

This Layer will also be in charge of syncing the local storage.

```
ImagesRepository
+ func getImages(page: Int): Observable<[ImageMetadata]>
+ func downloadImage(id: UUID): Observable<Data>
```

When the repository loads the images, it will overwrite the previous images with the batch
we just received. If the `RepositoryLayer` can't make the request due to connectivity issues,
it will serve the images from local repo.

Additionally, we can create a stream to get notifications on the connectivity status:
```
NetworkConnectionStream
+ status: Observable<Status>
```
