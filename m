Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A231289357
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829740; cv=none; b=hgjgSwwqZTRvACWI5MeIUW8ELTPezqQVBzsQBDkngHebfHFtKvIRbIS8/OH2nKrQSdZ/+mnHWLi+vn+KHyu7251gdzryBt/g+xiYUh+AkjPYi+3kXHBQ2DbWCpPlubw1SNHnzW3SfqphwN6/OzKkiaN9i3TtEskgDG850uXe30I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829740; c=relaxed/simple;
	bh=1G471Ztcvd9/EAbr4zfSr/Pr5YCZ5sKUbrndZzoQZd4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OicUnRX9rWR/WCaH5RZq9y1v/hCl9tTbyY+UGxXIKkmZUjJ2wsGqT1zMO2p4ircyTZEpbo1ngynMME9o0tUk7DWeRHBkUWf9j0LnC0CIgINy6GNyGKozD4ynTw+cUPdW/kSj2ggHcvZ8SIESZ9TkPhjYkSWK2l2KhIyhmRQNYQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W6sEfm0d; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W6sEfm0d"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748f30d56d1so136309b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829738; x=1754434538; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=c+/NMJmsylkoBC4gWvcEbFQsUKJfGfTOY8uMnbEW6yY=;
        b=W6sEfm0dVMpZwHCs6kuoTjoqgS/KZG4iQ3rHnNip9iATBbGaMUpAVAnjYbUiIUpvAq
         1duuMOT+tAL7QTnGdHmVqRmfejdpyALpwI9CzUbX4D0l4wBUXbYFgFujBxYIR3wh2cVo
         O+qytalcQRNtGLtJtrT9NpJ5Z4bBXoj01jVl7jL/HTZ9ynx2DIU0w0pFTLGITL08XEEY
         uCmR3pXlWVqK8OnlnioLBY+YiOHb6leHNzuzqJeddvCnUK2gtjmGJNWF8wsLr+c0FLmW
         Ql8wzMWNm/JX5H7ugZYdkrjGMhk8kFifuqjT1QMFZVVZ5UldmzsBtV9MjdB+JRQvJiaC
         7tLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829738; x=1754434538;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c+/NMJmsylkoBC4gWvcEbFQsUKJfGfTOY8uMnbEW6yY=;
        b=JsIvDX0aVQ/qVwhBItpkvRuSdoNod1bsNTwGdA+Vu7Sw5VL/0fEtmW3U2VsjmPq6cX
         NVKbQR/2vWe3h4Yg1EmV0KFUwOfA5sUBDSCHhTJbnG25zk0Mc8LTAHKyszU37SzYdGgj
         1QmuCRc0L1NswIuQfBI5Z5wjToI7MOJIzWbwMn2XPQGcYQEhNpy20NmJvnEMQOvuhgDm
         6MrwWM7GmVuyN4IgjTnyUwM2iQhqdQ5wqncPoHx4TYcdaCpLZueieXqgyi4ZXehyZzHq
         rlT1vgemjfZBuVNy52NN5qDUeHdzL4nG+f3i8JSTL2f3WzKYjadGeMYIwqnpl9Nv5OQx
         p34Q==
X-Forwarded-Encrypted: i=1; AJvYcCUfSKsDV7GIY9xVyfXFEYIYk0rDx1QrssWFUXlc3SJgGljrhWcV1ixZn1Tg1ACvfnwUN/F/c44=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3BQ2KjC3vajwNgP/eUoU8LJcRuks6omidDvstsrDjgptXtygu
	/WDu8S404mRLxC2+Crde6qvq9JncRWazFwvZbRlAUIum9jqGopxY3ZnFjayJrxvzJ5AjVm3hCUG
	xlr1rIA==
X-Google-Smtp-Source: AGHT+IH4iSr5KwLJmRVqnNug5aDy8pe70mqGviSCJM20Gbtyqe1yxZEdeYq4VIFoxas+vnB8AcFiz0D+NEw=
X-Received: from pfbhm20.prod.google.com ([2002:a05:6a00:6714:b0:748:f270:c438])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:88d1:0:b0:74b:4d96:d159
 with SMTP id d2e1a72fcca58-76aad77f4d6mr1711853b3a.0.1753829738459; Tue, 29
 Jul 2025 15:55:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:36 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-6-seanjc@google.com>
Subject: [PATCH v17 05/24] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
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

The original name was vague regarding its functionality. This Kconfig
option specifically enables and gates the kvm_gmem_populate() function,
which is responsible for populating a GPA range with guest data.

The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
option: to enable arch-specific guest_memfd population mechanisms. It
also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
options.

This improves clarity for developers and ensures the name accurately
reflects the functionality it controls, especially as guest_memfd
support expands beyond purely "private" memory scenarios.

Temporarily keep KVM_GENERIC_PRIVATE_MEM as an x86-only config so as to
minimize churn, and to hopefully make it easier to see what features
require HAVE_KVM_ARCH_GMEM_POPULATE.  On that note, omit GMEM_POPULATE
for KVM_X86_SW_PROTECTED_VM, as regular ol' memset() suffices for
software-protected VMs.

As for KVM_GENERIC_PRIVATE_MEM, a future change will select KVM_GUEST_MEMFD
for all 64-bit KVM builds, at which point the intermediate config will
become obsolete and can/will be dropped.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig     | 14 ++++++++++----
 include/linux/kvm_host.h |  2 +-
 virt/kvm/Kconfig         |  9 ++++-----
 virt/kvm/guest_memfd.c   |  2 +-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 13ab7265b505..c763446d9b9f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -79,11 +79,16 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
+config KVM_X86_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_GUEST_MEMFD
+	bool
+
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_X86_PRIVATE_MEM
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -133,8 +138,8 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_GENERIC_PRIVATE_MEM
-	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select KVM_X86_PRIVATE_MEM
+	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
 	  confidential VMs on Intel processors.
@@ -157,9 +162,10 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_X86_PRIVATE_MEM
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
+	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching encrypted VMs which use Secure
 	  Encrypted Virtualization (SEV), Secure Encrypted Virtualization with
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8cdc0b3cc1b1..ddfb6cfe20a6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2534,7 +2534,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
 /**
  * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
  *
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index e4b400feff94..1b7d5be0b6c4 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -116,11 +116,6 @@ config KVM_GUEST_MEMFD
        select XARRAY_MULTI
        bool
 
-config KVM_GENERIC_PRIVATE_MEM
-       select KVM_GENERIC_MEMORY_ATTRIBUTES
-       select KVM_GUEST_MEMFD
-       bool
-
 config HAVE_KVM_ARCH_GMEM_PREPARE
        bool
        depends on KVM_GUEST_MEMFD
@@ -128,3 +123,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_GUEST_MEMFD
+
+config HAVE_KVM_ARCH_GMEM_POPULATE
+       bool
+       depends on KVM_GUEST_MEMFD
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 7d85cc33c0bb..b2b50560e80e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -627,7 +627,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
-#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
-- 
2.50.1.552.g942d659e1b-goog

