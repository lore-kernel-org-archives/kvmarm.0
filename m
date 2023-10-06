Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160D0629
	for <kvmarm@lists.linux.dev>; Fri,  6 Oct 2023 00:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RlpMDI2E"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-594e1154756so23520077b3.2
        for <kvmarm@lists.linux.dev>; Thu, 05 Oct 2023 17:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696552595; x=1697157395; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FFGyyoIZBiPvd1jiREWMi+h6K+SB/tS5bqtQENPZq7c=;
        b=RlpMDI2E2k7d6BcKcVDBzaaUrlPp4CKDrVeQwZzMBKuzc77n3+4/dNOfTfwSf7Q0Id
         qWhQjY9W/5Fnurf5ci2qGmOAoR0CSj4ue0hKh35MJTtP7s349NGcDs6nLx9FQXlaSc5d
         IdBcotGm0PY+aH9kYyNODQByFWpB3t31vpv+7wXe96EPHannSWYs0/4CqznA/Xe5YGl/
         zLQiPdSUSKI2JDjXKHtpErvWhZbuFfrhFdgiFq4PvFPo7wOqlGCNA89PG7gJDnAE9o+7
         +IdZG6e+1FzikbKufGcx1FRDrhITxvfaADEl5juWPFL89Fpy49Nc79iGyYFkoHEfZkoK
         /wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696552595; x=1697157395;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FFGyyoIZBiPvd1jiREWMi+h6K+SB/tS5bqtQENPZq7c=;
        b=rEVuS3W3uM/JMB5tkNj6CqgrspBuXhdnz3qdmH6QJSGXsYR0mGv/3ukE834krOl5f8
         RpEbJxaYWsC9Ktl/sF1Xd6U0KS45yBNEV3zxpt9HaSq/jhVNFllkAPY+0outSobl64Xn
         y/dFSUT63gm21FngTrnnGYWTsaU8H++mNlm567GIRoLd8tJlZ7mU5NQZPCioUXd7gFRA
         jITLsIVnGSF/UgDA4kESIaZohQpsx/FZl1BEmJSg9kkFTHY65s5amwPDy8dl+WFUeaLU
         mSX6lZDi3AvoxuWGuqKUxX5Fn3cXeiPH+CNWPdpIKd5ZWWkTb7Dia2xZxS/hI9NVBUj1
         +YlQ==
X-Gm-Message-State: AOJu0YzqU1RFUo8SGN1L0WNpzULBE2FJ76y8VNjwAHw0rLZ1D5jJfuXk
	XJmyoItZF0jtU4UCEaXbAvgtJzvGK7Q=
X-Google-Smtp-Source: AGHT+IHMHN7swFenOS6CqX1CulxSvfnTXe0NuHV3YDhFkwlpsdK+cW1savjCK047jlFW+8MdB9+J5s/Vl5I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:988:b0:5a4:f657:5cb8 with SMTP id
 ce8-20020a05690c098800b005a4f6575cb8mr118734ywb.10.1696552594876; Thu, 05 Oct
 2023 17:36:34 -0700 (PDT)
Date: Fri, 6 Oct 2023 00:36:33 +0000
In-Reply-To: <CAF7b7mp9VDu3hEFrOys9-9wfS+nKAJX7vcnBYgk_pBZ-NnJE2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-7-amoorthy@google.com>
 <ZR4Qr4Yzj7nUNIT3@google.com> <CAF7b7mp9VDu3hEFrOys9-9wfS+nKAJX7vcnBYgk_pBZ-NnJE2g@mail.gmail.com>
Message-ID: <ZR9WkaObdPTIc07-@google.com>
Subject: Re: [PATCH v5 06/17] KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 05, 2023, Anish Moorthy wrote:
> On Wed, Oct 4, 2023 at 6:26=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > ...isn't helpful because it doesn't provide any
> > insight into the actual impact of the change, i.e. requires the reader =
to already
> > know exactly how and when kvm_handle_error_pfn() is used.
>=20
> Ah, true. Hopefully the following is better?
>=20
> > KVM: x86: Annotate hva->hpa translation failures in stage-2 fault path
> >
> > Set up a KVM_EXIT_MEMORY_FAULT in cases where the stage-2 fault exit
> > handler successfully translates a GPA to an HVA, but fails to translate
> > the HVA to an HPA via GUP. This provides information to userspace which=
 it
> > could potentially use, for instance to resolve the failure.
>=20
> Maybe the "via GUP" isn't really doing anything there

Yeah, drop GUP.  Not all pfns are resolved via gup(), e.g. see hva_to_pfn_r=
emapped().

Actually, I would hedge on the "HVA" part too.  It's an accurate statement =
for
both ARM and x86, but only because writes to readonly slots get treated as =
MMIO
(stupid option ROMs).

And what part of the translation fails isn't important, what's important is=
 that
KVM is exiting to userspace with an error.  Using "can't resolve the pfn" i=
s fine
and desirable, but the changelog should first focus on the important outcom=
e,
which is that KVM is now providing more information when throwing an -EFAUL=
T at
userspace.

Something like this?

  When handling a stage-2 fault, set up a KVM_EXIT_MEMORY_FAULT exit if KVM
  returns -EFAULT to userspace, e.g. if resolving the pfn fails for whateve=
r
  reason.  Providing information about the unhandled fault will allow
  userspace to potentially fix the source of the error and avoid terminatin=
g
  the guest.=20
