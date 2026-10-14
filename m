Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E289148489E
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 09:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791970662; cv=none; b=nb+NdtvB061zHWE6RzgW6zODX7JK8tibn6pD2HBMoG+AOwxkdcerrbDh9btGXRuOhGS2xdBreLjEVjJgZko5EdsxepFTKWGj+UhjcM9dTqjtm1yoDY98OmbKEE2IpiiNuO3wR2fzzuf3hwN37nduaZlArfmeojDVopniU0a7iNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791970662; c=relaxed/simple;
	bh=ntefZR9vc/AuAzq5SyGXCs7uQ7aNzfJHzHjbjpyaoho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YZMhps5tkhOo1Yvvq2d1LjR9mWM2Xew03BOiz3KIsUkkzPQEiyZXfAxfTP6iUvRWsUr60umQ94NqVfCyvHG9pM4lMocUh0XiL8S3HoogXh19TQP/Tw3REVfGoB+SQUC2vVwnnz/fh3vIf0YP7hw9RTzNyeipYI+blHJ4h8MiecI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WVuVpAn1; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVuVpAn1"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48c6f764f82so113432f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 02:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791970657; x=1792575457; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OqyQwIgQ/OPd1P3CopPmT923OjJym72s0dWzOzTAjxY=;
        b=WVuVpAn1Wf5Q9xYcILVUiLynBlVOJRfz14H7/884hacLiS9VWBM2C950nhfSBLOtDQ
         Uj/g2uGrYeC0zC8epUz3mftLa1ZyhL8rgv6TtnPJ4QT8fyxz6fqnl1edEmMSsLDjz4e1
         UXjDEpVbeBfWpGsy3yM2/w2KhXn8+7wW/CU/maYywibXjG6vXQle0J+H7WaG3dR46m6f
         DecQehThj92SyjD0T0xdg7hWLJ3vhtCBm6NbkGv+l53HJZJk4Ypfki4V76YOZ8WmzBan
         DqhqNJLDtjk/E4jBucq9zxNYlsfK4GuX80viykBxboYfk5++R5TsUyJJDyGjIb279zb1
         NIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970657; x=1792575457;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OqyQwIgQ/OPd1P3CopPmT923OjJym72s0dWzOzTAjxY=;
        b=p4Q39rv+Q4fooaADxljJd9mY97eN2plRE0PDK+EOG0wf2sTgSgHJNhytr4TCEQ0iLt
         SBU2pu7/gBDyav5g+BuKatlYNEIPf3W2tjp6UcTLY6fWcGDkVXI0/VB91XqK3TUBrGu7
         f6EUaC/16yk9vSp1LWq9lEc5FC3+qOxUMUk4XxJdx2zBChq63Xn1w9v37Orf+L73oTmi
         gJx/BjgKehdntNsRPJbm5z9IpsCLtj6aZF94GpeorpvUgr+Ck+nmPzFJ09zh+M/8x6pq
         ZFcDlr++5LHeI46VeSHmU9wL0jahrh0WktWMw7Od07NGZhQgCPhQBH6I4ZNXnTSLzmSZ
         rM3A==
X-Forwarded-Encrypted: i=1; AKwUvBxaqLL9btM/jTOrFU2cw90ITnB5QGuBDBAUaSf7eFkbJ+73kT9+ZdRC+yfPDD+bhrgB/AC+ry0=@lists.linux.dev
X-Gm-Message-State: AFq9FYL6P27YYmOPSZ+8o+CGVVua/x/V6TItQx1xc9UOE6EIBm0iSDmZ
	uNmjFKHvfHZVo+VcJ7R3Mn8iL5CMAX1Ca+hMVOrm9K9gkweSRsMo2eFE
X-Gm-Gg: AYBFou3gvTFto26Ih6Wsg92INsaqN0Vdn4K1kW8zH1/p8vgkKJG72uhn85RYRdeimez
	YDn7njQI6/XJ9aIJRdA/be23hfeUA+Q+LsPFr8ktw2x3HTwhe/foTIljyihP9R82L/iWDXh6IEt
	vKxxqyXm2LJxuQGEJJqIq0aijMFELnrzmt4TaX7Z5Bc6314RN1NaqaRwHQN2wUA0xQnTGawydCM
	cZr5+xKl2OYaDMFVFBJTfYId9Sld+NrqjI6xTqxFnlxjYGRGLWmE3dKFpefpXLlUWACleP8cTol
	TG8ya4S2EhbuFugVWYGtyPsEGRkdhwAIX6XDeEKV2r3Krv/hscsfKH4VFAnaIU7yRzuL4JJ/sCh
	sogX9I1Yuc7n27QAKMA+geODvPIMLA9e4lAm0keg8fIoepkez/4SRwo2Y2GdSktJ2wCUb1xnNbY
	1ozAxKGQUwFuhlNreTYRv2fuPVrhDNie0iNViAqD8x9PdTGyhMeoM9E+2qTPhkU3Zl2+qd3A/WE
	V5QiC5qbERcbgFAo3ehpJdz+Ma6oFSiqXyrxc2SgRQlX5NxW1yrCMecpqxFhguni0vY9On0QyZX
	SLPKiNwEa0doBjuC7O90EJYBIgJAX7WCSKU=
X-Received: by 2002:a05:6000:4b14:b0:48d:eb6b:9d0f with SMTP id ffacd0b85a97d-48deb6b9db7mr2281067f8f.11.1791970656765;
        Wed, 14 Oct 2026 02:37:36 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de3f7f8b8sm9365477f8f.35.2026.10.14.02.37.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:37:36 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 01/11] KVM: guest_memfd: Introduce guest memory ops and route native gmem through them
Date: Wed, 14 Oct 2026 09:37:23 +0000
Message-ID: <20261014093733.90312-2-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014093733.90312-1-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Woodhouse <dwmw@amazon.co.uk>

Guest_memfd today has exactly one backing implementation, hard-wired
into virt/kvm/guest_memfd.c.  To let other subsystems supply guest
memory from an alternate source -- for example a physically contiguous
range without struct page, or memory shared with a peer device --
lift the operations into a small vtable and route the built-in gmem
through it.

Introduce struct kvm_gmem_ops in <linux/kvm_host.h>: bind / unbind /
get_pfn / populate / invalidate for the memory-side operations, plus
release / mmap / fallocate for the file-level ones.  Every file that
can back guest memory is created with one shared struct
file_operations, kvm_gmem_fops, and file->private_data points at a
struct kvm_gmem_backing whose ->ops field is the per-instance vtable.
This mirrors the dma-buf / socket / iommufd pattern: a canonical fops
identifies the file (is_kvm_gmem_file() is a plain fops-equality
check), and per-instance behaviour is reached via private_data.

Every callback on kvm_gmem_fops -- release, mmap, fallocate, and the
memory-side dispatchers already present -- reaches through the ops
table, so foreign implementations get a private hook for each and
KVM code never has to distinguish "native vs foreign".  Native gmem
becomes one implementation of the ops (kvm_gmem_native_ops), with the
current release/mmap/fallocate bodies moved into
kvm_gmem_native_release/_mmap/_fallocate.  struct gmem_file gains a
struct kvm_gmem_backing as its first member so file->private_data can
be reinterpreted uniformly across implementations.

.populate is deliberately left NULL for the built-in path;
kvm_gmem_populate() keeps an inline fast path because the current
folio-locked + attribute-checked shape of post_populate() does not fit
the ops signature cleanly.  Wiring that flow through ops is a separate
cleanup.  .invalidate is likewise NULL for the built-in path, because
its invalidations run through inode->i_mapping (truncate, hwpoison,
free_folio) rather than an out-of-band notification.

kvm_gmem_unbind() gains a struct kvm * parameter so the dispatcher can
pass it to ops->unbind() without keeping a duplicate copy anywhere.
The three existing callers in kvm_main.c already have @kvm in scope.

Based on a proof-of-concept by Connor Williamson <connordw@amazon.com>.

Signed-off-by: David Woodhouse (Kiro) <dwmw@amazon.co.uk>
---
 arch/x86/kvm/Makefile    |   5 +-
 include/linux/kvm_host.h |  82 ++++++++++
 virt/kvm/guest_memfd.c   | 339 +++++++++++++++++++++++++++++++--------
 virt/kvm/kvm_main.c      |   8 +-
 virt/kvm/kvm_mm.h        |   4 +-
 5 files changed, 365 insertions(+), 73 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 77337c37324b..36a319f382b7 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -63,7 +63,10 @@ exports_grep_trailer := --include='*.[ch]' -nrw $(srctree)/virt/kvm $(srctree)/a
 				-e kvm_write_track_remove_gfn \
 				-e kvm_get_kvm \
 				-e kvm_get_kvm_safe \
-				-e kvm_put_kvm
+				-e kvm_put_kvm \
+				-e kvm_gmem_invalidate_range \
+				-e kvm_gmem_fops \
+				-e file_is_kvm
 
 # Force grep to emit a goofy group separator that can in turn be replaced with
 # the above newline macro (newlines in Make are a nightmare).  Note, grep only
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab8cfaec82d3..b33d2f475042 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -621,6 +621,88 @@ static inline bool kvm_slot_has_gmem(const struct kvm_memory_slot *slot)
 	return slot && (slot->flags & KVM_MEM_GUEST_MEMFD);
 }
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+/*
+ * struct kvm_gmem_ops - vtable a guest_memfd backing implementation exposes.
+ *
+ * Every file that can back KVM guest memory -- KVM's own guest_memfd (see
+ * kvm_gmem_create()) and any other subsystem opting in -- is created with
+ * the shared kvm_gmem_fops (see is_kvm_gmem_file()).  file->private_data on
+ * such a file points at a struct kvm_gmem_backing whose ->ops field is the
+ * per-instance vtable below.  KVM never looks any further; the rest of the
+ * per-file state (allocator, refcount, private xarray, ...) is up to the
+ * implementation and is reached via container_of() from the backing.
+ *
+ * The memory-side callbacks (bind, unbind, get_pfn, populate, invalidate)
+ * are the reason the interface exists.  The file-level callbacks (release,
+ * mmap, fallocate, ...) are dispatched by kvm_gmem_fops so that every
+ * implementation gets a private hook -- see the dispatchers in
+ * virt/kvm/guest_memfd.c.
+ *
+ * get_pfn() contract:
+ *  - *pfn is the host PFN backing @gfn.  It need not have a struct page.
+ *  - *max_order is the largest order KVM may use to map starting at @gfn.
+ *    The implementation MUST clamp it to the physical contiguity and the
+ *    HPA/GPA alignment of the backing, so KVM never builds a huge SPTE that
+ *    spans discontiguous physical memory.
+ *  - If *page is non-NULL on return the caller owns that page reference and
+ *    is responsible for put_page() after use.  If *page is left NULL the PFN
+ *    is treated as non-refcounted, and its lifetime is owned by the
+ *    implementation across bind()/unbind().
+ *
+ * Memory intended to back guest RAM MUST be reported as E820_TYPE_RAM by the
+ * host so KVM maps it write-back (and applies the memory-encryption bit on
+ * encrypted hosts) rather than treating it as MMIO.
+ */
+struct kvm_gmem_ops {
+	/* Memory operations. */
+	int (*bind)(struct file *file, struct kvm *kvm,
+		    struct kvm_memory_slot *slot, loff_t offset);
+	void (*unbind)(struct file *file, struct kvm *kvm,
+		       struct kvm_memory_slot *slot);
+	int (*get_pfn)(struct file *file, struct kvm *kvm,
+		       struct kvm_memory_slot *slot, gfn_t gfn,
+		       kvm_pfn_t *pfn, struct page **page, int *max_order);
+	int (*populate)(struct file *file, struct kvm *kvm,
+			struct kvm_memory_slot *slot, gfn_t gfn,
+			kvm_pfn_t *pfn, struct page *src_page, int order);
+	void (*invalidate)(struct file *file, struct kvm *kvm,
+			   struct kvm_memory_slot *slot,
+			   gfn_t start, gfn_t end);
+
+	/*
+	 * File-level operations, dispatched by kvm_gmem_fops.  These are
+	 * per-instance analogues of the like-named file_operations members,
+	 * with the same semantics.  A NULL entry causes the dispatcher to
+	 * fail the file-level operation with an appropriate errno.
+	 */
+	void (*release)(struct file *file);
+	int (*mmap)(struct file *file, struct vm_area_struct *vma);
+	long (*fallocate)(struct file *file, int mode, loff_t offset,
+			  loff_t len);
+	long (*ioctl)(struct file *file, unsigned int cmd, unsigned long arg);
+};
+
+/*
+ * Anchor placed at file->private_data of every guest_memfd-backing file.
+ * KVM's own gmem embeds it as the first member of struct gmem_file; other
+ * implementations do the same in their own per-fd state.  is_kvm_gmem_file()
+ * (fops-identity check) proves the reinterpretation is safe.
+ */
+struct kvm_gmem_backing {
+	const struct kvm_gmem_ops *ops;
+};
+
+/* Defined in guest_memfd.c; single canonical fops for every gmem file. */
+extern struct file_operations kvm_gmem_fops;
+
+static inline bool is_kvm_gmem_file(struct file *file)
+{
+	return file && file->f_op == &kvm_gmem_fops;
+}
+
+#endif /* CONFIG_KVM_GUEST_MEMFD */
+
 static inline bool kvm_slot_dirty_track_enabled(const struct kvm_memory_slot *slot)
 {
 	return slot->flags & KVM_MEM_LOG_DIRTY_PAGES;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index db57c5766ab6..057f90eb835a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -22,11 +22,22 @@ static struct vfsmount *kvm_gmem_mnt;
  * specific to its associated VM, e.g. memslots=>gmem bindings.
  */
 struct gmem_file {
+	/*
+	 * MUST be first: file->private_data points here.
+	 * is_kvm_gmem_file(file) proves this reinterpretation is safe.
+	 */
+	struct kvm_gmem_backing backing;
+
 	struct kvm *kvm;
 	struct xarray bindings;
 	struct list_head entry;
 };
 
+static inline struct gmem_file *gmem_file_of(struct file *file)
+{
+	return container_of(file->private_data, struct gmem_file, backing);
+}
+
 struct gmem_inode {
 	struct shared_policy policy;
 	struct inode vfs_inode;
@@ -296,7 +307,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 	return r;
 }
 
-static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
+static long kvm_gmem_native_fallocate(struct file *file, int mode, loff_t offset,
 			       loff_t len)
 {
 	int ret;
@@ -320,9 +331,10 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 	return ret;
 }
 
-static int kvm_gmem_release(struct inode *inode, struct file *file)
+static void kvm_gmem_native_release(struct file *file)
 {
-	struct gmem_file *f = file->private_data;
+	struct inode *inode = file_inode(file);
+	struct gmem_file *f = gmem_file_of(file);
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
 	unsigned long index;
@@ -367,7 +379,6 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 
 	kvm_put_kvm(kvm);
 
-	return 0;
 }
 
 static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
@@ -466,7 +477,7 @@ static const struct vm_operations_struct kvm_gmem_vm_ops = {
 #endif
 };
 
-static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
+static int kvm_gmem_native_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	if (!kvm_gmem_supports_mmap(file_inode(file)))
 		return -ENODEV;
@@ -481,12 +492,61 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-static struct file_operations kvm_gmem_fops = {
-	.mmap		= kvm_gmem_mmap,
+/* File-op dispatchers — thin: they all go through the backing's ops table. */
+
+static int kvm_gmem_fops_release(struct inode *inode, struct file *file)
+{
+	struct kvm_gmem_backing *b = file->private_data;
+
+	if (b && b->ops && b->ops->release)
+		b->ops->release(file);
+	return 0;
+}
+
+static int kvm_gmem_fops_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct kvm_gmem_backing *b = file->private_data;
+
+	if (!b || !b->ops || !b->ops->mmap)
+		return -ENODEV;
+	return b->ops->mmap(file, vma);
+}
+
+static long kvm_gmem_fops_fallocate(struct file *file, int mode,
+				    loff_t offset, loff_t len)
+{
+	struct kvm_gmem_backing *b = file->private_data;
+
+	if (!b || !b->ops || !b->ops->fallocate)
+		return -EOPNOTSUPP;
+	return b->ops->fallocate(file, mode, offset, len);
+}
+
+static long kvm_gmem_fops_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	struct kvm_gmem_backing *b = file->private_data;
+
+	if (!b || !b->ops || !b->ops->ioctl)
+		return -ENOTTY;
+	return b->ops->ioctl(file, cmd, arg);
+}
+
+/*
+ * A single struct file_operations for every guest_memfd-backing file --
+ * KVM's built-in gmem and any subsystem-supplied backing alike.  All
+ * callbacks that can vary per implementation dispatch through the
+ * kvm_gmem_backing at file->private_data.
+ */
+struct file_operations kvm_gmem_fops = {
 	.open		= generic_file_open,
-	.release	= kvm_gmem_release,
-	.fallocate	= kvm_gmem_fallocate,
+	.release	= kvm_gmem_fops_release,
+	.mmap		= kvm_gmem_fops_mmap,
+	.fallocate	= kvm_gmem_fops_fallocate,
+	.unlocked_ioctl	= kvm_gmem_fops_ioctl,
+	.compat_ioctl	= kvm_gmem_fops_ioctl,
 };
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_fops);
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
 				  struct folio *dst, struct folio *src,
@@ -557,6 +617,43 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return true;
 }
 
+static int  kvm_gmem_native_bind(struct file *file, struct kvm *kvm,
+				 struct kvm_memory_slot *slot, loff_t offset);
+static void kvm_gmem_native_unbind(struct file *slot_file, struct kvm *kvm,
+				   struct kvm_memory_slot *slot);
+static int  kvm_gmem_native_get_pfn(struct file *file, struct kvm *kvm,
+				    struct kvm_memory_slot *slot, gfn_t gfn,
+				    kvm_pfn_t *pfn, struct page **page,
+				    int *max_order);
+static void kvm_gmem_native_release(struct file *file);
+static int  kvm_gmem_native_mmap(struct file *file,
+				 struct vm_area_struct *vma);
+static long kvm_gmem_native_fallocate(struct file *file, int mode,
+				      loff_t offset, loff_t len);
+
+static const struct kvm_gmem_ops kvm_gmem_native_ops = {
+	/* Memory operations. */
+	.bind      = kvm_gmem_native_bind,
+	.unbind    = kvm_gmem_native_unbind,
+	.get_pfn   = kvm_gmem_native_get_pfn,
+	/*
+	 * .populate is deliberately NULL: kvm_gmem_populate() has an inline
+	 * fast path that drives post_populate() with the folio locked and
+	 * the memory-attribute check in the right place; that flow doesn't
+	 * fit the current ops signature cleanly.  Wiring it through ops
+	 * is a separate cleanup.
+	 *
+	 * .invalidate is deliberately NULL: invalidations for the built-in
+	 * implementation flow through inode->i_mapping (truncate, hwpoison,
+	 * free_folio) and don't need an out-of-band callback from KVM.
+	 */
+
+	/* File-level operations (dispatched by kvm_gmem_fops). */
+	.release   = kvm_gmem_native_release,
+	.mmap      = kvm_gmem_native_mmap,
+	.fallocate = kvm_gmem_native_fallocate,
+};
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
 	static const char *name = "[kvm-gmem]";
@@ -605,7 +702,8 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	}
 
 	file->f_flags |= O_LARGEFILE;
-	file->private_data = f;
+	file->private_data = &f->backing;
+	f->backing.ops = &kvm_gmem_native_ops;
 
 	kvm_get_kvm(kvm);
 	f->kvm = kvm;
@@ -640,34 +738,27 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	return __kvm_gmem_create(kvm, size, flags);
 }
 
-int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-		  unsigned int fd, uoff_t offset)
+static const struct kvm_gmem_ops *kvm_gmem_get_ops(struct file *file)
+{
+	if (!is_kvm_gmem_file(file))
+		return NULL;
+	return ((struct kvm_gmem_backing *)file->private_data)->ops;
+}
+
+static int kvm_gmem_native_bind(struct file *file, struct kvm *kvm,
+				struct kvm_memory_slot *slot, loff_t offset)
 {
 	uoff_t size = slot->npages << PAGE_SHIFT;
+	struct gmem_file *f = gmem_file_of(file);
+	struct inode *inode = file_inode(file);
 	unsigned long start, end;
-	struct gmem_file *f;
-	struct inode *inode;
-	struct file *file;
 	int r = -EINVAL;
 
-	BUILD_BUG_ON(sizeof(gpa_t) != sizeof(offset));
-	BUILD_BUG_ON(sizeof(gfn_t) != sizeof(slot->gmem.pgoff));
-
-	file = fget(fd);
-	if (!file)
-		return -EBADF;
-
-	if (file->f_op != &kvm_gmem_fops)
-		goto err;
-
-	f = file->private_data;
 	if (f->kvm != kvm)
-		goto err;
-
-	inode = file_inode(file);
+		return -EINVAL;
 
-	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
-		goto err;
+	if (offset < 0 || !PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
+		return -EINVAL;
 
 	filemap_invalidate_lock(inode->i_mapping);
 
@@ -677,14 +768,13 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!xa_empty(&f->bindings) &&
 	    xa_find(&f->bindings, &start, end - 1, XA_PRESENT)) {
 		r = -EEXIST;
-		filemap_invalidate_unlock(inode->i_mapping);
-		goto err;
+		goto out;
 	}
 
 	/*
-	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable to change, so
-	 * kvm_gmem_bind() must occur on a new memslot.  Because the memslot
-	 * is not visible yet, kvm_gmem_get_pfn() is guaranteed to see the file.
+	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable, so bind must
+	 * occur on a new memslot.  Because the memslot is not visible yet,
+	 * kvm_gmem_get_pfn() is guaranteed to see the file.
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
@@ -692,15 +782,51 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
 	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
+	r = 0;
+out:
 	filemap_invalidate_unlock(inode->i_mapping);
+	return r;
+}
+
+int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
+		  unsigned int fd, uoff_t offset)
+{
+	const struct kvm_gmem_ops *ops;
+	struct file *file;
+	int r;
+
+	BUILD_BUG_ON(sizeof(gpa_t) != sizeof(offset));
+	BUILD_BUG_ON(sizeof(gfn_t) != sizeof(slot->gmem.pgoff));
+
+	file = fget(fd);
+	if (!file)
+		return -EBADF;
+
+	ops = kvm_gmem_get_ops(file);
+	if (!ops || !ops->bind || !ops->get_pfn) {
+		r = -EINVAL;
+		goto out;
+	}
+
+	if (!PAGE_ALIGNED(offset)) {
+		r = -EINVAL;
+		goto out;
+	}
 
 	/*
-	 * Drop the reference to the file, even on success.  The file pins KVM,
-	 * not the other way 'round.  Active bindings are invalidated if the
-	 * file is closed before memslots are destroyed.
+	 * On success .bind() associates the fd with @kvm and (if the
+	 * implementation needs it) records the reference that makes the fd
+	 * pin the VM.  A .bind() that returns success is trusted to have
+	 * done so; there is no separate ownership check here.
+	 */
+	r = ops->bind(file, kvm, slot, offset);
+out:
+	/*
+	 * Drop the reference to the file even on success.  The file pins
+	 * KVM, not the other way 'round: it is the implementation's job to
+	 * invalidate its bindings if the fd is closed before the memslots
+	 * are destroyed.
 	 */
-	r = 0;
-err:
 	fput(file);
 	return r;
 }
@@ -719,21 +845,15 @@ static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct gmem_file *f)
 	WRITE_ONCE(slot->gmem.file, NULL);
 }
 
-void kvm_gmem_unbind(struct kvm_memory_slot *slot)
+static void kvm_gmem_native_unbind(struct file *slot_file, struct kvm *kvm,
+				   struct kvm_memory_slot *slot)
 {
-	/*
-	 * Nothing to do if the underlying file was _already_ closed, as
-	 * kvm_gmem_release() invalidates and nullifies all bindings.
-	 */
-	if (!slot->gmem.file)
-		return;
-
 	CLASS(gmem_get_file, file)(slot);
 
 	/*
-	 * However, if the file is _being_ closed, then the bindings need to be
-	 * removed as kvm_gmem_release() might not run until after the memslot
-	 * is freed.  Note, modifying the bindings is safe even though the file
+	 * If the file is _being_ closed, then the bindings need to be removed
+	 * as kvm_gmem_release() might not run until after the memslot is
+	 * freed.  Note, modifying the bindings is safe even though the file
 	 * is dying as kvm_gmem_release() nullifies slot->gmem.file under
 	 * slots_lock, and only puts its reference to KVM after destroying all
 	 * bindings.  I.e. reaching this point means kvm_gmem_release() hasn't
@@ -741,15 +861,41 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	 * until the caller drops slots_lock.
 	 */
 	if (!file) {
-		__kvm_gmem_unbind(slot, slot->gmem.file->private_data);
+		__kvm_gmem_unbind(slot, gmem_file_of(slot_file));
 		return;
 	}
 
 	filemap_invalidate_lock(file->f_mapping);
-	__kvm_gmem_unbind(slot, file->private_data);
+	__kvm_gmem_unbind(slot, gmem_file_of(file));
 	filemap_invalidate_unlock(file->f_mapping);
 }
 
+void kvm_gmem_unbind(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	const struct kvm_gmem_ops *ops;
+	struct file *file;
+
+	/*
+	 * Nothing to do if the underlying file was _already_ closed, as
+	 * kvm_gmem_release() invalidates and nullifies all bindings.
+	 */
+	file = READ_ONCE(slot->gmem.file);
+	if (!file)
+		return;
+
+	ops = kvm_gmem_get_ops(file);
+	if (ops && ops->unbind)
+		ops->unbind(file, kvm, slot);
+
+	/*
+	 * .unbind() may clear slot->gmem.file itself (as the built-in gmem
+	 * ops do, under filemap_invalidate_lock, to serialise against
+	 * release/invalidate); catch the ones that don't.
+	 */
+	if (READ_ONCE(slot->gmem.file))
+		WRITE_ONCE(slot->gmem.file, NULL);
+}
+
 /* Returns a locked folio on success.  */
 static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					struct kvm_memory_slot *slot,
@@ -757,7 +903,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					int *max_order)
 {
 	struct file *slot_file = READ_ONCE(slot->gmem.file);
-	struct gmem_file *f = file->private_data;
+	struct gmem_file *f = gmem_file_of(file);
 	struct folio *folio;
 
 	if (file != slot_file) {
@@ -787,17 +933,14 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	return folio;
 }
 
-int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order)
+static int kvm_gmem_native_get_pfn(struct file *file, struct kvm *kvm,
+				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   kvm_pfn_t *pfn, struct page **page,
+				   int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
-	int r = 0;
-
-	CLASS(gmem_get_file, file)(slot);
-	if (!file)
-		return -EFAULT;
+	int r;
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio))
@@ -809,7 +952,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
-
 	folio_unlock(folio);
 
 	if (!r)
@@ -819,6 +961,24 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	return r;
 }
+
+int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
+		     int *max_order)
+{
+	const struct kvm_gmem_ops *ops;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return -EFAULT;
+
+	ops = kvm_gmem_get_ops(file);
+	if (!ops || !ops->get_pfn)
+		return -EFAULT;
+
+	*page = NULL;
+	return ops->get_pfn(file, kvm, slot, gfn, pfn, page, max_order);
+}
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
@@ -860,11 +1020,51 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return ret;
 }
 
+static int kvm_gmem_populate_one(const struct kvm_gmem_ops *ops,
+				      struct file *file, struct kvm *kvm,
+				      struct kvm_memory_slot *slot, gfn_t gfn,
+				      struct page *src_page,
+				      kvm_gmem_populate_cb post_populate,
+				      void *opaque)
+{
+	struct page *ignored_page = NULL;
+	kvm_pfn_t pfn;
+	int ret;
+
+	/*
+	 * Resolve the PFN via the ops.  A populate() op may also copy
+	 * @src_page into the backing before the arch post_populate() step
+	 * (e.g. SNP LAUNCH_UPDATE); otherwise fall back to get_pfn().
+	 */
+	if (ops->populate)
+		ret = ops->populate(file, kvm, slot, gfn, &pfn,
+				    src_page, 0);
+	else
+		ret = ops->get_pfn(file, kvm, slot, gfn, &pfn,
+				   &ignored_page, NULL);
+	if (ret)
+		return ret;
+
+	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
+
+	/*
+	 * Populate does not consume a refcount on the destination page.
+	 * Drop @page (if any) AFTER post_populate() so the PFN cannot be
+	 * freed and reallocated behind an arch hook (e.g. RMPUPDATE) that
+	 * is still operating on it.
+	 */
+	if (ignored_page)
+		put_page(ignored_page);
+
+	return ret;
+}
+
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src,
 		       long npages, bool may_writeback_src,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
 	struct kvm_memory_slot *slot;
+	const struct kvm_gmem_ops *ops;
 	int ret = 0;
 	long i;
 
@@ -884,6 +1084,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src,
 	if (!file)
 		return -EFAULT;
 
+	ops = kvm_gmem_get_ops(file);
+
 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
 	for (i = 0; i < npages; i++) {
 		struct page *src_page = NULL;
@@ -906,8 +1108,13 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src,
 			}
 		}
 
-		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, src_page,
-					  post_populate, opaque);
+		if (ops && (ops->populate || ops->get_pfn != kvm_gmem_native_get_pfn))
+			ret = kvm_gmem_populate_one(ops, file, kvm, slot,
+						    start_gfn + i, src_page,
+						    post_populate, opaque);
+		else
+			ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i,
+						  src_page, post_populate, opaque);
 
 		if (src_page)
 			put_page(src_page);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e44c20c04961..3af5270d2a90 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -935,7 +935,7 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
 static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	if (slot->flags & KVM_MEM_GUEST_MEMFD)
-		kvm_gmem_unbind(slot);
+		kvm_gmem_unbind(kvm, slot);
 
 	kvm_destroy_dirty_bitmap(slot);
 
@@ -1747,7 +1747,7 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 		 * flags-only changes on guest_memfd slots should be impossible.
 		 */
 		if (WARN_ON_ONCE(old->flags & KVM_MEM_GUEST_MEMFD))
-			kvm_gmem_unbind(old);
+			kvm_gmem_unbind(kvm, old);
 
 		/*
 		 * The final quirk.  Free the detached, old slot, but only its
@@ -2118,7 +2118,7 @@ static int kvm_set_memory_region(struct kvm *kvm,
 
 out_unbind:
 	if (mem->flags & KVM_MEM_GUEST_MEMFD)
-		kvm_gmem_unbind(new);
+		kvm_gmem_unbind(kvm, new);
 out:
 	kfree(new);
 	return r;
@@ -5475,7 +5475,7 @@ bool file_is_kvm(struct file *file)
 {
 	return file && file->f_op == &kvm_vm_fops;
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(file_is_kvm);
+EXPORT_SYMBOL_GPL(file_is_kvm);
 
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 7510ca915dd1..ea0fe74e89d4 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -76,7 +76,7 @@ void kvm_gmem_exit(void);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, uoff_t offset);
-void kvm_gmem_unbind(struct kvm_memory_slot *slot);
+void kvm_gmem_unbind(struct kvm *kvm, struct kvm_memory_slot *slot);
 #else
 static inline int kvm_gmem_init(struct module *module)
 {
@@ -91,7 +91,7 @@ static inline int kvm_gmem_bind(struct kvm *kvm,
 	return -EIO;
 }
 
-static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
+static inline void kvm_gmem_unbind(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	WARN_ON_ONCE(1);
 }
-- 
2.47.3

