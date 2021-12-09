Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA38C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 10:11:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97C804B0D0;
	Thu,  9 Dec 2021 05:11:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JEn5Up8zry+B; Thu,  9 Dec 2021 05:11:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 216ED4B0B9;
	Thu,  9 Dec 2021 05:11:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86B9D4A193
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 05:11:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f-5qed8pnpKq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 05:11:03 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D35749F5D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 05:11:03 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id DB721B82418;
 Thu,  9 Dec 2021 10:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656E9C004DD;
 Thu,  9 Dec 2021 10:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639044660;
 bh=RYhR2iP19QRA3Oma18FQhK2Re2fOq8fTvX1MIpeSMg0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=q0Lej2zGbp/4EwFGqRP+78kf2BC/Sm+ciMQgKeWUbFMnDtjpHrwIYQbZzzAqslzHY
 YJnSAYBaOAs5nj87BVV0sfc54c3u4kIJ8qV/LDS9x05irsm+RAie8Y2fPftfqXNMzt
 fdBHFxIzTm8A0gk7sjYOP0O0lTF5nf/yIfM/L8UrL5eEHdpUaKrqFKjA3cmM/gCzMJ
 TJ44niU8x6MyUA25i2UOy19P1uVMR2rVCOW/cAnvns6VmDQoqJ6HGLKDcjzUj/R38V
 MeBz0JaUo1U0DmuIKX+T7pK/DSBpgfJ32VZqohyGu56ZqsAa4foZZfm9+KslY71IuR
 rnOmwwuCvhKDg==
Date: Thu, 9 Dec 2021 10:10:54 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 01/15] KVM: arm64: Check if running in VHE from
 kvm_host_owns_hyp_mappings()
Message-ID: <20211209101053.GA1833@willie-the-truck>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-2-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211201170411.1561936-2-qperret@google.com>
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

On Wed, Dec 01, 2021 at 05:03:55PM +0000, Quentin Perret wrote:
> The kvm_host_owns_hyp_mappings() function should return true if and only
> if the host kernel is responsible for creating the hypervisor stage-1
> mappings. That is only possible in standard non-VHE mode, or during boot
> in protected nVHE mode. But either way, non of this makes sense in VHE,
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
> index 326cdfec74a1..f8f1096a297f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -239,6 +239,9 @@ void free_hyp_pgds(void)
>  
>  static bool kvm_host_owns_hyp_mappings(void)
>  {
> +	if (is_kernel_in_hyp_mode())
> +		return false;

This looks identical to:

https://lore.kernel.org/r/20211208152300.2478542-7-qperret@google.com

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
