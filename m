Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC4C23EAB4
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310053; cv=none; b=YU6KeNsE3gOox10gPtQDE+mPSRYMCEBxDNBMlDsbqIT+Yd+EIcSBRlYgD3W403K286BmKsTjaod7ME2e2du0Hx/wLuLuEii74zInu/qnPrHQrxllW3XdzFRQIt4uw8QyPwb33X+M9p5YIA5oDtraq9DMcGwwFml8fAD0LFdNhr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310053; c=relaxed/simple;
	bh=M/n+s2ScTJoVUw7uG6hi9PjTyqlDpaI5PqGjdNus3Rg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pAE5fuXESXoHuTj+X8bueCsnYkueqIOeQzh/98uwfelaWIyg09HxkrQjZQkNVntCc0KowbehWKhuwysphv2Tu4dWuOCW3cTZ+H9gTq9D7+icPAOLKIO7dfnZuWy002pFKjlyrybHMSO+B10FWcKVOUWQUS1xe16abZ+Fg2pdZoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PJQl4FZ1; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PJQl4FZ1"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8428384f31fso1184396b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310050; x=1781914850; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rIJ8Uf8PcJidyyeBqiFcFwTrdNm0vIWb+NN/Ok5zc0s=;
        b=PJQl4FZ15iBxn7MZEMPQEycdkWYatBgeExLYr5Nu6ZXeIzDc5DSKcq1BdLTXUylc0+
         aalaVJEpSN+j0qX7Sc59Hzi0oYiGjzFWfXBb/2E1nhOJI1nU+maZg/zR31XkvelKk81q
         8aTlBuO6cWHDCnOMjP2onAzD9NbQrcU2aSg8htE8HaOopAhG3T0NW61RxbUaXqynK6TC
         3iieGdxJKrwm8M8Kg8nEp3FxvAZgiwpy/+euuOouMghfRRuxTKa/GF2UseVxkl7Bne9F
         WcaXkNWJRrgyHAn+E1DpZYPf8wr8lXL1nuu/QFG75eFu2s5oONYBOSXq6SZ1glpZGpcp
         qKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310050; x=1781914850;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rIJ8Uf8PcJidyyeBqiFcFwTrdNm0vIWb+NN/Ok5zc0s=;
        b=ifTJW3Ac0g0/aKT4SkDXYIwDWV7+2e6QfYGaH7aaXATbde3MlYliU4gsH0rJ9tOkBm
         Ue6jzRW81pWkvNyTjiPeg7GXoHTa9IJvSqIewhDIpa9mnBDpRAROc2vXIgzFIov/GeB+
         Hcl3ZY46YWg3ftQBGW+bLdvoBgkqrIclERXLcSRgNmox/hV7R7JiFYNUwW3/NHrnsTmh
         jJleAFT2JKqO5RFJKxnt4YZ/q+xvZOA0d2R0ML/CRWGJ35U6MGEXRyiat0luU+SLPqk0
         hpuV98rH+RMw7CCQ1p/BlBWcYcZhLmFIr/XRUN2APlsDqlyA7xsCGp7lbmNU+zaQdpDP
         KcBQ==
X-Forwarded-Encrypted: i=1; AFNElJ+NBjdoXcOAMhiiI2+SLaVCR1TJt9paOrS9KelbKgnqhbOV61Ks+Z5P+6iELx3Wlx+gy4q1k0g=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiYgR6l10Wa0M4MBB1fqF3FwfeVISMYB7mMtOm3b8dVNfO8VOp
	VmuDl4zpc+iLPaY3cU6KZH9DCjEfXPKS0TOMmUoOVL3xG5iNNCx8loZJr5/f5MX4USzqd7CEdOi
	XyY+rXQ==
X-Received: from pghm14.prod.google.com ([2002:a63:f60e:0:b0:c79:87d6:650a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:486:b0:39f:a8fb:3354
 with SMTP id adf61e73a8af0-3b783b9cceemr6105295637.17.1781310050361; Fri, 12
 Jun 2026 17:20:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:23 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-13-seanjc@google.com>
Subject: [PATCH v7 12/20] KVM: selftests: Add option to set empty routing
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
index c01aa313f719..2356912e2272 100644
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
@@ -223,9 +235,13 @@ int main(int argc, char **argv)
 	irq_cpu = -1;
 
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
2.54.0.1136.gdb2ca164c4-goog

