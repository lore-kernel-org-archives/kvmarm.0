Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A37C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 13 Dec 2021 13:10:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 855FA4B1F0;
	Mon, 13 Dec 2021 08:10:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2D2TWCyepXf9; Mon, 13 Dec 2021 08:10:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 274204B1C9;
	Mon, 13 Dec 2021 08:10:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C52D4B12E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 08:10:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UxKVNawPzX-K for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 08:10:20 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5156F4B1BA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 08:10:20 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B961BB80EC5;
 Mon, 13 Dec 2021 13:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F1FC34602;
 Mon, 13 Dec 2021 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639401017;
 bh=6RnmVJm7tvkziLPdJjjUKlfgnu3VziPQnWCgROg9gAU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=nsVKp1JoV7QJvWjNANLDyxVa9bpKHjOo/klK1VQW6CFsydU3oeUp9FDBcqhOGU8rf
 4lX2vfYGydQn9VNQrXM+VSOCVSTjBPkJ8fU07tkP9O8IEmDL4lF9PWRHzlDbBNMFJG
 gSyZogLTE/owLTJok6LG17PUPb5ubpmh7CfVz71s/UYql8zTkimiRYJJ+iiFbwt65I
 eihnR1NxbCawsePFZQdUrVtCQSYwqWf94L7z70WN1fMGJBKbgpFoc0Fy0Lf5s/xxdu
 LyvquFCg+6oB6KoyRbJoqQK5QGBwZxEBY6O7wj5ehsdVX+eUhac1fIQLYteiDeA/LM
 STcBdIikZ8iiw==
Date: Mon, 13 Dec 2021 13:10:11 +0000
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Use defined value for SCTLR_ELx_EE
Message-ID: <20211213131011.GA11479@willie-the-truck>
References: <20211208192810.657360-1-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211208192810.657360-1-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Wed, Dec 08, 2021 at 07:28:10PM +0000, Fuad Tabba wrote:
> Replace the hardcoded value with the existing definition.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f4871e47b2d0..cd5fd9b92b04 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -386,7 +386,7 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
>  		*vcpu_cpsr(vcpu) |= PSR_AA32_E_BIT;
>  	} else {
>  		u64 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> -		sctlr |= (1 << 25);
> +		sctlr |= SCTLR_ELx_EE;
>  		vcpu_write_sys_reg(vcpu, sctlr, SCTLR_EL1);

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
