Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE13B169AE6
	for <kvmarm@lists.linux.dev>; Thu, 23 Oct 2025 15:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761234397; cv=none; b=JGpYt3NzXygpm6me67znBs5iGU1bjkfKxLx4ywdFHqcDIFFy/uzfPk6SbeXoNI6L38r6P5wjQsecrvAVmLDahi7Q7pgzukHtn730olPQ7K82jAmMlhiTy9MZVscRVsOZt19oadqt0UQkx+d6y243Tubyz1rTeVa9gl+Lh5JAChA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761234397; c=relaxed/simple;
	bh=6pTymwxV3JY+AUKKUttfqyjqfuzMSv+BI+TUzdzowfg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UQYBhLiYNm5t3tIfzMs6CnP9Cu9LcC6OBozI1xrejwkPl75+D/+8Kph0Q4CYgsDehp8q+rTa4OCNOPW+9FW+2JekfH9V9+qWzndJr9zshQoCon+1BUlzTpkks2y4elvaY7p5hn85a76wVxJ2YlVWFb1LFeiVF4kg66QA0Ipv6Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k1fG2xz0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k1fG2xz0"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3324538ceb0so1575508a91.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Oct 2025 08:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761234395; x=1761839195; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cA8f+nNEAJRY7EiGBsr+OimXBMbTdTa3L7KnOjbjNro=;
        b=k1fG2xz0uiZouoaytOLGD4vrD/kJ59W+GDHYfKywgfVu3JNWoP4BKj/ZDpfKdUIF8Q
         IwtaCi7aS2Y/iIB/3wKFOtsSV6UzayH2eDo74RzeIpDB5ErJByjR3uBDmVLNleNQGsBQ
         Dyi3qt/To8/QyKGwo+TgH1OlmnHw0mgMswNtz1rrP6a9i7RkriPiBvaphRYlmwYZKmYt
         /dbhoLUUEnkrPtr15bHpVim7Qn0ZaXRZmW1i8/I0a9seS0m3X49o5v7ntyys624CZFhw
         hHrbMukxHlFgLML/7CViW3Q7b0cvUCAHWT1Gj5M7jDTpf4GhmYlegBe0VjsorgQdO13e
         zttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761234395; x=1761839195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cA8f+nNEAJRY7EiGBsr+OimXBMbTdTa3L7KnOjbjNro=;
        b=GQgolC7eaBvv1SX+aL4wnVCN3+0gCnlLbvIlZiDN9mYFClu9WiffbilvUmFOgZQCQx
         gYCKTIesjI6rs/4hYDsQ8wA68Xq2jeuIUdXnlF6dKAftnX4VaIB/rZWQH6lgLIAk+fnF
         35Y+ApEn5dCqzF3ErhI/AOmPm8zSg4vauuyZQdQ/JRid32oyznFbxe3PCoYZwsz8ghPi
         /lMFvzwSTMCcJSe/sHAg4r5jhtesTUr7RmbmJxbAfCjrSqWhPsDTCa0uhP5GTMb1BOjN
         FVP2if9LdeO1ehPupmbaVI6a/U6PNajy0yNB3X/lGdJQJr4Q3waYV8p1SvJcZdBKjrhD
         QSkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaNN7j1/yrqJs8FivgHhT5f30tBRdjGquySYf7Oqrq+vp2wy8mmjVGC2pTzfS5VVMFBLBObTg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9jLJ+fwjLClH2zPpZktHHpC9kBZep1eNhZsDt7mZ9ZGvW5Zib
	A8QPSEwhGQ0I1Wiy+br+Y/7Vpxw/P72xH0eRZHFv/wrhgwoibuipyDdLbiFyXPirOiNyrXFDldm
	1BtHx/g==
X-Google-Smtp-Source: AGHT+IH1AC48gpV9weuwwebG5qkhyKt/sOEZ87sVL1uSftHljNqtSkYW1d4gsE3nQlKslL7141ZzFVVxScM=
X-Received: from pjzm22.prod.google.com ([2002:a17:90b:696:b0:339:ee20:f620])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c0e:b0:330:a228:d32
 with SMTP id 98e67ed59e1d1-33bcf86b401mr34594579a91.10.1761234395178; Thu, 23
 Oct 2025 08:46:35 -0700 (PDT)
Date: Thu, 23 Oct 2025 08:46:33 -0700
In-Reply-To: <zqtfz6k3mud5rjmnfy45pdvqhmf33mkqvmtsvayf7pjz2buoiw@m5z5rqqhiqh6>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <10A5745B-411F-4EB3-A168-0BC6CA99FF4D@linux.dev>
 <aPbL8NCPCfLHIB3w@linux.dev> <aPjdgqHlxFOyjSKT@google.com>
 <62kml5omikxsb3ppd4yewcvbuje4xojffi6nkcnpxddsy77hpb@plprg57waxnb>
 <aPkYox4XLwrYi9qJ@linux.dev> <zqtfz6k3mud5rjmnfy45pdvqhmf33mkqvmtsvayf7pjz2buoiw@m5z5rqqhiqh6>
Message-ID: <aPpN2U7lq8ZDdHx9@google.com>
Subject: Re: RFC KVM: arm64: selftest: stage 2 mapping helpers
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Itaru Kitayama <itaru.kitayama@linux.dev>, 
	kvmarm@lists.linux.dev, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 22, 2025, Yosry Ahmed wrote:
> On Wed, Oct 22, 2025 at 10:47:15AM -0700, Oliver Upton wrote:
> > On Wed, Oct 22, 2025 at 04:57:16PM +0000, Yosry Ahmed wrote:
> > > On Wed, Oct 22, 2025 at 06:34:58AM -0700, Sean Christopherson wrote:
> > IOW, the starting point for us is fine-grained control over potentially
> > multiple stage-2 MMUs with modal descriptor fields that change meaning
> > based on the current MMU context.
> > 
> > > > I.e. if we envision any arch-agnositic tests that can do nested things,
> > > > now's the time.  E.g. running dirty logging tests in L2 maybe?
> > 
> > We can just as easily implement an agnostic wrapper after the fact;
> > enabling architectural validation of the arm64 nested implementation is
> > the highest priority at the moment for us.
> 
> Oh 100%, I was not suggesting that we need to do this now, not sure if
> Sean was.

I was maybe 60% suggesting that? :-)

But it sounds like the underlying x86 and arm64 details are going to be much more
different than I was anticipating, so I'm a-ok punting for now.  E.g. I was thinking
we'd want a common kvm_mmu_arch or kvm_stage2_arch, but trying to implement such
structures without a concrete use case would likely be painful/ugly.
