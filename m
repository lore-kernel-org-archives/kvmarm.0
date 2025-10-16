Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEFC342CBE
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635831; cv=none; b=YaU4VnQ1Z3HJkvxgAzP2gDkRodkPxmy+QQimQts5d7urcbU3q2fzi5JMLP4s+dNxq56SYhZSWUSLY5xl/IqGX+2oX/2/4EnDZLx4CVeLxNrPX9ux6Biq25rnJ9iYC6vPaHXH7yyDX79mpR5vEMu/0KS8XMrHne2/7sPWiIFWLXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635831; c=relaxed/simple;
	bh=u73IkWxovHfIqFa1WeugdviVlKOG53gOaetPwlyyztU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NRTiprH/FG2xjxlfhcmvQ3gqnFUM+8W0xhu2zfxzy8Z9zN3tFo64E6AceYuL0Bt2auzWGkTkcjXDUzRokrrHg/8K6hPBm5+sOUEkwoxUr6Htee80ZgpsYpXntq6BG6v4JDQko48ONgpgsRuLox8MHRhNQFyWKgWWBrznBs/uphU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DNC2+xGu; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DNC2+xGu"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b630753cc38so1532109a12.1
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 10:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635829; x=1761240629; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hVBqs1fBWLjUqhKekNBXs2j0fRJmcNGrbmsvLjXeKrQ=;
        b=DNC2+xGu4f9RT0c9ZiJaD88qym1fpQJ8R79oKfqDZcQq9cTPgp6M7RNKTqm9isJNmD
         xyNJ2Ljhe2TOaJmY8+AKHasFn+iblGCHDy/ohFse9UZdo2HLTNdRGokG3TV/bxf5R/71
         NWbvRDxsK+oOkSTzIDVplB51++PjlXEYp+SH3g7VvhSfCpJASwuZTslhmsZDMHVy0NAz
         NGDgdOE1/Sy8u0+D6QwiwHcW3ukZKJqqlsbmfYg2EM9F0UuabbUnPwM0WB2g4efhZtPp
         x347mtcUAbWdTxyz8JZ/36HDJ14iDMZZYHnZ4ENZY0I/oCWG7hOQn16c3+9n1QEJisGq
         b3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635829; x=1761240629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hVBqs1fBWLjUqhKekNBXs2j0fRJmcNGrbmsvLjXeKrQ=;
        b=rUWR8a1Cy3OJxDEu3NGSKh9B8YAu7QrvleL99dz1/+5GHZ7owJyVSJ1gF/bA/Ayyk/
         DUo3u2gGFvnAlE0WQtEpjzJsVfpqWmF6FUnZVERLuOzjwhMUZD8cI+VMX7jUbf/QHUWP
         YrAX+xS1gUZyi7TiDxQwUQO2yQHHpVekSsY4QLWKO4MDi8nyKizgZRNwwT2olKXS4Bs8
         1vdXOpod9RJGqcSfAQa/uZsTu2ehxC52GltzhqJfrd2HOz+R1ufijPgtRwfCm0IgqIaA
         yi17lglUlplx9BMIAsHRLE2Mn31u+pa6nvTtL2ClD3BL2agbKVW+igqtTH2+OeIhCaYB
         BvnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzA4LY9avD3keqnbjNTgUDVuXwVm8HI4ot89vumFHBtwQdN2rvpY0+132ZdLBaCMdm+Vj2Kzc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy81aLnRCmM0ZuktnpGebM/HHg7/f4QbhGee7dnI891jqz5S8CT
	TsHI4X+94wnebHH5/eKpKx8RCrBv/OzbUqa0K2Awurtu0szWqRV/0F2LPOOUXuMvQ2xr5uQKUPm
	r2AfQUw==
X-Google-Smtp-Source: AGHT+IGe2t05unDim4uDryBf0T+QferPUXjPaV2LK4Nd4NgexnAWeTiux+wqiz6ZgBu9e+7IBbrnySiYCWM=
X-Received: from pja6.prod.google.com ([2002:a17:90b:5486:b0:33b:51fe:1a79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2590:b0:2e0:9b1a:640a
 with SMTP id adf61e73a8af0-334a8485506mr977560637.3.1760635829602; Thu, 16
 Oct 2025 10:30:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:53 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-13-seanjc@google.com>
Subject: [PATCH v13 12/12] KVM: guest_memfd: Add gmem_inode.flags field
 instead of using i_private
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Track a guest_memfd instance's flags in gmem_inode instead of burying them
in i_private.  Burning an extra 8 bytes per inode is well worth the added
clarity provided by explicit tracking.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4463643bd0a2..20f6e7fab58d 100644
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
@@ -154,7 +156,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 
 static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
 {
-	if ((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED)
+	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
 		return KVM_FILTER_SHARED;
 
 	return KVM_FILTER_PRIVATE;
@@ -385,9 +387,7 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 
 static bool kvm_gmem_supports_mmap(struct inode *inode)
 {
-	const u64 flags = (u64)inode->i_private;
-
-	return flags & GUEST_MEMFD_FLAG_MMAP;
+	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
 }
 
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
@@ -399,7 +399,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
-	if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED))
+	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
 		return VM_FAULT_SIGBUS;
 
 	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
@@ -588,7 +588,6 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fops;
 	}
 
-	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
 	inode->i_mapping->a_ops = &kvm_gmem_aops;
 	inode->i_mode |= S_IFREG;
@@ -598,6 +597,8 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
+	GMEM_I(inode)->flags = flags;
+
 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
@@ -917,6 +918,8 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	mpol_shared_policy_init(&gi->policy, NULL);
+
+	gi->flags = 0;
 	return &gi->vfs_inode;
 }
 
-- 
2.51.0.858.gf9c4a03a3a-goog

