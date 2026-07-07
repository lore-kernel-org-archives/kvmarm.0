Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4811F43784E
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783444364; cv=none; b=rcbEgTpjXvrHNDkWJSumXVgCwngjFTtJy6XTYNDVcdotyKQxgausfk576CwiFOWOcQ5stFy90xTSPahL+fGXpIU15SKVa5kBjYn1WJLVuMAd2OAQWj8njbkJM7ZV2FCnIzuFh2Q2tw1RcgkXuO0uSW7ewUAU8SH09dkJJF4th+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783444364; c=relaxed/simple;
	bh=FFjXvxdIEmW78NOb7O4ot75fXMGl848EVDxXEcHT2kM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ogNL3CWre4G1YdjB1bx93nj2JCQEk58P1qJ5njeF/E6DxpjitG3GZ9YSmog++2WA+fmbhZW3qEDfc9jd0AIGByMEuLZjvm1vKx/jOgM0vLkqzpJM7cIwu7OEiTB1uRUYJOkNlTK31v0iJntwkyrG8BIaw2oB8xKAZP46x0a9kNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tIm726sr; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tIm726sr"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c892143db7fso3916818a12.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Jul 2026 10:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783444363; x=1784049163; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mjL5lkh4mRywMsy9wb/JKlBVu6SpNdiAeQ5oUXhs6l4=;
        b=tIm726srCBhFit6IFKWt129Ue+j6++9hWWdO6gQCemnD2et94VuHww855l5M/Z3CQl
         9VkcNdK+JLI5fv3ofvG/tKAad/VviwKU8dwWaq/63Snx3dMghoMIktiJmDNKmdqMGY3y
         xqNC57qPfENzarWb4+wbTaDMWjYPkYlLJJ9R7FhBwuI1fRMIrJszPJFNuoDyVBFfjfCG
         XJEhDxgCcQTXwSAS+hUkxN3MZC4IuJjimlU97jldytFDYOApgG2viyqckv+0jzpI0odB
         i1zcgD7/gAPUTVgd/ClWuwvo+OXb79mBGXi5bWplCbi74H7V7NSlWmD8F77craTjOx2A
         8Idw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783444363; x=1784049163;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mjL5lkh4mRywMsy9wb/JKlBVu6SpNdiAeQ5oUXhs6l4=;
        b=lZd77ZDI9fdyooP17Zgac12AkHvT23XEsQ/9m0/Gbad4NyjMMYfEjtOUluJ3Hulycm
         4EMIZReMQtx/DOwAFDaoKoShV16pgBXcbJAOm4Lg9waBbdQjZ9PppJXoruQ8uKkGfziJ
         T9p3ffzVFASkaIt0D05IHeaPbFtYEsIsLd5zdMqjwUbvKeCDBDRtBp3poO4sqRc9nUvz
         o0hwkolAX33eyX+1kztUNEtF0yb4Z1n4tUpWPl9759Jwd/LkjvVXMekWWWnuOsxjQnB+
         KID+CG0pCYh2Qdiuim6GdeJwOTVxsHjRpwbfPmWPnbSoFboCXkHeJ7uBQmqJXmUiz2Ix
         IqLQ==
X-Forwarded-Encrypted: i=1; AHgh+RqBpyCdf4mJdXDGMZGDcIeA7ZVlhJeUvxnwpyetz54FmTEcE2jaNnRZtXDDkJe+AQiuSqqp5nw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/lB0IIl+4tUZPjcEUGTt4MGzjMgpphAGW6qEALre98+w+wRoa
	qnfoHnpqpthv/H9aGV01w6Rn05B0gxGrbFLZmbBAwfsDvpErbGmcHlK9OPB67HBt+IPMibfjuMO
	YjiIiKA==
X-Received: from plrs4.prod.google.com ([2002:a17:902:b184:b0:2cc:6ddb:debc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e74a:b0:2bf:7b62:a038
 with SMTP id d9443c01a7336-2ccbe616766mr60096485ad.9.1783444362422; Tue, 07
 Jul 2026 10:12:42 -0700 (PDT)
Date: Tue, 7 Jul 2026 10:12:41 -0700
In-Reply-To: <ak0wSQ1133O7B96D@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com> <ak0wSQ1133O7B96D@raptor>
Message-ID: <ak0ziUcCXUlDdcla@google.com>
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, david.hildenbrand@arm.com, 
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	fuad.tabba@linux.dev, mark.rutland@arm.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 07, 2026, Alexandru Elisei wrote:
> Hi Sean,
> 
> On Mon, Jul 06, 2026 at 05:56:12PM -0700, Sean Christopherson wrote:
> > On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> > > The memory represented by guest_memfd-only memslots
> > > (kvm_memslot_is_gmem_only() is true) is shared with userspace, which can
> > > freely mmap it and access it. The only thing that is preventing dirty page
> > > logging for such memslots is that KVM doesn't allow slots backed by
> > > guest_memfd to have their flags changed; they can only be created and
> > > deleted.
> > 
> > Please (publicly) document *why*  you want to add dirty-logging support.  It's
> > all but impossible to review new uAPI without knowing the use case.
> 
> Of course, my mistake, I was so deep in this that I didn't realise that
> there might be different perspectives.
> 
> My thinking was that since guest_memfd created with GUEST_MEMFD_FLAG_MMAP +
> GUEST_MEMFD_FLAG_INIT_SHARED is extremely similar from a userspace point of
> view to using an anonymous file (created with memfd_create()), that
> supporting dirty page logging and migration would be a natural next step
> and would expand the usefulness of guest_memfd. It has nothing to do with
> confidential compute.

Sure, but just because userspace usage *might* be extremely similar, doesn't mean
the logic is technically solid.  There is simply no requirement that guest_memfd
be mmap()-able.  And that's the one of the main selling points of guest_memfd:
the memory doesn't need to be mapped into userspace in order to map it into the
guest.

> As to why I'm working on it now, it's because of an arm64 feature that
> requires that memory remains mapped at stage 2, called Statistical
> Profiling Extension (SPE), similar to Intel's PEBS or AMD's IBS. Exposing
> the feature to a guest requires that memory remains mapped at stage 2
> outside of userspace explicitely unmapping it, and guest_memfd, with the
> patch to ignore the MMU notifiers [1], has this property.  I wanted to
> expand the functionality of guest_memfd to support migration of virtual
> machines when that arm64 feature is exposed to guests.

I'm all for adding dirty logging support for guest_memfd, but for SPE I don't
think relying on guest_memfd always being mapped is a good idea.  guest_memfd
is "pinned" purely because adding support for page migration is (very) low
priority for SNP, TDX, and pKVM.  guest_memfd page migration might play nice
with SPE?  Probably depends on whether KVM is forced to do break-before-make?

And at some point guest_memfd may support userspace-driven swap, but I suppose
we can cross that bridge when we come to it.

From a uABI perspective, forcing userspace to use guest_memfd to get access to
something like SPE isn't ideal.  While I have aspirations of using guest_memfd
much more broadly, I don't know that banking on guest_memfd replacing "everything"
is a winning strategy.
