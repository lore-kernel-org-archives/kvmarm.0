Return-Path: <SRS0=oQ5U=F7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B436C433DB
	for <kvmarm@archiver.kernel.org>; Sun, 27 Dec 2020 14:41:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B08C2250F
	for <kvmarm@archiver.kernel.org>; Sun, 27 Dec 2020 14:41:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B08C2250F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EA304B202;
	Sun, 27 Dec 2020 09:41:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8iR8Czyq-Xtj; Sun, 27 Dec 2020 09:41:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 017B44B1A3;
	Sun, 27 Dec 2020 09:41:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF1464B178
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Dec 2020 09:41:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eZ2pFgkT2FSA for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Dec 2020 09:41:20 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E6734B138
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Dec 2020 09:41:20 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 657F520867;
 Sun, 27 Dec 2020 14:41:19 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1ktXET-0042p5-6Q; Sun, 27 Dec 2020 14:41:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: james.morse@arm.com, julien.thierry.kdev@gmail.com,
 Alexandru Elisei <alexandru.elisei@arm.com>, suzuki.poulose@arm.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] KVM: arm64: Miscellaneous improvements
Date: Sun, 27 Dec 2020 14:41:09 +0000
Message-Id: <160908000998.17921.2757873262572473059.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201150157.223625-1-alexandru.elisei@arm.com>
References: <20201201150157.223625-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, julien.thierry.kdev@gmail.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

On Tue, 1 Dec 2020 15:01:52 +0000, Alexandru Elisei wrote:
> The documentation update in the first patch was suggested by Marc [1]. When
> I was going through the code to track down all the places error codes were
> coming from I noticed a few things that in my opinion could be improved.
> The following patches aim to do just that. I'm fine dropping them if the
> churn looks unjustified.
> 
> Tested the Documentation changes by building pdfdocs, didn't notice any
> warnings regarding api.rst.
> 
> [...]

Applied to next, thanks!

[1/5] KVM: Documentation: Add arm64 KVM_RUN error codes
      commit: 3557ae187c32203d1bb8b48ee1e2e7bdb23d98d5
[2/5] KVM: arm64: arch_timer: Remove VGIC initialization check
      commit: f16570ba47ff2b3766ebeaba6f4b80ad48cfd6a1
[3/5] KVM: arm64: Move double-checked lock to kvm_vgic_map_resources()
      commit: 1c91f06d296de4f0c27022f5ec464e047d471215
[4/5] KVM: arm64: Update comment in kvm_vgic_map_resources()
      commit: 9e5c23b9bd71d00b07720b2a8037b019d356e9df
[5/5] KVM: arm64: Remove redundant call to kvm_pmu_vcpu_reset()
      commit: 282ff80135717cc43f1e33ddd4b0cd9e760d060b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
