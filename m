Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AA71A304A
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 02:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774924874; cv=none; b=RKh64J4vlJK6BitnZYXc5GCBi5mLYwAnb0/TQCHtkjz9tYstKCaHglBcMyUX8pQCOrL1J/zhQLL8gI+Ab+Dr4QxNSPrfnpufPvEJjrB3Lo/m+MxwYDt/VltWp17xcBrFEP0AopySTCMaB+hOFeHlxyhaGtVYY5lNf9S4VNPjgS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774924874; c=relaxed/simple;
	bh=ObRxpbE/eUS3h8F3m+U6Yj6wv+FCD3d3U1SDjVIZ6jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7yv4RmT1JZakLFaWTW6U5gbxbphLyVC/l1z3maYmE1dUWaUJ28yUa5/G1NjXMy2tu/F3bjrR967JaMw+90CEROuB36qM963ZjihszUF/ZGdi0mFmD92YAgy5izNaJ/BmmZhfEEOC0UxQ/SVloB7xrI6Toh1ubE4Tyiuug2/Wu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aPqBRjBx; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aPqBRjBx"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-486fd27754bso50915845e9.3
        for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 19:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774924871; x=1775529671; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LXnJaJoemcaiDGH1WZmG/hzLsuogYk0N7x2l4+nhrvM=;
        b=aPqBRjBxL55uVoZgfy3Rk9jrKOhDOf+7EoJHdlMTVb2+5rmJjEy0V9np2wfAHgQGVT
         lW2TKwFCByg7sBDlFlHRzvHYUCbDs/CNy5FdLPSdf5/Oc64bdxCScmTvZpi7oxxWrjZ1
         pCuyCwFfl4/fnFi9FjIj5HEIDHKQ1lX8M9LFIhHRhIr+N1UxoOq/LexXLaAnw0haij9p
         KudDGG8llSSff5iyWgBRRPtRbUHl1FqejvK9TxDmDt0TWjZDHfJdN9RmzV2JRaV6xECX
         bXqqSpLewGMSwez3vFo1msTYCSCtMtWHh9yESKmpmhtbOv0YKI3GgH9hQVzoIEjf32th
         QTig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774924871; x=1775529671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LXnJaJoemcaiDGH1WZmG/hzLsuogYk0N7x2l4+nhrvM=;
        b=A978465fXk+f1cT/6JFBCRIarO5NMJCvXQqwvxvpzi7lxLg6sN/KHFN7LR9rx8gUhF
         vSmYleSVqKtsswX9X4ArTImKx9W1mz6HD6kY+14vK6a5nRuRnAubbG1c3ZcY5YVhwjhy
         TDE5wWj0Fy+5Wqo9hzYfHZWXZUNikweakEMmemHV32PurDZF+lEM0HVWTB40KmVBK/1Y
         hMF+fqdvRXDtsYYOz9AY+uUY650Yls1l4Ik6RF6V/CnySnxh8/dggzAqb+0dJ7BsgnPq
         DghgzB4pub8xyVWPXX0iZWNrv8YbZpDvE5ntF7Y6FNKjEp/Y2nmma+2sJURESzh9a0PY
         Q8Xg==
X-Gm-Message-State: AOJu0YzATrORbzIrG4T/4L59PdF8Mm9PgljIpZSHRVZUucdtBB76fD4D
	i12ACTkzE97hV3YV3ndz9eq/ghscR4cq7QSoBwzZZ/mPq6zMAdsAhNIKfJcA48KXFA==
X-Gm-Gg: ATEYQzwnXkcKMZEq2df2ULKlLRGfeXDvLxGfhU/OJggpjVPoBehnHEjIGmWWvTrly6X
	QSsDRsAN1TkznY65n3uVlnqJqlXoLp7j9pCXL7K9ObuGHk0iZ2u6vlHK19gU7TYU1Jw0L1oq02z
	bhpb3+er6M0iQYxSLFRjeX0j6DM4qOhThRPbfb5IIlqzHpou1ym5jftNVPu9vy+OAXyQHuqIz3R
	Gsq6vazhG2tTkqwxSz+4/zY9wHSj68qbxUHVk+E6GhXvwrk2xtSjqX/7NETjbD5sP49P9r79QFs
	dMcsk0kDHhhxCJHnSrWZU9JQvFj2XPcDCBTqA3pVl2n6v50FpkK8bf/xBjoIr1/w1juHJ++nMYt
	/tF6EXBPLV9W+jetKNMG4tLkqJOiczBgWL9QYUyc+smX8cAl8PZX22tfOlgo4UJNN5z1RTYs5os
	rQtRgjf6hzXYTf6NPy/TCn8Sd1NTdXXsTp4nEqJySnDE9EYhAWo1d0McrVCag/8dm8Wzo=
X-Received: by 2002:a05:600c:c090:b0:487:338:b4df with SMTP id 5b1f17b1804b1-4873de6ca3dmr61799345e9.15.1774924871032;
        Mon, 30 Mar 2026 19:41:11 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4873062ec9bsm219312745e9.7.2026.03.30.19.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 19:41:09 -0700 (PDT)
Date: Tue, 31 Mar 2026 03:41:05 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH v3] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
Message-ID: <acs0Qbjfdmlkvd1e@google.com>
References: <20260330105441.3226904-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330105441.3226904-1-sebastianene@google.com>

On Mon, Mar 30, 2026 at 10:54:41AM +0000, Sebastian Ene wrote:
> The ARM Service Calling Convention (SMCCC) specifies that the function
> identifier and parameters should be passed in registers, leaving the
> 16-bit immediate field un-handled in pKVM when an SMC instruction is
> trapped.
> Since the HVC is a private interface between EL2 and the host,
> enforce the host kernel running under pKVM to use an immediate value
> of 0 only when using SMCs to make it clear for non-compliant software
> talking to Trustzone that we only use SMCCC.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
> v2 -> current:
>  - move the ESR decoding of the imm16 in the handle_host_smc where it
>    was supposed to be
>  - updated the commit message to include the reason behind while we are
>    not doing for HVCs as well
>  - updated the commit message to clarify that pKVM is not handling the
>    imm16
> 
> v1 -> v2:
>  - Dropped injecting an UNDEF and return an error instead
>    (SMCCC_RET_NOT_SUPPORTED)
>  - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
>  - Updated the title of the commit message from:
>    "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
>     smc with imm16 != 0"
> 
> Link to v2:
> https://lore.kernel.org/all/20260325113138.4171430-1-sebastianene@google.com/
> Link to v1:
> https://lore.kernel.org/all/20260324135728.3532400-1-sebastianene@google.com/
> 
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index e7790097db93..461cf5cb5ac7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -676,8 +676,14 @@ static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
>  static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(u64, func_id, host_ctxt, 0);
> +	u64 esr = read_sysreg_el2(SYS_ESR);
>  	bool handled;
>  
> +	if (esr & ESR_ELx_xVC_IMM_MASK) {
> +		cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
> +		goto exit_skip_instr;
> +	}
> +
>  	func_id &= ~ARM_SMCCC_CALL_HINTS;
>  
>  	handled = kvm_host_psci_handler(host_ctxt, func_id);
> @@ -686,6 +692,7 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
>  	if (!handled)
>  		default_host_smc_handler(host_ctxt);
>  
> +exit_skip_instr:
>  	/* SMC was trapped, move ELR past the current PC. */
>  	kvm_skip_host_instr();
>  }
> -- 
> 2.53.0.1018.g2bb0e51243-goog
> 
