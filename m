Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F359C7FBC4
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 23:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717456640; cv=none; b=D7knO7sP1bMjw/4P2ZGda0xoA0hQSArsgAUuoRWT2FaxfmMcpc2mTmDIhZTUmXoy0iv8j3WYhW5XSmLXMxuAINGEchHLa0A8ONQGFtXcmpcKn2HIS/c/E2SPHRwCYzJKqAO6GUi+1i1M2rm6tj5Ao3gJz0hYc5ZHR+wTfvq8ukY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717456640; c=relaxed/simple;
	bh=4jxu/JsmVRXCfHV8AURZSjnWZ5s+7pAtAjdq2rTVOys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m2/PX2ycyP29hXbZS/EAlosc8kenQk2rBX7qDgIG/OwEWRGkK2cLFnZ/GUCx48Yg+GkD4paALQvnTNmbFr/wH4ZYuSYaY3h3/+OCZrUmeUT6hhOuboT33LdrMCQXDwSlwwB/2/nHAn0ehQNm5o5q8sRMEcFk52BfyRmjNuHRups=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cYdiPnKa; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cYdiPnKa"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-43dfe020675so127131cf.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 16:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717456638; x=1718061438; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDykUGLfvL3M1lWs+oKStYngTbEIAr5rRwVrwRKKurY=;
        b=cYdiPnKamgp6bc2ofMK/ajLcmDceigkZJncShNf00sALLqBpjcrCndCtrLWTDCESf2
         0vHfSDikubFnIJbxBVVJLb1LRcIT5Nv1nUKYqwYF5ay6ig7Jgko8fMV7iAqLohuQ7GVc
         YspHmrriF7nc1kHChhOJU2Qf+myyTFmru9t6X1N9Mp3YO/sXp7FhuXazDyvQh8WSkzEi
         Q+jsMmef8UrsRNigf6xalHaZWHWp9Wu93I8fHBXExLeuRK2AvzZs3dvL2qKan88z+vlF
         Pf97I6j61WWYKjrWUBDv3IssxxmBLCwhf8m/S6/LmYNhQy8urNCSqfdpdpM6Q3GobRc7
         K58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717456638; x=1718061438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDykUGLfvL3M1lWs+oKStYngTbEIAr5rRwVrwRKKurY=;
        b=fRtoJOfGBX5i3LsXeG66PRuWs8mWJ5z7gyfvRGMCQ9gSgVpZ15mEm1uiKrtPy14l2u
         APJPbGLR8gT9sEBjhhwPNvAaLmantz/F161EyYfGnt9H8NA0xj4FWRp2Y0PeqOM0aSNG
         NnkXXTzdPf7bOSJkiVm6hjt/RejV1Mv9moIgrvVPOEA+vu+b/EuXxZ2sVnEq9RmVokb0
         uuMBi8gBdRL+Hx47pT7L24OwEph4nfcQRTd/bS9c54IuJxLzo0hBDOwg7/fmedHIg7f8
         0ed/mIlxcUSvkitdIJ11Qc/Qp6VvpxIa5O360jieIIo/3KGsEz+H3EXgG49MNgdkK928
         7ZdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhbgAxzA27QHoVLD6uOqr6rjtb+Y8csaWYUmClyB17uC0K7/OcZQCIIKqnjo0KtmN6X+w2H+aum8I+o4wFFuQfbtiPWhQA
X-Gm-Message-State: AOJu0YzCCRnq6lrS+bFk/Ggvzs7nxN7kzaynX/3m9aD7/lPMsUr3D6Wr
	UzUpe9Ua/rwQLmJgn5v16mX3GAg16ntRLoH1eSXKWVc/iDHqKq9M//nWyKdFY9vR/pvOZMHUsVb
	u4+3QxLLs8PRn+bYYN0d7cMRbwErM6Dt6EoJS
X-Google-Smtp-Source: AGHT+IERlDy+7BDKGdKU12nHNHCd2TlJ06DKBFhjKpTdcIQ5T8pyrt6cuvlCSmsOxFEEGgqtt5PP7LKTO7CDtdLxk+8=
X-Received: by 2002:a05:622a:4ccc:b0:43a:aa3f:917a with SMTP id
 d75a77b69052e-4401e68c145mr1144381cf.27.1717456637692; Mon, 03 Jun 2024
 16:17:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
 <20240529180510.2295118-3-jthoughton@google.com> <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
 <ZlelW93_T6P-ZuSZ@google.com> <CAOUHufZdEpY6ra73SMHA33DegKxKaUM=Os7A7aDBFND6NkbUmQ@mail.gmail.com>
 <Zley-u_dOlZ-S-a6@google.com> <CADrL8HXHWg_MkApYQTngzmN21NEGNWC6KzJDw_Lm63JHJkR=5A@mail.gmail.com>
 <CAOUHufZq6DwpStzHtjG+TOiHaQ6FFbkTfHMCe8Yy0n_M9MKdqw@mail.gmail.com>
 <CADrL8HW44Hx_Ejx_6+FVKt1V17PdgT6rw+sNtKzumqc9UCVDfA@mail.gmail.com> <Zl5LqcusZ88QOGQY@google.com>
In-Reply-To: <Zl5LqcusZ88QOGQY@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 3 Jun 2024 16:16:41 -0700
Message-ID: <CADrL8HU734C_OQhzszWJWMXEXLN6HkBo4yweN2fX4BbOegXrFA@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Ankit Agrawal <ankita@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Bibo Mao <maobibo@loongson.cn>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 3, 2024 at 4:03=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Jun 03, 2024, James Houghton wrote:
> > On Thu, May 30, 2024 at 11:06=E2=80=AFPM Yu Zhao <yuzhao@google.com> wr=
ote:
> > > What I don't think is acceptable is simplifying those optimizations
> > > out without documenting your justifications (I would even call it a
> > > design change, rather than simplification, from v3 to v4).
> >
> > I'll put back something similar to what you had before (like a
> > test_clear_young() with a "fast" parameter instead of "bitmap"). I
> > like the idea of having a new mmu notifier, like
> > fast_test_clear_young(), while leaving test_young() and clear_young()
> > unchanged (where "fast" means "prioritize speed over accuracy").
>
> Those two statements are contradicting each other, aren't they?

I guess it depends on how you define "similar". :)

> Anyways, I vote
> for a "fast only" variant, e.g. test_clear_young_fast_only() or so.  gup(=
) has
> already established that terminology in mm/, so hopefully it would be fam=
iliar
> to readers.  We could pass a param, but then the MGLRU code would likely =
end up
> doing a bunch of useless indirect calls into secondary MMUs, whereas a de=
dicated
> hook allows implementations to nullify the pointer if the API isn't suppo=
rted
> for whatever reason.
>
> And pulling in Oliver's comments about locking, I think it's important th=
at the
> mmu_notifier API express it's requirement that the operation be "fast", n=
ot that
> it be lockless.  E.g. if a secondary MMU can guarantee that a lock will b=
e
> contented only in rare, slow cases, then taking a lock is a-ok.  Or a sec=
ondary
> MMU could do try-lock and bail if the lock is contended.
>
> That way KVM can honor the intent of the API with an implementation that =
works
> best for KVM _and_ for MGRLU.  I'm sure there will be future adjustments =
and fixes,
> but that's just more motivation for using something like "fast only" inst=
ead of
> "lockless".

Yes, thanks, this is exactly what I meant. I really should have "only"
in the name to signify that it is a requirement that it be fast.
Thanks for wording it so clearly.

>
> > > > I made this logic change as part of removing batching.
> > > >
> > > > I'd really appreciate guidance on what the correct thing to do is.
> > > >
> > > > In my mind, what would work great is: by default, do aging exactly
> > > > when KVM can do it locklessly, and then have a Kconfig to always ha=
ve
> > > > MGLRU to do aging with KVM if a user really cares about proactive
> > > > reclaim (when the feature bit is set). The selftest can check the
> > > > Kconfig + feature bit to know for sure if aging will be done.
> > >
> > > I still don't see how that Kconfig helps. Or why the new static branc=
h
> > > isn't enough?
> >
> > Without a special Kconfig, the feature bit just tells us that aging
> > with KVM is possible, not that it will necessarily be done. For the
> > self-test, it'd be good to know exactly when aging is being done or
> > not, so having a Kconfig like LRU_GEN_ALWAYS_WALK_SECONDARY_MMU would
> > help make the self-test set the right expectations for aging.
> >
> > The Kconfig would also allow a user to know that, no matter what,
> > we're going to get correct age data for VMs, even if, say, we're using
> > the shadow MMU.
>
> Heh, unless KVM flushes, you won't get "correct" age data.
>
> > This is somewhat important for me/Google Cloud. Is that reasonable? May=
be
> > there's a better solution.
>
> Hmm, no?  There's no reason to use a Kconfig, e.g. if we _really_ want to=
 prioritize
> accuracy over speed, then a KVM (x86?) module param to have KVM walk nest=
ed TDP
> page tables would give us what we want.
>
> But before we do that, I think we need to perform due dilegence (or provi=
de data)
> showing that having KVM take mmu_lock for write in the "fast only" API pr=
ovides
> better total behavior.  I.e. that the additional accuracy is indeed worth=
 the cost.

That sounds good to me. I'll drop the Kconfig. I'm not really sure
what to do about the self-test, but that's not really all that
important.
