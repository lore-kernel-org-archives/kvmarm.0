Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DC3493D5A
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790102433; cv=none; b=LdLyBN2+P0327R5n8PI/x5QlYQc3wmTdjzjDn0VByEZFR+KBaU0F4lYtp2qfm7AllU7x594pdPPxTmJXhiee1R9BblaFugYaPw7goIJ8HDqpuSLysPCJFmS9hS6JSWvyrcSevWHhvwkL5WN6SMH6yUqffDEJrpwIgub11uSgUfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790102433; c=relaxed/simple;
	bh=ERtLhWAKheJkkB1jYfwWgoVSdNN2wmMgOYzp/tzF/bI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AGD4XdH92d+UvoayJuWqeb9FSzm26RMjmRocqYMSzYOJriigYkxxn5wQWDddI6r1ZlOe23WxVCe0+wlwKSJUFTMRwGb1WR6Rboapxyl93D34pH9qmvbNGJqfiKyDxInNNbOjy2FBaYD4k0h6U8jAX6LcvlVpeLptXxDrOz2G3tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HHN5xgoJ; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HHN5xgoJ"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-854f274dd69so190599b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 11:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790102431; x=1790707231; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=22qb4IkKc4A4y/WM6dRh1XUq626SL2Lh5OkUO2ttVr4=;
        b=HHN5xgoJ1EyJzyk0KBYutUUj5fcXaiEdO8nIFU/pq4JkHceHOS+Zj7zo5Y59W+R6fW
         5OquYY0LpPmEuftljs6I2znbVfoUgy/+X7tgN3v/dTHjAqlDTBlx9J3XE1RqpYWd0Jos
         BnL5JwEPJpGyyF3ksfkzqUYLEX96JcR1ux4T0/+NoWmZlQCEmXkbx3eMfGBdFvSKVd6d
         2HGjQv8CCUorADjk9+LlrPdthaz38g6f/Kckxvgeu3BKaCG34i5HcVwBJCaxnqKoXwzX
         Y16a36UY+gSu7RYXKh1NxzYt0XMLjFZ86W2/HWk7gPLZZ7LFs+/RO/k2zeqnxigqyca8
         6OeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790102431; x=1790707231;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=22qb4IkKc4A4y/WM6dRh1XUq626SL2Lh5OkUO2ttVr4=;
        b=moA1Q7t7MqVG8H7YwUPGq+YvdaiJX7VaPMBdAnh5s3iLX2BOb8qMgB22LVR9vXpXJe
         CcfaAeBfnEKyFHgjuAHUDNIzUa3ogqs8AtrLphd0LZrK/xbVYI3aV1lP8AEGzazp2is4
         IOyFZMkQ6Tvti2sH3F2h4hdvZWhXbXJRTICgXYYu2SfmavgS0cjYmESrL8yYk8Mz6EyN
         PNX2TWlr6jNbzUJtQKaFhWYdl0Cc0nytyKy6jMllSG/E4Gl7J1i3HaAnbgTZHtvQWrz4
         uN8Eth4b2iruIA/jbinRWbpJqTDeDfcgb7Y7JN/Rt0/3aIWU1kpoBJsqIpnnbUwURpxC
         eq/w==
X-Forwarded-Encrypted: i=1; AKwUvBxLhogiO9AGsmiBqCpyjBMi56LN+U+oMmZFL3I3/MSHDLPIPMIDQ3x+Fu5nSwuQWNHWYwE4wek=@lists.linux.dev
X-Gm-Message-State: AFuF++lNLKGkHP9myugYX8TYSiXL2wm1yBE+CanQK6h5XyDd4sAUsczD
	vxeaWK/A/mqiecyO/rajuFKs/OwCQax/hDNp04rlexAQwVUQhCZi4nVaatHMmIUYaP+6vg6ZzHA
	ue9sXYg==
X-Received: from pfbgd10.prod.google.com ([2002:a05:6a00:830a:b0:863:cabd:d30d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4396:b0:878:3507:8d5e
 with SMTP id d2e1a72fcca58-87d1bfae6abmr510835b3a.37.1790102430559; Tue, 22
 Sep 2026 11:40:30 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:40:29 -0700
In-Reply-To: <arK8-Hec3-5o4jYs@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org> <arKxjsxuO1F5ExrY@kernel.org>
 <arK5n9HrbZMCOHOt@google.com> <arK5ynpRi7VbY7Ek@gremlin> <arK8seJVT9wYgVCP@google.com>
 <arK8-Hec3-5o4jYs@gremlin>
Message-ID: <arLLnYvkXSFr6f6u@google.com>
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
> On Tue, Sep 22, 2026 at 10:36:49AM -0700, Sean Christopherson wrote:
> > On Tue, Sep 22, 2026, Lorenzo Stoakes (ARM) wrote:
> > > On Tue, Sep 22, 2026 at 10:23:43AM -0700, Sean Christopherson wrote:
> > > > Rather than have kvm_arch_vcpu_allow_pre_fault_memory(), what if we add a more
> > > > generic kvm_is_vcpu_loadable()?  That way we don't need to worry as much about
> > > > the return value, the connection to vcpu_load() is obvious, and we don't need to
> > > > add another pre-check if future (or cleaned-up existing?) ioctls want to do
> > > > vcpu_load() in common code.
> > >
> > > ...this is exactly what I started out with.
> > >
> > > But then you are in a pickle, because _really_ you need to do that check in
> > > vcpu_load(). Which is a void function. Which is called by every single
> > > architecture all over the place.
> > >
> > > So you'd have actually no way of signalling the error back.
> > >
> > > Of course those places are arch code and you could say 'arches should know
> > > better and if they call it it's fine not to call the arch 'can you load'
> > > function.
> >
> > Yes, that's my vote.  It'd be easy enough to clarify that "rule" with a comment
> > in linux/kvm_host.h.
> 
> I note you dodge the actually difficult question of what this wrapper function
> would look like ;)

Oh, I was thinking we wouldn't bother with a wrapper.  Because I agree that
providing a complement to vcpu_load() would get all kinds of messy.  Though we
could harden vcpu_load() with a WARN_ON_ONCE(), which in practice would prevent
the vast majority of violations from making it to a final kernel release. 

> > > Instead you can make the predicate 'don't prefault on a not-yet-initialised
> > > vCPU' which is pretty sensible I think, have a specific place to put it and
> > > all's well with the world.
> >
> > But look at it from an x86 perspective.  Pretty much everyone will look at this
> > and expect:
> >
> >   bool kvm_arch_vcpu_allow_pre_fault_memory(struct kvm_vcpu *vcpu)
> >   {
> > 	return vcpu->kvm->arch.pre_fault_allowed;
> >   }
> 
> I'm not sure I really get your point here at all? :)
> 
> Why would it matter what people who are too lazy to go check the implementation
> assume about an arch hook?

Because I don't hate the people that contribute to KVM, and want to make it as
easy as possible for them to not make mistakes?
