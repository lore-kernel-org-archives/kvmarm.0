Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CA43A7F72
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721951; cv=none; b=uyt88Mnjaab5fITAMevcDoWmAyYYvM9+inommtJxUWuQyoxSi9WmSZDl4mJap2uFzRyLjCG/Ho04EBWtret6G18jFalCQV4aTv8W1lW8aVaIl1ZNYc0SXtkCIuuN0hbVxu5JnhPmszr5vsV21k1Til4UjHq25SMAXt/p0YiJiU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721951; c=relaxed/simple;
	bh=v3KVb0ei2XKe7JH4mQ0tL3ZhknFGX3kJj3Ixv2atPic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VB8GPPEWFMeI4zGdV/tq+hM9Okw758b3EAL3hZ6QjRAR/9fgX28eGW4l9/QFO14dj/FBfdTBh0YBALsqiAsd83vJk5QIwFW1+W3FFsu/2EpzGsOp3P/D4+fsclmmB9foFNCl+7M0X8i8DvYKQZh2e+0BQSaRJhwZUZJb0PNZy24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELDBMzL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELDBMzL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C73C116C6;
	Thu,  5 Mar 2026 14:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721951;
	bh=v3KVb0ei2XKe7JH4mQ0tL3ZhknFGX3kJj3Ixv2atPic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELDBMzL+5yewdZ8eTaRHY/0NCdHbmhFT7Xs7YJozcKml/YJ06vvg5QvZmdJXC3yru
	 Mx78ooyba6FkO5U3rymr9mgEEyB89nX8LZYvt5IzUDTCvZdYj4qT3Edbt5dD6GsMdl
	 IWLcmosBlBlarwAG9c1yQ7HQyWbNpvHku+mq8Dn4nmgT+/vlSaPWT8e/HXdEy2CmQK
	 ZsexCB3Qvm1ie2NavWdvrevDQRDQ3MqqYBv5oDM6bsRU/TxCBw4uPHZRj4antrOkYK
	 8Bgu8f3CvzYZBOOLSt6Mb8A77MTcHDA864vRUfAc07YzGoTaKGxQcZbwYClvU2lBPC
	 2EWsOOMMsxskQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 29/36] KVM: arm64: Implement the MEM_UNSHARE hypercall for protected VMs
Date: Thu,  5 Mar 2026 14:43:42 +0000
Message-ID: <20260305144351.17071-30-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the ARM_SMCCC_KVM_FUNC_MEM_UNSHARE hypercall to allow
protected VMs to unshare memory that was previously shared with the host
using the ARM_SMCCC_KVM_FUNC_MEM_SHARE hypercall.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 34 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 22 ++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 42fd60c5cfc9..e41a128b0854 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -36,6 +36,7 @@ extern unsigned long hyp_nr_cpus;
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
+int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 22d456ab15a6..4451955ac767 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -991,6 +991,40 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 	return ret;
 }
 
+int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 meta, phys, ipa = hyp_pfn_to_phys(gfn);
+	kvm_pte_t pte;
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
+	if (ret)
+		goto unlock;
+
+	ret = -EPERM;
+	if (pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte)) != PKVM_PAGE_SHARED_OWNED)
+		goto unlock;
+	if (__host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED))
+		goto unlock;
+
+	ret = 0;
+	meta = host_stage2_encode_gfn_meta(vm, gfn);
+	WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
+						      PKVM_ID_GUEST, meta));
+	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
+				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+unlock:
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
+
 int __pkvm_host_unshare_hyp(u64 pfn)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 1dc9225073c4..ebfd9904ede6 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1019,6 +1019,19 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
+static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	u64 ipa = smccc_get_arg1(vcpu);
+
+	if (!PAGE_ALIGNED(ipa))
+		return;
+
+	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
+	if (!__pkvm_guest_unshare_host(hyp_vcpu, hyp_phys_to_pfn(ipa)))
+		ret[0] = SMCCC_RET_SUCCESS;
+}
+
 /*
  * Handler for protected VM HVC calls.
  *
@@ -1036,6 +1049,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_SHARE);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_UNSHARE);
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID:
 		if (smccc_get_arg1(vcpu) ||
@@ -1054,6 +1068,14 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 		handled = pkvm_memshare_call(val, vcpu, exit_code);
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
+		if (smccc_get_arg2(vcpu) ||
+		    smccc_get_arg3(vcpu)) {
+			break;
+		}
+
+		pkvm_memunshare_call(val, vcpu);
+		break;
 	default:
 		/* Punt everything else back to the host, for now. */
 		handled = false;
-- 
2.53.0.473.g4a7958ca14-goog

