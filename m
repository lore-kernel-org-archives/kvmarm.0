Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792632406;
	b=LhPuKu1xoqq5ZNU4KcF5WTUXhttQgDkZOQrsgJGkmfFWMWAQ6fJEIZVYGxnvHgo8exAo
	 SLlCql4epGen5wlGwbnM86johPOMGRPSN2lxF6zj6hj0PH1nTHTDxOx1gUrn1eeUmSELe
	 tA7wWgDNY21mZG1C9+8ai2sQUihMBd7RuqWgDmL48jagRGnvqgfXvTXeaCFaTKPeGAz/S
	 Tgwg1a/ESzIrV/TX9PLp/8KGxLq8iNpawxqzJV3qoX85e384BzRisQ9v7wV3HasEZZWeE
	 jHfaKexNdOU1DKFq5YiaEB11tHokJ3NtBledt/dq7++gdmWhQDXUMrlUu4/Ss3PcGkQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792632406;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=o28ydFuUHHD4c/U0AkyEgOljfI5EK57zWWg+tuRSc8Y=;
	b=xwzM6pNe6aXokiBMAmamsQBq+9oEUFosxpOkqZMZVgV8utgZkubA7N77r5uzzu1lMbUC
	 Ne4LSaasT4tJwomE3pgKhNru2oFZqJOrVBSv5HcBnjoHSx5gQsy4R00QoSjLRxE+FRaum
	 SiEokmLfUs4fkyAiQdTlKMjy3p4ZlQuJQ/uDG7tobZVA6tO/jlemLNOaTwrt2glH/depw
	 eIzETSplN8uQwHDBm97AUK4Nhne9viegnKZjg9zO9Y8snutpGVA1BCPhkHeKwU3J9zDSS
	 6lsOasv4Zd5q8weXehQ+Pu8wnOJr2cOQAjmtXGGCLqmLirGECFQgbjFBsqUCKl6wPzA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=WrqDCVUJ;
	arc=fail smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A49606A31B
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 01:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34A49606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=WrqDCVUJ
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b1f4d8e09aso1997394a12.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 18:26:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792632404; cv=none;
        d=google.com; s=arc-20260327;
        b=HH06B7Qp0WaJ91OkkUPCDpi8FJ1i2Tp2rtuV8rX7Vzoy9D5C7+gKUDE02pmD2kABi2
         n+fJ/fvRE9oy7FKDWcVYy1uyuk8El4y24syNWWmTQr0B626RGznTTwuNomkB1tLxG8QA
         Kg1Jbq0NuhkJuRldnodd3HxgSy0Yhl8DCSOqBuvBbry0Su+KlMS+YAHXrxfEV9Re99cS
         oOFxFUW4S46RJGfhjfmOhzKg7SUbRMhrEGiMSbgLBh8hOO2u0aObDohtyYX4zQx2LsJt
         SYyTTr24wVFU89ChuNFo2V/5utNg8Dr4F5LfqjFYfsWI2jpOgYhWkyIJmQ7hbvQuzDLB
         9JXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o28ydFuUHHD4c/U0AkyEgOljfI5EK57zWWg+tuRSc8Y=;
        fh=INgUrp4GtU+lk8u7TKvbtoLk/MNtD/5qGmDrGeJpXYs=;
        b=L+VbJXxp3FQiWYJ3d0wq95a5q4XlNnUqxMc1zN3OHvcIcV/iNOS7ySWozvotuYdKbc
         6/t5oAkE7ubRztFOPwsqnH/9trhuuZGweReW2incYNO+xVds4AFNq2NWgCtKRETXMrF4
         uB5C3+Qe75ROTPO3YWVYu9eDQnF7qeFL8Wt0JkkxeZ8tETC8G0pC5Ha7wzv36/EyvuC0
         Ul4Nysd7sIShOgZHeCrnTqlkN7t9MJ21VvrBHu6a0O7m9fUXw65Ow9+H0gDQcTadCZJI
         G1AjdHa3loeeja8zG8Xiske+Nz0kz9eTwqvTTSmp+L0MjnBktnaiSh2IgwXKZBZDLxqu
         LyFQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792632404; x=1793237204; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o28ydFuUHHD4c/U0AkyEgOljfI5EK57zWWg+tuRSc8Y=;
        b=WrqDCVUJf0uooMZGbZozEgbjqSA6sDmH2exsIupV5QcGGztHHbg6MCl2kNGC9Iq6cj
         Yj4UInvPsF+70mB9cZQ6YRngJQIxts4JhXjT0wVvvcYtStL9oO2Y7UIxJRCoDGyse7Qg
         nRL76yXt3o43DrrFJsbpkyMH+jWVLYaXJFCdJsicJPfqULXNq8fE4PG97vf7rA2BQ9Lv
         uNxSJFv49GNPz6M8JnqG5e+ktSsLoUsPKPT17WCVe8NesYNt/2utU5zhwRb+toSTcHL0
         jaFxyWoYTPoEnFx3FNKX4mR0zl8MSEnmPhZWNSt/w2WCIJ/Kywm7c1aFFhrtfopQT03z
         JHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792632404; x=1793237204;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o28ydFuUHHD4c/U0AkyEgOljfI5EK57zWWg+tuRSc8Y=;
        b=qRSaAgzgu0nzpnCiNuQOyl0jwsOjI7FYg3tLkQmeUUOHZFc+XDK2naC56OUJaQ3XFw
         Xm70iGjPOXv8JXj4DXFrvbSDAdnEE1mShd0ZdwYfJhiwmg4Cq6yK/pOFVE8/+Jl1cAtD
         0SbIzWBZabEVY8tIleaxpC2lGiyvMKDH6wkRWVwvgtDp24Ztc2t4ZHwLcD18hWfgNK71
         EeudiEypZ6r6NK1Jh2lyam9R+cLx18TEnBKdEJEQX5Nebjl/NBywIj8QX8IikynFQqZJ
         Z5VWUdYNqkI+cjUGY60kXiL8kAOfTcHq3Y/g5Ek9r3jutu+p0g38mMB3sKdk0n62Jiuo
         ItmA==
X-Forwarded-Encrypted: i=1; AKwUvBxtWq2UDc1uE/3kM7CIDPSKK4Bt4W2K7dW9ivHhLV8AdyapiZ3aavCG1Bi/aUXvNDCpymO7jPY=@lists.linux.dev
X-Gm-Message-State: AFq9FYIAd178t9dMFfcWXjqwULL+IB/BoyP5eXBmdImAXxnPOOVonMdR
	dXtI8rDcdLIwxIXgW21/7TitBe9MbpGTJ6WJtKzfA/RTCOKqJfqGZIMuZQF9nj/DHGY/1v7Ajw/
	n6YWNQzxFLiuFL3kr173KBnjwogd6KANbuJLDqA6QkA==
X-Gm-Gg: AYBFou1TP5j5eUNWNaFeqHD0cEeE3Npi6cu7HwQOk1NN9KSXXW/mzBJDthkQInwYUiS
	YVkmg/yxhVSRONPS6Eb+YEKAcuB5E+r/gas7ArKM15qefygDwQ0lVu5amZWgxaopYSlANh0v7rr
	99duenBYnoCexhuIL9m9mzBPNfXNea56WPH8h5HQoXlRhBDCYQBUgeHz9MX93soA0YWzpASJAjT
	2OtMXn60E8vPijRnKwZLR0FnLmCu7y/ImRbNWBKf2ZzJO9kGAUeuJA5aFApTP/tWOgEjhWkhp5t
	asOXT2RC54+dktMsxPYJZYW5FI7ehxHZZ7/0/t2H2ED//wxzdrtfUjC4cNhCEKvhyOaXvqkDq9g
	+mNDZMBOcjJxkEJyxvdOvGzvksz8/6+ocxVbZTjVugtT4B1TAUC+1/DUNC/ayOVj1DQI=
X-Received: by 2002:a05:6402:2801:b0:6b3:a1ad:ef6d with SMTP id
 4fb4d7f45d1cf-6b408dcce19mr2969744a12.6.1792632404378; Wed, 21 Oct 2026
 18:26:44 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com> <atlKsD-aJB3mJr2j@google.com>
In-Reply-To: <atlKsD-aJB3mJr2j@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 21:26:06 -0400
X-Gm-Features: AclHuK8Appp8OBdUFGLxu0V1hBTCm-a-9f142JZiexa4wOQOsDrRrU21F_J0R34
Message-ID: <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 7:28=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> > On Wed, Oct 21, 2026 at 2:47=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > >
> > > On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.com> wrote=
:
> > > >
> > > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > > >
> > > > > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@go=
ogle.com> wrote:
> > > > >>
> > > > >> LUO and its file handlers validate handed-over state with monoli=
thic
> > > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change to a se=
rialized
> > > > >> structure, even an optional additive one, must bump the string, =
which
> > > > >> breaks live update between adjacent kernels. Replace the string =
in
> > > > >> struct luo_ser with a feature header, so that the target kernel =
can
> > > > >> accept or reject the source kernel state per feature.
> > > > >>
> > > > >> struct luo_feature_hdr is a fixed 128-byte header: the serialize=
d
> > > > >
> > > > > This patch is all wrong; 128 bytes is far too large. For every _s=
er
> > > > > struct, we only need 8 bytes instead.
> > > >
> > > > NOO, It is not. It is intended to avoid complex mess with unnecessa=
ry
> > > > over-engineering.
> >
> > 128-byte per serialized struct is not starter.
> >
> > > >
> > > > >
> > > > > The first 4 bytes are the size, and the next 4 bytes are flags (i=
.e.,
> > > > > 30 feature flags + 2 reserved bits for flags extension). The last=
 two
> > > > > bits of the flags indicate whether an extended flags field is pre=
sent.
> > > > > Each extended flags field is 8 bytes, and its last two bits indic=
ate
> > > > > that yet another extended flags field follows.
> > > >
> > > > If we will have dynamic extension of flags, Think about this.
> > >
> > > To support dynamic extensions in a backward compatible way you want
> > > something like this:
> > >
> > > struct luo_feature_hdr {
> > >    size
> > >    flags
> >
> > __u32 size
> > __u32 flags
> >
> > >    extensions  // offset of first luo_feature_extensions (or 0)
> >
> > __u64 extensions[0]  --> but the size should be specificed in
> > declaration macro that I showed in the next patch.
>
> I think you may have misunderstood what I meant. In my proposal,
> extensions is an offset to the first extension, not an array of
> extensions that immediately follow the header.
>
> If the extensions immediately follow the header, then the number of
> extensions is baked into the struct layout. Every field after them sits
> at an offset that depends on how many extensions there are. If we ever
> need one more extension, all the fields shift and old and new kernels
> can no longer read each other's struct. That is the problem Tarun

We can structure it cleanly by nesting the payload: something like
struct { struct header {...}h; struct serialize_data { ... }p; };
That way, the header can expand dynamically at the front, while all
fields inside `serialize_data` stay at fixed offsets relative to the
start
of the payload.

Since the header size is self-describing via continuation bits (e.g.,
the last two bits indicating whether another flag word follows), LUO
can
easily compute where the payload begins in the incoming blob. This
keeps the implementation simple, avoids linked lists of offsets.
