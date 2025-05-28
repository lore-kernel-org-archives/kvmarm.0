Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC13230BF9
	for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 23:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748474728; cv=none; b=ZncPYvmcPmayB7LaYePna3cEOzH8+D1x0hrxfJQPHfom55lRepkCmedGLtRG2N8BZg7epozrrBydSce8Y8MeEwoMvm3NGRr6JmbK6WRGSA3nSajOpEIdpKLBHOEiwXgmSYPQZvArIhMVWFhNTB5WedRWEwrr4R0ki93UT9jisTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748474728; c=relaxed/simple;
	bh=HgABNnq1PWhhK0FklJ/SVzoi8Z+ONJI1riVy8DoPDxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gmlm1tTIhCUf4Ex1oAPOybQtIQ/qwSw+AGaeBoEh00qaCblcq/a6/N4aEsyiGnD1UxTkmComn8uOr+X/JG7IstgZYWGg1lqhyiDjjCp2xs4LDNju+DdhNIR4WlAomBJQUoTbzx3bwzlCC8wu9ePVbQsg4PH+p1+614Gtuyu2Fnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EdfuO27R; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EdfuO27R"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7401179b06fso168595b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 16:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748474725; x=1749079525; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gcxQaHt9YO/4vp8lHIwRWi8ySYcHIjzznVMdx4yu7+k=;
        b=EdfuO27RGJuFV+GXN4RWni4LL764jHlIXM2bO6zekDJbd18MFo+Q7Ak+CnPE+B8uVc
         4sFopldUlUdQhY1Rqjobp48jddywu3z9Jths2ByVTHAlXBABH3NyHaTaYnDW1g44jSDX
         xvCGiohQcnkLr7yLOjrRmun3dxZMbHQI/aJSpQGaln1teCAlTFvJb4WnliT++x45DD2j
         tBPjcajMS7wKxqzJKzso6FqjUHeSgkSLqhzR4dTspFFoo2iS7OHb0QFjHqDhcm+dhyLO
         pP1cG8GfHW4ogOMsWtz+3BpulZDTcCgUIJNmWueTK1cGzxPIWK8VxByK/eEkc5/HaffQ
         2biA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748474725; x=1749079525;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gcxQaHt9YO/4vp8lHIwRWi8ySYcHIjzznVMdx4yu7+k=;
        b=HcJI0gNCuvlii6AOdZa01wFOmcHmFgLmkMCJbL1nvSFCOeHmhJBAv0E5GbNi7eF17v
         FUAV/b6DQUWU/y7NCO8yDLU+/hqUvPaWgHMnD+aKZ2714zkD3AFgCv3p5jTM0lNGIKlw
         CVtBktyHoC71nH9VZ7HVaq1wQhZeIPxq2rw0ifXcsbL7zWcskIzQg4vd/EzjaQxn0wv3
         qc8nYtAyoqTa60fHu4DOvBcWlv6x+hNmEYVmP2X2y3On31UBikIRsxjR8ldXKMSkpex8
         dIb64gHKH1VZM47m9I2WdHdcMb9aL3Q17Vy5wIy7f6QQ/DJbS3bGu6xbK0dXSYrIRpTr
         mLKg==
X-Forwarded-Encrypted: i=1; AJvYcCX74haxxzhhfddWOsQ8ymsiXnEquv8e41dAMmsJhdOracLFbGTl4kvnqTYLEDN0Y+94MAJEeNQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyq4APdWyVvc2h+H/uZS8E3/4ghZ0CAOSaf646WbrCHTQmUSs7N
	4DHIx/4d9MQnzPBdjNgn+ZU7Qx72dWZbEm3jkO36X8HsCrhHgLUtSN45Q9zHnlIY7UE24Ubk2vK
	sEhDh6g==
X-Google-Smtp-Source: AGHT+IErw9co+DcBT121540SfwKH6gZVIzfkdn9B2d2kwxMAwaFIuqhkwNuL6Huhgc39bFpmxXdGbf8i9Ig=
X-Received: from pgdu5.prod.google.com ([2002:a05:6a02:2f45:b0:b2e:c392:14f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:699:b0:218:cdcf:106b
 with SMTP id adf61e73a8af0-21aad7827femr6695431637.9.1748474725210; Wed, 28
 May 2025 16:25:25 -0700 (PDT)
Date: Wed, 28 May 2025 16:25:24 -0700
In-Reply-To: <20250528201756.36271-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <aDdILHOu9g-m5hSm@google.com> <20250528201756.36271-1-jthoughton@google.com>
Message-ID: <aDebZD1Kmmg15zs7@google.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: amoorthy@google.com, corbet@lwn.net, dmatlack@google.com, 
	kalyazin@amazon.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	pbonzini@redhat.com, peterx@redhat.com, pgonda@google.com, 
	wei.w.wang@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025, James Houghton wrote:
> On Wed, May 28, 2025 at 1:30=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c5d21bcfa3ed4..f1db3f7742b28 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2127,15 +2131,23 @@ void kvm_arch_commit_memory_region(struct kvm *kv=
m,
>  				   const struct kvm_memory_slot *new,
>  				   enum kvm_mr_change change)
>  {
> -	bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +	u32 old_flags =3D old ? old->flags : 0;
> +	u32 new_flags =3D new ? new->flags : 0;
> +
> +	/*
> +	 * If only changing flags, nothing to do if not toggling
> +	 * dirty logging.
> +	 */
> +	if (change =3D=3D KVM_MR_FLAGS_ONLY &&
> +	    !((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
> +		return;
> =20
>  	/*
>  	 * At this point memslot has been committed and there is an
>  	 * allocated dirty_bitmap[], dirty pages will be tracked while the
>  	 * memory slot is write protected.
>  	 */
> -	if (log_dirty_pages) {
> -
> +	if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
>  		if (change =3D=3D KVM_MR_DELETE)
>  			return;
> =20
>=20
> So we need to bail out early if we are enabling KVM_MEM_USERFAULT but
> KVM_MEM_LOG_DIRTY_PAGES is already enabled, otherwise we'll be
> write-protecting a bunch of PTEs that we don't need or want to WP.
>=20
> When *disabling* KVM_MEM_USERFAULT, we definitely don't want to WP
> things, as we aren't going to get the unmap afterwards anyway.
>=20
> So the check we started with handles this:
> > > > > + =C2=A0 =C2=A0 =C2=A0 u32 old_flags =3D old ? old->flags : 0;
> > > > > + =C2=A0 =C2=A0 =C2=A0 u32 new_flags =3D new ? new->flags : 0;
> > > > > +
> > > > > + =C2=A0 =C2=A0 =C2=A0 /* Nothing to do if not toggling dirty log=
ging. */
> > > > > + =C2=A0 =C2=A0 =C2=A0 if (!((old_flags ^ new_flags) & KVM_MEM_LO=
G_DIRTY_PAGES))
> > > > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>=20
> So why also check for `change =3D=3D KVM_MR_FLAGS_ONLY` as well? Everythi=
ng I just
> said doesn't really apply when the memslot is being created, moved, or
> destroyed. Otherwise, consider the case where we never enable dirty loggi=
ng:
>=20
>  - Memslot deletion would be totally broken; we'll see that
>    KVM_MEM_LOG_DIRTY_PAGES is not getting toggled and then bail out, skip=
ping
>    some freeing.

No, because @new and thus new_flags will be 0.  If dirty logging wasn't ena=
bled,
then there's nothing to be done.

>  - Memslot creation would be broken in a similar way; we'll skip a bunch =
of
>    setup work.

No, because @old and thus old_flags will be 0.  If dirty logging isn't bein=
g
enabled, then there's nothing to be done.

>  - For memslot moving, the only case that we could possibly be leaving
>    KVM_MEM_LOG_DIRTY_PAGES set without the change being KVM_MR_FLAGS_ONLY=
,
>    I think we still need to do the split and WP stuff.

No, because KVM invokes kvm_arch_flush_shadow_memslot() on the memslot and =
marks
it invalid prior to installing the new, moved memslot.  See kvm_invalidate_=
memslot().

So I'm still not seeing what's buggy.
