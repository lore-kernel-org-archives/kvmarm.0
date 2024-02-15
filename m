Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE45146908
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041261; cv=none; b=Pxs1Z9ltsOtpssCB4rOQmEh+WwF2EcYoMayKohudDbXx7iBhP7gHF9DXmnD0wwkcr6FCoiRN1/5jEMdWraKeE1yQSOX2Blr9+oCOujDuDcpgqN/LsvRFjuf7ZqZwOm0xhxLbJkVlwjR0bvtMIBgiYp7EKY7wiEdlxZ23obt9ADw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041261; c=relaxed/simple;
	bh=eLQTZ0Bt1CIZ9NPrKNRT5DeFFxc1SAR3qmaE7o5Oe8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CDCxQX/xZb6MzTIAloE8N+MtTK/BtQF+OrTH8tPm6N2ve7qPaQULGLnOpnIFRB+oZclb1mzkMwCMmJWRDO2y+f1B4cpdsQjGxYZ6lcpf3jefFd0/ucLYy50Zb92g6+jULNiwsZDeC58wav0NKlnvf3qSye8ybky0+6pjhXEnWPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vSVYj2mE; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vSVYj2mE"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf216080f5so2194470276.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041259; x=1708646059; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=APWWApm07v+Ii9pzK+6vOaw3uMIWE5cbc20AIdxyhTk=;
        b=vSVYj2mEmYWuHfvPC/Rq1XYamjSQ7++KiBk/swRoV0atDXmon0JCmdJIHjMRDJI1eq
         OU0OXzjHfDamWcrrMwuXCtCTI0dPMuAIl3LUU8gFwZZGg4QP3UkoRzinKL1Y/f2Ui1uk
         NV12ZjAUjq5efybRxpJ15YtApWTbTBVbsQeW8AoCu11ZMfwkIWZgyma3sXyCeOYdwQ1o
         HGjWYmLH4i75OcJf5Lwf8fab9MBfc5iUWCxp5Q9XkGkeQqjpKGRjkXHcBFaiVTJjkWF/
         LdyuW8FVbbj6niwFOlJ9hpzsBjHSPKPEgtMxsScrGlQvVntAd2MIebn0cNE8lrGV8WN9
         568g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041259; x=1708646059;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=APWWApm07v+Ii9pzK+6vOaw3uMIWE5cbc20AIdxyhTk=;
        b=B4ec1UhCb/ohA1ilrne0d6izeWLBWkHx3DTjkhgTW7oPy9mf62L9jecAB0NeERFJZq
         JqmMmUT2EJNBfRKpJWDMwGnERDA1lC3Z0Cwu1DKXgoNbU9FzDzbZWGuW/Tf2h/8z4iKF
         4j0OwWo9eFLf+7vRDRhV8E7DF0FRopI6z0d+pV+Sj3CRvc07Lbxv+0KhvZTnbc6vXVHW
         5mhqbM2UlQLneOPEbItiJoIQafc8u09m0IhcfVwNnr6Hpzh4vZjIEa7xJG0x0vq0Ndml
         V0F6+UeZFB0b904FBtbPJGV3bJiAv/xKeaG+slxYVxi993USRNw1FnbNR/4xFhe/Btwt
         y/aw==
X-Forwarded-Encrypted: i=1; AJvYcCWzfYj2Kqv5sQUeraRDlmWT12Nu58dOfXScftP/nbTwXxLKzmCErLbcoyFjiRm+2+2SJMaSZyxCuS6aF/oPkm2tjlrVoWas
X-Gm-Message-State: AOJu0YxyFiy/ANsSGarF/Xgv1MICqTcBYa04hB1MLqWr4saz/JKcWsIv
	e2SRl7X2okJBqDmwcXfwVpy9dLpGNRUH5KLr3y+yGlcq4BJ9yrvDn2ATTg6XiuyUGxcNm3Bu/7N
	Hu3ZTfXXRyA==
X-Google-Smtp-Source: AGHT+IHPEJ59b8BXtnY8f7wKfLDM6BJPxRmmBDQPm7EUmwopjvKfjeWa/RaVSEDv68ZZb+Tit0/u/eoxIpod4A==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:2487:b0:dc2:466a:23c4 with SMTP
 id ds7-20020a056902248700b00dc2466a23c4mr725257ybb.4.1708041259622; Thu, 15
 Feb 2024 15:54:19 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:59 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-9-amoorthy@google.com>
Subject: [PATCH v7 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and
 annotate fault in the stage-2 fault handler
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

At the moment the only intended use case for KVM_CAP_MEMORY_FAULT_INFO
on arm64 is to annotate EFAULTs from the stage-2 fault handler, so
add that annotation now.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/arm.c           | 1 +
 arch/arm64/kvm/mmu.c           | 5 ++++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d52757f9e1cb..7012f40332b3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8031,7 +8031,7 @@ unavailable to host or other VMs.
 7.34 KVM_CAP_MEMORY_FAULT_INFO
 ------------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that KVM_RUN will fill
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..ca4617f53250 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -240,6 +240,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index dfe0cbb5937c..5b740ddfcc8e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1492,8 +1492,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
2.44.0.rc0.258.g7320e95886-goog

