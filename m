Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF68318DF75
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 13:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723123010; cv=none; b=CqRhG1iUKRzSie+gc0K/Swaw5kcc24/ICAEA+mdQrbE2/qX8pyv8h6Llp006H7d6iYcFAmWJm6UxWJmn1bkB9t3KmojeOO1pdbtPH1HwQwcfINy15Vvcx6ifD1UdGnbnrJLrO/Bd+7ftYzwrkTPvjJTLAxQUQSKQvckW5cvM8xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723123010; c=relaxed/simple;
	bh=SIRHTk+m4P1RNpcxL6rwR5xC8tZQja2BIbrMKp2HGV0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XbhNpKlVvKyap+C9ThE7Uoorq0Dku4W6ubjVp1PumEyudO5sD6a/AGxRXpsW2sXOjmcPiwkcNh+YKKBpXxroYq0hO7qvsqq8Wlv7YsP9QPwck8q7Grb/0KItX7wCX0jqTJBFBtwvgvGKzoy24bw/fJ4MKibdlIMp6G1+9QplF1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EsJQWJmP; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EsJQWJmP"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d1a747ee6so1088241b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 08 Aug 2024 06:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723123008; x=1723727808; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ep+xfrS41+80V4sejFNz0q3mTB6TQE8jTTfF1Jh5lTI=;
        b=EsJQWJmPoNQ84VMOpavP3ll3u7lGZzJywbfhAODIUVOCOnI0mn5Ncy7sIct+bZ22Dn
         fj92WOFc0Jm51XwOLqosRowsQ3O9ttHWLVSYBY9mwG8NVFL8/j4u0QBTt2tEmORpvx1f
         XORB3QAmxwvTLvwPiKVb3PlfrzdKT6ejKzM/oEJ8XLN5n6eCGPmhx4PCJWk91EL3wrFF
         ijCg3WWin86Yyxx+vpA97l14/Suf2B+kWEsWbvsmO+ssQaxza9CBZXV2+rjkRVVhjmas
         I048xvK0Oo8hTSnsVMJENFHEsg2n5IUvWhkSYVs0TWIdSsaXh17vPI+XZyYxEwNQVGQ/
         GsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723123008; x=1723727808;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ep+xfrS41+80V4sejFNz0q3mTB6TQE8jTTfF1Jh5lTI=;
        b=T5dWNhoK8oDF1lnZ7jqrcpqafi2n81TQyf3WPniN9bA53b6+Y9XOrgKgDj3BLAV5BY
         j24QrKLonegAa5S5GZ1POzEM3WuLP5PsYsjRGfTngF9tk/OwcEpHNGiCPhFQaUIsQVwz
         Cecv4tmEjUTvzVhc3RBENrsEtI3mo7Wti99wehLFhf4twvt2IOKFGUkA9ZhWPUe72HQG
         KjbIf6NHh0YYXai2AZXs25R9K9PeiPmuz8CJhGkRVgT/9JyBm/hN1xvBgIu59jG6R2nd
         ZQRA/qFOp62p755iF22gWZ78RbQo9lIXdcZRh5cuXJ8G53kVtrq+YhaPCZAJhyw3ihK4
         bpUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1w20hrcEcCzFgZ4/kRXpWu46vA5vi0hxZXwSBtaHP9erOnytI4ptB74hoTtRHgjidVN98qopXewUD24t7JyJVjQAaaRVr
X-Gm-Message-State: AOJu0Yxq2mGSzPdyV3oKDz+NLFwJhpOPOnEUiA0oe4zyXl7BuwBP4Cey
	10x6CgUUG3GiBVwqOD8/5zke+G0ujeAwff44+WZcUAF2o/QWtio8jREW80zTkimUF1rciy+d1za
	9bA==
X-Google-Smtp-Source: AGHT+IHJBsGw5UgR/iugxzmSr+QeSrp5dZN/v/XODES4sTP0wn0G9d+/VHKS2R50We/GZxKaCQexvWJSP70=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d8c:b0:70d:2a24:245d with SMTP id
 d2e1a72fcca58-710cae763e9mr108614b3a.3.1723123007877; Thu, 08 Aug 2024
 06:16:47 -0700 (PDT)
Date: Thu, 8 Aug 2024 06:16:46 -0700
In-Reply-To: <87bk23ql6n.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-14-seanjc@google.com>
 <87bk23ql6n.fsf@draig.linaro.org>
Message-ID: <ZrTFPhy0e1fFb9vA@google.com>
Subject: Re: [PATCH v12 13/84] KVM: Annotate that all paths in hva_to_pfn()
 might sleep
From: Sean Christopherson <seanjc@google.com>
To: "Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2024, Alex Benn=C3=A9e wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > Now that hva_to_pfn() no longer supports being called in atomic context=
,
> > move the might_sleep() annotation from hva_to_pfn_slow() to
> > hva_to_pfn().
>=20
> The commentary for hva_to_pfn_fast disagrees.
>=20
>   /*
>    * The fast path to get the writable pfn which will be stored in @pfn,
>    * true indicates success, otherwise false is returned.  It's also the
>    * only part that runs if we can in atomic context.
>    */
>   static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
>=20
> At which point did it loose the ability to run in the atomic context? I
> couldn't work it out from the commits.

It didn't lose the ability per se (calling hva_to_pfn_fast() in atomic cont=
ext
would still be functionally ok), rather the previous patch

  KVM: Drop @atomic param from gfn=3D>pfn and hva=3D>pfn APIs

removed support for doing so in order to simplify hva_to_pfn() as a whole.
