Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778F910FD
	for <kvmarm@lists.linux.dev>; Thu,  4 Dec 2025 00:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764806719; cv=none; b=lNQyCi+KSUWoNpDlsnEsuOgqJponQHQ9trVMtjQF0HBRT7ii+AaoB7bOM78foMMngXSEo0qZjtkWx6sUtSkH9blLx57hZzJGSpGwItgufRN+PxKwnUjPO3TbQ7Z/rkv/G7hvryU1hc6Wa1hP1p8BeDGVrl8Q5R3aI8ESkufT9S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764806719; c=relaxed/simple;
	bh=x5mBtF42C9vuyDFwHE+YA3ZE08rnQOGA8Etyfdi9gMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=My2ZTQra5mO+XJJX3Je1nJPKjYs8Y4NeOwr7bCLGjGIVC7u6uO5b4xAgRwqbKqg9lNqT99TgV/yZm3Sonk7Kv654SdVJ2Nv4SUTqXS+cpOSrJbY45bU47q/CzBCXvdEaP/fYAg3npb8H6UBI1wvYvamrJNM/yZyCI2z3ooBIYhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KlEfllmq; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KlEfllmq"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5942a631c2dso492627e87.2
        for <kvmarm@lists.linux.dev>; Wed, 03 Dec 2025 16:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764806716; x=1765411516; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zd9WoFQTvNfYXS0FutJkOHLRDDNZG45Z8fkn2eFEtfA=;
        b=KlEfllmqT5owU3xyfA1GuiqwtMbA3G/EbT56dhSPyq4SGRGgfOMC9ARQ40bRks0BG+
         X0hLK3X9QNS44OxylcxUfugZ7lYWmW6C2+GEtRe40+IxNP76U8AHL+Sx95fwYAAj3t1P
         8rzFRD3aPgTCx2G2r/EYTuJeIQVMToNdEe2sXgkqIFd1y/vnJ41xTcZOyV9uvIYXUsCd
         qgxk5CnqEaSxdZEGmB2wuQ9qWwmykokhRzWPpRcVazqBpQ/kuEt4goiSOdk7gOxxjNsE
         b3It05pp7fRulTslusU2wO8AqzocYdjh1aThQ6tX2/+0QPaVLv5S1mTht9luHkJyuMsj
         kiDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764806716; x=1765411516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zd9WoFQTvNfYXS0FutJkOHLRDDNZG45Z8fkn2eFEtfA=;
        b=jlFB19drLxe8oX5ry63GJ3K0D0pMLmsGvHtVQwuH4rRgWXIhcECUpw4e4ZP0W6URZ4
         762BkWoQUK24oyvAimMjkLG/MEc2kShfQoj2srY+RmHpBISlgqCeLfGb6or7WDqbRC68
         Pdsp5OFQh1RcDax76Gr6I5pPb3U/HiWzKaJsEZbgfMcnIZD+HU+dh5rlmJzskC0atb/V
         og7MVovnBs/LvmFZP4RRlLzAjVjJnDzFZsLwSEDBxC8LCVLQd61u9hF2kOCp8B5Ju0Xe
         WSl+CuVYJ34MhL53RnDa3gItE/j+E5unw7WRyn7e/0rqgQuq4KrNbyJMx15utW4PCo8V
         ABLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW02cfET/+t6Sh9bTZnjvxOT/6emmqObgwdBOSeOyguYxe23J3sQrfcFRFPxVXsOYjpGEanJNU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yynz0cQNXf/LQck24nTtAmH64ure7ikQdrCTX+zOwnftzpHdtnb
	yAKdrw9A/LL1RRW9gyr0/tc8+1DglAwvEAqpU5v50C/T/xRW1fzDrtyo4Ldbm6mfwmLyahemrR0
	Q0Woa8QIsyyyDrH7EBfSATse1t41vjmZmQwoVuWvT
X-Gm-Gg: ASbGncuy6K+XsN1d/rf8XEicOm5vTE9tWwzktbnFS7RtPlfHrOO5AOLw77a1yXPiUpK
	kEreSQAFmj5CZAyOqKoU/a6pKdyYTceQ7SX/I3s8FBRTN+orZ6KJoADA27CrmUPRU3HW7cSvIGp
	dH8RkR57IH1dInOHJBtMTVOy/losP0UfaFlzC0yPeTTq5Exu35b/97RsxyrptE1Zc1IQkAsUjCZ
	bThzBsL3DppuqAcpJGahHnJDTumZpblF6wCM9hcRSa8WGXnUSK37RimEln46YyVvY7m7qbB
X-Google-Smtp-Source: AGHT+IF4CyNFKv3NT4Ky0XeOn1TQzX5YXD6kxpQuevTbiLqvfi0Z1H0r6mqBjI/VHgPS5RUsjZgaT368W08YU9UmgDU=
X-Received: by 2002:a05:6512:12c4:b0:578:ed03:7b5f with SMTP id
 2adb3069b0e04-597d3f7b821mr1673675e87.26.1764806715139; Wed, 03 Dec 2025
 16:05:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com> <aBPhs39MJz-rt_Ob@google.com>
 <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com> <aRZ9SQ_G2lsmXtur@google.com>
In-Reply-To: <aRZ9SQ_G2lsmXtur@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 3 Dec 2025 16:04:47 -0800
X-Gm-Features: AWmQ_blvUOA-vJuP7PArgXkGtxVwcyZaljS6okCvAjRlV-VnKxXpsCQN-Lg9GyA
Message-ID: <CALzav=fN4FpZsfzwbdLeNSj4nx4OpRkwHvKiZNVgP8S-zsUvJA@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 4:52=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Oct 17, 2025, David Matlack wrote:
> > On Thu, May 1, 2025 at 2:03=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > On Thu, May 01, 2025, David Matlack wrote:
> > > > This series renames types across all KVM selftests to more align wi=
th
> > > > types used in the kernel:
> > > >
> > > >   vm_vaddr_t -> gva_t
> > > >   vm_paddr_t -> gpa_t
> > >
> > > 10000% on these.
> > >
> > > >   uint64_t -> u64
> > > >   uint32_t -> u32
> > > >   uint16_t -> u16
> > > >   uint8_t  -> u8
> > > >
> > > >   int64_t -> s64
> > > >   int32_t -> s32
> > > >   int16_t -> s16
> > > >   int8_t  -> s8
> > >
> > > I'm definitely in favor of these renames.  I thought I was the only o=
ne that
> > > tripped over the uintNN_t stuff; at this point, I've probably lost ho=
urs of my
> > > life trying to type those things out.
> >
> > What should the next step be here? I'd be happy to spin a new version
> > whenever on whatever base commit you prefer.
>
> Sorry for the slow reply, I've had this window sitting open for something=
 like
> two weeks.

No worries, thanks for taking a look :)

>
> My slowness is largely because I'm not sure how to land/approach this.  I=
'm 100%
> in favor of the renames, it's the timing and coordination I'm unsure of.
>
> In hindsight, it probably would have best to squeeze it into 6.18, so at =
least
> the most recent LTS wouldn't generate conflicts all over the place.  The =
next
> best option would probably be to spin a new version, bribe Paolo to apply=
 it at
> the end of the next merge window, and tag the whole thing for stable@ (ma=
ybe
> limited to 6.18+?) to minimize downstream pain.

With LPC coming up I won't have cycles to post a new version before
the 6.19 merge window closes.

I'm tempted to say let's just wait for the next LTS release and merge
it in then. This is low priorit, so I'm fine with waiting.
