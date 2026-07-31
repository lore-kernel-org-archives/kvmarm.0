Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A830378823
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 19:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527784; cv=none; b=WFqC8maGvEZ3HmKA8Axm1IUu6vbu5ZMBYGw1TJ17M2kNtl4HYi/sLRticYLI9jwE6UIMpOREqaUfZ3laMAbq+UDNH+Na5szb6YjXv0+PLuo9WEdlt6bYjw+XryK0hhCLirMyQ5ajaevpnN5GiH1XBcuHq+T/KEADrUi4HhgOWKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527784; c=relaxed/simple;
	bh=HRd/veKnQQoNlLPIk/S30A+ciXDQdelNm8xjt5JmDww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dArxeVWD3G9NH5oRSaU0e5ayAlM4x4WBdX8Sq8U0TO/qoM9Owq3ovlSKaowpD5P8Z2Pni1S+uCM5uENzahwJ7XrX31YdUGiEVsZ295/uWd9/zBQgZG4a0+08yk5V/i8mr9NxsVICFKrmBn2DgPikiGu3J8e1C2fWJiJf64lWL7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UXRzFYqI; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UXRzFYqI"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84857446424so2574634b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785527781; x=1786132581; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kus6EqucfaH9HPf637yAVY0TPxuMIU/5NctVRnWGiLw=;
        b=UXRzFYqIQ76I4UeYmzZVlcZkLXGj8Ej689m5L7XYMQEL81+FqaHvEHT2H7PgTDFbCP
         cYMXaPDCpU7Rr9ypcPZiuKXLp4xDQxBjVywybXzgxUyGTodImc33CsiVbqqN9EfYohav
         WFrxqfy7MN/lWlNoKK8cBUtCWTBZgzYUsZbZXiPbVgLlIdjXNTIJCf6oave6SLmibCK7
         N98QZ0mNZXrjfp8RAWl599Cg+Al7nTQMisCMf3dCEvCQJ6CUxa9JbhLy0mfyuI8CRV5E
         fzi5d/z1ED1pJzKouXLooUWaFI3O34jw04lb6zLg5oAzdxN1JynDU5I7nNTOIGNd0vH+
         0CtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785527781; x=1786132581;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kus6EqucfaH9HPf637yAVY0TPxuMIU/5NctVRnWGiLw=;
        b=VmexwCYvzNMxDwFi+h4f/O11km66nu7jolVvWUQy0hU0FN3lV03+JCsAKTcls39iYF
         T4MkGbhJKjw8PCUjeZPDqKfj1B5pTIh1Mf4y0nze4bzSwGO777cMosg5EDjNcajcnbBp
         GNmyJdLIkfMCryyBpWy06USw+JHYJoNuMnPF7gNgSpggDHdw2SMIivcYdPzmz2d2rzG5
         5HtExHhIjRZGGBHMLBCt96pFC9ai2V3Iz4Qoc88wTLYGkHG7scQtDgNRsOq753xfMJ99
         CrvXVUswNwAZflm4fmiNXRYMa/ClFEQhDJniDPL3gal4dKTHIvVbBFvd45CLAv26Ge5j
         le7A==
X-Forwarded-Encrypted: i=1; AHgh+RpcHIdAe1wYmkYtO2qDUMCynOQjxsmn0lvniZcLU2SAgKWtCJ2RCZQgXpBtp4HgjFoRxpkgOrs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCdsxInh1geR2k2dH3k8wvdzvz2FLznHOHPaaOTOsmueYKwMm9
	ETjcIK9DMWtK9QapU0EBnwCYdonYiAVe+KTcQlsWW7RQPzdi11wC0olCF8Rzf1Qi5mO0InCo+FF
	OzkliHA==
X-Received: from pgiz17.prod.google.com ([2002:a63:c051:0:b0:c9f:dabd:440f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4c95:b0:848:63fb:fd91
 with SMTP id d2e1a72fcca58-84ee490ac2fmr778630b3a.41.1785527781042; Fri, 31
 Jul 2026 12:56:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 12:56:04 -0700
In-Reply-To: <20260731195612.2697986-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731195612.2697986-5-seanjc@google.com>
Subject: [PATCH v3 04/12] KVM: selftests: Return the target CPU from pin_task_to_random_cpu()
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

When pinning a task to a random CPU, return which CPU the task was pinned
to so that the caller can do things like avoid running other tasks on the
target CPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c     | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index b39e713c30a4..61d72e1e7601 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1094,7 +1094,7 @@ static inline void pin_task_to_cpu(pthread_t task, int cpu)
 	TEST_ASSERT(!r, "Failed to set thread affinity to pCPU '%u'", cpu);
 }
 
-void pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus);
+int pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus);
 
 static inline int pin_task_to_any_cpu(pthread_t task)
 {
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3794575d2ca0..af2bad0553f9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -668,7 +668,7 @@ void kvm_print_vcpu_pinning_help(void)
 	       "     (default: no pinning)\n", name, name);
 }
 
-void pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus)
+int pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus)
 {
 	int target_idx;
 	int nr_cpus;
@@ -682,11 +682,12 @@ void pin_task_to_random_cpu(pthread_t task, cpu_set_t *possible_cpus)
 	for (cpu = 0; cpu < CPU_SETSIZE; cpu++) {
 		if (CPU_ISSET(cpu, possible_cpus) && target_idx-- == 0) {
 			pin_task_to_cpu(task, cpu);
-			return;
+			return cpu;
 		}
 	}
 
 	TEST_FAIL("Failed to find random CPU in possible_cpus");
+	return -1;
 }
 
 void kvm_parse_vcpu_pinning(const char *pcpus_string, u32 vcpu_to_pcpu[],
-- 
2.55.0.508.g3f0d502094-goog

