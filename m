Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B66463B9F
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 09:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789463793; cv=none; b=k8ZXjGfQFtKWkJsoUCj6s7vzdFhBbfjt4xC0cP7BFA8/JZCZvGQA3n7BFmUsCze2KcfAXO+qWXQNOCQ6Ra+og9TKhvtn1FCC5gQFbBubkDHOHIR0iAZS1lUC0CEHXiaDho2CuMUMyc0cTWToCHGMfL3Nn88YaniAANGRP2gRx0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789463793; c=relaxed/simple;
	bh=jBOER1cXcUAn6k80SQnWneIhPSKZ3YKRpoussvYtGi0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Leo22gUF1hYqWuPgmlXR0jCs7ITIiNRSHpSA0bHgL/g//3tnoyjq6K2WgoFbk0W+J91SR3rTXVAij9y6PZn5DqYW3381GIPqlIXxjJD05Ps4HyqxUhSPRPM3Z2Lnc6RT21VRpBYKHg2xI8VM6OxCuW7tK+FhmVDr/VrqS4LX7H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fj/TdXfn; arc=none smtp.client-ip=209.85.221.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fj/TdXfn"
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48704504d61so299026f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 02:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789463789; x=1790068589; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IAcoPa4jlwbshTSTSUzhgIUdN8VWUk7aj8T/MzEYoIs=;
        b=fj/TdXfnftf2zuZPK9+auH4Z30Ynf5eXbEHzQ/w8LR4HoCNUxPua7HLfpnL3udnJEp
         xdu19pkAK4XmuaFaBofrpgytTKRyq4VFFmLNkqC91XtIvYq0tfuSOh7hJkch5GVfDKtX
         BoslAGvms9s/KRozTyItFcxsTcqbf6ZESnlTGJlN2SdmyNcPVHAiMLHQGtKiCxzi/o5t
         7FTpw2qcRYlk4g+WWybWDuGZG9sTuIB8/N6Gz6j3mv1bG5N2O5N6qz9+UnZjWfSQj7B8
         xfDQAfsEGqWpWlhcLdYQ/R1Jq8UInNVNFffvH/1dksRnSjCC9gFEAnN/ZcuVi2q8qiLe
         G4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789463789; x=1790068589;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IAcoPa4jlwbshTSTSUzhgIUdN8VWUk7aj8T/MzEYoIs=;
        b=lOCfcU0yMVO+jSR3IHJ1RJ3Vy03aT79DO2CNVuRGW03rZiAFXgMIcI8GM7QE+rnQYm
         bwUqmOIg9MkD+EQbU1uHu1RZKi4nKchaDbPDPIEwsKHt2nZ+KHnkZvGDd8EqXQcNW0Bf
         mT3pqdhYS9IiQtQivJvbznBDbPPNBTYm0HpGsEqgXA1gEIxYRtpIWS5NpzTfbjxyHvxy
         T/BHonUEW9xINWWhB5/EO7lznH61uxj9quInCADgN2oGO1r230pXFXGJjR6559m5a/ek
         R/N98J3BNlEkT6qu65WR+v6hCEUSL4uGNKPVnlRozyMWnzwWxJpv7jpAPm5a011QNst3
         NQAw==
X-Forwarded-Encrypted: i=1; AKwUvByI/1imGZxI86Byxj0XlbHZ0ChN467RqmUnbT4eWO17xNZyKRnmYF/8H9jIHF9pkS2jm/TdoNA=@lists.linux.dev
X-Gm-Message-State: AFuF++kff2tQFCe/nHlbDCDatkOzkYM2q+r/yduBtJeapoMyHv1LADX1
	xeMTsSoLIsxcXo6suHMBcjxB9OmB8v6NSGBwWbDhSDJw6BGtmhN/CtlTEQrJlyWo+1zAuN8OptG
	Nh2ZHUEKkMgrqpQWlha7OKQ==
X-Received: from wrvm9.prod.google.com ([2002:a5d:6249:0:b0:484:3705:a028])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4605:b0:487:92e:c609 with SMTP id ffacd0b85a97d-487092ec81cmr1510335f8f.0.1789463789109;
 Tue, 15 Sep 2026 02:16:29 -0700 (PDT)
Date: Tue, 15 Sep 2026 10:16:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260915091606.2111217-1-vdonnefort@google.com>
Subject: [PATCH v3] KVM: arm64: Fix protected VM fault on system with pages
 larger than 4K
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Just like commit 08f97454b7fa ("KVM: arm64: Fix protected mode handling
of pages larger than 4kB") fixed the boot of non-protected VMs on system
larger than 4K pages, align the fault IPA down to the page-size for
protected VMs.

To paraphrase Marc, pkvm_pgtable_stage2_map() assumes the address passed
as a parameter is aligned to the size of the intended mapping, while
HPFAR_EL2 gives the IPA minus the bottom 12 bits, regardless of the
system page size configuration.

Add a check at the start of pkvm_pgtable_stage2_map() as we do not
support !PAGE_ALIGNED arguments and ensure callers pass a page-aligned
IPA.

Fixes: ea03466e806f ("KVM: arm64: Handle aborts from protected VMs")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/mmu.c  | 12 +++++++-----
 arch/arm64/kvm/pkvm.c |  3 +++
 2 files changed, 10 insertions(+), 5 deletions(-)

Changelog:

v3: 
  - Fix nested case in gmem_abort() (Sashiko)

v2: https://lore.kernel.org/all/20260914075839.4019904-1-vdonnefort@google.com/

  - Use gfn_to_gpa(gfn)
  - Drop "phys" from the PAGE_ALIGNED check, it isn't a requirement.
  - Fix gmem_abort() as well (Sashiko)

v1: https://lore.kernel.org/all/20260913173516.3122436-1-vdonnefort@google.com/

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4a..e199dd339583 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1610,6 +1610,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	bool write_fault, exec_fault;
 	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
+	phys_addr_t ipa = ALIGN_DOWN(s2fd->fault_ipa, PAGE_SIZE);
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
 	unsigned long mmu_seq;
@@ -1672,12 +1673,12 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		 * PTE, which will be preserved.
 		 */
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, ipa,
 								 prot, flags);
 	} else {
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
-							 __pfn_to_phys(pfn), prot,
-							 memcache, flags);
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, ipa, PAGE_SIZE,
+							 __pfn_to_phys(pfn),
+							 prot, memcache, flags);
 	}
 
 out_unlock:
@@ -1710,6 +1711,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
 	struct kvm_vcpu *vcpu = s2fd->vcpu;
 	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	gfn_t gfn = gpa_to_gfn(s2fd->fault_ipa);
 	struct mm_struct *mm = current->mm;
 	struct kvm *kvm = vcpu->kvm;
 	void *hyp_memcache;
@@ -1756,7 +1758,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
+	ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(gfn), PAGE_SIZE,
 				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
 				      hyp_memcache, 0);
 	write_unlock(&kvm->mmu_lock);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec12..b7340c430ed6 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -414,6 +414,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 end = addr + size;
 	int ret;
 
+	if (!PAGE_ALIGNED(addr | size))
+		return -EINVAL;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
 

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.55.0.1032.g73a4cd73de-goog

