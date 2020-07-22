Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB1AC433E4
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:24:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93FDB2065F
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:24:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93FDB2065F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D5424B2C0;
	Wed, 22 Jul 2020 12:24:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iIIDS8k0zcDW; Wed, 22 Jul 2020 12:24:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32E674B2AF;
	Wed, 22 Jul 2020 12:24:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 689324B2AF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:24:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dd5yRu4xQWkg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:24:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CE1B4B2BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:24:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C68CD6E;
 Wed, 22 Jul 2020 09:24:33 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE12F3F66E;
 Wed, 22 Jul 2020 09:24:32 -0700 (PDT)
Date: Wed, 22 Jul 2020 17:24:30 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v2 0/4] Manage vcpu flags from the host
Message-ID: <20200722162429.GP30452@arm.com>
References: <20200713210505.2959828-1-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200713210505.2959828-1-ascull@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: maz@kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jul 13, 2020 at 10:05:01PM +0100, Andrew Scull wrote:
> The aim is to keep management of the flags in the host and out of hyp
> where possible. I find this makes it easier to understand how the flags
> are used as the responsibilities are clearly divided.
> 
> The series applies on top of kvmarm/next after VHE and nVHE have been
> separated.

(A commit ID would be useful for someone trying to the patches.)

> From v1 <20200710095754.3641976-1-ascull@google.com>:

(Nit: Is there some easy way of looking up mails by Message-ID?

Otherwise, it can be helpful to have a mail archive URL here, e.g.,
lore.kernel.org)

>  - Split FP change into smaller patches
>  - Addressed Dave's other comments
> 
> Andrew Scull (4):
>   KVM: arm64: Leave KVM_ARM64_DEBUG_DIRTY updates to the host
>   KVM: arm64: Predicate FPSIMD vcpu flags on feature support
>   KVM: arm64: Leave vcpu FPSIMD synchronization in host
>   KVM: arm64: Stop mapping host task thread flags to hyp
> 
>  arch/arm64/include/asm/kvm_host.h         |  7 ++-
>  arch/arm64/kvm/arm.c                      |  4 +-
>  arch/arm64/kvm/debug.c                    |  2 +
>  arch/arm64/kvm/fpsimd.c                   | 54 ++++++++++++++++-------
>  arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  2 -
>  arch/arm64/kvm/hyp/include/hyp/switch.h   | 19 --------
>  arch/arm64/kvm/hyp/nvhe/switch.c          |  3 +-
>  arch/arm64/kvm/hyp/vhe/switch.c           |  3 +-
>  8 files changed, 48 insertions(+), 46 deletions(-)
> 
> -- 
> 2.27.0.383.g050319c2ae-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
