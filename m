Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D5F326937
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 09:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768467791; cv=pass; b=dZqYFLvr4oAa34YybPSl2wrVpc5QpPalz7TvcNqvsgvqjH9qgc6QVC5M5zDuxILikI0Ljo3ZlUduTcyBishQSiEzj2dkCxUubDLfxCXoir3xxICWBxfhqS9jsjrJLx21VFaJvIuWYFwQyn/wxRbfLe8Tq4n9X6qOGJt06DOrnxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768467791; c=relaxed/simple;
	bh=03g5GHo7VUuroNdnNffpeJG0qnrQfvR4X6uMf/z1OKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MqwlZRNoT+D/XX4vzuuj2yUd7aFPuG2S3eyPJUfZbOi5liGhW4KGaeoDERi3c79wALN82CoNFFNO8kVBvaAj1hXGz42VfA0zng1AKTH4PEBJxjT3I+60Za26C+DAwvhNMyKQCod7+ZQFpz89Obqrtmvl+6JPTmuIoaZeNqTKFh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2V9vosrN; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2V9vosrN"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5014acad6f2so263191cf.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 01:03:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768467788; cv=none;
        d=google.com; s=arc-20240605;
        b=irgMQ1tUbb1cM/rx/LzjZcHB7O6cG7gNn0/Uju1/MhVsc71+71dwN2siD4NunGHzOv
         V+Vd8BVPRLWCQIXBjmUYLNdXZlTSDecSyMrNcZtLCfBQRVjydMkA7WcUwlRSeaqbn2p9
         qxAHPyTVX17vQ/TcnjPwDZTDxa6n9OHl7Zn8jEHWHxPy2TzjFJtXxB8UdWrGkbA71LW0
         g0VfLrtAa3tQcTJOBmztUzrPWr9IpTSgTRWUk+8Xl41PoSoZ130KEJFArOPd4VGnO0cQ
         MyVMsip0HJE84aVuSpIboNyqwPkVMxpbg+HZHojfOoy4ThZmStgV9CWw4o2SI0czxqGt
         d+FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jaHTBHlKT0XpapwOdZ2HklxNZ/MZMO/Ynn29Wqw5zNk=;
        fh=bq6GaEX5DdAv1Q8w/xZMrGqMeUIOs4UVU4SIv0bH6IA=;
        b=IZZHhGzntFKnSe/E1jTab9bfvq3qMxrRFFBpGy55Inib2QV59E/vfii1Yix5gBHLOq
         IDQPY0/IZ28WQ7vTxe14JhPWYYGiqX3WVEQ7+CGbvhMSQ0sXDBr+eZluGiNot24Me5PG
         aFEZupSc7eZWJ+LsZMbzg7RURXdsKz/p/GL5HsVxJEzk83Nv7Dn1ELGK0hhfnJxBIvbJ
         B+9HKo9PTk93xec0nEv6FOEevAtGHDTg7ZgBjHOzPsZjTUC1z3uC0+4tM0rPYtOY62Us
         /92G2M2BRkpcqJQEig2K0Au6SUVY8WFIs+ttF5LFGuXD6g/vUe3/HdHtVVE4b6LVEhvo
         vT7g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768467788; x=1769072588; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jaHTBHlKT0XpapwOdZ2HklxNZ/MZMO/Ynn29Wqw5zNk=;
        b=2V9vosrNywHKknS6eGOmL8j5uwjHK2XHRNWsJdQ+RgLQqZa3GqsE/XJQdB/wh2p4Bj
         Bs9jRz4ykTe7DhOHZ9lt5zFV0KT87YMO7jcTlImpH9VV0j7KIH6rzSn0RKxOlYvLOeam
         XgIjiSR++uxx0kSQSGK9NB0FJvCdTg9jx1emoA3y4i+BPcYONoVWO9FydHw5QSU+4Bg4
         RRBaBKGzeja+3HcjP7SOasy0bioowjPoN/a8XFsKUBVQXZ6l5XIG0UbuIwA1j9afEZF+
         bZs0AkUSF7C4EAuvXCoBeiXstjcU4yfO1sNxeo5Vu7GBZS8pLKEfPa1zWiPLKoc6TPkw
         u0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768467788; x=1769072588;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaHTBHlKT0XpapwOdZ2HklxNZ/MZMO/Ynn29Wqw5zNk=;
        b=bq+Kln1nGwPO1a29MjZI8hLnT9physRTbRqc9Tsm2VnVYnBEBnvwNOieaBVSfuei3Z
         QGuNfINYe2LKe6m0Ga/MWq2ZCXCAmQf8tNjinityzant7+sy5KuNW3wx0RCv2NjC0cHS
         uNncvaa5vAEWk4zXBDXB11iU5Pwmd2Cietw+fyicdoFpgrhyyWIghPsLO2dynDXvz9qm
         WGlopwHENHWOXbEIarZhcVWKnLSOgQj9q1TVXLs955qwGwiEINNyGAdBjOkX90vast26
         LFFExshMd8kT1MvV/hkJmPABpT6WLgt9deLlx/dE/rgqZ9U6ujWqq1BP78bIexsm+x0I
         Lx3w==
X-Forwarded-Encrypted: i=1; AJvYcCVwbT7J/+5wTDSosSj/eKH9zvIXS/WNuZHvt3yraliSPPrX7/3zV8Szt3fevS+9e4YDgGHyl5s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBT37+SkZFPoM3LUnCrozNWOcNWsyiMQ+9v4tLqjzjL+Cq9vmU
	1d6Xet+bCPlMAy1hVZIUt3hRlps0BxY8n29i4/8wUA247UuNdrUYsETEbpLUgEfcY7lUKHPS8yV
	OzettLptpT74Vrnf7xY4X0PnPC2oOLfUfUpPGWc02
X-Gm-Gg: AY/fxX7E29oq4xgMiyZKsCNtOrmlnQQfqLLEzWp+TxmCPQaww7ZvZiIS9akmQY4gs9D
	CqgS4T1j0eke/BKj62qcJaDiBzeAH1H+OAemdmcyWepGzs0vhBYrtYLKoqUlFvIRPcPed9jOMpt
	XQeNfxi3+auhwGElXlKQeHRfkL4sudCa3DGUEQvp8Pw1w3sFNITq0dfG+VwjxjJKGsqNQUTRTpJ
	iSlAb8KUjulDIBLJeGzqEmpIm+PFtXtYwHKOF6MboYpBbc+bn6WHyUZfuglodo7YCjoVRBj
X-Received: by 2002:ac8:5dd3:0:b0:4f0:2e33:81aa with SMTP id
 d75a77b69052e-5026ed4f925mr5343061cf.11.1768467788106; Thu, 15 Jan 2026
 01:03:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-23-8be3867cb883@kernel.org> <CA+EHjTyYcrWwBR0AwwdWFfOSwbmTMOhSee7y_-vrMfOxphrvqw@mail.gmail.com>
 <5a053bb6-5052-4664-b0cb-f05d56d4679d@sirena.org.uk>
In-Reply-To: <5a053bb6-5052-4664-b0cb-f05d56d4679d@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 15 Jan 2026 09:02:31 +0000
X-Gm-Features: AZwV_Qg4xCZRn6ebTpsQyf1oiKPYkQGhv7VLsovgzCpdoBOU9QpCHpXoiLQKrWU
Message-ID: <CA+EHjTwMs6BzZwtcNjyZnxLb9Gs01B1RcDvo1RB-f2w98eMzFQ@mail.gmail.com>
Subject: Re: [PATCH v9 23/30] KVM: arm64: Context switch SME state for guests
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 14 Jan 2026 at 17:28, Mark Brown <broonie@kernel.org> wrote:
>
> On Tue, Jan 13, 2026 at 02:24:56PM +0000, Fuad Tabba wrote:
> > On Tue, 23 Dec 2025 at 01:23, Mark Brown <broonie@kernel.org> wrote:
>
> > > +#define sme_cond_update_smcr_vq(val, reg)                      \
> > > +       do {                                                    \
> > > +               u64 __smcr = read_sysreg_s((reg));              \
> > > +               u64 __new = __smcr & ~SMCR_ELx_LEN_MASK;        \
> > > +               __new |= (val) & SMCR_ELx_LEN_MASK;             \
>
> > Similar to what I pointed out in patch 15 [1], I think you need to
> > preserve the other bits, since SMCR isn't just about the length.
>
> This does preserve the existing bits?  It reads SMCR, masks out and then
> replaces the length.

You're right. Sorry for the noise.

Cheers,
/fuad
