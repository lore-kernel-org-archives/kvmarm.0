Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724CD627
	for <kvmarm@lists.linux.dev>; Sat,  9 Mar 2024 00:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709945198; cv=none; b=K0J6rUajjM1mP0UhMrJY8JGeSPZz7VNVJEcJ1vtvzvURq9UHradhVJQZ6IQS5SGCSi9X+LBJ2HhkNLuWE8tUnODFC+YEfyLT0QWKc2vBTJAxYGFPBVnvjhiTaJ3i6lIWS3wzISVcDWAzAsDscyx+4QHo9xCegTOu+86rrvFmO5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709945198; c=relaxed/simple;
	bh=XnwCQlYciyf3IeX6pM24no5SoUvOGXQU0xT5IaEgZB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfDoV1fJ78voxJ8nBiOZ8yAKU7eUfqXrSUXw8t3SFKFLd5frF+jIo8/6rAOf78KuoFzG0VeZaX/58UjMdqQyBsHQ9PzH3nsG94mcEQZysT6QaVRDZwWhsODcIoiaV4uMhKNgz7zxLGeuJYWL3Pz/2AUdjacB/lFWdKuPOj+MCbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a0ZRnmg9; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a0ZRnmg9"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e64647af39so2579163b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 08 Mar 2024 16:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709945197; x=1710549997; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wagJ5bb0RSx3p5Ow1rY4xtUtbXLWil/+U/7AEuF2y7s=;
        b=a0ZRnmg9lF05grZ89w87vjiJp3U80ROWBoCGQSNF0itECNjmHz8h0Qw8ecPxS/7AAw
         W1/5a3rpm97VfFqkLd4hjfY7ZVtITjBnKHnns0ePAfL4wMaMVqzFOqsa2+oQ/Z8VssqU
         AWTpN6dQml45Cs7ExbboOuOwcEnmOSNsxUVI3FQmUHD6jqEOZkNHgG8vrDys2qkPaLV4
         yFh7IQlj7HSPViXnCU6rOA1j/U2GO4VGkwQj4frVSh8ltbOUfwKdjNP47J4FHmY7DJAL
         IinNihUIAGcSB8t/PTEsh1rXv7jYwUtyMCzwkwK+HCbP6/KEb/75JECagWJ9TU9bY5wH
         iM0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709945197; x=1710549997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wagJ5bb0RSx3p5Ow1rY4xtUtbXLWil/+U/7AEuF2y7s=;
        b=Mpfk1Q79Qxq+OhIfV+0mEAq/RPEJTlGGPKx+k5bdPfbXNfCjkSNHS0sc3B/mSo7/2e
         pzGRJVof90PyDnTPWl02JJGgVb5XjRUl58XEhGoV5ITSDKuHEfkBy19bs28mW0qlb0WE
         UMHX26v/nroaxI9nTIY4pEdcSV4t0kk+3k9KkptkHvvKVnKfyPByZF/hQSwyxqXPUlTZ
         t2t6Q7SmRMQ/Boc7N9YV1ND3imMUEn4FT8EIH+8C6aOcsey+m9yWTYXtFdvvM48Vn7/Z
         gYgdkK0YpQ7uxOSclTqS38Eqm78vtugm18ktSDsEIdXJhuXIqThMcckdygfHnmehigY6
         kJ7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWjJG3Yb3T4ZLY6lRWrklA81GsB8Vd8u859g2F1+LRsVBoYe9+QcIUVjTModwedAXywBfzGSokWccOX84skOuq1cvCDxL0G
X-Gm-Message-State: AOJu0YwV8usfrAhzsGg6gbo6sqUf+U8J3YZcpT6wEX9OC+zEu6j7WXc5
	b8dDyA5nzAIdrWRQ9Rxiqxc4++ptYS06TlPZCa0FciabJkdcod5vZPlOGzdZkw==
X-Google-Smtp-Source: AGHT+IHM1VN1Fjzl6sZbFiIRHPQ/sssnHDssRMi7SSnmYWHqJ9Z3fUPXXzQY3JbPdG92rjZEFQOAuw==
X-Received: by 2002:a05:6a00:1406:b0:6e6:4fb1:6e97 with SMTP id l6-20020a056a00140600b006e64fb16e97mr659530pfu.10.1709945196546;
        Fri, 08 Mar 2024 16:46:36 -0800 (PST)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id y25-20020a62b519000000b006e65d676d3dsm293234pfe.18.2024.03.08.16.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 16:46:35 -0800 (PST)
Date: Fri, 8 Mar 2024 16:46:32 -0800
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev,
	maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	robert.hoo.linux@gmail.com, jthoughton@google.com,
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
Message-ID: <ZeuxaHlZzI4qnnFq@google.com>
References: <20240215235405.368539-1-amoorthy@google.com>
 <20240215235405.368539-7-amoorthy@google.com>
 <ZeuMEdQTFADDSFkX@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeuMEdQTFADDSFkX@google.com>

On 2024-03-08 02:07 PM, Sean Christopherson wrote:
> On Thu, Feb 15, 2024, Anish Moorthy wrote:
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 9f5d45c49e36..bf7bc21d56ac 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -1353,6 +1353,7 @@ yet and must be cleared on entry.
> >    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
> >    #define KVM_MEM_READONLY	(1UL << 1)
> >    #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
> > +  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
> 
> David M.,
> 
> Before this gets queued anywhere, a few questions related to the generic KVM
> userfault stuff you're working on:
> 
>   1. Do you anticipate reusing KVM_MEM_EXIT_ON_MISSING to communicate that a vCPU
>      should exit to userspace, even for guest_memfd?  Or are you envisioning the
>      "data invalid" gfn attribute as being a superset?
> 
>      We danced very close to this topic in the PUCK call, but I don't _think_ we
>      ever explicitly talked about whether or not KVM_MEM_EXIT_ON_MISSING would
>      effectively be obsoleted by a KVM_SET_MEMORY_ATTRIBUTES-based "invalid data"
>      flag.
> 
>      I was originally thinking that KVM_MEM_EXIT_ON_MISSING would be re-used,
>      but after re-watching parts of the PUCK recording, e.g. about decoupling
>      KVM from userspace page tables, I suspect past me was wrong.

No I don't anticipate reusing KVM_MEM_EXIT_ON_MISSING.

The plan is to introduce a new gfn attribute and exit to userspace based
on that. I do forsee having an on/off switch for the new attribute, but
it wouldn't make sense to reuse KVM_MEM_EXIT_ON_MISSING for that.

> 
>   2. What is your best guess as to when KVM userfault patches will be available,
>      even if only in RFC form?

We're aiming for the end of April for RFC with KVM/ARM support.

> 
> The reason I ask is because Oliver pointed out (off-list) that (a) Google is the
> primary user for KVM_MEM_EXIT_ON_MISSING, possibly the _only_ user for the
> forseeable future, and (b) if Google moves on to KVM userfault before ever
> ingesting KVM_MEM_EXIT_ON_MISSING from upstream, then we'll have effectively
> added dead code to KVM's eternal ABI.
