Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56244C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 15:23:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11DB34B149;
	Wed,  8 Dec 2021 10:23:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QdNYA6AjXn8K; Wed,  8 Dec 2021 10:23:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED4BA4B166;
	Wed,  8 Dec 2021 10:23:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 741394B165
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5VMP5kHZVfz8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 10:23:22 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9B364B16E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:21 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 145-20020a1c0197000000b0032efc3eb9bcso3207992wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 07:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uoeb8ZSnDE4o8Pfzcz/JRgpjIAPknsa+43VWqkDL6SE=;
 b=FLyX6GFGnWQE7qMZM26O1O1AIl75kaww4jWCqv4JML5oIxJznYt9gmaqoKEtOluEIA
 KivNJtKKcK5gQqfUIvhnbeRCcIGE4cfZuQ3Z1B5J5RHBhJLgW41frhBZiL+74d5zvtjQ
 YTXVsaTlKCICiUB8KMyDO8wp/JClMuGlKFewIBt3+94HtCTajeFbEV0YelIu3Iuj277W
 86JPh53Fj2k/kN6UXiqUCcD5vyQdWQhbDDtxGqMl6se8ENYkODZ7oT+K2FS4TsPAAsCZ
 Dcqr8eXGeTQyX4059KSQKZm1fFeKlvhLHrQgxl0ZG1j46Mv7NoPJjwwGbd0clsKGfsfc
 ufJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uoeb8ZSnDE4o8Pfzcz/JRgpjIAPknsa+43VWqkDL6SE=;
 b=vOHB06HM6G06iFDOtLzeX2VeI9GZcMjQ7f5eNw6sQEnvMTcA25K31XilsiFpZ0zjK6
 YY7riq14ayftG0VrTQCX7WmQmjntc27eVkUuVWuTLRyoVmHgWgExvI1wVgsZOYE/i/wB
 +gB6RvBB0pNAWSWxhDLnLnqwyD2ThqSflSc5Q7HSbCHLOEPnBU7JKNRZUpY2+nKbLhZ8
 wNWqg1zAs1oO76gE0+FudCWBtiX42XscogAD9aEG9D+6elxkt2k5mRDVEDu1p/PpcWCf
 M5dKA8W5a1mGOujZPKC0no8fqu8APr4Cosvk1Aihu14XdazESRxQZDDGEuEhGNUKvpRH
 On8Q==
X-Gm-Message-State: AOAM531Or6E9TB4eAjC6F6Rm4DYiP2ujE0IMJHnpfQ4rYCzs4yqdgACf
 O8+9PCHT4UkGaR+yaYmDcReKGBmXgueH
X-Google-Smtp-Source: ABdhPJzw6DIyY3LwITNb68nDRIYXL5b0dyrc0mUWTC50VbADX2UnqIrRkM3tCHlIcHHhMLL5CQqyW4AukkHv
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:c718:14b8:982a:57d5])
 (user=qperret job=sendgmr) by 2002:a7b:cc94:: with SMTP id
 p20mr16347652wma.162.1638977000902; Wed, 08 Dec 2021 07:23:20 -0800 (PST)
Date: Wed,  8 Dec 2021 15:22:59 +0000
In-Reply-To: <20211208152300.2478542-1-qperret@google.com>
Message-Id: <20211208152300.2478542-7-qperret@google.com>
Mime-Version: 1.0
References: <20211208152300.2478542-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 6/6] KVM: arm64: pkvm: Make kvm_host_owns_hyp_mappings()
 robust to VHE
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

The kvm_host_owns_hyp_mappings() function should return true if and only
if the host kernel is responsible for creating the hypervisor stage-1
mappings. That is only possible in standard non-VHE mode, or during boot
in protected nVHE mode. But either way, non of this makes sense in VHE,
so make sure to catch this case as well, hence making the function
return sensible values in any context (VHE or not).

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 605c104eb030..ea840fa223b5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -239,6 +239,9 @@ void free_hyp_pgds(void)
 
 static bool kvm_host_owns_hyp_mappings(void)
 {
+	if (is_kernel_in_hyp_mode())
+		return false;
+
 	if (static_branch_likely(&kvm_protected_mode_initialized))
 		return false;
 
-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
