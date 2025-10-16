Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAE2328B66
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635818; cv=none; b=D4SG2piBl4tmXOsHQdkjsBFnU4wzby3Wm8Ednoudv3FiaQDXBICYHmTeefJKqDzOK31xzh/HsUwWYlQMSABc/4NO9ogVhRL0ggWFl3Z2W8rhCLuWKpelBl3zTLM+4Q9+uVC2vXhvRbg2pTNJSR+GdoVEuariQzxgfe9LvNyY5f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635818; c=relaxed/simple;
	bh=+KxRHhvCBviGDFsIU3Lsgn+jy+PLVOG7yrAqda/g69w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uuxOxMNlUyopBx4NNo6azTrDeDtUvAnARwb628KizNh0nNACyAZ5d2Juil9xT3X1bLappGINDxq9+RUQNfoB0mvs1UrIBekuSZfCOrlOo66yQ9h7nHZDQnZEZDneOPhoFp2xQeOBvBq3aK2hkfI5Ii8cRrVd6QSMZW+FlkElIns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oqTlg4ed; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oqTlg4ed"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339b704e2e3so1062888a91.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 10:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635816; x=1761240616; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hTGJgj5iiOhAO7S5Tta2IQsGxNpf9yY+7OEbh2Vbabs=;
        b=oqTlg4ed/zs+rF5x5EC42aT3U3DFKzUP9Si+0ZbhaphdPwY/NV+N9rx+XQ9orC4A0+
         mUqGB+KX83J3EflahBRfJrXGlkuHfXvHHsMuMAL0drxyuTZ5itmcL770eGgXTJCFvHOD
         dUQ0mxBg1eiFlKWmJ+Dq+UZwzfEvbPHLFT5FE1QWIpn3dAS1q2KV29foxZ8WgZFWjkCI
         45QhEINLWeyKRGSGJ1GcYpxODYZNNkJN1nsySTNi6uT+EswfDqOZmqLRBQE3amTfLGqd
         JPpTUgwQt9dlCiwqmOgiF5kcE+lBqrRgSi1vUMxoyLef9uWi2h3p11CNHmqiEhFrXYLL
         +SUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635816; x=1761240616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hTGJgj5iiOhAO7S5Tta2IQsGxNpf9yY+7OEbh2Vbabs=;
        b=mylIv/wojcws7cev/X6O2pDZGpVG8IibjqQStq5RysPadJQas/SmScnpzLRTlFDnL8
         YklenVtQG2Hn4a6SscrVndr7mBYpp5R1yg/W0Wx2rNQ+xsk17UdmyG+ohRGE+kLycu/I
         i9H+Ke4J+goO/IBEfz84i7YgMQRPaUeB635DEWo9FCTlC23evDkpeLpEJ+IylcwDb/ju
         y6ZQVXXKsBL3GdlDRutJvcigtnGld5+nm2kNSARfBPelTVbca7jgoy5HT/h8+v3nsMrV
         MD3v7q4qwWIk0jtHnpMSlUGdYJHPkxIdJqN42YjhGsgqXrBtGLghR7fG4AAfmLtFge+6
         0rSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdYD9KpYzw0VYohSpXVJrf4rnztM2ygi5LSg8jmYK6RVrDFp2EWf/bOK8R+EtlpGi8kMPNxHQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEGy+MwVsPD3E3YkME6magQNBzJKM9IA0e0nCGHOo+VZaX1xOE
	0D6IqTu6b5AGsJGDcznFt3iTJ+I8qUtOn+7FSQnHGCjq5nN7dGD/dITW6q9ts5HpLGDbmIScd22
	RC6l/Vg==
X-Google-Smtp-Source: AGHT+IFjMzWsmgpoKD47UCjvnfFv794+YDxXLQNcCuCgExxBvy0QxtFrFU6ExIRDVZTLIlyFyypR9AR8QDM=
X-Received: from pjbmd14.prod.google.com ([2002:a17:90b:23ce:b0:330:793a:2e77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cce:b0:32e:dd8c:dd18
 with SMTP id 98e67ed59e1d1-33bcf8f7617mr777557a91.17.1760635815980; Thu, 16
 Oct 2025 10:30:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:45 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-5-seanjc@google.com>
Subject: [PATCH v13 04/12] KVM: guest_memfd: Add slab-allocated inode cache
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

From: Shivank Garg <shivankg@amd.com>

Add a dedicated gmem_inode structure and a slab-allocated inode cache for
guest memory backing, similar to how shmem handles inodes.

This adds the necessary allocation/destruction functions and prepares
for upcoming guest_memfd NUMA policy support changes.  Using a dedicated
structure will also allow for additional cleanups, e.g. to track flags in
gmem_inode instead of i_private.

Signed-off-by: Shivank Garg <shivankg@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
[sean: s/kvm_gmem_inode_info/gmem_inode, name init_once()]
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 77 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 76 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ce04fc85e631..88fd812f0f31 100644
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
 
@@ -830,13 +839,61 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
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
@@ -860,13 +917,31 @@ static int kvm_gmem_init_mount(void)
 
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
2.51.0.858.gf9c4a03a3a-goog

