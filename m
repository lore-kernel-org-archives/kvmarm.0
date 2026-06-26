Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB743CF963
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509763; cv=none; b=gOUr0DwRfI3PFoFXgXeFIXDsgAFGdUFS5bayRjn8hiB7+pqwgRZzsy38dTaUknQaRXmstWEALK4fKFl6x/ImTnvo/PxpNbe+Cg+CTjGMTgM1b9IJXV8Wt+9ypc181gYnCylZyj62jytWntIlj+RiQznrhwCghKjN+a/ZD6jGlOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509763; c=relaxed/simple;
	bh=lPLty6nGrS4VH1t2tuC4QXIh85FGwa4BJF1hWv7uCr0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OO6hzcoblVPIeJ066gItP2pLPr+FyL1xMZhOOX2WRsBQNqIkZh7mcdeU0LOxvAcxXzEP/cdFD0IlBrrrMfaUdsuC21BE9MdqkSJOjtIrz1mAXKQRkiI2O9TLby6oYy8urkmm3WLJP/UV2E4HhYTdJVYNaQvAf1sJYnlGwrnI6Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IVwWF+g8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IVwWF+g8"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c79e5de32cso11232815ad.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509759; x=1783114559; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4C+wq0VK0ghddVns1kN4nyVNDsu3kjVzVymKqfTzcVg=;
        b=IVwWF+g8bOtCkb57sxOPpalG8J+bZeXwg+SEZc6FfAlq0gtyjGNYDvyP5Yz00KSWKT
         cwxpfSEFMZsfU16QNAPBfV0MLj/5OukDKarYdTmyVT+my+8UBerSRolN+lwOuA/oVfiV
         jk/zSxvwuV0n+08L6Sxteh3gun6o1lPC6vC5ntpLyyhaasbNlYEAIKvcht7VhtY0/Tp3
         WQWR7qH3YEn6x+oyfv28Jj82jQkJaoPzzUpuNpw0Fs/0A34Jy4Pf8K4x94nm0yBby53+
         EoC7qSDAx9uF+y2wu//PrLeLp1D+wRB1xBVEfLtAIYJorE8PlaBsJG7qUvORW/UNLIwu
         4Hgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509759; x=1783114559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4C+wq0VK0ghddVns1kN4nyVNDsu3kjVzVymKqfTzcVg=;
        b=n4FVWLoN2FOGeCXG4okB8CNQBWb1gwW8nucq2tl+ycw//BxNzTHcaxeFGqXHaizH1e
         XyNAntb2wnyE4SvflFcIqS5TqTdzi7zGx1YVO/g6gNQPXwGzZE8Nywi4EdgsWZD3kEQT
         EhQgbgMmOK9qmB1Yd0SGlZHC3Q4bkKlhxHvbbFPl0oARlbWyfiCKooDTIWKu/nhLPP0+
         yk4TRuKCPimlJ0TAWWl3jDo6wWwDuGgLAW1WINkrNW4vWaJnvg0FbFMyzwfIbKwGp7x7
         eJLjHR8TJoqIfW15q5q8RvWmsCYCfkcusCU7DdLzUrRnaYZugKt2HpHb6TGUuhtX/c4M
         jbOA==
X-Forwarded-Encrypted: i=1; AFNElJ9qEqgUZw1iRscpWRBkk2+2tolXCKrj9dwdZeXYsdPOImsnIbwrUeY5M0zpteyTMTcfbQrsJZw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/80gvX5oGq1xU/JG/1QjvksKADN9jkcKDcOXxpfNQezSSclHJ
	IJXcViOMUKbqyEytfplVYgTWRLQaNsP/VGsm+VxEk56lGl6DG1yHchBQXmV7WnQLMwmJ4xadnXh
	PwXocLA==
X-Received: from pgdr9.prod.google.com ([2002:a63:9b09:0:b0:c86:1628:53b3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d81b:b0:3bf:6c08:2b30
 with SMTP id adf61e73a8af0-3bf6c084b2fmr1584091637.56.1782509759266; Fri, 26
 Jun 2026 14:35:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:32 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-20-seanjc@google.com>
Subject: [PATCH v8 19/20] KVM: selftests: Make number of vCPUs configurable in
 IRQ test
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

Extend the eventfd IRQ test with a '-v' flag to allow the user to
configure the number of vCPUs to create and run (versus only ever using a
single vCPU).

Update the routing logic to play nice with 32 bit IDs, enable x2APIC format
in KVM (to enable 32-bit ID routing), and disable KVM's x2APIC broadcast
quirk so that targeting vCPU 255 doesn't blast the interrupt to all vCPUs
when in x2APIC mode.

Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/irq_test.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
index c0ff6e60b167..d2c745c54960 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -124,7 +124,8 @@ static void kvm_route_msi(struct kvm_vm *vm, u32 gsi, struct kvm_vcpu *vcpu,
 		.entry = {
 			.gsi = gsi,
 			.type = KVM_IRQ_ROUTING_MSI,
-			.u.msi.address_lo = 0xFEE00000 | (vcpu->id << 12),
+			.u.msi.address_lo = 0xFEE00000 | (vcpu->id & GENMASK(7, 0)) << 12,
+			.u.msi.address_hi = vcpu->id & GENMASK(31, 8),
 			.u.msi.data = use_nmi ? NMI_VECTOR | (4 << 8) : vector,
 		},
 	};
@@ -157,7 +158,7 @@ static const char *probe_iommu_type(void)
 
 static void help(const char *name)
 {
-	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-i nr_irqs] [-m] [-n] [-t iommu_type]\n", name);
+	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-i nr_irqs] [-m] [-n] [-t iommu_type] [-v nr_vcpus]\n", name);
 	printf("\n");
 	printf("Tests KVM interrupt routing and delivery via irqfd.\n");
 	printf("-a	Affine the device's host IRQ to a random physical CPU\n");
@@ -167,6 +168,7 @@ static void help(const char *name)
 	printf("-m	Pin target vCPU to random physical CPU before triggering interrupt\n");
 	printf("-n	Deliver 50 percent of IRQs as non-maskable interrupts\n");
 	printf("-t	Override the IOMMU type to use (vfio_type1_iommu or iommufd)\n");
+	printf("-v	Number of vCPUS to run\n");
 	printf("\n");
 	exit(KSFT_FAIL);
 }
@@ -203,7 +205,7 @@ int main(int argc, char **argv)
 	struct kvm_vm *vm;
 	int irq, irq_cpu;
 
-	while ((c = getopt(argc, argv, "ad:ehi:mnt:")) != -1) {
+	while ((c = getopt(argc, argv, "ad:ehi:mnt:v:")) != -1) {
 		switch (c) {
 		case 'a':
 			irq_affinity = true;
@@ -226,6 +228,11 @@ int main(int argc, char **argv)
 		case 't':
 			iommu_type = optarg;
 			break;
+		case 'v':
+			nr_vcpus = atoi_positive("Number of vCPUS", optarg);
+			TEST_ASSERT(nr_vcpus <= KVM_MAX_VCPUS,
+				    "KVM selftests support at most %u vCPUs", KVM_MAX_VCPUS);
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -235,6 +242,9 @@ int main(int argc, char **argv)
 	TEST_REQUIRE(kvm_arch_has_default_irqchip());
 
 	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	vm_enable_cap(vm, KVM_CAP_X2APIC_API, KVM_X2APIC_API_USE_32BIT_IDS |
+					      KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK);
+
 	vm_install_exception_handler(vm, vector, guest_irq_handler);
 	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
 
-- 
2.55.0.rc0.799.gd6f94ed593-goog

