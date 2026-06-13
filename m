Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1034D2C11DF
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310052; cv=none; b=VtfShTP9V3DvgeStQcb2p6rrIeDwuqC4c3N9UbwCWE/VT6dnWNPnBk/3HiKDo1KtNo6WoX0HUOsXsiRQa0NuET44rXh7aljAZBB7JauTV/sCgFe/fB9d/HC8JLhdfaPsUT2kVcCq7EiBwfAseX17jbR0Whiw7+IO0I/eDyguUHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310052; c=relaxed/simple;
	bh=pRjDYVgvzAMSMcyC4gsaWq6nGi+ggwtK6qIS2vByNj4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CI5WRXF4OmbciYX191lzH3PXOeUKnDfSy29ADn6GMHmBBg+TW7oWM98YB0ilPU97cmCys5lwxlnUCV9K7Kot/FTBjXdF4ryT/zwL/OXDWr9vykBklURsThdmy4vc4BN7JDTsmnQMeeygiSg9N/9v/L9xyEix7+8IIR7fQZO9+9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=POP5zg5E; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="POP5zg5E"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-36d985df4cfso1804526a91.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310049; x=1781914849; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xZ0eZe4fkiDCH3zVpYK4NQsEFBnaL8FaPs5jLK/npco=;
        b=POP5zg5EBNWuIoHJ3xpMH3AERdzwlK006WhYtJjtI9SF29knRaLAyNa3Zxc8qeMwTV
         9QfEO6Bu0vp88/uu4cNm/cTpFrynYhA8UmMQnaiZ658sukDbAytCdZfDPjmOzlptlrhP
         QfRxKiHjNiZbAzLWcSSxzpzdSpvF99K2wV3GmaaIZ8DLSrzS5Kkbr+wFSKCbQc9i9e4i
         ahEtwUtm1mi2J7P8Df0WdRd0eVSC+kSmTPHBPKQdMiYMSmbC4Lnvdo9TkZezz7hRLELm
         mSg+CNf0Vx7Rsk+k2ATJ7La0G0FbyinpNxW9wbC0eGYJGNEtKLikWjLjd1K2YH2mP0dz
         ADQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310049; x=1781914849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZ0eZe4fkiDCH3zVpYK4NQsEFBnaL8FaPs5jLK/npco=;
        b=hw8jnFpXZH6hsjd4xW4x1DA04GCibfejQE6KYVXsw727bFscDN8SlqnvOQ3ZgwhDEg
         kz1wRrCOOgLmYbnoKtoGLeRaKCoDvHBapKirSW/AWsn3VDCEvJG1Afsh60D9/Gy7SsKb
         nEbXriyGEwnNJ68vpJ6TDHohfr2AumHmAj4YiXMrlqtwAXX/weLeFv1CdrBrG3FyJMmA
         N1zSRpP286WJUgtf/+oMObiZUnX9mFdr52W4PrgrFGDj+N5M63odipux2L0CZgRWXPq2
         eqwyxa3w61vrPP9FIcfArZqI6FMSBFC7DobTpDS/EF6CP/gyaVyaQeNlb0XyVUeBeiZQ
         LwJg==
X-Forwarded-Encrypted: i=1; AFNElJ+A9Fxfh6k7GFWhHg1y9Zm3cMSdqJ/EGuoviz7NPBiv/k2CHPlfqfgEStnBIZ2Ei8/4Zf/dhPU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzO9YtyEpUoBUzdu60N2SNcAyKQuTZ9P33h2v0TuqEyiqtnejfn
	5aApfSmMOAh8Ye2agbDR/LHwahWLXgK8nHYUGz2DLU4YopLgy4e68jvyTLQFLYUsJVNnVCmxPtG
	e9aNdmQ==
X-Received: from pjty19.prod.google.com ([2002:a17:90a:ca93:b0:369:bec6:fd63])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c8e:b0:368:ac5f:d31b
 with SMTP id 98e67ed59e1d1-37a040b3ec6mr5340250a91.24.1781310049202; Fri, 12
 Jun 2026 17:20:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:22 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-12-seanjc@google.com>
Subject: [PATCH v7 11/20] KVM: selftests: Verify interrupts are received when
 IRQ affinity changes in IRQ test
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

Extent the eventfd IRQ test with a '-a' flag to randomly affinitize the
device's host IRQ to different physical CPUs throughout the test.  This
stresses the kernel's ability to maintain correct interrupt routing and
delivery even as the underlying hardware IRQ affinity is changed
dynamically via /proc/<irq>/smp_affinity{,_list}.

Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/irq_test.c | 27 +++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
index 6888be54ee4a..c01aa313f719 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -12,10 +12,12 @@
 #include <unistd.h>
 #include <pthread.h>
 #include <sys/eventfd.h>
+#include <sys/sysinfo.h>
 
 static u64 timeout_ns = 2ULL * 1000 * 1000 * 1000;
 static bool guest_ready_for_irqs[KVM_MAX_VCPUS];
 static bool guest_received_irq[KVM_MAX_VCPUS];
+static bool irq_affinity;
 static bool done;
 
 #define GUEST_RECEIVED_IRQ(__vcpu)	\
@@ -125,9 +127,10 @@ static const char *probe_iommu_type(void)
 
 static void help(const char *name)
 {
-	printf("Usage: %s [-d <segment:bus:device.function>] [-h] [-t iommu_type]\n", name);
+	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-h] [-t iommu_type]\n", name);
 	printf("\n");
 	printf("Tests KVM interrupt routing and delivery via irqfd.\n");
+	printf("-a	Affine the device's host IRQ to a random physical CPU\n");
 	printf("-d	Use a VFIO device to send MSI-X interrupts instead of manually signaling the eventfd\n");
 	printf("-t	Override the IOMMU type to use (vfio_type1_iommu or iommufd)\n");
 	printf("\n");
@@ -160,10 +163,13 @@ int main(int argc, char **argv)
 	int i, j, c, msix, eventfd;
 	struct iommu *iommu;
 	struct kvm_vm *vm;
-	int irq;
+	int irq, irq_cpu;
 
-	while ((c = getopt(argc, argv, "d:ht:")) != -1) {
+	while ((c = getopt(argc, argv, "ad:ht:")) != -1) {
 		switch (c) {
+		case 'a':
+			irq_affinity = true;
+			break;
 		case 'd':
 			device_bdf = optarg;
 			break;
@@ -192,7 +198,11 @@ int main(int argc, char **argv)
 		printf("Using device %s MSI-X[%d] (IRQ-%u)\n", device_bdf, msix,
 		       irq);
 	} else {
+		TEST_ASSERT(!irq_affinity,
+			    "Setting IRQ affinity (-a) requires a backing device (-d)");
+
 		eventfd = kvm_new_eventfd();
+		irq = -1;
 	}
 
 	pr_info("Injecting interrupts for GSI %d (guest vector 0x%x) %d times\n",
@@ -210,12 +220,19 @@ int main(int argc, char **argv)
 			continue;
 	}
 
+	irq_cpu = -1;
+
 	for (i = 0; i < nr_irqs; i++) {
 		struct kvm_vcpu *vcpu = vcpus[i % nr_vcpus];
 		struct timespec start;
 
 		kvm_route_msi(vm, gsi, vcpu, vector);
 
+		if (irq_affinity) {
+			irq_cpu = kvm_random_u64(&kvm_rng) % get_nprocs();
+			proc_irq_set_smp_affinity(irq, irq_cpu);
+		}
+
 		for (j = 0; j < nr_vcpus; j++)
 			TEST_ASSERT(!GUEST_RECEIVED_IRQ(vcpus[j]),
 				    "IRQ flag for vCPU %d not clear prior to test",
@@ -229,8 +246,8 @@ int main(int argc, char **argv)
 			cpu_relax();
 
 		TEST_ASSERT(GUEST_RECEIVED_IRQ(vcpu),
-			    "vCPU %d timed out waiting for IRQ (vector 0x%x) from GSI %d\n",
-			    vcpu->id, vector, gsi);
+			    "vCPU %d timed out waiting for IRQ (vector 0x%x) from GSI %d (via CPU %d)\n",
+			    vcpu->id, vector, gsi, irq_cpu);
 
 		WRITE_AND_SYNC_TO_GUEST(vm, guest_received_irq[vcpu->id], false);
 	}
-- 
2.54.0.1136.gdb2ca164c4-goog

