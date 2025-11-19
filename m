Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF8E371DD5
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 15:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763567381; cv=none; b=bgq4YbBcyAUGtvXiUGx0m5mva0rOlDLsOcV3+kem8tYn0zLxuXROHGwwXS1bcMsbTKO/l+WDjBYLQWpR9sp5+Vw5xTI2tVmJ55YO0EPKTd1ib+ei+6OGCYBZSF93IdTvStS5FE59PJ36id506wJL1NtN/GUulTKIf5hs8B3occY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763567381; c=relaxed/simple;
	bh=sTnGVg0SCaIrS4UjjUcMvcDbivW2KJoCD34GtIJku8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iANlOUkApk/azyHZaZo3APoNUBlCGMA3dZehZmCag3+tF/160riaVAvaGSICz7AF4Dzi3rYbzeIBOvDe5p7x+jny5A0Yy2YEEdCe4NEVvAVu/wSdq3EMwhoxbUQNSqZWchuCLz/UhJISAQ24HwsUH4zSAwB/t0NI6jCvdptGtkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B0Y1cB+Z; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0Y1cB+Z"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42b31507ed8so5580622f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 07:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763567377; x=1764172177; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxA90nGyzmSaiY6A5XGVLVAHyvsgTHRyJZyrvZboKIE=;
        b=B0Y1cB+ZfuhGKHa8Ek7YFiy10/Bn79k38QdWmQaqhN5G3gvwDvvoxOteibJlDGI7Bb
         NNqWVvaqQaDRDLaglC4f2uew9TjFwvRr5bNxKTEVr84rUHIy+fl1wwBcwV5Ogo7fEyQS
         h9nhKGZckmH7FBtAqaMiKzmRlvd8gzYpHHHFy1WkzVZh4wkEN+0LHnEZXYNnjiQVk00x
         1FLXkvOqgP00s3UZXAweqC6MHyL6hriWMqlaH4uwEBPwnTcyreZ3l9vmi4c81eeo2iwF
         ujM3Pj9tEv9OzJU1DQs87US+z1e0lRCv0lA4xUSeeajWNCcDKAQXeNdkvXWqw3z1NjRU
         zAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567377; x=1764172177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fxA90nGyzmSaiY6A5XGVLVAHyvsgTHRyJZyrvZboKIE=;
        b=B7FOfH57fcZuXw5NGtxlw25DDBtzgS+vnKtiHC1JRLhZXMWd4smUvq5575TBxuMd5L
         MBPWxr124vMWAKCX9dxLcn8/GKzWhrTj1nsiLGx10qt8N85X2W2DRoCtCyNB3U2XCfNT
         5Un96tC5dsp3TIk8JdvqabLZGZJ2WFz6WTTB6ijIKdY25E4W8XxsL298T/RYAya6rdyw
         TpKJvwzoCMBHBmEuJAGgs7Ggyh0Q861Cgddq3ST9HTIDlzO5Bw5kS6VqEoTlta3tKfOa
         ucipBZVZscbMRWQAyNSTeSOeeNqNEKGKu1hZb8TL/3WVUed9ieDv4+nrp/1t6Z62fIye
         MR/w==
X-Forwarded-Encrypted: i=1; AJvYcCUztNdqGsXeeRjXmou8JtsUBpd0Qcbyi2UHUks9MLkscZz7dWd2f89ifkh0351UKTepKGl2Y7I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYNjMFLA1qRHcZvB9DTxPBVlNtHunLZugFxwxvbnik/7ndvbcq
	vYEwVkuVFCS+fU/k62tfxsFxKDUz0N55YlzzMqWb81+FZBRDZM/8vn8n
X-Gm-Gg: ASbGnct7d3kszdX3ULnUHdrtn+NKgxdMsoViRW5hO/6HLNLylTwPUnUAbV32l4XhHlW
	Sk4DVmNBmNIwgH+Om3uQqCHpnDYYYhXNCqiGuLBSEZfv+L8u55bK1gkSTSzCkiVh++xRd1BOE5v
	GKVoY5L84f/boGHh22pHGWd4ipobhfGMYT8iHQXfY+9pz+pzXovPoeOnyxrXUcU9qhHTcE6+sWM
	e/aVeBtLlZ4XctDsFoArLjw1YUzOJuqP7CshfIfGM7+lB80XV1RBdRE+5Bd73kxLt1xlMB3h7/Y
	ghUhrpCQmAg8I8x4KbhfqMfID06L7de42hveungBVn+ZyNVOndaX1k9agFThuoVCqiDQBfU+fxl
	RDBZKmsYodV3yy94MTubqWeKUweN0xTsqcCag02Soux4RCK6QuXjFnnuOhxY/9uDpB7LeCDEgsO
	/C5wY5qE2CekNVym/REU+UGlr30Q2MIfSnD/1rNWELJO2Jfzrrd5mKDHhqOmZ6StaRgA==
X-Google-Smtp-Source: AGHT+IEHRSEOlV/PjXO/es3oQjzN6p04w3tM9GnKGrsmunlZpgWhO8lg57u4CtlSOr65Ov1n2stQfw==
X-Received: by 2002:a05:6000:288d:b0:42b:5567:854b with SMTP id ffacd0b85a97d-42b59394d6cmr19768291f8f.45.1763567376680;
        Wed, 19 Nov 2025 07:49:36 -0800 (PST)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.3.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42c9628ebacsm25969755f8f.30.2025.11.19.07.49.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Nov 2025 07:49:36 -0800 (PST)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	isaku.yamahata@intel.com,
	xmarcalx@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.com
Subject: [PATCH v3 3/3] KVM: selftests: Add option for different backing in pre-fault tests
Date: Wed, 19 Nov 2025 15:49:10 +0000
Message-ID: <20251119154910.97716-4-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251119154910.97716-1-jackabt.amazon@gmail.com>
References: <20251119154910.97716-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Add a -m option to specify different memory backing types for the
pre-fault tests (e.g., anonymous, hugetlb), allowing testing of the
pre-fault functionality across different memory configurations.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 .../selftests/kvm/pre_fault_memory_test.c     | 42 +++++++++++++++----
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 674931e7bb3a..e1111c4df748 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -172,6 +172,7 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
 struct test_params {
 	unsigned long vm_type;
 	bool private;
+	enum vm_mem_backing_src_type mem_backing_src;
 };
 
 static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
@@ -190,14 +191,19 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 	uint64_t guest_test_virt_mem;
 	uint64_t alignment, guest_page_size;
 
+	size_t backing_src_pagesz = get_backing_src_pagesz(p->mem_backing_src);
+
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(guest_mode));
+	pr_info("Testing memory backing src type: %s\n",
+		vm_mem_backing_src_alias(p->mem_backing_src)->name);
 
 	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
 
 	guest_page_size = vm_guest_mode_params[guest_mode].page_size;
 
 	test_config.page_size = guest_page_size;
-	test_config.test_size = TEST_BASE_SIZE + test_config.page_size;
+	test_config.test_size = align_up(TEST_BASE_SIZE + test_config.page_size,
+					 backing_src_pagesz);
 	test_config.test_num_pages = vm_calc_num_guest_pages(vm->mode, test_config.test_size);
 
 	guest_test_phys_mem = (vm->max_gfn - test_config.test_num_pages) * test_config.page_size;
@@ -206,20 +212,23 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 #else
 	alignment = SZ_2M;
 #endif
+	alignment = max(alignment, backing_src_pagesz);
 	guest_test_phys_mem = align_down(guest_test_phys_mem, alignment);
 	guest_test_virt_mem = guest_test_phys_mem & ((1ULL << (vm->va_bits - 1)) - 1);
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+	vm_userspace_mem_region_add(vm, p->mem_backing_src,
 				    guest_test_phys_mem, TEST_SLOT, test_config.test_num_pages,
 				    p->private ? KVM_MEM_GUEST_MEMFD : 0);
 	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, test_config.test_num_pages);
 
 	if (p->private)
 		vm_mem_set_private(vm, guest_test_phys_mem, test_config.test_size);
-	pre_fault_memory(vcpu, guest_test_phys_mem, TEST_BASE_SIZE, 0, p->private);
+
+	pre_fault_memory(vcpu, guest_test_phys_mem, test_config.test_size, 0, p->private);
 	/* Test pre-faulting over an already faulted range */
-	pre_fault_memory(vcpu, guest_test_phys_mem, TEST_BASE_SIZE, 0, p->private);
-	pre_fault_memory(vcpu, guest_test_phys_mem + TEST_BASE_SIZE,
+	pre_fault_memory(vcpu, guest_test_phys_mem, test_config.test_size, 0, p->private);
+	pre_fault_memory(vcpu, guest_test_phys_mem +
+			 test_config.test_size - test_config.page_size,
 			 test_config.page_size * 2, test_config.page_size, p->private);
 	pre_fault_memory(vcpu, guest_test_phys_mem + test_config.test_size,
 			 test_config.page_size, test_config.page_size, p->private);
@@ -251,7 +260,8 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 	kvm_vm_free(vm);
 }
 
-static void test_pre_fault_memory(unsigned long vm_type, bool private)
+static void test_pre_fault_memory(unsigned long vm_type, enum vm_mem_backing_src_type backing_src,
+				  bool private)
 {
 	if (vm_type && !(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type))) {
 		pr_info("Skipping tests for vm_type 0x%lx\n", vm_type);
@@ -261,6 +271,7 @@ static void test_pre_fault_memory(unsigned long vm_type, bool private)
 	struct test_params p = {
 		.vm_type = vm_type,
 		.private = private,
+		.mem_backing_src = backing_src,
 	};
 
 	for_each_guest_mode(__test_pre_fault_memory, &p);
@@ -270,10 +281,23 @@ int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
 
-	test_pre_fault_memory(0, false);
+	int opt;
+	enum vm_mem_backing_src_type backing = VM_MEM_SRC_ANONYMOUS;
+
+	while ((opt = getopt(argc, argv, "m:")) != -1) {
+		switch (opt) {
+		case 'm':
+			backing = parse_backing_src_type(optarg);
+			break;
+		default:
+			break;
+		}
+	}
+
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

