Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A5CC4320E
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 08:51:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41CAB61053
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 08:51:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 41CAB61053
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD07A4B0CA;
	Wed, 18 Aug 2021 04:51:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p72wGQ2W14Sl; Wed, 18 Aug 2021 04:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EC874B0DF;
	Wed, 18 Aug 2021 04:51:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD868402C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 04:50:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ctt1lajlYhdc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 04:50:58 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A90FC40630
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 04:50:58 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 j9-20020a2581490000b02905897d81c63fso2121334ybm.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 01:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DspQEBuuNTP9Bq7Hjczs55/n66cjehtUP3MVQic92Uw=;
 b=d8YQgwF8kuiNURI/c1QYvU6zzDLbI6X3ENm5vQ2Km5NMelVr6e+EfpEnn4+5nDCbnA
 sBJy039P9fixXoQtw3D6Xys6fwAbDLRKT11qwbp9IhABvc2jCvgE5Ju3CelpTV5CH/9t
 U7AG6IwjHmpjjyzBR8BQeV1tzbgfUFaQiu0y374iezdAhNGfVK87yRvmBuMOoA3OtK09
 Ze/+8zhG1aBmpDoMQkK3sM6XntNmZ2XqvsJkuFOJiOElsrHI1XOufwYv4FgeC8Q/mLse
 GGuIJPLdK0jAQlFk7s1zh3XZGTPoqfGsVd8+Rqjg2d8vYS6702FhvtB+XHPNCYIz4PyF
 M3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DspQEBuuNTP9Bq7Hjczs55/n66cjehtUP3MVQic92Uw=;
 b=YBh+vkwF2K8JXN1TwXPC4EGePliD31Gn57jsxoeE9bFwhhtDXU1t1BMNe3SqRumL3G
 9ZnBy0Ajr5mGeh1UC9KNPhlSmK6osZz66NF5h+ETw5KUqFfxfBtDKwTdceP41M3uI8XZ
 Mo0mmgEBfuC0ZGPsq5MdCjrc4C2wjd4rakGwnkG98Gehl+LUTDgN83kRsb8k+vIbKU8B
 e2EVFrUTetfA7H2I3FOznqfnxztGVVVa5HTGPpF+6as1tLV8TQKRzBHy4QwlKbfOV+OH
 2/iPSlc/YEXu29yyIAl2hbeh3Qva6LhsNTRT1XcCX+RWYHxypmmpBh+drHkFDZY6YHqf
 NtVw==
X-Gm-Message-State: AOAM5315flMLPMfnGAxxoG9nimJ3XIUwut+KFVk8NdJo+7grE11jhj8x
 vBsF76i1SOKCs85K+XKEkD3K2rBqxHs=
X-Google-Smtp-Source: ABdhPJz8bUl+O8hBODHIOgKlHWEgrJLWQc8EpGlIAkpoRfRXwfEhJfPc5yYBs4v3vq707g0eqs2ujbCAlxY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7a03:: with SMTP id
 v3mr10801375ybc.202.1629276658180; 
 Wed, 18 Aug 2021 01:50:58 -0700 (PDT)
Date: Wed, 18 Aug 2021 08:50:45 +0000
In-Reply-To: <20210818085047.1005285-1-oupton@google.com>
Message-Id: <20210818085047.1005285-3-oupton@google.com>
Mime-Version: 1.0
References: <20210818085047.1005285-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 2/4] KVM: arm64: Handle PSCI resets before userspace touches
 vCPU state
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>
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

The CPU_ON PSCI call takes a payload that KVM uses to configure a
destination vCPU to run. This payload is non-architectural state and not
exposed through any existing UAPI. Effectively, we have a race between
CPU_ON and userspace saving/restoring a guest: if the target vCPU isn't
ran again before the VMM saves its state, the requested PC and context
ID are lost. When restored, the target vCPU will be runnable and start
executing at its old PC.

We can avoid this race by making sure the reset payload is serviced
before userspace can access a vCPU's state. This is, of course, a hairy
ugly hack. A benefit of such a hack, though, is that we've managed to
massage the reset state into the architected state, thereby making it
migratable without forcing userspace to play our game with a UAPI
addition.

Fixes: 358b28f09f0a ("arm/arm64: KVM: Allow a VCPU to fully reset itself")
Signed-off-by: Oliver Upton <oupton@google.com>
---
I really hate this, but my imagination is failing me on any other way to
cure the race without cluing in userspace. Any ideas?

 arch/arm64/kvm/arm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0de4b41c3706..6b124c29c663 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1216,6 +1216,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (copy_from_user(&reg, argp, sizeof(reg)))
 			break;
 
+		/*
+		 * ugly hack. We could owe a reset due to PSCI and not yet
+		 * serviced it. Prevent userspace from reading/writing state
+		 * that will be clobbered by the eventual handling of the reset
+		 * bit.
+		 */
+		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
+			kvm_reset_vcpu(vcpu);
+
 		if (ioctl == KVM_SET_ONE_REG)
 			r = kvm_arm_set_reg(vcpu, &reg);
 		else
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
