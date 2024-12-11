Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A897346F
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 13:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733923855; cv=none; b=EyXebdSRNOR/9NbyewxE4KNU2kuuN0Gi1bw33vBpsZw+pki0GkB9bsSlu7TaiyRRqXdhzlHC7dw8kDJrTKLgkKlbTVBuk/6Y6b5T9c/x3krbvKqqxOwcioHhz0yRbhsC9ZcSN2tlroTNFYiSkcT+cKnWKV3iCABOFt0Na2QX4Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733923855; c=relaxed/simple;
	bh=C1UIaXO+VRGavSCatmr6n7DFTKuxbco27SL9QauqXHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W7u84vcQe1N1lbYAOSKUgBvvbEG00sfANw0iYNU/LMoYInT5bbiQbVALy0yV46fLcASQBQtS0kYiUgVblLkbAT5crzRXKT42h9CgPrBObQ/KFhj0ArtKzgfxpb2J18imf3dmKDjXQhv1herkz5et3z3cFxbkr6WWc7LrqRkH6rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rM5SvJh4; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rM5SvJh4"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-434fa6bf6e4so38335e9.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 05:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733923852; x=1734528652; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ulXepV2jQyhdTDFrhVhKMW5GrTR/j6m545w2I4GVRQs=;
        b=rM5SvJh4Zq4DS3aLBF43yqb6Lip9IiXsUN7LHeDs0xrObrxRIWUdLr6dWTA9ySHFXV
         c7BZ6jZny4Z1mT7TprrNi7YkfwBPHCCLdRwiNuOpL66qy3KNuSRrEaPWENtGa6+Xk5YZ
         8JbxM+xBxnbfuoVKFoz2i/V5JoT7o3d0LtfhNhPckJf8H4QlT5Nt5lzq+JXUtqdlxxjW
         vpyjSSjj4iYyzzbAYSFKxYnfyIkViH/NQnjX8G1ed35WPQ+wfYlG74wJN2ezCxOoIOgv
         eszaipkwN+5jgh+hjs8v7mrr7DcIuno/2pEykZ3dfEP4ImeYrgI7Mi2TAd0YQ19KwHHu
         pnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733923852; x=1734528652;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ulXepV2jQyhdTDFrhVhKMW5GrTR/j6m545w2I4GVRQs=;
        b=n/tfpyP0YvD+Nf2/T/vQD5gMJaprrcT9Ngb2kjD1uXF9bBkkY0MCIRsg+7G32jg989
         DzIzhweBytWktJNQBpWxlC+G+wjbvj6zDgMKCqMHTaJCn4pA9xcpYFIbJw/kTuD0J92N
         QWYnQ/hjylIn4GZbv7TADXMnAT10trrOfS3h3YyG1SJoELk9gVGXavrwl7BjeEGzB7tP
         Cp24Y2XYBWE39zeRYwLZZGAjjqwGGW86YFxtwhfAnpee1mlRcJcfNiMGTrxE9lZrPJ/7
         LviMSCEVGsDG14o9EaWdt7UNLsRe+WSlSc4LNztNT3JLPEn4EgRTsQn7xA3g7+g7NYIS
         ikSA==
X-Gm-Message-State: AOJu0Yx0a6Qc5Dt4jfpEfPyQjqna3SzHkWUpo2WCzUej0/Y+8IMR48P9
	S8PoW6+WrP0eTo3SHPwkVRhQDNJj33rIe9qFDFfg7ACIyzvZCGhReuKDbnWf1mSGwBkBVa3+YrU
	mDMRNvuiDzwewUC+IpaorJ+QpZHIjDOqDYeXp
X-Gm-Gg: ASbGncvYfHp5eZ3ZzYnQgEOjcsluswWg1yHwxY9cq/A3TPQTUORiE5enkJv15GNlu1h
	hs9M/MiFZX8jYhAQ4jYzmWMF/qS6IqXJ6Z/QhlvRcZy5X16VaTF/jUnRxYgRlDewc
X-Google-Smtp-Source: AGHT+IHRmXPiKVksQ+Q/0QXbqfJBa96/TnVG7AgNvAzq10478M87vDfF4wy2b2OQtQNTCiOmKVHSqDgIJgLmrCedgrY=
X-Received: by 2002:a05:600c:6c8a:b0:436:1811:a79c with SMTP id
 5b1f17b1804b1-4361dc51b9bmr977485e9.5.1733923852355; Wed, 11 Dec 2024
 05:30:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com> <20241202154742.3611749-5-tabba@google.com>
 <Z1MwAomiLhnMn--k@google.com> <CA+EHjTy6Y6w9RyU2Vn8O+DDviSJf=P-Y4c+xVFqY-3GmHBv3kQ@mail.gmail.com>
 <Z1mTtS9nGvVM-BIq@google.com>
In-Reply-To: <Z1mTtS9nGvVM-BIq@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Dec 2024 13:30:15 +0000
Message-ID: <CA+EHjTz6B_8YzreN5EEqh6u-ZGLj0GjBxGe2THCwjWP0RT5KeA@mail.gmail.com>
Subject: Re: [PATCH v4 04/14] KVM: arm64: Use KVM extension checks for allowed
 protected VM capabilities
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Dec 2024 at 13:29, Quentin Perret <qperret@google.com> wrote:
>
> On Monday 09 Dec 2024 at 08:14:15 (+0000), Fuad Tabba wrote:
> > Hi Quentin,
> >
> > On Fri, 6 Dec 2024 at 17:10, Quentin Perret <qperret@google.com> wrote:
> > >
> > > On Monday 02 Dec 2024 at 15:47:31 (+0000), Fuad Tabba wrote:
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > > index fb733b36c6c1..59ff6aac514c 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > > @@ -329,34 +329,20 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
> > > >
> > > >       bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
> > > >
> > > > -     /*
> > > > -      * For protected VMs, always allow:
> > > > -      * - CPU starting in poweroff state
> > > > -      * - PSCI v0.2
> > > > -      */
> > > > -     set_bit(KVM_ARM_VCPU_POWER_OFF, allowed_features);
> > >
> > > For my understanding, why do we drop this bit?
> >
> > Since the hypervisor is responsible for the power state of protected
> > VMs. This should either be a separate patch or I should explain it in
> > the commit message. Any preference?
>
> Gotcha, perhaps make that its own patch so we have a commit message
> motivating the change?

Will do.
/fuad
