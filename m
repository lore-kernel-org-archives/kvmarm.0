Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE924B95D3
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790269509; cv=pass; b=E/aq7MZFxKuzOPA0OzAtiKGZosDnSPHB/DdmBTtQ56GbHxmjWwRjXqDNnIXI1J/H35HfHGlWSfcpTipK463XQX6ComGDLNB6R4Xj7CMPUJYe3uCdxszm1YB6tJJ3qLiYF/wO9IQ3BRW5qsn/h/4sqF5ndtdSfA+E9lWrQNK0Vgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790269509; c=relaxed/simple;
	bh=1F8/rz3ypcsoCgDUnUPkG7WkBCl4kCGuN1jCJU9T35k=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UfdxAd7NdHAKTvimgFU3WASYBPl9JmtYPditECzJ+Clf5JTHclTdfk6jD423iEBElQMqpxc+UTmEJA4xDfHMIrlwCT1vXcYM7wDIflaYcTJXD0+xLanwzkAJFR/zjNKg8NHmrhjUECt9Moh8xqOuS2sCBDRVnWaHmPGGkeiK2VI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tBdWuHyL; arc=pass smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tBdWuHyL"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-91235f46716so852566d6.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:05:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790269506; cv=none;
        d=google.com; s=arc-20260327;
        b=EwEGGD4LQdvfhoJLz1OQekg0MToPLKYUAPg1rEBPPAOpH7B5Ql23qZ6yihAjeDApI7
         ASQDmek1Xad5ARFgqy9cmJ7e3/3s9xW8EGYoMt/f1Ir20pjUwrTDL7C9KUeO6zorfsoQ
         a2ZV/HKnF3cUMaslZGEA4k+O36yV39kxjrYpydZza755MUWBzONUJxXQFzWNOHoOYvNO
         ntHDK+X3EKwVf7h6sWMVR6QdeRKT8FzlVCuofXz+l+TNyn1ZSwfFNDitLYtH1TmV/nV3
         M7iaogzsqB1nFknmBVlRj5zF4h/7zh7IG1suoQ8dRNMiYDocapilE2J/V7czfdRjHWah
         y9Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=OHcWMQ1Z3aW3bHAxm3qzvYkMiIOMbOZVWxnCDEHnj30=;
        fh=wzhmHLgbhIYtuEdd/6BLuyPmvz4zt/PjCT1/RWKQ1Ps=;
        b=UwPGNwC/7F29Y6gxqkFyUK98rDGsvYje25nRfECCx5zRYNc6CLnWt+qQvaI4/nJyhp
         jp4bV8v/yWJIbAxUk11XkZO+lz5NaPN8G91z/aowMkCIwR2rZJOXrhQmlnKWat4eyOrk
         L8xewPH4m+Z7F1IWgOGnWkkCCjp7WbGGqjXw9IHdS9S0sdtRYLLbXIc8px6nqyLT/bse
         sz26yGv9IOZc9MtwrO7UWcAkRAkIrlQ5OhPejP3OyfAevRye7s0IOHGq+aGafvSUPJa9
         7LlUJrh8R99kcMIwzd8WP85K/Pqv/gFINuA2KTV6nX4jGwHbulSzRUXPlHK3iaoDN/D7
         ugVg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790269506; x=1790874306; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OHcWMQ1Z3aW3bHAxm3qzvYkMiIOMbOZVWxnCDEHnj30=;
        b=tBdWuHyLJvA8/LxCcBoAWpCa/MF9+TfiyGey5aQL5Cdao3qhhyXUXlHe+d3Dx+hmOa
         3Uh6KMNjyWSCexLztjoisWu8H/W6/eLiht6NjiXOqGtwUkbLN9d/EBY+QQV9724NCckP
         r4GRFnsNMcdk9bVlvgPmd9GtMfAbz0Hb3e6N7TAyLSZxubfgYGl5fxvvuRfKcM5P8NME
         ivrs0vCuGxmIk45YlujdFkGFZCxmqjLh5F22B+5kvL+8L89zXXEroyVAdpbjg5NRB30J
         /sufYlzjm+BU7TCN67wlhW0OwDW36/n15D57u8+pER096ncrHRxSdTyoL+jNFjP2CPyE
         V2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790269506; x=1790874306;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OHcWMQ1Z3aW3bHAxm3qzvYkMiIOMbOZVWxnCDEHnj30=;
        b=Z0Kd3HYt5yxHqhypuFy5Kp8xUgcAzfC9XffXLFen0qvZKoVqxBD5T8WfRmTkFzYzdS
         0gCsw05JGBvHoZcL3ktC4TcqERKwz+VAwh9e0jsgBoH8ml34b3k2jJ/jzCN8S1f+tb5Y
         KVggemL1NYTpmPPoIeJhmsd6SPFzfM5ibKyRAA7/dkdot2ZZ2uNmNzdLcNGrIQUA7qwt
         yUl++F6nBlDH/KnXEk91QzjM3zOjmqZo6Ivb5v+xuQtytUll7euZPmH/qR9NIwtXx+i0
         J7iU+bgIt30jAiQu9uS2/SPlnB3XOL6VPZlS3hsFvJrVqohV7b4lkARYkjn9XVCG6eW0
         D/ZQ==
X-Forwarded-Encrypted: i=1; AKwUvByLd/VvKE/z1HXAn6G7E0VGBqYV6Ehx93nqYAjU3JwXhNrv9zs8rrXDOdfdemXdhyL9uT8V9YY=@lists.linux.dev
X-Gm-Message-State: AFuF++lW/okT+k6PUV9j1GnCOodDz4rh6YBcXolcJqwQmkBATnPL028y
	mUSf4ce1dBHxOJgR4z6t48dUx/lkU3Q4pQpRwhFbnZP9BMOgnasn9Tl2gda07zl/6kA8v0CldBB
	qwGKP3bB2OP9jrbwgHNP+uXs58PqehGQ8jPLmfdH/
X-Gm-Gg: AYBFou2Qmw9cGWoK7Rv0fVGCakxJa8LAoQ+W2d46L7GOdZAIWqx2QvdXSNSeY0DOcGs
	X6lqEE4P/nVmF5+Jhqg0pCSiY18bc6Ff6W8XUo30LqHvVNpu3ykbXYECaMwDzMEC/aX0vCX6M78
	lqogAIUTBEsdnYYChzWHFNMHQ7srpRI0FToh+hq8Bg29GIsqLshZyVF2d4kjMp4n3zgWWPCEOZQ
	e01voIwzUFsjf5SH/DVOITy/Xxob1f5GmGh6e6Y6la2OYZtuhSUB7Fp7tygqfXHI14dMiI4d5qZ
	zuy186DdqLCFrKIK6bp9/1/2S5OQXS81OzeqRa7FXoJwjZZ4OgHk4A9LHfwlGFbqJSb9jzpOMqp
	v4W9WuTub549pFu9MO0s4x1TQ5EsuQpoCIionqPPkuA==
X-Received: by 2002:a05:6214:4a83:b0:912:cec:7450 with SMTP id
 6a1803df08f44-91421b1851amr31284116d6.0.1790269505101; Thu, 24 Sep 2026
 10:05:05 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 24 Sep 2026 10:05:04 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 24 Sep 2026 10:05:04 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260924135201.850038-2-suzuki.poulose@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com> <20260924135201.850038-2-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 10:05:04 -0700
X-Gm-Features: AclHuK_DlezgNpJkyQ6-N0Dq0ZFyu15Ut5n5SPUx6_YH9nitYJ5xMl_wRWW9wVM
Message-ID: <CAEvNRgH8Hwt6_VaFxJVvytZ4La1R7bUN2emc37_fWecF9j2-YA@mail.gmail.com>
Subject: Re: [PATCH v19 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org, 
	gshan@redhat.com, joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com, 
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, 
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com, 
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com, 
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

>
> [...snip...]
>
> +
> +/*
> + * Note many of these fields are smaller than u64 but all fields have u64
> + * alignment, so use u64 to ensure correct alignment.
> + */
> +struct rmm_config {
> +	union { /* 0x0 */
> +		struct {
> +			u64 tracking_region_size;
> +			u64 rmi_granule_size;
> +		};
> +		u8 sizer[SZ_4K];
> +	};
> +};
> +
> +static_assert(sizeof(struct rmm_config) == SZ_4K);
> +
> +#define RMI_REALM_PARAM_FLAG_MEC_POLICY_MASK	GENMASK(8, 7)
> +#define RMI_REALM_PARAM_FLAG_LFA_POLICY_MASK	GENMASK(6, 5)
> +#define RMI_REALM_PARAM_FLAG_DA			BIT(3)
> +#define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
> +#define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
> +
> +#define RMI_HASH_SHA_256			0
> +#define RMI_HASH_SHA_512			1
> +#define RMI_HASH_SHA_384			2
> +
> +struct realm_params {
> +	union { /* 0x0 */
> +		struct {
> +			u64 flags0;
> +			u64 s2sz;
> +			u64 sve_vl;
> +			u64 num_bps;
> +			u64 num_wps;
> +			u64 pmu_num_ctrs;
> +			u64 hash_algo;
> +			u64 num_aux_planes;
> +		};
> +		u8 padding0[0x400];

The union + sizer concept is cool. Technically this one isn't a padding,
it's also a sizer? (same for the other structs below.

> +	};
> +	union { /* 0x400 */
> +		struct {
> +			u8 rpv[64];
> +			u64 ats_plane;
> +		};
> +		u8 padding1[0x400];
> +	};
> +	union { /* 0x800 */
> +		struct {
> +			u64 padding2;
> +			u64 rtt_base;
> +			s64 rtt_level_start;
> +			u64 rtt_num_start;
> +			u64 flags1;
> +			u64 max_num_vdevs;
> +		};
> +		u8 padding3[0x700];
> +	};
> +	union { /* 0xf00 */
> +		struct {
> +			u8 padding4[0x80];
> +			u64 aux_rtt_base[3];
> +		};
> +		u8 padding5[0x100];
> +	};
> +};
> +
> +static_assert(sizeof(struct realm_params) == SZ_4K);
> +

Does declaring this struct as packed matter? I guess the static_assert()
has the same effect.

>
> [...snip...]
>
