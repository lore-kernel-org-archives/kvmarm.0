Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502C9275B15
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052835; cv=none; b=isI2cbvEO5enIKgUTF6D2O0z3xEvJQmgaqszt/0MJO9hGXlEWET2nzg7NSjzGN7VzAqMclrEQx4za5kMAH4qdpvRI2kgnONFZ0IyZ0NCxPdQeqX+hoVMItBRL1kyjO66iRkOP2w5K5qkoZdfSeJXlDaGpQT5FbTlZu/292x7N9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052835; c=relaxed/simple;
	bh=6p/UxwFyy00BUUg7ywfzwLzVHqQE+WuT3TdE7X/nD00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VcPy1hWGZ5Jd/mXRnenwKc01y7FklmGkrYysGZmpO+zMUqRovZSXRMAn4Ekq8lfV6gjJPMHxzBMwRinnVtl6iqCwCCyJGST3i5ov/B9oYBsZ3T2x9iQRgjWeYpsOLgaDLHugG5Q9v6TMmw7kmUpENQTNvtqegEw0tZzb7j/Xr68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GrF2mNEv; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GrF2mNEv"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2bf08c2a24bso58890405ad.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052833; x=1781657633; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wSOZjviZd40BWOUFk+/WMboICZddvNeGN5s5yOjzJRQ=;
        b=GrF2mNEv5eMkZeUKFK7ArbbKOFSQsQ2EE33ZSPSRboj5JqCBF23bwi59KotcZQ/0Jv
         rpuleg6rVogHDS/fL7em2SRkRUGgOJ1m2jYJx/or23qtqoRahOGMRWuuH0/uBwFBJRjV
         fd+N1yX3PvlX6JOxZz57qw+ueNStHjC34nR/7GFHTwYFhel/EPDf+Eqt0TzBDkjPMPbj
         mnxnq17bl6oiP/HNm0ZiPyAEzzi4o7FyEb6SBu3teMTU2slc6PjAP2SyjY6/EFwPe8e3
         7hGCc9bwl7dtqQl4SLPCteCL988OfEqOVFy8byKpOHd1ZD/6UAYPinfc6CibCxK/Sr6E
         mQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052833; x=1781657633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wSOZjviZd40BWOUFk+/WMboICZddvNeGN5s5yOjzJRQ=;
        b=gPaoYFiZOahVjiZLvSngdhNYCFtvqQ5t3Dc6RB9R7uh8Jadl6Yg+3A70SVX10MAaei
         mGlqUhtw4YRf/z6hC+09XeBqauBqo9MKmE5dhrJSjCNjWcsg3Ry05v2Jb/x5x5Hu5w63
         AvSY9aL28aLNVGSjHUqSPEglv5tNiBd2oTPV5AxAyGtimzYY2o72z5EJPSU6BI8CwbAx
         9qGsnXx0TXkoVFmU48GRqP6m/INqqxr/EaZ5+DdVrp8vMWSl5zk9ezrbzqn1VFc1TZd5
         Xqh7bMyFh5U+zaKljxcxr2axL1ElrnccrywhLXUhyWAx9comu9cZMd5mU0LnpAQf1PXK
         SSYQ==
X-Forwarded-Encrypted: i=1; AFNElJ+pF2uXWsg/lrJuWGwLqWu09xP2JUhItMDLfyR3AaNOxm8Uv1Ycrq3V62jo9Tt+t1pNZeHbHik=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPRcz3yMHTzEv0EMytLVIQIwgDhlsB1gvHhAR09CVLz6AYS8Lf
	Ozgdog9Gi159P/2qKtpzeCeYJGMDqyzii38jpMWGjrdKqkiTbcRg33q7SMr8JwLKURmNUGaZWTB
	evn7FyA==
X-Received: from plbkt16.prod.google.com ([2002:a17:903:890:b0:2bf:2609:e7bc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2381:b0:2c2:27be:39a7
 with SMTP id d9443c01a7336-2c2a1c9ac2emr62573145ad.29.1781052833323; Tue, 09
 Jun 2026 17:53:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:29 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-10-seanjc@google.com>
Subject: [PATCH v6 09/18] KVM: selftests: Verify interrupts are received when
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
 tools/testing/selftests/kvm/irq_test.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
index 6888be54ee4a..9e2287490262 100644
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
@@ -192,7 +198,12 @@ int main(int argc, char **argv)
 		printf("Using device %s MSI-X[%d] (IRQ-%u)\n", device_bdf, msix,
 		       irq);
 	} else {
+		TEST_ASSERT(!irq_affinity,
+			    "Setting IRQ affinity (-a) requires a backing device (-d)");
+
 		eventfd = kvm_new_eventfd();
+		irq = -1;
+		irq_cpu = -1;
 	}
 
 	pr_info("Injecting interrupts for GSI %d (guest vector 0x%x) %d times\n",
@@ -216,6 +227,11 @@ int main(int argc, char **argv)
 
 		kvm_route_msi(vm, gsi, vcpu, vector);
 
+		if (irq_affinity) {
+			irq_cpu = kvm_random_u64(&kvm_rng) % get_nprocs();
+			proc_irq_set_smp_affinity(irq, irq_cpu);
+		}
+
 		for (j = 0; j < nr_vcpus; j++)
 			TEST_ASSERT(!GUEST_RECEIVED_IRQ(vcpus[j]),
 				    "IRQ flag for vCPU %d not clear prior to test",
@@ -229,8 +245,8 @@ int main(int argc, char **argv)
 			cpu_relax();
 
 		TEST_ASSERT(GUEST_RECEIVED_IRQ(vcpu),
-			    "vCPU %d timed out waiting for IRQ (vector 0x%x) from GSI %d\n",
-			    vcpu->id, vector, gsi);
+			    "vCPU %d timed out waiting for IRQ (vector 0x%x) from GSI %d (via CPU %d)\n",
+			    vcpu->id, vector, gsi, irq_cpu);
 
 		WRITE_AND_SYNC_TO_GUEST(vm, guest_received_irq[vcpu->id], false);
 	}
-- 
2.54.0.1099.g489fc7bff1-goog

