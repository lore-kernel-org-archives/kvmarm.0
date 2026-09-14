Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F62470E8E;
	Mon, 14 Sep 2026 12:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388868; cv=none; b=JLsE5iYcJlJ8v39oq8ON7+HRwLpeYkxUD2u57uHeJZDKmw186N7GD21DbhY/s1cTcmztU9Y02+S3W4VnOW/xezIFkwrmgZARgCixaRZJFIrXBh0GKsLsq9tR9PRrYPG/Mkp/bIs8NZmYdqEsqYHj9bHP/I9L/TPk8zhR5kR1TR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388868; c=relaxed/simple;
	bh=2mli7Z7Iv34/jPztedKMCf45PGYRXNpv3Rf35FR6iow=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nepcoqMSBpyXwH4Euj1KgM6yiQbsn73G34lQ48hlExODtSWHh4r9mU7DdxUAIXXh0xS4ZxFqRHXdcnBXI6BbUdiJt/g0lUeIiygHdlsrb1+aAdE1asrPBH5rLPNoEsg0uUX9mwzpUwYSPVurnn6PtVYlafrxUCzkZqnGE9G9vDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Io6C9H8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Io6C9H8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774451F00898;
	Mon, 14 Sep 2026 12:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388866;
	bh=cRk7lD7czZ0zVPvtZdVAKc/8RTbrtJAsMOSGvFeFLfA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Io6C9H8n9TBJSPWspiFAo4lj1AINIU5qLH1BKYRpxfVkGRoRYiRDWGsydFbA4hwOP
	 gXA+w75D6VyzBIb0ctScuhgE10mfZMR4qKwro2zsNcDjD8IVexr8IphkqIfC3KTh3n
	 a/F3aASjPhZvmvcTvfjj/8AyNCLIP8q+azBQndoVerdhMFnyjjO+K2/Ehn/frT2teC
	 aNQalNRhW0YPgonsDXqQFmsDfWxAQMjHo0XBdlK9XQjK0xoT5avqe2oe+wAUbSsLb7
	 6FRmkna9r4nX1SvlgpM/HnxJWlk37ij7y+KRYzHFCo7vl6/ZASm3No4eoRECwRBEMC
	 zvc4qQrLmvz/w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 13:26:23 +0100
Subject: [PATCH v2 12/13] KVM: selftests: Add option for different backing
 in pre-fault tests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-kvm-arm-prefault-v2-12-26fb47f74b73@kernel.org>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
In-Reply-To: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6683; i=ljs@kernel.org;
 h=from:subject:message-id; bh=PO6VwHVzr1ywPi/wKPjgqxPqz8SXyRcry63dvjVJNh0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWP/8mKO3QFf99W7Ygx8yTbd163+edFzraVFBd8G3ep
 7VXPdrsOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARyyKG/w6X1zl/X7F21o9o
 X5NtyWzZ9YInPhsvP8P3esqJAuZ/3xUZGQ50OxVw3X9wQj/VIOhEWKbjC72gd4HTnStZ3xtafxZ
 eygkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

From: Jack Thomson <jackabt@amazon.com>

Add a -s option to specify different memory backing types for the
pre-fault tests (e.g. anonymous, hugetlb), allowing testing of the
pre-fault functionality across different memory configurations.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 .../testing/selftests/kvm/pre_fault_memory_test.c  | 51 +++++++++++++++-------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index ee77c51cc566..702c72bbfa96 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -46,6 +46,7 @@ struct slot_worker_data {
 	struct kvm_vm *vm;
 	gpa_t gpa;
 	u32 flags;
+	enum vm_mem_backing_src_type mem_backing_src;
 	bool worker_ready;
 	bool prefault_ready;
 	bool recreate_slot;
@@ -66,14 +67,16 @@ static void *delete_slot_worker(void *__data)
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
@@ -84,6 +87,7 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
 		.vm = vcpu->vm,
 		.gpa = base_gpa,
 		.flags = private ? KVM_MEM_GUEST_MEMFD : 0,
+		.mem_backing_src = mem_backing_src,
 	};
 	bool slot_recreated = false;
 	pthread_t slot_worker;
@@ -173,11 +177,13 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
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
@@ -189,24 +195,28 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
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
@@ -214,14 +224,18 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
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
 
@@ -250,11 +264,13 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
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
@@ -268,23 +284,28 @@ static void test_pre_fault_memory(unsigned long vm_type, bool private)
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
@@ -294,10 +315,10 @@ int main(int argc, char *argv[])
 
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
2.55.0

