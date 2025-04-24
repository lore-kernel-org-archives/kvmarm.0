Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93B128E5F0
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504063; cv=none; b=T4WQqy52np06EJ1fIW9ka/vFKWCrfURgkgLAHxdDyoK4pPv7lTnZ7LyGFLxSgptlGHhjZKYxKAhyw82RBsOuuHYqkHTqoqVJyyCy+98cv0xXkoxF4d3HZYtiEd9ldk7RQaB0mMohq61DSKrGonR634rSlaf3yqI9YSTHBLwRlyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504063; c=relaxed/simple;
	bh=NPLvNPRTGZlQyPSKuchNVhThznQp0bCS99QwrEGsnQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=inxueU3MJUXq4hboAa3eqIY8gVa4HCDu2hVsfXNYSpWO9YexHAX/fZi89C1n7p/i5LOSUPLSPWU6ShcQ4Bq5hp6u4pKxlLo7/CbSh+BK9tqJUlc48GHKrC6BV/BO3uxwjACPAJ0VniuJAahWjGv5KJft/3A5pBnLZ064eOGWmxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TT9hx3zL; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TT9hx3zL"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4394a823036so10603075e9.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504056; x=1746108856; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2LhbI7ata+xuMo4MQ3LDVVCBYF7iuDckOVgkFelFFVk=;
        b=TT9hx3zLFZon4sPamRGRVJOkfe3KYBfm85RaVKKdjIYsuDS1Eap30BRbdPHMqyrVu+
         ShRBXQ/NGrQefYv2mlWdmBU7QUSmr7j28WdPU9kklRAdMbIlhgtMw5y4OCmTC9L7OHFs
         Uh0E/DYS2NtXIBAJ1F7BeawO8hekdSqN6GGW37Fye4WYuinZROAtSYRCXq4zSq7FFmH/
         y7dLHoxOfASTIsH9GIE65B2FgrUbNgz3gWuNO4Mat4mE3bvBJRNPCwUcZGliTA/4hvG9
         g5Ss12LjgfEgBMHRGvjQd7FBSPsWAffPFXdatm9i2EBawxpiHdi1D3hSXTbxL4GKGjzU
         Wy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504056; x=1746108856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2LhbI7ata+xuMo4MQ3LDVVCBYF7iuDckOVgkFelFFVk=;
        b=N0G9L1ih3iD2THWpfSGzaMIRJzKZMJBuY7YL75JLTuLgT+m0Hx8yt8LmG/mgd5YU+D
         PD4RYXgsviLlgVGD0RUbwua+5y4btA3wsDfOLHk7g6WT1lZqaNq2P/shoX+skJDSvEKB
         BhIyFTe1OOSHVEThOUVQWle2PCXnZsKYPXHqtiF1kGcwgoRR3DzqWsPdqXeVW0PGoGHb
         Q1DsWnEpHfLKibUI0ZTkGTEU3otBSKnqtOFMv8Utis+ye4oTYbNRNkq1/ck5ffWI7qGf
         hm4vf3ay2rEm0oDvhPixKxkt+d2T3CXjxySXUQwZsbStTaw8N4p0+eyN/4dmaL0JmT0A
         50yw==
X-Forwarded-Encrypted: i=1; AJvYcCWCfhfnIWKR3ZMg458M1fbIceNI3f/e4BUtHrF2q/vNDntILcezTRBDcIFXm/H4mrFCtUuFJ/M=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZPPcSf5GMBxij3YwMl4vY9/m4Zyshpjafc6ULkQHjzls+Jk1e
	fENP8sc9G3S4mv3HdIWYdkp+lkeVCNTzCkZxTwwJkg/xRjaWAhQJ0nPFAKeGLmI=
X-Gm-Gg: ASbGncs57myxWrfCkTp9dIBPJgcPG8kosKH+FLVnu7h3RS/lwv5tl04EvYcGKpWn1Np
	bsJ6MY1aZq0qgVzJxBWONQj+aa4Z7+WbO+Jtaaz1rd+DhMRICUYxbFajfFVMnrIp8tSMkflwf3h
	+HOcqLhcWHm/iFjq5/rxltPrDaLUGvN7E1JHbuXP4vhM7Bp4+kJwulktznvLSfCz4m49mCVLKdz
	wh4G8UIuNbjChEc8L4f4t6bzaU/eM2JUXOFx3R9HTfC+XfndJ+4uFrg+bqw2RXC9Gz1pCtvJVHm
	Mb1ZP9MryAYLdUaiDsv8sen/SowGtOYzSktZxlh15/tiuG6ezHr6Fcdeh9ZiTlF05ebcm1fzPjq
	IUxnG0nwasnVjJK1x
X-Google-Smtp-Source: AGHT+IHqcrFkop2AMczZB7InA+Ahpw3ClIzGk7Xop+jnijaBOC/Y4QzTBvOvzogG1ZcwEVc5x1XCjQ==
X-Received: by 2002:a05:600c:8106:b0:440:6852:5b31 with SMTP id 5b1f17b1804b1-4409bd0d902mr31333525e9.10.1745504055954;
        Thu, 24 Apr 2025 07:14:15 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:15 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [RFC PATCH 23/34] gunyah: Add interfaces to map memory into guest address space
Date: Thu, 24 Apr 2025 15:13:30 +0100
Message-Id: <20250424141341.841734-24-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Elliot Berman <quic_eberman@quicinc.com>

This patch is a subset of [1], without gunyah guest-memfd parts.
I added the original commit message below.

[1] https://lore.kernel.org/lkml/20240222-gunyah-v17-20-1e9da6763d38@quicinc.com/
---
 arch/arm64/kvm/gunyah.c | 212 +++++++++++++++++++++++++++++++++++++++-
 include/linux/gunyah.h  |   6 ++
 2 files changed, 217 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index e066482c2e71..5d18d133df50 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -10,8 +10,8 @@
 #include <linux/cpumask.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm_irqfd.h>
-#include <asm/kvm_mmu.h>
 #include <linux/perf_event.h>
+#include <asm/kvm_mmu.h>
 
 #include <linux/gunyah_rsc_mgr.h>
 #include <linux/gunyah.h>
@@ -19,6 +19,15 @@
 #undef pr_fmt
 #define pr_fmt(fmt) "gunyah: " fmt
 
+#define GUNYAH_VM_ADDRSPACE_LABEL			0
+#define GUNYAH_VM_MEM_EXTENT_GUEST_PRIVATE_LABEL	0
+#define GUNYAH_VM_MEM_EXTENT_HOST_SHARED_LABEL		1
+#define GUNYAH_VM_MEM_EXTENT_GUEST_SHARED_LABEL		3
+#define GUNYAH_VM_MEM_EXTENT_HOST_PRIVATE_LABEL		2
+
+#define WRITE_TAG (1 << 0)
+#define SHARE_TAG (1 << 1)
+
 static int gunyah_vm_start(struct gunyah_vm *ghvm);
 
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
@@ -332,6 +341,23 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	}
 }
 
+static bool gunyah_vm_resource_ticket_populate_noop(
+	struct gunyah_vm_resource_ticket *ticket, struct gunyah_resource *ghrsc)
+{
+	return true;
+}
+static void gunyah_vm_resource_ticket_unpopulate_noop(
+	struct gunyah_vm_resource_ticket *ticket, struct gunyah_resource *ghrsc)
+{
+}
+
+static inline struct gunyah_resource *
+__first_resource(struct gunyah_vm_resource_ticket *ticket)
+{
+	return list_first_entry_or_null(&ticket->resources,
+					struct gunyah_resource, list);
+}
+
 static int gunyah_vm_add_resource_ticket(struct gunyah_vm *ghvm,
 				  struct gunyah_vm_resource_ticket *ticket)
 {
@@ -430,6 +456,159 @@ static void gunyah_vm_clean_resources(struct gunyah_vm *ghvm)
 	mutex_unlock(&ghvm->resources_lock);
 }
 
+static inline u32 donate_flags(bool share)
+{
+	if (share)
+		return FIELD_PREP_CONST(GUNYAH_MEMEXTENT_OPTION_TYPE_MASK,
+					GUNYAH_MEMEXTENT_DONATE_TO_SIBLING);
+	else
+		return FIELD_PREP_CONST(GUNYAH_MEMEXTENT_OPTION_TYPE_MASK,
+					GUNYAH_MEMEXTENT_DONATE_TO_PROTECTED);
+}
+
+static inline u32 reclaim_flags(bool share)
+{
+	if (share)
+		return FIELD_PREP_CONST(GUNYAH_MEMEXTENT_OPTION_TYPE_MASK,
+					GUNYAH_MEMEXTENT_DONATE_TO_SIBLING);
+	else
+		return FIELD_PREP_CONST(GUNYAH_MEMEXTENT_OPTION_TYPE_MASK,
+					GUNYAH_MEMEXTENT_DONATE_FROM_PROTECTED);
+}
+
+static int gunyah_memory_provide_folio(struct gunyah_vm *ghvm,
+		struct folio *folio, gfn_t gfn, bool share, bool write)
+{
+	struct gunyah_resource *guest_extent, *host_extent, *addrspace;
+	u32 map_flags = BIT(GUNYAH_ADDRSPACE_MAP_FLAG_PARTIAL);
+	u64 extent_attrs;
+	gfn_t gpa = gfn_to_gpa(gfn);
+	phys_addr_t pa = PFN_PHYS(folio_pfn(folio));
+	enum gunyah_pagetable_access access;
+	size_t size = folio_size(folio);
+	enum gunyah_error gunyah_error;
+	unsigned long tag = 0;
+	int ret;
+
+	if (share) {
+		guest_extent = __first_resource(&ghvm->guest_shared_extent_ticket);
+		host_extent = __first_resource(&ghvm->host_shared_extent_ticket);
+	} else {
+		guest_extent = __first_resource(&ghvm->guest_private_extent_ticket);
+		host_extent = __first_resource(&ghvm->host_private_extent_ticket);
+	}
+	addrspace = __first_resource(&ghvm->addrspace_ticket);
+
+	if (!addrspace || !guest_extent || !host_extent)
+		return -ENODEV;
+
+	if (share) {
+		map_flags |= BIT(GUNYAH_ADDRSPACE_MAP_FLAG_VMMIO);
+		tag |= SHARE_TAG;
+	} else {
+		map_flags |= BIT(GUNYAH_ADDRSPACE_MAP_FLAG_PRIVATE);
+	}
+
+	if (write)
+		tag |= WRITE_TAG;
+
+	if (share && write)
+		access = GUNYAH_PAGETABLE_ACCESS_RW;
+	else if (share && !write)
+		access = GUNYAH_PAGETABLE_ACCESS_R;
+	else if (!share && write)
+		access = GUNYAH_PAGETABLE_ACCESS_RWX;
+	else /* !share && !write */
+		access = GUNYAH_PAGETABLE_ACCESS_RX;
+
+	gunyah_error = gunyah_hypercall_memextent_donate(donate_flags(share),
+							 host_extent->capid,
+							 guest_extent->capid,
+							 pa, size);
+	if (gunyah_error != GUNYAH_ERROR_OK) {
+		pr_err("Failed to donate memory for guest address 0x%016llx: %d\n",
+		       gpa, gunyah_error);
+		return gunyah_error_remap(gunyah_error);
+	}
+
+	extent_attrs =
+		FIELD_PREP_CONST(GUNYAH_MEMEXTENT_MAPPING_TYPE,
+				 ARCH_GUNYAH_DEFAULT_MEMTYPE) |
+		FIELD_PREP(GUNYAH_MEMEXTENT_MAPPING_USER_ACCESS, access) |
+		FIELD_PREP(GUNYAH_MEMEXTENT_MAPPING_KERNEL_ACCESS, access);
+	gunyah_error = gunyah_hypercall_addrspace_map(addrspace->capid,
+						      guest_extent->capid, gpa,
+						      extent_attrs, map_flags,
+						      pa, size);
+	if (gunyah_error != GUNYAH_ERROR_OK) {
+		pr_err("Failed to map guest address 0x%016llx: %d\n", gpa,
+		       gunyah_error);
+		ret = gunyah_error_remap(gunyah_error);
+		goto memextent_reclaim;
+	}
+
+	return 0;
+memextent_reclaim:
+	gunyah_error = gunyah_hypercall_memextent_donate(reclaim_flags(share),
+							 guest_extent->capid,
+							 host_extent->capid, pa,
+							 size);
+	if (gunyah_error != GUNYAH_ERROR_OK)
+		pr_err("Failed to reclaim memory donation for guest address 0x%016llx: %d\n",
+		       gpa, gunyah_error);
+	return ret;
+}
+
+static int gunyah_memory_reclaim_folio(struct gunyah_vm *ghvm,
+		struct folio *folio, gfn_t gfn, bool share)
+{
+	u32 map_flags = BIT(GUNYAH_ADDRSPACE_MAP_FLAG_PARTIAL);
+	struct gunyah_resource *guest_extent, *host_extent, *addrspace;
+	enum gunyah_error gunyah_error;
+	phys_addr_t pa;
+	size_t size;
+	int ret;
+
+	addrspace = __first_resource(&ghvm->addrspace_ticket);
+	if (!addrspace)
+		return -ENODEV;
+
+	guest_extent = __first_resource(&ghvm->guest_private_extent_ticket);
+	host_extent = __first_resource(&ghvm->host_private_extent_ticket);
+	map_flags |= BIT(GUNYAH_ADDRSPACE_MAP_FLAG_PRIVATE);
+
+	pa = PFN_PHYS(folio_pfn(folio));
+	size = folio_size(folio);
+
+	gunyah_error = gunyah_hypercall_addrspace_unmap(addrspace->capid,
+							guest_extent->capid,
+							gfn_to_gpa(gfn),
+							map_flags, pa, size);
+	if (gunyah_error != GUNYAH_ERROR_OK) {
+		pr_err_ratelimited(
+			"Failed to unmap guest address 0x%016llx: %d\n",
+			gfn_to_gpa(gfn), gunyah_error);
+		ret = gunyah_error_remap(gunyah_error);
+		goto err;
+	}
+
+	gunyah_error = gunyah_hypercall_memextent_donate(reclaim_flags(share),
+							 guest_extent->capid,
+							 host_extent->capid, pa,
+							 size);
+	if (gunyah_error != GUNYAH_ERROR_OK) {
+		pr_err_ratelimited(
+			"Failed to reclaim memory donation for guest address 0x%016llx: %d\n",
+			gfn_to_gpa(gfn), gunyah_error);
+		ret = gunyah_error_remap(gunyah_error);
+		goto err;
+	}
+
+	return 0;
+err:
+	return ret;
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -1357,6 +1536,17 @@ static int gunyah_vm_start(struct gunyah_vm *ghvm)
 	return ret;
 }
 
+static inline void setup_extent_ticket(struct gunyah_vm *ghvm,
+				       struct gunyah_vm_resource_ticket *ticket,
+				       u32 label)
+{
+	ticket->resource_type = GUNYAH_RESOURCE_TYPE_MEM_EXTENT;
+	ticket->label = label;
+	ticket->populate = gunyah_vm_resource_ticket_populate_noop;
+	ticket->unpopulate = gunyah_vm_resource_ticket_unpopulate_noop;
+	gunyah_vm_add_resource_ticket(ghvm, ticket);
+}
+
 static struct gunyah_vm *gunyah_vm_alloc(struct gunyah_rm *rm)
 {
 	struct gunyah_vm *ghvm;
@@ -1375,6 +1565,20 @@ static struct gunyah_vm *gunyah_vm_alloc(struct gunyah_rm *rm)
 	INIT_LIST_HEAD(&ghvm->resources);
 	INIT_LIST_HEAD(&ghvm->resource_tickets);
 
+	ghvm->addrspace_ticket.resource_type = GUNYAH_RESOURCE_TYPE_ADDR_SPACE;
+	ghvm->addrspace_ticket.label = GUNYAH_VM_ADDRSPACE_LABEL;
+	ghvm->addrspace_ticket.populate = gunyah_vm_resource_ticket_populate_noop;
+	ghvm->addrspace_ticket.unpopulate = gunyah_vm_resource_ticket_unpopulate_noop;
+	gunyah_vm_add_resource_ticket(ghvm, &ghvm->addrspace_ticket);
+
+	setup_extent_ticket(ghvm, &ghvm->host_private_extent_ticket,
+			    GUNYAH_VM_MEM_EXTENT_HOST_PRIVATE_LABEL);
+	setup_extent_ticket(ghvm, &ghvm->host_shared_extent_ticket,
+			    GUNYAH_VM_MEM_EXTENT_HOST_SHARED_LABEL);
+	setup_extent_ticket(ghvm, &ghvm->guest_private_extent_ticket,
+			    GUNYAH_VM_MEM_EXTENT_GUEST_PRIVATE_LABEL);
+	setup_extent_ticket(ghvm, &ghvm->guest_shared_extent_ticket,
+			    GUNYAH_VM_MEM_EXTENT_GUEST_SHARED_LABEL);
 	return ghvm;
 }
 
@@ -1389,6 +1593,12 @@ static void gunyah_destroy_vm(struct gunyah_vm *ghvm)
 	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_RUNNING)
 		gunyah_vm_stop(ghvm);
 
+	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->addrspace_ticket);
+	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_shared_extent_ticket);
+	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_private_extent_ticket);
+	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->guest_shared_extent_ticket);
+	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->guest_private_extent_ticket);
+
 	gunyah_vm_clean_resources(ghvm);
 
 	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_EXITED ||
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index 2648d3a623de..d1048d0fc246 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/kvm_host.h>
 
+#include <asm/gunyah.h>
 #include <linux/gunyah_rsc_mgr.h>
 
 #define gunyah_vcpu(kvm_vcpu_ptr) \
@@ -107,6 +108,11 @@ struct gunyah_vm {
 	struct list_head resources;
 	struct list_head resource_tickets;
 	enum gunyah_rm_vm_auth_mechanism auth;
+	struct gunyah_vm_resource_ticket addrspace_ticket;
+	struct gunyah_vm_resource_ticket host_private_extent_ticket;
+	struct gunyah_vm_resource_ticket host_shared_extent_ticket;
+	struct gunyah_vm_resource_ticket guest_private_extent_ticket;
+	struct gunyah_vm_resource_ticket guest_shared_extent_ticket;
 };
 
 /**
-- 
2.39.5

