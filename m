Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1173EBF15
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074918; cv=none; b=DHeCHyrLFEeNLVcu+GTEeoZG4/WssR2taZn3b71tGwYxrnBTAcCw9UkPh86k0lEnLdvY9PQX48cRrGezULGWtozz0vEwYCXs7KGdF8n7WXTRwXI5pdtvDWgdYJc/LvB825ZO5wBxCDzNbXglOG/t5HfesqKmjTo9pAogH6T7ILA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074918; c=relaxed/simple;
	bh=Vzefwy+FmvZ4/SyohLy5EyBfQ7O9LgW5bNYkr6/E3d4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lm1oABMwfGsqi/Qu/0yWLJzYAWkp0M/lzswrBU8UWojbY3+O+LBDkW4rDhrOVhqXkBS3494ilxLwjIcQoX2yNwhW660r0ck6IRAZfFgpo1efS5ftNGA1s9EJa+oUUDi12evB4ajIEOaa2IyUtQ7vvN08vOY3agle5949HP6AD5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bbRhGa3b; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bbRhGa3b"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-470174001a0so234616f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Jul 2026 03:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783074913; x=1783679713; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wp+fsHhsX4lAKb58gXPJ8tba1DU/IH/qxP9n8Ckh7NI=;
        b=bbRhGa3b/jwVdAyb9aoDYxEdwqyVXw3yA2wmaS47VKG10nVB3iEH1vxd03oAt8vF1I
         7wP89/MMTtHuPxqru2gUil/wQls81mLVYMte7VF/asi6NTZzIiDT6+ICkKTCjws7/4+d
         xtSjehSFTuwFUQWxiS3a5PVPfzvyxk+rCH577sYDMQsJa1csdfcriGBbSl2qZG/IYy5I
         Zc0KQ8O0/kgC9B4R58fAuKuJhiaTAdPzVgPzhsq5QmieUT/ZV5tAhdwugM6icb0cYJxW
         Rr3BmfjA0w6P/4AD1pRWgAwssnqDqm/pXnM7TvpvPPJe0V4uF+MXG7Kt+wl3D9NSy77a
         IzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783074913; x=1783679713;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wp+fsHhsX4lAKb58gXPJ8tba1DU/IH/qxP9n8Ckh7NI=;
        b=j+U+k5QFA8JRNv/RIY4ItqRPiOx+611ioJ4z9U6cs8knDykc9g9tmqwT6FN8mpYSJs
         o1YnliMvMXiMRIxldHfp6EdAVXzZArw3TKIPBUTFREZqhpNXeNjfm8tCQq2T455r7YBY
         TaeCC9ma1SMHkUd1wauxERe7jr+YAHHNszSVNqVVd7Sq3qQolvngMxQEVzk5y8T+TeyY
         fmRSbK5CRM210UZRmGBvYDqrN8UqgD2fySYqvrLYl0xnYorltUj+1eG4CViAIWVpKuc8
         o6TH8yCLZt4ip2pmRZYtUkZ6wFpdnXl5Wnn9F8JQEnunD2f2FFDFj4wwvLSCT8lQ6N5m
         t0Ow==
X-Forwarded-Encrypted: i=1; AHgh+Rr1Nhn5Kz2vt4MH+ujTu/BGZT2gtzdDSzs2YCzURhHmfiPJt2RpIYOUwcWtbO8+/pQ8xJvJQeE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUGvx3m8ARAnl3kXMAZ+pSRzf6Ax8+XpOYjjXVXzvzYL82pv7x
	BLss0LyjZ1h3m7TtFY3PU+yXUQcyYYDlpGaM/54V4kQwBp2X5y+oJNxdbO2KZ0KKZQ==
X-Gm-Gg: AfdE7cmjzDxpOCg63gxb+qFAsYq1Zivk4XSLeRcqNY4a+TI+vmaUElNv2RAoiC62aIm
	qWMqdb+99S63yp2UIoUMJb850AQvqRcYsqhGOPTFy413/7OdOp2RzGuDgdXjhcKqbN/IRh2wXMh
	6zSPgIsbPLHZ6Jal5P3R4W1T2/GrKerrZGekImXzgkwjzFxxjk27B4iqjA45Ibm9eI1vYGQ5D/6
	/hXFQQYHm06+rQUeVJ+aGus6oTMWm+5SnagaOezaXCzoTQoHxEg+kCaUQfDSnRFwt6IcsnDO517
	u0CrN9j3QP0Z6KBiFN7sUuIZxSBxO2UvdEnf/SloaYE1rjQ9QYLTfrSuvJ3oa9Wt19YXvwebiio
	yAHSjc15K4JDdUg8GTve5cjigWWSDvOeWcHeM14sww+J7OiHI6XUA0CrNod8GRqtuqVOzCzlx7Q
	1zkxrMgP4yZ+vSFzOcCeoxsP0JswEgfPtz27uVMIe3ocHxoOUl3GoohqZMijtlug==
X-Received: by 2002:adf:e106:0:b0:46d:d693:88cc with SMTP id ffacd0b85a97d-477b5489f5cmr8754455f8f.47.1783074912560;
        Fri, 03 Jul 2026 03:35:12 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-477de3dd46asm18021822f8f.36.2026.07.03.03.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 03:35:11 -0700 (PDT)
Date: Fri, 3 Jul 2026 11:35:08 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org,
	will@kernel.org, jens.wiklander@linaro.org, joey.gouly@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	maz@kernel.org, mrigendra.chaubey@gmail.com,
	op-tee@lists.trustedfirmware.org, perlarsen@google.com,
	seiden@linux.ibm.com, smostafa@google.com, sumit.garg@kernel.org,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v9 4/6] KVM: arm64: Validate the offset to the mem access
 descriptor
Message-ID: <akeQXIY_7Z0v9ouR@google.com>
References: <20260702103848.1647249-1-sebastianene@google.com>
 <20260702103848.1647249-5-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702103848.1647249-5-sebastianene@google.com>

On Thu, Jul 02, 2026 at 10:38:41AM +0000, Sebastian Ene wrote:
> Prevent the pKVM hypervisor from making assumptions that the
> endpoint memory access descriptor (EMAD) comes right after the
> FF-A memory region header.
> Prior to FF-A version 1.1 the header of the memory region
> didn't contain an offset to the endpoint memory access descriptor.
> The layout of a memory transaction looks like this from 1.1 onward:
> Type | Field name | Offset
> [ Header | ffa_mem_region  | 0
>   EMAD 1 | ffa_mem_region_attributes) | ffa_mem_region.ep_mem_offset
> ]
> Verify that the offset to the first endpoint memory access descriptor
> is within the mailbox buffer bounds.
> 
> Also, fix one hardcoded sizeof(struct ffa_mem_region_attributes) that
> should be replaced ffa_emad_size_get() for compatibility with FFA v1.0.
> 
> Fixes: 42fb33dde42b ("KVM: arm64: Use FF-A 1.1 with pKVM")
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 27 +++++++++++++++++++--------
>  include/linux/arm_ffa.h       |  7 +++++++
>  2 files changed, 26 insertions(+), 8 deletions(-)
> 
[...]

> diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> index 033c630b271b..e71d83ee0aef 100644
> --- a/include/linux/arm_ffa.h
> +++ b/include/linux/arm_ffa.h
> @@ -421,6 +421,13 @@ struct ffa_mem_region {
>  #define FFA_EMAD_HAS_IMPDEF_FIELD(version)	((version) >= FFA_VERSION_1_2)
>  #define FFA_MEM_REGION_HAS_EP_MEM_OFFSET(version) ((version) > FFA_VERSION_1_0)
>  
> +/* The layout changed from FFA_VERSION_1_0 and the region includes an
> + * ep_mem_offset.
> + */

nit: Coding-style.

> +#define FFA_MEM_REGION_SZ(version)		(!FFA_MEM_REGION_HAS_EP_MEM_OFFSET((version)) ?\
> +						 offsetof(struct ffa_mem_region, ep_mem_offset) :\
> +						 sizeof(struct ffa_mem_region))

nit: Could avoid the ! by just swapping the two expressions.

> +
>  static inline u32 ffa_emad_size_get(u32 ffa_version)
>  {
>  	u32 sz;
> -- 
> 2.55.0.rc0.799.gd6f94ed593-goog
> 
