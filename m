Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7E13E7145
	for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785240716; cv=none; b=P8hYDKxPfsxJMXIgEp4zwkJiu0Cajvosfj0wJ7BYIDvk5WzJTLapM/dHNQ0qxlLPxUT05d3jfD8nF2V6Bu1DcFytf051tJRWv7NbsmykOqpn5ORunbqWk/xAkiNLMEEyiDY2iXkZZUNYGj4uH7G0rItZZrso8Cc8IJJgAJ2Hpss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785240716; c=relaxed/simple;
	bh=/vSUg1OE7HEij5qVtE7FZ8/UTf17OChwHX9OyhhF2pc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lSsvDOTM0O+AsU3IInrmVOvHsy1yZHgiJoIKDZTsvgSb9qXOTMtHt2I7W4kyR5JRBhZgcVMoOkSJPCIYBYx/MTuofvEXZigWy/HeUaL8aAHkknwx5nGRFoMkBSOwnpRTud9SqmX2azMRekTVwG2McmPVfo2KH8IbqMPBeSpoMpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=izoli1yZ; arc=none smtp.client-ip=209.85.218.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="izoli1yZ"
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15cec1ccb6so410273566b.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 05:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240711; x=1785845511; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3IzCJe625fGAUzp7Q7cJMtVFgujH1lwmHQF/47+9AJw=;
        b=izoli1yZHGAyp+LjcpUxchi6o9rHYnt44NiHnqxLg4g4vH5YIRIbsDTLhiqB92yyXH
         L0WDyArG84bSlrX1TI3amHwvfQPvW4LENXlbdNqJjjzJSorWhhPssA2wjfJEa3yoYfsn
         T6oE7EbtJnpjGIaR7hul6JbBqGyBcqxmVocXi1i9MxHSUPJ+buhwr83dyCXMjgHZpSqL
         69cfNi1az68SSkvSNDeN011IyUoC8sLhQXR9szHkwNF6yo2HhlG4B6U3Se4A5ItGsGS2
         UlkyJQ2yMglVwcSoRzIkl5saPfiDyskQo5OlPKmOEV8W+rzxlzMMeVV7MlPSDOM4TnK7
         oJ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240711; x=1785845511;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3IzCJe625fGAUzp7Q7cJMtVFgujH1lwmHQF/47+9AJw=;
        b=YMHep2PAvTXAEfZbpEQDU4dlVQ8BgOSwTG8doTROBp4XGPvJk4LeKVZ0Lt33NtzX6C
         ZhK00YVMoBh5t6VhNVkV2PokBE6i8eklZ/QUPto/zh53fy9wU7FcP4S23c1IAzlkdywW
         UoO4umysL0057O31vCH91TdQH8ZB26OetacLaS/Mn8h/Q1Ho7EYa3EtdqBSBpLnYM4u6
         mwLe7mXu8SzJX8ogfkj794nmnLDQyCvKPUnAJXLC6PEGOsCyp65CS2pE4rOSAL6GUADs
         B8KUlHEINBC0Y32iy70R3GLdF5IEjMvzGwBgt4Nvle9DSfQgMuYe/h4jenDMpfj0Q0pm
         wtog==
X-Forwarded-Encrypted: i=1; AHgh+Ros3O60AwjdOGsMlbPfpMbKU0pdIQdBoLhatDFfWKiztHssfgsZach0okkZQr59rUU1mHDbqc4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3a8moekMMvv2J2mw4j2Q+2+nf/smUthiZgJJsDEE/kDXA3HFP
	PX50mKYJ6HcfK9F0YMQBY6NjBMbCikKVvHA8CaWKdBU276Rqk6mozh856UBi0u2Ectt7Fu+6g0E
	qPvrPmRZjvUaJYRdhtg==
X-Received: from ejzp8.prod.google.com ([2002:a17:906:b208:b0:c12:5e2b:a869])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:7947:b0:c16:12c:9aa7 with SMTP id a640c23a62f3a-c1f7212f773mr127482566b.40.1785240710512;
 Tue, 28 Jul 2026 05:11:50 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:35 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-9-tarunsahu@google.com>
Subject: [PATCH v4 08/11] KVM: guest_memfd: Add support for preservation via LUO
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Register a Live Update Orchestrator (LUO) file handler for guest_memfd
files to preserve guest memory across kexec reboots.

Freeze the guest_memfd inode via kvm_gmem_freeze() during preservation to
prevent concurrent fallocate() calls or page fault allocations. Walk the
inode's page cache folios to serialize their metadata and physical PFNs
for kexec handover.

On retrieval, reconstruct the guest_memfd file with __kvm_gmem_create_file(),
re-insert the preserved folios into the page cache via filemap_add_folio(),
and associate the file back to its preserved KVM VM via the VM token.

Currently, this supports fully shared guest_memfd instances backed by
PAGE_SIZE pages. Also update MAINTAINERS for guest_memfd LUO preservation.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 MAINTAINERS                 |   1 +
 include/linux/kho/abi/kvm.h |  79 +++++-
 virt/kvm/Makefile.kvm       |   2 +-
 virt/kvm/guest_memfd_luo.c  | 515 ++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c         |   7 +
 virt/kvm/kvm_mm.h           |   4 +
 6 files changed, 601 insertions(+), 7 deletions(-)
 create mode 100644 virt/kvm/guest_memfd_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0283f0fd6ef4..8db8bb448b23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14548,6 +14548,7 @@ L:	kexec@lists.infradead.org
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
 KVM PARAVIRT (KVM/paravirt)
diff --git a/include/linux/kho/abi/kvm.h b/include/linux/kho/abi/kvm.h
index 718db68a541a..42074d76e04a 100644
--- a/include/linux/kho/abi/kvm.h
+++ b/include/linux/kho/abi/kvm.h
@@ -9,20 +9,23 @@
 #define _LINUX_KHO_ABI_KVM_H
 
 #include <linux/types.h>
+#include <linux/bits.h>
 #include <linux/kho/abi/kexec_handover.h>
 
 /**
- * DOC: KVM Live Update ABI
+ * DOC: KVM and guest_memfd Live Update ABI
  *
- * KVM uses the ABI defined below for preserving its state
+ * KVM and guest_memfd use the ABI defined below for preserving their states
  * across a kexec reboot using the LUO.
  *
- * The state is serialized into a packed structure `struct kvm_luo_ser`
- * which is handed over to the next kernel via the KHO mechanism.
+ * The state is serialized into packed structures (struct kvm_luo_ser and
+ * struct guest_memfd_luo_ser) which are handed over to the next kernel via
+ * the KHO mechanism.
  *
- * This interface is a contract. Any modification to the structure layout
+ * This interface is a contract. Any modification to the structure layouts
  * constitutes a breaking change. Such changes require incrementing the
- * version number in the KVM_LUO_FH_COMPATIBLE compatibility string.
+ * version number in the KVM_LUO_FH_COMPATIBLE or
+ * GUEST_MEMFD_LUO_FH_COMPATIBLE compatibility strings.
  */
 
 /**
@@ -36,4 +39,68 @@ struct kvm_luo_ser {
 /* The compatibility string for KVM VM file handler */
 #define KVM_LUO_FH_COMPATIBLE	"kvm_vm_luo_v1"
 
+/**
+ * struct guest_memfd_luo_folio_ser - Serialization layout for a single folio in guest_memfd.
+ * @pfn:   Page Frame Number of the folio.
+ * @index: Page offset of the folio within the file.
+ * @flags: State flags associated with the folio.
+ */
+struct guest_memfd_luo_folio_ser {
+	u64 pfn:52;
+	u64 flags:12;
+	u64 index;
+} __packed;
+
+/**
+ * GUEST_MEMFD_LUO_FOLIO_UPTODATE - The folio is up-to-date.
+ *
+ * This flag is per folio to check if the folio is uptodate.
+ */
+#define GUEST_MEMFD_LUO_FOLIO_UPTODATE	BIT(0)
+
+
+/**
+ * GUEST_MEMFD_LUO_FLAG_MMAP - The guest_memfd supports mmap.
+ *
+ * This flag indicates that the guest_memfd supports host-side mmap.
+ */
+#define GUEST_MEMFD_LUO_FLAG_MMAP		BIT(0)
+
+/**
+ * GUEST_MEMFD_LUO_FLAG_INIT_SHARED - Initialize memory as shared.
+ *
+ * This flag indicates that the guest_memfd has been initialized as shared
+ * memory.
+ */
+#define GUEST_MEMFD_LUO_FLAG_INIT_SHARED	BIT(1)
+
+/**
+ * GUEST_MEMFD_LUO_SUPPORTED_FLAGS - Supported guest_memfd LUO flags mask.
+ *
+ * A mask of all guest_memfd preservation flags supported by this version
+ * of the KVM LUO ABI.
+ */
+#define GUEST_MEMFD_LUO_SUPPORTED_FLAGS	(GUEST_MEMFD_LUO_FLAG_MMAP | \
+						 GUEST_MEMFD_LUO_FLAG_INIT_SHARED)
+
+/**
+ * struct guest_memfd_luo_ser - Main serialization structure for guest_memfd.
+ * @size:      The size of the file in bytes.
+ * @flags:     File-level flags.
+ * @nr_folios: Number of folios in the folios array.
+ * @vm_token:  Token of the associated KVM VM instance.
+ * @folios:    KHO vmalloc descriptor pointing to the array of
+ *             struct guest_memfd_luo_folio_ser.
+ */
+struct guest_memfd_luo_ser {
+	u64 size;
+	u64 flags;
+	u64 nr_folios;
+	u64 vm_token;
+	struct kho_vmalloc folios;
+} __packed;
+
+/* The compatibility string for GUEST_MEMFD file handler */
+#define GUEST_MEMFD_LUO_FH_COMPATIBLE	"guest_memfd_luo_v1"
+
 #endif /* _LINUX_KHO_ABI_KVM_H */
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index c1a962159264..d30fca094c42 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -13,4 +13,4 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
-kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/kvm_luo.o
+kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/guest_memfd_luo.o $(KVM)/kvm_luo.o
diff --git a/virt/kvm/guest_memfd_luo.c b/virt/kvm/guest_memfd_luo.c
new file mode 100644
index 000000000000..c0aa9354e0a7
--- /dev/null
+++ b/virt/kvm/guest_memfd_luo.c
@@ -0,0 +1,515 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Tarun Sahu <tarunsahu@google.com>
+ *
+ * Guestmemfd Preservation for Live Update Orchestrator (LUO)
+ */
+
+/**
+ * DOC: Guestmemfd Preservation via LUO
+ *
+ * Overview
+ * ========
+ *
+ * Guest memory file descriptors (guest_memfd) can be preserved over a kexec
+ * reboot using the Live Update Orchestrator (LUO) file preservation. This
+ * allows userspace to preserve VM memory across kexec reboots.
+ *
+ * The preservation is not intended to be transparent. Only select properties
+ * of the guest_memfd are preserved, while others are reset to default.
+ *
+ * Preserved Properties
+ * ====================
+ *
+ * The following properties of guest_memfd are preserved across kexec:
+ *
+ * File Size
+ *   The size of the file is preserved.
+ *
+ * File Contents
+ *   All folios present in the page cache are preserved.
+ *
+ * File-level Flags
+ *   The file-level flags (such as MMAP support and INIT_SHARED default mapping)
+ *   are preserved.
+ *
+ * Non-Preserved Properties
+ * ========================
+ *
+ * NUMA Memory Policy
+ *   NUMA memory policies associated with the guest_memfd are not preserved.
+ */
+#include <linux/liveupdate.h>
+#include <linux/kvm_host.h>
+#include <linux/pagemap.h>
+#include <linux/file.h>
+#include <linux/err.h>
+#include <linux/anon_inodes.h>
+#include <linux/magic.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/abi/kvm.h>
+#include "guest_memfd.h"
+#include "kvm_mm.h"
+
+
+static int kvm_gmem_luo_walk_folios(struct address_space *mapping,
+		pgoff_t end_index, struct guest_memfd_luo_folio_ser *folios_ser,
+		u64 *out_count)
+{
+	struct folio_batch fbatch;
+	pgoff_t index = 0;
+	u64 count = 0;
+	int err = 0;
+
+	folio_batch_init(&fbatch);
+	while (index < end_index) {
+		unsigned int nr, i;
+
+		nr = filemap_get_folios(mapping, &index, end_index - 1, &fbatch);
+		if (nr == 0)
+			break;
+
+		for (i = 0; i < nr; i++) {
+			struct folio *folio = fbatch.folios[i];
+
+			if (folios_ser) {
+				if (folio_test_hwpoison(folio)) {
+					err = -EHWPOISON;
+					folio_batch_release(&fbatch);
+					goto out;
+				}
+				err = kho_preserve_folio(folio);
+				if (err) {
+					folio_batch_release(&fbatch);
+					goto out;
+				}
+
+				folios_ser[count].pfn = folio_pfn(folio);
+				folios_ser[count].index = folio->index;
+				folios_ser[count].flags = folio_test_uptodate(folio) ?
+							  GUEST_MEMFD_LUO_FOLIO_UPTODATE : 0;
+			}
+			count++;
+		}
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+out:
+	*out_count = count;
+	return err;
+}
+
+static bool kvm_gmem_luo_can_preserve(struct liveupdate_file_handler *handler, struct file *file)
+{
+	struct inode *inode = file_inode(file);
+	struct gmem_file *gmem_file;
+	struct kvm *kvm;
+
+	if (inode->i_sb->s_magic != GUEST_MEMFD_MAGIC)
+		return false;
+
+	gmem_file = file->private_data;
+	if (!gmem_file)
+		return false;
+
+	/*
+	 * Only Fully-shared guest_memfd preservation is supported
+	 */
+	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
+		return false;
+
+	/*
+	 * It makes sure that no memory can be converted to private
+	 * even if it was initially fully shared (in-place conversions are
+	 * prevented).
+	 */
+	kvm = gmem_file->kvm;
+	if (kvm_arch_has_private_mem(kvm))
+		return false;
+
+	if (mapping_large_folio_support(inode->i_mapping))
+		return false;
+
+	return true;
+}
+
+static int kvm_gmem_luo_preserve(struct liveupdate_file_op_args *args)
+{
+	struct guest_memfd_luo_folio_ser *folios_ser = NULL;
+	u64 count = 0, gmem_flags, abi_flags = 0;
+	struct guest_memfd_luo_ser *ser;
+	struct address_space *mapping;
+	struct gmem_file *gmem_file;
+	struct inode *inode;
+	pgoff_t end_index;
+	struct kvm *kvm;
+	int err = 0;
+	long size, i;
+
+	inode = file_inode(args->file);
+	kvm_gmem_freeze(inode, true);
+
+	mapping = inode->i_mapping;
+	size = i_size_read(inode);
+	if (!size) {
+		err = -EINVAL;
+		goto err_unfreeze_inode;
+	}
+
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(size))) {
+		err = -EINVAL;
+		goto err_unfreeze_inode;
+	}
+
+	gmem_file = args->file->private_data;
+	kvm = gmem_file->kvm;
+
+	gmem_flags = READ_ONCE(GMEM_I(inode)->flags);
+	if (gmem_flags & ~(GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED
+				| GUEST_MEMFD_F_MAPPING_FROZEN)) {
+		err = -EOPNOTSUPP;
+		goto err_unfreeze_inode;
+	}
+
+	if (gmem_flags & GUEST_MEMFD_FLAG_MMAP)
+		abi_flags |= GUEST_MEMFD_LUO_FLAG_MMAP;
+	if (gmem_flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+		abi_flags |= GUEST_MEMFD_LUO_FLAG_INIT_SHARED;
+
+	end_index = size >> PAGE_SHIFT;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser)) {
+		err = PTR_ERR(ser);
+		goto err_unfreeze_inode;
+	}
+
+	/* First pass: Count the folios present in the page cache */
+	err = kvm_gmem_luo_walk_folios(mapping, end_index, NULL, &count);
+	if (err)
+		goto err_free_ser;
+
+	ser->size = size;
+	ser->flags = abi_flags;
+	ser->nr_folios = count;
+
+	/* VM Token will be set during the kvm_gmem_luo_freeze() */
+	ser->vm_token = 0;
+
+	if (count > 0) {
+		folios_ser = vcalloc(count, sizeof(*folios_ser));
+		if (!folios_ser) {
+			err = -ENOMEM;
+			goto err_free_ser;
+		}
+
+		/* Second pass: Fill the metadata array and preserve folios */
+		err = kvm_gmem_luo_walk_folios(mapping, end_index, folios_ser, &count);
+		if (err)
+			goto err_unpreserve_unlocked;
+
+		if (WARN_ON_ONCE(count != ser->nr_folios)) {
+			err = -EINVAL;
+			goto err_unpreserve_unlocked;
+		}
+	}
+
+	if (count > 0) {
+		err = kho_preserve_vmalloc(folios_ser, &ser->folios);
+		if (err)
+			goto err_unpreserve_unlocked;
+	}
+
+	args->serialized_data = virt_to_phys(ser);
+	args->private_data = folios_ser;
+
+	return 0;
+
+err_unpreserve_unlocked:
+	for (i = (long)count - 1; i >= 0; i--) {
+		struct folio *folio;
+
+		if (!folios_ser[i].pfn)
+			continue;
+
+		folio = pfn_folio(folios_ser[i].pfn);
+		kho_unpreserve_folio(folio);
+	}
+	vfree(folios_ser);
+err_free_ser:
+	kho_unpreserve_free(ser);
+err_unfreeze_inode:
+	kvm_gmem_freeze(inode, false);
+	return err;
+}
+
+static int kvm_gmem_luo_freeze(struct liveupdate_file_op_args *args)
+{
+	struct guest_memfd_luo_ser *ser;
+	struct gmem_file *gmem_file;
+	struct kvm *kvm;
+	struct file *kvm_file;
+	u64 vm_token;
+	int err;
+
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	gmem_file = args->file->private_data;
+	kvm = gmem_file->kvm;
+
+	/*
+	 * Obtain a strong reference to kvm->vm_file to prevent the SLAB_TYPESAFE_BY_RCU
+	 * file memory from being reallocated while it is being processed.
+	 */
+	kvm_file = get_file_active(&kvm->vm_file);
+	if (!kvm_file)
+		return -ENOENT;
+
+	err = liveupdate_get_token_outgoing(args->session, kvm_file, &vm_token);
+	fput(kvm_file);
+	if (err)
+		return err;
+
+	ser->vm_token = vm_token;
+	return 0;
+}
+
+static void kvm_gmem_luo_discard_folios(
+	const struct guest_memfd_luo_folio_ser *folios_ser,
+	u64 nr_folios, u64 start_idx)
+{
+	long i;
+
+	for (i = start_idx; i < nr_folios; i++) {
+		struct folio *folio;
+		phys_addr_t phys;
+
+		if (!folios_ser[i].pfn)
+			continue;
+
+		phys = PFN_PHYS(folios_ser[i].pfn);
+		folio = kho_restore_folio(phys);
+		if (folio)
+			folio_put(folio);
+	}
+}
+
+static void kvm_gmem_luo_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct guest_memfd_luo_folio_ser *folios_ser = args->private_data;
+	struct guest_memfd_luo_ser *ser;
+	long i;
+
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	if (ser->nr_folios > 0)
+		kho_unpreserve_vmalloc(&ser->folios);
+	for (i = ser->nr_folios - 1; i >= 0; i--) {
+		struct folio *folio;
+
+		if (!folios_ser[i].pfn)
+			continue;
+
+		folio = pfn_folio(folios_ser[i].pfn);
+		kho_unpreserve_folio(folio);
+	}
+	vfree(folios_ser);
+
+	kho_unpreserve_free(ser);
+	kvm_gmem_freeze(file_inode(args->file), false);
+}
+
+static int kvm_gmem_luo_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct guest_memfd_luo_folio_ser *folios_ser = NULL;
+	struct guest_memfd_luo_ser *ser;
+	struct kvm *kvm = NULL;
+	struct file *vm_file;
+	struct inode *inode;
+	struct file *file;
+	u64 gmem_flags = 0;
+	int err = 0;
+	u64 i = 0;
+
+	if (!args->serialized_data)
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	if (ser->size <= 0 || !PAGE_ALIGNED(ser->size)) {
+		err = -EINVAL;
+		goto err_free_ser;
+	}
+
+	if (ser->flags & ~GUEST_MEMFD_LUO_SUPPORTED_FLAGS) {
+		err = -EOPNOTSUPP;
+		goto err_free_ser;
+	}
+
+	if (ser->flags & GUEST_MEMFD_LUO_FLAG_MMAP)
+		gmem_flags |= GUEST_MEMFD_FLAG_MMAP;
+	if (ser->flags & GUEST_MEMFD_LUO_FLAG_INIT_SHARED)
+		gmem_flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	err = liveupdate_get_file_incoming(args->session, ser->vm_token, &vm_file);
+	if (err) {
+		pr_warn("gmem: provided VM FD token (%llx) on preserve is incorrect\n",
+						ser->vm_token);
+		goto err_free_ser;
+	}
+
+	if (file_is_kvm(vm_file))
+		kvm = vm_file->private_data;
+
+	/*
+	 * Release the temporary reference taken by the liveupdate_get_file_incoming
+	 * call. LUO still holds a reference.
+	 */
+	fput(vm_file);
+
+	if (!kvm) {
+		err = -EINVAL;
+		goto err_free_ser;
+	}
+
+	if (gmem_flags & ~kvm_gmem_get_supported_flags(kvm)) {
+		err = -EINVAL;
+		goto err_free_ser;
+	}
+
+	file = __kvm_gmem_create_file(kvm, ser->size, gmem_flags);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_free_ser;
+	}
+
+	inode = file_inode(file);
+
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (!folios_ser) {
+			err = -EINVAL;
+			goto err_destroy_file;
+		}
+
+		for (i = 0; i < ser->nr_folios; i++) {
+			struct folio *folio;
+			phys_addr_t phys;
+
+			if (!folios_ser[i].pfn)
+				continue;
+
+			phys = PFN_PHYS(folios_ser[i].pfn);
+			folio = kho_restore_folio(phys);
+			if (!folio) {
+				pr_err("gmem: failed to restore folio at %llx\n", phys);
+				err = -EIO;
+				goto err_put_remaining_folios;
+			}
+
+			err = filemap_add_folio(inode->i_mapping, folio, folios_ser[i].index,
+						GFP_KERNEL);
+			if (err) {
+				pr_err("gmem: failed to add folio to page cache\n");
+				folio_put(folio);
+				goto err_put_remaining_folios;
+			}
+
+			if (folios_ser[i].flags & GUEST_MEMFD_LUO_FOLIO_UPTODATE)
+				folio_mark_uptodate(folio);
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		vfree(folios_ser);
+	}
+
+	args->file = file;
+	kho_restore_free(ser);
+	return 0;
+
+err_put_remaining_folios:
+	i++;
+err_destroy_file:
+	fput(file);
+err_free_ser:
+	if (ser->nr_folios) {
+		if (!folios_ser)
+			folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (folios_ser) {
+			kvm_gmem_luo_discard_folios(folios_ser, ser->nr_folios, i);
+			vfree(folios_ser);
+		}
+	}
+	kho_restore_free(ser);
+	return err;
+}
+
+static void kvm_gmem_luo_finish(struct liveupdate_file_op_args *args)
+{
+	struct guest_memfd_luo_ser *ser;
+	struct guest_memfd_luo_folio_ser *folios_ser;
+
+	/* Nothing to be done here, if retrieve_status was successful or errored,
+	 * Cleanup is taken care of in retrieval call.
+	 */
+	if (args->retrieve_status)
+		return;
+
+	if (!args->serialized_data)
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (folios_ser) {
+			kvm_gmem_luo_discard_folios(folios_ser, ser->nr_folios, 0);
+			vfree(folios_ser);
+		}
+	}
+
+	kho_restore_free(ser);
+}
+
+static const struct liveupdate_file_ops kvm_gmem_luo_file_ops = {
+	.can_preserve = kvm_gmem_luo_can_preserve,
+	.preserve = kvm_gmem_luo_preserve,
+	.freeze = kvm_gmem_luo_freeze,
+	.retrieve = kvm_gmem_luo_retrieve,
+	.unpreserve = kvm_gmem_luo_unpreserve,
+	.finish = kvm_gmem_luo_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler kvm_gmem_luo_handler = {
+	.ops = &kvm_gmem_luo_file_ops,
+	.compatible = GUEST_MEMFD_LUO_FH_COMPATIBLE,
+};
+
+int kvm_gmem_luo_init(void)
+{
+	int err = liveupdate_register_file_handler(&kvm_gmem_luo_handler);
+
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register luo filesystem handler: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+
+void kvm_gmem_luo_exit(void)
+{
+	liveupdate_unregister_file_handler(&kvm_gmem_luo_handler);
+}
+
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9c3dd1afb05..e8e2f10cd71e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6581,6 +6581,10 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (r)
 		goto err_luo;
 
+	r = kvm_gmem_luo_init();
+	if (r)
+		goto err_gmem_luo;
+
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
@@ -6594,6 +6598,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	return 0;
 
 err_register:
+	kvm_gmem_luo_exit();
+err_gmem_luo:
 	kvm_luo_exit();
 err_luo:
 	kvm_uninit_virtualization();
@@ -6625,6 +6631,7 @@ void kvm_exit(void)
 	 */
 	misc_deregister(&kvm_dev);
 
+	kvm_gmem_luo_exit();
 	kvm_luo_exit();
 
 	kvm_uninit_virtualization();
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 87198715fb01..1295ff8bd504 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -103,9 +103,13 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 #ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
 int kvm_luo_init(void);
 void kvm_luo_exit(void);
+int kvm_gmem_luo_init(void);
+void kvm_gmem_luo_exit(void);
 #else
 static inline int kvm_luo_init(void) { return 0; }
 static inline void kvm_luo_exit(void) {}
+static inline int kvm_gmem_luo_init(void) { return 0; }
+static inline void kvm_gmem_luo_exit(void) {}
 #endif /* CONFIG_LIVEUPDATE_GUEST_MEMFD */
 
 #endif /* __KVM_MM_H__ */
-- 
2.55.0.229.g6434b31f56-goog

