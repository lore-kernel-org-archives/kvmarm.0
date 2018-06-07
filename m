From: Raz <raziebe@gmail.com>
Subject: Re: A KVM kernel for FVP for ARM7
Date: Thu, 7 Jun 2018 23:44:14 +0300
Message-ID: <CAPB=Z-pF=BuHV73ybKaURavRd=-J2dHL3JWEzcH+=pih+-V0Ng@mail.gmail.com>
References: <CAPB=Z-qULLZUVOabsNDPRYxybC3M=O8ZrYpRo8Dfc0oT4nKcGQ@mail.gmail.com>
 <20180607073426.GA20446@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0246351575984209538=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9D6C49EA4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jun 2018 16:33:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NEtCL9pLjDc1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jun 2018 16:33:17 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D14A40192
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jun 2018 16:33:17 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id 69-v6so8681379wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Jun 2018 13:44:36 -0700 (PDT)
In-Reply-To: <20180607073426.GA20446@C02W217FHV2R.local>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============0246351575984209538==
Content-Type: multipart/alternative; boundary="000000000000e180a6056e1359c4"

--000000000000e180a6056e1359c4
Content-Type: text/plain; charset="UTF-8"

The bellow is the command line I use. I am using now 4.14.48 compiled as
arm7/ARCH-VEXPRESS . there is no clock tick. The boot hangs in:
....
    while (get_jiffies_64() < waitjiffies)
            udelay(10);

/opt/DS-5_v5.28.1/sw/models/bin/FVP_VE_Cortex-A9x1  -a
/opt/arm7/FVP/FVP_VE_V7/FVP_VE_V7.axf --data
/opt/tlinux-4.14.48/arch/arm/boot/Image@0x80008000 -f
/opt/truly/arm7/fvpbase.conf  --data
/opt/t/linux-4.14.48/arch/arm/boot/dts/vexpress-v2p-ca9.dtb

Any idea ?


On Thu, Jun 7, 2018 at 10:34 AM, Christoffer Dall <christoffer.dall@arm.com>
wrote:

> On Wed, Jun 06, 2018 at 09:22:52AM +0300, Raz wrote:
> > Hello
> > KVM arm was introduced in 3.9. I wish to debug it through fast models.
> > My problem is that FVP uses 3.4 kernel, and 3.9  from "git://
> > git.kernel.org/pub/scm/virt/kvm/kvm.git " does not boot it.
> >
> > Do you have a ready kernel for FVP ?
>
> Mainline kernels should boot just fine on Arm fast models.  I strongly
> recommend you use a much newer kernel version for anything KVM-related.
>
> -Christoffer
>

--000000000000e180a6056e1359c4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><br></div><div>The bellow is the command line I use. =
I am using now 4.14.48 compiled as arm7/ARCH-VEXPRESS . there is no clock t=
ick. The boot hangs in:<br></div><div>....<br></div><div>=C2=A0=C2=A0=C2=A0=
 while (get_jiffies_64() &lt; waitjiffies)<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=
=A0=C2=A0 =C2=A0=C2=A0=C2=A0 udelay(10);<br></div><div><br></div><div>/opt/=
DS-5_v5.28.1/sw/models/bin/FVP_VE_Cortex-A9x1=C2=A0 -a /opt/arm7/FVP/FVP_VE=
_V7/FVP_VE_V7.axf --data /opt/tlinux-4.14.48/arch/arm/boot/Image@0x80008000=
 -f /opt/truly/arm7/fvpbase.conf=C2=A0 --data /opt/t/linux-4.14.48/arch/arm=
/boot/dts/vexpress-v2p-ca9.dtb</div><div><br></div><div>Any idea ? <br></di=
v><div><br></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Thu, Jun 7, 2018 at 10:34 AM, Christoffer Dall <span dir=3D"ltr">&lt;<a =
href=3D"mailto:christoffer.dall@arm.com" target=3D"_blank">christoffer.dall=
@arm.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">On Wed, Jun 06, 2018 at 09:22:52AM +0300, Raz wrote:<br>
&gt; Hello<br>
&gt; KVM arm was introduced in 3.9. I wish to debug it through fast models.=
<br>
&gt; My problem is that FVP uses 3.4 kernel, and 3.9=C2=A0 from &quot;git:/=
/<br>
&gt; <a href=3D"http://git.kernel.org/pub/scm/virt/kvm/kvm.git" rel=3D"nore=
ferrer" target=3D"_blank">git.kernel.org/pub/scm/virt/<wbr>kvm/kvm.git</a> =
&quot; does not boot it.<br>
&gt; <br>
&gt; Do you have a ready kernel for FVP ?<br>
<br>
</span>Mainline kernels should boot just fine on Arm fast models.=C2=A0 I s=
trongly<br>
recommend you use a much newer kernel version for anything KVM-related.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Christoffer<br>
</font></span></blockquote></div><br></div></div>

--000000000000e180a6056e1359c4--

--===============0246351575984209538==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0246351575984209538==--
