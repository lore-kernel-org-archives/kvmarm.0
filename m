Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3CD25A2C9
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 22:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875298; cv=none; b=ob8qzaN0i5UCd4PnPEWSjPmY8yhkrrPM3E3PtQjeuZ5F+x7o/SZqBUFkoMbR17QXqOnkHjnfY3uFZ4v17MWtPXlrAWavdi6dNQg8ODWG5H4o3w1vSoicNverbHR0NVy1Xnd9mLX75/DwHE03uKxZpOiwxRHsyUSzsYkRYzdI5pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875298; c=relaxed/simple;
	bh=iKrUI9LQBOh4k9pZFLc/fEW3XuLEnIsg8figDKSsXGA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L3cGthvTtCIufQKuYmvX8bmZJayuxOELaybEXiXHOXvTn6gkDriw50Nnd1H+cBYplBJzNuDi8sO5ESb2B0rO9VnbOQ3lN1ZWuTDQz6AguFPzNezEfVX1mopSOjnAX/VCdBANIC8qS6odOkGMFeI/UkNKeb/5dgzb5BIQGlazP/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N1IZxrOe; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N1IZxrOe"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-339d5dbf58aso8264564a91.3
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 15:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875293; x=1760480093; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=efPtgGQoMr4oubNxAv1qKprX0Kma5wbATW1PH+6tg30=;
        b=N1IZxrOeOpO3IqsqkXuQzsuXo2d4T5277Bjn6QKT+j9C2tN+vgklodOZ8LQIaJqe+b
         i76mxd3yOV60o5tA0oKWNCGMpLg0BOHH0gR2E0cR2eBqTYjUqFyulBhiFGFHfrU5fTnX
         Ds/YseQYjdj5G7YDv7i83GRJBNEkZXdu/V3lwHS3gl2N3Cllk3MjxV9N8lE0hTBsD1oH
         JO8VRb5Ln6eTWaIwJe03FrNJC9lgKqFDA8WHm/O58sgkMIGN7L2r4rKBASnb/H1nmPJ1
         G0Qda1kIewKrBfzymfvBMHTa//spmqPpLninf3c+P9eG6BTusND0lWCLyVGW4HPfQ07F
         qb4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875293; x=1760480093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=efPtgGQoMr4oubNxAv1qKprX0Kma5wbATW1PH+6tg30=;
        b=ATVH5eBMP0PNG94kGhJP22QUF28+IOV7uU7Aps4TXUe2KiuKADLMFharilvDNw2pe6
         FfiZDOzwu8PSohHPAHp1tKP+jnyHgKxCHtiipPrCWFLqBYjfdrQZMY9QLzDd04aDFThP
         XNvyGr4I+4oP5anAhoc7PPRL+Gd8eE91NEm9x/mi/Bf4mTQ389tvNJXBg8bm5xkYOP3s
         9usgRiIG2Pp63vF0L0b39oRWIvb8B/ufsKQjJy+QjoWlZwxo/IChTSBq8FOpxBe6uqog
         9rsNPQEynHqN3e4hDiMmoXgJhjHKNzDp4mnxqj2aFroMCw70M+RzUz044DRLkXbZECgf
         594w==
X-Forwarded-Encrypted: i=1; AJvYcCXevn1yAkNlhVr2MGUJJtS84wGKtBEjfiefkNAP57nOd8q07rsaWNiwnbpVREbbvGqebYV1hb4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxmos6MjnFtVHmbjDVb+L8ngv6rsVE4qPgsWW7hYRoEoYFJE3S4
	RcAUFSsiAqftwdJGWriFLHbSNO3r9fbHbJG0mj3DcfDfADFM/1Siqp8F3A19sHPoi+51ilwGkUV
	++5jxiA==
X-Google-Smtp-Source: AGHT+IFTaBPktlqVR37VqVA9cZzZZ/8OTio3uAd9mQ94N7kdyxx902DDy6/7iqhCbZbcOwfgNKOb2jtvL6Q=
X-Received: from pjbsn6.prod.google.com ([2002:a17:90b:2e86:b0:32b:61c4:e48b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1806:b0:32d:db5b:7636
 with SMTP id 98e67ed59e1d1-33b513cdaf5mr1179313a91.27.1759875293062; Tue, 07
 Oct 2025 15:14:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:17 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-10-seanjc@google.com>
Subject: [PATCH v12 09/12] KVM: selftests: Use proper uAPI headers to pick up
 mempolicy.h definitions
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Include mempolicy.h in KVM's numaif.h to pick up the kernel-provided NUMA
definitions, and drop selftests' definitions, which are _mostly_
equivalent.  The syscall numbers in particular are subtly x86_64-specific,
i.e. will cause problems if/when numaif.h is used outsize of x86.

Opportunistically clean up the file comment and make the syscall wrappers
static inline so that including the header multiple times won't lead to
weirdness (currently numaif.h is included by exactly one header).

Fixes: 346b59f220a2 ("KVM: selftests: Add missing header file needed by xAPIC IPI tests")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/numaif.h | 32 +-------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
index aaa4ac174890..1554003c40a1 100644
--- a/tools/testing/selftests/kvm/include/numaif.h
+++ b/tools/testing/selftests/kvm/include/numaif.h
@@ -1,14 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * tools/testing/selftests/kvm/include/numaif.h
- *
- * Copyright (C) 2020, Google LLC.
- *
- * This work is licensed under the terms of the GNU GPL, version 2.
- *
- * Header file that provides access to NUMA API functions not explicitly
- * exported to user space.
- */
+/* Copyright (C) 2020, Google LLC. */
 
 #ifndef SELFTEST_KVM_NUMAIF_H
 #define SELFTEST_KVM_NUMAIF_H
@@ -37,25 +28,4 @@ KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
 		   const unsigned long *, nodemask, unsigned long, maxnode,
 		   unsigned int, flags);
 
-/* Policies */
-#define MPOL_DEFAULT	 0
-#define MPOL_PREFERRED	 1
-#define MPOL_BIND	 2
-#define MPOL_INTERLEAVE	 3
-
-#define MPOL_MAX MPOL_INTERLEAVE
-
-/* Flags for get_mem_policy */
-#define MPOL_F_NODE	    (1<<0)  /* return next il node or node of address */
-				    /* Warning: MPOL_F_NODE is unsupported and
-				     * subject to change. Don't use.
-				     */
-#define MPOL_F_ADDR	    (1<<1)  /* look up vma using address */
-#define MPOL_F_MEMS_ALLOWED (1<<2)  /* query nodes allowed in cpuset */
-
-/* Flags for mbind */
-#define MPOL_MF_STRICT	     (1<<0) /* Verify existing pages in the mapping */
-#define MPOL_MF_MOVE	     (1<<1) /* Move pages owned by this process to conform to mapping */
-#define MPOL_MF_MOVE_ALL     (1<<2) /* Move every page to conform to mapping */
-
 #endif /* SELFTEST_KVM_NUMAIF_H */
-- 
2.51.0.710.ga91ca5db03-goog

