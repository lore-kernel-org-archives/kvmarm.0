Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC733112DA
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 13:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786454828; cv=none; b=TGP5GB+Nd+dObNTldxEdpMN4AYGM1HfYZSvV784QWmUjHhTP/XUAtW4t+VZHdh2ZB8f+2VDQJS0hYgjKKjIz14jV9hWnoUeJ1zDRi0ItSPjxea9d6SBtPdRK2AAK9kSYeYBTmotrq3xDTPrguHDlXRWF6zWltNzuo8+cuqEAgZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786454828; c=relaxed/simple;
	bh=HSS2ol7a0YjbjSr7IwadkoiUtq++DDqP02Tw9wqOwC4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l+r+4tzWsoenxUCK824SlYTNiiDMmXrlM4QqyTFLaoP5DFzYEV47fz8UreUHrvz1JflYAQz631aZiCMm7GiM4ZmcoGt9nCE+ftZomNogyRqLeCcpllMy5tIilF9S+XjjKV5yJA9yih2mGrMDN4ansPNM/07IY3WDYJr1LUoREBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RTMlKL9H; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RTMlKL9H"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a1188c8948so2962187a12.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 06:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786454825; x=1787059625; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VHer5Euf93guPyEW5SSggQ6xE9fM7y8lLNbmZzisUY0=;
        b=RTMlKL9HIaz4rcxLR4g/zUxMv/UboeEAhZCkvonrdqwdYiPMxUKE/Hv1uO9gGirqPA
         M5DiCcTU7XAyC3AnW7UOXypPF5hsNK540tqM3pVYer0sRcJh0NWIJ6j6ytB3AlXf4r95
         EdWg/tZzVnyr3JG1rFbKKEpvCMdJYHk4Ep8pcoXGA7f09Nj19lQvGuH4FfWPgj9icRfD
         A8D5ATx9XW0BigFZwUcmPQ8xEpZnrtcPc25KmUkEoLYWQTmIzjpCCHnrqeVKPeGXcTNh
         j/9xGgQwQPQmJ5K2yA6wD+6g7MRTn75ULfMhV0l0scwvSIV8yWZLGFbC8mQOXjLH+VTN
         vHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786454825; x=1787059625;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VHer5Euf93guPyEW5SSggQ6xE9fM7y8lLNbmZzisUY0=;
        b=BsAxRLmqGIyCgvVVTe5te7ET3JcJlDOw4FBJzhQ1mx5+lQXo6KGYGIrHkIwDuzrzwE
         ZjOl4gO8FDR/ZKHJZiI1Qz5feO7iQE2PBr3wRZ2JB8mf6IwhVEiaueo8HQJ1L3MnUgky
         SdeM30PbEqwMnv2u024VoVvdA1PkK7c/94vVgeRg5QnKfJA2NIDWOzeWoDtv5XEDFGgi
         o3JIbUL6ArtrDbuFHkzanLDtN5DZ5xaXFYGiGUOu7XK7i2bpCU3gy16ZgCiySQ6TM+7P
         9SZor89R3/K9GE7GLiHlyB5ubwwLdewIA80iBNsfCujTKeUGpNbDNApD5VMR/SCH4IGs
         pKOQ==
X-Forwarded-Encrypted: i=1; AHgh+RqfUMZgfMxfq2fe3MqnZSuC3aGCpH26BL3lJ9vRDKvRq9+92LaK8B9VNlO6abyGQzGhLzkTWrs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxpvAKUU32TPMKYlZJXSGG3Xy24SabLKiKyF2Lj5MruwR2uFiX
	TGZhPBPQNJKuH+8gQSEswR4cZI3O0Ooz+Y36S26wYnnyYvkVZ/co/AOtQR4ZakMqKczSsw6yr7r
	bypr/Qu4hjX4SqdMjjw==
X-Received: from edsu13.prod.google.com ([2002:aa7:d98d:0:b0:69c:835e:2527])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:210f:b0:6a1:b23d:e962 with SMTP id 4fb4d7f45d1cf-6a36c32a68emr218706a12.8.1786454825019;
 Tue, 11 Aug 2026 06:27:05 -0700 (PDT)
Date: Tue, 11 Aug 2026 13:27:04 +0000
In-Reply-To: <anpZMemVz5yC_WLo@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-3-tarunsahu@google.com> <anpZMemVz5yC_WLo@google.com>
Message-ID: <9huzo6f8zt1z.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 02/11] KVM: Introduce kvm_create_vm_file() helper
From: tarunsahu@google.com
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jul 28, 2026, Tarun Sahu wrote:
>> - Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
>> - Introduce kvm_create_vm_file() to wrap kvm_create_vm() and
>>   anon_inode_getfile(), providing a unified VM file creation API.
>
> As Ackerley pointed out, changelogs that are literally a list pretty much always
> needs to be split.
>
> These also need to explain *why*.  "providing a unified VM file creation API"
> isn't sufficient justification.  In general, all of these changelogs need to
> provide more of the "why"; I can figure out what the patches are doing easily
> enough, but in my speed read of the series, it's hard to figure out the "why".

Okay, Will update them.
