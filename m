Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADD625B0BD
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310066; cv=none; b=ueUibN/rycvTPBg1OCsQpUyKI0AGXR/UMtK3bWFd5263iN5ClCzJgmtV2KiDUcc9G6YGkqiiDY/AksHH2JlAYHFImF/Cpboj+Sha/d8EEJGL0NYYmOqG0yoAP/HDPoJWQg4qf+DOWcWVuu+QnGUdRxDmyoji3E7/zHvUPeNs02I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310066; c=relaxed/simple;
	bh=qRB1TlhzR03MlmYRqqLITndd9esgDX7rdlg7Z5QSiQU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H6tvor3vDgXV5f6e+w1tLZ0oqo3hJWBtk7MDRQOE2rZ4KdLnbWdmvgWejUVYHoB53ierNMR85XL490sNho4Qv7MEWWSYPYR8/94AYXosDB54oiANNFrobC0G2h7LE24g8Z6Pcxan65dp9w5Hp7nmo++jcfa/wwrOs2WEN2SmbSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wDnRP1yw; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wDnRP1yw"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-84240b58211so1100183b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310061; x=1781914861; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5oHTfXMBdClQrZ4tUCiIh2PRbirp3RVnp/XkqMdpO/4=;
        b=wDnRP1ywxE2RNKKfZ79RjpkoRhYvh86I2gMRcDo4Kifn0iPmvkNSG5yZXMMhFI72EP
         xAuJl3MRRSUN4xZmgl3NU+8IJjky/GIdXFtFQG2jzyzSUINzYpmqFO+Cj4aajU9YwsDB
         WpnOsBo76DmO/LoY7314a/OBHgWGEoYRfVlNCQ/5SDrGf9bPfe8w4gBtsXytYHWark3y
         JLGkR8N3WGaEkLA4MFizZXqXOsh3vSkBe0kxCVDfgB2nCVtOWzk8TGQdizSsCS3o1rNy
         xYmWWMSgXMUv4quE1Twnvm86wtBXxgCVrbDmDcTUr7qtqtid8S3OeU0mUMaNjGCQ8lnP
         nurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310061; x=1781914861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5oHTfXMBdClQrZ4tUCiIh2PRbirp3RVnp/XkqMdpO/4=;
        b=KWL0F1zor4ZdjdkLNZBd06v+0/f9UOkPFucrzrUwsu/gxxO5nMH5N9ABCOui3fIZV/
         SOJ8wASbE98tPk0VEg7mV7V3yEqWufBjAleypRDizuyBu5sE9BSdG/RIx5cv6cbmpjZC
         6kQSDudoYojECJlf38xoaTH6oouyDO6zZ31xDjcxHuu6y7T7ztRraeB4jB5x5c0uL7Hy
         KrBi2Zigc1hngucSHhoQB4OW9eQ3lE6UN2TALI0CiM9XmXqoTMPMFcmCOyZitqx/XSls
         VK3TBYKk6QCflD4r5p7mQhOYC7GDuQL2bvdpoHDSc4Tt06Si8d8oYG7E5xB6QZ+81NZe
         L49Q==
X-Forwarded-Encrypted: i=1; AFNElJ9PSiAoWewy2wT7q9FeszpqSsttn3YC8VeP+EQyDT4d7mkLvVx9PA17JCQt++RLEof0h0Nivxg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7eBkj+GVP3X04g7fElO8L37S9ixFM95b3ijM/9aBIDhabouUE
	Ek5GTsFvF1o5fkhWlE3Uuu48yTVadAr24kcPzKcZp8oqQBeK9LfU/RpZFlNzrBW9BtVZaVZtmJc
	/wkIFoQ==
X-Received: from pfnz25.prod.google.com ([2002:aa7:85d9:0:b0:83f:1851:35f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:399f:b0:842:2382:a0ea
 with SMTP id d2e1a72fcca58-8434cd2592cmr5324202b3a.14.1781310060965; Fri, 12
 Jun 2026 17:21:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:31 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-21-seanjc@google.com>
Subject: [PATCH v7 20/20] KVM: selftests: Add xAPIC support in eventfd IRQ test
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
index dfdb9f8e398c..a17e274c9b4a 100644
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
@@ -259,6 +278,8 @@ int main(int argc, char **argv)
 
 	kvm_assign_irqfd(vm, gsi, eventfd);
 
+	sync_global_to_guest(vm, x2apic);
+
 	if (migrate_vcpus)
 		kvm_sched_getaffinity(0, sizeof(available_cpus), &available_cpus);
 
-- 
2.54.0.1136.gdb2ca164c4-goog

