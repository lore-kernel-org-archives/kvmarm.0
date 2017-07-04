From: Raz <raziebe@gmail.com>
Subject: Re: How to trap a real interrupt to EL2 ?
Date: Tue, 4 Jul 2017 19:32:37 +0000
Message-ID: <CAPB=Z-oZtJyOewtAMsK7iSWnhrhv5iX90HmV0FMj_E5DHy7d-g@mail.gmail.com>
References: <CAPB=Z-o0-fGEvaxmwUVnSUTUAVWa0GgWupaaFcjJNecpeX3mrQ@mail.gmail.com>
 <20170704111212.GQ4066@cbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8322782639677430205=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D63340D2F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jul 2017 15:32:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ySa5qcpaNtkh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jul 2017 15:32:38 -0400 (EDT)
Received: from mail-lf0-f41.google.com (mail-lf0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 277D840D1D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jul 2017 15:32:38 -0400 (EDT)
Received: by mail-lf0-f41.google.com with SMTP id h22so123248431lfk.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jul 2017 12:32:59 -0700 (PDT)
In-Reply-To: <20170704111212.GQ4066@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, jintack.lim@linaro.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============8322782639677430205==
Content-Type: multipart/alternative; boundary="001a1140d866695f43055382f37a"

--001a1140d866695f43055382f37a
Content-Type: text/plain; charset="UTF-8"

The entry woken in the vector is IRQ 64-bit EL1 ( same as el1_irq in
kvn/hyp.S ).
ESR_EL2.EC =  0x16 -" HVC executed in EL2".  It does not change.

Jintack
CPSR.I is 1 , but I do not think I can just clear it, if that what you
mean...

Chrtistoph

You deactivate traps in kvm_vcpu_return( called from el1_irq).
Does it mean we cannot exit-enter the hypervisor when hcr_el2.IMO is
enabled ?

thx





On Tue, Jul 4, 2017 at 11:12 AM, Christoffer Dall <cdall@linaro.org> wrote:

> On Mon, Jul 03, 2017 at 09:56:06PM +0000, Raz wrote:
> > Hey
> >
> > I am trying to trap any real IRQ  into EL2.
> > I created a thin hypervisor with mmu enabled and set hcr_el2 as follows:
> > hcr_el2= HCR_IMO  | HCR_VM | HCR_RW.
> >
> >
> > Now it seems that once I set hcr_el2 to the above value and then exit
> from
> > EL2 I immediately jump back to EL2.
>
> You could read the ESR_EL2 and figure out what caused the exception...
>
> -Christoffer
>



-- 
https://sites.google.com/site/ironspeedlinux/

--001a1140d866695f43055382f37a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div>The entry woken in the vector is =
IRQ 64-bit EL1 ( same as el1_irq in kvn/hyp.S ). <br><a href=3D"http://ESR_=
EL2.EC">ESR_EL2.EC</a> =3D=C2=A0 0x16 -&quot; HVC executed in EL2&quot;.=C2=
=A0 It does not change.<br>=C2=A0<br></div>Jintack <br>CPSR.I is 1 , but I =
do not think I can just clear it, if that what you mean...<br></div>=C2=A0<=
br></div>Chrtistoph<br><br>You deactivate traps in kvm_vcpu_return( called =
from el1_irq).=C2=A0=C2=A0 <br></div>Does it mean we cannot exit-enter the =
hypervisor when hcr_el2.IMO is enabled ?<br><br></div>thx <br><div><div><di=
v><div><div><div><div><br><br><br>=C2=A0 =C2=A0 <br></div></div></div></div=
></div></div></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail=
_quote">On Tue, Jul 4, 2017 at 11:12 AM, Christoffer Dall <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:cdall@linaro.org" target=3D"_blank">cdall@linaro.org=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">O=
n Mon, Jul 03, 2017 at 09:56:06PM +0000, Raz wrote:<br>
&gt; Hey<br>
&gt;<br>
&gt; I am trying to trap any real IRQ=C2=A0 into EL2.<br>
&gt; I created a thin hypervisor with mmu enabled and set hcr_el2 as follow=
s:<br>
&gt; hcr_el2=3D HCR_IMO=C2=A0 | HCR_VM | HCR_RW.<br>
&gt;<br>
&gt;<br>
&gt; Now it seems that once I set hcr_el2 to the above value and then exit =
from<br>
&gt; EL2 I immediately jump back to EL2.<br>
<br>
</span>You could read the ESR_EL2 and figure out what caused the exception.=
..<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Christoffer<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div clas=
s=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><=
div><a href=3D"https://sites.google.com/site/ironspeedlinux/" target=3D"_bl=
ank">https://sites.google.com/site/ironspeedlinux/</a></div></div></div>
</div>

--001a1140d866695f43055382f37a--

--===============8322782639677430205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8322782639677430205==--
