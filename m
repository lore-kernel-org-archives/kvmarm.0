Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF144DEC3F
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 09:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791970670; cv=none; b=mPcwvIODVAN8Rx7kCmUU5j09S77xOptI3bBTaJRdZ0JMVNG/pkeXLD7o4OyW0Cj1zWm2vuWMYdBVLNcrU3yZH5kx5xR8Wp/fQpBaJzs78hyaEroULrKxFtF1b3waJV9wgl69wqwNOAcsY4GaJAp9+8xoCY3OPHpIANxLH4lGcos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791970670; c=relaxed/simple;
	bh=GSTkZHTxdgCWNjcCpuVHNLDyv/lElmtfkosENMeU0eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tScwgLH4C537lOhlON7R/AlOn+33Pwub4QalDOFTfKTFpFR4nT+g1QFRP3q8l7Xbd7u3/1H3a26H5ZBndafsQRWipn57zy6pbET5jPxpg+cOTMrled+uSZ1u6amkSBhPpWgak+y1zjncrWEszWMGX78zhRHMmJGrfFRqPGYcuYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LUU8DsZ5; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUU8DsZ5"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48b0584ad71so2267101f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 02:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791970661; x=1792575461; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YnixE7YDNRpivB1UU4iI/IX+KTEZR1IaHnjZrRIVebw=;
        b=LUU8DsZ5Lgv2xmJqiuFHHo817EnHcs4sG37bBL/01sUFos4mVq60yoXXRwm/vs9/ms
         ZkJvOqR2dE/Bb9qNyXkaSn29XKBjnosKZWpUzc5Y7FI5J5qnyn39y3vNrccrt4q7rA4L
         KPeVzujVLj53cm7oLG4viOqtvIZ6X3fxxTVzLyTIfuxiT9WrIMBNhisb8+S9HyX92jDe
         hQ/ZBDUU7gfyT9gT7O/KxtLwifXmdJ2v5J+GxY4ZPCRfE4xWuTTOTofo8aEAtRCqZ/k9
         UPaH0T0ixtce6qUkgArAtcTOTsivsoEae+V69SwkBMPEZlTQf4wlO9WoMNycHJBearlm
         v2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970661; x=1792575461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YnixE7YDNRpivB1UU4iI/IX+KTEZR1IaHnjZrRIVebw=;
        b=iLf3seHRrfgEepcN4RRkTTA2FnOImElWjRU2PP4AvRF+E7HP21LRSGqL04o/ZEhybt
         wKgInQ1SugUD2quiJ4wAwwDkM2T7tkIaszHiQuosI1oFIEh9lGgLzKocAlJLIKB0oRgW
         hEwNyKoDTzcJpgtUFeUU/cnxCENS2T788zN3JbAHYwsXj+7I4mfyNkuBycrXmT0chr6x
         6RbGoksb3Ah+GBvcl9dxZHtyxCwwYaBEdKIjdFBzj3QY5dlKpRw/FiBxzyIn1/nbvfIs
         oxtx+vtJhUB2j459S8D9bto86FNKAcq2IcDawfAtPMMDrSDYjS1aivB9MtdPkf3SPcgb
         8JeA==
X-Forwarded-Encrypted: i=1; AKwUvBxeW2X0JTS8//LM3B8q0YhEZsLUr5FShP1ckcL7SHmKot3rT7HmlXXn2y3pKAtMKImaGlkF9Ss=@lists.linux.dev
X-Gm-Message-State: AFq9FYKzVMspD/Qv6WKTaSDxH8GlPQzjBWnUJTLVDScI5c+PK1trRXUW
	C7xzyz2ZhAT0/FrtDpS/Wb+hqUrGEJJlWs4T/wiYoucBTYRvAJ3Whm1w
X-Gm-Gg: AYBFou3toULD3BuSrx8CqSdBQW4wmRn/EIpTnW92+azH34o8fgurjMy/jwooDIx18Gk
	i6r3alVluzwtQKCyHMXJl/erKKz47H0dXAyt60LTGEAaVHAc6TAWmhGHjC/X8RAcSc9z9rU4odP
	zv+nReo81608xjM2cBuG6UNSztDC4uDR3KJWjXcWkMsM50YtFQ/9uZdKPCX8xCGy2D080zfx7fH
	8le0CtKM4oSnROqVwU1KEnTd7WU8fZroH1ZWdyysz1+krVtmUeeYS/ikoxxibW0azgtrneYMa+9
	8dmhMznkmcweBXtWGqx+SBy/5Rhb6/NpWgpYnYYsOpwN/VRdBZ42NVzjYju4MOk3tot6IF04zhd
	tWK/4/WnP6UH1HVB9KZIARyHOyDT9QiWR+oaMhB9PoX6b37ZNygFyanL1K4FcpBOGN2Ib1g9IT6
	T3fipMz+OxoMpl+oFn1QDkBBrobzaQhl8OmAkq+/IQDTs322r0ZOP5pa/UpLZzZ4IaOR957S8Ql
	eBpPm5e4JfNzkVfbwm3j+bi/MQ6SzSj5rSv/5wBL9wgvxyPWIIjxe0voj+MVUy2oCnX3/E8AdFF
	yCW0n4CZkOWNU90c04V82dIteaWth4LrF2A=
X-Received: by 2002:a05:6000:4312:b0:487:27f6:a4e4 with SMTP id ffacd0b85a97d-48dbad489d1mr28539959f8f.52.1791970661017;
        Wed, 14 Oct 2026 02:37:41 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de3f7f8b8sm9365477f8f.35.2026.10.14.02.37.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:37:40 -0700 (PDT)
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
Subject: [RFC PATCH v2 04/11] KVM: guest_memfd: Add a memory provider backing
Date: Wed, 14 Oct 2026 09:37:26 +0000
Message-ID: <20261014093733.90312-5-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014093733.90312-1-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
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

Add GUEST_MEMFD_FLAG_USE_RESOURCE and resource_fd, as defined in
Ackerley Tng's resource pool RFC [1], so that both series share one
flag and one field. resource_fd uses the first reserved word and must
be zero without the flag. guest_memfd picks the backing from the kind
of file: for now only memory provider files are accepted, and any
other file fails with -EOPNOTSUPP.

Guest faults ask the provider for each frame, and a revoke removes the
range from the guest and from the VMM's mapping. A guest access to a
page that is not backed, or not RAM, exits with KVM_EXIT_MEMORY_FAULT.
Read-only pages are mapped read only, and fallocate() is not supported.

guest_memfd maps itself into userspace from the same frames, so that
a provider needs no fault handler. Pages marked NO_USER_MAP raise
SIGBUS there.

USE_RESOURCE requires GUEST_MEMFD_FLAG_MMAP, so that the memory slot is
gmem-only. An architecture opts in; x86 does so for VMs of the default
type, which have no private memory, and other architectures refuse the
flag for now.

A legacy SEV or SEV-ES guest, set up with KVM_SEV_INIT, is also a VM of
the default type. Its writes can leave encrypted dirty cache lines for
the frames it used, and their later write-back would corrupt a frame
that the provider has given to another owner. A revoke therefore writes
back the guest's caches before it returns, as the mmu notifiers do when
they zap guest memory. Closing the file does the same, while a revoke
can still find the file: the VMM may close it before deleting the
memory slot, and a later revoke would then find no file to flush.

Native guest_memfd files now take the invalidate lock when a file is
added and when a closing file is unbound, because a revoke walks the
file list and the bindings under it.

[1] https://lore.kernel.org/all/20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com/

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst                |  46 ++-
 arch/x86/kvm/x86.c                            |   9 +
 include/linux/kvm_host.h                      |   4 +
 include/uapi/linux/kvm.h                      |  11 +-
 tools/include/uapi/linux/kvm.h                |  11 +-
 .../testing/selftests/kvm/guest_memfd_test.c  |  15 +
 virt/kvm/Kconfig                              |   1 +
 virt/kvm/guest_memfd.c                        | 299 +++++++++++++++++-
 8 files changed, 380 insertions(+), 16 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a5f9ee92f43e..215088364102 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6431,7 +6431,9 @@ and cannot be resized  (guest_memfd files do however support PUNCH_HOLE).
   struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	__s32 resource_fd;
+	__u32 pad;
+	__u64 reserved[5];
   };
 
 Conceptually, the inode backing a guest_memfd file represents physical memory,
@@ -6453,15 +6455,39 @@ a single guest_memfd file, but the bound ranges must not overlap).
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
+  GUEST_MEMFD_FLAG_USE_RESOURCE Take the memory of the file from the resource
+                                behind `resource_fd`, instead of allocating
+                                it.  Requires GUEST_MEMFD_FLAG_MMAP.  Not
+                                supported for VMs with private memory.
+  ============================= ================================================
+
+`pad` must be zero.  Without GUEST_MEMFD_FLAG_USE_RESOURCE, `resource_fd` must
+be zero.  With it, `resource_fd` is the file whose memory backs the guest_memfd.
+The only kind of resource supported so far is a file handed out by a memory
+provider (see include/linux/mem_provider.h); any other file fails with
+EOPNOTSUPP.
+The provider decides which pages exist and what backs them, and can change
+this at any time.  The guest and any host mapping of the guest_memfd follow
+the change.  A guest access to a page that the provider does not back exits
+to userspace with KVM_EXIT_MEMORY_FAULT, and so does an access to a page that
+is not RAM.  A page that the provider marks read only is mapped read only for
+the guest.  fallocate() is not supported.  Only x86 VMs of type
+KVM_X86_DEFAULT_VM support GUEST_MEMFD_FLAG_USE_RESOURCE.
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
index afcac1042947..99b55b4e1ca4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14124,6 +14124,15 @@ bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return !kvm_arch_has_private_mem(kvm);
 }
 
+/*
+ * Only VMs of the default type, which have no private memory.  A legacy SEV
+ * guest is one of them; a revoke, and closing the file, write back its caches.
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
index a15abd0f7fb7..b9c0b4271945 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -823,11 +823,15 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
+bool kvm_arch_gmem_supports_provider(struct kvm *kvm);
 
 static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 {
 	u64 flags = GUEST_MEMFD_FLAG_MMAP;
 
+	if (kvm_arch_gmem_supports_provider(kvm))
+		flags |= GUEST_MEMFD_FLAG_USE_RESOURCE;
+
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
 		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8..4ad81d17f21d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1654,11 +1654,20 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_USE_RESOURCE	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	/*
+	 * With GUEST_MEMFD_FLAG_USE_RESOURCE: the file whose memory backs
+	 * this guest_memfd, for now a memory provider file.  The provider
+	 * may take any range back at any time; the guest and every host
+	 * mapping of this guest_memfd follow.  Must be 0 otherwise.
+	 */
+	__s32 resource_fd;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index d0c0c8605976..18841962a4e8 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1644,11 +1644,20 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_USE_RESOURCE	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	/*
+	 * With GUEST_MEMFD_FLAG_USE_RESOURCE: the file whose memory backs
+	 * this guest_memfd, for now a memory provider file.  The provider
+	 * may take any range back at any time; the guest and every host
+	 * mapping of this guest_memfd follow.  Must be 0 otherwise.
+	 */
+	__s32 resource_fd;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 2233d871a38f..9c8afe904b1e 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -405,6 +405,21 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 
 	for (flag = BIT(0); flag; flag <<= 1) {
 		fd = __vm_create_guest_memfd(vm, page_size, flag);
+		/* USE_RESOURCE also needs MMAP and a provider file. */
+		if (flag == GUEST_MEMFD_FLAG_USE_RESOURCE && (flag & valid_flags)) {
+			struct kvm_create_guest_memfd args = {
+				.size = page_size,
+				.flags = GUEST_MEMFD_FLAG_MMAP | flag,
+				.resource_fd = vm->fd,
+			};
+
+			TEST_ASSERT(fd < 0 && errno == EINVAL,
+				    "guest_memfd() with USE_RESOURCE alone should fail with EINVAL");
+			fd = __vm_ioctl(vm, KVM_CREATE_GUEST_MEMFD, &args);
+			TEST_ASSERT(fd < 0 && errno == EOPNOTSUPP,
+				    "guest_memfd() with a resource that is not a provider should fail with EOPNOTSUPP");
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
index c9595cc9d56e..742147303459 100644
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
+	/* The provider of the pages, with GUEST_MEMFD_FLAG_USE_RESOURCE. */
+	struct mem_provider_attachment att;
 };
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
@@ -331,7 +335,11 @@ static long kvm_gmem_native_fallocate(struct file *file, int mode, loff_t offset
 	return ret;
 }
 
-static void kvm_gmem_native_release(struct file *file)
+/*
+ * @reclaim: write back the guest's caches once it has lost the frames, before
+ * the file leaves the list that a revoke walks (see kvm_gmem_provider_revoke()).
+ */
+static void __kvm_gmem_release(struct file *file, bool reclaim)
 {
 	struct inode *inode = file_inode(file);
 	struct gmem_file *f = gmem_file_of(file);
@@ -367,6 +375,8 @@ static void kvm_gmem_native_release(struct file *file)
 	__kvm_gmem_invalidate_start(f, 0, -1ul,
 				    kvm_gmem_get_invalidate_filter(inode));
 	__kvm_gmem_invalidate_end(f, 0, -1ul);
+	if (reclaim)
+		kvm_arch_guest_memory_reclaimed(kvm);
 
 	list_del(&f->entry);
 
@@ -381,6 +391,11 @@ static void kvm_gmem_native_release(struct file *file)
 
 }
 
+static void kvm_gmem_native_release(struct file *file)
+{
+	__kvm_gmem_release(file, false);
+}
+
 static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 {
 	/*
@@ -654,7 +669,243 @@ static const struct kvm_gmem_ops kvm_gmem_native_ops = {
 	.fallocate = kvm_gmem_native_fallocate,
 };
 
-static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
+/*
+ * Can @kvm use a memory provider?  @kvm is NULL for the system-wide capability.
+ * An architecture opts in by overriding this.  VMs with private memory are not
+ * supported: each frame would need preparing before use.
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
+	/*
+	 * The provider may give the frames to someone else once this returns.
+	 * A legacy SEV guest is a VM of the default type, and may have written
+	 * them with its key: write its caches back, as the mmu notifiers do.
+	 */
+	kvm_gmem_for_each_file(f, inode)
+		kvm_arch_guest_memory_reclaimed(f->kvm);
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
+/*
+ * Once the file is closed, a revoke no longer finds it and cannot write back
+ * the guest's caches, so write them back on release, while a revoke would
+ * still find the file.
+ */
+static void kvm_gmem_provider_release(struct file *file)
+{
+	__kvm_gmem_release(file, true);
+}
+
+static const struct kvm_gmem_ops kvm_gmem_provider_ops = {
+	.bind    = kvm_gmem_native_bind,
+	.unbind  = kvm_gmem_native_unbind,
+	.get_pfn = kvm_gmem_provider_get_pfn,
+	.release = kvm_gmem_provider_release,
+	.mmap    = kvm_gmem_provider_mmap,
+	/* The provider decides which pages exist: no fallocate(). */
+};
+
+static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
+{
+	struct file *file;
+	int ret;
+
+	file = fget(resource_fd);
+	if (!file)
+		return -EBADF;
+
+	/* Memory provider files are the only resource supported so far. */
+	if (file->f_op->fop_flags & FOP_MEM_PROVIDER)
+		ret = mem_provider_attach(&GMEM_I(inode)->att, file,
+					  i_size_read(inode),
+					  kvm_gmem_provider_revoke);
+	else
+		ret = -EOPNOTSUPP;
+	fput(file);
+	return ret;
+}
+
+static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags,
+			     int resource_fd)
 {
 	static const char *name = "[kvm-gmem]";
 	struct gmem_file *f;
@@ -695,6 +946,12 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 
 	GMEM_I(inode)->flags = flags;
 
+	if (flags & GUEST_MEMFD_FLAG_USE_RESOURCE) {
+		err = kvm_gmem_attach_resource(inode, resource_fd);
+		if (err)
+			goto err_inode;
+	}
+
 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
@@ -703,12 +960,18 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 
 	file->f_flags |= O_LARGEFILE;
 	file->private_data = &f->backing;
-	f->backing.ops = &kvm_gmem_native_ops;
+	if (flags & GUEST_MEMFD_FLAG_USE_RESOURCE)
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
@@ -735,7 +998,20 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	if (size <= 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
-	return __kvm_gmem_create(kvm, size, flags);
+	if (args->pad ||
+	    (!(flags & GUEST_MEMFD_FLAG_USE_RESOURCE) && args->resource_fd))
+		return -EINVAL;
+
+	/*
+	 * Without MMAP the memslot is not gmem-only, and a VM without private
+	 * memory would fault through the slot's userspace address instead of
+	 * the provider.
+	 */
+	if ((flags & GUEST_MEMFD_FLAG_USE_RESOURCE) &&
+	    !(flags & GUEST_MEMFD_FLAG_MMAP))
+		return -EINVAL;
+
+	return __kvm_gmem_create(kvm, size, flags, args->resource_fd);
 }
 
 static const struct kvm_gmem_ops *kvm_gmem_get_ops(struct file *file)
@@ -859,9 +1135,14 @@ static void kvm_gmem_native_unbind(struct file *slot_file, struct kvm *kvm,
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
 
@@ -1167,6 +1448,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	mpol_shared_policy_init(&gi->policy, NULL);
 
 	gi->flags = 0;
+	gi->att.ops = NULL;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
@@ -1181,10 +1463,19 @@ static void kvm_gmem_free_inode(struct inode *inode)
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
 
-- 
2.47.3

