Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA17EC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 17:27:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 456C14B1D5;
	Wed,  8 Dec 2021 12:27:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id in7mdsO64fE8; Wed,  8 Dec 2021 12:27:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32BF54B1C5;
	Wed,  8 Dec 2021 12:27:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3452B4B19D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 12:27:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I5WdpgHShTLi for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 12:27:32 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1CB04B17D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 12:27:31 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id B2E2ECE227A;
 Wed,  8 Dec 2021 17:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040C3C00446;
 Wed,  8 Dec 2021 17:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638984446;
 bh=lqbWSxTjq5h0nfPwj+YekiOXt9qpJedy5VZxJJntbss=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Y0hEJRnnfWShU9xbZCzZR2oAvbYFZ3QgMqGx/hEt9tUWvHY8//Icy5kr3pdvOMXro
 PuA8ULwyWbjne5qTr0AYnN4gu28TWPRnsea8DjZ4wwOT1JVQwv6tVKNDbO6itzMwjp
 2Aok7RStqjFXUtOe4UeC+NAjXs6UWvhmEjNf+ufTkuMiAoct3fY+L0Fow1EABLlh5m
 kfA5Q0/aEciVFGcRDlAv4PdXi0OrpvRX2bEmKTjk5Ha5stIZdx+LLqsZ84DsxDlFEL
 +U6piotWHGcMzPK70srpc2BZ+qxXinBduw+DgkMjXWXOMxAU4d+OLYApv5qbUW9C0Q
 iHQRmVK7CMJoA==
Date: Wed, 8 Dec 2021 17:27:21 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 1/6] KVM: arm64: pkvm: Fix hyp_pool max order
Message-ID: <20211208172720.GB820@willie-the-truck>
References: <20211208152300.2478542-1-qperret@google.com>
 <20211208152300.2478542-2-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211208152300.2478542-2-qperret@google.com>
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

On Wed, Dec 08, 2021 at 03:22:54PM +0000, Quentin Perret wrote:
> The EL2 page allocator in protected mode maintains a per-pool max order
> value to optimize allocations when the memory region it covers is small.
> However, the max order value is currently under-estimated whenever the
> number of pages in the region is a power of two. Fix the estimation.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
