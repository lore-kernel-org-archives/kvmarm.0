Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AED330D5E
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635827; cv=none; b=E6UMkOmbnAsTc5J21Y709L4ti/MiSvRkCwYzI7cEi/Yxa/MGp8xos+JrVPq6uV6eQWy9OhOWhfiLDu0XZZvt8zIdlMH9gP1JmRcFLaPQLz1QLkVYgT/qB5cQGo30jU3j0UdbKDtL9mJsVvqHhAuYT4fPU+XmDH6ccjw866rE24Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635827; c=relaxed/simple;
	bh=heky2zXel5Gf2tCzEvHsxs+55wiRGUenTfJxQBBGyvI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UlaHXaa/DCBJ/U1fPEM0FFLrBI/kzsZB/6r3r4Bpgbez8UXAJ0cUpcJ3htCSPGECnniSpbkv0PjqTllkGWuSQbZ3Gca1hG5J4jzf2Ej6C0LUOtHgXfu41TcuKxxhsAU8mri0E1XMCBh1hXyoz7hTzU92AWpEmSHK9dH1fCH0fgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hGm9IHwF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hGm9IHwF"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-339d5dbf58aso2344981a91.3
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 10:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635825; x=1761240625; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4u4q+H5ARYkVWCNl+U6142GnGsl0yn3w8dvhjLsaut8=;
        b=hGm9IHwFCrtVS79DMUiYSzmeMZhOIaddqs/3wzL/t6gQSoBMFAvj836zljzYz0Gg9C
         tdtpt5AuJHmNVbqFhZI+p6mCWGuM64RRDH9AnNJSqhBNN1dGOc3x7CTc1S2WLzI3EeIo
         ftKQpRe3RtdWb85mdcMS4mMbTZ0djWTLNoSMQWFr/sLtuyvy9maXaKD4kHFFCQxXClNY
         VLA78jAsWMdoU8R9kzlClVZQ4wif/H8gpvheEgwkc/dew3wEXVXEnEboF2fNWIzGvya5
         WxKn4a9h/db0P1GJZ1eNQG77cs3Gwmn+5On4cQow/1f76VJ0HV87OfXQhgv8ywpaev8X
         8K5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635825; x=1761240625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4u4q+H5ARYkVWCNl+U6142GnGsl0yn3w8dvhjLsaut8=;
        b=GfAJhzRNMyeSYz3123XIk9JPhlzC5/P9GnyJYW5yDZLGNwYhP1OdDue58uPEdpuX5B
         yp5UtsekNnhCYGUMqda5KfG8VokqNgATuBJXRMbiff/pBGnHkstiDrJuhi1J4h+bjI3r
         hS5UeRm7y15DDNRNVHc8si7ivEgHKpJ19YmUrhude06qS7xnM9IBGZKBmkdEVbcjpIog
         rfErXR1b8KhapwJ1a/usBFg19iqHNAcc6rhqqxCGLPxsdHbNwcWo+0pvcJKd01OyfIN5
         ZK9i4xWQsbOHQxmOCg5P1iaDFSBvdn6OrzW+F1tXwIO8lTkB2iguWxLfOrKYoCznx7Ja
         tuJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh7yngx+AxBpErxgGBJnl9H3PQDW8VmxPo6NBQbSIpOkWetMNuwV03wv2nnCeVPLYIWWnyO8Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVvtwzfJNEFI3hear4ySu2JlxLT7KVm1K9EKOc/tbFcJWrMciN
	mmOWRVdPHitfNwi0Lgr4TwOyWJnYxf8dBrbIZIg9H0JWg4yGtDlFQpnP9EmR25HaJcCC6HM2BgC
	Wb0v7Jg==
X-Google-Smtp-Source: AGHT+IFjz6Aq3RDvBNfXfc7PgYrCrCMU7f2p0qSK1iEGyybs/z37dRTZt+Dzr1VQ+adtly8KdiPZ7TtQHj0=
X-Received: from pjbnc11.prod.google.com ([2002:a17:90b:37cb:b0:33b:caf7:2442])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c88:b0:32e:1b03:6e12
 with SMTP id 98e67ed59e1d1-33bcf88aaa6mr718301a91.13.1760635824646; Thu, 16
 Oct 2025 10:30:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:50 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-10-seanjc@google.com>
Subject: [PATCH v13 09/12] KVM: selftests: Use proper uAPI headers to pick up
 mempolicy.h definitions
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Drop the KVM's re-definitions of MPOL_xxx flags in numaif.h as they are
defined by the already-included, kernel-provided mempolicy.h.  The only
reason the duplicate definitions don't cause compiler warnings is because
they are identical, but only on x86-64!  The syscall numbers in particular
are subtly x86_64-specific, i.e. will cause problems if/when numaif.h is
used outsize of x86.

Opportunistically clean up the file comment as the license information is
covered by the SPDX header, the path is superfluous, and as above the
comment about the contents is flat out wrong.

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
2.51.0.858.gf9c4a03a3a-goog

