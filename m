Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E2A14EC59
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560993; cv=none; b=EMqwUk3QhOL9XT8pJhT+zqkxJ7Pkv+3ywO6WzFSz4Jy41DCtfU9CO1tuFwosc702CSzp0gUAlOQj3aLe//9Q5gX1Eiv8jQO9Clz0cdYsj3g0CRomdLuWt2sO6hQpCWR3FX4RojKueV/BqVaRyAnUiJKxElSbTEMiDmnr6UIDgts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560993; c=relaxed/simple;
	bh=TWw8GSHpbvCQEeG5Vl1VuWj9Nqtl/FyXDE95CmRt6LI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AZE0OH3LxtBOSoXqfkLclrPXgWluDm80UFtFky4q01kS0NTK8UZ1lmL+mMO83lM32Rs2ybOiz0TgXNmIPE1KVAJWa3bYWMuJFMPV8c/82uK3WqwvN37AWnqnXTzwBvsNYzvNvA1KNKIAfPGh//L08N9DVofu3k7CxcLD7eN9yXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eUPHbfS5; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eUPHbfS5"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dced704f17cso71403276.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560989; x=1712165789; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S2ox9frODKq27/FQSYGQW7YaTxoEZALwWxso0rx8Zp0=;
        b=eUPHbfS58PzfzPs7+XXo7x/mdXdW7vAMs8wTBMrWXTwhhRg2oOUCiHoqklxmd+evt0
         JfOKo8zxUnIPq8dZJNK++2bURRq0Br64YF9+d6Aws836KpYRDtvo9d1TppbU1G4vB0sw
         DwZIEVZLDMqBLfpZa2mRpCYVSEQPfSPPAvi8PicycEHoWJKiZA2CEfkDa6/SHZZPKPX4
         0kxB5IgpIx+WX07ir0B6WuRF2C/Cmk2ME8gtMbrtFR4U4GwVmoVQlEcVdlEfLwop9E2r
         ZDiTZuit540YqO2RYBc9WlJ/QRV4fSNNE+6mmGbkgKvKKHlxZ4GNAOJcIp8T8N7wizbW
         AD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560989; x=1712165789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S2ox9frODKq27/FQSYGQW7YaTxoEZALwWxso0rx8Zp0=;
        b=n8efHDguFXLawhhGy86kc5+NOoG3hWRGUhWQj74vVYgKhnGqGrHSFhrpqjVOxPnAs4
         3jF8C0VTvIJrMPCIWRRthJxQGXLHj8pFbsXjqlLMqTQzwlbgI03l71U/MWKKfmBTajps
         toNSmeP0MwQ+jaIN0oEWvPm/TSDPwSdwXtqnSJieNLpnzcRIN6t+GWGB2BCCNR4avgSv
         DWZmetw4m5reaRZt5btGj9eY17Gv61FnR/TUqumUtlT9pL6SQ6A1YEcgz0buarahyXl4
         rbT3RVT7PHDLZsOLIpQlqtvqVOvpkxkT9Vj6LTP6ehLcBZveNKO2zXZdOKcGSGi+tJuS
         hV5Q==
X-Gm-Message-State: AOJu0YwDO8XDqJgdbcI9KQ3SMoRAzylvsVdgMb9q4fX1nzbaFDjcOM7L
	cmXxAB8SY066E65p9Fxmqg51ElNOcKmjD/t9rP5C7ZY02xEgNC3uOzhiBDxgNxARf9I4gY/ogqw
	qpVbFiQ2KTTDPmrsZfhC5cQUY66PD2sFM+L4xloQFHhDjlSPFZSbwu1Nuwi13r+mvr6dt49uUBa
	C9bdAzJ7sAxb5hMEkWuFsWB/Eg5Nc=
X-Google-Smtp-Source: AGHT+IFw/wM0050s76hBQvrPUVvQW8rI0JT60RWVVIRlEGMx8b1iF5k0DYCPsycO8UnBylnRLnmaA5YrEQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2311:b0:dbe:d0a9:2be8 with SMTP id
 do17-20020a056902231100b00dbed0a92be8mr59891ybb.0.1711560989531; Wed, 27 Mar
 2024 10:36:29 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:11 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-25-tabba@google.com>
Subject: [PATCH v1 24/44] KVM: arm64: Do not use the hva in kvm_handle_guest_abort()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

The hva isn't needed by kvm_handle_guest_abort(), but is used as
a proxy for determining whether there's an error or a write
fault. Use the newly introduced gfn_to_hva_memslot_prot() to
determine errors or write faults.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3afc42d8833e..b35a20901794 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1375,7 +1375,7 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
+			  struct kvm_memory_slot *memslot,
 			  bool fault_is_perm)
 {
 	int ret = 0;
@@ -1387,12 +1387,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
 	short vma_shift;
-	gfn_t gfn;
+	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	unsigned long hva = gfn_to_hva_memslot_prot(memslot, gfn, NULL);
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1469,7 +1470,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
 		fault_ipa &= ~(vma_pagesize - 1);
 
-	gfn = fault_ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
@@ -1629,7 +1629,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	unsigned long esr;
 	phys_addr_t fault_ipa;
 	struct kvm_memory_slot *memslot;
-	unsigned long hva;
 	bool is_iabt, write_fault, writable;
 	gfn_t gfn;
 	int ret, idx;
@@ -1687,10 +1686,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	gfn = fault_ipa >> PAGE_SHIFT;
-	memslot = gfn_to_memslot(vcpu->kvm, gfn);
-	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
+	memslot = gfn_to_memslot_prot(vcpu->kvm, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
-	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
+	if (!memslot || (write_fault && !writable)) {
 		/*
 		 * The guest has put either its instructions or its page-tables
 		 * somewhere it shouldn't have. Userspace won't be able to do
@@ -1718,7 +1716,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * So let's assume that the guest is just being
 		 * cautious, and skip the instruction.
 		 */
-		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
+		if (!memslot && kvm_vcpu_dabt_is_cm(vcpu)) {
 			kvm_incr_pc(vcpu);
 			ret = 1;
 			goto out_unlock;
@@ -1744,8 +1742,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva,
-			     esr_fsc_is_permission_fault(esr));
+	ret = user_mem_abort(vcpu, fault_ipa, memslot, esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.44.0.478.gd926399ef9-goog

