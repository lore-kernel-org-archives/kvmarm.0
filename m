Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7917A31E835
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052848; cv=none; b=r342k6xz+YIJMYRzOWrdoT0vMcEILQfdke2O920O6bmzrnhU6EAOSOGvJRvqbTUF3IViJn+zpKYtaeoS++Hp4tDZid0NRj3/42ja6qip+yVlk4I8krev9c2wmaPUsYKdNyzHwPSBcASa2G88BtbzFcg+X0rtsHGM/jCd54Yk2ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052848; c=relaxed/simple;
	bh=AiUuBRIX0kUa2VEzwQ/KiwLXhNWB6Ni7nPHSHxTzQ78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X7K+aHxwLsVYOqUCLQyzatvXBR0BxjDGMQNkKyIQaSsAgo5L8txt05YMJ7d8pG7VsP6S19NRG5VkG28BBv+ydWMtx4rz4R1joghcOS+KEL4U8ZLWhkPqqJas1rf4EyaL/a4Qpjbh6q57JuC1NtctFzG84NPpQpGLhBYa7cgv6PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dF2LNZkW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dF2LNZkW"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-36d99333358so5874255a91.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052847; x=1781657647; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q4JpkxXanGmrcDhm8+OuLX2LEo2GMxbk1wO2svPpVp4=;
        b=dF2LNZkWgaU9N5zMYx6/wHoley9pLcp4zEgI7oyKW+tHrSL6e54P8YiBoQAv+vyafZ
         j5gODaHFYJfrrD4rt37CfWqrMaunvXNwY3WAeyLltgbAQRa/DvpaaoDzadUZ+txKvZYB
         z1WRejxEeqxq/0SADUY7QBdOapqwn3us9vzsDZ+OxOki/KA+OFpX51hy+8YjfrZAgiem
         tojjoWp8i9lqjf+NjZqbyi0eXQhIHXSzDECfCdPpCHAmjC+lojg35B67bgVIb2hnaeqE
         mT62jmukvCPJvY8uIww2vDvrZHNko7R3u/7NQrRf5H0uFJdSYxhKCVEEVq97rk+uXPu4
         j3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052847; x=1781657647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q4JpkxXanGmrcDhm8+OuLX2LEo2GMxbk1wO2svPpVp4=;
        b=YUmowu6Kv0FksLcduiUzmSkX8kqpA6APaeh/rqTK0EgTO6NUlT63iCitwQy/tNcsha
         I8RfqW8jk4m/1UY1v/Gdke/B56Ou8oxXML55Bx9fuYAy4OzJTdGoBvu/qkWKgAJqJIFp
         LgQbZKMk4JzZS4d3PusB80re25QAp6gHVvwir7qf51jF0j5MLp6oiFTHksXWCf7eK29D
         yHAmpLwzc0FFln6Jm8tZPWVOBC664q8xuIpIj9frB2nPZmlNdQ2KTRwe/dGTvvL92yCR
         vu0FwD9FdoaBCKwlNcnSloDZBSX0cRxKy8SY79QsRmSf3SwbPtaN2Y+q8mKdIhN4py4X
         1O/A==
X-Forwarded-Encrypted: i=1; AFNElJ8sbWKEdLIZbv/WunX8t1Y24uCfd8lCZHJ3Teq0kOdrjTleQ8opCDqLvoD2TwBgdNQ5m9JmTsM=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywa3CZfCOM4cYaKPf+/49Bt7WVT68xdwGZNXyIYZgNJ5VZkVksu
	i0acMtXs+tVf/CMNfYCthl8y2NEJkv6Mm0l9CyMyjesXoHoSiU1tOmckdOC+hqmI2pU7lfKPd5R
	CcA1HBw==
X-Received: from pjbiq21.prod.google.com ([2002:a17:90a:fb55:b0:36b:7f07:6fcd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc7:b0:36d:cf58:b79
 with SMTP id 98e67ed59e1d1-375211ae901mr6245033a91.19.1781052846605; Tue, 09
 Jun 2026 17:54:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:38 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-19-seanjc@google.com>
Subject: [PATCH v6 18/18] KVM: selftests: Add xAPIC support in eventfd IRQ test
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

Extend the eventfd IRQ test with a '-x' flag to let the user run the test
in xAPIC mode instead of the default x2APIC mode.  When using xAPIC mode,
sanity check user input to ensure the test is being run with at most 255
vCPUs, as xAPIC can only address IDs 0-254 (255, i.e. 0xff, broadcasts to
all CPUs).

Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: add sanity check on number of vCPUs]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/irq_test.c | 31 +++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
index 7d64fd29ea8b..2b6fc0335d38 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -18,6 +18,7 @@ static u64 timeout_ns = 2ULL * 1000 * 1000 * 1000;
 static bool guest_ready_for_irqs[KVM_MAX_VCPUS];
 static bool guest_received_irq[KVM_MAX_VCPUS];
 static bool guest_received_nmi[KVM_MAX_VCPUS];
+static bool x2apic = true;
 static bool irq_affinity;
 static bool done;
 
@@ -31,14 +32,20 @@ static bool done;
 
 static u32 guest_get_vcpu_id(void)
 {
-	return x2apic_read_reg(APIC_ID);
+	if (x2apic)
+		return x2apic_read_reg(APIC_ID);
+	else
+		return xapic_read_reg(APIC_ID) >> 24;
 }
 
 static void guest_irq_handler(struct ex_regs *regs)
 {
 	WRITE_ONCE(guest_received_irq[guest_get_vcpu_id()], true);
 
-	x2apic_write_reg(APIC_EOI, 0);
+	if (x2apic)
+		x2apic_write_reg(APIC_EOI, 0);
+	else
+		xapic_write_reg(APIC_EOI, 0);
 }
 
 static void guest_nmi_handler(struct ex_regs *regs)
@@ -48,7 +55,10 @@ static void guest_nmi_handler(struct ex_regs *regs)
 
 static void guest_code(void)
 {
-	x2apic_enable();
+	if (x2apic)
+		x2apic_enable();
+	else
+		xapic_enable();
 
 	sti_nop();
 
@@ -146,7 +156,7 @@ static const char *probe_iommu_type(void)
 
 static void help(const char *name)
 {
-	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-i nr_irqs] [-m] [-n] [-t iommu_type] [-v nr_vcpus]\n", name);
+	printf("Usage: %s [-a] [-d <segment:bus:device.function>] [-e] [-h] [-i nr_irqs] [-m] [-n] [-t iommu_type] [-v nr_vcpus] [-x]\n", name);
 	printf("\n");
 	printf("Tests KVM interrupt routing and delivery via irqfd.\n");
 	printf("-a	Affine the device's host IRQ to a random physical CPU\n");
@@ -157,6 +167,7 @@ static void help(const char *name)
 	printf("-n	Deliver 50 percent of IRQs as non-maskable interrupts\n");
 	printf("-t	Override the IOMMU type to use (vfio_type1_iommu or iommufd)\n");
 	printf("-v	Number of vCPUS to run\n");
+	printf("-x	Use xAPIC mode instead of x2APIC mode in the guest\n");
 	printf("\n");
 	exit(KSFT_FAIL);
 }
@@ -193,7 +204,7 @@ int main(int argc, char **argv)
 	struct kvm_vm *vm;
 	int irq, irq_cpu;
 
-	while ((c = getopt(argc, argv, "ad:ehi:mnt:v:")) != -1) {
+	while ((c = getopt(argc, argv, "ad:ehi:mnt:v:x")) != -1) {
 		switch (c) {
 		case 'a':
 			irq_affinity = true;
@@ -221,6 +232,9 @@ int main(int argc, char **argv)
 			TEST_ASSERT(nr_vcpus <= KVM_MAX_VCPUS,
 				    "KVM selftests support at most %u vCPUs", KVM_MAX_VCPUS);
 			break;
+		case 'x':
+			x2apic = false;
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -236,6 +250,11 @@ int main(int argc, char **argv)
 	vm_install_exception_handler(vm, vector, guest_irq_handler);
 	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
 
+	if (!x2apic) {
+		TEST_ASSERT(nr_vcpus < 256, "xAPIC can only target IDs [0-254] (255 vCPUs)");
+		virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+	}
+
 	if (device_bdf) {
 		if (!iommu_type)
 			iommu_type = probe_iommu_type();
@@ -260,6 +279,8 @@ int main(int argc, char **argv)
 
 	kvm_assign_irqfd(vm, gsi, eventfd);
 
+	sync_global_to_guest(vm, x2apic);
+
 	if (migrate_vcpus)
 		kvm_sched_getaffinity(0, sizeof(available_cpus), &available_cpus);
 
-- 
2.54.0.1099.g489fc7bff1-goog

