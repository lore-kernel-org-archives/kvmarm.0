Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3FF33067C
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 11:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770980875; cv=pass; b=BVQTKGj4dbxxN1ZYNOmFz89fiTqFMGtoGZG2Cmae6bxFlOOfT0gOrAXthwSLkEMX756fSowKvdrLu1LALNjG3kmJTyjHAHNF0zR11GK8MUmnjoLyrORG3Bayo5prQagHHgpuwfO6Ww9NTDjJwQ25nD2QMi/VJpC6mDDcUrFm9Z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770980875; c=relaxed/simple;
	bh=S4Ba0KXNuJGSXiTRArril8r2Pr+NJQGRneQ2XA75mB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gc8S6EoeYejOgcscA1G8M1Ps+Xccvwao5DzQARNVUDmQ1ZksNg13dC1licdd9VqIH1UTZDgghkt1J/nbz4wY/FxWFrYi8wR8yG10rC3FhL+K/4NSPYMn1bTayRDGm0QOYMAtjVJcQkJKIO/uW9O0fY/ueF7GJ9d1rZW7PbgvLEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fb96OeUC; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fb96OeUC"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5069a785ed2so343561cf.1
        for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 03:07:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770980873; cv=none;
        d=google.com; s=arc-20240605;
        b=DDCenlX69a7fjxuv19i1ZDwpyl+SLLbuw2wt6HdIRrPxgz6TCAsUpeRhniJORU5CRc
         mron7hath+GlznuAt00Gn/M6rApYBuXRI6/LPAT0LpbMEl9YtMeJgLhU+fO4jNma+C1a
         lvCsVIYEWisv+GhVSw6cqVcgmhso2wfLBxNUJt9czOYooljsbFSUHNeburi65AypGO/q
         wlt6FD/ODxCEmcDyg3Wt6XNuxbZhuamUXXGkKBt8seNjbE7xjfanLK2iyYP3mpjiMxWk
         XHh1mPFhesRu2EvTs7ziYrxrcZl9qFSzW9KbXpyQYb8Eonj/VEhpj+kdFfJ5/hMSkN0z
         sJAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BhioMr+TlEkKghKMNX83e9mEkIV+C0EY/uR4/Y90u/g=;
        fh=uh2CA1lZNuPorsuZkFDQbL3osQWnS9lPgWqcvkCgcJw=;
        b=Il6n+tO0+ZLXeOjIIs+bpUUi7Fid3hUKp72G/j5rWboATrXUQPJZUaTeFAE1DOQaYx
         R6ZIIUL/Eh3NiJJcXXJG+Tyzis40NRHONRvnsXFUt1lLh+L6zBhHRcXdbTeA7GZxLChY
         vjQkKxdAr6uU8xRJat4apJdVa9AJ6xJSGxh3yYlkYucc9L7BRPrmgSk0pt9D8U+ui3ef
         Hw5JeBHa5ULPTcvaaFkIhK4ADQPKygQBG8q8EvJITYeocSgfmI1mEz7DUK94l37vk+Sh
         xy06YczsDGgyCHBfk5PxKejCKkd/xBD17+z/Dc/afT/r7u9sW286ml0uE6D28NGWzXHF
         o9GQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770980873; x=1771585673; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BhioMr+TlEkKghKMNX83e9mEkIV+C0EY/uR4/Y90u/g=;
        b=Fb96OeUCFK/KUg9fBS5P3CvhyvMzsCkwrhj3rUv4IrGeMlV1DzGMajkm8hevXm4f/K
         d8ffrKyDv/+e1Xm8KaT4cjCN1mc+LIk420gqfoW4A9XIB9xCjO00Ao+U8fpS8p9tpqcZ
         8bQdviKj8mEK/nZVqlykscnSekL6eKwKH1vC7EZrVCgtp8qOeQfnljhNZp3sUEqTYIjR
         sMy4ES/TTZuVfSa2dKNa/W3qh/vyOLjlA0OnOg3XvpScK16KrghY4xssMr+zNkZfyUs0
         /0Z25DjhJJwQO9TVeHnn20/XC58LppU1mXmUJmiB7Qqwp3rmiPek2aKOI5qmwnogSVQn
         JeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770980873; x=1771585673;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BhioMr+TlEkKghKMNX83e9mEkIV+C0EY/uR4/Y90u/g=;
        b=aOCXSKCC5PKUlAENK8oni4AC4vHoDaHXfvL3Qayjyixq+rVRucv0ZfLywojv4m579p
         UGXttRZ5gwSWhPmSdNA/PJBtzjD7iQndGAAsXJfG9Z0YUECixNBfszS1u4fz+BHKvaP8
         SJVwWAlhIrjSItLuZ1PWRWySzpCe18XmHEU2vtYopki8/i9y4DH6yitegbP32JT+K6Pd
         TPmPaG/wMcRmUP1Eh3Oap3i+YT03RiEe9HXR7UjIjv2bMgFrrIKnjc8gp1e7EPFld+l9
         SE7n8XYJSwkD7xJczFzhpUQCdchY/i+XLKN0NbP2WGzmG9UPoK4b3YO2YUzjPyP5ckRw
         5Rpw==
X-Forwarded-Encrypted: i=1; AJvYcCV3kkRZ3KxyLo0P8JxwUtakQQN50CGE0FacCPyaoFNC0Ta4Eg+pMfbzk4cx/rjJHq/Gv4bjXM4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJ3I7lBKgYSfeoR9IMoWwO6RlJMX8YNIINbs802AiV5Jg6dCCx
	JE0kJxX8MqeTVjYuBH9AkIBHDl4RyqMdT+1mUHhTTk1Fo/ZtoQQ8iCuaJM1AvJvy7O22U61FlPD
	Zwp/afrtAxJQxW0R0zIyUIb8A5ZcrjdabMhYmbSJI
X-Gm-Gg: AZuq6aIDnDsT2rJYIz5c8mRF9MhZrjQj8gISuY0snvgFyDH0k4envRNGq2kapj7+6Tb
	8av6kVZU9Fc0ZbjLmLBzG/BoXMNkqd8x8PH/X7SOm8pEhAAF8zJkcJ0tS32NrOAFbgre1NSx9eI
	jJTqfU794HRP/KOhQGpfxtxtNyUg1hw+QKWwwJBLSFkN+aIxoU3ZXuQd2pL3cS3bwCWelKy2VWR
	f19EajSGugK5bAz3Y8ve5eV+6DZIdaTkEke0Qzs6wViS/dSXfyuNTZhFnuKFkQxi3YXM1E2lg93
	zBFYYD/Q
X-Received: by 2002:ac8:5794:0:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-506a8434debmr6596891cf.5.1770980872383; Fri, 13 Feb 2026
 03:07:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260212090252.158689-1-tabba@google.com> <20260212090252.158689-3-tabba@google.com>
 <86ecmoc3dk.wl-maz@kernel.org>
In-Reply-To: <86ecmoc3dk.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 13 Feb 2026 11:07:16 +0000
X-Gm-Features: AZwV_QgSdg6ZxR7oLi_wuOeoAvMjVYMSeO2-E9Trn8UZX41x8tt3ScmTFjatuKs
Message-ID: <CA+EHjTx1xjPCd0w56YDF42W=-HtKm9DYxUwGPd+2u-zmiSw9CQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] KVM: arm64: Fix ID register initialization for
 non-protected pKVM guests
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Feb 2026 at 11:03, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 12 Feb 2026 09:02:51 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > In protected mode, the hypervisor maintains a separate instance of
> > the `kvm` structure for each VM. For non-protected VMs, this structure is
> > initialized from the host's `kvm` state.
> >
> > Currently, `pkvm_init_features_from_host()` copies the
> > `KVM_ARCH_FLAG_ID_REGS_INITIALIZED` flag from the host without the
> > underlying `id_regs` data being initialized. This results in the
> > hypervisor seeing the flag as set while the ID registers remain zeroed.
> >
> > Consequently, `kvm_has_feat()` checks at EL2 fail (return 0) for
> > non-protected VMs. This breaks logic that relies on feature detection,
> > such as `ctxt_has_tcrx()` for TCR2_EL1 support. As a result, certain
> > system registers (e.g., TCR2_EL1, PIR_EL1, POR_EL1) are not
> > saved/restored during the world switch, which could lead to state
> > corruption.
> >
> > Fix this by explicitly copying the ID registers from the host `kvm` to
> > the hypervisor `kvm` for non-protected VMs during vCPU initialization,
> > since we trust the host with its non-protected guests' features. Also
> > ensure `KVM_ARCH_FLAG_ID_REGS_INITIALIZED` is cleared initially in
> > `pkvm_init_features_from_host` so that `vm_copy_id_regs` can properly
> > initialize them and set the flag once done.
> >
> > Fixes: 41d6028e28bd ("KVM: arm64: Convert the SVE guest vcpu flag to a vm flag")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c | 37 ++++++++++++++++++++++++++++++++--
> >  1 file changed, 35 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 12b2acfbcfd1..267854ed29c8 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -344,6 +344,8 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
> >
> >       /* No restrictions for non-protected VMs. */
> >       if (!kvm_vm_is_protected(kvm)) {
> > +             clear_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &host_arch_flags);
> > +
> >               hyp_vm->kvm.arch.flags = host_arch_flags;
>
> Can't you just have
>
>                 hyp_vm->kvm.arch.flags &= ~BIT_ULL(KVM_ARCH_FLAG_ID_REGS_INITIALIZED);
>
> since there are no atomicity requirements here?

I'll fix this.

> >
> >               bitmap_copy(kvm->arch.vcpu_features,
> > @@ -471,6 +473,36 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
> >       return ret;
> >  }
> >
> > +static int vm_copy_id_regs(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> > +     const struct kvm *host_kvm = hyp_vm->host_kvm;
> > +     struct kvm *kvm = &hyp_vm->kvm;
> > +
> > +     if (!test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &host_kvm->arch.flags))
> > +             return -EINVAL;
> > +
> > +     if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
> > +             return 0;
> > +
> > +     memcpy(kvm->arch.id_regs, host_kvm->arch.id_regs, sizeof(kvm->arch.id_regs));
> > +     set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
>
> This looks a bit odd. Can you have another vcpu doing this in
> parallel? You seem to be holding vm_table_lock at this stage, so
> that's probably OK,  but I'd have expected something like:

You're right, it cannot happen in parallel, but another vCPU could
have beaten this one to it.

>
>         if (test_and_set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
>                 return 0;
>
>         memcpy(kvm->arch.id_regs, host_kvm->arch.id_regs, sizeof(kvm->arch.id_regs));
>
> which makes the intent slightly clearer.

I agree. I'll fix this too.

Thanks,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
