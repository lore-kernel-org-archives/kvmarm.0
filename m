Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BF2277028
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 22:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875302; cv=none; b=niFMp5VMUlL0PhvUJc+l6+y9P3RmTAP6yXh8xNVxaNSnnP1/sxNEIAhcpOpG1aC4CLYXHxq4h4KvwTxfUibIC/KpBuZXEpjz8aSJYjUSmG5BU7XHrRhbiHWwZJKBBJAPu1sK1dt8ih9e1E5fqHcqe1rWRQxYXt1PjFYCRqo04xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875302; c=relaxed/simple;
	bh=ercJrCIZ2Uh4j1w9fwtjPtGjrYq3ynhNx8655WKwJ3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aeCq7X7A6o2FpF8G7Hi6cecJMgRAR9mlmxeE+9aiEO2XsUWGjUYn7LHKvS35Noa0W5KkcbSvzvJdwyjxYJTD/Zbs4YLYD48qPmnFI6wcRONxxuKx50nzY+NMcgRJGZqf8TOptoCUnXMmUL2uT5ciLwUsbi6aTPlKUC9vEh38h2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Fa9N7nW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Fa9N7nW"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2699ed6d43dso67558875ad.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 15:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875300; x=1760480100; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7fMZ7OhM8JOlJvnfA26tbvkth+uO96Z3bmtnJ/qhoYI=;
        b=1Fa9N7nWSnm2NiGGOKFiUqZe5WcZ+PxSgG4tbDdkx6Fa6217PxeX9OeoxVqzKhJYfp
         qZkixmZGz6RNWMw8ybJZpOEqdrTDyP5OeojHxnv85oINslVuE6qffcLMi1zDFk1t+nDT
         bK4h8wlFhzcTkH1duts4S5psdyLHKJSNnFu4A5ProrufE7IcOgh2j+YZ299jqLtgoflz
         yDB/8iOG3qkZ/Dm3PEh5hERocUHnN4TiBT+qxNym0PUXLbGENKs5YHHBi9C1/As2wP33
         ujeGbq5N4IEeg6bjhOJGKRApVdgEVRvDPG7nqI64HQwxa5B/nIwp0cBzzB/0uwoE6rVW
         9mcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875300; x=1760480100;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7fMZ7OhM8JOlJvnfA26tbvkth+uO96Z3bmtnJ/qhoYI=;
        b=ncfV308ZCfF3K84+7LmuPiNF/d6dFApcS3Ug8GS2Y+D3TTpmc6i7Al8BXyRO1cYv+I
         A5c1RnTIFNgVCjhTt7gd8h/pUKRZQxIO93Feov3835AaReQZjEU8T7AW8Zj8o3V9AAc9
         iXCOJC++YAF4KbLavTUge10+OfdR5Q37aIPV65mYCYpFLyZUwfn9g2LVk3PBANWwpDEc
         bp86j4iUCvmRsprnyJH3qFGhTu5nAkeLWBQzfnY2fKbLi/QI8kDhnGuJmt79Fwv8bT+X
         gZnvhJw9b8fYCwCI4TjozKbtAIiILEKNrwe9Vl8GFFO6u1R2qxBmcA6YCfv3PIkfpzbV
         qH5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXRFmYT7Jdn5XSDTk9lA1UWZFRxjgairEX4DpabmhKmG7x1+Ur2ydMjiZ2zVDFvp8VGtshu6Q4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzK9Qoz/lWHsrWHhewv6x8QsXqQe8BFDWaAtGIVGDpZ+kChHwnu
	oSkdXDLPtfmRWWHixYPhuvifjkC2R3EIyP6aaee0z2zMwkoortnWA65T15nosZReBjSAqSHVxod
	7QJZwcA==
X-Google-Smtp-Source: AGHT+IECKNXtIHUW5N14ZiXdwr22UXg6a0qRVDT9HGhdqQLa/WqCTYC09KfmHy6MwiN8aQHU+fr/YvGCioI=
X-Received: from plblb3.prod.google.com ([2002:a17:902:fa43:b0:269:a2bc:79bc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2c5:b0:27f:1c1a:ee57
 with SMTP id d9443c01a7336-290273736d4mr15592295ad.16.1759875300207; Tue, 07
 Oct 2025 15:15:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:20 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-13-seanjc@google.com>
Subject: [PATCH v12 12/12] KVM: guest_memfd: Add gmem_inode.flags field
 instead of using i_private
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Track a guest_memfd instance's flags in gmem_inode instead of burying them
in i_private.  Burning an extra 8 bytes per inode is well worth the added
clarity provided by explicit tracking.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 95267c92983b..10df35a9ffd4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -30,6 +30,8 @@ struct gmem_file {
 struct gmem_inode {
 	struct shared_policy policy;
 	struct inode vfs_inode;
+
+	u64 flags;
 };
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
@@ -162,7 +164,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 
 static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
 {
-	if ((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED)
+	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
 		return KVM_FILTER_SHARED;
 
 	return KVM_FILTER_PRIVATE;
@@ -398,9 +400,7 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 
 static bool kvm_gmem_supports_mmap(struct inode *inode)
 {
-	const u64 flags = (u64)inode->i_private;
-
-	return flags & GUEST_MEMFD_FLAG_MMAP;
+	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
 }
 
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
@@ -412,7 +412,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
-	if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED))
+	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
 		return VM_FAULT_SIGBUS;
 
 	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
@@ -601,7 +601,6 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fops;
 	}
 
-	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
 	inode->i_mapping->a_ops = &kvm_gmem_aops;
 	inode->i_mode |= S_IFREG;
@@ -611,6 +610,8 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
+	GMEM_I(inode)->flags = flags;
+
 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
@@ -931,6 +932,8 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	mpol_shared_policy_init(&gi->policy, NULL);
+
+	gi->flags = 0;
 	return &gi->vfs_inode;
 }
 
-- 
2.51.0.710.ga91ca5db03-goog

