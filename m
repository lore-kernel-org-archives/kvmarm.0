Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2365449B0A
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517586; cv=none; b=dh3Ivv1IXMgKJ/2Z1oaryY8sdaaY668AgezBNBeAkmQQ5qo3bb2m/MHfc7vZlPXKVV03yIp1JAvVfNwkhc0XcHffhDgnd00KknycJ2QStTfIf7HSz+cR70GDIlq8cZt/S0+fipIpCLAlGbVeLDhVyBU0bQ81WTxX5xM3FkovOfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517586; c=relaxed/simple;
	bh=jIqegcMSdQEr3CCSBl7CEcF3KSy6gnzkLIXn/FjtTSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NcczFZObr3nUNkjFODr1O/z0iqgjEbvlK1ZVWjDyXPH5182kN+2U5dRQ/5n7kRWAuVnTf2DAthuxvgqzDpRJE1upLH+VBjUqd42lb6hEIPoH0SJXGOyA0L9ZvpCmsc4E6oKMyDWlGFNz43TTBRImvtSAytGZzS3FnWHCTHq8u5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MsRsPun5; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MsRsPun5"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so1349766a91.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785517584; x=1786122384; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=I1vB8uido3pB5A8nVpiV1ZvPN5oqRESsQC5EjXRdj5A=;
        b=MsRsPun5r+31n4MEE5OC2a2TjeT/PwKI6NQkOO5lXYFmGZQxpOPgj1ADecWlcoaM49
         MD43Z+23JEmi63wnEIHyjAoiU6eGrAamppnhi6+Uz/L9xLrm9uVciCh7lQHvU6B/tjKE
         juP2o0kgs6agzJEuOghMPEaAVHTxCoQPiMw5FoIGHeaFmD6y7T+cfZwbaxPY9XHZLNaF
         4y4lAyZv/tWAumUQpu0CODNSk5JP3IMEbJhsVtd8R4MHyWt7AeHC64Pc7v/1PPW5B7t6
         AtLHsrSSoQm4TYTfIVTKJqX24yYZcf3sdbb5pC8tGG/R3MII9aeaXDTcz/M6Qg8QAGxO
         Pxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517584; x=1786122384;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I1vB8uido3pB5A8nVpiV1ZvPN5oqRESsQC5EjXRdj5A=;
        b=YTaDtjUfv3DVBZL70QKQ9OhrSdy5TqPETmPAGTu32YToSee8cHs1ypk/mq8V6kcyQ0
         +0hFUgDJqRuPmeh0nHlkZPXjxPj5YiDaEBDpt1XL5la6WOKwk+FOR3/VKkqHDfV6zmj3
         H/Xbt99fpgdG+sG+xFnQeTMJvhEAZeyebi+TsxggDFjvCRV04cxiaxvleG9NhH7gNegq
         eeNcXohysp91HfOc31wsCP/9od6JxHB5kRJj+8b46J2Hin6/k+bSDIZpH27q4iiz5Ql8
         J5h4qhCG9CBztRjNHAlLSaCOfrSBD9eZ5CMTBU49drh/z3H9S7lezzWkbHscqdr9yE+c
         +MMw==
X-Forwarded-Encrypted: i=1; AHgh+RoKwzFFqynhzWiaid1hOF2JQaBaHTvptPSY0S3pUy0uAQNo2ejdKe66GxzxGH2YTa8AL/HJw7Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVxJ2XvPmHPNBzQ7SVrcxY92b44lqMfEeMeSBd7L/6XcsdCgxo
	0QhCRqjztqAxKP2o+dYYZfUTteZkSMyCAF0qAWAmyvIErtMBkHA7mpOdxkvT2vPglhIpTVHYliT
	X7dg3aQ==
X-Received: from pjso10.prod.google.com ([2002:a17:90a:c08a:b0:381:171e:961c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:280a:b0:37f:c28a:de61
 with SMTP id 98e67ed59e1d1-38fbc45521dmr583105a91.17.1785517584041; Fri, 31
 Jul 2026 10:06:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 10:06:08 -0700
In-Reply-To: <20260731170619.2620845-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731170619.2620845-2-seanjc@google.com>
Subject: [PATCH v2 01/12] KVM: selftests: Add a KVM syscall wrapper for sched_setaffinity()
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

Add and use a KVM wrapper for sched_setaffinity() so that selftests don't
need to manually assert that the syscall succeeded.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_syscalls.h | 1 +
 tools/testing/selftests/kvm/rseq_test.c            | 6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
index 5dae6143ddb0..01dca99009c2 100644
--- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -95,6 +95,7 @@ __KVM_SYSCALL_DEFINE(fallocate, 4, int, fd, int, mode, loff_t, offset, loff_t, l
 __KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, off_t, length);
 __KVM_SYSCALL_DEFINE(madvise, 3, void *, addr, size_t, length, int, advice);
 __KVM_SYSCALL_DEFINE(sched_getaffinity, 3, pid_t, pid, size_t, cpusetsize, cpu_set_t *, mask);
+__KVM_SYSCALL_DEFINE(sched_setaffinity, 3, pid_t, pid, size_t, cpusetsize, cpu_set_t *, mask);
 
 #define kvm_free_fd(fd)		\
 do {				\
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 557e393c223b..edcaf0fbe20c 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -75,7 +75,7 @@ static void *migration_worker(void *__rseq_tid)
 {
 	pid_t rseq_tid = (pid_t)(unsigned long)__rseq_tid;
 	cpu_set_t allowed_mask;
-	int r, i, cpu;
+	int i, cpu;
 
 	CPU_ZERO(&allowed_mask);
 
@@ -96,9 +96,7 @@ static void *migration_worker(void *__rseq_tid)
 		 * stable, i.e. while changing affinity is in-progress.
 		 */
 		smp_wmb();
-		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask), &allowed_mask);
-		TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
-			    errno, strerror(errno));
+		kvm_sched_setaffinity(rseq_tid, sizeof(allowed_mask), &allowed_mask);
 		smp_wmb();
 		atomic_inc(&seq_cnt);
 
-- 
2.55.0.508.g3f0d502094-goog

