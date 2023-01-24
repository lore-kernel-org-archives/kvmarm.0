Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4F610E9
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 09:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DBAC433EF;
	Tue, 24 Jan 2023 09:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674553055;
	bh=1zzgkNRfTR3Nd94PvxKyIX49lYH4mssft7KcQNucUqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OuS4XbfhuQ3vkfJ5iXQDtE2abnO3giky+BFrHtX9/CzM2VEj7jIajVl3lm3t8TESe
	 3J9E1BgzSrg6Ijj1OD9PnRHVMsi78EoCbg+uXeSxb6WSsq7GohmMbMB6KmCI5eqYlC
	 RqeqIjuxVDDdeSyjJk6fNj87WntHQT8KbDLL9iSIlMmuD3/DhUbR0ljdemdHZDu+65
	 HO79MXjydzAmPG7ReyEOs5t2keE1cwBs3yJGmsQw5IiXXFbsHs7QlTelg2ytdRDKx+
	 Xot+lVqHRsDyREMJFq+iNzq8Xj42LhEf5N/+8L3IzjVWilnXZFdCXiHX0IaFigf5TF
	 zCGl3E6GGApXw==
Date: Tue, 24 Jan 2023 09:37:29 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MAINTAINERS: Add Oliver Upton as co-maintainer of
 KVM/arm64
Message-ID: <20230124093728.GA26080@willie-the-truck>
References: <20230123210256.2728218-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123210256.2728218-1-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jan 23, 2023 at 09:02:56PM +0000, Oliver Upton wrote:
> Going forward I intend to help Marc with maintaining KVM/arm64. We've
> spoken about this quite a bit and he has been a tremendous help in
> ramping up to the task (thank you!). We haven't worked out the exact
> details of how the process will work, but the goal is to even out the
> maintenance responsibilities to give us both ample time for development.
> 
> To that end, updating the maintainers entry to reflect the change.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 42fc47c6edfd..7323efcc1270 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11355,9 +11355,9 @@ F:	virt/kvm/*
>  
>  KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
>  M:	Marc Zyngier <maz@kernel.org>
> +M:	Oliver Upton <oliver.upton@linux.dev>

Ya know, alphabetical order tends to put Mr Z at the bottom of the list,
but I can understand why you don't necessarily want to be first in the
pack just yet!

In any case, this is really great to see:

Acked-by: Will Deacon <will@kernel.org>

Thank you!

Will
