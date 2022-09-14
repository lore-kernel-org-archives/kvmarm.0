Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D106AECAAD3
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 08:36:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F2F34BB72;
	Wed, 14 Sep 2022 04:36:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WRzIp4oEhh-S; Wed, 14 Sep 2022 04:36:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EE9D4BC59;
	Wed, 14 Sep 2022 04:36:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB784BC4C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1-H90+JTklaJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 04:36:32 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D97C64BC91
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:32 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 01FF0B8168D;
 Wed, 14 Sep 2022 08:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C97C433D7;
 Wed, 14 Sep 2022 08:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663144590;
 bh=nabgJXIV5TCp67knXjzIafDEUmrxwmyp5lgXbjeYsoY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=BwGpsQIvXIaeqxGaEkCBcSLb4v5uClChYPe4/xrdni5T7IvhEWhFIsJGg2uWI9EY3
 Dl8olJqZj8iNC4C4y8k0mCdn61+zqZnf2/SweHQTYieLDhWhR3U1wHHqU5FaG7whpP
 gG2jgoJ/RJv/qrnU0c7n6XkV/wamvKHDLIZdw1N+yBogyDcIO3vW+8xp+XVqi3ggPa
 1/FXgsXlLURhZgrIFMVEGMJkWLj89JwuNd7FvfTYLXXkZUR6mdcmRInbi5IUViLZuZ
 BVNBrY0S13M7AtNf8xqpMbWiIJuXF07OOf5FPIljurWSGQ6rsMMFP6NiGD3mexmhZe
 Ez5UsxTUafc4w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 23/25] KVM: arm64: Explicitly map 'kvm_vgic_global_state'
 at EL2
Date: Wed, 14 Sep 2022 09:34:58 +0100
Message-Id: <20220914083500.5118-24-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
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

From: Quentin Perret <qperret@google.com>

The pkvm hypervisor at EL2 may need to read the 'kvm_vgic_global_state'
variable from the host, for example when saving and restoring the state
of the virtual GIC.

Explicitly map 'kvm_vgic_global_state' in the stage-1 page-table of the
pKVM hypervisor rather than relying on mapping all of the host '.rodata'
section.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 0f69c1393416..5a371ab236db 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -161,6 +161,11 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
+	ret = pkvm_create_mappings(&kvm_vgic_global_state,
+				   &kvm_vgic_global_state + 1, prot);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
