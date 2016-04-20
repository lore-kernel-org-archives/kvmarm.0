From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v7 1/6] KVM: arm/arm64: Add VGICv3 save/restore API
 documentation
Date: Wed, 20 Apr 2016 11:59:41 +0100
Message-ID: <CAMJs5B8b1kpdeUDPGOcyaiNjSo+ZSzzUZOS4+wJ6cWmjtd58dg@mail.gmail.com>
References: <cover.1449491035.git.p.fedin@samsung.com>
 <204d6b178e611ee0b5aede2b945516e0a6048c3c.1449491035.git.p.fedin@samsung.com>
 <CAFEAcA_N7F4r6fpQTW8Duyu577=uGcRyS7VhAMxumwTDN3khcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7812230498709125564=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32FB649B80
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2016 06:57:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ls-usNmXVf44 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2016 06:57:42 -0400 (EDT)
Received: from mail-yw0-f182.google.com (mail-yw0-f182.google.com
 [209.85.161.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BAA6649B74
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2016 06:57:42 -0400 (EDT)
Received: by mail-yw0-f182.google.com with SMTP id j74so43144735ywg.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2016 03:59:42 -0700 (PDT)
In-Reply-To: <CAFEAcA_N7F4r6fpQTW8Duyu577=uGcRyS7VhAMxumwTDN3khcw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

--===============7812230498709125564==
Content-Type: multipart/alternative; boundary=001a114dcb4ca2c7f70530e87d3d

--001a114dcb4ca2c7f70530e87d3d
Content-Type: text/plain; charset=UTF-8

On Friday, 15 April 2016, Peter Maydell <peter.maydell@linaro.org> wrote:

> On 7 December 2015 at 12:29, Pavel Fedin <p.fedin@samsung.com
> <javascript:;>> wrote:
> > From: Christoffer Dall <christoffer.dall@linaro.org <javascript:;>>
> >
> > Factor out the GICv3-specific documentation into a separate
> > documentation file.  Add description for how to access distributor,
> > redistributor, and CPU interface registers for GICv3 in this new file.
> >
> > Acked-by: Peter Maydell <peter.maydell@linaro.org <javascript:;>>
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com <javascript:;>>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org
> <javascript:;>>
> > Signed-off-by: Pavel Fedin <p.fedin@samsung.com <javascript:;>>
>
> Nothing in here describes a mechanism for reading or writing the
> current interrupt line_level state from the kernel (which doesn't
> matter for edge triggered interrupts but does for level triggered
> interrupts). Do we need accessors for these or does somebody
> have a good rationale for why we don't need to migrate that data?
> (Christoffer?)
>
> (GICv2 doesn't do this either and I suspect it's wrong too.)
>
>
I thought we relied on user space to migrate its device state including the
interrupt line output state and set the corresponding line state to the
kernel, but that may have been wrong, and would rely on userspace to call
the IRQ_LINE ioctl again.  Would that work?

How is it again, does QEMU preserve the IRQ output line state per device?

This may just work currently because we rely on the reads/writes to SPENDR
to preserve the state and apparently level triggered interrupts are
reinjected as needed.

Thanks,
-Christoffer

--001a114dcb4ca2c7f70530e87d3d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>On Friday, 15 April 2016, Peter Maydell &lt;<a href=3D"mailto:peter=
.maydell@linaro.org">peter.maydell@linaro.org</a>&gt; wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">On 7 December 2015 at 12:29, Pavel Fedin &lt;<a href=3D=
"javascript:;" onclick=3D"_e(event, &#39;cvml&#39;, &#39;p.fedin@samsung.co=
m&#39;)">p.fedin@samsung.com</a>&gt; wrote:<br>
&gt; From: Christoffer Dall &lt;<a href=3D"javascript:;" onclick=3D"_e(even=
t, &#39;cvml&#39;, &#39;christoffer.dall@linaro.org&#39;)">christoffer.dall=
@linaro.org</a>&gt;<br>
&gt;<br>
&gt; Factor out the GICv3-specific documentation into a separate<br>
&gt; documentation file.=C2=A0 Add description for how to access distributo=
r,<br>
&gt; redistributor, and CPU interface registers for GICv3 in this new file.=
<br>
&gt;<br>
&gt; Acked-by: Peter Maydell &lt;<a href=3D"javascript:;" onclick=3D"_e(eve=
nt, &#39;cvml&#39;, &#39;peter.maydell@linaro.org&#39;)">peter.maydell@lina=
ro.org</a>&gt;<br>
&gt; Acked-by: Marc Zyngier &lt;<a href=3D"javascript:;" onclick=3D"_e(even=
t, &#39;cvml&#39;, &#39;marc.zyngier@arm.com&#39;)">marc.zyngier@arm.com</a=
>&gt;<br>
&gt; Signed-off-by: Christoffer Dall &lt;<a href=3D"javascript:;" onclick=
=3D"_e(event, &#39;cvml&#39;, &#39;christoffer.dall@linaro.org&#39;)">chris=
toffer.dall@linaro.org</a>&gt;<br>
&gt; Signed-off-by: Pavel Fedin &lt;<a href=3D"javascript:;" onclick=3D"_e(=
event, &#39;cvml&#39;, &#39;p.fedin@samsung.com&#39;)">p.fedin@samsung.com<=
/a>&gt;<br>
<br>
Nothing in here describes a mechanism for reading or writing the<br>
current interrupt line_level state from the kernel (which doesn&#39;t<br>
matter for edge triggered interrupts but does for level triggered<br>
interrupts). Do we need accessors for these or does somebody<br>
have a good rationale for why we don&#39;t need to migrate that data?<br>
(Christoffer?)<br>
<br>
(GICv2 doesn&#39;t do this either and I suspect it&#39;s wrong too.)<br><br=
>
</blockquote><div><br></div><div>I thought we relied on user space to migra=
te its device state including the interrupt line output state and set the c=
orresponding line state to the kernel, but that may have been wrong, and wo=
uld rely on userspace to call the IRQ_LINE ioctl again.=C2=A0 Would that wo=
rk?</div><div><br></div><div>How is it again, does QEMU preserve the IRQ ou=
tput line state per device?</div><div><br></div>This may just work currentl=
y because we rely on the reads/writes to SPENDR to preserve the state and a=
pparently level triggered=C2=A0interrupts are reinjected as needed.=C2=A0<d=
iv><br></div><div>Thanks,</div><div>-Christoffer<br><div><br></div><div><br=
></div></div>

--001a114dcb4ca2c7f70530e87d3d--

--===============7812230498709125564==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7812230498709125564==--
