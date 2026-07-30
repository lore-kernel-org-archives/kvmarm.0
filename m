Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3B53B440E
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 19:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439154; cv=none; b=h5Po+4gW3tV63vdN8Gn0eJmH/H4ClQrM/3g4IfbHHSRklVlAXbePSkNQLWO0GmhN6wElKlzB9OH7dGalZGMlArxxEb4DJlXZrRX8q7Qlxvp/BRq980pPueKZKYwtGxpZaNByPBepZiyK5zfvyaT+xsSjkz+fJVlTG9MRMI5eQUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439154; c=relaxed/simple;
	bh=HRd/veKnQQoNlLPIk/S30A+ciXDQdelNm8xjt5JmDww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LaWGIX2SEga+73xLFmZCj/gahBjJbMDUe4vOZeBAL97Ar3fTucDDW7FgtgQ+pTXb0Zo5KBHv1Sb7Yc4W2RUa8unJdakoBEI3Q68j0QU72i7yZUaOPzjQMEJRIoQwUzuewGCgCcj4PbdavTg398FBYFL7/BFGxjVW3LFiwM0Ksd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sctFyi6m; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sctFyi6m"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8485d853b08so361053b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 12:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785439152; x=1786043952; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kus6EqucfaH9HPf637yAVY0TPxuMIU/5NctVRnWGiLw=;
        b=sctFyi6ms9V2HS+SVpUrdpis4US11PnuZtouV/u/wlE0ZnocZxOHpkGJQIeQcFoSfW
         7K886laFVzIkde5TNSv3eAXCzdUEbXb5KItjtB/mco1b0q7amDe2BYypWh2wY0PHu59y
         itamf46hfnunLusoBtqCCMfC2bJQ6OnkOP3LyKeBeqNKNnoF4df4ReC4TEy9+8dJjrhw
         uEnuK6yGqoZEY+ztHYJZD1NDohOErcJsg9wsHw36+7eGS7Vi9+Rme8Lv943+i6Tk5e8H
         CS1Cv6Tj5BkFjvnlenrze+11V3U6ysjKisd/TykOigdMYprERMbQcy01s/mEMv7cilb3
         7gNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785439152; x=1786043952;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kus6EqucfaH9HPf637yAVY0TPxuMIU/5NctVRnWGiLw=;
        b=I0GiexfpeXZw2/RotR0JFlJabl9hiR4zLt06DgrROpvOfO2sNfb4iruYtuFwfwOqg6
         /EGdps9u6xUmCdE0FPTRmAeux72Lk3vC9HTFxru4U8iJqiDIza+oqnJPr5oZIk2urDTO
         Q8RhHEgplycCHdvOLcw/ggHgRXP9dgeKov5PUvtLCQNCOxI7G099Iid2CN88k896HJi0
         NEOqbODYr4Kv6L7chwqAmN2nthhE8r8gyd3NWGnCYrAcPe1EoSNWEbf7CuOscCI91wtH
         MSOHzzOT2eWecJSHSroeV+UVEJbYwaHpSeLqiJUANREdbjwzyZy4uAl67YnRK8wgMrFq
         PxUA==
X-Forwarded-Encrypted: i=1; AHgh+Rosnf0Hy4mNDGxV0UXnXbfpreewSUsvystI8ThLaPJaVqZULyvFkf/lVu7727k51O47KanMb5Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVk9SxWOulR3JHKKguRwPU9m5glvozf4shAabj7jTUtAvgZhXU
	7GcWEWvJWBBhInisY14VWSv7rPCms7aGtA5gRliyeW0fwh3auVQ0yIUOaWgDry6LalWf2kWcWw5
	Fp6Uqpw==
X-Received: from pfjd18.prod.google.com ([2002:a05:6a00:2452:b0:847:7599:7277])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3020:b0:846:8b21:6304
 with SMTP id d2e1a72fcca58-84ebc1fd6bemr3617195b3a.14.1785439151792; Thu, 30
 Jul 2026 12:19:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Jul 2026 12:19:00 -0700
In-Reply-To: <20260730191908.2084803-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260730191908.2084803-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260730191908.2084803-2-seanjc@google.com>
Subject: [PATCH 1/9] KVM: selftests: Return the target CPU from pin_task_to_random_cpu()
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

