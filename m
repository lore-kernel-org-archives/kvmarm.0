Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A17B1A23A4
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 14:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778509855; cv=none; b=LFqpvEKeQWyvUbikBWv89fGBnRo9s5+tpbyuWNed/zWncA1Q0b7CUljRWVWvCkoKHk5WB45MwJ+WSClNyTDcNXL36b58ooV2g0n6e+j1ulGkC7RHUHCWPnVbMS3tfj53szgy6kWDqgcgylUgwMmNv6wnHIHzN47QWZc29GIcKX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778509855; c=relaxed/simple;
	bh=KyLuFEE+coaf/jJEo/cblEGq/QqRcgAQPejr03h+6d4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KEphVZ0nP7Q3pKq3qJ4IkM660rMH+87XuBCewwXS6j2803KQL9W+sYnCo/5Smb1sf2AXdKfosjhMTJxrKOXuzyBMC5CXGOE2sPR9w6BPRyDfZ4HRFF5wVyVFjSOFtpo0Z22SoQgSf6tES9UIUwlDrivD0a6ev4dqCY9gNeEBtyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ZtrHkyad; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZtrHkyad"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50e97863425so43303931cf.0
        for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 07:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778509853; x=1779114653; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1t4Q3YbgMx/6e1k8a1sHgBJ6iv/rwR+3bFc9xbIXC10=;
        b=ZtrHkyadwuhBYmESPMVYW3YKwwrKOUiaTVoSP7iXRfX5elWE/HXEiCOqikt+f9S8LT
         Bi2Ch841y7cj4zJbYBwNMexTHMU7AfCRMT+e4j+GmL9cG0iiDMHFdnFQBiuYSwdCwPd2
         lXCFhbEh8UY4gVnMEuHjyFIls81ChxdQ/uKHbXpgp8ptfhplgo+eBP5+3hvT2K1ZQYvn
         70RC2zp27aOCGqhFagdhqp+MH05gr+8KUJ+LOvG2fUV8xtebRl8pb9vS60uhGBw4NEb4
         GUuMs+d4842mAYTeQryDBaPshQnjqMBrWF1euFclXuoWp+429YKPLQlocM4clvS/BGf4
         +0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778509853; x=1779114653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1t4Q3YbgMx/6e1k8a1sHgBJ6iv/rwR+3bFc9xbIXC10=;
        b=JcF+u+OiO8jtgXbccu02wOGabewhm2wLe/ZMm07CLjmORAqUZuBVP4F+hytebVaitZ
         T0uVGeji+WsS2bP2lJFPLNdW4YbW3J3J7ErEIPb+hU+avYkYRmDguCCbIORrKTkaKpkZ
         a+cLAwzBejCOkQGVCxbbduJUXdoYHZSytixHqBuzajqWoBd9r68cqeIhaztkcojBaBT/
         KpBjLEFa1gNwsF81llRncFG59pO9fqW7FLp6gTVBeAoURMSsAqxh+L34K34U1ecl5F5l
         HlK5dbvPLiub1DA2+sRtKRCOM5VRY8WiQ1/IlFx+t5f2eiNzcF+Kn2v5JUTFpruAGxjO
         iMEw==
X-Forwarded-Encrypted: i=1; AFNElJ87+xqCoykeh98bvfj9LYvhbQ4HnOEqQFYOydpDaPwGv//LFb9cTgbVfHJ26eNqvyNwTGDSwYU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUJ8mQOp3YtyhZHalOrmlhPMQ0XVJ2SXVAtba3Rrr57sglXOek
	FjXxCSJ71EloL+zyul9QIGj3fRIsT/zDZQ1z0gahjth05j4JP0gosF6B/trs7m6zodc=
X-Gm-Gg: Acq92OFBhK2sSRKz1gzhxaNqECOdRVkn/5/wANP3JWTGqWFvpAw9dMiYFLj/a9eoIIO
	QTMOuypU9DPUV3yLs7QV+ZqO6hry7uEeOKv9TtuVjojUXf2r2XkmWmEo7zPCSd0HrdI/lZ6GlFZ
	9+G1rSWR2J02wgHHmqSoJ5ZYiJTRwmA8UnRY2pZ5ooHSRkAMT4nmyk8aOGrHL5kcwSDtXFS3lW9
	37bZf2VVaDFjdPTPoZvD8mtBzsqyZbtrZx3GDlWBNkgwh/TvqOXSqe5CYdSvbzL6fSSkb5PASUu
	pGpaJu/6TyHxHHDjMwdhCvLpidE9WPd7Pam34h3po723Lgqi+Aiwd3rUb+1PQleqncjxvtDRvQt
	HKI7jaLjh1APAxfDB6HGIE57O9Sts7m02Y+KcBKrgeUClOMrhpTR+hqFLQxDxuJYShk9PG7seN5
	miIstfmCgOCsijtag3GgnpZLYGR7qAskk+loYJ2BvRtUKpIAQ1Sd1R20z8n30phu+4smstNWJDf
	SxA6Q==
X-Received: by 2002:a05:622a:d5:b0:50d:2a76:43c5 with SMTP id d75a77b69052e-514619de7e5mr335362441cf.2.1778509850538;
        Mon, 11 May 2026 07:30:50 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e83aa2bsm90525421cf.28.2026.05.11.07.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 07:30:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wMRej-00000004oIk-12xC;
	Mon, 11 May 2026 11:30:49 -0300
Date: Mon, 11 May 2026 11:30:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 05/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <20260511143049.GR9285@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-6-smostafa@google.com>
 <20260501124716.GD6912@ziepe.ca>
 <afiODW2sVMeOj3Ag@google.com>
 <afoagb/wVBJD1IX+@ziepe.ca>
 <afofSPQbepd_fpom@google.com>
 <afsQTwO3eW+Ks2fe@ziepe.ca>
 <afxlufh3t3hRe4-G@google.com>
 <20260509233443.GK9285@ziepe.ca>
 <CAFgf54rJqq_bJONpx85p+uB68i1oVAGZW40aZA1ufid_5fqwQw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFgf54rJqq_bJONpx85p+uB68i1oVAGZW40aZA1ufid_5fqwQw@mail.gmail.com>

> > Copying a bunch of functions into a shared .c file exactly as it is,
> > then compiling the shared file with some #ifdef'ery at is going to be
> > long term better than trying to mangle the whole thing to avoid using
> > any of the core types and not directly share the code, IMHO.
> >
> 
> There isn't #ifdef'ery at the moment, that's what I was trying to
> avoid by introducing shared code.

Yeah, I think that may be a bad direction. Ultimately it feels like it
will be more burden to maintain this careful split, while some small
list of carefully selected #defines will let you reuse alot more with
no code changes and I think that is ultimately going to be better.

> What concerns me is how fragile that is, any change in the main struct
> can easily break the hypervisor, unlike if we have a clear shared code
> and defined API that is used by 2 entities.
> I will think more about this before v7 and see how intrusive it is.

IMHO so long as it is easy to include pkvm in the compilation I see no
issue with build testing the pkvm driver when working on smmuv3
driver. So I'm not worried about this, any breaks will be compile
breaks and can be delt with.

What I'd like is to minimize logic changes and maximimize re-use so
you don't have to make bad re-implementations. Like pkvm shouldn't be
building a weaker tlbi, it shouldn't have different logic for errata
and FEAT, it shouldn't be doing STE changes without the
hitless logic, etc, etc. All these things are easier to solve with
greater direct code re-use..

Thus I feel the trade of off 'use the code with no changed via
#define' is better than 'try to carefully cut away and avoid #define'

Jason
