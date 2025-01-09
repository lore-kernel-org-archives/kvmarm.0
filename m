Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com [209.85.160.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578A3202C31
	for <kvmarm@lists.linux.dev>; Thu,  9 Jan 2025 20:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455803; cv=none; b=LTb7qyQKk+hbXd+WzhXvF94139u5V1/csgl2Ex+PgVaN6knlvBpW3TCZyHvHYqUyx1ijH61clSpSrZvSNqO/NJQTMoP7u91joavm6klN9vxgNueYl8S3M8eLpFsmLzfUYTz+/RHx4zeyKD9bjJfZxey6vbYpLV2PpMAk1IbwPcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455803; c=relaxed/simple;
	bh=Bf6Z/SdUsbkpIsqoT2JIQQkVc3cDT9ghaIOkviu+ke8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fl2OZPB4+BwxL86TVQnjEt48xqC/nM+sEXpIuTF3gI3eXTnzGPNnrkvp8b3gq4EsykxfCfQG6N0+1CZ3ntoIuwYgPy3NiF2CYJwQTQm0dkGKQySe9OXWCWYZElt4XNn+y0Mm4+Y/mxgbrKMY8BNeydiMAHb1JB2iTZbL43WJDUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GN4iOfLV; arc=none smtp.client-ip=209.85.160.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GN4iOfLV"
Received: by mail-qt1-f202.google.com with SMTP id d75a77b69052e-467a3c0c8f6so25378991cf.0
        for <kvmarm@lists.linux.dev>; Thu, 09 Jan 2025 12:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455800; x=1737060600; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ej4vKCsRcXi3JRFU5yXFClNg+jWCgVgQEDR3f6Axo50=;
        b=GN4iOfLVRAhFu3cP+nqh0K+fNrzC391B6uOCzLSG3UZl3qo6wRbpsjoVQpV2MDC+Vb
         ZsbVIFr8bbNzQ1TWqms3l1KWa/S4Uw8wOreSZ7dcl6+LGzxlXXOgC/7rAmSA0yEWUTLw
         JGxqsMVlOyJTas/Qx9KSe7tBGIkE6b0t6rwBLQ8GhyG+NktJZNN3xxdn/vx1n8MXbMxF
         SaXowM4IiF9SRJlQUalAENU0DjluskiHP08Yg8Os6hlDM5J1B+Q2mHU2GdFFDke5Jgmq
         F0GlYUd+/5OIPW0ATBRgDz48kNwLodH/UPJ2GitW0Y+h9gfb/bEkMXWO0YZnZppKm2FX
         XeVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455800; x=1737060600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ej4vKCsRcXi3JRFU5yXFClNg+jWCgVgQEDR3f6Axo50=;
        b=o8NNnN3m4lAAYiCi9oEVbMP9XyK2PQNajIdBERZBxRsYGBYiaDGvkvHJK/+2SCvMza
         pJHtFJsQUK4y1UTm1XajFYydoB36mrLiqN+yCiuvv0Em20EZbUsBis/lj+M6t4fj84qw
         WjACFoXBYMyIsroM67jnPieGpLOQOnL5QVoEM+YnARn9DMBPeCihwswE3txzJkYHmjv9
         xM8c5Kcdbnf2116fm+Vk5uUsjQ6rpJBUOMRYWPjTqkmGBua7/F020lzN7BEm707pQuqK
         K6hSMtpX48twLJQV5eUPgnKxcFXaLT3a2rGsVFxjMlgmvuUGA39xjd7Zcb6cz2tasZ44
         ja3w==
X-Forwarded-Encrypted: i=1; AJvYcCV3FVTq7dVSDL2W95w/h7rA5Xj0HVbVVRlZFY7Lkkjp6tkaY0gxKKyJo59OxSCawE3z+qhbGJ4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFYBNJNwxFDKtEqgAVLjUJqEMouLsw2r2zCHIVgy5Nk/s1JlUz
	2soisWwsnalMBcFwBxgSJ2EerYFXiZSm5XX8KuCmyzueeXzCz813GtNJtE83v2crn+p5mBI8sfG
	1XKu9hVYdr6VY70Wskg==
X-Google-Smtp-Source: AGHT+IEjWh1ifMEjbhq2t/4s1LokEzVaJxOMILKR5p4NmJRJSQEQbDzHfJF1YycGc5qCqnm1VGVZZj4bYy7TorUf
X-Received: from qtbiw5.prod.google.com ([2002:a05:622a:6f85:b0:466:928b:3b7c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:622a:14e:b0:467:5926:fcf2 with SMTP id d75a77b69052e-46c7107e0b4mr103936581cf.9.1736455800057;
 Thu, 09 Jan 2025 12:50:00 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:22 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-7-jthoughton@google.com>
Subject: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Adhering to the requirements of KVM Userfault:
1. When it is toggled on, zap the second stage with
   kvm_arch_flush_shadow_memslot(). This is to respect userfault-ness.
2. When KVM_MEM_USERFAULT is enabled, restrict new second-stage mappings
   to be PAGE_SIZE, just like when dirty logging is enabled.

Do not zap the second stage when KVM_MEM_USERFAULT is disabled to remain
consistent with the behavior when dirty logging is disabled.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kvm/Kconfig |  1 +
 arch/arm64/kvm/mmu.c   | 26 +++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

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
index c9d46ad57e52..e099bdcfac42 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1493,7 +1493,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active) {
+	if (logging_active || kvm_memslot_userfault(memslot)) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1582,6 +1582,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -2073,6 +2080,23 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 new_flags = new ? new->flags : 0;
+	u32 changed_flags = (new_flags) ^ (old ? old->flags : 0);
+
+	/*
+	 * If KVM_MEM_USERFAULT has been enabled, drop all the stage-2 mappings
+	 * so that we can respect userfault-ness.
+	 */
+	if ((changed_flags & KVM_MEM_USERFAULT) &&
+	    (new_flags & KVM_MEM_USERFAULT) &&
+	    change == KVM_MR_FLAGS_ONLY)
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
2.47.1.613.gc27f4b7a9f-goog

