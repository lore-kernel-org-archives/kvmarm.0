Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79F02D4B47
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829769; cv=none; b=BtfUoe5AeVaDrnL3eYJVIUAntNq3RYRuj6BIMGBss0RnOvGHxOoLsROrg99o679Irf02etGBhYLLQ55RQsgcLHnGFQFhjlUr43py29zHFqoqwIACe1eYKNr++DTwKiBumIk4IzCmWjEAe4p2mGqT5acBApom6voxtooRpZ4UZFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829769; c=relaxed/simple;
	bh=vnri19yf9LfJXIcNv1qDJmMwl1WKLHs9dVfwzDC2NUk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QIWAAcN7Mqk4UWIuO9NEjYh9vSxrRq4XbgNNKMUpW0EZsQzHaFfdhJFdOvIjRz2AE0zgbUo7F25rk3FZ/+Cqdl/K7+dSdxLgG3d9YemDMsGyYJpXxxSqjzpjlXvO2jwhyCmFGA2cDSgvAspJDDUl2rb+f7FxEtbSWR2/nN3Ve/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=esyOf1Q0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="esyOf1Q0"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso10559851a91.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829767; x=1754434567; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CDh3a2mKi2563DqkffKvhXA2J/RouDXBIlWaKp9FKZM=;
        b=esyOf1Q0mEquO+QpgWz713k5afomg5Zpqw7/t2bEBPuiAxlHYlcazAeBRfJF29c9ZF
         k5WVADd/11mdahJ20tVtkleClv6eFAOzzPlSq3xGm9bSK/b+5glBwsfJOnbmDtb/bzIn
         upCQnUJfXqeibM/beZFAH/TPWWavtxIkDzq4GRBsj0w5y2q1v7GI6gVlz6UfL9H3JBRC
         iOgWiPT02sc3o9HL7cOrMvDsxhvDqnKlLn7gKA+rYVmFZtAJ1TOOZxKaDNoEWuYi+TC8
         1baw8bTPVENMHU2+aUQdrweUmL1Ne9s698CHF3yA7GNDgN/FT/Wi01zMXeYTo+odZjvU
         SIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829767; x=1754434567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CDh3a2mKi2563DqkffKvhXA2J/RouDXBIlWaKp9FKZM=;
        b=wmvixu1q9hxobBXlwvfswLhRRdoyU8um6yT8UQF7L2MyA4Vt0uFKAzHRMkYlv6FgKp
         z0sc6GC2buWk8VZvwDXOT0kGvQj09htd0VFA90MEVnsUL65GN6OnqCgxEi7WoAOS56WH
         RlsTQfiaGWMiUk1JtEkxo34W3cAgZdwxeEpMXQgQPoX3JGJoMNFyR340LP8wc5zGDI6I
         zSspd/wc0DTPvRAgJhwJBGUChDj5MLutwujVBa1qOpF7wy3v9OREKTh4YhYcSbOdGZ+o
         N+vxnQentZ3Qa/KwOjvNviM041tVYRJPc/44xZVT7Z4FhlNAN/4G8a6UHtFrtANx57U/
         cGTg==
X-Forwarded-Encrypted: i=1; AJvYcCWpQC6NIKsSd47/fKvXRkUnHWMzdjZy0H5Wut4eCCDrngwfcdfuYEwv8ctqW6Ehj/nC4PKFDrs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVLZ+v3Bp0et86TKwddQkj2yAZpQqHTemoLhRBZHQu3PMr2TDI
	2WXUjB4KVlpT/YrJ7esv1wRlXrVUgsIKyATOff1lAApZiZAHKZAzDwOYITVkM25UTkwnZXpRW9f
	bicu/Jg==
X-Google-Smtp-Source: AGHT+IHC3uJKuTdSzXOEtHPqlvC+coV4BnnQv6uc7mWxcOspxNE/dt4wFfxxPGUhBzxbDLgfuxcg7hNN5F0=
X-Received: from pjg6.prod.google.com ([2002:a17:90b:3f46:b0:31c:bd1d:516])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a81:b0:31f:210d:2e56
 with SMTP id 98e67ed59e1d1-31f5de557femr1551448a91.28.1753829767333; Tue, 29
 Jul 2025 15:56:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:52 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-22-seanjc@google.com>
Subject: [PATCH v17 21/24] KVM: Allow and advertise support for host mmap() on
 guest_memfd files
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

Now that all the x86 and arm64 plumbing for mmap() on guest_memfd is in
place, allow userspace to set GUEST_MEMFD_FLAG_MMAP and advertise support
via a new capability, KVM_CAP_GUEST_MEMFD_MMAP.

The availability of this capability is determined per architecture, and
its enablement for a specific guest_memfd instance is controlled by the
GUEST_MEMFD_FLAG_MMAP flag at creation time.

Update the KVM API documentation to detail the KVM_CAP_GUEST_MEMFD_MMAP
capability, the associated GUEST_MEMFD_FLAG_MMAP, and provide essential
information regarding support for mmap in guest_memfd.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 9 +++++++++
 include/uapi/linux/kvm.h       | 2 ++
 virt/kvm/guest_memfd.c         | 7 ++++++-
 virt/kvm/kvm_main.c            | 2 ++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fcb783735dd1..1e0c4a68876d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6414,6 +6414,15 @@ most one mapping per page, i.e. binding multiple memory regions to a single
 guest_memfd range is not allowed (any number of memory regions can be bound to
 a single guest_memfd file, but the bound ranges must not overlap).
 
+When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
+supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
+enables mmap() and faulting of guest_memfd memory to host userspace.
+
+When the KVM MMU performs a PFN lookup to service a guest fault and the backing
+guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
+consumed from guest_memfd, regardless of whether it is a shared or a private
+fault.
+
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
 4.143 KVM_PRE_FAULT_MEMORY
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index aeb2ca10b190..0d96d2ae6e5d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -961,6 +961,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_GUEST_MEMFD_MMAP 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1597,6 +1598,7 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_MMAP	(1ULL << 0)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d5b445548af4..08a6bc7d25b6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -314,7 +314,9 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 
 static bool kvm_gmem_supports_mmap(struct inode *inode)
 {
-	return false;
+	const u64 flags = (u64)inode->i_private;
+
+	return flags & GUEST_MEMFD_FLAG_MMAP;
 }
 
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
@@ -522,6 +524,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 flags = args->flags;
 	u64 valid_flags = 0;
 
+	if (kvm_arch_supports_gmem_mmap(kvm))
+		valid_flags |= GUEST_MEMFD_FLAG_MMAP;
+
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4f57cb92e109..18f29ef93543 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4918,6 +4918,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_GUEST_MEMFD
 	case KVM_CAP_GUEST_MEMFD:
 		return 1;
+	case KVM_CAP_GUEST_MEMFD_MMAP:
+		return !kvm || kvm_arch_supports_gmem_mmap(kvm);
 #endif
 	default:
 		break;
-- 
2.50.1.552.g942d659e1b-goog

