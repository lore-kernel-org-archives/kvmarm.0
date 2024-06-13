Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0FD137914
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 12:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281747; cv=none; b=Rb56yT70MprSYOy9YiTKcRsmXHg7YkJ97lDpteUiHmCx0RBfP/Dv7ZHeKxIrfdozc6YmulfhcYWhyKIUjJu1ZjYjCexrIivzGNElK4Iln28b8+aw59f+hd6KKOn9TMYBBLafwRJ6XlY42pEe0A9qTjXJzXJZYNJCnm+jl+aSNeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281747; c=relaxed/simple;
	bh=ZQr1/K4f23/ybKQFINkZ4Mvh9i6Y52jFysbDIWiMqSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emI3iF/vUYRpBp8gxS2jL8nA6UPNdjWrxWctt64V0WF7a54Iio338cJHVGTYHyIGGrEwkTfFP2Qz8esenNb78dR+/UxbgNq9ROAJavntN6i6pOcALPPToCIfQ70EreuKSQxHgAilYn8qtIZUSJrGOGoXmglnUTocpieI4w4m6R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WK/a/jGw; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WK/a/jGw"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-422954bbe29so58655e9.1
        for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 05:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718281744; x=1718886544; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J0fEuFqzalyC11tgCJL2olWAZeSZgE1wRxfqpcISgXM=;
        b=WK/a/jGwbJUs1FRR5ohUSC7JMje77Xf4OLI/vYQNqM9cjDDYEatxGallpVGPoBhx0r
         BUmi+E2bZRAXMLOCmlXoumPAgDUnNu97/i8kl9+xN3oxqtUjo4Rwzl4QY0JHjnMIG4V5
         KJrRTTizR4S+Rfdy6AXN3oAphl8hwOhAtVMtHtpoJ3X4tm+twont5VXcmUHwIOzj0AXh
         vx96FZNXKkTlCD+jpO97wVYyMK+h12xbyHpEB58rWI+LKiLl9IWcib+IvJxcjJyKjTm7
         Lymq8Yf6L9j98fwbpm1/LPjqEd4UBN0uwuURYDlEMCB95fgWTyBHWHMKlZ63PO/nhEwH
         0tAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718281744; x=1718886544;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0fEuFqzalyC11tgCJL2olWAZeSZgE1wRxfqpcISgXM=;
        b=VUdnasIzI7PS+VCUof18nwyzR39EpFe303URbA1pGE2ZeJbmbH+0dwe6RKfu6IDgol
         w1mHx8/7ErBmzCVYWZFMcIr8dFkcMTInJZT20SdbMp5x+lON6Kwrg2yLJLx5hhRpoRDZ
         GwKpA+zJjJcDGr0bLLxJOX4OsSVvy3/znD4ggyK0XKvhEzY1A9WQAqEjapxQY5FpNlNh
         xQHNtBKB9ySaWgdnaVP3tQ4wvMa4AB4/EBUU+2VPODONn/JfmP4anM8kyvTez9Ny3sNC
         d6LTn4fY4Q/aX65jb41oYXccVuzb1H+F3cpYLjpAyXeppsC/VqcjowZliH+DDsnIaVMg
         BM9g==
X-Forwarded-Encrypted: i=1; AJvYcCUJKGj9K5mDtgZcB4axfU1rkxSa4L5UwoiTzjUrHM5hQ0gvbKLjGNvbjeXLELhsOrK630lW692QZWlUCTsptg9v9O8QIxO3
X-Gm-Message-State: AOJu0Yy2PHorwVRHYHmX4i+QSioQ+kYQQLlf5zMC7xIKLIwjYtZgB0IQ
	Sz1ML5UmNhDI6Y4XnsODUqRZx+BXxkoXIFUhlnzdzKQc1ffUuXSt0f0sxutq/w==
X-Google-Smtp-Source: AGHT+IEYwF3dbYa8WWBR2FOETBShap+ZaRRBpIecfX014Bk1dlr42J+E8CnlmGuDyWnxRW8ohwrAxQ==
X-Received: by 2002:a05:600c:1e1c:b0:41b:4c6a:de7a with SMTP id 5b1f17b1804b1-422f2aba180mr1330895e9.3.1718281743540;
        Thu, 13 Jun 2024 05:29:03 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ca390b493sm133521e87.161.2024.06.13.05.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 05:29:02 -0700 (PDT)
Date: Thu, 13 Jun 2024 12:29:00 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, suzuki.poulose@arm.com, tabba@google.com,
	will@kernel.org, yuzenghui@huawei.com, lpieralisi@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
Message-ID: <ZmrmDHEoZoOXmSd4@google.com>
References: <20240515172258.1680881-1-sebastianene@google.com>
 <20240515172258.1680881-3-sebastianene@google.com>
 <ZmmxBWIerq5Durve@bogus>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmmxBWIerq5Durve@bogus>

On Wed, Jun 12, 2024 at 03:30:29PM +0100, Sudeep Holla wrote:
> On Wed, May 15, 2024 at 05:22:56PM +0000, Sebastian Ene wrote:
> > Handle the FFA_PARTITION_INFO_GET host call inside the pKVM hypervisor
> > and copy the response message back to the host buffers.
> >
> > Save the returned FF-A version as we will need it later to interpret the
> > response from the TEE.
> >
> I don't understand the context of the above statement and this patch.
> Did you mean use the saved version to take apt action/decision within
> FFA_PARTITION_INFO_GET handler. Or is it just missed cleanup ?

This is a missed cleanup I will drop this part from the commit message.

Thanks,
Seb

> 
> The change itself looks good.
> 
> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
> 
> --
> Regards,
> Sudeep
