Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84CD3644A2
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781615182; cv=none; b=SZGCXVrAFJS5QF0XemcPd4/eyQuabaW9Wqwg81Ph6bLtqEMj6vBGwJvDDl+/wNQgCvlksc+dq60B3D9OLdQugrEnjwgFcQKohyFj4rfbljJ1QEfZ+OwNhOYNFLwwt/H/BVRvA4ZAvFO354q8L6z2GjwGsAlrH/T8ryDGvDWvxW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781615182; c=relaxed/simple;
	bh=1LzCSrcwoDPbXsWcbplaeIlKCaf6O9hUMjJNmMKJDKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SyXBz11wGEIPzqKaoagzP7XpX8je7for53/XmEZg7dqY85Ir6PNkzMeW4Srq/My9yEyK/ftm6Eb+1LUzx9BzCAm54IxHzjc4ZN4ulqWJzh6nR/MZlW8WPZeAzB6+jdZfJCp5XlNv7L0o55XDNot/2pVa6E4BOHVbMPel2bL9DO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g/ROFtD2; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g/ROFtD2"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4905529b933so44878665e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 06:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781615179; x=1782219979; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QnzW1lCgZUE9U3suyJwPj7ScgyD/az5VlYfMmVApb6U=;
        b=g/ROFtD2/bX75MQ0w7BsoLs4bPPMPkHeN1soU5lkTAsDgpmv7Z/SFuh2rzfwImQyoo
         bmTrnC+5/DRNyDpXE/TjmAuNOF8zjbZtP8a1pORhpVFuAbz9kvoWlrgk8MDh7Q4xJeFF
         x+fXkDRtuiVZK9HtYNc5dF3oAzM2NJseEX88tiSFvpy3F1yqaA2HwNETnDcSMatj95kN
         r8EIOiosjmEkUok7++c4kveVbcbLGrbyvBP806a6naRoTfnaDCj6XBp3QPZqDQC9dXk3
         H8MUWoRowJ3RVAGmUuzySfKWbcuQDCwIlH8EkBZo/GruID/2f3MARNYJ7JiQBJ6Bv2up
         G82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781615179; x=1782219979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QnzW1lCgZUE9U3suyJwPj7ScgyD/az5VlYfMmVApb6U=;
        b=e5OG3EtgFIamrALmgYWvx2/RxecaaiwU0uuVBh2mzGxTF73x/serF6WBCSPl8ZUS+B
         BXFDwcR+asL2ea8MYnvDEKcaIFvhXr8bHAU2B7NR/AdeQ75a7+GAAU7g1rFAZJ+5XLUq
         vR/RQv9MyWT5P+WOlRbgqR4If9p6NuEVA966LhcoxNz/6pPyoXKJRSBbC76ZaCrgXA3X
         HmubGTS/tF5/gjzUiwBLK8jEarw6YwR8DJ0qlbXWP+xKY9vW7c3Wy5FH2pKzm+PnJM7H
         ihT4IWBv6TsUAG9kN4+SIZWKJyWhkses9o5bKBfy4HDg/1uFnRVDU4dWA2CQIj0qFOOQ
         8yqA==
X-Forwarded-Encrypted: i=1; AFNElJ+7Vbw/LRK6kg59wGXE6QCAPZun47DlpA9GHynd6c3jCkiKmnOGURIjL0VCmA5wsm5Cdr2fxdk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9lR0hRuC4PvmFuJaWc2c0hWZMpWRA+o/EKjLCLWU6YRC7CLgv
	iA+/Aas5gu8DZ7WntGZVrsPaKz4B9afsBIvLGt0o18kZpjO9QBHD0UyYesYHTaj66A==
X-Gm-Gg: Acq92OF1dhCHuUM/of4TFqw0F9YBcRjCE9L4UIKXIZtsoVcEfcbyBWkrmPwm7Or3PAi
	iQkqVlpswt7WZT86+DKa6NiIGyVvuY4KUX2fHugJksx+E5sT6/McylHXHiJ4tqTTNGdug8SxFTf
	lpHJkY6ToCdea5ZdLW8TernJXB0xg0p1kQ67BYMN0Bt0vrYaW5LU7lqNn5GLYxKwd1RV8s+AxWi
	f66mEvFw+Lgu/5xbGtNxBGQRDSpVoNgWCOXeo550QvDKWuSci5ZNDOSmPsUHd9P8erHgn8fJHrC
	T4utLJ0jCD15buZp26YLWBc8N5ynElIC2W6YQFjAimyho7rXeH8xN4xBK7c69dSwv5AJdL6dRIC
	bg3MC3TsD7I8VKwv4zECnt9tvxYaGKGlmBQpHl8fP5Roz7D8pA8Qk1NBoVtB1alPrtR1WUPJQ6l
	9N3FU/cxq6Q2InL3R2U3TjRBot8kUX8h9z7AgH73gxozqBCJkluKr1p6LRRSXN7Ztiqmw=
X-Received: by 2002:a05:600c:46d1:b0:48e:6db3:ff3a with SMTP id 5b1f17b1804b1-4922ff7bc90mr57743445e9.16.1781615178301;
        Tue, 16 Jun 2026 06:06:18 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa47ce3sm88174375e9.6.2026.06.16.06.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 06:06:16 -0700 (PDT)
Date: Tue, 16 Jun 2026 14:06:12 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 3/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host
 handler
Message-ID: <ajFKRFj8vp_KqrNc@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-6-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616105417.2578670-6-sebastianene@google.com>

On Tue, Jun 16, 2026 at 10:54:12AM +0000, Sebastian Ene wrote:
> Verify the arguments of the FF-A notification bind call and forward the
> message to Trustzone.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index dc7496ec295f..3d8ed829f558 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -42,6 +42,8 @@
>   */
>  #define HOST_FFA_ID	0
>  
> +#define FFA_NOTIF_SENDER_ENDP_MASK	GENMASK(31, 16)
> +
>  /*
>   * A buffer to hold the maximum descriptor size we can see from the host,
>   * which is required when the SPMD returns a fragmented FFA_MEM_RETRIEVE_RESP
> @@ -713,7 +715,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
>         /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_BIND:
>  	case FFA_NOTIFICATION_UNBIND:
>  	case FFA_NOTIFICATION_SET:
>  	case FFA_NOTIFICATION_GET:
> @@ -929,6 +930,32 @@ static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
>  	hyp_smccc_1_2_smc(args, res);
>  }
>  
> +static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
> +			      struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, endp_id, ctxt, 1);
> +	DECLARE_REG(u32, flags, ctxt, 2);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 5)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (FIELD_GET(FFA_NOTIF_SENDER_ENDP_MASK, endp_id) != HOST_FFA_ID) {

"A Receiver uses the FFA_NOTIFICATION_BIND interface to bind one or more
notifications to the Sender"

Does that mean that if the host issues a FFA_NOTIFICATION_BIND it is the
"Receiver" and not the "Sender"? 

(Same for unbind)


> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (flags > 1) {
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
> @@ -991,6 +1018,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_NOTIFICATION_BITMAP_DESTROY:
>  		do_ffa_notif_bitmap(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_NOTIFICATION_BIND:
> +		do_ffa_notif_bind(&res, host_ctxt);
> +		goto out_handled;
>  	}
>  
>  	if (ffa_call_supported(func_id))
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
