Return-Path: <SRS0=7ri5=BA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C48C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 09:45:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E41720771
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 09:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="i7S9t2tE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E41720771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0643B4B1B7;
	Tue, 21 Jul 2020 05:45:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7ykZnKYCFFyB; Tue, 21 Jul 2020 05:45:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA2494B19D;
	Tue, 21 Jul 2020 05:45:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9994B1A7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 05:45:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NYQDk8Z0xhAO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jul 2020 05:45:01 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDB1A4B186
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 05:45:00 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id a14so5674154wra.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 02:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=VCTmXoCDoueHGgkSs0dR8Q0gxBgF8BRtzs8whbeoPBY=;
 b=i7S9t2tE6o1ZpRYbBoPLh0mSIFrwHpF9lRxApXBd0SVtfEaMYvKF999IuDfaCE0DdV
 wFP+lVdRe3oBxP2XXvkxkBId3a9rt+6LPKWVsl+ePCY53KV/eftUkC17hvcyirlr+CGK
 x7ecwNpbckzsh0wui6eblLsfMr8GEq9ZrWF10CjkBxj2vMY7btc6zTVBhf2gFaf+aYKQ
 Z9o0w00u6PzL/RWmFmEzV0p9EKWUu+yEx7/TbdTY8Td8Japa4BSiSwPQ6XbmtKjsTrTi
 vXBWkcRXULUnuwkT7FCat/ZEFHAvwe0oSFvoHGLxUv4FYZhSJU1tk0eMqjkihc349oCz
 jYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=VCTmXoCDoueHGgkSs0dR8Q0gxBgF8BRtzs8whbeoPBY=;
 b=cT0d0hXrzmgUtRktjJks9ews8q2CWMNdPtOluXCROBxx/5uWK5v7nAIBcu4D6vWMXl
 EIBEg0j/1EfFfnOHag66t5EAtH4XqAYHrUyPVAKpWsL3Mm1aDRKW5+/x/6EnDAttj4C8
 x7TatRqfdfeyxvuP2DyRRobW4bikfYqHm931r9Gt3EodtJ+e3cl0UAqgS2OMEE4CyiBg
 t4L75gggkCAQuQIIubERkaBcMO/kxuC2xEkmG8xn37p90Frlau1EoPl9mfMkRIOkpWz4
 tU5Dg/xcdPvtGPUKctG1XTWRxjnv3NTDhFB0b15Q607nDau/OXS65iknFu0JKlT07/w7
 XhJw==
X-Gm-Message-State: AOAM532W1e2LBxkIO1EGuENcOFnvdTx4JqpGaHf3ZMsmyXLHcFwmafQE
 5g00N04MRlcnjTuNt85bxbT9dw==
X-Google-Smtp-Source: ABdhPJwsEeqkTbsLPEJadyPaueujiKzL/IxGYymb0jshDg7vVUsqj2qjWEo9k1RSpX4pHM494OqVlA==
X-Received: by 2002:adf:f542:: with SMTP id j2mr25975490wrp.61.1595324699596; 
 Tue, 21 Jul 2020 02:44:59 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:cd93:4ca4:af31:19e5])
 by smtp.gmail.com with ESMTPSA id l1sm39195773wrb.12.2020.07.21.02.44.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jul 2020 02:44:58 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 1/2] KVM: arm64: Make nVHE ASLR conditional on RANDOMIZE_BASE
Date: Tue, 21 Jul 2020 10:44:44 +0100
Message-Id: <20200721094445.82184-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721094445.82184-1-dbrazdil@google.com>
References: <20200721094445.82184-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

If there are spare bits in non-VHE hyp VA, KVM unconditionally replaces them
with a random tag chosen at init. Disable this if the kernel is built without
RANDOMIZE_BASE to align with kernel behavior.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/va_layout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index a4f48c1ac28c..e0404bcab019 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -48,7 +48,7 @@ __init void kvm_compute_layout(void)
 	va_mask = GENMASK_ULL(tag_lsb - 1, 0);
 	tag_val = hyp_va_msb;
 
-	if (tag_lsb != (vabits_actual - 1)) {
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb != (vabits_actual - 1)) {
 		/* We have some free bits to insert a random tag. */
 		tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
 	}
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
