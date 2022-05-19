Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7E3C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:45:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA1D0400CF;
	Thu, 19 May 2022 09:45:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 68IE5aozxIck; Thu, 19 May 2022 09:45:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 788024B422;
	Thu, 19 May 2022 09:45:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57B574B384
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U4VBcoO1c33r for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:45:18 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9334400D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:16 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 71A056176B;
 Thu, 19 May 2022 13:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633BCC34115;
 Thu, 19 May 2022 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967915;
 bh=NfURsrYW4h19F3WtHdQkYC/dH7t8OmUGfRpzGnNJnCw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=V8CE1dB72f2xw7zuWqcSJwBuXFyA8DJKPJRmNTFu5MMnncefdQvH44S7N0U1mB9Zc
 ltLAoKsJukAnREAop57PfnCskiIzNHdCzq3VrvaaDi5HSEiG1O3LYAEQKg9LTzqyMJ
 jhaNiN+GUuxos+/jHZyFfxDfYMgM6mxlabIuj8N7wT/wDz928AScV3Zp5V/6vhNnaH
 g6qjSBqWMkvTW4b8Sp+O4eXKMhz5/NuR4xPxSQqt9j+Yc0IzJNUvluddSX1bRjO3sK
 0DgQsZntMcDT4vYQ+Zv0jsXgGqvSdgwffsIBbH3ABN83srItSWA4LM6em6bcJkfJzZ
 k431H+QX4noLw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 43/89] KVM: arm64: Add the {flush,
 sync}_vgic_state() primitives
Date: Thu, 19 May 2022 14:41:18 +0100
Message-Id: <20220519134204.5379-44-will@kernel.org>
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

Rather than blindly copying the vGIC state to/from the host at EL2,
introduce a couple of helpers to copy only what is needed and to
sanitise untrusted data passed by the host kernel.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 50 +++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5b46742d9f9b..58515e5d24ec 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -18,10 +18,51 @@
 #include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
+#include <linux/irqchip/arm-gic-v3.h>
+
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
+static void flush_vgic_state(struct kvm_vcpu *host_vcpu,
+			     struct kvm_vcpu *shadow_vcpu)
+{
+	struct vgic_v3_cpu_if *host_cpu_if, *shadow_cpu_if;
+	unsigned int used_lrs, max_lrs, i;
+
+	host_cpu_if	= &host_vcpu->arch.vgic_cpu.vgic_v3;
+	shadow_cpu_if	= &shadow_vcpu->arch.vgic_cpu.vgic_v3;
+
+	max_lrs = (read_gicreg(ICH_VTR_EL2) & 0xf) + 1;
+	used_lrs = READ_ONCE(host_cpu_if->used_lrs);
+	used_lrs = min(used_lrs, max_lrs);
+
+	shadow_cpu_if->vgic_hcr	= READ_ONCE(host_cpu_if->vgic_hcr);
+	/* Should be a one-off */
+	shadow_cpu_if->vgic_sre = (ICC_SRE_EL1_DIB |
+				   ICC_SRE_EL1_DFB |
+				   ICC_SRE_EL1_SRE);
+	shadow_cpu_if->used_lrs	= used_lrs;
+
+	for (i = 0; i < used_lrs; i++)
+		shadow_cpu_if->vgic_lr[i] = READ_ONCE(host_cpu_if->vgic_lr[i]);
+}
+
+static void sync_vgic_state(struct kvm_vcpu *host_vcpu,
+			    struct kvm_vcpu *shadow_vcpu)
+{
+	struct vgic_v3_cpu_if *host_cpu_if, *shadow_cpu_if;
+	unsigned int i;
+
+	host_cpu_if	= &host_vcpu->arch.vgic_cpu.vgic_v3;
+	shadow_cpu_if	= &shadow_vcpu->arch.vgic_cpu.vgic_v3;
+
+	WRITE_ONCE(host_cpu_if->vgic_hcr, shadow_cpu_if->vgic_hcr);
+
+	for (i = 0; i < shadow_cpu_if->used_lrs; i++)
+		WRITE_ONCE(host_cpu_if->vgic_lr[i], shadow_cpu_if->vgic_lr[i]);
+}
+
 static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 {
 	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
@@ -43,16 +84,13 @@ static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 
 	shadow_vcpu->arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
-	shadow_vcpu->arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
+	flush_vgic_state(host_vcpu, shadow_vcpu);
 }
 
 static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 {
 	struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
 	struct kvm_vcpu *host_vcpu = shadow_state->host_vcpu;
-	struct vgic_v3_cpu_if *shadow_cpu_if = &shadow_vcpu->arch.vgic_cpu.vgic_v3;
-	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
-	unsigned int i;
 
 	host_vcpu->arch.ctxt		= shadow_vcpu->arch.ctxt;
 
@@ -63,9 +101,7 @@ static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 
 	host_vcpu->arch.flags		= shadow_vcpu->arch.flags;
 
-	host_cpu_if->vgic_hcr		= shadow_cpu_if->vgic_hcr;
-	for (i = 0; i < shadow_cpu_if->used_lrs; ++i)
-		host_cpu_if->vgic_lr[i] = shadow_cpu_if->vgic_lr[i];
+	sync_vgic_state(host_vcpu, shadow_vcpu);
 }
 
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
