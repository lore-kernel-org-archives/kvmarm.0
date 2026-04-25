Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F9392C28;
	Sat, 25 Apr 2026 14:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777126765; cv=none; b=g54vdmRnOlWlYPGMdJHWwVYbw4BUFjxPT7eouE6/hL6nW3Uk2cDkLUgkZDKXfVwjgc88nW36yWQ96tKl2VpUBpe0sCelkO376MeIVtyYJ2XlI9WjjcFKWhe1U3kqlLQ3Hwb9OoUdOkm/xh0c1ajpZRzra+ZBPs5MOjL+m0ZzWc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777126765; c=relaxed/simple;
	bh=ZmsK2POVH2Z4YyUaXKtECdBvyDUFXk5uggawnQxeVQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jkCJdX41C27fjE+7L6khKNawJp6zar/KIDglphwjjyyEFpDXr6CEoqcu/iKDeVEsmzCXK96y0vGdG1DwAXgDp0veegmaTDezXJbz3Y+imQcCQuqE/+77NBhKGyIzZIxS8UM0vcW91dXdClGQe5qXxd0gaeXrv/5XZUxBZevGAzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqaFM3DB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqaFM3DB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F1FC2BCB0;
	Sat, 25 Apr 2026 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777126765;
	bh=ZmsK2POVH2Z4YyUaXKtECdBvyDUFXk5uggawnQxeVQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DqaFM3DB8C2ytMYZMb6+p2eO6CaGG597R8Sg00ja0PzZg8Luxl5fdzHGkl88YEqyg
	 Fu6mM8hP/Biv7Y7x8iGJ9BbRZpKGvBs4bBPUcTOr7xaFUS5OabJVGGJLu/OdHcfhGP
	 5qdY/BWhPScC73EtTA1KRYufLM47XwG/zgxhCOVXhuoAsoeH5fVkdIE7Pa2ALYpMYY
	 mibvG6F9/7bvZK5lix1eSetpkwF4d+L95aow4kkxbP6F5uy1sT33e7HLAIX9LvoPk5
	 nXbMzt+VMCaGYgILGP5NZG+/knO+BJ88WDWYV8LxFG9zrxOwf4/Xnncv4FZWWeCGXp
	 XWoSF8dlq4Y/Q==
Date: Sat, 25 Apr 2026 17:19:21 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, jgg@ziepe.ca,
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
	sebastianene@google.com, Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [RFC PATCH v3 4/4] Revert "firmware: arm_ffa: Change initcall
 level of ffa_init() to rootfs_initcall"
Message-ID: <aezNaZEcXlEklNoj@kernel.org>
References: <cover.1777036497.git.noodles@meta.com>
 <2e7b4dc552b45ddf14cc43bc449cbebb4ade0027.1777036497.git.noodles@meta.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e7b4dc552b45ddf14cc43bc449cbebb4ade0027.1777036497.git.noodles@meta.com>

On Fri, Apr 24, 2026 at 02:24:42PM +0100, Jonathan McDowell wrote:
> From: Yeoreum Yun <yeoreum.yun@arm.com>
> 
> This reverts commit 0e0546eabcd6c19765a8dbf5b5db3723e7b0ea75, which was
> added to address ordering issues with the IMA LSM initialisation where
> the TPM would not be fully ready by the time IMA wanted it. This has
> been resolved within IMA by retrying setup during late_initcall_sync if
> the TPM is not available at first.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Jonathan McDowell <noodles@meta.com>
> ---
>  drivers/firmware/arm_ffa/driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
> index f2f94d4d533e..01547c5c0e38 100644
> --- a/drivers/firmware/arm_ffa/driver.c
> +++ b/drivers/firmware/arm_ffa/driver.c
> @@ -2106,7 +2106,7 @@ static int __init ffa_init(void)
>  	kfree(drv_info);
>  	return ret;
>  }
> -rootfs_initcall(ffa_init);
> +module_init(ffa_init);
>  
>  static void __exit ffa_exit(void)
>  {
> -- 
> 2.53.0
> 

LGTM (for both tpm patches).

However, I'll hold on any further comments/tags up until I've sorted 7.1 PRs
(just so that I have full focus).

BR, Jarkko
