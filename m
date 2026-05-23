Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066A45B1EB
	for <kvmarm@lists.linux.dev>; Sat, 23 May 2026 08:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779523422; cv=none; b=Nob1DqpXjJBWCEOzXdiJr8RhwhroICSvqJfDsEZTQA1QWkb2m842KkPOu9yVEUHR2HRRh9a9mSua0LtmP6ZOJ+K1TjvLVN4nnWL4u9aK6oRAaV8OB05sfjZAIjG/pFY5a/TtfEax1abwh2fq2/DvRojKdKuO0tYIzIhRkO9Y5JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779523422; c=relaxed/simple;
	bh=qz6D3f3YJ2k4+mQtE6g0uFyZLHw2nxe5jE72RTocq8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LIRwJVvrm2lSwzOHTF4E1yeAz5vp677S+/w3g24ljf6jATqC0NuFhkrAJDJaA/z3cMQXBVgbknoC3lMXvLIDStedzelMR8BrqQVoeqTNnppDkTZuYEoas+3A5bp5bS7gkkVaDkJQSPtcw0UcPPcrbW/jMn+X+7lvDHF76gssqq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TmXWnTrE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TmXWnTrE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779523420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8kCCPSR7eAbezRrY9EzmdTOQTokcL1TCE2C4CcBHkS8=;
	b=TmXWnTrECwQicLVh2U4s1iZn4V5As7wyHW3noteoEkX+bBzylXKXYvV8j2NV17zR5GFixA
	R46TrqMIz7KgFZIlbh22KnHmtbMjUHF6hvolvAT6JIVpjkgfhzBq3PQ2cDp12uFLFY5JKR
	mRcbDE43QTbsExtGI1PtyWzSQJz0FI8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-MW4chs5tNBm3kFus5swd7g-1; Sat, 23 May 2026 04:03:38 -0400
X-MC-Unique: MW4chs5tNBm3kFus5swd7g-1
X-Mimecast-MFC-AGG-ID: MW4chs5tNBm3kFus5swd7g_1779523417
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48d127eb013so36906745e9.1
        for <kvmarm@lists.linux.dev>; Sat, 23 May 2026 01:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779523417; x=1780128217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8kCCPSR7eAbezRrY9EzmdTOQTokcL1TCE2C4CcBHkS8=;
        b=UawZmUmXbc2jz+e4DvQxcPtYgOsF97JdVgMe/vJ2h0sUaf1TJAngrYWnXHQkkTKVLG
         twH/AztOwZ9O6D4XAxb+LksQ7ZZ/KGL2lFfpUnXcC8b1KZD11/Eq/3kEv3sOfXLpxu5N
         c+141j3WJyRNsC0T1lrjuPbzmCNftfGGtWgLgVd2r6rldfcmdAOirDxZsuXARLtCKVqr
         SBx2T0Q3wuMPtr0LmPbss1UsDM/KEhUVWjRv/LCIJBJJNRgqe0LHdV/WbdfoESDp2CuH
         EaYlJLeVXZJYE/DZBYL7a4ovphfJeaoM8aynVFv/mXVA1QWJ8BCNWU1emdJiTvfYnSgg
         Rjgg==
X-Forwarded-Encrypted: i=1; AFNElJ9yRXLK9rShwbihhjMZIFEwmK9lScUlsK9rAdnpUMdx/rv8jh9goXHq2vMoXdma3pI22a8/imA=@lists.linux.dev
X-Gm-Message-State: AOJu0YymHhMRkaIQ/qHP3ewSTrfNgOoPW8BLdR5aqsVbRi+Mt6Y4Ogsp
	a5We1NfPunC3R50T85c08sTlxsy0wrmxX5pzKhWSzO/hXDj4nSf1uv5nxz9ZyzjwMTY6v1QJ9Ei
	dNolYvN1gCj6b/hoi3VceMhuqNZeN7NU7DV/OCp6frlUWrsSbB/uZ7lPTWx0sZzQ3bQCTELE1Zn
	Y8nWg0xK0bHvLRzSDVxgtyC6/SBeMhr8Qq
X-Gm-Gg: Acq92OHRXtZg2wpsMSi826yNX7ICi2axrzhs39T2o1owsaIy3BKwAhnCDeYHJP5iSid
	GaFtD/qaeNrWKvrYn3zc9Ej2qHRueqwP5ttbISJv15Tsmt7tq2PydlOGBTP4K7n7IiOJecsJZe4
	rHlnGfZsbCAHig0z8LCj8mzYXPWaup7qwg2lc0YRfz/pEEbQzCY/fU1Q0V0wUv4NomBiWYPLFyo
	UAKruD6wCBAArn1D4nR2C94lSqUP6+LhM05DXr6C/K9QciVHTlNGDDZ7NOxBHSvM+uZGICJq6Q+
	MDArW30=
X-Received: by 2002:a05:600c:5298:b0:48e:51f8:eb39 with SMTP id 5b1f17b1804b1-490428e0b24mr103916255e9.28.1779523417110;
        Sat, 23 May 2026 01:03:37 -0700 (PDT)
X-Received: by 2002:a05:600c:5298:b0:48e:51f8:eb39 with SMTP id
 5b1f17b1804b1-490428e0b24mr103915625e9.28.1779523416685; Sat, 23 May 2026
 01:03:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520072518.504865-1-maz@kernel.org>
In-Reply-To: <20260520072518.504865-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 23 May 2026 10:03:24 +0200
X-Gm-Features: AVHnY4JSA0Bs3_rwKjWLijly1xMqn0yNDirfiVv1I4mSWo8k1UBJzXBC_g_e__A
Message-ID: <CABgObfb4UiufkpDOP6yyAYNjBYnSZvZpi6hfqXoEX7dqCPBk3g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.1, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Michael Bommarito <michael.bommarito@gmail.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Will Deacon <will@kernel.org>, Yuan Yao <yaoyuan@linux.alibaba.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F5LGcqmg6Nw_duhG9JpfMM1UZG6YvkDu01zw_72BNa0_1779523417
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 9:25=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the next set of KVM/arm64 fixes for 7.1. Continuing the trend,
> we have two AI-fuelled fixes, both of which are stable candidates.
> Additionally, a minor tidying-up of the hypervisor tracing descriptor
> validation.
>
> Please pull,
>
>         M.
>
> The following changes since commit effc0a39b8e0f30670fe24f51e44329d4324e5=
66:
>
>   KVM: arm64: Pre-check vcpu memcache for host->guest donate (2026-05-07 =
14:12:42 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.1-3
>
> for you to fetch changes up to 1702da76e017ae0fbe1a92b07bc332972c293e89:
>
>   KVM: arm64: Fix nVHE/pKVM hyp tracing error on invalid desc (2026-05-20=
 08:08:37 +0100)

Done, thanks.

Paolo

> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.1, take #3
>
> - Fix ITS EventID sanitisation when restoring an interrupt translation
>   table.
>
> - Fix PPI memory leak when failing to initialise a vcpu.
>
> - Correctly return an error when the validation of a hypervisor trace
>   descriptor fails, and limit this validation to protected mode only.
>
> ----------------------------------------------------------------
> Michael Bommarito (2):
>       KVM: arm64: vgic-its: Reject restored DTE with out-of-range num_eve=
ntid_bits
>       KVM: arm64: vgic: Free private_irqs when init fails after allocatio=
n
>
> Vincent Donnefort (1):
>       KVM: arm64: Fix nVHE/pKVM hyp tracing error on invalid desc
>
>  arch/arm64/kvm/arm.c            | 4 +++-
>  arch/arm64/kvm/hyp/nvhe/trace.c | 9 +++++++--
>  arch/arm64/kvm/vgic/vgic-its.c  | 4 ++++
>  3 files changed, 14 insertions(+), 3 deletions(-)
>

