Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979421B0137
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 09:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728984971; cv=none; b=ZIxia9mTjDCIu6JKKA/omCM+2LomNXVheJcr9ck9hyUVdBuE7YlXtXuUO+F9JyhzBC65ktrAX8dUCTV6IR0zNmbBp/WWuGuqzoK5/cPejPDo0GUcujeBJq7nlEI8zRaGiIRVEQNBdVRzDm6Bd7xmZCLjE0KuF2vCrgsojKpaYTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728984971; c=relaxed/simple;
	bh=DHIu2GJg2XL6lCoa8Tp5aYxrwiY8yMq/pR4wpfkNTkU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tHhigwXuuBqJNy+kR0hFA4A7jPvqAfXGrg8IzkktyAPfCPsRdkyhLJwwUXfogZ+xK9VNCa3smtWtmoIUeldXRbv6dOfOiqAk8PNWD0YedFm0x78qo0O/FGl8hs8G73lPjI1GNGaqbs040irHly4+BAGc/mpmPYQMXbVztQP+UJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qYJrJKew; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qYJrJKew"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539e681ba70so40108e87.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 02:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728984968; x=1729589768; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DHIu2GJg2XL6lCoa8Tp5aYxrwiY8yMq/pR4wpfkNTkU=;
        b=qYJrJKeworyYLMhw5c7EpiAFPvHURbRyFoiyhDyGUbfioUP9m2SHjIv2OMQ/NexAfv
         5uuRdihCHJUP5D2W4UJvDCCEIin+maaKAchLKMzFGIkn6Ru0dUDlzVjU28OleyWU7tAf
         X/4yhozO/Gb7SK+IwM1kSgruvRXhuo5ZqXACggw6ImH2f7KYlhSNntp95LMW9YfIR+8K
         j7AlhMjWR3FP8FG2TNbIlIb3BYuW+A/NldNjFRmsrObOKcN/wrYCsdFNJqBqxZYLDIvP
         YqTMG4gqz5imbJAUDSI3DIDxFk1tlhy4vwbc/XF1sZwJeV30d2wiG345qzMn097J5QII
         7YXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728984968; x=1729589768;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DHIu2GJg2XL6lCoa8Tp5aYxrwiY8yMq/pR4wpfkNTkU=;
        b=Y9lqiEI1ATU/CEEEaDrcd7zdM9I8HK4I75yXAbz2IGpwrdgyJBfIyiJCv2JrD9m1qT
         uAZajfrM0aZDQS9a/f6WaudzdBOKl7/MdRAzHlkISvnEvKCCUk5lPWqjjNEFdnpNUd+u
         LB+QSclabGL8IjLwX+lAsM9B/yIJVd0SFKWrMAJey/EmlEtoXZFXQsLxCbYVLnJwzmwQ
         f1b5WWmI3IblP1nQ0g6UZk9xh0VsPUn5TC9Et4OQZ4WqzoyMCh0/s7aaNosJjjLGBBn1
         T6w5e55B7o5A1AHpb8npj2QRitFbobFyt2Ulv5OaKleTViIsfRbjTURtU7NCvlgZ+C6w
         yQKA==
X-Gm-Message-State: AOJu0YwyhkJy4KO3ZEfSXzOtHzvGdQpf81bz5hpTlI4Gbf4tJEnBjoOo
	MPZoVUNkMcqwTAYi99PMXmeSHeoNtYELrpMbBZlymzx2ZjcjkanQOGWrn1LsJbGPvmA5D7mqUIl
	JbZYDoghNTHfizvbagcps9Am5kCKoEBmhKIya
X-Google-Smtp-Source: AGHT+IFwvEjsAfmjJsjwdq7AI/y75pUtNWz88qxCsZMtSodx/0hbpLzIHSb9xsLGNx7Lj6a7FfBDJQa0Gzb23CtCl+Y=
X-Received: by 2002:a05:6512:ba5:b0:538:9e44:3034 with SMTP id
 2adb3069b0e04-539e5f9fcb7mr923179e87.6.1728984967496; Tue, 15 Oct 2024
 02:36:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241014102413.4092725-1-tabba@google.com> <20241014102413.4092725-2-tabba@google.com>
 <Zw4byVfZngXV19ni@linux.dev> <CA+EHjTwLE+zpSKMMaRDNbuuBmvMJZZAFoha7hpiRuNhwgP60Ww@mail.gmail.com>
 <Zw4oOI7GzHnGjImP@linux.dev>
In-Reply-To: <Zw4oOI7GzHnGjImP@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 15 Oct 2024 10:35:30 +0100
Message-ID: <CA+EHjTz1vmX_5mNKOrFH1hx0u5rjSiYz1n4=vEofgn3fry4hmA@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] KVM: arm64: Move pkvm_vcpu_init_traps() to init_pkvm_hyp_vcpu()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Oct 2024 at 09:30, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Tue, Oct 15, 2024 at 09:22:47AM +0100, Fuad Tabba wrote:
> > Hi Oliver,
> >
> > On Tue, 15 Oct 2024 at 08:37, Oliver Upton <oliver.upton@linux.dev> wrote:
> > > Can we instead get rid of this hypercall by implementing the one-time
> > > late initialization as the comment suggests?
> >
> > I'm not sure I understand. I thought this is what I'm doing in this patch...
>
> You're more than welcome to say when I'm being a damn idiot, such as
> right now :)
>
> I've been staring at too much initialization code and forgot that the
> hypervisor's view of the VM is created late and not at 'vCPU
> initialization' i.e. KVM_ARM_VCPU_INIT.

No worries, just making sure we're on the same page :)

I'll give it a day to see if there are other comments, and respin this
based on yours (and any others I might get).

Thanks!
/fuad

>
> > > It'd be great if the feature configuration for non-protected and
> > > protected VMs is done in a similar way, and that is userspace changes to
> > > the ID registers before KVM_RUN.
> > >
> > > So we need this sort of 'late' initialization for that behavior to work.
> >
> > I think this is related to me now quite understanding the first
> > comment, and by extension not sure I quite get this one.
>
> Sorry for the noise.
>
> --
> Thanks,
> Oliver
