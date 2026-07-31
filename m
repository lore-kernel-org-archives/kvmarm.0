Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF40359A6F
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 19:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527779; cv=none; b=Wf6GlNtLTRfXyvG5rHL6whRPATX+1NswcQkc30beabCzSTW5JzEdAvmGYSaVaA5/aoNGlIcTf0rizpCimMPnT5OP91jfm0jCTX+y4N1DdgigGdBzYmlPep3vKXgBDCXbWtSamNeJOcIkTVk3bGXPIamCO+Tc46G0CjDDjCrrAH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527779; c=relaxed/simple;
	bh=jIqegcMSdQEr3CCSBl7CEcF3KSy6gnzkLIXn/FjtTSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IPeQuh0Pm8xqpvbz0yUhyuQHgyJgGPVgn3lT8N3yuhUkeFayNHnlkP+o0SipGTw6b0KjvY8JhUyd0v0skmRDp+qDzezktJNwjSlkrfpTLx6eVbEQ+4DRDJN3spUS1ukit2VjISY02bbGzXXcraULEnHkihswnFPqA2wbipOxGto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ndzyO6RP; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ndzyO6RP"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84e01a62d99so1839540b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785527777; x=1786132577; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=I1vB8uido3pB5A8nVpiV1ZvPN5oqRESsQC5EjXRdj5A=;
        b=ndzyO6RP6wdZ8v+eShFw1iCBzVZO+KOWPQfvJzEatQ5U7haq9CFpgMzBTDWv6NAI2X
         Q6w17KJN5trGBnJBe7cRJSYoqicG8i7WyBI0PfFQj7XhyP2zXfQDmUs+V+gbRU41S7dz
         Ijrd/FklH8tDYdf42haGkgUJJSm7Q9wZtsYpHZ+1gnVPyQHG0OK4i4IUr7lEuMQ0xok0
         Ula+DvhF6MIpoMXVdIV+q9G8kMkMk5DUeo2XRCN1PppioO5m9oBw/M+qFx53mfLRO1zS
         0agaysSkCBqBL0XCWBMv/JvFM9OJANSEdhnEZ8zUzMF1yDbtzQor9V5ONr1IiX/0mpcw
         7MqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785527777; x=1786132577;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I1vB8uido3pB5A8nVpiV1ZvPN5oqRESsQC5EjXRdj5A=;
        b=LnmzEuH+Q/G7AQHKmgt7GQIA0xXmmIEAYRR4mb/RQl4JxScjujy2ppHRjMZLAyKjEA
         IziRPSlWLYIolxhSDx0gHadLiw2RSMRL4eLioot5v3Kiss+FLk66fNkZxjlt2u2peYB9
         +52Joruw2ue9iqUem9wmZvWla5nFJest9Oc8l9VpKFZY5GhGnlYRfvO594wmcKxK6V8g
         yA+nJlL4xCZKvwlnuiSHYdS8XMuS6h6qyY3Smt3oQGVzKp58NYC3OnJypoLQpccA3dRu
         r53ytUtlijYGXs1CNgRssx8PFZU+N7/KGDZdqL3FB/EK2iFoLdiEqaunA8j/LvQ+rk0I
         TfNQ==
X-Forwarded-Encrypted: i=1; AHgh+RqlfB3ib8nnoxc6f63uZNGdaFHQa8wP34p+YQ9fqfcUmxxnVwONKA2tc1Rpp0NL06X9QHFZKgI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1YdrnzLbm21+3KuC923PaN39cbMJvxNDE6HE4ZgVXL9MiIdQL
	tj7tgy7apA26jk9GYXMADENMBymBjtTv7Vl8AEqAUysYn9EBNG+wa3zb27dtZLf9QyK95GDf61v
	HEEua3A==
X-Received: from pfbi2-n1.prod.google.com ([2002:a05:6a00:a502:10b0:845:c4b8:9730])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:9a87:0:b0:848:2f73:8ffd
 with SMTP id d2e1a72fcca58-84ee49339bemr849272b3a.70.1785527777019; Fri, 31
 Jul 2026 12:56:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 12:56:01 -0700
In-Reply-To: <20260731195612.2697986-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731195612.2697986-2-seanjc@google.com>
Subject: [PATCH v3 01/12] KVM: selftests: Add a KVM syscall wrapper for sched_setaffinity()
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

