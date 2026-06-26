Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC7C3CCA12
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509759; cv=none; b=ZrW+WgzISg0M0eJ6LPN8nHPNEqm3hwUU10xvhL0wDI7JJU7HTSo+7Uhir7lDWY6J7btu8kiHRjH52sI9kjkrKZg2ywYHlGOHKcnmj9ZaVRnUPOLodsUyuVrYi0vRjcY0X8CEnzY12Vmj+E43eJa253RHHfkXP7x3FRO54PyHO7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509759; c=relaxed/simple;
	bh=quYP307cCmyP2CKKWA+CHAZMV/Jy7UY2hC7jDhiWYJM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=agU3jIrNuSGZOtzydIP4DPPPxd6aiE995vOhpdwr8qxU8K1ZxqfdI5g1dfsLIoZpTuE5qn5cc5Pc9R6labNMz7nrvqtM4IA/EqaaegzXqMiwL1l/tldpS9cRTt1oGYSMQmtW1MHKBE0bz2d/4cwxiijx6wSmrctTbwaSqZAKAtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GE/I/Rqq; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GE/I/Rqq"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-845b97ebc72so1052368b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509757; x=1783114557; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rZu3Cjc6CZtki/JQXUzTgacdlapy8vtMh25cja8rCSM=;
        b=GE/I/RqqCHV65TJnxMcMtPjJxlBWgCxuYL9yQKMl/q0TGYgoKA1huscbGMkfjyf8RM
         cCbe8yj+PaZcExtUmGv3em9yOA0HrPaGqIRb1nxfGgH7j6KvuCoJWFRe5HqS98dEFJi7
         yRVmjZYI3MFlXVYMCvkiD0m3GKq/6N7B1a9Re204RDJO6zg2iiJC/kyfWHD7azpIrp/j
         faAGjzJ1UzaxwfmN2DMxurzRex/QRoqnrSXMWMIy0XccsQbExxoOawtTvT//eaFp6OLt
         knwUNOLKoOuoXWw9ozuz37j/Wt9qxGEPCegRXMopDKBpj70OKJgiZr97BMCT92oJTsEH
         +Qtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509757; x=1783114557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rZu3Cjc6CZtki/JQXUzTgacdlapy8vtMh25cja8rCSM=;
        b=OvUcud1OjZKdNxuA953iWUSBfJOBCYMygQHRR7LR0brUDzrQP7ix7o2D1TFQirvR8/
         fcauDiD3q6dKqPbWjSoKN1o6MG8wqBTjMPn1kWtTYv5FkAolEzQOYfwLmPiX9qmM08ps
         NO0aFBCTuEWVhyknBdnkGNuqLU7I5SbVeHWTb22uKPLQOskZiDm0lWTcxD9/dq+xDTFm
         vvRIiO+Su/5m9e8HVgZhJiUa+IHMYYH7wzB/CmTe2DNfAxDhsANmUrmkS22QgSkxfR/h
         Bvj+LMs8h808Eb9YkGrdkKQLd32SMv9SxvZInXYRbPyFImEToiiRrbVIAmZRdSuB/HN5
         KARQ==
X-Forwarded-Encrypted: i=1; AHgh+RqqfmAyxNaaPRbil5B5cXzGKtBjmzlHZx2h5m5HMh8qe995k5iUUDaVPq57S2dC+v2n4y2jT6g=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbEcnjtZ9M3GVMw/9OPOxs7iFF6l9nztya2avL4n6saDslr1uc
	AkMLZI9Ustr8nKQFwHRiadbXaOkvh2LakTsu/IXL6+2clBcp5dir2qSVsiluFb2dBSuQ1ooQVhK
	QAjsKCA==
X-Received: from pfbgi11.prod.google.com ([2002:a05:6a00:63cb:b0:845:ba3d:923a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2987:b0:845:d274:bf90
 with SMTP id d2e1a72fcca58-845d274e56dmr1605456b3a.57.1782509756871; Fri, 26
 Jun 2026 14:35:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:30 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-18-seanjc@google.com>
Subject: [PATCH v8 17/20] KVM: selftests: Add a utility to pin a task to a
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
index 6a0ee033fdef..3794575d2ca0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -668,6 +668,27 @@ void kvm_print_vcpu_pinning_help(void)
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
2.55.0.rc0.799.gd6f94ed593-goog

