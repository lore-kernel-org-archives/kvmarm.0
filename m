Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com [209.85.222.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C72B38F9A
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l3+vlMYm"
Received: by mail-qk1-f201.google.com with SMTP id af79cd13be357-778a738a523so148501685a.0
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563833; x=1700168633; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOcXPtnv49h6RAm6cS9G5VMrOnN29qVgKtjpOURCfKY=;
        b=l3+vlMYmNUK+aFvSs/rDnXsnDcyj+NdiYutZyQx/Vvv6y7WyiX7UhLe/PO4nHgldpq
         83sVl7pS7MuZDmzU+v310Hobpyw+NixEqc6BAag3ncHkpcPF8wHsQNG39bAjbB0VX1ON
         nPUDSMzz5umy9jk257jyH46Nxx1K0bMie2UotbAR/n34QbwnX9rPpC6nGW0n/TLb9Udw
         amiFbi8z9XbD1zmOx+/6PXedG/VlkgWGflXeWu69nZoINEf5wNOheW81WU/YZng8scvQ
         6F5+cq9uWlIdPTjhqbRE0GzTDm9kSa0MwctpqRl6z09+4Ly1A96ttZR7bNRFCcuNS0Bq
         s7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563833; x=1700168633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FOcXPtnv49h6RAm6cS9G5VMrOnN29qVgKtjpOURCfKY=;
        b=YjSZxo9w43qToLxKA/HH42whyet1hlPfN3aPMz7AHc79FGmRAskHJY7k1oNd46pty2
         LDK8Sx/d8m/K5nA5Hj5r5+0mSH3c8HPeXKXQVUWRe7K2lcEbfcuIsTR8Wuhe1ogptIT8
         5ZTN7LkR2jAjevP3ZN/M86INipMVju2OaOdcBYfu0QVmyKIh4zJvMccvv0/e0lLzO/jY
         eJTZW1XBYWO7X/pVnLa3OjTaUKCHPA/fiz1MXblOfTRO8Hx5JWbf7U9wMsFDc/icmPT3
         A5UMGT32f5tuUYDAVSa+wV/RStVbwIc5gXMucEhHUgFyr19qJQeS3uJ/d7tWb4sK+KBz
         9pHA==
X-Gm-Message-State: AOJu0Yxy+Rzx/QXDqcJVxaqgDI2PvA/2G1Mkc9118iMnyUGMp0ATHH9j
	PNBa0kAD+oI+hsOqsumVV7IpS8twCcFo/A==
X-Google-Smtp-Source: AGHT+IEPvmgFr/ZO9CbrgP1bKZHB0+G4ikHM0pFYVGxmjxS0Pviry7UBKDcbDGJlyuhvYt2yNZUCp14aW3sEOA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:620a:4509:b0:775:7572:4e62 with SMTP
 id t9-20020a05620a450900b0077575724e62mr188628qkp.2.1699563833047; Thu, 09
 Nov 2023 13:03:53 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:20 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-10-amoorthy@google.com>
Subject: [PATCH v6 09/14] KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and
 annotate an EFAULT from stage-2 fault-handler
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Prevent the stage-2 fault handler from faulting in pages when
KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
calls to check the memslot flag.

To actually make that behavior useful, prepare a KVM_EXIT_MEMORY_FAULT
when the stage-2 handler cannot resolve the pfn for a fault. With
KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of stage-2
faults as vCPU exits, which userspace can attempt to resolve without
terminating the guest.

Delivering stage-2 faults to userspace in this way sidesteps the
significant scalabiliy issues associated with using userfaultfd for the
same purpose.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/Kconfig         | 1 +
 arch/arm64/kvm/mmu.c           | 7 +++++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fd87bbfbfdf2..67fcb9dbe855 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8068,7 +8068,7 @@ See KVM_EXIT_MEMORY_FAULT for more information.
 7.35 KVM_CAP_EXIT_ON_MISSING
 ----------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 1a777715199f..d6fae31f7e1a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -43,6 +43,7 @@ menuconfig KVM
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select INTERVAL_TREE
 	select XARRAY_MULTI
+        select HAVE_KVM_EXIT_ON_MISSING
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 13066a6fdfff..3b9fb80672ac 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1486,13 +1486,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, false, NULL);
+				   write_fault, &writable, true, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE_SIZE,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
-- 
2.42.0.869.gea05f2083d-goog

