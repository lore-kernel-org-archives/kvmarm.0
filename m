Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC135C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:59:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8326260FC4
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:59:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8326260FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36D954A7FD;
	Wed,  4 Aug 2021 04:59:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n3qQltXW7Gbe; Wed,  4 Aug 2021 04:59:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DF984B0AC;
	Wed,  4 Aug 2021 04:58:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC17B40C88
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MecODjaQL2Qs for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:54 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D32044B096
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:52 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 y10-20020a0cd98a0000b029032ca50bbea1so1286721qvj.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=h8C+AkSSxjD2I6RXdGSsBwEWeDSTzFjVwyFJmn30s0c=;
 b=vdFpyj+9XNPjdYnHOx6TwDyWXfkwfTUZA5Sw6ri/Z+MfoVjX9B5ei1iIA6qchNTckg
 Js4/woRxok9rGl937dT5UR6w8jykMhwsS++V75ZeD8wlloCL6wCsYKsehUNaIOE43JeR
 Z2I0iFTOk5qzEKQKx3u2dbLLBMotmDxqqKCR94OqjLYyygFGecaxna6m9TnnTENZ1dlO
 BcCV64E3066DzzNmcmkPW3oPneJUjkCGeWxgt3hXPaU/8EVSRFSD6lZNyz1DT33Lkoi7
 qZmZBVlnNgK5BwZRYc/LHdxEGICI0QBX432vw8WwyIBzzYfANL3FddNoQdY4qIW6LGFV
 epqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=h8C+AkSSxjD2I6RXdGSsBwEWeDSTzFjVwyFJmn30s0c=;
 b=TRhAl74pvM0lOsWmVfCFnGGOU79k/Xp+wvYknz5bRK23XeBcm6EXmrr8a6oil2s+Qg
 rAHbdJxXoHE/SsPGugXdMMQU14VxslsmtuseehiI9aiDcbNlOHKuCGFNSwIbXeN3ljmN
 pawGErD1zHcmshq8DL4Ug/uSZKlzmq0Rj0rbGe6YW4s5VLvrhnK80LwmC86AqktrRD09
 KRw4IMx7WT0G35HPvbpTsY9HYLQlEji+R9oB7YKegl160JfNwkoEc20alimx0n7wlzGp
 iCTSDpZU/5vrl9DyF1Ujj6lXEExRZLysv/MVD8yPeE8upDWS/lxjj9tPYcg+WSpOd9d8
 3jGQ==
X-Gm-Message-State: AOAM531cHoOQGKmsI01BQKhCRXmcaxEETDYnHrpIgXCe2gKjTb9qXkIY
 0hEUT27u2s18r1Z6rXLx9S+GstDcM/4=
X-Google-Smtp-Source: ABdhPJx+GeA32n6jMUHsP7WogSpQpinH4eyTOFkLIo8qvlVC8zogWUDIRuiTAtVqSj3R5xgXeAPAlnAcOpw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:134c:: with SMTP id
 b12mr24474131qvw.39.1628067532459; Wed, 04 Aug 2021 01:58:52 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:14 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-17-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 16/21] arm64: cpufeature: Enumerate support for Enhanced
 Counter Virtualization
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Introduce a new cpucap to indicate if the system supports full enhanced
counter virtualization (i.e. ID_AA64MMFR0_EL1.ECV==0x2).

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/sysreg.h |  2 ++
 arch/arm64/kernel/cpufeature.c  | 10 ++++++++++
 arch/arm64/tools/cpucaps        |  1 +
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7b9c3acba684..4dfc44066dfb 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -847,6 +847,8 @@
 #define ID_AA64MMFR0_ASID_SHIFT		4
 #define ID_AA64MMFR0_PARANGE_SHIFT	0
 
+#define ID_AA64MMFR0_ECV_VIRT		0x1
+#define ID_AA64MMFR0_ECV_PHYS		0x2
 #define ID_AA64MMFR0_TGRAN4_NI		0xf
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN64_NI		0xf
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0ead8bfedf20..94c349e179d3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2301,6 +2301,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Enhanced Counter Virtualization (Physical)",
+		.capability = ARM64_ECV,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64MMFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR0_ECV_SHIFT,
+		.matches = has_cpuid_feature,
+		.min_field_value = ID_AA64MMFR0_ECV_PHYS,
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 49305c2e6dfd..d819ea614da5 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -3,6 +3,7 @@
 # Internal CPU capabilities constants, keep this list sorted
 
 BTI
+ECV
 # Unreliable: use system_supports_32bit_el0() instead.
 HAS_32BIT_EL0_DO_NOT_USE
 HAS_32BIT_EL1
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
