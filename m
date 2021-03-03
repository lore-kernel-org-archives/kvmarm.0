Return-Path: <SRS0=lGHe=IB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44333C433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 11:29:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D4A064EDF
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 11:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D4A064EDF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E71224B498;
	Wed,  3 Mar 2021 06:29:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C79DXnYstXdE; Wed,  3 Mar 2021 06:29:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3A7C4B329;
	Wed,  3 Mar 2021 06:29:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36B2A4B329
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 06:29:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 18JXpDbE99Jr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Mar 2021 06:29:43 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E7044B2C0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 06:29:43 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BE0D64EE3;
 Wed,  3 Mar 2021 11:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614770980;
 bh=X7znKVskg1MlkzK8CLsnoOUCSQ1ohITe7zhHreZVWvE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Y7Px4czelhdxpnQqPohTeAkivJu14CrWiCChoxyi1u+XEAGiMgtLkXZS9u39tk0iC
 l4/9e3Z4DXcJA0j3KX467gCLH+t8DTdunFYUD9ntLfXo5l55Om6BZL6ymwlb51i2iz
 5zH6uKZVR5hWvP1Kw+nLxcrV/+YNwn505/gqmWjqTKerlDBA7YDc9UALsm2h1lyfhw
 zX4n2c5kvLYSWzATKD2Zi+r/6HIXXev+o8tcc8vSVaz+sXZzQUUXXxoE1/NOpvcHj8
 wvoYNa9UeC/HIVOfHJvMsTXGdKb3mx75IkVg8DjaPUCupMuPFzGRPRA1JReXPzPiZd
 Xxk7dmhide6QQ==
Date: Wed, 3 Mar 2021 11:29:34 +0000
From: Will Deacon <will@kernel.org>
To: Jia He <justin.he@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix unaligned addr case in mmu walking
Message-ID: <20210303112934.GA18452@willie-the-truck>
References: <20210303024225.2591-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210303024225.2591-1-justin.he@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
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

On Wed, Mar 03, 2021 at 10:42:25AM +0800, Jia He wrote:
> If the start addr is not aligned with the granule size of that level.
> loop step size should be adjusted to boundary instead of simple
> kvm_granual_size(level) increment. Otherwise, some mmu entries might miss
> the chance to be walked through.
> E.g. Assume the unmap range [data->addr, data->end] is
> [0xff00ab2000,0xff00cb2000] in level 2 walking and NOT block mapping.
> And the 1st part of that pmd entry is [0xff00ab2000,0xff00c00000]. The
> pmd value is 0x83fbd2c1002 (not valid entry). In this case, data->addr
> should be adjusted to 0xff00c00000 instead of 0xff00cb2000.
> 
> Without this fix, userspace "segment fault" error can be easily
> triggered by running simple gVisor runsc cases on an Ampere Altra
> server:
>     docker run --runtime=runsc -it --rm  ubuntu /bin/bash
> 
> In container:
>     for i in `seq 1 100`;do ls;done
> 
> Reported-by: Howard Zhang <Howard.Zhang@arm.com>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index bdf8e55ed308..4d99d07c610c 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -225,6 +225,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  		goto out;
>  
>  	if (!table) {
> +		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
>  		data->addr += kvm_granule_size(level);

Can you replace both of these lines with:

	data->addr = ALIGN(data->addr, kvm_granule_size(level));

instead?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
