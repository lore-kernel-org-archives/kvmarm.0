Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB78C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 14:28:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C564B219;
	Fri,  1 Apr 2022 10:28:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a6soksbOdlbG; Fri,  1 Apr 2022 10:28:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BE9B4A10E;
	Fri,  1 Apr 2022 10:28:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9635F4B120
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:28:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ES1pMaVX6RLF for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 10:28:37 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 685A84B134
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:28:37 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 83394B82502;
 Fri,  1 Apr 2022 14:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F062C340EE;
 Fri,  1 Apr 2022 14:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1648823315;
 bh=++ZMjef2Bu+3ZlLA/4YbvSkJqgM7tr0bCiofyxAxu8Y=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=jp0m5nTO1U+2u9ZJ07IAEPjWzh3wjvqNZ0nFwqZuJOKUiNbgMZV/xQkFApUZJN3Jy
 4Fogs7FX0sR8e5O2rvw/rMjGgbXskJwa3hWhY80ETpz97BxO7r7Yl2jkWQ7t0eZf9t
 5vs6AnLAgQaC0ZgtZaF+lqB7OiH2CnbvOolL2h4Ek7gEvJLLEB/+5pfCvpyhLnV13k
 nm6EMsPtDP3ccKczTvMFIVPtmWDgf0bXTUYPLhTHTODVVQQNRRGUKUPEm7c2FmZpuF
 MwwndBcPm5nJhtdavdPERFEoaCzNavcMZiWDSdJ+N3sO9enGbt8FNtqge4ioY2WenG
 j0gaMtPXUh1Tg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 054/149] kvm: selftests: aarch64: fix the failure
 check in kvm_set_gsi_routing_irqchip_check
Date: Fri,  1 Apr 2022 10:24:01 -0400
Message-Id: <20220401142536.1948161-54-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kselftest@vger.kernel.org,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
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

From: Ricardo Koller <ricarkol@google.com>

[ Upstream commit 5b7898648f02083012900e48d063e51ccbdad165 ]

kvm_set_gsi_routing_irqchip_check(expect_failure=true) is used to check
the error code returned by the kernel when trying to setup an invalid
gsi routing table. The ioctl fails if "pin >= KVM_IRQCHIP_NUM_PINS", so
kvm_set_gsi_routing_irqchip_check() should test the error only when
"intid >= KVM_IRQCHIP_NUM_PINS+32". The issue is that the test check is
"intid >= KVM_IRQCHIP_NUM_PINS", so for a case like "intid =
KVM_IRQCHIP_NUM_PINS" the test wrongly assumes that the kernel will
return an error.  Fix this by using the right check.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127030858.3269036-4-ricarkol@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 7f3afee5cc00..48e43e24d240 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -573,8 +573,8 @@ static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
 		kvm_gsi_routing_write(vm, routing);
 	} else {
 		ret = _kvm_gsi_routing_write(vm, routing);
-		/* The kernel only checks for KVM_IRQCHIP_NUM_PINS. */
-		if (intid >= KVM_IRQCHIP_NUM_PINS)
+		/* The kernel only checks e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS */
+		if (((uint64_t)intid + num - 1 - MIN_SPI) >= KVM_IRQCHIP_NUM_PINS)
 			TEST_ASSERT(ret != 0 && errno == EINVAL,
 				"Bad intid %u did not cause KVM_SET_GSI_ROUTING "
 				"error: rc: %i errno: %i", intid, ret, errno);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
