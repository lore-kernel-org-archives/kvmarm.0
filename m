Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA15C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 10:28:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57F4860ED3
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 10:28:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 57F4860ED3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05ADF4A1AF;
	Thu, 19 Aug 2021 06:28:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SLQWR1wlIYHl; Thu, 19 Aug 2021 06:28:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C856C4B092;
	Thu, 19 Aug 2021 06:28:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEF2649E57
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 06:28:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6w88KD8ervrK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 06:28:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D5CE84099E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 06:28:24 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1531B60ED3;
 Thu, 19 Aug 2021 10:28:23 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mGfHZ-005wq0-4o; Thu, 19 Aug 2021 11:28:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 0/3] KVM: arm64: Use generic guest entry infrastructure
Date: Thu, 19 Aug 2021 11:28:16 +0100
Message-Id: <162936887458.598180.10185839299725357336.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210802192809.1851010-1-oupton@google.com>
References: <20210802192809.1851010-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com,
 peterz@infradead.org, luto@kernel.org, catalin.marinas@arm.com,
 alexandru.elisei@arm.com, shakeelb@google.com,
 linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, james.morse@arm.com,
 guangyus@google.com, kvm@vger.kernel.org, suzuki.poulose@arm.com,
 linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
 pshier@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Guangyu Shi <guangyus@google.com>,
 Will Deacon <will@kernel.org>, Shakeel Butt <shakeelb@google.com>,
 Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
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

On Mon, 2 Aug 2021 19:28:06 +0000, Oliver Upton wrote:
> The arm64 kernel doesn't yet support the full generic entry
> infrastructure. That being said, KVM/arm64 doesn't properly handle
> TIF_NOTIFY_RESUME and could pick this up by switching to the generic
> guest entry infrasturture.
> 
> Patch 1 adds a missing vCPU stat to ARM64 to record the number of signal
> exits to userspace.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Record number of signal exits as a vCPU stat
      commit: fe5161d2c39b8c2801f0e786631460c6e8a1cae4
[2/3] entry: KVM: Allow use of generic KVM entry w/o full generic support
      commit: e1c6b9e1669e44fb7f9688e34e460b759e3b9187
[3/3] KVM: arm64: Use generic KVM xfer to guest work function
      commit: 6caa5812e2d126a0aa8a17816c1ba6f0a0c2b309

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
