Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0673E3CE4AD
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 11:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774438526; cv=none; b=XIFchT86rXGeer4Kh6pPmetBcY4q2DPAj5bt3DpvXo45uK6DBKAylBdHOf/ccz9nYVuP8JJi9TfuM+c2oYNzC6r+TQUL0rJzH4Xi2/BVvn2Yc3z3QjAfqaFzcxYxnJ+DBReYcSlu5p/Ih9z5wdE//xeE5wK8O3F2TfK7yABjyIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774438526; c=relaxed/simple;
	bh=qMzt9FUj03HMUvDVnnr74rtwo0PMBSzEfu90mfD0QzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aiBYBuQruISfBXMvBFfgn6ko5PfUstauYdjEF/cKt8zsjetwhazKvs5z8Le1b0InfzupLkQ4Q9RF6DfSlgfhy1bkEowpnUdR9TnRSZlXUc7A3PFwy4+ZmqwAg0OsmlNTqqtKhQn+gHB+aaOrtzvfSoLhXndIV1p2zCSo1Pl5tZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vGrmqhtO; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vGrmqhtO"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b4d734678so2214039f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 04:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774438523; x=1775043323; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zkE1roP0rQTN4agoxojZxa0tqCSQLd/1PEJ1rtsPXGA=;
        b=vGrmqhtOwgYjJ+xfPWBZcVwXwvzYYj1JVBf+wLgDOF+nll4as39awudFa6sQ2UFX2p
         dyhETsJr6Uc285CDAWajOHgFDOKIpg8r1J+at3gKh3Y2Q5z/EXbmj2taIoC85DPrh8yP
         uN8kjPBIml3aunIqwzU9V/uuw2Y5aKj5g+5iM1Y4Ab6UBDFjW+HMHkBaakvqgo65sZss
         0zdktH8QiZibbbhHd6UveIWiO7qxvAZxn+7iNgrQ1ElLsgU+vKBx2b/sLebME343R3y7
         VOz5RUa6MrnQt4EHXhlEC21vqtSN/ZvVL15P77sibxVMCBtUWcPcHitL66AVVD/MAJ7z
         3yPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774438523; x=1775043323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zkE1roP0rQTN4agoxojZxa0tqCSQLd/1PEJ1rtsPXGA=;
        b=URfBA9lEJwfSXGc4qOpuHI6eQ0y33qH1yHl3NeJi6LitLPFsVGJWduUx8tj+FCLItX
         fl5HvLoQE7NqhuN+VhGhKmLlomIlH5vxvSktjnTyPxWHZX8MKedpW1AAHxtzC/d/d9cv
         TDJHAybSbof38Tu3E24se8Zyu6/EdYNSzxZ0Z2ysb++hnij2N+GbZFAH1cLpU4jZxx2s
         JQgGU65M0FG1k5ad9jrQLmgrGeqIpFhOhhCQOSGoyIh1fkDkQyCJRPu6+ueJ+XHm2IvZ
         bkEJxJjyuhdG8dhl9qL05qy7qUhf0s3JBZL51I+ywN/hpzD82MEjjoEttFU6fPwsVC6A
         6nwQ==
X-Gm-Message-State: AOJu0YxUb+5I7we/1ycYQkzuo+ihyIS9orF8AP6SESKpIVxdygXEydV3
	MsIoRgbmrDFj11MpcjvoR1MzHYijO3vdfRrN/zITMm1bhao5K/GFNrdOdnpcJkIwIg==
X-Gm-Gg: ATEYQzyv+7dKoFPTDf+mMtBG/JjLGtP44iNO2oHyuNhgBLITQIr3C9bsP2C77T0DMOJ
	Qv1YVOKHNEQV/wgaVZH5XeDtwQwWZOpH6esiCpjpF6kbvkAEDbz6f7aw2HyzDs7kA8T+5PNthiS
	T07WBfWK2qn/bDFTPKG2gB8MNbQMXnqrw3YqPHcedItBr9aMVg4qGtp/GLLbtXqvCJmYiknlgnc
	AOgC85b9VxKNP0cspnzoluyvRf6+sNj3YFAjgLoUZHsgGHcsBdMGE/5amb2Nc8xJ4GMSw+DsFFQ
	C/o4Y4U/adHh5tt19ju3AoM1rh+UzGVQWHILapq2JjfVezrA4WZz9x7BEGnbMZ4nAA0xyJpUEyZ
	kJ7vMU3Waprmoon1CoB/y+8TJLe4MPxVPT/T8EBWKezys4w/zxniu6IylIzwCWWoegw33c/imOy
	kAfAwVMSoxKsPoRqND3VDnwTVJh2fee5e/TF4v1+HMG0nkhwL2wPNcgSLLoZdreZAHM48=
X-Received: by 2002:a5d:6806:0:b0:439:c157:2577 with SMTP id ffacd0b85a97d-43b88a055a4mr3167113f8f.34.1774438522008;
        Wed, 25 Mar 2026 04:35:22 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b86fbb195sm10280737f8f.14.2026.03.25.04.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 04:35:21 -0700 (PDT)
Date: Wed, 25 Mar 2026 11:35:18 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
Message-ID: <acPIdoA8oc7T8wKX@google.com>
References: <20260325113138.4171430-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325113138.4171430-1-sebastianene@google.com>

On Wed, Mar 25, 2026 at 11:31:38AM +0000, Sebastian Ene wrote:
> The ARM Service Calling Convention (SMCCC) specifies that the function
> identifier and parameters should be passed in registers, leaving the
> 16-bit immediate field of the SMC instruction un-handled.
> Currently, our pKVM handler ignores the immediate value, which could lead
> to non-compliant software relying on implementation-defined behavior.
> Enforce the host kernel running under pKVM to use an immediate value
> of 0 by decoding the ISS from the ESR_EL2 and return a not supported
> error code back to the caller.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
> v1 -> v2:
> 
>  - Dropped injecting an UNDEF and return an error instead
>    (SMCCC_RET_NOT_SUPPORTED)
>  - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
>  - Updated the title of the commit message from:
>    "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
>     smc with imm16 != 0

> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index e7790097db93..4ffe30fd8707 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -762,6 +762,12 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
>  		handle_host_hcall(host_ctxt);
>  		break;
>  	case ESR_ELx_EC_SMC64:
> +		if (ESR_ELx_xVC_IMM_MASK & esr) {
> +			cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
> +			kvm_skip_host_instr();
> +			break;
> +		}
> +

I wonder if it isn't better to move that into handle_host_smc() as this is part
of how we handle the SMC after all? (and it calls that kvm_skip_host_instr()
already)

>  		handle_host_smc(host_ctxt);
>  		break;
>  	case ESR_ELx_EC_IABT_LOW:
> -- 
> 2.53.0.1018.g2bb0e51243-goog
> 
