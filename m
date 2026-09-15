Received: from mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA824A5C42
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 12:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475941; cv=none; b=o6UhO9z0CC3blqLKQDalWbDrC1/t/ONw50Apo2gmIN0PsPYEHKmFOcpOfvPXBbeis772PrP5B0OLwKtIdJ9Gli0vws0jnszn+Bjl69L5LOr8HSN8I1JTlKvnrRaYa+9DswozdCMTzXSpjoF0gwcVGoEtJVy2HkYlEhoHvcXGp6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475941; c=relaxed/simple;
	bh=UabJMBs9Z2dMomcvezICknlRvRSdmtK2yTGhqNrS3jk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qiPbfNcnBQq43zVIlJe2OUW08zbepxO7JIx4xopcOEj3zBezrhqb50Fb21SysdFskyMvm0kDhSTF7ZSaEnHu5ESLGW+kikfi6Qa5KuTvqMSWDBqs3HfGBI/LMExqSRYzKljmQ4uSjt3pMP12ui+iukxWWxLDzOO8qcqoq+WIY6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xBWwOu9m; arc=none smtp.client-ip=91.218.175.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xBWwOu9m"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=UabJMBs9Z2dMomcvezICknlRvRSdmtK2yTGhqNrS3jk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789475937; v=1; x=1790080737;
 b=xBWwOu9m2XNP6rrRCyoIw9ylEsQyX47X8jfI9yg6LbgRwCNB1k+OruuMSsu2hkEUbY/Kufv7
 l5QManhMU5gv7Kw4fzSNovQJ1+ruRmy5FAmIFzNilapg9d599S9MmL0ert47LlM6H7JQq/99++C
 I49gkqBBl6uAP6Q9mVen4O6g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6cbd52d59c5a6876;
	Tue, 15 Sep 2026 12:38:57 +0000
X-Mizu-Trace-ID: 6cbd52d59c5a6876
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
	Sascha.Bischoff@arm.com,
	steven.price@arm.com,
	tabba@google.com
Subject: [PATCH 2/7] KVM: arm64: Reject the stage-2 flush hypercalls under pKVM
Date: Tue, 15 Sep 2026 13:38:41 +0100
Message-Id: <20260915123846.2317931-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915123846.2317931-1-fuad.tabba@linux.dev>
References: <20260915123846.2317931-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The stage-2 TLB and context flush hypercalls remain callable once pKVM
has finalised, and five of the six dereference a host-supplied
struct kvm_s2_mmu pointer. Under pKVM none has a valid caller: the host
walks no guest stage-2, its TLB flushes go through the handle-based
__pkvm_tlb_flush_vmid, and kvm_arch_vcpu_load() skips both the VMID
update and the CPU context flush.

Move them into the band the dispatcher rejects once pKVM has finalised.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260914130152.F0D5F1F000FF@smtp.kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_asm.h   | 12 ++++++------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 ++++++-----
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ea319c496bb26..b182c908c1a98 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -64,6 +64,12 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
+	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa_nsh,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
+	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MIN_PKVM),
 
@@ -72,12 +78,6 @@ enum __kvm_host_smccc_func {
 	/* Hypercalls that are always available and common to [nh]VHE/pKVM. */
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
-	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
-	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
-	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa_nsh,
-	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
-	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
-	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
 	__KVM_HOST_SMCCC_FUNC___tracing_load,
 	__KVM_HOST_SMCCC_FUNC___tracing_unload,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 7c939baf9c1ba..b2657a3c65b40 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -913,16 +913,16 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_get_gic_config),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
-	HANDLE_FUNC(__pkvm_prot_finalize),
-
-	HANDLE_FUNC(__kvm_adjust_pc),
-	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa_nsh),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
+	HANDLE_FUNC(__pkvm_prot_finalize),
+
+	HANDLE_FUNC(__kvm_adjust_pc),
+	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__tracing_load),
 	HANDLE_FUNC(__tracing_unload),
@@ -969,7 +969,8 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 
 	/*
 	 * If pKVM has been initialised then reject any calls to the
-	 * early "privileged" hypercalls. Note that we cannot reject
+	 * early "privileged" hypercalls, and to the ones the host has no
+	 * use for in protected mode. Note that we cannot reject
 	 * calls to __pkvm_prot_finalize for two reasons: (1) The static
 	 * key used to determine initialisation must be toggled prior to
 	 * finalisation and (2) finalisation is performed on a per-CPU
-- 
2.39.5

