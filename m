Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6433E2DFF3B
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 16:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178005; cv=none; b=TOLHpkGzzMhiEYbxbghBTmDssYhh6TIztoxyJ7yKxgX4S7QNIXVwrjO/OHEiylUQ47YrhHcwF4Q23IoXgpXKSuKJ+c1W5kvEj0KG93o9578UjA3YGEmU3+65XnlYllppx/7hyjXLuhvkRV0xEAC7XrF5zrkidyaeWkdRlnKFRGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178005; c=relaxed/simple;
	bh=wPJ3yKHy2XMTQqfdv8k8EDEfQPdSKTp026T+PxCf4Bw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bIT4c0DjbcjtmeZe/iayufmUZVAVGL9BVtB5OazE+bhdOiAuNZsga1haSVZ/FA9U6+FL2RZ+da9ozB4Lh1NOPFgf0Upd6h45F1XOOEAYPZXhI/QuZbAOmEGsUesBKQM0Qz+ZvJX6iBnNBGebIF+dUB77J7YUs3/2Aijm3ViC67U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dyXPLcBR; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dyXPLcBR"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7377139d8b1so5467323b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 09:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750178002; x=1750782802; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m5Zyre//7L5S9K+V+4OPyWpG1CcHuDNKjA2A/jB3Ga8=;
        b=dyXPLcBRytRKR2WJdxZWGTYGBzlD32QIvj5P5YWPr2YGe7FEWfynXF7+dLQKJ2WmcK
         LWSrq0dSWjPMUHA79eskJ4U+HYgU0nGAOOeZ1FCTUlK+IpIdB+Tu7s7gsXqhvwnPXaEe
         +qOjkEV+ua08UyFUyi90lql7urKOZMFbqDqDn7eahceEtYOfd0uhc8aIBjupYi1aINIu
         NJcl2VzK0d6dKlLH0FOPhllvbkTIC73v4wf1NRi5VnUbF1C7p6KyD4DPc/TO2zwLtbts
         aFs2qX6co5xFaWNtVfMe6t6c05e6NFZ21EfEyP1vO3spMqj5j2d4YndNHfLOFVnuNKJ+
         lvkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178002; x=1750782802;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m5Zyre//7L5S9K+V+4OPyWpG1CcHuDNKjA2A/jB3Ga8=;
        b=wkJ0hMY2lSi3DycXvHTnH+laI8NR04zJORGas0XALl13spBo7ZvyMPgo0prBCuagyV
         /qZDUDWhE3m4OwBOhZkosKPqfX26otXXKqXzLKmykgsaX8oQ7JWO1C03UnIJR3spwDJW
         TTePnXnh5HwkTDnphGA7oai4Nf7JgfdJ6EGlgwAJqTwzVh9mRxibkAks9VhmPWvAu78u
         esnow3Qppibe3A8R2sZl41ZDw74A+4wcjpvvqhQnXpJJO9XXzNQninoCr2vIi8DyRIdG
         ruAaNrrMSxSo1h317T5QMEU/nHllf6IpM3P74cKbtkl7vKOIfbQq92jyGEl70Lhjf+Em
         5VMA==
X-Forwarded-Encrypted: i=1; AJvYcCVoFYDaJLfcWRW4RkLUPZnj9zoFtupvvWnaZADjW0C7WxoCYgp/EXYImmxhjDcsQy5mRlgAjwg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy84lJd4Rr8mrVRyQWiPSkWHgERPXtgAlhlZqA/7ZzqvAMFcJpS
	CzYxSwT44ocF51EVMKKiAdYZLQE7KGCfWB1nLNdxqAsHwcpTVT4jaNXDWiVsdKsli4DMNi2y3S7
	nRWZrxw==
X-Google-Smtp-Source: AGHT+IGznCbVopLyCbJY+8Q1ZM+hTyrpfcDqYdoxZ7oVyP5z618lCsgFgNDzhTDn4xHf3X8k9i95X2JuvoQ=
X-Received: from pgbdh21.prod.google.com ([2002:a05:6a02:b95:b0:b2e:b370:6975])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3298:b0:1f5:5a0b:4768
 with SMTP id adf61e73a8af0-21fbd558b04mr20200215637.21.1750178001731; Tue, 17
 Jun 2025 09:33:21 -0700 (PDT)
Date: Tue, 17 Jun 2025 09:33:20 -0700
In-Reply-To: <qusmkqqsvc7hyuemddv66mooach7mdq66mxbk7qbr6if6spguj@k57k5lqmvt5u>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-15-seanjc@google.com>
 <qusmkqqsvc7hyuemddv66mooach7mdq66mxbk7qbr6if6spguj@k57k5lqmvt5u>
Message-ID: <aFGY0KVUksf1a6xB@google.com>
Subject: Re: [PATCH v3 13/62] KVM: SVM: Drop redundant check in AVIC code on
 ID during vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025, Naveen N Rao wrote:
> On Wed, Jun 11, 2025 at 03:45:16PM -0700, Sean Christopherson wrote:
> >  static int avic_init_backing_page(struct kvm_vcpu *vcpu)
> >  {
> > -	u64 *entry, new_entry;
> > -	int id =3D vcpu->vcpu_id;
> > +	struct kvm_svm *kvm_svm =3D to_kvm_svm(vcpu->kvm);
> >  	struct vcpu_svm *svm =3D to_svm(vcpu);
> > +	u32 id =3D vcpu->vcpu_id;
> > +	u64 *table, new_entry;
> > =20
> >  	/*
> >  	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AV=
IC
> > @@ -291,6 +277,9 @@ static int avic_init_backing_page(struct kvm_vcpu *=
vcpu)
> >  		return 0;
> >  	}
> > =20
> > +	BUILD_BUG_ON((AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE =
||
> > +		     (X2AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE);
> 						    ^^^^^^^^^^^^^^
> Renaming new_entry to just 'entry' and using sizeof(entry) makes this=20
> more readable for me.

Good call, though I think it makes sense to do that on top so as to minimiz=
e the
churn in this patch.  I'll post a patch, unless you want the honors?

> Otherwise, for this patch:
> Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
>=20
> As an aside, there are a few static asserts to validate some of the=20
> related macros. Can this also be a static_assert(), or is there is=20
> reason to prefer BUILD_BUG_ON()?

For this particular assertion, static_assert() would be fine.  That said,
BUILD_BUG_ON() is slightly preferred in this context.

The advantage of BUILD_BUG_ON() is that it works so long as the condition i=
s
compile-time constant, whereas static_assert() requires the condition to an
integer constant expression.  E.g. BUILD_BUG_ON() can be used so long as th=
e
condition is eventually resolved to a constant, whereas static_assert() has
stricter requirements.

E.g. the fls64() assert below is fully resolved at compile time, but isn't =
a
purely constant expression, i.e. that one *needs* to be BUILD_BUG_ON().

--
arch/x86/kvm/svm/avic.c: In function =E2=80=98avic_init_backing_page=E2=80=
=99:
arch/x86/kvm/svm/avic.c:293:45: error: expression in static assertion is no=
t constant
  293 |         static_assert(__PHYSICAL_MASK_SHIFT <=3D
include/linux/build_bug.h:78:56: note: in definition of macro =E2=80=98__st=
atic_assert=E2=80=99
   78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
      |                                                        ^~~~
arch/x86/kvm/svm/avic.c:293:9: note: in expansion of macro =E2=80=98static_=
assert=E2=80=99
  293 |         static_assert(__PHYSICAL_MASK_SHIFT <=3D
      |         ^~~~~~~~~~~~~
make[5]: *** [scripts/Makefile.build:203: arch/x86/kvm/svm/avic.o] Error 1
--

The downside of BUILD_BUG_ON() is that it can't be used at global scope, i.=
e.
needs to be called from a function.

As a result, when adding an assertion in a function, using BUILD_BUG_ON() i=
s
slightly preferred, because it's less likely to break in the future.  E.g. =
if
X2AVIC_MAX_PHYSICAL_ID were changed to something that is a compile-time con=
stant,
but for whatever reason isn't a pure integer constant.
