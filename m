Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321441474B3
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041267; cv=none; b=DSvncS7jK7QlPtJ8+LyaLxQKvyvsZfK3zeWMBDFRhlNbqgCfdml+3d6Vn84UAMUJsdoIvtTsiLoLMjvqyyA9pcCti/Q6OKNyn+BJenxQ+pZ54eXXoz03+Cz69eSFk2zS21YGshmM7W0EgNUPV3kNzDifg0SRVlqLeaSqXyOeGzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041267; c=relaxed/simple;
	bh=7F0hdUQkgcbLnNEOLN45aw7eBCRbULVKfec0j/XaDOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IR8Ijyl06s5f2ECBBlML1lXH7smpDYUzetsYvb64UHYL9bMhQYD7zWWX3jagos29IZ5ScOAfHJRH5mry3ycjA6pcSFzeoLJT33Hh10AkU42tkgVJoWAQrbGNjBmJegz2MOWAN3JpV0CA4r8PqL30lo1+5GZ9OzHzVURjV3tYZ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UMe5SfJC; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UMe5SfJC"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc74ac7d015so1989679276.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041265; x=1708646065; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pZ3z5wuWWtoz1ZMhcdaCZuytQaO+bHVR4Pertr9jsQQ=;
        b=UMe5SfJC9Vp56yaaO+/CHgHEtTTvN3M6znYcyGX0uGsWBvi8IVOCsXlNJO6QUnKpjo
         Fr5B3dm+8BnjmAaWgA6Bf3bONcT5Fx+XkHT6jhsCQ09Q7JvMjE10NGyJ8X/pYLZ/sOwt
         PuMz63Y0aVescPeUWVUDgBj8Nn/WqX014j1jZXmzkwELpq/yednJfaPOUkiiLs1HSEvp
         oqZkdAcL6HpOOCVpq+U44ZX61eiBxBeKk15TXSXW9pnDm8NrA0lmXJZgyNime2ED89eW
         7ovM2C6xXTkOABMdfJumla5NmzdI8HN2PnIIrkCr3d0UrWXwTai7G/68TO3sxZvlQKFD
         m8Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041265; x=1708646065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pZ3z5wuWWtoz1ZMhcdaCZuytQaO+bHVR4Pertr9jsQQ=;
        b=LKn6NgKHrGJ5hNCtbyJoxRIzEoWoZL3W3ZhoJFqX+ojd6dZSJAlziDMdHbuOp87jlK
         NMGwBgYNOPEophtMyOY3xRq7/tzn/inhsvmwoTdjq3ZxA4UjG0Ggkf5WDchmp3QZt+K3
         Of3HMh6gzgpDU8+g1rFqdWsVLt85A17pVECIfI2C7himjYuX1FmrTPnt0t65SoEtiQ7W
         uccTgyecKs5+wf304lfagNPI+AOrL+L6E6SDikhrS695jMWr8m5ivcyj8wpQ80Dh/uAC
         +sVOeM7U+d0JktkbDOAWaSpHn/bNP0k+nu68WCAMQeWEaWHJAvFV5yA/3V5kCz91KJoj
         DNkg==
X-Forwarded-Encrypted: i=1; AJvYcCXkGL+DxDuTLCYK/WDKl9klGoOjhZ19TO4jgmHyBt/oRohxBz9hrb970qtH8/lBYwJ9qkUi3H8JIdeJgfnDJuKyriczuj24
X-Gm-Message-State: AOJu0YwuEvYDMbKjk3UE36NA+LRVHRAu+zocwyHASikJA+kjOei/lHig
	SfaSlK9gJ77Lkb4t2i04YM2u5njIRjFdFykmqU8Wju0rSNsILyJ+GP0asnkmjfdxMN9Q/ifCPP9
	ryp3bIh4F0A==
X-Google-Smtp-Source: AGHT+IEUZwP+LJ+E+jxNEEZlreKraG2jY/8zcXTmmfUSkAeCJVN8Cnv8dxS1QjyGU3QmLdYMdQnNWZ+EgajasA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:9846:0:b0:dcd:c091:e86 with SMTP id
 k6-20020a259846000000b00dcdc0910e86mr128874ybo.13.1708041265304; Thu, 15 Feb
 2024 15:54:25 -0800 (PST)
Date: Thu, 15 Feb 2024 23:54:04 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-14-amoorthy@google.com>
Subject: [PATCH v7 13/14] KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Memslot flags aren't currently exposed to the tests, and are just always
set to 0. Add a parameter to allow tests to manually set those flags.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c       | 2 +-
 tools/testing/selftests/kvm/demand_paging_test.c              | 2 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c             | 2 +-
 tools/testing/selftests/kvm/include/memstress.h               | 2 +-
 tools/testing/selftests/kvm/lib/memstress.c                   | 4 ++--
 .../testing/selftests/kvm/memslot_modification_stress_test.c  | 2 +-
 .../selftests/kvm/x86_64/dirty_log_page_splitting_test.c      | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 3c7defd34f56..b51656b408b8 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -306,7 +306,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	int nr_vcpus = params->nr_vcpus;
 
-	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1, 0,
 				 params->backing_src, !overlap_memory_access);
 
 	memstress_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0455347f932a..61bb2e23bef0 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -163,7 +163,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	double vcpu_paging_rate;
 	uint64_t uffd_region_size;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1, 0,
 				 p->src_type, p->partition_vcpu_memory_access);
 
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index d374dbcf9a53..8b1a84a4db3b 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -153,7 +153,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int i;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
-				 p->slots, p->backing_src,
+				 p->slots, 0, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
 	pr_info("Random seed: %u\n", p->random_seed);
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index ce4e603050ea..8be9609d3ca0 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -56,7 +56,7 @@ struct memstress_args {
 extern struct memstress_args memstress_args;
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes, int slots, uint32_t slot_flags,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access);
 void memstress_destroy_vm(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index d05487e5a371..e74b09f39769 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -123,7 +123,7 @@ void memstress_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 }
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes, int slots, uint32_t slot_flags,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access)
 {
@@ -212,7 +212,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    MEMSTRESS_MEM_SLOT_INDEX + i,
-					    region_pages, 0);
+					    region_pages, slot_flags);
 	}
 
 	/* Do mapping for the demand paging memory slot */
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 9855c41ca811..0b19ec3ecc9c 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -95,7 +95,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = arg;
 	struct kvm_vm *vm;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1, 0,
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);
 
diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
index 634c6bfcd572..a770d7fa469a 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
@@ -100,7 +100,7 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	struct kvm_page_stats stats_dirty_logging_disabled;
 	struct kvm_page_stats stats_repopulated;
 
-	vm = memstress_create_vm(mode, VCPUS, guest_percpu_mem_size,
+	vm = memstress_create_vm(mode, VCPUS, guest_percpu_mem_size, 0,
 				 SLOTS, backing_src, false);
 
 	guest_num_pages = (VCPUS * guest_percpu_mem_size) >> vm->page_shift;
-- 
2.44.0.rc0.258.g7320e95886-goog

