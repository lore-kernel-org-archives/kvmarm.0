Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71523C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 16 Dec 2021 10:45:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D84D74B1FC;
	Thu, 16 Dec 2021 05:45:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XwAYGAlRiUnw; Thu, 16 Dec 2021 05:45:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D39334B1FD;
	Thu, 16 Dec 2021 05:45:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E12C24B1FB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 05:45:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WIFDIN9qYpVc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Dec 2021 05:45:13 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1BD84B1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 05:45:13 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id ADE4661D29;
 Thu, 16 Dec 2021 10:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCFCC36AE2;
 Thu, 16 Dec 2021 10:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639651512;
 bh=k0sivyjWD6szjwF7EGZwTgDdQ7orNpZ4z/eWXEe5lP4=;
 h=From:To:Cc:Subject:Date:From;
 b=d/RWKPI8UWWAp5WprshmvvrNmHGQsazv9wZDjUQydw4QCzWknLcdlyr+klXfvyhdz
 v+Isb31JYbR2RAhcFLkRNU2ydhKduXWVGMshNlP9Lpwtw5cASQBs4cKPUebubLHVgi
 Ng8afvuGuYgziZmm00YN0xnbblzxhYWumw5GML6xhD5Pz+D80HmHzNCBmHtQnB2hPR
 Bvb7KDdulgett2y0/CMIefxQTMSPpPhz0gRODa5YGywfVtYzcBVVcmBen+rC759Ha/
 i7cX73n9e9TsOKWCkQ2VLGS5u8pwvgBc1az+zdTxUogfwc+QdL0l/WCP6tfkLFwskZ
 TMTwsoHo60Xyg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mxoG6-00CUsg-7H; Thu, 16 Dec 2021 10:45:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: vgic: Demote userspace-triggered console prints
 to kvm_debug()
Date: Thu, 16 Dec 2021 10:45:07 +0000
Message-Id: <20211216104507.1482017-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

Running the KVM selftests results in these messages being dumped
in the kernel console:

[  188.051073] kvm [469]: VGIC redist and dist frames overlap
[  188.056820] kvm [469]: VGIC redist and dist frames overlap
[  188.076199] kvm [469]: VGIC redist and dist frames overlap

Being amle to trigger this from userspace is definitely not on,
so demote these warnings to kvm_debug().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 4 ++--
 arch/arm64/kvm/vgic/vgic-v3.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 95a18cec14a3..280a708631cd 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -293,12 +293,12 @@ int vgic_v2_map_resources(struct kvm *kvm)
 
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
 	    IS_VGIC_ADDR_UNDEF(dist->vgic_cpu_base)) {
-		kvm_err("Need to set vgic cpu and dist addresses first\n");
+		kvm_debug("Need to set vgic cpu and dist addresses first\n");
 		return -ENXIO;
 	}
 
 	if (!vgic_v2_check_base(dist->vgic_dist_base, dist->vgic_cpu_base)) {
-		kvm_err("VGIC CPU and dist frames overlap\n");
+		kvm_debug("VGIC CPU and dist frames overlap\n");
 		return -EINVAL;
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 04f62c4b07fb..97ab7c02e189 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -554,12 +554,12 @@ int vgic_v3_map_resources(struct kvm *kvm)
 	}
 
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base)) {
-		kvm_err("Need to set vgic distributor addresses first\n");
+		kvm_debug("Need to set vgic distributor addresses first\n");
 		return -ENXIO;
 	}
 
 	if (!vgic_v3_check_base(kvm)) {
-		kvm_err("VGIC redist and dist frames overlap\n");
+		kvm_debug("VGIC redist and dist frames overlap\n");
 		return -EINVAL;
 	}
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
