Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25037C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 15:00:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2F7E4BA2C;
	Fri, 25 Feb 2022 10:00:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cIS48RxlIjGC; Fri, 25 Feb 2022 10:00:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C423E4BAC9;
	Fri, 25 Feb 2022 09:59:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CC8D4BAE8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:47:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WYQlVcVEII5w for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 22:47:08 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 712344BAE3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:47:08 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 r14-20020a5b018e000000b00624f6f97bf4so2030407ybl.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 19:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=om0xysVIIw9w8FzfTtAfz0giNjNwsYB4g7QZmD5nI+Y=;
 b=WVPkG6ES/sCmn8lQ1hBGOAFT6sAZLWvKKvAPxfkFImziENa9MmhlGM2Q4HneZD0ggX
 SV+KILfryfEtqfVpxXqsY3cUO9OVPCOIastmLhVbIlX0hDZf5fzC/eTniDjI/ILbfvk9
 enLwnK45LQ7C1Hrj5fjK6w6Ujt6dco1aPCJ+sOrsXl/So/+2uWq1uo8GtWy3P249KjzP
 8uutdyw99mgB+8wOypEb6D/gn2ycT4KUE8m4u0xIQk9H00MibgMnaw9f7DbbBrUeqdaY
 sb6cvBHxYuYKfhQ+ns+xxtYJsMb/R15oK7YxLywjK6vRIj5ofTCgjdSwoUDhFMdwaGhv
 O2nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=om0xysVIIw9w8FzfTtAfz0giNjNwsYB4g7QZmD5nI+Y=;
 b=B5hp8wsbt0yk7Yll50VZW7hlEjLL6iBnJ9Sm2+9ABP5+kLfarG8D//Vycm2RU3OHFR
 f3rVNlcH6IYzRTononU4chpTyToTWG9kOY5mXe+jgI4uFQj30ZcVqsT+VE2SZU28qbUP
 JTo/8/vWo61iD9PByaYQPV5+92XSI+9OhjYe0LUxzH25RipFrK9YCmCPPpMYXeW0IaxM
 odOS8fHX26iRcPVV24F2dRk+eB05r7rTtrot8OdYAVzPQ296NsFS3I+TvAp7hQj8+XF1
 TbKumFpaUoAAXzaowMv9orYMnd1pXKfdp3dAMBZKcaDeR2abrSwWexwEDk4o9W3RjWHZ
 mkaQ==
X-Gm-Message-State: AOAM531+x9fto5mm59fzvEKNzP83TsQtubGEf1BxXaXf7MHZfoP238jN
 ryj3wIFH+1HwVuwpGowPiECocXVbLRP+AoeOBA==
X-Google-Smtp-Source: ABdhPJywVKUzlNs9CpFR9Smz5BgJxf3VvxB2SbQLgJEE0yGbJjLxLydpBATqIyhm5663Rm308Uj8I847LN5RduC7Yw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:3a50:90b2:e6a2:9060])
 (user=kaleshsingh job=sendgmr) by 2002:a25:3b17:0:b0:619:4463:a400 with SMTP
 id i23-20020a253b17000000b006194463a400mr5640044yba.36.1645760827975; Thu, 24
 Feb 2022 19:47:07 -0800 (PST)
Date: Thu, 24 Feb 2022 19:34:53 -0800
In-Reply-To: <20220225033548.1912117-1-kaleshsingh@google.com>
Message-Id: <20220225033548.1912117-9-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220225033548.1912117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 8/8] KVM: arm64: Symbolize the nVHE HYP backtrace
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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

Reintroduce the __kvm_nvhe_ symbols in kallsyms, ignoring the local
symbols in this namespace. The local symbols are not informative and
can cause aliasing issues when symbolizing the addresses.

With the necessary symbols now in kallsyms we can symbolize nVHE
stacktrace addresses using the %pB print format specifier.

Example call trace:

[   98.916444][  T426] kvm [426]: nVHE hyp panic at: [<ffffffc0096156fc>] __kvm_nvhe_overflow_stack+0x8/0x34!
[   98.918360][  T426] nVHE HYP call trace:
[   98.918692][  T426] kvm [426]: [<ffffffc009615aac>] __kvm_nvhe_cpu_prepare_nvhe_panic_info+0x4c/0x68
[   98.919545][  T426] kvm [426]: [<ffffffc0096159a4>] __kvm_nvhe_hyp_panic+0x2c/0xe8
[   98.920107][  T426] kvm [426]: [<ffffffc009615ad8>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
[   98.920665][  T426] kvm [426]: [<ffffffc009610a4c>] __kvm_nvhe___kvm_hyp_host_vector+0x24c/0x794
[   98.921292][  T426] kvm [426]: [<ffffffc009615718>] __kvm_nvhe_overflow_stack+0x24/0x34
. . .

[   98.973382][  T426] kvm [426]: [<ffffffc009615718>] __kvm_nvhe_overflow_stack+0x24/0x34
[   98.973816][  T426] kvm [426]: [<ffffffc0096152f4>] __kvm_nvhe___kvm_vcpu_run+0x38/0x438
[   98.974255][  T426] kvm [426]: [<ffffffc009616f80>] __kvm_nvhe_handle___kvm_vcpu_run+0x1c4/0x364
[   98.974719][  T426] kvm [426]: [<ffffffc009616928>] __kvm_nvhe_handle_trap+0xa8/0x130
[   98.975152][  T426] kvm [426]: [<ffffffc009610064>] __kvm_nvhe___host_exit+0x64/0x64
[   98.975588][  T426] ---- end of nVHE HYP call trace ----

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v2:
  - Fix printk warnings - %p expects (void *)

 arch/arm64/kvm/handle_exit.c | 13 +++++--------
 scripts/kallsyms.c           |  2 +-
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index ff69dff33700..3a5c32017c6b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -296,13 +296,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	u64 elr_in_kimg = __phys_to_kimg(elr_phys);
 	u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr_virt;
 	u64 mode = spsr & PSR_MODE_MASK;
+	u64 panic_addr = elr_virt + hyp_offset;
 
-	/*
-	 * The nVHE hyp symbols are not included by kallsyms to avoid issues
-	 * with aliasing. That means that the symbols cannot be printed with the
-	 * "%pS" format specifier, so fall back to the vmlinux address if
-	 * there's no better option.
-	 */
 	if (mode != PSR_MODE_EL2t && mode != PSR_MODE_EL2h) {
 		kvm_err("Invalid host exception to nVHE hyp!\n");
 	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
@@ -322,9 +317,11 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 		if (file)
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
-			kvm_err("nVHE hyp BUG at: %016llx!\n", elr_virt + hyp_offset);
+			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
+					(void *)panic_addr);
 	} else {
-		kvm_err("nVHE hyp panic at: %016llx!\n", elr_virt + hyp_offset);
+		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
+				(void *)panic_addr);
 	}
 
 	kvm_nvhe_dump_backtrace(hyp_offset);
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 54ad86d13784..19aba43d9da4 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -111,7 +111,7 @@ static bool is_ignored_symbol(const char *name, char type)
 		".LASANPC",		/* s390 kasan local symbols */
 		"__crc_",		/* modversions */
 		"__efistub_",		/* arm64 EFI stub namespace */
-		"__kvm_nvhe_",		/* arm64 non-VHE KVM namespace */
+		"__kvm_nvhe_$",		/* arm64 local symbols in non-VHE KVM namespace */
 		"__AArch64ADRPThunk_",	/* arm64 lld */
 		"__ARMV5PILongThunk_",	/* arm lld */
 		"__ARMV7PILongThunk_",
-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
