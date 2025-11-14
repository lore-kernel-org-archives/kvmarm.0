Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB96021E097
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 00:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081610; cv=none; b=pGpVKFi/ubNjgZaUVDcqqutkwKEJR1xMkVFkKzKdm6bGAYetmdifSkefaI65OB+MAs3LYdPOUqe3KyGI7/FgxxXr9bZjokC430pf3nOAYusw22vubeX/4XBptAlI9TJPT/z7EjdNGADmBuEDYvJUaDmkehW+NULTKlZ4WF7gWSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081610; c=relaxed/simple;
	bh=sk2uMggCq1ckhCBdGx9muJo7+MWiHKvDO30mLbByhn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CiHXGtjgG0UP5U4ruizbHmxY3OvjQzo3q842dEiOcRYQNng5Koc+Z65SaOuq+rI29rubKhnEU35B+gV3Oo7m2ahvI0j0rjXwAl9RN6Iq8eyMJHCKhC0Z1ID2mYMyMoH9deSyzoT9m/jvdOmW6a1WpeuvF/42F7YlxrRNSEcvk7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M4PXtX0B; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M4PXtX0B"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477741542bcso25665e9.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 16:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081607; x=1763686407; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sk2uMggCq1ckhCBdGx9muJo7+MWiHKvDO30mLbByhn8=;
        b=M4PXtX0Bmi32iMfA1jARjjSk4mka4pxMuPdyHABylY7gGAtu5e8blEf1hZI6H25Knz
         YEeN0lVagARxAFZZnZwTonblQjtQssQ4BUUCwueb7WXdJN9gFLUUPrRor3ffbddzY8oo
         R4zlIo7hejxanzKC0IFg/dLIo4EG8UPAORjlDstLvQs6vQaiK6KTNEOTtJD/TNZshBZq
         MnmVjU5JWviXoZS3WmfmHdsx3cU7l/RsEJKfyLz6j1v+mmOhJnYXsP7iM/G5rV01RID3
         EWdnjUcosQMlt0rLrOMwik5o6xe2lYebXOCClqBiEia2Sdt5imSkghrPpI+NjUR4laNg
         HK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081607; x=1763686407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sk2uMggCq1ckhCBdGx9muJo7+MWiHKvDO30mLbByhn8=;
        b=ppFdDLQGQVnwaq6NSn7XrkOt/O03dZfGe8VoI2/njDihhxeq+UEmL2yN2C8LzNlfob
         jjiTW+/dWw6QgsIoEEH9o2/5YnAaa9FatsOH+1zzkfJBlcjWcBcp778elD1uwgXHt0SI
         hcfYSqC19J3m1msbC1cHMLWvj6E8hjvv2QBMA4ie4or/xvSnndDUrSejXjEhURbMuGKi
         N9vHYMZ+bNmurbf27H4c1eD8Kx2C99XcPcdLTVSB4LmiyUdaWPwlFClN1hs09vD7Tf5l
         lBoEq+Ri9/LlaRnMprwPKPfTvaockMcxXtbXIEPECTKDrLF9eGhPuuMHWYVAvbS0clX1
         lCGA==
X-Forwarded-Encrypted: i=1; AJvYcCW1POAOAhB+pzzx2n5xLHfjVfKykJ8WeXwc15TwaZjmFgBEjWQAY1L75QtNyKKB3xutYMh6jRI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLsWi74E4ABthyL7W1eclrvU2/MH3gUe8BJc+QE6IiyYENrTYc
	I5iw1lurjiwLa5v2+AvzcNvc0ooCy8FxOILSvx5faqnjQIlrvwqPmJkmycD+aOKN621GGvHeBgA
	hU5IO59CUEVbBrvxWVd7zlTcqe8ezlRrBQOxs1IxK
X-Gm-Gg: ASbGncv31VZNJ/ry9n0KaS4dGPr+faBkUkcNKjaQAq4HX1Io3y5uTXWNB5jGcJ7vS08
	UYxPQEZ9wbF4MZ3NhIMh16PgJFvoPSxUUWeAtf0dwxbBT6/HeAq0uBBZ8XDqFKsyFqawsPlflu2
	8pqdUVRvxz9+D3aSrdx4erRj82TXW0LiX7y1KWmeHnnMamH8VrO5zO8CwB5EpCWaoAWGswerXEX
	7C+1X2CzGx4dQqKmjOcT0Pqp8+MKEBCR3972zEPeoWf/Do6ne4dvHdIcOGz+MozmS3rn+np0a0v
	fXN4CWS7gyWvkJMJskhXLiAJxw==
X-Google-Smtp-Source: AGHT+IE3vstJm3oWP95qkqRJjs5fszSUCVzNUiug16EQF/JXNPVFpZq7hEiC3L8y9CW/kpoGUurTym+p6tSTb8UVNrk=
X-Received: by 2002:a05:600c:a20e:b0:477:86fd:fb19 with SMTP id
 5b1f17b1804b1-47790b10751mr266505e9.9.1763081607050; Thu, 13 Nov 2025
 16:53:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013185903.1372553-1-jiaqiyan@google.com> <176305834766.2137300.8747261213603076982.b4-ty@kernel.org>
 <CACw3F51cxSgd-=D46A6X6GptEZS8-JZ_MnB_yK_ZR1wktunYRA@mail.gmail.com> <aRZc1SqU01Cyxc5Y@kernel.org>
In-Reply-To: <aRZc1SqU01Cyxc5Y@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 13 Nov 2025 16:53:15 -0800
X-Gm-Features: AWmQ_bmZ-_H-myZL0CSQJa9c5c9xb22UWf4fE3TvV1ETbHc5zzWFdDRoRMYRrbg
Message-ID: <CACw3F50ti1cXOLwhyEbM8OCmwEaDDXK-r3QT+qfz2=a0yCTBjA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
To: Oliver Upton <oupton@kernel.org>
Cc: oliver.upton@linux.dev, maz@kernel.org, duenwen@google.com, 
	rananta@google.com, jthoughton@google.com, vsethi@nvidia.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:34=E2=80=AFPM Oliver Upton <oupton@kernel.org> wr=
ote:
>
> On Thu, Nov 13, 2025 at 02:14:08PM -0800, Jiaqi Yan wrote:
> > On Thu, Nov 13, 2025 at 1:06=E2=80=AFPM Oliver Upton <oupton@kernel.org=
> wrote:
> > >
> > > On Mon, 13 Oct 2025 18:59:00 +0000, Jiaqi Yan wrote:
> > > > Problem
> > > > =3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > When host APEI is unable to claim a synchronous external abort (SEA=
)
> > > > during guest abort, today KVM directly injects an asynchronous SErr=
or
> > > > into the VCPU then resumes it. The injected SError usually results =
in
> > > > unpleasant guest kernel panic.
> > > >
> > > > [...]
> > >
> > > I've gone ahead and done some cleanups, especially around documentati=
on.
> > >
> > > Applied to next, thanks!
> >
> > Many thanks, Oliver!
> >
> > I assume I still need to send out v5 with typo fixed, comments
> > addressed, and your cleanups applied? If so, what specific tag/release
> > you want me to rebase v5 onto?
>
> No need -- I took care of the issues I spotted when applying, LMK if
> anything looks amiss on kvmarm/next.

I took a look and everything looks fixed, and thanks for nearly
rewriting the documentation!

>
> Thanks,
> Oliver
