Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EDEC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 21:46:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBE744079D;
	Wed, 20 Apr 2022 17:46:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BgaHRT-9ej4q; Wed, 20 Apr 2022 17:46:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FEC640E62;
	Wed, 20 Apr 2022 17:46:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5F804079D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 17:46:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aMQbBlqFPx3L for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 17:46:50 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAA2440797
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 17:46:50 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 t18-20020a257812000000b0064140091ba2so2695213ybc.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 14:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=3TRcCUUaZ+b7tjFg88UNtO89FA4GsBVVD3ULOF8xuc0=;
 b=fNlEbCPYFY/2sKN0B+7mRjKWh9Vmc0mQaldUs5//VcDe8AKIWT3mEXRG2KmS10vL5m
 55EK4a6Y6SvHoEHe583jl1ltI7lA3lfGImFy/DQ2SKUpe8Irwm8RZBCCkLKpl4jwU2hE
 cQjtaRRrYRRRRGCWFwdlb4iNu1ZFs+3MDX+TOnItxhcue3RRUprY5La0mnX8uvo+dqjt
 2Mxx/8gIDsYenMuLbEfx/0MI476D/uSdF3vFghFSAOT/mzBSXqlZchMjcvwiSaJPI+yl
 685YmTacJ70CuTt+LNso67g/Cybklwhm0T5nrSbQ3W8Y2OVqVugGT8KvrofMeWv2RMV8
 OYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=3TRcCUUaZ+b7tjFg88UNtO89FA4GsBVVD3ULOF8xuc0=;
 b=tYi1CmoTcTun/8bhof1mM+hPcWY4iFT1eGqFjnSE9DGls/KyF7wbcS8jb1OIYWjvFF
 1/34puxfRGGY+CXLT2yduo/94JVpI0jlwcrWwkjett3avLteneEUc9y/IdJHUUvfvcl2
 Rqz3NVTDBcUHZ1N4tcYwCfrOoeptK+GpP/5wce9kxVJg56aEOytQ+xg0+JJiVVXfiJWs
 R1cM3XkzLOA+s17D2oRXGROMe+IySZ79YUf58KOGvGyeZ0nBT+Je2w4SvGs6waQAQzIo
 ReRbCMToewID0lUq1qpfMotituyLWSgTI5QTR7RTWKJAkWh7uqdRsJbDMU9JbpegyPEq
 lKKw==
X-Gm-Message-State: AOAM531+J6Rnf6UxkTLYXHjousKhyZKz3ctyV7f8hM3uvgxPoCEmvytR
 Tyi9pSTrrlN7WDGQ6qhj8AUibISx8ssDyV/q2g==
X-Google-Smtp-Source: ABdhPJxyWCmldtrllRKLYN9yFrNAbR/NngkeHfsRFEFtVhkoioyyWhx2dJv29w6NEgLNecP0TQ8HxC5kcoFaJH7jLQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:2a20:cec4:8f41:cd6f])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:70c:b0:645:58e:a3ac with SMTP
 id k12-20020a056902070c00b00645058ea3acmr17151653ybt.380.1650491210272; Wed,
 20 Apr 2022 14:46:50 -0700 (PDT)
Date: Wed, 20 Apr 2022 14:42:57 -0700
In-Reply-To: <20220420214317.3303360-1-kaleshsingh@google.com>
Message-Id: <20220420214317.3303360-7-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220420214317.3303360-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v8 6/6] KVM: arm64: Symbolize the nVHE HYP addresses
From: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Walbran <qwandor@google.com>, will@kernel.org, maz@kernel.org,
 Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Nathan Chancellor <nathan@kernel.org>,
 Changbin Du <changbin.du@intel.com>, linux-arm-kernel@lists.infradead.org,
 surenb@google.com
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
addresses using the %p print format specifier:

[   98.916444][  T426] kvm [426]: nVHE hyp panic at: [<ffffffc0096156fc>] __kvm_nvhe_overflow_stack+0x8/0x34!

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---

Changes in v8:
  - Also ignore local symbols prefixed by '.L' in KVM nvhe namespace,
    per Marc

Changes in v6:
  - Add Fuad's Reviewed-by and Tested-by tags.
  
Changes in v2:
  - Fix printk warnings - %p expects (void *)


 arch/arm64/kvm/handle_exit.c | 13 +++++--------
 scripts/kallsyms.c           |  3 ++-
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 97fe14aab1a3..a377b871bf58 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -295,13 +295,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
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
@@ -321,9 +316,11 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
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
 
 	/*
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 8caabddf817c..e6906f79833d 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -111,7 +111,8 @@ static bool is_ignored_symbol(const char *name, char type)
 		".L",			/* local labels, .LBB,.Ltmpxxx,.L__unnamed_xx,.LASANPC, etc. */
 		"__crc_",		/* modversions */
 		"__efistub_",		/* arm64 EFI stub namespace */
-		"__kvm_nvhe_",		/* arm64 non-VHE KVM namespace */
+		"__kvm_nvhe_$",		/* arm64 local symbols in non-VHE KVM namespace */
+		"__kvm_nvhe_.L",	/* arm64 local symbols in non-VHE KVM namespace */
 		"__AArch64ADRPThunk_",	/* arm64 lld */
 		"__ARMV5PILongThunk_",	/* arm lld */
 		"__ARMV7PILongThunk_",
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
