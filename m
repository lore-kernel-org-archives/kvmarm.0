Return-Path: <SRS0=y90B=AM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2769C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jul 2020 21:53:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A62892082F
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jul 2020 21:53:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A62892082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60E434B4B6;
	Wed,  1 Jul 2020 17:53:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h25V6hOx7fo6; Wed,  1 Jul 2020 17:53:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56F354B4A8;
	Wed,  1 Jul 2020 17:53:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D3D84B415
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 17:53:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2IpDuuXnW45N for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jul 2020 17:53:12 -0400 (EDT)
Received: from mail-il1-f196.google.com (mail-il1-f196.google.com
 [209.85.166.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 310BF4B4A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 17:53:12 -0400 (EDT)
Received: by mail-il1-f196.google.com with SMTP id k6so22401182ili.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Jul 2020 14:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=6myzpVZlHvRhDUXKhD51L6OEXdk3wWpP/dkJayJrioU=;
 b=GCAd+iT2ZJmv216/4oS5Z8BjpBXN33KuwS7tKQ1QNnzvMPrGBFO7gOwDnSD+oLYOLJ
 QcvRKPwRxqIupccS2Oa9hXa8mw/EMcUKFzpo4WxbPof6AHI/FTl2nNxd5HPBKJBCDYtk
 DVYi+bzla1lwBLif7LYD1c7PILSACCZI8XsysmzvnCrPr+iAAGG3c9VjFel8rv3Blwhn
 gC4GLy25yLRttF77PIzTepVOzREuIY0TZ2II++CgyIxxr0gDErJ/fCeJXGm77FjZfY5i
 BqCLAcgV2oIXO2Q28bMXGn9OFWqjdmZTUaSsh/Uu1hFf6kQudlpNeuNPFlLDXWbq85Wq
 quZA==
X-Gm-Message-State: AOAM5302YzPdvma47+VvvCWO/yIh6Z4W3zV1AwqHz/y7gwg7cD2h6zXQ
 TRUoftwAV89p2M2xnnKi2w==
X-Google-Smtp-Source: ABdhPJyozKyEhvb1swPTcS1Q1+rEDJSW+Yufh0BOBdy5SHq8hgnWgC/ZZcT274EIcrH/AnflS5MPuw==
X-Received: by 2002:a92:502:: with SMTP id q2mr9251389ile.61.1593640391742;
 Wed, 01 Jul 2020 14:53:11 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.253])
 by smtp.googlemail.com with ESMTPSA id g1sm3784707ilk.51.2020.07.01.14.53.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Jul 2020 14:53:11 -0700 (PDT)
From: Rob Herring <robh@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v2 1/3] KVM: arm64: Print warning when cpu erratum can cause
 guests to deadlock
Date: Wed,  1 Jul 2020 15:53:06 -0600
Message-Id: <20200701215308.3715856-2-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200701215308.3715856-1-robh@kernel.org>
References: <20200701215308.3715856-1-robh@kernel.org>
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

If guests don't have certain CPU erratum work-arounds implemented, then
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
 arch/arm64/kvm/arm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90cb90561446..e2f50fa4d825 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1653,6 +1653,10 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
+		kvm_info("Guests without required CPU erratum work-arounds can deadlock system!\n" \
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
