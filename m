Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E5838F22D
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 23:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782258106; cv=pass; b=kKfG34To5OWyTXtpI2wiCjydscY1CYaGGRT0QQAjZI+Qx9SYzmtRztEnt1I/HPbyQ6DhzSSNe6PK55+lH6CIxWA2QzTqThnMk0ojNus4yFA2OGeiLEXlhbr5oxi1wDbvlXh7C0JxC5nbOHvzgK2cGhx/bI+7lMBayPvQgzlpnOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782258106; c=relaxed/simple;
	bh=0o2TLZAQfupxDW1DGh5utshxlDAHM+yJodjjXz1Q8ok=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h2Z0oJLuG7n7bZxWPIQFyrZ/XbIvJJWxdizOfA8rvnLp46ao6/GFc2gNLgLMiWWd8Se5y1d9VmCyLlMZr1SM9XYJQm/Q0EPDY/4GxdIqmKhUPpmKZbA2CekzNcMAWAsVO9GORgBDaWncE0f8mK/c+AqpTZ3oMJRB8dMui+XkH/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AOy4JPiG; arc=pass smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AOy4JPiG"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-30bc806fcf8so456978eec.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 16:41:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782258104; cv=none;
        d=google.com; s=arc-20240605;
        b=K5/LmylgwXmX6OZw7qijzvYe/wE2ZP5RTpEQK4OLMaC3dScZOF05mEwdpFXtlPudtY
         kuJo+n7s9eHq4GzFf9os5L7AV++u8/VPGlNUsrXrc+elfn8+FUqNeLbbzzlVQiaefuWm
         /CG1qzqLMST9y+UOl7RcWcCEReGgqdwOYbc0cuxhO1NlF9rgE2tK2Eup3uUTUlHBIefd
         NP7C0LBqIHBkhbsqVlouRUF78nwObxO2z3y9SRRV8Y3IXPswerGt4De4dF+cAsb4ffzb
         N7JAGm1GKmwnnCNP/Iz1vHi922zTOtMWB9B+Vayy8Ta6+v+tUQXoGmhNmcePRqBLldcm
         cVkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=5R4jJVdiiD97J3GTz0Op+QXJSLTSXOE5UM4tQq8YjrM=;
        fh=9gUdO8y/uSRxJmxrQpwjTs+4qWKUU7MReyXmuBQ/TgQ=;
        b=daxgqbAKxKrS+4o5FwKFMpS+qcvITcsEBXc25wHAB7SkFkPzAPHNxAw5OzPf5R4B4z
         uxHWXup3u9u7bheFuHn0T6ut5WbfVAh55fiGZgVoTWNMPvlwi6boYd1+AvhegQbAv0Hw
         KGz6enhoX8VGlp4OCYEmH7JeejYxrzozAxDX4NFAboyqmmSnmSrhOY6S1toJocQM7qAp
         TBR50O/98a0MPLV3wF/Z6BG2uv3tJOI1d5cN6UvZWdQiUaLNZsZJ/sPh7XDlT9rkagzn
         HiAhks44qoP9vSfkvhCBvq9apsD/aPbeuQqbrBb/GJp3yu7vcjF1dNJ0byAKX/rndrfG
         IZ7g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782258104; x=1782862904; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5R4jJVdiiD97J3GTz0Op+QXJSLTSXOE5UM4tQq8YjrM=;
        b=AOy4JPiGi+007uQckfOE6MJaayYLXOzU0R9skIh5Rqo225+bNZnCDvJA6+DN737LMT
         PkA13AZuON60W5vi+p9JeOScBpQKKlWjQ78bFtQunR20jxJ5r2JJObs67PcOXPbU4h39
         qWwjtarCVZrEy+QGBcPAiPpAzMlb0RFSXokGYTyEY3KLJgCZa8Hegb8VS5xHONCliYl2
         6ID6vnHvQaE0fpwqR82hLGAEIt82dKZYDTm3PA3DoZDuaNSTSbQQA2U6/bNr7cS9UfT2
         p7IF9/g5kYPv+7zu0Hna0cKreenEHO3tXd8zckU+dgyXH0irk3h16PnDarWmVQUNxenU
         y5ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782258104; x=1782862904;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5R4jJVdiiD97J3GTz0Op+QXJSLTSXOE5UM4tQq8YjrM=;
        b=OOkRntW+fpowd/dBzafPJFkN5gBmM/A4o3hZ1pTlHhqXIRo3S0w12162LyqJoJGO7x
         MmIgVRJxdAxhCCeDdKFLuZuNWrB9miIYb3ZxSvf0I+MbfnsqvP2bAxByt7l6rVM9tV36
         lmVz8Ayxp9q+mTMWMnyQDlErVD6vO99+nVEsJoArzYuisKEDIV0ERLfL1JDrV/fQPoUy
         oxCJgh1j54cxjWiOm53gP6Do2JDBxyz2qk5q9adZK59eApHzdWEo0pLVnRKAn5igSoPv
         CWqEsTJ2zNYKhPPb036Ir/fOMzGb3q3BTt1gjie8jtRivJ694VuA0tV37XM24RTd3OyT
         PpVg==
X-Forwarded-Encrypted: i=1; AHgh+RqeNhqzKQE1zeHIVNAHfcNMpJMLcJaTb3nDPGLA78luhOzJBIkTvQgYHGPHlgW05m5va3h3nCU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiWicf1r7OVxKYxjB/fnGQzc7EQsGJqIFy0/n8R4DeppMCF9Z5
	PKaiQbz6X3Sb2paUPv2YH5RiCHCSLr6odMArhZU7LAhS3EbX2dMsm3s+OeijnDRziaKt6IWh+cH
	I52jBc4S3cfi6X3xzGijOePyMCULJudemzg/v8H3v
X-Gm-Gg: AfdE7cl6BCs9p/BR1z+BZ6okCWfJhG+FQawkXnZvq5LS3KlteKr+WkPuEcp+OnhvRDd
	0KKh0sAB4OHJcof9mwqEMcHgRBEnZQj90pkk4SmlfjN1XOqXvHXEDfqg4NDOEHihY6GpeTW5K1D
	OYGT8pDkZtA3L9WaRyYllcoB+7t6ytyzAOcNrm540fMUTc5x2F9pk8MPHNTcnCAxG6INkkRhxSt
	IuPAAIs5PgEncuq8TwSXf7MbioS6ZKQg6iTXAGVpW0cA0AydFTxsU8+WClvSxiRwJS9bK8AQzEp
	xFbcP4PYYNvQsC1DmLWcEPCIL6r8GUHa4k6s+diyVxw2LidnmhhekDfDvjM=
X-Received: by 2002:a05:7300:4314:b0:30c:41df:3734 with SMTP id
 5a478bee46e88-30c58c1760dmr5223426eec.22.1782258103394; Tue, 23 Jun 2026
 16:41:43 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 16:41:42 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 16:41:42 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ajMPvgA2eHQCj-B0@google.com>
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
 <20260615160901.9A1A61F000E9@smtp.kernel.org> <ajA6ogaNiI3KDv5i@google.com>
 <ajKcDRqT5m069PXK@raptor> <ajMPvgA2eHQCj-B0@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 23 Jun 2026 16:41:42 -0700
X-Gm-Features: AVVi8Ce0E01zo3uw2YUeY9tYq73kkPJeDmWeesJXGCOlSxxJ-xDfRo5Fdwxu5EY
Message-ID: <CAEvNRgE9cLfjDbXuR5wq3fEWZyHxYPxdExxNjXUFO1nT5m==1A@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only memslots
To: Sean Christopherson <seanjc@google.com>, Alexandru Elisei <alexandru.elisei@arm.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

>
> [...snip...]
>
>>
>> The KVM_MEMSLOT_GMEM_ONLY flag is set if the backing guest_memfd has been
>> created with GUEST_MEMFD_FLAG_MMAP. The documentation for the flag says
>> that '[..] the fault will always be consumed from guest_memfd, regardless
>> of whether it is a shared or private fault'.  As far as I can tell, this
>> means that, absent a fallocate(FALLOC_FL_PUNCH_HOLE) call, the page is
>> still in the page cache for the guest_memfd file after userspace has
>> unmapped it, so the guest will not be accessing a freed page.
>
> KVM_MEMSLOT_GMEM_ONLY is somewhat misleading, it only applies to the KVM's MMU.
> For other cases where KVM accesses guest memory, KVM still follows the host virtual
> address, e.g. so that copy_{to,from}_user() Just Works.  But userspace isn't
> strictly *required* to keep the userspace mapping coherent with guest_memfd, nor
> is userspace required to make the userspace mapping fully RWX.  And so if
> userspace modifies the VMA, KVM needs to react accordingly.
>
> When in-place conversion comes along, KVM will also rely on userspace mappings
> being torn down before allow a SHARED page to become PRIVATE (for all intents

Conversions explicitly unmaps the pages being converted from userspace
page tables, then checks for users other than guest_memfd. Unmapping
does invoke the MMU notifier stuff, but conversions doesn't rely on MMU
notifiers to unmap from stage 2 page tables, since conversions directly
calls kvm_gmem_invalidate_start().

On a shared to private conversion, if the page was mapped in stage 2
page tables, we'd have tried to unmap it twice (the second time doesn't
actually unmap, but still tells guest vCPUs trying to fault to retry.

So we're good! With this, the first unmap will notify through MMU
notifiers but actually do no unmapping. Thank you for working on this!

> and purposes, we're conceptually treating conversions as free()+re-alloc().  So
> while the page might still be in the page cache, it's effectively been "freed".
> So in that case, KVM really does need to ensure it handles mmu_notifier events
> correctly to avoid UAF.

Just making sure: "handle mmu_notifier events" here refers to
gfn_to_pfn_cache and other parts of KVM that works with memory. There's
no issue with a UAF between mmu_notifier invalidations and conversions,
right?
