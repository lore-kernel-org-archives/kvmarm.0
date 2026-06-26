Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F623C8C72
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509753; cv=none; b=Y4DHp/mql3cf1gBbe1xoaQ10NFgAdxl36glmE0TeH/ebyKQD2mVbRTyad9F7iJuZehlY+y2SXy9R19WUIqCDNd9LONZvnKZPNy7y+n4dT2jLl/S1x4nghet2qKCcHs8OBpEyy1hncoj7VO8rhgWvaE9VRxldthCxqN1GsTt/CNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509753; c=relaxed/simple;
	bh=ZbaRyKJ5+N5Q+0DLeDMTRepe35qClN0OPdAISbfzeZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OxJN4D5H6iUsS5BVT7IlsdL6zyEEy7E/9+1NdAM44ALYVY5BwMpkqW4gENj0kRmeqfGQssNG2vHxYB6kMNJbHZqiNW7oIxS8bjV1QVd4dicupF0fJ7CMy619a6Jv+3jM+RLtpL+IoTZKk+HJHHe+VFh8j8oDisOEK8eNHvt3WVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c87JGyA8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c87JGyA8"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c987913b08so3223405ad.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509751; x=1783114551; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BfGxV+xN5MQJzo1OxAcNftwHJizNMsItpsF+xT3GCNY=;
        b=c87JGyA8Gqvh3k7sCdMd7YQl7ppMtAtcBqiTuXe6heUwUiUoieCE/guylhYAMa1vr2
         zIQJVUUgbtu/gs73DEc5n+h2cnaMPNOJGCEkQrv43ZyvXSZWKeaV6RmpsRf8Hke2VkDA
         sdyt8tROvfBfTjCqda/VUrH4wZLN5bpsIQ6ME1RCeAxTZLHBM6kdRTaw3XNVOi/990I1
         azzyIcQvkYa8SLxCHEP6qgMAgK4VHSX8UFV0zXgBneYccGBQZrMJNpMEJkkHOdFRGDnu
         bzscCSj144paKZ3tuSFClQ+uotOR/rUVP/Rx4/AlMNpt19SaSQfd9tlGReuB53x6eAEi
         Rn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509751; x=1783114551;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BfGxV+xN5MQJzo1OxAcNftwHJizNMsItpsF+xT3GCNY=;
        b=OsmUmNUxSuSECeBFjbLSJ3/oZe+ObBqIsX9neoax6Oi5Ak0MzIHne9xsI9zCak4UQW
         Y9ydJLtC/+X/XBDFitnMO3br4rFMvKWNfj0kNMVvTQbCbZdRu3krIPMmTLGZ76U9+ULL
         tzl2zPVnGlpywwby4esSZjpeZO71SSXnBcpwF5paJUUw806/B+GhOu+r2QuThh8wbaeJ
         IeAqBiYewtl4VvVM1kdRydpCykCx2cC5qRAmFeIHKGLNlSrxpyyEvoTWAqJObJap+pus
         JKwP760dDYskT6HoloSyKFIdZQ1Jy+K23JdOO2LpXB83g6iv/JFtDklEeLh95B/e76LQ
         6Sgg==
X-Forwarded-Encrypted: i=1; AHgh+Ro3ZksAxGtAb4Wle2xzFI/ZJvwDT1MPBeGSBglPgHRYNMLbAMG2JMEPUKwP06H+AjpyQf7Lr1M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLm5NVqXYakvjcxPi30TjTCSNb12cLVekzsUk/F9MmL8PVJQtw
	maClnlAuwNRAgtH7iqNZNbxqLDCxS2HxFJGHHhmTErLH/SszaiLu3YC4amzZREJ+el0mm/IoDiM
	RsqOU0Q==
X-Received: from plbmj7.prod.google.com ([2002:a17:903:2b87:b0:2c7:f558:fbb4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f786:b0:2c0:bb2d:a30b
 with SMTP id d9443c01a7336-2c7fc754bebmr76656145ad.32.1782509750610; Fri, 26
 Jun 2026 14:35:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:25 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-13-seanjc@google.com>
Subject: [PATCH v8 12/20] KVM: selftests: Add option to set empty routing
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
index fd386e3e9ac3..fd03ec940362 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -121,6 +121,13 @@ static void kvm_route_msi(struct kvm_vm *vm, u32 gsi, struct kvm_vcpu *vcpu,
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
@@ -139,11 +146,12 @@ static const char *probe_iommu_type(void)
 
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
@@ -170,6 +178,7 @@ int main(int argc, char **argv)
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	struct vfio_pci_device *device = NULL;
 	int nr_irqs = 1000, nr_vcpus = 1;
+	bool set_empty_routing = false;
 	const char *device_bdf = NULL;
 	const char *iommu_type = NULL;
 	int i, j, c, msix, eventfd;
@@ -177,7 +186,7 @@ int main(int argc, char **argv)
 	struct kvm_vm *vm;
 	int irq, irq_cpu;
 
-	while ((c = getopt(argc, argv, "ad:ht:")) != -1) {
+	while ((c = getopt(argc, argv, "ad:eht:")) != -1) {
 		switch (c) {
 		case 'a':
 			irq_affinity = true;
@@ -185,6 +194,9 @@ int main(int argc, char **argv)
 		case 'd':
 			device_bdf = optarg;
 			break;
+		case 'e':
+			set_empty_routing = true;
+			break;
 		case 't':
 			iommu_type = optarg;
 			break;
@@ -234,9 +246,13 @@ int main(int argc, char **argv)
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
2.55.0.rc0.799.gd6f94ed593-goog

