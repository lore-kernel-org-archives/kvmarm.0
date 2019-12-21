Return-Path: <SRS0=JRaC=2L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F5AC2D0C0
	for <kvmarm@archiver.kernel.org>; Sat, 21 Dec 2019 13:12:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF13E2072B
	for <kvmarm@archiver.kernel.org>; Sat, 21 Dec 2019 13:12:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF13E2072B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17F744AEBD;
	Sat, 21 Dec 2019 08:12:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id An+PzJhWe7u9; Sat, 21 Dec 2019 08:12:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3FCA4AEAB;
	Sat, 21 Dec 2019 08:12:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59B164AD09
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Dec 2019 08:12:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iqW64c5ajTn2 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 21 Dec 2019 08:12:21 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F32604AC7C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Dec 2019 08:12:20 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why)
 by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
 (Exim 4.80) (envelope-from <maz@kernel.org>)
 id 1iieYK-0002tv-Gk; Sat, 21 Dec 2019 14:12:16 +0100
Date: Sat, 21 Dec 2019 13:12:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 02/18] arm64: KVM: reset E2PB correctly in MDCR_EL2
 when exiting the guest(VHE)
Message-ID: <20191221131214.769a140e@why>
In-Reply-To: <20191220143025.33853-3-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-3-andrew.murray@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, will@kernel.org,
 catalin.marinas@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Fri, 20 Dec 2019 14:30:09 +0000
Andrew Murray <andrew.murray@arm.com> wrote:

> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> On VHE systems, the reset value for MDCR_EL2.E2PB=b00 which defaults
> to profiling buffer using the EL2 stage 1 translations. 

Does the reset value actually matter here? I don't see it being
specific to VHE systems, and all we're trying to achieve is to restore
the SPE configuration to a state where it can be used by the host.

> However if the
> guest are allowed to use profiling buffers changing E2PB settings, we

How can the guest be allowed to change E2PB settings? Or do you mean
here that allowing the guest to use SPE will mandate changes of the
E2PB settings, and that we'd better restore the hypervisor state once
we exit?

> need to ensure we resume back MDCR_EL2.E2PB=b00. Currently we just
> do bitwise '&' with MDCR_EL2_E2PB_MASK which will retain the value.
> 
> So fix it by clearing all the bits in E2PB.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 72fbbd86eb5e..250f13910882 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -228,9 +228,7 @@ void deactivate_traps_vhe_put(void)
>  {
>  	u64 mdcr_el2 = read_sysreg(mdcr_el2);
>  
> -	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
> -		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
> -		    MDCR_EL2_TPMS;
> +	mdcr_el2 &= MDCR_EL2_HPMN_MASK | MDCR_EL2_TPMS;
>  
>  	write_sysreg(mdcr_el2, mdcr_el2);
>  

I'm OK with this change, but I believe the commit message could use
some tidying up.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
