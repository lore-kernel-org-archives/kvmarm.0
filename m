Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEBF4A3F26
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 18:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791311581; cv=none; b=kxAyAlS24OPUS1VCKVp/ZOv9Z7PhFf2jXMZ1zgA4cEA7URXk9+BP2e4fRUVtgaLG2lLPG0Mro3a+rKOJ0pDQcmWooN9sntPkhYlzpS61BMpqfIK0XZg5jPgJAxv3iCG8hOfuEj2GDgVDqfLlLNuSPc1h8ITGYVnEfovH6MJ91vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791311581; c=relaxed/simple;
	bh=buTvesJlhgUTf0vczctJ698a6ICo6NUhKgsxQGl6L0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuXXh6wmoi5tjpb7FtZ/ByOXlVX07ZQeaJsmBdJZgkiha9WgfVsw9BHSo27+aSFh42591qjtSQDk0p0lf1DuK4Rkuy3a+MUgbT6mkrHP/37Bf4GerPE1YtZUIdoOfDfR4TF2iokRWpOxF2be5CjU/DhmmgtDXihIcDgciPiWZ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hGH9g2Pq; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGH9g2Pq"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6afb0d2a586so1949282a12.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Oct 2026 11:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311571; x=1791916371; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mrJHg4EcIiUcrJStP3IT7dLBVIoFsRs5h14JomE41+A=;
        b=hGH9g2PqiHmGIuK1DYQzoNUtVFLfBm2mRV11dwMd2ehGLux8Hms5z2GMEnm0EpDE7i
         ng4PDjLg73naj5fXHWeFVw9HLU0OW++SRGzIeqp1O5WmkZ0cPWh6Obsih0MO723dNr6h
         Zp/CVcrYZQqnqrDtiM/zX/+7rvRkF1nejmA6FfvkV7zy57spmuyWwyJRa29U2V2wXiXu
         9l1739fFYlxbUPEjGO9AiiJXcrAgPo6a6kkfsKtove8ZK+4aTvBBPdy0teYPS4J/DYLv
         /ImQA69rDDaSbVS1/tV7w2LjaHCnZ1/uiUwMFj7oEMC8pBzbxyYUsiONz02HsLlPex09
         2K+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311571; x=1791916371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mrJHg4EcIiUcrJStP3IT7dLBVIoFsRs5h14JomE41+A=;
        b=ZuWe7fqvDgCdCJSfeNkRjY1uX2+gH04Ihzvo6yCm2OYKam1DNBGkbU3kcohfTRurkt
         kGGUwKCJ30e3xYDHMuqlVxilagUPFofE6xuRdhMfwwy+UzRNhs6loWE0AgAL4pkuJmUx
         Uo0iRRaiViOE9k4euC/OfOdop3azEODQ/c+6ywDgXg7ErwSiB5tJNDp+CuFJD9hD4DM0
         sG/nuHl2iSthNz6WBUTKMz6AkJUYSCphrcr2vFu85wqzqLHaeyWH5691tBK1qjkPz3fb
         mCxPXB3yje+RjT0+SqdxipTiLs45/qaMJ9OiyXu8BNc4yxNj85WlrfxbH7pDNFktLL1j
         roYQ==
X-Forwarded-Encrypted: i=1; AKwUvBxZmoSttxZqNndwfkqcPeLH0AyZKh7Ck8cp8DS0/LbKKPSS2o6OcPl19iYRnDQzHjPVHST+ee4=@lists.linux.dev
X-Gm-Message-State: AFuF++lkGmo0DOGRbYYpERqhB375+f3Ptk/WZpMQaZauYpCTj/ykQMrA
	JkE6GFiovLS66BjargPSrVJZK6d5Eu7sbYN/2nIrvxlxVOx1r1v1VqOj
X-Gm-Gg: AYBFou12ijUlSxm+BBsUHciK0VUey6HJsSH3JtkyTo361L5vuXXG6RSVR21X9D8Or9T
	P5YzQ/KiNTmmracMk4UxVN5kfEuTXOJTWbnxIeqeA25SgPnsThOLGej3lXstB7C15j30m6lxoZl
	pqd42TdF9F7bc1HzPrV4c62/oB5tFDRnO9so426UcfDvdtvE8N8kwc5FWfUN5ZI+4M1u87flker
	wMINOAGjfVxL8tFPbD5PkHW5BcpaM7tfHla+3a04cmM0UtG2GSeYSGONKyLoJpLTwTJnfbmLzYh
	OkwxPkPsQnsul0j7JOa7YA+5sQQqx7tXQ6X74LYvIy7juHNd9OhQcS+KV0ZQ39t0mxVF81mr4ZR
	ovL1pgaEy5e8CmMVk6IPrWOANCv4VRTNh0arngFRTyxawhKKLZN0AAIKVJ6hN2PUshYYncg9PmD
	lTV35zoAZJhZicAfB3/fSKviTfjz1DZUHdBEbegN68qb8EKXbpJ7MydK6tbX9P/78+XIE86wxqZ
	Spp8XaDiEsXy5r6xfMP6BxQoN2ADeB5TWyD0g66s84+JM7LSpuTajO0fdd1b6uVWeJZWMEIDYrO
	vF6A5zX5lISsabrytMchgqAapqKaTUkMCMg=
X-Received: by 2002:a17:907:3fa3:b0:c31:5e99:6961 with SMTP id a640c23a62f3a-c316a0cd86dmr245698366b.42.1791311571180;
        Tue, 06 Oct 2026 11:32:51 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:50 -0700 (PDT)
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
Subject: [PATCH 9/9] KVM: selftests: Test a memory provider shared by KVM and iommufd
Date: Tue,  6 Oct 2026 18:32:35 +0000
Message-ID: <20261006183235.16576-10-griffoul@gmail.com>
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

Test that guest, host and device mappings of one provider file follow
the provider's changes.

Two VMs get child files of the sample provider, each passed to
guest_memfd and to an iommufd mock domain. The test moves a range
between them, donates and reclaims pages, and makes a page read only.
After each change it checks the guest, a host mapping and the device
mapping. Pages are mapped on the host before a change, so the test
checks that the revoke zaps them.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/mem_provider_test.c     | 582 ++++++++++++++++++
 2 files changed, 583 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/mem_provider_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 4d7082448cea..ccee373b4c13 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -84,6 +84,7 @@ TEST_GEN_PROGS_x86 += x86/gmem_provider_revoke_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_readonly_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_iommufd_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_vfio_test
+TEST_GEN_PROGS_x86 += x86/mem_provider_test
 TEST_GEN_PROGS_x86 += x86/hwcr_msr_test
 TEST_GEN_PROGS_x86 += x86/hyperv_clock
 TEST_GEN_PROGS_x86 += x86/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/x86/mem_provider_test.c b/tools/testing/selftests/kvm/x86/mem_provider_test.c
new file mode 100644
index 000000000000..bd7ae44f05d7
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/mem_provider_test.c
@@ -0,0 +1,582 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * mem_provider_test - one memory provider shared by KVM and iommufd.
+ *
+ * A control process and two VMMs, in one process:
+ *
+ *  ctl:  holds /dev/mem_provider_sample, the owner of the memory.  Creates a
+ *        child provider file per VM, moves pages between children, donates
+ *        and reclaims them, and makes them read only.
+ *        Never touches a VM.
+ *  vmm:  holds one child file, one VM and one iommufd IOAS on a mock domain.
+ *        Passes the child file to KVM_CREATE_GUEST_MEMFD and to
+ *        IOMMU_IOAS_MAP_FILE.  Never touches the control device.
+ *
+ * Scenarios:
+ *
+ *  1. Launch:    each guest writes to its memory, the host sees the write,
+ *                and the device mapping covers the pages the child has.
+ *  2. Move:      a range leaves A for B.  A's guest and A's host mapping
+ *                fault on it and A's device loses only that range.  B's
+ *                guest and host read what A wrote, and B's device reaches
+ *                the frame A had.
+ *  3. Donate:    a range leaves A for the root and comes back on reclaim,
+ *                for the guest, the host mapping and the device.
+ *  4. Read only: a guest write to a read-only page exits to the VMM and a
+ *                host write raises SIGBUS; both land once the page is
+ *                writable again.
+ *  5. Window:    a host mapping of the guest_memfd faults after the range it
+ *                covers is donated.
+ *
+ * Requires samples/kvm/mem_provider_sample.ko and CONFIG_IOMMUFD_TEST.
+ */
+#include <fcntl.h>
+#include <errno.h>
+#include <setjmp.h>
+#include <signal.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include <linux/iommufd.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+/*
+ * The iommufd mock domain test interface.  The iommufd selftest helpers
+ * bring their own harness, which does not mix with the KVM selftest library.
+ */
+#include "../../../../../drivers/iommu/iommufd/iommufd_test.h"
+
+/* Mirrors samples/kvm/mem_provider_sample.h */
+#define MPS_FLAG_MMAP_CAPABLE	(1u << 0)
+
+struct mps_new_child { __u32 flags, pad; __u64 offset, len; };
+struct mps_move { __s32 src_fd, dst_fd; __u64 offset, len; };
+struct mps_donate { __s32 fd; __u32 pad; __u64 offset, len; };
+struct mps_ctl_range { __s32 fd; __u32 value; __u64 offset, len; };
+struct mps_stats {
+	__u64 region_offset, region_len, owned_pages, absent_pages, readonly_pages;
+};
+
+#define MPS_NEW_CHILD		_IOW('P', 5, struct mps_new_child)
+#define MPS_MOVE		_IOW('P', 6, struct mps_move)
+#define MPS_DONATE		_IOW('P', 7, struct mps_donate)
+#define MPS_RECLAIM		_IOW('P', 8, struct mps_donate)
+#define MPS_GET_STATS		_IOR('P', 10, struct mps_stats)
+#define MPS_CTL_SET_READONLY	_IOW('P', 11, struct mps_ctl_range)
+
+#define PAGE		0x1000ULL
+#define CHILD_SIZE	0x400000ULL		/* 4 MiB per child */
+#define GPA		(1ULL << 32)		/* each VM maps its child here */
+#define IOVA		(1ULL << 28)		/* inside the mock aperture */
+#define MAGIC_A		0xa11ce000a11ce000ULL
+#define MAGIC_B		0xb0bb0bb0b0bb0bb0ULL
+
+/*
+ * The ranges of A and B in the root overlap on [SHARED_OFF, +SHARED_LEN).
+ * A is created first and has its whole range, B is created second and has
+ * its range without the overlap.  The overlap can then move from A to B.
+ */
+#define A_OFF		0ULL
+#define SHARED_LEN	(4 * PAGE)
+#define B_OFF		(CHILD_SIZE - SHARED_LEN)
+#define SHARED_OFF	B_OFF
+#define ROOT_SIZE	(B_OFF + CHILD_SIZE)
+
+#define A_SHARED_GPA	(GPA + (SHARED_OFF - A_OFF))
+#define B_SHARED_GPA	(GPA + (SHARED_OFF - B_OFF))
+#define A_SHARED_IOVA	(IOVA + (SHARED_OFF - A_OFF))
+#define B_SHARED_IOVA	(IOVA + (SHARED_OFF - B_OFF))
+
+/* A page of A that never moves. */
+#define RO_OFF		(64 * PAGE)
+#define RO_GPA		(GPA + RO_OFF)
+
+/* Pages of A that are donated and reclaimed. */
+#define DON_OFF		(8 * PAGE)
+#define DON_GPA		(GPA + DON_OFF)
+#define DON_IOVA	(IOVA + DON_OFF)
+
+/* A page that B has from the start. */
+#define B_HOME_OFF	(CHILD_SIZE / 2)
+#define B_HOME_GPA	(GPA + B_HOME_OFF)
+
+struct guest_args {
+	uint64_t write_gpa;	/* 0 to skip */
+	uint64_t write_val;
+	uint64_t read_gpa;	/* 0 to skip; the value goes to GUEST_SYNC */
+};
+
+static void guest_code(struct guest_args *a)
+{
+	if (a->write_gpa)
+		*(volatile uint64_t *)a->write_gpa = a->write_val;
+	if (a->read_gpa)
+		GUEST_SYNC(*(volatile uint64_t *)a->read_gpa);
+	GUEST_DONE();
+}
+
+/* ---- Control process ---------------------------------------------------- */
+
+static int ctl;
+
+static int ctl_new_child(uint64_t off, uint64_t len)
+{
+	struct mps_new_child nc = {
+		.flags = MPS_FLAG_MMAP_CAPABLE,
+		.offset = off, .len = len,
+	};
+	int fd = ioctl(ctl, MPS_NEW_CHILD, &nc);
+
+	TEST_ASSERT(fd >= 0, "NEW_CHILD(%#llx, %#llx) errno=%d",
+		    (unsigned long long)off, (unsigned long long)len, errno);
+	return fd;
+}
+
+static int ctl_move(int src, int dst, uint64_t off, uint64_t len)
+{
+	struct mps_move mv = { .src_fd = src, .dst_fd = dst,
+			       .offset = off, .len = len };
+
+	return ioctl(ctl, MPS_MOVE, &mv) ? -errno : 0;
+}
+
+static void ctl_donate(int fd, uint64_t off, uint64_t len, bool reclaim)
+{
+	struct mps_donate d = { .fd = fd, .offset = off, .len = len };
+
+	TEST_ASSERT(!ioctl(ctl, reclaim ? MPS_RECLAIM : MPS_DONATE, &d),
+		    "%s errno=%d", reclaim ? "RECLAIM" : "DONATE", errno);
+}
+
+static void ctl_readonly(int fd, uint64_t off, bool ro)
+{
+	struct mps_ctl_range cr = { .fd = fd, .value = ro, .offset = off,
+				    .len = PAGE };
+
+	TEST_ASSERT(!ioctl(ctl, MPS_CTL_SET_READONLY, &cr),
+		    "CTL_SET_READONLY errno=%d", errno);
+}
+
+/* ---- VMM ---------------------------------------------------------------- */
+
+struct vmm {
+	const char *name;
+	int child;		/* the provider file */
+	int gmem;		/* the guest_memfd backed by it */
+	int iommufd;
+	uint32_t ioas, stdev, hwpt;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	void *hva;		/* host mapping of the whole guest_memfd */
+	gva_t args_gva;
+};
+
+static void vmm_create(struct vmm *v)
+{
+	v->vm = vm_create_with_one_vcpu(&v->vcpu, guest_code);
+	v->args_gva = vm_alloc_page(v->vm);
+}
+
+static bool vmm_iova_mapped(struct vmm *v, uint64_t iova, uint64_t len,
+			    bool mapped)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd), .op = IOMMU_TEST_OP_MD_CHECK_MAPPED,
+		.id = v->hwpt,
+		.check_mapped = { .mapped = mapped, .iova = iova,
+				  .length = len },
+	};
+
+	return !ioctl(v->iommufd, IOMMU_TEST_CMD, &cmd);
+}
+
+static uint64_t vmm_iova_phys(struct vmm *v, uint64_t iova)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd), .op = IOMMU_TEST_OP_MD_IOVA_TO_PHYS,
+		.id = v->hwpt,
+		.iova_to_phys = { .iova = iova },
+	};
+
+	if (ioctl(v->iommufd, IOMMU_TEST_CMD, &cmd))
+		return 0;
+	return cmd.iova_to_phys.out_phys;
+}
+
+/* Give the child file to KVM and to iommufd. */
+static void vmm_attach(struct vmm *v, int child_fd)
+{
+	struct iommu_ioas_alloc alloc = { .size = sizeof(alloc) };
+	struct kvm_create_guest_memfd gm = {
+		.size = CHILD_SIZE,
+		.flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_USE_PROVIDER,
+		.provider_fd = child_fd,
+	};
+	struct iommu_test_cmd mock = {
+		.size = sizeof(mock), .op = IOMMU_TEST_OP_MOCK_DOMAIN,
+	};
+	struct iommu_ioas_map_file map = {
+		.size = sizeof(map),
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_READABLE |
+			 IOMMU_IOAS_MAP_WRITEABLE,
+		.fd = child_fd, .start = 0, .length = CHILD_SIZE, .iova = IOVA,
+	};
+	int r;
+
+	v->child = child_fd;
+
+	/* KVM: a guest_memfd backed by the child, behind one memslot. */
+	v->gmem = __vm_ioctl(v->vm, KVM_CREATE_GUEST_MEMFD, &gm);
+	TEST_ASSERT(v->gmem >= 0, "%s: KVM_CREATE_GUEST_MEMFD errno=%d",
+		    v->name, errno);
+	v->hva = mmap(NULL, CHILD_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
+		      v->gmem, 0);
+	TEST_ASSERT(v->hva != MAP_FAILED, "%s: mmap(guest_memfd) errno=%d",
+		    v->name, errno);
+	r = __vm_set_user_memory_region2(v->vm, 10, KVM_MEM_GUEST_MEMFD, GPA,
+					 CHILD_SIZE, v->hva, v->gmem, 0);
+	TEST_ASSERT(!r, "%s: SET_USER_MEMORY_REGION2 errno=%d", v->name,
+		    errno);
+	virt_map(v->vm, GPA, GPA, CHILD_SIZE / PAGE);
+
+	/* iommufd: the same child file, in an IOAS on a mock domain. */
+	v->iommufd = open("/dev/iommu", O_RDWR);
+	__TEST_REQUIRE(v->iommufd >= 0, "iommufd unavailable");
+	TEST_ASSERT(!ioctl(v->iommufd, IOMMU_IOAS_ALLOC, &alloc),
+		    "IOAS_ALLOC errno=%d", errno);
+	v->ioas = alloc.out_ioas_id;
+
+	mock.id = v->ioas;
+	__TEST_REQUIRE(!ioctl(v->iommufd, IOMMU_TEST_CMD, &mock),
+		       "no iommufd mock domain (CONFIG_IOMMUFD_TEST?)");
+	v->stdev = mock.mock_domain.out_stdev_id;
+	v->hwpt = mock.mock_domain.out_hwpt_id;
+
+	map.ioas_id = v->ioas;
+	TEST_ASSERT(!ioctl(v->iommufd, IOMMU_IOAS_MAP_FILE, &map),
+		    "%s: IOAS_MAP_FILE(provider) errno=%d", v->name, errno);
+}
+
+/*
+ * Continue the guest.  KVM_RUN fails with EFAULT for KVM_EXIT_MEMORY_FAULT,
+ * which several scenarios expect; the expect_*() helpers check the exit.
+ */
+static void vmm_resume(struct vmm *v)
+{
+	int r = _vcpu_run(v->vcpu);
+
+	TEST_ASSERT(!r || (errno == EFAULT &&
+			   v->vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT),
+		    "%s: KVM_RUN r=%d errno=%d exit=%s", v->name, r, errno,
+		    exit_reason_str(v->vcpu->run->exit_reason));
+}
+
+static void vmm_run(struct vmm *v, uint64_t write_gpa, uint64_t write_val,
+		    uint64_t read_gpa)
+{
+	struct guest_args *a = addr_gva2hva(v->vm, v->args_gva);
+
+	a->write_gpa = write_gpa;
+	a->write_val = write_val;
+	a->read_gpa = read_gpa;
+	vcpu_arch_set_entry_point(v->vcpu, guest_code);
+	vcpu_args_set(v->vcpu, 1, v->args_gva);
+	vmm_resume(v);
+}
+
+static void expect_done(struct vmm *v)
+{
+	struct kvm_run *run = v->vcpu->run;
+	struct ucall uc;
+
+	TEST_ASSERT(run->exit_reason != KVM_EXIT_MEMORY_FAULT,
+		    "%s: unexpected memory fault at gpa %#llx", v->name,
+		    (unsigned long long)run->memory_fault.gpa);
+	TEST_ASSERT(get_ucall(v->vcpu, &uc) == UCALL_DONE, "%s: guest exit %s",
+		    v->name, exit_reason_str(run->exit_reason));
+}
+
+static uint64_t expect_sync_then_done(struct vmm *v)
+{
+	struct ucall uc;
+	uint64_t val;
+
+	TEST_ASSERT(get_ucall(v->vcpu, &uc) == UCALL_SYNC, "%s: guest exit %s",
+		    v->name, exit_reason_str(v->vcpu->run->exit_reason));
+	val = uc.args[1];
+	vmm_resume(v);
+	expect_done(v);
+	return val;
+}
+
+static void expect_memory_fault(struct vmm *v, uint64_t gpa)
+{
+	struct kvm_run *run = v->vcpu->run;
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_MEMORY_FAULT,
+		    "%s: want KVM_EXIT_MEMORY_FAULT, got %s", v->name,
+		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->memory_fault.gpa == gpa,
+		    "%s: fault at gpa %#llx, want %#llx", v->name,
+		    (unsigned long long)run->memory_fault.gpa,
+		    (unsigned long long)gpa);
+}
+
+static void vmm_stats(struct vmm *v, struct mps_stats *st)
+{
+	TEST_ASSERT(!ioctl(v->child, MPS_GET_STATS, st),
+		    "%s: GET_STATS errno=%d", v->name, errno);
+}
+
+static void vmm_destroy(struct vmm *v)
+{
+	close(v->iommufd);
+	kvm_vm_free(v->vm);
+	munmap(v->hva, CHILD_SIZE);
+	close(v->gmem);
+	close(v->child);
+}
+
+static sigjmp_buf host_jmp;
+
+static void host_sig(int sig)
+{
+	siglongjmp(host_jmp, sig);
+}
+
+/*
+ * Read @addr, or write @val to it, through a host mapping.  Return the
+ * signal that the access raised, or 0.
+ */
+static int host_access(volatile uint64_t *addr, bool write, uint64_t val)
+{
+	struct sigaction sa = { .sa_handler = host_sig }, old_bus, old_segv;
+	int sig;
+
+	sigaction(SIGBUS, &sa, &old_bus);
+	sigaction(SIGSEGV, &sa, &old_segv);
+	sig = sigsetjmp(host_jmp, 1);
+	if (!sig) {
+		if (write)
+			*addr = val;
+		else
+			(void)*addr;
+	}
+	sigaction(SIGBUS, &old_bus, NULL);
+	sigaction(SIGSEGV, &old_segv, NULL);
+	return sig;
+}
+
+#define host_read_faults(p)	(host_access(p, false, 0) == SIGBUS)
+#define host_write_faults(p, v)	(host_access(p, true, v) == SIGBUS)
+
+/* ---- Scenarios ---------------------------------------------------------- */
+
+static void scenario_launch(struct vmm *a, struct vmm *b)
+{
+	pr_info("1. launch\n");
+	vmm_run(a, GPA, MAGIC_A, 0);
+	expect_done(a);
+	vmm_run(b, B_HOME_GPA, MAGIC_B, 0);
+	expect_done(b);
+	TEST_ASSERT(*(volatile uint64_t *)a->hva == MAGIC_A,
+		    "A: the guest write is not visible to the host");
+	TEST_ASSERT(*(volatile uint64_t *)(b->hva + B_HOME_OFF) == MAGIC_B,
+		    "B: the guest write is not visible to the host");
+
+	/* A has its whole range; B lacks the shared window. */
+	TEST_ASSERT(vmm_iova_mapped(a, IOVA, CHILD_SIZE, true),
+		    "A: device mapping incomplete");
+	TEST_ASSERT(vmm_iova_mapped(b, B_SHARED_IOVA, SHARED_LEN, false),
+		    "B: device maps a window that B does not have");
+	TEST_ASSERT(vmm_iova_mapped(b, B_SHARED_IOVA + SHARED_LEN,
+				    CHILD_SIZE - SHARED_LEN, true),
+		    "B: device mapping incomplete");
+}
+
+static void scenario_move(struct vmm *a, struct vmm *b)
+{
+	struct mps_stats st;
+	uint64_t frame;
+	int r;
+
+	pr_info("2. move A -> B\n");
+	vmm_run(a, A_SHARED_GPA, MAGIC_A, 0);
+	expect_done(a);
+	frame = vmm_iova_phys(a, A_SHARED_IOVA);
+	TEST_ASSERT(frame, "A: window not mapped before the move");
+	/* Map the window on the host too, so that the move must zap it. */
+	TEST_ASSERT(*(volatile uint64_t *)(a->hva + SHARED_OFF - A_OFF) ==
+		    MAGIC_A, "A: host mapping does not see the guest write");
+
+	/* B does not have the window yet. */
+	vmm_run(b, 0, 0, B_SHARED_GPA);
+	expect_memory_fault(b, B_SHARED_GPA);
+
+	/* A move outside the destination's range is refused. */
+	r = ctl_move(a->child, b->child, RO_OFF, PAGE);
+	TEST_ASSERT(r == -EINVAL, "MOVE outside B's range returned %d", r);
+
+	r = ctl_move(a->child, b->child, SHARED_OFF, SHARED_LEN);
+	TEST_ASSERT(!r, "MOVE returned %d", r);
+
+	vmm_stats(a, &st);
+	TEST_ASSERT(st.owned_pages == (CHILD_SIZE - SHARED_LEN) / PAGE,
+		    "A has %llu pages after the move",
+		    (unsigned long long)st.owned_pages);
+	vmm_stats(b, &st);
+	TEST_ASSERT(st.owned_pages == CHILD_SIZE / PAGE,
+		    "B has %llu pages after the move",
+		    (unsigned long long)st.owned_pages);
+
+	/* A's device lost the window and only the window. */
+	TEST_ASSERT(vmm_iova_mapped(a, A_SHARED_IOVA, SHARED_LEN, false),
+		    "A: moved window still mapped");
+	TEST_ASSERT(vmm_iova_mapped(a, IOVA, CHILD_SIZE - SHARED_LEN, true),
+		    "A: the rest of the mapping went too");
+
+	/* A's guest and A's host mapping fault on the window. */
+	vmm_run(a, 0, 0, A_SHARED_GPA);
+	expect_memory_fault(a, A_SHARED_GPA);
+	TEST_ASSERT(host_read_faults(a->hva + SHARED_OFF - A_OFF),
+		    "A: host mapping of the moved window still readable");
+
+	/* B reads what A wrote, and B's device reaches A's frame. */
+	vmm_run(b, 0, 0, B_SHARED_GPA);
+	TEST_ASSERT(expect_sync_then_done(b) == MAGIC_A,
+		    "B does not see A's write");
+	TEST_ASSERT(*(volatile uint64_t *)(b->hva + SHARED_OFF - B_OFF) ==
+		    MAGIC_A, "B: host mapping does not see A's write");
+	TEST_ASSERT(vmm_iova_phys(b, B_SHARED_IOVA) == frame,
+		    "B: window is not on the frame A had");
+}
+
+static void scenario_donate(struct vmm *a)
+{
+	struct mps_stats st;
+
+	pr_info("3. donate and reclaim\n");
+	/* Map the page on the host, so that the donation must zap it. */
+	TEST_ASSERT(!host_access(a->hva + DON_OFF, false, 0),
+		    "A: host mapping faults before the donation");
+	ctl_donate(a->child, DON_OFF, 2 * PAGE, false);
+	vmm_stats(a, &st);
+	TEST_ASSERT(st.owned_pages == (CHILD_SIZE - SHARED_LEN) / PAGE - 2,
+		    "A has %llu pages after the donation",
+		    (unsigned long long)st.owned_pages);
+	TEST_ASSERT(vmm_iova_mapped(a, DON_IOVA, 2 * PAGE, false),
+		    "A: donated pages still mapped for the device");
+	TEST_ASSERT(host_read_faults(a->hva + DON_OFF),
+		    "A: host mapping of a donated page still readable");
+	vmm_run(a, 0, 0, DON_GPA);
+	expect_memory_fault(a, DON_GPA);
+
+	ctl_donate(a->child, DON_OFF, 2 * PAGE, true);
+	vmm_stats(a, &st);
+	TEST_ASSERT(st.owned_pages == (CHILD_SIZE - SHARED_LEN) / PAGE,
+		    "A has %llu pages after the reclaim",
+		    (unsigned long long)st.owned_pages);
+	TEST_ASSERT(vmm_iova_mapped(a, DON_IOVA, 2 * PAGE, true),
+		    "A: reclaimed pages not mapped again for the device");
+	TEST_ASSERT(!host_access(a->hva + DON_OFF, false, 0),
+		    "A: host mapping of a reclaimed page faults");
+	vmm_run(a, 0, 0, DON_GPA);
+	expect_sync_then_done(a);
+}
+
+static void scenario_readonly(struct vmm *a)
+{
+	volatile uint64_t *page = (volatile uint64_t *)(a->hva + RO_OFF);
+
+	pr_info("4. read only\n");
+	*page = MAGIC_B;
+
+	ctl_readonly(a->child, RO_OFF, true);
+	TEST_ASSERT(vmm_iova_mapped(a, IOVA + RO_OFF, PAGE, true),
+		    "A: read-only page not mapped for the device");
+
+	vmm_run(a, RO_GPA, MAGIC_A, 0);
+	expect_memory_fault(a, RO_GPA);
+	TEST_ASSERT(host_write_faults(page, MAGIC_A),
+		    "A: host write to a read-only page did not fault");
+	TEST_ASSERT(*page == MAGIC_B, "write to a read-only page landed");
+
+	/* Clear the bit; the guest retries the same write. */
+	ctl_readonly(a->child, RO_OFF, false);
+	vmm_resume(a);
+	expect_done(a);
+	TEST_ASSERT(*page == MAGIC_A, "write after clearing read only lost");
+	TEST_ASSERT(!host_write_faults(page, MAGIC_B),
+		    "A: host write after clearing read only faulted");
+	TEST_ASSERT(*page == MAGIC_B, "host write after clearing read only lost");
+}
+
+static void scenario_window(struct vmm *a)
+{
+	volatile uint64_t *win;
+
+	pr_info("5. host mapping\n");
+	win = mmap(NULL, PAGE, PROT_READ | PROT_WRITE, MAP_SHARED, a->gmem,
+		   DON_OFF);
+	TEST_ASSERT(win != MAP_FAILED, "mmap(guest_memfd, page) errno=%d",
+		    errno);
+	*win = MAGIC_A;
+	TEST_ASSERT(*(volatile uint64_t *)(a->hva + DON_OFF) == MAGIC_A,
+		    "the two host mappings disagree");
+
+	ctl_donate(a->child, DON_OFF, PAGE, false);
+
+	TEST_ASSERT(host_read_faults(win),
+		    "host mapping still readable after the donation");
+
+	ctl_donate(a->child, DON_OFF, PAGE, true);
+	TEST_ASSERT(*win == MAGIC_A, "host mapping did not come back");
+	munmap((void *)win, PAGE);
+}
+
+int main(void)
+{
+	struct vmm a = { .name = "A" }, b = { .name = "B" };
+	struct mps_new_child probe = { .offset = ROOT_SIZE - PAGE, .len = PAGE };
+	int fd;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS) &
+		     GUEST_MEMFD_FLAG_USE_PROVIDER);
+
+	ctl = open("/dev/mem_provider_sample", O_RDWR);
+	__TEST_REQUIRE(ctl >= 0, "mem_provider_sample not loaded");
+
+	/*
+	 * Without addr= and len=, the first NEW_CHILD sizes the root, so ask
+	 * for its last page first and give it back.  A fixed root that is too
+	 * small makes the test skip.
+	 */
+	fd = ioctl(ctl, MPS_NEW_CHILD, &probe);
+	__TEST_REQUIRE(fd >= 0, "provider root smaller than %#llx bytes",
+		       (unsigned long long)ROOT_SIZE);
+	close(fd);
+
+	vmm_create(&a);
+	vmm_create(&b);
+	vmm_attach(&a, ctl_new_child(A_OFF, CHILD_SIZE));
+	vmm_attach(&b, ctl_new_child(B_OFF, CHILD_SIZE));
+
+	scenario_launch(&a, &b);
+	scenario_move(&a, &b);
+	scenario_donate(&a);
+	scenario_readonly(&a);
+	scenario_window(&a);
+
+	vmm_destroy(&a);
+	vmm_destroy(&b);
+	close(ctl);
+	pr_info("mem_provider: all scenarios passed\n");
+	return 0;
+}
