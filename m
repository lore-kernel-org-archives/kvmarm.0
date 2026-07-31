Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44B377018
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 19:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527783; cv=none; b=QWTiypewUeZ6zHeCpAULx958b3nmOLhwgJrFtxzEZF1T1KCHFswpmD3lVKJKqidCx1f8OejTiBMcwwdyyalwZphRPvV4GfPCfuKoPhLePt9JrqQb2rYlilWMZD2rMDk+UJDEhoraYdBjyRrUk/cJm/2eJbX/XhCNc1kW74tDUXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527783; c=relaxed/simple;
	bh=cFWa99Xo2ScAZGQfMvB0ds8Ya6pH9puVFr0S2RC2rBc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WruUl6FY/nLr+tWh+dzTqy/e3ayyoxIcNAfgWCtZTaP6r7vPUlRoiU2Kx9N7oqC95n3AukWgag+6zRjhTEUfDqR+uO9OQa4Mzkl20hscy1+F9Uq4quycnvh/Nlwyf3JLqnlHg1eSRtftJwK187XHPUPm6xhEM3LpqM8rFwyjpNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GhSXNbBD; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GhSXNbBD"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84a3514f912so2363643b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785527780; x=1786132580; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QWTFo4fs/kSU6lr4ZzfhIdwS/NOVkYn2PmTaiQ/QINI=;
        b=GhSXNbBDOSxBm7I+uMBx1cgOYL16m8M3EWqdcLHYwM2K71Lpi8ZHc1e73kK7xXMIEV
         r2iHlHreuKaiahw5xsWe38vql5mdGOMgBK+m3Z5dBd2KL6+4SAYVUInpaEh3PMEkWoM4
         FxPIQkha560h31FcjHS35ydb/uq/27u6b4Qc/IPM24T8tvC+tRlMm+6WQFrD7bDfv8XI
         BEy2oKZfMbwTmHgoXw83q5NbBd3mdTt/v6Ql1EWN3P3AZDk6zHHXujoejbmmJ6OstMzb
         j31ojh7j0y2DcurQbW0u3dJtCHisPWA+HjePtJ9UvccdWB6+F1uI0ee2ymJ4K4BI9M/Q
         Mr4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785527780; x=1786132580;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QWTFo4fs/kSU6lr4ZzfhIdwS/NOVkYn2PmTaiQ/QINI=;
        b=C44BwV9Os6KjZXE2z86lbXGnwSkg9cKoHXpnwRrb3OOeIHtPvyt1qmvXwwIHKsvC7+
         OR239FTRNHqGKRNL5PMqcr22tYiVUi1vaGo7yNMdu0hhuDLx8ymDdTjdkV+/YCQmqHm0
         QedzQ3LS8LjwrrkYkNnMJd6rm52+TTQUGbvojVshU+9mi/YGrjir7J9AEFVHWSVMKZG7
         e+hjEaR46EV4PF0WDDFpko2AyOOPZD+QR2xHgnUM8i/jTR6GL/LkrDBWh57Goq0JWv0f
         g2/ANR0DKfKIuy6Vsdxi/zNctrJDEY9qsNCb3Fr1j0Pu9XrOcvJmMf78T0bmaI3bCVDP
         yTew==
X-Forwarded-Encrypted: i=1; AHgh+RrTsEt3F7Q2u9sgkILp7zhNmi//a3j02Rc6EtNUP1M6Gh8QfXxJptB0i4wyHI11tJWfP8MOSv0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvTNiSvT6pjdM7yaKlYxq1P3pNunp2I4L4MkCh5Dy9UsiRG9Pc
	FERAA7BXadM/Rkjo0V+fbocBj0fQMrYsg5TROKoeUs3N4usa+gE2JAzGHwYHIURsd0T/29zytwg
	bXZ+Phg==
X-Received: from pgnp30.prod.google.com ([2002:a63:7f5e:0:b0:cbb:b782:6be1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:13aa:b0:847:1d73:f753
 with SMTP id d2e1a72fcca58-84ee48a4d18mr834507b3a.45.1785527779971; Fri, 31
 Jul 2026 12:56:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 12:56:03 -0700
In-Reply-To: <20260731195612.2697986-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731195612.2697986-4-seanjc@google.com>
Subject: [PATCH v3 03/12] KVM: selftests: Pre-set threads affinity in hardware
 disable test when possible
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

When building against a libc that provides pthread_attr_setaffinity_np(),
pre-set the grandchildren threads CPU affinity in the hardware disable test
to further reduce the perceived latency of pthread_create().  On large NUMA
systems, this reduces the average runtime from ~10s to ~5s.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/hardware_disable_test.c  | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index f088b4af3ccc..b4edeadfa3f4 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -36,7 +36,9 @@ static void *run_vcpu(void *arg)
 	struct kvm_vcpu *vcpu = arg;
 	struct kvm_run *run = vcpu->run;
 
+#ifndef _GNU_SOURCE
 	kvm_sched_setaffinity(0, sizeof(cpu_set_t), &threads_cpu_set);
+#endif
 
 	vcpu_run(vcpu);
 
@@ -50,7 +52,9 @@ static void *sleeping_thread(void *arg)
 {
 	int fd;
 
+#ifndef _GNU_SOURCE
 	kvm_sched_setaffinity(0, sizeof(cpu_set_t), &threads_cpu_set);
+#endif
 
 	while (true) {
 		fd = open("/dev/null", O_RDWR);
@@ -80,22 +84,28 @@ static inline void check_join(pthread_t thread, void **retval)
 static void run_test(u32 run)
 {
 	struct kvm_vcpu *vcpu;
+	pthread_attr_t attr;
 	struct kvm_vm *vm;
 	pthread_t threads[VCPU_NUM];
 	pthread_t throw_away;
 	void *b;
 	u32 i, j;
 
+	TEST_ASSERT_EQ(pthread_attr_init(&attr), 0);
+#ifdef _GNU_SOURCE
+	TEST_ASSERT_EQ(pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &threads_cpu_set), 0);
+#endif
+
 	vm = vm_create(VCPU_NUM);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
 	for (i = 0; i < VCPU_NUM; ++i) {
 		vcpu = vm_vcpu_add(vm, i, guest_code);
 
-		check_create_thread(&threads[i], NULL, run_vcpu, vcpu);
+		check_create_thread(&threads[i], &attr, run_vcpu, vcpu);
 
 		for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
-			check_create_thread(&throw_away, NULL, sleeping_thread,
+			check_create_thread(&throw_away, &attr, sleeping_thread,
 					    (void *)NULL);
 		}
 	}
-- 
2.55.0.508.g3f0d502094-goog

