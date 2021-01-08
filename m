Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B842C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9590B239EB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9590B239EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 372AA4B3DE;
	Fri,  8 Jan 2021 07:15:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q9ji1l8JRaY0; Fri,  8 Jan 2021 07:15:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 366F44B40D;
	Fri,  8 Jan 2021 07:15:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C8D04B3FD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RMBkAueur6zK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:47 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E4D64B403
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:46 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id u3so4038692wri.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=j2147gnSzl9I0ScvZHWmAEizoS1X3L4ZHr3IS+13AKY=;
 b=Ns/jsJnBKAEMgPThyuR5EpWbpEFuji6DabFH+5GBY0CvrWpmvNqu9R86B3G/uacWQS
 KmN2zpRmuvtgq4B7YACdY7SURg02CGduxtogRTfv3ogluubm5YiaSF9YIp7Z01d6HSs6
 s580RGQ/bhzezrX1DLcpZQ1xub6tyD6US0n+U7l3f5mQr/Nng8tw58EvPQ+pOHn13Kbs
 m3e0q3j6/ETq9wkmQoFp8k0t3mxpKxsFtfPE+Iu6HMXj2287z9WV/eS3AJBTmYhm3rF1
 K4g+HsMOnZqEbMKeNYSPpu3EAeAydUEzoDvGYM3uBjU/V0yKSJX+qcVx62rpCysU4UJj
 8gCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=j2147gnSzl9I0ScvZHWmAEizoS1X3L4ZHr3IS+13AKY=;
 b=g/5Qz2iEbo68RDxI91MQBx0l7a0Mk04o+WRSgVkDaZaqT5ims77PxijTWf7dZpvr89
 dRlXx7fc9FSBa3THtdHmOYcKiwCVySQMxgDbu2sJr2CpH+nurE01tw1LPWFczheuxw6I
 zXQ8emqS5nrNgzkk506oNh68RnZIWGHNExx+YF5J0/vMDMcxUn5Hfo4mUMolLXrQxzbY
 aH0Mz/Yhsu5B86uwUysriVVYg9yoLUjDsaRrvxGwsFfoD8lM8/zWhiFH/wF1kq/XjZ0p
 r5vGtE89Qcz+AK+bAJd0mdLhwfpn51SDaYBcVYtB9FjAzy5kSoMFmJpHL1QlLNw9jwLX
 2kJQ==
X-Gm-Message-State: AOAM532irWNGuAJJhMFasYWUaYzLUCfGPY9AM6mmK4u6y2QJ0CFhL6Wl
 fD3HHrPmmBSCahm3RuxdVeGmEbxY3GGe
X-Google-Smtp-Source: ABdhPJwRmzTEPIbtvpk5L3tJWHR0GVJuAQ8eMijo/E5QxD7yqAIOXUsNUHDzy7jweXBIXi3SBPh+MOe9FUID
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:adf:fbd2:: with SMTP id
 d18mr3451456wrs.222.1610108145504; Fri, 08 Jan 2021 04:15:45 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:07 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-10-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 09/26] KVM: arm64: Allow using kvm_nvhe_sym() in hyp
 code
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

In order to allow the usage of code shared by the host and the hyp in
static inline library function, allow the usage of kvm_nvhe_sym() at el2
by defaulting to the raw symbol name.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/hyp_image.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
index e06842756051..fb16e1018ea9 100644
--- a/arch/arm64/include/asm/hyp_image.h
+++ b/arch/arm64/include/asm/hyp_image.h
@@ -7,11 +7,15 @@
 #ifndef __ARM64_HYP_IMAGE_H__
 #define __ARM64_HYP_IMAGE_H__
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 /*
  * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_,
  * to separate it from the kernel proper.
  */
 #define kvm_nvhe_sym(sym)	__kvm_nvhe_##sym
+#else
+#define kvm_nvhe_sym(sym)	sym
+#endif
 
 #ifdef LINKER_SCRIPT
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
