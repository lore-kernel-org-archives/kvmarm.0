Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B91AC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 20:07:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E971A49ECE;
	Mon, 14 Mar 2022 16:07:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aVvehRjgYlHK; Mon, 14 Mar 2022 16:07:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCCDD40A84;
	Mon, 14 Mar 2022 16:07:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6A1440A84
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:07:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lIxkR0ntF49y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 16:07:04 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5B4B4086D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:07:04 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2dc7bdd666fso141105647b3.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 13:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=7WPeIutFQ8MpWvUoMJwXeeMUz9b7tskLEPBl/3D4C6U=;
 b=cxwJyz+g5A+OyqgvqDWvQe+JtpGKB6vHjvy5/DobHD8VmnHbQT7A8rTMSYElYviMzV
 W2Ps0EwVwxAvO4EXrcUP+dDEnYoUg3I3HrOiQ1Fegi6FffpY/SExycCPO8B9as25wbEs
 mwIMQpE2KLgaM4IFNmfC7KuV140gff8y5mz7qMpS/pLSxfK5wmgHsyGsDCF+j20zyA/M
 YFwqfQz2bm5J7nmGQAcJNNF9upClL6AnaCzH+kLXvABXiE8HErJNMACfTubNk6o3WD6n
 kf0Pwd1Kc522idPnHKae37N1MgRr0LwMpNAJ0ASvNDXcruiU4hGYsN5Aj6i1mx1VtsKw
 yZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=7WPeIutFQ8MpWvUoMJwXeeMUz9b7tskLEPBl/3D4C6U=;
 b=ukQiAwF1OSnoq6rC6YqThQ2q9UvLDl+jCmNxuU+kb5ljr5KyFtiGjuKnP18rcchweG
 JKO7RM9sdWOU4fwbhgESgotmAV2Exn6aCrX9OwQ8i0YfQrnrzH7JqcWuCUO5yQbGzn4q
 5bynxbvBP/EGSAqb7RiW4uMcDJdwfcslfQeI//BSkCSAgun9OH2RQbXs4ZrnsJUo5IIj
 P/BvCv20dIS4oc8ov4HFxAKizujyn50O62/2tCiCBQhyFKv8lmdDdQ6KyLjKgbpRUZO0
 Gmp/I4+Wlm4n+W1hs/FecpQRLdEU54KnBjVp+tmEkttfGJRB2BoelGrltftaYZaYXn91
 JifA==
X-Gm-Message-State: AOAM531TIci7DujSoVO+k7MwTVWz7nei0FJ9uIGoP8q57+amBRdfwayH
 QzefskEW9af6AYTDVXpQl2zBBrLQTfgG8N54Nw==
X-Google-Smtp-Source: ABdhPJwqmuZWietxle5e91HveZ+teLadkWuBWcTKe8lzVoiXl7o144fZFzG4YZ53zF6KF//5yrRIAJR7dEQ1e0ntag==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:500a:9ac2:e73e:69e3])
 (user=kaleshsingh job=sendgmr) by 2002:a25:2514:0:b0:62e:a211:a940 with SMTP
 id l20-20020a252514000000b0062ea211a940mr17232935ybl.122.1647288424162; Mon,
 14 Mar 2022 13:07:04 -0700 (PDT)
Date: Mon, 14 Mar 2022 13:01:17 -0700
In-Reply-To: <20220314200148.2695206-1-kaleshsingh@google.com>
Message-Id: <20220314200148.2695206-9-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220314200148.2695206-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 8/8] KVM: arm64: Symbolize the nVHE HYP backtrace
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
