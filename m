Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F9C397E73
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781776033; cv=pass; b=awGl/04o01/Fb/YQSQLoSaUsepZsNmBjsf8ZGM1v8QUviKn8qRydBBBPmJYcEuDaVg2Wz656CouWSyszyNLgH2hxdY5AHgSADK+xqR5gLXyM2kVgzkvbzjEGkZzqfmElyuwGykGHw2r8LjGJbaMa3d4QEJfIlbjNwkw+htDNnyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781776033; c=relaxed/simple;
	bh=Z7Soew3TPCiVWkiiQZ2awf2v4XHKtpyj6S0xQatonU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FcioF4oPiW+smAC4iEPsCwsavERMSBbHIgaCw5f+8Ix5BF6QOy6i1+T4pLGVXfLCoijnxcldq7fKOiNVD9YIYdA+KQBeEjD41jpSabBtPSYCg2TIwi6bmx/qX6yX8KBpReuL2DPnRPf0Qd+Mcnh9zkZTvS8DH0o6EoLYNnMO9J4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H5asJ9B8; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H5asJ9B8"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5ad4ee260b0so4778e87.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 02:47:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781776030; cv=none;
        d=google.com; s=arc-20260327;
        b=Izup7N9JNx60Q5oMCy7/zPijSGsE4dN37VkGu6swezb/xftgOEXR9S9wqkitbE8d5n
         VKvF2P7l7qWrQHs+k7lpgcuYjYFYg/ydzxcSkIMucgFXsh4soa585M7efMubew6WstVA
         dFUCuJjKjvEr6A3fRpblN1LbbmoLUgXobEbVgGXZY+R5dtlMXU3O5Afefl+f0T0TtoIh
         ar/rbkOU9wx7t2fzs41L1X0foBwNmzpTj9QnwzsMUbQv3yTRd6tGaL4KE6mOoDxBTmie
         ft65gKjJEY9IwfdQ6TNwOdVuVdKsLiHVsR3h1gCkPZDdpU+D/hiTEixumYugeKOPp4s7
         vAcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3nOkEEN7ElYuC9x+a6xshp6SZdg9WydOxf9jhKoXMNQ=;
        fh=cesSAHfnOUeC76Jt7lkDTN87JnI3350i3rzg0Ulh/+E=;
        b=XU7PwoYSGSwjafDsGCgp5r5tpTd8d7C/m50sEf69SdLBqJCswKk1QAqpK1SdC65yKn
         sSpGh4K7xNV+RngSa6+qElYt+djhydz1yo9qD/psR5djKkZjPCwoFaGRcQrqrFV2rWwB
         SyoVMFtVHPsIf9UoS16DV8aQjLabmMB+Ijkpw3BA3DGVd6+6kdpiWqT21yqf5oMDukU3
         68sGDyhJmqKRMXu+2EU30OUrRoOczX9N7+NKoJM3NsuaqrBSstD9UcGwx4xiFG1jDP10
         qXYfK1mq2kDsBxKyfZ3yLLRe81mOS9P/wMs0nxrvLcS2l7iUurOGgCE8+rg7ovibwiwF
         6QqQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781776030; x=1782380830; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3nOkEEN7ElYuC9x+a6xshp6SZdg9WydOxf9jhKoXMNQ=;
        b=H5asJ9B8JNnBNg1NZ60qwVTJ+ELWd1lQSBbuPn+z9Bl8lW+r9zzSrFSkApLswrk1o1
         qNvqlEOivpvDxTN0UBPQ7FQE/4hQptM6nZhNrf5OasFIUdCKNtl+FeGpxxBEexj9scsq
         8oRCTEAzoirjVefil+W6ELmdMFk7SYZOY3Cb9f8Acn9RhDRgozI/2brd/hVU0Fnz6Zj+
         aCM2uKZefttxsLE71j2zOFn0Msi7UgD7dSfGlTy0ifG4a2o9KoLiBeP/Ivunt99ZdZLz
         M71ujnQy6EVZkPZpgCIZ+08Vu7KFnzeXy1MQSPMmCXfxFCaKz9VRMo2CRcI2QUum0S55
         21bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781776030; x=1782380830;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3nOkEEN7ElYuC9x+a6xshp6SZdg9WydOxf9jhKoXMNQ=;
        b=o16YOHo3fykSzZWadKZBl8iBuc2NEIylwZbztIFqVaCRLVvgSeD7B5WyJzYc515xzU
         jmn/uG+LbrMQCK2GULoBxWaGXOdd7idfQUxNwCvB270R3Kx5wZM+zhlJQWYT2LF351pR
         qQ8iyhY6E/BTgieR0+wihnXcD8N7rKj1RZLggrPRdPDrWDh1gAzVZF5m13lSKso+wEID
         VZ25kUrKMgpgbgQycub/ZjinVG7KdeR2J4yOdJy4WSvpYPRe8QmUPBIlP8WeHKNiTi+J
         PTT+jLC/FyS/SShN0vx5ywj3yXVIGvZyp6EWNcNH6HTHSHhRQURnTUpcJSeLLXaBjf55
         TQnA==
X-Forwarded-Encrypted: i=1; AFNElJ9f3MSDLGjrRcYJiMjsRKUKVq9UFe/Z1YtjPl9uZrT9Cu742JXE3PZOFlC5lbiXGKROONuFSeY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/9TnsQyq3MlIpWqbKS+mTSQzl+I002vczCZnn8kDky03m7ksd
	461TqTzKbF/Tj2jJLdkVDqA02ih2QqTp7nVvT+OBNJ905Y1rP4nXOEusoUP69ZYxfHDk6bNdO4N
	G+bzVulUCxw6FeOORH7LS8WdoXj4iyjO7SMRdc3rW
X-Gm-Gg: AfdE7cmAjGSaBY2VO6xKwckBIQk66FMqMtTP4KejxWJzpB8y4f1qDu7LJidp+ISODbj
	gp1ltc2Kz1Z5Su3KyG6aBimcXaQBn+lpQs+bhzgiFjAtZ0Oafehbduw+74rsXncN+sW0+6Cy/jh
	sos30RiZ6GGRk3UBBwpINAefaK/H+XurosHepBSAZbBcX8V8r5llt2hwtzSgs1wPaePwNkP/KGR
	3tJad8zYLDDDae0GPCVGzxutnVNWFTx7CqciE9Trks8tp2c1nRiMtaSGQX/xoG6q8PyP20VUA==
X-Received: by 2002:a05:6512:3b96:b0:5aa:883f:5da5 with SMTP id
 2adb3069b0e04-5ad4db8f3b5mr127738e87.12.1781776029259; Thu, 18 Jun 2026
 02:47:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com> <20260612065925.755562-4-tabba@google.com>
 <86jyrwrymb.wl-maz@kernel.org> <CA+EHjTz-+8M5oSh+7A2vkQ-zPmDkaKptYMoBhLz=rReufKsAHg@mail.gmail.com>
 <86ik7grxrg.wl-maz@kernel.org>
In-Reply-To: <86ik7grxrg.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 10:46:30 +0100
X-Gm-Features: AVVi8Cdj3_cVvPSPYeXrneOqZ9vthmWKgulM3oMPHaqRW3tcDe5Y00kHjlerqkc
Message-ID: <CA+EHjTytu_tKDK5+UHX0EWAweLTD-mKtMw32TiQxc0AU9D0x5g@mail.gmail.com>
Subject: Re: [PATCH v1 03/11] KVM: arm64: Use guard()/scoped_guard() in arm64
 KVM EL1 code
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jun 2026 at 10:41, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 18 Jun 2026 10:24:55 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > On Thu, 18 Jun 2026 at 10:23, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Fri, 12 Jun 2026 07:59:17 +0100,
> > > tabba@google.com wrote:
> > > >
> > > > Convert the manual mutex_lock()/spin_lock() pairs in
> > > > arch/arm64/kvm/{pkvm,arm,mmu,reset,psci}.c to guard(mutex),
> > > > guard(spinlock) and scoped_guard(), dropping unlock-only goto labels in
> > > > favour of direct returns. Centralised cleanup gotos that still serve
> > > > other resources are preserved.
> > > >
> > > > reset.c uses scoped_guard() rather than guard() so the lock covers only
> > > > the small read/update window inside kvm_reset_vcpu(), leaving the rest
> > > > of the function outside the critical section.
> > >
> > > To be brutally honest, I don't think this sort of widespread changes
> > > bring us anything. This is just churn.
> > >
> > > Sure, if you are reworking a particular bit of code that is goto-heavy
> > > for the purpose of error handling, this has the potential to cleanup
> > > the code *while you are changing it*.
> > >
> > > But doing it for the sake of doing it? I think we have bigger fish to
> > > fry right now.
> >
> > I understand what you mean. Would you like me to drop all of the guard
> > patches, or only those that go beyond the code changed in this series?
>
> The latter. I'm fine with conversion that happens while the code is
> being reworked.

Sure, I'll do that on the respin.

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
