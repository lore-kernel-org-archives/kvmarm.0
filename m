Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27463C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:04:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 807004B249;
	Wed,  1 Dec 2021 12:04:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TQQroVU2iCrq; Wed,  1 Dec 2021 12:04:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED4384B23E;
	Wed,  1 Dec 2021 12:04:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DB5B4B218
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LEHK3L9S55bn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:04:19 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 943974B23E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:18 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 g81-20020a1c9d54000000b003330e488323so617891wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=To0SNnHVfI+H6lAX6lBPI0gbbL9kvAmYwmWxoThbEmQ=;
 b=c3N+Hsz63lDc/AuLe7OwcJn+QlFGAiiPAK/v+uveeQj4J/xIMFLUVreGUkLB/OhWe7
 xxQExo5sN2tjJX/K0t22Pyedrge8bHw8PQX9ioa+ZyPcJXTNVTqwnzaN4wJmEAY0G3WF
 qePOIM36BNZrzbzHLF499Ie9giwIeOEhK0DjLg4A4aO0pyneUPX9V3J3QAgZhnAalmGq
 GgU2j5rGVQ+/ywMfsyzLjUCf/yIn9JUsfAZrM4tEXfekoTu7F7CPl0GECKg5acnJo0gD
 ldlS2SRcWRjiOuZ7JvgkDuWdek0FI/pSl01nLYU8GyAhvbnuRN8Ufpu4D57DZce5aeNr
 wU9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=To0SNnHVfI+H6lAX6lBPI0gbbL9kvAmYwmWxoThbEmQ=;
 b=RCC50o49Rws7aIP12rjsBo8xVA8+ib2gReqw0OGApJ8deEltNs5LxEfu/w8Psc9CEk
 RtbXzro2gPcykB8LxXFOQ1t4DiUC69w7178B0O8XXPwYIE8XZ6ewNuSLyPzdwrWCj6K7
 E1pZRksx6G1HupL70CPPgCMM52NEaSbUE8z/n4UCUv2y2/hJIXFzJfLK2ixG01VB7no+
 0kljGOQwJwPXSeBngd0hgipitoHEgREBiLotTgI3UZFLjVCABO279LCm+zPhu2tYOW13
 ahw7Ba9PllOzxlyDykyIq9lNtWm4veqoeAD+AMXFdZaho4xSmDON3DxIv4CDsnWn4Z3C
 GT8g==
X-Gm-Message-State: AOAM531EjcnyJ/Xj/4MAdWcsbhYRlS+NUpr0Wsd7FX1KaRdX32hdYl38
 7RIk/KZtKYx0vNCeQBdF38oyBu+bOGwc
X-Google-Smtp-Source: ABdhPJyFcaB2RvMSztkS941w8QnL4bS9fgV6ZFzqQ3PoBgP+qzxkDtb1aqs2DI+obM4eDv5SPs/p5zCTtLuI
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:a05:600c:198f:: with SMTP id
 t15mr8655534wmq.94.1638378257676; Wed, 01 Dec 2021 09:04:17 -0800 (PST)
Date: Wed,  1 Dec 2021 17:03:55 +0000
In-Reply-To: <20211201170411.1561936-1-qperret@google.com>
Message-Id: <20211201170411.1561936-2-qperret@google.com>
Mime-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 01/15] KVM: arm64: Check if running in VHE from
 kvm_host_owns_hyp_mappings()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

The kvm_host_owns_hyp_mappings() function should return true if and only
if the host kernel is responsible for creating the hypervisor stage-1
mappings. That is only possible in standard non-VHE mode, or during boot
in protected nVHE mode. But either way, non of this makes sense in VHE,
so make sure to catch this case as well, hence making the function
return sensible values in any context (VHE or not).

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 326cdfec74a1..f8f1096a297f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -239,6 +239,9 @@ void free_hyp_pgds(void)
 
 static bool kvm_host_owns_hyp_mappings(void)
 {
+	if (is_kernel_in_hyp_mode())
+		return false;
+
 	if (static_branch_likely(&kvm_protected_mode_initialized))
 		return false;
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
