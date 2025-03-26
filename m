Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A7E1547E7
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 16:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743007476; cv=none; b=uHnXR7rThbKzF3NakLvWjzngVcYCmRfhyliEMXX2PwmXi9IOlS2aNJ4S26jHm8VDnKwy5GRWKvxrJ6sF+gRmFDyeZU7ikkKoLkRDZFzakre9Q8YI3jwkP+QImAoEnuYWXT2wP2DAYrB6zlUOssE12QG2jfI5h2JKs4NRikUm0d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743007476; c=relaxed/simple;
	bh=vl/8jvl883eRDOcU46eNAJBVeBbw1nad1SPppAXkr2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZ2aeAuZMs62D1g6m/5KTQRElAsoBi44GB+m1jkJNKW3rK7L25bir8mbDCk0b9CXk6bG7Zjr524NKIT7cHbXeRiQBDOlw0vWRLQpQcipgq9wCLxGJa+rHWwSXY+8ajm0fe9s9AumiruVcZeLghchQtJK0/5LqI5r6UDm52VzOpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sz7LpsfE; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sz7LpsfE"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac25520a289so1447666b.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 09:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743007473; x=1743612273; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5FLbYc6DJ86SQdhqAmrNYoz6E78qOWd9IB6ZElcruN4=;
        b=Sz7LpsfEwqgfrT9rn8tO5VKDgWT4xVfkyahxfmN9DthCSatkjmfgD6b4bclmifg8W+
         QTijtS2lE8YLETbiblVvqjGIJp+JT4Wq56D4IbwsWjgn34pHHq06JhEH1kQGywEDwmSX
         ZrnraG/+v1fzgxefUNRK6luID86+zasip067XfBKjUSE8zsFa6yhiu+a2valSNw8aliZ
         c7CYVFi6fxOg2pKEOVSdqCxa73XspTUJq1qvVdBoEmcYX+Z1SopDT+SIZO63TykVVQwt
         MqqVB4lXKA1LCVRYCcayGQ2SJi22un9vc9po/lOKWTZf9yXFJ87PkiP/KoS/llGaxlnW
         dqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743007473; x=1743612273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5FLbYc6DJ86SQdhqAmrNYoz6E78qOWd9IB6ZElcruN4=;
        b=RUVYl5uSaY04mO9BLPYX10TBu1XU/Q7wsPIjeVY8+zlBAa/3e4endFOolBW758Dg1D
         YwJi3VRtornX/I5qyDJpzdgV7X6dpuaFxaErwIN78JCwRDytGA05A7aOHwnIyRVd0dcM
         LGy7U5ibtIhUeTWhcd/qkD1MvO7L8pWHpaeyT1inJiXUiF9IKOUsv2nU4pic7T6/tXpQ
         tOFdhHm9i/beczgltr8LU5qHw1xJjkdXyzyo10RW+3+ZYAWF/2Gszhao3iyUINLral/u
         EcjOBDSaz0T3YCdNZ1Kd9zIobk41sagWdoBwnRB7O9kassGdqpKcy3m+d3a4s4UK2NS2
         DfWg==
X-Forwarded-Encrypted: i=1; AJvYcCWpUQUtHNn33aN57j+ihr7HuKQr8/tczCo+5HjPG4M6JWf15ZfkqFKk3brKlGYjK/VRjGwMoM4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzylzNJShsmVLlbbWyYsx0t5Jhrjq/kvW5i2v3+kJ4m1FJvYxb7
	h/JrgbpSnfhsALd6TS1L1KW2gNNKiD8TF52gtoYNbMfpTus8YsEiw90YH9vf8g==
X-Gm-Gg: ASbGncsE28F/SQh5lkj0Cp4DrJYu8+KrytG0W0A4EF2jQS8bpu1rr4VNWk4zqmxlT8g
	+RvbuCMn7VMFpV+elQ7cMotYDPFfy2Y0e6Rfl9QA0DiL3ddq7Q5jYEGzKJOUgEXJp2y2Cbzh+Wy
	5dXXlVA3Dv5/bbNId1ZV8zfutytpP/SYGyuXZ7rscr+m8574JuprTKJKaRIbNo7pEYPn/roWnNQ
	59OIgXQV2b6Gt/9T34/B1bF3Objl4kE5XTreCkFrO9r8V9dMVQpwQoHsx6RxT1f3NwpmwU8j2Yg
	ft5xqAEJ9d0kN5tE/WuH8wOd6cURVhhz8pKwTFZCZ9m+Ee9rtDHYd/VKLmKIon4kRjGMB58Yetj
	pSNU=
X-Google-Smtp-Source: AGHT+IElc209Ee2L3zjrpSie3PIBXbdLz1F9LHwLhTXBJRf87bcz8LqAbv5vE8ZPP/e4GdP9Kaf4Lg==
X-Received: by 2002:a17:907:7f25:b0:ac3:b126:58a9 with SMTP id a640c23a62f3a-ac6fb107f18mr8924066b.40.1743007472752;
        Wed, 26 Mar 2025 09:44:32 -0700 (PDT)
Received: from google.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efb6588esm1066894166b.90.2025.03.26.09.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 09:44:32 -0700 (PDT)
Date: Wed, 26 Mar 2025 16:44:28 +0000
From: Quentin Perret <qperret@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	will@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v4 1/3] KVM: arm64: Use the static initializer for the
 version lock
Message-ID: <Z-Qu7NSg96-1uimk@google.com>
References: <20250326113901.3308804-1-sebastianene@google.com>
 <20250326113901.3308804-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326113901.3308804-2-sebastianene@google.com>

On Wednesday 26 Mar 2025 at 11:38:59 (+0000), Sebastian Ene wrote:
> Replace the definition of the hypervisor version lock
> with a static initializer.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Acked-by: Will Deacon <will@kernel.org>

Reviewed-by: Quentin Perret <qperret@google.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index e433dfab882a..6df6131f1107 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -69,7 +69,7 @@ static struct kvm_ffa_buffers hyp_buffers;
>  static struct kvm_ffa_buffers host_buffers;
>  static u32 hyp_ffa_version;
>  static bool has_version_negotiated;
> -static hyp_spinlock_t version_lock;
> +static DEFINE_HYP_SPINLOCK(version_lock);
>  
>  static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
>  {
> @@ -911,6 +911,5 @@ int hyp_ffa_init(void *pages)
>  		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
>  	};
>  
> -	version_lock = __HYP_SPIN_LOCK_UNLOCKED;
>  	return 0;
>  }
> -- 
> 2.49.0.395.g12beb8f557-goog
> 
