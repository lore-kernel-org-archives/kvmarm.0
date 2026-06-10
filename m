Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E7A30677D
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052846; cv=none; b=D1CGvti1P7JMOxDgBMftkNouaNPhXGnoo44c3tFvKS8bk+2QcUWJalAK62aTjVIABVnMblZ6ww9ADmos8SflwwoPc5frC1Hc9M0GyjcfIPPbXHMytwYRbpHRy+o/+C4+bkXUEO7soNawt3n5BaE/54K3aVU1joPhe1dAQGV46/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052846; c=relaxed/simple;
	bh=qRiHP93HzItwv9bapY68Uc63LTzVWdeDkf8XAm1kmZ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OZM0tLmGXx3bouOn7pzIt/QftyjTCMyRjV7F31/Wkykh1g2k1WNIiKlZAaAvkuT1K3ItLIbFuV2cV2ixq1Scn9cKexM1TaaEBMI1K4RzsYgiqCqQUy2NCVH1e71VMXHOw6HH7iZd55NgNSOHjVbajqyexS+gjx9QpNTHigjF3+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NlmR/0vO; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NlmR/0vO"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c0c32f4b1bso63411985ad.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052844; x=1781657644; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uzhOX8od6JHJiC3xs1cQBCBTU98nABZKFOR7TwpKopY=;
        b=NlmR/0vOcq7j/MzSXOr9ldkSPZpYD4nN34LoFudpUNb1IfeILA3WeExQQM4PysYAyw
         MCcC659CugMOXuLMRjhB6YmQD+ZLU+kvj6TwUlPr6TAaoj7Ow4p3caZOm5ODljkIw00a
         xBbwlzfCmEMq0AD4Sj0cbtL/+d+5wqMBSK0x3hw0qP4NBfVzI4Fw0ztPTAHnTwqt42np
         0t0Wnd1PxPnXUtz3QOaB58nUxGMvsRPEAYjf3RebkpaxbmKKej71OypLp4pyAGrc2bT9
         PBLX/Ulbhsq484bnaK2Y3YxDAEz0Qpi89V/vvh6dOGcQ/6DzGtkYUyX8qJbMz2M1v6Gb
         cAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052844; x=1781657644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uzhOX8od6JHJiC3xs1cQBCBTU98nABZKFOR7TwpKopY=;
        b=il1WyDbr2X8tFcO7E6WoZ1jpOwMj2Yss0hrRs9h3Hm+02jkiOSsSpesJ5zVDKSGBGV
         vFK92pVG5sQhLCnyBvrIBuzeCiKMl2b5dTb82uwSMheuBkK1w/nLu5l4Vz5KlvTDjR9P
         kNYGtBvkXV8N90WzZMq9MByT1mUUw/ajrMcYwSvNPPHpFsJeAsT3fy6yLTQW8xD51/Tl
         qRfUk2cqa5I5eILUrlJ5fKDA0Oc39E9NOFc3P+VtXrpctXqRQyCzGr1ZF26aEr7n3/2Y
         1nXLIh5hJDZGsOrM/U3QUDvf3u5eOnFqJMcYaL/07Y1B5wfCbBWCH+P9onjXuTiVxPgZ
         nHMg==
X-Forwarded-Encrypted: i=1; AFNElJ/PHosn4mzkXoO4shhRUZ8mw+XtkeVe9tWflOZXIaYROihDpexgSM4HNbY3GY2+HZidRHdw/CM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwH3JhzSXmCckuASO6XPgiYxlSaGzN6ZewCNiQF2iWzDHyeyYyU
	rPFdHlB5RhrZzN+p9dHOw/PGcpx9/bFaKDMRZr4TlBnlMr1QB1MX4NxsuTVvQtRgzCUFec52ISy
	vZX/r9g==
X-Received: from pfbha13.prod.google.com ([2002:a05:6a00:850d:b0:83f:24a9:a829])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b04:b0:36a:5d1f:7b6
 with SMTP id 98e67ed59e1d1-370ee5444e7mr23400292a91.2.1781052843860; Tue, 09
 Jun 2026 17:54:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:36 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-17-seanjc@google.com>
Subject: [PATCH v6 16/18] KVM: selftests: Verify vCPU migration during IRQ
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
index 3fed76c553dd..aeede7937147 100644
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
@@ -244,6 +250,9 @@ int main(int argc, char **argv)
 
 	kvm_assign_irqfd(vm, gsi, eventfd);
 
+	if (migrate_vcpus)
+		kvm_sched_getaffinity(0, sizeof(available_cpus), &available_cpus);
+
 	for (i = 0; i < nr_vcpus; i++)
 		pthread_create(&vcpu_threads[i], NULL, vcpu_thread_main, vcpus[i]);
 
@@ -270,6 +279,9 @@ int main(int argc, char **argv)
 			proc_irq_set_smp_affinity(irq, irq_cpu);
 		}
 
+		if (migrate_vcpus)
+			pin_task_to_random_cpu(vcpu_threads[i % nr_vcpus], &available_cpus);
+
 		for (j = 0; j < nr_vcpus; j++) {
 			TEST_ASSERT(!GUEST_RECEIVED_IRQ(vcpus[j]),
 				    "IRQ flag for vCPU %d not clear prior to test",
-- 
2.54.0.1099.g489fc7bff1-goog

