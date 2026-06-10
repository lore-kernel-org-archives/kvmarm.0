Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F171D3093CF
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052844; cv=none; b=QvnAxJoJXq5NLLM/aoubk8hgVsVdcJN9i+/rPChdHaa3XfTi2ufMycMdkrpqZZ1+RPCNSVpyZIWrg/b3Kk+2MNPHa4BzhWm1fbOa5gri5B68EWut5h81GmAnij4qGED3om/e6wAhTI2dlWtk4mADGp9cuEqOKFvGcuKyY6WAeQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052844; c=relaxed/simple;
	bh=JlooIplFY0tapZ4KHCVZzqX1ug3glWpGzl8vxECWm74=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Us0J3RD5UoohqPr+JVL/RxSp16rP/s0G0zLOQd2kKT4ep91sh9JRs1Qxjq18aNkhkXeyX0Oamt74BUzyVZPJy/HIEodP4pFU5m/aC4tQmraLq53XQoUzYJ9nU3HSKQBHBFvAmA1Cbqk7Eie/dVP7+eucbwbk4dS7CBt7vog4CLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X1U3He08; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X1U3He08"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8423f1fe39eso6740650b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052842; x=1781657642; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=i+ncGA6Fvns8f5sP+kNiRwZfNV+IfAKagrqzhgLKDtg=;
        b=X1U3He08ORhpb8sgYkKyZ32+V3InkEdFzYkaE0SSb+Cwq1cpWjmzzBm7qQpjidgDYr
         X373WAl/j0ycvTPD1dADcUfCctUxE7bheLA3rsCUIws65UamJK+GlzzuYgMN8rOkq/Ld
         O44KUHsQzkvHyyblchUWaVfxbblxDXDRT4UfabNagTdjK2GWlA0TfwYDABXBjaJfPObL
         kWM0D5SYNP6oja+RQKax0atMaEjeGvcgW1SMHDE3qQSy8lGdjUmzCJeT8mtsyA8WRnz6
         nhStfcP/7zTskxdAE5B33oHboKyGK9vR74lUse2wdkouncB1sYYDdjT7Qdjdslc/Rjcs
         cKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052842; x=1781657642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i+ncGA6Fvns8f5sP+kNiRwZfNV+IfAKagrqzhgLKDtg=;
        b=NJiyZWScUZ9ddHAZYbHJLT/1u5//VUyDCgqyxz17QOwSzOVfBNKDHh8snrL8onIU6J
         EBPGnHBt3awIaBDykMKVTRfhk1CiHnXs31Fd+UbUIbPAdxKV78iFIAnKU7RF1UoZBQPo
         doXoSJzh5j+NFoDhjQR5uVb2NF8MpP7AN3boWQlmiol3czz6rqDMw/FYT5d/A/xmlPp5
         7pQl/xYvuM739WJaLjaUuENWJSxj41/rD6pLu6N3YN+jNM3i45NehkT8Yp77NY8s9jdx
         uP6WT+4avz0dkno6FJMoHC1U/br33TQ9YTYjxtZpQeKUiUGXRl9U4+6iH6PsIBoD5Ohc
         Gduw==
X-Forwarded-Encrypted: i=1; AFNElJ/1mFAkUcjq18gVzSjgAsngCs1wWg0LoKoXGLx69ktNE214TSdzUubxNPb1eN3NGI+RHhQA3H0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzckfeaTckEz1xprT3Be5xfQu5sJHK6y7cl/TjiUwMCrZA/xo54
	/TPMjUtub8tSfNaYHSoPUJd+VKw4/c/U6IX3XfuDRwegItr0ofTPsRi4ibcg7wPEUgb9bEdqH8+
	Tr8UAtA==
X-Received: from pfad10.prod.google.com ([2002:a05:6a00:28a:b0:842:84fc:f4f3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b90b:b0:82a:6461:6d15
 with SMTP id d2e1a72fcca58-842b0f49acamr22128319b3a.46.1781052842229; Tue, 09
 Jun 2026 17:54:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:35 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-16-seanjc@google.com>
Subject: [PATCH v6 15/18] KVM: selftests: Add a utility to pin a task to a
 random CPU, given a CPU set
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Josh Hilke <jrhilke@google.com>

Add a helper function, pin_task_to_random_cpu(), to pin a task to a random
CPU from a given cpu_set_t.

This helper will be used eventfd IRQ test to migrate vCPUs to random pCPUs,
to stress host-side interrupt routing and delivery.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c1f588154398..b39e713c30a4 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1094,6 +1094,8 @@ static inline void pin_task_to_cpu(pthread_t task, int cpu)
 	TEST_ASSERT(!r, "Failed to set thread affinity to pCPU '%u'", cpu);
 }
 
+void pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus);
+
 static inline int pin_task_to_any_cpu(pthread_t task)
 {
 	int cpu = sched_getcpu();
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 92013883f35b..72f41b15594c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -662,6 +662,27 @@ void kvm_print_vcpu_pinning_help(void)
 	       "     (default: no pinning)\n", name, name);
 }
 
+void pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus)
+{
+	int target_idx;
+	int nr_cpus;
+	int cpu;
+
+	nr_cpus = CPU_COUNT(possible_cpus);
+	TEST_ASSERT(nr_cpus > 0, "No CPUs available in possible_cpus");
+
+	target_idx = kvm_random_u64(&kvm_rng) % nr_cpus;
+
+	for (cpu = 0; cpu < CPU_SETSIZE; cpu++) {
+		if (CPU_ISSET(cpu, possible_cpus) && target_idx-- == 0) {
+			pin_task_to_cpu(task, cpu);
+			return;
+		}
+	}
+
+	TEST_FAIL("Failed to find random CPU in possible_cpus");
+}
+
 void kvm_parse_vcpu_pinning(const char *pcpus_string, u32 vcpu_to_pcpu[],
 			    int nr_vcpus)
 {
-- 
2.54.0.1099.g489fc7bff1-goog

