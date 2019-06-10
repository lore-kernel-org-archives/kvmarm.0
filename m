Return-Path: <SRS0=ZPOc=UJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D16C468C1
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 06:06:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96C2020820
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 06:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JivEgBVu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96C2020820
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E55224A516;
	Mon, 10 Jun 2019 02:06:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TPF9HnETu5Y9; Mon, 10 Jun 2019 02:06:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2EF74A4E1;
	Mon, 10 Jun 2019 02:06:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F1D14A4E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 02:06:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vWx8wNIwWwTe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jun 2019 02:06:41 -0400 (EDT)
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
 [209.85.210.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33AD54A4A4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 02:06:41 -0400 (EDT)
Received: by mail-pf1-f193.google.com with SMTP id t16so4621727pfe.11
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 Jun 2019 23:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=/Dkvj991Uhw/1cfRgxPNcyrHB69xx77ySHEyTXjhqvA=;
 b=JivEgBVuc6FZ4RjN29MeUE/bi4q5QoB1acpQCvG8UpXZhGQxck6vFiqw3+HjTh4Z5W
 2K4vQW/5irgR3BnFrr6hbyNMNs+TGlC5gFHh39gF46VAA6T3UWprM0IpMfaexBbj7klS
 C0Urd0dp0FU36novirPjriUnM1bK4c4qYvHL5ciE28lX6N/I6tkzuWewsiYx41IgwElK
 8EN8i0ved+yvkXSHOyHWnRxljY31ztw1L4wSWA9XJg4P1lxb+WrzDxCzsVGJ9b6EpCpr
 lNF96CTDQxEDstXRPOrYiz/mixGYEg9zIzZHwEFO467O4vSldUCZJuNfgCWnHkneFL4s
 oaew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=/Dkvj991Uhw/1cfRgxPNcyrHB69xx77ySHEyTXjhqvA=;
 b=P+to+lhqhRsY+SE9EDCBDgCoZr6JyQbBrMklEFXJt2+4fa1E/jAxK68rXr8aH68sot
 H4KdcabH2WeILUj+t2KdxRT+fwmoRKIkLdjLjULSGyMTuzoDRU2G9Bf1PDd9mvoBMe17
 j+RCb3EghHRzrowrHlm6VIpZ0zkILA0lOnbhyO69MgTR8YwgPWROGJgzYqfo2SWPnEzv
 KuegnKUTg4vrAV9MCxP4CBfbscuCycqzAlSLJCG8c76WW3d8hp1ipYvXSlHitI7ou6KY
 hc/8O2KplwUScltlOmbVg3ahFD4oLRRj+TSslHb5qjgyz8U0+EtOXtuEeLz6Wc80ZoUB
 oong==
X-Gm-Message-State: APjAAAXuAa7fPoziffnhnI0Df/WoVZb1RNsOABlLreSr8rmNnIw4PENN
 zb5ed5sa3WHWcWGKPZz8F4ilIQ==
X-Google-Smtp-Source: APXvYqwLbTkJ83xIZQSN0X41sV2Qx5mmIUMQI8suaFwh1ovaQIunxZGLx5yEKCwIgFShFJqoprwhXg==
X-Received: by 2002:a62:2643:: with SMTP id m64mr70607053pfm.46.1560146800022; 
 Sun, 09 Jun 2019 23:06:40 -0700 (PDT)
Received: from localhost ([122.172.66.84])
 by smtp.gmail.com with ESMTPSA id 26sm9290214pfi.147.2019.06.09.23.06.38
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sun, 09 Jun 2019 23:06:38 -0700 (PDT)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
 James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>,
 Suzuki K Pouloze <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>
Subject: [PATCH V2] KVM: arm64: Implement vq_present() as a macro
Date: Mon, 10 Jun 2019 11:36:33 +0530
Message-Id: <7c2590c4d8cc95cd40bbb05c0d0c5e2b0735a16b.1560145715.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
MIME-Version: 1.0
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
 Vincent Guittot <vincent.guittot@linaro.org>, kvmarm@lists.cs.columbia.edu,
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

This routine is a one-liner and doesn't really need to be function and
should be rather implemented as a macro.

Suggested-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2:
- The previous implementation was fixing a compilation error that
  occurred only with old compilers (from 2015) due to a bug in the
  compiler itself.

- Dave suggested to rather implement this as a macro which made more
  sense.

 arch/arm64/kvm/guest.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 3ae2f82fca46..a429ed36a6a0 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -207,13 +207,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
 #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
-
-static bool vq_present(
-	const u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
-	unsigned int vq)
-{
-	return (*vqs)[vq_word(vq)] & vq_mask(vq);
-}
+#define vq_present(vqs, vq) ((*(vqs))[vq_word(vq)] & vq_mask(vq))
 
 static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-- 
2.21.0.rc0.269.g1a574e7a288b

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
