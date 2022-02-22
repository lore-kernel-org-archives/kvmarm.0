Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDEDC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4488F4C461;
	Wed, 23 Feb 2022 06:02:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id clr1i2QK5psa; Wed, 23 Feb 2022 06:02:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A1F44C4A7;
	Wed, 23 Feb 2022 06:02:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC95B49EEA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 12:02:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WO-ALxFYj19d for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 12:02:49 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9BE940BF0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 12:02:49 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 s133-20020a252c8b000000b0062112290d0bso24793901ybs.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 09:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=beGtXg45IQ4dKCY/A8ewT2jAssjG8oCd/wil2F8VoF8=;
 b=Qmw8f9ngENw67mW7ZY926jso9fM6FSWsadBt2xuNCmEM/wL9yNNx+++6QAzW5Geysa
 X0CVpzvJkNzo1xClPSFGBfQoQ9e82eUu5kgF0cfza/NxsGQMydRbfBIhqKkBzLs5aCzK
 VBY/ce5OQiMkErnhinkSoy35Z7xGC9tfoOBy0pVxgyAmPZog1qhtESjBaWlKEIEeimgX
 bKnw6hLvfmjhuk5Ps7Kiuf9lL11CkBXEiVCRXEz1k0Pj8iOLK68P3f2mF/3G5iD/5IP2
 26qsHRaykVbWjx15kawdg3HR402vdDmc9IFBtIz1CQ/1k/qSnS4QDbrQcuG21X7huvEk
 B9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=beGtXg45IQ4dKCY/A8ewT2jAssjG8oCd/wil2F8VoF8=;
 b=LRRr1189+mZbjIKLjlVcjCQH5dNfnXlBT6PNcNE8Xv/7wLlvvvGLxPEpSLA/DSQnrK
 nyN9l2zmDRHP4ewqBLlgpjP0RAHvXuv503Sj6z6Vt+DAIh3UsEGM/KWd/i2bkQu2Cr+s
 PdxDZ3EObGJK0sGSqMWlb+qaEs6VTswyU3mMf37tX/AP9gZRID+TTfxKo3Wiz/DDoJAU
 PFOmAgUY0Rt0Q640YLca+O8qZALSE8HjhxkxVJEAsCKFmhRuy8Id+cSotOWUSI1VMcWH
 JqL0Jc7i2GcE1rEwF6pLqaUlAfdzSgJPNp0B4dZHDg4mfmXmiP2/cs0M5qPjdaQ0T3fp
 QWtQ==
X-Gm-Message-State: AOAM533E+nNyl3Xfi8Y1Jx3GnnX75rw3XJIwi8qYxoB5m0sLxogP9ygl
 /CqKRNGPhKCFKC3wL/n1ttFkCIXpbBNToJw/xg==
X-Google-Smtp-Source: ABdhPJx9ya/dSuGbtyc2Drwg2dL1gTZ3RclR9peZ4NgVIVWBnHY+dyxNePng3kg7EOauiAGLQaMx/zndC7RygsTqtw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5db7:1235:b3dd:cfcb])
 (user=kaleshsingh job=sendgmr) by 2002:a25:d60c:0:b0:610:dc8d:b3bd with SMTP
 id n12-20020a25d60c000000b00610dc8db3bdmr24399063ybg.561.1645549369167; Tue,
 22 Feb 2022 09:02:49 -0800 (PST)
Date: Tue, 22 Feb 2022 08:51:10 -0800
In-Reply-To: <20220222165212.2005066-1-kaleshsingh@google.com>
Message-Id: <20220222165212.2005066-10-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220222165212.2005066-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v2 9/9] KVM: arm64: Symbolize the nVHE HYP backtrace
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 Andrew Walbran <qwandor@google.com>, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, Pasha Tatashin <pasha.tatashin@soleen.com>,
 surenb@google.com, Peter Collingbourne <pcc@google.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

Changes in v2:
  - Fix printk warnings - %p expects (void *)

 arch/arm64/kvm/handle_exit.c | 13 +++++--------
 arch/arm64/kvm/stacktrace.c  |  2 +-
 scripts/kallsyms.c           |  2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b038c32a3236..1b953005d301 100644
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
 
 	hyp_dump_backtrace(hyp_offset);
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index cdd672bf0ea8..896c225a4a89 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -261,7 +261,7 @@ static void hyp_dump_backtrace_entry(unsigned long hyp_pc, unsigned long hyp_off
 	hyp_pc &= va_mask;	/* Mask tags */
 	hyp_pc += hyp_offset;
 
-	kvm_err("[<%016lx>]\n", hyp_pc);
+	kvm_err("[<%016lx>] %pB\n", hyp_pc, (void *)hyp_pc);
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
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
