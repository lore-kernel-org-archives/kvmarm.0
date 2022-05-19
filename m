Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825B5C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:46:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 423674B479;
	Thu, 19 May 2022 09:46:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O9IVnsNyDc0P; Thu, 19 May 2022 09:46:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 360DA4B484;
	Thu, 19 May 2022 09:46:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 254254B44E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rKELSQcBV208 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:46:56 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2B374B484
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:55 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 89F61617CA;
 Thu, 19 May 2022 13:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0CAC36AE3;
 Thu, 19 May 2022 13:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968015;
 bh=B946jQuS7j2fg5L+Q7AQunEposbhc2Gy7MExnPSIXp0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=JGG5z1aIipXv0PgYjivZS0279gWmC483ak3c4hspl9DEisL8KMsLBYHK6z5b2wkJQ
 s/CT8WKOT1SEbFndyiC4kMsf3wzWDoY8yrauyMY2H7ZtKffnWx8epydJch3i7QDGs7
 LCxBvmpl4gLsOVYi5qGlNn92OcrXV8b3GMjSlFQZ8Q57d6/C6nwofGd8la8SRDF8w7
 xPfb5lTMyJqwCCBxvZ8uSzT6AnXXLmJNPaWpFcJWwwDGGZgzjCpJI9gqtkDt2Rq237
 JDnKZ2vrORNFe3304WUJcsI2qvBu20TSaXU6fzc+hy9FMe2GrahlfSoHgVy7+gG129
 Xc9pMYrSkrFBw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 68/89] KVM: arm64: Move vgic state between host and shadow
 vcpu structures
Date: Thu, 19 May 2022 14:41:43 +0100
Message-Id: <20220519134204.5379-69-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Marc Zyngier <maz@kernel.org>

Since the world switch vgic code operates on the shadow data
structure, move the state back and forth between the host and
shadow vcpu.

This is currently limited to the VMCR and APR registers, but further
patches will deal with the rest of the state.

Note that some of the scontrol settings (such as SRE) are always
set to the same value. This will eventually be moved to the shadow
initialisation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 65 ++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 692576497ed9..5d6cee7436f4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -619,6 +619,17 @@ static struct kvm_vcpu *__get_current_vcpu(struct kvm_vcpu *vcpu,
 		__get_current_vcpu(__vcpu, statepp);			\
 	})
 
+#define get_current_vcpu_from_cpu_if(ctxt, regnr, statepp)		\
+	({								\
+		DECLARE_REG(struct vgic_v3_cpu_if *, cif, ctxt, regnr); \
+		struct kvm_vcpu *__vcpu;				\
+		__vcpu = container_of(cif,				\
+				      struct kvm_vcpu,			\
+				      arch.vgic_cpu.vgic_v3);		\
+									\
+		__get_current_vcpu(__vcpu, statepp);			\
+	})
+
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_shadow_vcpu_state *shadow_state;
@@ -778,16 +789,62 @@ static void handle___kvm_get_mdcr_el2(struct kvm_cpu_context *host_ctxt)
 
 static void handle___vgic_v3_save_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
+	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *vcpu;
+
+	vcpu = get_current_vcpu_from_cpu_if(host_ctxt, 1, &shadow_state);
+	if (!vcpu)
+		return;
+
+	if (shadow_state) {
+		struct vgic_v3_cpu_if *shadow_cpu_if, *cpu_if;
+		int i;
+
+		shadow_cpu_if = &shadow_state->shadow_vcpu.arch.vgic_cpu.vgic_v3;
+		__vgic_v3_save_vmcr_aprs(shadow_cpu_if);
+
+		cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	__vgic_v3_save_vmcr_aprs(kern_hyp_va(cpu_if));
+		cpu_if->vgic_vmcr = shadow_cpu_if->vgic_vmcr;
+		for (i = 0; i < ARRAY_SIZE(cpu_if->vgic_ap0r); i++) {
+			cpu_if->vgic_ap0r[i] = shadow_cpu_if->vgic_ap0r[i];
+			cpu_if->vgic_ap1r[i] = shadow_cpu_if->vgic_ap1r[i];
+		}
+	} else {
+		__vgic_v3_save_vmcr_aprs(&vcpu->arch.vgic_cpu.vgic_v3);
+	}
 }
 
 static void handle___vgic_v3_restore_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
+	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *vcpu;
 
-	__vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
+	vcpu = get_current_vcpu_from_cpu_if(host_ctxt, 1, &shadow_state);
+	if (!vcpu)
+		return;
+
+	if (shadow_state) {
+		struct vgic_v3_cpu_if *shadow_cpu_if, *cpu_if;
+		int i;
+
+		shadow_cpu_if = &shadow_state->shadow_vcpu.arch.vgic_cpu.vgic_v3;
+		cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+
+		shadow_cpu_if->vgic_vmcr = cpu_if->vgic_vmcr;
+		/* Should be a one-off */
+		shadow_cpu_if->vgic_sre = (ICC_SRE_EL1_DIB |
+					   ICC_SRE_EL1_DFB |
+					   ICC_SRE_EL1_SRE);
+		for (i = 0; i < ARRAY_SIZE(cpu_if->vgic_ap0r); i++) {
+			shadow_cpu_if->vgic_ap0r[i] = cpu_if->vgic_ap0r[i];
+			shadow_cpu_if->vgic_ap1r[i] = cpu_if->vgic_ap1r[i];
+		}
+
+		__vgic_v3_restore_vmcr_aprs(shadow_cpu_if);
+	} else {
+		__vgic_v3_restore_vmcr_aprs(&vcpu->arch.vgic_cpu.vgic_v3);
+	}
 }
 
 static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
