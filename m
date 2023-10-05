Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792EE405FB
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 18:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZcaFPt3r"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3af604c3f8fso839418b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Oct 2023 11:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696532337; x=1697137137; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yDQQmCSsjmsi9m5zFrDWZjrxSkRh4MDqIUqD4S4tkjk=;
        b=ZcaFPt3rtz4IV52xa8giVzPaO4ZhxlQIUM5Ed9g7HxODlZOLQ1tTEyvwyR+vZiFf7K
         QSadUauhHPW1YiaihqKzDl/s06j6RuRnJqFk3CJU4MFwUecJA94UWFTsJf9+Yy8yRO4U
         ldEMUV38aNXD15R+8hJfdiy+huoRUF68BNnulVcFpTziYaXJ8v7vJImsI2xJO/nt4u6u
         AGYHM3aXVvmdPIUeVaWMTD0qKWMf/UzM53Yf6lr1nMEDERpLpHg9mJbhrjJ3vGLYQfpl
         9/AHuFteU1VWTKIOIrxg+c3dt0GRCZgr3mBbIZHsQoKuHOKc68SojDqlQQ4ftyt0HcS3
         Xezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696532337; x=1697137137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yDQQmCSsjmsi9m5zFrDWZjrxSkRh4MDqIUqD4S4tkjk=;
        b=dvgIh+oBA8ov6tWg7lU8xjZAP9dnKsPgvmQePsfSkUp+9vYHBcqJk5kGkTYgR3Ni++
         gnCkQDpYpnVD6UUi4uE/iCEIalfHdVehItC80dsJFE/AZZMyI47lWazSb3LNgQGfffJQ
         E4cdcBhwqe2B36AeOC7nU0aafxnyj0486Ci+TP3SACsJ0PA9enU+xJQfB1/Ud6itvziz
         ISkh3fYgxgZwaSsQW+PWXSgO65GibJud4Wfm5KPEKRTmHXBMPtdaQh267gvkam0uYgEP
         8l26ko6h1/hEZZ+Q0ne5fzQSuXljVMLzYGgCEGg6QJAa1j+ikE4PSHDZhTkb5+IVaZQg
         dWDw==
X-Gm-Message-State: AOJu0YzzOfww98Q7pKDF6dgAK2ywOVC26vFknldcK2pliyhNsC+5S6Ks
	r3q4s52rVGL9+jhTAIjbYM+CblfFIQL2XNV2KTfLN1S10kD8+z7Lxqw=
X-Google-Smtp-Source: AGHT+IEjwNOFakx4ccTdhsQ8QAUUS0UJOAJL+jgIf9Wgup01bCxwbJD37o3+W/nPZD5mUlQnp9NN4JrzgAjg2NZqln8=
X-Received: by 2002:a05:6808:1143:b0:3a8:1727:5af4 with SMTP id
 u3-20020a056808114300b003a817275af4mr6814984oiu.24.1696532337483; Thu, 05 Oct
 2023 11:58:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com>
In-Reply-To: <ZR4U_czGstnDrVxo@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 5 Oct 2023 11:58:21 -0700
Message-ID: <CAF7b7mqUkP1jDf_TF_DpGcAKqn+nYx4ZPasW00qT4nOr-76e_Q@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Eh, the shortlog basically says "do work" with a lot of fancy words.  It =
really
> just boils down to:
>
>   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_MISS=
ING
>
> On Fri, Sep 08, 2023, Anish Moorthy wrote:
> > Change the "atomic" parameter of __gfn_to_pfn_memslot() to an enum whic=
h
>
> I've pushed back on more booleans multiple times, but IMO this is even wo=
rse.
> E.g. what does an "upgrade" to atomic even mean?

Oh, that bad huh? Based on what you mentioned earlier about some
callers of __gfn_to_pfn_memslot() needing to opt out of the memslot
flag, it seemed like there were basically three ways (wrt to @atomic)
that function needed to be called

1. With atomic =3D true
2. With atomic =3D false, and some way to make sure that's respected
whatever the memslot flag says
3. With atomic =3D false, but respecting the memslot flag (ie, changing
to atomic =3D true when it's set).

An "upgrade" in this context was meant to describe case 3 (when the
memslot flag is set). Anyways despite terminology issues, the idea of
an enum encapsulating those three cases seems like, essentially, the
right thing to do. Though of course, let me know if you disagree :)

> Since we have line of sight to getting out of boolean hell via David's se=
ries,
> just bite the bullet for now.  Deciphering the callers will suck, but not=
 really
> anymore than it already sucks.

Sorry, what exactly are you suggesting via "bite the bullet" here?
