Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D39B33769C
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598598; cv=none; b=mV7BAF5hTVkC0GbgtCZzpqYAk0FJ6NU89AC6kNtQ2Paxq7lii+xiCPIYFql+0+5ILkVtkoi4GPm4R77AEkf8/K0BG2+BmXWI2J3Ipbq2TwS2aRrli4oFZ6mGv3lDpF+LcKfwoS+GBQ41HXWeHAPH38S6E5aRs54nQIGSZQDoJDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598598; c=relaxed/simple;
	bh=AfUKt9Y64nk4DJCkkE4xk0dAPQmcJX1fmTUpYECF7XQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rSqrrB0wBSDYUO5XA+c2fbFrb2URlzSYpmw54TO8b4Eoe43apzAjgXcEbY03vGxUm7k1I5jHSMlqbk8E1rcm5Oy2K5OdbvuySyAX3fClWS7GlJBRnxoh3/OHQC1MtlOzhqfyo2AjHJ6kr+dg21W7EQmfJFrREkImA4yfpV6iZwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RN+48Vdr; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RN+48Vdr"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3df726ecff3so465558f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 06:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757598595; x=1758203395; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzQnDluOQWqcbRXyu07+4Pf89SEymkI9ph5TfK7+5co=;
        b=RN+48Vdr57Hw99reo3JcNU9kXBNZegHBEXwq7jjFNs8MxnffAO7RIzUPz/YBxXGZeS
         6wZPV16DftJjIlpAu4AYT92nbgVC/6ibCS/IYPhYyUytPiuj2rCUCm+eUOWU0eESWpKR
         atPF4+sfOVY28MxBNOvcj6eFdj+YSMJOoS8RPDoxkCWzMJeYno7I015ODnG6UgB2AjXe
         tBTCR4Q/ww+UqComudPzCSmoqFCz22LLoalYlNlxqzYQH+T/Qk1rp9/tw8rND+X1ahIo
         4uMMpYFvOdhxWIPyjSwc5fMbQIei1hPTEIpZm8IUQrQ55bzRazYptJkgNmZt6T9b4WAP
         x99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757598595; x=1758203395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mzQnDluOQWqcbRXyu07+4Pf89SEymkI9ph5TfK7+5co=;
        b=juboWZjEetoaIvresqjXHxTs3ziZ+nb2eVDMMkMYvVhJ7BiLVMG7gpHQz9f1Yzsi34
         +U5VnEA2Rgr2xWqTtoaUjnfAEAVxplrZqjKMbyV8qKL49NPBCppt9JE99TcAHxbEo7k6
         6ln21Hd6NzzEo+C7QKr1TToNGy0bDPEYnFzcUHBQrmannsY7qLQj76da2IrxZmY2cABm
         9eo5/xM9kEmQ3MADBHtvfH3h8hXhOEYu4/G4ZMK+Ip3LdOWJjDfHJ0ERRnQ4AKqkvKEx
         FhwCAslxruokNp6LBi72E7VQk1UjVvug3taB+CwEPUP1ve3RHYmxTCviVtWKQQCiAxIU
         pDtg==
X-Forwarded-Encrypted: i=1; AJvYcCVuYLn4qpAbgdCAupSWxR+XB9RuhR/0YHt72TI1vpdNH2Z3B6sDOy3K5KlB0JfyJr/Uxu7Wo5I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxcidl2Acq5vsl/007eBeKkR9MVdSeMcG/rxRylJ9rly8OqaHfR
	TrtnwKbdsalD7mLIuJKTZIhp4zolBeNP//zlUF7U2+7uLfZ93trO+GdC
X-Gm-Gg: ASbGncsdnKV8j5lRF9Yssfs1AE0dcsM9nfmh7QegLxtVzpU09N65a0+ldtITwQrH4l9
	vxQibToK2LR9xiDAqBcQ9X6Wk4PwnKfc51B76XrzfL3nUDAUZcN7SQ2UPCWIqaXn4rpEtBcPVCx
	pwfCvyCzdDfV/15sc8UFOBqGDcBPj8Ec188625mG4VsXLcqKjHA71vFbjGCs4Aei6qL8Dlw0ozL
	VYJcFpg/wMUhNJT5rdngoRjDU0AlctVjJHt60dO712FDh2WErJIvXEOiFK82lMu8Y0IT/c31+GL
	sjQO90abtnSUEXSouoaGMNWvlq8OI3o09kl+BNO0S4GODnj4FNI6Bi+jjmmbxGsy6gDfI9k6MX2
	dvk57KfMOE+1KbCYEJqXc0tfhTa8How163xsFrGkR2sHF+f4aT3l/8vurEEy8en54iFniQfpH
X-Google-Smtp-Source: AGHT+IG/J8P3rse6GJgnSeKVDJySxFHBWlgnLhBSgwpmqxWIY8gC4wxlNuo/9KWFNfyudpaEFtWD+g==
X-Received: by 2002:a5d:5d02:0:b0:3e1:2d70:674e with SMTP id ffacd0b85a97d-3e643e08071mr16467931f8f.47.1757598594539;
        Thu, 11 Sep 2025 06:49:54 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760778915sm2608361f8f.12.2025.09.11.06.49.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Sep 2025 06:49:54 -0700 (PDT)
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
	roypat@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.com
Subject: [PATCH 6/6] KVM: selftests: Add option for different backing in pre-fault tests
Date: Thu, 11 Sep 2025 14:46:48 +0100
Message-Id: <20250911134648.58945-7-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250911134648.58945-1-jackabt.amazon@gmail.com>
References: <20250911134648.58945-1-jackabt.amazon@gmail.com>
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
 .../selftests/kvm/pre_fault_memory_test.c     | 31 ++++++++++++++++---
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index ed9848a8af60..22e2e53945d9 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -76,6 +76,7 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
 struct test_params {
 	unsigned long vm_type;
 	bool private;
+	enum vm_mem_backing_src_type mem_backing_src;
 };
 
 static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
@@ -94,7 +95,11 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 	uint64_t guest_test_virt_mem;
 	uint64_t alignment, guest_page_size;
 
+	size_t backing_src_pagesz = get_backing_src_pagesz(p->mem_backing_src);
+
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(guest_mode));
+	pr_info("Testing memory backing src type: %s\n",
+		vm_mem_backing_src_alias(p->mem_backing_src)->name);
 
 	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
 
@@ -110,10 +115,11 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
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
@@ -155,7 +161,8 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 	kvm_vm_free(vm);
 }
 
-static void test_pre_fault_memory(unsigned long vm_type, bool private)
+static void test_pre_fault_memory(unsigned long vm_type, enum vm_mem_backing_src_type backing_src,
+				  bool private)
 {
 	if (vm_type && !(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type))) {
 		pr_info("Skipping tests for vm_type 0x%lx\n", vm_type);
@@ -165,6 +172,7 @@ static void test_pre_fault_memory(unsigned long vm_type, bool private)
 	struct test_params p = {
 		.vm_type = vm_type,
 		.private = private,
+		.mem_backing_src = backing_src,
 	};
 
 	for_each_guest_mode(__test_pre_fault_memory, &p);
@@ -174,10 +182,23 @@ int main(int argc, char *argv[])
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

