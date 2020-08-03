Return-Path: <SRS0=KyyX=BN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C6EC433DF
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 19:31:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61F7C22B45
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 19:31:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61F7C22B45
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E61684B6A1;
	Mon,  3 Aug 2020 15:31:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nkE6Mk2mvLGf; Mon,  3 Aug 2020 15:31:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE6944B6AF;
	Mon,  3 Aug 2020 15:31:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10D6D4B6A6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 15:31:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jcmiqYNHzojP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2020 15:31:31 -0400 (EDT)
Received: from mail-io1-f68.google.com (mail-io1-f68.google.com
 [209.85.166.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CECA4B6A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 15:31:31 -0400 (EDT)
Received: by mail-io1-f68.google.com with SMTP id k23so39685936iom.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Aug 2020 12:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=j63V9CdXPRw65XqqzN2bqRvwfPF7ISjBsKgk8HEVQnE=;
 b=dUi24G+zbxirrGPqUoxwhN9hhAQ/jPpSYKaXzqKyyFCKUDTJgo5SD4McVsUQO3Vqxa
 IpZCgwXWDsCaI6/qFH+RLS02XlsoUJsw5ohF8KPR9mr5MoPCAl3lfyCqcOgdiT2GVoSw
 8+Hi6V24oOwuvdNrLqMrmpMSmeC4LVTsq25V5dUvTlA8i9600BYgywqDU7h5jVHKhaiT
 yypLWN02O7jTUN8yWz+Cb4jHIWlZChBg5M8pI6hjbpUobv63+o8MmH1gmzenu5FBtw+h
 qROQEhmzQZnY/HfcJnjtU7IseImvXZ4MKRnzMxfWW7QA1jXzBcZpdMpzS/HbutdhuIz0
 w5Jg==
X-Gm-Message-State: AOAM531HFdZmQkE65Vtksw3ShZAiQAfJuCsRbYO560aBk8IKs0hXOX3p
 sH4ZoyhVABHz1+wB3QleeA==
X-Google-Smtp-Source: ABdhPJxcA0fkFnLT4iFQRI78IP34MbLmhHo68FNBp3OoOx6jxY6MQ5Iy9duqqKv1rn2pJ2OFbmGHtg==
X-Received: by 2002:a5e:dd02:: with SMTP id t2mr1413126iop.90.1596483090665;
 Mon, 03 Aug 2020 12:31:30 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.252])
 by smtp.googlemail.com with ESMTPSA id j79sm11254738ilg.42.2020.08.03.12.31.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 03 Aug 2020 12:31:30 -0700 (PDT)
From: Rob Herring <robh@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v4 1/3] KVM: arm64: Print warning when cpu erratum can cause
 guests to deadlock
Date: Mon,  3 Aug 2020 13:31:25 -0600
Message-Id: <20200803193127.3012242-2-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200803193127.3012242-1-robh@kernel.org>
References: <20200803193127.3012242-1-robh@kernel.org>
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

If guests don't have certain CPU erratum workarounds implemented, then
there is a possibility a guest can deadlock the system. IOW, only trusted
guests should be used on systems with the erratum.

This is the case for Cortex-A57 erratum 832075.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Rob Herring <robh@kernel.org>
---

v4:
- Use cpus_have_final_cap instead of cpus_have_const_cap

v3:
 - s/work-arounds/workarounds/

---
 arch/arm64/kvm/arm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90cb90561446..cbc8365307f2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1653,6 +1653,10 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}

+	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
+		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
+			 "Only trusted guests should be used on this system.\n");
+
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu, check_kvm_target_cpu, &ret, 1);
 		if (ret < 0) {
--
2.25.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
