Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com [209.85.222.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2891F5430
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339664; cv=none; b=B1TnVr5Zr9/Ry6uHUgD3sC5u8IYutAkSsIjKmLII07mmXE76GcvH/rtKlQBgtRjj+imK46tU+ErLYE9KtYkqqJr83tQ7/wnEayx/hlsDhI8x+QvnspooEJZgb1wqC9A8mhFOaJRXfc+O66GSdAbzMDb2CzdBZ8lEPdSdNWyVfKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339664; c=relaxed/simple;
	bh=7uKPJu5MZttnLGZHU4AcApt1HeYqG3NuIftXyYnBeQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mNMFJ99NDnboCh/yADfP1YcqoPPMPCiDRtv7+lkKl/upGP6dzcs7Xdw5u2GnC8stm3V12UmznVvWk5ySYOgcTzgKOqzqMtQ2jTOsG3MunmK2eKPK7qL9ZmTiWZCfiNfZkwTUCtZg68OulXTM6jJbiOLyBIt+8zDI0IupwF3zrE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TwUXtrT8; arc=none smtp.client-ip=209.85.222.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TwUXtrT8"
Received: by mail-qk1-f201.google.com with SMTP id af79cd13be357-7b35758d690so17757785a.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339661; x=1733944461; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3LkXqlJAd4fQvrkyb/GIMYTRcu+OGHQVMPLjSgCJbVo=;
        b=TwUXtrT8jh4Pzs1QUxoestIRitGgfCqgMN5BtkH56+yxEEiKepjq8Mh9RxBVXHYJa4
         Z7EAvd/xJcWavCgl0LmUxAcegoy/HdQngl2fAjFyQA/Z8QKZcDxoxGRkPBXpwCgFpNQ0
         Y1MKJZlYHvlEIRMViosnVTkESh5AunY7ZV/F32RYgCthgbJqXUj1aaHlyfP2T22GBKF1
         I0H3IpXEcXklYxXuwflAzfj1T13GcnwTs3Ek+QHO0pRZtzJziEV0MViqXGjOY4JAz4+d
         Wg4gUyNylm8FrXMXCfXTaIWjHOUvKA0FBrDzx6e3rc3JSL7giyh+UAoLKcYsJywzMPFw
         5L/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339661; x=1733944461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3LkXqlJAd4fQvrkyb/GIMYTRcu+OGHQVMPLjSgCJbVo=;
        b=YW38uop3qeBPZIK59ZavtDcSmyNjylirQHFKD443jIOiLjSYCr1XW6RgYi4UgsHJTU
         3YU8QLA0AX7u1rBoXEW5+5Re+BGwHyeeYJt0sg9uZZxsiamViK7XbJJsUJsT+XmZURU3
         2z2Ce4vTjOwoNTxVfK9jBuG3RCs5OVBNSvpJU2Sm+PdIAad6GLZ2K/PHo7/pLHxB4tcH
         RZO2+tvtfELSC9qCtr12QBgWAnWJoBvdPMAb988+T67tuDzcrQ5qc6kp2/insGj+7wv6
         Q7xSu0sLbfo4MdsrKjQgptGaUwP0Ohf7uBLYgtSmxBZ0aXl6LU8bfuXyluYMtyMxQr3r
         O03w==
X-Forwarded-Encrypted: i=1; AJvYcCVq7wVRFdmSZZ9vA8nhdYt0zDgwJijndpGcOcxFsIF2QDOC1/jMHFhPn5bcJiqK/6dWVGPZlyw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzeHQHliWKdDXqwioEpAFxzUWUFUw9LO2sQmZQOTjHmKf4erOKe
	Q7n5pg1K4jZcZF3JQgjO7pzaykibr46QRtlGXqz+EPQoe4myRkUrAXrossxhFWbVL2vOn3GX9Xe
	uNG8uE/p5N27nHRCEbQ==
X-Google-Smtp-Source: AGHT+IG2YC7xA0GwWXk+cMxHq3A6sTNXchADXjRqs7ScJbz/ng/FU66WmJEiNslyAxyIF4C+tDiCnDtGEeEHeuoK
X-Received: from uah9.prod.google.com ([2002:a05:6130:5209:b0:856:f0b0:717])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:40c2:b0:7b6:6b07:e80d with SMTP id af79cd13be357-7b6abbb7350mr835946485a.57.1733339661300;
 Wed, 04 Dec 2024 11:14:21 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:41 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-7-jthoughton@google.com>
Subject: [PATCH v1 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Adhering to the requirements of KVM Userfault:

1. When it is toggled (either on or off), zap the second stage with
   kvm_arch_flush_shadow_memslot(). This is to (1) respect
   userfault-ness and (2) to reconstruct block mappings.
2. While KVM_MEM_USERFAULT is enabled, restrict new second-stage mappings
   to be PAGE_SIZE, just like when dirty logging is enabled.

Signed-off-by: James Houghton <jthoughton@google.com>
---
  I'm not 100% sure if kvm_arch_flush_shadow_memslot() is correct in
  this case (like if the host does not have S2FWB).
---
 arch/arm64/kvm/Kconfig |  1 +
 arch/arm64/kvm/mmu.c   | 23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ead632ad01b4..d89b4088b580 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select HAVE_KVM_USERFAULT
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a71fe6f6bd90..53cee0bacb75 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1482,7 +1482,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active) {
+	if (logging_active || kvm_memslot_userfault(memslot)) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1571,6 +1571,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
+	if (kvm_gfn_userfault(kvm, memslot, gfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn << PAGE_SHIFT,
+					      PAGE_SIZE, write_fault,
+					      exec_fault, false, true);
+		return -EFAULT;
+	}
+
 	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
 				&writable, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
@@ -2062,6 +2069,20 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 changed_flags = (new ? new->flags : 0) ^ (old ? old->flags : 0);
+
+	/*
+	 * If KVM_MEM_USERFAULT changed, drop all the stage-2 mappings so that
+	 * we can (1) respect userfault-ness or (2) create block mappings.
+	 */
+	if ((changed_flags & KVM_MEM_USERFAULT) && change == KVM_MR_FLAGS_ONLY)
+		kvm_arch_flush_shadow_memslot(kvm, old);
+
+	/*
+	 * Nothing left to do if not toggling dirty logging.
+	 */
+	if (!(changed_flags & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
 
 	/*
 	 * At this point memslot has been committed and there is an
-- 
2.47.0.338.g60cca15819-goog

