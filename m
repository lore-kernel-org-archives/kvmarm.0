Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430573;
	b=ueJGJmL8YS660u9LFEQbRaEd6k3YtHXt9wk187rc/5vTOyOUiXismOp5J2UQtaeGCNRZ
	 b+8ATgGSxM65cTJsRtU3E6VqofRmwRQ4xDHrrnTL2RctS9rMYdWhrJP1PZ6+onEO0EOYr
	 vWuzs1YbT7zwCUCsusH1H2R6Lo1nPpwvfRsIjbSPAtocQe7UMQv7lZAyBP+NXedmQft+j
	 tIGY1esBjUxbooaCIyEAfFgtWnlOiY+4gvVUMGCR74L5KHr+6fzZTAOa6eyELuJijd1ol
	 +Xc0t6Qwrbc7vgp4p8NUW3OS9pagXk4SQWx+qiRaV3HhYm/mc2uZ+ExH7bCMdE0lQWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430573;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2QZXCDCUsri/fCqMkv6Sqp8+BO3UKbCWsc2sGVEU9V4=;
	b=mSsYg5rn54bIchThL8P9Qq6NVPWczJ4rIsAIubrXCfhOT2deXlhxO8y/dj0AGU/6jHws
	 OQ8DvW2xPX62D8BBQGwc6bMC1mT/U7GPGVq0m+n0jJxqz7Mf3wh4RYn84s7g13+sqN4B6
	 emteZxhltiWGcKm6A1AjY8chTj8mhgfmyH9DOVhFiDXc+6zPuTLXxxgNKOxVthOzVyPat
	 DLpjHKjNjoRR/iyKRCqiKCyKTA08MvrUcOMBS0rFUv+QzkVEv8ed0RqJPQq44wPmV3deb
	 Wvg6NUTtsX6DLh6I1oBlniXJzhIEUjONJAQJA0PGA9elBjwVvNci1y8a0R9BwDggSaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UqDpoz2P;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A83D606A31A;
	Mon, 23 Nov 2026 10:42:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A83D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UqDpoz2P
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8784176B;
	Mon, 23 Nov 2026 02:42:49 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 836B43F632;
	Mon, 23 Nov 2026 02:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795430572; bh=Bcn/e1MZmqsfO3HIXSrjDn+qTu+ZI+50S1gKI1SPZp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqDpoz2PcB35yr90eM0wrsH5uAq6HlLEv56ZXBrsgvClicRR3i6BNZkzbbTqAKJSb
	 XCW0BNBACXpidZvUXIkXVlI3GsPGm2sf1+KgjF/u2M0pj1obIwrwzyYmILLTfRN5wV
	 22Mzom+5y4D8OP7SguW4piWPj2FQT7gNd6zyjd/8=
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
Subject: [PATCH v4 01/11] KVM: arm64: guest_memfd: Check mmap support when preparing memslot
Date: Mon, 23 Nov 2026 10:42:21 +0000
Message-ID: <20261123104233.95710-2-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123104233.95710-1-steven.price@arm.com>
References: <20261123104233.95710-1-steven.price@arm.com>
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

Arm64 requires mmap-capable guest_memfd backing because the memslot HVA
may still be used to access shared memory even when guest faults use
guest_memfd.

The existing check rejects guest_memfd without mmap support based on the
memslot's gmem-only flag. That stops working when arm64 defines
kvm_arch_has_private_mem() for realms: in-place conversion then marks all
guest_memfd memslots gmem-only, including those backed by files without
GUEST_MEMFD_FLAG_MMAP. Such files would pass the existing check.

Check the backing file's mmap capability directly to keep requiring it
for every arm64 VM. Expose a helper to reuse kvm_gmem_supports_mmap().

Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v3:
- Explain why in-place conversion makes checking the memslot's
  gmem-only flag insufficient for arm64.

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

