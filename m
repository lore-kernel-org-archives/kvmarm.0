Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DFD13B298
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 07:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714116075; cv=none; b=qR0LZWXmbbaBOdgXUCoJ6gnt6uMhAsyp3wj7XoCo/YAW19KPB23t1Ep/m4i6avg+P/SLtEBA2FHPWYCxDOnkhq6k3rZXHrxzfVX6a4tfCd2WxvAYjxdqlTwfddgDq/gNREefUBdZ0wEyD892WR9LCg/Xugka+nBvs1YHFEJ0RKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714116075; c=relaxed/simple;
	bh=rANPXM6l2rPw4aYc3tXkotjAQSSZfwwMFUVoI7/VEqo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mZpwVi8EQOllQjCHaGAXEsrckEN3HuzbfypiUlE37ydQbm0NIgml0jkx6ToZMviKa4mNM7Zarpbr2S2Dnhh5VXd6n9tZyamzeQF1F0wrZedG6dowDgq0PsKuA1yJ0sVb5ZYQnS3a8HvmWgMS80zWWNsAUDy0hDzBU8vwXjBmqbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GhONS0EN; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GhONS0EN"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-479c8f43ca5so473327137.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 00:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714116073; x=1714720873; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rANPXM6l2rPw4aYc3tXkotjAQSSZfwwMFUVoI7/VEqo=;
        b=GhONS0ENtrbrFE5Tu5vD3ggvsgqFrefk8tssiNQ4aK9TFgdynninuWocsLITu/HhlD
         lxHYF60ZczUfbykluVD5VoZSoHKiqxk+UFnvQjOQo6DINsVhcR6BG9BOxmujNqTQXPbE
         VC6MUQnfNuS/umdavkjbv99L7TIZAtNrwTEyLeBuP6MwuAiDM8n9LlAuZSNoQlxTcPCi
         SGA/YWgcYXmLQqda1igUTf2564uT4vR+ydLnmPUgkzSdmhP/Itjnx1VonihHz6EHi18X
         sWmG9MxwH2YH55jCJs/Go78jwg2SHh0KNbZmgw5njKgwbETD/CBDQ7xyZ3lzTtYPCVYG
         9oqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714116073; x=1714720873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rANPXM6l2rPw4aYc3tXkotjAQSSZfwwMFUVoI7/VEqo=;
        b=fVvpnGYIjCJhjMqVyC047ZmzbOvg5Gx2VgCaawkf/Mid7zr2Nnss8Km19WpXAiWzdC
         k0jjLA2TaOxnlEN1AJfTgvMWcEOyQHYy3uia9j8BPvt6XEoX6uNGLysX3Ev2gtZftjHU
         kAqpZzLbjwWAtP3pg9tzjHhpOctHTpz4pmypvPXot7M2QTZhYtULPPLJSgeQ50lNVSfk
         hnmvE+ywOLLcvEQgbnY3IFpp+gu0gD9fz+QPh3ffum9sgx9sJWtMfSS2cYxcLmJXjeIF
         Z3rI7SA2eDhRJpKDN+lX7oth94AaFr7/3vjvy4o1eU/eQYBlehirSttDUmxwCescdocK
         d52g==
X-Gm-Message-State: AOJu0YxFZRC1Y+t1XMav1I3nf17+DgQXObwRb3xIQBruQCYqXrWHVOOt
	F7vYxx9sDeqqJXi8lrW16EXSnhbTnxHy3ceNJA1sfUIzrDVb+qmzpBMrV7gYkWONybo/aRPnp+z
	2h6pDBNBGAibm5Vt8uVEug2vIbFYjyZYsPrr8
X-Google-Smtp-Source: AGHT+IFjdhVyp32ZpHSQDjEmsyuj45UbL4GPHPIFvpLcBn3VDDRt7EAwXotkkY2oBeQY0ar4w9H5S0NlriJ/8jS7ZBM=
X-Received: by 2002:a05:6102:24a6:b0:47b:5eb3:85e1 with SMTP id
 s6-20020a05610224a600b0047b5eb385e1mr1669258vse.33.1714116073008; Fri, 26 Apr
 2024 00:21:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com> <20240423150538.2103045-22-tabba@google.com>
 <ZirfWVZ-PsET5Aii@linux.dev>
In-Reply-To: <ZirfWVZ-PsET5Aii@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 26 Apr 2024 08:20:36 +0100
Message-ID: <CA+EHjTzPoW8pWtRaPksL7oE73R-sP2GHWmaznq-prEcPr3VdxA@mail.gmail.com>
Subject: Re: [PATCH v4 21/30] KVM: arm64: Refactor calculating SVE state size
 to use helpers
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 25, 2024 at 11:55=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Fuad,
>
> On Tue, Apr 23, 2024 at 04:05:29PM +0100, Fuad Tabba wrote:
> > The main factor for determining the SVE state size is the vector
> > length, and future patches will need to calculate it without
> > necessarily having a vcpu as a reference.
>
> Unless I'm missing something (which happens a lot), I don't see any
> users for sve_state_size() in this series. The refactoring looks
> fine, but let's only do it when there's users for it.

No, there aren't any users for this now. I thought it made sense
though to decouple the calculation of the state size from the vcpu,
since it's not vcpu dependent.

But sure, I can hold on to this one until the remaining sve patches are rea=
dy.

Cheers,
/fuad

> --
> Thanks,
> Oliver
