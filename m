Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF29321CC6A
	for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760537095; cv=none; b=sWYr54mRo7/T4O0jDvT04n5qDn88RF5Wcm1ur8N7faVA0W+DNHq/Ig0Lze+x4/L1PsooUW+dwdjB+Z+S+PdvPeIE88IokaWsYyPAVpo5dwFzng1Gznopaj0ms5dSeU39RsXRQFsDDQyZz5d3sBSalEEbLtkC0dQ+6DNS3SbYsGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760537095; c=relaxed/simple;
	bh=FKP112/g/eo72651dC5ZG86Ojol6zoySUjFxfFoQock=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MNH0tofIFxRXVsSRoGWLYufO0h0xSmcXhlLgr397YShaUyB8Y6em/XdgxeAMQSB4d7NlM19xXhAF31b5Zh8A1mPH7cjnJX3aOgLdyrG0ZtaweXoy0/ve5wUBCODbXflCV3e/zmWIjlBftuSB/V+y/QvTZ4J9xEXp9ZaerdVlR/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z2wZFdgm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z2wZFdgm"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befc08so22801156a91.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 07:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760537093; x=1761141893; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4DiBH4L2zFebqfEoDk29CwM1Bc3n2gl1Oz2cKH7YPo=;
        b=z2wZFdgmAEvRkhhJ2uVr4LkHETugvu4qJbO23hlwBa636K76MOR1LfTE5FtWA9tntE
         izTFDFUoJmR4ti//uIzEzzY7h8j4QJnyqxWS9IcKd2N1g3peQdDD5EfSTovKf1wwsT+5
         GsNtcRmTXh2CdHwgCPZaMmGPqsyQhIaeJzAKwm4UM1HOIEBY+NqcuDveGUxUGQ3yze1O
         wuZRO7a7I/K13ec06pcSX/940OJQhqsQ8aDIdSlD5c86TeyxkSBm8eL7/cp3wOtHfqNQ
         DFoaLQYxR0n6uR2B88IKab8zerLrF6MoqNQpqtDE82RDomcEFcnEhKh/MW+c3jxEl57k
         Zkvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537093; x=1761141893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4DiBH4L2zFebqfEoDk29CwM1Bc3n2gl1Oz2cKH7YPo=;
        b=xERaa9GpBPSfd3ffIqxIbAzCvVaXzXghtIaZ/4v8TbetQ2BZIfEYG+8RbKJ2X7keYT
         rKtmQyS6K31O6TEJeOx3sP4Fz9JC+HPWaimN2npIm+vqgyhOjMcySNtaL2pDOIUxq+TB
         Hr6/dZp6LZvmaUcYe0k9zNFpeYYdMTcGWl46l+SBUxA+iGsi5BZqNpROPGcrY8IQeJ1L
         IGSjGU2NXU170B/w1OeWZTqMLLFkBdxP3zLR8BqsGHIGqS/vgkAkVmcWWPmLLCoTMtk+
         jGzWGfdtqwRDDj8UQtJGmbaB+/AkQ9mZ/1B/hVOG5o9PJuHaB/H4HT8sw3/Qdv8+vFyI
         svcg==
X-Forwarded-Encrypted: i=1; AJvYcCWU/Crh+x+SnZYI45VnXtWZAMispBhsfP3RlV+FnFrfcuWd8FzYUegNy1KBG6Wu9KC3tP9GJ/A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYwtVEuEJhED9gw1PcxfkLNC6fLGB0boCU9cA1N4IqIwcLmoQg
	ydvL5xYyXlxwN1luCzSD6ubrs3H74azizfQ9A7/A11kDex7WQRJbauii8hFKN06gLdzZYIT0RHw
	x+5SRWA==
X-Google-Smtp-Source: AGHT+IE1+td5soWF05Hoahm6Hvpema7mHvLUqdyQlzOJZyQi5z9/sZLyyXRWNTOg3FlzXOK9GExt35QwxNQ=
X-Received: from pjbkx5.prod.google.com ([2002:a17:90b:2285:b0:327:c20a:364])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec4:b0:32e:d16c:a8c6
 with SMTP id 98e67ed59e1d1-33b5111bd79mr42350202a91.16.1760537092984; Wed, 15
 Oct 2025 07:04:52 -0700 (PDT)
Date: Wed, 15 Oct 2025 07:04:51 -0700
In-Reply-To: <81af1654-5cb1-405a-bd42-670058dd22b6@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251014122857.1250976-1-maz@kernel.org> <81af1654-5cb1-405a-bd42-670058dd22b6@redhat.com>
Message-ID: <aO-qA0oz5PyqPtGj@google.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.18, take #1
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jan Kotas <jank@cadence.com>, Joey Gouly <joey.gouly@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Osama Abdelkader <osama.abdelkader@gmail.com>, Sascha Bischoff <sascha.bischoff@arm.com>, 
	Sebastian Ott <sebott@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Zenghui Yu <zenghui.yu@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 15, 2025, Paolo Bonzini wrote:
> On 10/14/25 14:28, Marc Zyngier wrote:
> > You will notice that, just like I did with the main pull request, I'm
> > adding message-ids to the tag instead of putting them into the
> > individual patches. It looks rubbish, but I don't have a good
> > alternative, and I'm not prepared to remove provenance information
> > from the stuff I ferry upstream.
> > 
> > I'd welcome any guidance that would make things suck less for people
> > reporting bugs and backporting stuff, despite the "Link: is bad"
> > nonsense. Preferably something that we can adopt across architectures
> > supporting KVM.
> Because you're already unusually meticulous in tracking tags, I'm going to
> say whatever floats your boat.  If you want to add it to each patch, I'm
> certainly not going to be the one to complain, and/or to make your life
> harder, because of something like "Link".
> 
> Personally I think that there's a different between adding something
> mindlessly as a cargo cult, and adding it *unconditionally*.  Link is the
> latter, it's unconditional because it may be needed *later*.  In some cases
> it may not be strictly necessary (for example the tip bot used it to send
> replies, and that is served by notes just fine), but overall I don't get the
> hate either.
> 
> In fact, I'm very adamant about *needing* Link trailers for each patch in
> the RISC-V pull requests, which are the ones I look at most closely since
> the code is still in relative infancy.

FWIW, adding Link to every commit is a hill I'll die on (and Paolo has confirmed
that he doesn't object), it's simply far too valuable.  And as Paolo has mentioned
off-list, I don't think Linus will ever notice, so long as we don't send him
garbage and thus give him cause to see what lies behind the Link.
