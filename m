Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FFA3BB682
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 08:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783326990; cv=none; b=By+wkfz6A9zSUFGk339gMHdpLSX+tvu6dOvdpxcUvQmtg0J5EaqWy3cuzskW9jfBJm8ydf4NJaghsg8DZUTxf7CGn8uh9zRuHKWY8pQ/3qBXwCoFfzGFdYV1iKQDNu4s8hyqSiCqIZMXrWp9sakrNr95jZMVQ9NSPWo88gB+m84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783326990; c=relaxed/simple;
	bh=qLDY7WVH3+gTbsMQ9Ylt9zwWu/lYyQy0uCJ+Rs34fXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RVC0rvCJJjhjpWuFl4wBVXhnA3aUNPUxwJHMMcyktj0+IEhtEr1ppPDKeS2jYJwgD0T1AXse31jVe0P2SaPcmXzC4TJWYBpfRSe4e5dn+46Ikw0FlblF/Y64tiZQ1NzW8nO+SWRL7WrHgNrbnvJpiMFpsNu33liWns4xb61jRzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rZOkw50U; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rZOkw50U"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783326970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ctcb9e15jym4XmiABGToZoWZJ0i9DGdTPWmTVq+UbMM=;
	b=rZOkw50Ub/zYmoW5VEeQ9/5kWCcfZfToQteJVglWUWweiiHDHJ9v9/uS1sYVGxmCYa05g3
	qd7JfyMygKrE3mh4+m5USAXXXi/9YOkKbft6z++0kNT/KTDHfr2YkskcINGpepp1+Gws5O
	VY29+gUEwWu2Lld4zOrgrDvD5Wzks4Y=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool v1 4/5] Add guest_memfd support to kvm__register_mem()
Date: Mon,  6 Jul 2026 09:35:54 +0100
Message-Id: <20260706083555.302972-5-fuad.tabba@linux.dev>
In-Reply-To: <20260706083555.302972-1-fuad.tabba@linux.dev>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a guest_memfd file descriptor and offset to kvm__register_mem().
When guest_memfd >= 0, set KVM_MEM_GUEST_MEMFD and populate the
guest_memfd fields, binding the memslot to the file. This prepares
for backing guest RAM with guest_memfd on arm64.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 hw/cfi_flash.c    |  2 +-
 include/kvm/kvm.h | 15 +++++++++++++--
 kvm.c             |  9 ++++++++-
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/hw/cfi_flash.c b/hw/cfi_flash.c
index b68d9e0..4413955 100644
--- a/hw/cfi_flash.c
+++ b/hw/cfi_flash.c
@@ -451,7 +451,7 @@ static int map_flash_memory(struct kvm *kvm, struct cfi_flash_device *sfdev)
 	int ret;
 
 	ret = kvm__register_mem(kvm, sfdev->base_addr, sfdev->size,
-				sfdev->flash_memory,
+				sfdev->flash_memory, -1, 0,
 				KVM_MEM_TYPE_RAM | KVM_MEM_TYPE_READONLY);
 	if (!ret)
 		sfdev->is_mapped = true;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index eb23e2f..5e7b5eb 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -128,11 +128,22 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
 int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
+		      int guest_memfd, u64 guest_memfd_offset,
 		      enum kvm_mem_type type);
 static inline int kvm__register_ram(struct kvm *kvm, u64 guest_phys, u64 size,
 				    void *userspace_addr)
 {
 	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
+				 -1, 0, KVM_MEM_TYPE_RAM);
+}
+
+static inline int kvm__register_ram_guest_memfd(struct kvm *kvm, u64 guest_phys,
+						u64 size, void *userspace_addr,
+						int guest_memfd,
+						u64 guest_memfd_offset)
+{
+	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
+				 guest_memfd, guest_memfd_offset,
 				 KVM_MEM_TYPE_RAM);
 }
 
@@ -140,13 +151,13 @@ static inline int kvm__register_dev_mem(struct kvm *kvm, u64 guest_phys,
 					u64 size, void *userspace_addr)
 {
 	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
-				 KVM_MEM_TYPE_DEVICE);
+				 -1, 0, KVM_MEM_TYPE_DEVICE);
 }
 
 static inline int kvm__reserve_mem(struct kvm *kvm, u64 guest_phys, u64 size)
 {
 	return kvm__register_mem(kvm, guest_phys, size, NULL,
-				 KVM_MEM_TYPE_RESERVED);
+				 -1, 0, KVM_MEM_TYPE_RESERVED);
 }
 
 int __must_check kvm__register_iotrap(struct kvm *kvm, u64 phys_addr, u64 len,
diff --git a/kvm.c b/kvm.c
index 8a7fd09..3d05756 100644
--- a/kvm.c
+++ b/kvm.c
@@ -237,7 +237,8 @@ out:
 }
 
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
-		      void *userspace_addr, enum kvm_mem_type type)
+		      void *userspace_addr, int guest_memfd,
+		      u64 guest_memfd_offset, enum kvm_mem_type type)
 {
 	struct kvm_mem_bank *merged = NULL;
 	struct kvm_mem_bank *bank;
@@ -327,6 +328,12 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 			.userspace_addr		= (unsigned long)userspace_addr,
 		};
 
+		if (guest_memfd >= 0) {
+			mem.flags	|= KVM_MEM_GUEST_MEMFD;
+			mem.guest_memfd		= guest_memfd;
+			mem.guest_memfd_offset	= guest_memfd_offset;
+		}
+
 		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);
 		if (ret < 0) {
 			ret = -errno;
-- 
2.39.5

