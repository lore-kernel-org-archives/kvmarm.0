Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4788DC433E0
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 11:45:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E66FB207CD
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 11:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hnd8In/V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E66FB207CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 854ED4B552;
	Thu,  2 Jul 2020 07:45:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SjVoDzz-LIru; Thu,  2 Jul 2020 07:45:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C01014B53F;
	Thu,  2 Jul 2020 07:45:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95A644B50B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 07:45:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kH9YhDm6eFMB for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 07:45:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D23D4B508
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 07:45:33 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0EDFC20780;
 Thu,  2 Jul 2020 11:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593690332;
 bh=lK9ZDFBRHRZiyt8b9qOv9CduSVBofyNwqADl1zFK3K4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Hnd8In/V0QdpVQIggMTWSEAGiBAkpb4PL3z9GCFgiHy4FBglSF7dwy/0xePpJX9Ms
 8tVnB3bRE6G26TNaYhWR3QwNn7MKiQvqoPAqQgHvtRIQD/O0LGlNttNL+Amp+aJ7jh
 Y0Rntix1G8HK9+JODeUEfkqeP1+b+l2UE9YQJFNE=
Date: Thu, 2 Jul 2020 12:45:27 +0100
From: Will Deacon <will@kernel.org>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Print warning when cpu erratum can
 cause guests to deadlock
Message-ID: <20200702114527.GB16499@willie-the-truck>
References: <20200701215308.3715856-1-robh@kernel.org>
 <20200701215308.3715856-2-robh@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200701215308.3715856-2-robh@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Jul 01, 2020 at 03:53:06PM -0600, Rob Herring wrote:
> If guests don't have certain CPU erratum work-arounds implemented, then
> there is a possibility a guest can deadlock the system. IOW, only trusted
> guests should be used on systems with the erratum.
> 
> This is the case for Cortex-A57 erratum 832075.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 90cb90561446..e2f50fa4d825 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1653,6 +1653,10 @@ int kvm_arch_init(void *opaque)
>  		return -ENODEV;
>  	}
>  
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
> +		kvm_info("Guests without required CPU erratum work-arounds can deadlock system!\n" \

work-arounds => workarounds

(mainly for consistency, I have no clue if this is a real word or not!).

I'd also probably do erratum => errata given that you're about to add a
second one.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
