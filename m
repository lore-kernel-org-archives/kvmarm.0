Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24116C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 17:51:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B03574B12C;
	Wed,  8 Dec 2021 12:51:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9XvxJDfNvn+V; Wed,  8 Dec 2021 12:51:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B84084B17D;
	Wed,  8 Dec 2021 12:51:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0411A4B12C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 12:51:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i-tsVP3H4aDz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 12:51:02 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F342A4B126
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 12:51:01 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id C284DCE228F;
 Wed,  8 Dec 2021 17:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BB0C00446;
 Wed,  8 Dec 2021 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638985857;
 bh=xb90MP/qB6HOV2i1jXMu36XCMenmbWiRSkd39nIEmlY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Ud+CpWXkWyC0eQlPUzIkm8PiPlvtU5DesoGGVTezeiqznlT7eoggyRWIMxEuzAU+Q
 WZg2msTa2KghO/JnLvHJgxWeVkg4ao5NE4J8uBcJFuFFc0SySIaiCiKlfWGY0BJ5GI
 EqxD2xsgkVornOHroFGXZ/eiVoDoSM24hdYnWgB4cBSEJBFSTL2lblJEsMKXsWqTUl
 PBmHBMLWJe9AjEyrSiebEHAWncWHVFnT1HjDN1th/moeOf3OLITKzjyo9iLgkKUWTd
 lHo4pxlbXW1li6ogPTjyK/QIyO4rrQo62fC0nx81kh6WHqnWQkOnx/0LFcz2lg6Thm
 SwG7IKVUEjghA==
Date: Wed, 8 Dec 2021 17:50:51 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 6/6] KVM: arm64: pkvm: Make kvm_host_owns_hyp_mappings()
 robust to VHE
Message-ID: <20211208175050.GF820@willie-the-truck>
References: <20211208152300.2478542-1-qperret@google.com>
 <20211208152300.2478542-7-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211208152300.2478542-7-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Dec 08, 2021 at 03:22:59PM +0000, Quentin Perret wrote:
> The kvm_host_owns_hyp_mappings() function should return true if and only
> if the host kernel is responsible for creating the hypervisor stage-1
> mappings. That is only possible in standard non-VHE mode, or during boot
> in protected nVHE mode. But either way, non of this makes sense in VHE,

Typo: non => none

> so make sure to catch this case as well, hence making the function
> return sensible values in any context (VHE or not).
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 605c104eb030..ea840fa223b5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -239,6 +239,9 @@ void free_hyp_pgds(void)
>  
>  static bool kvm_host_owns_hyp_mappings(void)
>  {
> +	if (is_kernel_in_hyp_mode())
> +		return false;

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
