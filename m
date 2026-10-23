Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792792315;
	b=4DkRWyLKrL00o8qzlWvZ8C15grPLnjEzTGTgUnUVs+xkXuT5ZBUKiHQQg3YcA6xOxeu8
	 oyAWFUI/GBitY/kCsLAFOBsdffH0wCSnozujR0NBr4dUtu0HmQJAKI1mbJ+kLk76F6+sT
	 npEsuCURsk4VhgSJezPGqp+YawoJXgpuqezfNfPKHhev/aVfO6FTTWcB6RRZfUAjorkSb
	 IXnoZAdhxqo/SLAZqw1fWhlzQ07EMDlzUiR3Bt6WR8zrsG8OGc9OOXxwdNYfTk7I+bseV
	 dPzoaHdiLeDN7UjCh3tKgUfpg/Lh85QoYiUOnvLAiRBBdHL7/lqimIGVoy266jNbtjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792792315;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=37bgzHVD8y8sAVNI32vtF0/e4Mt+8V5lKNPa4buINEw=;
	b=5USMcxG42XhaAzHX7M/g6jVkTzeCFf8/JnVCOdj+P3izEICet6i2X9rpaKpjiCyCo3dJ
	 lDycPApoeYJfgNwWYmvnASbi5JZRql0ZNKmIYiK3OyxiFm1qLuwgr74yx1aD7IOMTQeeQ
	 p8P3QtZihgmVkvf099O6PdzP6k5M1oTjyv2cd96yXul1nStEU2gzrKe+4ULUiQZXD/8KF
	 R1cYK607SAREb39OT1o9IAQFXB2W7DMns6dOB9y5QQz4jmuRlQhMAYMEkRXIe+56Q0Mzc
	 4wEXCcZmYM/hkWAo/2fEod9yXy4HofJnyDNsCuUjslJzbJalOjs3HefHE5Wt972pvtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rDT6Lh0I;
	arc=none smtp.remote-ip=209.85.208.71
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0FB606A324
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 21:51:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A0FB606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rDT6Lh0I
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a125f5b317so1429354a12.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 14:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792792313; x=1793397113; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=37bgzHVD8y8sAVNI32vtF0/e4Mt+8V5lKNPa4buINEw=;
        b=rDT6Lh0IRK+zeM2Rdm9rpEpmV8UTIzCyVJXaYGmAf7T56l6CWDg0+1nAUNuXQdhDT9
         CjcP0YQThcSPTPDW6/Uvy0Yvq0X2SByuyhrGvbCwfEhPIhOTOSSa3TYtRXrXhvIsNg+P
         0VvW6TzbDYa4hCv13rCOg6diH2aCs0tsz1JHTZ/E1War8hDeKIg5xripSotRcKkx8TJP
         Z8rejh8Yh1G2mW040AgOxbMPA1htiMPFYD0Ro3jEtnb1iMpfuHpx434aKM30eaekJ6vf
         D+uA6/enF6IvwSJS4ZGTafvUtpNpmQYbs+xNxOjw5ZOEX63QPzqYnrbSfae/mTs3v9DD
         8G5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792792313; x=1793397113;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=37bgzHVD8y8sAVNI32vtF0/e4Mt+8V5lKNPa4buINEw=;
        b=UaZ6X9RpbVFBhsAiXx58Q6+l6w4eXIseZXxfbWUrs7gt2mlV1jiaG+BKlsNm25A1RO
         a7+OjMsOBR1pqs/mV3A2t7KuDnsSJ6InhIGWZYrAp4uXZ9ETvX1G5bdl3lNWfAHtw0My
         wooUJk3x0/ImR3zvRCZ1xhesnMbNGbsyso96f9pDoGZHEb8Se1PzNQHZM1OAggld0S+X
         P5yDXp9ztLwCGDDXcrLyi13RXp6fSAalNysW9I9FlJJjw75hkOWmGBSGVUhum44VxW99
         T/47ycTO4JDMc/XbRORfwaghtl9PMbprYMC9Wi52K9DDKdOH36qtDg8f8Btra4XVf2uP
         TsdA==
X-Forwarded-Encrypted: i=1; AKwUvBxmTP9QMaVYnIUYmnom3vQDqvesEeuMBTtrJWBbu5zyd/9YfcKcdZJNEMVL1D59TMD377oBh0A=@lists.linux.dev
X-Gm-Message-State: AFq9FYLkqTBFZEM4RDjw4AdR1TELGVGnfSqyiVZNKrt7UgEyRuPoTIB3
	4NJZ51uEjTrGeV6XHI8cKfFF2DCD+a61XaQQ1V1hplBN1WpkOdiS62XX79bopNPCv1oQNmoJwOw
	9ZVUXh5xMVFnG/2erNg==
X-Received: from edve18.prod.google.com ([2002:a05:6402:1492:b0:6b3:c422:923c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5191:b0:6b1:b97b:744 with SMTP id 4fb4d7f45d1cf-6b442ff3810mr590380a12.32.1792792312470;
 Fri, 23 Oct 2026 14:51:52 -0700 (PDT)
Date: Fri, 23 Oct 2026 21:51:51 +0000
In-Reply-To: <atsQQcUiVhb9KXWZ@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-2-tarunsahu@google.com>
 <CA+CK2bC_wc4LxvHe0TREbBP7esYW3pcMNtkGK-kqvf6MyvOh2g@mail.gmail.com>
 <9huzik2u6hs5.fsf@tarunix.c.googlers.com> <CA+CK2bDyk=F7W3J=q3pKCjsr2wy_PLdgqgu+ywp0F5HL=VoMpA@mail.gmail.com>
 <9huzld7q4zjz.fsf@tarunix.c.googlers.com> <atsQQcUiVhb9KXWZ@kernel.org>
Message-ID: <9huz33twf5l4.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 1/4] liveupdate: Rename handler compatible to name
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Andrew Morton <akpm@linux-foundation.org>, 
	joro@8bytes.org, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-pci@vger.kernel.org, 
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Mike Rapoport <rppt@kernel.org> writes:

> On Wed, Oct 21, 2026 at 07:35:28PM +0000, tarunsahu@google.com wrote:
>> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
>> > On Wed, Oct 21, 2026 at 2:16=E2=80=AFPM <tarunsahu@google.com> wrote:
>> >> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
>> >>
>> >> > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@goog=
le.com> wrote:
>> >> >>
>> >> >> --- a/include/linux/kho/abi/luo.h
>> >> >> @@ -84,18 +84,16 @@ struct luo_ser {
>> >> >>         u64 flbs_pa;
>> >> >>  } __packed;
>> >> >>
>> >> >> -#define LIVEUPDATE_HNDL_COMPAT_LENGTH  48
>> >> >> -
>> >> >>  /**
>> >> >>   * struct luo_file_ser - Represents the serialized preserves file=
s.
>> >> >> - * @compatible:  File handler compatible string.
>> >> >> + * @name:        File handler name string.
>> >> >
>> >> > We are renaming from cpmaptible to name; I am not sure that is
>> >> > necessary. We can still use compatible for the same purpose as name=
.
>> >> > Unless it really bothers people, but for me 'compatible' works just
>> >> > the same.
>> >>
>> >> Yes it is necessary, For example if we have two handler for a single
>> >> subsystem. We should refer it by handle this or handler that, not lik=
e
>> >> handler with compatible string this and handler with compatible strin=
g
>> >> that.
>> >
>> > I still feel like compatability makes more sense to me. Take an exampl=
e:
>> >
>> > We have two file handlers for memfd (i.e., FH_OLD and FH_NEW): one has
>> > compatibility =3D "memfd", and the other has compatibility =3D
>> > "memfd_next_generation". The user chooses one of them to preserve the
>> > memfd data, and the compatibility string is saved alongside the FD.
>> > When the next kernel scans through the registered file handlers, it
>> > must find exactly one that is compatible with the preserved data.
>>=20
>> I will open this for vote.
>
> I'd rather won't ;-)
>
> "compatible" does not contradict more fine grained bitfields, and still h=
as meaning.
> Just like in FDT world from where we inherited it, it means "these ops ar=
e
> somewhat compatible with that serialized format, will check the details a=
nd
> will know for sure".
>
> And IMO we should keep it.
> =20
> And please, trim your responses. I had to scroll 463 lines to see there's
> nothing there.

Okay.

I will send the v3 soon with feature flags only. Also I will drop this
and its next patch, as It will be part of other compatiblity series with
exporting the schema to userspace so that userspace can make better
decision in selecting the handler (As per the response from the other threa=
d).

~Tarun

>
> --=20
> Sincerely yours,
> Mike.
