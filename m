Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6D4C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 16:37:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1231360E74
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 16:37:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1231360E74
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9049B4B207;
	Mon, 18 Oct 2021 12:37:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ptISY9wIxvxB; Mon, 18 Oct 2021 12:37:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69D8D4B22C;
	Mon, 18 Oct 2021 12:37:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D5C44B207
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 12:37:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EzPQEp05GjRN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 12:37:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2248E4B203
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 12:37:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 02E8260E0C;
 Mon, 18 Oct 2021 16:37:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mcVdM-0001We-Pq; Mon, 18 Oct 2021 17:37:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: Re: [PATCH v9 00/22] KVM: arm64: Fixed features for protected VMs
Date: Mon, 18 Oct 2021 17:37:02 +0100
Message-Id: <163457498602.1692816.17093273443605618000.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alexandru.elisei@arm.com,
 qperret@google.com, mark.rutland@arm.com, tabba@google.com,
 pbonzini@redhat.com, will@kernel.org, suzuki.poulose@arm.com,
 oupton@google.com, james.morse@arm.com, drjones@redhat.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, pbonzini@redhat.com, will@kernel.org
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

On Wed, 13 Oct 2021 13:03:35 +0100, Marc Zyngier wrote:
> This is an update on Fuad's series[1].
> 
> Instead of going going back and forth over a series that has seen a
> fair few versions, I've opted for simply writing a set of fixes on
> top, hopefully greatly simplifying the handling of most registers, and
> moving things around to suit my own taste (just because I can).
> 
> [...]

Applied to next, thanks!

[12/22] KVM: arm64: Fix early exit ptrauth handling
        commit: 8a049862c38f0c78b0e01ab5d36db1bffc832675
[13/22] KVM: arm64: pkvm: Use a single function to expose all id-regs
        commit: ce75916749b8cb5ec795f1157a5c426f6765a48c
[14/22] KVM: arm64: pkvm: Make the ERR/ERX*_EL1 registers RAZ/WI
        commit: 8ffb41888334c1247bd9b4d6ff6c092a90e8d0b8
[15/22] KVM: arm64: pkvm: Drop AArch32-specific registers
        commit: 3c90cb15e2e66bcc526d25133747b2af747f6cd8
[16/22] KVM: arm64: pkvm: Drop sysregs that should never be routed to the host
        commit: f3d5ccabab20c1be5838831f460f320a12e5e2c9
[17/22] KVM: arm64: pkvm: Handle GICv3 traps as required
        commit: cbca19738472be8156d854663ed724b01255c932
[18/22] KVM: arm64: pkvm: Preserve pending SError on exit from AArch32
        commit: 271b7286058da636ab6f5f47722e098ca3a0478b
[19/22] KVM: arm64: pkvm: Consolidate include files
        commit: 3061725d162cad0589b012fc6413c9dd0da8f02a
[20/22] KVM: arm64: pkvm: Move kvm_handle_pvm_restricted around
        commit: 746bdeadc53b0d58fddea6442591f5ec3eeabe7d
[21/22] KVM: arm64: pkvm: Pass vpcu instead of kvm to kvm_get_exit_handler_array()
        commit: 0c7639cc838263b6e38b3af76755d574f15cdf41
[22/22] KVM: arm64: pkvm: Give priority to standard traps over pvm handling
        commit: 07305590114af81817148d181f1eb0af294e40d6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
