Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EE2C3A5A1
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 12:21:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1EAB2089E
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 12:21:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1EAB2089E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4024A5DF;
	Thu, 22 Aug 2019 08:21:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pnYYwlWIXtRV; Thu, 22 Aug 2019 08:21:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20D3C4A5DA;
	Thu, 22 Aug 2019 08:21:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B4044A5D4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 08:21:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GojgLx2XFxNV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 08:21:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 237AB4A5CF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 08:21:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1D7C337;
 Thu, 22 Aug 2019 05:21:25 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 E78B13F706; Thu, 22 Aug 2019 05:21:24 -0700 (PDT)
Subject: Re: [PATCH v2] arm64: KVM: Only skip MMIO insn once
To: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190822110305.18035-1-drjones@redhat.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <af0737b1-ffe8-1ace-5aab-f08331b6d940@kernel.org>
Date: Thu, 22 Aug 2019 13:21:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822110305.18035-1-drjones@redhat.com>
Content-Language: en-US
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

On 22/08/2019 12:03, Andrew Jones wrote:
> If after an MMIO exit to userspace a VCPU is immediately run with an
> immediate_exit request, such as when a signal is delivered or an MMIO
> emulation completion is needed, then the VCPU completes the MMIO
> emulation and immediately returns to userspace. As the exit_reason
> does not get changed from KVM_EXIT_MMIO in these cases we have to
> be careful not to complete the MMIO emulation again, when the VCPU is
> eventually run again, because the emulation does an instruction skip
> (and doing too many skips would be a waste of guest code :-) We need
> to use additional VCPU state to track if the emulation is complete.
> As luck would have it, we already have 'mmio_needed', which even
> appears to be used in this way by other architectures already.
> 
> Fixes: 0d640732dbeb ("arm64: KVM: Skip MMIO insn after emulation")
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
> v2: move mmio_needed use closer to other mmio state use [maz]
> 
>  virt/kvm/arm/mmio.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Applied with Mark's Ack.

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
