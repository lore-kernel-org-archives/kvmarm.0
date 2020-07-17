Return-Path: <SRS0=EkBd=A4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1E1C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jul 2020 20:52:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3AB512076D
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jul 2020 20:52:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AB512076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C49CB4B175;
	Fri, 17 Jul 2020 16:52:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LZfhKSMc3gIf; Fri, 17 Jul 2020 16:52:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3D384B168;
	Fri, 17 Jul 2020 16:52:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B33474B132
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2020 16:52:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ggvgwsjEPfuL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2020 16:52:36 -0400 (EDT)
Received: from mail-il1-f193.google.com (mail-il1-f193.google.com
 [209.85.166.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C43D14B15A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2020 16:52:36 -0400 (EDT)
Received: by mail-il1-f193.google.com with SMTP id x9so8472811ila.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2020 13:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=lA6y1484mCfujwLhJ510Qn2HTKproByu1gKdBQz37Eo=;
 b=a5Rhn0xFV/BfTmgA2c0oCq01PoaKdaHfbH83Mmg9PPn0f2n5S6ujM/PsD1TVeHPBCx
 GGKN9XKIPp5BXvPWS/E9WxdV9E3hOcJQKkcdZ2xQ/Dx3PbksFH9Hkvs6bYsg6Ob6WyY7
 pxNGD/J0ZPmdTAd/UREgCr5yrdNqkWFCqskV8Mn5XT5PxeiCopI2dV1TyFNtzjke3cFt
 obEbPXghyJnO01d3waQdWwksb6e+ZmM+YO0Xa9lViYUPlloiBHxaVNjtHLfEiYrzJHRd
 nUiZpoROREkKAhzN7Gl/DRJoMhtk2OFROJ36ydzYiccVNP+FFAuTToJEK/2DRRc+Sy3o
 X8ig==
X-Gm-Message-State: AOAM530vZITLRqe0RpUtt7zhqw62cW50lR6zWxZtIbohMQQew/8HyOpL
 sq+zY40kCpUbaQQgDXKD9A==
X-Google-Smtp-Source: ABdhPJyx/gulu/KTsFX3iauAwSag59A89mCNqY2i4r9k8OMUlJTecA50WQpkSdggWHrYVxGOD+Zqdw==
X-Received: by 2002:a05:6e02:ead:: with SMTP id
 u13mr11850062ilj.46.1595019156351; 
 Fri, 17 Jul 2020 13:52:36 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.252])
 by smtp.googlemail.com with ESMTPSA id 136sm4737492iou.50.2020.07.17.13.52.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jul 2020 13:52:35 -0700 (PDT)
From: Rob Herring <robh@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v3 1/3] KVM: arm64: Print warning when cpu erratum can cause
 guests to deadlock
Date: Fri, 17 Jul 2020 14:52:31 -0600
Message-Id: <20200717205233.903344-2-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200717205233.903344-1-robh@kernel.org>
References: <20200717205233.903344-1-robh@kernel.org>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
v3:
 - s/work-arounds/workarounds/

 arch/arm64/kvm/arm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90cb90561446..9b070b5e212b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1653,6 +1653,10 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}

+	if (cpus_have_const_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
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
