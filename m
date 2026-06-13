Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3507C219301
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310065; cv=none; b=BXdVMQKsFZpodp6QWAsgEmaGo/pTbRP/B587MUyAI7E+uWQbt32xVy1oRqweeFDLObMAbbQYhwONQaKRWmrwEIYpxBI+Q8iVrToXDazYwjOqaelYLX3f6a6HVW7cTwOa8mulU8SrPrVwU+BEf7cDCQm/ZOUVzVcCouwOJgoUtIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310065; c=relaxed/simple;
	bh=q9v86LbBy4ULsRhjcFAlynNfgbXy4k/LwajVhA+uSBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kP21Gt3Um/0YtmorSbS2Q9MT/4F9iCT/1xGSH0raWP+6jweEyGD+aTG46yEA6FWpyW+L5j8m/APHSjkHYrQEjaffT/EipiEAmcjI8CyPKNsVGk0Eit/bz6v0nezyEqEPktykP4eLtc0Bcd24/QLgNHQwh2WRRQNDOPnkWCVRRAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XPPzSWQE; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XPPzSWQE"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-84240b58211so1100167b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310059; x=1781914859; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iRnVKRSeVHE8C4mveHZ7BQt7/PAYY6Y/vufRbYFKpcE=;
        b=XPPzSWQEiGNxOVosDPdU7dXlREMWDiXhmfRTumnuT0isDlps5VtkIqYkf8X3Zbj8wb
         f7OCTsclE0EC2FN8znL6EyG7dqdK8fe2cCA7VTPPHkQwO7htjpbDxfSTLrdjul103xgE
         Rtl7r97v+XCZ/RRwl4thCTZFQ0ZaAsyM7N/zkeK7GbARqmm58k2+Y7CSuuGA/HeuCwWs
         chi+JN9rWiQBBh1A6KTGm3VA+hJ+VapOoyWILR3rszZ9rawPE6p7dRqNGWEeprHp951x
         UhfpIsS7F0p4Q+bWdFH5/gh/k8eziTxSY3btpLukUQPFeCvIxcQLTDeRipuBLnlQArr9
         s6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310059; x=1781914859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iRnVKRSeVHE8C4mveHZ7BQt7/PAYY6Y/vufRbYFKpcE=;
        b=MmS3guq7Djy7iLHUJuhOvL1ix1BpbwmA4TwWwXWGhBo8IYj0b+xblgFtUV650/SvRA
         x83+yrms00KFVD6eCihBRw3Hk1250NPKgZyJaE8o/WhSEmoDJzHM5FQgYM64nCSQ9W+B
         4QdR16WfbtGqmhcy8fKFXdRbC/gOB5DcQVoF1nikbBbrED9bZIen0idFo2D/6KaSAGAL
         KEN5coKUrSS5l+d7n/AKgHt6lCKot7jMB3JSX87kQToxFVORc/7NyyEiXwtQhHccenOO
         t+MMX3M2HDGFI2hzFc9ihoQ2cZvu1a2DZDVy8o8WSm9+eLyKGv7C2RCoo9zE1rBeyKkY
         TyNw==
X-Forwarded-Encrypted: i=1; AFNElJ/3/88205F31euu6Dj3wEIghW1wiiCB4nc0ug1HI3sE6q32ieTitndaDQGOZ79YIpPEi19fbkY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAlbSRQ+ZwUdVT9/DrP8QjxJ2EjKfgetWR6vSNsYw7spqRoCcu
	Raw3Lj/JzpKZf/kILHItwv4kDvrKYjCwLQ3ueM7cmBkhrP4q39C+TOmqj8WmKuihPS+NaC50z6Z
	8+O88mw==
X-Received: from pfms4.prod.google.com ([2002:aa7:8284:0:b0:842:6fe1:8620])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1483:b0:842:4612:55f4
 with SMTP id d2e1a72fcca58-8434ce824d3mr5497594b3a.31.1781310059290; Fri, 12
 Jun 2026 17:20:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:30 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-20-seanjc@google.com>
Subject: [PATCH v7 19/20] KVM: selftests: Make number of vCPUs configurable in
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
index 5049cb69cd95..dfdb9f8e398c 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -112,7 +112,8 @@ static void kvm_route_msi(struct kvm_vm *vm, u32 gsi, struct kvm_vcpu *vcpu,
 		.entry = {
 			.gsi = gsi,
 			.type = KVM_IRQ_ROUTING_MSI,
-			.u.msi.address_lo = 0xFEE00000 | (vcpu->id << 12),
+			.u.msi.address_lo = 0xFEE00000 | (vcpu->id & GENMASK(7, 0)) << 12,
+			.u.msi.address_hi = vcpu->id & GENMASK(31, 8),
 			.u.msi.data = use_nmi ? NMI_VECTOR | (4 << 8) : vector,
 		},
 	};
@@ -145,7 +146,7 @@ static const char *probe_iommu_type(void)
 
 static void help(const char *name)
 {
-	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-i nr_irqs] [-m] [-n] [-t iommu_type]\n", name);
+	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-i nr_irqs] [-m] [-n] [-t iommu_type] [-v nr_vcpus]\n", name);
 	printf("\n");
 	printf("Tests KVM interrupt routing and delivery via irqfd.\n");
 	printf("-a	Affine the device's host IRQ to a random physical CPU\n");
@@ -155,6 +156,7 @@ static void help(const char *name)
 	printf("-m	Pin target vCPU to random physical CPU before triggering interrupt\n");
 	printf("-n	Deliver 50 percent of IRQs as non-maskable interrupts\n");
 	printf("-t	Override the IOMMU type to use (vfio_type1_iommu or iommufd)\n");
+	printf("-v	Number of vCPUS to run\n");
 	printf("\n");
 	exit(KSFT_FAIL);
 }
@@ -191,7 +193,7 @@ int main(int argc, char **argv)
 	struct kvm_vm *vm;
 	int irq, irq_cpu;
 
-	while ((c = getopt(argc, argv, "ad:ehi:mnt:")) != -1) {
+	while ((c = getopt(argc, argv, "ad:ehi:mnt:v:")) != -1) {
 		switch (c) {
 		case 'a':
 			irq_affinity = true;
@@ -214,6 +216,11 @@ int main(int argc, char **argv)
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
@@ -223,6 +230,9 @@ int main(int argc, char **argv)
 	TEST_REQUIRE(kvm_arch_has_default_irqchip());
 
 	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	vm_enable_cap(vm, KVM_CAP_X2APIC_API, KVM_X2APIC_API_USE_32BIT_IDS |
+					      KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK);
+
 	vm_install_exception_handler(vm, vector, guest_irq_handler);
 	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
 
-- 
2.54.0.1136.gdb2ca164c4-goog

