Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5669C6FA8B
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 17:02:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9824B647;
	Thu, 22 Sep 2022 13:02:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IZg+NyWcRnVT; Thu, 22 Sep 2022 13:02:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86AC14B6EE;
	Thu, 22 Sep 2022 13:02:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAD9D4B256
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 13:02:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VNw80qriYH1H for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 13:02:01 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 237F44B63F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 13:01:59 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 43B64B837E0;
 Thu, 22 Sep 2022 17:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E555CC433B5;
 Thu, 22 Sep 2022 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663866116;
 bh=CqYMGL55Zc/uSrcf2lz2TZ/3YVAgOdKluXHhKAiPBMg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=TrxUnGabe/Nwi9Qa0YZw5AZDzoXloe/cfZ5ZLxa1/+CwsXuzxf6tGDI32T0mxeaad
 X3gOzhOQ/C6ZnU1igOIkJWxCq3Ms/1CN3B87egwUeB6a0Q8tXDYDQGAsbvvigV/pbX
 ZmRz5315BHYj0mIAarW7ZBSiBqxluNsU4o1feXQ4o/c662pBoFWropTDXIuvAtQSJX
 AvfhjWPuUBEoIctIYr8b7SNG6LYG7ACLjnMb66EUS5faot3st0lU7wE/jBap1ivf2L
 TyyTtH8m5E9T2IAy1BQnnwcVKrxUBuhjqO84uss5/o8g2DvWXIisWcUjv7VINhoHDp
 IcbIQpo0lDdKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1obPaD-00Bxdo-PG;
 Thu, 22 Sep 2022 18:01:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [PATCH 3/6] KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ORDERED
Date: Thu, 22 Sep 2022 18:01:30 +0100
Message-Id: <20220922170133.2617189-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922170133.2617189-1-maz@kernel.org>
References: <20220922170133.2617189-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
 andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
 peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
 shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org
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

Since x86 is TSO (give or take), allow it to advertise the new
ORDERED version of the dirty ring capability. No other change is
required for it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index e3cbd7706136..eb63bc31ed1d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -29,6 +29,7 @@ config KVM
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_DIRTY_RING
+	select HAVE_KVM_DIRTY_RING_ORDERED
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_IRQ_ROUTING
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
