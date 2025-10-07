Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037FE25D528
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 22:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875284; cv=none; b=VwDA81iyEYvFA5g/3kWHxRr+Xrox3EOg93s257dN3qVQOBRSw/gKi3yRZ2S8u8GRUGv8Lb6IXTz8TBIQzJiHGJ58dacQcgSibEdQoHyKSDqdALN9CEQpp4JiTGqoFE9uqdgaJHStVa/mLx0mdF49n2wi6HjY8esB1BBXrZzEy/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875284; c=relaxed/simple;
	bh=hk3P/iMlQ4ykxksWA+57q4ope7eH8XLXI1gf+T3z+mQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f/yfgmBX7MxTW3xb3M1h6OH1FYvdpL1U7kzQy663z45YAmuO1XYmYqHQTqt0nAqs2Gd2zLnbm4c7aJWaRwA1QIoVy5kRAnyoptfLq7I0CffNtNNR38+MdQKxKHgN/4gZOkmoA7qR+GQXShBdv7VcHV+F+xu+/hOgat6MZVI9lnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mwP4nP3j; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mwP4nP3j"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3352a336ee1so12590062a91.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 15:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875282; x=1760480082; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XeONchAeZ2W/BnYW50Y0JuCpKNk/eh0ylYTeKOoopl0=;
        b=mwP4nP3j/mjPKfZpTaB6ytoSMnNoR2/1FgFfJPfAmRFMPXz9w0pHEhghMdiYa+DRn/
         9m6e6ojHLxC9WYbbB6ItoYx/okvu5DaJ0ZREy5iWStM2TIbIMTWkDK3zTYQp4gM9zfC+
         PGnt/me2gP/q8h5+cNeOZxtHiSqSqv1x9kHAjoOMkycofLoJDRcHJaqa4buPdoQLO114
         g+okJuBZqzOpunTJNp+/sNF85Cz1xBnPa7ogk6FKjqzJzpHJY/MgZMly/BoCjTIFTknP
         Brq6Gj1q3Mvsa+sahEmn5PzEEP1jHFoHYj3otT2Rt1+Wt65vWUWcyVe7oLc0RAO5y3WF
         6Sjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875282; x=1760480082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XeONchAeZ2W/BnYW50Y0JuCpKNk/eh0ylYTeKOoopl0=;
        b=wJhtwAAAzb0DFaHOwOnvFDHB8CQkJ8woIJck/KoO0TiRVZJRE7GNfh0lTlHYM7prqf
         XkW/czDsCeR00eqoYEqZQP+ZGdgifHouL+m1aCT3IwTPhqFZ6vaTwjtG30FAIfzt3rog
         K5WfWEiJ5Hit7aPywQqZ4IG9sYCtFXVRDIBISsbjm+e/ev1U+e9CVlaMAZd1nvGHKPQk
         4EAqalX8MjPxfcWAmZuVjtMDw4hGqPhkqs3Ml3/1ihpb1M6qwYuX8WZgfswRx2qI2PNE
         odmgxWJbo+B7jn2Dq9Kx8pZBHfcH+NixRTlcWPICKS7CtWGlLypOixHQAGLAycu8TAm7
         vWGw==
X-Forwarded-Encrypted: i=1; AJvYcCW7hAUc0jdxm11TLoLlwjMrnOLHt1E5xek019a3uVxykCJIb+QfiCEtTsb/Z8xYF451DxokBwA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzECnVIaRMZigbS2QwYw/18BQlmu0S5c4Kc8AASwm8/ZpukslH0
	HovMZ7xcC87sdtrgbYpWf9jaEccQMKBNfBj//qsViuzqpJXhi5cIkGbduokAtyL4DsYWa9YAFhA
	+TlMTaQ==
X-Google-Smtp-Source: AGHT+IE2+221EmFwqFBWMvoQR4yGg9P25ItxnENkIb2SOi1cibrAfb57GoNKRhcdEePQSic/GlYtZWJds1k=
X-Received: from pjwo13.prod.google.com ([2002:a17:90a:d24d:b0:32b:35fb:187f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d87:b0:32e:d011:ea1c
 with SMTP id 98e67ed59e1d1-33b51112272mr1450486a91.15.1759875282455; Tue, 07
 Oct 2025 15:14:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:11 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-4-seanjc@google.com>
Subject: [PATCH v12 03/12] KVM: guest_memfd: Use guest mem inodes instead of
 anonymous inodes
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

guest_memfd's inode represents memory the guest_memfd is
providing. guest_memfd's file represents a struct kvm's view of that
memory.

Using a custom inode allows customization of the inode teardown
process via callbacks. For example, ->evict_inode() allows
customization of the truncation process on file close, and
->destroy_inode() and ->free_inode() allow customization of the inode
freeing process.

Customizing the truncation process allows flexibility in management of
guest_memfd memory and customization of the inode freeing process
allows proper cleanup of memory metadata stored on the inode.

Memory metadata is more appropriately stored on the inode (as opposed
to the file), since the metadata is for the memory and is not unique
to a specific binding and struct kvm.

Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
[sean: drop helpers, open code logic in __kvm_gmem_create()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/uapi/linux/magic.h |  1 +
 virt/kvm/guest_memfd.c     | 82 +++++++++++++++++++++++++++++++-------
 virt/kvm/kvm_main.c        |  7 +++-
 virt/kvm/kvm_mm.h          |  9 +++--
 4 files changed, 80 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index bb575f3ab45e..638ca21b7a90 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -103,5 +103,6 @@
 #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
 #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
+#define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
 
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9b9e239b3073..2a580b2bdc9d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1,12 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/anon_inodes.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
+#include <linux/fs.h>
 #include <linux/kvm_host.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
-#include <linux/anon_inodes.h>
 
 #include "kvm_mm.h"
 
+static struct vfsmount *kvm_gmem_mnt;
+
 /*
  * A guest_memfd instance can be associated multiple VMs, each with its own
  * "view" of the underlying physical memory.
@@ -426,11 +430,6 @@ static struct file_operations kvm_gmem_fops = {
 	.fallocate	= kvm_gmem_fallocate,
 };
 
-void kvm_gmem_init(struct module *module)
-{
-	kvm_gmem_fops.owner = module;
-}
-
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
 				  struct folio *dst, struct folio *src,
 				  enum migrate_mode mode)
@@ -502,7 +501,7 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
-	const char *anon_name = "[kvm-gmem]";
+	static const char *name = "[kvm-gmem]";
 	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
@@ -518,16 +517,17 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fd;
 	}
 
-	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, f, O_RDWR, NULL);
-	if (IS_ERR(file)) {
-		err = PTR_ERR(file);
+	/* __fput() will take care of fops_put(). */
+	if (!fops_get(&kvm_gmem_fops)) {
+		err = -ENOENT;
 		goto err_gmem;
 	}
 
-	file->f_flags |= O_LARGEFILE;
-
-	inode = file->f_inode;
-	WARN_ON(file->f_mapping != inode->i_mapping);
+	inode = anon_inode_make_secure_inode(kvm_gmem_mnt->mnt_sb, name, NULL);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto err_fops;
+	}
 
 	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
@@ -539,6 +539,15 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
+	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_inode;
+	}
+
+	file->f_flags |= O_LARGEFILE;
+	file->private_data = f;
+
 	kvm_get_kvm(kvm);
 	f->kvm = kvm;
 	xa_init(&f->bindings);
@@ -547,6 +556,10 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	fd_install(fd, file);
 	return fd;
 
+err_inode:
+	iput(inode);
+err_fops:
+	fops_put(&kvm_gmem_fops);
 err_gmem:
 	kfree(f);
 err_fd:
@@ -819,3 +832,44 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
 #endif
+
+static int kvm_gmem_init_fs_context(struct fs_context *fc)
+{
+	if (!init_pseudo(fc, GUEST_MEMFD_MAGIC))
+		return -ENOMEM;
+
+	fc->s_iflags |= SB_I_NOEXEC;
+	fc->s_iflags |= SB_I_NODEV;
+
+	return 0;
+}
+
+static struct file_system_type kvm_gmem_fs = {
+	.name		 = "guest_memfd",
+	.init_fs_context = kvm_gmem_init_fs_context,
+	.kill_sb	 = kill_anon_super,
+};
+
+static int kvm_gmem_init_mount(void)
+{
+	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
+
+	if (IS_ERR(kvm_gmem_mnt))
+		return PTR_ERR(kvm_gmem_mnt);
+
+	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
+	return 0;
+}
+
+int kvm_gmem_init(struct module *module)
+{
+	kvm_gmem_fops.owner = module;
+
+	return kvm_gmem_init_mount();
+}
+
+void kvm_gmem_exit(void)
+{
+	kern_unmount(kvm_gmem_mnt);
+	kvm_gmem_mnt = NULL;
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b7a0ae2a7b20..4845e5739436 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6517,7 +6517,9 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (WARN_ON_ONCE(r))
 		goto err_vfio;
 
-	kvm_gmem_init(module);
+	r = kvm_gmem_init(module);
+	if (r)
+		goto err_gmem;
 
 	r = kvm_init_virtualization();
 	if (r)
@@ -6538,6 +6540,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 err_register:
 	kvm_uninit_virtualization();
 err_virt:
+	kvm_gmem_exit();
+err_gmem:
 	kvm_vfio_ops_exit();
 err_vfio:
 	kvm_async_pf_deinit();
@@ -6569,6 +6573,7 @@ void kvm_exit(void)
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
+	kvm_gmem_exit();
 	kvm_vfio_ops_exit();
 	kvm_async_pf_deinit();
 	kvm_irqfd_exit();
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 31defb08ccba..9fcc5d5b7f8d 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -68,17 +68,18 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 #endif /* HAVE_KVM_PFNCACHE */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-void kvm_gmem_init(struct module *module);
+int kvm_gmem_init(struct module *module);
+void kvm_gmem_exit(void);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
-static inline void kvm_gmem_init(struct module *module)
+static inline int kvm_gmem_init(struct module *module)
 {
-
+	return 0;
 }
-
+static inline void kvm_gmem_exit(void) {};
 static inline int kvm_gmem_bind(struct kvm *kvm,
 					 struct kvm_memory_slot *slot,
 					 unsigned int fd, loff_t offset)
-- 
2.51.0.710.ga91ca5db03-goog

