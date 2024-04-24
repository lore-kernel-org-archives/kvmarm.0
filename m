Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CD215B12E
	for <kvmarm@lists.linux.dev>; Wed, 24 Apr 2024 13:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713963984; cv=none; b=KNrT8/onVrrFmvkDfYsVW6SsuwZ7nM/w6WSaRDHD1lL38ffW+BRTeemTVfHVRV38ftgUBA0/xfK9DjHkfXLD+Lvco9U3wKXgCA7VNwtJD1V6ykY/N8EExzS3LhWEnaRPVwR2tKFW16ituF+ztiPt5FYi1Q/WmrvCUGzmmO0N3Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713963984; c=relaxed/simple;
	bh=1X/4OOsHJ1KCbUAws4NmpoimMT/p0DvtpIV8MG8B394=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HrRTDttvqmK6MWzJnEeroyolB3vmcJVlXY3D0vVPTX3rKXButY8pVeda5M02xgBNJzRB6qktvwoO8gYj1oJxVOD4D7ctjOYvWQpF7t2WSCwVz17btbdM/h0KFQI7ecoggdfp5SeGF/nikDKhrFrc1rXWtdPFVrj6fTAFMHcj9ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zMrKFIll; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zMrKFIll"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-51acb95b892so6169214e87.2
        for <kvmarm@lists.linux.dev>; Wed, 24 Apr 2024 06:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713963981; x=1714568781; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oXPDyQAT+HitFMuQv0udxwIiXElf7T1dd2oYrE6rTrM=;
        b=zMrKFIllWFQgeRwxSKLxtlw1dbsX50TMPJDeYGdk7S+3nmylVcjKtcTEjEHRw2RFS8
         GkGL/Mm1CpRfP3+nVWZABvvsCc27KIWMYitawTeh0w236rpvsNjszV7hBm4WVjBBmPUc
         ePc98jofq4JfnnqWT3/n4ANduuGmO7PkYWxZVM+qox51VtYp9BfODg4NhiM5VpBoZCPA
         pnY3QwquPxTD6IbGWYyK6pHk7/lDK4WmflG4IwqnjB/lvpo5Dc6b467Sp3e5oCiineM7
         RvWgOvDH8osYv43ZCMUjnNo5AospBDAJRswn1zuagN8fBcYPIzcqq+a8iL4zBS3vxyVK
         oe+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713963981; x=1714568781;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oXPDyQAT+HitFMuQv0udxwIiXElf7T1dd2oYrE6rTrM=;
        b=u/osmnrESO1cjrCG+pXOhhABMjUztcyziSbM+EhryOvUFVbNKCQyEO75YsOkoIOolU
         ZND1dISXoHoZhu2wk8GdPKLR/C7mCJerdSLK41wM9DYKoOz9c/iGw0A+T4sHECVPJX0k
         DYrSlo5lF/vJ3oG30Ej6DiaWRjw5mkPaaHCU29MrbKIxGa7n+7qXLsp0Mmy/9qZAYyLd
         GRo0z6e2cwreaLVQ7HUf6ovpLSB8SIjxfNxYXYXCVgtPyRcFoHk6aKAH17g5GJNs+mRT
         09UOSnttqLz0jVElRePXz1m2L8d2nPO6sIXSrnqB3kz/XvKAvjWsZJv4v7sGP6EX8muW
         BRmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUz4SzUsGUxys1Ys6cxi76Kt5t6jqrMvvqjXaWBNUYDpXl2xZxdMPSeqIG3pWRBk1GwTI+302e5N5+F1m+MPUcRGAZamQj
X-Gm-Message-State: AOJu0YwU8QjUrdkhZq5B+5pHF6mUKgFQATsJ+3nNWifrNdw2tbH671UR
	yp5UCN2qJNUfNFT06y5lubHhTcMflVx8OM1Fd8IjgakUiYEQ31MATPcf/SxVrBqOTit+D1vLoRj
	kHow3yiSqe6ddFfrAcBTqQ6xWVXMqNE8NgI+AxA==
X-Google-Smtp-Source: AGHT+IFefKvAYRBqhr8QCesj7hq8WHWt10BLztHIAMclGVcycqHpNCSNgO9jv0EcYEOBsbpQ6CS9FIGy90LZsASyIU0=
X-Received: by 2002:a19:915b:0:b0:51a:f31f:fc6e with SMTP id
 y27-20020a19915b000000b0051af31ffc6emr2425780lfj.14.1713963981412; Wed, 24
 Apr 2024 06:06:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084213.1733764-1-steven.price@arm.com> <20240412084213.1733764-15-steven.price@arm.com>
In-Reply-To: <20240412084213.1733764-15-steven.price@arm.com>
From: Thomas Fossati <thomas.fossati@linaro.org>
Date: Wed, 24 Apr 2024 15:06:04 +0200
Message-ID: <CA+1=6ydMVk4Vcouc2ag8G7tfqZy80VWFxWHSHEKF1JaABd=A7A@mail.gmail.com>
Subject: Re: [PATCH v2 14/14] virt: arm-cca-guest: TSM_REPORT support for realms
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Sami Mujawar <sami.mujawar@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven, Sami,

On Fri, 12 Apr 2024 at 10:47, Steven Price <steven.price@arm.com> wrote:
> +/**
> + * arm_cca_report_new - Generate a new attestation token.
> + *
> + * @report: pointer to the TSM report context information.
> + * @data:  pointer to the context specific data for this module.
> + *
> + * Initialise the attestation token generation using the challenge data
> + * passed in the TSM decriptor.

Here, it'd be good to document two interesting facts about challenge data:
1. It must be at least 32 bytes, and
2. If its size is less than 64 bytes, it will be zero-padded.

cheers!
