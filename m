Return-Path: <SRS0=60hl=6P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F49C47258
	for <kvmarm@archiver.kernel.org>; Fri,  1 May 2020 10:12:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8CEB02071C
	for <kvmarm@archiver.kernel.org>; Fri,  1 May 2020 10:12:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="g30UCYx5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CEB02071C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43E854B61A;
	Fri,  1 May 2020 06:12:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M+1qtmXOn7PC; Fri,  1 May 2020 06:12:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F9434B643;
	Fri,  1 May 2020 06:12:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6328B4B61A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 May 2020 06:12:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zk5Izro8Rwq0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 May 2020 06:12:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 561F94B615
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 May 2020 06:12:16 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 89C772192A;
 Fri,  1 May 2020 10:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588327935;
 bh=FWdojJjPTloAAYOA1G94z/BC4dOQr1JzzPfiDjmSZ/s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=g30UCYx5CnN7AuBqp213+FU87CU30LjAik4HXzjMnOd6cerBQdEldONUb07oKgEXp
 qk5BOZB8FtjtrZ3HGVE7+2NoYFAO2gpnFcgYQ4w56PtI7K+Fgolrb/IH/pwYwgmWkG
 nuvVsAx3LgLyFtaRZE22edXOF02HRyemXMAD0Okw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jUSeU-008J3K-08; Fri, 01 May 2020 11:12:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4/4] KVM: arm64: Fix 32bit PC wrap-around
Date: Fri,  1 May 2020 11:12:04 +0100
Message-Id: <20200501101204.364798-5-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501101204.364798-1-maz@kernel.org>
References: <20200501101204.364798-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, maskray@google.com,
 mark.rutland@arm.com, ndesaulniers@google.com, will@kernel.org,
 yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Fangrui Song <maskray@google.com>,
 Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

In the unlikely event that a 32bit vcpu traps into the hypervisor
on an instruction that is located right at the end of the 32bit
range, the emulation of that instruction is going to increment
PC past the 32bit range. This isn't great, as userspace can then
observe this value and get a bit confused.

Conversly, userspace can do things like (in the context of a 64bit
guest that is capable of 32bit EL0) setting PSTATE to AArch64-EL0,
set PC to a 64bit value, change PSTATE to AArch32-USR, and observe
that PC hasn't been truncated. More confusion.

Fix both by:
- truncating PC increments for 32bit guests
- sanitizing all 32bit regs every time a core reg is changed by
  userspace, and that PSTATE indicates a 32bit mode.

Cc: stable@vger.kernel.org
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c     | 7 +++++++
 virt/kvm/arm/hyp/aarch32.c | 8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 23ebe51410f0..50a279d3ddd7 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -200,6 +200,13 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	}
 
 	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
+
+	if (*vcpu_cpsr(vcpu) & PSR_MODE32_BIT) {
+		int i;
+
+		for (i = 0; i < 16; i++)
+			*vcpu_reg32(vcpu, i) = (u32)*vcpu_reg32(vcpu, i);
+	}
 out:
 	return err;
 }
diff --git a/virt/kvm/arm/hyp/aarch32.c b/virt/kvm/arm/hyp/aarch32.c
index d31f267961e7..25c0e47d57cb 100644
--- a/virt/kvm/arm/hyp/aarch32.c
+++ b/virt/kvm/arm/hyp/aarch32.c
@@ -125,12 +125,16 @@ static void __hyp_text kvm_adjust_itstate(struct kvm_vcpu *vcpu)
  */
 void __hyp_text kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
 {
+	u32 pc = *vcpu_pc(vcpu);
 	bool is_thumb;
 
 	is_thumb = !!(*vcpu_cpsr(vcpu) & PSR_AA32_T_BIT);
 	if (is_thumb && !is_wide_instr)
-		*vcpu_pc(vcpu) += 2;
+		pc += 2;
 	else
-		*vcpu_pc(vcpu) += 4;
+		pc += 4;
+
+	*vcpu_pc(vcpu) = pc;
+
 	kvm_adjust_itstate(vcpu);
 }
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
