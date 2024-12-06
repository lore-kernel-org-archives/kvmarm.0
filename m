Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F99220687
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733506323; cv=none; b=mcIKvjUIPO4qMNnbSIbWOCJzTUSMS1MQhvstFGV357JSqaA0fqX2qyexh29qcYiQExKmdXOyWVFxw95/VXFWr5FHroOzD4Sy8AOXcDPHDy5dsHh+tLbTl61yTaWQhtfC4hsJZPKPH4HbnG3mXyJKcNulmOYrduktKw0CSnP3VTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733506323; c=relaxed/simple;
	bh=YTLSpb99iZx5iZkvYxRZ/efIbOQKx6N3XRwZu6mF/tA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJNENIN9B7bGrbt9/xDuDYGOVywx8UkPcEY38zVdizkVNN7haAOq6vNfTzSZhuGXzeJr8kSRov/EfCdl5OmSjuJM4Ov99rlFPvm8ozGKURQgQEulLa2IWcbDEqCU4SdO9ohNvwU5JeDq1HIeaRmIEpgQbMwC5n4D2Lssv49Ojh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fiZuEuTf; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fiZuEuTf"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa5f1909d6fso456924866b.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Dec 2024 09:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733506320; x=1734111120; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=doyX61/UjfisMnmB4zlyVxfi8RF1xe0m5OcRsC75Zuo=;
        b=fiZuEuTfbaBU7KG2bEAWDx2kQ8GElDeG/Z1SgFrNNXqeWMwd6bzt3AhG02jaD204RX
         Ij/X1/R0lQcpkGBoGinwEucfgo2oCnvSY0fntbBtUfNy3wcXDIIF2/CEyt3PAPOY+FdA
         5cZsOyp3Iyc5uuFxVL/VKCAtubUF6Bwi7ls1sUZA+kTYOi8EIuSqoa9aws7eZXQERIQm
         9vWDvG51NYOiQJy/HYU4FOBxUGXIScTce5tsOFHM9hhe/WONYzl86TSCebjUcz5tqDjN
         Wk56Z952ZSDNx2kBzhaETkwEDukzkqTbcpxEXzfMj3pkwre968KR5PiORSdXBK9p/3yz
         ysZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733506320; x=1734111120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=doyX61/UjfisMnmB4zlyVxfi8RF1xe0m5OcRsC75Zuo=;
        b=If8TjOwzrJ6kKhBVzy7BWRYSoXcm/3eNh8GJvrJLlTFdgM+oONNcPq6W+Mh0G4GfMk
         8/+xmU9X+KpFlDojYdxBjgB+2U2AzlUQZDg07AqMsaTIr4Cj13WBSWlmJSD3/stWThzU
         D0RcOI4ZBUYJek38prdexmcy5Mia6CnkM/EnjJFvPY09c2Si/zzO0zYi0F25we+NoKo5
         cVAsttlvD/dvBTznTLmpGt0XjC2CrFVcAYrXCbD7nlK4kqiNs2tZYMQwH4kMzNdE1iQW
         uaUx7mD5OyR7QHNIu8d95XZj7Ycf4zuamEfRAkbwuG0Nw6ZEIfAxi1ZAqKlcqcx3KJbL
         aIiA==
X-Gm-Message-State: AOJu0YwOef666wtqA+K5xSaTDsOFSo7SIwkWHwZBptUyy4LcARQDc3Ev
	tHDMB8POkepF8w1xtdYpZ63r3yRXxFONzcJ2Py4rHiuoKJgsASZdb+5tbK9isQ==
X-Gm-Gg: ASbGncsaoxis3GfUsRoljvGOjVgapLOWHS0kqYpRlfuK9+XKPfMeF1Je+oaKgc+hhvz
	04p1nRvqqO6SP5DzjcF2nV4Y31dP9HSkXJ2LBT5/tnl2wOOW+/cBgwzfK5IqVx/MzPdDaH0W7kO
	NoOATnfTtOYLxou8l3Gx9kAkX4uMwT70DHMJiFtSLPhtKDAJSu/d/x8iozSniCLz+MBdZ0ZdrWb
	D376u7hj7LRMutjmRLx+mWvscGsolfxvzQeVjDjtCJAemHZkJ0GRjfIvzqFeldIbVFQYjn8/Eti
	p1XLOirU
X-Google-Smtp-Source: AGHT+IGEieJLIbKw0zIu3BVBJZ8gMYSJUZuYoU0fobP25yd/vSbTF7HBZ8ltnsHPA+wF8CK2h2csdA==
X-Received: by 2002:a17:906:31ce:b0:aa5:358f:1eea with SMTP id a640c23a62f3a-aa63a00ac06mr351706066b.16.1733506320425;
        Fri, 06 Dec 2024 09:32:00 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa625eedcd0sm268395966b.87.2024.12.06.09.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 09:32:00 -0800 (PST)
Date: Fri, 6 Dec 2024 17:31:57 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v4 06/14] KVM: arm64: Set protected VM traps based on its
 view of feature registers
Message-ID: <Z1M1DYbvuqAEU5c-@google.com>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-7-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202154742.3611749-7-tabba@google.com>

On Monday 02 Dec 2024 at 15:47:33 (+0000), Fuad Tabba wrote:
>  static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
>  {
> -	const u64 id_aa64pfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
> -	const u64 id_aa64pfr1 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR1_EL1);
> -	const u64 id_aa64mmfr1 = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> +	struct kvm *kvm = vcpu->kvm;
>  	u64 val = vcpu->arch.hcr_el2;
>  
>  	/* No support for AArch32. */
> @@ -70,25 +68,20 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
>  	 */
>  	val |= HCR_TACR | HCR_TIDCP | HCR_TID3 | HCR_TID1;
>  
> -	/* Trap RAS unless all current versions are supported */
> -	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), id_aa64pfr0) <
> -	    ID_AA64PFR0_EL1_RAS_V1P1) {
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {

I'm admittedly getting a bit lost in the kvm_has_feat() macro maze, but
should this be:

	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1))

to replicate the existing check?

>  		val |= HCR_TERR | HCR_TEA;
>  		val &= ~(HCR_FIEN);
>  	}
