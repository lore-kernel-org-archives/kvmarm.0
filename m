Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8F2C5517A
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EFBCB2087D
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="n8+AMW9H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFBCB2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91CC34B79C;
	Wed,  4 Nov 2020 13:36:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o39YyDZoQjeL; Wed,  4 Nov 2020 13:36:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 866244B7B7;
	Wed,  4 Nov 2020 13:36:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DE4A4B6A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6yZkFQ+qltKy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:36:51 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F98D4B7BA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:50 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id x7so23173737wrl.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=DIjGlXFqYL9FyveOV16h0d1a4eeVc3TLm9h73PIyC8E=;
 b=n8+AMW9H/IX3G8lz+cWGN1oavBIb5GbzZnNrEEdw+sYskA9ecY1TNAMYatbRQDl7uy
 nU1UQSUawSlfFozbAg0rTLm5KbnI/FEYx0M9/Kn5+yGcBQ27q37523/Vo/IZipYdWuM5
 tw2FvnITfYxX4SXKqgpbQ4G76gBTOOkXtvxJTq7PtsfksWo89S01idD1OfYzSABuoFpP
 tVNb8gNrqGQGaUnf1bLkfw9v3P4dRzQICWnTURUB+lq5Xkz3zzjpXZlwLEPCy4VLihoo
 HEPi9o45di5YZQ7BQ/ZFrvoqXPnp9eMfV01QMcXfdeK2mVslLC+QAWW2jN6+MIZX9BRl
 qlGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=DIjGlXFqYL9FyveOV16h0d1a4eeVc3TLm9h73PIyC8E=;
 b=qsjijwC6s/r8m9DUwryR26lNJkGY8h7I/I+5jhO/XAvi0uQIO/+hBarsUX0BpuVFwt
 RzsNBTTHJvgVZIKIu3OiCqwMvniEie9OYys63cgow+q5LUOXF4KQpCnBbqH6UrqkWAog
 nO7PZ3Viyi57NId1cREN/6b76Et6t6PN3pib0v1K9tMKzFtjJ2yLxsxFUrQcZVn/I67G
 FiHhM+erqkaXtS5Vi6Fs0o4XE7QitYzBaO1CGwYNKX798VwZVbRrt62OogUhxHmot8QX
 HRkgqsbatzrb/jqBXTKvK04x5n5baX83C8tRX03mEL6ucs9IC9lqXgq2DHpX0d7DEIFi
 XknQ==
X-Gm-Message-State: AOAM530AyXUasmw4RBKT+czqIPxtRPD0+poLAIEJgKhQs7QCnMT/RPsq
 xmzo0EKu/pRH5t1vYwipLsb2zYaL1/p6LhdW
X-Google-Smtp-Source: ABdhPJwq7DN+2FlZtGXRhvnGQBPP7XUYeccP8u2X/rHVvW5yiq4qao29DK8F1rl8NE0ItwSBLn89Eg==
X-Received: by 2002:a5d:640d:: with SMTP id z13mr32595956wru.28.1604515009243; 
 Wed, 04 Nov 2020 10:36:49 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id h12sm3718613wrw.70.2020.11.04.10.36.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:48 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 05/26] kvm: arm64: Initialize MAIR_EL2 using a constant
Date: Wed,  4 Nov 2020 18:36:09 +0000
Message-Id: <20201104183630.27513-6-dbrazdil@google.com>
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

MAIR_EL2 is currently initialized to the value of MAIR_EL1, which itself
is set to a constant MAIR_EL1_SET.

Initialize MAIR_EL2 to the MAIR_EL1_SET constant directly in preparation
of allowing KVM to start CPU cores itself and not initializing itself
before ERETing to EL1. In that case, MAIR_EL2 will be initialized before
MAIR_EL1.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index b11a9d7db677..96e70f976ff5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -111,7 +111,7 @@ alternative_else_nop_endif
 
 	msr	tcr_el2, x0
 
-	mrs	x0, mair_el1
+	mov_q	x0, MAIR_EL1_SET
 	msr	mair_el2, x0
 	isb
 
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
