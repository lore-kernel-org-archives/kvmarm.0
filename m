Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356B016A921
	for <kvmarm@lists.linux.dev>; Fri,  9 Aug 2024 20:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723236729; cv=none; b=iCi7AzNHGHSINHd90AmzeTIgxQwbeIVOjskqnSivTkpXqDpgIVsEl+n8NtCKFKNZi7fun9xVF597BohErsp2IE2TzQK8JEEKFp9M++uRNmRmIrbeyHB7YjSV1uAox4u2rQ8YaFzTptUbJ++3Y3l3SCIynxENXLCQR9heCzwBaKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723236729; c=relaxed/simple;
	bh=aRlZUJEaiHRJGRJLYanOLgphxj1dBoKyLzhPuRD+1jE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NumJ9WGLU/FsonyUqjy2/i/NQ3yfBxMRRohkPByDxms2GQ0u8iy19Z8aMw13jm6Oa1P8XM6/nImHUNvR3KBkmRogfcTpB3e2tXY9pUTRCTgydN0BvITOc38uFbfrMhSA0I7nGKlmTzAoAHGznFu8W4FiUX9FEbXwgQ0N24S8rNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PPTq6fWy; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PPTq6fWy"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-66a2aee82a0so52735467b3.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Aug 2024 13:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723236727; x=1723841527; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dIbtHxMOA9YLjvqp+dS6Qdcb7Qd+13Wo6Sg7tuMzI5Y=;
        b=PPTq6fWytrwi5FHB+9CADYANaKtprSLvfsX/QzASpqln/UQCuXnzODOHQNLF8GQuj8
         NFZ2PjcWhkSDdCrvUkoRbgFhMpFZsYKC3QBmgefzlj0XlNWxC4odEzl1gxrcuwgWWIOJ
         BErS4qmgFv+8DMie6bmVv0zRAWvsiIOYYb9P6jtzykuvU+pUQk3qMptuAjOjL1dpLfKh
         L1Z+gl2TjaG9Y4K88KFnxv9VvFnfwU3ZcvniemzEfEuUjFjxWbL6vl/34Y4kt+Cl2Tub
         X1J/ehZYXX5hDVfKTMSTp6Atht2CJIntB9k5Zi1y2HV1grQI9zGcSz89Y2xm7SJ0yDux
         Ly8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723236727; x=1723841527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dIbtHxMOA9YLjvqp+dS6Qdcb7Qd+13Wo6Sg7tuMzI5Y=;
        b=SQfibu8g8MnfjFF1OGC3Cgy7WLiWdfO54A/w/RnmV7HLnlHliVuCmcpbV/lhEPb1SF
         Ully1BHqJtrTc2fC9EljHLFyxcNeJpQOR7O6E/PWw5GKRhQyRB1tJZbYlpI5ng8wF3Vu
         B5jFbHMTVlUkINFG3zzEcXKq3gUo8LlSisiG7EYPOk7QtIJkvKfqYb2hy71CNRJ66UE2
         oJfgTgzEogZqoqod+SR0D/P2SlWFAE90Btpg+AdojhCYTaCahAXb1D3QpN3gBSitHWs+
         F1Vgpap3AFM5s34oKGuZL1mqOhb3ooqZxd/JGYRjhC0+akE5omgMPPqLa/P8Wj3GpDz0
         0c9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWOwsWmwxrEKKU9jpZX3vWH+xW+C1HOpDtMr5qtKGmG6T0StJ0+2PgYzUxexv0wFgL+xWSVWeDYUXn1QzikCDd7s6l/ypmF
X-Gm-Message-State: AOJu0YzCZq9oKMWq8WGinD753On8R93gTCzra7hk85i7UNZahxZQuFzC
	4YckPfhhL3WE8BUrnbe79kg9caWmEIlyjJnD2sxusqK6PgChyBV6pAQfr84T+qMY1P0G6Pkke1r
	z6nM9X7VrtA==
X-Google-Smtp-Source: AGHT+IFEaybp/gQAI2dPTCR/v0E5CX7dxbSJimk27amgMiDWfuzdCjImbiciR7wYsAeR11wIqKwlf/27qs26HA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:8786:0:b0:68d:14aa:894a with SMTP id
 00721157ae682-69ec4a193b8mr1144237b3.2.1723236727230; Fri, 09 Aug 2024
 13:52:07 -0700 (PDT)
Date: Fri,  9 Aug 2024 20:51:58 +0000
In-Reply-To: <20240809205158.1340255-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809205158.1340255-4-amoorthy@google.com>
Subject: [PATCH v2 3/3] KVM: arm64: Perform memory fault exits when stage-2
 handler EFAULTs
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: jthoughton@google.com, amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Right now userspace just gets a bare EFAULT when the stage-2 fault
handler fails to fault in the relevant page. Set up a
KVM_EXIT_MEMORY_FAULT whenever this happens, which at the very least
eases debugging and might also let userspace decide on/take some
specific action other than crashing the VM.

In some cases, user_mem_abort() EFAULTs before the size of the fault is
calculated: return 0 in these cases to indicate that the fault is of
unknown size.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/arm64/kvm/arm.c           |  1 +
 arch/arm64/kvm/mmu.c           | 11 ++++++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c5ce7944005c..7b321fefcb3e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8129,7 +8129,7 @@ unavailable to host or other VMs.
 7.34 KVM_CAP_MEMORY_FAULT_INFO
 ------------------------------
 
-:Architectures: x86
+:Architectures: arm64, x86
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that KVM_RUN *may* fill
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a7ca776b51ec..4121b5a43b9c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -335,6 +335,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..c97199d1feac 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1448,6 +1448,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (fault_is_perm && !write_fault && !exec_fault) {
 		kvm_err("Unexpected L2 read permission error\n");
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
 	}
 
@@ -1473,6 +1475,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (unlikely(!vma)) {
 		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
 		mmap_read_unlock(current->mm);
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
 	}
 
@@ -1568,8 +1572,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
@@ -1643,6 +1650,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
+			kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
+						      write_fault, exec_fault, false);
 			ret = -EFAULT;
 			goto out_unlock;
 		}
-- 
2.46.0.76.ge559c4bf1a-goog

