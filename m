Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED357C43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 02:02:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F805221EC
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 02:02:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZ+KVvmK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F805221EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F3B4B3E6;
	Thu, 17 Sep 2020 22:02:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8zpPmJXoGKjc; Thu, 17 Sep 2020 22:02:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE78D4B3AB;
	Thu, 17 Sep 2020 22:02:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7160B4B3A9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 22:02:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zlUoh99mHlMR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 22:02:42 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A6F44B325
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 22:02:42 -0400 (EDT)
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net
 [73.47.72.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 70E8923447;
 Fri, 18 Sep 2020 02:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600394561;
 bh=aq1/5r2rp+WYg/sjQ6/chbTXBc+6EZ0FkQdPv+m7yps=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=OZ+KVvmKA9ceJqYM3lDLF1jhOSD9voeQJAwn8805WOZ0GekFdFOxRrFfBfRaD5SLA
 ODN1lm+RwtxoEGhoTKtVHUsTGpkwlB4W2JfngPF1lt/+PG2JkkcFhXtl9vYRGYhB8A
 /RpqbTTRTvJ1hSmKJjMswzff+oYhKAII5noa/X4A=
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 074/330] KVM: arm/arm64: vgic: Fix potential
 double free dist->spis in __kvm_vgic_destroy()
Date: Thu, 17 Sep 2020 21:56:54 -0400
Message-Id: <20200918020110.2063155-74-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Miaohe Lin <linmiaohe@huawei.com>, Sasha Levin <sashal@kernel.org>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 0bda9498dd45280e334bfe88b815ebf519602cc3 ]

In kvm_vgic_dist_init() called from kvm_vgic_map_resources(), if
dist->vgic_model is invalid, dist->spis will be freed without set
dist->spis = NULL. And in vgicv2 resources clean up path,
__kvm_vgic_destroy() will be called to free allocated resources.
And dist->spis will be freed again in clean up chain because we
forget to set dist->spis = NULL in kvm_vgic_dist_init() failed
path. So double free would happen.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/1574923128-19956-1-git-send-email-linmiaohe@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 6f50c429196de..6d85c6d894c39 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -177,6 +177,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 			break;
 		default:
 			kfree(dist->spis);
+			dist->spis = NULL;
 			return -EINVAL;
 		}
 	}
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
