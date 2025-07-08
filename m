Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A902B20F091
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 14:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751986000; cv=none; b=TKB3TEJpoHjOwcwt/+oyDQyS7gIy/+XB60AY8GtOb1Uq58tr5XqoZUVDOZMzjJfb5N2+TAtWxIGSfGcvVslcu96GJY9c/oFEC1cIBk4frdRFFm8Foad3e1+ec8P96Nom08R9L/iahhYZ28oDZPZvBpNPwHFIgzKj6OoZ3Z0RSmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751986000; c=relaxed/simple;
	bh=rdaHkwEgySzssWJnGXU8iu178barphVuPjFKEHZYUfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OoHurfJvxnUtIK2hl6pEv0Ig9AGvGsfG9vwgdsrMWsxld64j3e5on0yrnUEgn38pRAkzHIT2BpzsmrKFeatFiKj1S2yIHYRGSkdMeeEGKWu0qF+JUq8j8hbyQr+JmMOu17pdxZAtMs0K5eJD6t8GipFsggjVcKJXLIa1yd+JGOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THN/15Oq; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THN/15Oq"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b26f7d2c1f1so6119317a12.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Jul 2025 07:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751985997; x=1752590797; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0P5JXJKoQne0+91AzBGnZ+7c0bfri6L6epqykQQTaN0=;
        b=THN/15Oqc5E4VAf0jtm7f7/F0tJlEf7uKzd0Bo8V1E1qeu9j4SLVWTSXzJsSCw2KAM
         /oE/bJwB4HTCcoPLKL6V1rIzmt6cE/+vpUA8WMFass95laM2TxnyCTkh6fmDh2MSvDyO
         wrPyn4puCXBblzkKnVlTsjgNOXfQ+VwkDmIdXhpPhzlqyfCpNMV1Mf26+LWUwVBKgHNT
         IQ1Cac1iukpCrBnWUusQXepQQSCWnp8yAib6RcuDOrpMewX7m2pf35UdVzYP0904oQJG
         2OBgcfF0cBUYuNXIF3AEfnzJwIr8qPJEe3asQ3jt9TcyneyKpDmJhwy/IrfIi95LxieH
         tlnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751985997; x=1752590797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0P5JXJKoQne0+91AzBGnZ+7c0bfri6L6epqykQQTaN0=;
        b=JzXSrvsHLvNjZcSrjKW7KytYrxaF30BXP41LnNeJLbPf/MG8jM5M4PBqFj24NfoVWs
         KE0Fk+TuGRmm7zOTsfbWjkgPWdLANLej91lDUmTV/O8zgTr2+JTCVkLzrHhoeRXAMsiV
         evIwZU2XRFCQFAvuFHtcD994OBCm8cbEkHPbQjOs4LDgw2lvj+9bGe7ABBJS0sKiZSKo
         vqT+3cotVSh5fwTgjDH/Z8Qlx4i75AK9JZmwTWSl2/kETHezBfBiTUOMyvjlLVP0YE/8
         lz2OQGQmepT9F2meNZDRIztfHXlXgB7C+IGxcpxFQ8+N8CXCXuI8g6b+T4QgMkLcmbZ8
         aVfg==
X-Forwarded-Encrypted: i=1; AJvYcCU5WiDXwn6qwzAnPPrgt5Gk1Ccpir834xS6Tp/iYRdKcRLq5HCycYzc9oiPOHZj1tf27FqjBx0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjuGab3ujTkuUAlBxAqLTIDFWDWqJypmODt4T1+iwFqTKcFK47
	P88iFEiPEn0CVeiwg7fMXwRkKmtvi1EblE2jOP0i5Ri9e9896BN78+IO
X-Gm-Gg: ASbGnctF50Zg9IYGSDtjtog/0geQ76Apo0n2pwmTSuUdGT9vgqH+dvfSu3apZdNTRgw
	acroxUL/kxcVTmc5g/YtyFQIRVEikxRPBmnQQZpo+sS7PGU/5UHwys6ngGopXQio6ZFuG5Y1Zu5
	bfCAaA97y7jh3q4NJIU60GlR2suzQSchcXbBjjHdffFNOo+x3kLwx5KnWrjO5S0OA58NgzxD6If
	ns/u8nNpqFDe+4qTs+3rcb/OmAlYxu0rnI7q07VinJDA3csrvTt4gFWjaD5QRqMV+5nLthG/uPF
	F1OMn9/4PGRBVVQ9u+F43WfPvgRnmZAHzWQ+e/6/UuXxSxSCXr7Up+RxBAV4eA==
X-Google-Smtp-Source: AGHT+IFiqdSlCbU4zD//x0lPXI7pA7rphxHL2l3rMZn1TfraBPWBfii1gmAYrhU1Zmp/y07HuF1+6g==
X-Received: by 2002:a05:6a20:258e:b0:1f5:8a1d:3904 with SMTP id adf61e73a8af0-225b7f19802mr30657387637.7.1751985996536;
        Tue, 08 Jul 2025 07:46:36 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee476152sm11695895a12.24.2025.07.08.07.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 07:46:36 -0700 (PDT)
Date: Tue, 8 Jul 2025 10:46:33 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, catalin.marinas@arm.com,
	will@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux@rasmusvillemoes.dk, linux-kernel@vger.kernel.org,
	james.morse@arm.com
Subject: Re: [PATCH 2/2] bitfield: Ensure the return value of
 type##_replace_bits() is checked
Message-ID: <aG0vScXkDROkdASW@yury>
References: <20250703135729.1807517-1-ben.horgan@arm.com>
 <20250703135729.1807517-3-ben.horgan@arm.com>
 <aGv2WoAtxnEgqV4y@yury>
 <03a76e9a-86ac-4791-9f0a-494b28c07fcc@arm.com>
 <86tt3n9fsh.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tt3n9fsh.wl-maz@kernel.org>

On Tue, Jul 08, 2025 at 10:45:50AM +0100, Marc Zyngier wrote:
> On Tue, 08 Jul 2025 10:42:06 +0100,
> Ben Horgan <ben.horgan@arm.com> wrote:
> > 
> > Hi Yury,
> > 
> > On 7/7/25 17:31, Yury Norov wrote:
> > > Hi Ben,
> > > 
> > > On Thu, Jul 03, 2025 at 02:57:29PM +0100, Ben Horgan wrote:
> > >> As type##_replace_bits() has no side effects it is only useful if its
> > >> return value is checked. Add __must_check to enforce this usage. To have
> > >> the bits replaced in-place typep##_replace_bits() can be used instead.
> > >> 
> > >> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> > >> ---
> > >>   include/linux/bitfield.h | 4 ++--
> > >>   1 file changed, 2 insertions(+), 2 deletions(-)
> > >> 
> > >> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> > >> index 6d9a53db54b6..39333b80d22b 100644
> > >> --- a/include/linux/bitfield.h
> > >> +++ b/include/linux/bitfield.h
> > >> @@ -195,8 +195,8 @@ static __always_inline __##type type##_encode_bits(base v, base field)	\
> > >>   		__field_overflow();					\
> > >>   	return to((v & field_mask(field)) * field_multiplier(field));	\
> > >>   }									\
> > >> -static __always_inline __##type type##_replace_bits(__##type old,	\
> > >> -					base val, base field)		\
> > >> +static __always_inline __##type __must_check type##_replace_bits(__##type old,	\
> > >> +							base val, base field)	\
> > >>   {									\
> > >>   	return (old & ~to(field)) | type##_encode_bits(val, field);	\
> > >>   }									\
> > > 
> > > So, would it make sense to mark _encode_bits() and _get_bits() as
> > > __must_check as well? At least from the point of unification, it
> > > would.
> > Could do. It seems less important as there are no obvious foot-guns
> > that these would guards against. Would you like me to add this in a
> > v2?

Yes please.
 
> > > How would we move this - with my bitmap-for next or with arm branch?
> > 
> > I'm not familiar with the branch machinery so can't comment on this.
> 
> The first patch will definitely go in via the KVM/arm64 tree, probably
> as a fix for 6.16.

OK. Then I'll take patch #2 v2 by myself.

Thanks,
Yury
