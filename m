Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17329C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 16:01:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5645064E61
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 16:01:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5645064E61
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE5994B666;
	Wed, 17 Mar 2021 12:01:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qyqkMPwbJsfy; Wed, 17 Mar 2021 12:01:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC3004B674;
	Wed, 17 Mar 2021 12:01:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3784B666
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 12:01:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KJO0NGtCfDeJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 12:01:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2A184B3BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 12:01:20 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD39D64E61;
 Wed, 17 Mar 2021 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615996878;
 bh=we520fPnvR+Rv9m8n4m+wndrb+dnrLpZXA3mdbq49uQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=pPj0efyieA0yEzJ70ka3Gx5g46Q7tkHPeNCzVS+hZCHJG9DAz5vtsER1hfFPzGjFl
 QLgrDP8Y+IIAfUM7FrzRIiHJOFHwyGmGtphz4nqL3ld80zE1CsNKVZ0QbspYDO/mXW
 IMrqhSFfmAmQczE45DKGzHw3TyqDRcpjOtFvhNLTEgZRVHJI4uWmNOkeJtK/Zisc1e
 H74duv2v6hYqIF/ocoWF/KdfM1cYz9K5q2diQzmsT+YLN9PInv/c2U8JwvTsQeZ/bR
 1jtAoWfjBUEhyiR4p7Rs3bSgkIIDHBQhCE62fzV0mXGpH1BLvztQauk//LiRUUunEw
 WSdHWXVl813aw==
Date: Wed, 17 Mar 2021 16:01:12 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 06/10] KVM: arm64: Map SVE context at EL2 when available
Message-ID: <20210317160112.GA5556@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-7-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-7-maz@kernel.org>
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

On Tue, Mar 16, 2021 at 10:13:08AM +0000, Marc Zyngier wrote:
> When running on nVHE, and that the vcpu supports SVE, map the
> SVE state at EL2 so that KVM can access it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index b7e36a506d3d..84afca5ed6f2 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -43,6 +43,17 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		goto error;
>  
> +	if (vcpu->arch.sve_state) {
> +		void *sve_end;
> +
> +		sve_end = vcpu->arch.sve_state + vcpu_sve_state_size(vcpu) + 1;

Why do you need the '+ 1' here?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
