Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6532D44E67C
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517590; cv=none; b=Jd/9oidprPe4b8glKcJo+bAWm393NZLtvxnjA7Ry9VT9rFBAFNFENlap7qurw/gUEopK+mHo8A96PFXcKBqgtXQCio+LoTrCgY7phx14nWUkqMylgCdPSn7D3y17BRWio1eUgTc02GuFbcBGDqrOY4DawB4RKG8rpRJp5pBgIm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517590; c=relaxed/simple;
	bh=HRd/veKnQQoNlLPIk/S30A+ciXDQdelNm8xjt5JmDww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m9aerIKo+AqopEUEDaR42h6BMs+8J7EdTUBBTXSfRcGXpu71ESyKi54L9SzGzBUMxJKTh+/UwVzeMazGB7yD+CQj+PKQLNVFXFvaq+m8pe1YqBcuGHveaFKev1vA1ai9P8hcQ7KtyUQ9WJo/ccmzUMSIunnxIv6vZOjiP/0mRw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f5Pjn6Fd; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f5Pjn6Fd"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb5cc1e139bso769216a12.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785517588; x=1786122388; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kus6EqucfaH9HPf637yAVY0TPxuMIU/5NctVRnWGiLw=;
        b=f5Pjn6FdMlk/ffbnzalAto83vFn6QYC/vq4Vi60WmTZo7LVKnB8rnrgk5K39P5sVtc
         NJCDM1+NpO5y5wEmDdZVsDuq+7VSzOJKWZRbd5NgoyvUa/ZRjf9Iuu0YoktpiFhxbeU0
         nM/d2SyQmyQH3Yf/nW4/nkofHwlZuYvNzJUGfE9BZI1achTBeYk4G+3Are53nnhoXkVZ
         o3tRqRndQMuHQkXUNIFBMFbsOZyKS/pZzwuOR6xn/Njj5l1gUdIfIoXZEFhiuZyAlOzb
         CzbQyP9OL1p4dpAr34AHVNvoLtBlkfEdYXHxUA4ZjwA4o9L5QjG1skcJdBcGX7xhNvZa
         b2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517588; x=1786122388;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kus6EqucfaH9HPf637yAVY0TPxuMIU/5NctVRnWGiLw=;
        b=Wb3sRIRrXfEOQdnFZSHtA3awH3oiNKtbhYbeGS7L0GaILJzZZAtjbfh2WQBihQzejh
         jRXFILS4QxKiD64XMZ/R/ODio/PdxL0LlTyJJo2hdcciynmyMGIp3+6PdOqnL7ihZ6SM
         hk9Jdg7gd+HLkcacXBpaQx/fpWt5d1TuzOakZHGSBpwP/YITsQCmlEa/EDRE5lKZFE5S
         3Eb5GPjBMv+9zU2f+FZjDvacZZEjewVSFeQ9uz4YqcUR6kqQtmDgpU7tw6N+xwepZrYQ
         jdlyyqONYLmS0Pqs3R09D3mDdStGZAmG0W/Ns7lp89dExJF49iw3kYKeEQofVCd9v3iv
         YK2Q==
X-Forwarded-Encrypted: i=1; AHgh+RoqF+aJia/rv+/N75hBSfD0kpcoYtUMGPUHR2+gtmxMmkT1oeO3VjqZguxclslBgJTbO5lIiRM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzC60QLtS1HKvMlnaYkltGpep0pbb8TKR1dwmOGby9W4D2TI8FF
	DRbeqJVChWD8O6xY+DuORu21HawRnNJe1cC6fLixb/igw4ZkFc3jsjuhCucmo5y3ixnaf+KYMDp
	bQqs3pg==
X-Received: from pghd20.prod.google.com ([2002:a63:fd14:0:b0:c96:8e22:a215])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:116:b0:3c3:a1a4:862c
 with SMTP id adf61e73a8af0-3c92a94e9ffmr515706637.68.1785517587444; Fri, 31
 Jul 2026 10:06:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 10:06:11 -0700
In-Reply-To: <20260731170619.2620845-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731170619.2620845-5-seanjc@google.com>
Subject: [PATCH v2 04/12] KVM: selftests: Return the target CPU from pin_task_to_random_cpu()
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

