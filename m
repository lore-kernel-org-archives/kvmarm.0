Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCACC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:00:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB6B8407ED;
	Mon, 14 Feb 2022 02:00:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nxKVIW8eiZi7; Mon, 14 Feb 2022 01:59:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB335408A7;
	Mon, 14 Feb 2022 01:59:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7C1408A7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VvsVJd2hUR8u for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 01:59:56 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8B30407ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:56 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 v14-20020a170902e8ce00b0014b48e8e498so5781753plg.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 22:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=03TUyFaPg0/Gjl+vQfTSvgoxQ+5uxs9Hi6MR9A6wLJ8=;
 b=KcLvYfrEmbcbn9/knN5ogFzworOFEeVL5ZK8AZWWTFU0yGrQ6hL5mDfGOL7otoY7DR
 MyXrJDy49UxK0NIylHzK5Kb2vY5ZA3xGz37wsQNkJTS8gxji/7yEkk7ZAj6jvZCtspx8
 MdP3LyyAIa4guOEcXFwmjfL55hNOw3+XlP66BJuic56ao47fmmNw8vZtsWUpmU0kdsAz
 QiuI4vQKwMgyMdez4e0eoBFAWk5ZE58xz9J0/ZqFIYYdwrRbzcYtVJDPR5cHipUfImVa
 1KH0lY3Hlg2gzWwhjWzN3a1U1mJ/R4Am9ZBJ6ItMl/BtBeQ6A5e//6G8Y//FT3r6R1AF
 259A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=03TUyFaPg0/Gjl+vQfTSvgoxQ+5uxs9Hi6MR9A6wLJ8=;
 b=Q85fNwXXKv8e9ptJOuMwWOEO2tMy5cXnWImghK96y7/WpXQ0GE4SMV3iED+FByc7lG
 b9rgqASVPlb2QwLjEZ7KEuKh0adRpDm4ZTrQG4jTEah0Ewij9jCnJH1WSIVh997wF5yr
 6j4pGZufuXN0rzO49wo3sYQqVlFgzHTCqhm9k+hsmrOV/9KMWcvHG+RHQKlaEeE8r21n
 arPHO/bgu0Z9lQWZz3OrbGkpjwIFF1UmX/ChQpWjS2nNS/xhDJdA/IIsuMUepcPIVHN3
 khNOjzFInY/kDNmh9i9felqVPdeDUtHuiqA3VWD8B51ehdOGBiwmq+HSHVC627vMY/BA
 n6bA==
X-Gm-Message-State: AOAM532Ip9zp7W98yMqRKS9glA4YZHQEXO/EkiJM0JRmGmfBQKSJb7PY
 kBHqH6ea2gm/weceggg+SKiEr9NizZg=
X-Google-Smtp-Source: ABdhPJy+Udb+Z+ZE+Rw3PccqevtrcStNlD43OiYvy5Bfz0Nf6G3t2aLz7nIFNg+rtbp1DbKZPXtNfE5VWfk=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:2441:: with SMTP id
 l1mr12577060pls.142.1644821995705; Sun, 13 Feb 2022 22:59:55 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:29 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-11-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 10/27] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support
 for the guest
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
expose the value for the guest as it is.  Since KVM doesn't support
IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
expose 0x0 (PMU is not implemented) instead.

Change cpuid_feature_cap_perfmon_field() to update the field value
to 0x0 when it is 0xf.

Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a9edf1ca7dcb..375c9cd0123c 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
 
 	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
 	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
-		val = 0;
+		return (features & ~mask);
 
 	if (val > cap) {
 		features &= ~mask;
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
