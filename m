Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BA1C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35E4B60F22
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 35E4B60F22
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE5E04B14A;
	Tue, 17 Aug 2021 04:12:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BbtLxrzjs5wA; Tue, 17 Aug 2021 04:12:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B2504B16A;
	Tue, 17 Aug 2021 04:12:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73D0B4B159
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KvvXznz6ofUy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:12:04 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14FB64B14A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:54 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 p10-20020a5d68ca000000b001552bf8b9daso4587336wrw.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+LnYz68K0/l+zVlwhzMBHhFllBcdwA8o9zPnuvPdhe0=;
 b=eNCBRoMkjOMI1w4Bde0MwYe/+fVCHL1uO5oA1/7mvgpVquoq/U7usqWzx9nDuVenns
 BQi5B7hZi3es7WYC/W87KlBzYklGyJPgnQV7TfmgIoys5AQ4YA6+IunfsZvAIidGmumc
 XPNo4d52vG8FKOb94+28WQIeUjE2bFAMqVAHwcYCHWKtJC23mfmij3uHJSrBA7NsjnHn
 OydKvJ4RnpdwTpLfFQ+i/NK/GHDCZP3c5L+oe3KhCnYAiU9B9KOjwd0rQDJccClee7/z
 0KtgAGBKfcMOFu2mGsWMrmdAw//fBve6xiM1Yq8lW8dhDvbha/o14XZtd/52XL/ZIk1U
 Okng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+LnYz68K0/l+zVlwhzMBHhFllBcdwA8o9zPnuvPdhe0=;
 b=Fn9jInDZ6fRK+NnSl3bw4Iml8idFZepnIHAuhWQ8N9x6rO8Qm96CgcQcUmHTy9Xdnc
 NgETv709dS7fFJ6LE+LyjtQpHXpD4jKfLYfwb0/y6mhSGyzc9BfyMrp1+T3pByFqRNxq
 AEuvo+QQpQ50fIR31Y3Zg4nG3yHxmoDJZn5Hhmim6MGqy+Mm5G+C/sDYUXPyJaf+o9va
 hGwQYQAAAqyVPiZ6bORWWX8Cx2AXjlpQzbu6E2DCb7J1QOwjY9n4sjS/3mxeV3GHWDRO
 HN9qvWrEfWcD3md9fOr0LNkjESkQMfpWSMbwjtIRStdG+kAwIZxbY5chMKyO217N/wcj
 M0Xg==
X-Gm-Message-State: AOAM533R+NVE/GVMwF/FSOpppkXIBA+kg9F1/QZHdyGLLGwzLFF7nhep
 nYqZcgYeRUQC5TMDjye6kCxhB0PQQrMoUUZuBc0b3SJ55rZvwpayfI1dRMSIZYrgES0V6mEkeSX
 AvpKsK7/okCD3Q+E0DwPR/dwr1ZtpIKaOA2l/q7eLtUnORpF/PhSZDeB6nTtds002YTU=
X-Google-Smtp-Source: ABdhPJyZWFpU/vfGQ67R9j5JsRWqvs8PPjjGpxXblDdr0ny97M2MYAIupQIWIGkVZyPx3cSOzFUeUusJBQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:4c:: with SMTP id
 73mr2053153wma.139.1629187912994; 
 Tue, 17 Aug 2021 01:11:52 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:27 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-9-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 08/15] KVM: arm64: Track value of cptr_el2 in struct
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

Acked-by: Will Deacon <will@kernel.org>
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
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
