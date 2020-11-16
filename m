Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F1DC63697
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2BA882223D
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="SVWNYTmy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BA882223D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBDA84C25A;
	Mon, 16 Nov 2020 15:43:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9a+WyKKNYCYS; Mon, 16 Nov 2020 15:43:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2F824C24A;
	Mon, 16 Nov 2020 15:43:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73FD14C248
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wnu4Ik5OVqbQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:39 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28BE64C266
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:39 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id c9so585087wml.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=LvORiSrCboh1zuDeFhL4WafhjrkSrBKNjZKtj5yVH3Q=;
 b=SVWNYTmys1SPUElJcVnpJBNBs5oAdZHAjK3TgZzZfOjpBoMW5ofiWzcyLp+qfPd/rv
 kxeXWJJS9SoINBmJNnMAemKZcbUNdRiA7IlqnofStvW8mTMj8VEwIz2jUvrT0dA+i3Tm
 g4wlHWyoFXq/VYlwRf/yPokSBq5aRO13qmCxeFQHTGJWcIal7SJ4TcO6OjHoriu8V6fW
 cyyMoYuEkEBo1FJfAZu0x0BSpSDtsrjoio4mZiiVcN8P7hz6TwV2xEP4L0gzcuCfGjgh
 C997sjV7nUnfvAYgYd5xoY0UbaWHocozO0v8uoSSRaRQAVFTZ/vfGLIexqoU652x7Lnm
 bqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=LvORiSrCboh1zuDeFhL4WafhjrkSrBKNjZKtj5yVH3Q=;
 b=YLP3x+MWjkgqE9iCIZbwzfIgUri8V1+LRKh71lk5AwHKsSygYUYl8afe2rkwLNi7Vr
 oxJ1rV5uQ+p44tLi1LFIBBfAnEO4cA5Hmdh2ybsJU/hzHaEyubEm5xI9U79jjl4iUox9
 gEgRDfC022tYzkl0xrrxyq+FkKiStyQkvqCjyX8U5g1mPq7g0KLp4fa5/rtv6ksnaCpZ
 yGTqEuUL5uuB/M75n5O6pG8zztb0r0TjhQUOZkaCmrkZBX1c/6rtRShs3muSQtPwZ5pQ
 1hkK4jimOTNCSyJYOYWYdMm2p0a5HN16a06u/tAaz9WzlU+V2y0bOD5uhV9HO7lNeRPl
 atow==
X-Gm-Message-State: AOAM531GrqGnnrGrXOH7gdpAggUo72U2CXn9y4rtq0RMGn7GWV5NU9yw
 al1LtjZlWMddlngAARRzMhu9HbRdZgosDmRJ29M=
X-Google-Smtp-Source: ABdhPJwOvc5dWi+xkvClKzcf/gKj3+UyZ1JtpEdN2rvPQaTpD24kr3N4TlMaKDsdi++yak8H6bPEtQ==
X-Received: by 2002:a05:600c:255:: with SMTP id 21mr711033wmj.69.1605559417911; 
 Mon, 16 Nov 2020 12:43:37 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id h20sm547704wmb.29.2020.11.16.12.43.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:36 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 07/24] kvm: arm64: Refactor handle_trap to use a switch
Date: Mon, 16 Nov 2020 20:43:01 +0000
Message-Id: <20201116204318.63987-8-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
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

Small refactor so that nVHE's handle_trap uses a switch on the Exception
Class value of ESR_EL2 in preparation for adding a handler of SMC32/64.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 411b0f652417..19332c20fcde 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -16,9 +16,9 @@
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
-static void handle_host_hcall(unsigned long func_id,
-			      struct kvm_cpu_context *host_ctxt)
+static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 {
+	unsigned long func_id = host_ctxt->regs.regs[0];
 	unsigned long ret = 0;
 
 	switch (func_id) {
@@ -109,11 +109,12 @@ static void handle_host_hcall(unsigned long func_id,
 void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
-	unsigned long func_id;
 
-	if (ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64)
+	switch (ESR_ELx_EC(esr)) {
+	case ESR_ELx_EC_HVC64:
+		handle_host_hcall(host_ctxt);
+		break;
+	default:
 		hyp_panic();
-
-	func_id = host_ctxt->regs.regs[0];
-	handle_host_hcall(func_id, host_ctxt);
+	}
 }
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
