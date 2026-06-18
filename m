Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02843C414F
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781774738; cv=pass; b=ezuQhcqV69sXbVqwKDqbU6g0l3NhGt9PO0yQMy43Sp9qGugVKnPc069HoaVLtsxVuTY4D7L97Lw6hVeY0kZls1dtS6Rd9AeaiPfB/zvACrCzv/o6mSGGsDyEwjl7+yD7VNqDA8bpLiWawJEDrT9P1TadQWMX1FmLgpVOTaRRW4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781774738; c=relaxed/simple;
	bh=nMyv7fGhK4d8r3cu/UjWGOkJYyGMTVwtMbv3B4u8ncM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NMt3LlXxw/oOwZHCLqjnGhMXYwn5X+Tv3gVCdaJ65MaW6pVQ59pcRd4nfffN28xA7UEsvuI/tIMmMaeElp3C1nrlImWlN6XCR57kTWW49vIFcLndSd60jusyJphE8222Bg7WLh2uuexpdLCzsS4UGY7qENEW6DWIxwx61Mcor7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wFZ3IjFQ; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wFZ3IjFQ"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5ad4ee260b0so4606e87.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 02:25:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781774735; cv=none;
        d=google.com; s=arc-20260327;
        b=WFJGF1FnHGrlLuCiGngd/7qFLHZ1DTGQXcPsK/fHM7zqm1LGmTxbMMNFl0tmtKpDR0
         802dcxmhn/N9Ea6rEjkSnAFsxG0MvhWsOwpYF7przNLgUEM8/WZ6/kWPLCIC7NN0Bdc7
         IDaz7TfwIthQANp48xvTvwih46aI6pOrHWdr0XoeSjzvQ7hJgjxEjSOp49KrCMuqnq3y
         Brmo48m6nZPawMHMdwE/qobRPHOGPuwT8NYdDv9rSC6730+1LuT6ApuAIBEPT/nMXjF1
         hJ7QGn8Qv7BSac620tM5yldhk1dg7EC0o2VBAkKLsCf0PqCl9ppbavPl3+zKQMsRdIW+
         RjtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/3Zre669MYqcM/Oe6qE8drH+HyzXufisv4LydYG4RVg=;
        fh=w8JelBOxEQJJlhGGr48yqJly4F4BlK3ciU3cfHIhH5A=;
        b=oC4scrrfOYtnv9c5TTsKkSO8dhQhUtAA4Io3dNigphzeNAS5R/wuCuuRjwknoQnMkx
         5RGnzonvO7bWBerxSoBgBbiCzoXHLK0nEn06K6ZR6oJY+u/EVaZtAc/nmHojAJcxjRyw
         TUc5yK596iiXnjyHpMgIHJI/S4aBpU23+HLmLgEP7bJQi5XwcXaJbisZs9lajLrPzZi6
         iNDl14lKnDptPvu9lNuoIX4iG8Z7+r1Z5QbSaS+ZaEktRL/iQMgMH3iXeK4hGw/qogNx
         HseNbH7VwzUq3XSMNQN+1IAEs32in49ySHL6u9xCnfrW7IxCPkqGRl3HIupyasEExnqJ
         NbVA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781774735; x=1782379535; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/3Zre669MYqcM/Oe6qE8drH+HyzXufisv4LydYG4RVg=;
        b=wFZ3IjFQmmpv5rxrVvL5laTSWrHju/rskoyTc8cJ8CBPa0HXgaD+X0BfL9yfsytEAm
         uX9cvdD+AMtYVC5hGq+PbBYuTXIhEmgUD+7tMAe0VQ+VcEjMrxiGRPU/uqdRFvk2XiS4
         TFVwfr5g46iGgchdQVlbnYxUM+XngUyCeSaUj2KGwMADC3YFAclZzo+ii4jSoEJGwj9X
         pMjDhdWF6An82Hmly5foIlpXNFoMl6i+gXchEGXIKZBdt38OArLnlaSi0uGYxaEV525s
         GXWOBaV+Z18gdg4nbZzRu0RLcec7Ot/8WPcM1KLKf2ymOLyfYHSaVDoHcd9m4RizyOcp
         O3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781774735; x=1782379535;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/3Zre669MYqcM/Oe6qE8drH+HyzXufisv4LydYG4RVg=;
        b=sdXEC8jHSuz72mO1JxRF23EZqyvNKGxrTOTd9SaNCh/Au/4j+GFqK6p5T5UboU/W0G
         /0X6x6u+oAziKaUCwsZjidWmtIUh+ypGaq3pc09DgRy3o3hG2SOQeqr8QWR/xadfiuwN
         1PZJtZXVdpIFVBUMw0eilR8dscGdTwO+P8xl0YAwW31Ts4TzFyeDaEGYJb18l78lOWfI
         rXos9cD1mym08q+LUthkonddXhHk9kA5HJIYF8BQEGgA6g8qb91zTWW3M2/Ly7C9j92/
         1ctqoLp+sj/lqYEANzSk7N2LNJjn5D0G2EYWORP7niYDBav1B0U5kG9ixMdxV5pdPt2W
         UrHQ==
X-Forwarded-Encrypted: i=1; AFNElJ8pS59+PbpmeFcLDU8q2BWZRADajSA7rjdZdzb6sK3XqpJxDGNtK6uEoVQ76jFfzTxg5TnGZtA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+3/3IDtjSwDlmog4AYJAiRyFK0vv0tKvWh7apJLH0XuLFNNh9
	T8KcFkcVU8NfQdlGsOD8N63s+5974CHbqSblyObMprC/tzqQ3Z6cT9YcVO8f2puGOYnh5tEaBJw
	rvXJbFa2WK972yeFzWX3LdZ5j0B8LQRk2xyb5Lxqq
X-Gm-Gg: AfdE7cnzYlzEQq7U8+WkKhVqFgL+LndyRvBHHTmQhJ9op9pYPszXFsUsV3l10dc6Zl0
	vib9BIBCKjvJ01aj0+VjeGU4Fa+ZK38u0iXIRqsmgf6Zdx937ySOxxWJDpQ6XkqXqYqkp1njjbD
	5Ns+sdh8p4x7+1UEkCSg6Wxi38xIAbYKQ/oZ9ekhE+ReWBFCtlS8rA7jGF5nm+nPc3811FMd42/
	GXba7U0Nx+JAhlrwXbodethM4j55AXvB2VD/qQxA8b2o2nOVh0h9+T1vU5L7jffGmGpyX2otQ==
X-Received: by 2002:a05:6512:ad2:b0:5a8:73f1:4099 with SMTP id
 2adb3069b0e04-5ad4db0dae4mr128479e87.0.1781774734407; Thu, 18 Jun 2026
 02:25:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com> <20260612065925.755562-4-tabba@google.com>
 <86jyrwrymb.wl-maz@kernel.org>
In-Reply-To: <86jyrwrymb.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 10:24:55 +0100
X-Gm-Features: AVVi8Cel1tJy73CjSOqfUflX8FM5l1unqh7veSw-rmZTZN4CJ08nDfEqP60aiRU
Message-ID: <CA+EHjTz-+8M5oSh+7A2vkQ-zPmDkaKptYMoBhLz=rReufKsAHg@mail.gmail.com>
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

On Thu, 18 Jun 2026 at 10:23, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 12 Jun 2026 07:59:17 +0100,
> tabba@google.com wrote:
> >
> > Convert the manual mutex_lock()/spin_lock() pairs in
> > arch/arm64/kvm/{pkvm,arm,mmu,reset,psci}.c to guard(mutex),
> > guard(spinlock) and scoped_guard(), dropping unlock-only goto labels in
> > favour of direct returns. Centralised cleanup gotos that still serve
> > other resources are preserved.
> >
> > reset.c uses scoped_guard() rather than guard() so the lock covers only
> > the small read/update window inside kvm_reset_vcpu(), leaving the rest
> > of the function outside the critical section.
>
> To be brutally honest, I don't think this sort of widespread changes
> bring us anything. This is just churn.
>
> Sure, if you are reworking a particular bit of code that is goto-heavy
> for the purpose of error handling, this has the potential to cleanup
> the code *while you are changing it*.
>
> But doing it for the sake of doing it? I think we have bigger fish to
> fry right now.

I understand what you mean. Would you like me to drop all of the guard
patches, or only those that go beyond the code changed in this series?

Thanks,
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
