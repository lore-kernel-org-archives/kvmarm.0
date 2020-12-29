Return-Path: <SRS0=Fui2=GB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780E9C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 29 Dec 2020 22:11:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 108F1221F8
	for <kvmarm@archiver.kernel.org>; Tue, 29 Dec 2020 22:11:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 108F1221F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B33054B29F;
	Tue, 29 Dec 2020 17:11:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ftxDTeEtke1V; Tue, 29 Dec 2020 17:11:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F67A4B30C;
	Tue, 29 Dec 2020 17:11:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE9094B2B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 16:43:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hA4+OW4ETCP9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Dec 2020 16:43:41 -0500 (EST)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F72E4B2AE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 16:43:41 -0500 (EST)
Received: by mail-qt1-f178.google.com with SMTP id z20so9856797qtq.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 13:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=HyTMgo2VSftHBiDIe/SLp0txxvwc3jI6o6j5ZlWh/dw=;
 b=f0dILRFveWykzV+Z08AvfOmj26DARStkXTD2rimwgfWkfyVMqtfKDgl3xemZfvShcu
 wchzqQrdG3m9iLk3zCc2lgOa4be5mWmA4hJxWlc9OIqKOIavkMFv6U0Wjp6biO7jNHxK
 VMfU2h8EmtfFqiB1wQ3c5h10hPIZ7hfjpQAmzIEK/42ryVwsOtWnfffmx2hRQxlvPRm+
 lRPE3BxPkpJITLJ7pTCbUOWEdU8v3PPQzLPhxT2jCXyBltLlN/cFMCVqIUwTYvGWhpfP
 ahaKWxBfxutvEc4bFDrcIH5LZPJsw0wSv2gcWlpWUfD8WAA4MzYvetKlsExY7T9FmwSZ
 aFhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=HyTMgo2VSftHBiDIe/SLp0txxvwc3jI6o6j5ZlWh/dw=;
 b=RAHoj9CaCiAvvShTFPPoOOqlzWYcS4awWbqNfZ9fWg25+/1RLiJvcjZ43iJNIeTUCP
 JlAMFvQgDjc8c57fu5fIPbolQfEFjEWuLjWkb0v2tMR4XkSQhmCgxi3Zfgr/Z6Ez+iVQ
 qogBWzWw8iXpWsbOOZgrMXlXbb2PQTVv+/Ua5G+Xumy+EUUT7JSfAzON+BYG+c+xubFY
 7Ib+CTTd1x1xy3uTO+hI6C5o6VXrlxQ0udt4v5pqh83/VnohaRx9cZhvo1OPWrVuPsSB
 6CAD5JYaHjbfErWr4uci/VSon9jdR8Ixb0EQoRgXMYbS6PPwB5/I9wIqSbyNfEAaB5GN
 AiFQ==
X-Gm-Message-State: AOAM531GWt0nDsW+Qad/mw6pTGsZPyARqbKhbXv1kycM1n2rkmYL+Uz3
 CzBU1+hNrFnscGKDjnlxsNk=
X-Google-Smtp-Source: ABdhPJxNRqILS8BFoDpnYl60ROLPkm6ALqjECJjXraNE4zHWZETdZN9t0HskLPCKTUrnD0VAHbTDpA==
X-Received: by 2002:ac8:1184:: with SMTP id d4mr50229998qtj.103.1609278221078; 
 Tue, 29 Dec 2020 13:43:41 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:45f1:1d00::1])
 by smtp.gmail.com with ESMTPSA id 17sm25725927qtb.17.2020.12.29.13.43.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 29 Dec 2020 13:43:40 -0800 (PST)
From: Nathan Chancellor <natechancellor@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: arm64: Fix section mismatches around hyp_cpu_pm_{init,
 exit}
Date: Tue, 29 Dec 2020 14:43:36 -0700
Message-Id: <20201229214336.4098955-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mailman-Approved-At: Tue, 29 Dec 2020 17:11:21 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 clang-built-linux@googlegroups.com,
 Nathan Chancellor <natechancellor@gmail.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Commit fa8c3d65538a ("KVM: arm64: Keep nVHE EL2 vector installed")
inadvertently changed clang's inlining decisions around
hyp_cpu_pm_{init,exit}, causing the following section mismatch warnings:

WARNING: modpost: vmlinux.o(.text+0x95c6c): Section mismatch in
reference from the function kvm_arch_init() to the function
.init.text:hyp_cpu_pm_exit()
The function kvm_arch_init() references
the function __init hyp_cpu_pm_exit().
This is often because kvm_arch_init lacks a __init
annotation or the annotation of hyp_cpu_pm_exit is wrong.

WARNING: modpost: vmlinux.o(.text+0x97054): Section mismatch in
reference from the function init_subsystems() to the function
.init.text:hyp_cpu_pm_init()
The function init_subsystems() references
the function __init hyp_cpu_pm_init().
This is often because init_subsystems lacks a __init
annotation or the annotation of hyp_cpu_pm_init is wrong.

Remove the __init annotation so that there are no warnings regardless of
how functions are inlined.

Fixes: 1fcf7ce0c602 ("arm: kvm: implement CPU PM notifier")
Fixes: 06a71a24bae5 ("arm64: KVM: unregister notifiers in hyp mode teardown path")
Link: https://github.com/ClangBuiltLinux/linux/issues/1230
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6e637d2b4cfb..71a49eae9ea0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1574,12 +1574,12 @@ static struct notifier_block hyp_init_cpu_pm_nb = {
 	.notifier_call = hyp_init_cpu_pm_notifier,
 };
 
-static void __init hyp_cpu_pm_init(void)
+static void hyp_cpu_pm_init(void)
 {
 	if (!is_protected_kvm_enabled())
 		cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
 }
-static void __init hyp_cpu_pm_exit(void)
+static void hyp_cpu_pm_exit(void)
 {
 	if (!is_protected_kvm_enabled())
 		cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);

base-commit: 5c8fe583cce542aa0b84adc939ce85293de36e5e
-- 
2.30.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
