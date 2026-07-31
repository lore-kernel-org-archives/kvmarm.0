Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8A13793B1
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 19:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527788; cv=none; b=nbyCbGEA6CZjfWkDiaGvCQzPNI3gP+TJGNaTkzkv93zB45drtd5cr74xmke+AhUd5esxw2MJt6IX6atjRazjEu1aunT4E1NBcdLFj++KntlScd389nStoDzkggvBtd3fi5ETAFL/x4tfGES/iJvHTD29o1mwfoWAAxchpJODLsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527788; c=relaxed/simple;
	bh=/TJjnxpVpH8WmXNaVzrS2AeOgP3QdjHKxDY/CbjUI8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WwPPwHI+tBVjtpo/RB+l1EXsA+IMh88DiUocfcNsj/u1Y7YU0PPqO1vfkzaGgV7OAIyyxlHGZfA0L+ln+dIfPrfUl9v50Rz1ynapW8Cp+/oKNX5Gl7xNzzQYmDst3OVrpoGKp+UfMzEN3vCnXlJePQUTZYvj/KrfG8xSiaULg3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FJpwKqxV; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FJpwKqxV"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8487ed7f7beso1568609b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785527782; x=1786132582; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Bs3K8CpV0aK6wpGyTBasGbTbkVQEzOsTzupfjJkDnT8=;
        b=FJpwKqxVQjBfc/JpeNQQINJB95c/G4DOkNdiNLKhrGvSVxU3mhBEoE08ymyAZUNoLO
         ElIQUV3vkeBAqhHS3NDo2a1IMkQD8zYM86czvOwfX/zC5kCanZqKSbv+YijY7VXefBqT
         4dE3HJxZCc0ZEHbrdTvPLaIVmducrDQuw0N2OrXbCtXrTd5LUgYXN+dn+iokuLVrZxAj
         UiEBANgebIIndJPRFykMEjps+iYVhGf6GhvePzNR6pYXcFSpKnumeQul8EA6tqmnm3Rd
         nZzDbtVn3on5g1j66vFJy+IuiVuMij/5kHzH767Mki93w5EMwtpoS7H/zi3DzSyOtavQ
         761w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785527782; x=1786132582;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bs3K8CpV0aK6wpGyTBasGbTbkVQEzOsTzupfjJkDnT8=;
        b=L3zv9NLRPpVJAIBxwLykFTFD7Qt/LkxE703+yZkG34y1HtcI58EgMvrERJXFddPCOX
         9dQMI37HXDbqNaqWYvrFleWe/giSprDdvyvCK9Sm2Zi5pVb29lX7ExKRqcopaI9t/wD8
         yrD8e2NXlrrgVSOpEPWG+gBiJj4KuQ4olRj0IvqUmrU89XW/KnUtu5kBPqHodi8gk21F
         Bpi50J52iUj7C7JU/OBllYRi5lQbp5zj/8STVXsnKLbRaiD7WtnET+i0iGG2gnJHRwtb
         33PKbi72kcU6bcU6bk0XVxhiUiRHKGN8I2uieSZFZV3WpzOK0YNTA3Anh42Vim7JC/0F
         cPJg==
X-Forwarded-Encrypted: i=1; AHgh+RrfVPg1Ma6k7t2Ti/yVe6SaAMkRK7362Lb+jrIsQSHCEgBHFD3EsNfZ2uxUWDr49v+GKw03fTQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwsNFl9/JyGX2MvOLKffSvD2Eb+3aVNcJ2+ky2A5qH365f7ehQh
	bLUGqLIXQvP1snCgXo7ReEGD7AwjvlVU/wp6TWRBVgBuwqx2C6qFkdPAKO8UR97+u5MAL54Wvmj
	DB4eyCw==
X-Received: from pfh33.prod.google.com ([2002:a05:6a00:12e1:b0:848:46c7:cfe2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:f04:b0:84e:d46f:4921
 with SMTP id d2e1a72fcca58-84ee4915b80mr752468b3a.66.1785527782134; Fri, 31
 Jul 2026 12:56:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 12:56:05 -0700
In-Reply-To: <20260731195612.2697986-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731195612.2697986-6-seanjc@google.com>
Subject: [PATCH v3 05/12] KVM: selftests: Extract picking of random CPU from
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

