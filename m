Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC8A28EC
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 12:25:32 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id h16so13347279wrz.12
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 04:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LZAucNLzijzKQ21Q4plD1d78GkaeAHQGHHtmZwwWx5M=;
        b=vjxJteG2AEMkQG8SG05CW8sO/4P+xzJk2Vnh+rBKD69Ff/Oyfka4vwhhsZqhKRgws0
         15epdVbZeytxecFYQENRy0JaR6NWBjj0Qo/lPnMvyNPXGX1tmkhykVGpQqAZ2Et9pzVj
         W0ToShnsMttJXXxEb12Wpkrn4Nju+WATfpg/1Lx7cNiD6nGkO8Ljb5FJxIEBge4t84BD
         jX6+9449Q6o80EhUImqQHqOC2gxWkbo4WnoWqyGnWkrH7P5APItItpLNbxRfmvL6ruUw
         FQIZWIJ1uvd/yw+WxuDIJ40Fp3uC7IS1K4cXMhuLDamgqsJctdyCwF2srRjG0QMjiXH3
         ay0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LZAucNLzijzKQ21Q4plD1d78GkaeAHQGHHtmZwwWx5M=;
        b=bijo9EN+Xs/e+PTtzGUkavImLMYcCekjRyi+2TL5T2W4scWhOO8u1UlPyu21B70r7a
         0NdYogC9fYG3gr5UPpGPy3CUpw7DkQlvPcxhoFddMAYdUdIVdKAJtVl/pfvBG1dmwQb6
         ejSVm89w8ry3ROK4URAwDFDIexXCnvFjyHIKFiJTlLPBlrb6xEIxSZ8PLxANaxRLRIy4
         CuZjcYdxvUdlFsqk0zSuaiNbfwhYqoqdx4tef2pLgzx1RZdXfLjKVD3GWm9YdIBBQbNn
         84eMNHb778RclAYrhg2Evyj+X6BSoRp9xscvZ/chTJdVdcWWZJN8P/Gs8CpL1SH8m1Fa
         rezg==
X-Gm-Message-State: AO0yUKU1XDXkAmhznZ7x/6hl7s8pj63l2ITsPgqLmgsIcqvCRoUJevQU
	SnXNT9PiNMe0JdGjogObLgsSlg==
X-Google-Smtp-Source: AK7set8vgK5CfM858EiDxkXkMMgPk8OOvF3Hcy+IAl3YuF1Ka53mp4jCWqk6XtOI1TyvyC37K565Pw==
X-Received: by 2002:a05:6000:104:b0:2bf:ae3c:e963 with SMTP id o4-20020a056000010400b002bfae3ce963mr2424172wrx.9.1675772731272;
        Tue, 07 Feb 2023 04:25:31 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id f6-20020a5d5686000000b002c3daaef051sm9949472wrv.82.2023.02.07.04.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 04:25:30 -0800 (PST)
Date: Tue, 7 Feb 2023 12:25:26 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 06/28] arm64: RME: ioctls to create and configure
 realms
Message-ID: <Y+JDNkMpk9Y8ReWM@myrica>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-7-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127112932.38045-7-steven.price@arm.com>

On Fri, Jan 27, 2023 at 11:29:10AM +0000, Steven Price wrote:
> +static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	struct kvm_cap_arm_rme_config_item cfg;
> +	struct realm *realm = &kvm->arch.realm;
> +	int r = 0;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
> +		return -EBUSY;

This should also check kvm_is_realm() (otherwise we dereference a NULL
realm).

I was wondering about fuzzing the API to find more of this kind of issue,
but don't know anything about it. Is there a recommended way to fuzz KVM?

Thanks,
Jean

