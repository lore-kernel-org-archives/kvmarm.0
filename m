Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EE2240611
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 14:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783866348; cv=none; b=pZHmwbwanDd9MElstAkp3830WE95FeNXnryPdHMBNYjkSevIUdfddRLD0kd6+oeaIBG4LvzewjDMHKV5bG+vRberYIxu4W6dz0PVgGMHWFjNZklyHBeD/tdAgbf1CCKPmQdHl6yJgyw1ZRHMf1Y9AdBF9F6If9LMWX1/X3EO5pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783866348; c=relaxed/simple;
	bh=5F26L2THy8ciTeatfHbCXXtR5LIlN3WXqIRoCEE5UkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=smrIvsJayt5s5Upswcc+ZRKCLc3ZC1LvMRIN8zTPpIU7xNQLtbbQ+TxsvAsBjvIO05z4+6lpVdDVFEknK/dUNobpqbJIGM0S+LfbOmfsgdglRVO1Q/3PaZ+tLPu3xmnhK1hBtwkgP9DnaOsnWIKbHzRRKptE083judVciMOC4sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PHZ0rMny; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PHZ0rMny"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783866344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=km9voDa6Lw43hQJpF9SfqmtgdbZ0zmKTpaeKudQBhdU=;
	b=PHZ0rMnyQ/sPIKXKBDEjhcMQCCJAZPi6yB+DQUf4IcRSP11PKczxtDwezC5OPRcWpQXnqJ
	xFhfcsxO+6Rr+OshHofL3XKy0S5nDxkSG7fZyBRCZ5GEZJL9y7dSrp/6ZrY52OGBWzNEbG
	8EO5jeILJL4a8BszIEm4GTyOIyj/ipA=
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
Subject: [PATCH kvmtool v3 3/4] Add support for registering guest_memfd-backed memory regions
Date: Sun, 12 Jul 2026 15:25:35 +0100
Message-Id: <20260712142536.1391557-4-fuad.tabba@linux.dev>
In-Reply-To: <20260712142536.1391557-1-fuad.tabba@linux.dev>
References: <20260712142536.1391557-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Extend kvm__register_mem() with a guest_memfd file descriptor and
offset. A bank with a guest_memfd is registered with
KVM_SET_USER_MEMORY_REGION2 and KVM_MEM_GUEST_MEMFD, binding the
memslot to the file. This prepares for backing guest RAM with
guest_memfd on arm64.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 hw/cfi_flash.c    |  2 +-
 include/kvm/kvm.h | 16 ++++++++++++++--
 kvm.c             | 36 ++++++++++++++++++++++++++----------
 3 files changed, 41 insertions(+), 13 deletions(-)

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
index eb23e2f..077aaee 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -128,11 +128,23 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
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
+	BUG_ON(guest_memfd < 0);
+	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
+				 guest_memfd, guest_memfd_offset,
 				 KVM_MEM_TYPE_RAM);
 }
 
@@ -140,13 +152,13 @@ static inline int kvm__register_dev_mem(struct kvm *kvm, u64 guest_phys,
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
index 95ccfcb..947721b 100644
--- a/kvm.c
+++ b/kvm.c
@@ -237,9 +237,9 @@ out:
 }
 
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
-		      void *userspace_addr, enum kvm_mem_type type)
+		      void *userspace_addr, int guest_memfd,
+		      u64 guest_memfd_offset, enum kvm_mem_type type)
 {
-	struct kvm_userspace_memory_region mem;
 	struct kvm_mem_bank *merged = NULL;
 	struct kvm_mem_bank *bank;
 	struct list_head *prev_entry;
@@ -320,15 +320,31 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		flags |= KVM_MEM_READONLY;
 
 	if (type != KVM_MEM_TYPE_RESERVED) {
-		mem = (struct kvm_userspace_memory_region) {
-			.slot			= slot,
-			.flags			= flags,
-			.guest_phys_addr	= guest_phys,
-			.memory_size		= size,
-			.userspace_addr		= (unsigned long)userspace_addr,
-		};
+		if (guest_memfd >= 0) {
+			struct kvm_userspace_memory_region2 mem2 = {
+				.slot			= slot,
+				.flags			= flags | KVM_MEM_GUEST_MEMFD,
+				.guest_phys_addr	= guest_phys,
+				.memory_size		= size,
+				.userspace_addr		= (unsigned long)userspace_addr,
+				.guest_memfd		= guest_memfd,
+				.guest_memfd_offset	= guest_memfd_offset,
+			};
 
-		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
+			ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2,
+				    &mem2);
+		} else {
+			struct kvm_userspace_memory_region mem = {
+				.slot			= slot,
+				.flags			= flags,
+				.guest_phys_addr	= guest_phys,
+				.memory_size		= size,
+				.userspace_addr		= (unsigned long)userspace_addr,
+			};
+
+			ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION,
+				    &mem);
+		}
 		if (ret < 0) {
 			ret = -errno;
 			goto out;
-- 
2.39.5

