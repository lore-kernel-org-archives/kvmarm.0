Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB911411DD
	for <kvmarm@lists.linux.dev>; Mon,  8 Apr 2024 15:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712590915; cv=none; b=QiPEJdoQrSbWYzsE7fAnX57ui2FgV5b18Q9fOfYU6jnFPCfSoWYSBuz8qf4a8nZtRD4CDu8ImTAAy/ao7URF3rkth0DHpLSv1AnuyNVObNk7a4uNhpyAGsT/YQbhY8xertQZ962/8v9Q05G51j5qJwGVblPHqbNsHc5yLAQ1rjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712590915; c=relaxed/simple;
	bh=SfdtFOR6aiML9ktv68TwRgaYdrwUy0rL0HHJq0xG14k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DmURcJWPcY0jK8NlS0Sa34A8sarypvtO64w7Jvg/yT2gzbvfTzU29Jfsb4JBhIfZLrqxQp/hx8YSe8VedE1MeyiG+vgwnuxoJ6rcH0R7iLxrQNQY57GUXFQ0xP+KFjUYrexFN9kCiYha7V0aLEs+nTefZXiu5vaqib7TZ01K2wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o8EMSZot; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o8EMSZot"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-47a0bebeacaso282149137.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Apr 2024 08:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712590913; x=1713195713; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0lZf0V5CbwYLrE9UF8J47ZuFhjBiyoWGeXKBNAjOLM4=;
        b=o8EMSZot/lhhcUd6tPCKSNwpcm2nabxmBXqtlbh4ZfCBS/bvPP40X4X3lKwdK4x+fr
         v3+27alVFpz5jJQPKLzrxk/8XNRNeTrI6Mn68cH2VAMNTOD2DABPG9gvdAJYxfvHj67b
         cx4mCOt82FCugZmma0q6tWvmNVmZOnSjzsWNg2M2PWx78ovUIFiiv220PfwKG8UjUZIL
         sUKwbGv0GwzD4s0V0i8E0uuI1LF8ZwVOXqaronfO+As2OrYDOGyJoc0XSiTYMCQADLm2
         ry6G4I3ruvpz53FhzvG89ypGqsJ0SZqvHodIptgn0rp3fJwDkB5/XWhGhKGL7GfU/mdd
         qabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712590913; x=1713195713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0lZf0V5CbwYLrE9UF8J47ZuFhjBiyoWGeXKBNAjOLM4=;
        b=fE10ZRr8vGarJPNGLv66jv0FWIM93A6Vhu8PrnGxaJmnRuhiKT7ul8aBBEC0EWbz8S
         lxEpBbNSQD6vDpOpQi/ETWlLe+TrkMa5A9yNKpgzmt96tRSRnZjGiK+HpBP1GLr/vDTb
         GCrs2CP2pcuPmtz8xnwekMyCswKa7mX4n37ou4bexu3ev8MEK17lvod9+lW+1OVkX2aG
         VN8r3akBBo1s+SB6cCUWysl/KpnYGPOUWqVIoHlvSaturRkma/II10VOTCFUehcTWeBK
         2q9pysrANwZx+lZAPJvDF+q/XOwPP4QE+xeNL+lYRv/vIRU6bD2Mm1lu23Tk/p9cyn+Q
         8GKw==
X-Gm-Message-State: AOJu0Yw08tWgXWkkU3HCqtChnmjKD8iHdo8q1pJ/enCMolxQg0uqLhoS
	x5hRNpA3OZGe2daNrQ1ji5npo3bLjYCuOKDlt5hRiFSbLS6XSCWRQdETQ8mLIU3uVI5PtF+NvXj
	L0UOVcmWXGMF22AJyoq2PzjvSAVWutZNkQ/dA
X-Google-Smtp-Source: AGHT+IFYS0tBiOuN5XLkVK7i27WsEUnu3LOikcFf/F1NBA8MZwNzHSSRrJi4swsU9/EuDcy+X+9ye9OtxJ5xSc6DzeE=
X-Received: by 2002:a05:6102:cca:b0:479:f389:2a4a with SMTP id
 g10-20020a0561020cca00b00479f3892a4amr4206253vst.1.1712590912576; Mon, 08 Apr
 2024 08:41:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com> <20240327173531.1379685-4-tabba@google.com>
 <864jccti69.wl-maz@kernel.org>
In-Reply-To: <864jccti69.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 8 Apr 2024 16:41:15 +0100
Message-ID: <CA+EHjTxRSQdaKXpYd6GHEejZk0mpKwPz0CPmnAxPPneGijtSsw@mail.gmail.com>
Subject: Re: [PATCH v1 03/44] KVM: arm64: Move setting the page as dirty out
 of the critical section
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Apr 8, 2024 at 8:41=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 27 Mar 2024 17:34:50 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Move the unlock earlier in user_mem_abort() to shorten the
> > critical section. This also helps for future refactoring and
> > reuse of similar code.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 18680771cdb0..3afc42d8833e 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1522,8 +1522,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu,=
 phys_addr_t fault_ipa,
> >
> >       read_lock(&kvm->mmu_lock);
> >       pgt =3D vcpu->arch.hw_mmu->pgt;
> > -     if (mmu_invalidate_retry(kvm, mmu_seq))
> > +     if (mmu_invalidate_retry(kvm, mmu_seq)) {
> > +             ret =3D -EAGAIN;
> >               goto out_unlock;
> > +     }
> >
> >       /*
> >        * If we are not forced to use page mapping, check if we are
> > @@ -1581,6 +1583,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
> >                                            memcache,
> >                                            KVM_PGTABLE_WALK_HANDLE_FAUL=
T |
> >                                            KVM_PGTABLE_WALK_SHARED);
> > +out_unlock:
> > +     read_unlock(&kvm->mmu_lock);
> >
> >       /* Mark the page dirty only if the fault is handled successfully =
*/
> >       if (writable && !ret) {
> > @@ -1588,8 +1592,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
> >               mark_page_dirty_in_slot(kvm, memslot, gfn);
> >       }
> >
> > -out_unlock:
> > -     read_unlock(&kvm->mmu_lock);
> >       kvm_release_pfn_clean(pfn);
> >       return ret !=3D -EAGAIN ? ret : 0;
> >  }
>
> It now means that things such as marking a page dirty happens outside
> of the lock, which may interact with the dirty log/bitmap stuff.
>
> Can you elaborate on *why* this is correct?

The reason why I _think_ this is correct (something I am less certain
about now judging by your reply :) is that this is a lock that
protects the stage-2 page tables (struct kvm_vcpu_arch::hw_mmu), held
in this case for read. As far as I can tell, kvm_set_pfn_dirty() and
mark_page_dirty_in_slot() only access and modify (i.e., write to) the
page without accessing the stage-2 page table. I think that the dirtly
log is protected by the slots_lock.

Am I missing something?

Thanks,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
