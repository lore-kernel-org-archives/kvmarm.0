Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795087089;
	b=JFxeLBnq/lVIbMChhJtpgsENxPBOaW5zzw4pFzcOYQnDSHlKVN+c/uW+cZ4HZCENL7be
	 ZT0+dH/Tft3X4lsZWwg9+N6L0p5DESG5RqD9Ma1PCMI3XQ1dX5kwyUrjnwp0gE9m86mhF
	 3Sjdb8r3XbNi3IToNM0aBgIy65UnvBWdu9Je9ENhZVENrcl7KlMMefGX1Wael4F1xGR4b
	 8EYRYD/YsCWzG6xGqPqo2jQX7+6kgL+hToYXDORjFcB6xr3Z+RCGnqmZMaVv8sMJ7D9+G
	 FRzuTOOmcwL3kflFbtZ/zwFQsmFON4gChs4x/RG73/1YxtYoWog2diOhW86oMxbmIrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795087089;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=fY+Pd4NWLtkS0HB6qP6ih+nJNWbdv9Us893L8bxy/2g=;
	b=j7TrWsUcOZ+Oss6hsA5V/OJeXVsLFPEoqKC1xeo0uWxIzCSSjnAeiv5dS43QrqmJ7dEC
	 DxMcOjxu4pNjT9KeHUi4TwjCHPA/fymHe4QWaNrdyaWFecuZIXOrp7BrEmxLd+XkpXLTs
	 zazwJ+ofx6SgabU6TXQbXCCMR7H+H63qrF8PPJYywAx1kI5WasOHTVa6qVE8biJKi77FX
	 FNuAO2CsoPsPPntoDUau+5XRG8GqH7yyRx1HyAfK4aU9S+AspwlGppw1nvjcxxeXPSg5+
	 g9RwMSNPDEhI/wrmzqpUKYcJVsZPwS0DgtZVqzBDV61Kao+mR7CJTgTFJlAce59SL7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WA81r6MS;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DB8606A325
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 11:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91DB8606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WA81r6MS
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb845433b8so33975e9.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 03:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795087088; x=1795691888; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fY+Pd4NWLtkS0HB6qP6ih+nJNWbdv9Us893L8bxy/2g=;
        b=WA81r6MSiZyL/7N4cerevc+t1AZ7FUivSwelz4OSyQilRMCalwUOa8KzpFCsVhR+5U
         PFl6htnT0KWEfstnPd3UhDmYOETvDb+pza41VeqL6FuxyB93q1Qbi4hl2yfHSteaEw7Q
         N0R+zQ4oDDTRnumyC79V8T9t0IXEPEnFJOe+OyJ+AUWBe5+8yl2npv07OVADapFlim2B
         PeCUFJLvXWUurB/SWs3jLUNT3H6ywtoynA3Hb28H7B8EO82HTFwrbn3pgKVYYK2GwGcS
         /+EOJSvjzJLvtwHeKi24BolhXdNK/uw9ONKFWibbxdDgkibHnv6lowvAgxCY/huk0Q/U
         FwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795087088; x=1795691888;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fY+Pd4NWLtkS0HB6qP6ih+nJNWbdv9Us893L8bxy/2g=;
        b=QfAHpRXYAaoxfEooDtW+4vElmDES2g0Gxr+6ZI8DHxMzyOvP6wgy6FW+USSMC/PDgY
         rAUF7SeYUreec9u0hmTApE57Nbu3hSAob85qowrSJEOGpyD8iInRCLzj4Yzmaw1iYFx2
         /GFloZnnuFfum4JDnvC7ynDNVRfPjQbfbVWR1zK4grNJ3LJSvcYZFeOaRaYABdE3ZwBq
         ZHO1BEEfCQXy7dFCX0C+EaGV32lRjfFmj7wuiTIvk8rJ0DCuWA1AEZqEYjCJVuEl3jyZ
         fR0D9F5W6Wuu4HortCxuWUusQoTyUDkBusmpS3Tek+aG29ODaHdoYNCTmUebxKjcXpIv
         pxLg==
X-Forwarded-Encrypted: i=1; AL+hErFrmJFcpzcBaCnReELSuAsjqYxkWwvB69UdY75FPBDe0n/vi/EiLS6Mu5kTnxikhzNexWzbVW4=@lists.linux.dev
X-Gm-Message-State: APuU4Z9tnr6sI19/K1IZHmWkwhcqDbPOKo751vc+UiGy/sZeaY+upTsG
	357f5V8WN8KNG1k3cfTYtGMqXa2HEBBJrpv6ie6YTJnXUfNzTV1+0UGK11JMoZGClA==
X-Gm-Gg: AYBFou2/dEFdTsuoGxW++48dDjaVajKcgZNeJQ2YiBucCIXtaSYpDv8yX/GpXZB/Xzf
	UPVyDlQijClOPum8UEnuY8Kuf8/LlasGxnu0/9KFq4jCGzLdILuOZW6ceoCfiM0wVO7a/Yz9ShF
	tcOYTl44Y+GxtufK0jPczHFExxGf8ViBOzuQXWf0jZrc+kTd9tychbn8+U2fO4n10AxHxZKHzHY
	s+j5vOtkYxqLCq9mk9Jt4zZzXciOnfQkA4oAbt1worXzCezdo/eAmXrHGR1a66up7DHVaTH5rXD
	kBfJvvBbxeZri8bGQhQR+OPtdUbe6i9YWUZoP25njLA871r3RGypNvdBP308OhUbI0OFGgEMjcI
	CgxrQKs9AiP/jhZB+cz/OWhfm5utT5G07JSx9/nM0b4z0blwteuB6EgYCb9SGvBgD99XsUPrXfO
	PGsrpI7UpsVIIatTDn5RYfN2s04S5rcWoD49TJN/fPp+YVeRn/7P48zAlCWY9/Bxx2Vxxq4e342
	bn274HZ8AOSlKUuMtzMQNYJRElO9ooZZJgNgXsY2FxQ2RNdfEFMPayeUUzDwSUFXoiy8ibI3OuS
	J0YaLgFqDiKyO06Sog4zulI6J4X0KqoAURrWy1SqjwUHFoEOwLVriEo1xVBe9JKyWWHa/Iw=
X-Received: by 2002:a05:600c:a10e:b0:4bb:5e6b:2dfc with SMTP id 5b1f17b1804b1-4bb851b6663mr297035e9.13.1795087087341;
        Thu, 19 Nov 2026 03:18:07 -0800 (PST)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a655db6d45sm9766011f8f.33.2026.11.19.03.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 03:18:05 -0800 (PST)
Date: Thu, 19 Nov 2026 11:18:01 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v9 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <av7a6RNSDSFH8t6m@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-12-smostafa@google.com>
 <auzvygiGRTWgJXzF@nvidia.com>
 <avGk0ilyJh3obmKx@google.com>
 <avJidXM9yQOX4VBJ@nvidia.com>
 <avL016l_xASN5paR@google.com>
 <avNhekBYqiiZ9IM2@nvidia.com>
 <avW_9A48mtnK383x@google.com>
 <avdI5olRpBdKeE9C@nvidia.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avdI5olRpBdKeE9C@nvidia.com>

On Fri, Nov 13, 2026 at 09:29:10AM -0800, Nicolin Chen wrote:
> On Thu, Nov 12, 2026 at 01:32:36PM +0000, Mostafa Saleh wrote:
> > On Tue, Nov 10, 2026 at 10:24:58AM -0800, Nicolin Chen wrote:
> > > On Tue, Nov 10, 2026 at 10:41:27AM +0000, Mostafa Saleh wrote:
> > > > In Android, in that case, pKVM clears the FW (called pvmfw) that loads
> > > > the protected VM and authenticate it so any protected VM knows the
> > > > system is not trusted. This part is not upstream yet. [1]
> > > 
> > > You might want to double check a dual-SMMU case, where one gets
> > > accepted by pkvm driver and the other fails and so bound to the
> > > main driver.
> > > 
> > > It seems the pkvm driver would still pkvm_iommu_register_driver
> > > and carry on with an untrusted SMMU. Would it also clear the FW
> > > and mark the system as not trusted?
> > > 
> > 
> > That shouldn't be possible, if one SMMU fail the whole thing will
> > and the driver should clean up after as the probe is done through:
> > 	ret = platform_driver_probe(&smmuv3_nesting_driver, smmuv3_nesting_probe);
> 
> Hmm, if I read __platform_driver_probe correctly:
>  * __driver_attach() doesn't propagate ret from driver_probe_device()
>    via bus_for_each_dev to the caller
>  * bus_for_each_dev(..., is_bound_to_driver) at the end also returns
>    true, as one SMMU is bound to the driver while the other failed
> ?

I double checked, you are right. In android we have the following:
	ret = platform_driver_probe(&kvm_arm_smmu_driver, kvm_arm_smmu_probe);
	if (ret)
		goto err_free;
	if (kvm_arm_smmu_cur != kvm_arm_smmu_count) {
		/* A device exists but failed to probe */
		ret = -EUNATCH;
		goto err_free;
	}

We need that also here, I will add it in the next version.

Thanks,
Mostafa

> 
> Nicolin
