Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com [209.85.222.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C04A1C3BF3
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339659; cv=none; b=LH67Tb4U3TfEjqmsg6iggdKEAGlsclfFWeQGNA7GW3k8E5RRscxOSJdnrOJxDXNwXN+W0bDxOy7jRR18kEfNFSK6ikp8JOj6mUFuDy6Eke/bEnmZnRsKMu1fLUg72j86eApMMo7uD9EVmG2XZBT3PwWDOwXutqGVs1mUsNierIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339659; c=relaxed/simple;
	bh=c0rr8TXquNcORgcEqiRhpBJYz8YSK62+12i246a2psY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lYt9iPKlSdw8rm3LQLF3QjB+h6O96rlyS8Dmukm2nWP/EpPttu1pbDTtEQrXOzo/rAJfPTuLbO4mhoQGe21nF4vesSFrZeLLbkyQWVAS2qrGcHwajLjIRqkauuppToM386TvsENq75ghHpjne3c9wfwDJI6v/N204kTy03fwEBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P2eT9zE+; arc=none smtp.client-ip=209.85.222.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P2eT9zE+"
Received: by mail-qk1-f201.google.com with SMTP id af79cd13be357-7b676e150fcso16661485a.3
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339656; x=1733944456; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zrj0l+L1/XMejjcdAt6Cg23oGRx5OMh6hw9EKc02Jsg=;
        b=P2eT9zE+LYPbR6BMOrIKEw9ScKMdR0HTeY/sZcgCpSJ9tfAAkndd8Zkq761BVjFyzB
         SyaEZN2DnybC9yB5Vr8bhljtLYuh16LHeE8BYVNV3bruyCl3m9HW5IavPJO1xnTwxAUq
         5GQA4dDqAKrJyDGRoLO/vzbdGlwaSffTeunNPtQExSftuexQxsX7GwhXPpZGvWr+ZS91
         /GIoTzHNtZpQVp0fGmplW/nsvK8cD/V5w2JMAwhreNAN3DR75KKm08wm/LoggIUwXpZv
         WILH7UAUObNf9qjddQwlmc5aVxli+5asgTS73Pm5Arg5M5R8iAqpNKEmR0NBs3utdNwx
         NGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339656; x=1733944456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zrj0l+L1/XMejjcdAt6Cg23oGRx5OMh6hw9EKc02Jsg=;
        b=ufOEL1BW9YRbQdy9YoFKv84SlhczTEppO6AsY/98zM+3pKsq5kzY4/PsKpyUfdR6As
         wbFEY4DwOlkgLp71E0gr/qlxppvM19QcnyFgSgWxg7kCHefJI6Y+iOQgU0lFnXl+Kq5L
         xFU25cTy8S2cUJqz8BYGeqXdrnf4o9HxpccLLEecEi6DG3iP2YPhj48dsjAkm5J4Ziss
         4Mi9jtrd+7l3PO1u8yD80SfnWAMK1gg7kT+IKPA7ypP1niMF/7VxfEkw2eDybHSWZs8n
         Dlo8qeh+rfRB5K9h7qVnVxtwP/Zl9O3Awkq5rV56ADH1F63MWLDtQpjQz7Ah/wVD88t3
         LRRA==
X-Forwarded-Encrypted: i=1; AJvYcCXg0/ZMDpwC2ZYFH+JCAkp7BJtkkPyHOwc65qyB8/r5aL1XK4y5EIIlikRA43GOY6j6yIA+IhM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVsJHeXrm6D0PVYIjBTZHnqZyxlpECk6844pgZVG+OFduTK37Z
	Ssa8ugkiVcZzocCbocZhe0gGmuhaI+8W7Of/RuGTklSGZEuWMM5BjoNOstKNQ9v2E2qKpTKu0SB
	DVq2oDORu8lK7MQWHQw==
X-Google-Smtp-Source: AGHT+IEsH4AhFxEPswA6HSpr3bvQoscIWPYhswjH6B0ZmAUwG6NVAuJoyTvkHIFeYc2jG+fxyhqARW7A5Wn5aFvO
X-Received: from uabib8.prod.google.com ([2002:a05:6130:1c88:b0:85b:d490:f925])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:2685:b0:7a9:acd5:1b21 with SMTP id af79cd13be357-7b6a61cb6e2mr738681685a.50.1733339656100;
 Wed, 04 Dec 2024 11:14:16 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:36 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-2-jthoughton@google.com>
Subject: [PATCH v1 01/13] KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
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

Use one of the 14 reserved u64s in struct kvm_userspace_memory_region2
for the user to provide `userfault_bitmap`.

The memslot flag indicates if KVM should be reading from the
`userfault_bitmap` field from the memslot. The user is permitted to
provide a bogus pointer. If the pointer cannot be read from, we will
return -EFAULT (with no other information) back to the user.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h | 14 ++++++++++++++
 include/uapi/linux/kvm.h |  4 +++-
 virt/kvm/Kconfig         |  3 +++
 virt/kvm/kvm_main.c      | 28 ++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 401439bb21e3..f7a3dfd5e224 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -590,6 +590,7 @@ struct kvm_memory_slot {
 	unsigned long *dirty_bitmap;
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
+	unsigned long __user *userfault_bitmap;
 	u32 flags;
 	short id;
 	u16 as_id;
@@ -724,6 +725,11 @@ static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 }
 #endif
 
+static inline bool kvm_has_userfault(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_HAVE_KVM_USERFAULT);
+}
+
 struct kvm_memslots {
 	u64 generation;
 	atomic_long_t last_used_slot;
@@ -2553,4 +2559,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
+int kvm_gfn_userfault(struct kvm *kvm, struct kvm_memory_slot *memslot,
+		      gfn_t gfn);
+
+static inline bool kvm_memslot_userfault(struct kvm_memory_slot *memslot)
+{
+	return memslot->flags & KVM_MEM_USERFAULT;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 502ea63b5d2e..94be7e8b46a4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -40,7 +40,8 @@ struct kvm_userspace_memory_region2 {
 	__u64 guest_memfd_offset;
 	__u32 guest_memfd;
 	__u32 pad1;
-	__u64 pad2[14];
+	__u64 userfault_bitmap;
+	__u64 pad2[13];
 };
 
 /*
@@ -51,6 +52,7 @@ struct kvm_userspace_memory_region2 {
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
 #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
+#define KVM_MEM_USERFAULT	(1UL << 3)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 54e959e7d68f..9eb1fae238b1 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -124,3 +124,6 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_PRIVATE_MEM
+
+config HAVE_KVM_USERFAULT
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..23fa3e911c4e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1541,6 +1541,9 @@ static int check_memory_region_flags(struct kvm *kvm,
 	    !(mem->flags & KVM_MEM_GUEST_MEMFD))
 		valid_flags |= KVM_MEM_READONLY;
 
+	if (kvm_has_userfault(kvm))
+		valid_flags |= KVM_MEM_USERFAULT;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -2042,6 +2045,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if (r)
 			goto out;
 	}
+	if (mem->flags & KVM_MEM_USERFAULT)
+		new->userfault_bitmap = (unsigned long *)mem->userfault_bitmap;
 
 	r = kvm_set_memslot(kvm, old, new, change);
 	if (r)
@@ -6426,3 +6431,26 @@ void kvm_exit(void)
 	kvm_irqfd_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
+
+int kvm_gfn_userfault(struct kvm *kvm, struct kvm_memory_slot *memslot,
+		       gfn_t gfn)
+{
+	unsigned long bitmap_chunk = 0;
+	off_t offset;
+
+	if (!kvm_memslot_userfault(memslot))
+		return 0;
+
+	if (WARN_ON_ONCE(!memslot->userfault_bitmap))
+		return 0;
+
+	offset = gfn - memslot->base_gfn;
+
+	if (copy_from_user(&bitmap_chunk,
+			   memslot->userfault_bitmap + offset / BITS_PER_LONG,
+			   sizeof(bitmap_chunk)))
+		return -EFAULT;
+
+	/* Set in the bitmap means that the gfn is userfault */
+	return !!(bitmap_chunk & (1ul << (offset % BITS_PER_LONG)));
+}
-- 
2.47.0.338.g60cca15819-goog

