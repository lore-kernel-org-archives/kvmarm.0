Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB0B30E846
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368550; cv=none; b=ffIGqQRZwH9SDmE5mMqxp1Pxx7QB+0cyO4PbReTA5kTnyadi7sHa/kwEhSUDgN7vSWLFAimG92jk0/QbXPYf+ba06SgXjZEm7KMiWCoOG6+rKzkBIrv8NTLMQ385f1Ltog4Yx8bVgEBPo0iKn/4XefJPeIlhxOKKrXiSk65xDeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368550; c=relaxed/simple;
	bh=AfUKt9Y64nk4DJCkkE4xk0dAPQmcJX1fmTUpYECF7XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gc/cJLK0xlk/GOKfmM8BxjFchhrQ6wQXSdcq0h7HEUsla3tVa8DMeBBj3K4UzzituRc+oqYWRzadj1K5a8fyo/HUUQ1Kqc+VRZ+vBztE1bgOsCVmI9MygFIE6QDd9XFLU0wxbbwiLPXi+RR37Xp/OGz9uVr6n3HONY41E0euMTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QLMHtURt; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QLMHtURt"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46fc5e54cceso8045925e9.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 08:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760368547; x=1760973347; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzQnDluOQWqcbRXyu07+4Pf89SEymkI9ph5TfK7+5co=;
        b=QLMHtURt9e5GDYf9BAAF0mZaOLyf8lrxSFZz1r9WwaTIHVTB8ebUm9TaqqIKg5Ufa8
         nsZKLOtnD2elwd51jBLXLW7QZZuERSqXUm5YO194fooJ8LiqJ69MZcS/2M5uVbZoCBrF
         Hlj83Th6aUyYEqCwNlOu9AiuoR3DX7ekDPxsM6l7h4MkQWxI1T2MRRI0SUL/CAOyuhr/
         AquqzI5gyDg07Fuhf1tKpsBwmRypYAeNnJIbbLRYRcwaTuR5y7221gByh/WOJ0TqFeTs
         zHEmy51yJsRxC4HpmzlB1JfbHS/yDo1BUEgdcSLFGyiI0AdNuYjewL65iAuf8GERM+pC
         Vrlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760368547; x=1760973347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mzQnDluOQWqcbRXyu07+4Pf89SEymkI9ph5TfK7+5co=;
        b=gSdWnmRz/wh6NwGBV0I3Jk8iF4fWmeXzPdMJ0fiwGiSA7sv6RQ9pYZeP6tp4mxkCou
         gDmBfR2KLVkAs4fKPNcGSJhsBfMKs8KJwTgFOAo6gfQw4uIHuPEeAAXwA8ZiRF3JH2Vq
         Krgpd0RdZjVSayeghwm4CNO2UF5Tl+jAzjmWBmMYTPJdxAxk0YNqkuHIJqv/lVAhZTSS
         kZurxcHJyMH0or1XdTdSW55OXG9AWm2cS3Z0nYKCvO2uxhka+4uZA+wg6uFqftXdYqDL
         0hJA7pEBllStbBz9JUKCUOboq9svyXNfcmlCw722CrNbyuS5Hj8JxvEAmNoMZJ/p6e6U
         dHKA==
X-Forwarded-Encrypted: i=1; AJvYcCUHFswW2aA8Q696YKa0TomPfsjIjjkT2ExNoNnwHkLr8dkC1hMIp8F1THe7hCtmhqN2veABM1o=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPrtLv7QQr8jMDGftJ6leYlbxnec8npzCF2eqg/+vyxGtnhTp8
	iL7eZiSqgz+2bRe1CPGjN/dxi1m7/sIcHcbT2QZ3cqsrqkugAj1Lck/C
X-Gm-Gg: ASbGncvRheDn1Vte7yCfcFiv9DIjXuSyVQmm/LF4TF6QdNTY1a1M4OI5bdyZR1UgM5f
	v3K1oIww5E1tN/37gZoU0kwnwN+V++XvgSTMV8Gt5ugjrPeK6RIp1vEBwx2fwrhzaNTVsdMgJx3
	FzdtU2madkTnjgQYgsuqePBKKJn8s/38+svMcT/NfNEv0M9+amFaALa8zuoY5OC2mhjlX6t5YEk
	S3SyrixQ6vilgVvD2lbaKUt6Ip/EzRmdWaRn0sYjyMXe1HTH90yzO9EZYtPwhTNLFsztc8VEAUa
	fcRjcA04kVZPzZRmdttgtCfAKWF51ADm8E+mdkew7ph6EPhqbbLRuP1CUo+mlgLcyEiavdHW0NA
	EGFMsaa0SngIl2gfjuBnQX/EoucrOJEil8YMBaCcSgSstABL7uTK30gE6S9fIDsr6hdOGlyMBmi
	lOfMEWgaSfJTFYYU8Irh5C5EQkMA==
X-Google-Smtp-Source: AGHT+IHgTeXKHH2vcpsvzOcBDeWFCxx7j6NWXF765EtO+25xvlfpvrezTIu3A7FfM3RO5CiMYA9Vog==
X-Received: by 2002:a05:600c:1e85:b0:46e:39e4:1721 with SMTP id 5b1f17b1804b1-46fa9aa261amr141333095e9.12.1760368546663;
        Mon, 13 Oct 2025 08:15:46 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.3.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab36a773sm135545825e9.0.2025.10.13.08.15.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Oct 2025 08:15:46 -0700 (PDT)
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
Subject: [PATCH v2 4/4] KVM: selftests: Add option for different backing in pre-fault tests
Date: Mon, 13 Oct 2025 16:15:01 +0100
Message-ID: <20251013151502.6679-5-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251013151502.6679-1-jackabt.amazon@gmail.com>
References: <20251013151502.6679-1-jackabt.amazon@gmail.com>
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

