Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0312CC11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:48:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69BF061422
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:48:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69BF061422
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E327740CF9;
	Thu,  1 Jul 2021 09:48:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UFGvZVJ1ZczV; Thu,  1 Jul 2021 09:48:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4102549E57;
	Thu,  1 Jul 2021 09:48:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D97E40CF8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:48:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AUQBCuWC2Ts5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 09:48:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D4ED40877
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:48:31 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27F8A61420;
 Thu,  1 Jul 2021 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1625147309;
 bh=xq5lgInObWsa70Xiu5Iswt0q2HU0wkkrlQXuVnMsCo4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Ni1obni1R2bCfhKrCikDMlNHSVodaAc8ARaPmYETdp5Zl7ssxEgxXjZz100rN0RGt
 LrI2nbs/WlmdHqVvzTVJsU0bh652wq9lqj3DJgUEozyfcS289SzxXnKk1P915HooOE
 +YdIpUg8W0evBQWvjQpsBInL334396gv70OP3t+8XN8kGzz8jXW7k4cKDse1f1Sn52
 pV6ebuMtHttt0ENkQ3UvwM799w302Uex4kgEYxne99sB3eKoJUcljPGeL4Kj8iE/xL
 S2ppHWa4hHvlwRDma85SQ4b1DmOemJHVje85dHZgaJFA+AERqwEcZBDhWYoeeeu/fL
 P1s6ObOE7OJKg==
Date: Thu, 1 Jul 2021 14:48:23 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 08/13] KVM: arm64: Guest exit handlers for nVHE hyp
Message-ID: <20210701134823.GH9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-9-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-9-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Tue, Jun 15, 2021 at 02:39:45PM +0100, Fuad Tabba wrote:
> Add an array of pointers to handlers for various trap reasons in
> nVHE code.
> 
> The current code selects how to fixup a guest on exit based on a
> series of if/else statements. Future patches will also require
> different handling for guest exists. Create an array of handlers
> to consolidate them.
> 
> No functional change intended as the array isn't populated yet.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 19 ++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 35 +++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e4a2f295a394..f5d3d1da0aec 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -405,6 +405,18 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +typedef int (*exit_handle_fn)(struct kvm_vcpu *);
> +
> +exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
> +
> +static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
> +{
> +	if (is_nvhe_hyp_code())
> +		return kvm_get_nvhe_exit_handler(vcpu);
> +	else
> +		return NULL;
> +}

nit: might be a bit tidier with a ternary if (?:).

But either way:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
