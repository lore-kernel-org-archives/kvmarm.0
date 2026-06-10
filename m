Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7347621C9EA
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052828; cv=none; b=LRfPVDlrc1uvfTTtOma8MR5RfKrir+Uyv6QZSWm9RQDmfMimTs/Jkgrk3d+wM7TGZaNj2bCEDtJwstVfZdhE63JdVbMd82VlasVnq9nlsCUns4Zkfd0wE3RLtzhwlyNKsJVKk/p8gM6k48InZFNKCTdCtRYdNq9yVLF6PqcwNaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052828; c=relaxed/simple;
	bh=Kub5eQ7O/mtG75/OYJ/I1Cabb/JLl9Pdz2YqhISQBWM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F3hu16+VCOgfCKwJoW8n7rS77h/HD6i3JNRcVOEKEcFg0JP2oV1yvuE1WVHCqC0WfX8+XTx9UhXlfdg5BiOGpVhw0cLR/Y8Q24vBc2NolUqyQl5FojBd/mBKt76WuelS5iff5Hgc728Os3fryWntGzZkBzk7b7nWX97EnKZznQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DGkh0D6X; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DGkh0D6X"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c0c32f4b1bso63409165ad.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052826; x=1781657626; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tOfKL3aC3TJI7zJE4ow9XI3oPw5OgYVgulJRJ35YFpw=;
        b=DGkh0D6XGfZgH3qTTLubtChkN1jM1LhfHBAERdWgkEdF6B+8MdlD24AAhs0eadRuWU
         anUH860X2Bt+cyKYT31u3KNQhZ3Urt8qkLHlDjbsTg9yDpckCRpP46s9K8Ieo7sFJQ9s
         yx4gOdEAOhZ4noiM4nxtxY5sV4MSX1EMWiqdu/3WTZABGQE9mTST+5nZtI3GFMsF4nnz
         Az9ig5F3sSqNww9X7U0B2IOAb4naFNZv5wt+NhRnd27SjZLeyeNvvxF+1sui305GK0eO
         ijf4wXeftgaLv75GJ7zwUsc1tGLWYmCOYP5NsAbX9xwvlHqpOqmt1nJqBP4i5hf+v/7u
         amBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052826; x=1781657626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tOfKL3aC3TJI7zJE4ow9XI3oPw5OgYVgulJRJ35YFpw=;
        b=cInK523d09qNSUBGXZsV7T5HOIeADNHDR99tKVUQO952/mzmJcQD+PKC84/TP8sR9P
         IDi8ZEfE8bUc7wkzpLkEfUPgQOp8+yYTENs1kL6e20frwJ4RQnjjgi/yD5e/BCSPtdBz
         9jJ3+UT1ZJChGVBbU343JTJ2vgc6NGh+PcYxaLunvZv1E3BD+F+l0+vKXUyMTsupLwEX
         Ah5g2oLkt/WMX398lxLH4X91a0C+eJ9BUECe+w1wZwcc0W8U14eaRRWFQJMzOSbZaotp
         4f1zbCzMcxVa7lESwrV2gOb4xF0W0p8g+3n+NEuU5Tp1/FMDX9d7ShmJQAIgYYCvIspS
         bMrg==
X-Forwarded-Encrypted: i=1; AFNElJ/O9wRi3dUXJ3snXsthSyp2v8tQW0TtjY3/e/tC4CbkUvSjwFXnei3p0zioCdlfDp3J/NmL4WU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqOk588sazxInfQoFqZJrJ8rQB6O73uHOV8pOwV31NzyPY468V
	VTKrnl7dCQyHnR4icBAZmic5Hjjy8JXD7w2lvRJ0/hiwRLj+dCmj1vqxrcOLAO2Wws7kqiAmpPf
	zlm2mQA==
X-Received: from pfbmt10.prod.google.com ([2002:a05:6a00:6e6a:b0:83c:61b2:176b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5787:b0:368:147f:bd27
 with SMTP id 98e67ed59e1d1-370f0d52f5cmr24860811a91.23.1781052825537; Tue, 09
 Jun 2026 17:53:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:23 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-4-seanjc@google.com>
Subject: [PATCH v6 03/18] KVM: selftests: Rename guest_rng to kvm_rng
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Josh Hilke <jrhilke@google.com>

Rename functions prefixed with 'guest_random_' to 'kvm_random_' and the
global random state variable 'guest_rng' to 'kvm_rng', as the pRNG isn't
strictly limited to guest code.  This will allow using the pRNG in host
code without creating confusing/misleading function calls.

No functional changes are intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       |  4 ++--
 tools/testing/selftests/kvm/dirty_log_test.c  |  2 +-
 .../testing/selftests/kvm/include/test_util.h | 22 +++++++++----------
 .../selftests/kvm/include/x86/kvm_util_arch.h |  4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 20 ++++++++---------
 tools/testing/selftests/kvm/lib/memstress.c   |  8 +++----
 tools/testing/selftests/kvm/lib/test_util.c   |  6 ++---
 .../testing/selftests/kvm/x86/sev_dbg_test.c  |  2 +-
 8 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index ef779fa91827..7c5abe1ae9e0 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -311,7 +311,7 @@ int main(int argc, char *argv[])
 	int opt;
 
 	/* Override the seed to be deterministic by default. */
-	guest_random_seed = 1;
+	kvm_random_seed = 1;
 
 	dirty_log_manual_caps =
 		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
@@ -357,7 +357,7 @@ int main(int argc, char *argv[])
 			p.phys_offset = strtoull(optarg, NULL, 0);
 			break;
 		case 'r':
-			guest_random_seed = atoi_positive("Random seed", optarg);
+			kvm_random_seed = atoi_positive("Random seed", optarg);
 			break;
 		case 's':
 			p.backing_src = parse_backing_src_type(optarg);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 087e94a8a81a..e8419d7da1ea 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -121,7 +121,7 @@ static void guest_code(void)
 	while (true) {
 		while (!READ_ONCE(vcpu_stop)) {
 			addr = guest_test_virt_mem;
-			addr += (guest_random_u64(&guest_rng) % guest_num_pages)
+			addr += (kvm_random_u64(&kvm_rng) % guest_num_pages)
 				* guest_page_size;
 			addr = align_down(addr, host_page_size);
 
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a56271c237ae..44c0104d60ac 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -108,30 +108,30 @@ struct timespec timespec_sub(struct timespec ts1, struct timespec ts2);
 struct timespec timespec_elapsed(struct timespec start);
 struct timespec timespec_div(struct timespec ts, int divisor);
 
-struct guest_random_state {
+struct kvm_random_state {
 	u32 seed;
 };
 
-extern u32 guest_random_seed;
-extern struct guest_random_state guest_rng;
+extern u32 kvm_random_seed;
+extern struct kvm_random_state kvm_rng;
 
-struct guest_random_state new_guest_random_state(u32 seed);
-u32 guest_random_u32(struct guest_random_state *state);
+struct kvm_random_state new_kvm_random_state(u32 seed);
+u32 kvm_random_u32(struct kvm_random_state *state);
 
-static inline bool __guest_random_bool(struct guest_random_state *state,
+static inline bool __kvm_random_bool(struct kvm_random_state *state,
 				       u8 percent)
 {
-	return (guest_random_u32(state) % 100) < percent;
+	return (kvm_random_u32(state) % 100) < percent;
 }
 
-static inline bool guest_random_bool(struct guest_random_state *state)
+static inline bool kvm_random_bool(struct kvm_random_state *state)
 {
-	return __guest_random_bool(state, 50);
+	return __kvm_random_bool(state, 50);
 }
 
-static inline u64 guest_random_u64(struct guest_random_state *state)
+static inline u64 kvm_random_u64(struct kvm_random_state *state)
 {
-	return ((u64)guest_random_u32(state) << 32) | guest_random_u32(state);
+	return ((u64)kvm_random_u32(state) << 32) | kvm_random_u32(state);
 }
 
 enum vm_mem_backing_src_type {
diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index c33ab6e04171..6904dbda79f9 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -55,9 +55,9 @@ static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
 do {											\
 	const typeof(mem) val = (__val);						\
 											\
-	if (!is_forced_emulation_enabled || guest_random_bool(&guest_rng)) {		\
+	if (!is_forced_emulation_enabled || kvm_random_bool(&kvm_rng)) {		\
 		(mem) = val;								\
-	} else if (guest_random_bool(&guest_rng)) {					\
+	} else if (kvm_random_bool(&kvm_rng)) {					\
 		__asm__ __volatile__(KVM_FEP "mov %1, %0"				\
 				     : "+m" (mem)					\
 				     : "r" (val) : "memory");				\
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 195f3fdae1e3..875030c22d07 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -20,9 +20,9 @@
 
 #define KVM_UTIL_MIN_PFN	2
 
-u32 guest_random_seed;
-struct guest_random_state guest_rng;
-static u32 last_guest_seed;
+u32 kvm_random_seed;
+struct kvm_random_state kvm_rng;
+static u32 last_kvm_seed;
 
 static size_t vcpu_mmap_sz(void);
 
@@ -515,12 +515,12 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 	slot0 = memslot2region(vm, 0);
 	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
 
-	if (guest_random_seed != last_guest_seed) {
-		pr_info("Random seed: 0x%x\n", guest_random_seed);
-		last_guest_seed = guest_random_seed;
+	if (kvm_random_seed != last_kvm_seed) {
+		pr_info("Random seed: 0x%x\n", kvm_random_seed);
+		last_kvm_seed = kvm_random_seed;
 	}
-	guest_rng = new_guest_random_state(guest_random_seed);
-	sync_global_to_guest(vm, guest_rng);
+	kvm_rng = new_kvm_random_state(kvm_random_seed);
+	sync_global_to_guest(vm, kvm_rng);
 
 	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
@@ -2279,8 +2279,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	sigaction(SIGILL, &sig_sa, NULL);
 	sigaction(SIGFPE, &sig_sa, NULL);
 
-	guest_random_seed = last_guest_seed = random();
-	pr_info("Random seed: 0x%x\n", guest_random_seed);
+	kvm_random_seed = last_kvm_seed = random();
+	pr_info("Random seed: 0x%x\n", kvm_random_seed);
 
 	kvm_selftest_arch_init();
 }
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 6dcd15910a06..3599b75d97c9 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -48,14 +48,14 @@ void memstress_guest_code(u32 vcpu_idx)
 {
 	struct memstress_args *args = &memstress_args;
 	struct memstress_vcpu_args *vcpu_args = &args->vcpu_args[vcpu_idx];
-	struct guest_random_state rand_state;
+	struct kvm_random_state rand_state;
 	gva_t gva;
 	u64 pages;
 	u64 addr;
 	u64 page;
 	int i;
 
-	rand_state = new_guest_random_state(guest_random_seed + vcpu_idx);
+	rand_state = new_kvm_random_state(kvm_random_seed + vcpu_idx);
 
 	gva = vcpu_args->gva;
 	pages = vcpu_args->pages;
@@ -69,13 +69,13 @@ void memstress_guest_code(u32 vcpu_idx)
 
 		for (i = 0; i < pages; i++) {
 			if (args->random_access)
-				page = guest_random_u32(&rand_state) % pages;
+				page = kvm_random_u32(&rand_state) % pages;
 			else
 				page = i;
 
 			addr = gva + (page * args->guest_page_size);
 
-			if (__guest_random_bool(&rand_state, args->write_percent))
+			if (__kvm_random_bool(&rand_state, args->write_percent))
 				*(u64 *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(u64 *)addr);
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index bab1bd2b775b..e98ca7ef439c 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -30,13 +30,13 @@ void __attribute__((used)) expect_sigbus_handler(int signum)
  * Park-Miller LCG using standard constants.
  */
 
-struct guest_random_state new_guest_random_state(u32 seed)
+struct kvm_random_state new_kvm_random_state(u32 seed)
 {
-	struct guest_random_state s = {.seed = seed};
+	struct kvm_random_state s = {.seed = seed};
 	return s;
 }
 
-u32 guest_random_u32(struct guest_random_state *state)
+u32 kvm_random_u32(struct kvm_random_state *state)
 {
 	state->seed = (u64)state->seed * 48271 % ((u32)(1 << 31) - 1);
 	return state->seed;
diff --git a/tools/testing/selftests/kvm/x86/sev_dbg_test.c b/tools/testing/selftests/kvm/x86/sev_dbg_test.c
index a9d8e4c059f9..eaa8201b937d 100644
--- a/tools/testing/selftests/kvm/x86/sev_dbg_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_dbg_test.c
@@ -34,7 +34,7 @@ static void validate_buffers(void)
 
 static void ____test_sev_dbg(struct kvm_vm *vm, int i, int j, int nr_bytes)
 {
-	u8 pattern = guest_random_u32(&guest_rng);
+	u8 pattern = kvm_random_u32(&kvm_rng);
 
 	if (i + nr_bytes > BUFFER_SIZE || j + nr_bytes > BUFFER_SIZE)
 		return;
-- 
2.54.0.1099.g489fc7bff1-goog

