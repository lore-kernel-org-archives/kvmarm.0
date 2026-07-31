Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E2644C666
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517589; cv=none; b=FpkYng3cqi3TSB4e6/3JaigW5uBfZK+QHPEX0tEtTu24ENBPnFxF7JypwjG0ONJv+DfgnuOy1JEjZNG+qCdo+y/uBEsnSiHOu7N4Yvb+wuagCrPWFcinccPidaMPc9/B/mlRBwIGKQTpBCKvHS9csK4EMESmhMTXw7M9vfLDTb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517589; c=relaxed/simple;
	bh=O/HA18lT4V9uEUyS4D559RXemgyAqdlbEZKAn/jF9Js=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=crjYKeLcxA3FxE8bNTkZN/jVOP7JPTwqwch5u0A/ngUTqVElCvn91pVZcqk84SMzqfqB/kRcUnm0HUvhnfFl/HkPDWpcLeZ4HTds6c5KMDTL2bDQSEl0/yLUeaTQBA6/s5hwpL7qonXecHS4tbwdTge0NqLO6EA/IuqR4EbH8As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IibvLb0t; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IibvLb0t"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8484f26852dso1418716b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785517587; x=1786122387; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=i3VSeeQ+TY0YcGO9FGsFVyU5sUODRimnbCxeJHurnMk=;
        b=IibvLb0tEB3UpUu7v3G8Fhz823Eas3hKkSDlIboaue/s9MgTH75JRQcEfFEQkeNWoa
         kNLii0wpux07rV4GQrJ27N19jdkqmyGZDjoLWU8R2p+RklwUxR9z/fjNFXQUHMj7SV5T
         k78e1zFeu16+k9j1nZeEK0/i45StpXdojhgzEHPwKOWHFW6+6MLCgkcgapuqxTxomlrE
         ScZcF94y1X2VPmapB3A/FVLklyg6fftmQMz1smLgHK78TBqEoO6/4l6eAkK/7Xuq8WIa
         b8wyBdX4zvX7FNj7Pdn7x7/3gCqbKT3qXsl3whsCUhfqJcrT1Gxz1q8Y2VKfXfayS6H3
         bvXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517587; x=1786122387;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i3VSeeQ+TY0YcGO9FGsFVyU5sUODRimnbCxeJHurnMk=;
        b=qxHeW1doR0krJB3lKXVmRFCS4gLPmGKIILfTXaT+j3HOb9hXuigpToIQZ8n/XojlJI
         oKYMnm56rEwlnvLrWI0nukMJnOcdInnnhyqPOFB2Mod6F+3gqC8cqW0+q7hlqmSTBNy+
         XyvEaInS2ijgxkrfDxdCsoKV4lDRU5i0KvEJ3TEe8mfy3hZ6pE5GYHBe4GX9gdpjn9or
         V/aDcy4kyEgDmrsC5op3hl1QdOfKooKG9ztdxrQB6GazV5k1Dfmfp9o7l3iU2nAcE5Tb
         sud0GmE6BBbsw0ZYcmpAEwd0CRTaetic3s5ACOES4Yq5MXbB5BKFAfBG0+9Jm/imfzVL
         JTWw==
X-Forwarded-Encrypted: i=1; AHgh+RoQczmDclQ4w8/cotnrO9WG35yvZf/KupHfGAoGc3gkpq65RHtL5dhBx+9uRQKDJeMNsGhy0O4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBn2A32D+8FwCPCpNpZEg4m+t5eyHGeJzeZYgDUMahx3isVKCD
	vk6ijsjnyg7Kmj3ofznUJP+ETBkP8lgnZSsBwoM9Ngs9YR0rxdIhSQsA5y3WTR+HiT+NeJArbK9
	0No4QqA==
X-Received: from pfoc6.prod.google.com ([2002:aa7:8806:0:b0:847:9199:e06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ac07:b0:84e:d46f:492a
 with SMTP id d2e1a72fcca58-84ee496c951mr366009b3a.70.1785517586327; Fri, 31
 Jul 2026 10:06:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 10:06:10 -0700
In-Reply-To: <20260731170619.2620845-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731170619.2620845-4-seanjc@google.com>
Subject: [PATCH v2 03/12] KVM: selftests: Pre-set threads affinity in hardware
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
systems, this reduces the average runtime from ~10s to ~3.5s.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/hardware_disable_test.c  | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index f088b4af3ccc..d8288147b0a6 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -36,7 +36,9 @@ static void *run_vcpu(void *arg)
 	struct kvm_vcpu *vcpu = arg;
 	struct kvm_run *run = vcpu->run;
 
+#ifndef __USE_GNU
 	kvm_sched_setaffinity(0, sizeof(cpu_set_t), &threads_cpu_set);
+#endif
 
 	vcpu_run(vcpu);
 
@@ -50,7 +52,9 @@ static void *sleeping_thread(void *arg)
 {
 	int fd;
 
+#ifndef __USE_GNU
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
 
+	pthread_attr_init(&attr);
+#ifdef __USE_GNU
+	pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &threads_cpu_set);
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

