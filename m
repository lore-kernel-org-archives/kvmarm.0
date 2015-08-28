From: Matt Ma <matt.ma@linaro.org>
Subject: Re: virtio-serial: Add multiple times opening support to
 virtserialport(port)
Date: Fri, 28 Aug 2015 09:54:43 +0800
Message-ID: <CAHxyncsssCnxHEeV7cXvpjpB=VZkPYmBJ=he24mRfKkRqBWzyA@mail.gmail.com>
References: <CAHxyncvh+iECmEq4OADax9vsK_GGpCtZQBWd6cXsn4T9tVRFiw@mail.gmail.com>
 <1440577573.32587.11.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4371735970071520039=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2EB4487B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Aug 2015 21:54:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QH5carS0ewk0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Aug 2015 21:54:38 -0400 (EDT)
Received: from mail-ob0-f177.google.com (mail-ob0-f177.google.com
 [209.85.214.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F41E346FDA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Aug 2015 21:54:37 -0400 (EDT)
Received: by obkg7 with SMTP id g7so31547518obk.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Aug 2015 18:54:43 -0700 (PDT)
In-Reply-To: <1440577573.32587.11.camel@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============4371735970071520039==
Content-Type: multipart/alternative; boundary=001a11c30284193cbc051e555ec4

--001a11c30284193cbc051e555ec4
Content-Type: text/plain; charset=UTF-8

Hi Gerd,

On 26 August 2015 at 16:26, Gerd Hoffmann <kraxel@redhat.com> wrote:

>   Hi,
>
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
>
> vsock probably works better then:
>
>
> http://events.linuxfoundation.org/sites/events/files/slides/stefanha-kvm-forum-2015.pdf
>
> Also: for opengl you might want check out virtio-gpu (assuming you can
> build mesa for android).
>
> https://www.kraxel.org/slides/qemu-opengl/
>
> cheers,
>   Gerd
>
> Thanks for looking at this  mail. It may be suitable for our target, and
we are
looking at virtio-vsock already.

Thanks,
-Matt

--001a11c30284193cbc051e555ec4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Gerd,<br><div class=3D"gmail_extra"><br><div class=3D"g=
mail_quote">On 26 August 2015 at 16:26, Gerd Hoffmann <span dir=3D"ltr">&lt=
;<a href=3D"mailto:kraxel@redhat.com" target=3D"_blank">kraxel@redhat.com</=
a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0=
pt 0pt 0pt 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">=
=C2=A0 Hi,<br>
<span><br>
&gt; AndroidPipe is a communication channel between the guest system and<br=
>
&gt; the emulator itself. Guest side device node can be opened by multi<br>
&gt; processes at the same time with different service name. It has a<br>
&gt; de-multiplexer on the QEMU side to figure out which service the guest<=
br>
&gt; actually wanted, so the first write after opening device node is the<b=
r>
&gt; service name guest wanted, after QEMU backend receive this service<br>
&gt; name, create a corresponding communication channel, initialize related=
<br>
&gt; component, such as file descriptor which connect to the host socket<br=
>
&gt; serve. So each opening in guest will create a separated communication<=
br>
&gt; channel.<br>
&gt;<br>
&gt; We can create a separate device for each service type, however some<br=
>
&gt; services, such as the OpenGL emulation, need to have multiple open<br>
&gt; channels at a time. This is currently not possible using the<br>
&gt; virtserialport which can only be opened once.<br>
<br>
</span>vsock probably works better then:<br>
<br>
<a href=3D"http://events.linuxfoundation.org/sites/events/files/slides/stef=
anha-kvm-forum-2015.pdf" rel=3D"noreferrer" target=3D"_blank">http://events=
.linuxfoundation.org/sites/events/files/slides/stefanha-kvm-forum-2015.pdf<=
/a><br>
<br>
Also: for opengl you might want check out virtio-gpu (assuming you can<br>
build mesa for android).<br>
<br>
<a href=3D"https://www.kraxel.org/slides/qemu-opengl/" rel=3D"noreferrer" t=
arget=3D"_blank">https://www.kraxel.org/slides/qemu-opengl/</a><br>
<br>
cheers,<br>
=C2=A0 Gerd<br>
<br></blockquote><div>Thanks for looking at this=C2=A0 mail. It may be suit=
able for our target, and we are <br>looking at virtio-vsock already.<br><br=
></div><div>Thanks,<br></div><div>-Matt<br> </div></div><br></div></div>

--001a11c30284193cbc051e555ec4--

--===============4371735970071520039==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4371735970071520039==--
