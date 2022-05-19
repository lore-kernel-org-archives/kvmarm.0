Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B4FC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:45:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D7E04B42A;
	Thu, 19 May 2022 09:45:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bRgV3+GZSNsl; Thu, 19 May 2022 09:45:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 226124B421;
	Thu, 19 May 2022 09:45:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A144B415
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id orEdZTLMtOQL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:45:38 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0D214B42C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:37 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E14BEB8235B;
 Thu, 19 May 2022 13:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFBBC34100;
 Thu, 19 May 2022 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967935;
 bh=01scSGwFMX4UX/Fyks9TF9FRUQgO1lQ2Yumv8GkNuXU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hsLv2QBDVEbJnkW9C6SNDZaSlM95bEV9jgWjWDC33tevmIDYfvPlgWQfBf2C29IE8
 PdrjeP1VGHB94FH6y35YbmYNC/i9JVfbJB+emajAZaoIzi95LKLCU+SwTbGWkUrS/p
 MoXyjdHnNQ6HAi/FTI8f+/qIX20stHS87CALlgAbqEbPAPGNrJkMgrFuPNFYLtm2n+
 rtC2wyfGHOJAFkgmrNzzWMiFXrTFkfPagj2sTYvDldt1HDi1Q1syEqX2xr8AcRuLV3
 wNRwecTcQNVScVjsq0sxNu66dlU02HnZfRA81vGhPJokr0hhQmWejRAF31YI9aeRzf
 q4kTZXgcig5Hw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 48/89] KVM: arm64: Skip __kvm_adjust_pc() for protected vcpus
Date: Thu, 19 May 2022 14:41:23 +0100
Message-Id: <20220519134204.5379-49-will@kernel.org>
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

Prevent the host from issuing arbitrary PC adjustments for protected
vCPUs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 40cbf45800b7..86dff0dc05f3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -275,9 +275,22 @@ static void handle___pkvm_host_map_guest(struct kvm_cpu_context *host_ctxt)
 
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *vcpu;
+
+	vcpu = get_current_vcpu(host_ctxt, 1, &shadow_state);
+	if (!vcpu)
+		return;
+
+	if (shadow_state) {
+		/* This only applies to non-protected VMs */
+		if (shadow_state_is_protected(shadow_state))
+			return;
+
+		vcpu = &shadow_state->shadow_vcpu;
+	}
 
-	__kvm_adjust_pc(kern_hyp_va(vcpu));
+	__kvm_adjust_pc(vcpu);
 }
 
 static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
