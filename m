From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Tue, 21 Mar 2017 20:36:19 +0100
Message-ID: <CAMJs5B-UVU0VfY2dTidLw_f5Gr5qsDfgdTkf7HGdoPXOJoa26w@mail.gmail.com>
References: <1489996534-8270-1-git-send-email-gengdongjiu@huawei.com>
 <7055772d-2a20-6e0c-2bf8-204bc9ef52a5@arm.com>
 <b912c293-4314-7c90-30a4-2f986feb1670@huawei.com>
 <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com> <58CFF058.8020205@arm.com>
 <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
 <20170321113428.GC15920@cbox> <58D17AF0.2010802@arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8424006236638745727=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 711FE40A6A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:34:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SXr9BAzgy-m5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 15:34:33 -0400 (EDT)
Received: from mail-yw0-f173.google.com (mail-yw0-f173.google.com
 [209.85.161.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0D1D40A14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:34:33 -0400 (EDT)
Received: by mail-yw0-f173.google.com with SMTP id v198so116412122ywc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 12:36:20 -0700 (PDT)
In-Reply-To: <58D17AF0.2010802@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, gengdongjiu <gengdongjiu@huawei.com>, wangxiongfeng2@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============8424006236638745727==
Content-Type: multipart/alternative; boundary=001a113e72b621890d054b42c292

--001a113e72b621890d054b42c292
Content-Type: text/plain; charset=UTF-8

On Tue, Mar 21, 2017 at 8:11 PM, James Morse <james.morse@arm.com> wrote:

> Hi Christoffer,
>
> On 21/03/17 11:34, Christoffer Dall wrote:
> > On Tue, Mar 21, 2017 at 02:32:29PM +0800, gengdongjiu wrote:
> >> On 2017/3/20 23:08, James Morse wrote:
> >>>>>> On 20/03/17 07:55, Dongjiu Geng wrote:
> >>>>>>> In the RAS implementation, hardware pass the virtual SEI
> >>>>>>> syndrome information through the VSESR_EL2, so set the virtual
> >>>>>>> SEI syndrome using physical SEI syndrome el2_elr to pass to
> >>>>>>> the guest OS
> >>>
> >>> How does this work with firmware first?
> >>
> >> I explained it in previous mail about the work flow.
> >
> > When delivering and reporting SEIs to the VM, should this happen
> > directly to the OS running in the VM, or to the guest firmware (e.g.
> > UEFI) running in the VM as well?
>
> 'firmware first' is the ACPI specs name for x86's BIOS or management-mode
> handling the error. On arm64 we have multiple things called firmware, so
> the
> name might be more confusing than helpful.
>
> As far as I understand it, firmware here refers to the secure-world and
> EL3.
> Something like ATF can use SCR_EL3.EA to claim SErrors and external aborts,
> routing them to EL3 where secure platform specific firmware generates CPER
> records.
> For a guest, Qemu takes the role of this EL3-firmware.
>
>
Thanks for the clarification.  So UEFI in the VM would not be involved in
this at all?

My confusion here comes from not thinking about QEMU or KVM as firmware,
but as the machine, so it would be sort of like the functionality is baked
into hardware rather than firmware.

Note that to the VM, the environment will look like hardware without EL3
and without a secure world, so any software assuming there's something
'hidden' behind the available non-secure modes must not decide to disable
features if discovering the lack of a secure world.

Thanks,
-Christoffer

--001a113e72b621890d054b42c292
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Tue, Mar 21, 2017 at 8:11 PM, James Morse <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:james.morse@arm.com" target=3D"_blank">james.morse@arm.com</a=
>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi Christoffer,<br>
<span class=3D""><br>
On 21/03/17 11:34, Christoffer Dall wrote:<br>
&gt; On Tue, Mar 21, 2017 at 02:32:29PM +0800, gengdongjiu wrote:<br>
&gt;&gt; On 2017/3/20 23:08, James Morse wrote:<br>
</span><span class=3D"">&gt;&gt;&gt;&gt;&gt;&gt; On 20/03/17 07:55, Dongjiu=
 Geng wrote:<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; In the RAS implementation, hardware pass the v=
irtual SEI<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; syndrome information through the VSESR_EL2, so=
 set the virtual<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; SEI syndrome using physical SEI syndrome el2_e=
lr to pass to<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; the guest OS<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; How does this work with firmware first?<br>
&gt;&gt;<br>
&gt;&gt; I explained it in previous mail about the work flow.<br>
&gt;<br>
&gt; When delivering and reporting SEIs to the VM, should this happen<br>
&gt; directly to the OS running in the VM, or to the guest firmware (e.g.<b=
r>
&gt; UEFI) running in the VM as well?<br>
<br>
</span>&#39;firmware first&#39; is the ACPI specs name for x86&#39;s BIOS o=
r management-mode<br>
handling the error. On arm64 we have multiple things called firmware, so th=
e<br>
name might be more confusing than helpful.<br>
<br>
As far as I understand it, firmware here refers to the secure-world and EL3=
.<br>
Something like ATF can use SCR_EL3.EA to claim SErrors and external aborts,=
<br>
routing them to EL3 where secure platform specific firmware generates CPER =
records.<br>
For a guest, Qemu takes the role of this EL3-firmware.<br>
<br></blockquote><div><br></div><div>Thanks for the clarification.=C2=A0 So=
 UEFI in the VM would not be involved in this at all?</div><div><br></div><=
div>My confusion here comes from not thinking about QEMU or KVM as firmware=
, but as the machine, so it would be sort of like the functionality is bake=
d into hardware rather than firmware.</div><div><br></div><div>Note that to=
 the VM, the environment will look like hardware without EL3 and without a =
secure world, so any software assuming there&#39;s something &#39;hidden&#3=
9; behind the available non-secure modes must not decide to disable feature=
s if discovering the lack of a secure world.</div><div><br></div><div>Thank=
s,</div><div>-Christoffer=C2=A0</div></div></div></div>

--001a113e72b621890d054b42c292--

--===============8424006236638745727==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8424006236638745727==--
