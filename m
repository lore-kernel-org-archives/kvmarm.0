From: Matt Ma <matt.ma@linaro.org>
Subject: add multiple times opening support to a virtserialport
Date: Fri, 24 Jul 2015 19:55:33 +0800
Message-ID: <CAHxynctd+gt3b2PAT6OJxruzU48oG6Uk5tdX9B7OGbbS5COFJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8861002898437882968=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE5765912F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 07:43:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qXLi8X3lM7Pg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2015 07:43:18 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E55358F95
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 07:43:18 -0400 (EDT)
Received: by wibxm9 with SMTP id xm9so24651000wib.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 04:55:33 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============8861002898437882968==
Content-Type: multipart/alternative; boundary=047d7bd916b4639d24051b9dae09

--047d7bd916b4639d24051b9dae09
Content-Type: text/plain; charset=UTF-8

Hi all,

Linaro has developed the foundation for the new Android Emulator code base
based on a fairly recent upstream QEMU code base, when we re-based the
code, we updated the device model to be more virtio based (for example the
drives are now virtio block devices). The aim of this is to minimise the
delta between upstream and the Android specific changes to QEMU. One
Android emulator specific feature is the AndroidPipe.

AndroidPipe is a communication channel between the guest system and the
emulator itself. Guest side device node can be opened by multi processes at
the same time with different service name. It has a de-multiplexer on the
QEMU side to figure out which service the guest actually wanted, so the
first write after opening device node is the service name guest wanted,
after QEMU backend receive this service name, create a corresponding
communication channel, initialize related component, such as file
descriptor which connect to the host socket serve. So each opening in guest
will create a separated communication channel.

We can create a separate device for each service type, however some
services, such as the OpenGL emulation, need to have multiple open channels
at a time. This is currently not possible using the virtserialport which
can only be opened once.

Current virtserialport can not  be opened by multiple processes at the same
time. I know virtserialport has provided buffers beforehand to cache data
from host to guest, so even there is no guest read, data can still be
transported from host to guest kernel, when there is guest read request,
just copy cached data to user space.

We are not sure clearly whether virtio can support multi-open-per-device
semantics or not, followings are just our initial ideas about adding
multi-open-per-device feature to a port:

* when there is a open request on a port, kernel will allocate a portclient
with new id and __wait_queue_head to track this request
* save this portclient in file->private_data
* guest kernel pass this portclient info to QEMU and notify that the port
has been opened
* QEMU backend will create a clientinfo struct to track this communication
channel, initialize related component
* we may change the kernel side strategy of allocating receiving buffers in
advance to a new strategy, that is when there is a read request:
    - allocate a port_buffer, put user space buffer address to
port_buffer.buf, share memory to avoid memcpy
    - put both portclient id(or portclient addrss) and port_buffer.buf to
virtqueue, that is the length of buffers chain is 2
    - kick to notify QEMU backend to consume read buffer
    - QEMU backend read portclient info firstly to find the correct
clientinfo, then read host data directly into virtqueue buffer to avoid
memcpy
    - guest kernel will wait(similarly in block mode, because the user
space address has been put into virtqueue) until QEMU backend has consumed
buffer(all data/part data/nothing have been sent to host side)
    - if nothing has been read from host and file descriptor is in block
mode, read request will wait through __wait_queue_head until host side is
readable

* above read logic may change the current behavior of transferring data to
guest kernel even without guest user read

* when there is a write request:
    - allocate a port_buffer, put user space buffer address to
port_buffer.buf, share memory to avoid memcpy
    - put both portclient id(or portclient addrss) and port_buffer.buf to
virtqueue, the length of buffers chain is 2
    - kick to notify QEMU backend to consume write buffer
    - QEMU backend read portclient info firstly to find the correct
clientinfo, then write the virtqueue buffer content to host side as current
logic
    - guest kernel will wait(similarly in block mode, because the user
space address has been put into virtqueue) until QEMU backend has consumed
buffer(all data/part data/nothing have been receive from host side)
    - if nothing has been sent out and file descriptor is in block mode,
write request will wait through __wait_queue_head until host side is
writable

We obviously don't want to regress existing virtio behaviour and
performance and welcome the communities expertise to point out anything we
may have missed out before we get to far down implementing our initial
proof-of-concept.

Thanks,
Matt Ma

--047d7bd916b4639d24051b9dae09
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<br><br>Linaro has developed the foundation for the=
 new Android Emulator code base based on a fairly recent upstream QEMU code=
 base, when we re-based the code, we updated the device model to be more vi=
rtio based (for example the drives are now virtio block devices). The aim o=
f this is to minimise the delta between upstream and the Android specific c=
hanges to QEMU. One Android emulator specific feature is the AndroidPipe.<b=
r><br>AndroidPipe is a communication channel between the guest system and t=
he emulator itself. Guest side device node can be opened by multi processes=
 at the same time with different service name. It has a de-multiplexer on t=
he QEMU side to figure out which service the guest actually wanted, so the =
first write after opening device node is the service name guest wanted, aft=
er QEMU backend receive this service name, create a corresponding communica=
tion channel, initialize related component, such as file descriptor which c=
onnect to the host socket serve. So each opening in guest will create a sep=
arated communication channel.<br><br>We can create a separate device for ea=
ch service type, however some services, such as the OpenGL emulation, need =
to have multiple open channels at a time. This is currently not possible us=
ing the virtserialport which can only be opened once.<br><br>Current virtse=
rialport can not=C2=A0 be opened by multiple processes at the same time. I =
know virtserialport has provided buffers beforehand to cache data from host=
 to guest, so even there is no guest read, data can still be transported fr=
om host to guest kernel, when there is guest read request, just copy cached=
 data to user space.<br><br>We are not sure clearly whether virtio can supp=
ort multi-open-per-device semantics or not, followings are just our initial=
 ideas about adding multi-open-per-device feature to a port:<br><br>* when =
there is a open request on a port, kernel will allocate a portclient with n=
ew id and __wait_queue_head to track this request<br>* save this portclient=
 in file-&gt;private_data<br>* guest kernel pass this portclient info to QE=
MU and notify that the port has been opened<br>* QEMU backend will create a=
 clientinfo struct to track this communication channel, initialize related =
component<br>* we may change the kernel side strategy of allocating receivi=
ng buffers in advance to a new strategy, that is when there is a read reque=
st:<br>=C2=A0=C2=A0=C2=A0 - allocate a port_buffer, put user space buffer a=
ddress to port_buffer.buf, share memory to avoid memcpy<br>=C2=A0=C2=A0=C2=
=A0 - put both portclient id(or portclient addrss) and port_buffer.buf to v=
irtqueue, that is the length of buffers chain is 2<br>=C2=A0=C2=A0=C2=A0 - =
kick to notify QEMU backend to consume read buffer<br>=C2=A0=C2=A0=C2=A0 - =
QEMU backend read portclient info firstly to find the correct clientinfo, t=
hen read host data directly into virtqueue buffer to avoid memcpy<br>=C2=A0=
=C2=A0=C2=A0 - guest kernel will wait(similarly in block mode, because the =
user space address has been put into virtqueue) until QEMU backend has cons=
umed buffer(all data/part data/nothing have been sent to host side)<br>=C2=
=A0=C2=A0=C2=A0 - if nothing has been read from host and file descriptor is=
 in block mode, read request will wait through __wait_queue_head until host=
 side is readable<br><br>* above read logic may change the current behavior=
 of transferring data to guest kernel even without guest user read<br><br>*=
 when there is a write request:<br>=C2=A0=C2=A0=C2=A0 - allocate a port_buf=
fer, put user space buffer address to port_buffer.buf, share memory to avoi=
d memcpy<br>=C2=A0=C2=A0=C2=A0 - put both portclient id(or portclient addrs=
s) and port_buffer.buf to virtqueue, the length of buffers chain is 2<br>=
=C2=A0=C2=A0=C2=A0 - kick to notify QEMU backend to consume write buffer<br=
>=C2=A0=C2=A0=C2=A0 - QEMU backend read portclient info firstly to find the=
 correct clientinfo, then write the virtqueue buffer content to host side a=
s current logic<br>=C2=A0=C2=A0=C2=A0 - guest kernel will wait(similarly in=
 block mode, because the user space address has been put into virtqueue) un=
til QEMU backend has consumed buffer(all data/part data/nothing have been r=
eceive from host side)<br>=C2=A0=C2=A0=C2=A0 - if nothing has been sent out=
 and file descriptor is in block mode, write request will wait through __wa=
it_queue_head until host side is writable<br><br>We obviously don&#39;t wan=
t to regress existing virtio behaviour and performance and welcome the comm=
unities expertise to point out anything we may have missed out before we ge=
t to far down implementing our initial proof-of-concept.<br><br>Thanks,<br>=
Matt Ma<br></div>

--047d7bd916b4639d24051b9dae09--

--===============8861002898437882968==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8861002898437882968==--
