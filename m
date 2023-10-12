Received: from out-195.mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A863D971
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 20:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RJSVLSkU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697144075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ysKrMhA787sO5UVDC8NhNunti56cIWj9yanawa7g7NY=;
	b=RJSVLSkUo1jGerM0C+jXC5LuQQOX0NXdEVkQulty3HZ4V8GJBZdNgx2SLjZ/v5G2kFNtNk
	+4nlqlOw0tMlBpX4+AJrbtQvXhV4srN0X1b5Z9M+XaF8wuH8Di1egaTeNFcgi4+jBrGWQ7
	48PIzaN4W4FSvw8nzDh2KCIjm6tEXWU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 2/5] KVM: arm64: Restore the stage-2 context in VHE's __tlb_switch_to_host()
Date: Thu, 12 Oct 2023 20:54:19 +0000
Message-ID: <20231012205422.3924618-3-oliver.upton@linux.dev>
In-Reply-To: <20231012205422.3924618-1-oliver.upton@linux.dev>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

An MMU notifier could cause us to clobber the stage-2 context loaded on
a CPU when we switch to another VM's context to invalidate. This isn't
an issue right now as the stage-2 context gets reloaded on every guest
entry, but is disastrous when moving __load_stage2() into the
vcpu_load() path.

Restore the previous stage-2 context on the way out of a TLB
invalidation if we installed something else. Deliberately do this after
TGE=1 is synchronized to keep things safe in light of the speculative AT
errata.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/tlb.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index f3f2e142e4f4..ef21153ce5fa 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -11,18 +11,25 @@
 #include <asm/tlbflush.h>
 
 struct tlb_inv_context {
-	unsigned long	flags;
-	u64		tcr;
-	u64		sctlr;
+	struct kvm_s2_mmu	*mmu;
+	unsigned long		flags;
+	u64			tcr;
+	u64			sctlr;
 };
 
 static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 				  struct tlb_inv_context *cxt)
 {
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	u64 val;
 
 	local_irq_save(cxt->flags);
 
+	if (vcpu && mmu != vcpu->arch.hw_mmu)
+		cxt->mmu = mmu;
+	else
+		cxt->mmu = NULL;
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/*
 		 * For CPUs that are affected by ARM errata 1165522 or 1530923,
@@ -69,6 +76,10 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 	isb();
 
+	/* ... and the stage-2 MMU context that we switched away from */
+	if (cxt->mmu)
+		__load_stage2(cxt->mmu, cxt->mmu->arch);
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/* Restore the registers to what they were */
 		write_sysreg_el1(cxt->tcr, SYS_TCR);
-- 
2.42.0.655.g421f12c284-goog

