Return-Path: <SRS0=An/p=IE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9359EC433E0
	for <kvmarm@archiver.kernel.org>; Sat,  6 Mar 2021 10:29:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1AB06501D
	for <kvmarm@archiver.kernel.org>; Sat,  6 Mar 2021 10:29:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1AB06501D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74B2C4B4DD;
	Sat,  6 Mar 2021 05:29:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D423+MksZjfo; Sat,  6 Mar 2021 05:29:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50D924B4A2;
	Sat,  6 Mar 2021 05:29:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C61B4B69F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 15:21:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 23YPvlEyLeTg for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 15:21:28 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B2EE4B695
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 15:21:28 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id v196so3736602ybv.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 12:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=ulCKWwAgru14Pv0YBVciE6nHg3ZbaOajNEmz/MDhZ0E=;
 b=sUy/MKxPm0e0JaDZ61ZMVYmchygwUzsxZVRFhQ7ZB6rmk6BwKXl14SNbFoDUTOKgFa
 0ZKz2GEdT6lCTv01QXUfs5j8jrrEPZnjznZ5fha2ou4kuOABBQfjF8z70CrDys7tlVir
 3gH/EzvBcog9XTOaiVntPn9TJh0HdgKMRTYaEO86WDpFDX0uwo5S3c/KCefXmBFLTzLm
 i5NmOaBz7F/XIIWrZsaxhcpEb/dhSAGbBDiZYbh8quMAQGNavxnkkzMF+sGatxLHj9AC
 qKVBGb0/X80WMyGrAzKqxERNLhvZyx7tJI0leqSAdxwM+FfRUXZZ5xYLZX+NP18/qMl1
 yNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=ulCKWwAgru14Pv0YBVciE6nHg3ZbaOajNEmz/MDhZ0E=;
 b=mBOC6E23gda8duF0nToLQStN+VdRiYBa4Si/F6HGXn4rufMmpja09lce+JAGlndwCl
 RDN11rgdP+RCD0gSowxx/I6jRM6vs/NtJ9CMQszvN6zZIjiSdDVjTpHwDVygM7MlJsjv
 gn3cIonyY5zW7A8F5E/W4YfMDGT+k1YfCXvL0lkTCCWJKMCBWQIQlXuNPI8fgIM64bcB
 P3+6jCnEI8iCtNcRlWdfehUoAsQtbBmzgiDzzDsFM9tGukiM8+18t3k5LN3CyklMCYNI
 ZSwhKw9aGtArSWCP5GNBpr5jF8/MDypZxYOvBGRcjjoWPF2FUk25Su63F57qUXJcF/xB
 eBOg==
X-Gm-Message-State: AOAM532WPkouomnoiKfoD7JIdlWKD+be6E5YTS5SqXR2JdHHaMcWckbc
 PN6OSC6FLVFPnd9kqKX+fKbaCVlm33id7ROCS3E=
X-Google-Smtp-Source: ABdhPJzugclOPUcMl5rWpXYbl208BWEimx+fJTo5zFfMCx70e7i5TD/OVFvRhSrWZ4lMnOshHJ+EWZ1oZ8vlNNhorTs=
X-Received: from samitolvanen1.mtv.corp.google.com
 ([2620:15c:201:2:1d29:d678:6e3a:704d])
 (user=samitolvanen job=sendgmr) by 2002:a25:8706:: with SMTP id
 a6mr15467374ybl.158.1614975687742; Fri, 05 Mar 2021 12:21:27 -0800 (PST)
Date: Fri,  5 Mar 2021 12:21:24 -0800
Message-Id: <20210305202124.3768527-1-samitolvanen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] KVM: arm64: Don't use cbz/adr with external symbols
From: Sami Tolvanen <samitolvanen@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>
X-Mailman-Approved-At: Sat, 06 Mar 2021 05:29:25 -0500
Cc: Kees Cook <keescook@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>,
 Will Deacon <will@kernel.org>
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

allmodconfig + CONFIG_LTO_CLANG_THIN=y fails to build due to following
linker errors:

  ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21CC):
  relocation R_AARCH64_CONDBR19 out of range: 2031220 is not in
  [-1048576, 1048575]; references hyp_panic
  >>> defined in vmlinux.o

  ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21E0):
  relocation R_AARCH64_ADR_PREL_LO21 out of range: 2031200 is not in
  [-1048576, 1048575]; references hyp_panic
  >>> defined in vmlinux.o

This is because with LTO, the compiler ends up placing hyp_panic()
more than 1MB away from __guest_enter(). Use an unconditional branch
and adr_l instead to fix the issue.

Link: https://github.com/ClangBuiltLinux/linux/issues/1317
Reported-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kvm/hyp/entry.S | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index b0afad7a99c6..c62265951467 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -85,8 +85,10 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 
 	// If the hyp context is loaded, go straight to hyp_panic
 	get_loaded_vcpu x0, x1
-	cbz	x0, hyp_panic
+	cbnz	x0, 1f
+	b	hyp_panic
 
+1:
 	// The hyp context is saved so make sure it is restored to allow
 	// hyp_panic to run at hyp and, subsequently, panic to run in the host.
 	// This makes use of __guest_exit to avoid duplication but sets the
@@ -94,7 +96,7 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// current state is saved to the guest context but it will only be
 	// accurate if the guest had been completely restored.
 	adr_this_cpu x0, kvm_hyp_ctxt, x1
-	adr	x1, hyp_panic
+	adr_l	x1, hyp_panic
 	str	x1, [x0, #CPU_XREG_OFFSET(30)]
 
 	get_vcpu_ptr	x1, x0

base-commit: 280d542f6ffac0e6d65dc267f92191d509b13b64
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
