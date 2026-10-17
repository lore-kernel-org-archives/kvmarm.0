Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA9D394797
	for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 11:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792234975; cv=none; b=ZMve7aQR7pWdlaDZyAnZUpbpr9vFGJnSy38DSRCehuUn/JVk//89LN8wBKDoDNAAl92mKq97vJT+Cvn0dhBZCf7X73KBVQYiEAPCgniE3SiWfLd2KnsdD9SjA0MnQDSs8ANmifAzcLnhL3ytLZShcV7ZaQnH3Zh1VFDenlZ2Rpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792234975; c=relaxed/simple;
	bh=ptnh4246tl3PZEsc/STWjRYQ+/lRyGGUeix3Acx+XHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+U2o3flY2qANHj7KXY8BuEeLYPYxEW8sA9yiCHvGMX+VF3LRtVVjUNmNKD1maOuaOPxuSdMi/NRbh5n+wIQJMVtLF+zZuqsmN1WJREDD56NU5jqiRUrEO2lFAHFCYzr7V7Did7vJw9tFuVxza+vmAs+6GAiGYdL6+DBZ6Z+TK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AsdRXsW4; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AsdRXsW4"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e96502e447so4704185ad.1
        for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 04:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792234974; x=1792839774; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KIEnM8kSnE++SjvuuMHdYxk0kLmjaVprnb+UtVbFbO0=;
        b=AsdRXsW4WY7lNc8FErsUeghZIYyEE7iq8mv6fDk5Z//oWYt2jCXXRULo642COn3f84
         XTkmzFMAMmBJNfIIEpFdRdkufuV4nBV1+cJo58kHzfFz4CdJZrPEqA/MqsguIV4T0UFs
         3Rh/lqxcC2Fy2owx5bx2jqC+vC6FxiPZ/omr/f/I+dF10/iNcmlermCTJzjA4ZCD87Tn
         ynaD/fXvLd8aADxOhA8FptjoWnUC/QxjOwwhseRtPh74GAMA1V8s7U4tjAFRgJxpvAH2
         zL71dYp7hWMdU195yFiiBG4y2eg7x+QopqLRPOtCaShrZvOPvWDVLcwBvsGaReWaGcPA
         AUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792234974; x=1792839774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KIEnM8kSnE++SjvuuMHdYxk0kLmjaVprnb+UtVbFbO0=;
        b=IV/cqL+NpJKnL/9CvlZ3H3KOuOfeNYasLFth4/EuWXtsSQY5VUSTJIibhivnbr2vtC
         1bXQMT3sMGi7mA0xmZ7qKXSey/knFGBcp96hM3++nGg3jrpf5nOfvnPbhfGLe4Yk4UsL
         tt4wj2TC7VZX5QN7nwOrpul/g+OGAI/WDCOMXsoeY2mMJIgrO5YnOt6uI1nhcGwFDhzP
         BTgml4g//MdyAP44XuFtw7N4SY7tId7N3P0Al74+F84U8NuVJUIRNc9YjuUZeNcBZt8u
         kMlkQV9ncI0sJjLTKyfSOTkl92jooOa+lhIGjWHYf0JhG4RLm5erk3no6U4DAoBUxE4I
         XvAw==
X-Forwarded-Encrypted: i=1; AKwUvBxbtVjuIC2c/8P1gE5z1nAGoxchmh+mgRef/hS7+2LDccqN7jeeeiViYnwkBU/TW+IlYMcN19Y=@lists.linux.dev
X-Gm-Message-State: AFq9FYJoVxMe6p6+xBSAC6fJUT2DG9GSlmhy+XmCeK4KeQGVZYHmcnH9
	sooTVi+0yefHmqWqxsfRhUzmGqfXKt7aFWqw/L16EB2ZiYE7ij7prOO9
X-Gm-Gg: AYBFou0sqyzpEfB6FgAVXLumDtNvBIXETktJTR53KV+W/SuVKibEGx71aPz1+OsYgLD
	GQCLH2i3kekQdMQ7zK/Y27LN4DQ73nPUkp+rTa9VrZKuAZheZoTLx6/jJ93cIJzm71u/vLc0/+R
	d/RhAfFE/Tyv8mA3sjpALN/f2EVQQJgVn1y5ng7Yluah30goNiyyMZDPFo+Am+qZ2kyFd9RF7vY
	hnssbHmXNFg54mIgJ8Dw+O3cbz9AFsaTxu3dQf2juLqrytmFzWgKMUCTE+SPBscCNgzPVxug2vu
	wNQf3A0Q4fLqqzIKRGdkt0Xd12MkWJpZMYj4H3u7bmsbUw0al8cPXaFhIgrrPbQOBW7i892/ygV
	tc+QnPjGVPJQgqjWBaovix8Gzogr93IIr5vd80q6RxO4ZCmqPKqsDiyAsuFYxbljqfSM1Kf3Qil
	yuuqWGbQtI3zuNcZPr0beIP3zs0qkMSbrX5GFF8GtZ9g4xHKoqMxH62upISibAIOsyC9CxLWdtV
	21Bg7DV8cwVKvCPu9TYS4s=
X-Received: by 2002:a17:903:f84:b0:2e8:1f8a:9113 with SMTP id d9443c01a7336-2e9a6f58265mr21900555ad.40.1792234973971;
        Sat, 17 Oct 2026 04:02:53 -0700 (PDT)
Received: from x1c ([2405:9800:b670:b64b:7c65:ff3e:80ba:b06])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e804dd9sm20559955ad.16.2026.10.17.04.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 04:02:53 -0700 (PDT)
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
Subject: [PATCH 2/5] KVM: selftests: Use the shared memslot base in memslot_perf_test
Date: Sat, 17 Oct 2026 18:02:10 +0700
Message-ID: <20261017110213.46199-3-tharitt97@gmail.com>
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

Use TEST_MEM_SLOT_BASE for test memslot IDs and account for the
reserved slots when calculating the available slot count. This
prepares memslot_perf_test for reserving slot 1 for library use.

Signed-off-by: Tharit Tangkijwanichakul <tharitt97@gmail.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 62 +++++++++++--------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e1299611be32..cbb900ab58af 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -60,7 +60,7 @@
  * other memslot(s).
  *
  * We have different number of memory slots, excluding the reserved
- * memory slot 0, on various architectures and configurations. The
+ * memory slots 0 and 1, on various architectures and configurations. The
  * memory size in this test is calculated by picking the maximal
  * last memory slot's memory size, with alignment to the largest
  * supported page size (64KB). In this way, the selected memory
@@ -68,9 +68,9 @@
  *
  * architecture   slots    memory-per-slot    memory-on-last-slot
  * --------------------------------------------------------------
- * x86-4KB        32763    16KB               160KB
- * arm64-4KB      32766    16KB               112KB
- * arm64-16KB     32766    16KB               112KB
+ * x86-4KB        32762    16KB               176KB
+ * arm64-4KB      32765    16KB               128KB
+ * arm64-16KB     32765    16KB               128KB
  * arm64-64KB     8192     64KB               128KB
  */
 #define MEM_TEST_MOVE_SIZE		(3 * SZ_64K)
@@ -276,7 +276,7 @@ static u64 get_max_slots(struct vm_data *data, u32 host_page_size)
 		rempages = mempages % pages_per_slot;
 		if (check_slot_pages(host_page_size, guest_page_size,
 				     pages_per_slot, rempages))
-			return slots + 1;	/* slot 0 is reserved */
+			return slots + TEST_MEM_SLOT_BASE;
 	}
 
 	return 0;
@@ -313,38 +313,42 @@ static bool prepare_vm(struct vm_data *data, int nslots, u64 *maxslots,
 	data->hva_slots = malloc(sizeof(*data->hva_slots) * data->nslots);
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
-	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
-		data->nslots, data->pages_per_slot, rempages);
+	pr_info_v("Adding slots %u..%u, each slot with %" PRIu64
+		  " pages + %" PRIu64 " extra pages last\n",
+		  (u32)TEST_MEM_SLOT_BASE,
+		  TEST_MEM_SLOT_BASE + data->nslots - 1,
+		  data->pages_per_slot, rempages);
 
 	clock_gettime(CLOCK_MONOTONIC, &tstart);
-	for (slot = 1, guest_addr = MEM_GPA; slot <= data->nslots; slot++) {
+	for (slot = 0, guest_addr = MEM_GPA; slot < data->nslots; slot++) {
 		u64 npages;
 
 		npages = data->pages_per_slot;
-		if (slot == data->nslots)
+		if (slot == data->nslots - 1)
 			npages += rempages;
 
 		vm_userspace_mem_region_add(data->vm, VM_MEM_SRC_ANONYMOUS,
-					    guest_addr, slot, npages,
-					    0);
+					    guest_addr, TEST_MEM_SLOT_BASE + slot,
+					    npages, 0);
 		guest_addr += npages * guest_page_size;
 	}
 	*slot_runtime = timespec_elapsed(tstart);
 
-	for (slot = 1, guest_addr = MEM_GPA; slot <= data->nslots; slot++) {
+	for (slot = 0, guest_addr = MEM_GPA; slot < data->nslots; slot++) {
 		u64 npages;
 		gpa_t gpa;
 
 		npages = data->pages_per_slot;
-		if (slot == data->nslots)
+		if (slot == data->nslots - 1)
 			npages += rempages;
 
-		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr, slot);
+		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr,
+					 TEST_MEM_SLOT_BASE + slot);
 		TEST_ASSERT(gpa == guest_addr,
 			    "vm_phy_pages_alloc() failed");
 
-		data->hva_slots[slot - 1] = addr_gpa2hva(data->vm, guest_addr);
-		memset(data->hva_slots[slot - 1], 0, npages * guest_page_size);
+		data->hva_slots[slot] = addr_gpa2hva(data->vm, guest_addr);
+		memset(data->hva_slots[slot], 0, npages * guest_page_size);
 
 		guest_addr += npages * guest_page_size;
 	}
@@ -631,9 +635,10 @@ static void test_memslot_move_loop(struct vm_data *data, struct sync_area *sync)
 	u64 movesrcgpa;
 
 	movesrcgpa = vm_slot2gpa(data, data->nslots - 1);
-	vm_mem_region_move(data->vm, data->nslots - 1 + 1,
+	vm_mem_region_move(data->vm, TEST_MEM_SLOT_BASE + data->nslots - 1,
 			   MEM_TEST_MOVE_GPA_DEST);
-	vm_mem_region_move(data->vm, data->nslots - 1 + 1, movesrcgpa);
+	vm_mem_region_move(data->vm, TEST_MEM_SLOT_BASE + data->nslots - 1,
+			   movesrcgpa);
 }
 
 static void test_memslot_do_unmap(struct vm_data *data,
@@ -988,8 +993,10 @@ static bool parse_args(int argc, char *argv[],
 #endif
 		case 's':
 			targs->nslots = atoi_paranoid(optarg);
-			if (targs->nslots <= 1 && targs->nslots != -1) {
-				pr_info("Slot count cap must be larger than 1 or -1 for no cap\n");
+			if (targs->nslots <= TEST_MEM_SLOT_BASE &&
+			    targs->nslots != -1) {
+				pr_info("Slot count cap must be larger than %d or -1 for no cap\n",
+					TEST_MEM_SLOT_BASE);
 				return false;
 			}
 			break;
@@ -1027,20 +1034,21 @@ static bool parse_args(int argc, char *argv[],
 	}
 
 	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
-	if (max_mem_slots <= 1) {
-		pr_info("KVM_CAP_NR_MEMSLOTS should be greater than 1\n");
+	if (max_mem_slots <= TEST_MEM_SLOT_BASE) {
+		pr_info("KVM_CAP_NR_MEMSLOTS should be greater than %d\n",
+			TEST_MEM_SLOT_BASE);
 		return false;
 	}
 
-	/* Memory slot 0 is reserved */
+	/* Memory slots below TEST_MEM_SLOT_BASE are reserved. */
 	if (targs->nslots == -1)
-		targs->nslots = max_mem_slots - 1;
+		targs->nslots = max_mem_slots - TEST_MEM_SLOT_BASE;
 	else
-		targs->nslots = min_t(int, targs->nslots, max_mem_slots) - 1;
+		targs->nslots = min_t(int, targs->nslots, max_mem_slots)
+				- TEST_MEM_SLOT_BASE;
 
 	pr_info_v("Allowed Number of memory slots: %"PRIu32"\n",
-		  targs->nslots + 1);
-
+		 (u32)(targs->nslots + TEST_MEM_SLOT_BASE));
 	return true;
 }
 
-- 
2.53.0

