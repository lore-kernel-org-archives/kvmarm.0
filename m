Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7637EC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24D646138F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 24D646138F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C94804B0F7;
	Tue, 19 Oct 2021 08:13:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pPilotAxWp8C; Tue, 19 Oct 2021 08:13:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFD1F4B0CE;
	Tue, 19 Oct 2021 08:13:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A8854B0E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bztnpIqXEsF6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:29 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A99114B0DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:28 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 p12-20020a05600c204c00b0030da46b76daso653942wmg.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lFnO3V1vcCaxCQp+VktMJcKCn5jbqprlvSckwnNsC2I=;
 b=UesM75tSQOr45py6fmGldxnFZ9qhEpvDJtfc4apxLzl+vaSpskjZwXcD+vvH4lZb71
 As8F+7i1zzMOpoNT7YUGxMUVpiB8c0NDcbRvtlAROdU3IQYsujSlMzJLH9nvz+6DLVHK
 vJRzQS7wBFHQO3YkY6Xec9Pwo6xYZSj30VNWKHbaOabamzLvVtuZDneBjv1pLT8mGCYX
 DcoRFa8C8Iwqa1uNt0xjG6wxks4HeuMis1JBBY2eEu5k9YvLWHzHgOOhKtYnx5KcDzGR
 +xuNnU1Xky1kYEkg3hTbTL4NVyJOzh3NB457XGrqSEC0sX/d9IlZuLvuuYTnTBcm4Y1m
 ZRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lFnO3V1vcCaxCQp+VktMJcKCn5jbqprlvSckwnNsC2I=;
 b=EFJ6Bnw+Dr7tj2dYN5AhmpMZjhaJ41nvGUM7RdKOkXuXN1CuZz1/Rfn/w0xBzNfEkv
 qoHv9ZspUxSjOmjnrKFbVES8X94Kh4c93N2LjDjC/JeLhlf8RgUf/qWeo48PLoN7Ol8l
 Boe8+WFWhiYtao4VpSxgQfANNpf60BwKv2t0P8K2RNfF25PIzRa3jaaxX2StjI14OxAe
 WJcXI3J2pMrykqzLFMBPlIgiUrnndusOYRxO4wTf24dLi2rbDsI6jQW0q9M+X4CHjlQF
 sNMGMpkX7tA19wufUHMoE5iMsOlHut5/lcugiTgwLoKNHrlf7lucO0xr/ZXBZJSh39L+
 Kuug==
X-Gm-Message-State: AOAM530sQnh8yefU4E+cqtRph3W5hBnRp94zXP7GDMKt3HgsyG3mGBin
 svftmj4IA3/lUMmK/+5EyDUzqQoGJVEa
X-Google-Smtp-Source: ABdhPJzM8Yi1zkltqsZIknAWVlvpJd+76GDP3lU7clYj1DZGyxNzgbxFRtOLXsCPKmvrYy6VEEMSHUHhKXXR
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:a7b:c441:: with SMTP id
 l1mr5486888wmi.69.1634645607924; Tue, 19 Oct 2021 05:13:27 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:12:58 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-10-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 09/15] KVM: arm64: Extend pkvm_page_state enumeration to
 handle absent pages
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

From: Will Deacon <will@kernel.org>

Explicitly name the combination of SW0 | SW1 as reserved in the pte and
introduce a new PKVM_NOPAGE meta-state which, although not directly
stored in the software bits of the pte, can be used to represent an
entry for which there is no underlying page. This is distinct from an
invalid pte, as stage-2 identity mappings for the host are created
lazily and so an invalid pte there is the same as a valid mapping for
the purposes of ownership information.

This state will be used for permission checking during page transitions
in later patches.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index b58c910babaf..56445586c755 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -24,6 +24,11 @@ enum pkvm_page_state {
 	PKVM_PAGE_OWNED			= 0ULL,
 	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
 	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
+	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
+					  KVM_PGTABLE_PROT_SW1,
+
+	/* Meta-states which aren't encoded directly in the PTE's SW bits */
+	PKVM_NOPAGE,
 };
 
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
