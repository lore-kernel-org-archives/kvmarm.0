From: "Yasutaka, T" <skyfly0008@gmail.com>
Subject: Re: KVM on ARM Cortex A53 in 32-bit Mode
Date: Fri, 17 Mar 2017 01:09:22 -0400
Message-ID: <CAO=Ss3WXPSOfMHd2gg0W2gngtH6c0hvatw-kKHZWb34JC=ba-g@mail.gmail.com>
References: <CAPn9co60wgUms-V_6PBB4CDKeWV_mJzHqg-5wjTchKFi4G9xkg@mail.gmail.com>
 <20170307095559.GB101711@lvm>
 <CAO=Ss3XeBW17XfXroKsS-KbHcJV1E7c8gDBP+CnhyNYDMpeXsg@mail.gmail.com>
 <20170316093849.GT1277@cbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8281775553516448166=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E67540BC5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 01:07:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id adlVRuBczdoD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Mar 2017 01:07:44 -0400 (EDT)
Received: from mail-qt0-f170.google.com (mail-qt0-f170.google.com
 [209.85.216.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22DB940905
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 01:07:43 -0400 (EDT)
Received: by mail-qt0-f170.google.com with SMTP id n21so54801951qta.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 22:09:22 -0700 (PDT)
In-Reply-To: <20170316093849.GT1277@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Yasutaka Tanaka <yt2558@columbia.edu>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============8281775553516448166==
Content-Type: multipart/alternative; boundary=001a1136fb18418aff054ae62e87

--001a1136fb18418aff054ae62e87
Content-Type: text/plain; charset=UTF-8

2017-03-16 5:38 GMT-04:00 Christoffer Dall <cdall@linaro.org>:

> On Wed, Mar 15, 2017 at 07:50:36PM -0400, Yasutaka, T wrote:
> > Hi Christopher and other KVM/ARM community members,
> >
> > I tried the following QEMU and Kernel combinations on Raspberry Pi 3
> > (AArch64 mode) but failed:
> >
> > Latest commit of Alexander Graf's no-kvm-irqchip QEMU branch:
> > https://github.com/agraf/qemu/tree/no-kvm-irqchip
> >
> > raspberrypi/linux's rpi-4.10.y branch (forked from Linux 4.10-rc8?)
> latest
> > commit bb0ff9d059c67e1611c7422f7982a6a4876efe67
> > patched by $(git diff (linux 4.10-rc5 commit
> > 7a308bb3016f57e5be11a677d15b821536419d36) (Christpher's irqs-to-user-v2
> > latest commit d0a7cc725535df1b9cc64b442d246c20a9edb904) )
> >
> > and got the following error:
> >
> > pi@raspberrypi:~/os/graf/no-kvm-irqchip/aarch64-softmmu $
> > qemu-system-aarch64 --enable-kvm -M virt
> > "kvm" accelerator not found.
> > No accelerator found!
>
> You'd need "-machine virt,kernel_irqchip=off" to use the userspace GIC
> emulation.  Perhaps QEMU's error message for trying to initialize the
> in-kernel GIC is just weird.
>

I executed with the flag but still got the same error message (accelerator
not found):

qemu-system-aarch64 --enable-kvm -cpu host -machine
type=virt,kernel_irqchip=off -nographic -smp 1 -m 256 -kernel
aarch64-linux-3.15rc2-buildroot.img --append "console=ttyAMA0"


And I found out that an article saying recent OpenSUSE distro officialy
supports KVM:
https://news.opensuse.org/2016/12/05/opensuse-leap-42-2-gets-64-bit-raspberry-image/

The developer of this distro is the same as the kernel_irqchip=off QEMU
patch author (Alexander Graf), and when I tried the above command on this
[1] distro KVM-QEMU actually worked ("worked" means it reaches to the
buildroot login prompt).

So I guess this distro applied your patches (it proves KVM/QEMU on RPI3 is
actually feasible) and the central reason that my failure of KVM on
Raspibian OS would be just a kernel config problem.

I set my .config file by make menuconfig, but it might need some other
(potentially non-GUI?) configurations. My current config is:
https://gist.github.com/caprice-j/836e3c7627f65c0f3a79e56a8d75368e

I thought I enabled necessary KVM-related flags but I might miss something.

[1]
http://download.opensuse.org/ports/aarch64/distribution/leap/42.2/appliances/openSUSE-Leap42.2-ARM-X11-raspberrypi3.aarch64.raw.xz


> >
> > pi@raspberrypi:~/os/graf/no-kvm-irqchip/aarch64-softmmu $ lkvm run test
> >   # lkvm run -k test -m 448 -c 4 --name guest-1605
> >   Error: Unsupported KVM extension detected: KVM_CAP_IRQCHIP
> >   Fatal: Failed to create virtual GIC
>
> I don't think kvmtool supports running on a system that doesn't have
> in-kernel GIC support.
>
> >
> >
> > which seems strange for me because dmesg shows kernel is 4.10.2-v8+ and
> > Boot CPU is AArach64, all CPUs are initialized in HYP mode and /dev/kvm
> > exists. So I thought GIC emulation is also enabled, or should I need to
> > enable other config flags or do settings?
>
> The RPI3 doesn't have a GIC, so you'll never get KVM emulation of the
> GIC with that board.  Ever.  That's why you want the irqchip in
> userspace patches.
>
> > Or, is this way of applying patch
> > wrong? Current config.gz is:
> > https://gist.github.com/caprice-j/d6e144cb8727df813a4fbe716beac3cb
> >
> > My other concerns are no kvm-ok command is available and /proc/cpuinfo
> does
> > not show flags for virtualization support (I believe RPI3's cortex A53
> > (ARMv8) has builtin virt support and does not show the support flag
> > explicitly in /proc/cpuinfo ... but I'm unsure that is true)
>
> If you have /dev/kvm then KVM as such is running on your system, no need
> to worry further, just fix your setup to emulate the GIC in userspace.
>
> Thanks,
> -Christoffer
>



-- 
Yasutaka TANAKA
M.S. Candidate, Computer Science
Fu Foundation School of Engineering and Applied Science
Columbia University

y.tanaka@columbia.edu

--001a1136fb18418aff054ae62e87
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">2017-03-16 5:38 GMT-04:00 Christoffer Dall <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:cdall@linaro.org" target=3D"_blank">cdall@linaro.org</a>&gt;</s=
pan>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex"><span class=3D"g=
mail-">On Wed, Mar 15, 2017 at 07:50:36PM -0400, Yasutaka, T wrote:<br>
&gt; Hi Christopher and other KVM/ARM community members,<br>
&gt;<br>
&gt; I tried the following QEMU and Kernel combinations on Raspberry Pi 3<b=
r>
&gt; (AArch64 mode) but failed:<br>
&gt;<br>
&gt; Latest commit of Alexander Graf&#39;s no-kvm-irqchip QEMU branch:<br>
&gt; <a href=3D"https://github.com/agraf/qemu/tree/no-kvm-irqchip" rel=3D"n=
oreferrer" target=3D"_blank">https://github.com/agraf/qemu/<wbr>tree/no-kvm=
-irqchip</a><br>
&gt;<br>
&gt; raspberrypi/linux&#39;s rpi-4.10.y branch (forked from Linux 4.10-rc8?=
) latest<br>
&gt; commit bb0ff9d059c67e1611c7422f7982a6<wbr>a4876efe67<br>
&gt; patched by $(git diff (linux 4.10-rc5 commit<br>
&gt; 7a308bb3016f57e5be11a677d15b82<wbr>1536419d36) (Christpher&#39;s irqs-=
to-user-v2<br>
&gt; latest commit d0a7cc725535df1b9cc64b442d246c<wbr>20a9edb904) )<br>
&gt;<br>
&gt; and got the following error:<br>
&gt;<br>
&gt; pi@raspberrypi:~/os/graf/no-<wbr>kvm-irqchip/aarch64-softmmu $<br>
&gt; qemu-system-aarch64 --enable-kvm -M virt<br>
&gt; &quot;kvm&quot; accelerator not found.<br>
&gt; No accelerator found!<br>
<br>
</span>You&#39;d need &quot;-machine virt,kernel_irqchip=3Doff&quot; to use=
 the userspace GIC<br>
emulation.=C2=A0 Perhaps QEMU&#39;s error message for trying to initialize =
the<br>
in-kernel GIC is just weird.<br></blockquote><div><br></div><div>I executed=
 with the flag but still got the same error message (accelerator not found)=
:</div><div><br></div><div>qemu-system-aarch64 --enable-kvm -cpu host -mach=
ine type=3Dvirt,kernel_irqchip=3Doff -nographic -smp 1 -m 256 -kernel aarch=
64-linux-3.15rc2-buildroot.img --append &quot;console=3DttyAMA0&quot;<br></=
div><div><br></div><div><br></div><div>And I found out that an article sayi=
ng recent OpenSUSE distro officialy supports KVM:</div><div><a href=3D"http=
s://news.opensuse.org/2016/12/05/opensuse-leap-42-2-gets-64-bit-raspberry-i=
mage/">https://news.opensuse.org/2016/12/05/opensuse-leap-42-2-gets-64-bit-=
raspberry-image/</a><br></div><div><br></div><div>The developer of this dis=
tro is the same as the kernel_irqchip=3Doff QEMU patch author (Alexander Gr=
af), and when I tried the above command on this [1] distro KVM-QEMU actuall=
y worked (&quot;worked&quot; means it reaches to the buildroot login prompt=
).=C2=A0</div><div><br></div><div>So I guess this distro applied your patch=
es (it proves KVM/QEMU on RPI3 is actually feasible) and the central reason=
 that my failure of KVM on Raspibian OS would be just a kernel config probl=
em.=C2=A0</div><div><br></div><div>I set my .config file by make menuconfig=
, but it might need some other (potentially non-GUI?) configurations. My cu=
rrent config is:=C2=A0<a href=3D"https://gist.github.com/caprice-j/836e3c76=
27f65c0f3a79e56a8d75368e">https://gist.github.com/caprice-j/836e3c7627f65c0=
f3a79e56a8d75368e</a></div><div><br></div><div>I thought I enabled necessar=
y KVM-related flags but I might miss something.</div><div><br></div><div>[1=
]=C2=A0<a href=3D"http://download.opensuse.org/ports/aarch64/distribution/l=
eap/42.2/appliances/openSUSE-Leap42.2-ARM-X11-raspberrypi3.aarch64.raw.xz">=
http://download.opensuse.org/ports/aarch64/distribution/leap/42.2/appliance=
s/openSUSE-Leap42.2-ARM-X11-raspberrypi3.aarch64.raw.xz</a></div><div><br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left:1px solid rgb(204,204,204);padding-left:1ex">
<span class=3D"gmail-"><br>
&gt;<br>
&gt; pi@raspberrypi:~/os/graf/no-<wbr>kvm-irqchip/aarch64-softmmu $ lkvm ru=
n test<br>
&gt;=C2=A0 =C2=A0# lkvm run -k test -m 448 -c 4 --name guest-1605<br>
&gt;=C2=A0 =C2=A0Error: Unsupported KVM extension detected: KVM_CAP_IRQCHIP=
<br>
&gt;=C2=A0 =C2=A0Fatal: Failed to create virtual GIC<br>
<br>
</span>I don&#39;t think kvmtool supports running on a system that doesn&#3=
9;t have<br>
in-kernel GIC support.<br>
<span class=3D"gmail-"><br>
&gt;<br>
&gt;<br>
&gt; which seems strange for me because dmesg shows kernel is 4.10.2-v8+ an=
d<br>
&gt; Boot CPU is AArach64, all CPUs are initialized in HYP mode and /dev/kv=
m<br>
&gt; exists. So I thought GIC emulation is also enabled, or should I need t=
o<br>
&gt; enable other config flags or do settings?<br>
<br>
</span>The RPI3 doesn&#39;t have a GIC, so you&#39;ll never get KVM emulati=
on of the<br>
GIC with that board.=C2=A0 Ever.=C2=A0 That&#39;s why you want the irqchip =
in<br>
userspace patches.<br>
<span class=3D"gmail-"><br>
&gt; Or, is this way of applying patch<br>
&gt; wrong? Current config.gz is:<br>
&gt; <a href=3D"https://gist.github.com/caprice-j/d6e144cb8727df813a4fbe716=
beac3cb" rel=3D"noreferrer" target=3D"_blank">https://gist.github.com/<wbr>=
caprice-j/<wbr>d6e144cb8727df813a4fbe716beac3<wbr>cb</a><br>
&gt;<br>
&gt; My other concerns are no kvm-ok command is available and /proc/cpuinfo=
 does<br>
&gt; not show flags for virtualization support (I believe RPI3&#39;s cortex=
 A53<br>
&gt; (ARMv8) has builtin virt support and does not show the support flag<br=
>
&gt; explicitly in /proc/cpuinfo ... but I&#39;m unsure that is true)<br>
<br>
</span>If you have /dev/kvm then KVM as such is running on your system, no =
need<br>
to worry further, just fix your setup to emulate the GIC in userspace.<br>
<br>
Thanks,<br>
-Christoffer<br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><div class=
=3D"gmail_signature"><div dir=3D"ltr"><div dir=3D"ltr">Yasutaka TANAKA</div=
><div>M.S. Candidate, Computer Science</div><div>Fu Foundation School of En=
gineering and Applied Science</div><div>Columbia University</div><div><br><=
/div><div><a href=3D"mailto:y.tanaka@columbia.edu" target=3D"_blank">y.tana=
ka@columbia.edu</a></div></div></div>
</div></div>

--001a1136fb18418aff054ae62e87--

--===============8281775553516448166==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8281775553516448166==--
