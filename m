Return-Path: <SRS0=tvNx=YR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D347CA9EBB
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 12:25:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2EAA421925
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 12:25:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EAA421925
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2024A953;
	Thu, 24 Oct 2019 08:25:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xZyfkJSGl8Hu; Thu, 24 Oct 2019 08:25:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F6194A8A1;
	Thu, 24 Oct 2019 08:25:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07B164A65C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 06:27:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4j7vBD6jC5Jn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 06:27:50 -0400 (EDT)
Received: from out30-133.freemail.mail.aliyun.com
 (out30-133.freemail.mail.aliyun.com [115.124.30.133])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8B3B4A5D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 06:27:49 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R451e4; CH=green; DM=||false|;
 FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e07417; MF=shannon.zhao@linux.alibaba.com;
 NM=1; PH=DS; RN=8; SR=0; TI=SMTPD_---0Tg32PEs_1571912865; 
Received: from localhost(mailfrom:shannon.zhao@linux.alibaba.com
 fp:SMTPD_---0Tg32PEs_1571912865) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 24 Oct 2019 18:27:46 +0800
From: Shannon Zhao <shannon.zhao@linux.alibaba.com>
To: kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, christoffer.dall@arm.com
Subject: [PATCH RFC 2/7] KVM: arch_timer: Fix resource leak on error path
Date: Thu, 24 Oct 2019 18:27:45 +0800
Message-Id: <1571912870-18471-3-git-send-email-shannon.zhao@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571912870-18471-1-git-send-email-shannon.zhao@linux.alibaba.com>
References: <1571912870-18471-1-git-send-email-shannon.zhao@linux.alibaba.com>
X-Mailman-Approved-At: Thu, 24 Oct 2019 08:25:09 -0400
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

It needs to cleanup irq setup for host_vtimer_irq when
request_percpu_irq fails for host_ptimer_irq. It needs to cleanup irq
setup for both host_vtimer_irq and host_ptimer_irq when seeting vcpu
affinity error as well.

Fixes: 9e01dc76be6a ("KVM: arm/arm64: arch_timer: Assign the phys timer on VHE systems")
Signed-off-by: Shannon Zhao <shannon.zhao@linux.alibaba.com>
---
 virt/kvm/arm/arch_timer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index e2bb5bd..f5a5d51 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -960,7 +960,7 @@ int kvm_timer_hyp_init(bool has_gic)
 		if (err) {
 			kvm_err("kvm_arch_timer: can't request ptimer interrupt %d (%d)\n",
 				host_ptimer_irq, err);
-			return err;
+			goto out_free_irq;
 		}
 
 		if (has_gic) {
@@ -968,7 +968,7 @@ int kvm_timer_hyp_init(bool has_gic)
 						    kvm_get_running_vcpus());
 			if (err) {
 				kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
-				goto out_free_irq;
+				goto out_free_pirq;
 			}
 		}
 
@@ -984,6 +984,8 @@ int kvm_timer_hyp_init(bool has_gic)
 			  "kvm/arm/timer:starting", kvm_timer_starting_cpu,
 			  kvm_timer_dying_cpu);
 	return 0;
+out_free_pirq:
+	free_percpu_irq(host_ptimer_irq, kvm_get_running_vcpus());
 out_free_irq:
 	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
 	return err;
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
