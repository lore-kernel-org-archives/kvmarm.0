Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8C621C9F4
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750279153; cv=none; b=db77zn5Yzn9XC5gpka1n4gE09dcz50TuXbrhRcssuTiXKJtthBmsS1ql0gHlwI6C5dbHhWBwcB6DKu7sjJB45X/XOFHIGpOfFwshcoeWv+0o0WWd3ZNtS929q6sZyWFW2h+jN+Wt2FDIDwx6YIPXb8aKDJ3UoNN6r2kCyE0xI5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750279153; c=relaxed/simple;
	bh=/NM+ak0rLMjlCOg7dWPSQwADmJXEiX9mllS2HtmWndM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mT6iOMJFUJjBJjrRe/q4lIZAIfOZ93F+TKjKvNJrPhRTeHVuykIFUZN+xIChkRk0sIKqLDWskNEVDSqU5HGPGxms0Lw/zsomQ4tl/U9SX4xQLlUCz/YjerYiOnMgwmIp0i859SAnnRofOtNIrLpubzAg9yW7FUzfECy8oa8BsIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AlVI/u/n; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AlVI/u/n"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-710e344bbf9so986547b3.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 13:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750279151; x=1750883951; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xd7fVESQIYURer+XcfloCFqoNH9nVlZcYjsVdYV2DsQ=;
        b=AlVI/u/nGnDlK8MjPYSJtm7nw5m54y9vI2FDAQ9bdOdxUJ1GPyNkOhvPDNK1PCus6N
         Hh8mWR6fhbYtcvqV/z0/Rv7viGDAsuI6GtUTRcTyhQcroCKbX+biTwbt1/rxMAzi5KT/
         SVuBrw8Dss3qogSLkn1obpLUuCa49wAMgq3nWCddXlShKNC3VAHcThBQLZxZcK9ahsJ2
         Agb0QlJuFtRZKtV5ULF72JQmNA+bcykJ3vf5ey/VPfn38csXSWYR1X1lOgHv1o5vOs0h
         yEAm3epDfew5/qVa2xMwhyFrlvdtiXNcWJwiKYzG2rpiXLeso04ahTqdPTHCLpvry+19
         fLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750279151; x=1750883951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xd7fVESQIYURer+XcfloCFqoNH9nVlZcYjsVdYV2DsQ=;
        b=h+GLQIhbCREc6hHHh7KOrxa0cPB0p2JXfliS5CUJKWsxwMDE1z3V7S/czfyssuQZcx
         dm3MTZiVbUHqo7NO5UVFDs3dYahlYVnOFmKb87OeHk0Xa1wqG2YLNXg9RFQi18aXQM50
         aG8axZelziQJcHmb0Xq67oveA9emggpJfy47D8Wr39lWHiPgd/mJgqrByJYLn98i0o7U
         /FI0KxhzRi45ZPmgXBReEi/Si9mqMHIu/2lFY4RqX9jsILc6ofrMVetqzxXWrtqli/L3
         DZiLGVQwR6qD18KkfhXP6d0OC4HdB9F4NGXLBeI3zfAxgNAth1EhiAlD18Tp44ZC/U+M
         QF7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWPme/lY9fndDcpu8RxV6b5rjM0i8Ld6HzXYTXNyiT1wOuAbtRExJz2bB6/AdyzZoKIqKeHXKQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTGLnIaUWrMwGNWRd7Y9gLx7/7rwRNNQ0JNIFkZZiyqq/osCQs
	6DQc9WwHzSsQqeS2Z8c3aueB1R4FgjRzwMHKeXtNuPRJy6D/T9WxeEdPiT7PgnZF7+NeJwbJzo1
	hJc0kvZRoLDRj9QXGFweMLrbYHxC/oAyFCwShVGPE
X-Gm-Gg: ASbGncvMhVHw6dV1wDQpX4QoDFjufhCgcMv7PbirzfAOVB0sbs7TKuZUXOLUyh6RGyH
	d7zHZQN9SNCv2T92/6F1PVQfkdmvsFKqQKYdCgHSLy6HOR/iGBw7IstNR99+TcxsPyOy7dhCsyM
	I85D8vQhGz4f5ZPX/6X4UeXqSUkhLp9PQeCNoLAELcQHqtQJ+H/Jy+s8spbLkccRJkjqHztNhXg
	JPsgAw36rM=
X-Google-Smtp-Source: AGHT+IH1NWNvanAK0XOjMJEe/GTsQrjRFVmMnXkKiISsTuc+7lPoCeqCpycNb+zFFUr9NjVAP8ZmiqXZcDijHwWFKtA=
X-Received: by 2002:a05:690c:7241:b0:70e:2d17:84b5 with SMTP id
 00721157ae682-71175203681mr284981287b3.0.1750279150493; Wed, 18 Jun 2025
 13:39:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-5-jthoughton@google.com> <aFMWQ5_zMXGTCE98@linux.dev>
In-Reply-To: <aFMWQ5_zMXGTCE98@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Wed, 18 Jun 2025 13:38:34 -0700
X-Gm-Features: Ac12FXxtgm7oIFvlTJaEkpAlCqjTucv9lNobWhug7G4AqcUM4fEMOn24B5rvNUA
Message-ID: <CADrL8HXdBY-sxPJrKEKOzdyZ5C82dE3qUobQuh+LABgatCfgdw@mail.gmail.com>
Subject: Re: [PATCH v3 04/15] KVM: Add common infrastructure for KVM Userfaults
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2025 at 12:41=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Wed, Jun 18, 2025 at 04:24:13AM +0000, James Houghton wrote:
> > KVM Userfault consists of a bitmap in userspace that describes which
> > pages the user wants exits on (when KVM_MEM_USERFAULT is enabled). To
> > get those exits, the memslot where KVM_MEM_USERFAULT is being enabled
> > must drop (at least) all of the translations that the bitmap says shoul=
d
> > generate faults. Today, simply drop all translations for the memslot. D=
o
> > so with a new arch interface, kvm_arch_userfault_enabled(), which can b=
e
> > specialized in the future by any architecture for which optimizations
> > make sense.
> >
> > Make some changes to kvm_set_memory_region() to support setting
> > KVM_MEM_USERFAULT on KVM_MEM_GUEST_MEMFD memslots, including relaxing
> > the retrictions on guest_memfd memslots from only deletion to no moving=
.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
>
> > +#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
> > +bool kvm_do_userfault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa=
ult)
>
> The polarity of the return here feels weird. If we want a value of 0 to
> indicate success then int is a better return type.

The way it's written now feels fine to me. I'm happy to change it to
an int (where we return -EFAULT instead of 'true' and 0 instead of
'false').

> > +{
> > +     struct kvm_memory_slot *slot =3D fault->slot;
> > +     unsigned long __user *user_chunk;
> > +     unsigned long chunk;
> > +     gfn_t offset;
> > +
> > +     if (!kvm_is_userfault_memslot(slot))
> > +             return false;
> > +
> > +     offset =3D fault->gfn - slot->base_gfn;
> > +     user_chunk =3D slot->userfault_bitmap + (offset / BITS_PER_LONG);
> > +
> > +     if (__get_user(chunk, user_chunk))
> > +             return true;
> > +
>
> I see that the documentation suggests userspace perform a store-release
> to update the bitmap. That's the right idea but we need a load-acquire
> on the consumer side for that to do something meaningful.

Indeed, the below test_bit() should be test_bit_acquire(), thank you!

(N.B. I don't think the current code could result in an observable
bug, given that the later write of the PTE has a control dependency
here. But it is certainly written incorrectly.)

> > +     if (!test_bit(offset % BITS_PER_LONG, &chunk))
> > +             return false;
> > +
> > +     kvm_prepare_memory_fault_exit(vcpu, fault);
> > +     vcpu->run->memory_fault.flags |=3D KVM_MEMORY_EXIT_FLAG_USERFAULT=
;
> > +     return true;
> > +}
> > +#endif
> > +
> >  int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >                                                 struct kvm_enable_cap *=
cap)
> >  {
> > --
> > 2.50.0.rc2.692.g299adb8693-goog
> >
>
> Thanks,
> Oliver
