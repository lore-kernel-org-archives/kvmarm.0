Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9BEC43464
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 11:59:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C57A922208
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 11:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wi8gJFm9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C57A922208
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D5BF4B11F;
	Fri, 18 Sep 2020 07:59:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IDex0h6E7LTP; Fri, 18 Sep 2020 07:59:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30ECA4B21E;
	Fri, 18 Sep 2020 07:59:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52F414B120
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 07:59:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 97SEkduUBlzF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 07:59:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B6504B11F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 07:59:18 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 495142100A;
 Fri, 18 Sep 2020 11:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600430357;
 bh=3Qap6q40YIglmIHbQ+ks0DDlLM3eZIky/ggcT6S4TQM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Wi8gJFm90edZexQ0zmiObRObbHa7NJpw7886jHiADFFDszzxGATrW8XpeWZw5dxah
 fHUFqGko9Z7dTZGUcTjla0sFR8Lz5jiFLcGkCJ+UO1stNpP2Zgh4qHdD4LQYa1s81M
 W0vBdzAmsV0YtPGgfh6haS+qfm6IAI+ycXfGx0Wc=
Date: Fri, 18 Sep 2020 12:59:12 +0100
From: Will Deacon <will@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 07/11] kvm: arm64: Duplicate
 arm64_ssbd_callback_required for nVHE hyp
Message-ID: <20200918115911.GB31096@willie-the-truck>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-8-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200916173439.32265-8-dbrazdil@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
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

On Wed, Sep 16, 2020 at 06:34:35PM +0100, David Brazdil wrote:
> Hyp keeps track of which cores require SSBD callback by accessing a
> kernel-proper global variable. Create an nVHE symbol of the same name
> and copy the value from kernel proper to nVHE at KVM init time.
> 
> Done in preparation for separating percpu memory owned by kernel
> proper and nVHE.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h | 10 +++++++---
>  arch/arm64/kernel/image-vars.h   |  1 -
>  arch/arm64/kvm/arm.c             |  2 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c |  3 +++
>  4 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 189839c3706a..9db93da35606 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -529,23 +529,27 @@ static inline int kvm_map_vectors(void)
>  
>  #ifdef CONFIG_ARM64_SSBD
>  DECLARE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
> +DECLARE_KVM_NVHE_PER_CPU(u64, arm64_ssbd_callback_required);
>  
> -static inline int hyp_map_aux_data(void)
> +static inline int hyp_init_aux_data(void)
>  {
>  	int cpu, err;
>  
>  	for_each_possible_cpu(cpu) {
>  		u64 *ptr;
>  
> -		ptr = per_cpu_ptr(&arm64_ssbd_callback_required, cpu);
> +		ptr = per_cpu_ptr_nvhe(arm64_ssbd_callback_required, cpu);
>  		err = create_hyp_mappings(ptr, ptr + 1, PAGE_HYP);
>  		if (err)
>  			return err;
> +
> +		/* Copy value from kernel to hyp. */
> +		*ptr = per_cpu(arm64_ssbd_callback_required, cpu);

Hmm. Is this correct for late arriving CPUs, where we don't know whether
a callback is required at the point we do the copy?

That sounds fiddly to resolve, but this _might_ all be moot because I'm
about to post a series that allows us to remove the hyp mapping of this
variable entirely. So leave this for now, but maybe stick a comment in
that it doesn't work for late cpus.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
