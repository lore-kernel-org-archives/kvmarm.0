Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE901EC012
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 07:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740988729; cv=none; b=nHfXv/c4baAuSkjg8DQvD4C85JPGGF+CX/XNaypXaDk7yraIvTfJ4DMNE2gYrZSQrF2aTbnozFvavhvMKe++X2dsNa9HhLsIUV7x0vJpBF/HDogvksEt9auOBSbCJ7DDY6al1vzA+2iAbcmaEK3uohsX0d2K0WUlrJx8Y3nqCng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740988729; c=relaxed/simple;
	bh=7Eypa8UlJbVSFLC2dQyejzf/e9iV01l7sLE4jjNwdVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O9QC05iBjaVfz3nxJ7/VNCU7zi55hnQOy32QcAXpP+R/9MqriKpYH8BdE6Fvqwzm9yPYdyZOsG50FRiEqNWxSemZwS9mNsetDJgZPFrDvPGEhcZeofsK3Z1c6dUG7dldfMOrnL10n2H2EMd3zDKBg3drvzfXyLtLFs2u4ZMWInc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PIzScO5l; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PIzScO5l"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-474e1b8c935so215681cf.0
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 23:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740988727; x=1741593527; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eUO1jksSmzlhAfx/j3xxVgsgOha96dJxP5yOTtMR46M=;
        b=PIzScO5lFEgyyMxAyhQxEfhNFIMq3D/Cz4FOZ55FLTtLhGT8Y9MK0EPwiHwSToaBoG
         eONKIcNNkz+Lt8gR3Km+JOtRdIPRiQhgH/0GKVWLJRTQ5NVu86e5X+wRjk0UyjR3F5Os
         btzeZZKrtKxIwBqm9WuaIuI4ZHTxJcdJdmL9qJWMc7FheqIxt5QK9FU9vWOSGb4SVat2
         cdDXZ2kGi4hySIBPStrGOuQtXGmnsM5qlONDyB6lTiafeLfxaYaCaVBQ2qVL4e9N9tUw
         QtyifvT2qjWXPaLXBxgNIfbLaNsjIw9PeDQvWvrecto0LnHnL4LoGPWbjUfXQLhdz0ZS
         AvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740988727; x=1741593527;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eUO1jksSmzlhAfx/j3xxVgsgOha96dJxP5yOTtMR46M=;
        b=GaeXnhquWmsqzB1Yc67sh8LaTwTpMMGSrNl5dDTOzOkdrgRFdK7zaKbWEY4W8bePMa
         1MZIJ9H+SJvGtdy17aqLW+ovWqOX2TKfBK3a3q5IIlO9tWcIdBI9dY56AHzhriQeQCYX
         Rul8UVA9QHSJB4gBTojV61mroOQxyQNIzyfSpIwhecDAYivULsRVD6vTCE9C5ZFa2tKp
         xtNLOm4mGi+8mDaw6Mp8NgXhxGzIPl4drq6b7pC56AEwaJGh1A43Y+2p1yjutA0VNO4+
         1/uFc8Tu9xfCiQCuDYB255XFp2LuGvIOjagP5N2KH4VUh4qnzcxNlQ8QbOnR/tAtwylm
         D35g==
X-Gm-Message-State: AOJu0YxtgUBpyHKiAYaIbF2+JffGZ/BTjwgWBecjpEOdBORWQqT6zpYH
	1hxPN2pq/zvU6Mn0bMsPjMtokBDHRioa6i/yu6dBLhSRuMwjSu9jtX/im6nY94yKAf0q4hmTVvs
	Sq00TAUckfq4tSM1Hxdc++rpiYBwTcURdwO1r1AROH2HAPCoUTG7X
X-Gm-Gg: ASbGncsPcnagAgXb3u4L8aZFtSlXLmPiEynhLsesZsrov3xohQlGIedPHL/idY36wih
	UB1x0heTt7UErunXU6X0R/O84DPPlOjmJapODILl3DxNbm5gCAHsQQXqMMIjjtURVyAGj10Rf+Y
	irll/0M6DQtdB2niUfYgdV3RCm
X-Google-Smtp-Source: AGHT+IE3FrgYtSi6fG4kXuYXuz/jK19In39DBZldcGqipI/hiKj7Ook8PSAQkhdmiEcyY+thrVu8z5Hwh6+LBERKFs4=
X-Received: by 2002:a05:622a:6a8a:b0:474:e50d:e15e with SMTP id
 d75a77b69052e-474e50de602mr1680411cf.16.1740988726923; Sun, 02 Mar 2025
 23:58:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250226215520.1759218-1-tabba@google.com> <20250226215520.1759218-4-tabba@google.com>
 <Z8ISLxQRcsx2uuHw@google.com>
In-Reply-To: <Z8ISLxQRcsx2uuHw@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 3 Mar 2025 07:57:00 +0000
X-Gm-Features: AQ5f1Joaynh2cBRm8OtTCH-hJn2SnkXoThMxCC0fRrNpPRV0DAzWGfywmNtI5RU
Message-ID: <CA+EHjTympdi0wei2Qx=hF2cYvHpzE0sWto2ypcJB3ddmonTROg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Factor out pKVM hyp vcpu creation to
 separate function
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Fri, 28 Feb 2025 at 19:44, Quentin Perret <qperret@google.com> wrote:
>
> On Wednesday 26 Feb 2025 at 21:55:19 (+0000), Fuad Tabba wrote:
> >  static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> >  {
> > -     size_t pgd_sz, hyp_vm_sz, hyp_vcpu_sz;
> > +     size_t pgd_sz, hyp_vm_sz;
> >       struct kvm_vcpu *host_vcpu;
> > -     pkvm_handle_t handle;
> >       void *pgd, *hyp_vm;
> >       unsigned long idx;
> >       int ret;
> > @@ -161,33 +178,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> >       if (ret < 0)
> >               goto free_vm;
> >
> > -     handle = ret;
> > +     WRITE_ONCE(host_kvm->arch.pkvm.handle, ret);
>
> What's the reason to make this a WRITE_ONCE? Does it mean we should
> update the readers to be READ_ONCE()?

I don't remember the original reason, to be honest. In this case, it
was to make it consistent with downstream code in Android. That said,
I plan on revising all of these soon and fixing this (and related
code) in light of Will's comment regarding potential specter gadgets:

https://lore.kernel.org/all/20250218092705.GA17030@willie-the-truck/

Cheers,
/fuad

> > -     host_kvm->arch.pkvm.handle = handle;
> > -
> > -     /* Donate memory for the vcpus at hyp and initialize it. */
> > -     hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
> >       kvm_for_each_vcpu(idx, host_vcpu, host_kvm) {
> > -             void *hyp_vcpu;
> > -
> > -             /* Indexing of the vcpus to be sequential starting at 0. */
> > -             if (WARN_ON(host_vcpu->vcpu_idx != idx)) {
> > -                     ret = -EINVAL;
> > -                     goto destroy_vm;
> > -             }
> > -
> > -             hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
> > -             if (!hyp_vcpu) {
> > -                     ret = -ENOMEM;
> > -                     goto destroy_vm;
> > -             }
> > -
> > -             ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, host_vcpu,
> > -                                     hyp_vcpu);
> > -             if (ret) {
> > -                     free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
> > +             ret = __pkvm_create_hyp_vcpu(host_vcpu);
> > +             if (ret)
> >                       goto destroy_vm;
> > -             }
> >       }
> >
> >       return 0;
> > --
> > 2.48.1.711.g2feabab25a-goog
> >
