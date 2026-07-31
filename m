Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290A844AB65
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517587; cv=none; b=oOE+m6UA5OA4Spr7mIueoSVZoT8LxNN8wXHtQ7te3V6/Rs07ZT4EnqDaMqtm3h4DwCB/BM6dspuXKD0bc5HoSybNBXckY+L+v1k2wpKFc2bDg3zUXxfapKUW/ia4+ZN0HirA/85H5b50r66Bbs4d1T3OSfIN6rZbCC2s4I4trzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517587; c=relaxed/simple;
	bh=GTCdXxGxuqpPISX7zn1bGR9hfy0DxUEEavsRgWp0XqI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PElys/uO+4bv6vaMrDCaXO6g6BC/eV/Z2B+Zrd+UMeXIZtgWm4cks5WQYnlRmoLqJmmojJO/KNFXj1ehjGJntJeEoo8oZQvRCPeaEMp1dzqXGFWlZqKgRjXAidxkIlHMs/fSsfFSWz8frGeqZXLTCIUoeRV2zzcxNJAAzs0q8q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ECECDCiO; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ECECDCiO"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84870e7f498so1396542b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785517585; x=1786122385; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6tcAvkg/zKE4Wpx2bpF+dHLf7/L283ci232zJUD1488=;
        b=ECECDCiOQ3ozNASlb53rc1phM4j3eCuvnkjDk7ALEHdM2Wvjt1rUgRwks4QhDsxIt0
         z8L5DYL8UcnsSw6nh0DaykRs8OH0chRnfKPGNwCtRRj1Z0rFRQUY3rn29DMEn3zcri3a
         xO2YQMpEN3EV7kR4QdZVV7uYD2xAK2HYqCcGsfGKDyylJfBu8wpuMsVyxJGpK/GPdy6/
         HTsSJ1nKzndYAk3rga6af8nWyiCI1Xeux3zK3AVdi/YDofXcNZY3l++KAmXudqDkHSdi
         I5wUab185Qxl6rfZeJHDDwzmQnnMrb+zZ4ZCh2pN5lPNOmDq33guwUA1tabY2QLBv4cM
         iX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517585; x=1786122385;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6tcAvkg/zKE4Wpx2bpF+dHLf7/L283ci232zJUD1488=;
        b=L9nTMRJSOKtefrHi4OsBq6eEbpxG16lM5mm2KbRQG+0jlVGln0O9s3Qd9QCNaFV3Yq
         IFG+W/NkrbF5lu29htKXUlzFjuZL/sHp+DfzH7LpKDsNRj/oicsh7YKQp1b/dP4+fl3D
         bt4hW897RiJ8pfywz/imd3kWebNFFdzUxQjraFC4MAQrpXIz0MFx8bH/Uz7EeiSB2bXm
         BL695SdkQ/L/kXVlByzH/UGlYqdwfskl4E2YaN+nfXgh5fR5RFmxoPa1JTY5Qa/UHhHI
         lNV4E2p0TT8h6AhoCdEvRrgcnxBYeUH1t8X/ppGsrS2h7Z6DV2S4OX24rW1JAzQ3pqPS
         r8uw==
X-Forwarded-Encrypted: i=1; AHgh+Rpc1TlHCYrzVtkjgbdtg2NWHy4YWxKWGnk+eQAv/fMnBFHIP/czduRZHWW8DaXLuSyZAHV2SFA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzX2M90TdHdGmIhdWXCHXTCiehadInooml3sXk08NHvKVSgb0dI
	ZWvTiFDxnGa05dOLb4LZvpTnj2VicQwkkRpAkMLUkTiElPIqyt4ubnRAeJTfgiPmiIU+sKCTacE
	JxwKwgw==
X-Received: from pfnu15.prod.google.com ([2002:aa7:848f:0:b0:847:8962:8101])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a909:b0:84e:1815:f999
 with SMTP id d2e1a72fcca58-84ee4998f39mr357940b3a.64.1785517585158; Fri, 31
 Jul 2026 10:06:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 10:06:09 -0700
In-Reply-To: <20260731170619.2620845-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731170619.2620845-3-seanjc@google.com>
Subject: [PATCH v2 02/12] KVM: selftests: Set threads CPU affinity before
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

