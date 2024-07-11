Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3825D16C426
	for <kvmarm@lists.linux.dev>; Thu, 11 Jul 2024 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720720508; cv=none; b=uwzZLNvKL1yigTjWIQDmctAr2o3575hO5XSZBxQxMGLRTmmfFn71e5KgrhmntJ+tLZ2Wbff0LWVWctBO7AEADeNbeqU71NWw65dE7rQjtyGblCdcqryskJusfYTg0XuHaRA958yKkgHAHgiYXr7dn79t555LiPd7jpBqCyaybIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720720508; c=relaxed/simple;
	bh=Q2jGwB5t17HqynNj9nfvA8d60yx74p0B3SdLkap6ocU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W6Wvg51Ww4FjIsErbCD2QJeLgR6PM3cVgx4dh44IEWYfLrbztDRdS/n1PzzuOEnXhYlxW8cb75KsNHjznTKNwkgD7b51ykHE3KWCBveusdOiRMUKeIDX3FW5EJ4TK3knRx8O2xeR/K1F7X7qrpGO+T6BMyEcqI23N4K1iwMylJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=etCTPAH9; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="etCTPAH9"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fb67f59805so10625ad.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Jul 2024 10:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720720506; x=1721325306; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2jGwB5t17HqynNj9nfvA8d60yx74p0B3SdLkap6ocU=;
        b=etCTPAH9ix/zFz4v/rBrFdIVRI23lYuBYdS6weE3NcJXgSNjmk7StXyYbt/LAUIB1Q
         XnwR4tM55ueWOkEXOFx+x2R3Y69s+woRE/0SpScFratmjFkYBBK1mQmMkZh3tyYYElXN
         N/WNbFz0TXKtJa9S4gb8/4XdDhakIYuUCTgfLDQjsetkFf/wwiUbsk199RwTCoIGltuP
         3z+cvPDpe01tFm3KtDj6V2FOw+Kk5ZMWi38tVoZz0SYPHsMUWnBOE8cY/i/5IHpU0e1b
         koKm/eeCLrp3Q9Ig8CwUNmdR+hK6C+CJ9FafVnHBuQWoq6KzGueWIXSWSSRJV27B1tX0
         y/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720720506; x=1721325306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q2jGwB5t17HqynNj9nfvA8d60yx74p0B3SdLkap6ocU=;
        b=rZcj2DcU8COIDh2ivmsiAtWHFFuZosppGdAv0bZpIgV7mQSRbwdL+1L4/nMr6Un4N5
         GspRfuM0hb1PXI3o9Xs47qvAqmtMmYAGgnCEeXNeVd0O3AZKGWcwunuEFHnJmsumP2iP
         5u+kjHt+9EZCbx00wX7ZV5xfZWFY+ZF6xaR5bfVLoB0z2nWvugurLRSLMzvL8iS6BVfE
         cBe6ovuOxf4YuAS+eWwpPfpzuOfK330SPKWJ72jdBSQaucMve1TusMFgbAmaJdIVXt/D
         S7V/T6FlXM8o/QFUfI08Yww2vYfQBK2Eu+H6+Y/03YjPp3r2762s6f3M73AAb5/Q19fe
         C9oA==
X-Forwarded-Encrypted: i=1; AJvYcCWybrbay8boZaqWM0M2WKsQhr1K1ODv/2huwLx9C1iOFpdt8CSLYN92kmEjfwcmAHV6XpTbYQqBCf7ySWZFjB8O7z4BrZyr
X-Gm-Message-State: AOJu0YyqGWZJAJgShYwevf/pKNhrNh14gSJBSEDT/m0uFNMRNmSFctXy
	2Qz7LpIuXpvYWoADfaVzxxMHh/YJNcuoN0y4D8GTaEOk7xd/BnM+Z8u3WAZBck20IjG//YIAB+w
	z7K8F2e0Srx02M0VPAy5s62dJN8mXpisRBn2J
X-Google-Smtp-Source: AGHT+IHPl0hMtGzIful8PbEv97szuh+yMniIwD4UrUN5WZPWkOFkV7tC3++A18niRRomq2oAuqh7wl6DUv9+EvJrdGI=
X-Received: by 2002:a17:903:32c4:b0:1f7:3764:1e19 with SMTP id
 d9443c01a7336-1fbf24ced64mr106635ad.20.1720720506068; Thu, 11 Jul 2024
 10:55:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 11 Jul 2024 10:54:29 -0700
Message-ID: <CADrL8HVFARsLq0Tyw8XF3PR02gELQhbYM8ZDdWNx0eD_jyDW8w@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 4:42=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
> Solution: hook into the gfn -> pfn translation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The only way to implement post-copy with a non-KVM-specific
> userfaultfd-like system would be to introduce the concept of a
> file-userfault[2] to intercept faults on a guest_memfd.
>
> Instead, we take the simpler approach of adding a KVM-specific API, and
> we hook into the GFN -> HVA or GFN -> PFN translation steps (for
> traditional memslots and for guest_memfd respectively).
>
> I have intentionally added support for traditional memslots, as the
> complexity that it adds is minimal, and it is useful for some VMMs, as
> it can be used to fully implement post-copy live migration.

I want to clarify this sentence a little.

Today, because guest_memfd is only accessed by vCPUs (and is only ever
used for guest-private memory), the concept of "asynchronous
userfaults" isn't exactly necessary. However, when guest_memfd
supports shared memory and KVM is itself able to access it,
asynchronous userfaults become useful in the same way that they are
useful for the non-guest_memfd case.

In a world where guest_memfd requires asynchronous userfaults, adding
support for traditional memslots on top of that is quite simple, and
it somewhat simplies the UAPI.

And for why it is useful for userspace to be able to use KVM Userfault
to implement post-copy live migration, David mentioned this in his
initial RFC[1].

[1]: https://lore.kernel.org/kvm/CALzav=3Dd23P5uE=3DoYqMpjFohvn0CASMJxXB_XE=
OEi-jtqWcFTDA@mail.gmail.com/#t
