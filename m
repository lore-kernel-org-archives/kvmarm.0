Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F002BDC26
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 06:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784096954; cv=none; b=d6VP3ycnWQPJ4sBMp/8nFkFg14QLYO29j4nqFx+6SZUsx4xBH7AAV4dP57PbMLXcawDscEVx/H5GbIhKNR8Jg5pBnJHAT71fK9/pX3PypXfggbWiFU8SVndHsJ1PspGnnZ1Lr+or7g8NfKTQj/kD9U9SoBeJDnHTHH+AP+EscKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784096954; c=relaxed/simple;
	bh=blIVwwmkQUYplqZOvB7hE/t6rdKn6RDU0ldgx3zBgyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uDwCLj1iHVS1EMSE2YwHYPsPcXWEoG8CgctoVHO/yk3sIeSuXQe7v7NBMFpE/yuvgGehOx62ohgMZ2RPLO0D7C9JYpPM++EV3ilxMUTM6CWCBDAsWCwDzFvodbDd2ENxaOxKr0UDNFsGgGr3gZEWijI3P4GjgNXp/PfnaV6znbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o/6dLxkn; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o/6dLxkn"
X-Forwarded-Encrypted: i=1; AHgh+Rqzdk4crbNE4UXRa1VjJSzKE1GceZxh/bMDIljJPow7fQGJVjSO2sxifiXaacSNdSlmSzUgzg4=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784096950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6EkGPun7Mf1SwMti55JzBEC0aSDCyjyMtJCBge++9uc=;
	b=o/6dLxknLx12EJSSHGZhUloAriu1lpLWZcJci27ByOPHnLS7XxcNZyAQcz1NxQL+yS2zvU
	pUPZEB153DD+Kd3dIrSxGTpOz1Q9dvprkR9K24E6ituzpck8KDTEj3YDwnda1SzIlY9t+q
	TgG2rhehB+pJNh6Xmfm1+j/TI0m0zXI=
X-Gm-Message-State: AOJu0Ywba31RVc8dbn0rvgUPPPuVybWHO7yW0Aw4JuDfmjpQNiovn+uT
	VnSu3OsjX9UShkUKkNL8sNPtnnlbdN4jm33Zk6wfCs5OiHUb90bCyzrpf0G8Y/INNQ2t7nUxLln
	8alZC8SXYiENxiZY3evdaXS92cLyL6BUqTkK+Dk0k
X-Received: by 2002:a05:622a:2590:b0:50e:38f0:ccb2 with SMTP id
 d75a77b69052e-51d7bd1d6damr24365831cf.15.1784096938033; Tue, 14 Jul 2026
 23:28:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-9-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-9-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 07:28:20 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzCaEnOJnbDk_9GTo1N0U95zFTEw-HGyBetx3RkOfX4wA@mail.gmail.com>
X-Gm-Features: AUfX_myt8i1XINmMoG2MOijeMuzd2suULSaK515-nalLslNoZEiQ5HOO1OeJh7I
Message-ID: <CA+EHjTzCaEnOJnbDk_9GTo1N0U95zFTEw-HGyBetx3RkOfX4wA@mail.gmail.com>
Subject: Re: [PATCH v2 08/18] KVM: arm64: Handle PKVM_HYP_REQ_HYP_ALLOC request
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Introduce a new pkvm_hyp_request type asking the host to top up the pKVM
> heap allocator.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 0be1469e7874..99daa985856f 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -205,6 +205,7 @@ struct pkvm_mapping {
>
>  enum pkvm_hyp_req_type {
>         PKVM_HYP_NO_REQ = 0,
> +       PKVM_HYP_REQ_HYP_ALLOC,

Now that the enum has a request type the tracepoint can actually fire
for, would you be able to print it symbolically:
TRACE_DEFINE_ENUM(PKVM_HYP_REQ_HYP_ALLOC) plus __print_symbolic() in
kvm_handle_pkvm_hyp_req's TP_printk, so traces read HYP_ALLOC rather
than a raw number. I'm referring to trace_pkvm.h from the previous
patch.

Cheers,
/fuad



>         __PKVM_HYP_REQ_TYPE_MAX,
>  };
>
> @@ -226,9 +227,13 @@ struct pkvm_hyp_req {
>
>  static inline size_t pkvm_hyp_req_arg_size(u8 type)
>  {
> +       struct pkvm_hyp_req *req;
> +
>         switch (type) {
>         case PKVM_HYP_NO_REQ:
>                 return 0;
> +       case PKVM_HYP_REQ_HYP_ALLOC:
> +               return sizeof(req->mem);
>         default:
>                 WARN_ON(1);
>         }
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 5ba8b81b8c6c..adc418076cb0 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -626,6 +626,9 @@ static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
>         int ret = -EINVAL;
>
>         switch (req->type) {
> +       case PKVM_HYP_REQ_HYP_ALLOC:
> +               ret = pkvm_hyp_topup(PKVM_TOPUP_HYP_ALLOC, req->mem.nr_pages);
> +               break;
>         }
>
>         trace_kvm_handle_pkvm_hyp_req(req, ret);
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
