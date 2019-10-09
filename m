Return-Path: <SRS0=o2N9=YC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1CEC47404
	for <kvmarm@archiver.kernel.org>; Wed,  9 Oct 2019 17:24:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A311521920
	for <kvmarm@archiver.kernel.org>; Wed,  9 Oct 2019 17:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SbeWUKDK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A311521920
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BE0D4A87C;
	Wed,  9 Oct 2019 13:24:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id On1XZ3r4Jiq0; Wed,  9 Oct 2019 13:24:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C42A4A8B0;
	Wed,  9 Oct 2019 13:24:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15E5C4A885
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Oct 2019 13:24:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WDXBZQ0vKVEa for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Oct 2019 13:24:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E041D4A87C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Oct 2019 13:24:21 -0400 (EDT)
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 110C2218DE;
 Wed,  9 Oct 2019 17:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1570641861;
 bh=BnNP/S94t0ycyVIws48GAEBsgOMeY35JYl69u3+93fc=;
 h=From:To:Cc:Subject:Date:From;
 b=SbeWUKDKwKqsp4Ni7++f16Zn6d/zQS8tkfkfeoMYWc8RfgjohPsV2jLfjmtbr8kLg
 sS7C/qBVtSVk9hywa/1C/kF7owDIALeYAy6NwpSDSxIVeAi4v/8qKsgxHE8kKC5gfX
 jvEluiNnT8vNbNXX6V8mDKPYCMOzW5VRIEp7qRPg=
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/21] KVM: arm/arm64: vgic: Use the appropriate
 TRACE_INCLUDE_PATH
Date: Wed,  9 Oct 2019 13:05:54 -0400
Message-Id: <20191009170615.32750-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>,
 kvmarm@lists.cs.columbia.edu, Sasha Levin <sashal@kernel.org>,
 Marc Zyngier <maz@kernel.org>
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

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit aac60f1a867773de9eb164013d89c99f3ea1f009 ]

Commit 49dfe94fe5ad ("KVM: arm/arm64: Fix TRACE_INCLUDE_PATH") fixes
TRACE_INCLUDE_PATH to the correct relative path to the define_trace.h
and explains why did the old one work.

The same fix should be applied to virt/kvm/arm/vgic/trace.h.

Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/trace.h b/virt/kvm/arm/vgic/trace.h
index 55fed77a9f739..4fd4f6db181b0 100644
--- a/virt/kvm/arm/vgic/trace.h
+++ b/virt/kvm/arm/vgic/trace.h
@@ -30,7 +30,7 @@ TRACE_EVENT(vgic_update_irq_pending,
 #endif /* _TRACE_VGIC_H */
 
 #undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH ../../../virt/kvm/arm/vgic
+#define TRACE_INCLUDE_PATH ../../virt/kvm/arm/vgic
 #undef TRACE_INCLUDE_FILE
 #define TRACE_INCLUDE_FILE trace
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
