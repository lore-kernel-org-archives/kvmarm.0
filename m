Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384DAC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 01:16:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3E264B089;
	Wed,  6 Apr 2022 21:16:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Psc4D0gV308U; Wed,  6 Apr 2022 21:16:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 297274B220;
	Wed,  6 Apr 2022 21:16:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C53CB49F4E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 21:16:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fae5Xm3+0ZTZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 21:16:30 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAB9C4B208
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 21:16:30 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 y23-20020a62b517000000b004fd8affa86aso1610140pfe.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2022 18:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=bNkFmzFNlQeAcnvu9GC9OTshsJeI+rH6kiFRlwb3YBU=;
 b=K8Gs9++5sAjjhKmOk+cuBZV91Fgx1F2Mc9/ihaqPTpvvoSDaAbLdCPmuZPTlG68if4
 P+L4S4dZumJgdSzNaEYVh+GredXixyyYlIw20G4uFBWxPVYkE4B4SKiO/claX7T8fsqZ
 973YmBn98DfC32Jfkfmhgw6w0dQlXY+5zJIAo0HS7siO1awykxEQcHKvmgE2C7Wulzf+
 yCe+cXmw+ol7FZCVBquExv//U+Raiq+r8EeVZnh/Gvh67wftRg0AnrEFREcqmr/YtDAx
 MWqy6tOmw/VyRjst4kEyYRT0NdHa9vj5NDXg6tBeIW1fR0zgikI1q556ZrgXu7cgVb66
 SJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=bNkFmzFNlQeAcnvu9GC9OTshsJeI+rH6kiFRlwb3YBU=;
 b=Eb9MvO0zi6XlRzikIiXUGDOScNOQchkvZQoAQJ/w2PRQgC9EE7sCyHCDA9BHr2AUy5
 ysQWvXuSkiWjrUVftoqENLrS4i61S+1HLCbXli5h1C16FBcq2UADzHrpR/pU/pcS8d5i
 KGrXXNOVgU5ZTuR6pkX10F9EQhQAXdwWJlWgtHgkKNfnR5wbBn46ghhEAD5M+VV0a+4+
 dDaWUzUCpogda4v7h0/t1jqNnBgiy5ZKz7Piw0UD9ibVL0lFMZZAFIKlpGEdTXSrYm/X
 sv64c3zmdGtk4LB8LO6xIA4otnEexi3KNIezy4uUUfuMddGrHuk3icvHiQC4+a0G1DqV
 jfBg==
X-Gm-Message-State: AOAM532AmtFgaI989bkmtaf4XOKWkxs7VsXSd0x+0Ds93rNnTece/3QF
 gW67Q88XP2aFKj7cWEeengmUX6UCjim4
X-Google-Smtp-Source: ABdhPJw3H13JfmsLMr/v01PnuQI5IQ6Tom5pq0QlYE+3A76jaQsbAEjlYFdMr4kCXy4hfGM3I3np0WoSyb7z
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:7088:b0:156:1aa9:79eb with SMTP id
 z8-20020a170902708800b001561aa979ebmr11197910plk.71.1649294189989; Wed, 06
 Apr 2022 18:16:29 -0700 (PDT)
Date: Thu,  7 Apr 2022 01:16:05 +0000
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Message-Id: <20220407011605.1966778-11-rananta@google.com>
Mime-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 10/10] selftests: KVM: aarch64: Add KVM_REG_ARM_FW_REG(3)
 to get-reg-list
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Add the register KVM_REG_ARM_FW_REG(3)
(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3) to the base_regs[] of
get-reg-list.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 281c08b3fdd2..7049c31aa443 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -691,6 +691,7 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_REG(0),
 	KVM_REG_ARM_FW_REG(1),
 	KVM_REG_ARM_FW_REG(2),
+	KVM_REG_ARM_FW_REG(3),
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
