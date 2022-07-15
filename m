Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72862C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B47F4BDD7;
	Fri, 15 Jul 2022 02:11:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F4DsURydSEcZ; Fri, 15 Jul 2022 02:11:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFBFD4BBB0;
	Fri, 15 Jul 2022 02:11:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F0494BC20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12yIkUDHwTNw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:50 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1300A4BDCA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:50 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 z9-20020a258689000000b0066e38ab7122so3263146ybk.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=C+9RN60EOV8842FFgmBAy6PrpfwWqW7C+czhzeS/rR4=;
 b=YBfbYLBhEFURhCK4QKUC8bI/R6G7EXpPYpXv8EgvXFE5JI8iCfdDD/zhxXUPJ1FCj2
 HobAgwdJcz8iCJZ3Nf6qUn5/JFvFqTXwTbxs1Vp8JQ5DiIGMNOmoxWd8ZFtzh4zWdbW2
 UXXqKfjRvUH0FaeGEFgQrLpiSfFzw/8JrEAdOPLimA7QNNMLXVfCXV7aWgjExnRC71PE
 st+L76+Nt2+hlQM0Y7sQ2cwdVY2C1xVk2yx3eg9khBifSFQMmA4ZOR9Djwd7LeLopeWE
 xiMe9XRODecY4NQkbUkZ8/WtMreqsn6dA6vGRjB7aYLob2bWXnsgyxD5ML6TZoiDhcWj
 CuIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=C+9RN60EOV8842FFgmBAy6PrpfwWqW7C+czhzeS/rR4=;
 b=kAo86Ph4+V/zDd4Zab9SRXY+fWhSk72XXTy6RNvUvMyQ8I2Dt7OHm7dziQ6I63JpB7
 LJnzkI1H7erjcvSywFT6udK7JBGlr0a03WgPXQT8exvsjloKqdXiFir5bDHcSOD3g+eb
 6pzPSIr9xLabeXMRhsXwW7JZuGyeMonvMvFkQd3Un49CtLgVLrGkyLBcmyXY37lQZUD/
 aWgfgYazEGBxkkaDfKojRi54QQXnhGJ1O6JKNobpWWyzxJjChmLsYUVYKro7ElunF5/M
 Yv/2LZrNrBLB3NxVc6GMXXPG+W2rsOjjn6uQqS4bCa9riVoON2GunRosV9XAS8GnZVyU
 D/7A==
X-Gm-Message-State: AJIora+hTvfhvh6hoJmOhmqedxCybYGhemzbv7qMifHD00cVj3GyNja3
 JNhe+N8bAh0GdZrNHOlgOfYOyZ8I8itY9sopiA==
X-Google-Smtp-Source: AGRyM1vmpZrg9C65GGAVW8i3cJzkzgqCICriOC0RsFfWEe5JJODK8w4KS6U/1MhBLlAvC1UTH/ak2+fLI6MXcu3Qzw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:44d:0:b0:66f:ad5a:9d0b with SMTP
 id s13-20020a5b044d000000b0066fad5a9d0bmr10986561ybp.79.1657865509675; Thu,
 14 Jul 2022 23:11:49 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:27 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-19-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 18/18] KVM: arm64: Dump nVHE hypervisor stack on panic
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, android-mm@google.com, andreyknvl@gmail.com,
 kernel-team@android.com, drjones@redhat.com,
 linux-arm-kernel@lists.infradead.org, russell.king@oracle.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On hyp_panic(), unwind and dump the nVHE hypervisor stack trace.
In protected nVHE mode, hypervisor stacktraces are only produced
if CONFIG_PROTECTED_NVHE_STACKTRACE is enabled.

Example backtrace:

[  126.862960] kvm [371]: nVHE hyp panic at: [<ffff8000090a51d0>] __kvm_nvhe_recursive_death+0x10/0x34!
[  126.869920] kvm [371]: Protected nVHE HYP call trace:
[  126.870528] kvm [371]:  [<ffff8000090a5570>] __kvm_nvhe_hyp_panic+0xac/0xf8
[  126.871342] kvm [371]:  [<ffff8000090a55cc>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
[  126.872174] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
[  126.872971] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
. . .
[  126.927314] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
[  126.927727] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
[  126.928137] kvm [371]:  [<ffff8000090a4de4>] __kvm_nvhe___kvm_vcpu_run+0x30/0x40c
[  126.928561] kvm [371]:  [<ffff8000090a7b64>] __kvm_nvhe_handle___kvm_vcpu_run+0x30/0x48
[  126.928984] kvm [371]:  [<ffff8000090a78b8>] __kvm_nvhe_handle_trap+0xc4/0x128
[  126.929385] kvm [371]:  [<ffff8000090a6864>] __kvm_nvhe___host_exit+0x64/0x64
[  126.929804] kvm [371]: ---- End of Protected nVHE HYP call trace ----

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kvm/handle_exit.c     | 4 ++++
 arch/arm64/kvm/hyp/nvhe/switch.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index f66c0142b335..ef8b57953aa2 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -17,6 +17,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/debug-monitors.h>
+#include <asm/stacktrace/nvhe.h>
 #include <asm/traps.h>
 
 #include <kvm/arm_hypercalls.h>
@@ -353,6 +354,9 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 				(void *)panic_addr);
 	}
 
+	/* Dump the nVHE hypervisor backtrace */
+	kvm_nvhe_dump_backtrace(hyp_offset);
+
 	/*
 	 * Hyp has panicked and we're going to handle that by panicking the
 	 * kernel. The kernel offset will be revealed in the panic so we're
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6db801db8f27..a50cfd39dedb 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -25,6 +25,7 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
+#include <asm/stacktrace/nvhe.h>
 
 #include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
@@ -375,6 +376,10 @@ asmlinkage void __noreturn hyp_panic(void)
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
+	/* Prepare to dump kvm nvhe hyp stacktrace */
+	kvm_nvhe_prepare_backtrace((unsigned long)__builtin_frame_address(0),
+				   _THIS_IP_);
+
 	__hyp_do_panic(host_ctxt, spsr, elr, par);
 	unreachable();
 }
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
