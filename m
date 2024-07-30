Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE0F18DF70
	for <kvmarm@lists.linux.dev>; Tue, 30 Jul 2024 20:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722370504; cv=none; b=gBA5gYYNcemXnZ5ek1IUy1Tcb1hPMr/ycjLDlUDQMHQDHMZcXrM+y4JA9bxeHsGHFPaV4fE71huO4jOz0FoA6niL8NaSs5pjml1iIEMN5zwmH++SCyakK1qKyvScYiaIlSMusjFRCZmAGKtWEc9H/8+2Zn+VO1sMUiCyYKIaCiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722370504; c=relaxed/simple;
	bh=Xb56Rjm9GNT0X5C07vjpbr8J+7v+LjPM+oZnEZ2ZEvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tQ0bho7Q3qCFhs8vTqAEeU44veu++koYBh+RLtzPQYZL/yWwyyEUOxsvzL614BSitQ7fiHZdApUUcgmZSAy+ObWYFdUJDibEK6O5DuKkI41aU6wELowEeDngv6qVZFsaegN9AutbtWiRfJgWUUE/AyRrAbGHwhhccSxy6GXfG70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0wGCuw1p; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0wGCuw1p"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc4e03a885so38638095ad.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Jul 2024 13:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722370502; x=1722975302; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C8yo2cbMxRjf1SYFGiWaoP3WEwWP/CuFq0W0aGvMAlc=;
        b=0wGCuw1pbQXN7wWO26SSSHj3M3d46PTE6rXmKmePkT+Dqi9jPczInw+6S4J/zpDhRz
         UHQZyyo+eOFZLNMcPY5F/e3QbjYOiTisjGC1WC0RIP4wMhlq9nkEvcjfqKOLOLW2uq1I
         wJSoc7fpogC/VF5ENI0t3yDKzY4A+d7b7jFoPKKpO3atIpLOnjWKduL6cuXEKpBcLe5O
         /T3fhk7qHOEwBLjtM6W5BwMse89Os7Omy5ZsflWEk9QT1zXgvZxftCRfz8mfsP8G2vs+
         4vMXedK+OsCKfhBkrH+fDy5xWMWdJbV3SMR1ACssxvxRLe2UPEs7Qk9RoXBAROdFGBtX
         sCdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722370502; x=1722975302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C8yo2cbMxRjf1SYFGiWaoP3WEwWP/CuFq0W0aGvMAlc=;
        b=fCe1YUX4Eou894o2Hir7oWHJRYU9LpQFxRTkDWm46f3hD60RKnvSGeMFmz/81+uZuh
         auJjiMbnMMW2kivpPj83pY4Ecv21vtCg2pKgsrf3eMKbUYN0gojhNOc0sJsk20igYDuv
         L6iw7BC5M5WiihpQXNcc10Rpg6wzw7pMwg7JVj/LBnpXOz2tF3aOTp4gPmdU63KAZOmF
         +JXWCOoDlEZ29cXmx3zRcdp+dt7w+AWcaZNPC5CONfDvtebq9RtdrqqFFPCG2I6JCkJt
         yJABNuRcqgkpgVUpUMfNWA6VFeI8s69LdvYbnIqpfuEn4Tp/+G6idJWFN9v4c0648b7z
         M3GQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKWtvl+fUV75oaoHvun7hKENlMq4KfWhSuo/xaDQpqr9444/FoUhmNMAIDYbZ7KD1W8Kf9kSWShiB2MCxy5dTsUykOtphh
X-Gm-Message-State: AOJu0YyRkI5JK/wOj1mJLL+rjP2bewLg69HYP49AQGR4SgR2tlTH84Np
	jXZyNhrpC41vxHUsVkvbk+1tvvgXbhjrb5VwanCXpe81m/DJ1nFKYiufmn5wlhLjspiIDAwP43D
	3+g==
X-Google-Smtp-Source: AGHT+IH9iITYoLB/ZN9Oi4VKGOQu9lhx7HYkDR9WKhrc/jsriwfmp+7ZOuZAysZ686xisdvdjIEEvamlnSs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea01:b0:1fb:54d9:ebb3 with SMTP id
 d9443c01a7336-1ff04828eb3mr5974125ad.6.1722370502109; Tue, 30 Jul 2024
 13:15:02 -0700 (PDT)
Date: Tue, 30 Jul 2024 13:15:00 -0700
In-Reply-To: <63c41e25-2523-4397-96b4-557394281443@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-35-seanjc@google.com>
 <63c41e25-2523-4397-96b4-557394281443@redhat.com>
Message-ID: <ZqlJxJyOdsR206Zc@google.com>
Subject: Re: [PATCH v12 34/84] KVM: Add a helper to lookup a pfn without
 grabbing a reference
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Paolo Bonzini wrote:
> On 7/27/24 01:51, Sean Christopherson wrote:
> > Add a kvm_follow_pfn() wrapper, kvm_lookup_pfn(), to allow looking up a
> > gfn=>pfn mapping without the caller getting a reference to any underlying
> > page.  The API will be used in flows that want to know if a gfn points at
> > a valid pfn, but don't actually need to do anything with the pfn.
> 
> Can you rename the function kvm_gfn_has_pfn(), or kvm_gfn_can_be_mapped(),
> and make it return a bool?

Heh, sure.  I initially planned on having it return a bool, but I couldn't figure
out a name, mainly because the kernel's pfn_valid() makes things like
kvm_gfn_has_valid_pfn() confusing/misleading :-(

> (As an aside, I wonder if reexecute_instruction() could just use
> kvm_is_error_hva(kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa)) instead of going
> all the way to a pfn.  But it's ok to be more restrictive).

Heh #2, I wondered the same thing.  I think it would work?  Verifying that there's
a usable pfn also protects against retrying an access that hit -EHWPOISON, but I'm
prety sure that would require a rare race, and I don't think it could result in
the guest being put into an infinite loop.
