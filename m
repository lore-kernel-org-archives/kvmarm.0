From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC 00/55] Nested Virtualization on KVM/ARM
Date: Fri, 24 Feb 2017 05:08:05 -0500
Message-ID: <CAHyh4xiCS-oT__eDsJVH45cZiLesNN1=BeMXJM2z1CF9AAytQw@mail.gmail.com>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <20170222182331.GA27653@cbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4476625182653078524=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AFFB40CD5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 05:07:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hPyw0kuL-FAU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Feb 2017 05:07:08 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 782EB40CC6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 05:07:07 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v1OA74Qr022177
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 05:08:09 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 72FD86D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 05:08:09 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 2E80891
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 05:08:09 -0500 (EST)
Received: from mail-vk0-f71.google.com (mail-vk0-f71.google.com
 [209.85.213.71])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v1OA88mk029092
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 05:08:09 -0500
Received: by mail-vk0-f71.google.com with SMTP id 130so9408139vkn.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 02:08:09 -0800 (PST)
Received: from mail-ua0-f170.google.com (mail-ua0-f170.google.com.
 [209.85.217.170])
 by smtp.gmail.com with ESMTPSA id 2sm2038637uaq.9.2017.02.24.02.08.06
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 24 Feb 2017 02:08:06 -0800 (PST)
Received: by mail-ua0-f170.google.com with SMTP id 60so8023315uah.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 02:08:06 -0800 (PST)
In-Reply-To: <20170222182331.GA27653@cbox>
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
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

--===============4476625182653078524==
Content-Type: multipart/alternative; boundary=001a114fa3b6ec8cf9054943e753

--001a114fa3b6ec8cf9054943e753
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Christoffer,

On Wed, Feb 22, 2017 at 1:23 PM, Christoffer Dall <cdall@linaro.org> wrote:

> Hi Jintack,
>
>
> On Mon, Jan 09, 2017 at 01:23:56AM -0500, Jintack Lim wrote:
> > Nested virtualization is the ability to run a virtual machine inside
> another
> > virtual machine. In other words, it=E2=80=99s about running a hyperviso=
r (the
> guest
> > hypervisor) on top of another hypervisor (the host hypervisor).
> >
> > This series supports nested virtualization on arm64. ARM recently
> announced an
> > extension (ARMv8.3) which has support for nested virtualization[1]. Thi=
s
> series
> > is based on the ARMv8.3 specification.
> >
> > Supporting nested virtualization means that the hypervisor provides not
> only
> > EL0/EL1 execution environment with VMs as it usually does, but also the
> > virtualization extensions including EL2 execution environment with the
> VMs.
> > Once the host hypervisor provides those execution environment with the
> VMs,
> > then the guest hypervisor can run its own VMs (nested VMs) naturally.
> >
> > To support nested virtualization on ARM the hypervisor must emulate a
> virtual
> > execution environment consisting of EL2, EL1, and EL0, as the guest
> hypervisor
> > will run in a virtual EL2 mode.  Normally KVM/ARM only emulated a VM
> supporting
> > EL1/0 running in their respective native CPU modes, but with nested
> > virtualization we deprivilege the guest hypervisor and emulate a virtua=
l
> EL2
> > execution mode in EL1 using the hardware features provided by ARMv8.3 t=
o
> trap
> > EL2 operations to EL1. To do that the host hypervisor needs to manage E=
L2
> > register state for the guest hypervisor, and shadow EL1 register state
> that
> > reflects the EL2 register state to run the guest hypervisor in EL1. See
> patch 6
> > through 10 for this.
> >
> > For memory virtualization, the biggest issue is that we now have more
> than two
> > stages of translation when running nested VMs. We choose to merge two
> stage-2
> > page tables (one from the guest hypervisor and the other from the host
> > hypervisor) and create shadow stage-2 page tables, which have mappings
> from the
> > nested VM=E2=80=99s physical addresses to the machine physical addresse=
s. Stage-1
> > translation is done by the hardware as is done for the normal VMs.
> >
> > To provide VGIC support to the guest hypervisor, we emulate the GIC
> > virtualization extensions using trap-and-emulate to a virtual GIC
> Hypervisor
> > Control Interface.  Furthermore, we can still use the GIC VE hardware
> features
> > to deliver virtual interrupts to the nested VM, by directly mapping the
> GIC
> > VCPU interface to the nested VM and switching the content of the GIC
> Hypervisor
> > Control interface when alternating between a nested VM and a normal VM.
> See
> > patches 25 through 32, and 50 through 52 for more information.
> >
> > For timer virtualization, the guest hypervisor expects to have access t=
o
> the
> > EL2 physical timer, the EL1 physical timer and the virtual timer. So,
> the host
> > hypervisor needs to provide all of them. The virtual timer is always
> available
> > to VMs. The physical timer is available to VMs via my previous patch
> series[3].
> > The EL2 physical timer is not supported yet in this RFC. We plan to
> support
> > this as it is required to run other guest hypervisors such as Xen.
> >
> > Even though this work is not complete (see limitations below), I'd
> appreciate
> > early feedback on this RFC. Specifically, I'm interested in:
> > - Is it better to have a kernel config or to make it configurable at
> runtime?
> > - I wonder if the data structure for memory management makes sense.
> > - What architecture version do we support for the guest hypervisor, and
> how?
> >   For example, do we always support all architecture versions or the sa=
me
> >   architecture as the underlying hardware platform? Or is it better
> >   to make it configurable from the userspace?
> > - Initial comments on the overall design?
> >
> > This patch series is based on kvm-arm-for-4.9-rc7 with the patch series
> to provide
> > VMs with the EL1 physical timer[2].
> >
> > Git: https://github.com/columbia/nesting-pub/tree/rfc-v1
> >
> > Testing:
> > We have tested this on ARMv8.0 (Applied Micro X-Gene)[3] since ARMv8.3
> hardware
> > is not available yet. We have paravirtualized the guest hypervisor to
> trap to
> > EL2 as specified in ARMv8.3 specification using hvc instruction. We pla=
n
> to
> > test this on ARMv8.3 model, and will post the result and v2 if necessar=
y.
> >
> > Limitations:
> > - This patch series only supports arm64, not arm. All the patches
> compile on
> >   arm, but I haven't try to boot normal VMs on it.
> > - The guest hypervisor with VHE (ARMv8.1) is not supported in this RFC.
> I have
> >   patches for that, but they need to be cleaned up.
> > - Recursive nesting (i.e. emulating ARMv8.3 in the VM) is not tested ye=
t.
> > - Other hypervisors (such as Xen) on KVM are not tested.
> >
> > TODO:
> > - Test to boot normal VMs on arm architecture
> > - Test this on ARMv8.3 model
> > - Support the guest hypervisor with VHE
> > - Provide the guest hypervisor with the EL2 physical timer
> > - Run other hypervisors such as Xen on KVM
> >
>
> I have a couple of overall questions and comments on this series:


> First, I think we should make sure that the series actually works with
> v8.3 on the model using both VHE and non-VHE for the host hypervisor.
>

I agree. Will send out v2 once I make this work with v8.3 model.


>
> Second, this patch set is pretty large overall and it would be great if
> we could split it up into some slightly more manageable bits.  I'm not
> exactly how to do that, but perhaps we can rework it so that we add bits
> of framework (CPU, memory, interrupt, timers) as individual series, and
> finally we plug all the logic together with the current flow.  What do
> you think?
>

I think it sounds great. I can start with CPU patch series first.


>
> Third, we should follow the feedback from David about not using a kernel
> config option.  I'm afraid that some code will bitrot too fast if guided
> by a kernel config option, so a runtime parameter and using static keys
> where relevant seems like a better approach to me.  But since KVM/ARM is
> not loaded as a module, this would have to be a kernel cmdline
> parameter.  What do people think?
>
> Fourth, there are some places where we have hard-coded information (like
> the location of the GICH/GICV interfaces) which have to be fixed by
> adding the required userspace interfaces.
>

Right. I'll fix them and I'll provide a link which has userspace changes
for this nesting work in the cover letter.


>
> Fifth, the ordering of the patches needs a bit of love. I think it's
> important that we build the whole infrastructure first, but leave it
> completely disabled until the end, and then we plug in all the
> capabilities of userspace to create a nested VM in the end.  So for
> example, I would expect that patch 03 would be the last patch in the
> series.
>

Ah, I got it. I'll reorder patches accordingly.


>
> Overall though, this is a massive amount of work, and it's awesome that
> you were able to pull it together to a pretty nice initial RFC!
>

Thanks a lot for your help and reviews. I'll address individual reviews
soon :)

Thanks,
Jintack


>
> Thanks!
> -Christoffer
>
>

--001a114fa3b6ec8cf9054943e753
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Christoffer,<br><div class=3D"gmail_extra"><br><div cla=
ss=3D"gmail_quote">On Wed, Feb 22, 2017 at 1:23 PM, Christoffer Dall <span =
dir=3D"ltr">&lt;<a href=3D"mailto:cdall@linaro.org" target=3D"_blank">cdall=
@linaro.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi Jint=
ack,<br>
<div><div class=3D"h5"><br>
<br>
On Mon, Jan 09, 2017 at 01:23:56AM -0500, Jintack Lim wrote:<br>
&gt; Nested virtualization is the ability to run a virtual machine inside a=
nother<br>
&gt; virtual machine. In other words, it=E2=80=99s about running a hypervis=
or (the guest<br>
&gt; hypervisor) on top of another hypervisor (the host hypervisor).<br>
&gt;<br>
&gt; This series supports nested virtualization on arm64. ARM recently anno=
unced an<br>
&gt; extension (ARMv8.3) which has support for nested virtualization[1]. Th=
is series<br>
&gt; is based on the ARMv8.3 specification.<br>
&gt;<br>
&gt; Supporting nested virtualization means that the hypervisor provides no=
t only<br>
&gt; EL0/EL1 execution environment with VMs as it usually does, but also th=
e<br>
&gt; virtualization extensions including EL2 execution environment with the=
 VMs.<br>
&gt; Once the host hypervisor provides those execution environment with the=
 VMs,<br>
&gt; then the guest hypervisor can run its own VMs (nested VMs) naturally.<=
br>
&gt;<br>
&gt; To support nested virtualization on ARM the hypervisor must emulate a =
virtual<br>
&gt; execution environment consisting of EL2, EL1, and EL0, as the guest hy=
pervisor<br>
&gt; will run in a virtual EL2 mode.=C2=A0 Normally KVM/ARM only emulated a=
 VM supporting<br>
&gt; EL1/0 running in their respective native CPU modes, but with nested<br=
>
&gt; virtualization we deprivilege the guest hypervisor and emulate a virtu=
al EL2<br>
&gt; execution mode in EL1 using the hardware features provided by ARMv8.3 =
to trap<br>
&gt; EL2 operations to EL1. To do that the host hypervisor needs to manage =
EL2<br>
&gt; register state for the guest hypervisor, and shadow EL1 register state=
 that<br>
&gt; reflects the EL2 register state to run the guest hypervisor in EL1. Se=
e patch 6<br>
&gt; through 10 for this.<br>
&gt;<br>
&gt; For memory virtualization, the biggest issue is that we now have more =
than two<br>
&gt; stages of translation when running nested VMs. We choose to merge two =
stage-2<br>
&gt; page tables (one from the guest hypervisor and the other from the host=
<br>
&gt; hypervisor) and create shadow stage-2 page tables, which have mappings=
 from the<br>
&gt; nested VM=E2=80=99s physical addresses to the machine physical address=
es. Stage-1<br>
&gt; translation is done by the hardware as is done for the normal VMs.<br>
&gt;<br>
&gt; To provide VGIC support to the guest hypervisor, we emulate the GIC<br=
>
&gt; virtualization extensions using trap-and-emulate to a virtual GIC Hype=
rvisor<br>
&gt; Control Interface.=C2=A0 Furthermore, we can still use the GIC VE hard=
ware features<br>
&gt; to deliver virtual interrupts to the nested VM, by directly mapping th=
e GIC<br>
&gt; VCPU interface to the nested VM and switching the content of the GIC H=
ypervisor<br>
&gt; Control interface when alternating between a nested VM and a normal VM=
.=C2=A0 See<br>
&gt; patches 25 through 32, and 50 through 52 for more information.<br>
&gt;<br>
&gt; For timer virtualization, the guest hypervisor expects to have access =
to the<br>
&gt; EL2 physical timer, the EL1 physical timer and the virtual timer. So, =
the host<br>
&gt; hypervisor needs to provide all of them. The virtual timer is always a=
vailable<br>
&gt; to VMs. The physical timer is available to VMs via my previous patch s=
eries[3].<br>
&gt; The EL2 physical timer is not supported yet in this RFC. We plan to su=
pport<br>
&gt; this as it is required to run other guest hypervisors such as Xen.<br>
&gt;<br>
&gt; Even though this work is not complete (see limitations below), I&#39;d=
 appreciate<br>
&gt; early feedback on this RFC. Specifically, I&#39;m interested in:<br>
&gt; - Is it better to have a kernel config or to make it configurable at r=
untime?<br>
&gt; - I wonder if the data structure for memory management makes sense.<br=
>
&gt; - What architecture version do we support for the guest hypervisor, an=
d how?<br>
&gt;=C2=A0 =C2=A0For example, do we always support all architecture version=
s or the same<br>
&gt;=C2=A0 =C2=A0architecture as the underlying hardware platform? Or is it=
 better<br>
&gt;=C2=A0 =C2=A0to make it configurable from the userspace?<br>
&gt; - Initial comments on the overall design?<br>
&gt;<br>
&gt; This patch series is based on kvm-arm-for-4.9-rc7 with the patch serie=
s to provide<br>
&gt; VMs with the EL1 physical timer[2].<br>
&gt;<br>
&gt; Git: <a href=3D"https://github.com/columbia/nesting-pub/tree/rfc-v1" r=
el=3D"noreferrer" target=3D"_blank">https://github.com/columbia/<wbr>nestin=
g-pub/tree/rfc-v1</a><br>
&gt;<br>
&gt; Testing:<br>
&gt; We have tested this on ARMv8.0 (Applied Micro X-Gene)[3] since ARMv8.3=
 hardware<br>
&gt; is not available yet. We have paravirtualized the guest hypervisor to =
trap to<br>
&gt; EL2 as specified in ARMv8.3 specification using hvc instruction. We pl=
an to<br>
&gt; test this on ARMv8.3 model, and will post the result and v2 if necessa=
ry.<br>
&gt;<br>
&gt; Limitations:<br>
&gt; - This patch series only supports arm64, not arm. All the patches comp=
ile on<br>
&gt;=C2=A0 =C2=A0arm, but I haven&#39;t try to boot normal VMs on it.<br>
&gt; - The guest hypervisor with VHE (ARMv8.1) is not supported in this RFC=
. I have<br>
&gt;=C2=A0 =C2=A0patches for that, but they need to be cleaned up.<br>
&gt; - Recursive nesting (i.e. emulating ARMv8.3 in the VM) is not tested y=
et.<br>
&gt; - Other hypervisors (such as Xen) on KVM are not tested.<br>
&gt;<br>
&gt; TODO:<br>
&gt; - Test to boot normal VMs on arm architecture<br>
&gt; - Test this on ARMv8.3 model<br>
&gt; - Support the guest hypervisor with VHE<br>
&gt; - Provide the guest hypervisor with the EL2 physical timer<br>
&gt; - Run other hypervisors such as Xen on KVM<br>
&gt;<br>
<br>
</div></div>I have a couple of overall questions and comments on this serie=
s:=C2=A0</blockquote><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
First, I think we should make sure that the series actually works with<br>
v8.3 on the model using both VHE and non-VHE for the host hypervisor.<br></=
blockquote><div><br></div><div>I agree. Will send out v2 once I make this w=
ork with v8.3 model.</div><div>=C2=A0</div><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Second, this patch set is pretty large overall and it would be great if<br>
we could split it up into some slightly more manageable bits.=C2=A0 I&#39;m=
 not<br>
exactly how to do that, but perhaps we can rework it so that we add bits<br=
>
of framework (CPU, memory, interrupt, timers) as individual series, and<br>
finally we plug all the logic together with the current flow.=C2=A0 What do=
<br>
you think?<br></blockquote><div><br></div><div>I think it sounds great. I c=
an start with CPU patch series first.=C2=A0</div><div>=C2=A0</div><blockquo=
te class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc so=
lid;padding-left:1ex">
<br>
Third, we should follow the feedback from David about not using a kernel<br=
>
config option.=C2=A0 I&#39;m afraid that some code will bitrot too fast if =
guided<br>
by a kernel config option, so a runtime parameter and using static keys<br>
where relevant seems like a better approach to me.=C2=A0 But since KVM/ARM =
is<br>
not loaded as a module, this would have to be a kernel cmdline<br>
parameter.=C2=A0 What do people think?<br>
<br>
Fourth, there are some places where we have hard-coded information (like<br=
>
the location of the GICH/GICV interfaces) which have to be fixed by<br>
adding the required userspace interfaces.<br></blockquote><div><br></div><d=
iv>Right. I&#39;ll fix them and I&#39;ll provide a link which has userspace=
 changes for this nesting work in the cover letter.</div><div>=C2=A0</div><=
blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex">
<br>
Fifth, the ordering of the patches needs a bit of love. I think it&#39;s<br=
>
important that we build the whole infrastructure first, but leave it<br>
completely disabled until the end, and then we plug in all the<br>
capabilities of userspace to create a nested VM in the end.=C2=A0 So for<br=
>
example, I would expect that patch 03 would be the last patch in the<br>
series.<br></blockquote><div><br></div><div>Ah, I got it. I&#39;ll reorder =
patches accordingly.</div><div>=C2=A0<br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x">
<br>
Overall though, this is a massive amount of work, and it&#39;s awesome that=
<br>
you were able to pull it together to a pretty nice initial RFC!<br></blockq=
uote><div><br></div><div>Thanks a lot for your help and reviews. I&#39;ll a=
ddress individual reviews soon :)</div><div><br></div><div>Thanks,</div><di=
v>Jintack</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Thanks!<br>
<span class=3D"HOEnZb"><font color=3D"#888888">-Christoffer<br>
<br>
</font></span></blockquote></div><br></div></div>

--001a114fa3b6ec8cf9054943e753--


--===============4476625182653078524==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4476625182653078524==--
