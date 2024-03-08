Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF7B225D9
	for <kvmarm@lists.linux.dev>; Fri,  8 Mar 2024 22:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709935637; cv=none; b=rkHJQnqTqANEe4KXy5JwIYs+DYUQ8ofVuwvBz2hmrAyIlDM46kd8G4RxnPbuQSL6KHDd5F1zBzJCPbM9MnUK3KwbcWv4pT3MjDKW8vGfOJr+lPLqzp7JdvyZrhJ4mT37qpllLDg3dFtK2CUx8HWx2/9xohOiCdJSailq1W231tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709935637; c=relaxed/simple;
	bh=/VWEFaB91VYuq/7FP3hbWaFOlEC3Se8rWQyqpo8SkjQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bo9poo4pACvgy4moYqn5vkuyJp6GMScS/MX+2nW5Yfz7gYqEITxiIFmRjv4DhKeyK0qC1STzQGl/E0FurNWlyu0DG21IZA3i29m2apLshDDQaODR89na9PsN9ZzfTvo2e3McTLV355zYFUhiSuf9k5KWdrn2duZwhIzMwkv7aEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c1W5GzMk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c1W5GzMk"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-29b3a63c589so2199042a91.3
        for <kvmarm@lists.linux.dev>; Fri, 08 Mar 2024 14:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709935635; x=1710540435; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AL4ZgvwyGuJh/ix6P2kmz5yj0R+a2NL9R/hhgMUybJw=;
        b=c1W5GzMkSAqUwcxoYcDyTgoSIpBxhJRjrhfoHfIrIZwpqcKw9Ukua8rB13evgXwspB
         k787dmlnUWoxV4WUrTrVVao2hBZxChAaHaNtK0LE1NiTFrsN7/5HgWwc0o/W0kI3cmCP
         aVFM5e3Eio0Nsg5jyl1Sw7uhdqpz8apd7b9sMjjw8Davcj3nWggU7iSOJ6cwhXzJVGtS
         xjJteqJlB794BehLmBF2jnkcnZKLa/tF2K92VGyFyxrwmuz2ItYsdZ3oQHsAw9qFXY0P
         Y5GzM1hnnTuHr9XCrES37KEUfLBTFb7rC1D34BOAtqCcUce6qHACwTQpqKcF5knZOeqR
         Gk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709935635; x=1710540435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AL4ZgvwyGuJh/ix6P2kmz5yj0R+a2NL9R/hhgMUybJw=;
        b=aEC7eCwVS+638lZPLw33ny7h6vl4D/GtRZrQIFft/OxcRzgo1hITUL3lQUfQJpOMiL
         33mDpIxoVq68VYcwEfH5+ES4yErR/hLjiEiYME4pNx2mYOM3IbvETboLWi+f/RmBaEgg
         y54zX3XmPM8WpdiwVW3BqfM9yy3YcbIJjv8u1kaIhZiWYSL3mwkFrF1/KrVr68i07GvW
         3LPATUFvFkZPvRxBKVd8BQ79akI1cEuREvSP2xISeaTdBqdYwEVnlLKVROcYduRRahgX
         xsXXPO09CUXJzXPQbe6de171Byiv7+Tdg8fh+XawkTwAb7SL3u7FP9feFkn34LpjnEBO
         TCJg==
X-Forwarded-Encrypted: i=1; AJvYcCXjZz3eS3BoOMi/HpvQYsgJU2D5OUYp+K8/z/RHQRgpp+O045bJG/QAJ0wJ1HY2jGRoSLN6Opt5SSXwV5i3bRv8IT6ItOvK
X-Gm-Message-State: AOJu0YyCwvH8M/tTybBEccAPEertvaYYmdpiHZqeWJheOri4hqldXLcv
	IQ3vQjVW2PxyIs9Ksxin9Q3U+c6pGX1N4SeRWnN9UrDViX+dlsiSZPmVJAyM0mmDlOYwVYpMy0Q
	+Uw==
X-Google-Smtp-Source: AGHT+IFpb3dLKOMGT5haa9ES8rvCErnpQz1aA1UcmD01kGlHWr03OeYxf+VGbagktBOC6J1UCTh2s0w09TU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a92:b0:29b:c1c8:8f19 with SMTP id
 lp18-20020a17090b4a9200b0029bc1c88f19mr1873pjb.6.1709935635098; Fri, 08 Mar
 2024 14:07:15 -0800 (PST)
Date: Fri, 8 Mar 2024 14:07:13 -0800
In-Reply-To: <20240215235405.368539-7-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-7-amoorthy@google.com>
Message-ID: <ZeuMEdQTFADDSFkX@google.com>
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Anish Moorthy wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9f5d45c49e36..bf7bc21d56ac 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1353,6 +1353,7 @@ yet and must be cleared on entry.
>    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>    #define KVM_MEM_READONLY	(1UL << 1)
>    #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
> +  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)

David M.,

Before this gets queued anywhere, a few questions related to the generic KVM
userfault stuff you're working on:

  1. Do you anticipate reusing KVM_MEM_EXIT_ON_MISSING to communicate that a vCPU
     should exit to userspace, even for guest_memfd?  Or are you envisioning the
     "data invalid" gfn attribute as being a superset?

     We danced very close to this topic in the PUCK call, but I don't _think_ we
     ever explicitly talked about whether or not KVM_MEM_EXIT_ON_MISSING would
     effectively be obsoleted by a KVM_SET_MEMORY_ATTRIBUTES-based "invalid data"
     flag.

     I was originally thinking that KVM_MEM_EXIT_ON_MISSING would be re-used,
     but after re-watching parts of the PUCK recording, e.g. about decoupling
     KVM from userspace page tables, I suspect past me was wrong.

  2. What is your best guess as to when KVM userfault patches will be available,
     even if only in RFC form?

The reason I ask is because Oliver pointed out (off-list) that (a) Google is the
primary user for KVM_MEM_EXIT_ON_MISSING, possibly the _only_ user for the
forseeable future, and (b) if Google moves on to KVM userfault before ever
ingesting KVM_MEM_EXIT_ON_MISSING from upstream, then we'll have effectively
added dead code to KVM's eternal ABI.
