# Run time
* with bert-base, bsz=4096, max\_seq=128, samples\_per\_gpu=256, on 3090, I achieved ~570 samples/s
* with 6 hours budget, at 8.6k steps, I got validation loss 2.425 (training loss 2.294)

* compare to Dinkytrain
    * it s faster than DinkyTrain (4096 samples took 10-11 seconds, which translates to ~400samples/s)
    * note: For DinkyTrain, I did not install apex and deeplearning.
