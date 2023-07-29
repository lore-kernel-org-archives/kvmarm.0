Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E456392
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:02 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1bb962ada0dso17190035ad.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591022; x=1691195822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jA1UVJV2mTAx+a2Lkx0I6MPmHbvMTggN8U6YXQ/WoPE=;
        b=K4d3Yo027UjIWQLKdsJ+4pJ5JAFOzUO0KRpjGWvQAJC1C3ucZprPSO1EmmSKjHL5RL
         mjMb4Wl4ok7XoJJ1UpvXExKrZiS4rMu1JU2JGycw5Xxs2iEvXPyGUoNKsTKzfJGYhbPU
         LgRlUQInLmq2DH5Uyogf+21W7XUb6ldLqjMT1xd34fC8sn4mYbNS+bx1bJKHKYjbaUdK
         7AmwiB3Jjx2+vUvKZ15nrKoZsoW4PVfdu+/S0+ZWTbol8JYhHE2XH87j8WOQEjM0KOrB
         unEKPbBvWYwlhSNsm+dRFNpapqFmKqvp2geugj636QFuzYT5UZl84xpkYXOlHRd0ByML
         cS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591022; x=1691195822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jA1UVJV2mTAx+a2Lkx0I6MPmHbvMTggN8U6YXQ/WoPE=;
        b=PAdYFtfIIN1gLonNMy8ef+wLfqyxSVqRJzLzTQa8VMbFcqQDffGVatEBZmYenjPSgm
         UbykPXi4J8k0EuPF3DMvE2dYmotIH8GPC25N2hUrjTyXdAvXTYH0oSbt8wW2vJy6rwUX
         qdEtzAN8DHGlujHs/fFvYoBSewl/qx7gR0H75kslbcz54CgOlPKFaZPxoXyhwQgzKvPc
         2iykOeQzfuGSssJHRt57ehXIdbkB8+Wi5yTys9e9NSqowjG1G3sAIZHQPrInRkKb57V0
         fOOWjIgsG1FgM3RZyFloRdwaFlabzZCd11gbZbvU6x9l5Oi/jwjusu74ZwbTWKLI5jl+
         ms1Q==
X-Gm-Message-State: ABy/qLY8fV4fFFJ62jCakMLdQ0F94gDd5qSONqdYMyMzmgYDUz+Kmw5x
	c/N9GnAiyZMju5OcsA5W5Z2yAbaFo1A=
X-Google-Smtp-Source: APBJJlHBrL+TeZGSt6drIsgYNE5M3L5vEoG966oFy1TYmHeiItdpMHlHz7MHdTn/QgLjI5xFk+55OLkG/EQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2309:b0:1b3:bfa6:d064 with SMTP id
 d9-20020a170903230900b001b3bfa6d064mr13000plh.1.1690591021464; Fri, 28 Jul
 2023 17:37:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:17 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-9-seanjc@google.com>
Subject: [PATCH v4 08/34] KVM: selftests: Add formatted guest assert support
 in ucall framework
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add printf-based GUEST_ASSERT macros and accompanying host-side support to
provide an assert-specific versions of GUEST_PRINTF().  To make it easier
to parse assert messages, for humans and bots alike, preserve/use the same
layout as host asserts, e.g. in the example below, the reported expression,
file, line number, and message are from the guest assertion, not the host
reporting of the assertion.

The call stack still captures the host reporting, but capturing the guest
stack is a less pressing concern, i.e. can be done in the future, and an
optimal solution would capture *both* the host and guest stacks, i.e.
capturing the host stack isn't an outright bug.

  Running soft int test
  ==== Test Assertion Failure ====
    x86_64/svm_nested_soft_inject_test.c:39: regs->rip != (unsigned long)l2_guest_code_int
    pid=214104 tid=214104 errno=4 - Interrupted system call
       1	0x0000000000401b35: run_test at svm_nested_soft_inject_test.c:191
       2	0x00000000004017d2: main at svm_nested_soft_inject_test.c:212
       3	0x0000000000415b03: __libc_start_call_main at libc-start.o:?
       4	0x000000000041714f: __libc_start_main_impl at ??:?
       5	0x0000000000401660: _start at ??:?
    Expected IRQ at RIP 0x401e50, received IRQ at 0x401e50

Don't bother sharing code between ucall_assert() and ucall_fmt(), as
forwarding the variable arguments would either require using macros or
building a va_list, i.e. would make the code less readable and/or require
just as much copy+paste code anyways.

Gate the new macros with a flag so that tests can more or less be switched
over one-by-one.  The slow conversion won't be perfect, e.g. library code
won't pick up the flag, but the only asserts in library code are of the
vanilla GUEST_ASSERT() variety, i.e. don't print out variables.

Add a temporary alias to GUEST_ASSERT_1() to fudge around ARM's
arch_timer.h header using GUEST_ASSERT_1(), thus thwarting any attempt to
convert tests one-by-one.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/ucall_common.h      | 48 +++++++++++++++++++
 .../testing/selftests/kvm/lib/ucall_common.c  | 22 +++++++++
 2 files changed, 70 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index b5548aeba9f0..4ce11c15285a 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -36,6 +36,8 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
 void ucall_fmt(uint64_t cmd, const char *fmt, ...);
+void ucall_assert(uint64_t cmd, const char *exp, const char *file,
+		  unsigned int line, const char *fmt, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 int ucall_nr_pages_required(uint64_t page_size);
@@ -63,6 +65,50 @@ enum guest_assert_builtin_args {
 	GUEST_ASSERT_BUILTIN_NARGS
 };
 
+#ifdef USE_GUEST_ASSERT_PRINTF
+#define ____GUEST_ASSERT(_condition, _exp, _fmt, _args...)				\
+do {											\
+	if (!(_condition))								\
+		ucall_assert(UCALL_ABORT, _exp, __FILE__, __LINE__, _fmt, ##_args);	\
+} while (0)
+
+#define __GUEST_ASSERT(_condition, _fmt, _args...)				\
+	____GUEST_ASSERT(_condition, #_condition, _fmt, ##_args)
+
+#define GUEST_ASSERT(_condition)						\
+	__GUEST_ASSERT(_condition, #_condition)
+
+#define GUEST_FAIL(_fmt, _args...)						\
+	ucall_assert(UCALL_ABORT, "Unconditional guest failure",		\
+		     __FILE__, __LINE__, _fmt, ##_args)
+
+#define GUEST_ASSERT_EQ(a, b)							\
+do {										\
+	typeof(a) __a = (a);							\
+	typeof(b) __b = (b);							\
+	____GUEST_ASSERT(__a == __b, #a " == " #b, "%#lx != %#lx (%s != %s)",	\
+			 (unsigned long)(__a), (unsigned long)(__b), #a, #b);	\
+} while (0)
+
+#define GUEST_ASSERT_NE(a, b)							\
+do {										\
+	typeof(a) __a = (a);							\
+	typeof(b) __b = (b);							\
+	____GUEST_ASSERT(__a != __b, #a " != " #b, "%#lx == %#lx (%s == %s)",	\
+			 (unsigned long)(__a), (unsigned long)(__b), #a, #b);	\
+} while (0)
+
+#define REPORT_GUEST_ASSERT(ucall)						\
+	test_assert(false, (const char *)(ucall).args[GUEST_ERROR_STRING],	\
+		    (const char *)(ucall).args[GUEST_FILE],			\
+		    (ucall).args[GUEST_LINE], "%s", (ucall).buffer)
+
+/* FIXME: Drop this alias once the param-based guest asserts are gone. */
+#define GUEST_ASSERT_1(_condition, arg1) \
+	__GUEST_ASSERT(_condition, "arg1 = 0x%lx", arg1)
+
+#else
+
 #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...)		\
 do {									\
 	if (!(_condition))						\
@@ -129,4 +175,6 @@ do {									\
 #define REPORT_GUEST_ASSERT_N(ucall, fmt, args...)	\
 	__REPORT_GUEST_ASSERT((ucall), fmt, ##args)
 
+#endif /* USE_GUEST_ASSERT_PRINTF */
+
 #endif /* SELFTEST_KVM_UCALL_COMMON_H */
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index b507db91139b..816a3fa109bf 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -75,6 +75,28 @@ static void ucall_free(struct ucall *uc)
 	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
 }
 
+void ucall_assert(uint64_t cmd, const char *exp, const char *file,
+		  unsigned int line, const char *fmt, ...)
+{
+	struct ucall *uc;
+	va_list va;
+
+	uc = ucall_alloc();
+	uc->cmd = cmd;
+
+	WRITE_ONCE(uc->args[GUEST_ERROR_STRING], (uint64_t)(exp));
+	WRITE_ONCE(uc->args[GUEST_FILE], (uint64_t)(file));
+	WRITE_ONCE(uc->args[GUEST_LINE], line);
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
 void ucall_fmt(uint64_t cmd, const char *fmt, ...)
 {
 	struct ucall *uc;
-- 
2.41.0.487.g6d72f3e995-goog

