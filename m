Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250663D47BB
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281464; cv=none; b=TttR/jD/CoC3Wp8XiV6adQRE2tTchoOnhovVQWRgz9QVLvDYG5+QkoRb6taXCaDTRAgkDfn0pHs4a9qcoZkjiNnv1Xt1jSAr8i/lJvTbZs4v71q8fnZ+5pr66nSMDupRXII6hKcDBE6PSTLuIJmc5vbnyuqaktgLLzH4aYh7QqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281464; c=relaxed/simple;
	bh=KmMepa6SILU+p5gEjwRcDM4ZL8kxCOFddSZl35hjD5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4A22fOvckmMiVop1hQj5XXMXffoUmR0Wgdbjgumhi8mz7VAqgisvGD7km1nQwt+tTqIViWGVX43XOjilPoqVAb8tJOvApln9WD76IFXUeVZHldxKLW4Ww5lRXdXQXpGjOOsfQ4roJJk35/uEeMXmVPYU2XN8dY+4k0Wztr4vjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rt2Ny5Fp; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rt2Ny5Fp"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-491b390f9e9so4948835e9.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 09:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781281458; x=1781886258; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tuh44YqrjzSlLd6mm7aQwU0y2sKDDLs9iqICVctwKS8=;
        b=rt2Ny5FpOhj1kt7BO4okgMsTvesSjJk07r6ncyJN9jwgHUAIjtN8KOYa9wpO7MYMm6
         mzUGqP4q2jM1X5NSHBL+/nzoePeIhPmEMvkpDpneQuMme///qYtngvducuAgX4uAl2wG
         C866uSajnVcaWKuGNO6JUM0BFEOCHlRqU4FIo704qVIVQN3Bd+UKo4V7YAmmPBiEdDF0
         0Cjse9YO2UQ2/8OKJtN9yGYBf6cVjvBVJepxO1zRBCtsJz6UTp27xBbQfFYViHqC/pR9
         NPyc9w7WZBXqUEY/sx0biqAZIw1vM5KZzT7xKg8CN55UHc6Uz1EF3lTFMxnPjUbtf4Lm
         H2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781281458; x=1781886258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Tuh44YqrjzSlLd6mm7aQwU0y2sKDDLs9iqICVctwKS8=;
        b=kVFFHOYso2JHBN5VuEzPXLVqwFtYEv4Z9ybkkPRQ8ep9TIYM4YdLeCjwsPF1X+yQg2
         XWoMXjKQbTHXlntkXeUixVqMiB10YIZ2UzbzduTpHheKIU5AAbqfgQSrKfTF4io/PKv9
         TOexu8bJkNKM+nqpvSvePHYrcJgx9vl4DdEgTv+GdWtRDS4fC6rllj9jA6Gj6ShEVTfn
         RiMi9AkpS/CjTmmGeNusWhRfhbcd+xsbuvQo1T/r+57OGvvr5Ugm53UGM5GfZ2Li1vM8
         99xi61oW2oalJdyWNHJJ3DdwAYsl4OEVLdAOAEK0Nc2SI13HNU1uPjRuTCi/gx4RlC0A
         uCWA==
X-Forwarded-Encrypted: i=1; AFNElJ+9/XV52lCMnu/IKeHXAtMCybSC13StOArhdC9dZSuUEqWsyCnf+XWBwn1I4/f0SBqFc+CII+c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy125+hLQMkiRHj6GIy3LL/DRN5L7dfxRDIZw0VgQZMzeEkN38L
	QrnTQzYHc9OiAX1UA4LwutB4syh+KMqq98B/sQ5OnBccdR12RX0ZysuA
X-Gm-Gg: Acq92OGT7gjHC1gbD20VicE7h/lgapwhduektsHpyi1vE+U87e/YUoF/LOW4EjKaHEg
	K0GPYsDLb+PNjGX6yoJ6fiAoO4mnUFum90tmwAfBg7tAveWuzYSPeZ70cfu9n5CxQj8gOFZBdqy
	SnMkBidumErOasq9JihPx5sDYdwGJ2d1BD88JnQjDZXU5XW3cuJjaW2b8BDzEQf/Bs81xuQwqFG
	wr3c9EjfQ47H9QsJmK9+Kt344MYYmHdtSK2o6GEckAN3GlqTI7Nw/h0cj6vxY67LCbTA5TWSt+E
	Ek29jf+Tcj4V2OS/MU1VqkNIuhFwhSROW1LhDjCWCVnVlwCremdte4CONi1e87K8G3Ncw228n+x
	jNZ7GZ7puq2yOFseheXYG7hJ4owp/Zcw/10ND4Vi6CmJKbnmHzsa5XwVhcer5AkkK603rPpwAfQ
	vpAVDZKulKwacylmuapQ9DhLt5u1EWLPYHGDfs3DdwmY3RlLZGhVKyL+NsssukRA==
X-Received: by 2002:a05:600c:468d:b0:490:9588:bdae with SMTP id 5b1f17b1804b1-490ec4ee664mr53299705e9.18.1781281458289;
        Fri, 12 Jun 2026 09:24:18 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95c51dsm57620935e9.1.2026.06.12.09.24.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jun 2026 09:24:18 -0700 (PDT)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oupton@kernel.org,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	corbet@lwn.net,
	vladimir.murzin@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	isaku.yamahata@intel.com,
	Jack Thomson <jackabt@amazon.com>
Subject: [PATCH v5 4/5] KVM: selftests: Add option for different backing in pre-fault tests
Date: Fri, 12 Jun 2026 17:23:52 +0100
Message-ID: <20260612162354.73378-5-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260612162354.73378-1-jackabt.amazon@gmail.com>
References: <20260612162354.73378-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Add a -s option to specify different memory backing types for the
pre-fault tests (e.g. anonymous, hugetlb), allowing testing of the
pre-fault functionality across different memory configurations.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 .../selftests/kvm/pre_fault_memory_test.c     | 51 +++++++++++++------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 9f5f0d1a5db1..c850cf28e86a 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -45,6 +45,7 @@ struct slot_worker_data {
 	struct kvm_vm *vm;
 	gpa_t gpa;
 	u32 flags;
+	enum vm_mem_backing_src_type mem_backing_src;
 	bool worker_ready;
 	bool prefault_ready;
 	bool recreate_slot;
@@ -65,14 +66,16 @@ static void *delete_slot_worker(void *__data)
 	while (!READ_ONCE(data->recreate_slot))
 		cpu_relax();
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, data->gpa,
+	vm_userspace_mem_region_add(vm, data->mem_backing_src, data->gpa,
 				    TEST_SLOT, test_config.test_num_pages, data->flags);
 
 	return NULL;
 }
 
 static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
-			     u64 size, u64 expected_left, bool private)
+			     u64 size, u64 expected_left,
+			     enum vm_mem_backing_src_type mem_backing_src,
+			     bool private)
 {
 	struct kvm_pre_fault_memory range = {
 		.gpa = base_gpa + offset,
@@ -83,6 +86,7 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
 		.vm = vcpu->vm,
 		.gpa = base_gpa,
 		.flags = private ? KVM_MEM_GUEST_MEMFD : 0,
+		.mem_backing_src = mem_backing_src,
 	};
 	bool slot_recreated = false;
 	pthread_t slot_worker;
@@ -172,11 +176,13 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
 struct test_params {
 	unsigned long vm_type;
 	bool private;
+	enum vm_mem_backing_src_type mem_backing_src;
 };
 
 static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 {
 	gpa_t gpa, gva, alignment, guest_page_size, host_page_size;
+	gpa_t backing_src_pagesz, mem_page_size;
 	struct test_params *p = arg;
 	const struct vm_shape shape = {
 		.mode = guest_mode,
@@ -188,24 +194,28 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 	struct ucall uc;
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(guest_mode));
+	pr_info("Testing memory backing src type: %s\n",
+		vm_mem_backing_src_alias(p->mem_backing_src)->name);
 
 	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
 
 	guest_page_size = vm_guest_mode_params[guest_mode].page_size;
 	host_page_size = getpagesize();
+	backing_src_pagesz = get_backing_src_pagesz(p->mem_backing_src);
+	mem_page_size = max(host_page_size, backing_src_pagesz);
 
 	test_config.page_size = guest_page_size;
 	test_config.test_size = align_up(TEST_BASE_SIZE + test_config.page_size,
-					 host_page_size);
+					 mem_page_size);
 	test_config.test_num_pages = vm_calc_num_guest_pages(vm->mode, test_config.test_size);
 
 	gpa = (vm->max_gfn - test_config.test_num_pages) * test_config.page_size;
 	alignment = SZ_2M;
-	alignment = max(alignment, host_page_size);
+	alignment = max(alignment, mem_page_size);
 	gpa = align_down(gpa, alignment);
 	gva = gpa & ((1ULL << (vm->va_bits - 1)) - 1);
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+	vm_userspace_mem_region_add(vm, p->mem_backing_src,
 				    gpa, TEST_SLOT, test_config.test_num_pages,
 				    p->private ? KVM_MEM_GUEST_MEMFD : 0);
 	virt_map(vm, gva, gpa, test_config.test_num_pages);
@@ -213,14 +223,18 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 	if (p->private)
 		vm_mem_set_private(vm, gpa, test_config.test_size);
 
-	pre_fault_memory(vcpu, gpa, 0, test_config.test_size, 0, p->private);
+	pre_fault_memory(vcpu, gpa, 0, test_config.test_size, 0,
+			 p->mem_backing_src, p->private);
 	/* Retry the same range after the first prefault attempt. */
-	pre_fault_memory(vcpu, gpa, 0, test_config.test_size, 0, p->private);
+	pre_fault_memory(vcpu, gpa, 0, test_config.test_size, 0,
+			 p->mem_backing_src, p->private);
 	pre_fault_memory(vcpu, gpa,
 			 test_config.test_size - host_page_size,
-			 host_page_size * 2, host_page_size, p->private);
+			 host_page_size * 2, host_page_size,
+			 p->mem_backing_src, p->private);
 	pre_fault_memory(vcpu, gpa, test_config.test_size,
-			 host_page_size, host_page_size, p->private);
+			 host_page_size, host_page_size,
+			 p->mem_backing_src, p->private);
 
 	vcpu_args_set(vcpu, 1, gva);
 
@@ -249,11 +263,13 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 	kvm_vm_free(vm);
 }
 
-static void test_pre_fault_memory(unsigned long vm_type, bool private)
+static void test_pre_fault_memory(unsigned long vm_type, enum vm_mem_backing_src_type backing_src,
+				  bool private)
 {
 	struct test_params p = {
 		.vm_type = vm_type,
 		.private = private,
+		.mem_backing_src = backing_src,
 	};
 
 	if (vm_type && !(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type))) {
@@ -267,23 +283,28 @@ static void test_pre_fault_memory(unsigned long vm_type, bool private)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-m mode]\n", name);
+	printf("usage: %s [-h] [-m mode] [-s mem-type]\n", name);
 	puts("");
 	guest_modes_help();
+	backing_src_help("-s");
 	puts("");
 }
 
 int main(int argc, char *argv[])
 {
+	enum vm_mem_backing_src_type backing = DEFAULT_VM_MEM_SRC;
 	int opt;
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hm:")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:s:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
 			break;
+		case 's':
+			backing = parse_backing_src_type(optarg);
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -293,10 +314,10 @@ int main(int argc, char *argv[])
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
 
-	test_pre_fault_memory(0, false);
+	test_pre_fault_memory(0, backing, false);
 #ifdef __x86_64__
-	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, false);
-	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, true);
+	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, backing, false);
+	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, backing, true);
 #endif
 	return 0;
 }
-- 
2.43.0

