Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8A7140E55
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708711205; cv=none; b=DrmdoDhCc2ZHCv/tIKoyC8kNbzc9xK0iTQgYx+3Ni2uGFcmCFCZiQNlzS5LI/9cahgwhSjyf7Al0f7WCJl90VwlnexME0VXd9ScbSCIBFwjJNT8YkifYtopfOYj2Zhs0AIuquTa9MGEJ3aaLQ1JcsRc+KB04OaO8YmBP8rhmfhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708711205; c=relaxed/simple;
	bh=JTIBShtgIr5g6rY0xtefZuQDFwfDgZS/8epM2acW8kM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W9vu6UipD9sasHWzd34yoERsy+NFk3drA0Rz4Pala34wbY9gRbJjaTr/jn9CCtOQqsTVLNqj1iJ0tYp92ibjrq+BzztIyAUjcFKmhP2yUlLq1mZZiOD6V61KnBJpt3ZpX75LSldUzyIEDqU89njBh7Rb+96TyXc+ehtnMcmj/EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pFluGmR7; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pFluGmR7"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-608a5b42559so20919457b3.2
        for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 10:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708711203; x=1709316003; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZlW1EJxs94ddQvEpIRIB6nMElLk51bT9baoyhTLzcw=;
        b=pFluGmR7SsHtbb8B9H2ij1GZMdWKioVFUrTfc2CCSM8Rbea7XpXDFhG8ek/u+4G5/+
         FDvRx5E9XFH7EDdUwbtYbUynOQxacO8FmCFu3AlaYQg3N+IT1bE/Dnt2+7vTsK+5AkcA
         eAKWX3bmFh/RP29nft9cCOKbqDLLm0aKE2W18Zya5vZmN0J8v1IyVx5q05GeHpair+vj
         i+HbV+Vo94RCIyu6vFRP2A02tezQ7nHfTGHh6UkyPYtZgMoyqnzf/ZJB2JBev9vpOF1D
         yHItVDhgr3w98IjciHJxTTTs4pRlLluM/3gTH9TA3/nK7vNHRNUr3bh3qtd67YLIA7Rh
         SHiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708711203; x=1709316003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZlW1EJxs94ddQvEpIRIB6nMElLk51bT9baoyhTLzcw=;
        b=O8KnrJ47l19S503+ke5o/1mO2OixIosFxcRJdC/9K4aBQyQIu9/n9UOoeEXJVVjyIa
         sKGF2KS4oZOP1WqTHKK4jycqf8YVTpXJQNPtWnsAEiWW37Jl6BZuxkKi+j6Pws1m7Ti2
         lE4fTu8qQ4kq/TS87fuzvlqTXaHu6izewW2mHIMlDWrS6KFEHg36rm3mzBZ7wGrxzXdN
         QK0CP2v8UYLB1de8jEm6NyiZ6gAG1+3HvsmPaIeH0O6F4FJd5GtCpGKkncTuK4J7LeSP
         pVuExf+2eeqbhn4pEZXFr+n9uMIBS40AFCST9Maql4iGevkEyZFZchHuiNtkihZk1pkE
         vScQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOLy8AnZNcm5kIeg3pDRXoGSr0SGOg73x6MFFZVNAarGhoLVqLCh3OZCVmbBEXiyzGSJyvGk9AqZ+9p3u9q06DOZgH5TdJ
X-Gm-Message-State: AOJu0YxSOIhg/NEPpim25hufba90cjACr+T1E53N5/JdO1mBambSRBV4
	WTOu2x/wDQkz1W6xTkIjEGFQ3VRmV56vPDbZEM7A3EBlaQVPKaARF85oQY5oGF0rbQgrnfxOM3m
	fzA==
X-Google-Smtp-Source: AGHT+IFddBZPJ0oMQJFmcgncflFQLIynO52TmQ0RXS5kF1rPgpXbVxpnqSicc8D4/kWxpa1H1Uj3I4Yk7aw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c2:b0:dcc:9f24:692b with SMTP id
 w2-20020a05690210c200b00dcc9f24692bmr24709ybu.13.1708711203125; Fri, 23 Feb
 2024 10:00:03 -0800 (PST)
Date: Fri, 23 Feb 2024 10:00:01 -0800
In-Reply-To: <5580a562-b6ac-448d-a8fe-cedc32d33bab@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240221072528.2702048-1-stevensd@google.com> <20240221072528.2702048-5-stevensd@google.com>
 <5580a562-b6ac-448d-a8fe-cedc32d33bab@redhat.com>
Message-ID: <ZdjdIYNEA7k2Fmnu@google.com>
Subject: Re: [PATCH v10 4/8] KVM: mmu: Improve handling of non-refcounted pfns
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Stevens <stevensd@chromium.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> On 2/21/24 08:25, David Stevens wrote:
> > +	} else if (!kfp->refcounted_page &&
> > +		   !kfp->guarded_by_mmu_notifier &&
> > +		   !allow_unsafe_mappings) {
> > +		r = -EFAULT;
> 
> Why is allow_unsafe_mappings desirable at all?

It's for use cases where memory is hidden from the kernel and managed by userspace,
e.g. where AWS uses /dev/mem (I think) to map guest memory.  From a kernel
perspective, that is unsafe because KVM won't do the right thing if userspace
unmaps memory while it is exposed to L2 via a pfn in vmcs02.

I suggested allow_unsafe_mappings as a way to make upstream KVM safe by default,
without completely breaking support for AWS and friends.
