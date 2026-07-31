Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941424582C9
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517599; cv=none; b=riTDG7J2wyua9p4mdol+YktD1/cSawVeqow+0yY62pdljcEKQ1h29+Q2hMCJL782jLreQFKalzpqTI8c0YKoXJQ07GYTMIgh9dh+5En/GJlkrFegRgtPbs5WHN4qhEdi41l5a1jcqqM0MkpVGFmsF+abX+XMjvIUfsy5/SFoKek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517599; c=relaxed/simple;
	bh=D2cCds+Rmi8+J6lQPkFl0u/IOfzO+nxs2jcefDTat0Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=leUPFCuTq3V6azIsmR39WuT4SdKOyMUdMIxWpIZqQGYyvNQC34UjDrAA32jl9w1LiIryOANFsRm1ZNgJ8XpPszM2eLiY4lfsORuCfQqlsqVc/HZxEy7ITZqT76jpHQholmtr8mlHt72H8RAfFL+W8l6OHCTPqm1p8NDnUTYRs8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=adOLQmW2; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="adOLQmW2"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-848d21bbb55so2186780b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785517597; x=1786122397; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Hu2nzxTULIrNid+T0wW8lXLrPPrctqAZSUyi9Ewmd1M=;
        b=adOLQmW2R51ecMJC/1OVVvUT/kM+dg5j/Lp/eRbzmQl7vYxgZq0fONo0FjDV8BNRNl
         iQmAiKn1dYQCc2xQEwebsmtpNoQSajhiA5HBOAMVLz1t1tOIZdozRX/aATrpPqfoHxMH
         YU4BwOCFiydHb4zdpmPU9iLl/EiypQtT4/V2SJoHNUHKYsC6dhFvLm5IC59gCtPlU+cB
         wSNvzBKBfVmLTqdBDM+u84FDWkNmsFca3vp6dr6tvVjWdBmYyRWQV1G14vKmmtQd4cG9
         ssIItFWMT9k2mGkK2MoMX2gQ4CtQQ4RA8j19n8/aZMRhzF6kt91Ya3adVvsz1KiC+qiZ
         23kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517597; x=1786122397;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Hu2nzxTULIrNid+T0wW8lXLrPPrctqAZSUyi9Ewmd1M=;
        b=Rqtc6QFkWYGOYPtrIypURQQh/VV8iPrJZp2nYq/FefgkrWFmJbTgcGcotDkgVPVhhO
         qG8bKzriDHS3mO0LJrsv+3PA7HyyelUTJz8ulIhgmHA4ZyCEPTDlX1ZxxNnDUrmSVDX9
         GIEp7mIo0E+yDCforiU2PmoNK/v5P9IAzNbCobXUJHYOBOHJfx2SzVB5TPS6Cn3dSk5Q
         zd5/sfklbAvHNwkh1xiMU+1Z6bFSuTUurqoWLqnUJm0E+zi8oGFGsI9nj6T2pzgSAQnq
         nFxnZtlBHY8LHO05j1MHIA/8a1zkWcBaizOAMDR1BNZmNg9Hb5GnZC7+fiOzLq46vuaM
         s6/g==
X-Forwarded-Encrypted: i=1; AHgh+RrWjgONaiZRdZw6MmGpN28Ex6CDAFDBJmpyQwlfwlQOIr1oX1KpvWiINRLrxSfMRMeoEvdqf+s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwepHEagFDG7vU5l911q9uk+ECJjG31/BL4m25ZLs1raVBiYNiq
	OeqbsnapJQjgYbI+ljlxDP6XPabcyENcYzePuZoiD1wiJAE7cHod42dPyOhdqZ7X6P6mVj/Ldbk
	Qo1yxTg==
X-Received: from pgsb25.prod.google.com ([2002:a65:67d9:0:b0:c99:aff5:707d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:484:b0:3c3:8c88:7b2a
 with SMTP id adf61e73a8af0-3c92a84bcf4mr591268637.58.1785517596388; Fri, 31
 Jul 2026 10:06:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 10:06:18 -0700
In-Reply-To: <20260731170619.2620845-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731170619.2620845-12-seanjc@google.com>
Subject: [PATCH v2 11/12] KVM: selftests: Add KVM syscall wrappers for pthread_{g,s}etaffinity_np()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add and use KVM wrappers for pthread_{g,s}etaffinity_np() so that selftests
don't need to manually assert that the syscalls succeeded, and so that they
don't need to manually pass in sizeof(cpu_set_t) for the size.

Note, the steal time test didn't assert success, but the TEST_ASSERT() one
line later makes it quite clear the test relies on pthread_getaffinity_np()
succeeding.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_syscalls.h | 16 ++++++++++++++++
 tools/testing/selftests/kvm/steal_time.c         |  2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
index c0657e54aee5..dc7461894aef 100644
--- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -98,6 +98,22 @@ __KVM_SYSCALL_DEFINE(madvise, 3, void *, addr, size_t, length, int, advice);
 __KVM_SYSCALL_DEFINE(sched_getaffinity, 3, pid_t, pid, size_t, cpusetsize, cpu_set_t *, mask);
 __KVM_SYSCALL_DEFINE(sched_setaffinity, 3, pid_t, pid, size_t, cpusetsize, cpu_set_t *, mask);
 
+__KVM_SYSCALL_DEFINE(pthread_getaffinity_np, 3, pthread_t, thread,
+		     size_t, cpusetsize, cpu_set_t *, cpuset);
+__KVM_SYSCALL_DEFINE(pthread_setaffinity_np, 3, pthread_t, thread,
+		     size_t, cpusetsize, const cpu_set_t *, cpuset);
+
+static inline void kvm_pthread_getaffinity(pthread_t thread, cpu_set_t *cpuset)
+{
+	kvm_pthread_getaffinity_np(thread, sizeof(cpu_set_t), cpuset);
+}
+
+static inline void kvm_pthread_setaffinity(pthread_t thread,
+					   const cpu_set_t *cpuset)
+{
+	kvm_pthread_setaffinity_np(thread, sizeof(cpu_set_t), cpuset);
+}
+
 typedef void *(*pthread_fn_t)(void *);
 __KVM_SYSCALL_DEFINE(pthread_create, 4, pthread_t *, thread,
 		     const pthread_attr_t *, attr, pthread_fn_t, fn, void *, arg);
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 6cb1eb4c40c9..bc3c62b72c58 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -549,7 +549,7 @@ int main(int ac, char **av)
 		/* Steal time from the VCPU. The steal time thread has the same CPU affinity as the VCPUs. */
 		run_delay = get_run_delay();
 		kvm_pthread_create(&thread, NULL, do_steal_time, NULL);
-		pthread_getaffinity_np(thread, sizeof(cpuset), &cpuset);
+		kvm_pthread_getaffinity(thread, &cpuset);
 		TEST_ASSERT(CPU_COUNT(&cpuset) == 1 && CPU_ISSET(cpu, &cpuset),
 			    "Worker failed to inherit parent's CPU affinity");
 
-- 
2.55.0.508.g3f0d502094-goog

