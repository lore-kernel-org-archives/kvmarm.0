Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF65F4AB3C3
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 16:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791821745; cv=none; b=kfFlDHPqOkVY5tC9ktp5cmYWanaEc1SwOuG08yUC6mBm0Ld5zmKiBE/+6Gqeo8KzzAA4bm4QLg2dwmi/g12UHNQLXIxaocqxNCqJZu7Nxju72+8B3vHsT+effrirBCxc+fQbqoHjbxtHLMjqkbtQpsE5dGORAL4yMH0+mFhmOF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791821745; c=relaxed/simple;
	bh=MS6Ai7kYsGDBUhWOJOqxT06KTaz3wq2XFRTVLCJ+Ee0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rWNRd4ySHkuaj5eVnbMqE/zjFW0o6tZBDd/0DgaiRoLeyw5VPNK6kldnYeIJRoXCbSq4PyoS6M4ymPszBW4rZr3S6rRkvh1mmB4Zwgg35o4mkBUoB2XwR+f2XVtMNHnfnXUj0dHTZLISfXv8OwnRwrNBAQO1A8x6kRxKxj9fWGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Onbftcie; arc=none smtp.client-ip=95.215.58.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Onbftcie"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=MS6Ai7kYsGDBUhWOJOqxT06KTaz3wq2XFRTVLCJ+Ee0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791821741; v=1; x=1792426541;
 b=OnbftcieTnKywjJLyKVZOdM8BTW+wixQ/5LsZ8xU5M13j0njVoFzb6/xQzK1PNoh3BRzxViO
 /SO/h5jt/qcY3Fl5cDLtwMaylPbtg2aQ7WuMbILvDFFXGXqbnRHrhRJuS2dWLPbeQfBcIIIDe9E
 ef6ltG42wXQKwRA/Rlo4H7g8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 35b98ee5bcb724f9;
	Mon, 12 Oct 2026 16:15:41 +0000
X-Mizu-Trace-ID: 35b98ee5bcb724f9
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
Subject: [PATCH v3 2/5] KVM: arm64: Reject the stage-2 flush hypercalls under pKVM
Date: Mon, 12 Oct 2026 17:15:21 +0100
Message-Id: <20261012161524.4016464-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261012161524.4016464-1-fuad.tabba@linux.dev>
References: <20261012161524.4016464-1-fuad.tabba@linux.dev>
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
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
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

