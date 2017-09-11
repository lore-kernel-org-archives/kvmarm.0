From: Hemanth Kumar <hemk976@gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: Fix vgic_mmio_change_active with
 PREEMPT_RT
Date: Mon, 11 Sep 2017 16:59:11 +0530
Message-ID: <CAKgvECZs7pm_O_SemzFQnDJvtv0MBrm9XCztmAAvN=9KRXBcEw@mail.gmail.com>
References: <1504882339-42520-1-git-send-email-christoffer.dall@linaro.org>
 <1504882339-42520-3-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2705566017011414079=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5C2649C23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Sep 2017 07:26:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EqfsQLcfsHXP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Sep 2017 07:26:36 -0400 (EDT)
Received: from mail-io0-f196.google.com (mail-io0-f196.google.com
 [209.85.223.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A722340C5A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Sep 2017 07:26:36 -0400 (EDT)
Received: by mail-io0-f196.google.com with SMTP id d16so3477454ioj.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Sep 2017 04:29:12 -0700 (PDT)
In-Reply-To: <1504882339-42520-3-git-send-email-christoffer.dall@linaro.org>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

--===============2705566017011414079==
Content-Type: multipart/alternative; boundary="001a113e36905927c70558e83cbe"

--001a113e36905927c70558e83cbe
Content-Type: text/plain; charset="UTF-8"

Tested Works fine.

On Fri, Sep 8, 2017 at 8:22 PM, Christoffer Dall <
christoffer.dall@linaro.org> wrote:

> From: Christoffer Dall <cdall@linaro.org>
>
> Getting a per-CPU variable requires a non-preemptible context and we
> were relying on a normal spinlock to disable preemption as well.  This
> asusmption breaks with PREEMPT_RT and was observed on v4.9 using
> PREEMPT_RT.
>
> This change moves the spinlock tighter around the critical section
> accessing the IRQ structure protected by the lock and uses a separate
> preemption disabled section for determining the requesting VCPU.  There
> should be no change in functionality of performance degradation on
> non-RT.
>
> Fixes: 370a0ec18199 ("KVM: arm/arm64: Let vcpu thread modify its own
> active state")
> Cc: stable@vger.kernel.org
> Cc: Jintack Lim <jintack@cs.columbia.edu>
> Reported-by: Hemanth Kumar <hemk976@gmail.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index c1e4bdd..7377f97 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -181,7 +181,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu
> *vcpu, struct vgic_irq *irq,
>                                     bool new_active_state)
>  {
>         struct kvm_vcpu *requester_vcpu;
> -       spin_lock(&irq->irq_lock);
>
>         /*
>          * The vcpu parameter here can mean multiple things depending on
> how
> @@ -195,8 +194,19 @@ static void vgic_mmio_change_active(struct kvm_vcpu
> *vcpu, struct vgic_irq *irq,
>          * NULL, which is fine, because we guarantee that no VCPUs are
> running
>          * when accessing VGIC state from user space so irq->vcpu->cpu is
>          * always -1.
> +        *
> +        * We have to temporarily disable preemption to read the per-CPU
> +        * variable.  It doesn't matter if we actually get preempted
> +        * after enabling preemption because we only need to figure out if
> +        * this thread is a running VCPU thread, and in that case for which
> +        * VCPU.  If we're migrated the preempt notifiers will migrate the
> +        * running VCPU pointer with us.
>          */
> +       preempt_disable();
>         requester_vcpu = kvm_arm_get_running_vcpu();
> +       preempt_enable();
> +
> +       spin_lock(&irq->irq_lock);
>
>         /*
>          * If this virtual IRQ was written into a list register, we
> --
> 2.7.4
>
>

--001a113e36905927c70558e83cbe
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Tested Works fine.<br></div><div class=3D"gmail_extra"><br=
><div class=3D"gmail_quote">On Fri, Sep 8, 2017 at 8:22 PM, Christoffer Dal=
l <span dir=3D"ltr">&lt;<a href=3D"mailto:christoffer.dall@linaro.org" targ=
et=3D"_blank">christoffer.dall@linaro.org</a>&gt;</span> wrote:<br><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc s=
olid;padding-left:1ex">From: Christoffer Dall &lt;<a href=3D"mailto:cdall@l=
inaro.org">cdall@linaro.org</a>&gt;<br>
<br>
Getting a per-CPU variable requires a non-preemptible context and we<br>
were relying on a normal spinlock to disable preemption as well.=C2=A0 This=
<br>
asusmption breaks with PREEMPT_RT and was observed on v4.9 using<br>
PREEMPT_RT.<br>
<br>
This change moves the spinlock tighter around the critical section<br>
accessing the IRQ structure protected by the lock and uses a separate<br>
preemption disabled section for determining the requesting VCPU.=C2=A0 Ther=
e<br>
should be no change in functionality of performance degradation on<br>
non-RT.<br>
<br>
Fixes: 370a0ec18199 (&quot;KVM: arm/arm64: Let vcpu thread modify its own a=
ctive state&quot;)<br>
Cc: <a href=3D"mailto:stable@vger.kernel.org">stable@vger.kernel.org</a><br=
>
Cc: Jintack Lim &lt;<a href=3D"mailto:jintack@cs.columbia.edu">jintack@cs.c=
olumbia.edu</a>&gt;<br>
Reported-by: Hemanth Kumar &lt;<a href=3D"mailto:hemk976@gmail.com">hemk976=
@gmail.com</a>&gt;<br>
Signed-off-by: Christoffer Dall &lt;<a href=3D"mailto:cdall@linaro.org">cda=
ll@linaro.org</a>&gt;<br>
---<br>
=C2=A0virt/kvm/arm/vgic/vgic-mmio.c | 12 +++++++++++-<br>
=C2=A01 file changed, 11 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/virt/kvm/arm/vgic/vgic-mmio.<wbr>c b/virt/kvm/arm/vgic/vgic-mm=
io.<wbr>c<br>
index c1e4bdd..7377f97 100644<br>
--- a/virt/kvm/arm/vgic/vgic-mmio.<wbr>c<br>
+++ b/virt/kvm/arm/vgic/vgic-mmio.<wbr>c<br>
@@ -181,7 +181,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vc=
pu, struct vgic_irq *irq,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool new_active_state)=
<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct kvm_vcpu *requester_vcpu;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&amp;irq-&gt;irq_lock);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* The vcpu parameter here can mean multip=
le things depending on how<br>
@@ -195,8 +194,19 @@ static void vgic_mmio_change_active(struct kvm_vcpu *v=
cpu, struct vgic_irq *irq,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* NULL, which is fine, because we guarant=
ee that no VCPUs are running<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* when accessing VGIC state from user spa=
ce so irq-&gt;vcpu-&gt;cpu is<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* always -1.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 *<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * We have to temporarily disable preemption to=
 read the per-CPU<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * variable.=C2=A0 It doesn&#39;t matter if we =
actually get preempted<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * after enabling preemption because we only ne=
ed to figure out if<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * this thread is a running VCPU thread, and in=
 that case for which<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * VCPU.=C2=A0 If we&#39;re migrated the preemp=
t notifiers will migrate the<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * running VCPU pointer with us.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0preempt_disable();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 requester_vcpu =3D kvm_arm_get_running_vcpu();<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0preempt_enable();<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&amp;irq-&gt;irq_lock);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* If this virtual IRQ was written into a =
list register, we<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a113e36905927c70558e83cbe--

--===============2705566017011414079==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2705566017011414079==--
