Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858A63ED3C1
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 08:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783326989; cv=none; b=uWhNuSquGDMjlZUoVmPfsNCO50fQJbrm3fgK8MLf8I74AcDyyToib+exKDf4bIuOc/7JkOh1Hu4i/8cL2qnxm/2011q/8NiYPZ/4MRNIsKyiZkFO4/8NZ0NfMtc9jqon9HV6/qC1XtIEqelepSi10grBv9Z0dxGjGtR3eWu66xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783326989; c=relaxed/simple;
	bh=vl/iryhf9udICuhQXglL/J5ZJ7SSiFYsibHhvsCeNaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p8vP8HAn+2IisuOoSgVP8DG+RkgpLdy8uT5qacQCb0W4ifO34+mWSKFo2rUKpUy/lk5KWlOQJ04TxY+td8Hoou5WTCk6nU1asRU43uhS1vr25QHlNcXPACf+Nx9e0Syv+ascSZwbZG5d5DFQydaCmCRC/ctI8MbBpzMBmYd8hDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FdiueYq8; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FdiueYq8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783326969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EvB+FrHYwLZwyAle5HzB6D+RY21yU1tK+IKQCUMzJJQ=;
	b=FdiueYq8aLnVNoz75vlrH+WzecD9DgMOxHPjoBpSyduh+aExylHFKqU3H6nMgn+2+PhnIn
	DBsz0p2VRZ/o1UUJdc5oKaJGdH+swhLa+32DvdAdyTRy/oKY6r4O9Go0mtT7EXWr4kItAy
	vGG/60YJFEmZhGzlPIMXcSb5lscr474=
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
Subject: [PATCH kvmtool v1 3/5] Use kvm_userspace_memory_region2 for all memory registration
Date: Mon,  6 Jul 2026 09:35:53 +0100
Message-Id: <20260706083555.302972-4-fuad.tabba@linux.dev>
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

Switch kvm__register_mem() and kvm__destroy_mem() from
kvm_userspace_memory_region to kvm_userspace_memory_region2 and
KVM_SET_USER_MEMORY_REGION2 unconditionally. The v2 struct is a
superset; when the extra fields are zero, the ioctl behaves
identically to v1.

This prepares for adding guest_memfd support.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 kvm.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kvm.c b/kvm.c
index 95ccfcb..8a7fd09 100644
--- a/kvm.c
+++ b/kvm.c
@@ -189,7 +189,7 @@ core_exit(kvm__exit);
 int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		     void *userspace_addr)
 {
-	struct kvm_userspace_memory_region mem;
+	struct kvm_userspace_memory_region2 mem;
 	struct kvm_mem_bank *bank;
 	int ret;
 
@@ -213,14 +213,14 @@ int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		goto out;
 	}
 
-	mem = (struct kvm_userspace_memory_region) {
+	mem = (struct kvm_userspace_memory_region2) {
 		.slot			= bank->slot,
 		.guest_phys_addr	= guest_phys,
 		.memory_size		= 0,
 		.userspace_addr		= (unsigned long)userspace_addr,
 	};
 
-	ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
+	ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);
 	if (ret < 0) {
 		ret = -errno;
 		goto out;
@@ -239,7 +239,6 @@ out:
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		      void *userspace_addr, enum kvm_mem_type type)
 {
-	struct kvm_userspace_memory_region mem;
 	struct kvm_mem_bank *merged = NULL;
 	struct kvm_mem_bank *bank;
 	struct list_head *prev_entry;
@@ -320,7 +319,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		flags |= KVM_MEM_READONLY;
 
 	if (type != KVM_MEM_TYPE_RESERVED) {
-		mem = (struct kvm_userspace_memory_region) {
+		struct kvm_userspace_memory_region2 mem = {
 			.slot			= slot,
 			.flags			= flags,
 			.guest_phys_addr	= guest_phys,
@@ -328,7 +327,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 			.userspace_addr		= (unsigned long)userspace_addr,
 		};
 
-		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
+		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);
 		if (ret < 0) {
 			ret = -errno;
 			goto out;
-- 
2.39.5

