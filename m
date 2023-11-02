Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DE4200D4
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 19:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pcEz0Tby"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3b3f55e1bbbso814464b6e.2
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 12:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698952518; x=1699557318; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zQjgybZFTlPKj/UiWrViWEzaYunnF8hFWA7g6W/61+Q=;
        b=pcEz0TbyAvF6s6QiV4YLL1bANhVzWPG2Ch22apJEcGQlKQkAc0WlCbq5G+lNrciYqh
         x5Ump6xWXF/kw6b+tgw+weGMo7SgrF5VSVIOQLbZhvHHvHlTpgDBYU7EmRi3ukx7CE/W
         FzDkL7vFr5tJOv3SYvyzgLgO5VASOEi9lBMj+WXslid4uTns5jF1MHFU1ZOPgoKA9oUa
         z+pjQFWk5NOF5QDJ1u/hZJbDO+5UhbW/e5Pw88rv5+90mHqQ2aTYa1IhxZyLjCpVlykl
         hTE/5H/WdXhoh94NYE0ljo1D2K0yXnnQzf/Cu1JR0xZ3oM8z6ndEQETHAgWvjfihYQb7
         XUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698952518; x=1699557318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zQjgybZFTlPKj/UiWrViWEzaYunnF8hFWA7g6W/61+Q=;
        b=eiDmMAmWVrmN0qSBwspjDpcvA84qil9RFK7GkjaHxrU7PAA3QEobg1npPHmHbgNbyw
         4nA38Jmnf6GLKIbKkOEQAGFfcxqaTi7cjkVJEMXQr2lhgZPD6znjMYHkRqIy3Iyrnczd
         RQ+tur1U8BFcxncHYAOd/NKo9G9ID1lt2gpMOPUPfYrUTgIxbQEXEhSMP1DV3iX+8c8D
         pD1QD7ihGXG0gR03PjgOFMS51H0fh5bQVzHACJdHlbJ3pDX9amme5wxDDFv1FqRz8DVu
         Xp6EvQ4v0m8oQ21Dvgsno1kW+9/X4KGuKzh7Pt5OQvwPXNZOFCuU12tUR66fOz8EeD8W
         Rq0w==
X-Gm-Message-State: AOJu0YxhQ4cIDMsEn8Pn1h52Fsk0iu7XTy/jpmV2mNjLKaDzOsyQO5pv
	va16mJVzZn02jewT9RnwKGxn0y9NIIDbuLtCS+/pOg==
X-Google-Smtp-Source: AGHT+IGdp46tnQ41glidviv3jlI3EmK1KPcYKTU7WJay+sA87MaG0B2sVQ3c1NQw2onVdre5QSNu/aGCQozfSBDS8iE=
X-Received: by 2002:a05:6808:f15:b0:3a3:b39d:a8bf with SMTP id
 m21-20020a0568080f1500b003a3b39da8bfmr23023527oiw.45.1698952518287; Thu, 02
 Nov 2023 12:15:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
In-Reply-To: <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 2 Nov 2023 12:14:42 -0700
Message-ID: <CAF7b7mpzkjvBTybbaEUSp7iL3dVURVi+rDtkkojOcXAY=Bk9=g@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

I'm going to squash this into patch 9: the fact that it's separated is
a holdover from when the memslot flag check lived in arch-specific
code.

Proposed commit message for the squashed commit

> KVM: Add KVM_CAP_EXIT_ON_MISSING which forbids page faults in stage-2 fault handlers

> Faulting in pages via the stage-2 fault handlers can be undesirable in
> the context of userfaultfd-based postcopy: contention for userfaultfd's
> internal wait queues can cause significant slowness when delivering
> faults to userspace. A performant alternative is to allow the stage-2
> fault handlers to, where they would currently page-fault on the
> userspace mappings, exit from KVM_RUN and deliver relevant information
> to userspace via KVM_CAP_MEMORY_FAULT_INFO. This approach avoids
> contention-related issues.

> Add, and mostly implement, a capability through which userspace can
> indicate to KVM (through the new KVM_MEM_EXIT_ON_MISSING memslot flag)
> that it should not fault in pages from the stage-2 fault handlers.

> The basic implementation strategy is to check the memslot flag from
> within __gfn_to_pfn_memslot() and override the "atomic" parameter
> accordingly. Some callers (such as kvm_vcpu_map()) must be able to opt
> out of this behavior, and do so by passing the new can_exit_on_missing
> parameter as false.

> No functional change intended: nothing sets KVM_MEM_EXIT_ON_MISSING.

One comment/question though- as I have the (sqaushed) patches/new
commit message written, I think it could mislead readers into thinking
that callers that pass can_exit_on_missing=false to
__gfn_to_pfn_memslot() *must* do so. But at least some of these cases,
such as the ones in the powerpc mmu, I think we're just punting on.

I see a few options here

1. Make all callers pass can_exit_on_missing=false, and leave the
=true update to the x86/arm64 specific "enable/annotate
KVM_EXIT_ON_MISSING" commits [my preference]

2. Make the powerpc callers pass can_exit_on_missing=true as well,
even though we're not adding KVM_CAP_EXIT_ON_MISSING for them

3. Add a disclaimer in the commit message that some cases where
can_exit_on_missing=false could become =true in the future

4. Things are fine as-is and I'm making a mountain out of a molehill

Any thoughts?
