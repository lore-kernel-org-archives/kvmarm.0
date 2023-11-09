Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E9E39858
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S/gJdVPu"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-da033914f7cso1623729276.0
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563837; x=1700168637; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2a/M+0Fr1PqC5kgKOfRG5N8I8zu921PMSouy8YMa7RU=;
        b=S/gJdVPu/IZk8E3FjT18grI9Ka4RHn7qNnmZ6+8mvU2bk7Xo2q2kpAL1ea6ArP7fc0
         dn2BUtVBqMkWgQuoy5uAqTLVCioD/RAfAIusIzJX+eUgGiFgmwFtLq2/VqgWjxwCb225
         V3tbksa17G8lsr5SgQgt6MI52mhFY/Sx3n6y+onWg/qj/ZkVU5ap6N+FOoSVhXqZ4g6D
         kNqznizVBrhmSPQ14dFKGek9+ypYRl8HUBm9GhSD++98nkcwbQflnUPz9/PZ50/aOcTU
         cG7UCy/yeFIPWu+KDeEIIGwbhdv6vJduVLCQH6S02U1LreKt4rqQgvVYze9FduqbHJE8
         pfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563837; x=1700168637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2a/M+0Fr1PqC5kgKOfRG5N8I8zu921PMSouy8YMa7RU=;
        b=I79+Zo7KBfHJywW8a2ncUuK/1iB0t6jFBltXsKEPYVcL125k+w1QCkSLcXlaih/aE9
         O0Y5oDfhsNaqUS3I76ytdTxtLGjxDf59patWoM67HBeCegBVFrqNnZIVXM8M1eWhFvyO
         Aatk8PW1RtZ0rRlGjce0Q3+2GTSZCrd0z5j1zAjVRJrdtYgkfMMrQC4vfFDjArM7IafR
         7EQRGP5B0NixrsFRNt2Ohcl4uMqutqKC6AY7c40xJEyhguMr87XHHKVfYb7FPuTVSS5q
         jm2ojtz5/GTldAaR+23Ig1HpZZ39h+U+FRehZWa23hCG5w3yMWiVO4Q+xAgzPyLaU52e
         B9bA==
X-Gm-Message-State: AOJu0YxezlZLA4xhhR/J92bKsD1LdhxdRRVNfpuIwbn5Mg4E41+8IlL0
	HJNp0EDKDSKUKex8OABFAkFpW1atdKe7Eg==
X-Google-Smtp-Source: AGHT+IGkRtZ0otuvawnXg3FnB/DDPqjO//IWJIG3gi/q13j0FI8C9+TJy7xo5m2vn9PLkCfKS8hq9ldNvIQW3A==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:800c:0:b0:da0:48e1:5f46 with SMTP id
 m12-20020a25800c000000b00da048e15f46mr166858ybk.9.1699563837558; Thu, 09 Nov
 2023 13:03:57 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:24 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-14-amoorthy@google.com>
Subject: [PATCH v6 13/14] KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
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
2.42.0.869.gea05f2083d-goog

