Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D09DC433E7
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C6C2622C9C
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="FdmUXfPp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6C2622C9C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 813664B2A9;
	Wed, 22 Jul 2020 12:45:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mG16RkXBsQJP; Wed, 22 Jul 2020 12:45:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 792D14B2DC;
	Wed, 22 Jul 2020 12:45:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DDA84B2BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OvH4UCrtSeWz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:45:08 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52FB64B2C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:07 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id y3so2558514wrl.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 09:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ZXiAbLOq4ubRUcURJC9B1BLv2xJ+3CpTn0EBGii9veo=;
 b=FdmUXfPpY7o9uEYvSP5nVu4ofg8PL0EkzaQt7c+IphnlbncN6veKPYDXPYLTXRODhI
 6vN22+BUNOewLPRoB+VyntfTGU4957QCwvCWV4Rw7/XkrQ5nCgRdII3n6ncKJXismyaG
 QS0jI990BiiNf12aOl1OO24EJqhL4eaTHvJhZbTDwwVFTC3dpmWz+SUWBIJik8UNPp67
 ECuHSrQPykTUctnyqBj2l7S9VS7/jA1LuCpMeq71p8zbNS1+omtsRiI4ZMO+HJbglaMO
 Mum0PSJ1/kp1e9/TTPm0RAKKWXHtacAuaJYN4Yme80qiYihUdK+xHTp+LbJ5sEzZYVCJ
 fGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ZXiAbLOq4ubRUcURJC9B1BLv2xJ+3CpTn0EBGii9veo=;
 b=bYJ9+yOE7MjZ8/YXNOINj1YggglLwWvsR3Sp5gq1739C0UZu5FdJEVkw4RTFSiYIgC
 xMAyxrlSdiZtgPL7iHktSYfa5UbtBgj/8BvG613UobPCWzC0WFZk7EHf3Vb9fbEk9hzn
 w1uRSlwIa9QGcb3mC5yxCWBUlTZm0e62FTa1rYKGwq1cS1llHaJyI9kT6aDIktm3t0Cu
 k+ORtkplrCbO4FAtyivVEiDEOmCszFMccrOg4xhoqnlAQG+kTHsxgHTC9G19kb18T9AA
 X6GU75qncmecdS4C9mtsd7COwdWNjlJVe7+FG1FJqRbScnnhFwpfseCKjXsN1BIYKuE1
 NMzQ==
X-Gm-Message-State: AOAM533g7RS09lKCHN+e1J9NSo9eip9BUHAF0bJcrBos4MFrGtXqaVpj
 2fP5smv5KeQWsC5SyGn3v2Iqaw==
X-Google-Smtp-Source: ABdhPJzJgI+HFT65fE1fBmZ9mEiYEXOQtPMo4T9cTDa2bRmHKYwwP+XUbleLmCwLMIPgGxnThsRfXw==
X-Received: by 2002:a5d:6288:: with SMTP id k8mr347278wru.373.1595436306334;
 Wed, 22 Jul 2020 09:45:06 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:b0ee:900a:e004:b9d0])
 by smtp.gmail.com with ESMTPSA id 33sm590292wri.16.2020.07.22.09.45.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Jul 2020 09:45:05 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/9] kvm: arm64: Add helpers for accessing nVHE hyp per-cpu
 vars
Date: Wed, 22 Jul 2020 17:44:19 +0100
Message-Id: <20200722164424.42225-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200722164424.42225-1-dbrazdil@google.com>
References: <20200722164424.42225-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@google.com, kvmarm@lists.cs.columbia.edu,
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

Defining a per-CPU variable in hyp/nvhe will result in its name being prefixed
with __kvm_nvhe_. Add helpers for declaring these variables in kernel proper
and accessing them with this_cpu_ptr and per_cpu_ptr.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index bbd14e205aba..3d69cab873e4 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -60,9 +60,21 @@
 	DECLARE_KVM_VHE_SYM(sym);		\
 	DECLARE_KVM_NVHE_SYM(sym)
 
+#define DECLARE_KVM_VHE_PER_CPU(type, sym)	\
+	DECLARE_PER_CPU(type, sym)
+#define DECLARE_KVM_NVHE_PER_CPU(type, sym)	\
+	DECLARE_PER_CPU(type, kvm_nvhe_sym(sym))
+
+#define DECLARE_KVM_HYP_PER_CPU(type, sym)	\
+	DECLARE_KVM_VHE_PER_CPU(type, sym);	\
+	DECLARE_KVM_NVHE_PER_CPU(type, sym)
+
 #define CHOOSE_VHE_SYM(sym)	sym
 #define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
 
+#define this_cpu_ptr_nvhe(sym)		this_cpu_ptr(&kvm_nvhe_sym(sym))
+#define per_cpu_ptr_nvhe(sym, cpu)	per_cpu_ptr(&kvm_nvhe_sym(sym), cpu)
+
 #ifndef __KVM_NVHE_HYPERVISOR__
 /*
  * BIG FAT WARNINGS:
@@ -75,12 +87,21 @@
  * - Don't let the nVHE hypervisor have access to this, as it will
  *   pick the *wrong* symbol (yes, it runs at EL2...).
  */
-#define CHOOSE_HYP_SYM(sym)	(is_kernel_in_hyp_mode() ? CHOOSE_VHE_SYM(sym) \
+#define CHOOSE_HYP_SYM(sym)		(is_kernel_in_hyp_mode()	\
+					   ? CHOOSE_VHE_SYM(sym)	\
 					   : CHOOSE_NVHE_SYM(sym))
+#define this_cpu_ptr_hyp(sym)		(is_kernel_in_hyp_mode()	\
+					   ? this_cpu_ptr(&sym)		\
+					   : this_cpu_ptr_nvhe(sym))
+#define per_cpu_ptr_hyp(sym, cpu)	(is_kernel_in_hyp_mode()	\
+					   ? per_cpu_ptr(&sym, cpu)	\
+					   : per_cpu_ptr_nvhe(sym, cpu))
 #else
 /* The nVHE hypervisor shouldn't even try to access anything */
 extern void *__nvhe_undefined_symbol;
-#define CHOOSE_HYP_SYM(sym)	__nvhe_undefined_symbol
+#define CHOOSE_HYP_SYM(sym)		__nvhe_undefined_symbol
+#define this_cpu_ptr_hyp(sym)		&__nvhe_undefined_symbol
+#define per_cpu_ptr_hyp(sym, cpu)	&__nvhe_undefined_symbol
 #endif
 
 /* Translate a kernel address @ptr into its equivalent linear mapping */
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
