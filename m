Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794323545;
	b=vC6KhRWfRTCvRoyt9ELFh6RieGBmF4X/5e7I1iHuHmiOn9EQ4NJrA1i5HIrYIPy0fw5n
	 tYdOyPXBRKijvCXpNLTVGpIJxGGJpBvuWalg4MSJ6Ui2JgSgFGy/6OyAf+27Wtta13+z9
	 FRsvOzvA+yv6HCL5q0iEsBMKheMbvLutMn0Yq/BCAJiRVE0Cur2RUGYp2PN2R+6sHKro0
	 s59U08RjEmz8aJE4yktk+Qrvxti0YEb6ImTuCDRce/yKg3G0L/raHejfXSgNOAtUuD5UZ
	 KkZ4TmGwoZdXxnawJR0uhCScN1Dwot8lH4Iy0Ib5ovFIw7u1Z7NyaEfWyFkK79WGWcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323545;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Mime-Version:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Cc:Subject:
	 From:To:X-Mailer:References:In-Reply-To;
	bh=KpEwWty65XIKqwE7JeJ6p16oyvStp8N2eZzOQMIZadI=;
	b=04fCLC2AqLwjel7zdjMUNOBGNZ5cwOYhbIE9dqUBGqZhgKLlkwlwJkDPDdd0yD37MZzM
	 /kP0A9VHPqrG9sUAIm1U4uRdwNUz2MomYZjQBwvkoA8Sm9Dox6qQzmY/EsNDUn5ShuUpH
	 cQiIYPkXEUpY5EYLt8hi6PCvysyVw4hamagFDW/Scs/yB+O+/uQba/0qbbIkfIUXdpimy
	 Pd5rq2z9j8V1NNWcYyZcWM4OGf+S+gKNobmcEIvz8hf8QQp9Bl9wOeWD1/z95+FuWTV6s
	 DNHiIV7fOoh1Fp/WqlhCjpbda85mWXOlzGba8C4kSLmtv0rsQk7jnLuLOkfoLN2y9Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=fErt2oxi;
	arc=none smtp.remote-ip=209.85.221.171
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC2E60A2604
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:12:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CC2E60A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=fErt2oxi
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5ea969fafeeso744062e0c.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 07:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794323544; x=1794928344; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KpEwWty65XIKqwE7JeJ6p16oyvStp8N2eZzOQMIZadI=;
        b=fErt2oxix7FuW8mrPMI+TDmW/sfPxkkilbiGuCcI8IlTozvOOvoRjCOXP7IlWeS3ma
         xGKoQ2ztNQ0+YQI24R4VJJXZTewVjwwbJu8E1Qk3EpW5fA4fyPVKXro9zG9I/ymFC4c3
         Cz6SnI50jpmwBH0SfxvuAKpTsSdMD4hkV8ZewWVE2f389sx6gK5xnZPfMCFafk5VEnFz
         +xukaEN+ycBXZRBW71cPIOrtXJQBQjJGykRsOZd5NUOYQxRJBxDu/ZHdzJtCVmeZc7Jo
         lj8W9rl+i+MalLueuhhYZCgKsewajLwicgz55ksyTHWgaFvSxx5O8TLvKnw6F39wMSsk
         DGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323544; x=1794928344;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KpEwWty65XIKqwE7JeJ6p16oyvStp8N2eZzOQMIZadI=;
        b=h/8VUbKP7tuwWZTUx/p2AR4XoARhM1bOGayi9h7L3Q1V1GbcK9nTtUSqRxHqrvxqw9
         IFwn4m7PVrir7ZGU0y4TooAHXcgiD943u8w1M5P1IAJok6REqOcw2KZHR0+HyQKO8ZTq
         IsG281DT5u4iwt2wWBo3TV1LqFKvY6538ep1VmCSzFp4STY3zmTN7vG3SERxgXyQ6idr
         cGSfi1SoI1J1kWWlMa6SZDm5wIAjri3ABhZR+eAZ5yIvWN8XOJNgd3MPPeL2XjnwjqzV
         jE74Mr3bzZyvLYiqNWuDQJyqZglul982f3fVR8vzP/xtSSPPfKd+tJYtXiJAv1TwRlaB
         Olkw==
X-Gm-Message-State: APuU4Z/zMlKohiOXrGg4tvPwbuLooKZTnZP40BjvNOToHLYuomEKNaqy
	7Um5meT0yHZ4B2WTZOkKiEkLbQlYpCqUZLmlq2vXnI0ua5WhMuQPzijW9Tv5Q5NfWcA=
X-Gm-Gg: AYBFou0Rrb6z4fu4iXTVFDiht9h7zUhUBvl72q4ujXV8LBHLQchlV41FnEynMdjLBul
	7waYvXfvxjElygNiThVH4ZMRW7OH7x7OOXiMy4ZpNqkU9mPSZ6dMH/nfFOj3hYrZJS1Plbin4GO
	bzIFph4XiJ4XQak5YHdqBWJG47746KeO8I8N6zfGRi7iRamBJdCxkQ8kgZtEUKkBHhP1WEZ8PGn
	30nNDtia/2vA1RumStoNjIs/tZD7E9eXh5gukNJbg51TGJmYBn0pXsStAIHZhhCU5GpKq7oB9UR
	A0bHitjaRZYHZGp+FfEW399odrVPSkvHu9Mm/uPp3GraVQIgACupXbfqchgh5UmLk+wHdFTcoj7
	V31VqUNoe/yuLb0Ifg2E0rHveBVH47fv/wFjMTbL1HSSJHsm4DFSq+0thXH25/wnYbaJ+yYg6wS
	uBTRc3iGmamE1bBo1p4t6Ze8hBbTBj3qSQ5I8NK6EdvnvtUZ44SmKd9WCCAfIa1KrVpTXgABZok
	eFLBQP+mmSTHoIrqYRrERn905lgeh0gwBffUJdwneWEeR2cAa6veetA+wk6gaIHG3OewJfo4bj8
	mw8jht1HSbc9RE188P/mj78yH5EJ0p+1+8bM1NxxfcCY/yPMuPW06HFlUGPvrUwSSp2QqAF6w0f
	MIj4qTP1o9YIbni2lqLAEUPLKNyE1
X-Received: by 2002:a05:6122:5313:b0:5ea:a0f0:192f with SMTP id 71dfb90a1353d-5ee0d0cd07bmr947867e0c.10.1794323544266;
        Tue, 10 Nov 2026 07:12:24 -0800 (PST)
Received: from localhost (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee0c45a110sm2039560e0c.2.2026.11.10.07.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 07:12:23 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 10:12:22 -0500
Message-Id: <DMRMLZSZ0LAZ.D4P70QWX0IHB@soleen.com>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-6-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-6-tarunsahu@google.com>

On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:

> +/**
> + * DECLARE_KHO_SER - Register a serialized payload structure with KHO.
> + * @name:         Structure tag name (e.g. luo_ser).
> + * @payload_size: Compile-time expected size of struct @name in bytes.
> + * @nr_required:  Total number of defined required features.
> + * @nr_optional:  Total number of defined optional features.
> + *
> + * Size and 8-byte alignment are asserted under CONFIG_64BIT: KHO and LU=
O are
> + * 64-bit only, while !CONFIG_KEXEC_HANDOVER stubs pull ABI headers into
> + * 32-bit builds where u64 has 4-byte or 2-byte alignment.
> + */
> +#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)	\
> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
> +		      sizeof(struct name) =3D=3D (payload_size),		\
> +		      "struct " #name " size mismatch");		\
> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
> +		      __alignof__(struct name) =3D=3D 8,			\
> +		      "struct " #name " must be 8-byte aligned");	\
> +	extern struct kho_ser_hdr __kho_ser_hdr_##name;			\

Remove this extern.

> +	enum {								\
> +		__KHO_SER_SIZE_##name =3D (payload_size),			\
> +		__KHO_SER_NR_REQUIRED_##name =3D (nr_required),		\
> +		__KHO_SER_NR_OPTIONAL_##name =3D (nr_optional),		\
> +	}
> +
> +/**
> + * DECLARE_KHO_SER_HDR - Declare a feature header variable, field, or pa=
rameter.
> + * @name: Structure tag name registered with DECLARE_KHO_SER().
> + * @decl: Declarator (e.g. *fhdr, **out_fhdr, or * inside DECLARE_KHOSER=
_PTR).
> + *
> + * Declares @decl with type struct kho_ser_hdr while checking at compile=
 time
> + * that @name was registered with DECLARE_KHO_SER(), documenting which
> + * serialized payload structure a feature header pointer belongs to.
> + */
> +#define DECLARE_KHO_SER_HDR(name, decl)	typeof(__kho_ser_hdr_##name) dec=
l

Remove DECLARE_KHO_SER_HDR, use kho_ser_hdr directly.

--=20
Pasha

