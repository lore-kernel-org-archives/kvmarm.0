Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E125833F6
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 19:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741029736; cv=none; b=IvUo5YOgAS5q1imP/B7GgH5izJHuE7Q0JdWC9nGjM9IVwqNOlaKUgZq101mfWBItEoTXoSGo57X27Vq89tL0IGpGnIfWCFMiXY8ASW9o44B9JRz/dda+02khu4eTt4mizRbtYNlbmZ2RLuYmJSA/1dQ8lQ14GtTVxLa2m9qF3oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741029736; c=relaxed/simple;
	bh=JWWTShIikkZrJnIQAM0T1MAtzt3yaegknH6lY2DD8W0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oNwfkzHgbgVIeU+WRq9YnN0ROTSqjrvFhuRcbkwJdZcNcLOrKI5HQg0CBn3Rse6WyCDDGKv8kZK+hQsPJPeDPWk+YEHnEPKI5tGsurLKrh4fa9gYnlwRb09KExlODeu3qNbn1uE/qZUp29aLGwvlVhLEMljCk7P8b5oYuFGfe/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ls4Ro50Y; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ls4Ro50Y"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5497363eeafso1177e87.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 11:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741029733; x=1741634533; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PDLT3QzYiiEMxH3LRhvcTZswaNirfgCySO+G8g1d1Lw=;
        b=Ls4Ro50YdquvRUvh3vf7WTsBdayldU177MZ9wwZBMIVqBDu+2nj5Im5D3qlPmRItLE
         W7ivjDovibezBHkHy/qMFIWDnWWCH0AZuYiDSzkiCwDkB6SUkNHIcvvNPIMd2xkP3REX
         OH46B/hr2sjJ8/K2eOJ23pMpV4poMLiwctwDSF2/dxIxtWWQG3vgVwWjp2pp/oq8zey+
         of6b6oI6OIPXBBhP0/sewDHzj9r8fmAqLDitMcjosQlo9GRCgbdHgJqsuHcsLKbnjJOm
         ue59//NcbwB/Ye25c/1NOpqmT7eo7mstjzeeT+MD4Cdy8oCyRPZj1RtWPlpiVXlg3QEl
         gc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741029733; x=1741634533;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PDLT3QzYiiEMxH3LRhvcTZswaNirfgCySO+G8g1d1Lw=;
        b=YF2ibDB9qWht5lRt+j2ej39czuIucZoUnKum3PS1NJSfJm4W8afUWS6T0D+1SNDTIy
         eQxIoLHHuSePG6044XlLvhGnKew57yR6isNHEPLjsrtVYBN70jg/IwHmyyCmPxFLMmQ/
         3XaJLHpbY+foABDls779c7qZU58b6EotyVDChw9hhvyG/Eijz+KNIQjIX3OmHj8Ety7a
         RbqDcORbm0OUWzF+epszFFh6c/30OO+aLyZKucllPa6be/t6x9v1X+P0fovntoHezXAP
         t6HNlB5BRAZ+7Dxgig/StB75PedaHADSLNzjqLocDQ7oexpi/A3GM/j1nvGtpTzXKFAT
         F1cA==
X-Forwarded-Encrypted: i=1; AJvYcCXT2pYv2f7b/YP9rtX4H4ck8HcCaDyg6yMooHQjcU07mdIzZ+3v1bCBUGWrwRLsAJbG78YBeXU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyH3rCHh5XaPAmb+AvyqQobBG8uWitTvuQdzvq+63KtriKqBYaZ
	FaIY9zpqIYtVyIZ83PzIOgErt2drN0fDuGr4PtViWqZ8UfK7yQms5/NeLj/2fx2aaPscT0wyKyV
	owLTXEa6tBTAb5uaBesED/wtgE5mftoF5nMki
X-Gm-Gg: ASbGncsG8PZ+nhhycowEikYYUpuPc8C2DIqyjpwyPZsI39jFfQHBRuuaqFpv/8Hroe/
	SQe0LeLgJbfwLrSgh3oJbuPMJ8TTnv+JnHTmi4JYeH/FerxDv56oND+QyfaRe/zacgwcO2I5Xlq
	XZfa6Tya6IsvYfpYfODwFvBaY5
X-Google-Smtp-Source: AGHT+IH0UTG3oJy1Apr/sXOoJuaoHHK92kRrLOibMfH2rbEqTUafssJ68yUuJTdCNdnYlytHqDJOqqFRXysa369aflM=
X-Received: by 2002:a05:6512:3f1d:b0:549:73a8:c258 with SMTP id
 2adb3069b0e04-54975de8114mr25263e87.0.1741029732676; Mon, 03 Mar 2025
 11:22:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250226215520.1759218-1-tabba@google.com> <20250226215520.1759218-4-tabba@google.com>
 <Z8ISLxQRcsx2uuHw@google.com> <CA+EHjTympdi0wei2Qx=hF2cYvHpzE0sWto2ypcJB3ddmonTROg@mail.gmail.com>
 <20250303191811.GA30361@willie-the-truck>
In-Reply-To: <20250303191811.GA30361@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 3 Mar 2025 19:21:33 +0000
X-Gm-Features: AQ5f1JovXie3lpePW4x4dhoQubm0OwM3WEY0HTJKnA6kBEqtNQIAaQvijWR7Ijk
Message-ID: <CA+EHjTySqDHDpOy=Vix5ZaNKWg61coySvV3Yk=+i0p8vg3mXTQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Factor out pKVM hyp vcpu creation to
 separate function
To: Will Deacon <will@kernel.org>
Cc: Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Mon, 3 Mar 2025 at 19:18, Will Deacon <will@kernel.org> wrote:
>
> On Mon, Mar 03, 2025 at 07:57:00AM +0000, Fuad Tabba wrote:
> > On Fri, 28 Feb 2025 at 19:44, Quentin Perret <qperret@google.com> wrote:
> > >
> > > On Wednesday 26 Feb 2025 at 21:55:19 (+0000), Fuad Tabba wrote:
> > > >  static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> > > >  {
> > > > -     size_t pgd_sz, hyp_vm_sz, hyp_vcpu_sz;
> > > > +     size_t pgd_sz, hyp_vm_sz;
> > > >       struct kvm_vcpu *host_vcpu;
> > > > -     pkvm_handle_t handle;
> > > >       void *pgd, *hyp_vm;
> > > >       unsigned long idx;
> > > >       int ret;
> > > > @@ -161,33 +178,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> > > >       if (ret < 0)
> > > >               goto free_vm;
> > > >
> > > > -     handle = ret;
> > > > +     WRITE_ONCE(host_kvm->arch.pkvm.handle, ret);
> > >
> > > What's the reason to make this a WRITE_ONCE? Does it mean we should
> > > update the readers to be READ_ONCE()?
> >
> > I don't remember the original reason, to be honest. In this case, it
> > was to make it consistent with downstream code in Android. That said,
> > I plan on revising all of these soon and fixing this (and related
> > code) in light of Will's comment regarding potential specter gadgets:
> >
> > https://lore.kernel.org/all/20250218092705.GA17030@willie-the-truck/
>
> I'm not sure the spectre stuff changes the concurrency aspects here, so
> Quentin's question presumably still stands even after that.
>
> Looking at the Android code, this WRITE_ONCE() pairs with a READ_ONCE()
> in pkvm_is_hyp_created() which is called without the config_lock held
> by kvm_arch_prepare_memory_region(). However, given that
> pkvm_is_hyp_created() is only testing against 0, I don't think the
> _ONCE() accessors are doing anything useful in that case.
>
> The more confusing stuff is where 'kvm->arch.pkvm.handle' is read
> directly without the 'config_lock' held. The MMU notifiers look like
> they can do that, so I wonder if there's a theoretical race where they
> can race with first run and issue TLB invalidation with the wrong handle?
> That would apply equally to the upstream code, I think.

Would using _ONCE accessors with the MMU notifiers be enough to avoid
the race, or do we need to reconsider the lock protecting the handle
and apply it to the notifiers?

Cheers,
/fuad

> Will
