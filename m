Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B97937475D
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 19:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527781; cv=none; b=Rd7/mij9cCA0lFlFwOi9rVwWOsjAh/VTE0A+q3zm/hsvdVtftXXaVYnhfp7NDeFrwF6gDBGfPx8e730Xl29BKIlbGJliU/bvEa0ehOxm9sn1r65rFw8AZIJ6nJ8/YPVWOI7VmPJWh4ZEMlaBpW93AqXsQesc1uyjoI7vZqGsxHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527781; c=relaxed/simple;
	bh=GTCdXxGxuqpPISX7zn1bGR9hfy0DxUEEavsRgWp0XqI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aInCc5Db5R9BF2nqMYNGGHCGk+fQsHGEgcyxUqnvvzhlHTDWzpEc+OWsIDrkht2VkW4HVkPxFyZ3RQyJQGabNJqR35Tb1pIdsW9jD5TvsHml1UiJ28TpQNQ1e+ZDONlpyORIrp9zonvT6MlOhcpUWg7jHaLWI0OoF+TzYWPokXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WRRDyj4j; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WRRDyj4j"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-ca124bf0189so1713382a12.0
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785527779; x=1786132579; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6tcAvkg/zKE4Wpx2bpF+dHLf7/L283ci232zJUD1488=;
        b=WRRDyj4jm+YNNABzrT927eyQ0y0yc7yZW8jauB2WeH7zpRhuyBlvxxd8Jvd6wVM+ny
         C1SbMWmF0inNpVhePEIhhsoobf9mZIUUdNFEpWC3nCCMqeHmmCt/AL0aEahWU2fdONGB
         rOh+6cyBzi+FRLuBnuiCzP/z30Ep9uee1G2KSkr+UNokDqoXVLJ3g8o5S9jQHicbKvSc
         lrHVYDo8Kqv4oEfZPr8fw7rWaLfWpOdq5AR2sVF8AF4irKCwSrTlCpHFQd1MLw3oOsSQ
         /GNqT0jwqrt2hYv2cj76exscA758VtXt12ytuIB4fBsA1SmHRWvVyWDZZ6dBg3LJBaNI
         7vwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785527779; x=1786132579;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6tcAvkg/zKE4Wpx2bpF+dHLf7/L283ci232zJUD1488=;
        b=ZYOAjhmP6UJ9dTJpkEQQjha8Orhe6ZF6mlMsuDnlobvEMcneEGaLUlR6Yj082n5TQl
         8LdInUfxEc7HK1jm02faBRBKNeGt1JWQIEZ7HJ/IzEt7cEiNO+4sek2kWxCE/iv2E7TX
         6T9biQjuxiQXw88zRUDwdwq9vSGtTg5d1nEFSATEAWi+FV58qwtP+9tEYuKcMv8/kn5h
         heHWofqF94GVTsku5XIvwPmD3iENa++vBeY1LALn4ijMjzgibOK59Ri1NnQEAjW1fWd1
         3zGAd8yAHq1lBc8j6e/KgBPj8ZCwDWHZ12P13j8fH99Xhqe42aK/haDdEvNHcaqsbYx5
         U1VQ==
X-Forwarded-Encrypted: i=1; AHgh+RpeIGwaxqdmmCGZnjRufdzbaVNrdZAzBKduSvefINc9QGs7bRa9MwxFMG12iyu9ELEN3dn7Bmo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzslmePyD6xKUEYPbX19sMNjf8gYSTDy+mlgigRgWmV+UbBj8pP
	Vp4WBlgnX/JEbpkiJCMX5Gb0+zWAlVxCEd4XPn5V/9lWrIMvsRpJBucsevS7Q+7SqzFttU88Ntx
	PVTYJEg==
X-Received: from pgj184.prod.google.com ([2002:a63:9c1:0:b0:c99:aff5:7078])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7290:b0:3bf:651d:fee0
 with SMTP id adf61e73a8af0-3c92ae1d81fmr774604637.19.1785527778610; Fri, 31
 Jul 2026 12:56:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 12:56:02 -0700
In-Reply-To: <20260731195612.2697986-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731195612.2697986-3-seanjc@google.com>
Subject: [PATCH v3 02/12] KVM: selftests: Set threads CPU affinity before
 doing work in hardware disable test
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

Affine worker threads to their target pCPU set *before* doing any work in
the hardware disable test.  When running a preemptible kernel on a NUMA
system with a large number of CPUs (100+ of CPUs), waiting to set the
affinity of the grandchildren until after the grandchild is fully spun up
results in total test runtimes of over a minute, presumably due to
cross-node NUMA penalties and scheduler lock contention.

E.g. from the perspective of the caller, when waiting to affine the tasks,
pthread_create() takes ~100x longer.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/hardware_disable_test.c     | 23 +++++++------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 3147f5c97e94..f088b4af3ccc 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -21,6 +21,7 @@
 #define FORK_NUM (1ULL << 9)
 #define DELAY_US_MAX 2000
 
+static cpu_set_t threads_cpu_set;
 sem_t *sem;
 
 static void guest_code(void)
@@ -35,6 +36,8 @@ static void *run_vcpu(void *arg)
 	struct kvm_vcpu *vcpu = arg;
 	struct kvm_run *run = vcpu->run;
 
+	kvm_sched_setaffinity(0, sizeof(cpu_set_t), &threads_cpu_set);
+
 	vcpu_run(vcpu);
 
 	TEST_ASSERT(false, "%s: exited with reason %d: %s",
@@ -47,6 +50,8 @@ static void *sleeping_thread(void *arg)
 {
 	int fd;
 
+	kvm_sched_setaffinity(0, sizeof(cpu_set_t), &threads_cpu_set);
+
 	while (true) {
 		fd = open("/dev/null", O_RDWR);
 		close(fd);
@@ -64,14 +69,6 @@ static inline void check_create_thread(pthread_t *thread, pthread_attr_t *attr,
 	TEST_ASSERT(r == 0, "%s: failed to create thread", __func__);
 }
 
-static inline void check_set_affinity(pthread_t thread, cpu_set_t *cpu_set)
-{
-	int r;
-
-	r = pthread_setaffinity_np(thread, sizeof(cpu_set_t), cpu_set);
-	TEST_ASSERT(r == 0, "%s: failed set affinity", __func__);
-}
-
 static inline void check_join(pthread_t thread, void **retval)
 {
 	int r;
@@ -84,16 +81,11 @@ static void run_test(u32 run)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	cpu_set_t cpu_set;
 	pthread_t threads[VCPU_NUM];
 	pthread_t throw_away;
 	void *b;
 	u32 i, j;
 
-	CPU_ZERO(&cpu_set);
-	for (i = 0; i < VCPU_NUM; i++)
-		CPU_SET(i, &cpu_set);
-
 	vm = vm_create(VCPU_NUM);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
@@ -101,12 +93,10 @@ static void run_test(u32 run)
 		vcpu = vm_vcpu_add(vm, i, guest_code);
 
 		check_create_thread(&threads[i], NULL, run_vcpu, vcpu);
-		check_set_affinity(threads[i], &cpu_set);
 
 		for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
 			check_create_thread(&throw_away, NULL, sleeping_thread,
 					    (void *)NULL);
-			check_set_affinity(throw_away, &cpu_set);
 		}
 	}
 	pr_debug("%s: [%d] all threads launched\n", __func__, run);
@@ -153,6 +143,9 @@ int main(int argc, char **argv)
 	int s, r;
 	pid_t pid;
 
+	for (i = 0; i < VCPU_NUM; i++)
+		CPU_SET(i, &threads_cpu_set);
+
 	sem = sem_open("vm_sem", O_CREAT | O_EXCL, 0644, 0);
 	sem_unlink("vm_sem");
 
-- 
2.55.0.508.g3f0d502094-goog

