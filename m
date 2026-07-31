Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A47450901
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517591; cv=none; b=UEJjRDmswlJBt5y079wQ55x8NfRUsJ/pzcSqpLe3VN5L/IrEOPy6alyYIGTuHHjH+TL5uwymXqdE5PCu/bBmO6KfD4hWxg8Gr0nVMVGmzLZyyYCwY0UtNQnyOrmsCRWLFgY4HuClTHoWCHjwwmOX1Nqsz6RUlGINAnozUzPdiSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517591; c=relaxed/simple;
	bh=/TJjnxpVpH8WmXNaVzrS2AeOgP3QdjHKxDY/CbjUI8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DfFch1iEzG9BhRgc69kfz2PvB2aypnyultNgfX7Ojz8hIwRD20fZkOrgDKEbynOHO2t9Zy9pplnOKFUz7RiRjFzxoOFJApbLjc9tvkU5wCs8Yhrs6jnHsikXrNbGFnxHqVSruUaThe1wsTpTQEmOEEFi16w3Cn1VLpEKqfll+1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r8lNft4D; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r8lNft4D"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d004f13426so14701425ad.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785517589; x=1786122389; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Bs3K8CpV0aK6wpGyTBasGbTbkVQEzOsTzupfjJkDnT8=;
        b=r8lNft4DeKClqEQegisYmpuEz6nojK/phXPY4GIXe1ELlTMLyHLd1kNJG+ahqy5yoT
         rsd61GsHE8A3M9dxoBmzRxOdQbUfA/WDbVVJzoc/FRWMHG4WqPdgbC8wEUSutyRhpA6k
         hl5o0ECyzhk3gtq0W+EGfMz/LRWKttupfHLCHC8DJ8QStivnbUS1vSfMSYAfDCDA4DaI
         TQoenkClIo0J5QCTqm52H2AXnnDCdLBSLraN5515+Uww4Bg7YmDVT7Ga1oUBg61XyKC9
         p8MxMeYlkm9iR/aTKfcNDVHY1lxU8wABteoY7igNv4MXErT3MxJhsxqiurul+TFOSg2j
         KFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517589; x=1786122389;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bs3K8CpV0aK6wpGyTBasGbTbkVQEzOsTzupfjJkDnT8=;
        b=kQfOT5XMmb+XfmkGnDNvMyO5eSJ6QMuWU7asjzeMmME6yhHrygny/iP5UR4e+91uL5
         9DGR3lwaO6Iw+6ZlSEz+6Q1Y+8pLTZWY/mVKvVIlh4NZEy2vBQtzhaR2JJlS1iyhj5IS
         0BOz9cKpw9JZdGpEeG0l3S9h2yjMPiodamJXdlaeNPPp8APsv9l3pYouQbW/LAQMh+b1
         +9lacb/REgSA2tcVlRKS1tYNJDjVf1VJR+85HRtmkEwo25THNgiysN5pdG6vRAoyKv1f
         xyJ/O7lBTjgX4AnLVQk3X96hCjR0CFyPtjvNWWtXKpIK2Slntk9/bTBn85F5KrfUdCen
         wGOQ==
X-Forwarded-Encrypted: i=1; AHgh+RqWpIAbyUydZxIJ5esaewa6N9Ucxpqb6gOBjK7rqBPWu1rW+OglN7C/O9XXoJEaF3FZDNpf8AM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw23aqtbWwYZu3xqTJBXM97qgAm+c5ieGKxD9QY0cSGrT6sH2de
	VXKKYcP4ljz8bMEfmI83Rjp9DLyrRAMKv/g5E6J7YUDlMng9Rt+eXjjsJJFOA3ZpoOziOY70B+B
	fea5N9w==
X-Received: from pjbee14.prod.google.com ([2002:a17:90a:fc4e:b0:384:7daf:f48a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5605:b0:37f:9ce3:ca95
 with SMTP id 98e67ed59e1d1-38fbc560e9amr564372a91.30.1785517588641; Fri, 31
 Jul 2026 10:06:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 10:06:12 -0700
In-Reply-To: <20260731170619.2620845-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731170619.2620845-6-seanjc@google.com>
Subject: [PATCH v2 05/12] KVM: selftests: Extract picking of random CPU from
 cpu_set_t to separate API
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

Extract kvm_pick_random_cpu() out of pin_task_to_random_cpu() so that tests
can choose a random CPU without having to immediately pin a task to that
CPU.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 11 ++++++++++-
 tools/testing/selftests/kvm/lib/kvm_util.c     |  7 ++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 61d72e1e7601..5a7a455b5387 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1084,6 +1084,8 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 
 void kvm_set_files_rlimit(u32 nr_vcpus);
 
+int kvm_pick_random_cpu(cpu_set_t *possible_cpus);
+
 int __pin_task_to_cpu(pthread_t task, int cpu);
 
 static inline void pin_task_to_cpu(pthread_t task, int cpu)
@@ -1094,7 +1096,14 @@ static inline void pin_task_to_cpu(pthread_t task, int cpu)
 	TEST_ASSERT(!r, "Failed to set thread affinity to pCPU '%u'", cpu);
 }
 
-int pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus);
+static inline int pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus)
+{
+	int cpu;
+
+	cpu = kvm_pick_random_cpu(possible_cpus);
+	pin_task_to_cpu(task, cpu);
+	return cpu;
+}
 
 static inline int pin_task_to_any_cpu(pthread_t task)
 {
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index af2bad0553f9..9ddc047d5c27 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -668,7 +668,7 @@ void kvm_print_vcpu_pinning_help(void)
 	       "     (default: no pinning)\n", name, name);
 }
 
-int pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus)
+int kvm_pick_random_cpu(cpu_set_t *possible_cpus)
 {
 	int target_idx;
 	int nr_cpus;
@@ -680,12 +680,9 @@ int pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus)
 	target_idx = kvm_random_u64(&kvm_rng) % nr_cpus;
 
 	for (cpu = 0; cpu < CPU_SETSIZE; cpu++) {
-		if (CPU_ISSET(cpu, possible_cpus) && target_idx-- == 0) {
-			pin_task_to_cpu(task, cpu);
+		if (CPU_ISSET(cpu, possible_cpus) && target_idx-- == 0)
 			return cpu;
-		}
 	}
-
 	TEST_FAIL("Failed to find random CPU in possible_cpus");
 	return -1;
 }
-- 
2.55.0.508.g3f0d502094-goog

