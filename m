Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7394D29B793
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829743; cv=none; b=QAZ+uPV2RmPJW6v5XWGkX9hInAO05TvLRuTjj/ObkBSWoOb/d/HTpoNpWX9ozKXQZLm274VGGvIXoOgh2mQ14HrE7Wg5TbloDOywm0p9O475IlkK250obQPZBu1IavKIEOSEA/9N1Q8Hgnb/f9/+PNCu9a/ExJpO+0whT608XCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829743; c=relaxed/simple;
	bh=5XaLz6TgyathNJqnhdFXTkNHqph5QPuoYA9YQ+u2AWk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TOT50RDgHhiPZwR+INOA3fG4KYa20W46hmX07u7R0urW4HjcvbGqDQbAFEdp+D/HvkJ3KcAM4G4u/cyGw2eWCDoJwP21PgXFyRk0OztHdklL0k9QZ9eVhNr8+7TcgJ5jtqJkZERG+xN1oPjsaI6cj0jOoz/B9fMZzK3Q8OjvMHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SPfFBjjQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SPfFBjjQ"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f322718faso1067897a91.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829742; x=1754434542; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jzYeQ19SvsGHPOnRphF4Uobk/zE+UGMKVRi+nf13iRw=;
        b=SPfFBjjQ9a4TQI2yH2noS1nwjFlVWUP2LLLWnpOpjCHxsCZUVHW3C/2JyxbrZNWHiN
         m/ESJyWpUBdj6oJjt4WG3EQdLKlsHpVMxGsrAbYsA9HNf7mul3dFJ+EYkvIMz1PhZU+f
         f3jk7mATWukN4dB47XZMgiRT9lYfswif1ltxkFM0rC4R+JXMix59WIL5NDeMZ9kCGORh
         mldyMdkUImMtOLMg1wCsCdWY3c6ZJsoL9OfxqIasyT1ptY4KAO42RYW4RoQqITSMbmMT
         Xv3UyjkDYzqDe4hqZdqD0uPfqu1gwwPFjX5YA0obZkGRHq4lC/Bqd+/bxyeotHIIe6x5
         5oZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829742; x=1754434542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jzYeQ19SvsGHPOnRphF4Uobk/zE+UGMKVRi+nf13iRw=;
        b=kQdvYWD5NMCHkU8R1YpkuAOG8NAx8KS4roXD3eZ20cG9b72lcucMU1g+Fo7Tofawln
         NQAnNNjLDE8iuiUeP5OAxh7zwO0y/gO3awN0OdAKiaJTAaePKGXi58HwgxNg1swqiQhv
         6zQKqhsdpXg+CTb5WVMOLpUHasOgxsC1CU+HjYQoIxCjCWC1Go+jLkMIJIoLsauPPN5m
         z6Xc21sWztsA7geGUm7nSeehtnL0NW4FFQMDVmiD+3HNtfu64RvYsSlxwqzi0e6u9fn3
         kk60HuPcBOmRyQsCJdZsi/x9Oy8rkgNhALih0H3+aVDG3iXVUuUMdf0fcWlgQzu/mbUE
         KKzg==
X-Forwarded-Encrypted: i=1; AJvYcCUbCVC/faKDFBVBTz6358i9BwYnVUrL2PKQEQZT3QplOQ9gxFri2lwHQj6eZlR96Oiu8lpP/Gk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy52R0rlcrccAYfZ1U9KvUdfU9JFRHVGjwAhHbfZ3Ssx5VmOsN
	Fp3SQGp1SJDpI0AoUuc/sh51CjRgYgpqarSgOeQFpX6+z0D+H4TGO++XxnLTg9jYeb/AAh/4/EB
	cNUbi4w==
X-Google-Smtp-Source: AGHT+IFn2WAK9ukizMY0dgeyzampJaEckC2xblRT2k3Bk2uKavbOCAt+9mg9yLDOobFQoDGRUwGnRmEVCVE=
X-Received: from pjoa9.prod.google.com ([2002:a17:90a:8c09:b0:31e:fac4:4723])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc1:b0:31c:36f5:d95
 with SMTP id 98e67ed59e1d1-31f5de2f372mr1596778a91.2.1753829741953; Tue, 29
 Jul 2025 15:55:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:38 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-8-seanjc@google.com>
Subject: [PATCH v17 07/24] KVM: Fix comments that refer to slots_lock
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

Fix comments so that they refer to slots_lock instead of slots_locks
(remove trailing s).

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4c5e0a898652..5c25b03d3d50 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -860,7 +860,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25a94eed75fd..aa86dfd757db 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -331,7 +331,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * All current use cases for flushing the TLBs for a specific memslot
 	 * are related to dirty logging, and many do the TLB flush out of
 	 * mmu_lock. The interaction between the various operations on memslot
-	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * must be serialized by slots_lock to ensure the TLB flush from one
 	 * operation is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-- 
2.50.1.552.g942d659e1b-goog

