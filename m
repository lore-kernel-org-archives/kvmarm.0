Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8904F3783AE
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 17:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789407939; cv=none; b=SqmZ3xUsIodkKqTaN3S0GlgWpDatkCQFIJ8imy4D4Xcr/50joJtLsxG8LowDts/m0xVyzS5SSM+saE3PEJNohqUvH5tvxFyPaBwl7hQdJAZyF0pswOhL0Htw//CcysO160Y4+gCl7Fa3C1mDx6pBDp954/MGbNdfpejd4bNc3w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789407939; c=relaxed/simple;
	bh=PrgyValbiyYMTfVMJESIc+fLfCQaV5hw9qbA3T1oo9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oHMayeodod9AIzlRIPYSFyKZ+OPsidiU2fdXTjKE9Q3R21gjHE2cChSS2fGxzwJOhMbDlyh7QfMp4za5xkggbOU9daokmcMrORhLUPT6xWUogmkML3XuGMxuFz3mJc9PY+4mJYhtlAt6ZoFdz3JsZduUA9KD72rgesjizvhSVRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RNvV8mMl; arc=none smtp.client-ip=91.218.175.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RNvV8mMl"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=PrgyValbiyYMTfVMJESIc+fLfCQaV5hw9qbA3T1oo9Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789407935; v=1; x=1790012735;
 b=RNvV8mMlroXJNlt9iqOXpGir57TnBB1WiHxz/xeDTAOHxVFCqzuvinq4n0t8yOQ5rSockQnL
 X3YcH+U5l2z4ZvoXknyXe3ncHOrVpBBpGSmLG/smN7IoZutYhmpxz+NAGQ4AZTMF70kVEOZQb4r
 1pzl5DHU46QEdc+2PQZHh7CI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a45841c83f61cc60;
	Mon, 14 Sep 2026 17:45:22 +0000
X-Mizu-Trace-ID: a45841c83f61cc60
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH] KVM: arm64: Reject the stage-2 MMU pointer hypercalls under pKVM
Date: Mon, 14 Sep 2026 18:45:21 +0100
Message-Id: <20260914174521.832575-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The five hypercalls that take a struct kvm_s2_mmu pointer remain
callable after pKVM finalises, and each dereferences the host pointer
in __load_stage2(). Under pKVM none of them has a valid caller: the
host walks no guest stage-2, its TLB flushes go through the handle-based
__pkvm_tlb_flush_vmid, and kvm_arch_vcpu_load() skips the CPU context
flush.

Reject all five when protected mode is enabled.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260914130152.F0D5F1F000FF@smtp.kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    No in-tree host path reaches these, so no Fixes: tag.

 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626adb..4b0d00e55e2ea 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -557,6 +557,9 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
 	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
 	DECLARE_REG(int, level, host_ctxt, 3);
 
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
 	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 }
 
@@ -566,6 +569,9 @@ static void handle___kvm_tlb_flush_vmid_ipa_nsh(struct kvm_cpu_context *host_ctx
 	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
 	DECLARE_REG(int, level, host_ctxt, 3);
 
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
 	__kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va(mmu), ipa, level);
 }
 
@@ -576,6 +582,9 @@ handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
 	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
 	DECLARE_REG(unsigned long, pages, host_ctxt, 3);
 
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
 	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, pages);
 }
 
@@ -583,6 +592,9 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
 
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
 	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 }
 
@@ -602,6 +614,9 @@ static void handle___kvm_flush_cpu_context(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
 
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
 	__kvm_flush_cpu_context(kern_hyp_va(mmu));
 }
 

base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

