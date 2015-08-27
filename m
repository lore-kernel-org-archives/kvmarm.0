From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: add multiple times opening support to a virtserialport
Date: Thu, 27 Aug 2015 20:30:48 +0200
Message-ID: <20150827183048.GE29439@cbox>
References: <CAHxyncujhHABs1Ld78biVZemeL=AZMqJow3vbCqdASf-1qBb5A@mail.gmail.com>
 <55DF1D6A.4080507@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55DF1D6A.4080507@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: Matt Ma <matt.ma@linaro.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, QEMU Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Aug 27, 2015 at 10:23:38AM -0400, Christopher Covington wrote:
> On 07/24/2015 08:00 AM, Matt Ma wrote:
> > Hi all,
> > 
> > Linaro has developed the foundation for the new Android Emulator code
> > base based on a fairly recent upstream QEMU code base, when we
> > re-based the code, we updated the device model to be more virtio based
> > (for example the drives are now virtio block devices). The aim of this
> > is to minimise the delta between upstream and the Android specific
> > changes to QEMU. One Android emulator specific feature is the
> > AndroidPipe.
> > 
> > AndroidPipe is a communication channel between the guest system and
> > the emulator itself. Guest side device node can be opened by multi
> > processes at the same time with different service name. It has a
> > de-multiplexer on the QEMU side to figure out which service the guest
> > actually wanted, so the first write after opening device node is the
> > service name guest wanted, after QEMU backend receive this service
> > name, create a corresponding communication channel, initialize related
> > component, such as file descriptor which connect to the host socket
> > serve. So each opening in guest will create a separated communication
> > channel.
> > 
> > We can create a separate device for each service type, however some
> > services, such as the OpenGL emulation, need to have multiple open
> > channels at a time. This is currently not possible using the
> > virtserialport which can only be opened once.
> > 
> > Current virtserialport can not  be opened by multiple processes at the
> > same time. I know virtserialport has provided buffers beforehand to
> > cache data from host to guest, so even there is no guest read, data
> > can still be transported from host to guest kernel, when there is
> > guest read request, just copy cached data to user space.
> > 
> > We are not sure clearly whether virtio can support
> > multi-open-per-device semantics or not, followings are just our
> > initial ideas about adding multi-open-per-device feature to a port:
> > 
> > * when there is a open request on a port, kernel will allocate a
> > portclient with new id and __wait_queue_head to track this request
> > * save this portclient in file->private_data
> > * guest kernel pass this portclient info to QEMU and notify that the
> > port has been opened
> > * QEMU backend will create a clientinfo struct to track this
> > communication channel, initialize related component
> > * we may change the kernel side strategy of allocating receiving
> > buffers in advance to a new strategy, that is when there is a read
> > request:
> >     - allocate a port_buffer, put user space buffer address to
> > port_buffer.buf, share memory to avoid memcpy
> >     - put both portclient id(or portclient addrss) and port_buffer.buf
> > to virtqueue, that is the length of buffers chain is 2
> >     - kick to notify QEMU backend to consume read buffer
> >     - QEMU backend read portclient info firstly to find the correct
> > clientinfo, then read host data directly into virtqueue buffer to
> > avoid memcpy
> >     - guest kernel will wait(similarly in block mode, because the user
> > space address has been put into virtqueue) until QEMU backend has
> > consumed buffer(all data/part data/nothing have been sent to host
> > side)
> >     - if nothing has been read from host and file descriptor is in
> > block mode, read request will wait through __wait_queue_head until
> > host side is readable
> > 
> > * above read logic may change the current behavior of transferring
> > data to guest kernel even without guest user read
> > 
> > * when there is a write request:
> >     - allocate a port_buffer, put user space buffer address to
> > port_buffer.buf, share memory to avoid memcpy
> >     - put both portclient id(or portclient addrss) and port_buffer.buf
> > to virtqueue, the length of buffers chain is 2
> >     - kick to notify QEMU backend to consume write buffer
> >     - QEMU backend read portclient info firstly to find the correct
> > clientinfo, then write the virtqueue buffer content to host side as
> > current logic
> >     - guest kernel will wait(similarly in block mode, because the user
> > space address has been put into virtqueue) until QEMU backend has
> > consumed buffer(all data/part data/nothing have been receive from host
> > side)
> >     - if nothing has been sent out and file descriptor is in block
> > mode, write request will wait through __wait_queue_head until host
> > side is writable
> > 
> > We obviously don't want to regress existing virtio behaviour and
> > performance and welcome the communities expertise to point out
> > anything we may have missed out before we get to far down implementing
> > our initial proof-of-concept.

Hi Chris,

> 
> Would virtio-vsock be interesting for your purposes?
> 
> http://events.linuxfoundation.org/sites/events/files/slides/stefanha-kvm-forum-2015.pdf
> 
> (Video doesn't seem to be up yet, but should probably be available eventually
> at the following link)
> 
> https://www.youtube.com/playlist?list=PLW3ep1uCIRfyLNSu708gWG7uvqlolk0ep
> 
Thanks for looking at this lengthy mail.  Yes, we are looking at
virtio-vsock already, and I think this is definietely the right fix.

-Christoffer
