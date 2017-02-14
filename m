From: Raz <raziebe@gmail.com>
Subject: Re: Booting a kernel to EL1 in Armv8.1
Date: Tue, 14 Feb 2017 22:08:19 +0000
Message-ID: <CAPB=Z-oKHfTn5h2nuctRAkJLCx3+vsNzM_0DzWiJLhdGy78bMg@mail.gmail.com>
References: <CAPB=Z-pGjZ398fZuUeR2EsOnVf-0Qp3m4ckdeCBniKZmjs25Nw@mail.gmail.com>
 <20170125082252.GS15850@cbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7363071559285539907=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95FCE408EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 17:07:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CrNZtt0d+8NF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Feb 2017 17:07:58 -0500 (EST)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D76DC40625
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 17:07:57 -0500 (EST)
Received: by mail-lf0-f53.google.com with SMTP id n124so72851355lfd.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 14:08:42 -0800 (PST)
In-Reply-To: <20170125082252.GS15850@cbox>
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
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============7363071559285539907==
Content-Type: multipart/alternative; boundary=001a114002f87a397d054884ce6f

--001a114002f87a397d054884ce6f
Content-Type: text/plain; charset=UTF-8

On Wed, Jan 25, 2017 at 8:22 AM, Christoffer Dall <
christoffer.dall@linaro.org> wrote:

> On Tue, Jan 24, 2017 at 09:50:04PM +0000, Raz wrote:
> > Hello
> >
> > I am trying to boot EL1 kernel in a platform based on Armv8.1.
> > I am using fvp as a hardware.
> > What I am trying to achieve is to execute some kernel code in
> > EL2 exception level..
>
> When you boot a reasonably recent kernel on VHE, it will execute in EL2,
> so all the code you're executing will be at EL2, so I think you've
> already achieved what you're trying to do.
>
> >
> > The current VHE patch is booting the kernel into EL2. So I took an older
> > kernel
> > and I tried to set  TTBR1_EL2 to access kernel memory as if it is
> TTBR1_EL1
> > .
>
> That won't work unless you set the E2H bit, see the ARMv8.1
> documentation.
>
> If you boot a kernel that doesn't have the necessary bits to enable VHE,
> then you'll just run as on a non-VHE system with the main kernel running
> at EL1 and a stub installed at EL2 which eventually gets replaced by the
> KVM hyp lowvisor code in EL2.
>
> >
> > It is theoretically possible ?
>
> I'm not sure what you're asking?
>
> > Setting TTBR1_EL2 to TTBR1_EL1
> > and enabling mmu  thtough sctlr_el2 does not work.
> >
>
> Again, not sure what you're trying to do.  If you're running in EL1
> (because you're old kernel drops you to EL1) then trying to access EL2
> registers obviously won't work.
>
> I created my own vector instead of kvm's . I am doing that because I want
to create a sort of secured execution context by using a hypervisor. It is
an academic work.

I managed to do that by the way. I am calling regular kernel code in EL2.
so thank you.


If you run a VHE kernel, it will have already set the _EL2 registers to
> the values you want (but it will use _EL1 register access intructions to
> do so, and they are transparently rewritten by hardware to program the
> corresponding _EL2 registers).
>
> Hope this helps,
> -Christoffer
>



-- 
https://sites.google.com/site/ironspeedlinux/

--001a114002f87a397d054884ce6f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Wed, Jan 25, 2017 at 8:22 AM, Christoffer Dall <span dir=3D"ltr">&lt=
;<a href=3D"mailto:christoffer.dall@linaro.org" target=3D"_blank">christoff=
er.dall@linaro.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
<span>On Tue, Jan 24, 2017 at 09:50:04PM +0000, Raz wrote:<br>
&gt; Hello<br>
&gt;<br>
&gt; I am trying to boot EL1 kernel in a platform based on Armv8.1.<br>
&gt; I am using fvp as a hardware.<br>
&gt; What I am trying to achieve is to execute some kernel code in<br>
&gt; EL2 exception level..<br>
<br>
</span>When you boot a reasonably recent kernel on VHE, it will execute in =
EL2,<br>
so all the code you&#39;re executing will be at EL2, so I think you&#39;ve<=
br>
already achieved what you&#39;re trying to do.<br>
<span><br>
&gt;<br>
&gt; The current VHE patch is booting the kernel into EL2. So I took an old=
er<br>
&gt; kernel<br>
&gt; and I tried to set=C2=A0 TTBR1_EL2 to access kernel memory as if it is=
 TTBR1_EL1<br>
&gt; .<br>
<br>
</span>That won&#39;t work unless you set the E2H bit, see the ARMv8.1<br>
documentation.<br>
<br>
If you boot a kernel that doesn&#39;t have the necessary bits to enable VHE=
,<br>
then you&#39;ll just run as on a non-VHE system with the main kernel runnin=
g<br>
at EL1 and a stub installed at EL2 which eventually gets replaced by the<br=
>
KVM hyp lowvisor code in EL2.<br>
<span><br>
&gt;<br>
&gt; It is theoretically possible ?<br>
<br>
</span>I&#39;m not sure what you&#39;re asking?<br>
<span><br>
&gt; Setting TTBR1_EL2 to TTBR1_EL1<br>
&gt; and enabling mmu=C2=A0 thtough sctlr_el2 does not work.<br>
&gt;<br>
<br>
</span>Again, not sure what you&#39;re trying to do.=C2=A0 If you&#39;re ru=
nning in EL1<br>
(because you&#39;re old kernel drops you to EL1) then trying to access EL2<=
br>
registers obviously won&#39;t work.<br>
<br></blockquote><div>I created my own vector instead of kvm&#39;s . I am d=
oing that because I want to create a sort of secured execution context by u=
sing a hypervisor. It is an academic work. <br><br></div><div>I managed to =
do that by the way. I am calling regular kernel code in EL2. so thank you. =
<br></div><div><br><br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
If you run a VHE kernel, it will have already set the _EL2 registers to<br>
the values you want (but it will use _EL1 register access intructions to<br=
>
do so, and they are transparently rewritten by hardware to program the<br>
corresponding _EL2 registers).<br>
<br>
Hope this helps,<br>
-Christoffer<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"m_-884120=
7887007875843gmail_signature" data-smartmail=3D"gmail_signature"><div dir=
=3D"ltr"><div><a href=3D"https://sites.google.com/site/ironspeedlinux/" tar=
get=3D"_blank">https://sites.google.com/site/<wbr>ironspeedlinux/</a></div>=
</div></div>
</div></div>

--001a114002f87a397d054884ce6f--

--===============7363071559285539907==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7363071559285539907==--
