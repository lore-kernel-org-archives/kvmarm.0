Return-Path: <SRS0=gNwE=PR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7EF1C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 29 Oct 2021 00:32:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6EBC461106
	for <kvmarm@archiver.kernel.org>; Fri, 29 Oct 2021 00:32:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6EBC461106
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 211CF4B1A2;
	Thu, 28 Oct 2021 20:32:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p3ZnonxYMoHR; Thu, 28 Oct 2021 20:32:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD104B162;
	Thu, 28 Oct 2021 20:32:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C350C4B190
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 20:32:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0w5qGPzq0KqJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 20:32:44 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE0014B162
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 20:32:44 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 n10-20020a056602340a00b005de2be80c34so5321392ioz.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 17:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Oy01IknDRFVJKLSnWHmExcfPSXKDoq8nS6BDKnDz0O8=;
 b=i4SQt8b1AkstVV8CAePyo55dLl6VOqR1QVAiVbqgmCto/zYMwI9p6BgIoTIFAPZXvC
 RYV9R9Ieg85IjpWwhQ80iBwhSdmiRXDjZ4Cn6EKwvCQ4VFzULIRTbQVedU4MI34xHFpE
 knIqoBIrFOrTTrlhR63X91EXWeHBrqc8Wy44sc0gQ2InrMkPC7POadxyO/T73FTHi0Uz
 U1XBNc8ODIfe3BJS4+JTlNavF3j1xjXWmuzWnVVrW+KmGUeZemgl6ZxQKNUlvzmsAt2S
 XJRivugCqYaiWWIKtuyQlzaOJghDbN2iENFoRYExbkDSbvRJj/hVa65/XRo4FEamT4QT
 hQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Oy01IknDRFVJKLSnWHmExcfPSXKDoq8nS6BDKnDz0O8=;
 b=HWwEeSM1o3qrgRICoJoP+1DO40uPs57U0hfe/8x0hgRsJaJloqEzDswoQOo8fYQA0G
 5eT91df6kkw11HBL9GI8Mw7k1+cYJbY/WYIauzpBwN5pyvJkjKdvHgyGYzzMhvVGA6v3
 91CuMeaU8ieq6FHDRcXHjBGbf3VChdTEN4rlcrNnfJZGIeecsG+XzpFVmz5PGSTGevTY
 fg4wUPlDFIPZxPAsrz9H9zmZajUc3n0yDhohbs7K16LoLZlwaZ7iT7diCigV5s78IVdH
 sfxc5uAxkOxJU34xiJtyYjo6kRGEthls/vSmZxbySg4WJ7FSz5IGJtkr7brzuWur6eBN
 ON5A==
X-Gm-Message-State: AOAM530STgYgSETOHS8RoMeURnY69m/X2AAoFymYU8s/WgMDAdzVRq3N
 H+g2R7I7w9jAkgAwCv6OxuJUoCol1p6gSp3vbtsjz7nyJqt3BM+XG0spJZIgEni11EcI4vm0m9R
 GwN9oEv2dmOHGUndjOURu+DHNSw6Sjr7TpHA9tVCSNh/AsDJGbwTZsY0EVKD9PtqLxIcVcg==
X-Google-Smtp-Source: ABdhPJyxXD1Yuus5/OHrCt1h6LMDXta7JdKp3vcZcLarAByoLzOk+GrzMDSQpNSt9IwjFcgVU85NVKnra50=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:329e:: with SMTP id
 f30mr4310865jav.63.1635467564021; Thu, 28 Oct 2021 17:32:44 -0700 (PDT)
Date: Fri, 29 Oct 2021 00:32:02 +0000
In-Reply-To: <20211029003202.158161-1-oupton@google.com>
Message-Id: <20211029003202.158161-4-oupton@google.com>
Mime-Version: 1.0
References: <20211029003202.158161-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 3/3] KVM: arm64: Raise KVM's reported debug architecture to
 v8.2
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

The additions made to the Debug architecture between v8.0 and v8.2 are
only applicable to external debug. KVM does not (and likely will never)
support external debug, so KVM can proudly report support for v8.2 to
its guests.

Raise the reported Debug architecture to v8.2. Additionally, v8.2 makes
FEAT_DoubleLock optional. Even though KVM never supported it in the
first place, report DoubleLock as not implemented now as the
architecture permits it for v8.2.

Cc: Reiji Watanabe <reijiw@google.com>
Cc: Ricardo Koller <ricarkol@google.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0840ae081290..f56ee5830d18 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1109,9 +1109,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI));
 		break;
 	case SYS_ID_AA64DFR0_EL1:
-		/* Limit debug to ARMv8.0 */
+		/* Limit debug to ARMv8.2 */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 8);
+
+		/* Hide DoubleLock from guests */
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK), 0xf);
+
 		/* Limit guests to PMUv3 for ARMv8.4 */
 		val = cpuid_feature_cap_perfmon_field(val,
 						      ID_AA64DFR0_PMUVER_SHIFT,
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
