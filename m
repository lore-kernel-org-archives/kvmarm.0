Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4F541C6A
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 10:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739442590; cv=none; b=L0bgvJJfO27OTVfv2vDRaVuF4XNwoen8/BGmGDC5bjn5X60yFKFfo9JzwrPr/19OYirwjOqRwP7u2/po+msaPd/XO1y3xjUFjsCSGRwqKBLHADeeA7wOz7PlWV8c5y/qv3I4xF91X0iWDUxa47KbF4iP5Hlfwd40WNfqAh7C/LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739442590; c=relaxed/simple;
	bh=iDH2mAPI1dc+oNCI+jprC1LnlVjmBy3U7iiSh3qJEe0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZE4BhArp736iLWO/MMhL54ogpsoQBXKDKZOjh3E9PcpUMwBoeu/137UlpjVDAIotoAXvk3I0qLMD4/RCTpzOa+7rxmQxSSUr5jTrn4JWhJK+1SGjPyVXFiqakw/8Z8lQs0qjnnHf2gpavZNK5jy5VUkLjPZU1J+jINDDBdPIID4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XiuZR5oQ; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XiuZR5oQ"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6e45dbf15c7so5342436d6.2
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 02:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739442587; x=1740047387; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iDH2mAPI1dc+oNCI+jprC1LnlVjmBy3U7iiSh3qJEe0=;
        b=XiuZR5oQOlQOuIyXBuFAeT08womwnOPLwGbp8Ops56Ylx9utsBvjgajXBUYkx55CIZ
         d9GSlqJAi3mlCC9QvsBMyyNcA6VMJ7A8eis4AJs3UgsQxVh3wxSgbjI7Ft+jirijx8Gv
         vWC+Jof/ut+2a179ZaKeRT7bV0Na7hAfTHfBal5rIwMRmJYelShDf4LAJJ8t4TlUbl/V
         r+Wb/pPpouBoUxz8JyxOFoFgRKCAAzGNfXzM9PiJaJDNiZja6RTX6N20j59+dDrH1zCA
         WJ2LMxJeG0daw3o3X3KhjBxAxzLUlZ0zkMYigPWMDHl3UERWHou7v2tjcAC7lt9yqY14
         7rFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739442587; x=1740047387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iDH2mAPI1dc+oNCI+jprC1LnlVjmBy3U7iiSh3qJEe0=;
        b=O61w+gTGmTNqz0A5JiAztmzbyjAJM4JX94Wp1rzJ19r21Md41Nu4QzUx9Il/dp35In
         GfDXDr+1CzrY0IVnTcaOA9NQAUhWJ0Z+yxakcbpiAVJzSrrFctWynaGwF4ZWpYm+1gqY
         O4hYfONQYOTMgxB87WlDU4j8y6CcZ6GDNMklEpAbVp/YAC87XP8x+iGVZuHqfSh+1IcG
         VBmkndjzBGGkxhI2ByK1qEHZsGcjN2RT7VCsIWyF2CkZ5gh0odwpiEpNMLyB1kR0WF0o
         /D0f16cmmhT3mmHDgL8onyKMRfnClTup0nC6QNKjOJsJDdW7K3VxwPbmS5P1WjLw3mKw
         MDcg==
X-Forwarded-Encrypted: i=1; AJvYcCUm+TNYi9OIwm6pESk0P7qpdJhE7UkXpLx7z0q17QjE+TYL8ygnxPt0Gb5AsxUL0MdKX89TWpw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCuzESC8FOu0PpSyDoWsyq5suQKa8/q73mn+5+OBVWPwn/58+q
	8H81mbHih0pdTbiXhcrAtL4GE9NDDcM4zvjO5so5v2pGj/eyVfEyUoEkH+Pq6k2l3Oy7OuJKlb9
	CDnx9e0hCVPA6mcQltGkuzJDsgVkLIikQHqG7
X-Gm-Gg: ASbGncvm4eJRp4o4A6pJgYCPdFK0OTGtsNz01kMEqVuYbe0wdZwu+tUlb1bFJz4YmCm
	4B4okh4s9X8QVPogihJVH6wWBFf/baXQIFd+1W+91hLcqMPrOCtCs6/pbUnUqBsCn0Nng1qo7lr
	15j7SAyMH+ifBxtAc2NXzrJd8s+Fk=
X-Google-Smtp-Source: AGHT+IFSuewblnxjgj5HnSVadvSSuC/qdEmqFfvr9Q9PXwmIlT3F19JHVcIhx52HuK/by84c3/uhvL7P/3cNQ+kC7m4=
X-Received: by 2002:a05:6214:f61:b0:6e4:269f:60fe with SMTP id
 6a1803df08f44-6e65bf1a860mr53983996d6.10.1739442587576; Thu, 13 Feb 2025
 02:29:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250212182558.2865232-1-maz@kernel.org> <Z618Rd__s7g8xWNP@linux.dev>
In-Reply-To: <Z618Rd__s7g8xWNP@linux.dev>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 13 Feb 2025 11:29:11 +0100
X-Gm-Features: AWEUYZlpJcerqPZRSnhliHHFx2Y2i8XCh23BYfHNVZxojxkfWkjFhjBvxm-zDpI
Message-ID: <CAG_fn=VYXBce+0S7=ZuggNKvn4-b7awWVtq4v9B14U9ivRimkw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Assorted vgic fixes for 6.14
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 5:59=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, Feb 12, 2025 at 06:25:56PM +0000, Marc Zyngier wrote:
> > Alexander, while fuzzing KVM/arm64, found an annoying set of problems,
> > all stemming from the fact that the vgic can be initialised or
> > destroyed in parallel with the rest of the guest still being live.
> >
> > Yes, this is annoying.
> >
> > This second version takes a different approach at the problem,
> > plugging the glaring hole we have between vgic creation and private
> > interrupt allocation.
> >
> > Although this is more invasive, I'm more confident about this one than
> > the initial version I posted a week ago.
>
> Much better place now! Here's to the next pile of syzkaller bugs :)
>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
>
> > Alex, I'd very much appreciate your testing on this.
>
> I too would like to see the tires kicked before we pick this up, if it
> isn't too much trouble Alex.

I am on it, will report back today or tomorrow.
