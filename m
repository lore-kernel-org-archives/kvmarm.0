Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521AD3EE1E4
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098613; cv=none; b=TxWvtgIVi2R4FFO39CqU/08qF79ikH1i1JGYDjKF5t1Cbc1x0Z6zCqHagzaA+yyPJAKnCu9RF/21LklFPMS1REoAwrfIIqhXeKzTTeVs6/T8Yvy/WUeD6nXTngXMULlaoqi8dRBZAZaLrPnTDc+Q1Wm1aCzZqYRyTOke/U3oIHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098613; c=relaxed/simple;
	bh=pqfxOYdbk3G5uQ189p1pwNugqSafNpPZSMqnl+pMNDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Viy0S4Gn9VrhV3IdCjzY/UJpLY0taBaVgQot1Y4A36e23rlfUlCGWb8sLg9Mf1QAIZDNZ2Hu1N/Rppkb1JhOh95og6QpoFu+Ke+CwJXhHa9Klvc9p85y+dGDP/qmqO8K2BOAb1nPvYlYwIlo/A9+wjHuClKt/++JTDIPP+kpCWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JPQfrxDZ; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JPQfrxDZ"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d7443e0f0bso1364315ad.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 10:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790098612; x=1790703412; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gMBUcj03qoQAyG1GKCyEGFSnmBsF37yewOw9nu3IXkc=;
        b=JPQfrxDZ5Kot/wo5W2at3IqxhSPwLTPFbFzgO6gz8gZqPRx7jeITPQeLa+UYzxtzGe
         NH4MDKXM/kQcIFJ3wwnSfWzXmLWRCjs8hb/TTvU27ecSxvztBBxsMCXgTqk39CWrkd7+
         DVvdf2QBlHG6ShFbJ7fiveR7s437ND9KC9qVIAu/9Wuu4Vo3FLNTUhFkX3rSL0Jcb937
         yDX5CsDJUP+IwVEv5gioqrv8GZhjU2KlZ6Uoc2Tg8hdDOlQGA5/AixS1elOX3Q2IchWe
         SozkPx1Wa4Fg1JZiXVobgoFL9sG6DFL94CZEQV//75X0m/cXT5waHs8E8Gvnt7B4Zc6j
         G0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790098612; x=1790703412;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gMBUcj03qoQAyG1GKCyEGFSnmBsF37yewOw9nu3IXkc=;
        b=ToUC9rXjo3dFoQUQxS6otLN2XTEYtbBsX2p3b7bnLlzaL6iyGAkah6ol4E2Z89VvCu
         D/gziemokZD29zQwqp8/9y/+wP6Mv+AdTGEM0bbsvmrYklhBLderTdjPTecrOAwO7GE7
         CEXJ45e/UsjJ0301qwbxui8ofV9CoGEuuvzstXY7WWrxwgah3XiokUMaE8sGmE8q1Gya
         RLrJZtjEONMfzk3/+X65eXtVhtAr6xh5n8XZYOHLlibt8aUoegmggEXnBhJyzVYKoQpL
         nQdwwxjchD4/KoGl3CFV+/XBIND6+TMJozE9VB4FOPTNPSnKj7sCIH0TjV8hEOFTw6a5
         gJGw==
X-Forwarded-Encrypted: i=1; AKwUvBxtdPhkj0X//Yz0iEIdmOwvGgfk6/BvzhbFQKIOnevtVA8qI0f3It2N7O+OYcXZ1Dsk85V+/xo=@lists.linux.dev
X-Gm-Message-State: AFuF++nOIhlzIdl4rx9QR0PbI5ZyxHS9n7+HTGKSIBgsPJ5a4xyQX9Nw
	hlbZBDCloTwZjIbDT0ARegEOsYm9wC9z8VCWHhXFK2+njdboqNeCf58IjqzNOOX/eICq8xAAvOF
	wBi5lLg==
X-Received: from plhz10.prod.google.com ([2002:a17:902:d9ca:b0:2df:4a0d:5ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b27:b0:2dd:c100:a5d9
 with SMTP id d9443c01a7336-2df69df7453mr924125ad.45.1790098610429; Tue, 22
 Sep 2026 10:36:50 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:36:49 -0700
In-Reply-To: <arK5ynpRi7VbY7Ek@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org> <arKxjsxuO1F5ExrY@kernel.org>
 <arK5n9HrbZMCOHOt@google.com> <arK5ynpRi7VbY7Ek@gremlin>
Message-ID: <arK8seJVT9wYgVCP@google.com>
Subject: Re: [PATCH v3 01/14] KVM: Allow architectures to disallow pre-fault
From: Sean Christopherson <seanjc@google.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 22, 2026, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 22, 2026 at 10:23:43AM -0700, Sean Christopherson wrote:
> > Rather than have kvm_arch_vcpu_allow_pre_fault_memory(), what if we add a more
> > generic kvm_is_vcpu_loadable()?  That way we don't need to worry as much about
> > the return value, the connection to vcpu_load() is obvious, and we don't need to
> > add another pre-check if future (or cleaned-up existing?) ioctls want to do
> > vcpu_load() in common code.
> 
> ...this is exactly what I started out with.
> 
> But then you are in a pickle, because _really_ you need to do that check in
> vcpu_load(). Which is a void function. Which is called by every single
> architecture all over the place.
> 
> So you'd have actually no way of signalling the error back.
> 
> Of course those places are arch code and you could say 'arches should know
> better and if they call it it's fine not to call the arch 'can you load'
> function.

Yes, that's my vote.  It'd be easy enough to clarify that "rule" with a comment
in linux/kvm_host.h.

> But you're still stuck with the problem of where exactly you put this check.
> 
> So then do you put that check in a wrapper around it?
> 
> Instead you can make the predicate 'don't prefault on a not-yet-initialised
> vCPU' which is pretty sensible I think, have a specific place to put it and
> all's well with the world.

But look at it from an x86 perspective.  Pretty much everyone will look at this
and expect:

  bool kvm_arch_vcpu_allow_pre_fault_memory(struct kvm_vcpu *vcpu)
  {
	return vcpu->kvm->arch.pre_fault_allowed;
  }

> > I'd also be tempted to say it can be a macro, not a __weak function.  E.g.
> 
> Yeah it can be many things but why would you want a macro if you could possibly
> avoid it? :)

Because it allows arch code to dererefence "struct kvm_vcpu" in kvm_host.h,
i.e. allows "inlining" the check.
