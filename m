Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B877C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 11:13:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D48D04B0C0;
	Thu,  9 Dec 2021 06:13:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B34B2uElPT7r; Thu,  9 Dec 2021 06:13:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94E774B0DB;
	Thu,  9 Dec 2021 06:13:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 382BE4B0BD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 06:13:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UztdDCJ2wkyM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 06:13:23 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E05644A193
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 06:13:22 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 5CD68CE1FD9;
 Thu,  9 Dec 2021 11:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A43C004DD;
 Thu,  9 Dec 2021 11:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639048395;
 bh=ANeJvJaglK5z+Q0sms0vKHiAMCpEobKinM29UMmj+kE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=s60RD7GDYskSr2bUPl4Kx/pLl11WfPwMgkk8Enj3/7qQfiS5iSS2cOqU/NqanNnYn
 G8Vh7m8J0qjIPmUcfZaxLF9DsLMzyCkd38la1HoUSVnsUdid0fiCoxLXb/RWEHQAn5
 AgqXC41G2nSOQELJGmzuIU/1nSMp5Bbj+i7MsVYmm26stg2cJS1ddkE4s61sVIDx6A
 g4MFWt5Fhpg5JT2PIUOosh3uE/uYuWRZFq/x5bWr8FXFehgAmeDJVbEKrjvdA0rNzr
 N1c1O4ENZhx0H/2eJ/2PegJNpHVVZEn2MZPUCRkG+MSVI8AGCuJWuT6p4pqoO30Uzq
 ITK3b+qwVC4kA==
Date: Thu, 9 Dec 2021 11:13:10 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 07/15] KVM: arm64: Introduce kvm_share_hyp()
Message-ID: <20211209111309.GB1912@willie-the-truck>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-8-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211201170411.1561936-8-qperret@google.com>
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

On Wed, Dec 01, 2021 at 05:04:01PM +0000, Quentin Perret wrote:
> The create_hyp_mappings() function can currently be called at any point
> in time. However, its behaviour in protected mode changes widely
> depending on when it is being called. Prior to KVM init, it is used to
> create the temporary page-table used to bring-up the hypervisor, and
> later on it is transparently turned into a 'share' hypercall when the
> kernel has lost control over the hypervisor stage-1. In order to prepare
> the ground for also unsharing pages with the hypervisor during guest
> teardown, introduce a kvm_share_hyp() function to make it clear in which
> places a share hypercall should be expected, as we will soon need a
> matching unshare hypercall in all those places.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h |  1 +
>  arch/arm64/kvm/arm.c             |  4 ++--
>  arch/arm64/kvm/fpsimd.c          |  2 +-
>  arch/arm64/kvm/mmu.c             | 27 +++++++++++++++++++++------
>  arch/arm64/kvm/reset.c           |  2 +-
>  5 files changed, 26 insertions(+), 10 deletions(-)

[...]

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f8f1096a297f..fd868fb9d922 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -299,6 +299,25 @@ static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
>  	return 0;
>  }
>  
> +int kvm_share_hyp(void *from, void *to)
> +{
> +	if (is_kernel_in_hyp_mode())
> +		return 0;
> +
> +	/*
> +	 * The share hcall maps things in the 'fixed-offset' region of the hyp
> +	 * VA space, so we can only share physically contiguous data-structures
> +	 * for now.
> +	 */
> +	if (is_vmalloc_addr(from) || is_vmalloc_addr(to))
> +		return -EINVAL;

If we're adding these sanity checks, perhaps is_vmalloc_or_module_addr()
would be worth using instead?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
