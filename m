Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AB8A93C
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 21:35:34 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-54f8b46f399so40047387b3.10
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 14:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335334; x=1683927334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Enih2OM3xwbE5JxqMI9mr7glLAzseUE52pRXsIPwpY=;
        b=LJSLx2GmrRRLif5bbLyYGFln1e+mukhuEhQ8NMHWImtHxszerqlY/NKn+zz1MUyL4g
         Rlbv9IpPwkTyJx8bnss02J6GJZz2JTwlgyaXgxqHU3tn4LkPOw11BCHr/ArqNWqOxIB2
         hHqqC6FrtyMb61n7b+Ls90p9ALsXIFcnVJa/q40H84E0KOXzBt6kpUTjEjtE+ocWlBdY
         RNd/SE0HnxV79jWKOBVBGLq8MMReIJ4+vmT4abRVkyAkKHk+1t/UXey6drvtWNdrlN4i
         um/lqceHm0LhijaKXqX57GaVUClwr+zMEqAwGOYFMXAvgIRufjrICOxdPvn8Hhik5V3Q
         3yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335334; x=1683927334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Enih2OM3xwbE5JxqMI9mr7glLAzseUE52pRXsIPwpY=;
        b=SRKuAkQo7n7+3GxolSZbsyiUOEiG19RdgkUpL0RbJfxDUFGGmbcZj/18rcBjEcFkSn
         RtegGyTimAbWCRGZhGCxMvZRCjMWa4BXFb4KA7GXqVzhscrxyoohhsrlVFzuMcEzh2di
         BJtuaUSBIv9RAQiCPBAnzvb8OcN2As7zMQ2gZKg+qdmBkpaGKhfCvr+qHXwF8ns4qQ+F
         nzq7+TaO+8omsA80n0XlE/ZToq3t/crP6618RbJ4gpqWyc/ctj9UcAvc4HaD4v6B9NjI
         O3bLMrEpc3Xb7OrolZSa6wsifub02UMr9QBypP4zELoTy4U1hztSgcAx4A23lDag5pHP
         1AYA==
X-Gm-Message-State: AAQBX9c0mBrvJVh79WDehZMr/+dcuNonMUSgEf+BvwetFTOEw+Dk3DCU
	42Ejuu4COmAuRzYIeVG7fBBqSnqxJnSSBw==
X-Google-Smtp-Source: AKy350ZFX3aP1qiu5losJdiyWVTYHetybhx9O9AbXDP6rP4+1JK6fQgdp+4BmbBKGbw0H30C9IftH48afs2buA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:3354:0:b0:b8e:f726:d198 with SMTP id
 z81-20020a253354000000b00b8ef726d198mr5949388ybz.8.1681335334026; Wed, 12 Apr
 2023 14:35:34 -0700 (PDT)
Date: Wed, 12 Apr 2023 21:35:09 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-22-amoorthy@google.com>
Subject: [PATCH v3 21/22] KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
From: Anish Moorthy <amoorthy@google.com>
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	amoorthy@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Memslot flags aren't currently exposed to the tests, and are just always
set to 0. Add a parameter to allow tests to manually set those flags.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c       | 2 +-
 tools/testing/selftests/kvm/demand_paging_test.c              | 4 ++--
 tools/testing/selftests/kvm/dirty_log_perf_test.c             | 2 +-
 tools/testing/selftests/kvm/include/memstress.h               | 2 +-
 tools/testing/selftests/kvm/lib/memstress.c                   | 4 ++--
 .../testing/selftests/kvm/memslot_modification_stress_test.c  | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 3c7defd34f567..b51656b408b83 100644
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
index c729cee4c2055..e84dde345edbc 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -144,8 +144,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int i, num_uffds = 0;
 	uint64_t uffd_region_size;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
-				 p->src_type, p->partition_vcpu_memory_access);
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
+				1, 0, p->src_type, p->partition_vcpu_memory_access);
 
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index e9d6d1aecf89c..6c8749193cfa4 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -224,7 +224,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int i;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
-				 p->slots, p->backing_src,
+				 p->slots, 0, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
 	pr_info("Random seed: %u\n", p->random_seed);
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index 72e3e358ef7bd..1cba965d2d331 100644
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
index 5f1d3173c238c..7589b8cef6911 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -119,7 +119,7 @@ void memstress_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 }
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes, int slots, uint32_t slot_flags,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access)
 {
@@ -207,7 +207,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    MEMSTRESS_MEM_SLOT_INDEX + i,
-					    region_pages, 0);
+					    region_pages, slot_flags);
 	}
 
 	/* Do mapping for the demand paging memory slot */
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 9855c41ca811f..0b19ec3ecc9cc 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -95,7 +95,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = arg;
 	struct kvm_vm *vm;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1, 0,
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);
 
-- 
2.40.0.577.gac1e443424-goog

