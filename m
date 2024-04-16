Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502AC3FE2A
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261463; cv=none; b=XbUa70n3sHRezbFfr1bMGBCmllf/lbwsg5RWc8xpBgoDDauvjIOVjvF6tECjoB12oX3cEZ2JgaAkZ2BKt4JN1Hw2aPpfbt/CLyyawl+rxyX4lWp2EEem2fl0wOdDAae8bF3+uailusoh1t1iQNjtM4PhnXPcaVVt9hzN3sTAeEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261463; c=relaxed/simple;
	bh=EbzfujmwjB09ZVfqR8RzfYWoTVbEWjUyUeYcdB99E6o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qe60Hz+RFqxlpLNfde0SbAwoc7SsEsJv8/Nw2+iFydhCdpUDZn65f+tPIcnII8N4qhMkh2jXILjFPGx0E5cD7GM8rrYCKDv9HkcrgUgFFYvbBLfmVufIL5TV45iPJK8fmQWRnQ3LtvCiWL+NVDJt0dlw5ic1B/4HDTzM5sozwkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yky3j6uG; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yky3j6uG"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-343bb240f70so2708038f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261461; x=1713866261; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/TKS0x8yplqfJbm1g3yuumBADTII0l2viaV9WxCWVi4=;
        b=Yky3j6uGMuRzAvoEj71LC/h1wR+Zh0TIdKnGa1KJkEDHkCPd8ktmBQTfJ+pnAlNjl7
         zduk4hDKsLYX85KtUZ8RQNiOlF8wEWXotb0iTbq8JLC1i8flvZwnAC26KhNmXyi5TN2u
         puzRnLkD7H6j40MZ33GLZRk/1W4rEVm3+cE3seIn1bBfIzrQ7nnQcsvG9tYwYDGv8UcD
         OaVUTsb3EkAP7j5qIA1FYW/6JEHWmtXWKkk2K7FtKl3EhJEkxeOgy5n/Jn8t6MD26uX4
         g3QgyOlw6zqya4ju9hCmxI09YuFhXDpVP5SkT0FxU9ZMNy4XfA1+yGFIaOptZcnvesQL
         vbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261461; x=1713866261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/TKS0x8yplqfJbm1g3yuumBADTII0l2viaV9WxCWVi4=;
        b=j+rIN5nc174UyfQcikJVjPfJ6vlo93XrVbl8boGInx8ioq2ACdbQcqBYAoLw0HT2VE
         zN7vqkVhXXEeD+PHgJIAc3RPqs76c9uePYfXRTVTghWfTMuLpRVPYZ01IW0v9UpehPB9
         eEfe52jvZjj+ZAKhmKxvbjsPzY7IWq58n7OyJFqk/W9z457gfir9TmH5r5IMtwyBKZMt
         kvlKrb9UAumq/Ay8P9litKBc8lU34JvQk27mt2CYFmL5J5cC8s322Tzn5ALbgsalMI92
         6dIkQgSzFmonoFF9rqVYzK/raOZFteli6y0AfLpZkuc8Wh2KkHa5JdjrOue5g+eaW1da
         VUrw==
X-Gm-Message-State: AOJu0YxzPf0vDrckQjQFS9szPGhCt9XhSlMw6Yrba+kSBXviNbv3Cm4I
	9JaV3/il2zSGraxLaxpvN09Bot7vkpw+gLMBwjOlhQoXbMlJ0E3apmLx1Jv7BxgNCDAlgItSseg
	hL94IbyGY+xi8YZNEjVfVuU7veIuCfIUaWqxrYdKIRiUggY/CT0KhBGfmhbQAIiEhVTHzHOY+Vc
	M0AU9Ya3C4gOHUyyw1cuFK671fveI=
X-Google-Smtp-Source: AGHT+IFnawqrhf9OZAuRmsrbwBu27rWhiWkmDoHXP0ziFutHKofCKMhZp8JX48242qO0zi0/SJisb5d3JA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:fa8c:0:b0:345:a5a9:6668 with SMTP id
 h12-20020adffa8c000000b00345a5a96668mr4939wrr.5.1713261460346; Tue, 16 Apr
 2024 02:57:40 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:17 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-27-tabba@google.com>
Subject: [PATCH v2 26/47] KVM: arm64: Do not use the hva in kvm_handle_guest_abort()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
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
index 03cf0a473458..0dfa85ade103 100644
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
2.44.0.683.g7961c838ac-goog

