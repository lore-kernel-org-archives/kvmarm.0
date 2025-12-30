Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968942E36F1
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135729; cv=none; b=LiR1QaolsRA1vjTcb+leP+LvbcVIvaPLwOpkBm63jXPH+fwikLwveT8U/NzDmADsn2BXEakQwkL6glL9etY+g4iEq4wNehgEzjqjYfzywHTk4QwDnpIb4BqLCkiXykvtWulrailr73CM9qIB1Y03Nx1VT2THjDRzizIzwTZ9gxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135729; c=relaxed/simple;
	bh=pyBUiyOamhL8LS5/W09JA+DscggetuA4FZPbkkaVrm8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mnIGqo/5342G3sU8U4ymhog9oWPBF3Rg05rs6OT2uMNhqLQeVjZg6XQKB+ZW4tyag6R+Wk/lC0qAAc7pYaC2UPTBUHD+v0yg93U2rAtjRH+G5mINUsfTR5slT/r1KnN6AkzGx0FcoXfLa4ReCoQTzsmx8Tdy49kOI7LCR20L504=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pSqO+NxI; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pSqO+NxI"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0f0c7a06eso205678405ad.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135727; x=1767740527; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sUaPNsiWybrsN14UDe2YJDAR+cxy5ZbGWPMbDaaniZw=;
        b=pSqO+NxIZbBle7CtddoVT0Yn1YsatIg4hOrNFZbB6L1o9wSAI/5FrXNq/U6+SCN7VA
         LlpsPDrqxCNePydtnnf/zCqCKCOFqaXnfz2TZQKWYH3GOU2JD3X/r9VWfR0bNlJqbnTz
         lNGGKQiX7YAyDeWh3ExT6BpEYKeE76AL/yT+BQRZLDuhjqzKpwq8/gwjMgcBulFL8706
         WO7YBsg9nd+xczpC4POR4LQcWB5lZLbCiihLHbpdltgiLQDirbL6JJ2iukFLkXlqEGwV
         SD82zIbPFXM3lYLMWnFN5mGJc43aXyve2Z0Bu0rzyMZn8Ed+7+E7lRMNdAoMlwsURUfm
         vZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135727; x=1767740527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sUaPNsiWybrsN14UDe2YJDAR+cxy5ZbGWPMbDaaniZw=;
        b=M/iUN76TvsU88kkHbprYzrCkCzblKohx3FrLZgCn0wJXFA5lfKzh7SU07A5jKkVfI8
         dHsnj2rHT/S4JA5af+N9blHS4S8IKYpBxliKc9bl3JjOHjPSbmrwXAvcQTpm+RT5vAyL
         R/KQGXmEW1YQAvlKBuJEiiQ9R8wMmSYTmS1T0Min+riIYpdf10WmHTM/648nRfR//i6c
         diFZ9zBGEV41MvlDTV9SmEbKyBDMsC+Yq5FQ3q0vyMl5XM3AIgVszncMbbiImzEX86O7
         6Xl4nuxz4Ecuo5pZsflvv6FCAg95ZU83IbIVylv72sYOFM/yQVIGHb9LwpYv5uvc2jSR
         9+og==
X-Forwarded-Encrypted: i=1; AJvYcCVYtCFLMnWxQ080rSLUdpwFiLH/2rul63KatRsPUrZT/S6Ktf0gZPm/gh/F1JCQ00dLG1PNET8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzA2wEbo+vMw5k0eGUKSNv3N/uFQGUxMqXVyq4J23LXZ222Qvr0
	PguZRDJPuORt1xcU/yarlzVm6IrQ4sS0Jx/dTLMzEVfjVNBxBbQTdqFhCNbZC/0B3hPww5OtXXw
	rPi3Zpg==
X-Google-Smtp-Source: AGHT+IFQnOuwYC0g4+LirB1coBfKvkA6ZwCBuTM8ay+vZ/F6ieVjqX4SvnIiidBDol06ehcl6JagnUzMopM=
X-Received: from plxx9.prod.google.com ([2002:a17:902:e049:b0:2a0:9ab8:a28d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f0b:b0:2a0:9970:13fd
 with SMTP id d9443c01a7336-2a2f293cf1emr298922605ad.43.1767135726838; Tue, 30
 Dec 2025 15:02:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:37 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-9-seanjc@google.com>
Subject: [PATCH v4 08/21] KVM: selftests: Add a "struct kvm_mmu_arch arch"
 member to kvm_mmu
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add an arch structure+field in "struct kvm_mmu" so that architectures can
track arch-specific information for a given MMU.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h     | 2 ++
 tools/testing/selftests/kvm/include/kvm_util.h                | 2 ++
 tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h | 1 +
 tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h     | 1 +
 tools/testing/selftests/kvm/include/s390/kvm_util_arch.h      | 1 +
 tools/testing/selftests/kvm/include/x86/kvm_util_arch.h       | 2 ++
 6 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
index b973bb2c64a6..4a2033708227 100644
--- a/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
@@ -2,6 +2,8 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
 
+struct kvm_mmu_arch {};
+
 struct kvm_vm_arch {
 	bool	has_gic;
 	int	gic_fd;
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 39558c05c0bf..c1497515fa6a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -92,6 +92,8 @@ struct kvm_mmu {
 	bool pgd_created;
 	uint64_t pgd;
 	int pgtable_levels;
+
+	struct kvm_mmu_arch arch;
 };
 
 struct kvm_vm {
diff --git a/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h b/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
index e43a57d99b56..d5095900e442 100644
--- a/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
@@ -2,6 +2,7 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
 
+struct kvm_mmu_arch {};
 struct kvm_vm_arch {};
 
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
index e43a57d99b56..d5095900e442 100644
--- a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
@@ -2,6 +2,7 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
 
+struct kvm_mmu_arch {};
 struct kvm_vm_arch {};
 
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h b/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
index e43a57d99b56..d5095900e442 100644
--- a/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
@@ -2,6 +2,7 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
 
+struct kvm_mmu_arch {};
 struct kvm_vm_arch {};
 
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index 972bb1c4ab4c..456e5ca170df 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -10,6 +10,8 @@
 
 extern bool is_forced_emulation_enabled;
 
+struct kvm_mmu_arch {};
+
 struct kvm_vm_arch {
 	vm_vaddr_t gdt;
 	vm_vaddr_t tss;
-- 
2.52.0.351.gbe84eed79e-goog

