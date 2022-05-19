Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F03C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:46:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E81024B473;
	Thu, 19 May 2022 09:46:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KnC2vOmVJ5vF; Thu, 19 May 2022 09:46:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB6064B46E;
	Thu, 19 May 2022 09:46:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9986B4B413
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PogaxUzVfv70 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:46:47 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A12694B3B3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:47 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3945E617D1;
 Thu, 19 May 2022 13:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF2AC385B8;
 Thu, 19 May 2022 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968007;
 bh=E1015Uo5m9qQ+l/7YYTJwJcecYTkXjzWrhDPUZbkvqQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Sa8MhUqPbbEtNQoduO6nqD4n1geAIXj03Okw2MLZAGzVD/WXwb6+clOJIYjK7za3A
 ruFghhtE3LF4KCXFu2TGRDLKMaro1wB6ba+np+GNntmB80SCIhCXvfvP7PAANFTE7m
 hM0remAoSSBf/B3FkCUzY9cmJpCaDqGRhGoQss7jBh7Z0/D/zEs37i8+htwQWZK8I3
 1lXl53f3OFKaX7MutdoTvi2ugXs60KRKdsXOvCl74EIw6yNdVFbMgn2GgX/tZUiv1l
 dYkuVqY5DAui1d5BcNgkQE7kNmD5z7903UeQvOq332FxoM2WfIu3qHupCv5spkBdS4
 cxWvD4Kdli7Aw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 66/89] KVM: arm64: Donate memory to protected guests
Date: Thu, 19 May 2022 14:41:41 +0100
Message-Id: <20220519134204.5379-67-will@kernel.org>
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

From: Marc Zyngier <maz@kernel.org>

Instead of sharing memory with protected guests, which still leaves the
host with r/w access, donate the underlying pages so that they are
unmapped from the host stage-2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index c1939dd2294f..e987f34641dd 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -465,7 +465,10 @@ static void handle___pkvm_host_map_guest(struct kvm_cpu_context *host_ctxt)
 	if (ret)
 		goto out;
 
-	ret = __pkvm_host_share_guest(pfn, gfn, shadow_vcpu);
+	if (shadow_state_is_protected(shadow_state))
+		ret = __pkvm_host_donate_guest(pfn, gfn, shadow_vcpu);
+	else
+		ret = __pkvm_host_share_guest(pfn, gfn, shadow_vcpu);
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
 }
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
