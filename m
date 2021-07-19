Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6C5C07E95
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F88C6147E
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F88C6147E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F12940667;
	Mon, 19 Jul 2021 12:04:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZKyulDolZRzw; Mon, 19 Jul 2021 12:04:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E3A04B0C5;
	Mon, 19 Jul 2021 12:04:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E4434A5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UrbDImb8RKUP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:04:03 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53AD64B0D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:03 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 i7-20020a05600c3547b0290229a389ceb2so4105772wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=U8tD0ZWRxueOiZnXn8UX8nsv6z5g8QfT23T+iieg6fI=;
 b=ea29I0iVbjUEGeftel12Gbq366g83QtA8E8r2Uz+6IHkJ5UWd79gUIX3JA3bLyJe2D
 QopBkuDzcKVtOEKFgcYrOrqaG1U79giGVajM4WVon/jAnyPxWl7lSRLHkf5bUKq7hgqI
 qYrGlejOsSSAggxfvj3GQmg9m+MadgXLM2jZmKxePlf5wMrQg7oXbwV1tsjyrjq2MRA6
 FvMoXKvos5kv9fcrVWa87rlDj4y5EvS+eYCN+qe3HXSpqhRo9Kq1RukOmpGNRgkw1sAf
 vmRE9+AgJ5UoMmzOf5n3YI7T6NGPJw9OgUFVbWdHiFjEvWuFY/8WIPBGjuVN8OxaTsLr
 z+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=U8tD0ZWRxueOiZnXn8UX8nsv6z5g8QfT23T+iieg6fI=;
 b=k2gfXMZ4x4Rs4D37rqyHa4EaB3N28yuM9YpnmMlKflqsvkybJspF9GnTCXyQu3ebl5
 ItDtz54hxvdc3uvx46mhmcIX4ygkrdN+uz747s0e0ZsYEHt1ZeFbP9LUreg66rG5QP0z
 9gveXHU062X3J1mzRyrrSkXgmIwZkzBFZnsWwmVmpd2zRcE+TCaOnlBLT7KIxJddd964
 JlPuP7B6NNHM77V/QfrP5uo0h32PYv4kUNFYjG907YT1Fjov+QL0nGcyVjtKtfgjb8fo
 M3A7adkTUl4mvgYbhIufWJ21ukz3mqTc1DwvaubyB8UzTV+zIQCg1W5kPggfG3HiV8c6
 gyJA==
X-Gm-Message-State: AOAM533RZatWkcD69rVK/leMB98OZsoIKFNbkUyRNPjmW5Ym4Q0yV4p2
 ZOmTsoyIi5gEt0tSs2grglgst2/UtG6zsT99PqIwwIPJvHSnHDqRH0s+AUo02tJBq9wsV9Se7TH
 jc5Fs5r+mEcjj1v8UCkiB8GTryQjL3WRlVvNl6Q9cFJJclw/CUfKfMvux7jX17ekXR9U=
X-Google-Smtp-Source: ABdhPJyZIExAAOBCez1kX40oKv+JGxZhb6d/02I7dL1PYFLCOK6saRJUulsso2zHWmJh0mrJepqqSzq7lA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:4ccb:: with SMTP id
 c11mr30162930wrt.331.1626710642525; 
 Mon, 19 Jul 2021 09:04:02 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:38 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-8-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 07/15] KVM: arm64: Track value of cptr_el2 in struct
 kvm_vcpu_arch
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Track the baseline guest value for cptr_el2 in struct
kvm_vcpu_arch, similar to the other registers that control traps.
Use this value when setting cptr_el2 for the guest.

Currently this value is unchanged (CPTR_EL2_DEFAULT), but future
patches will set trapping bits based on features supported for
the guest.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 1 +
 arch/arm64/kvm/hyp/nvhe/switch.c  | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 76462c6a91ee..ac67d5699c68 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -290,6 +290,7 @@ struct kvm_vcpu_arch {
 	/* Values of trap registers for the guest. */
 	u64 hcr_el2;
 	u64 mdcr_el2;
+	u64 cptr_el2;
 
 	/* Values of trap registers for the host before guest entry. */
 	u64 mdcr_el2_host;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..14b12f2c08c0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1104,6 +1104,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
+	vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
 
 	/*
 	 * Handle the "start in power-off" case.
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 1778593a08a9..86f3d6482935 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -41,7 +41,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	___activate_traps(vcpu);
 	__activate_traps_common(vcpu);
 
-	val = CPTR_EL2_DEFAULT;
+	val = vcpu->arch.cptr_el2;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
 	if (!update_fp_enabled(vcpu)) {
 		val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
