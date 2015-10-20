From: Paolo Bonzini <pbonzini@redhat.com>
Subject: =?utf-8?B?UkU6IFtHSVQgUFVMTCAzLzZdIEtWTTogYXJtOiB1c2UgR0lDIHN1cHBvcnQgdW5jb25kaXRpb25h?=
 =?utf-8?B?bGx5?=
Date: Tue, 20 Oct 2015 15:51:05 -0400 (EDT)
Message-ID: <672714208.55851501.1445370665940.JavaMail.zimbra@zmail13.collab.prod.int.phx2.redhat.com>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
 <1445357947-6022-4-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6800880745601069482=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF4EC410BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 15:48:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tt0S7jJ-BUIV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Oct 2015 15:48:43 -0400 (EDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5707D40FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 15:48:42 -0400 (EDT)
In-Reply-To: <1445357947-6022-4-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, christoffer.dall@linaro.org
Cc: marc.zyngier@arm.com, arnd@arndb.de
List-Id: kvmarm@lists.cs.columbia.edu

--===============6800880745601069482==
Content-Type: multipart/alternative;
	boundary="----=_Part_55851502_745639444.1445370665965"

------=_Part_55851502_745639444.1445370665965
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Should this be "select" or "depends on"? Not a blocker, can always be fixed=
 in 4.4.

Paolo


-----Original Message-----
From: Christoffer Dall [christoffer.dall@linaro.org]
Received: marted=C3=AC, 20 ott 2015, 18:18
To: Paolo Bonzini [pbonzini@redhat.com]; kvmarm@lists.cs.columbia.edu, kvm@=
vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: Marc Zyngier [marc.zyngier@arm.com]; Arnd Bergmann [arnd@arndb.de]; Chr=
istoffer Dall [christoffer.dall@linaro.org]
Subject: [GIT PULL 3/6] KVM: arm: use GIC support unconditionally

From: Arnd Bergmann <arnd@arndb.de>

The vgic code on ARM is built for all configurations that enable KVM,
but the parent_data field that it references is only present when
CONFIG_IRQ_DOMAIN_HIERARCHY is set:

virt/kvm/arm/vgic.c: In function 'kvm_vgic_map_phys_irq':
virt/kvm/arm/vgic.c:1781:13: error: 'struct irq_data' has no member named '=
parent_data'

This flag is implied by the GIC driver, and indeed the VGIC code only
makes sense if a GIC is present. This changes the CONFIG_KVM symbol
to always select GIC, which avoids the issue.

Fixes: 662d9715840 ("arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 210ecca..356970f 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -21,6 +21,7 @@ config KVM
 =09depends on MMU && OF
 =09select PREEMPT_NOTIFIERS
 =09select ANON_INODES
+=09select ARM_GIC
 =09select HAVE_KVM_CPU_RELAX_INTERCEPT
 =09select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 =09select KVM_MMIO
--=20
2.1.2.330.g565301e.dirty


------=_Part_55851502_745639444.1445370665965
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><body><div>Should this be &quot;select&quot; or &quot;depends on&quot=
;? Not a blocker, can always be fixed in 4.4.
<br>
<br>Paolo
<br>
<br>
<br>-----Original Message-----
<br>From: Christoffer Dall [christoffer.dall@linaro.org]
<br>Received: marted=C3=AC, 20 ott 2015, 18:18
<br>To: Paolo Bonzini [pbonzini@redhat.com]; kvmarm@lists.cs.columbia.edu, =
kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
<br>CC: Marc Zyngier [marc.zyngier@arm.com]; Arnd Bergmann [arnd@arndb.de];=
 Christoffer Dall [christoffer.dall@linaro.org]
<br>Subject: [GIT PULL 3/6] KVM: arm: use GIC support unconditionally
<br>
<br></div><br><div>From: Arnd Bergmann &lt;arnd@arndb.de&gt;
<br>
<br>The vgic code on ARM is built for all configurations that enable KVM,
<br>but the parent_data field that it references is only present when
<br>CONFIG_IRQ_DOMAIN_HIERARCHY is set:
<br>
<br>virt/kvm/arm/vgic.c: In function 'kvm_vgic_map_phys_irq':
<br>virt/kvm/arm/vgic.c:1781:13: error: 'struct irq_data' has no member nam=
ed 'parent_data'
<br>
<br>This flag is implied by the GIC driver, and indeed the VGIC code only
<br>makes sense if a GIC is present. This changes the CONFIG_KVM symbol
<br>to always select GIC, which avoids the issue.
<br>
<br>Fixes: 662d9715840 (&quot;arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIM=
ER}&quot;)
<br>Signed-off-by: Arnd Bergmann &lt;arnd@arndb.de&gt;
<br>Acked-by: Marc Zyngier &lt;marc.zyngier@arm.com&gt;
<br>Signed-off-by: Christoffer Dall &lt;christoffer.dall@linaro.org&gt;
<br>---
<br> arch/arm/kvm/Kconfig | 1 +
<br> 1 file changed, 1 insertion(+)
<br>
<br>diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
<br>index 210ecca..356970f 100644
<br>--- a/arch/arm/kvm/Kconfig
<br>+++ b/arch/arm/kvm/Kconfig
<br>@@ -21,6 +21,7 @@ config KVM
<br> &nbsp; &nbsp; &nbsp;depends on MMU &amp;&amp; OF
<br> &nbsp; &nbsp; &nbsp;select PREEMPT_NOTIFIERS
<br> &nbsp; &nbsp; &nbsp;select ANON_INODES
<br>+&nbsp; &nbsp; &nbsp;select ARM_GIC
<br> &nbsp; &nbsp; &nbsp;select HAVE_KVM_CPU_RELAX_INTERCEPT
<br> &nbsp; &nbsp; &nbsp;select HAVE_KVM_ARCH_TLB_FLUSH_ALL
<br> &nbsp; &nbsp; &nbsp;select KVM_MMIO
<br>--=20
<br>2.1.2.330.g565301e.dirty
<br>
<br></div></body></html>
------=_Part_55851502_745639444.1445370665965--

--===============6800880745601069482==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6800880745601069482==--
