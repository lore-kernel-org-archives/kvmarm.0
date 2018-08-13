From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 32/37] KVM: arm: vgic-v3: Add support for ICC_SGI0R and
 ICC_ASGI1R accesses
Date: Mon, 13 Aug 2018 15:57:50 +0100
Message-ID: <20180813145755.16566-33-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47BBD4A22F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tpQQWj3Mb8gh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 11:00:33 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BC464A1FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:32 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to generate Group0 SGIs, let's add some decoding logic to
access_gic_sgi(), and pass the generating group accordingly.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index b17c52608a19..450c7a4fbc8a 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -246,6 +246,7 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 			   const struct coproc_reg *r)
 {
 	u64 reg;
+	bool g1;
 
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p);
@@ -253,7 +254,25 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 	reg = (u64)*vcpu_reg(vcpu, p->Rt2) << 32;
 	reg |= *vcpu_reg(vcpu, p->Rt1) ;
 
-	vgic_v3_dispatch_sgi(vcpu, reg, true);
+	/*
+	 * In a system where GICD_CTLR.DS=1, a ICC_SGI0R access generates
+	 * Group0 SGIs only, while ICC_SGI1R can generate either group,
+	 * depending on the SGI configuration. ICC_ASGI1R is effectively
+	 * equivalent to ICC_SGI0R, as there is no "alternative" secure
+	 * group.
+	 */
+	switch (p->Op1) {
+	default:		/* Keep GCC quiet */
+	case 0:			/* ICC_SGI1R */
+		g1 = true;
+		break;
+	case 1:			/* ICC_ASGI1R */
+	case 2:			/* ICC_SGI0R */
+		g1 = false;
+		break;
+	}
+
+	vgic_v3_dispatch_sgi(vcpu, reg, g1);
 
 	return true;
 }
@@ -459,6 +478,10 @@ static const struct coproc_reg cp15_regs[] = {
 
 	/* ICC_SGI1R */
 	{ CRm64(12), Op1( 0), is64, access_gic_sgi},
+	/* ICC_ASGI1R */
+	{ CRm64(12), Op1( 1), is64, access_gic_sgi},
+	/* ICC_SGI0R */
+	{ CRm64(12), Op1( 2), is64, access_gic_sgi},
 
 	/* VBAR: swapped by interrupt.S. */
 	{ CRn(12), CRm( 0), Op1( 0), Op2( 0), is32,
-- 
2.18.0
