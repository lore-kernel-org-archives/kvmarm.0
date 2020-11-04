Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712E6C5DF9D
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE1FE20BED
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="NS23bt/7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE1FE20BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56F5E4B72E;
	Wed,  4 Nov 2020 13:37:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o6e8TFh2BGEN; Wed,  4 Nov 2020 13:37:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C9614B79B;
	Wed,  4 Nov 2020 13:37:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B22F4B7BC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j7KO1HeVDWGz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:02 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 001604B79C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:00 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id v5so3364607wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=fuG04+12p5GokhKo0kAWDPgSX2S/UpZSRo8GkJtW9dc=;
 b=NS23bt/72SalQlPudTi1kUeX4t6arEB5xzntdPJJpX9s45iPtfgG25FglOu4DBwuIG
 qzomur1VBzBc4eT5elwu7R8DhwGP3UWqyIW03ua3R8FF0NAFV/hAEUHGoNvJ92aATLPG
 Hc50WuDGVvCyF2qvzN1oqJ0pQ/uzyS1xVgM5ySHGA/2Zr3YWI9emxF2G0MZ57rF8fn3+
 /WnduyCd+eCb7wr0OK7Tmj46TiKZLTLrEnko/9u8/wjW6APOdTjHk+YdTtjnX/xbcKQT
 NyqveU6uNgHoKOBvg7H8nh/7Qu06IfYBzm8UD65hQ3YltPI1FpIYhhvcUu8MMntcXDCu
 4+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=fuG04+12p5GokhKo0kAWDPgSX2S/UpZSRo8GkJtW9dc=;
 b=Uu0CXnIH2azM+325fURqeVrlHSWLv6Pu7B9vd7g+dcJgq4eov6MMei4VzQ1xfSc6jW
 LudP1d9qjipUQle4KhXhnM4KjGqO1uipZ1NtqthYrOFg5i6pLto8a/y9Cz+47DFfltie
 Aqb1D7PcL/rMu0wPqLlKE1bRC1D2pagO91gnK09EocMX+70xHJ6RtMXNKS+HMC0Ir4CR
 x1QI0PCplV2FUFRyEfs98pJgbzMHmXiBhE3E0lD8UEXuo2GG+6BWOQvFJwQO6lIAQFcX
 ZawDj10AX51AkmCkcZl3y+NvIY6MjvMGLP5c2e/fo9h7YVeXc3+KY1bXkJVOoWuwZJRG
 NE9A==
X-Gm-Message-State: AOAM530OHgijVu/yUuh7vt8+KN9aXGvL7eMzKnAB79SmcCzx7M8RW7nJ
 5GInJJFJ8VT7Qj4u9efWHgEAvJamdvxkq1p/
X-Google-Smtp-Source: ABdhPJwMQ/dqr9JqMtNDYjvCoJDFSybTlMO7ZERHRXz8pPXtXsVsNjnOk5mwvRVZ/l0H0MUNKyXdMw==
X-Received: by 2002:a1c:1d92:: with SMTP id d140mr6025920wmd.48.1604515019649; 
 Wed, 04 Nov 2020 10:36:59 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id o184sm3518971wmo.37.2020.11.04.10.36.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:58 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 10/26] kvm: arm64: Refactor handle_trap to use a switch
Date: Wed,  4 Nov 2020 18:36:14 +0000
Message-Id: <20201104183630.27513-11-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
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
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
