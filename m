Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9240153E13
	for <kvmarm@lists.linux.dev>; Mon, 11 Dec 2023 22:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cwi9buOC"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5de8c2081d1so42034207b3.1
        for <kvmarm@lists.linux.dev>; Mon, 11 Dec 2023 14:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702335422; x=1702940222; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XLiTtRRqM+qNBV6tYcuiNPBMTUo4FdzTRXinHk4XXSY=;
        b=Cwi9buOCGKlpuG1lHoACs47f26uonCRt8VjufKI2DI8HsOdcx3VkjmGszbKcwTUdbQ
         jb7lNDb+SZPhrWrX1LJKJq1F/fIS5ES86A6NnpWmDdCOxgMCCYgVjr5f278G82IM/PPI
         CUsV1ajOR6wvVDcB2K0Lrxu6+sotdlTcC4bp/uh5Z94jF9H70gF5yhOXkWfVYzZ/E7nV
         fIqFOLTFI30YsV1G93mNMj9RYQPHtiK3tFa7TvGDY3/gkul35wbkRlP3S9Zu7ImDB6jY
         uq7WepA+SNGczm57YfdQl1AOVSngKt3DkCCxwq+C4nc+sx/V5JtLz4YpuulCwyCs6+jO
         mylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702335422; x=1702940222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XLiTtRRqM+qNBV6tYcuiNPBMTUo4FdzTRXinHk4XXSY=;
        b=NLCORjxjTFeyejmqIQZr67u7ra8Bm8TI0k/VHTQ/KV5/1M1HQVAzKxRYqmIqc8wrbj
         DowTMA/fllVnbRZ2oPT1epzhWN22QqI1qomB14q7EMmM5/cdQGdeM8vHE6duBro6acMf
         LNDKqA9kqY5dVu6YiOzXWQ2yQDSEpIQyN3KuRrqN9dDYuLRhZEy37BDYzRNsEtTHp7sL
         lhyHI3IL+l8r1nVYcrgwPys1i1IuLCzj+naczCxajs5kOuld/kXndVpqsB+pPiAI/obZ
         YkkxOqMaL7qfB0LDhsJ52tGOVz/n+6LYla22G8xlEkPnk8hSufPFibgYC5qgVltVgidT
         9YIw==
X-Gm-Message-State: AOJu0YxyWg1lRLFZO/PsNL8fXSFebeNfxxu4XqdeYo6WPdo4WxEJKHlz
	f0lPlOWHyX5wICmOVCBCpdqWFt4kjnk=
X-Google-Smtp-Source: AGHT+IEhhypj7D/PwqeFaL95W7v5NUceMg/HzzkyowCvBZn3QIeqdswnpmg0GcBg4W9bI7RZryt2AT+W5iM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c01:b0:5d1:104a:acb5 with SMTP id
 cl1-20020a05690c0c0100b005d1104aacb5mr53522ywb.2.1702335422457; Mon, 11 Dec
 2023 14:57:02 -0800 (PST)
Date: Mon, 11 Dec 2023 14:57:00 -0800
In-Reply-To: <865y16b6cf.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
 <SYBPR01MB6870FDFBB88F879C735198F39D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
 <865y16b6cf.wl-maz@kernel.org>
Message-ID: <ZXeTvCLURmwzpDkP@google.com>
Subject: Re: [PATCH v3 1/5] KVM: Add arch specific interfaces for sampling
 guest callchains
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Tianyi Liu <i.pear@outlook.com>, pbonzini@redhat.com, peterz@infradead.org, 
	mingo@redhat.com, acme@kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	mark.rutland@arm.com, mlevitsk@redhat.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, namhyung@kernel.org, irogers@google.com, 
	adrian.hunter@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Dec 10, 2023, Marc Zyngier wrote:
> On Sun, 10 Dec 2023 08:12:18 +0000, Tianyi Liu <i.pear@outlook.com> wrote:
> > +bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, gva_t addr, void *dest, unsigned int length)
> > +{
> > +	/* TODO: implement */
> > +	return false;
> > +}
> 
> I don't do it very often, but the only thing I can say about this is
> *NAK*.
> 
> You have decided to ignore the previous review comments, which is your
> prerogative. However, I absolutely refuse to add half baked and
> *dangerous* stuff to the arm64's version of KVM.
> 
> If you can convince the x86 folks that they absolutely want this, fine
> by me. But this need to be a buy-in interface, not something that is
> required for each and every architecture to have stubs, wrongly
> suggesting that extra work is needed.
> 
> For arm64, the way to go is to have this in userspace. Which is both
> easy to implement and safe. And until we have such a userspace
> implementation as a baseline, I will not consider a kernel
> version.

I too want more justification of why this needs to be handled in the kernel[*].
The usefulness of this is dubious for many modern setups/workloads, and outright
undesirable for some, e.g. many (most?) cloud providers want to make it all but
impossible to access customer data.

[*] https://lore.kernel.org/all/ZSlNsn-f1j2bB8pW@FVFF77S0Q05N.cambridge.arm.com
