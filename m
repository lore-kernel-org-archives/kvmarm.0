Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CD93C4167
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509763; cv=none; b=Q+6P8vGDw84297KI2mCwfyUYCBZ6H21nsHxhGaOrOEghxJdicf/4NY6QD8kbhYiBUuItzpfHuzPoCgfi1h14fTGMkpznn8GFhKi7l6ld9TNHR9E9r85c26b2nCb+13tYoGWxtkLn7gpHTxh89WGzwXiHxxPaSpcwEh7OmJJCI/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509763; c=relaxed/simple;
	bh=7417aI7o8+VY0zFgJhxw12Swg3ymzFrCld14qvLBip0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hqKBDS95sWD3s/zVuwT1wOWbXJoU7MOEaPFVKpJGE5KorBzc9bRiHxGgc4g5nBbKsjWVSdjkBnAmjhS8qGS7eaFYV5CxWcXt3Zbd8Tw+HNLchV0Nn1ZPSnjoix5cOTJvpa3Eu9LhF996BlaOvi9TLhXCu85wjfr88R3ecp3DE7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JQkGefYr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JQkGefYr"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-37c6916c768so1750540a91.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509758; x=1783114558; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=37AjqTPC3Cofz5c5D7lHCWd7gT64KCMX7KZ8N6F2Usg=;
        b=JQkGefYrWkobb84QO+icrmrE0q2CgV/RVtsWUHgGOcLO3H4oqLICsxMwBGq4f/EHU4
         x7SBHngrrZ74troS3F2wieUDVot3THwSSMRCXDdPINYLDfwejHc+FCT3FZCp0H0WgT7t
         aHSWjjg9v+sg6qHbnn0mbOK1IeKZ7UieS+Vb7jKldfin7ZAgpFifuEPiGoCYUxpR/6hy
         yzDN8r7ZVBOL/+d1ykc2zOcVmwjl1UkTPWdowHuX7VEbUi2NyJZTOE7hfg9XkSX+9Nmt
         seqJ+khKVyiSNS9kHdsL9W9/umtXa7vwas9gTZqdq2tD9kIjgfzVcB9wVc3/9zfg3NrA
         9/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509758; x=1783114558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=37AjqTPC3Cofz5c5D7lHCWd7gT64KCMX7KZ8N6F2Usg=;
        b=a/OQSmOSsXQE2gtyTm6CMsM0p1huwPY6XgmkTKSZbbhh56LfhCcEtWr+QFDRtdEYIV
         7Rz6uY8zO1GOYIyz33pmYCBcg/6UOqzku4j711Z9fphlHakcoTjPnOX9zw5MyebZdRyq
         Ke/SSF726mqJK9uqiRSSWGc3lgrK1jgw/xDLS/ND+jHNUP63du1/zQNhbgVfZ/qwgS8W
         tJYbIDx6e5YYznTpBJi0tJ1OxbEpC7+CrJj1SjHy4pIByz8Vdnn+ogsrtuWET0m6aNwX
         q+ET5uOoXmLkJRrHblBfIXnmwEjSB0tl5Xi4h0yCSn/Z5XxuFDIP4p2HeFudECFYOpF3
         W5JA==
X-Forwarded-Encrypted: i=1; AHgh+RqkiDMsejsSUL0C+QCQqsgSrSub7nbn560nLs37nzgY2X67PJOKc9whtEGiaZXcv4gLMokQWLs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbbcUsxv/UF5ElBmJcv3+0uIe1ulhO6j3TwaMwENI65qPxdD1P
	HReSXPeMOoDVpnysgDGZv+cuH4hpy+rj9AOODZy347ypEtKiUpKeYMrxEl7Y9gCVVn8VLEtKdNu
	djkfT+g==
X-Received: from pjyl13.prod.google.com ([2002:a17:90a:ec0d:b0:37d:f8a4:accb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cd0:b0:36b:9daf:1504
 with SMTP id 98e67ed59e1d1-37dfa250f22mr8077365a91.14.1782509758025; Fri, 26
 Jun 2026 14:35:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:31 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-19-seanjc@google.com>
Subject: [PATCH v8 18/20] KVM: selftests: Verify vCPU migration during IRQ
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
 tools/testing/selftests/kvm/irq_test.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
index 48520c6dea69..c0ff6e60b167 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -157,13 +157,14 @@ static const char *probe_iommu_type(void)
 
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
@@ -195,12 +196,14 @@ int main(int argc, char **argv)
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
@@ -214,6 +217,9 @@ int main(int argc, char **argv)
 		case 'i':
 			nr_irqs = atoi_positive("Number of IRQs", optarg);
 			break;
+		case 'm':
+			migrate_vcpus = true;
+			break;
 		case 'n':
 			use_nmi = true;
 			break;
@@ -248,7 +254,6 @@ int main(int argc, char **argv)
 
 		eventfd = kvm_new_eventfd();
 		irq = -1;
-		irq_cpu = -1;
 	}
 
 	pr_info("Injecting interrupts for GSI %d (guest vector 0x%x) %d times\n",
@@ -256,6 +261,9 @@ int main(int argc, char **argv)
 
 	kvm_assign_irqfd(vm, gsi, eventfd);
 
+	if (migrate_vcpus)
+		kvm_sched_getaffinity(0, sizeof(available_cpus), &available_cpus);
+
 	for (i = 0; i < nr_vcpus; i++)
 		pthread_create(&vcpu_threads[i], NULL, vcpu_thread_main, vcpus[i]);
 
@@ -266,6 +274,8 @@ int main(int argc, char **argv)
 			continue;
 	}
 
+	irq_cpu = -1;
+
 	for (i = 0; i < nr_irqs; i++) {
 		const bool do_set_empty_routing = set_empty_routing && (i & BIT(3));
 		const bool do_use_nmi = use_nmi && (i & BIT(2));
@@ -282,6 +292,9 @@ int main(int argc, char **argv)
 			proc_irq_set_smp_affinity(irq, irq_cpu);
 		}
 
+		if (migrate_vcpus)
+			pin_task_to_random_cpu(vcpu_threads[i % nr_vcpus], &available_cpus);
+
 		for (j = 0; j < nr_vcpus; j++) {
 			TEST_ASSERT(!GUEST_RECEIVED_IRQ(vcpus[j]),
 				    "IRQ flag for vCPU %d not clear prior to test",
-- 
2.55.0.rc0.799.gd6f94ed593-goog

