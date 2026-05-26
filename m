Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B6A400E0A
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779807088; cv=none; b=sdjUsqB/PHLUXHNuN1NrK6tVjiu3DhCY0Ldou+Dx1lfQ154sIRQiueY9OodhgjYVpKmz6Nsp7/VS/UC08LzYKduSnJE1MC68CC5OJ4mGkoh6rSzAJ4eMqksx3aKYEhlfUFA2LLgwFIOnmgrVpZQ/5OPL0DU3+bcrHKDnDtSN7sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779807088; c=relaxed/simple;
	bh=dct6851wSN9ndDFkDx2k5HoInqLOlNRNNKG7LPUMDm8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=uI39dw16CARnl+H5qnuIN9/OyYzxCWL6JmoX5a3VeNz1oe6Q1quJqoA6LwvV7ATk8yl8GE/zH5FhowWFyMEA9PgS6CpLsWH8+bfHB2ikt4S2cMXVkhL+Wd/3Mz7u15P8am/fqdJz2S1u/bG6fKEighzJrYzjA5yqe4qWipGFAz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WfFnH3h9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WfFnH3h9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779807086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vNB5dRuBQUkYWcL2tTZPtjic1AfVAuz4/Sce5KoR+pE=;
	b=WfFnH3h9tPBTXdhrjWIXRG23hSjtgMKnaVTX4nlqG1hz7uVTNPWmAXE+JEkAAfNT7g6vk6
	ROWhh4AKB7u7P9d99fNAli1h+LEiY8yrXDzrh33AHtY1mjWQl6qMQABebjb3kSPTyeC9SV
	qozB+T/ibd4dmTAZggGmTkxM8YmBNiQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-9mLSo35ANcWM5oJLJ5wqqw-1; Tue, 26 May 2026 10:51:24 -0400
X-MC-Unique: 9mLSo35ANcWM5oJLJ5wqqw-1
X-Mimecast-MFC-AGG-ID: 9mLSo35ANcWM5oJLJ5wqqw_1779807084
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44f56d5523eso9533199f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 07:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779807084; x=1780411884;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vNB5dRuBQUkYWcL2tTZPtjic1AfVAuz4/Sce5KoR+pE=;
        b=hHTgwXwwL5MHoAPHqPpFmZt4iQyoSRSClSwSlJj6u+tYp01Dlbxkng/DtoSd1/azdP
         jSZtIpNUGD5zTijwihdUaD1/QJjnEfoPsUPtkcoHnK9KGJrmvZHPiShM1YrEziQt+yG6
         e9Cx0Mz9UQXznZ45ieZVg+wAkWlYsOleHqmAHOCe3WOadgAHLKQ2asF1D7yG+F/NUu6l
         nEj7uXUbOg/J3acEEgktLMcq5rWBMuzjXm5beCT3NUCo0rEgVczMDKLoqUd8v+nTMoC0
         yc0vScSrXjvzCCvZjaU26cQTPKDhFQpC9c++vH4VxuA5LfrQERMUukQ7XCce/HERKp/Z
         Clig==
X-Forwarded-Encrypted: i=1; AFNElJ/2NGboAS6wY2VWNTVlKlNSLx3OT94JRGDxZPmPx8SK958FJK06yVVbxsCrQPm0aUX/9m9W0aU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhIYqV/ERbKBCfb/4Y1u3GFPA0Dd18bWeG1K45zbZIrOz/ip/O
	lEGbI3VWDAXdV3iyAy04QFdtE6//I76AXaOXu3Cdm6Bb4IuypoDVNy4GOzOHU0gVLvtMmVNMifQ
	gKZZoML0t4sl2daPfZT9if/qHx+T3kOsOJUw1AHbMRK0Xa2oawe23e70oEQ==
X-Gm-Gg: Acq92OGEoI47rzcpzCM7u5tecQ1bWfWiUUPqaPExsdJAly9wwnbgYkdIy1Jg73ZpTAM
	FDd+fNINawCe8ntdmu3SDXCamYteZ1IVWvSE/IRu+m8eYaBgFcl7sojVwR8EqwW5i7QPiwbIebq
	HrO6+kqrfRlXuOAGakQXMYTgrJnTmmzXNc6zV70Brg/Wn4mAGXxZZwdZyakndkI//FAuEeIZsn0
	DlHayEOPr5nA+5Uhr+HcCLEJpEWbzpJGkwtqec3ZC+/7yStzwqJSioCXg+QCbUK1mjmp/0d8OKC
	BFzj0913zB/9/LyT3Vyr1Z5LQ1mvDn3t68FaZlXNhbfGaBLj1s80I+xX1UuK8Ngy6OrHUZO9Dzo
	ETTgM+ge/dt6GfUJNFS1Qln4Yme4JW6Zb0D1vcgMi6iejZuIqShE16tuKiagJjKiEvJ5mucw=
X-Received: by 2002:a05:600c:628f:b0:490:5057:f602 with SMTP id 5b1f17b1804b1-49050580d79mr260088395e9.17.1779807083719;
        Tue, 26 May 2026 07:51:23 -0700 (PDT)
X-Received: by 2002:a05:600c:628f:b0:490:5057:f602 with SMTP id 5b1f17b1804b1-49050580d79mr260087825e9.17.1779807083231;
        Tue, 26 May 2026 07:51:23 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454a0cd5sm406863615e9.10.2026.05.26.07.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 07:51:22 -0700 (PDT)
Date: Tue, 26 May 2026 16:51:21 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
    kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
    yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
    skolothumtho@nvidia.com, philmd@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com, 
    berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Subject: Re: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
In-Reply-To: <20260519132905.145643-17-eric.auger@redhat.com>
Message-ID: <26485473-c1bb-4dee-ff9c-429d9ecc7305@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com> <20260519132905.145643-17-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WLhIRkIgBrSv0vi3cq-uqJw8SRQu_xKR7z9ICOPvDV0_1779807084
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 19 May 2026, Eric Auger wrote:
> If the host supports KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES and
> KVM_ARM_GET_REG_WRITABLE_MASKS ioctl successfully retrieved the mask
> of writable fields for all ID regs, expose uint64 SYSREG properties
> for all the writable ID reg fields exposed by the host kernel which
> can be matched in target/arm/cpu-idregs.h.inc.
>
> Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
> being those used ARCHMRS Registers.json.
>
> When such properties are set, they override the default field value
> retrieved from the host and reinjected into KVM. Then the actual value
> being applied at KVM depends on the register, ie. it can be sanitized.
> In case the field value is rejected by KVM, the vpcu init fails.
>
> Anyway there is a first attempt to write back this value into KVM.
>
> Then legacy CPU options (virtualization, secure, ...) can still
> override the previous value. So low level IDREG field properties
> apply before the legacy ones.
>
> An example of invocation is:
> -cpu host,SYSREG_ID_AA64MMFR0_EL1_ECV=0x0
> which sets ECV field of ID_AA64MMFR0_EL1 to 0 (enhanced counter
> virtualization).
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

