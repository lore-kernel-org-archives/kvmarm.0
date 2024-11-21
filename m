Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF0E23099D
	for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 08:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732177932; cv=none; b=JtJw5UcA3T94H4yTvY8EtzVpveaozCrD/9pNYdwEUiwiBXSWH6yEFCDh06bABCzuvvu0yJiVdchAdTudFxWqxNT+/F32EN6fZb9dKGzIRmyQYf05MKniomFMEyNy0bv6GuWpK6E05MpcrOaob7/dt0dinWFnj4yulgIgFa7h4GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732177932; c=relaxed/simple;
	bh=yyJ/2Ofp+3Wgah6kp5Pwxlh1xjmJuz3p6nImKDy3QSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dC8S22e5W68gnjKAUDM+bXFTJc1gd5kq5hy3fPwpaG5cW1SzNP38kSU6TNhKiG4lu9CIS1CyKEDkg2szddtsGejLFitCxI2AmZTZguUeB/gbNjDOgTPRvB/y9wj8emGS/7QgepUDjX3a5dNMMo+1X2F8r1Y5+PiFtL1MLD1pVtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wpnBlkoK; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wpnBlkoK"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9a6b4ca29bso97517166b.3
        for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 00:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732177929; x=1732782729; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1hREuEO5bVK0P8afBUPbQKjHm3+nA0mzaIkZSOu2Ro4=;
        b=wpnBlkoK2DhsC0gc6HeTB6K0u9NgU9LR0Vbb/hMkmkMW5R8ijl62+42tlg2qFUzDmb
         ZviZGDyDiVjbd23m0I2S3NPULNgwT02y1JnWfG/i2E/xU41x3hTSlJOuJRjwkqASKZeI
         SlQcvGp2qWBmmWv3XFJo1RtsZhG6e+g62GsxbUDJqSl0/0a82E/8pBO4V+0K1kjAaLhn
         mMFsIcNCkXIMTQ74A5Ji/O11n3hGRzD7JTad/A97viou4MvBohGM8gMRumCFtdHE3UuO
         CWQ9WLV53WGKtyC+Vr66dwUAMNin34fK+IJsbqO1h6oR9G9hu3yVJuclFKrRyPsLuz7f
         SDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732177929; x=1732782729;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hREuEO5bVK0P8afBUPbQKjHm3+nA0mzaIkZSOu2Ro4=;
        b=WdX+HM5JXcI6te9rZ9bySoI6VTGneoXYet6Sbfmj7CnC6dUp8535qSWpresoo8hjDZ
         PbjQkSAaok6d2YrGiJ+CsDCGiX/jlekTcxwcDJ/UM561U9+RzmBfdkOmo9op2E/FgEio
         yCRkjNQseEqSWWLZzB/0zEuLTG36OtSYAXQDgX0XVucOwJcqYcMNzDYta/1Zq0W1cSAk
         cCvvHUPrKvV0SzwO1iw8hT5Adrp/1SfmsQcHqw3EbXDiyaFatUmVEDubdOWuFyvi3t6U
         3uZpCCuj4L+jdX0zczn4OqUquXRNGnM0Gg2eRumrMlprXo8LVqUfc7QBuZlR1B3MfHcM
         T/pw==
X-Gm-Message-State: AOJu0YwBmz7yw54BSPwAZs5A2vb9VWs+JJoqEm02nM7R53QOck+Zx87x
	iDpTdbmb4WJxJnmujDmy5pN1cUOfBhZFwJZlS+lzHhQ0SoOEKaJW3qOG+ynpX0qMpBm5l9VRGGY
	G5w==
X-Google-Smtp-Source: AGHT+IE4TKd5wDKmvQpBdEEu/xfgGiIKA3cuRbSFfnFXGKnL4yHVKF2Vc8v1y9VFoin4Md85lL2nLw==
X-Received: by 2002:a17:907:86ac:b0:a9e:670e:38bc with SMTP id a640c23a62f3a-aa4dd52fd73mr593858266b.3.1732177928228;
        Thu, 21 Nov 2024 00:32:08 -0800 (PST)
Received: from google.com (40.162.204.35.bc.googleusercontent.com. [35.204.162.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f431a7absm52035166b.143.2024.11.21.00.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 00:32:07 -0800 (PST)
Date: Thu, 21 Nov 2024 08:32:05 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Subject: Re: [PATCH v1 10/12] KVM: arm64: Calculate cptr_el2 traps on
 activating traps
Message-ID: <Zz7wBU3BHW-XNnbr@google.com>
References: <20241120105254.2842020-1-tabba@google.com>
 <20241120105254.2842020-11-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241120105254.2842020-11-tabba@google.com>

Hi Fuad,

On Wednesday 20 Nov 2024 at 10:52:52 (+0000), Fuad Tabba wrote:
> -static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
> -{
> -	struct kvm *kvm = vcpu->kvm;
> -	u64 val = vcpu->arch.cptr_el2;
> -
> -	if (!has_hvhe()) {
> -		val |= CPTR_NVHE_EL2_RES1;
> -		val &= ~(CPTR_NVHE_EL2_RES0);
> -	}

To be on the safe side, should keep the RES1 stuff for nVHE?

Thanks,
Quentin
