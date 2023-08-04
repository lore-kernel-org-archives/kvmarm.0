Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A2DA4E
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 00:42:34 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1bbf8cb6143so13302175ad.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Aug 2023 17:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691109754; x=1691714554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J+mxzLyo3KvL1X1/io+X1OzBSufdvdiiGzpaJwRMhFQ=;
        b=SOX0LmZ7M/i5Xu6IShPkO2I+BxiwZ7/tKfFw/OszRJyMzjeA8srrxfMqCj4Z29VgNn
         T0538ljVhrlqi2oWqsf8SDO/oV45EgP4x4oPafLtiFcA3cCpGCSnbWPlD7O1UBhgOJNe
         iWOEAZPpkZuEI+dl8Vup28taKKrYkoe9EEkFDZdVyWlSSumkRefUTDG/veJy2F6RniEr
         D4CN9ItmtE3GLQpzTfzusmxS7gLu+J3zXqOmaxg3BFTHOgLSHC5+aOpOePxVzXkX7y+j
         40aPvclyhw23NLYArpVti1fhnKJ/y5UqJGdMWPnW2w3RzepQtSrazDZXeGyOlRrMC0eG
         uSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691109754; x=1691714554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J+mxzLyo3KvL1X1/io+X1OzBSufdvdiiGzpaJwRMhFQ=;
        b=DPRs+nHeb8L+lRoYF2v07nHpuTyoIQQBmct10pIU+dpsBcNo0m54A/j+Re09ysETL6
         EUnKuK0GoMvqFTCfAdgYIrSVGBpkB+IBncPdbs9aPEwEtjr4rrrzSSZQuNCqfRZUB4RY
         Dsw25V0SYZ9Oy0GA2czkCOb8BG1DtQL32Gbaanpk/r6BQiGmk+iW/KOSfMszf/u+6/bM
         P1vQH3pRXSO3lwVJmWqtnbuX/p4E2QxluviSR52n3D10FXTbO4AfE9jbvyOt1rN30uk5
         XZs0Wd2CMhrfmTv4FuGzG4P46/Q9ONZZFE7S0/lhKAVs/6ULYYcqXb/vXxpEPC6N8f3I
         ytLg==
X-Gm-Message-State: AOJu0YyW+aCIhXGRlbgxosHjQU4E2bF8NCYlkKx5laMrPqRyaQ4+CvM1
	vr2rXlqdAG87WCshpZdpcOLMAZlopW4=
X-Google-Smtp-Source: AGHT+IHgxmGXjdzVwOxMuN7YUlHLd0HAzkRoLNDux7bwtM6itZt1UHKYVf8WxlurAEE0Phc3A5aSSAIz63w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dad1:b0:1b8:a555:385d with SMTP id
 q17-20020a170902dad100b001b8a555385dmr1165plx.9.1691109754176; Thu, 03 Aug
 2023 17:42:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  3 Aug 2023 17:42:25 -0700
In-Reply-To: <20230804004226.1984505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230804004226.1984505-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230804004226.1984505-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: selftests: Use asserting kvm_ioctl() macros when
 getting ARM page sizes
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"

Use kvm_ioctl() instead of open coding equivalent ioctl()+TEST_ASSERT()
calls when getting the support page sizes on ARM.  The macro usage is a
little funky since the "kvm_fd" parameter implies an actual /dev/kvm fd,
but on the other hand the code is invoking KVM ioctl()s.

Alternatively, the core utilities could expose a vm_open()+vm_close()
pair so that the ARM code could create a dummy, on-stack VM+vCPU pair and
use {vm,vcpu}_ioctl() as appropriate.  But the odds of something breaking
due to oddball, partial usage of kvm_vm and kvm_vcpu structures is much
higher than realizing meaningful benefit from using {vm,vcpu}_ioctl().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/aarch64/processor.c      | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 3a0259e25335..afec1a30916f 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -496,7 +496,7 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 				      bool *ps4k, bool *ps16k, bool *ps64k)
 {
 	struct kvm_vcpu_init preferred_init;
-	int kvm_fd, vm_fd, vcpu_fd, err;
+	int kvm_fd, vm_fd, vcpu_fd;
 	uint64_t val;
 	struct kvm_one_reg reg = {
 		.id	= KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1),
@@ -504,19 +504,13 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 	};
 
 	kvm_fd = open_kvm_dev_path_or_exit();
-	vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, (void *)(unsigned long)ipa);
-	TEST_ASSERT(vm_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm_fd));
+	vm_fd = kvm_fd_ioctl(kvm_fd, KVM_CREATE_VM, (void *)(unsigned long)ipa);
+	vcpu_fd = kvm_fd_ioctl(vm_fd, KVM_CREATE_VCPU, (void *)0ul);
 
-	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
-	TEST_ASSERT(vcpu_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu_fd));
+	kvm_ioctl(vm_fd, KVM_ARM_PREFERRED_TARGET, &preferred_init);
+	kvm_ioctl(vcpu_fd, KVM_ARM_VCPU_INIT, &preferred_init);
 
-	err = ioctl(vm_fd, KVM_ARM_PREFERRED_TARGET, &preferred_init);
-	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_ARM_PREFERRED_TARGET, err));
-	err = ioctl(vcpu_fd, KVM_ARM_VCPU_INIT, &preferred_init);
-	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_ARM_VCPU_INIT, err));
-
-	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
-	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
+	kvm_ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
 
 	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4), val) != 0xf;
 	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64), val) == 0;
-- 
2.41.0.585.gd2178a4bd4-goog

