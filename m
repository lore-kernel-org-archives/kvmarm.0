Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716001;
	b=qNxMiUE0fp0djXP7CUdVuXq622ad/1zzdZk1FA6l4HYHctL+EnYP6jCzzLTj3oIlA9bQ
	 FyHqMShcRzW1IePrLDheLF1EM0m/ahgNyxyhkafcrBYLqzZxSwpbAO8C7ZJbDf6cTZkXR
	 IeS0t39b63FildIYEm06G0e/h2/bJSnt+Z11xIjN76SwyAEB5nOpbDxIQsv9LGOGcnyA2
	 Bf76BDy2w9EVwlc1fUHYTzfCgc2bFKgM7u+sWO1cIzH5waAwOdGR9s207pLMoYIm2bFF0
	 9rQlf5PusN0RNWaps0BM9VMzg8Hr3+4690DEFix88UIUy1MHScfjyrbzgNmnhgvssAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716001;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=MMnUGkHRy+otlfLzxjS9F1trRkrtSmw/Pufvv+pTUZY=;
	b=OT6LEdYv4+CdKRtMFVA+EJxfpYBrt+z0U/xzj27UQZUdJ1gBouY6uIWJ/+pHj9e0H0Qs
	 KxKPlVYQRSVGqBU8mC4jY+MpFEHa/ILu6M5ap5fOuMJYAG5HpF85DJ3FjEYUlzyj5SywG
	 wKnzp6pqpjz9s5QqhSMkhgfNWgsreCDF1tzQHGlpfOm97eY8WxkKumnvQYckz+KmmlAAY
	 cTJeHxMPiw4aag3CGqNPtuYGG7IQXqOa7t6yRNke4S3theYa/7+G4BVIzc9NjdPeh4rWA
	 ozDnbkDKA2kbyyK9pnHW5oSVqOdYJzV4InmkeXyyDnDRgf/CT0xhxWWsCa9A9F0oFUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cSHu+ZOm;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E80606A326
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 14:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03E80606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cSHu+ZOm
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso34716385e9.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 06:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793715999; x=1794320799; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MMnUGkHRy+otlfLzxjS9F1trRkrtSmw/Pufvv+pTUZY=;
        b=cSHu+ZOmp2+ZKGxyqWEYkiEMRHLL6nyvduNbHkXXlqdOtK/yKqEW/6y14PYy9S2Ac0
         0lMJdfVVVFoz0b8oIWxZQZaeLbJQ0I8FF54zWyjARxUgG0KaVBteUM2ZFW/MyK2L3pz/
         DsVoQLzi8rSsBCKmDnNs06KcXHph6iEAM92t3VcAblmcZZdYNymgpUYAsY43UFKTPuYw
         dhtn8exNju5davfNDEJPW6L4snpOFDN1Ni/RvmBltbJFHuWk6PCcf9BY8wyYqKXjboNj
         JpZVvS7Ayy/S1M3i4ueZVZLo35Rpley+wN7BBHhMZZ70gBJCDGpO6LEpdMUkwbLCY0nA
         75wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793715999; x=1794320799;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MMnUGkHRy+otlfLzxjS9F1trRkrtSmw/Pufvv+pTUZY=;
        b=eOtivbQgG+2qQUgrCCl8JXLkwC3Xc3LPtuZ1OJaUHiGiDKvJ7eSD2h1y81bk49ME9l
         klWwVv+LnP2RtwzYdXIMlBQaw5X4ukWbhF29NC557GuJO6d8PXTUCD4N4J7Lgz0uaHQ5
         BlBArBYU6GH4mqqiAnouQNtdDHk5mKEFsBZ5tFzXWsIAS+sOas/a9PYKumoFIkjJPXWV
         752VFgeRbEd6hAFpc3fcs70SpMjRBdoafD6FjyJBkvqOuGiIN5oXbzzb0OWyq8oFBYwJ
         lgsMbPO/BSgkVPnlETaxIdSrWzV5BL/JwiztZfWwRKl/7umCD0I5HLky1CIgPkZ6Rz1t
         6ULA==
X-Forwarded-Encrypted: i=1; AKwUvBywlYlISzW3/XchwTNjL5zmP2W3WPxV2Dcdt0nSkZP19U9Y0knyLLFXGsiZniZ39/RipqUQf8M=@lists.linux.dev
X-Gm-Message-State: APuU4Z/EY8P7uMuQmrtqFa2gj+VKUuOKzzBPDFzw7oyhiD6PrmkOZ0SI
	n5+hwqqLlvSSyuXjRn9ilxA+LDgECSnPS5thV/yAFgKN1fREhnTMem2zvmNAwuJiLA==
X-Gm-Gg: AYBFou3g8/KiaRI5Ju/SIwlezZYPY4jQOHVbw4Sigkz+46fkbOds5zbpkAJ1Tnwei22
	dmvCT8yEdmzcflQJVibc1kkOKGie2BOblR4ovf4HiJ9JIU4p5dV1hjCXPwUr+c2bAuPhoHsb9Rb
	V1f7/ONEY7zwLQ2HLGUU63QFuu1gzvC2UdDE7yTvoF0q96Bfl+4qaMtn4QZns/HErm9eFB2lHiC
	ahghv7l1pcZXmGI2YAGGCL9wEviwtNda+aD7Fcrye2tohXpXB6I0b99JYHSGC5QCivmkHhhMeKl
	KLp9es0JVrOpVfKL48+JDEDoqkXJxeTDurcDYOau8f2lvhU06cdM/Gshd7FJplIb6BCP48uFDXj
	ihIQjto4CvwS02Oh+GJgGLcWm31sIqFnUWmCUvjx7I3uH+BzEdiMbSQDxoMDe449qamjHEUZGwx
	Y7QoVUK7qhfZrzv/wt2zaQkbXVy5Wl/itJC/WlpRXCb/jOALExYpPIeszCTB3eMENhAxFPRa2ck
	ACKKJjbA3Du/m8Ys8cLsqnU1C/HBx7PiaH2XPIYrWSpaZ0r2BuPTsdCBxvcv+iKvVPSUmK5Z5YM
	X7PchO/SJDcd0qzgCJvSLLHEufvOQsa0RhRgszjMuy7NOH+k956LGO2aF/5H2ptT1Q==
X-Received: by 2002:a05:600c:4e48:b0:4a2:150f:1610 with SMTP id 5b1f17b1804b1-4ac183d16eemr287425385e9.23.1793715998361;
        Tue, 03 Nov 2026 06:26:38 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac0950d533sm204541635e9.3.2026.11.03.06.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:26:37 -0800 (PST)
Date: Tue, 3 Nov 2026 14:26:33 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, ljs@kernel.org, ryan.roberts@arm.com
Subject: Re: [PATCH v1] KVM: arm64: Fast path transparent_hugepage_adjust()
 for non-PMD folios
Message-ID: <aunvGQb--3Lp6kQp@google.com>
References: <20261102211900.504192-1-vdonnefort@google.com>
 <867biu2ujs.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867biu2ujs.wl-maz@kernel.org>

On Tue, Nov 03, 2026 at 08:22:47AM +0000, Marc Zyngier wrote:
> On Mon, 02 Nov 2026 21:19:00 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > transparent_hugepage_adjust() must walk the userspace stage-1 to detect
> > if a PMD-level mapping is installed. If it is, then a stage-2 block
> > mapping can be installed. Even though this stage-1 walk is most likely
> > cache hot (in most cases, the mapping has just been installed), walking
> > a page-table is still costly. This walks accounts for ~5% of the
> > user_mem_abort() execution time on an Apple M2 big core. This makes a
> > fast path interesting.
> 
> This raises a few questions:
> 
> - Isn't this a "fast fail" rather than a fast path? You don't make the
>   S1 walk faster, but you instead avoid cases where it would have
>   returned an level-3 size.
> 
>   If anything, you make transparent_hugepage_adjust() slower for the
>   case that succeeds. I don't think this invalidates the approach, but
>   it feels that the commit message is just wrong.

Yes, "fast fail" would be a far better description.

> 
> - How do you measure this? 5% feels like a huge amount for something
>   that should be 3 loads. Isn't this more an indication that the page
>   table walker is overly complicated because it was designed for
>   something else? In any case, It'd be good to verify your findings,
>   so please provide a minimal reproducer.

I have booted with qemu a L1 guest. Pinned to the biggest CPUs of the Mac M2 and
set the performance governor.

Then in the L1 guest, I disabled completely THPs and enabled the tracing
function_graph to measure user_mem_abort() and get_user_mapping_size(), before
booting a L2 guest with a single vCPU.

That gave me something like ...

 0)               |  user_mem_abort() {
 0)   0.208 us    |    get_user_mapping_size();
 0)   5.958 us    |  }

I have skipped the outliers (the function_graph prefix them with '+', '$' ...)
which I believe are most likely related to interrupts.

Then for each pair, I got the percentage get_user_mapping_size() represents in
the user_mem_abort() execution time.

Now looking again at the results I have, I realised I gave the mean (5%) but
perhaps the median which is 2.7% is a better representation of the overall
improvement and is slightly less impressive.

-- 
Vincent

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
