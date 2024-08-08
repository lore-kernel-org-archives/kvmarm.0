Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D1754648
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 16:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723133784; cv=none; b=eLkltN0dul+SqD4JWWAEYje/+kpNS9+kWTBjjijIRlIsKvAocJPKB44w6qNEbHhb/ziMGH8TzSnYh1Kkz75A5iYYJ15Kzq17B5oi5PnIQzd3CRANj3thu6e7UMvxQPR/dJAp+FhQkKkBM3qgycuVWDdMUwRXVIouiXdS3Jm7pVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723133784; c=relaxed/simple;
	bh=R8R/7XxJiD8SbGw4qFqr3w25VlObii1GrVvmAIP4ewA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=N3EYTMbaORP/kZxS0kbwe9fyMYJ2k1FxmY3BdiQVBc1Wm4OhlH12krH7ipagPC9s4pisbaWWC6NccQPGPu3SHoV8PpNuVILD9JIsMFTk8e0NvEHeCKigjG77GI+gc3WMYbgBglOqqZwwS4Crg6OQXlB5N210cGzEm2YWTMORp/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qChh0zUY; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qChh0zUY"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2f025b94e07so12981601fa.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Aug 2024 09:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723133779; x=1723738579; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLPa+w6AdBa1cUfelytt4eYDYgnS/jumqOLX9cOCUyA=;
        b=qChh0zUYvzXxiznZq0ZEqBxMu3HwAVDYkpLfbsNNEOdXDe2v/NJez6CVTbmN3nMcpZ
         eeTqvtHHiavVTshEIXBruFvqa09ydn8W/PK7MTZsQnDdXU82gi8vfS15E67xbW0DWt7+
         TRhcUrI/uK33uvCPaAal6opqrJaAfvmv8SPokIHYz2LVAGrphWElaazehkQYf7ypkZgl
         oiqPDcstSbolmgBkgv1qYy20uTtEvr/oIvMKBHbsyfdwTFU3G+SfpaQlQN/UhCHKLtDj
         hPR1NEx+oVQOC70kYc2qKixLS+boonj49OhC0ZZBxePMxv+PIDQS08i0K06hPi4t8qcM
         NKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723133779; x=1723738579;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLPa+w6AdBa1cUfelytt4eYDYgnS/jumqOLX9cOCUyA=;
        b=ZPajB4udXTbPcjXeGhsLBGV97L3nPC2IY3K6vuye0AzkVmTxmNsFrer5BzsKk5asLf
         K0fn3k4ZisNn0bERCv8o8BzEhXl3jvRhEjSExAcGGT+gW8Jpp54clv7YSthTxxEWFrDG
         3lpnnBMkexW+YuhV+EdfPV/L7VtAH5jQGBzR9SzQausTMKBFQKVYnObzd0K9wsuwzYQX
         TNBTaEpYYwUjJeq4SuSld4Dnd+qyVw8iygaAy+fYUWogEDMuAFwDICzXMwIO0LpIkmGQ
         CqlxSnnyVKZk+yvu+Q8W9fwzAjStxswMmEZCNLFLdbOsn94uWcKtVMi5ixWu5iymKgbA
         LY5A==
X-Forwarded-Encrypted: i=1; AJvYcCUTS4cOoq0XB7kjeRRPtkoVG6THahUEG8aph22Cfi9SI1D5z2e02rYKkcPtWjCL/VpdNacr4Vna2iEx4/s+xQG5KlF7tFVy
X-Gm-Message-State: AOJu0YxMYuYi84oHp3Ib9DYmIAzg7nRxxBNIW42TIsxH+c/EPoTtsbuD
	SjFrNtBtjIRr5AYrqMim4+5hQIL7MLYonYXeqv1UOGyspHRKiYo1alnu9RwjZmk=
X-Google-Smtp-Source: AGHT+IFeg1aw2R2jdtW33+RTmD0GoFD4AbJwR/eufpV8IO4HacBEUsTerwG6znblRji34uNx3VzDqg==
X-Received: by 2002:a2e:331a:0:b0:2f0:2d85:2238 with SMTP id 38308e7fff4ca-2f19de75d02mr16453671fa.44.1723133777752;
        Thu, 08 Aug 2024 09:16:17 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36d27229eaasm2377515f8f.103.2024.08.08.09.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 09:16:16 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 824915F769;
	Thu,  8 Aug 2024 17:16:15 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Marc Zyngier <maz@kernel.org>,
  Oliver Upton <oliver.upton@linux.dev>,  Tianrui Zhao
 <zhaotianrui@loongson.cn>,  Bibo Mao <maobibo@loongson.cn>,  Huacai Chen
 <chenhuacai@kernel.org>,  Michael Ellerman <mpe@ellerman.id.au>,  Anup
 Patel <anup@brainfault.org>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,  Janosch Frank
 <frankja@linux.ibm.com>,  Claudio Imbrenda <imbrenda@linux.ibm.com>,
  kvm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.linux.dev,  loongarch@lists.linux.dev,
  linux-mips@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org,  David Matlack <dmatlack@google.com>,
  David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 13/84] KVM: Annotate that all paths in hva_to_pfn()
 might sleep
In-Reply-To: <ZrTk4sQS8k1-GBb3@google.com> (Sean Christopherson's message of
	"Thu, 8 Aug 2024 08:31:46 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-14-seanjc@google.com>
	<87bk23ql6n.fsf@draig.linaro.org> <ZrTFPhy0e1fFb9vA@google.com>
	<877ccrqc06.fsf@draig.linaro.org> <ZrTk4sQS8k1-GBb3@google.com>
Date: Thu, 08 Aug 2024 17:16:15 +0100
Message-ID: <8734nfq9bk.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Aug 08, 2024, Alex Benn=C3=A9e wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>=20
>> > On Thu, Aug 08, 2024, Alex Benn=C3=A9e wrote:
>> >> Sean Christopherson <seanjc@google.com> writes:
>> >>=20
>> >> > Now that hva_to_pfn() no longer supports being called in atomic con=
text,
>> >> > move the might_sleep() annotation from hva_to_pfn_slow() to
>> >> > hva_to_pfn().
>> >>=20
>> >> The commentary for hva_to_pfn_fast disagrees.
>> >>=20
>> >>   /*
>> >>    * The fast path to get the writable pfn which will be stored in @p=
fn,
>> >>    * true indicates success, otherwise false is returned.  It's also =
the
>> >>    * only part that runs if we can in atomic context.
>> >>    */
>> >>   static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *=
pfn)
>> >>=20
>> >> At which point did it loose the ability to run in the atomic context?=
 I
>> >> couldn't work it out from the commits.
>> >
>> > It didn't lose the ability per se (calling hva_to_pfn_fast() in atomic=
 context
>> > would still be functionally ok), rather the previous patch
>> >
>> >   KVM: Drop @atomic param from gfn=3D>pfn and hva=3D>pfn APIs
>> >
>> > removed support for doing so in order to simplify hva_to_pfn() as a wh=
ole.
>>=20
>> It still sticks out given the only caller no longer enforces this.=20
>
> Oh, sorry, I should have been more explicit.  I'll fix the comment, I sim=
ply
> missed it.

No worries, with the fixed comment:

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
