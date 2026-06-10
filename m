Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B70C29AAEA
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052837; cv=none; b=q2CNuMBvmp85oekfecHiAtXT2g6uDLCEbip+Fy2R5IE4mcK8rDoxCkbSo6QRDVTzYFJ/spys+lGNuhTmg79IXlNE1PwvUj6Mu0KfXce+9AXR9mVULAoCLv5QsEwKuaeKoCy7UGSmweenn6OvJ3og34xsFDPxlbJmHzlvWYZFkps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052837; c=relaxed/simple;
	bh=H9ocbRXmqpUzNRZEYOywUK7YbIGe6F+ezqNJxIrfZQA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aknz6+IjgTS+aD7WqARx5cHcKi+wz3EqEF2qTpABQOOmGYVFlsu8M5aNt7zsB+EjIfLSy3YTQYrU/yanGGPcS/LfVnh38pfNUTHAt3EyzMhz82wB3oS4vEJFB3CMOFi52VWdrzOpFUFu0MMuUsq3GEh2t89DzxtTlpJZe01DZy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fr0yeO78; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fr0yeO78"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-36d97955899so5805495a91.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052834; x=1781657634; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FxxrfMGS0zaiu+w3muh1AaxqaJx6GaJWf2ySi/7JstM=;
        b=fr0yeO78LHPSTayE6LjR+628SOeUiKKrHFmxtxD2kZ0Mu3F9moYSs9crQdzfIc1ya0
         gE4UOueEuZS3AaoBmxD69swrDCCjhHitIxb/utLkCDwiLofcCD/lDUsvuRnBX3y5sZyn
         sn0kI7Gt1Gadufhwtx6hHsRik1aHc9gSQ1wa30XxLBfKnv0mdRsu3bl+Z3THY4Iyvamz
         iI7zFCULRmXdiwlFmIEuO10f0dRlMrQuhovVNyz9+aeTuVyLHgbyHjC3YSoDoA/8P5DN
         QGYZiAS8UeCXpgR9Mlr/rJ/NjZ27bRyZ7BH+HH/Hpj1tXHWM3oio+Kccg/3paG0K7vly
         ps+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052834; x=1781657634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FxxrfMGS0zaiu+w3muh1AaxqaJx6GaJWf2ySi/7JstM=;
        b=XkzVjYYGmHx4gb5znkEM8ekc2d+wd6gV6YJ+dwsUZmRLKcXarI4M1ewXwsHrGLX4H9
         dotOglQBl5/MHCDUAUiKqCV+m8TWjyFVBFbpUOQFvvN3gpi0U5/nChM+ciB0JtOL5pIA
         SGINeWLcd0FNy9lpZSG9vd9yOjxGCINyqLMpzYEYhD4NFOy7/pXOf0hYcnGOMNcx3vtN
         wQBr3GRCgWzvmWO16NacYdZI6PTEM+X6+gByFN41QNwmiY2iMTL4sGE1YI+LGQtJ38r4
         y0ljJWgjXFQZ5fluefDdCTImMXU9Z7zNVFjYRkbj+olOS1FHgwx3OaychEhgtKOOIYF5
         5hiQ==
X-Forwarded-Encrypted: i=1; AFNElJ80InIfCmHGU/ahl7FDmRUudFV+Zc1/vTouUA/F/++6Qg9SlIbPNR9CyITrGIEYQ4EGGj5v/OM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+aIarT1+rkgaxqVPiYZskEjtx31vwX27eFOHa9n4Oqgrt0gS2
	R/hnG3cP9/YHxPv11vxII8wGmpXwDSqBBY2onCZd4NaGfIs8kTfzmC73PpcyPfeZK/FPH/JnmLn
	sj1v6+Q==
X-Received: from pjbfv16.prod.google.com ([2002:a17:90b:e90:b0:36b:7407:9b72])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:50cf:b0:35e:d015:d675
 with SMTP id 98e67ed59e1d1-3751f843387mr6325275a91.7.1781052834478; Tue, 09
 Jun 2026 17:53:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:30 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-11-seanjc@google.com>
Subject: [PATCH v6 10/18] KVM: selftests: Add option to set empty routing
 between IRQs in eventfd IRQ test
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

Extend the eventfd IRQ test with an '-e' flag to set empty GSI routing
between interrupts.  Clobbering the GSI routing table verifies that KVM
correctly handles CPUx => NULL => CPUy transitions, not just CPUx => CPUy
transitions, and verifies that KVM can "rebuild" an entire routing setup.

Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: '-e' for "empty" instead of '-c' for "clear", massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/irq_test.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
index 9e2287490262..2ad9efd9abc7 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -109,6 +109,13 @@ static void kvm_route_msi(struct kvm_vm *vm, u32 gsi, struct kvm_vcpu *vcpu,
 	vm_ioctl(vm, KVM_SET_GSI_ROUTING, &routing.header);
 }
 
+static void kvm_set_empty_gsi_routing(struct kvm_vm *vm)
+{
+	struct kvm_irq_routing routing = {};
+
+	vm_ioctl(vm, KVM_SET_GSI_ROUTING, &routing);
+}
+
 static const char *probe_iommu_type(void)
 {
 	int io_fd;
@@ -127,11 +134,12 @@ static const char *probe_iommu_type(void)
 
 static void help(const char *name)
 {
-	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-h] [-t iommu_type]\n", name);
+	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-t iommu_type]\n", name);
 	printf("\n");
 	printf("Tests KVM interrupt routing and delivery via irqfd.\n");
 	printf("-a	Affine the device's host IRQ to a random physical CPU\n");
 	printf("-d	Use a VFIO device to send MSI-X interrupts instead of manually signaling the eventfd\n");
+	printf("-e	Set empty GSI routing in-between some interrupts\n");
 	printf("-t	Override the IOMMU type to use (vfio_type1_iommu or iommufd)\n");
 	printf("\n");
 	exit(KSFT_FAIL);
@@ -158,6 +166,7 @@ int main(int argc, char **argv)
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	struct vfio_pci_device *device = NULL;
 	int nr_irqs = 1000, nr_vcpus = 1;
+	bool set_empty_routing = false;
 	const char *device_bdf = NULL;
 	const char *iommu_type = NULL;
 	int i, j, c, msix, eventfd;
@@ -165,7 +174,7 @@ int main(int argc, char **argv)
 	struct kvm_vm *vm;
 	int irq, irq_cpu;
 
-	while ((c = getopt(argc, argv, "ad:ht:")) != -1) {
+	while ((c = getopt(argc, argv, "ad:eht:")) != -1) {
 		switch (c) {
 		case 'a':
 			irq_affinity = true;
@@ -173,6 +182,9 @@ int main(int argc, char **argv)
 		case 'd':
 			device_bdf = optarg;
 			break;
+		case 'e':
+			set_empty_routing = true;
+			break;
 		case 't':
 			iommu_type = optarg;
 			break;
@@ -222,9 +234,13 @@ int main(int argc, char **argv)
 	}
 
 	for (i = 0; i < nr_irqs; i++) {
+		const bool do_set_empty_routing = set_empty_routing && (i & BIT(3));
 		struct kvm_vcpu *vcpu = vcpus[i % nr_vcpus];
 		struct timespec start;
 
+		if (do_set_empty_routing)
+			kvm_set_empty_gsi_routing(vm);
+
 		kvm_route_msi(vm, gsi, vcpu, vector);
 
 		if (irq_affinity) {
-- 
2.54.0.1099.g489fc7bff1-goog

