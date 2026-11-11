Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418682;
	b=MyoLLQHgvrREohZDO+ef0r44NfQiCyGXQ7UtaPogHntamgesyjt5FX9DlURO3KrcB9AJ
	 dWEnbntvInbXCd8+DoO1N7xBdsLB1hP26dsqm0nmHftCUu2AAsVKL3kYv+IZdTiar1w4z
	 U4aHlpWWjqtUZUKz1NnMUqEXU2XwrK+kvgkcUZOU8wWNobG8w4yWnvF+LEm4jB3AjOdcv
	 /dSdfgcnHhnr75YnpM7/KyV7H60u7FuR3vMnAYXSiU5xaeCXwRZJQgPDEaa2XmnvYou9o
	 eEdouLuQW2uPvmuv/Ao7D+bqValU3JjN0Ph9uKPI+hmZvCUN4hgE9VC/kU3BXijMEgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418682;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=IGymzurcCAqkuazrSBLvvuD8i7vbGW+naOWdeyf6NCQ=;
	b=k2uT6XcOWPw4JlIBcEklpmNqOyk44R+24x7jGR0jEyX3isnTXOkFmaDWABeWE28bc7Nj
	 gTvDURYuXSkW37C4Ncstzo5mZGc2UJRzhZC4+q6hzA64Mqs5gjlJ3OrcvW/PyYAQ15tXd
	 ICa2ksCgIPOaCAST2oEoX1HfJ8v5IfITUzVt3sR/o5f1GHq2pMf3HhvYyDtKrvE1N9n/5
	 6dz2YVvrquL0e7wKsjsf/E6AqkvLNuUqXNOfbaGcQAU114Ts0xBfzuw8rnLfF1vtP+8vM
	 NH4zV30u8zzHiZvu7idTLnJ3gHAoK6/I/1AA/RLixSXyWzq1qWqyOPLaB7veXNlhJfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dgEAFrKJ;
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939A9606A333
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 17:38:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 939A9606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dgEAFrKJ
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdd9fa2a558so1165873a12.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 09:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794418682; x=1795023482; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IGymzurcCAqkuazrSBLvvuD8i7vbGW+naOWdeyf6NCQ=;
        b=dgEAFrKJ/qnsiqUd+i5gOJype8syiwWvGZEpJbnVqKNEt933PiWSC8bF+BSFHYXaEV
         25NXiMzK6e81pV8yTDuKO49hcqdGKurYIqyvi5WdoPTFRHFpnhHotr+aLJsLRNF1+kpI
         iqF3o+rulte3QhBe/tj30La9TUU4QJWfo8cvVdYeICzy7q8b3xJkDMXYVpd1mQLdvwwB
         s8QDQRewy9X3vRwOytAAHW4w5b26kkqg+q/uzCgrpyuCRrVvqqLiH9gEgij0AqXhV0OE
         AWpG31DiJCFAIFYEgpIbT+lXpeb7yxPuVU+x41W+u6krzv+pj1XZ73iA35bLox9vZ1hY
         vIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794418682; x=1795023482;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IGymzurcCAqkuazrSBLvvuD8i7vbGW+naOWdeyf6NCQ=;
        b=RgETEIfArvGDTrCneYICtF4pGYy7CIJo9fQ92dn2g+/+srlxVjClXLJNXjZKiSu79U
         G2SWKNeIcKEmUB6u2L6PxH3ybfb+fK/sK15Qhvkw71iyoEnlBqz794GLG0OGFHUfXOPj
         iVxW9mWo8PEu7J381Dn337LOxla8+QMlQH3KbhyBHqASeW6GgD4/ggCrrsivzNF3W4lf
         XY6tAdrjgfD8eL9Hzcr1kLvj/o43onCKF0sCEnBEKPEWEhni1NMYnnTjX6tX71Zozhgs
         XljWwKrfcM+y+n7oTlkkZqGx0zCetPqVN9ZFxEttzdkgKRLqKT5QHNHb7ZHkyvXIJoDu
         I1Jg==
X-Forwarded-Encrypted: i=1; AL+hErGrixCH8DjPIAzP1OkJ7xVOWDuLxx9IGfioUiIZnm4GrAkebE2kcn9Sge7UE8mBhAKHEj65svk=@lists.linux.dev
X-Gm-Message-State: APuU4Z/eRokt1wsFjMDBVIIv5gM6UK/1iYVYyZcaUqlIfX+io9W8Q+2c
	7tRF0vmy3IEDvN9UMIeM5xm2p55+R/hbGARc7H6ZQsQmosX1CbcD0QBy61u0Iaoc+NFR/qQveQQ
	qHuwkbA==
X-Received: from pgoo5.prod.google.com ([2002:a05:6a02:3485:b0:cd8:b51c:c0b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7349:b0:3e2:6b5a:fea3
 with SMTP id adf61e73a8af0-3f2ff4cfa62mr3490465637.71.1794418681497; Wed, 11
 Nov 2026 09:38:01 -0800 (PST)
Date: Wed, 11 Nov 2026 09:38:00 -0800
In-Reply-To: <auzSxEsGAcm3MYtN@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20260714160411.302386-1-alexandru.elisei@arm.com>
 <amPCdAswlk24Xilf@google.com> <anxAGkdyPYXBlS00@raptor> <autwsR83Ii-tRrqF@gremlin>
 <auzSxEsGAcm3MYtN@google.com>
Message-ID: <avSn-IW8DMybO-Tg@seanjc-mac.roam.internal>
Subject: Re: [PATCH v2] KVM: Ignore MMU notifiers for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, david@kernel.org, mark.rutland@arm.com, 
	ackerleytng@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 05, 2026, Sean Christopherson wrote:
> On Wed, Nov 04, 2026, Lorenzo Stoakes (ARM) wrote:
> > [updated David's email address to @kernel.org]
> > 
> > On Wed, Aug 12, 2026 at 10:42:50AM +0100, Alexandru Elisei wrote:
> > [ ... ]
> > > On Fri, Jul 24, 2026 at 12:52:20PM -0700, Sean Christopherson wrote:
> > > > It'll probably take me a few weeks to circle back to this, as I finally crawled
> > > > out from underneath a pile of urgent and am just now getting back into review
> > > > mode, but this is fairly high on my todo list, so with luck we might still squeeze
> > > > this into 7.3.
> > 
> > Hey Sean,
> > 
> > I wondered whether you'd had a chance to look at this?
> > 
> > After discussing this with Marc and Alex it is clear that this is really a
> > blocker for Alex's SPE series, as we need a sensible means of ensuring
> > that stage-2 mappings stay in place.
> > 
> > So ideally would prefer to get something like this in in the next cycle,
> > if you don't have any objections to it? :)
> > 
> > If it'd be easier, I think a smaller version of the same patch would also
> > give us what we need? I.e. your snippet from June with the page ageing part
> > dropped, as below.
> 
> The GPC invalidation fix landed, so we can go straight to the super simple v1.
> Compile tested only at this point, I'll formally post this (hopefully today),
> assuming nothing explodes in testing.

/facepalm

I spaced on sending this (and I think on testing it too...).  I'll try to get it
posted in the next few days.
