Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0596E261B94
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 22:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875286; cv=none; b=IrCHBcF3se/+zOZFYHafpyN3vkLFfFrrb68HJM+OfC82LIcA5eK2I7goztDGqYAIkQmWSO3JmSPEx61pKSzHOjgmpgSECuyRJYWj+8s/fu4yE9YOgy5hA4ewF+dgZh7YhTRhRYQFQncswPpru9roKM41R/NADziYpf7lXwQIr3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875286; c=relaxed/simple;
	bh=hLovmYk8bySz7R8bk2raTs2ZMWeD3KM3QSIpRcC8qVs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EfWKh4n5QD9PGZ19aBnDKVUvHNfs+w9O4qfWEbC/3hOH45yvZ+O7i3MeRykklQe5ISpcHk+su9aDBhZZgWAuFd/El9sODLpmPg4+xJwOQWTcO8oVPzNlgADYuJ1uT7Hcc0NyRhd0QLMW2EHxeLvYd74w7uYLrKBtBCU4YF9mRjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x3ezfgGC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x3ezfgGC"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-272b7bdf41fso77087585ad.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 15:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875284; x=1760480084; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=taWA6Z3KD+nH98ISDpDB0Js/qA9hrmRliA7l8Dl3Bbs=;
        b=x3ezfgGC8H7YaT2J4xj4PG7mrXvxUYOGH44RMwLY9c08J2vRV964s8fo9ZJkTEKOnZ
         9WpMiG550CLh6Cbsi3YDg8fPuxDW5SIJ+/qTg1TnFBykQjQyey8lOjilqlOG6KpHuYQU
         Vz/ihDzPgVvotvF5+CMmfZCP83yjyYvWKWESbdVBXJrQ8I3HJgNUikn6Or94wv8idvwH
         GfBBwzjf9dlvUSiHgdifs2BEHpb1BcBfnUqNlw9bhlH97vhSMIChYx7TfeCN0Nm0CvQT
         AWbiBZuIb75mBsBinrku/rWlSuSFlGoAS/6LlHjO2Mn5oS7ka+dUVkoVYEl14nk8DxQ5
         /2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875284; x=1760480084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=taWA6Z3KD+nH98ISDpDB0Js/qA9hrmRliA7l8Dl3Bbs=;
        b=XfauJvdVArEtQpq9rFuBDdtdCCUh8/Qe4ihEolv9oJnff/C9+TJWrtwZ1Pc3FMGhMB
         Z/EOTO4DfJJLw/lyOiGUcA/yjoSsyFTiz5cw08YphgP7bFBOXGFPuGvc9yDEEJZ9ihSu
         6pjmXB6yRXMi/lMXtjzQiru3VL+r7xAutV+ydQNzbsNlvM59ddZc/P5KJw8jAZIL2Rmo
         vRiGFjCHHbSkhGwHBgH5rs3iOhI9g+vY9QpsNC3aTPs3BPBD/C7SwT/Qf1P30AHlD+Pv
         F3Ln6/Eu8OCo+HIH3gQdFHBrX1abAaKhrE4/FLTkhxTrd7u4gRrWYjJbhwE92jcswo4Z
         p6tw==
X-Forwarded-Encrypted: i=1; AJvYcCUpecwHd50F2up38NSX5xsfZLDIzRYlU1btczmvkjCBzJyo/KjXQfyNND5E+7kS1oFjC5xB50c=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrHF0/Zz47oyqSvIw7fPPH5N/8h+HcdBZoAp80hfcqk/FgyUoi
	0ZC2kncV2I+q3/xMFU//AVLmbtV9qSJuUKJFS8wSsmAwlgJKhj/uwMGd3EIzqAQQT4tXP/CIavp
	n35SWKg==
X-Google-Smtp-Source: AGHT+IG9oleyJb8iura9cqY09UwB/z7uMhOzD+raOSeu/vbFWL+mfa3tRg9JWsWtb4qRWng07qdUpuou8jY=
X-Received: from pjbsx11.prod.google.com ([2002:a17:90b:2ccb:b0:32e:d644:b829])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38cc:b0:32e:f1c:e778
 with SMTP id 98e67ed59e1d1-33b51105f5dmr1325599a91.3.1759875284309; Tue, 07
 Oct 2025 15:14:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:12 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-5-seanjc@google.com>
Subject: [PATCH v12 04/12] KVM: guest_memfd: Add slab-allocated inode cache
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

From: Shivank Garg <shivankg@amd.com>

Add a dedicated gmem_inode structure and a slab-allocateda inode cache for
guest memory backing, similar to how shmem handles inodes.

This adds the necessary allocation/destruction functions and prepares
for upcoming guest_memfd NUMA policy support changes.  Using a dedicated
structure will also allow for additional cleanups, e.g. to track flags in
gmem_inode instead of i_private.

Signed-off-by: Shivank Garg <shivankg@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
[sean: s/kvm_gmem_inode_info/gmem_inode, name init_once()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 77 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 76 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2a580b2bdc9d..cc3b25155726 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -26,6 +26,15 @@ struct gmem_file {
 	struct list_head entry;
 };
 
+struct gmem_inode {
+	struct inode vfs_inode;
+};
+
+static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
+{
+	return container_of(inode, struct gmem_inode, vfs_inode);
+}
+
 #define kvm_gmem_for_each_file(f, mapping) \
 	list_for_each_entry(f, &(mapping)->i_private_list, entry)
 
@@ -833,13 +842,61 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
 #endif
 
+static struct kmem_cache *kvm_gmem_inode_cachep;
+
+static void kvm_gmem_init_inode_once(void *__gi)
+{
+	struct gmem_inode *gi = __gi;
+
+	/*
+	 * Note!  Don't initialize the inode with anything specific to the
+	 * guest_memfd instance, or that might be specific to how the inode is
+	 * used (from the VFS-layer's perspective).  This hook is called only
+	 * during the initial slab allocation, i.e. only fields/state that are
+	 * idempotent across _all_ use of the inode _object_ can be initialized
+	 * at this time!
+	 */
+	inode_init_once(&gi->vfs_inode);
+}
+
+static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
+{
+	struct gmem_inode *gi;
+
+	gi = alloc_inode_sb(sb, kvm_gmem_inode_cachep, GFP_KERNEL);
+	if (!gi)
+		return NULL;
+
+	return &gi->vfs_inode;
+}
+
+static void kvm_gmem_destroy_inode(struct inode *inode)
+{
+}
+
+static void kvm_gmem_free_inode(struct inode *inode)
+{
+	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
+}
+
+static const struct super_operations kvm_gmem_super_operations = {
+	.statfs		= simple_statfs,
+	.alloc_inode	= kvm_gmem_alloc_inode,
+	.destroy_inode	= kvm_gmem_destroy_inode,
+	.free_inode	= kvm_gmem_free_inode,
+};
+
 static int kvm_gmem_init_fs_context(struct fs_context *fc)
 {
+	struct pseudo_fs_context *ctx;
+
 	if (!init_pseudo(fc, GUEST_MEMFD_MAGIC))
 		return -ENOMEM;
 
 	fc->s_iflags |= SB_I_NOEXEC;
 	fc->s_iflags |= SB_I_NODEV;
+	ctx = fc->fs_private;
+	ctx->ops = &kvm_gmem_super_operations;
 
 	return 0;
 }
@@ -863,13 +920,31 @@ static int kvm_gmem_init_mount(void)
 
 int kvm_gmem_init(struct module *module)
 {
+	struct kmem_cache_args args = {
+		.align = 0,
+		.ctor = kvm_gmem_init_inode_once,
+	};
+	int ret;
+
 	kvm_gmem_fops.owner = module;
+	kvm_gmem_inode_cachep = kmem_cache_create("kvm_gmem_inode_cache",
+						  sizeof(struct gmem_inode),
+						  &args, SLAB_ACCOUNT);
+	if (!kvm_gmem_inode_cachep)
+		return -ENOMEM;
 
-	return kvm_gmem_init_mount();
+	ret = kvm_gmem_init_mount();
+	if (ret) {
+		kmem_cache_destroy(kvm_gmem_inode_cachep);
+		return ret;
+	}
+	return 0;
 }
 
 void kvm_gmem_exit(void)
 {
 	kern_unmount(kvm_gmem_mnt);
 	kvm_gmem_mnt = NULL;
+	rcu_barrier();
+	kmem_cache_destroy(kvm_gmem_inode_cachep);
 }
-- 
2.51.0.710.ga91ca5db03-goog

