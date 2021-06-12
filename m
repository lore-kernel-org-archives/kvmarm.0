Return-Path: <SRS0=m071=LG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F83FC48BE5
	for <kvmarm@archiver.kernel.org>; Sat, 12 Jun 2021 11:11:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11BBC6138C
	for <kvmarm@archiver.kernel.org>; Sat, 12 Jun 2021 11:11:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11BBC6138C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B18F640CF9;
	Sat, 12 Jun 2021 07:11:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2SU8elkoXxqo; Sat, 12 Jun 2021 07:11:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67E8D4086F;
	Sat, 12 Jun 2021 07:11:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 579DD40874
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Jun 2021 07:00:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ifDnEvq4SCq for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Jun 2021 07:00:22 -0400 (EDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B040E406AD
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Jun 2021 07:00:21 -0400 (EDT)
Received: by mail-pf1-f180.google.com with SMTP id k15so6578430pfp.6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Jun 2021 04:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:mime-version:content-disposition
 :user-agent; bh=8iFz8MxPZLy39szDaTinyyt9MSbr8V1d4abH/6Oyi34=;
 b=dsAZPKVtBd9FNW3PfmVk3BX6RVgYyNpg0Raa2+UAkDpXioHz+z76oMr8eGi8viVXKL
 LiNViHV8bVXfGjz0w4vn5sST0m+1oEkawdQVH6VFf3HTzWn9mgM8simVoLWywHcmAjtQ
 Z5oDevv6bonmRxRv8y3Qfal5SfB/GcuD4YJ10Dy3ZuM/P1CR/PAsmHRit8p9LNXwuzmt
 96fq9jE3x5LClunwOps24irJn4iE69mURhQPk9sMhixglFpgcmI6JMUnDtFcCVSWfkUr
 bM+PHdzbUsRyDk8Oj5BS4EVg53CAaiJBGtekU/CtFElLbP/5IYTNvijdZPAefdDb70V8
 tRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition:user-agent;
 bh=8iFz8MxPZLy39szDaTinyyt9MSbr8V1d4abH/6Oyi34=;
 b=LCX3dJEo7DX1TH6lZ/xMR/0WtC1wvsc9IPpJeZgkNBxAAlPvAdwMfUBPk2fMBORlcf
 r/WlzEtR3w9SMD40V1PvPh0j0f5mjpinzpwsmex89PJeudqFANwnijZM/LxG4g7i5yvJ
 RA3KEl4+pgayPNS2n0FHf6n3/405EK9NNaz1qb5HEsaTG1yOK0CCb0q3uOM8TlqN0r9r
 ftark4unhzOqHCB211jhKBzEcPJ6/p+OqMQRG/fjLZXC5+8Tv5ZM6ewuWWodgXLWrDxi
 HpuEIyy+6jqiK6y42n+IF/7WYqVM6Qb4qe0lZyE55fMWggnkitNfwNg939OKH/9X3ylN
 2R7Q==
X-Gm-Message-State: AOAM532S5roqswLTi2qrqQ/rfdle8kc7++lbx87i/g4VQ/eotQSqNdzY
 IaOS94wCU3fjHnE7pL+ZW/g=
X-Google-Smtp-Source: ABdhPJxX8jxHPklTMEHdOxhkDMwNRN9obBLTCd8K9iuKwSlL5men33m5itr/QfiIZGiD/H4CqQ9vhA==
X-Received: by 2002:a62:7e05:0:b029:2ea:57f:ec86 with SMTP id
 z5-20020a627e050000b02902ea057fec86mr12613918pfc.37.1623495621051; 
 Sat, 12 Jun 2021 04:00:21 -0700 (PDT)
Received: from raspberrypi ([125.141.84.155])
 by smtp.gmail.com with ESMTPSA id v15sm8060992pgf.26.2021.06.12.04.00.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 12 Jun 2021 04:00:20 -0700 (PDT)
Date: Sat, 12 Jun 2021 12:00:14 +0100
From: Austin Kim <austindh.kim@gmail.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Subject: [PATCH] KVM: arm64: vgic: declear local variable 'flags' before for
 loop starts
Message-ID: <20210612110014.GA1211@raspberrypi>
MIME-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailman-Approved-At: Sat, 12 Jun 2021 07:11:10 -0400
Cc: austindh.kim@gmail.com, austin.kim@lge.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

From: Austin Kim <austin.kim@lge.com>

Normally local variable 'flags' is defined out of for loop,
when 'flags' is used as the second parameter in a call to
spinlock_irq[save/restore] function.

So it had better declear local variable 'flags' ahead of for loop.

Signed-off-by: Austin Kim <austin.kim@lge.com>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 2 +-
 arch/arm64/kvm/vgic/vgic-v4.c   | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 48c6067fc5ec..ae32428d9f87 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -232,11 +232,11 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	u32 value = 0;
 	int i;
+	unsigned long flags;
 
 	/* Loop over all IRQs affected by this read */
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-		unsigned long flags;
 		bool val;
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index c1845d8f5f7e..a0c743f83bbe 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -116,7 +116,7 @@ static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
 {
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
 	int i;
-
+	unsigned long flags;
 	/*
 	 * With GICv4.1, every virtual SGI can be directly injected. So
 	 * let's pretend that they are HW interrupts, tied to a host
@@ -125,7 +125,6 @@ static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
 	for (i = 0; i < VGIC_NR_SGIS; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
 		struct irq_desc *desc;
-		unsigned long flags;
 		int ret;
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
@@ -158,11 +157,11 @@ static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
 static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
 {
 	int i;
+	unsigned long flags;
 
 	for (i = 0; i < VGIC_NR_SGIS; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
 		struct irq_desc *desc;
-		unsigned long flags;
 		int ret;
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
