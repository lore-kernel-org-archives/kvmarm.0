Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773FC3DCD8D
	for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 11:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792234963; cv=none; b=pjxAm03O5Ond7ZceUInGAu4QVhnA9bfKvFCsUt8BkioUh9XG/AcWMIAIdtuz/jDxaC+xjDq+cckCHz6d/tAsNTJki05auAJkta1YMptDwteV0LlS/qvFz98VxT4vYINz2uK8qd+7+WE1cjKKtUV6LKtEcGgYb6xhjrhEf4b9h/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792234963; c=relaxed/simple;
	bh=8ywuulccP1F+xp8m0G/rdMRl+HXUX9U2tjWY4yPqxJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO81gkpcXyV63/ACINakLG90WDQTPPlWa7TP6Incou1ICaNEY9F9OxrORa/diflR9SOJBCrtyJW8qJ9rGV1hIHeV8Rez6+QnrMIrxKeYcHzvxojY6xYtlLlgUjA1brS3dLn1oYyFjTxLd0SmDyQy5clGNA26tNKKz53Ww21yNM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OkSKW3j+; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OkSKW3j+"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e60f9af6e6so4542535ad.3
        for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 04:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792234962; x=1792839762; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Khy5mpRZBeQDtqVcHeSI4CoZNFAypt9Icm1BgzV+FWo=;
        b=OkSKW3j+hg+onX4X83QrUGl6S0hYlbIus2/ZAbS5/HeGr6OXcSMx/Ao8YB3lfmlzv+
         i1Cg0xvaVu4yqnpFQuM4q5CkoprNfyXowQDn1HUQwLZeStEuFs7MwjLVDTO7dzYOLjo2
         xUng8NpznePhqA2LDafs6AnnbtRSy89qwcpGQiJrSKCRoso4aWeL4/S93baMYUlMCcVU
         s/NK2B4nCEz4req3Ap73zQJab+o7A8j8GNy+boQCNSbVi/nP54tzUqSmlCUIQpHbv9ZQ
         yKToJdM92UHbzDZV4YzHlYdj5P70dRpgDM0HjUciE5Eu0EjoePlXU7X/3OkyFGcjqMZG
         t53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792234962; x=1792839762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Khy5mpRZBeQDtqVcHeSI4CoZNFAypt9Icm1BgzV+FWo=;
        b=ZHykyG9KDUNKW/EJ4e0H77mJRos4gRTPoLPBKMTTPBHUpAICk2U++gHG0ixm0GXi2g
         tk+yT7GNZRm2LXyE2dUQE7tDTeuyUizASh9+y8pQHSblYZC5lI7Srau/MjeDuzjb1/bO
         yN4tRjIMb9VHhUdqo5PPgd2Pant3anWjus19gSoOP9IN43pKckb9pPzbvTj9cC1fu/n4
         s8ep5xQpxQ1WGcOigmcr+mPMOnjv0ge8tdgeBBU9dDWrSHMjef2iJy+xKnO4/3DqmCnE
         TyUZs7W/1XF8T7JlScxMO8eEo1WhA0ujxFseS8thDAhLHakAjcho70zak3WydGq+e7qk
         79qg==
X-Forwarded-Encrypted: i=1; AKwUvBxclqcvpJcQ6T/93I7Y5irDRCInGeCTDDuyNa0bwcXTu5MG63yRYrrUHdbjCTWSVH1Iw/AqXis=@lists.linux.dev
X-Gm-Message-State: AFq9FYIBWTuE/7qKzIesUgd4nx23zUyQKu3+NISxW51pHPwMRssg+Zhs
	NKmLWtKfazysbc31Q72+acLjFC9zP9eNThH+WAceMyo9IBuF8YMAOrfb
X-Gm-Gg: AYBFou0U5ymnuLuQrEbpNahVMMOUdSklkSSRmZfl9S205rjSXbQYURsT9lhCIMzbEkO
	FDCtegfbcSnlsFQAxWIfYMjTcRMeqN8SbOTyt19ZDfJ79Wf1rRRJ44cpYHFoMVxuaT0myT5oiRW
	IEMgVRtPD92hbQxJb4qyBqXacG6t1VTLr2F/af6PLyOdrpCz9/TSw5VWgPZLHdyq2/FawCFy9ry
	vpX5a5IR8ugs/yTSRh6cqqE3ianeU7HLkHtK8gXqInWegmLrMUgfdr/T276vSUNkKUzmrYuBtdX
	amod8yfkU6Y7EzxA9jkY4JW3xqnZBS7/yxWvPr6b1lDT4XVNMOAfULUzfAGuTcGZVv4mP4Abk3J
	FyKHF5yC1kYCpEXpcR0Am24FqrzwsysyDC0/YThQJ9d2Op6Q2qzhdGMzHtvoXfH4XJ3CtQXVBgL
	gBzZq+s7mao45yf8va3suLXcAGPN021Sj2jik2mf063U0HfXMct4uxcjRtf9QOUQM+ej8nyCCfD
	z/nOtnjCjZqijOo9lY1yJJmdLZ7bz/K
X-Received: by 2002:a17:903:283:b0:2e7:4a2f:68e6 with SMTP id d9443c01a7336-2e9a6c0de31mr22453835ad.39.1792234960910;
        Sat, 17 Oct 2026 04:02:40 -0700 (PDT)
Received: from x1c ([2405:9800:b670:b64b:7c65:ff3e:80ba:b06])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e804dd9sm20559955ad.16.2026.10.17.04.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 04:02:40 -0700 (PDT)
From: Tharit Tangkijwanichakul <tharitt97@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>
Subject: [PATCH 1/5] KVM: selftests: Introduce a shared base for test memslots
Date: Sat, 17 Oct 2026 18:02:09 +0700
Message-ID: <20261017110213.46199-2-tharitt97@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017110213.46199-1-tharitt97@gmail.com>
References: <20261017110213.46199-1-tharitt97@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace hardcoded slot 1 assignments with TEST_MEM_SLOT_BASE
This prepares tests for reserving slot 1 for library use.

Signed-off-by: Tharit Tangkijwanichakul <tharitt97@gmail.com>
---
 tools/testing/selftests/kvm/arm64/hypercalls.c               | 3 ++-
 tools/testing/selftests/kvm/arm64/sea_to_user.c              | 2 +-
 tools/testing/selftests/kvm/arm64/stage2_block_transitions.c | 2 +-
 tools/testing/selftests/kvm/arm64/vgic_its_save.c            | 2 +-
 tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c          | 2 +-
 tools/testing/selftests/kvm/dirty_log_test.c                 | 2 +-
 tools/testing/selftests/kvm/guest_memfd_test.c               | 2 +-
 tools/testing/selftests/kvm/include/kvm_util.h               | 1 +
 tools/testing/selftests/kvm/kvm_page_table_test.c            | 2 +-
 tools/testing/selftests/kvm/mmu_stress_test.c                | 2 +-
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c             | 3 ++-
 tools/testing/selftests/kvm/steal_time.c                     | 3 ++-
 tools/testing/selftests/kvm/x86/nested_dirty_log_test.c      | 2 +-
 tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c  | 2 +-
 14 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/hypercalls.c b/tools/testing/selftests/kvm/arm64/hypercalls.c
index 391e2ba58b0b..ff7c21738a96 100644
--- a/tools/testing/selftests/kvm/arm64/hypercalls.c
+++ b/tools/testing/selftests/kvm/arm64/hypercalls.c
@@ -191,7 +191,8 @@ static void steal_time_init(struct kvm_vcpu *vcpu)
 	unsigned int gpages;
 
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE);
-	vm_userspace_mem_region_add(vcpu->vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
+	vm_userspace_mem_region_add(vcpu->vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE,
+				    TEST_MEM_SLOT_BASE, gpages, 0);
 
 	vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PVTIME_CTRL,
 			     KVM_ARM_VCPU_PVTIME_IPA, &st_ipa);
diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index d4af6e0eed28..bb552debc61c 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -323,7 +323,7 @@ static struct kvm_vm *vm_create_with_sea_handler(struct kvm_vcpu **vcpu)
 		/*vm=*/vm,
 		/*src_type=*/src_type,
 		/*gpa=*/start_gpa,
-		/*slot=*/1,
+		/*slot=*/TEST_MEM_SLOT_BASE,
 		/*npages=*/num_guest_pages,
 		/*flags=*/0);
 
diff --git a/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c b/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
index 5fd47f4ada1f..0e23d7b55782 100644
--- a/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
+++ b/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
@@ -41,7 +41,7 @@
 #include "test_util.h"
 #include "ucall.h"
 
-#define DATA_SLOT		1
+#define DATA_SLOT		TEST_MEM_SLOT_BASE
 #define TEST_GVA		0xc0000000UL
 #define BLOCK_SIZE		SZ_2M
 
diff --git a/tools/testing/selftests/kvm/arm64/vgic_its_save.c b/tools/testing/selftests/kvm/arm64/vgic_its_save.c
index 864da01539f3..e858a4aa741d 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_its_save.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_its_save.c
@@ -29,7 +29,7 @@
 #include "ucall.h"
 #include "vgic.h"
 
-#define TEST_MEMSLOT_INDEX	1
+#define TEST_MEMSLOT_INDEX	TEST_MEM_SLOT_BASE
 
 /* All three ITS table entry sizes are 8 bytes in ABI 0. */
 #define ESZ			8
diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index 9a69c439a0f8..1d5c56481053 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -18,7 +18,7 @@
 #include "ucall.h"
 #include "vgic.h"
 
-#define TEST_MEMSLOT_INDEX	1
+#define TEST_MEMSLOT_INDEX	TEST_MEM_SLOT_BASE
 
 #define GIC_LPI_OFFSET	8192
 
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index af5eb0334a74..75084fe3bec6 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -26,7 +26,7 @@
 #define PAGE_SHIFT_4K  12
 
 /* The memory slot index to track dirty pages */
-#define TEST_MEM_SLOT_INDEX		1
+#define TEST_MEM_SLOT_INDEX		TEST_MEM_SLOT_BASE
 
 /* Default guest test virtual memory offset */
 #define DEFAULT_GUEST_TEST_MEM		0xc0000000
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 2233d871a38f..231bfe238e31 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -510,7 +510,7 @@ static void test_guest_memfd_guest(void)
 	 * the PCI hole and other MMIO regions that need to be avoided.
 	 */
 	const gpa_t gpa = SZ_4G;
-	const int slot = 1;
+	const int slot = TEST_MEM_SLOT_BASE;
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 5a7a455b5387..759d604d44ce 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -30,6 +30,7 @@
 
 #define KVM_DEV_PATH "/dev/kvm"
 #define KVM_MAX_VCPUS 512
+#define TEST_MEM_SLOT_BASE 1
 
 #define NSEC_PER_SEC 1000000000L
 
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 974813ea8953..f18720109319 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -20,7 +20,7 @@
 #include "guest_modes.h"
 #include "ucall_common.h"
 
-#define TEST_MEM_SLOT_INDEX             1
+#define TEST_MEM_SLOT_INDEX             TEST_MEM_SLOT_BASE
 
 /* Default size(1GB) of the memory for testing */
 #define DEFAULT_TEST_MEM_SIZE		(1 << 30)
diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 741e343962ed..b965a8b9d214 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -273,7 +273,7 @@ int main(int argc, char *argv[])
 	 * 1gb-3gb,but it's simpler to skip straight to 4gb.
 	 */
 	const u64 start_gpa = SZ_4G;
-	const int first_slot = 1;
+	const int first_slot = TEST_MEM_SLOT_BASE;
 
 	struct timespec time_start, time_run1, time_reset, time_run2, time_ro, time_rw;
 	u64 max_gpa, gpa, slot_size, max_mem, i;
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 20388f0b959d..6abd74870e01 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -605,7 +605,8 @@ static void test_vm_events_test(void *guest_code)
 static void test_vm_setup_snapshot_mem(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	/* PMU Snapshot requires single page only */
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, PMU_SNAPSHOT_GPA_BASE, 1, 1, 0);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, PMU_SNAPSHOT_GPA_BASE,
+				    TEST_MEM_SLOT_BASE, 1, 0);
 	/* PMU_SNAPSHOT_GPA_BASE is identity mapped */
 	virt_map(vm, PMU_SNAPSHOT_GPA_BASE, PMU_SNAPSHOT_GPA_BASE, 1);
 
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 785d19f9ee8f..e386580ef540 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -509,7 +509,8 @@ static struct kvm_vm *vm_create_steal_time(u32 nr_vcpus, void *guest_code,
 	/* Create a VM and an identity mapped memslot for the steal time structure */
 	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * nr_vcpus);
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE,
+				    TEST_MEM_SLOT_BASE, gpages, 0);
 	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
 
 	return vm;
diff --git a/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
index 26b474bf1353..e86d625b3e89 100644
--- a/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
@@ -16,7 +16,7 @@
 #include "vmx.h"
 
 /* The memory slot index to track dirty pages */
-#define TEST_MEM_SLOT_INDEX		1
+#define TEST_MEM_SLOT_INDEX		TEST_MEM_SLOT_BASE
 
 /*
  * Allocate four pages total.  Two pages are used to verify that the KVM marks
diff --git a/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c b/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
index a130759f39a1..4bc57e5e40e3 100644
--- a/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
@@ -17,7 +17,7 @@
  * interpreted as a direct L1 GPA or translated using NPT as an L2 GPA, depends
  * on which VMCB is accessed.
  */
-#define TEST_MEM_SLOT_INDEX		1
+#define TEST_MEM_SLOT_INDEX		TEST_MEM_SLOT_BASE
 #define TEST_MEM_PAGES			2
 #define TEST_MEM_BASE			0xc0000000
 
-- 
2.53.0

