Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F6DC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 16 Dec 2021 10:45:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 258BB4B106;
	Thu, 16 Dec 2021 05:45:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xzeeBfHbFz7j; Thu, 16 Dec 2021 05:45:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 037674B1FB;
	Thu, 16 Dec 2021 05:45:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C53A74B106
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 05:45:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B4hT9ZSa8Zrd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Dec 2021 05:45:31 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF3704025B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 05:45:31 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 6F80861D27;
 Thu, 16 Dec 2021 10:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6499C36AE2;
 Thu, 16 Dec 2021 10:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639651530;
 bh=lsuTIb4QAadkxB8JMSkIQ9kqbNzDrbIGstkl5NzJwos=;
 h=From:To:Cc:Subject:Date:From;
 b=B0qqq+k/zpavypznn4lXvo8eWd3jIvRsOq1wLuNkkcKE2eCwmxsykIfqoV6UB6glQ
 fXov3G3Bbiw7lvoqb0D1L1QXsoFqcVESCGRd1QmYpkqvm58c4iIwzNM0wA2FZ2BRiB
 Py9/ydqN86OSU6WumHXwmiVsxQdqzKfYwPiP4/tIB1uRQKtqLnFn8Vb8iYwkcngok0
 rKUA/g3Gg3H9Y58ZLkxEjrUl1gnnxmmImBznoZO3anypRsLrFwQjLGePJ0UeyUfQtH
 +T3JOg35lDnxAUlipIfz1KubrL5vRZRXGar7zxdFLdzhKAZNa/uBql/AyL0KnV+NnX
 7QNz4dQsP6jSw==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mxoGO-00CUtK-TR; Thu, 16 Dec 2021 10:45:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: vgic-v3: Fix vcpu index comparison
Date: Thu, 16 Dec 2021 10:45:26 +0000
Message-Id: <20211216104526.1482124-1-maz@kernel.org>
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

When handling an error at the point where we try and register
all the redistributors, we unregister all the previously
registered frames by counting down from the failing index.

However, the way the code is written relies on that index
being a signed value. Which won't be true once we switch to
an xarray-based vcpu set.

Since this code is pretty awkward the first place, and that the
failure mode is hard to spot, rewrite this loop to iterate
over the vcpus upwards rather than downwards.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index bf7ec4a78497..9943a3fe1b0a 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -763,10 +763,12 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 	}
 
 	if (ret) {
-		/* The current c failed, so we start with the previous one. */
+		/* The current c failed, so iterate over the previous ones. */
+		int i;
+
 		mutex_lock(&kvm->slots_lock);
-		for (c--; c >= 0; c--) {
-			vcpu = kvm_get_vcpu(kvm, c);
+		for (i = 0; i < c; i++) {
+			vcpu = kvm_get_vcpu(kvm, i);
 			vgic_unregister_redist_iodev(vcpu);
 		}
 		mutex_unlock(&kvm->slots_lock);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
