Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ED6392
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:00 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1bba5626342so24247895ad.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591019; x=1691195819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ELXU1ozQzdRVu6Pw/o2mcwSfwjzxGjCFC9TkVEz9ZVQ=;
        b=JXtcg+1ByHrhsMnwuvWSktPaXMMguvcz07wHpELDSVv6jhZ3yrEl0JvsbHqBi5Lg2x
         OmX5Eimu/ODFnq3VaAjn8vXO1K17rz8y6EpesxllWzQRPUfsavJkfM4At0ImL4pderV8
         fvgM9Bge1BI96MVbtQDXU+64v48qE3nq1HyrYE9zFRgPRHo+Wg2XKMo2Sc5iGJCqFUhY
         FPfQU4uIVpdGn2QFHpgCsDRaEnqFriANA72+NhczhR8B6xGQYtfwAurIWtQuSJ8qMWVA
         Ml4BO52nX87ezdWgvfx/qbYHGyhUaBoVsxUYpnpeEXRxWOxYM7y18KJ85RhTqqTsk3lN
         JNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591019; x=1691195819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ELXU1ozQzdRVu6Pw/o2mcwSfwjzxGjCFC9TkVEz9ZVQ=;
        b=KkcyCxAS7xWO3SnjCW8usxu088Qz6hICgZ1M5l8Wj29YW9q2UgNXbSJ5w+n0WEhPEm
         cpS6xL+sqH0shw5XR/n+2WM3cr/yNlXGePr6u8JqrSTbuFGh0kq+KCjHv1JC53TYIZjt
         vRgw25EJ7mtUdM/nM5fOZZJH7K9sGwfMBYNhynxcor/b4mlVB7byfjqHsQMpVEDv8FEH
         YO47I2BraIArq/h4QleRbfPvkWnSWuRAULh75rVuVnun6e3Pbg8NtdikyBAqN2av/ksd
         BJzrW8v8eMb96de0QFTaWv5jnlM+TGKtXEbF8AMmX3EARKA6RO1EuTAKiKCFWYojXSab
         LUFg==
X-Gm-Message-State: ABy/qLai3CqdpFqJE2uP/7g+Hiz3rVvZksywkQM2Yhmqzl3w+j3TUjdA
	lcMgRxiunE9viW/gFk6geiIlZtSVPFE=
X-Google-Smtp-Source: APBJJlFaQWpQ9EmvDFhoqjrlvd9ghhe4hfSspLAxYVt7vmgNKcaTBWdjzzZ7FvjaiMwdSLF+VQ/4xTSUS1M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa0d:b0:1bb:a13a:c21e with SMTP id
 la13-20020a170902fa0d00b001bba13ac21emr11796plb.10.1690591019608; Fri, 28 Jul
 2023 17:36:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:16 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-8-seanjc@google.com>
Subject: [PATCH v4 07/34] KVM: selftests: Add string formatting options to ucall
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Aaron Lewis <aaronlewis@google.com>

Add more flexibility to guest debugging and testing by adding
GUEST_PRINTF() and GUEST_ASSERT_FMT() to the ucall framework.

Add a sized buffer to the ucall structure to hold the formatted string,
i.e. to allow the guest to easily resolve the string, and thus avoid the
ugly pattern of the host side having to make assumptions about the desired
format, as well as having to pass around a large number of parameters.

The buffer size was chosen to accommodate most use cases, and based on
similar usage.  E.g. printf() uses the same size buffer in
arch/x86/boot/printf.c.  And 1KiB ought to be enough for anybody.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
[sean: massage changelog, wrap macro param in ()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/ucall_common.h        |  7 +++++++
 tools/testing/selftests/kvm/lib/ucall_common.c  | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index bcbb362aa77f..b5548aeba9f0 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -13,15 +13,18 @@ enum {
 	UCALL_NONE,
 	UCALL_SYNC,
 	UCALL_ABORT,
+	UCALL_PRINTF,
 	UCALL_DONE,
 	UCALL_UNHANDLED,
 };
 
 #define UCALL_MAX_ARGS 7
+#define UCALL_BUFFER_LEN 1024
 
 struct ucall {
 	uint64_t cmd;
 	uint64_t args[UCALL_MAX_ARGS];
+	char buffer[UCALL_BUFFER_LEN];
 
 	/* Host virtual address of this struct. */
 	struct ucall *hva;
@@ -32,6 +35,7 @@ void ucall_arch_do_ucall(vm_vaddr_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
+void ucall_fmt(uint64_t cmd, const char *fmt, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 int ucall_nr_pages_required(uint64_t page_size);
@@ -47,8 +51,11 @@ int ucall_nr_pages_required(uint64_t page_size);
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
+#define GUEST_PRINTF(_fmt, _args...) ucall_fmt(UCALL_PRINTF, _fmt, ##_args)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
 
+#define REPORT_GUEST_PRINTF(ucall) pr_info("%s", (ucall).buffer)
+
 enum guest_assert_builtin_args {
 	GUEST_ERROR_STRING,
 	GUEST_FILE,
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 77ada362273d..b507db91139b 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -75,6 +75,23 @@ static void ucall_free(struct ucall *uc)
 	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
 }
 
+void ucall_fmt(uint64_t cmd, const char *fmt, ...)
+{
+	struct ucall *uc;
+	va_list va;
+
+	uc = ucall_alloc();
+	uc->cmd = cmd;
+
+	va_start(va, fmt);
+	guest_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
+	va_end(va);
+
+	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+
+	ucall_free(uc);
+}
+
 void ucall(uint64_t cmd, int nargs, ...)
 {
 	struct ucall *uc;
-- 
2.41.0.487.g6d72f3e995-goog

