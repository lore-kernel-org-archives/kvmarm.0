From: "Yasutaka, T" <skyfly0008@gmail.com>
Subject: Re: KVM on ARM Cortex A53 in 32-bit Mode
Date: Wed, 15 Mar 2017 19:50:36 -0400
Message-ID: <CAO=Ss3XeBW17XfXroKsS-KbHcJV1E7c8gDBP+CnhyNYDMpeXsg@mail.gmail.com>
References: <CAPn9co60wgUms-V_6PBB4CDKeWV_mJzHqg-5wjTchKFi4G9xkg@mail.gmail.com>
 <20170307095559.GB101711@lvm>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1009766491747871023=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B78A0405DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 19:49:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zyAEOp4DtTvi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Mar 2017 19:49:01 -0400 (EDT)
Received: from mail-qk0-f180.google.com (mail-qk0-f180.google.com
 [209.85.220.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3451E40296
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 19:49:00 -0400 (EDT)
Received: by mail-qk0-f180.google.com with SMTP id v127so26731384qkb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 16:50:37 -0700 (PDT)
In-Reply-To: <20170307095559.GB101711@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Yasutaka Tanaka <yt2558@columbia.edu>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============1009766491747871023==
Content-Type: multipart/alternative; boundary=94eb2c03d616777db9054acd9c92

--94eb2c03d616777db9054acd9c92
Content-Type: text/plain; charset=UTF-8

Hi Christopher and other KVM/ARM community members,

I tried the following QEMU and Kernel combinations on Raspberry Pi 3
(AArch64 mode) but failed:

Latest commit of Alexander Graf's no-kvm-irqchip QEMU branch:
https://github.com/agraf/qemu/tree/no-kvm-irqchip

raspberrypi/linux's rpi-4.10.y branch (forked from Linux 4.10-rc8?) latest
commit bb0ff9d059c67e1611c7422f7982a6a4876efe67
patched by $(git diff (linux 4.10-rc5 commit
7a308bb3016f57e5be11a677d15b821536419d36) (Christpher's irqs-to-user-v2
latest commit d0a7cc725535df1b9cc64b442d246c20a9edb904) )

and got the following error:

pi@raspberrypi:~/os/graf/no-kvm-irqchip/aarch64-softmmu $
qemu-system-aarch64 --enable-kvm -M virt
"kvm" accelerator not found.
No accelerator found!

pi@raspberrypi:~/os/graf/no-kvm-irqchip/aarch64-softmmu $ lkvm run test
  # lkvm run -k test -m 448 -c 4 --name guest-1605
  Error: Unsupported KVM extension detected: KVM_CAP_IRQCHIP
  Fatal: Failed to create virtual GIC


which seems strange for me because dmesg shows kernel is 4.10.2-v8+ and
Boot CPU is AArach64, all CPUs are initialized in HYP mode and /dev/kvm
exists. So I thought GIC emulation is also enabled, or should I need to
enable other config flags or do settings? Or, is this way of applying patch
wrong? Current config.gz is:
https://gist.github.com/caprice-j/d6e144cb8727df813a4fbe716beac3cb

My other concerns are no kvm-ok command is available and /proc/cpuinfo does
not show flags for virtualization support (I believe RPI3's cortex A53
(ARMv8) has builtin virt support and does not show the support flag
explicitly in /proc/cpuinfo ... but I'm unsure that is true)

pi@raspberrypi:~/os/graf/no-kvm-irqchip/aarch64-softmmu $ cat /proc/cpuinfo
processor       : 0
BogoMIPS        : 38.40
Features        : fp asimd evtstrm crc32
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 4

I would be delighted if someone gives me suggestions.

Yasutaka

2017-03-07 4:55 GMT-05:00 Christoffer Dall <christoffer.dall@linaro.org>:

> Hi Yasutaka,
>
> On Thu, Mar 02, 2017 at 09:57:50AM -0500, Yasutaka Tanaka wrote:
> > Hello KVM/ARM community,
> >
> > I am now trying to execute KVM on Raspberry Pi 3 Model B (RPI3).
> > Does anyone know whether KVM/ARM can run with 32-bit mode on ARM Cortex
> A53?
>
> Theoretically, it should.
>
> >
> > The CPU of RPI3 is ARM Cortex A53 which can be executed in both 32-bit
> and
> > 64-bit mode. I've managed to display /dev/kvm on 64-bit mode execution
> > (i.e. with a 64-bit linux kernel) on RPI3, but I failed to do so in
> 32-bit
> > mode.
> >
> > In 32-bit mode, an KVM error messages says CPU not supported. I guess the
> > reason for the error message is KVM_ARM_TARGET_CORTEX_A53 is only
> returned
> > in /arch/arm64/kvm/guest.c not under/arch/arm/kvm/guest.c.
> >
> > So I'm wondering whether it's possible or not.
>
> It should be.  You may just have to add the minimal missing definitions
> for a 32-bit A53 CPU support.
>
> > What I'd like to do is to
> > compare the execution speed of KVM between 32-bit and 64-bit mode. The
> > second plan is to compare between KVMs of 32-bit RPI2 and 64-bit RPI3 (I
> > have both), but since RPI2 spec is a little low and I'm worried that some
> > numeric comparisons become unfair.
>
> I would be careful here, since the RPI3 doesn't have the GIC and you'll
> end up going to user space a lot for interrupt handling.  Especially
> look out for SMP workloads in the VM which may generate a lot of IPIs
> which are really going to suffer from having to go to userspace on the
> host.
>
> >
> > (I was also notified by an KVM/ARM expert that since RPI doesn't have a
> GIC
> > and I need to apply some patches)
>
> Yes, you need the "Support userspace irqchip with arch timers" series
> and corresponding QEMU patches:
>
> http://www.spinics.net/lists/kvm/msg144685.html
>
> Good luck.
> -Christoffer
>



-- 
Yasutaka TANAKA
M.S. Candidate, Computer Science
Fu Foundation School of Engineering and Applied Science
Columbia University

y.tanaka@columbia.edu

--94eb2c03d616777db9054acd9c92
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Christopher and other KVM/ARM community members,</=
div><div><br></div><div>I tried the following QEMU and Kernel combinations =
on Raspberry Pi 3 (AArch64 mode) but failed:</div><div><br></div><div>Lates=
t commit of Alexander Graf&#39;s no-kvm-irqchip QEMU branch: <a href=3D"htt=
ps://github.com/agraf/qemu/tree/no-kvm-irqchip">https://github.com/agraf/qe=
mu/tree/no-kvm-irqchip</a></div><div><br></div><div>raspberrypi/linux&#39;s=
 rpi-4.10.y branch (forked from Linux 4.10-rc8?) latest commit bb0ff9d059c6=
7e1611c7422f7982a6a4876efe67</div><div>patched by $(git diff (linux 4.10-rc=
5 commit 7a308bb3016f57e5be11a677d15b821536419d36) (Christpher&#39;s irqs-t=
o-user-v2 latest commit d0a7cc725535df1b9cc64b442d246c20a9edb904) )</div><d=
iv><br></div><div>and got the following error:</div><div><br></div><div>pi@=
raspberrypi:~/os/graf/no-kvm-irqchip/aarch64-softmmu $ qemu-system-aarch64 =
--enable-kvm -M virt</div><div>&quot;kvm&quot; accelerator not found.</div>=
<div>No accelerator found!</div><div><br></div><div>pi@raspberrypi:~/os/gra=
f/no-kvm-irqchip/aarch64-softmmu $ lkvm run test</div><div>=C2=A0 # lkvm ru=
n -k test -m 448 -c 4 --name guest-1605</div><div>=C2=A0 Error: Unsupported=
 KVM extension detected: KVM_CAP_IRQCHIP</div><div>=C2=A0 Fatal: Failed to =
create virtual GIC</div><div><br></div><div><br></div><div>which seems stra=
nge for me because dmesg shows kernel is 4.10.2-v8+ and Boot CPU is AArach6=
4, all CPUs are initialized in HYP mode and /dev/kvm exists. So I thought G=
IC emulation is also enabled, or should I need to enable other config flags=
 or do settings? Or, is this way of applying patch wrong? Current config.gz=
 is: <a href=3D"https://gist.github.com/caprice-j/d6e144cb8727df813a4fbe716=
beac3cb">https://gist.github.com/caprice-j/d6e144cb8727df813a4fbe716beac3cb=
</a></div><div><br></div><div>My other concerns are no kvm-ok command is av=
ailable and /proc/cpuinfo does not show flags for virtualization support (I=
 believe RPI3&#39;s cortex A53 (ARMv8) has builtin virt support and does no=
t show the support flag explicitly in /proc/cpuinfo ... but I&#39;m unsure =
that is true)</div><div><br></div><div>pi@raspberrypi:~/os/graf/no-kvm-irqc=
hip/aarch64-softmmu $ cat /proc/cpuinfo</div><div>processor =C2=A0 =C2=A0 =
=C2=A0 : 0</div><div>BogoMIPS =C2=A0 =C2=A0 =C2=A0 =C2=A0: 38.40</div><div>=
Features =C2=A0 =C2=A0 =C2=A0 =C2=A0: fp asimd evtstrm crc32</div><div>CPU =
implementer : 0x41</div><div>CPU architecture: 8</div><div>CPU variant =C2=
=A0 =C2=A0 : 0x0</div><div>CPU part =C2=A0 =C2=A0 =C2=A0 =C2=A0: 0xd03</div=
><div>CPU revision =C2=A0 =C2=A0: 4</div><div><br></div><div>I would be del=
ighted if someone gives me suggestions.</div><div><br></div><div>Yasutaka</=
div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">2017-03=
-07 4:55 GMT-05:00 Christoffer Dall <span dir=3D"ltr">&lt;<a href=3D"mailto=
:christoffer.dall@linaro.org" target=3D"_blank">christoffer.dall@linaro.org=
</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi Yasutaka,<br>
<span class=3D""><br>
On Thu, Mar 02, 2017 at 09:57:50AM -0500, Yasutaka Tanaka wrote:<br>
&gt; Hello KVM/ARM community,<br>
&gt;<br>
&gt; I am now trying to execute KVM on Raspberry Pi 3 Model B (RPI3).<br>
&gt; Does anyone know whether KVM/ARM can run with 32-bit mode on ARM Corte=
x A53?<br>
<br>
</span>Theoretically, it should.<br>
<span class=3D""><br>
&gt;<br>
&gt; The CPU of RPI3 is ARM Cortex A53 which can be executed in both 32-bit=
 and<br>
&gt; 64-bit mode. I&#39;ve managed to display /dev/kvm on 64-bit mode execu=
tion<br>
&gt; (i.e. with a 64-bit linux kernel) on RPI3, but I failed to do so in 32=
-bit<br>
&gt; mode.<br>
&gt;<br>
&gt; In 32-bit mode, an KVM error messages says CPU not supported. I guess =
the<br>
&gt; reason for the error message is KVM_ARM_TARGET_CORTEX_A53 is only retu=
rned<br>
&gt; in /arch/arm64/kvm/guest.c not under/arch/arm/kvm/guest.c.<br>
&gt;<br>
&gt; So I&#39;m wondering whether it&#39;s possible or not.<br>
<br>
</span>It should be.=C2=A0 You may just have to add the minimal missing def=
initions<br>
for a 32-bit A53 CPU support.<br>
<span class=3D""><br>
&gt; What I&#39;d like to do is to<br>
&gt; compare the execution speed of KVM between 32-bit and 64-bit mode. The=
<br>
&gt; second plan is to compare between KVMs of 32-bit RPI2 and 64-bit RPI3 =
(I<br>
&gt; have both), but since RPI2 spec is a little low and I&#39;m worried th=
at some<br>
&gt; numeric comparisons become unfair.<br>
<br>
</span>I would be careful here, since the RPI3 doesn&#39;t have the GIC and=
 you&#39;ll<br>
end up going to user space a lot for interrupt handling.=C2=A0 Especially<b=
r>
look out for SMP workloads in the VM which may generate a lot of IPIs<br>
which are really going to suffer from having to go to userspace on the<br>
host.<br>
<span class=3D""><br>
&gt;<br>
&gt; (I was also notified by an KVM/ARM expert that since RPI doesn&#39;t h=
ave a GIC<br>
&gt; and I need to apply some patches)<br>
<br>
</span>Yes, you need the &quot;Support userspace irqchip with arch timers&q=
uot; series<br>
and corresponding QEMU patches:<br>
<br>
<a href=3D"http://www.spinics.net/lists/kvm/msg144685.html" rel=3D"noreferr=
er" target=3D"_blank">http://www.spinics.net/lists/<wbr>kvm/msg144685.html<=
/a><br>
<br>
Good luck.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">-Christoffer<br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div di=
r=3D"ltr"><div dir=3D"ltr">Yasutaka TANAKA</div><div>M.S. Candidate, Comput=
er Science</div><div>Fu Foundation School of Engineering and Applied Scienc=
e</div><div>Columbia University</div><div><br></div><div><a href=3D"mailto:=
y.tanaka@columbia.edu" target=3D"_blank">y.tanaka@columbia.edu</a></div></d=
iv></div>
</div>

--94eb2c03d616777db9054acd9c92--

--===============1009766491747871023==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1009766491747871023==--
