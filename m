Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AD73939BE
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 15:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768318083; cv=none; b=GdvVz7qhtnNnDvAuKw/MOgf4RELQ2Vi1Xo9dOohlPin3C5s+8Ioo1MCzY/psI2z1FnMh6ljj5yGWW0FI3WWDgfgljwZ7S2X2WvUwCLoKnoYYEanW1vIwGIjDcx/y/NDkDLxP2OKVR+NvJrg6ka9gvz8f0Zuwo+pynDvI3dASa2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768318083; c=relaxed/simple;
	bh=XoO5KMHdnpZAZi99zA/PXMxt1/PSOD8GRG3MV4pqspk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nj7fOmu00799V0kT6V4zogpQlcsfyhPv2PW6dGj8h0JPVdKHXJZ7sEwnGxZ8Q+VkA/QtFiKIPxjLERlBleZHf9CRhPcHF37w/l09mmS7l71HfBltny0uqUDyp9vbnsciD/ne4J9VXM+Eem4ElibwLHWvS/UWJet6OPSpmA/pv2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KtZA0lGX; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KtZA0lGX"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47774d3536dso56925975e9.0
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 07:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768318065; x=1768922865; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ClV6xb3uKauwGoOx6LpIuCiwNxs8C5+P0pKaRtPxBMQ=;
        b=KtZA0lGXpZu91DNQ308+x6ac5j9ADjuHwr9fV7Ov0/NmpbygTkjmv7V9qjByXthjHe
         HfJCTYkQrncl7AXj0JsMcv0bTfhLMMOU6gT/LMzvyp/3ab0iJ6fpxNi7JGlkd1aNkCn6
         aABZDG9A/lw4RH9wf7yjsd7iEsWR3gxmH9tDjFg4mvBxt/BpyFPcpqNil2gJZGF5Ku8X
         VTQelwbHm2ngIbumX2Fp8QeeZk20z+n0W1DIH3eojCo3D6q4a/eFJnHSZEbUXg2vM4M0
         DPckFwgN9yXillg2CUd3fzkDaY9Uq6EZa5LvCOKIxBwCIMRDfdJX3gsbNwhIfzk50ELL
         BHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768318065; x=1768922865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ClV6xb3uKauwGoOx6LpIuCiwNxs8C5+P0pKaRtPxBMQ=;
        b=wtvASCAHWAPB3CPBaEc/jRp6jYe3TeuBcPh6TBtRPNA65nuD1F+qGk1Y7Ju/ZWMS2g
         jdx/4TcgbFIqElmCCB6HwIP65HjwlWzJIda/gzVO4vL94VwmX/e7ayvIEyN1TQzjoo1y
         i5SahDUiVJWuaq165D21VyryPPpAwqgr+UOImoSoxzUjQqSqCQOICHFHx9kMrKaKwgi5
         KHw+BiRL3hpQcVbwsl4i7kdzHFnxb7WuU8iBWxZxXeV3bGoUccrf1VWHicRJxuKjBR32
         u8ntJieernHN5iLkpBzmHC8dfO/W63CKZQIVF/ydC1/WnSXx+iKzvd+IinlsRbzW7HCC
         kC9w==
X-Forwarded-Encrypted: i=1; AJvYcCViCbdiextN1gMyR279BsHnzL70zBcoU7fCxzMvJ3AQoeKj+/aME1v6eoMTnom3BYSaFo9c5fM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhQDtTaUBSZaoJBd9NVHUpcRSj6FWwzcPlL+9lQaiSnoUWj2qM
	R/a1IYVWKj678/LvSJzVAOtBQ/1lxZWBsLtnjPL63r1XZ/6hdXqG/c+E
X-Gm-Gg: AY/fxX464/MUIoBCLWKH0q2Dos/+HqRuBbYUzlyLCeoT5zwzg4xLJpktvqI5YzvIMSV
	VxsAW5jH5iTaWVmtAfl84FMXijOmPSQK3uLDDUe8WAlCO7J/COs3TPRuVcj4rUPHYIkrpagAYeD
	+LeM1RsJbpiOR+YmofnGKkrp259iSiVJuRsmepFnGVWS49o1yfw8W/t5e+SHdzGbkDEo0fKaa8K
	yJTSPy3W0jIlcSJQZp3N/eclGAWAu+ikQsLmY1yVx6LpbJPYkr9R2OkccIePyfPTivIK0xt3fam
	UPRsHHsEwBr28yz1vXjL/Wyd0heAonuD2ULS8P3po5dtFHfhHCaudb4zVCHZBBubK1bw8aOlJab
	XO+yiGrPNEO82JBYEsBzWVtd2rRpXOtYF5NZi3P3JFEEnFAF1h0cxRsrOw5iwSWSosmwolSEkv8
	K1usO9gHb2cjaDiiw4tjMMMElBQ/PeXfHRQ/9NNvNDS7l6/8rDHWS9zOTRLZZcw48L0w==
X-Google-Smtp-Source: AGHT+IFPYD4aUkgLw+ElK2nCfQAn3fMA8ZdORSxU/HjmPMO8JbFroHKdhuJYQgeH2rPGmtTppuBJ8Q==
X-Received: by 2002:a05:600c:1391:b0:477:a219:cdc3 with SMTP id 5b1f17b1804b1-47ed7cccaa3mr41796735e9.12.1768318064610;
        Tue, 13 Jan 2026 07:27:44 -0800 (PST)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f68f4ddsm421025325e9.2.2026.01.13.07.27.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 07:27:44 -0800 (PST)
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
Subject: [PATCH v4 3/3] KVM: selftests: Add option for different backing in pre-fault tests
Date: Tue, 13 Jan 2026 15:26:42 +0000
Message-ID: <20260113152643.18858-4-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113152643.18858-1-jackabt.amazon@gmail.com>
References: <20260113152643.18858-1-jackabt.amazon@gmail.com>
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
index be1a84a6c137..1a177f89bc43 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -172,6 +172,7 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
 struct test_params {
 	unsigned long vm_type;
 	bool private;
+	enum vm_mem_backing_src_type mem_backing_src;
 };
 
 static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
@@ -187,14 +188,19 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 	struct kvm_vm *vm;
 	struct ucall uc;
 
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
 
 	gpa = (vm->max_gfn - test_config.test_num_pages) * test_config.page_size;
@@ -203,20 +209,23 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 #else
 	alignment = SZ_2M;
 #endif
+	alignment = max(alignment, backing_src_pagesz);
 	gpa = align_down(gpa, alignment);
 	gva = gpa & ((1ULL << (vm->va_bits - 1)) - 1);
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+	vm_userspace_mem_region_add(vm, p->mem_backing_src,
 				    gpa, TEST_SLOT, test_config.test_num_pages,
 				    p->private ? KVM_MEM_GUEST_MEMFD : 0);
 	virt_map(vm, gva, gpa, test_config.test_num_pages);
 
 	if (p->private)
 		vm_mem_set_private(vm, gpa, test_config.test_size);
-	pre_fault_memory(vcpu, gpa, 0, TEST_BASE_SIZE, 0, p->private);
+
+	pre_fault_memory(vcpu, gpa, 0, test_config.test_size, 0, p->private);
 	/* Test pre-faulting over an already faulted range */
-	pre_fault_memory(vcpu, gpa, 0, TEST_BASE_SIZE, 0, p->private);
-	pre_fault_memory(vcpu, gpa, TEST_BASE_SIZE,
+	pre_fault_memory(vcpu, gpa, 0, test_config.test_size, 0, p->private);
+	pre_fault_memory(vcpu, gpa,
+			 test_config.test_size - test_config.page_size,
 			 test_config.page_size * 2, test_config.page_size, p->private);
 	pre_fault_memory(vcpu, gpa, test_config.test_size,
 			 test_config.page_size, test_config.page_size, p->private);
@@ -248,11 +257,13 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
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
@@ -265,14 +276,27 @@ static void test_pre_fault_memory(unsigned long vm_type, bool private)
 
 int main(int argc, char *argv[])
 {
+	enum vm_mem_backing_src_type backing = VM_MEM_SRC_ANONYMOUS;
+	int opt;
+
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
 
 	guest_modes_append_default();
 
-	test_pre_fault_memory(0, false);
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

