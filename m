Return-Path: <SRS0=zxSv=L4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEA5C11F84
	for <kvmarm@archiver.kernel.org>; Sun,  4 Jul 2021 23:06:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E0D7E6195C
	for <kvmarm@archiver.kernel.org>; Sun,  4 Jul 2021 23:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0D7E6195C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B0534A126;
	Sun,  4 Jul 2021 19:05:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tkoclO1tbljw; Sun,  4 Jul 2021 19:05:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 095DC40CF8;
	Sun,  4 Jul 2021 19:05:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0C6407EF
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jul 2021 19:05:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QbXUWpZ1MtGg for <kvmarm@lists.cs.columbia.edu>;
 Sun,  4 Jul 2021 19:05:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79D5E406D3
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jul 2021 19:05:54 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9312C613E5;
 Sun,  4 Jul 2021 23:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1625439953;
 bh=k4A9U8XSbpXM50WX2bk9eqfV52wvOpVIiCKt8c8gujg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=cl1I3TZ+YCF35Hj97tff50OR/Mk/k0GPy7geJPMbSRSbDkhSz27sXrsjKV+KIHIjn
 XWf1455SC5Wy16O395mmQfArVKQ6y3kd5WIrhPgCHa1+zml2pMtIVvhXpQoKrKSpYK
 J4MZgZBLBjWaOlTvOhf/XliSYkmtjgpH7jRoHNz7FAWaDzl8N+ekkhi7LAy2ypArtT
 0wIcQG3qvs9Hsbj8Q7UVBLH4z9QBgVQE2r4gnr0XvHbo+XNE7LdKO+82bGKOcvZv8Q
 Nh8osPu9xEWL/9IBf3lbcFCSryeMBxYgL8GQ15DnTAuwhTZmCok/JMrk5KBkCVAPbF
 84xu36m3Nejfw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 68/85] KVM: arm64: Restore PMU configuration on
 first run
Date: Sun,  4 Jul 2021 19:04:03 -0400
Message-Id: <20210704230420.1488358-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jinank Jain <jinankj@amazon.de>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit d0c94c49792cf780cbfefe29f81bb8c3b73bc76b ]

Restoring a guest with an active virtual PMU results in no perf
counters being instanciated on the host side. Not quite what
you'd expect from a restore.

In order to fix this, force a writeback of PMCR_EL0 on the first
run of a vcpu (using a new request so that it happens once the
vcpu has been loaded). This will in turn create all the host-side
counters that were missing.

Reported-by: Jinank Jain <jinankj@amazon.de>
Tested-by: Jinank Jain <jinankj@amazon.de>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/87wnrbylxv.wl-maz@kernel.org
Link: https://lore.kernel.org/r/b53dfcf9bbc4db7f96154b1cd5188d72b9766358.camel@amazon.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 4 ++++
 arch/arm64/kvm/pmu-emul.c         | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cd7d5c8c4bc..6336b4309114 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -46,6 +46,7 @@
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
+#define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e720148232a0..facf4d41d32a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -689,6 +689,10 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			vgic_v4_load(vcpu);
 			preempt_enable();
 		}
+
+		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
+			kvm_pmu_handle_pmcr(vcpu,
+					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fd167d4f4215..a0bbb7111f57 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -850,6 +850,9 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		   return -EINVAL;
 	}
 
+	/* One-off reload of the PMU on first run */
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	return 0;
 }
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
