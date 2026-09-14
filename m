Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D4C463B96;
	Mon, 14 Sep 2026 12:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388818; cv=none; b=qNn5/aDae3aSjyBYC41sZ503KfHFHwFiMLqDv3iqKCVR/2dS5DJlnUkmN+O1LFmGb3Orn+mqAcY/QRr/j4J9lRkvLt7edIKNerleb54xfu5QUnuP2W47Xt/BWaif1bPlY01xA54eTFw8AE7nxVOiUUYUbA9st+lHKjrXtU3Pr18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388818; c=relaxed/simple;
	bh=VZcSKR8yxRV7e2O4hOy2SU5uYNlmsrpgI1kclfEhfHw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G43JWwLz7Zhb/5VlBgm9IPp4zSRBmhK4wB02JUBVtvKNlQdAAfbl59W+OU2nLh0p6j4EGFyqbuCMQYIJ6HDfje2PhF1d5lW+jAQ34zsRHdS9+6FBQwX1oQXYC2p7JkwkqlU17YnfMY1NC4G4rn764/X7GIhNIxgrq7tGn+agrfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lj8jBcZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lj8jBcZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC381F00893;
	Mon, 14 Sep 2026 12:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388814;
	bh=2BN4nsRUF6et4huKV7sboPy7MNqNCFDoN6pq7KaBtvI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lj8jBcZEcHBQyVpUtx8fvicJEMpA+vQtXGEQ3iVBQa+D72wsYCg1MISeemTEOmy0e
	 ZohRt3EHQCuEb7yKQ0mhc88U8PMX3gJ7gdGN4cPowS0UQYptCgF3KIu9vvssp7vPzR
	 01wElEv7lBX985U22kVMTuzmafbqKlhDc8cGtWRKFaDc1/ZS5jyyXXMN1HP5B/3FQP
	 /22RA8jOECnKwMKfiF5vdoZaMMI4fnnG8oKo20UqszI4034zqWpjlSrOQw/+j397cv
	 L9ohyZ8clqAYU79KH9dXMgNnX+ZcKcS+ABQfZUM5Hi+IFIcKM3aKUIPyNpPaVPWbIp
	 ZnsOu5xavM20w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 13:26:14 +0100
Subject: [PATCH v2 03/13] KVM: arm64: Propagate and use esr in s2fd when
 handling guest aborts
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-kvm-arm-prefault-v2-3-26fb47f74b73@kernel.org>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
In-Reply-To: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2889; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VZcSKR8yxRV7e2O4hOy2SU5uYNlmsrpgI1kclfEhfHw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWP//ySLxMS5T/aLtwXP+LRQnb52Wregc/PWsc1x0Su
 ++Fse+PjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzk+z9GhqUrjgttTdz1W6OM
 pUdNaUq3s5vzFK5w2VKG8rbW/bPqghgZbm+fU9KlGXp64nddxc7i0CmvSvvb0q8Vn3pvMTVCrVu
 MBwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

kvm_handle_guest_abort() establishes a kvm_s2_fault_desc data structure,
s2fd, to store and propagate state to either pkvm_mem_abort(), gmem_abort()
or user_mem_abort() handlers.

Each of these, however, examines the Exception Syndrome Register (ESR) via
s2fd->vcpu.

Introduce an s2fd->esr field to abstract this and propagate it to callers.

The value of this (beyond refactoring) is to be able to later generate
faults with a synthetic esr, specifically to implement stage 2 page table
pre-faulting.

Abort handlers which use kvm_s2_fault_desc - gmem_abort() and
user_mem_abort() - now only reference s2fd->esr and do not look it up in
any other way, which makes it safe to pass a synthetic s2fd->esr value to
these functions.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d1a6e25c3095..8303121e3332 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1603,21 +1603,22 @@ struct kvm_s2_fault_desc {
 	struct kvm_s2_trans	*nested;
 	struct kvm_memory_slot	*memslot;
 	unsigned long		hva;
+	unsigned long		esr;
 };
 
 static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
 {
-	return esr_fsc_is_permission_fault(kvm_vcpu_get_esr(s2fd->vcpu));
+	return esr_fsc_is_permission_fault(s2fd->esr);
 }
 
 static bool kvm_s2_fault_is_exec(const struct kvm_s2_fault_desc *s2fd)
 {
-	return esr_abt_is_exec_fault(kvm_vcpu_get_esr(s2fd->vcpu));
+	return esr_abt_is_exec_fault(s2fd->esr);
 }
 
 static bool kvm_s2_fault_is_write(const struct kvm_s2_fault_desc *s2fd)
 {
-	return esr_abt_is_write_fault(kvm_vcpu_get_esr(s2fd->vcpu));
+	return esr_abt_is_write_fault(s2fd->esr);
 }
 
 static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
@@ -1626,7 +1627,7 @@ static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
 
 	if (!kvm_s2_fault_is_perm(s2fd))
 		return 0;
-	level = kvm_vcpu_get_esr(s2fd->vcpu) & ESR_ELx_FSC_LEVEL;
+	level = s2fd->esr & ESR_ELx_FSC_LEVEL;
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
 }
 
@@ -1997,7 +1998,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	 * and trigger the exception here. Since the memslot is valid, inject
 	 * the fault back to the guest.
 	 */
-	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(s2fd->vcpu))) {
+	if (esr_fsc_is_excl_atomic_fault(s2fd->esr)) {
 		kvm_inject_dabt_excl_atomic(s2fd->vcpu, kvm_vcpu_get_hfar(s2fd->vcpu));
 		return 1;
 	}
@@ -2426,6 +2427,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		.nested		= nested,
 		.memslot	= memslot,
 		.hva		= hva,
+		.esr		= esr,
 	};
 
 	if (kvm_vm_is_protected(vcpu->kvm)) {

-- 
2.55.0

