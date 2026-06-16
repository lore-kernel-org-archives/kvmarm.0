Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6796A3382DC
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 12:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781614038; cv=none; b=ZKyFHd440Q2fljXcUPy4DwmkNfSfU6kNtag3IQWkfEJYW/rJHXDXJ86qBKCYzd8bkc488ydo+ioN74sZI+fxI11/WNRNU/ycGPCGbdhtbnkf1+ZbP9WDqj/fR3V+2paZVOJYkcHUnQXypfnShUYbDrkaL36LN1JzKYxMQTHl1K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781614038; c=relaxed/simple;
	bh=s9PwPborDxQcwJdI5p4j46GCuJjSnERlNpDvf4JxExA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtB27m8/OTH0648vD7pGneb+Md/vB76RWszrZ8ripepbNg+h2R7kZLZdp+Q8Ksclw3/G3V2xUYhTEkwFMUuUAE3VYwcbTvwmgbb2LK5pw/OBGpGffrwlKoxFXLG4NPh16ypIIstPV18ZCHGh0qlQ0ymsOVEIZ47Lt1x5Dp1xD0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nKoTSZxK; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nKoTSZxK"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bec3ffb95dbso658446966b.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 05:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781614036; x=1782218836; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MIkvauF10sSe2Poa7JVmuLLeALb9mXVPDLiKngYfXa0=;
        b=nKoTSZxK7MfFrWs2Ke7vpd3SV5B7Jfat0Hleh6FjxcNg1LScj1tqMSIwLG1tkGSoAi
         wnrTctFFM3RhkD4CzoPBTQHaQs7lN1Ozw4Kd59RYtWphz5as66ZXFnuw1NMI0Wpni7D8
         cGqYOnDnofsXMf7XWby0rVSzFaXZGXYFU25DmVsrd7TpejkSpo4BDoIVLBkcT8c/wKQg
         1ECThEHes6n7vYQ+8/Ji90SBlB8zgbqhm3gT4oMk7odNanUxPaTH6r04w20UNDCszMwV
         vw/rwGHfmX9L4MHZaLTSj+V3djDlaZc0OLjCr5ZF4XuVIlppKevyXXqoMr34uZ/Fu3VR
         ju4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781614036; x=1782218836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MIkvauF10sSe2Poa7JVmuLLeALb9mXVPDLiKngYfXa0=;
        b=Am1DkZYbVKv9ppnKyaZHdc38+8OZi9uyFboTYBw0UFV/yb913gp9q7cKCVSDecOxz6
         bJlGyZ7+nT2p7AxCzacAcgUjOLTfx5Ehm5tA/7A3okWGm3+Ftp8q6gSYlCmtUaZh2fJ+
         HVw9g1ddObBJSkg3X/sIizUUR8yet7T6aoYxfi9aegSzxeactxIMOh24cvdiuAy9J+7S
         aSOSRhrBBsgvivUu9B9e+k2xHFynBGi6cdlZRA2zAXxePy6cN+Ubr70ZtDVLxq0zBApN
         0ua85p0cjB2AgYXFRg6QM8C8vjLn+3cMWvievx1ULe+Y5iDyF8USEEovx3Bh0PyJVhv+
         f4+Q==
X-Forwarded-Encrypted: i=1; AFNElJ94h50h2Hj163DUuQKJ9bO+UPAVrvPoRXYBBAG3ToezJEPiJ88sHqnzPQfJuQ++cg/cLIcIP3Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEYCvuK/24M+P/suka/SRxNPp4EjEylEu7mDMQc8oPAAc1HHaM
	hlbtyBEIF2+cnDQiHhDH9d6hmc5a63Y1ogyuNGwbZetf5dRNhotMZKyG+JovP94c/A==
X-Gm-Gg: Acq92OGQWn8NuA9dfgtpARss5mk3i45LwfKAqSBVa1XLYbFcpCKsSbmW9ib26jcyV95
	WeYXk12N4zZkAjfcAOCJnHD3YW6uiR7AQy3Wtiy7ms52OqICnv6MBVisHULrroNKa6lh1letmTH
	koEuuxoD6713hLGbltJJsDzJRKjK5No6hbfNQfDwUbNogG/bKjXLEBouzUBxdxdhQlsxwG97llY
	3OGRpNy9hqQt2nSK+mWrroLT9iy+Kbad9J73i+ssxZl+HrxHu6NcpwnRNVwzZ5teX/vQrMRBTPg
	o3+UDvWXUtK3zUfekZlsG2X0XZsrrVTgv58AyvTdMuttCe4BfH+Xb8jra34Gf2cZmWjQZKmrX1b
	LcyUuXO0Rq19rUOcSE5POI+gMWgFRMJTsOO0rW5M0uosm3SmBVH2VzwOhvjfDYX7j4IdiExqden
	r2xYiS9RibKL4FWsQJfMPHH2j/+1N1TLuCAtp313/w2xCqXtyuW8CZrCVZ7094yDS3vFg=
X-Received: by 2002:a17:907:734f:b0:bdc:9d94:3257 with SMTP id a640c23a62f3a-c043cdcf4c9mr126540566b.14.1781614035236;
        Tue, 16 Jun 2026 05:47:15 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb7b6d9b7sm644734366b.41.2026.06.16.05.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:47:14 -0700 (PDT)
Date: Tue, 16 Jun 2026 13:47:11 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 7/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in
 host handler
Message-ID: <ajFFz0mE24ZcusuP@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-10-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616105417.2578670-10-sebastianene@google.com>

On Tue, Jun 16, 2026 at 10:54:16AM +0000, Sebastian Ene wrote:
> Allow the host to query the FF-A notifiction status and proxy the info
> get message to Trustzone. Make sure that the SBZ fields are enforced.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 549250ff8f82..dac30a5fcf5a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -714,8 +714,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_RXTX_MAP:
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
> -       /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_INFO_GET:
>  	/* Optional interfaces added in FF-A 1.2 */
>  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
>  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
> @@ -1020,6 +1018,20 @@ static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
>  	arm_smccc_1_2_smc(args, res);
>  }
>  
> +static void do_ffa_notif_info_get(struct arm_smccc_1_2_regs *res,
> +				  struct kvm_cpu_context *ctxt)
> +{
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 1)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args = (void *)&ctxt->regs.regs[0];
> +	arm_smccc_1_2_smc(args, res);

	hyp_smccc_1_2_smc()

ditto FFA_NOTIFICATION_GET, FFA_NOTIFICATION_SET, FFA_NOTIFICATION_UNBIND

> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -1094,6 +1106,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_NOTIFICATION_GET:
>  		do_ffa_notif_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_NOTIFICATION_INFO_GET:
> +		do_ffa_notif_info_get(&res, host_ctxt);
> +		goto out_handled;
>  	}
>  
>  	if (ffa_call_supported(func_id))
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
