Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847463;
	b=XBacI8mTtG8ASFsbA3xLJYk6qf5cVg8oyfbSbuFpbUpDNoQ8SYKiT8jQVR3+QtCdkTrI
	 EZj4rmNoS/TKAUXiQgSkg+HezG6rl2WCnkuDUUCnrHz2zllvXBuih5HO9fCBmM9fN+uek
	 KEY8WHoaZN77R9pyJ9rAIzgQaELVvmiP7GX+2DTpcSF7vasmn91mK/JlaDCNgJ1C53Hhd
	 GfJX8bXopvgV3kcKNTnLmErq7GVOl/9b5CJqpIedBavHi4jSuNQMUde6fto/OxSLsx2kp
	 +3eOxi9z0pkkWTEG6zeTKOVgTJvdYrYzX7XVFl+mLewVz//e7eAXdsCROLeaMcYOtdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847463;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=e2NylE6+sjsYCqRT2Dyu7dEdAZnWtwzqoeaBFDuhRWY=;
	b=pMUyG13sqtFRoxfoR8Vw/7shm4u4jjVtZmdQGDx98Huo7lKikdgxjVPMHODdHJdDcLHP
	 QiGW0hUD2IgnB7Krndwhztv/kVVk7Vc2A97MChnOX2uDLPr1+3bemHQafSWZ8IbA6/VD/
	 JtviikpnKp/zOufoBRntlZCS3Glbi92cHFTGhySPun1LmQGEf7kD9z1cFZLtiBUsrS+EG
	 TspLKdGwO63P9V0mYlWV45VuPzG4njuWRNFiI+MMZSfzihLK7YlU1mbDAZyQ/i8TPg0Fz
	 TigTjFRpgr3pKuwZP9WIo5/+LD/JIAfY90XCmzI191exl2KvxeZZ1BbU9p2G9+QC4Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LS7D+Qa4;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B054606A880;
	Mon, 16 Nov 2026 16:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B054606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LS7D+Qa4
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 699E71A25;
	Mon, 16 Nov 2026 08:44:17 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C2A33F763;
	Mon, 16 Nov 2026 08:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794847460; bh=c8M7HQoWriGSwwNOlIuqZVi474mU0DgVTsjTtOYq8k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LS7D+Qa4Jug1w7pNyO1WZhVWl/1vtp+gwic0VcV/t+Jn2ZJMnOnAtIxNtTBUe5qxx
	 SOu6yyzhY9xBdwxBTYKiKo4lxyLdhdOn+K4xeBwD6IWSsug5w6g4yEEPaMFdz2Hsis
	 c+vRGjWKRTXfdgNs+FYW8p4Pdh6Imxy97oR3/0tk=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Kohei Enju <enju.kohei@fujitsu.com>
Subject: [PATCH v3 01/11] KVM: arm64: guest_memfd: Check mmap support when preparing memslot
Date: Mon, 16 Nov 2026 16:43:47 +0000
Message-ID: <20261116164358.142785-2-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116164358.142785-1-steven.price@arm.com>
References: <20261116164358.142785-1-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check the guest_memfd backing file when deciding whether an arm64
memslot has mappable memory rather than checking whether the slot is
gmem only. A public helper function is added to be able to reuse the
static kvm_gmem_supports_mmap() function.

Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v2:
- Require mmap-capable guest_memfd backing for all arm64 VMs, as
  shared-memory access can use the memslot HVA.

Changes since v1:
- New patch in v2. Check the guest_memfd backing file rather than the
  memslot flag when deciding whether arm64 can map the backing memory.
---
 arch/arm64/kvm/mmu.c     | 6 +++---
 include/linux/kvm_host.h | 1 +
 virt/kvm/guest_memfd.c   | 6 ++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db7..2825fccd2a19 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2839,10 +2839,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		return -EFAULT;
 
 	/*
-	 * Only support guest_memfd backed memslots with mappable memory, since
-	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 * All VMs need mappable guest_memfd memory, as the memslot's HVA may be
+	 * used to access shared memory even if guest faults use guest_memfd.
 	 */
-	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
+	if (kvm_slot_has_gmem(new) && !kvm_gmem_slot_supports_mmap(new))
 		return -EINVAL;
 
 	/* guest_memfd is incompatible with MTE. */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e7fc94e2910a..f65728a713ec 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2614,6 +2614,7 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
+bool kvm_gmem_slot_supports_mmap(const struct kvm_memory_slot *slot);
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
 
 static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8c97a69b16dc..3dd8d227bebb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -442,6 +442,12 @@ static bool kvm_gmem_supports_mmap(struct inode *inode)
 	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
 }
 
+bool kvm_gmem_slot_supports_mmap(const struct kvm_memory_slot *slot)
+{
+	/* The guest_memfd file is pinned while preparing a new memslot. */
+	return kvm_gmem_supports_mmap(file_inode(slot->gmem.file));
+}
+
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
-- 
2.43.0

