Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225DAC64E7C
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 16:33:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 933842220B
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 16:33:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 933842220B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA3F14B92A;
	Thu, 26 Nov 2020 11:33:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XG+0zE3RT5x0; Thu, 26 Nov 2020 11:33:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B05384B791;
	Thu, 26 Nov 2020 11:33:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07AD34B70A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 11:33:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U+GDFtwh+T-6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 11:33:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4AF84B6D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 11:33:52 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59A5731B;
 Thu, 26 Nov 2020 08:33:52 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F6243F23F;
 Thu, 26 Nov 2020 08:33:51 -0800 (PST)
Subject: Re: [PATCH 0/8] KVM: arm64: Disabled PMU handling
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20201113182602.471776-1-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d5d09a86-41bc-1085-9394-09cfcecef9d9@arm.com>
Date: Thu, 26 Nov 2020 16:34:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113182602.471776-1-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com
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

Hi Marc,

On 11/13/20 6:25 PM, Marc Zyngier wrote:
> It recently dawned on me that the way we handle PMU traps when the PMU
> is disabled is plain wrong. We consider that handling the registers as
> RAZ/WI is a fine thing to do, while the ARMv8 ARM is pretty clear that
> that's not OK and that such registers should UNDEF when FEAT_PMUv3
> doesn't exist. I went all the way back to the first public version of
> the spec, and it turns out we were *always* wrong.
>
> It probably comes from the fact that we used not to trap the ID
> registers, and thus were unable to advertise the lack of PMU, but
> that's hardly an excuse. So let's fix the damned thing.
>
> This series adds an extra check in the helpers that check for the
> validity of the PMU access (most of the registers have to checked
> against some enable flags and/or the accessing exception level), and
> rids us of the RAZ/WI behaviour.
>
> This enables us to make additional cleanups, to the point where we can
> remove the PMU "ready" state that always had very bizarre semantics.
> All in all, a negative diffstat, and spec compliant behaviours. What's
> not to like?
>
> I've run a few guests with and without PMUs as well as KUT, and
> nothing caught fire. The patches are on top of kvmarm/queue.
Everything looks fine to me. You can add my Reviewed-by tag the patches I haven't
commented on separately.

Thanks,

Alex

>
> Marc Zyngier (8):
>   KVM: arm64: Add kvm_vcpu_has_pmu() helper
>   KVM: arm64: Set ID_AA64DFR0_EL1.PMUVer to 0 when no PMU support
>   KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at reset time
>   KVM: arm64: Inject UNDEF on PMU access when no PMU configured
>   KVM: arm64: Remove PMU RAZ/WI handling
>   KVM: arm64: Remove dead PMU sysreg decoding code
>   KVM: arm64: Gate kvm_pmu_update_state() on the PMU feature
>   KVM: arm64: Get rid of the PMU ready state
>
>  arch/arm64/include/asm/kvm_host.h |  3 ++
>  arch/arm64/kvm/pmu-emul.c         | 11 +++----
>  arch/arm64/kvm/reset.c            |  4 +++
>  arch/arm64/kvm/sys_regs.c         | 51 ++++++++-----------------------
>  include/kvm/arm_pmu.h             |  3 --
>  5 files changed, 24 insertions(+), 48 deletions(-)
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
