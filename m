Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3466115AD
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 01:07:32 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-52f2ab6a942so70071017b3.14
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 17:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9BAtKaaHohTEAYMjD0cR4uj3MWVe56GuEhp9bvwPfa4=;
        b=Yj822Ifz/waLQy8MmSjHN2pZu32oORMwB771wgCi32mwkJC0hUQpN1N/nWxoPuQKkY
         MR5Obqol9/aE1XAhNk7AVogHzndhjoI3zj/ErGMJSzobg1QkdKs40EF9od/2mDXGl3Mr
         vML3D5iNNfD1nb34vZDllfCbGcaAnWRYJUliZNg+yJkjJr9xtUkHpwrusRFPJfJbTXvS
         iIZLxpFggJQJTFRdLpI55cjbpErqmMuA8qkkrcU08xAnYu4PDLbIWuBAlSrsut48bP65
         31IIpqq6lv+RfBeb3Rip0r7AbEsVn78niJMaW1e4tKNTl7PeTbGqq+6vGsP827kL6i0p
         hNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BAtKaaHohTEAYMjD0cR4uj3MWVe56GuEhp9bvwPfa4=;
        b=2yNOjteAeqrQXOUG/3U1qW9WM7skApiL2Je7zqOiHsDKZD51w6THBjtQo0rE2HE7cz
         XlcOsj1wm1hnQgjW8Cc9uLpOGYGHYy14YY5IEPxS3/599AqjUVwv3+gPY4sEyMP1/D0Q
         umEfJ2kBoEjb8b5w63ErIkbhH6zVivWOGKj34+55g83Q2jEi+6w4XFAr+vxDTn9uVBgA
         wfekq/s2BIU7/Bksvl6XuSuZHDceKjXCOdi+aXDP5Q8jtlZ+m9/GUWbEmmW97+5LSISY
         tFPeUA/CGj+7Mqp767osnnLEmpYvrdkIo8X6MNELUi1QiFnSO+1Y3QYD3c+fTBbRj2T4
         GmTA==
X-Gm-Message-State: AO0yUKVXAYzyv7L0Q6zYqgo0hi1SraRmxwSPblv35PxumUIBDDIsqnLd
	VFwCHs13O2y5MDJAGYiebEbvaDsTU8/l
X-Google-Smtp-Source: AK7set9KQp5+rmM+igHZkkICMtVguIIXyRbXqTvu6s5OOn6LZ8Hz4m5ENjHy86UYN6YyxNTRrDsY/D2AXKXH
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:ae0b:0:b0:530:a340:bcd7 with SMTP id
 m11-20020a81ae0b000000b00530a340bcd7mr0ywh.8.1676423250349; Tue, 14 Feb 2023
 17:07:30 -0800 (PST)
Date: Wed, 15 Feb 2023 01:07:09 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-9-rananta@google.com>
Subject: [REPOST PATCH 08/16] selftests: KVM: aarch64: Consider PMU event
 filters for VM creation
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Accept a list of KVM PMU event filters as an argument while creating
a VM via create_vpmu_vm(). Upcoming patches would leverage this to
test the event filters' functionality.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 64 +++++++++++++++++--
 1 file changed, 60 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 15aebc7d7dc94..2b3a4fa3afa9c 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -15,10 +15,14 @@
 #include <vgic.h>
 #include <asm/perf_event.h>
 #include <linux/bitfield.h>
+#include <linux/bitmap.h>
 
 /* The max number of the PMU event counters (excluding the cycle counter) */
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
 
+/* The max number of event numbers that's supported */
+#define ARMV8_PMU_MAX_EVENTS		64
+
 /*
  * The macros and functions below for reading/writing PMEV{CNTR,TYPER}<n>_EL0
  * were basically copied from arch/arm64/kernel/perf_event.c.
@@ -224,6 +228,8 @@ struct pmc_accessor pmc_accessors[] = {
 	{ read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pmevtypern },
 };
 
+#define MAX_EVENT_FILTERS_PER_VM 10
+
 #define INVALID_EC	(-1ul)
 uint64_t expected_ec = INVALID_EC;
 uint64_t op_end_addr;
@@ -232,6 +238,7 @@ struct vpmu_vm {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	int gic_fd;
+	unsigned long *pmu_filter;
 };
 
 enum test_stage {
@@ -541,8 +548,51 @@ static void guest_code(void)
 #define GICD_BASE_GPA	0x8000000ULL
 #define GICR_BASE_GPA	0x80A0000ULL
 
+static unsigned long *
+set_event_filters(struct kvm_vcpu *vcpu, struct kvm_pmu_event_filter *pmu_event_filters)
+{
+	int j;
+	unsigned long *pmu_filter;
+	struct kvm_device_attr filter_attr = {
+		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr = KVM_ARM_VCPU_PMU_V3_FILTER,
+	};
+
+	/*
+	 * Setting up of the bitmap is similar to what KVM does.
+	 * If the first filter denys an event, default all the others to allow, and vice-versa.
+	 */
+	pmu_filter = bitmap_zalloc(ARMV8_PMU_MAX_EVENTS);
+	TEST_ASSERT(pmu_filter, "Failed to allocate the pmu_filter");
+
+	if (pmu_event_filters[0].action == KVM_PMU_EVENT_DENY)
+		bitmap_fill(pmu_filter, ARMV8_PMU_MAX_EVENTS);
+
+	for (j = 0; j < MAX_EVENT_FILTERS_PER_VM; j++) {
+		struct kvm_pmu_event_filter *pmu_event_filter = &pmu_event_filters[j];
+
+		if (!pmu_event_filter->nevents)
+			break;
+
+		pr_debug("Applying event filter:: event: 0x%x; action: %s\n",
+				pmu_event_filter->base_event,
+				pmu_event_filter->action == KVM_PMU_EVENT_ALLOW ? "ALLOW" : "DENY");
+
+		filter_attr.addr = (uint64_t) pmu_event_filter;
+		vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &filter_attr);
+
+		if (pmu_event_filter->action == KVM_PMU_EVENT_ALLOW)
+			__set_bit(pmu_event_filter->base_event, pmu_filter);
+		else
+			__clear_bit(pmu_event_filter->base_event, pmu_filter);
+	}
+
+	return pmu_filter;
+}
+
 /* Create a VM that has one vCPU with PMUv3 configured. */
-static struct vpmu_vm *create_vpmu_vm(void *guest_code)
+static struct vpmu_vm *
+create_vpmu_vm(void *guest_code, struct kvm_pmu_event_filter *pmu_event_filters)
 {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -586,6 +636,9 @@ static struct vpmu_vm *create_vpmu_vm(void *guest_code)
 		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
 
 	/* Initialize vPMU */
+	if (pmu_event_filters)
+		vpmu_vm->pmu_filter = set_event_filters(vcpu, pmu_event_filters);
+
 	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
 	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
 
@@ -594,6 +647,8 @@ static struct vpmu_vm *create_vpmu_vm(void *guest_code)
 
 static void destroy_vpmu_vm(struct vpmu_vm *vpmu_vm)
 {
+	if (vpmu_vm->pmu_filter)
+		bitmap_free(vpmu_vm->pmu_filter);
 	close(vpmu_vm->gic_fd);
 	kvm_vm_free(vpmu_vm->vm);
 	free(vpmu_vm);
@@ -631,7 +686,7 @@ static void run_counter_access_test(uint64_t pmcr_n)
 	guest_data.expected_pmcr_n = pmcr_n;
 
 	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
-	vpmu_vm = create_vpmu_vm(guest_code);
+	vpmu_vm = create_vpmu_vm(guest_code, NULL);
 	vcpu = vpmu_vm->vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
@@ -676,7 +731,7 @@ static void run_counter_access_error_test(uint64_t pmcr_n)
 	guest_data.expected_pmcr_n = pmcr_n;
 
 	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
-	vpmu_vm = create_vpmu_vm(guest_code);
+	vpmu_vm = create_vpmu_vm(guest_code, NULL);
 	vcpu = vpmu_vm->vcpu;
 
 	/* Update the PMCR_EL0.N with @pmcr_n */
@@ -719,9 +774,10 @@ static uint64_t get_pmcr_n_limit(void)
 	struct vpmu_vm *vpmu_vm;
 	uint64_t pmcr;
 
-	vpmu_vm = create_vpmu_vm(guest_code);
+	vpmu_vm = create_vpmu_vm(guest_code, NULL);
 	vcpu_get_reg(vpmu_vm->vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
 	destroy_vpmu_vm(vpmu_vm);
+
 	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
 }
 
-- 
2.39.1.581.gbfd45094c4-goog

