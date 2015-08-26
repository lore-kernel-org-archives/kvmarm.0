From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: virtio-serial: Add multiple times opening support to
 virtserialport(port)
Date: Wed, 26 Aug 2015 10:26:13 +0200
Message-ID: <1440577573.32587.11.camel@redhat.com>
References: <CAHxyncvh+iECmEq4OADax9vsK_GGpCtZQBWd6cXsn4T9tVRFiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHxyncvh+iECmEq4OADax9vsK_GGpCtZQBWd6cXsn4T9tVRFiw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Ma <matt.ma@linaro.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

  Hi,

> AndroidPipe is a communication channel between the guest system and
> the emulator itself. Guest side device node can be opened by multi
> processes at the same time with different service name. It has a
> de-multiplexer on the QEMU side to figure out which service the guest
> actually wanted, so the first write after opening device node is the
> service name guest wanted, after QEMU backend receive this service
> name, create a corresponding communication channel, initialize related
> component, such as file descriptor which connect to the host socket
> serve. So each opening in guest will create a separated communication
> channel.
> 
> We can create a separate device for each service type, however some
> services, such as the OpenGL emulation, need to have multiple open
> channels at a time. This is currently not possible using the
> virtserialport which can only be opened once.

vsock probably works better then:

http://events.linuxfoundation.org/sites/events/files/slides/stefanha-kvm-forum-2015.pdf

Also: for opengl you might want check out virtio-gpu (assuming you can
build mesa for android).

https://www.kraxel.org/slides/qemu-opengl/

cheers,
  Gerd
