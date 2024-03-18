Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A220157866
	for <kvmarm@lists.linux.dev>; Mon, 18 Mar 2024 16:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710780448; cv=none; b=pOXJElXxya6CXVgKdcQwBHySM/8stNuF71YOPDFFa0xlp7VLdaaHRnPqyXDhGb7W0igMnqAXINn65B5OMtIvoVMjkeusw1q147YQXGxsxZm8aw7RJKP89SHZlR2PPz5nEqKYBB2VdjG024RrhA1Q1PvQozvYRRnx2IMaYCMOWyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710780448; c=relaxed/simple;
	bh=1IGAbzWT+iuWIien3m6/wU6i6zltZt1qWdCRlCR4yG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuY6ebRsPKD1jIBT8XOTNAtCRzbaMJ6fbCNVM2U0lCDtHMGjqrGRV/ycUywVR4bBTfB6uk+Kfj2nOM8grD+dTartUCFVbwL75wW5IRzKGSswHkHMZChi6AdL/Nu0DnQy6tpsI9JG6LvLTsjdHXMNLKPPzD3aoMoGxUFOjz478oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=BGCn8U1t; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BGCn8U1t"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-513c8b72b24so5077223e87.3
        for <kvmarm@lists.linux.dev>; Mon, 18 Mar 2024 09:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1710780445; x=1711385245; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fA2qjVsX0hEHrRuna2wB7Jh5sjPxChSCeSPdyOfnMv8=;
        b=BGCn8U1tdbD4NT/tlYMnC9EgZYu7fQXDLJzjnx6FFtYo86DMe9y/ctRsWkEOlb+ZJ2
         r+IEEIZe4rJGTdnlTkd/mUIHF6jGJqklf1ZpSF+MYpMbB605nj5RYIegTCBgdgYwBpyW
         nndHnITRUEwBL2y5wC7gP7DlXGrQO4dFRFjf/VgRFX4Zwp5fzxwTEaR2NVNG4eJ/kcwl
         5zCO2/QXZuW74rMUMpnRplyn35W0bBUdyANc5AbbdAWbRKSaJOf7gZVUh3tIw48WWww2
         W3VjqIElQFFXm7phHpIGxJphO4WKZHHNFIZZYf0NCDNaEhUEQR1mN0j14o33t0ew7wGt
         fyFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710780445; x=1711385245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fA2qjVsX0hEHrRuna2wB7Jh5sjPxChSCeSPdyOfnMv8=;
        b=tSzp3o5oMR/lQa7WatN+U3YfEouLeSuI0tmz5O2ZG6m38gINtz/1N+i+Bzq1MTx89M
         WMKXtD4Pca3VIuyQJHA4L6ghk5zWUE8zsfd6g/yta4B7Blgqrkj+3vmZMGx9rgPaf30Q
         hhpEdW94DfLWfYZA8elYTZPFsMmd/tDQj3hm5VPVeEY+WCDiNqS+d2UiW8MsKja+gy0d
         K2SVOI9NJPNViSPWAEABY2t5MfEpouAQgRfE7pIrpHJbosvbyahboPDPQwr2mTtP247u
         /iUjJJ18Wuv3RWq7WMW+lXPcU92FoNREMpN8vFYITkbAPlyzIQ+/02Uy8cfxOpqHyWaG
         PJCA==
X-Gm-Message-State: AOJu0Ywk2MhsI/T7BjX1dXHMTJr8/2cqpAxPhvpfbbnigmRXCli2/IWd
	xmTiVqi+aPDVyIiSEA/dHV4jeiHfFH1bM7DftVtv8mw1xBDJRK5EwP3kvNV14jyuQvNtWM16cO/
	E
X-Google-Smtp-Source: AGHT+IFWBx/jEIbmiWiha8zsZ8bi6uLNsp3DCToUo/3QEYqiKMx7GKl4Y0e/A8TYpLl3jo8iDXZnzg==
X-Received: by 2002:a19:6914:0:b0:513:b023:7608 with SMTP id e20-20020a196914000000b00513b0237608mr52848lfc.8.1710780444755;
        Mon, 18 Mar 2024 09:47:24 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c468800b00414108a1c55sm3734951wmo.16.2024.03.18.09.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 09:47:24 -0700 (PDT)
Date: Mon, 18 Mar 2024 17:47:23 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm64: Improve unhandled exception traces
Message-ID: <20240318-61fac0a100e0fde487c5b55c@orel>
References: <20240227190935.486566-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227190935.486566-2-andrew.jones@linux.dev>

On Tue, Feb 27, 2024 at 08:09:36PM +0100, Andrew Jones wrote:
> Put the stack trace at the bottom, rather than mixing it with
> register dumps, and also start the trace from the current PC.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/arm64/processor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
> index 5bcad679605e..06fd7cfcc548 100644
> --- a/lib/arm64/processor.c
> +++ b/lib/arm64/processor.c
> @@ -130,9 +130,9 @@ static void bad_exception(enum vector v, struct pt_regs *regs,
>  	printf("Vector: %d (%s)\n", v, vector_names[v]);
>  	printf("ESR_EL1: %8s%08x, ec=%#x (%s)\n", "", esr, ec, ec_names[ec]);
>  	printf("FAR_EL1: %016lx (%svalid)\n", far, far_valid ? "" : "not ");
> -	dump_stack();
>  	printf("Exception frame registers:\n");
>  	show_regs(regs);
> +	dump_frame_stack((void *)regs->pc, (void *)regs->regs[29]);
>  	abort();
>  }
>  
> -- 
> 2.43.0
>

Merged.

Thanks,
drew
