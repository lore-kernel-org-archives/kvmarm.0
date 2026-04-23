Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F77C383C66;
	Thu, 23 Apr 2026 10:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776939452; cv=none; b=XnB9nWERT/2/AIdZ1vG8piNwKeXgihX2xkRHECmGyCr/yCnLXUQpDZcn5DwbnMKcwJtDaSiFVA092d5ipio6VrTnovFsxjiEEaoLosYRLhJtTyV8nYoaJv2EL7TPjT142TpgreE08gL7wFsSlxXUi5tnsoDrj6J3tYftzt1LL+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776939452; c=relaxed/simple;
	bh=Eh+rxbW5ADS/ygmkGFPlk846VYv4ZMXX9UlZzCUlUQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/tOjKPE/7AIeHskGpeWMKGnV7o2Q2KfblyEuic2Mu5tn6iGrSYMAPAtTRf+JhvKP39WC6FNqmQVJRjRTe2BmkN8keYmrjP4FuW5b3F8V9C2bf8ZFiIpQmB1oSqfrphxk/1X+Y1YuiEH+u72hRncnNkr3fjloQIZzuulD/Vi+4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRs5EZs+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRs5EZs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E3CC2BCB2;
	Thu, 23 Apr 2026 10:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776939451;
	bh=Eh+rxbW5ADS/ygmkGFPlk846VYv4ZMXX9UlZzCUlUQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LRs5EZs+C+W4Tt5ez+7FVfPvZ7loMsxFfvo24ZTmqRjA4OLTmGY4nXtGDrMIcehvS
	 I8qr35S9XtfHKYAHJW5uh7dgpauP5OXakHWyrbP19QIfwyyz/mTGmIfjE/eta5Vj1h
	 crmNgGSP44AQLW5Rbiov36q6vscGVHKaKWNxIOcsZMGhXwYuoVCPYUTk7ssPo0fea+
	 nD5bZ25tIRHnnstVyN2M/EXRETYWElnQ7nqatdTwUO9IwPzq155XJA8rgRSDg1OQT4
	 qfasuvo84W+aG584F2AnBd0Yp25dOT7UgyVgnVlj+8jHda/G5hBRgkGs1Kr1tV64XD
	 iM5PJq4cV+thw==
Date: Thu, 23 Apr 2026 13:17:27 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, jgg@ziepe.ca,
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
	sebastianene@google.com
Subject: Re: [RFC PATCH v2 2/4] tpm: tpm_crb_ffa: revert defered_probed when
 tpm_crb_ffa is built-in
Message-ID: <aenxtxb5eIsCWOZd@kernel.org>
References: <20260422162449.1814615-1-yeoreum.yun@arm.com>
 <20260422162449.1814615-3-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422162449.1814615-3-yeoreum.yun@arm.com>

On Wed, Apr 22, 2026 at 05:24:47PM +0100, Yeoreum Yun wrote:
> commit 746d9e9f62a6 ("tpm: tpm_crb_ffa: try to probe tpm_crb_ffa when it's build_in")
> probe tpm_crb_ffa forcefully when it's built-in to integrate with IMA.
> 
> However, as IMA init function is changed to late_initcall_sync level.
> So, this change isn't required anymore.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  drivers/char/tpm/tpm_crb_ffa.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb_ffa.c b/drivers/char/tpm/tpm_crb_ffa.c
> index 99f1c1e5644b..025c4d4b17ca 100644
> --- a/drivers/char/tpm/tpm_crb_ffa.c
> +++ b/drivers/char/tpm/tpm_crb_ffa.c
> @@ -177,23 +177,13 @@ static int tpm_crb_ffa_to_linux_errno(int errno)
>   */
>  int tpm_crb_ffa_init(void)
>  {
> -	int ret = 0;
> -
> -	if (!IS_MODULE(CONFIG_TCG_ARM_CRB_FFA)) {
> -		ret = ffa_register(&tpm_crb_ffa_driver);
> -		if (ret) {
> -			tpm_crb_ffa = ERR_PTR(-ENODEV);
> -			return ret;
> -		}
> -	}
> -
>  	if (!tpm_crb_ffa)
> -		ret = -ENOENT;
> +		return -ENOENT;
> 
>  	if (IS_ERR_VALUE(tpm_crb_ffa))
> -		ret = -ENODEV;
> +		return -ENODEV;
> 
> -	return ret;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_crb_ffa_init);
> 
> @@ -405,9 +395,7 @@ static struct ffa_driver tpm_crb_ffa_driver = {
>  	.id_table = tpm_crb_ffa_device_id,
>  };
> 
> -#ifdef MODULE
>  module_ffa_driver(tpm_crb_ffa_driver);
> -#endif
> 
>  MODULE_AUTHOR("Arm");
>  MODULE_DESCRIPTION("TPM CRB FFA driver");
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> 

I'll hold review to next version i.e. after Mimi's concerns
have been addressed.

BR, Jarkko
