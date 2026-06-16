Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41C735C1BD
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 12:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781613633; cv=none; b=AScJWFz78j3Bm3EuPRBUjLhIX9L75UhBXEp08TNH1uwi8ziN41cIluhZME4cJ8mWmujmjB43dJI1KBuA4P/MewNHjV3uGufA8zp3shHZWHfLN4zv/SwQaWyNL+vHhOcjwgrLGCjaGcC94+FcVst69GDLXBP8IreYO1vF68ICQt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781613633; c=relaxed/simple;
	bh=+zYPb9QpAEwlhsEkXT18Zv+K7ppCzOTN3pVgB9pUMBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzZgbj7OGunihtE7R64tURy8U8chCmZrS+RDaP6Jky14WD/VSxT2dF+D1GtU4IWgJtR3vzWLoQ9pDYPK6m0ZM306I5TJAV04wJEdDKu2r+bCRSy6fBmVL6rndgz3xu8qNO6XJTE2DDscjEseFiFgRhqJYYEC/Vrav/2cFyM2K4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iJbhVsIy; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iJbhVsIy"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490b4a8e28bso33673685e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 05:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781613630; x=1782218430; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9bkaQdVB1icoUbZrrnd4GITgcdZYxSW0MNtl1DcuHmc=;
        b=iJbhVsIyKPzI6EOq5x7h08VQqrcEgfX41Cqk9FKgSDHx+9s8dY0EwmqZapkBulAuHO
         D+mnREZiSZAaioyWnW0PQxEzpAHXwBCq+BMZCZnH3iPibhMyVN0AwY4hCxcTUnpaqTYE
         DkFuXvHQsUOvAxVJVsU8og7YCHngHOTPFOyRQiYc3QZ0aNze6j4IRs5MgZXb4ajalo5M
         pgkAT+Q9eWnAqmtNUiXaeR4Q0F8eNsm1HIyaGZZ5fv+rxbTU9LhXsPQiv+wkicaM1U1M
         sdoi2VBNG0qZt931IdR+pZ+/OYGaS3WHhd8eJfKwonXDQ/YmninhIRdkjvCC64Cz8+ZC
         KQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781613630; x=1782218430;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9bkaQdVB1icoUbZrrnd4GITgcdZYxSW0MNtl1DcuHmc=;
        b=BdlO4HPvnFvPWqHVSKkmwe2/sxEBUzrXV19urDT44V0OwjztkyQoE1IvT+gl9O2Sug
         h6ZkZKiHECjhb9L4Uth9qjmFwbfiJJ3JtT6t/TCweeQtkJgywnwumdsJYmiV31cBxEqh
         D8eCIYaW0rHF5XXqmMEZv1ClDWzLc9aVo7rFY69UcFT3LrrIMnUl1wVTpUeEfrJcTKBW
         0gUWpF9ZYoCGOFMNAwQ9LI6WSSP8c/69VVFrIzwUmFiJaVWJkd1hdoPuGQE5xkvPV5wx
         DF13mFgII8/T36LWLyURcicVIAr9QDvRX6H493oQXR25WSbU2ODLG1s/eWAeSfr6wTgw
         2h4Q==
X-Forwarded-Encrypted: i=1; AFNElJ/0LLdxVrGjkEfQh+x8myI7vJ/1oEQ9YFMxKntsXr2PPPk9Q6rUfdlCcfCNBGV/yqBpHYdjUs4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfpkjSWmYs0TtSBUVmhEoXtN43qrJL4s7J5NTUytJTqOD/J5mx
	Zl+6a3aecCHRp0qDPb/D5M6graBkXela2mFlVDSqsQ1/LXcmqbjfuEw9kEpNixlJaw==
X-Gm-Gg: Acq92OH8l9CxI4skonaq+EefdicpNe3PlzQffetJgM9IW6taI7E8TAv5I//uvabKARF
	xywQdqPypaN72+8KHlsO8kgjNalsoA+S8esD4l4k4tmVVKxBajLMorbPmQqcC+jiXREq/F714Xw
	bsisH9U5xMsDyLQqAn08b7IkwgF646fHt8+0Z1k+jTuNQYdrEyKv1jwFBa9WHxKQV7UkGrFyMDR
	nbQp+s8oFlbA1mm087NqLhMj66mS99dLu5j272yDf4gEAmlUKLNP71IWwRpQxwSmTEljeB4XtO+
	NGu7XWfaISin3Qt24Av7ysr0HICtbYxLZYqy28W7eO8XwKXPf6ALWUMfxVv4TKgodoFHR65zlls
	ZKU9E7Kw2qEujOjzgSggJbGn3XZFEUomqsThmSRKl1iZRrdO9JXic/9ixYus6ER8Zt6x1tkuBIA
	GtYrne3pShVUILP044vK5nVKThbgN0EdXlwupT8gCM04TU3WuSHcAeNVta5s5mpZvj9Bs=
X-Received: by 2002:a05:600c:1396:b0:490:c032:ae92 with SMTP id 5b1f17b1804b1-4922ffc87c1mr50927645e9.33.1781613629590;
        Tue, 16 Jun 2026 05:40:29 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a96d14sm54054125e9.12.2026.06.16.05.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:40:28 -0700 (PDT)
Date: Tue, 16 Jun 2026 13:40:24 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 1/7] KVM: arm64: Support
 FFA_NOTIFICATION_BITMAP_CREATE in host handler
Message-ID: <ajFEOK3bVu5QRoCv@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-3-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616105417.2578670-3-sebastianene@google.com>

On Tue, Jun 16, 2026 at 10:54:09AM +0000, Sebastian Ene wrote:
> Allow FF-A notification bitmap creation messages to be forwarded to
> Trustzone from the host and introduce a helper to check for SBZ
> register fields.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 36 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178..b1e5f9ee86ef 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -71,6 +71,18 @@ static u32 hyp_ffa_version;
>  static bool has_version_negotiated;
>  static hyp_spinlock_t version_lock;
>  
> +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> +{
> +	int reg;
> +
> +	for (reg = first_reg; reg < 17; reg++) {
> +		if (cpu_reg(ctxt, reg))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +

Hum, there's something a bit weird, as this function was introduced already in
the previous patch. (and both have the same number)


>  static void ffa_to_smccc_error(struct arm_smccc_1_2_regs *res, u64 ffa_errno)
>  {
>  	*res = (struct arm_smccc_1_2_regs) {
> @@ -676,7 +688,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
>         /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_BITMAP_CREATE:
>  	case FFA_NOTIFICATION_BITMAP_DESTROY:
>  	case FFA_NOTIFICATION_BIND:
>  	case FFA_NOTIFICATION_UNBIND:
> @@ -862,6 +873,26 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
> +				struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, vmid, ctxt, 1);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 3)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (vmid != HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args = (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -920,6 +951,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_PARTITION_INFO_GET:
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_NOTIFICATION_BITMAP_CREATE:
> +		do_ffa_notif_bitmap(&res, host_ctxt);
> +		goto out_handled;
>  	}
>  
>  	if (ffa_call_supported(func_id))
> -- 
> 2.54.0.1099.g489fc7bff1-goog
> 
