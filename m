Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5590C4A4848
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 18:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791311569; cv=none; b=GcR0/idS+KTXTcGFydlo660cz4B4C9+IWoTbbiWT2eH+OqreDziWflo6UoobNHGXy+/1hIYgrHwrv5k/88oeXJCaEWLB2gDvggX3BEXRcOMNIGab0Rvi5Y9X2AvFMry0cR5NhXnhf5ASe80VoNJE4w8W/BVa+nnQvMDHX0TaW2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791311569; c=relaxed/simple;
	bh=t7GXCphLl7GcrZVUVEajd4jx5XAa+YOyDICyaEIeV/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sajhxI4bbztcdCuiLskJXP5Cf24SKbT067MoYngxrJZPSL5ywS9mFODceJFXSHJpZ53FV4G7SJ3r2i6Dq33svLX9OjxB+5t13ONtRt9TcFhRMlmoTz3/n1VX9LyN9r/2I/D8+GHNClP/TdCox7L29DCHHGFZUEtj+eCghaH99Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b+g1DMjE; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b+g1DMjE"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2e69aa07c3so466592166b.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Oct 2026 11:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311562; x=1791916362; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5boJG8VrsD7ZSz5TiXOa56IazFckHWotL6L1dCPt+Jk=;
        b=b+g1DMjEXFJdG2Xfz+ZD4i6ma/n+MfwaFCAn+5y2eOOtOpMoj4xKFNEobI6KRmQZxc
         nxsXCzAXmwBvMVrHq48Y8WScug++V/mlaMj2lujVB7XxLH2M37fDM3Ru4uiWUM8KbUuB
         kfDjvr0eDK6/MUx2kQnFfgvFFmMHO++O7Rh39pEkSdTmYIAVSdeqHU6gd57gvSLQq+uh
         jNPlKT0CT42ae2BqmG2R2UVfEs3P1e514D9Z3wUqbXmnbOFmA8ms01iBwN74KrdnE/Ss
         eMQK6AQWYuD5d3k8hG4ZFRZGuyflwYoipA0FwiSmPC5T4reMmZjypGuW9SRbVDRGVdpc
         x8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311562; x=1791916362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5boJG8VrsD7ZSz5TiXOa56IazFckHWotL6L1dCPt+Jk=;
        b=Jm+WZWNt1T7y99hJh/AKjp3uqGixfkrBImpYYVgEb47XC7tt822c5+KS5Z12VINkkD
         oVSs1g87U0uYw7R7ZRb+98CEWPG+3iHE88lN4XZ8DWQi7lyq/mb5KlulJ6/919Rcxa9q
         ERdhh21cAlhmMWAsS9NeF8SzqLQRaXvWrOXdz591Xp8Fwc2iNvbe+FimYDgJVGV8+yhy
         H+t31UpVqrJr7wuR/T5NpaKpHann1Yx3HrRdKgpu9AUZ0XcEcC+RO/zCkjbeLfpJ9GJ6
         pNw6fjXleBt9KuqKpI4tMEoMF6ha/lfwrl2CAoidejc18ZhQ/nRm9X1WfJIWJ3117bB+
         q7dg==
X-Forwarded-Encrypted: i=1; AKwUvBzJ0OVbvGS2YU7+JejllGQnmiF0tHMdSvdGJkNMtTUizN5ZsscK5KNpAcjyPDS5CLvRsih7GaM=@lists.linux.dev
X-Gm-Message-State: AFuF++kRPPZxBQa5+rnUolGUuW60PeMw2eJ4RbkhbogmulDaNr03zV3a
	40yRHgkLWU/fspjw3SVBP92WKkLwTIRFFCgUUNL59GMZ5BNcH4TTtJBk
X-Gm-Gg: AYBFou1/8wCjsTmyHEIj3rWNsRyi+a8JLiqeify7LxL+kMKZtlIZfYweHoOxUxsWns2
	r9rji28UbVWDlCIiSw9ukhyarMHG6V+rFVp676wUO/uS7gTwzvNea7ffBydyoCB6xFOA/tyy/e3
	Tqi9QXpz/V9PHlfXDFDugTIa61tUnfobotnEjGehzLOdcf/hjzAa6Lc6gdpHAdFQeejcChV9u72
	md7I6ytBfFXNAUYxSkyQqxyW5t2SH0oS03JuMI6NW2G6LojTj6XF5J6CbtlFRNm3fHnsgLNrZsp
	7LOMISqIB1CgUo//hYVnkiGVO7AVMNuzRFgHLHddfgobb2271ZWCGcX/S091bt1cl12hj7lsX3X
	HsCNMtquF2KE1DJj0pHz0CWdRp5mc7GrrdaCQ/MZcSN1L66FxinPgLN6LEU01y2eY2h84jtf4FH
	2fmdqNJHK7ntg8upnzBE8GLc9QQa7oFVNPfFnAKiu6kkSnPqVk8QbMWPEysNiADG11HZBWU8iIX
	4advdjponDjahIR+2rU+2ypsfWFhzPsVZ9dEKRG9iTflmzRaOf5FgPkzla1DGJ6j9hAUDRZBFuW
	dM+dhY4j73DXE4q8cDWlf8MytEwvR0jbB7/W1yQavBCaag==
X-Received: by 2002:a17:907:94d0:b0:c29:7953:6c06 with SMTP id a640c23a62f3a-c316a0be162mr212554166b.49.1791311561871;
        Tue, 06 Oct 2026 11:32:41 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:41 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
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
	Shuah Khan <shuah@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
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
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 3/9] KVM: guest_memfd: Add a memory provider backing
Date: Tue,  6 Oct 2026 18:32:29 +0000
Message-ID: <20261006183235.16576-4-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

A driver can back a guest_memfd today only by implementing
kvm_gmem_ops itself, and must then keep any device mapping of the same
memory consistent on its own.

Add GUEST_MEMFD_FLAG_USE_PROVIDER. KVM_CREATE_GUEST_MEMFD then takes a
memory provider file in provider_fd, which uses the first reserved word
and must be zero without the flag. Guest faults ask the provider for
each frame, and a revoke removes the range from the guest and from the
VMM's mapping. A page that is not backed, or that is not RAM, exits with
KVM_EXIT_MEMORY_FAULT. Read-only pages are mapped read only, and
fallocate() is not supported.

guest_memfd maps itself into userspace from the same frames, so that
a provider needs no fault handler. Pages marked NO_USER_MAP raise
SIGBUS there.

USE_PROVIDER requires GUEST_MEMFD_FLAG_MMAP, so that the memory slot
is gmem-only. An architecture opts in; x86 does so for VMs without
private or encrypted memory, and other architectures refuse the flag
for now. Native guest_memfd files now take the invalidate lock when
a file is added and when a closing file is unbound.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst                |  45 ++-
 arch/x86/kvm/x86.c                            |  10 +
 include/linux/kvm_host.h                      |   4 +
 include/uapi/linux/kvm.h                      |  11 +-
 tools/include/uapi/linux/kvm.h                |  11 +-
 .../testing/selftests/kvm/guest_memfd_test.c  |   6 +
 virt/kvm/Kconfig                              |   1 +
 virt/kvm/guest_memfd.c                        | 265 +++++++++++++++++-
 8 files changed, 338 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a5f9ee92f43e..d9aaf8a76b59 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6431,7 +6431,9 @@ and cannot be resized  (guest_memfd files do however support PUNCH_HOLE).
   struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	__s32 provider_fd;
+	__u32 pad;
+	__u64 reserved[5];
   };
 
 Conceptually, the inode backing a guest_memfd file represents physical memory,
@@ -6453,15 +6455,38 @@ a single guest_memfd file, but the bound ranges must not overlap).
 The capability KVM_CAP_GUEST_MEMFD_FLAGS enumerates the `flags` that can be
 specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
 
-  ============================ ================================================
-  GUEST_MEMFD_FLAG_MMAP        Enable using mmap() on the guest_memfd file
-                               descriptor.
-  GUEST_MEMFD_FLAG_INIT_SHARED Make all memory in the file shared during
-                               KVM_CREATE_GUEST_MEMFD (memory files created
-                               without INIT_SHARED will be marked private).
-                               Shared memory can be faulted into host userspace
-                               page tables. Private memory cannot.
-  ============================ ================================================
+  ============================= ================================================
+  GUEST_MEMFD_FLAG_MMAP         Enable using mmap() on the guest_memfd file
+                                descriptor.
+  GUEST_MEMFD_FLAG_INIT_SHARED  Make all memory in the file shared during
+                                KVM_CREATE_GUEST_MEMFD (memory files created
+                                without INIT_SHARED will be marked private).
+                                Shared memory can be faulted into host userspace
+                                page tables. Private memory cannot.
+  GUEST_MEMFD_FLAG_USE_PROVIDER Take the memory of the file from the memory
+                                provider behind `provider_fd`, instead of
+                                allocating it.  Requires
+                                GUEST_MEMFD_FLAG_MMAP.  Not supported for VMs
+                                with private or encrypted memory.
+  ============================= ================================================
+
+`pad` must be zero.  With GUEST_MEMFD_FLAG_USE_PROVIDER, `provider_fd` is a file
+handed out by a memory provider (see include/linux/mem_provider.h); without it,
+`provider_fd` must be zero.
+The provider decides which pages exist and what backs them, and can change
+this at any time.  The guest and any host mapping of the guest_memfd follow
+the change.  A guest access to a page that the provider does not back exits
+to userspace with KVM_EXIT_MEMORY_FAULT, and so does an access to a page that
+is not RAM.  A page that the provider marks read only is mapped read only for
+the guest.  fallocate() is not supported.  Only x86 VMs of type
+KVM_X86_DEFAULT_VM support GUEST_MEMFD_FLAG_USE_PROVIDER.
+
+mmap() of the guest_memfd maps the provider's pages into userspace on fault.
+An access raises SIGBUS if the provider does not back the page, if the page is
+not RAM, if the provider marks it as not to be mapped into userspace, or if it
+is a write to a read-only page.
+KVM's own accesses through the memslot's userspace address fail in the same
+cases.
 
 When the KVM MMU performs a PFN lookup to service a guest fault and the backing
 guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index afcac1042947..3669316f5712 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14124,6 +14124,16 @@ bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return !kvm_arch_has_private_mem(kvm);
 }
 
+/*
+ * Only VMs without encrypted memory: SEV and SEV-ES guests have no private
+ * memory in KVM's sense, but their memory would need reclaiming when a
+ * provider takes it back.
+ */
+bool kvm_arch_gmem_supports_provider(struct kvm *kvm)
+{
+	return !kvm || kvm->arch.vm_type == KVM_X86_DEFAULT_VM;
+}
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7281d0e94121..3ea591642542 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -832,11 +832,15 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
+bool kvm_arch_gmem_supports_provider(struct kvm *kvm);
 
 static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 {
 	u64 flags = GUEST_MEMFD_FLAG_MMAP;
 
+	if (kvm_arch_gmem_supports_provider(kvm))
+		flags |= GUEST_MEMFD_FLAG_USE_PROVIDER;
+
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
 		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8..820448f82e22 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1654,11 +1654,20 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_USE_PROVIDER	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	/*
+	 * With GUEST_MEMFD_FLAG_USE_PROVIDER: a memory provider file whose
+	 * pages back this guest_memfd.  The provider may take
+	 * any range back at any time; the guest and every host mapping of
+	 * this guest_memfd follow.  Must be 0 otherwise.
+	 */
+	__s32 provider_fd;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index d0c0c8605976..0f4d1dd0e931 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1644,11 +1644,20 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_USE_PROVIDER	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	/*
+	 * With GUEST_MEMFD_FLAG_USE_PROVIDER: a memory provider file whose
+	 * pages back this guest_memfd.  The provider may take
+	 * any range back at any time; the guest and every host mapping of
+	 * this guest_memfd follow.  Must be 0 otherwise.
+	 */
+	__s32 provider_fd;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 2233d871a38f..91ff10ac6274 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -405,6 +405,12 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 
 	for (flag = BIT(0); flag; flag <<= 1) {
 		fd = __vm_create_guest_memfd(vm, page_size, flag);
+		/* USE_PROVIDER also needs MMAP and a provider file. */
+		if (flag == GUEST_MEMFD_FLAG_USE_PROVIDER && (flag & valid_flags)) {
+			TEST_ASSERT(fd < 0 && errno == EINVAL,
+				    "guest_memfd() with USE_PROVIDER alone should fail with EINVAL");
+			continue;
+		}
 		if (flag & valid_flags) {
 			TEST_ASSERT(fd >= 0,
 				    "guest_memfd() with flag '0x%lx' should succeed",
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 794976b88c6f..cfb6c4e51128 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -105,6 +105,7 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES
 
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
+       select MEM_PROVIDER
        bool
 
 config HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a509f1a96c0b..aedd8630e3ea 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -4,6 +4,7 @@
 #include <linux/falloc.h>
 #include <linux/fs.h>
 #include <linux/kvm_host.h>
+#include <linux/mem_provider.h>
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
@@ -44,6 +45,9 @@ struct gmem_inode {
 	struct list_head gmem_file_list;
 
 	u64 flags;
+
+	/* The provider of the pages, with GUEST_MEMFD_FLAG_USE_PROVIDER. */
+	struct mem_provider_attachment att;
 };
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
@@ -654,7 +658,222 @@ static const struct kvm_gmem_ops kvm_gmem_native_ops = {
 	.fallocate = kvm_gmem_native_fallocate,
 };
 
-static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
+/*
+ * Can @kvm use a memory provider?  @kvm is NULL for the system-wide capability.
+ * An architecture opts in by overriding this.  VMs whose memory is private or
+ * encrypted are not supported: each frame would need preparing before use and
+ * reclaiming when the provider takes it back.
+ */
+bool __weak kvm_arch_gmem_supports_provider(struct kvm *kvm)
+{
+	return false;
+}
+
+/*
+ * A guest_memfd backed by a memory provider (include/linux/mem_provider.h).
+ *
+ * The provider owns the frames, and guest_memfd keeps no state for them.  A
+ * guest fault asks the provider for the frame each time.  A fault that
+ * races with a change in the provider is retried by KVM, because the
+ * provider revokes the range after the change and the revoke opens and
+ * closes KVM's invalidation window.  Host mappings are made by guest_memfd
+ * from the same frames and attributes, and removed by the revoke.
+ *
+ * Bindings and release are the same as for the native guest_memfd.
+ */
+static void kvm_gmem_provider_revoke(struct mem_provider_attachment *att,
+				     loff_t offset, loff_t len)
+{
+	struct gmem_inode *gi = container_of(att, struct gmem_inode, att);
+	struct inode *inode = &gi->vfs_inode;
+	pgoff_t start, end;
+	struct gmem_file *f;
+
+	if (offset >= att->size)
+		return;
+	len = min(len, att->size - offset);
+	start = offset >> PAGE_SHIFT;
+	end = DIV_ROUND_UP(offset + len, PAGE_SIZE);
+
+	/*
+	 * The bindings must be stable so that each start is matched by an
+	 * end.  Only VMs without private memory use a provider, but remove
+	 * both kinds of mapping so that none is missed.
+	 */
+	filemap_invalidate_lock(inode->i_mapping);
+	kvm_gmem_for_each_file(f, inode)
+		__kvm_gmem_invalidate_start(f, start, end,
+					    KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
+	unmap_mapping_range(inode->i_mapping, (loff_t)start << PAGE_SHIFT,
+			    (loff_t)(end - start) << PAGE_SHIFT, 1);
+	kvm_gmem_for_each_file(f, inode)
+		__kvm_gmem_invalidate_end(f, start, end);
+	filemap_invalidate_unlock(inode->i_mapping);
+}
+
+static int kvm_gmem_provider_get_pfn(struct file *file, struct kvm *kvm,
+				     struct kvm_memory_slot *slot, gfn_t gfn,
+				     kvm_pfn_t *pfn, struct page **page,
+				     int *max_order, bool *writable)
+{
+	struct gmem_inode *gi = GMEM_I(file_inode(file));
+	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	unsigned long frame;
+	int order, ret;
+	u32 attrs;
+
+	if (file != READ_ONCE(slot->gmem.file))
+		return -EFAULT;
+	if (xa_load(&gmem_file_of(file)->bindings, index) != slot)
+		return -EIO;
+
+	/* A large mapping needs the block aligned in both index and gfn. */
+	order = PUD_ORDER;
+	if (index != gfn)
+		order = min_t(int, order, __ffs(index ^ gfn));
+
+	ret = mem_provider_get_page(&gi->att, index, &frame, &order, &attrs);
+	if (ret)
+		return ret;
+
+	/*
+	 * KVM decides the guest's memory type itself, so accept RAM only.
+	 * -EFAULT, so that the VMM gets a memory fault exit for the access.
+	 */
+	if (mem_provider_type(attrs) != MEM_PROVIDER_TYPE_RAM)
+		return -EFAULT;
+
+	if (attrs & MEM_PROVIDER_ATTR_READONLY) {
+		if (!writable)
+			return -EPERM;
+		*writable = false;
+	}
+
+	*pfn = frame;
+	if (max_order)
+		*max_order = order;
+	return 0;
+}
+
+/* The protection for a host mapping of a frame with @attrs. */
+static pgprot_t kvm_gmem_provider_prot(struct vm_area_struct *vma, u32 attrs)
+{
+	vm_flags_t flags = vma->vm_flags;
+
+	if (attrs & MEM_PROVIDER_ATTR_READONLY)
+		flags &= ~VM_WRITE;
+	return vm_get_page_prot(flags);
+}
+
+/*
+ * Map page @vmf->pgoff of a provider-backed guest_memfd for the host.
+ *
+ * The invalidate lock is held shared across get_page() and the insert, and
+ * a revoke holds it exclusive while it unmaps the range, so a frame is never
+ * mapped after the revoke that removes it.  A writable page is mapped
+ * writable, and a read-only page without write permission.  With @mkwrite,
+ * the PTE is read only and the write must be checked: replace it under the
+ * lock, so that a change to read only cannot slip between the check and the
+ * upgrade.
+ */
+static vm_fault_t kvm_gmem_provider_map_host(struct vm_fault *vmf, bool mkwrite)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct inode *inode = file_inode(vma->vm_file);
+	unsigned long uaddr = vmf->address & PAGE_MASK;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	unsigned long pfn;
+	int order = 0;
+	vm_fault_t ret;
+	u32 attrs;
+
+	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
+		return VM_FAULT_SIGBUS;
+
+	filemap_invalidate_lock_shared(inode->i_mapping);
+	if (mem_provider_get_page(&GMEM_I(inode)->att, vmf->pgoff, &pfn,
+				  &order, &attrs)) {
+		ret = VM_FAULT_SIGBUS;
+	} else if (mem_provider_type(attrs) != MEM_PROVIDER_TYPE_RAM ||
+		   (attrs & MEM_PROVIDER_ATTR_NO_USER_MAP) ||
+		   (write && (attrs & MEM_PROVIDER_ATTR_READONLY))) {
+		ret = VM_FAULT_SIGBUS;
+	} else {
+		if (mkwrite)
+			zap_special_vma_range(vma, uaddr, PAGE_SIZE);
+		ret = vmf_insert_pfn_prot(vma, uaddr, pfn,
+					  kvm_gmem_provider_prot(vma, attrs));
+	}
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+	return ret;
+}
+
+static vm_fault_t kvm_gmem_provider_fault(struct vm_fault *vmf)
+{
+	return kvm_gmem_provider_map_host(vmf, false);
+}
+
+/* A write to a page that a read fault, or mprotect(), left read only. */
+static vm_fault_t kvm_gmem_provider_pfn_mkwrite(struct vm_fault *vmf)
+{
+	return kvm_gmem_provider_map_host(vmf, true);
+}
+
+static const struct vm_operations_struct kvm_gmem_provider_vm_ops = {
+	.fault		= kvm_gmem_provider_fault,
+	.pfn_mkwrite	= kvm_gmem_provider_pfn_mkwrite,
+};
+
+static int kvm_gmem_provider_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *inode = file_inode(file);
+	pgoff_t npages = i_size_read(inode) >> PAGE_SHIFT;
+
+	if (!kvm_gmem_supports_mmap(inode))
+		return -ENODEV;
+
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
+	    (VM_SHARED | VM_MAYSHARE))
+		return -EINVAL;
+
+	if (vma->vm_pgoff >= npages || vma_pages(vma) > npages - vma->vm_pgoff)
+		return -EINVAL;
+
+	/*
+	 * The frames may have no struct page.  They are inserted on fault, so
+	 * that a range that is revoked and comes back is reached again.
+	 */
+	vm_flags_set(vma, VM_PFNMAP | VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
+	vma->vm_ops = &kvm_gmem_provider_vm_ops;
+	return 0;
+}
+
+static const struct kvm_gmem_ops kvm_gmem_provider_ops = {
+	.bind    = kvm_gmem_native_bind,
+	.unbind  = kvm_gmem_native_unbind,
+	.get_pfn = kvm_gmem_provider_get_pfn,
+	.release = kvm_gmem_native_release,
+	.mmap    = kvm_gmem_provider_mmap,
+	/* The provider decides which pages exist: no fallocate(). */
+};
+
+static int kvm_gmem_provider_attach(struct inode *inode, int provider_fd)
+{
+	struct file *file;
+	int ret;
+
+	file = fget(provider_fd);
+	if (!file)
+		return -EBADF;
+
+	ret = mem_provider_attach(&GMEM_I(inode)->att, file,
+				  i_size_read(inode), kvm_gmem_provider_revoke);
+	fput(file);
+	return ret;
+}
+
+static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags,
+			     int provider_fd)
 {
 	static const char *name = "[kvm-gmem]";
 	struct gmem_file *f;
@@ -695,6 +914,12 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 
 	GMEM_I(inode)->flags = flags;
 
+	if (flags & GUEST_MEMFD_FLAG_USE_PROVIDER) {
+		err = kvm_gmem_provider_attach(inode, provider_fd);
+		if (err)
+			goto err_inode;
+	}
+
 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
@@ -703,12 +928,18 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 
 	file->f_flags |= O_LARGEFILE;
 	file->private_data = &f->backing;
-	f->backing.ops = &kvm_gmem_native_ops;
+	if (flags & GUEST_MEMFD_FLAG_USE_PROVIDER)
+		f->backing.ops = &kvm_gmem_provider_ops;
+	else
+		f->backing.ops = &kvm_gmem_native_ops;
 
 	kvm_get_kvm(kvm);
 	f->kvm = kvm;
 	xa_init(&f->bindings);
+	/* A provider can revoke, and walk the list, as soon as it is attached. */
+	filemap_invalidate_lock(inode->i_mapping);
 	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
+	filemap_invalidate_unlock(inode->i_mapping);
 
 	fd_install(fd, file);
 	return fd;
@@ -735,7 +966,20 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	if (size <= 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
-	return __kvm_gmem_create(kvm, size, flags);
+	if (args->pad ||
+	    (!(flags & GUEST_MEMFD_FLAG_USE_PROVIDER) && args->provider_fd))
+		return -EINVAL;
+
+	/*
+	 * Without MMAP the memslot is not gmem-only, and a VM without private
+	 * memory would fault through the slot's userspace address instead of
+	 * the provider.
+	 */
+	if ((flags & GUEST_MEMFD_FLAG_USE_PROVIDER) &&
+	    !(flags & GUEST_MEMFD_FLAG_MMAP))
+		return -EINVAL;
+
+	return __kvm_gmem_create(kvm, size, flags, args->provider_fd);
 }
 
 /*
@@ -911,9 +1155,14 @@ static void kvm_gmem_native_unbind(struct file *slot_file, struct kvm *kvm,
 	 * bindings.  I.e. reaching this point means kvm_gmem_release() hasn't
 	 * yet destroyed the bindings or freed the gmem_file, and can't do so
 	 * until the caller drops slots_lock.
+	 *
+	 * A memory provider can still revoke, and walk the bindings, until
+	 * the inode is evicted, so take the invalidate lock in this case too.
 	 */
 	if (!file) {
+		filemap_invalidate_lock(slot_file->f_mapping);
 		__kvm_gmem_unbind(slot, gmem_file_of(slot_file));
+		filemap_invalidate_unlock(slot_file->f_mapping);
 		return;
 	}
 
@@ -1219,6 +1468,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	mpol_shared_policy_init(&gi->policy, NULL);
 
 	gi->flags = 0;
+	gi->att.ops = NULL;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
@@ -1233,10 +1483,19 @@ static void kvm_gmem_free_inode(struct inode *inode)
 	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
 }
 
+static void kvm_gmem_evict_inode(struct inode *inode)
+{
+	/* Every file is closed, so nothing maps the provider's frames. */
+	mem_provider_detach(&GMEM_I(inode)->att);
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+}
+
 static const struct super_operations kvm_gmem_super_operations = {
 	.statfs		= simple_statfs,
 	.alloc_inode	= kvm_gmem_alloc_inode,
 	.destroy_inode	= kvm_gmem_destroy_inode,
+	.evict_inode	= kvm_gmem_evict_inode,
 	.free_inode	= kvm_gmem_free_inode,
 };
 
