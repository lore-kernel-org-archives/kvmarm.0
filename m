Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2E1146901
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041261; cv=none; b=jBjxlxdZoEP9yCpAISAet9EXITC4xaASnKqxYKu2MGicd93iO9CZ+yJzjxEwe791bwwO6vqpeAQrBGWMr2MahD4DH0LetXuKBbuhdc5TRScDyO8++4HsT+JnGmTB5kGngQDvwK4eWiNaYx/dTih1OXf1s+zpyFj9tG7RpkkICIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041261; c=relaxed/simple;
	bh=7QKLk8/MiFSWT7rzgMqDtu0qXhHYiCMoynK98E8XTjg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VK+8BlyDKtOaulhxHjTMwcbJsGs3ItCbLkwuOnH0zUQUaFTL4Mg9CTbZxC1zDi/6OQEDY1GsEIaoVynSXWHQ8Zc9YrLEdyUCzlVWUAPccTgpBL2vWNOJFyM16yAZRPyDBShIFO70NXSv0YTQ7PUKw4/oNOSt6X7bHhTi9qLdQ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B8S2ja0r; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B8S2ja0r"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc05887ee9so288400276.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041258; x=1708646058; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=evAg07Tqv00oZcSIXy7ksZn9JBa6lYxUCa9nTQwmh0k=;
        b=B8S2ja0rXYIBHsvTWtgnL4c2tMv8xv1GibgThyZgFKYrYJ1RsFc/04oshlehP/dFHf
         bm3z7+BqMo2WYnyZYyZ+AZ32yZDCkGN/KH622UxLAPBjHJm7lCdhfde8KWrjPnLm9BRV
         JSjzIYFvqwjndZxppaXEKAu479SxVxzppGOGZcTywl2XU2xtvjwLyWB+0oojJYaDAOdA
         1AgYLUv2yBKK+v9R4tNvJS8aYh90ox514KFSobASWOPSadeLNQLbI8C6pDBK7DG4y107
         4K7S39mt3DxmA8CK0ab0AliqWVI0BUHV2Z6Ddz6hcHCeY3exlLLukNVEtC4sRCXfBbRi
         cMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041258; x=1708646058;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evAg07Tqv00oZcSIXy7ksZn9JBa6lYxUCa9nTQwmh0k=;
        b=b+fyRsIfIJcUSs5peDfdQ+rJBqogEmipQ3qvRgLfqYMkHrYODXaiEBBwSzqiCJpcRW
         Unr3punPaP6CW/gvWr0iX4ypKPWaYMuQhSmEJj9EgjTnO6+UQ3L2aUHivKDqK3hFOPH8
         ugrGBVei9TaqoWILdVl3KyT8QeM1u8ACRvSSzf5d62zferyBOJofae3qwRjTv6n7gxJb
         VvlvC4c5MOcYRsVgVQgQkNS7eYDUgIDdsnoKQI/lkFepiwz912CM+SpuZPkB/ZadpD7Y
         Aov6oj6p4Hx0dgZSRRsIWEOHu5kk6+vkO9KPWdHLCcHJDJavMOY5XVqc8owTjed8n4HO
         oMxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyVgGzD9aSYCrUjhd9XgJsjo7Fq3ow9drUAr2U6HXY1MSkSXPuuGS2/UupB0UhgoxObN2c5JDBo51aLM9F/ycXi66kiW+M
X-Gm-Message-State: AOJu0YxWVCk0FP3Y7ObZyn78h4FR81T2llLJ4+O76ZuhWvBmmrCvQhlh
	xEGtTxoV4FRzbKaRt5853f+KPWJ0RPZsqrKYLZsosec35l49THNd5mI2UXhXpxovWV1YvBtL5Yy
	GkCUgNyw3rQ==
X-Google-Smtp-Source: AGHT+IEL+octx5Ma1aJhkF6nQtctFbc2VuoDa/1F8Y6Hxj4I3Z7U8nf+fteVhEAb2t5g/T3+SnjYzZ3R4wNElA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:100a:b0:dc6:c94e:fb85 with SMTP
 id w10-20020a056902100a00b00dc6c94efb85mr126325ybt.2.1708041258630; Thu, 15
 Feb 2024 15:54:18 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:58 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-8-amoorthy@google.com>
Subject: [PATCH v7 07/14] KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and
 annotate EFAULTs from stage-2 fault handler
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Prevent the stage-2 fault handler from faulting in pages when
KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
calls to check the memslot flag.

To actually make that behavior useful, prepare a KVM_EXIT_MEMORY_FAULT
when the stage-2 handler returns EFAULT, e.g. when it cannot resolve the
pfn. With KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of
stage-2 faults as vCPU exits, which userspace can attempt to resolve
without terminating the guest.

Delivering stage-2 faults to userspace in this way sidesteps the
significant scalabiliy issues associated with using userfaultfd for the
same purpose.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/x86/kvm/Kconfig           | 1 +
 arch/x86/kvm/mmu/mmu.c         | 8 ++++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bf7bc21d56ac..d52757f9e1cb 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8052,7 +8052,7 @@ See KVM_EXIT_MEMORY_FAULT for more information.
 7.35 KVM_CAP_EXIT_ON_MISSING
 ----------------------------
 
-:Architectures: None
+:Architectures: x86
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d43efae05794..09224e306abf 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -44,6 +44,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
+        select HAVE_KVM_EXIT_ON_MISSING
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b89a9518f6de..26388e4f42df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3305,6 +3305,10 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return RET_PF_RETRY;
 	}
 
+	WARN_ON_ONCE(fault->goal_level != PG_LEVEL_4K);
+
+	kvm_prepare_memory_fault_exit(vcpu, gfn_to_gpa(fault->gfn), PAGE_SIZE,
+				      fault->write, fault->exec, fault->is_private);
 	return -EFAULT;
 }
 
@@ -4371,7 +4375,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	async = false;
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
 					  fault->write, &fault->map_writable,
-					  false, &fault->hva);
+					  true, &fault->hva);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4393,7 +4397,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
 					  fault->write, &fault->map_writable,
-					  false, &fault->hva);
+					  true, &fault->hva);
 	return RET_PF_CONTINUE;
 }
 
-- 
2.44.0.rc0.258.g7320e95886-goog

