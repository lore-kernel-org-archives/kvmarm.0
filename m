Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16369C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 13:35:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E42964E27
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 13:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E42964E27
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC514B74C;
	Thu, 18 Mar 2021 09:35:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iDr8+JpFdDRL; Thu, 18 Mar 2021 09:35:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3714D4B731;
	Thu, 18 Mar 2021 09:35:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15B3B4B35E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 09:35:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hUdhy5kz5kle for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 09:35:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 280A64B319
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 09:35:09 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D883564E27;
 Thu, 18 Mar 2021 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616074508;
 bh=drwRf6r5gnk51sjNwKIMpcBEidEESTQ50krX8/oftAk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=eSRCQ+nrd6zWoS6wyFcVqCQno3fU8dhLOCqJSWq8Ak1J3eJEk85IiRVXzq6SNPE1l
 zRAEpM7cU5pWB503cpw5/9Mba59eGThFxIvximWdMXTJ3pLdvahh6aNcSMNLv5RGW/
 Dvi98vIMIxfqqFq+G1J8O98aOUuNnHAFDSUI7Elzu4EAg6Xn0VYRnAU67EFHT28Baf
 m0iDMHkBuK+F95qFt6F6YTNqEMHG3ZFeaXC5Kj4AJPFhttg1G5lSDELtO9lLKSwkXu
 +6/oAK99CIIobz4Om4PlXwX0yzHGqbz2H4nurU1mDJ7u9uG14zO5F0EC2BPdytYaYm
 HrzmvF3p/CwyA==
Date: Thu, 18 Mar 2021 13:35:02 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 07/11] KVM: arm64: Map SVE context at EL2 when available
Message-ID: <20210318133502.GD7055@willie-the-truck>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-8-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-8-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, broonie@kernel.org, kernel-team@android.com,
 dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On Thu, Mar 18, 2021 at 12:25:28PM +0000, Marc Zyngier wrote:
> When running on nVHE, and that the vcpu supports SVE, map the
> SVE state at EL2 so that KVM can access it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index b7e36a506d3d..3c37a419fa82 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -43,6 +43,17 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		goto error;
>  
> +	if (vcpu->arch.sve_state) {
> +		void *sve_end;
> +
> +		sve_end = vcpu->arch.sve_state + vcpu_sve_state_size(vcpu);
> +
> +		ret = create_hyp_mappings(vcpu->arch.sve_state, sve_end,
> +					  PAGE_HYP);
> +		if (ret)
> +			goto error;
> +	}

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
