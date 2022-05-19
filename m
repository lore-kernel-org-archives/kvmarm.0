Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BE0C4321E
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:46:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B8BC4B439;
	Thu, 19 May 2022 09:46:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tOaEdFDI2FBo; Thu, 19 May 2022 09:46:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A86B4B442;
	Thu, 19 May 2022 09:46:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D1D54B3D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GUhHunOwtp4U for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:46:09 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00AE04B424
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:09 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 52119617D2;
 Thu, 19 May 2022 13:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EEEC34100;
 Thu, 19 May 2022 13:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967967;
 bh=88e6OVrkJmSynl9ligIzRQd0lQ3ObHpfzQ+vy+gTKaY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=t7nbdcmc4S6MeEqTouC0TJGSjgHdW6wM8e+t4Ayg3eXGeT1aMD9Ua735ag0u7sU8S
 YsBa1mPe7z0pQjA/OrcAhieua+PTI+PrEldWuBdNdjy/ph5zumy/zOAd8RlGIPqYIX
 l8l4m4GyY2TYHO8fYCuWB3PW2qDyjcEC4H5RfeGH3f1LgasLCBpiTQaj29TV1p6OUX
 bKBoePq8DFe5DGLMnmq69HWYIPG7iKFeMRloyEtACj0Vswhd1CEsZWqFSf72uBSARc
 yGDbR35gjObq9re4epZynBw2hdicIHeriQLgGzsm0738+ONoiyCopDkYYADf2iMR2Y
 hV34CciKw9KqQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 56/89] KVM: arm64: Check directly whether the vcpu is protected
Date: Thu, 19 May 2022 14:41:31 +0100
Message-Id: <20220519134204.5379-57-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Simpler code and ensures we're always looking at hyp state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 9d2b971e8613..6bb979ee51cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -215,7 +215,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(kvm_vm_is_protected(kern_hyp_va(vcpu->kvm))))
+	if (unlikely(vcpu_is_protected(vcpu)))
 		return pvm_exit_handlers;
 
 	return hyp_exit_handlers;
@@ -234,9 +234,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
  */
 static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-
-	if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu)) {
+	if (unlikely(vcpu_is_protected(vcpu) && vcpu_mode_is_32bit(vcpu))) {
 		/*
 		 * As we have caught the guest red-handed, decide that it isn't
 		 * fit for purpose anymore by making the vcpu invalid. The VMM
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
