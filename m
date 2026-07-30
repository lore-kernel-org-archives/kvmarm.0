Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ADB46983B
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 19:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439158; cv=none; b=V4KerBSZtc/X/yUOYe7Ezkt7wapWqwb2rlYh9pf7XcbpmXI3HBMtIfNC80a4jxpm8GORizLATeh2piifwlMTcOloA0z7jkekXsoe5fLWyKVwMZQsvQZDHla6J+AdreqfuoUxsMcPQtQe8biLBD0/P6BbH/3a8tnBYDZGF+xkuUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439158; c=relaxed/simple;
	bh=Tzl/WlspRR+eS7uKI+T8ZIUt3U1xrKjzYObeF9nE8eU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FahmvE/wp+x9CCRdVPdXwB5vOBICVrl91mFp/Gy5q9Bi+TC1kKRme38dOBFa2Vh+C+7ZKiGCSy0yaAp5SIw/Kz/lSAyZL8hdaMBvVPniyt8Es0V9oHMDUYXfap6q8tJ6A5bDlmKxIO7NIHV7sQJTsE700bRpUNHy1PtN9SPb+aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N49VocfM; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N49VocfM"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e1118e4abso538735a91.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 12:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785439154; x=1786043954; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kV7AgRqM0rROb0IpxCIjCBLFpIy5wqfEikqI+1M66/s=;
        b=N49VocfM+98ndneBNy1XNGY3VMDR4jZr347NUD3ColTyePIoA23md8kr2/yvwlgDiN
         lP90S5AaZ2eAocycoxTLoPkYjUphdXeMcjwuor8uk2KSW8HcrFFHdoqpGzKXwC1vuSdB
         pIpdeJUxIpmXE/M6IFIasyXvoLgclHZ4wgeZT9o+kfCNKxN5CFZGcvHFY2Jgep1E2bqc
         cEMdJSUIoLYyOjm+Jb6QqTklF7S2bwzkTpaqKBP97LZpZwSnzwAuwPJf4xgwJsBrG9M9
         QT5g804CvCXfkSAe19GnogEBUVGbYJq7u2rScsEGObS/Mkw0a5WA2ZHxZQHTlaEJuxaD
         myyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785439154; x=1786043954;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kV7AgRqM0rROb0IpxCIjCBLFpIy5wqfEikqI+1M66/s=;
        b=qSTnFwW2ahrQ7Yiylgn6BOdJVDdkrER510oCi7jpm8YKik7fZqEQnxuu2I88sD6KOS
         fnXpOgzi30uCpx5qmpfEaA2bT6Tonph7SNWkzg0ui3/4VzAilPybKISsSdyNJz5YG+pw
         v3gmKsFDSkAvcHQi+nlp/EUF4vMM8/tzVnLK/W5Y0lwZBLX8fkotd4M9Fm9EVlVjApRm
         ntGRE0fwPq29u2/ZIJxye+YjSJt7eG+Xz02WJcigLu8WuCWSSO2GmpI1Vyv4y+tEJxeK
         W6mNxvbCTbnhvJlTqceoGQpf4igbjylsk4vuVCFiR+z759MDJd3ap7wLFOsfSz8LSMfM
         TuCg==
X-Forwarded-Encrypted: i=1; AHgh+RpZWhDY5BIW/HGhlKNuSNtAEQTIpXjsfPhzhlOBDoSkbPCiqx2J7IK2cY9idjxY0BXypEP/8xI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw66hEIqKI4+zDuSA3XOPumjVejROpZ5PxFXDyhZI3fsqKfVMkE
	eLatcvbomTbMLXOSWVMkVseVCbXrnRfbQi0tMbv3tQpbVwt+tQWxGkGtnYyLDWPLm7kRyYjniSK
	OnhYmeA==
X-Received: from pjbmg16.prod.google.com ([2002:a17:90b:3710:b0:381:bbcf:b10f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e4f:b0:38d:dfd1:7a8
 with SMTP id 98e67ed59e1d1-38f9bd3ef8cmr2857348a91.2.1785439154115; Thu, 30
 Jul 2026 12:19:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Jul 2026 12:19:02 -0700
In-Reply-To: <20260730191908.2084803-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260730191908.2084803-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260730191908.2084803-4-seanjc@google.com>
Subject: [PATCH 3/9] KVM: selftests: Affine child tasks to other pCPUs in
 hardware disable test
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

When possible, affine child tasks to a different pCPU than the parent task
in the hardware disable test.  On preemptible kernels, running 4 + 4*16
child tasks on the same 4 pCPUs as the parent can result in runtimes of
several minutes due to the children making it difficult for the parent to
make forward progress.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/hardware_disable_test.c     | 28 ++++++++++++++-----
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 3147f5c97e94..1bcbd13e9994 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -22,6 +22,7 @@
 #define DELAY_US_MAX 2000
 
 sem_t *sem;
+static cpu_set_t child_cpu_set;
 
 static void guest_code(void)
 {
@@ -84,16 +85,11 @@ static void run_test(u32 run)
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
@@ -101,12 +97,12 @@ static void run_test(u32 run)
 		vcpu = vm_vcpu_add(vm, i, guest_code);
 
 		check_create_thread(&threads[i], NULL, run_vcpu, vcpu);
-		check_set_affinity(threads[i], &cpu_set);
+		check_set_affinity(threads[i], &child_cpu_set);
 
 		for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
 			check_create_thread(&throw_away, NULL, sleeping_thread,
 					    (void *)NULL);
-			check_set_affinity(throw_away, &cpu_set);
+			check_set_affinity(throw_away, &child_cpu_set);
 		}
 	}
 	pr_debug("%s: [%d] all threads launched\n", __func__, run);
@@ -147,12 +143,30 @@ void wait_for_child_setup(pid_t pid)
 	}
 }
 
+static void setup_child_cpu_set(void)
+{
+	int cpu;
+
+	kvm_sched_getaffinity(0, sizeof(child_cpu_set), &child_cpu_set);
+
+	if (CPU_COUNT(&child_cpu_set) < 2)
+		return;
+
+	cpu = pin_task_to_random_cpu(pthread_self(), &child_cpu_set);
+	CPU_CLR(cpu, &child_cpu_set);
+
+	while (CPU_COUNT(&child_cpu_set) > VCPU_NUM)
+		CPU_CLR(kvm_pick_random_cpu(&child_cpu_set), &child_cpu_set);
+}
+
 int main(int argc, char **argv)
 {
 	u32 i;
 	int s, r;
 	pid_t pid;
 
+	setup_child_cpu_set();
+
 	sem = sem_open("vm_sem", O_CREAT | O_EXCL, 0644, 0);
 	sem_unlink("vm_sem");
 
-- 
2.55.0.508.g3f0d502094-goog

