Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1812F39FCAC
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 12:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776688363; cv=none; b=XrHdF066zVF6hYzYVPMbZ/BF75FI3Uj/dMbJQnhxT5j8l8EFFZPcpwCTBjeO7oEpYtH3mdTKQsAMcY8/1td4j1MEe00h8WPihAY7C9nXBNr4FK9iN3ttFpv80N+cifxLn5Hzzbm+5GBwS61ySC8r29j4dslHJk7yAA6Mbh8KhG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776688363; c=relaxed/simple;
	bh=mrnF/Wym7mp2XvioGnhhOSe51/kl7uiND0mhtfL/BcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fEgSrKn9uKJuVuh2VAdm71dL5AuGau69pWt8pQE7m46ktshUGd+tJwi7lHkcb76fFXUnYn+UcVg1y9E4ABnSo5hdeW/c22AFA+lrp6vw7+gaC9UpGoa3RnT9GzCms1UR0wiVwqCVX725eWG5WsGvc+/yjfyIbeYjWcg++VViZqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ft1gI7UA; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ft1gI7UA"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso85625e9.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 05:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776688359; x=1777293159; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=99fgHE25P8Rf1g7JLxo27iNfMt0M4KYBWTaNW36OxW8=;
        b=ft1gI7UAOZzPeSLWFU6ACg7V8DoWcNbFztg3GPikl4YSyYCKX0+R3HjdJNxVEykgBB
         mAL4Y4ghoAP3JZ2HzG0Z/k2uzul4DfUME0AeSIgnDgaSBK4xKnJR7fI9NSfIzgzm0LnP
         Su+iqs0v0yoiVd5rTpId95NHVAlB5OIhOSzRjQ57fdy15CzXBiGQbFP0B9rZKz+n2w4c
         XhfCDnOtI8dUxjy8XebGZXU7qVY9Bt4bCotj1cEcT3Xx1CB18rC9DQARtuqnEm889psa
         rFSXWOJbyrKk4gDEePUkEykYZix6NsMqk6nSaWOkRRDXYyHZief2yC23ehSecfPdV6U0
         snLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776688359; x=1777293159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99fgHE25P8Rf1g7JLxo27iNfMt0M4KYBWTaNW36OxW8=;
        b=lqBD7ASgOvOXOEiiWchWBHHsLSMs5NL8UIfSLj7JXj0g3U79RDP3Lw46z2XEb0fR2E
         bApDqrfXsZaNwQXzKo68eaXZLFMlqZppZe1LV+8mr1XHxg8YO9FhLAFTzVCD6hj2qPkt
         WZ+ut+2FADoKfcUPkPTf1Fja1cdAr+HX+oTlMMHU/5Q28l3Pc1FeGVgU16TrtH5zsZG3
         eqyE/j5r5+s+ehJzHaMgVOkk/XV+dU7GqqwvUYzUGbBGAHl16LnU+KPCrfI8fvh2EPss
         Vpbyj4HxEh9K2SjOKubYXjkKRqKZRX3BiVL7wiOL0vunCc7u8XoM98V7ow+xSWokos7q
         sAmQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Sle1tZJXCDyn33mCsf53adNsC5WUkPYhraceZ62OCa19Cg1FXAPCQOGUMyF1KuJ7u5P5ltLM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+SD3EopuqFCSmeeXVVRHUJkvIEoVb2ZqJ4sVqwdMlv8gB5x1I
	7WScw/ndBSeupVcIT6fyctgogt4KIqw+R4xYA1aNnLNUpwnuKTMrE1h0fprHk96D4A==
X-Gm-Gg: AeBDiesTSFlASlm0MPPissntZ0oNx/trR5ttzqFc3r3E6tmY5cKDN5K+HfNK2SYT4t9
	NKJYu87Fw8tcGiExYqn0HoqJXS2QRL3gCXNj76EuX8KNtn0LRsLaLPmIL9a4ZDIJ+xlUh8BNcy6
	B9BsAVqXWt0e9yKG8u6tYB99IGzYFWMYJlRI1o7FX+JDe4lofTnk6XnQu1sAeEVXCqNW+JA3YxP
	17p9A8c8Xq45gMsQBNMw0VmqCLkSFGSugv611cJ1hIcPahU4qAt2VdQJIO3QKkjCXoJt/HFf4OA
	r/eLnSvAfq0iM4bHKcuJR+DkrQo4kwAD2NoZBp200BUuTJjxY2Iqy2EUOHipSxpf7WnHueeStH5
	lwW/V9l+xOAngjmnIrD0vq71Y75XQiAnCYh+rp7OG+r+LvzGMjqSULjlltgjEqtmg8ZP/Y66Ns2
	y/8hADShex+IZ49DON0mmKmusfmy2FhrCfrx5yklNmqWW0ahk0e7/drm7p9qJ8GOvjCQD+OjaFu
	t+lIiOSn6TmN8+JTBo=
X-Received: by 2002:a05:600d:848c:20b0:485:4133:4021 with SMTP id 5b1f17b1804b1-489013bd634mr1545925e9.7.1776688358586;
        Mon, 20 Apr 2026 05:32:38 -0700 (PDT)
Received: from google.com (117.15.199.104.bc.googleusercontent.com. [104.199.15.117])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cc375dsm26265240f8f.14.2026.04.20.05.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:32:38 -0700 (PDT)
Date: Mon, 20 Apr 2026 12:32:32 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca,
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <aeYbdmshGZJ4GhXd@google.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-5-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417175759.3191279-5-yeoreum.yun@arm.com>

On Fri, Apr 17, 2026 at 06:57:59PM +0100, Yeoreum Yun wrote:

Hello Yeoreum,


> When pKVM is enabled, the FF-A driver must be initialized after pKVM.
> Otherwise, pKVM cannot negotiate the FF-A version or
> obtain RX/TX buffer information, leading to failures in FF-A calls.

At the moment this already happens after you move back ffa_init() to
device_initcall().

> 
> During FF-A driver initialization, check whether pKVM has been initialized.
> If not, defer probing of the FF-A driver.
> 

I don't think you need to add this dependency. pKVM is
installed through KVM's module_init() which ends up calling hyp_ffa_init() to
do the proxy initialization. The ARM-FFA driver comes after it (since
pKVM is arch specific code). We don't have to call finalize_pkvm(..) to
be able to handle smc(FF-A) calls in the hyp-proxy.

> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/kvm/arm.c              |  1 +
>  drivers/firmware/arm_ffa/driver.c | 12 ++++++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 410ffd41fd73..0f517b1c05cd 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -119,6 +119,7 @@ bool is_kvm_arm_initialised(void)
>  {
>  	return kvm_arm_initialised;
>  }
> +EXPORT_SYMBOL(is_kvm_arm_initialised);
> 
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  {
> diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
> index 02c76ac1570b..2647d6554afd 100644
> --- a/drivers/firmware/arm_ffa/driver.c
> +++ b/drivers/firmware/arm_ffa/driver.c
> @@ -42,6 +42,8 @@
>  #include <linux/uuid.h>
>  #include <linux/xarray.h>
> 
> +#include <asm/virt.h>
> +
>  #include "common.h"
> 
>  #define FFA_DRIVER_VERSION	FFA_VERSION_1_2
> @@ -2035,6 +2037,16 @@ static int __init ffa_init(void)
>  	u32 buf_sz;
>  	size_t rxtx_bufsz = SZ_4K;
> 
> +	/*
> +	 * When pKVM is enabled, the FF-A driver must be initialized
> +	 * after pKVM initialization. Otherwise, pKVM cannot negotiate
> +	 * the FF-A version or obtain RX/TX buffer information,
> +	 * which leads to failures in FF-A calls.
> +	 */
> +	if (IS_ENABLED(CONFIG_KVM) && is_protected_kvm_enabled() &&
> +	    !is_kvm_arm_initialised())
> +		return -EPROBE_DEFER;
> +
>  	ret = ffa_transport_init(&invoke_ffa_fn);
>  	if (ret)
>  		return ret;
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> 

Thanks,
Sebastian
