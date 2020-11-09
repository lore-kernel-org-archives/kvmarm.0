Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C135C56201
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B2BDF208FE
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="sB/y2/Ui"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2BDF208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E6A04B881;
	Mon,  9 Nov 2020 06:33:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0jdEOJmGS-ST; Mon,  9 Nov 2020 06:33:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 560044B874;
	Mon,  9 Nov 2020 06:33:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B82104B720
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o0jEWcEmBVtP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:15 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B70A54B627
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:15 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id c9so7650524wml.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=caV1ipuiTawe8T6twZGVAfyUFvhkg9VCzsqdE5ZajF4=;
 b=sB/y2/Ui9hncBiir49+ICz2IN5o2gtyOCZwiJX/81JcCULdYTBnLUZyWbf6WVQntem
 ST3A4s2jm+XkTBO+sD3RVmCmxXbkleOYtQkWctTReDQDMpcUTd8lFfELThVx7bxsi3A+
 mvOkZQv7hxbi/TUEOZtp4ETbpxrbZrLYmIaYwxS6p4xqY1hdKrvJTKfq6C6+XLdCQYb8
 NUY4JS033hx/waCf51nR8AnhxJWjo9FCRMh00+hUa0kh/PrtaUg6VfqLa2Hr8xyE3Dpf
 +lBqYkLg5uQySHjRhpyROYvpOV29xnCuLkDENvnYQ4A2kG6ODvE3+I00D69G0vZ7YC1K
 5odw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=caV1ipuiTawe8T6twZGVAfyUFvhkg9VCzsqdE5ZajF4=;
 b=VmGX2yHIMtCq3zDLpvMIsp5mA3eNkNmD0+kv2Zta9p5gAYcs12vhiHNSeQMHlmgbwt
 yERLrzSCCpcIzXHO5isybO37aGxZb5OMzhuDkuXMlWv7rSmuAHAvCRQ7OatUH3rffvK+
 MrFqc534RPNRQX7bSU+9FWPwELeb2v+b8QMBdxXHHc3ybNE4aIZcDprcZ20PqL4k+UCd
 BMlep0pOy5QVZRk+z8nU3N3AgKB82McKbd9lCCmA9+VybJ2CT2wWSUuVVhf+ScPbdBdv
 MEsBn/bM/y+pU5t0F4uaJ5mXeLIaTefsN9vwz5SM1INVrwDe/8OlfKHA7I6mYGZqMUGz
 G9vg==
X-Gm-Message-State: AOAM532yt4YXnMXtoNt1i+Z1/5u3bKE+5/qxRxyCjjfU1NdUG7rwL+lm
 rQW37C+oW0FrRnW82ZT4vEGqlfrSFhHzjG3B
X-Google-Smtp-Source: ABdhPJzSRWUlAySru4rwQabNSKivoN+hTeZrlzLIDmklGE7PxHdfZql7hj+Mrx0wU/sAZLmtXqsBrw==
X-Received: by 2002:a7b:cd99:: with SMTP id y25mr13827347wmj.128.1604921594515; 
 Mon, 09 Nov 2020 03:33:14 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id n128sm5063590wmb.46.2020.11.09.03.33.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:13 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 17/24] kvm: arm64: Add __hyp_pa_symbol helper macro
Date: Mon,  9 Nov 2020 11:32:26 +0000
Message-Id: <20201109113233.9012-18-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
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

Add helper macro for computing the PA of a kernel symbol in nVHE hyp
code. This will be useful for computing the PA of a PSCI CPU_ON entry
point.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
index b0b5df590ba5..7510b9e174e9 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci.c
@@ -20,6 +20,16 @@ s64 hyp_physvirt_offset;
 
 #define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
 
+#define __hyp_pa_symbol(sym)					\
+	({							\
+		extern char sym[];				\
+		unsigned long kern_va;				\
+								\
+		asm volatile("ldr %0, =%1" : "=r" (kern_va)	\
+					   : "S" (sym));	\
+		kern_va - kimage_voffset;			\
+	})
+
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
 	return host_ctxt->regs.regs[0];
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
