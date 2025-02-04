Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A632215196
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 14:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738681146; cv=none; b=pExW9Z1+IplRr54W6PMB+EPirh8KJWEXnz4pFqTpmjU22FRIST1rtWlPnkv2/DVCbrdHgoSkmY1d0axSFdwjv2rrS3I4Xg4mDoG/zXxNJdFdQkTMqhtEPSUFgQ67RjOtegq94I+p8gEGxEqCt9h/D+fQS9AsC4k/Db9KNPRtaqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738681146; c=relaxed/simple;
	bh=VvuVbyENZ4auhSLsZXmdZPBYLBDDdSjtrpm9K0VajbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GBHzOP4QWdpEFWcZnb9rGHR70AdodJrfCRLemWFdOGIE0JL0hoxiIqHebhl0FZF7fYPimp/tPpTsTAXyljOnCQz03iv16NzdoULi1hcQesEA7cd+DC6E4JObTRa+fQ8dpfecVuuqNabPZE0j5bfz63NPGOtsozhOoaG+8ebEITA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O68ZclI/; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O68ZclI/"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6d8f75b31bfso45539976d6.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Feb 2025 06:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738681143; x=1739285943; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VvuVbyENZ4auhSLsZXmdZPBYLBDDdSjtrpm9K0VajbE=;
        b=O68ZclI/kBtQTKb1y8ySgatz9gGAORkZ3iwZgUBWMMwM1jEMwvrrbWFbCgU5b08OZb
         00R/aSq/meKwmFqQc81eCk9zqkRYiFlKLwD7JkOnoGX4uWqujDjjskZGvhBf/eKnGm+x
         yq0jx0xKjJ6cB5fWYJSyfwVIU20Oa6Mt7g3baGNvX8baL3MRLoW5VSVx5CTJddsqnQ/w
         K7IBItagu6kcz6uU61CEausyyqALDaAXOKyU4pLaCIb4g7TMcJ30lp8Xf5nobFehke8i
         Ey0C7w9WfoeGelWtvw5cWnjtB/bibr0xcogdbmHXerSsFTqq+woYuPfhs9CalwE9tZPz
         wd1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738681143; x=1739285943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VvuVbyENZ4auhSLsZXmdZPBYLBDDdSjtrpm9K0VajbE=;
        b=CqjIY4NNnduCPK+sjgFhC6npY2tWbLprmJ/4g09rOyO6ZzxCXr6TVOuZbm95EeSWsL
         7Ig26y8otVIYBz/SxRCkV/9ay7RpzNuOJN3fbFDjAqSr+Pnz2WQfN90GFlYfRH46aYVC
         6TovMNp5g3cwYA1kCTIUb7c1BO2qe2M6xAXcydP/yalsDSFNZMrBZx/oJU15ILGuZ6ws
         SAytpYYvTXv7tmW05S7uV/fVyuIVpl1PY9y2mY1xpZzKoBaQJ/pcsixMo4u+yY/YI36P
         1v/jE956yT/76z5qPx/YLk1EblTjIF7XSBzMb5DRHgYvRld2Zihvr6glN6md3SNmlFTh
         SuyA==
X-Gm-Message-State: AOJu0YwehRdTcMtJNkGsobsgLyOhnENQ3i+2juexUN4QSjn9Vnrf2i04
	sxyzHEKofdF8UHYncz7H40S4ywjHs4Z96v1acBiBJdsBOeAdmfvvUhtbraZxlrWzm+tS0gLORkg
	YGikZmh2/H2fzcNBDiSHNBkx2ix27kNIilBj/KW2aK6KXFwXZruJ6J9Oh8Q==
X-Gm-Gg: ASbGnctyYQVXfkJhv2Le9l+v4G8Z3bJKa+xPSGAMBi1XfBn6JKcKZNXNfApbd65b4PE
	2xrnXd5v4gLy2mGikMuptHTX506HIn690G9eu/f6hBIe+66Qqs5ECul3jKbJpRwg8InfSKrAm/A
	6tI12v3nnRT/YEdGe20Oar36RvdQ==
X-Google-Smtp-Source: AGHT+IFAhabLVqsirEZQFdf7e3ceBagVlafz436gImWiXVQGRtoLiOgMD/iOF0PfOb3rV65x0lqUxFOlRvQqftx8+IQ=
X-Received: by 2002:ad4:5c61:0:b0:6e2:3591:7681 with SMTP id
 6a1803df08f44-6e243b98b34mr367364176d6.9.1738681143177; Tue, 04 Feb 2025
 06:59:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250204145554.774427-1-maz@kernel.org>
In-Reply-To: <20250204145554.774427-1-maz@kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 4 Feb 2025 15:58:26 +0100
X-Gm-Features: AWEUYZnrGwt3ZpWNwPxhZyqhgOTVIxqgbyE89lIt7Pj4mLTXRn01AniRNLX4-Yw
Message-ID: <CAG_fn=U4jKE_D-YAyGOxAnYVudwU1s_qQeR29MZ6uZR_voPJZw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix nested S2 MMU structures reallocation
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 3:56=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> For each vcpu that userspace creates, we allocate a number of
> s2_mmu structures that will eventually contain our shadow S2
> page tables.
>
> Since this is a dynamically allocated array, we reallocate
> the array and initialise the newly allocated elements. Once
> everything is correctly initialised, we adjust pointer and size
> in the kvm structure, and move on.
>
> But should that initialisation fail *and* the reallocation triggered
> a copy to another location, we end-up returning early, with the
> kvm structure still containing the (now stale) old pointer. Weeee!
>
> Cure it by assigning the pointer early, and use this to perform
> the initialisation. If everything succeeds, we adjust the size.
> Otherwise, we just leave the size as it was, no harm done, and the
> new memory is as good as the ol' one (we hope...).
>
> Fixes: 4f128f8e1aaac ("KVM: arm64: nv: Support multiple nested Stage-2 mm=
u structures")
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>
