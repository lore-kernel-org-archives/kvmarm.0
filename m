Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD75730FA6
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 20:58:47 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-27763c2c27dso1095555a91.2
        for <kvmarm@lists.linux.dev>; Tue, 03 Oct 2023 13:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696366727; x=1696971527; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ofK3yTXudgH3dPOX+NXSBZm32mvv1GbIdTLu5eO4ZUw=;
        b=yrLZ1rOElxQdBjdwRBNajH55Ndz59pPU/2JOtE3QT++TKsJtz06m8ui0QXw6YiYKL0
         3hWo+QZg+rFyoRdxMh8kzrO6SSW4cSRistfl0+B+Ug4dKQC9D/fTcMwCrB0EbCiVf1PB
         7AxkD3w0cz54XymV7ImbF/uJKgxjB6QAgcu0/u5rMrt2kkH/XLK11OH8sI+I4aio+HJW
         OZFQzuTHiXsYF287BjXHsE99iy4gQFlnJj6Wr66MYHeO5EjC09yUZrquTQJnU+RkMPpa
         8R6HYkYWE/up8y9U2RPBmjVubxzkemosJ9UV2XI1i3XEqpZBSFLsXVihwAQBUQ15H4lW
         JTig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696366727; x=1696971527;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ofK3yTXudgH3dPOX+NXSBZm32mvv1GbIdTLu5eO4ZUw=;
        b=MIHStdf0QmtEWa4Dghp0UvRH1QPfC+krgKJbg4IknV7WBqHGh65LdCsJ/Vtm84V4aT
         YPApJYFNHG82JFdNsO1nxpUXx4aLh9FMt8zCKzDNtndnoHsT4Eq8R0YuRnAd8hEsHmsR
         15k3X3d8LETs66gs5bILgnUJ9i142nlGiPHbx50jqzVkbmxf7Mp/Io547HKTvxaGpZJh
         xQUIwSD4zG64l2fEAjp1mszeA5YchlSa49m7Fg0o0PkR1UzJcy/2jvobh2YBoQ5JKyBS
         txecIvxmeH6rfiKy/+0PgkoXgKal0k+TEMe4BSDn2OvI0dblHX/rLGFIgQw349/gnzJS
         jDfw==
X-Gm-Message-State: AOJu0Ywqy/ZK/pr6JIwGCdfvNwaXvq13cTykEBiQDKHT8/dSljsW6h+b
	aqZ0J7FAUeMLCp8QXI4Ksqf0OCF03/o=
X-Google-Smtp-Source: AGHT+IEpJRqfisemR4Ma6/26idPCJUHwNJZNRJlSNji243dfZdo+DGHvKt5onPD5NiiwHo9l66/HVhcVsls=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:92:b0:26d:ae3:f6a4 with SMTP id
 bb18-20020a17090b009200b0026d0ae3f6a4mr6815pjb.5.1696366727020; Tue, 03 Oct
 2023 13:58:47 -0700 (PDT)
Date: Tue, 3 Oct 2023 13:58:45 -0700
In-Reply-To: <fe832be36d46a946431567cbc315766fbdc772b1.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-6-stevensd@google.com>
 <fe832be36d46a946431567cbc315766fbdc772b1.camel@redhat.com>
Message-ID: <ZRyAhdIvAkQhYJVr@google.com>
Subject: Re: [PATCH v9 5/6] KVM: x86: Migrate to __kvm_follow_pfn
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: David Stevens <stevensd@chromium.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 03, 2023, Maxim Levitsky wrote:
> =D0=A3 =D0=BF=D0=BD, 2023-09-11 =D1=83 11:16 +0900, David Stevens =D0=BF=
=D0=B8=D1=88=D0=B5:
> > From: David Stevens <stevensd@chromium.org>
> > @@ -4283,12 +4290,20 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *v=
cpu, struct kvm_page_fault *fault
> >  			return RET_PF_EMULATE;
> >  	}
> > =20
> > -	async =3D false;
> > -	fault->pfn =3D __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &=
async,
> > -					  fault->write, &fault->map_writable,
> > -					  &fault->hva);
> > -	if (!async)
> > -		return RET_PF_CONTINUE; /* *pfn has correct page already */
> > +	foll.flags |=3D FOLL_NOWAIT;
> > +	fault->pfn =3D __kvm_follow_pfn(&foll);
> > +
> > +	if (!is_error_noslot_pfn(fault->pfn))
> > +		goto success;
> Unrelated but I can't say I like the 'is_error_noslot_pfn()' name,=20
> I wish it was called something like is_valid_pfn().

I don't love the name either, but is_valid_pfn() would be extremely confusi=
ng
because the kernel already provides pfn_valid() to identify pfns/pages that=
 are
managed by the kernel.  Trying to shove "guest" somewhere in the name also =
gets
confusing because it's a host pfn, not a guest pfn.
