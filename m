Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC32520A5F5
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 11:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739360588; cv=none; b=mEjJFLUS2XomIVl1kZ6TIvRzt1+vEfggYIYHIuPHbhi2FVCXrW2eYOhFv8meXGTRhrA+TZiGU1AIEbkxGJMN+yesHzU8mURakAcv99O5GanDYic1SZyZ/PW91y1sv2iGcMO1TjlxwDZKwzLiYG1gO9jjNDHiqqK2/DrjfbEFyts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739360588; c=relaxed/simple;
	bh=NhqxhiZpfWPEn6pagf0thRaPnjSAZWlw7MZOS2drRSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HRuwT0VD/mBXHBwyhLNTeAslfCRCEq6tHXc6dgTZNSyvkkZtjdE6YpWErljbFmrbUgME1ZWzDEcREbvpP4oQw9NPpP7h+FRLyaKqV2idAISbfTZpP3FGGnXRybFaptHaAXg4X74qQ+3HqBiAVp64P1/iBcvmnZnKZVDICBbgeaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vaJN7U1c; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vaJN7U1c"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-51eb1a714bfso4154046e0c.3
        for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 03:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739360586; x=1739965386; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n3Pf9VLqr0zn74ybOM4AB3R6LkV9Kq24XCYfLCd4K6s=;
        b=vaJN7U1ckL0TmaFo3DNdkr3UnKe9XxpDYtRbh9+UndRuq6SmvVLL3GeiKR8pcTPEwU
         dbdvxwJvniEQ1cEMIIjMsdGEizalDX3TB6FPMn2ZVOyWXtzVxVJOn13Vu+UTZuJ6hmCl
         W1p2Z0ixb3yqfhs94KfkmLPDRqeEsghiuhrtqWvo9wzD44mthtlEb2C8NYXOvH086JkB
         Ucn9muR8mgHIGUJw4Ak1VGmhJBHm8eTFi2vu6NvwKMh1euYskNXXSziwl529sYBUuny/
         MxxdypUWnXXu8yS3Vq1A+2DQqE2Hg8vY+TTKaU36+d9ekXbH7VUU34OR14mQstis+v3P
         KmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739360586; x=1739965386;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n3Pf9VLqr0zn74ybOM4AB3R6LkV9Kq24XCYfLCd4K6s=;
        b=wTAxiCaqYTI4+jIQOgtqNdfNra9q5fKYaM0mkx1TobBLBIK/ByV8VvLjEA1g45lgLl
         o53nL8D1GlbzKQP1IKx6VlI/ah0KAZjWHIywlrKZZoQXsZOHDmZ8xsA0q6D61anSjOB1
         W8XFnJ464rkWIcYg+uLvOG4EQ9iDPe78Q7y5cOdr/tHQAUv4bvSjbaPziocf0Rs23wIk
         Ya0NGvaF6OcIPlDgE/FciAqEZXeSFY28lWyFVteJkHavsx7TNEHpb+8Nix+foAd8P861
         0uX351doz1NjVkIDih6v5Hal2S+uofm9+gOU3anM6VAcx0YyZWUfiVjDeC6I2nzy4f91
         NZWg==
X-Forwarded-Encrypted: i=1; AJvYcCX6dkj+gzdeiMo1xzCdghHh0l6JFC7wdqekdZE/F2wn4L2XWivMQNRH7I4lXFtQcKFKKw+W8Lw=@lists.linux.dev
X-Gm-Message-State: AOJu0YywZrwA+NywfVeP/rSnhe6OB5YCD/UG/8MUNrE0lMsoH9o7PlZ+
	5SVZz5Ta8+1r1pPHh/RpaSWTbX+50Ex/VLcC6ZsXe+X/L5e6CqOuqp0lkURCLUfhPQCdc02Bf5H
	Zn4NmqaGdnsiN0u5ui2LLfq6ZCfzJ3VJG15GYGw==
X-Gm-Gg: ASbGncsJK4eaKaWk3eIHbfJaAVzRF5Sc9SzCcBy0f7jdhEvYOxgvF78ka0BAJrA4nkO
	2Ye4J/f0Di/QJkLITGL65ug1NBpY9BD0Mo2gGQcNhSIFcNbWqZn5ELOIFneznOO86vKwX/89pbi
	E=
X-Google-Smtp-Source: AGHT+IFOih37+KrqDaHnv2z1gD470AjQX0R923clhFtL4aKxyGDPMwXe6xkjFhG576o5Jmtsc4iPKFF92U7xej2AN4Q=
X-Received: by 2002:a05:6122:3c4b:b0:520:42d3:91c4 with SMTP id
 71dfb90a1353d-52067b4369emr1897998e0c.2.1739360585770; Wed, 12 Feb 2025
 03:43:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CA+G9fYt6Cuu6=OO9w80yhJbZB77Q0qf7nzYdvjbgDbgAw6t1jw@mail.gmail.com>
 <8634gku30g.wl-maz@kernel.org> <3902208d-8814-46fe-ba98-3db833b9a886@stanley.mountain>
In-Reply-To: <3902208d-8814-46fe-ba98-3db833b9a886@stanley.mountain>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 12 Feb 2025 17:12:54 +0530
X-Gm-Features: AWEUYZm2GCz4FlZi-oNTIdRy1QPKZCSG3F-OJRaS44oBL_Jsi3XOtSmcXBGZNeY
Message-ID: <CA+G9fYsjW2U0k2XWBESRpy+xpn8hHGYTEV3TQu6qdeqj7fu6OQ@mail.gmail.com>
Subject: Re: kvm: nVHE hyp panic at: __kvm_nvhe_kvm_hyp_handle_sysre
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	open list <linux-kernel@vger.kernel.org>, virtualization@lists.linux.dev, 
	Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 12 Feb 2025 at 17:11, Dan Carpenter <dan.carpenter@linaro.org> wrote:
>
> On Tue, Feb 11, 2025 at 11:36:31AM +0000, Marc Zyngier wrote:
> > For the crash at hand, which clearly shows nVHE, can you report
> > whether the following hack fixes it for you?
> >
> >       M.
>
> No luck, I'm afraid.  It still crashes the same way.
>
> https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/anders/tests/2steTT4f2J8ZJjc3jNJFMuow9Cb
>
> Click on "Logs: html" for the dmesg.

Anders tested this patch and the reported issue did not fix,

Link: https://lkft.validation.linaro.org/scheduler/job/8118315#L1379

- Naresh
