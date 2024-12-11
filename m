Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52D1238E23
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 12:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733920470; cv=none; b=ZHlLzAPebJzuF92yEk+VtFazM592lSzLVwRwgagsSqSbl9rOg9lXbwz0v/BIc/2XPZGj94y0vLyRh5GZi4so77Zyhq994+5Lq0pMJqBTAarMx5apncAcUX3www2x61FqYB/EQ3h238ZlV4jFB4026+mIBYKWihKE1ZA07Nw7z3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733920470; c=relaxed/simple;
	bh=6TfHgc0zUQff+agx/i3rd8oWAsQO/SIH9JYUBfgRkFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e96622W8UXBQ3g1ucpthYaGKlhxvUOD6Y3ICFMQJCLxU01PeB4P76+rlcFYcU01W3VZlQmic6pk/k7Pt86FeFzXTng3a2UXQwS7xU+Nj6/gQg2Ym5mw13IKOVzkV1osn4v2msm5tAA5HZabbFRuxHH7LCj3txsIXrSZv3lOsb68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ai2HwDql; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ai2HwDql"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa68b513abcso584022266b.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 04:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733920467; x=1734525267; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tia9vB659w6sJFo+z8gVVhw9SCVZDEDlbolaVohvnm0=;
        b=ai2HwDqlZx3n9f1mz+14a8LIS4c8QqHbiY607m7r7HHTJFrKtJbuHLQeQBU9Pg6jOe
         Fxj4iq5JVluL4uDR9S34FybWplCmdc7p6ieFefjyDkMHu43sVwBFuTuE3m7QZa4coBvR
         iFcbDrX2GsrYl+kh5BuntZp2RHP+zC7jJtDbrSi8f8kCRL+p3gHt2TTilbQhpUWUBBNx
         SIcO0Q0AIogDXFv6bkJgpcM+q2+i/mayIuAweoQjDT9NqVYCkc2m+dZoiYmkiW61/v25
         MEB1PeCOJ5DIia6x+UT1FvvWhAH6ZTZbI8qhQwomr6j4N9S4cuB3495c5opg7Xeu0Pe0
         8imw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733920467; x=1734525267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tia9vB659w6sJFo+z8gVVhw9SCVZDEDlbolaVohvnm0=;
        b=QrsMVnHXvzOrqPPf3UaXIjnCH+aKFLCK0Xytzye2GsKzXpvUBk04L/lQWxv5xaQVEz
         QlfJkuf50NuTDbIP31Y8vCNpBGHPBVNdY5WRBdnnKEidwY9lbRdUwKT05Bj87ul1x/Fj
         Vt2+BVqhqLoc/4j2QcXQTkTgp78Pdp57Un1exKpLWoOBNFLqRnB7oFeVZSN3uM5rbtW5
         RzzglL66zUC8ponDFVJZtKKmzbwzooPbQgB7XRbAgFOS3tPgdP9gwS9t4mmi2z1jbnx1
         Z0SALlXsabvoa1kdXwg+LY2kJNODN8SuZwJWq5GPyCjooSl5xJ5agVtcGVgRlEceCtXc
         7lSg==
X-Gm-Message-State: AOJu0YzgR8cZnTc9jxjRc0M3PKE5m+/RYxwdh8NvBrDa9807WQaYT9Ae
	LmUjpBPXPnwB7QYYGfcjKusBx5rf3sssuAUypE947hgyIOLz0oPP5QWl71mATw==
X-Gm-Gg: ASbGncvJLMFrpJpxaQO/Z+/DVBJcltCwIkND5sHF8eI89FViZhOyijl8HnNP8KMTBk8
	gpDTwYbD7gvIslQT+BOWeQ2X3xNS5BOB35RcOJbEvuCY4NN2Kq1ufv4Pk8+WdeK5eG35lx+UPB3
	d7Hbhbk8Lp6MyW9mUSTAZphG2dcweHgf2zzxc+8+z0m165WjJjWZ7BxiNSiibsHfdxAF3RKOSnO
	QvYHPS6SOPsvZHd2MdaC+gpLv1EZyOVwaQ6ljSNVZr5z+rw6nr8VCxmv5MUd0XUKmQf7yczVOqH
	bOGDJ9DGqUFl
X-Google-Smtp-Source: AGHT+IGfijMMKjuLwCN4FI28W1IXgWX5yc3a7561qwngrsOIMBdubzqnGhrHwul9v673IkWy4GJKZg==
X-Received: by 2002:a17:906:599c:b0:aa6:b5d8:d5c2 with SMTP id a640c23a62f3a-aa6b5d8d624mr173985366b.41.1733920466577;
        Wed, 11 Dec 2024 04:34:26 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa683a0a736sm487811566b.142.2024.12.11.04.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 04:34:26 -0800 (PST)
Date: Wed, 11 Dec 2024 12:34:23 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v4 07/14] KVM: arm64: Rework specifying restricted
 features for protected VMs
Message-ID: <Z1mGzwZqVQCWWSTX@google.com>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-8-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202154742.3611749-8-tabba@google.com>

On Monday 02 Dec 2024 at 15:47:34 (+0000), Fuad Tabba wrote:
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f333b189fb43..230b0638f0c2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1422,6 +1422,7 @@ static inline bool __vcpu_has_feature(const struct kvm_arch *ka, int feature)
>  	return test_bit(feature, ka->vcpu_features);
>  }
>  
> +#define kvm_vcpu_has_feature(k, f)	__vcpu_has_feature(&(k)->arch, (f))
>  #define vcpu_has_feature(v, f)	__vcpu_has_feature(&(v)->kvm->arch, (f))

Nit: I see nested uses the raw __vcpu_has_feature() helper, so I guess
we should try and be consistent. Either way works, we can do the same
thing in sys_regs.c, or convert nested.c to use kvm_vcpu_has_feature().
