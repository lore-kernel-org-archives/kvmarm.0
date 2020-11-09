Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A66EC56201
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D25D5206ED
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Nlkt2NoS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D25D5206ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 703AB4B76F;
	Mon,  9 Nov 2020 06:33:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7xeTEdgnwWjT; Mon,  9 Nov 2020 06:33:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0244B872;
	Mon,  9 Nov 2020 06:33:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D2EF4B72B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bels-XHHaMiW for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:00 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 976E34B7D5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:59 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id j7so1053461wrp.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=R9d1+peEDKIDAC4BUkJrLbr91HxlsiVlv7gVncj7oJE=;
 b=Nlkt2NoSN06mNMUiV4czGigWOfDI7alqjAr/VMiKAFi8r6SvbUFmz5qPCSigNbzGOt
 CcGl9WRnVJZlERP13JXxePqpq+CU1BM2zj7a30/EIygFZ19rzJYInzQrH0Ljz4jw7llX
 f1jQJ0Kc8LLGgt1H2glCPIT3bTzTawZk3J/ZwhQ/dbCiyJR8NCUeqezVV4pN1JrRhYD+
 1H/QFadgpHUUQqKOgln9mSwviXlgghCm6zoyLHdi32xsm/LfSaHON6HH/BFfBXggztVp
 Xm6hUSHCwFGge2giBU9ofUcBQTbgyAdWT16BEx2thI/+/obwWbQx/TBHVlTa6aPc4rUM
 hr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=R9d1+peEDKIDAC4BUkJrLbr91HxlsiVlv7gVncj7oJE=;
 b=TV1uuOXONqdTqb7/bZKwLQXe5dJJP3NRRkL+e4C38Mx1ZytaleB4DJ2VbK/GBy0ovr
 rxQPDSVsoA0MzzFOQTw5Hdz7056fCSFUYUrSzzMlIShC7f0Q8t0smcgS2wL45V7rgzUi
 nDuSPWigRzby1Iaf3H8CQEaZjeRIcaROhcPG3y3iSo7NvKInPwiYhcfvD8uY3+7AZfCu
 lF73aq961DnvzKz/5IyT/yXzoM7wjbPqr4jtmvm2ug7A7yjKNqiQU5DtOms9QVpJsuG4
 kHBYbB09/aaXUlZiQRihQWu9u9lqdVKQ2P/mQ5KUBkc4pxaDh+zBLY96TB3rQB2jW3Gb
 j25w==
X-Gm-Message-State: AOAM530XB3zIFGZgTyxK/RhS1pU2hlHlivq+oV+PO2EdJHqP0Y0QuYO1
 of5dZhMscdABwalwS8ZQDO9kuXl4Fj5BIjjK
X-Google-Smtp-Source: ABdhPJwYuIGUPqMp11VFz88V7y1F5zU6JG+SWQiwKv4yp8uGAfg16WUH01aMz+AxIfZqkyce6q2v2A==
X-Received: by 2002:a5d:6452:: with SMTP id d18mr7927464wrw.200.1604921578344; 
 Mon, 09 Nov 2020 03:32:58 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id z14sm12812890wmc.15.2020.11.09.03.32.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:32:57 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 09/24] kvm: arm64: Refactor handle_trap to use a switch
Date: Mon,  9 Nov 2020 11:32:18 +0000
Message-Id: <20201109113233.9012-10-dbrazdil@google.com>
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
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
