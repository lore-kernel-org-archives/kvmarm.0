Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92DC1E509
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 20:30:34 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57320c10635so59005207b3.3
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 13:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690835433; x=1691440233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j/i9xkXUzFsa6Pkem09fqHIKArwnqvvallRasjUEu/Q=;
        b=ol/D1vn18oUZ3ioRq0LZxOfrfi4QKNP+IZMw82UVNYZJEQrg2p9TSQdhmZ557zjjK8
         YNLay9PTTld/yHQCES78q6zZA15L8qfGm2yWGPxnyouCaj3qwYLG7n+hX9/Z/TiGB1XH
         ZVFtjTev1VmpfWObXi4tKIdIa0k97i1lFZRWxpr9fL/ucywTEMv5u1QquYLWoaag9TDq
         steoZtkQhU1j9PzEHd09Pwvd+ClCnQ4gbS1TpSLnbEIoJaoWg5RhujHskm+ScEWrcmpE
         OhllDSmtXMn5tlecwjurFBTPTPfmxFpH32EowR/qsMrK7SL96pfS+/1oBQPBcKz4O17M
         evGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690835433; x=1691440233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j/i9xkXUzFsa6Pkem09fqHIKArwnqvvallRasjUEu/Q=;
        b=LXznJCaev7dr0u1LG8eouoh32XRZvAVaCX2KhQGSZrykVR1lV3FnZYg6NGjTlgqDRB
         Dbm9DdcpfYp0ASOrV3DbV2e/2+NzXVI4Cl6JvKR9MDzeIhLojFJr9Nm5CRvRDA9q2l+e
         RjRkqTkDdVTXTBk1Qn5ZX9SghRI2kUMXO6PcB+3k7on5UesrBeQP066ODpIC0xBka7EB
         rUJF7XbWnjOxiMw8OJFX9xWmdxHI2gCsDIorLN6lTv0H7CVzbPJCeVHcupnG4U9c8gVT
         eSwCQ44QyF6nRZb8+M0ZcFu1TzTCnK6FvkWJS6pPO0M5z0KZQaLcHLKNIyQVLNGlkVVJ
         pZ/w==
X-Gm-Message-State: ABy/qLZaCHH0PrP8264JXIZu9cmEuf0Mxh+tk+eP2HuWz2up54+GQIcT
	xfth/iRx4mhQda3qBFIqfcMmqwO+nQU=
X-Google-Smtp-Source: APBJJlHnKeYGeke3T6jeKytixQbOPuqvl7ziFDlXl7orfIvlptiiMkpoyewzKifvDo54ZaWDy8BplTeEvh0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:70a:b0:581:3939:59a2 with SMTP id
 bs10-20020a05690c070a00b00581393959a2mr85126ywb.3.1690835433789; Mon, 31 Jul
 2023 13:30:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 31 Jul 2023 13:30:25 -0700
In-Reply-To: <20230731203026.1192091-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230731203026.1192091-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230731203026.1192091-3-seanjc@google.com>
Subject: [PATCH v4.1 2/3] KVM: selftests: Add #define of expected KVM exit
 reason for ucall
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Define the expected architecture specific exit reason for a successful
ucall so that common tests can assert that a ucall occurred without the
test needing to implement arch specific code.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/aarch64/ucall.h | 2 ++
 tools/testing/selftests/kvm/include/riscv/ucall.h   | 2 ++
 tools/testing/selftests/kvm/include/s390x/ucall.h   | 2 ++
 tools/testing/selftests/kvm/include/x86_64/ucall.h  | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/ucall.h b/tools/testing/selftests/kvm/include/aarch64/ucall.h
index fe65fdf4f0d3..4b68f37efd36 100644
--- a/tools/testing/selftests/kvm/include/aarch64/ucall.h
+++ b/tools/testing/selftests/kvm/include/aarch64/ucall.h
@@ -4,6 +4,8 @@
 
 #include "kvm_util_base.h"
 
+#define UCALL_EXIT_REASON       KVM_EXIT_MMIO
+
 /*
  * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
  * VM), it must not be accessed from host code.
diff --git a/tools/testing/selftests/kvm/include/riscv/ucall.h b/tools/testing/selftests/kvm/include/riscv/ucall.h
index 86ed0500972b..be46eb32ec27 100644
--- a/tools/testing/selftests/kvm/include/riscv/ucall.h
+++ b/tools/testing/selftests/kvm/include/riscv/ucall.h
@@ -4,6 +4,8 @@
 
 #include "processor.h"
 
+#define UCALL_EXIT_REASON       KVM_EXIT_RISCV_SBI
+
 static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
diff --git a/tools/testing/selftests/kvm/include/s390x/ucall.h b/tools/testing/selftests/kvm/include/s390x/ucall.h
index 47ad4b1fbccb..b231bf2e49d6 100644
--- a/tools/testing/selftests/kvm/include/s390x/ucall.h
+++ b/tools/testing/selftests/kvm/include/s390x/ucall.h
@@ -4,6 +4,8 @@
 
 #include "kvm_util_base.h"
 
+#define UCALL_EXIT_REASON       KVM_EXIT_S390_SIEIC
+
 static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
diff --git a/tools/testing/selftests/kvm/include/x86_64/ucall.h b/tools/testing/selftests/kvm/include/x86_64/ucall.h
index 05cc69b0d550..06b244bd06ee 100644
--- a/tools/testing/selftests/kvm/include/x86_64/ucall.h
+++ b/tools/testing/selftests/kvm/include/x86_64/ucall.h
@@ -4,6 +4,8 @@
 
 #include "kvm_util_base.h"
 
+#define UCALL_EXIT_REASON       KVM_EXIT_IO
+
 static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
-- 
2.41.0.585.gd2178a4bd4-goog

