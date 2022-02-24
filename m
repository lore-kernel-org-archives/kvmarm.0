Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF73C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 10:36:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C31654BFCE;
	Thu, 24 Feb 2022 05:36:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PeWr+rPPWEFh; Thu, 24 Feb 2022 05:36:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64F3C4C066;
	Thu, 24 Feb 2022 05:36:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2701C4BC7E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:23:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HsVRVqd4MBgp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 00:23:40 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A2014BC67
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:23:40 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 i6-20020a255406000000b006241e97e420so944519ybb.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 21:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=fcCfTEScaMgjegsqAtCFQCUUlnf7S421rxV5/DLFNa4=;
 b=K2UkLk6KH0WGprg1Tt3b/YISPTEbGJ5NwL75GWwwQRifJr+Ia78r3xJ74AmzAn6des
 +RpW5F9uvgZ9sJ1fT5i6np+KQN4qKRmZSJJLm2W9x5SYPYx8og6F3yLGsatCWV6FzEDf
 673NAhqpRqg9eTDgS3UnApqhvX/5GRHjopLIWxweU9YOKdQpVxRnTDNuOFv5bZKbiXBW
 6zpPdP2dAFKxHQAsD8SNy1C39D6al0+AgBC+DSjUXheYoiIBU/1Kmxx/wpNbXRnyHlFP
 d6Mi3V5tWu+SiyXcU2q1ve1zdVP5SR3nN7kl8jsFPLZhM2l3A8Uk9bYysuSZ57PN/rxz
 s+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=fcCfTEScaMgjegsqAtCFQCUUlnf7S421rxV5/DLFNa4=;
 b=BZz12eVHMB8AtB3GB4im+x0vX/qXK00hQJu08UkTdZ2gz/Gw0diS4rEc9x0i5QxvoT
 n51SG43ywmRUWxGuyv+0dmMWBgr/pB/FKCf1vPyjRmRRXLOA/SRk1n/oca7JwP1rwmyY
 06zgq64IZ9BrjvYnZVdCE3W0uE6D431xGPw95VgI40P9Z+B6w9e4xAPwVE4dkhcPO/Rc
 Hg4OSaD93kqoDSZcAs6k4rgfVIaMTYMf7gP8cAt2gjZlUyr8Kyyyw2sd5QiZlxitZTYP
 ZATikCm5tyA3y2caXeELkfJr5Q2rM96lrepGdNmIm+a9YzED7Hii+umCp316xhs5s1dP
 onsw==
X-Gm-Message-State: AOAM531gd/6gEfvQ11A/qnflUaxJA0I21riHPAiqx+Hg8zn8X3Dvbs50
 B/l0QVE00w45q6pRsjGOUFM1KiECcOQEfWuW7g==
X-Google-Smtp-Source: ABdhPJwr5WYU+mcvUrEVYhYcHNbWEi05aKeybW8uxmEUPY7QeTHeRrUuULjEo5RNfVU+of1dj3HUHZ68vUNHlphVAQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:415c:9be0:c461:440a])
 (user=kaleshsingh job=sendgmr) by 2002:a25:30d6:0:b0:624:cd97:b907 with SMTP
 id w205-20020a2530d6000000b00624cd97b907mr981062ybw.542.1645680219922; Wed,
 23 Feb 2022 21:23:39 -0800 (PST)
Date: Wed, 23 Feb 2022 21:13:43 -0800
In-Reply-To: <20220224051439.640768-1-kaleshsingh@google.com>
Message-Id: <20220224051439.640768-9-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 8/8] KVM: arm64: Symbolize the nVHE HYP backtrace
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Thu, 24 Feb 2022 05:36:21 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Walbran <qwandor@google.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Kalesh Singh <kaleshsingh@google.com>, linux-arm-kernel@lists.infradead.org,
 surenb@google.com, kvmarm@lists.cs.columbia.edu
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
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
