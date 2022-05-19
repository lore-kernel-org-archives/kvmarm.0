Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E48C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:45:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 262014B3C6;
	Thu, 19 May 2022 09:45:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QOBvtJTVFHzJ; Thu, 19 May 2022 09:45:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFB094B428;
	Thu, 19 May 2022 09:45:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF9D4B3C6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zfvpJ-3R4XBj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:45:33 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBF6B4B38D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:32 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5506E61783;
 Thu, 19 May 2022 13:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F4FC36AE9;
 Thu, 19 May 2022 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967931;
 bh=Lap94vFReqwzTxg/tbwg0Yft34nE9OnNIp6v3p0dx8U=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GaBkW/HfPe0KmezeFJL4EFboOVaIrUETQBmTsWvHeWFsNovB0DsnZja5PCdhGL1c5
 voJhnaSvK6DzfziEV1XynP58XmIUR6wsJDltbTNo+dk9rPMlgF+hloxC5p87BuNwG0
 MeG13K1Ji0WX+XqFoMbo6NYc6f/i19Mkn7e4tzaR5Xhi+neV8qNzUIGFlxZSi4noaP
 kXiWL20/KlZSbohxXXrovc0M94LzPoF67UfMtV2kGTzHo2zGuQFol8p9AYiTWzZfj/
 CUQF0RIr+O9MEmRG8o4N8O1fwnnYxFymOZw08xMZ1+Nstoo+n/1/3DiiEyRYrg0myx
 mPW3FZIW7X7XA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 47/89] KVM: arm64: Add current vcpu and shadow_state lookup
 primitive
Date: Thu, 19 May 2022 14:41:22 +0100
Message-Id: <20220519134204.5379-48-will@kernel.org>
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

In order to be able to safely manipulate the loaded state,
add a helper that always return the vcpu as mapped in the EL2 S1
address space as well as the pointer to the shadow state.

In case of failure, both pointers are returned as NULL values.

For non-protected setups, state is always NULL, and vcpu the
EL2 mapping of the input value.

handle___kvm_vcpu_run() is converted to this helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 41 +++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9e3a2aa6f737..40cbf45800b7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -177,22 +177,51 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
 	}
 }
 
+static struct kvm_vcpu *__get_current_vcpu(struct kvm_vcpu *vcpu,
+					   struct kvm_shadow_vcpu_state **state)
+{
+	struct kvm_shadow_vcpu_state *sstate = NULL;
+
+	vcpu = kern_hyp_va(vcpu);
+
+	if (unlikely(is_protected_kvm_enabled())) {
+		sstate = pkvm_loaded_shadow_vcpu_state();
+		if (!sstate || vcpu != sstate->host_vcpu) {
+			sstate = NULL;
+			vcpu = NULL;
+		}
+	}
+
+	*state = sstate;
+	return vcpu;
+}
+
+#define get_current_vcpu(ctxt, regnr, statepp)				\
+	({								\
+		DECLARE_REG(struct kvm_vcpu *, __vcpu, ctxt, regnr);	\
+		__get_current_vcpu(__vcpu, statepp);			\
+	})
+
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
+	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *vcpu;
 	int ret;
 
-	if (unlikely(is_protected_kvm_enabled())) {
-		struct kvm_shadow_vcpu_state *shadow_state = pkvm_loaded_shadow_vcpu_state();
-		struct kvm_vcpu *shadow_vcpu = &shadow_state->shadow_vcpu;
+	vcpu = get_current_vcpu(host_ctxt, 1, &shadow_state);
+	if (!vcpu) {
+		cpu_reg(host_ctxt, 1) =  -EINVAL;
+		return;
+	}
 
+	if (unlikely(shadow_state)) {
 		flush_shadow_state(shadow_state);
 
-		ret = __kvm_vcpu_run(shadow_vcpu);
+		ret = __kvm_vcpu_run(&shadow_state->shadow_vcpu);
 
 		sync_shadow_state(shadow_state);
 	} else {
-		ret = __kvm_vcpu_run(kern_hyp_va(host_vcpu));
+		ret = __kvm_vcpu_run(vcpu);
 	}
 
 	cpu_reg(host_ctxt, 1) =  ret;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
