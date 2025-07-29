Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B202BEC37
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829750; cv=none; b=a2D7NvggfHY8XzaQ0VlhZMDvL5HV3jU9SWs3VMqgHMPyXDKvcCLMrVgLWk76eBBI0w/zdNWdgrzxfo5F4rHyW71Nbl2k++h4DKU5GRJ/jwCTNw78cuJpTtagiJUFJv7jJodHSUQvYpiYPaHpppTStcVScOnhB5uZLJDwZyOxB5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829750; c=relaxed/simple;
	bh=p3Az0/PEO9NNy7K/7GF+xs37R1p++sp7PEiKQeGgy/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VwVHXHBRv8gycwGLBIBep4c5ATZ4KGgSVxZxVZo9j7zJllURfD9hp0D3U97XPfaBNAUWJbwKBBtFojkeWbWFxeQN3cTVzizI5eqt9ae5uYOHZWqYcxu4nhZmW9a5Aki05qT8Wa9Gi3WcqWhzS7RqzeeR7zQuIoml+UmP/UEDMjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nbQ51stF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nbQ51stF"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31eec17b5acso2958618a91.2
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829749; x=1754434549; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4HY+eQdd/nLDovMCXUcK3sJZavohA3et9/rmOJ7S8mw=;
        b=nbQ51stF42XMmMzXN1QTeq7HuA76ffBXwkjLHXv+2NWWE/gQRQGGx+q4Qpay+noZUv
         IgYNzoMwWYzOpx76K6mpUmYmpHdFJ9ltk+iCBidb2t2R0mewVCn7yWIigg1FoNY4uPOL
         Sw+fmueSz0QpaUfLYFbi/ZVaYBiBh+MtGm9Ac0LbEmqJQmebKHtoHIkbrOzAObDOxIx8
         p+cyRDPwNnQzCsbn+kIUZ2tDv5pGHv2li42bHe+DAy2trw/r5tIODm4jpGTC3uzuM3QD
         DcX40o3PolzBMZ6Sq0c3UfF9yQ9LCJGPQgHnUHfIgYUPRRjeof7Ib7dacMje3f+ksU2/
         cQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829749; x=1754434549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4HY+eQdd/nLDovMCXUcK3sJZavohA3et9/rmOJ7S8mw=;
        b=RXSviJOT7IcxXn8v62II8k6k5RouXpAoelFWDuN+10gTZ8jOS3tzOfmRXH8En9pqX4
         HOacPV/5BTrSSywQe6fr/Aow7LCiWvEelcRQCoGwQ7cCpZ/Q8hrTx2XVuipWdK4dxtsK
         GIbgXsx/GXV7tEWH9SN4hSDNcuD++4IwQ4yLLIwQgOXQDMw2FoYkrAnZqyBdDL2jQFO9
         RA4g2GPKNXRbOsWDzNEYEixhAWNA3/kQHz5oXKQg3ZCStrrAYaushWixmunSYdSOvPeu
         wWdJKNw413Kh9KKh6ihdIWLC6uzah7HwKdQWexmkouOMJ2JWgPUDCXU+bdG0p/39dLTn
         HO0g==
X-Forwarded-Encrypted: i=1; AJvYcCUzag3+8DN+PAAZM5Z+uqfYum4Mk8gN/4yB8jxcjP4ZdewNh2KVUAaXfTuVF4ogJ0P3y1quzRw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd5SnYBwW+sJKF1ILKOLEq+6KYog5Km5HhldMOEmnUSpjc7EpX
	9cweHqA+cN0OAQId625lvMQkol2s+op+ek1JlMSkwOw901SMnId/EyBtH2mYfold17XVdFcRup+
	ykBlsEw==
X-Google-Smtp-Source: AGHT+IFhotmaClkAB7rg0QKOA9E4cmIDk69xmBeYfpjr1LTJA+UVvMJehEkVmJzu9WDpMq0oubFS0TPkvpU=
X-Received: from pjxx8.prod.google.com ([2002:a17:90b:58c8:b0:31c:4a51:8b75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:47:b0:31f:42cd:690d
 with SMTP id 98e67ed59e1d1-31f5dd9e0d8mr1649821a91.13.1753829748835; Tue, 29
 Jul 2025 15:55:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:42 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-12-seanjc@google.com>
Subject: [PATCH v17 11/24] KVM: guest_memfd: Track guest_memfd mmap support in memslot
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
memslot->flags (which makes it strictly for KVM's internal use). This
flag tracks when a guest_memfd-backed memory slot supports host
userspace mmap operations, which implies that all memory, not just
private memory for CoCo VMs, is consumed through guest_memfd: "gmem
only".

This optimization avoids repeatedly checking the underlying guest_memfd
file for mmap support, which would otherwise require taking and
releasing a reference on the file for each check. By caching this
information directly in the memslot, we reduce overhead and simplify the
logic involved in handling guest_memfd-backed pages for host mappings.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 11 ++++++++++-
 virt/kvm/guest_memfd.c   |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 26bad600f9fa..8b47891adca1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -54,7 +54,8 @@
  * used in kvm, other bits are visible for userspace which are defined in
  * include/uapi/linux/kvm.h.
  */
-#define KVM_MEMSLOT_INVALID	(1UL << 16)
+#define KVM_MEMSLOT_INVALID			(1UL << 16)
+#define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2490,6 +2491,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
+		return false;
+
+	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 67e7cd7210ef..d5b445548af4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -578,6 +578,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
+	if (kvm_gmem_supports_mmap(inode))
+		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
 	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
-- 
2.50.1.552.g942d659e1b-goog

