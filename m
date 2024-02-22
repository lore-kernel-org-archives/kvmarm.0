Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD25F150996
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618255; cv=none; b=eer9KAKgfFTHWePIp0gt+4uzqsCZ0Pk2BZzKczw6fmHhYQQt//PgbuROTKSz1zajgIygbFOg0XDNihMcqspe762jxknOiIooeuV5GqZ6ZELhYfVG4u1/SY4crkmwN0haECUwXheDexoJi9e3IBX+5WGDYPYAo/IaY71o1+KdfPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618255; c=relaxed/simple;
	bh=EzVThhpsjIFmZ6APONr+3YQMg6Kc3S6m7HggcVHh5j0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aNAs8zlf4ZIYl1/EnfB7hd9At6AHVimvVJb198MVnKi3sPzuCxu2T9QODD0PrLoCt4B0zAu0z7u48LW15AsgKniQ+rXBPd+j0w29pEggA1cMj0xlb1ji3WBPm50022AcXPUW1Kv1YInfftvLP22ntwbP7f7Nd00v3g+9O7lOC+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iIKUIq2G; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iIKUIq2G"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dce775fa8adso3966058276.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618253; x=1709223053; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p2sRNr14w+/34TVEz20+9bKFlKpUm8pWMLvdxv53Wkw=;
        b=iIKUIq2G7Hx0v6ZjLulYhihCm1OeVpUhHsjNNm4OWSx8hlS15w9HFWV/P/VvNN08lp
         lVUKoNvF2UqSbAk7nr9akSttTqzLvPRofvre+W1hV6R85BF/alSol/GQPhMPXbCZPrsO
         tHxp36tLDw2ksR8HXKF+8Tzs1U0QF3+UjfIzd2wEez7G7Sbm7CGzUCQYApnAefPK4eAq
         R44JANpizmz4o9FX18V8lc8duinJ9t7GzuBy0XK1sI/RLHoVqw/q8SFaF2UXi1Z8emlL
         xNnMfT+gceOkED5gKmrgxaCwT7aaTqe4eHX21m1O84BIFsYV7w//kgIhbqQjF49sCVHC
         rrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618253; x=1709223053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p2sRNr14w+/34TVEz20+9bKFlKpUm8pWMLvdxv53Wkw=;
        b=SOTBi8hoMR2klPtggHs2M+mwie7cJhbM9xcPEKji3Ml+Spie3bkslEzHGhrogugfo3
         75NMYd31Y2p16c4HP7xNkho/UfhwMBEmdJG6Lz8BXnjU9tJBpdGBFH6TLPRvADGPYlsd
         ubtLgmmtfW5VYYIummvvGLLuQWlYK9oi59YfdsAdo4pxJmhljd1PxOxMDWGnYmtjF36D
         BAwQtYrJtV8WkxfN77n2Yr9QuAJrvPhZEK8YW8Udu06BCT7B+pLlmA/rW/ZTrnK4YpI4
         WDgnCsgckndRNh+cHcipK4akTYArzHMoDWjrM/vmEuYfSQSHrYCOcV1ajBbexk0+QuW0
         nDNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhNLfUXmrmNr3LNVbzE4pZWeLmKeN6+YigaVZQDnKn2WwUZ8NNsLl0IQBLjFFW4poPgd21PmWvvEcJxW0fdOBqRDzbK5ES
X-Gm-Message-State: AOJu0Ywcv1VU4cgNPr7q/TNuulowvmVvr8gOMBzmAO24iWLhIuFVa6t1
	MYBrYZNZ39m7ONm/5whwlf2cf6SUUNFvWIIyny1UWXks3JN2l1HIl0eYZlKVMrIQfC9+wb6NFQ=
	=
X-Google-Smtp-Source: AGHT+IFYCuijTJVxj0GlLBJa9Pm0/DDmJE1649EzPWKeem3CrEc4NAZWsIRZhFfSZlUHJsQteNJxT4RkUg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:abd0:0:b0:dc6:5396:c0d4 with SMTP id
 v74-20020a25abd0000000b00dc65396c0d4mr723248ybi.1.1708618252702; Thu, 22 Feb
 2024 08:10:52 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:22 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-2-tabba@google.com>
Subject: [RFC PATCH v1 01/26] KVM: Split KVM memory attributes into user and
 kernel attributes
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Currently userspace can set all KVM memory attributes. Future
patches will add new attributes that should only be set by the
kernel.  Split the attribute space into two parts, one that
userspace can set, and one that can only be set by the kernel.

This patch introduces two new functions,
kvm_vm_set_mem_attributes_kernel() and
kvm_vm_set_mem_attributes_user(), whereby each sets the
attributes associated with the kernel or with userspace, without
clobbering the other's attributes.

Since these attributes are stored in an xarray, do the split at
bit 16, so that this would still work on 32-bit architectures if
needed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h |  3 +++
 include/uapi/linux/kvm.h |  3 +++
 virt/kvm/kvm_main.c      | 36 +++++++++++++++++++++++++++++++-----
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7df0779ceaba..4cacf2a9a5d5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1438,6 +1438,9 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 
+int kvm_vm_set_mem_attributes_kernel(struct kvm *kvm, gfn_t start, gfn_t end,
+				     unsigned long attributes);
+
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					struct kvm_memory_slot *slot,
 					gfn_t gfn_offset,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 59e7f5fd74e1..0862d6cc3e66 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -2225,6 +2225,9 @@ struct kvm_memory_attributes {
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
+#define KVM_MEMORY_ATTRIBUTES_KERNEL_SHIFT     (16)
+#define KVM_MEMORY_ATTRIBUTES_KERNEL_MASK      GENMASK(63, KVM_MEMORY_ATTRIBUTES_KERNEL_SHIFT)
+
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 
 struct kvm_create_guest_memfd {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8f0dec2fa0f1..fba4dc6e4107 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2536,8 +2536,8 @@ static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
 }
 
 /* Set @attributes for the gfn range [@start, @end). */
-static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long attributes)
+static int __kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+				      unsigned long attributes, bool userspace)
 {
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
@@ -2559,8 +2559,6 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	void *entry;
 	int r = 0;
 
-	entry = attributes ? xa_mk_value(attributes) : NULL;
-
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range as the desired attributes. */
@@ -2580,6 +2578,17 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	kvm_handle_gfn_range(kvm, &pre_set_range);
 
 	for (i = start; i < end; i++) {
+		/* Maintain kernel/userspace attributes separately. */
+		unsigned long attr = xa_to_value(xa_load(&kvm->mem_attr_array, i));
+
+		if (userspace)
+			attr &= KVM_MEMORY_ATTRIBUTES_KERNEL_MASK;
+		else
+			attr &= ~KVM_MEMORY_ATTRIBUTES_KERNEL_MASK;
+
+		attributes |= attr;
+		entry = attributes ? xa_mk_value(attributes) : NULL;
+
 		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
 				    GFP_KERNEL_ACCOUNT));
 		KVM_BUG_ON(r, kvm);
@@ -2592,6 +2601,23 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	return r;
 }
+
+int kvm_vm_set_mem_attributes_kernel(struct kvm *kvm, gfn_t start, gfn_t end,
+				     unsigned long attributes)
+{
+	attributes &= KVM_MEMORY_ATTRIBUTES_KERNEL_MASK;
+
+	return __kvm_vm_set_mem_attributes(kvm, start, end, attributes, false);
+}
+
+static int kvm_vm_set_mem_attributes_userspace(struct kvm *kvm, gfn_t start, gfn_t end,
+					       unsigned long attributes)
+{
+	attributes &= ~KVM_MEMORY_ATTRIBUTES_KERNEL_MASK;
+
+	return __kvm_vm_set_mem_attributes(kvm, start, end, attributes, true);
+}
+
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes *attrs)
 {
@@ -2617,7 +2643,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	 */
 	BUILD_BUG_ON(sizeof(attrs->attributes) != sizeof(unsigned long));
 
-	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
+	return kvm_vm_set_mem_attributes_userspace(kvm, start, end, attrs->attributes);
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-- 
2.44.0.rc1.240.g4c46232300-goog

