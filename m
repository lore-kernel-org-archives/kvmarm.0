Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2445C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:42:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D7D54B214;
	Thu, 19 May 2022 09:42:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UkF6h41iOPjU; Thu, 19 May 2022 09:42:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 541554B357;
	Thu, 19 May 2022 09:42:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96A404B278
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oCKAJ0GzwLbA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:42:39 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EB344B33F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id DB83EB824AA;
 Thu, 19 May 2022 13:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31739C34116;
 Thu, 19 May 2022 13:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967756;
 bh=a1MY3h8a9S0aqHMlLAuerB2YDvdA2T/4rKK2cTmBIjk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=rc3H0+shhVFHwPMvinJmw9KbK6Wd7pCcy7vGlnghkhkcYdvjkbWike3yQLEVQW/Zd
 +xTv76VIhV8wzancT/VpPkQSaRc2hPgeEq+DEzIRWp1qNVZJKC2X+vguZgJsgt5K4N
 RuW1gVyHFNT5pPzS9EeXBzHZLgm+tTodQLi4iY7ykFYqazZZNg3ezntCT+VMph2EVq
 6D5ndeU/zh68orEiPXpJ68UrZmixn3sj/sk82MlJl1T7SLL78GZNXWs3X2mQMbGBKL
 ddi+x9x7ms5SyBzeyRNknIwAUS90I+I7CMPUxFTJklU8O5St8Go29zvFMWEWS0hhtV
 /MGeeBdpnzACw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 03/89] KVM: arm64: Return error from kvm_arch_init_vm() on
 allocation failure
Date: Thu, 19 May 2022 14:40:38 +0100
Message-Id: <20220519134204.5379-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

If we fail to allocate the 'supported_cpus' cpumask in kvm_arch_init_vm()
then be sure to return -ENOMEM instead of success (0) on the failure
path.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..775b52871b51 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -146,8 +146,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_free_stage2_pgd;
 
-	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
+		ret = -ENOMEM;
 		goto out_free_stage2_pgd;
+	}
 	cpumask_copy(kvm->arch.supported_cpus, cpu_possible_mask);
 
 	kvm_vgic_early_init(kvm);
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
