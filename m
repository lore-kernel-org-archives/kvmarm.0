Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B33C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 22:02:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3FBA64FF0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 22:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3FBA64FF0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53B7F4B4D0;
	Thu,  4 Mar 2021 17:02:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qkNNIWZy80Ja; Thu,  4 Mar 2021 17:02:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76A364B56F;
	Thu,  4 Mar 2021 17:02:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0D8C4B624
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 13:45:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zNMzo--DM4zd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 13:45:48 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1C484B622
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 13:45:48 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id w2so8090485pjk.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 10:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=FHJbv/IQitHrDrqVV5Zv3feuTlL4Ima66irM/2+LBrM=;
 b=wRgnh5UtXhuDMEX4WcxzBYAuLiE44UoxjjEiFelNA/MY0cFHVj48pME9fSr35jrMFE
 tSuyPw2CTDTdDIuy2+baTjYoz/wY8tQa6exgABVRCswBJrn+hjSwzUZWXny19wggiVrw
 ivQTLxairGocBLde57e2olP4slyQ5tt92+sSshb63VLs1P9CrtqXtbWWE4wQEonyL86d
 uOhNhNe3NpndX/wFly+2qibRgAe2Q1QOjFOJNAJ6S1weKBl9tZmhscVg489lt3wLn8wB
 IlD2/WxJkMUZ/Nvsb6yivdGf5ni3Beh+AXoUzorwOrU/794T4T4gKoxVoQDad1XkunUz
 wRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=FHJbv/IQitHrDrqVV5Zv3feuTlL4Ima66irM/2+LBrM=;
 b=EBw9RSK1xgv111rHLGZhlHYnp7zUXDGfFwlQuiaHWOVkSOkxXzM5jWHtarPsaGL2Zz
 wG7XPYsIDZ9nBslf1Gwk6E6BrkYrDu6sbYlPg5NjvXqgBKD2Dd6N8cwlViC2C+P9mZ8g
 B9OxeZu/GeRqdEjce9dtY2eMHiU0lCI7mvJvdYOXVmTZAmiO6U0YF1Vh7GaKj8/f3cz0
 pxf2PXUhJR6h3KKu62kUBhTgN6VO+i064CdukdI2n2zrOWJl0Q/+LnMq2NzuKX6Qo2Zq
 cNvOf6NphmW2IXci11jrZqvcfQFFBB6iuLUhFVNCEgOPEaJ+4hGSFYb/npnCydB4b2EH
 AhvQ==
X-Gm-Message-State: AOAM531GD1YSER4ZfuKyM4Vzn+0jm59neJGm/wjzMYVLzh6BL79VfQSL
 9W7KzYC1+3g59nffM6YWmPjeCzv3K8sRQvt+dTQ=
X-Google-Smtp-Source: ABdhPJwfgFOcLFg9DksNl5+x+5Ik41PWFI2fJWyTU8ahVjM+/AOUwJrkCCQX7ndFdpkYHpBGBfgJrt3sQ6pNyQya1sQ=
X-Received: from samitolvanen1.mtv.corp.google.com
 ([2620:15c:201:2:c931:40c9:b7a5:6cc8])
 (user=samitolvanen job=sendgmr) by 2002:a17:90b:1b46:: with SMTP id
 nv6mr5948244pjb.45.1614883547630; Thu, 04 Mar 2021 10:45:47 -0800 (PST)
Date: Thu,  4 Mar 2021 10:45:44 -0800
Message-Id: <20210304184544.2014171-1-samitolvanen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] KVM: arm64: Disable LTO in hyp
From: Sami Tolvanen <samitolvanen@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>
X-Mailman-Approved-At: Thu, 04 Mar 2021 17:02:13 -0500
Cc: Kees Cook <keescook@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Nathan Chancellor <nathan@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

As LTO is not really necessary for the hypervisor code, disable it for
the hyp directory to fix the build.

Link: https://github.com/ClangBuiltLinux/linux/issues/1317
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kvm/hyp/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 687598e41b21..e8116016e6a8 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -11,3 +11,6 @@ subdir-ccflags-y := -I$(incdir)				\
 		    $(DISABLE_STACKLEAK_PLUGIN)
 
 obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
+
+# Disable LTO for the files in this directory
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))

base-commit: f69d02e37a85645aa90d18cacfff36dba370f797
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
