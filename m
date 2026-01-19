Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFBF35E555
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826899; cv=none; b=K4bGPzqRePn/34acv6JwcxLfyj7fpwzomIozFtOZpoV9EFewLwpVsXlGC1XY8Vmc/PCdnA/PedCfg+7N/6wy50kaZ9/zhm8Yn+ZqPmSKDZ5EkCoBvMRVjAC6ZanhhEvTJV1tek7oZ5hZp6mLdqBHiBMVD9TjctbsoB3C5V968d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826899; c=relaxed/simple;
	bh=9YAmtx2N6Hzqu9M4PgAhiSAbJaH9jkJSR2dOrWkXHxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIDxL16pnG/k4Inz+wIRrk4ZWsCpd546W+ZgVUkY3l8Ze6GbTfv5+7xYPbmHvLmLLbgegEu/yDEWw3SV5r+VoxeNBdAsh8LduGTqrW2/oBX7cUx4IZQJTRhYapH3obTB9Zvs/t1U1ZWH0JXr7KcDnos36DQMij6uKG77mUVRvHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qx2dlUPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qx2dlUPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35B0C116C6;
	Mon, 19 Jan 2026 12:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826899;
	bh=9YAmtx2N6Hzqu9M4PgAhiSAbJaH9jkJSR2dOrWkXHxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qx2dlUPVkJMFGSIMIvRsMOy8Nx2HAbZlHdJe43siIAaPLLi2/2yjDH2H7KJ5hiVSc
	 FOud4Y1WCJpe/mXc3kAuw2+ADN6WtB2fbMwkAelwBe9UO0+qkDS63rvMs1yZXYy7JQ
	 ZaYeqmOeruXD8A2KZUoZUquBveIZV6HeWu5p1a/5eII4ds4sb+4thnXGKpyvQKkCs+
	 /kA/gzsl1Ihf2+slTaB/iznRad/da+VT6+qmuDdYBmmU8b9ZIohy1doEdiifOCtGz5
	 59C4nJxwNW8t+9fY6tSQrX77z+5VvK6GNYGG8dQ5qpW+1FhzyLN0Y+LfiDPCTnyi0I
	 CgQf90torobZw==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 28/35] KVM: arm64: Implement the MEM_SHARE hypercall for protected VMs
Date: Mon, 19 Jan 2026 12:46:21 +0000
Message-ID: <20260119124629.2563-29-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the ARM_SMCCC_KVM_FUNC_MEM_SHARE hypercall to allow protected
VMs to share memory (e.g. the swiotlb bounce buffers) back to the host.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 32 ++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 61 +++++++++++++++++++
 3 files changed, 94 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 5e6cdafcdd69..42fd60c5cfc9 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -35,6 +35,7 @@ extern unsigned long hyp_nr_cpus;
 
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
+int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 914b373cfb56..7535a45565f4 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -967,6 +967,38 @@ int __pkvm_host_share_hyp(u64 pfn)
 	return ret;
 }
 
+int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 phys, ipa = hyp_pfn_to_phys(gfn);
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
+	if (pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte)) != PKVM_PAGE_OWNED)
+		goto unlock;
+	if (__host_check_page_state_range(phys, PAGE_SIZE, PKVM_NOPAGE))
+		goto unlock;
+
+	ret = 0;
+	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
+				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
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
index 64171e04ea82..4133556560d9 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -937,6 +937,58 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	hyp_spin_unlock(&vm_table_lock);
 	return err;
 }
+
+static u64 __pkvm_memshare_page_req(struct kvm_vcpu *vcpu, u64 ipa)
+{
+	u64 elr;
+
+	/* Fake up a data abort (level 3 translation fault on write) */
+	vcpu->arch.fault.esr_el2 = (ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT) |
+				   ESR_ELx_WNR | ESR_ELx_FSC_FAULT |
+				   FIELD_PREP(ESR_ELx_FSC_LEVEL, 3);
+
+	/* Shuffle the IPA around into the HPFAR */
+	vcpu->arch.fault.hpfar_el2 = (HPFAR_EL2_NS | (ipa >> 8)) & HPFAR_MASK;
+
+	/* This is a virtual address. 0's good. Let's go with 0. */
+	vcpu->arch.fault.far_el2 = 0;
+
+	/* Rewind the ELR so we return to the HVC once the IPA is mapped */
+	elr = read_sysreg(elr_el2);
+	elr -= 4;
+	write_sysreg(elr, elr_el2);
+
+	return ARM_EXCEPTION_TRAP;
+}
+
+static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	u64 ipa = smccc_get_arg1(vcpu);
+
+	if (!PAGE_ALIGNED(ipa))
+		goto out_guest;
+
+	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
+	switch (__pkvm_guest_share_host(hyp_vcpu, hyp_phys_to_pfn(ipa))) {
+	case 0:
+		ret[0] = SMCCC_RET_SUCCESS;
+		goto out_guest;
+	case -ENOENT:
+		/*
+		 * Convert the exception into a data abort so that the page
+		 * being shared is mapped into the guest next time.
+		 */
+		*exit_code = __pkvm_memshare_page_req(vcpu, ipa);
+		goto out_host;
+	}
+
+out_guest:
+	return true;
+out_host:
+	return false;
+}
+
 /*
  * Handler for protected VM HVC calls.
  *
@@ -953,6 +1005,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_SHARE);
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID:
 		if (smccc_get_arg1(vcpu) ||
@@ -963,6 +1016,14 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 		val[0] = PAGE_SIZE;
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
+		if (smccc_get_arg2(vcpu) ||
+		    smccc_get_arg3(vcpu)) {
+			break;
+		}
+
+		handled = pkvm_memshare_call(val, vcpu, exit_code);
+		break;
 	default:
 		/* Punt everything else back to the host, for now. */
 		handled = false;
-- 
2.52.0.457.g6b5491de43-goog

