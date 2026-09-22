Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232335505C4;
	Tue, 22 Sep 2026 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086724; cv=none; b=kxWqSXwphbaq4eMo+KGud0YE/uj/285ebhuC25h5tlYlch4TjWcmfMbuzFzrMBUZdt6m//GhqNzVcJfkFx4kOQzD57VxUJIeIv9v+2EAXeH2st3u9Fza62zwcm0jlGL76KMigR0/OEvqmPFBKt50cFUTyrE/tt5nikG4T7BhNco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086724; c=relaxed/simple;
	bh=asxtLL49HQozVkE268l/p+xpvta1Ezf4ofejg7HnIfs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SWZYrJDR6NaR4arN/HPEcgSjdWs8N4iJ2cGt92y8rKXrdi+R4Do8+VQ7Siz+Kk1ZeD+xclO/sMttTxQofY9I9YAr0zal5imTUgcijeq3Cde8HIB/MZAnivcKN10LYoMo4AgriuxOoBT/RLaweduqOX9/YbHXOZcZn1y9EH+i8R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tn9bpTGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tn9bpTGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9971F000FF;
	Tue, 22 Sep 2026 14:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086722;
	bh=6rfi6fn49UrxHSFNCSkfMq9EYAZI+/o5hmkNUu37CkM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Tn9bpTGQKCDEOkqmwzEF0kEESEQHF/u1j9RVDlaJBLFBAWlQuMKUdJMNUG5DXNsvp
	 2MAQfykhcU8sKD/wPzHvJq9Vf0I9EsqswPCz6dwwVu+ju39p3RhhwZIoNlgmQmI9Cj
	 Ymvsk25msvBItzeigUpPckNB1adlP0qIQzIfRXpIVsXgun9C9co8TM/7MZ5O3TeowS
	 DTtQP13A8Vmy4ihmtaQ7pWNf6ls8DSS1tuE2c6ibQwfAiKEs73blrFE9u6uBvz/WXB
	 W06CR9VvfM5Oa+MOE8++ZrTmvdzOhkOoxyC6wdAJxIPrs+QOs2XrjZyQU3Z+9VWpOo
	 thDS4brMvNuFw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 15:17:59 +0100
Subject: [PATCH v3 05/14] KVM: arm64: Propagate and use mmu in s2fd when
 handling guest aborts
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-kvm-arm-prefault-v3-5-787bd3bc7e3f@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
In-Reply-To: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3980; i=ljs@kernel.org;
 h=from:subject:message-id; bh=asxtLL49HQozVkE268l/p+xpvta1Ezf4ofejg7HnIfs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI29Ul4NtxsPl2bbDDrZ7h+ml39naz46pzJqqVH23Lzv
 3+e8Tumo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNZWszI8H/7yl0GkXd+CurO
 OXrumfGJv+s/rzv7gPXoYZu6Mx37WrwZGfqMbKW6Wv/NPfOl6HrqaZPJLHtr/rGrZR7jqhU26/y
 8kQcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

kvm_handle_guest_abort() establishes a kvm_s2_fault_desc data structure,
s2fd, to store and propagate state to either pkvm_mem_abort(), gmem_abort()
or user_mem_abort() handlers.

Each of these, however, examines the state of the stage 2 MMU via
vcpu->arch.hw_mmu.

Introduce an s2fd->mmu field to abstract this and propagate it to callers.

Similar to adding the esr field, this allows injection of synthetic faults
with the ultimate intention of implementing stage 2 page table
pre-faulting.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3cd4dd6478db..ea0d4be0298b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1656,6 +1656,7 @@ struct kvm_s2_fault_desc {
 	struct kvm_memory_slot	*memslot;
 	unsigned long		hva;
 	unsigned long		esr;
+	struct kvm_s2_mmu	*mmu;
 };
 
 static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
@@ -1689,7 +1690,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	bool perm_fault = kvm_s2_fault_is_perm(s2fd);
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
-	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
+	struct kvm_pgtable *pgt = s2fd->mmu->pgt;
 	struct kvm_guest_s2_mapping *mapping = NULL;
 	unsigned long mmu_seq;
 	struct page *page;
@@ -1805,7 +1806,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
 	struct kvm_vcpu *vcpu = s2fd->vcpu;
-	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	struct kvm_pgtable *pgt = s2fd->mmu->pgt;
 	struct mm_struct *mm = current->mm;
 	struct kvm *kvm = vcpu->kvm;
 	void *hyp_memcache;
@@ -2131,7 +2132,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	}
 
 	kvm_fault_lock(kvm);
-	pgt = s2fd->vcpu->arch.hw_mmu->pgt;
+	pgt = s2fd->mmu->pgt;
 	ret = -EAGAIN;
 	if (mmu_invalidate_retry(kvm, s2vi->mmu_seq))
 		goto out_unlock;
@@ -2363,6 +2364,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s2_trans nested_trans, *nested = NULL;
 	unsigned long esr = kvm_vcpu_get_esr(vcpu);
+	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
 	phys_addr_t fault_ipa; /* The address we faulted on */
 	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
 	struct kvm_memory_slot *memslot;
@@ -2392,7 +2394,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		}
 
 		/* Falls between the IPA range and the PARange? */
-		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
+		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(mmu->vtcr))) {
 			fault_ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
 
 			return kvm_inject_sea(vcpu, is_iabt, fault_ipa);
@@ -2429,8 +2431,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	 * nothing to walk and we treat it as a 1:1 before going through the
 	 * canonical translation.
 	 */
-	if (kvm_is_nested_s2_mmu(vcpu->kvm,vcpu->arch.hw_mmu) &&
-	    vcpu->arch.hw_mmu->nested_stage2_enabled) {
+	if (kvm_is_nested_s2_mmu(vcpu->kvm, mmu) &&
+	    mmu->nested_stage2_enabled) {
 		u32 esr;
 
 		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
@@ -2505,7 +2507,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	}
 
 	/* Userspace should not be able to register out-of-bounds IPAs */
-	VM_BUG_ON(ipa >= kvm_phys_size(vcpu->arch.hw_mmu));
+	VM_BUG_ON(ipa >= kvm_phys_size(mmu));
 
 	if (esr_fsc_is_access_flag_fault(esr)) {
 		handle_access_fault(vcpu, fault_ipa);
@@ -2520,6 +2522,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		.memslot	= memslot,
 		.hva		= hva,
 		.esr		= esr,
+		.mmu		= mmu,
 	};
 
 	if (kvm_vm_is_protected(vcpu->kvm)) {

-- 
2.55.0

