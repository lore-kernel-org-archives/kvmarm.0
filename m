Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E370B23BD02
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310066; cv=none; b=BMJpgTFZ5bmMCZ2ONI2OACnjrFzUvNALMY3ZNrn3dXq+O1lBXuewzx767llBtM/OF6GBs+PgpnUxKuHyjsv9F/y3NW2kCLQgub6Yo/JJhLGzVGoFz9NEuSRNctFi4AIAlnClNqGJV/51GoYWXHX4QXgYaJS2Xq67L1yB5RPTKO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310066; c=relaxed/simple;
	bh=i47PTXG9jX5B3AHEheaRbQ9TMioUl0YXGiCFFOMuEqY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Af1D65YUsMQugetL+BNgfzRqhV4ycTjQfOJ+WewpRHprCD+V+AtdKf2HmljW4CEyGFRWr37YDeesHLuXzC05+fzoByOI52dkMWBHm9fYIofKtT0Bin9iiCmpr5XkgKkzUT1WedWy+pUAsh1F5CmJ8XSx3oD+3CC07y9KFBvJgC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CBlBeQ2d; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CBlBeQ2d"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8611b27631so1455443a12.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310058; x=1781914858; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=szhm3cLvTGIMVFhVv0doCPKOe4ubDZorg2py5w134gs=;
        b=CBlBeQ2dqDpeTANro14FAiJUBV7rqoLewwWNwKu60b+C4m7Fk15BO9mScWfJ70/F6c
         LWZxfXdUpbsLqbfvjnXVpoNEXH9eTe98QFnmgfa2/F4LNFC0wGgAqoTCzechWpNCrtcb
         efB8yfK1LbtL2xtsJ1SacpziSDwO5JAh9+4t0Q3jlLXXdA0KRjMyFV2fugsXX5UQFsgj
         Nsvi9yIlNUX1Y4xpIQ2W4aq5EvWvT8Vn5EH1geKip4/jz7R37IWGg4vuNxOmmu4gaIXi
         39hV5MG6y7tjjWs3Qaro09KUwWloLan/H01xI6gD+C6SyzJG3z2ZP614VJsmCuHSm4r3
         nr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310058; x=1781914858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=szhm3cLvTGIMVFhVv0doCPKOe4ubDZorg2py5w134gs=;
        b=Hqu677DqxntyKn1U9P3/nxOE5saLQtrp/ESn6SZSZk0FPJx3a7jB58OEvbrKx4bmmq
         RhcDMXZSipWQuRKL5uTUhZ1yFqW1FmffAWPElZrGr2SC6VnawDRKxGcHMcQpjuHGsPDR
         E0adebrBlOn0kq8SiAwyu1fqpWHslS6i9eu7ui8b3y17B6a1810E/KWM7boBh5tFrOAP
         0sx61pBKF6lWHZZbdqFa7bh7pUGYt+UuUGPf0RzJH3dyRYyTqxkszUzn9alCmMY2U7wP
         eE03KwDU5/IfR9w9Fb5FcZLg12A/b0jwkHMfJpruEUveOLQN16MRW5QuHjkP0N271wTF
         S/Zw==
X-Forwarded-Encrypted: i=1; AFNElJ8pNwb/Bi5cuzz8N+6cWc3Q7GX9L2W+8rQGNGukPg4wknuN0+FOg0da1i+MZP8SnPkXiWR3U+0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuzLGupH6jDequ4k3kXrZSrqQshcJUjpXsNo3IkOMRU50SfmwP
	X3tARW5dezJBx37wNd0Isd5w9hUkjwSppUWnt2g8oWU9rC0qtbNQo6xqHcAS/8G1oD61oZaq2OC
	BCHzOvg==
X-Received: from pga4.prod.google.com ([2002:a05:6a02:4f84:b0:c7c:4b52:febd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e545:b0:3b4:b259:74e3
 with SMTP id adf61e73a8af0-3b78166f338mr4771279637.31.1781310058103; Fri, 12
 Jun 2026 17:20:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:29 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-19-seanjc@google.com>
Subject: [PATCH v7 18/20] KVM: selftests: Verify vCPU migration during IRQ
 delivery in IRQ test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Extend the eventfd IRQ test with a '-m' flag to have the test migrate the
target vCPU to a random physical CPU before triggering its interrupt, e.g.
to validate KVM's ability to update device posted IRQ routing.

Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: pin one vCPU at a time to simplify things, use main()'s affinity]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/irq_test.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
index d2d861119854..5049cb69cd95 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -145,13 +145,14 @@ static const char *probe_iommu_type(void)
 
 static void help(const char *name)
 {
-	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-i nr_irqs] [-n] [-t iommu_type]\n", name);
+	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-i nr_irqs] [-m] [-n] [-t iommu_type]\n", name);
 	printf("\n");
 	printf("Tests KVM interrupt routing and delivery via irqfd.\n");
 	printf("-a	Affine the device's host IRQ to a random physical CPU\n");
 	printf("-d	Use a VFIO device to send MSI-X interrupts instead of manually signaling the eventfd\n");
 	printf("-e	Set empty GSI routing in-between some interrupts\n");
 	printf("-i	The number of IRQs to generate during the test\n");
+	printf("-m	Pin target vCPU to random physical CPU before triggering interrupt\n");
 	printf("-n	Deliver 50 percent of IRQs as non-maskable interrupts\n");
 	printf("-t	Override the IOMMU type to use (vfio_type1_iommu or iommufd)\n");
 	printf("\n");
@@ -183,12 +184,14 @@ int main(int argc, char **argv)
 	const char *device_bdf = NULL;
 	const char *iommu_type = NULL;
 	int i, j, c, msix, eventfd;
+	bool migrate_vcpus = false;
+	cpu_set_t available_cpus;
 	bool use_nmi = false;
 	struct iommu *iommu;
 	struct kvm_vm *vm;
 	int irq, irq_cpu;
 
-	while ((c = getopt(argc, argv, "ad:ehi:nt:")) != -1) {
+	while ((c = getopt(argc, argv, "ad:ehi:mnt:")) != -1) {
 		switch (c) {
 		case 'a':
 			irq_affinity = true;
@@ -202,6 +205,9 @@ int main(int argc, char **argv)
 		case 'i':
 			nr_irqs = atoi_positive("Number of IRQs", optarg);
 			break;
+		case 'm':
+			migrate_vcpus = true;
+			break;
 		case 'n':
 			use_nmi = true;
 			break;
@@ -243,6 +249,9 @@ int main(int argc, char **argv)
 
 	kvm_assign_irqfd(vm, gsi, eventfd);
 
+	if (migrate_vcpus)
+		kvm_sched_getaffinity(0, sizeof(available_cpus), &available_cpus);
+
 	for (i = 0; i < nr_vcpus; i++)
 		pthread_create(&vcpu_threads[i], NULL, vcpu_thread_main, vcpus[i]);
 
@@ -271,6 +280,9 @@ int main(int argc, char **argv)
 			proc_irq_set_smp_affinity(irq, irq_cpu);
 		}
 
+		if (migrate_vcpus)
+			pin_task_to_random_cpu(vcpu_threads[i % nr_vcpus], &available_cpus);
+
 		for (j = 0; j < nr_vcpus; j++) {
 			TEST_ASSERT(!GUEST_RECEIVED_IRQ(vcpus[j]),
 				    "IRQ flag for vCPU %d not clear prior to test",
-- 
2.54.0.1136.gdb2ca164c4-goog

