Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1011C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72B66611CA
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 72B66611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25EF44B0C2;
	Thu, 16 Sep 2021 14:15:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6f685ulJuDku; Thu, 16 Sep 2021 14:15:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CED2F4B168;
	Thu, 16 Sep 2021 14:15:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2063B4B139
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KvtNOTbT6rkf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:15:29 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F1B74B09C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:29 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 b18-20020a92a052000000b00243a23d77c2so2633910ilm.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cEhucRmtScLoOKkKtz+kjGRHoUKux13Tg6JxfwC7i5M=;
 b=HV2MQTLtXFdc7iP17P6mtu+8Vde3/FS+kVARy2QXPbgRRHo/PT+peFbVCuiaH0L5hX
 gSyOjL5ewzJr4u8bsZbz32+QGydoZ5YuWBRsCNIry5m7huzZ+AbSGfdYoxN2H8aHJbXj
 7G1zF3VnT84BPqUqiqGevGw+SQjR95LA/evNsHyqbSl1a71OYGwzy5hbxeovonQ8nWDT
 NmOu/+teU1YRy4QgHPRSPdwkcKDemlLDByX1iQlHdBdDXfAnRIE8/jmNRPEfzJgkNw/D
 RpAdtoNqtqAhzyrlabI1525AGpzYZ2bUogOFN3u0p5FmQ/P48kbO0hOfsdUlKlIAFS+t
 tYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cEhucRmtScLoOKkKtz+kjGRHoUKux13Tg6JxfwC7i5M=;
 b=skKzdufIL1g7+x0sTAU/8zpk1XkeUPr4lEckPQbbcoeIZZsR+eWKwhp9hLtGbxFLh0
 ZMN63Z1lydMbmd+4Ll388TK+bCeVEkAmTeJ04nzZxqE/wqwJHi03uUdYNbBWF6qt7XFT
 796r1AI8BoJTZBsk6wHEoZeHkThhnA/TyB74FU3T/1fvheUV/Bs5kSA7vgq8x9Nzfroe
 PGW7KFPDogeH/3HxXiycPPpsMDQynlwAHwfIiF6PqS8gBrXFTFJSPZOcFgQl7X3BqEJh
 1R5ctwoSKkW2VJSg3z3f8eroN7CL/IKbZAzsmf4sUFvQc3l3mSf1DcEYvF7v6yGAUvEr
 WouA==
X-Gm-Message-State: AOAM530BxL7HWJikZPjO1BMKyV4S2jO3a+jBc3qfpLP2LGM0VEOf3U0V
 fq1LtQSP1av5OAdrd4k5zZOD3NkyuHk=
X-Google-Smtp-Source: ABdhPJxCd+H8v05h4eupFeeC2qY4icp5YVNK41l2UrN+lmRvW+IkyY3ujFedG7GRyGUSTbLIM5HEy4qonJo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:3642:: with SMTP id
 d2mr4967295ilf.234.1631816128784; 
 Thu, 16 Sep 2021 11:15:28 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:07 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-6-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 5/8] arm64: cpufeature: Enumerate support for FEAT_ECV >=
 0x2
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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
counter virtualization (i.e. ID_AA64MMFR0_EL1.ECV>=0x2).

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 arch/arm64/kernel/cpufeature.c  | 10 ++++++++++
 arch/arm64/tools/cpucaps        |  1 +
 3 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b268082d67ed..3fa6b091384d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -849,6 +849,7 @@
 #define ID_AA64MMFR0_ASID_8		0x0
 #define ID_AA64MMFR0_ASID_16		0x2
 
+#define ID_AA64MMFR0_ECV_PHYS		0x2
 #define ID_AA64MMFR0_TGRAN4_NI			0xf
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN	0x0
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX	0x7
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f8a3067d10c6..2f5042bb107c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2328,6 +2328,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Enhanced Counter Virtualization (Physical)",
+		.capability = ARM64_HAS_ECV2,
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
index 49305c2e6dfd..f73a30d5fb1c 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -18,6 +18,7 @@ HAS_CRC32
 HAS_DCPODP
 HAS_DCPOP
 HAS_E0PD
+HAS_ECV2
 HAS_EPAN
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
