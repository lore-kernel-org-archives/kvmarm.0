Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865378;
	b=Y30anNOjuM/vElsna1MtJCRmiLmRDL0Zalo67HFzJcu8W7L0VzKqtWefdlsmH5bnYX/f
	 JzJR0fgrQAuPmLMEQYvXvs8eW4cNHZeYt69LP0uKsq2RT3TQPtM441xfOHyglAA5f8eTn
	 sE0rH5HYibn7hDsI5i0bNwVVlNxUMpLzJS+LkFtf669Gtm6icJavR1Pcoic1uCK9RZrHz
	 /ir0PEFs7iT8/OZnTmYJuAgGSrZA/GVM3z1XWiy9Iq6PUobXVyV7ou0OvYfXRU0/kA3i0
	 v0vsjEAuNVEhdqo3Brpg8JekGnJyeBjIqGjwXQHqLtnPDVsCWQDE6s43JWtokP+2gxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865378;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5B6N4DDj22ixhixZyzdJmBe3oqOyXBdQr+7zM8Rp+j4=;
	b=st3Dy+FdCEtUu8E3QKLDgS+ssATPV37tt8KCWPI415VqtLu+Bg/g0tbsAuZ1faxuDjpr
	 T69WGnN2A3ZVDUV0U7Lb0giGKhTqLIr0TTGy3gk/89Yq2tVvEN8fXkJ714mr62wHncirR
	 CDpj0WIAM5dj5M+RcYhnSIEFsCaSGcSaEIqiMG4RQUxA5xv7LhdTrk7aQKLXLjryoTyz+
	 kS0wPkR5z3omlBkicLV+fXYfMOEfBYoDdgJJLIFFkehWb1tBJkOr1k0CvhWn9gOpAm9qp
	 g9ILoWEcHjWV+hRgu/pOutyy+AkVD1kygmOYl366st2GQL7uPUYn9jNxjBEGd/WA8Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YZlTis3C;
	arc=none smtp.remote-ip=91.218.175.86
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7846606A335
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 07:56:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7846606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YZlTis3C
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=rai9fG/1C6uPMGpQ7UrCfbymBtKFMp4VTd01RgKVVcc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793865374; v=1; x=1794470174;
 b=YZlTis3CtDsgrNO0X1a2UvxiQq3PHdmydM4Ov6871ydXABZUaodQaGjUIAlxhG4O8RtaX+Cv
 VR/Bg0xjAiZEB6FIIQsAEwxxeK85s3Gkr/edCqaJLgjoE3KDtIjuz4AUbizvbWelUTjuO4F8DGz
 lPeExx0pYqtdmJXXSRdUNYGU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cdd035fca78d65f2;
	Thu, 05 Nov 2026 07:56:14 +0000
X-Mizu-Trace-ID: cdd035fca78d65f2
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Martijn Bogaard <martijnbogaard@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: arm64: Honour the requested IPA size under pKVM
Date: Thu,  5 Nov 2026 07:56:06 +0000
Message-ID: <20261105075606.367005-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105075606.367005-1-fuad.tabba@linux.dev>
References: <20261105075606.367005-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pKVM gives every VM the host's IPA limit, whatever size the VMM
requested with KVM_VM_TYPE_ARM_IPA_SIZE, so the vgic_init selftest fails
on any pKVM host whose limit exceeds 40 bits: the addresses it expects a
40-bit VM to reject are in range. EL2 also sizes the guest's stage 2
from the host stage 2's VTCR, which on a 64K kernel built for 48-bit PAs
on a 52-bit part is 48 bits where the limit is 52. KVM_RUN then returns
-ERANGE on the guest's first access to a memslot above 2^48 that the
host accepted.

Have EL2 take the IPA size from the VM's VTCR, the one the host sized
the donated PGD from, and drop the host-side override, so the request
is checked and honoured as on any other host. A VMM passing the default
type then gets 40 bits, and -EINVAL on a host whose limit is below 40,
as without pKVM. EL2 rejects a size below 32 bits or beyond the host's
IPA limit, which kvm_hyp_init_symbols() copies to EL2 before the host
drops its privileges.

Fixes: 60dfe093ec13 ("KVM: arm64: Instantiate guest stage-2 page-tables at EL2")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hyp.h |  1 +
 arch/arm64/kvm/arm.c             |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c   | 20 ++++++++++++++++----
 arch/arm64/kvm/mmu.c             |  4 +---
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index b0e42be3d9eef..8cffdf614af46 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -154,6 +154,7 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
+extern u32 kvm_nvhe_sym(kvm_ipa_limit);
 extern enum mitigation_state kvm_nvhe_sym(spectre_v2_state);
 extern enum mitigation_state kvm_nvhe_sym(spectre_v4_state);
 extern enum mitigation_state kvm_nvhe_sym(spectre_bhb_state);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 157bf4b812020..81262193ffaca 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2836,6 +2836,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64SMFR0_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
+	kvm_nvhe_sym(kvm_ipa_limit) = get_kvm_ipa_limit();
 
 	kvm_nvhe_sym(spectre_v2_state) = arm64_get_spectre_v2_state();
 	kvm_nvhe_sym(spectre_v4_state) = arm64_get_spectre_v4_state();
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 820baf9ff74a2..0cbe15b15d08b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -30,6 +30,8 @@ unsigned long __icache_flags;
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
+u32 kvm_ipa_limit;
+
 unsigned int kvm_host_sve_max_vl;
 
 /*
@@ -505,7 +507,8 @@ static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
 }
 
 static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
-			     unsigned int nr_vcpus, pkvm_handle_t handle)
+			     unsigned int nr_vcpus, pkvm_handle_t handle,
+			     u64 vtcr)
 {
 	struct kvm_s2_mmu *mmu = &hyp_vm->kvm.arch.mmu;
 	int idx = vm_handle_to_idx(handle);
@@ -525,7 +528,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	/* VMID 0 is reserved for the host */
 	atomic64_set(&mmu->vmid.id, idx + 1);
 
-	mmu->vtcr = host_mmu.arch.mmu.vtcr;
+	mmu->vtcr = vtcr;
 	mmu->arch = &hyp_vm->kvm.arch;
 	mmu->pgt = &hyp_vm->pgt;
 }
@@ -908,6 +911,8 @@ int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva)
 	unsigned int nr_vcpus;
 	pkvm_handle_t handle;
 	void *pgd = NULL;
+	u32 phys_shift;
+	u64 vtcr;
 	int ret;
 
 	ret = hyp_pin_shared_mem(host_kvm, host_kvm + 1);
@@ -926,8 +931,15 @@ int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva)
 		goto err_unpin_kvm;
 	}
 
+	phys_shift = VTCR_EL2_IPA(READ_ONCE(host_kvm->arch.mmu.vtcr));
+	if (phys_shift < ARM64_MIN_PARANGE_BITS || phys_shift > kvm_ipa_limit) {
+		ret = -EINVAL;
+		goto err_unpin_kvm;
+	}
+
+	vtcr = kvm_get_vtcr(id_aa64mmfr0_el1_sys_val, id_aa64mmfr1_el1_sys_val, phys_shift);
 	vm_size = pkvm_get_hyp_vm_size(nr_vcpus);
-	pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.mmu.vtcr);
+	pgd_size = kvm_pgtable_stage2_pgd_size(vtcr);
 	if (!IS_ALIGNED((unsigned long)pgd_hva, pgd_size)) {
 		ret = -EINVAL;
 		goto err_unpin_kvm;
@@ -945,7 +957,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva)
 	if (!pgd)
 		goto err_free_hyp_vm;
 
-	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle);
+	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle, vtcr);
 
 	ret = kvm_guest_prepare_stage2(hyp_vm, pgd);
 	if (ret)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db73..861d10983d0d0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -972,9 +972,7 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	u32 phys_shift;
 
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
-	if (is_protected_kvm_enabled()) {
-		phys_shift = kvm_ipa_limit;
-	} else if (phys_shift) {
+	if (phys_shift) {
 		if (phys_shift > kvm_ipa_limit ||
 		    phys_shift < ARM64_MIN_PARANGE_BITS)
 			return -EINVAL;
-- 
2.47.3

