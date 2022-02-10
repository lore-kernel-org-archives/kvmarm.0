Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B0DC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 09:28:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C515D4A0FE;
	Fri, 11 Feb 2022 04:28:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y1p7Dv7ej0M4; Fri, 11 Feb 2022 04:28:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 401574B09C;
	Fri, 11 Feb 2022 04:28:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80DD149F17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:47:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wetJhSDWH4VN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 17:47:14 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5178D49F10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:47:14 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 2-20020a251302000000b006118f867dadso15065036ybt.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=0KTIZ/BsAXUFEI2iaae3XhjiZCEBM5hWuzmqdk8v8UY=;
 b=ZHZcx5xA7EHUTHCEaadFyiIjhdIRYxHvTFae4ko0TI3GsIog1bV3SjKx1jRojQWUj9
 9YmFQDHXzEGOwzo0jbIx2p05gWQot0LfhQEneSFTIQDTsEvDEu3cbgpbhfSSiOKTck7B
 XnA5mt4AM4oFT952jp0wtfNf7wV5ozC6f4FRX17E75v7SVOIT6Qq311evP23Cd+WxpCL
 t4yqScsbIWIhUS/HOMp6RY2OVDmFmetiuTA2yxdyMmNDQyRHtrtm3pjz0CB+NKSsCK+K
 F7SOpuTg/HVJ5A4DPQFaIsMVgylVqHlTpMjmwpbi8GWIswYd63eFghrQb2JVt08OjyHt
 AohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=0KTIZ/BsAXUFEI2iaae3XhjiZCEBM5hWuzmqdk8v8UY=;
 b=hsFzvCNM0PLrwXQy1l5Z872dLivNeu+ShqoPcCkXFhwlCiBbqx5z44PT90bevFaq0d
 5o4+eG08Rfk9NcxOsmuwAcePGcdbh+63G6mRlNQfuIBkVie8KVmduJhuulGwC8Pbwsua
 S9mJrh3pEzM+/SG7L9dD3eCsSL8sSkUp+lwHYABiFjQjET+bUxD3IyuRh/oF0QfxQVry
 50yXhr/BZcoavefeHC6yPLlDBzSgBTY2kRo7QWk7azd7zDmyXpsMH3Mus9OkWWBQK/LS
 AGPPjY0wveu2Yg2yYir2AcyxmNqg4Zu+wtVbIw+/ENM62M/STfeD0dC+Td41WFYM3ggu
 /qIg==
X-Gm-Message-State: AOAM531AD3aOOHQuJaqNryr3iFS9vEscf/y7sMWeyp5b53RC+JwXtmW/
 xqmzOpvaWrPaMCmfMDM5K2uLBl0fMPUADH2/pQ==
X-Google-Smtp-Source: ABdhPJw5p/Uh7hAVUUQUoiuUOWMwTt8ZLF4sqcEFxLAvSzIjy7oy/SoNwO/Prk3wKZ7puGZ6SI+A+MoEUcuHAzw3bA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:8f02:232:ad86:2ab2])
 (user=kaleshsingh job=sendgmr) by 2002:a81:b650:: with SMTP id
 h16mr9312369ywk.238.1644533233863; Thu, 10 Feb 2022 14:47:13 -0800 (PST)
Date: Thu, 10 Feb 2022 14:41:48 -0800
In-Reply-To: <20220210224220.4076151-1-kaleshsingh@google.com>
Message-Id: <20220210224220.4076151-8-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220210224220.4076151-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH 7/7] KVM: arm64: Symbolize the nVHE HYP backtrace
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 11 Feb 2022 04:28:10 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, surenb@google.com,
 linux-arm-kernel@lists.infradead.org
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

Some sample call traces:

-------
[  167.018598][  T407] kvm [407]: nVHE hyp panic at: [<ffffffc0116145cc>] __kvm_nvhe_overflow_stack+0x10/0x34!
[  167.020841][  T407] kvm [407]: nVHE HYP call trace:
[  167.021371][  T407] kvm [407]: [<ffffffc011614934>] __kvm_nvhe_hyp_panic_bad_stack+0xc/0x10
[  167.021972][  T407] kvm [407]: [<ffffffc01160fa48>] __kvm_nvhe___kvm_hyp_host_vector+0x248/0x794
[  167.022572][  T407] kvm [407]: [<ffffffc0116145dc>] __kvm_nvhe_overflow_stack+0x20/0x34
[  167.023135][  T407] kvm [407]: [<ffffffc0116145dc>] __kvm_nvhe_overflow_stack+0x20/0x34
[  167.023699][  T407] kvm [407]: [<ffffffc0116145dc>] __kvm_nvhe_overflow_stack+0x20/0x34
[  167.024261][  T407] kvm [407]: [<ffffffc0116145dc>] __kvm_nvhe_overflow_stack+0x20/0x34
. . .

-------
[  166.161699][  T409] kvm [409]: Invalid host exception to nVHE hyp!
[  166.163789][  T409] kvm [409]: nVHE HYP call trace:
[  166.164709][  T409] kvm [409]: [<ffffffc011614fa0>] __kvm_nvhe_handle___kvm_vcpu_run+0x198/0x21c
[  166.165352][  T409] kvm [409]: [<ffffffc011614980>] __kvm_nvhe_handle_trap+0xa4/0x124
[  166.165911][  T409] kvm [409]: [<ffffffc01160f060>] __kvm_nvhe___host_exit+0x60/0x64
[  166.166657][  T409] Kernel panic - not syncing: HYP panic:
. . .
-------

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kvm/handle_exit.c | 11 +++--------
 arch/arm64/kvm/stacktrace.c  |  2 +-
 scripts/kallsyms.c           |  2 +-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b038c32a3236..d7f0f295aebf 100644
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
@@ -322,9 +317,9 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 		if (file)
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
-			kvm_err("nVHE hyp BUG at: %016llx!\n", elr_virt + hyp_offset);
+			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr, panic_addr);
 	} else {
-		kvm_err("nVHE hyp panic at: %016llx!\n", elr_virt + hyp_offset);
+		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr, panic_addr);
 	}
 
 	hyp_dump_backtrace(hyp_offset);
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index 3990a616ab66..4d12ffee9cc6 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -261,7 +261,7 @@ static void hyp_dump_backtrace_entry(unsigned long hyp_pc, unsigned long hyp_off
 	hyp_pc &= va_mask;
 	hyp_pc += hyp_offset;
 
-	kvm_err(" [<%016llx>]\n", hyp_pc);
+	kvm_err("[<%016llx>] %pB\n", hyp_pc, hyp_pc);
 }
 
 void hyp_dump_backtrace(unsigned long hyp_offset)
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
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
