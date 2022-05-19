Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C343C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:47:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 523E34B48A;
	Thu, 19 May 2022 09:47:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JaD0QDmAuzlT; Thu, 19 May 2022 09:47:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B1474B478;
	Thu, 19 May 2022 09:47:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3A284B3B3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nBI49ckZcbdO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:47:01 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A8BD4B46A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:01 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 28276B824AF;
 Thu, 19 May 2022 13:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756DCC36AE5;
 Thu, 19 May 2022 13:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968018;
 bh=5F/D/YXt7t+edZebowc69LcMSXovKQAVpAUbrzWr4G8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GRqWIDIZ4YTWgSt+DR16tZq2E1Ls2DuPEl+9nvlXiOkuMl613G47YivsqPXtlNF7r
 Hoc3zHhhPWr0c6vZtsUp0i43+ZPYdo7OrNn/IYLf0AYuvMAmBuO1AI6VOfJLo4lDF2
 tdmi9SP1XL5QacOsTzXTvG/B6yDLhdCJ3dw1qC00PSNkbWbfMCmPv2PCclzh5PktDv
 Lg1N0DkrTLKWaMlg2H4Q0FHmwfQ6tmAkXDMAJuFyy/QBU5QaUoI1OndaP+gS3MCqlB
 OwjyF8M0PlwnflbwrlewxH0oaOxNp9cNZTqlrZsPLYHLG9a9I90bEgkV3jT2i0eX4x
 n59cjJsO/e/AA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 69/89] KVM: arm64: Do not update virtual timer state for
 protected VMs
Date: Thu, 19 May 2022 14:41:44 +0100
Message-Id: <20220519134204.5379-70-will@kernel.org>
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

Protected vCPUs always run with a virtual counter offset of 0, so don't
bother trying to update it from the host.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6e542e2eae32..63d06f372eb1 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -88,7 +88,9 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		if (likely(!kvm_vm_is_protected(vcpu->kvm)))
+			return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		fallthrough;
 	default:
 		return 0;
 	}
@@ -753,6 +755,9 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *tmp;
 
+	if (unlikely(kvm_vm_is_protected(vcpu->kvm)))
+		cntvoff = 0;
+
 	mutex_lock(&kvm->lock);
 	kvm_for_each_vcpu(i, tmp, kvm)
 		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
