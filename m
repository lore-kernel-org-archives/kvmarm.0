Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F95423FD00
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 12:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733921560; cv=none; b=av9c32+liw4Oi3bI7UHHOSZ5laEwvm69zqdq8mj9ZQEnOrFOYw47kHETQ6U7HviGfbS15TCdGbyUbtxpdpAyLRS15EBNumIoQABDwgeSjGiV/UAkXbBuQVuGmLHHQFx1RivbKAAhA3dFatwnUimkFfbzBWQxGmfJ+HElyYVj34E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733921560; c=relaxed/simple;
	bh=AbnaDALkZEq+iEmvTw0FbQO3kwAbIq4UAr+UHQFsqv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pudh6jawaDYbi6uYjKa4aeQ5e8WW2M3+XmSsIH3zJjDSWIBUaa5UrL58Gi5c4uj5v6skCcxlanlYSgJH9pLxft0YSpOiUS6M7etSJL+hxg3g8L6xPm9LVbKdcRJl6/0rEi/LNJO+uUE4RX2nZALAPlLpi0beNHKU4uLmQ5didmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AQQbYAVp; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AQQbYAVp"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4361d5730caso36245e9.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 04:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733921557; x=1734526357; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=271uW+1xPv7CJCNe7w9FZ47bv8k49aJ9mD3ELi0uLgg=;
        b=AQQbYAVpipnfYPUlRUUd4+TCcHDIfu1LZs94OmLw5osI4YyHWeUYFfa+IQwVBx9QM5
         gYP6nZu0r3h/D6vxXOKjGRk/L85dYPV6yZux/jTOnB8YcGO7Tqd51s3YlzvOVOal9zWU
         6SyrRBYhM1qZ3pFsGLXeBo4AFOr0RSMJfliZ2vcpxA4rh+jXdWtU38IPhtzcJNauAHCE
         nk6A6XQmw1X3GDoyZkWbt4RngG78qkB5if8sTVq5QuaUDiPgStMe1ViWhDfCeXJODF86
         avXl6fEjGMenygOAGbS664JOTFFBaYcva0ADFsfXD5qqnmor9SyY0JxQYfQHGk50gzKn
         TngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733921557; x=1734526357;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=271uW+1xPv7CJCNe7w9FZ47bv8k49aJ9mD3ELi0uLgg=;
        b=oInUYHsbHt2g/ndkv6ViRaGw8fXyKbUljhKx4peH0GKHFj7ZyTAdy1WWrwcTW8N9QV
         jd+om3dMtsmaxwkriH1ZGcWgLVOIo1n2K1o44trUuQj7DVavnouyXe84vs3lJ0CEQ0Jf
         1cSGa+VSeO9qc31RK44jGTubA9DMqwUooHcM8cU7SSrvh2BKXOcHUue85fDAL2Q5LmDB
         ZHit2M2BJBat8ta/HlOihYY9EAZ+V85ynC9rPYM28WzXLdhwjS4QlbGmdXwOSt1ubed8
         s2J6OoeqMyYySXR968KVpBC1/35oXAc66EzaQonuuNtWwYaajSg1AqI+n0LwNMqCKPm1
         vZjg==
X-Gm-Message-State: AOJu0YxtS1qRrmneLAAiTDHa7c8yVFskQO908cuFQbwT0jb5ieJn6cmM
	RMkKZF96udX8u1sh+BTYUXAmblfA+2zdoUqD+Q0xyXjsIddEKBVI2jRhj3lGBPGS6q+7MXoimur
	hzaiG+yhbxJLFnCXjuU20Yv1Qmf/qXK3YT9I3
X-Gm-Gg: ASbGncuwN082mwWzWE6TA0MsOTN77Q2P9XTUn3h9kHfNhuQ5v82J6Du5L0SxhdA2Qp4
	PEmy7ftDmrA650jhKxAAX50T5EqURjIJ4DqcpDjxoqall6105vjaLgsrVtvwfuV1t
X-Google-Smtp-Source: AGHT+IEJ5Z7J4T0pbtdb1XaT/LEsMpdnN+BaxN1Eg8jcKGqq6J6SI3/cA/Q4epYOeBKzFi9FCsCU+huAtx1SIzewIrk=
X-Received: by 2002:a05:600c:2105:b0:434:9fac:3408 with SMTP id
 5b1f17b1804b1-4361c0f4f80mr1201685e9.2.1733921557222; Wed, 11 Dec 2024
 04:52:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com> <20241202154742.3611749-10-tabba@google.com>
 <Z1mHtVJ4f7_N_wk4@google.com>
In-Reply-To: <Z1mHtVJ4f7_N_wk4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Dec 2024 12:52:00 +0000
Message-ID: <CA+EHjTy=zpDx6OhcQFAk7uxcqQmsVUgB=DuZUppszr0KVPGZhA@mail.gmail.com>
Subject: Re: [PATCH v4 09/14] KVM: arm64: Remove redundant setting of HCR_EL2
 trap bit
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Dec 2024 at 12:38, Quentin Perret <qperret@google.com> wrote:
>
> On Monday 02 Dec 2024 at 15:47:36 (+0000), Fuad Tabba wrote:
> > In hVHE mode, HCR_E2H should be set for both protected and
> > non-protected VMs. Since commit 23c9d58cb458 ("KVM: arm64: Fix
>
> I'm not finding that sha upstream, in which branch is it?

The whole commit is wrong, not just the hash, which refers to
something I have locally. It should be
b56680de9c64 ("KVM: arm64: Initialize trap register values in hyp in pKVM")

I'll fix on the respin. Thanks!
/fuad


> > initializing traps in protected mode"), this has been fixed, and
> > the setting of the flag here is redundant.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index ffa500b500f2..cede527a59d4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -57,9 +57,6 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
> >       /* No support for AArch32. */
> >       val |= HCR_RW;
> >
> > -     if (has_hvhe())
> > -             val |= HCR_E2H;
> > -
> >       /*
> >        * Always trap:
> >        * - Feature id registers: to control features exposed to guests
> > --
> > 2.47.0.338.g60cca15819-goog
> >
