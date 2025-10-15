Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C94332E74F
	for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 16:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760547419; cv=none; b=LxML7eO3VRafB4VsFgEui6wS5DqTu60zfIgmYdVPpn/epTpLx5C5lgyUSTHFkKvCKlQf1GMlRqa76GLZ2DNIOGyW1W2U+5Pq/RylLDe5Gu5YdGp+q0p0fNrWDtijShp4WiCclHybWwWv5As9SYKoiSykDwwrUybrw2nDuVf3eg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760547419; c=relaxed/simple;
	bh=Br2ogEQs1/iRtN5J5jedL4Onti9Vib3S8PTIJFNEsWI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tmo5R7qBKAqJJBxO0dWRwT1s2aFRRrbdA5WmD5YK0SC55dcUhheC8KDbq6zXMFSYtMf/53S5UwTRRDsnzx1EWWzyEIs5Yl0hw1uvzQzYfa20Nqo58qE18IxiLTAPxhqAQqYGQzuXVcleQe1ZHmui0SU6fTjNhv/C+UH+YAKZh5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xZfHuHaH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xZfHuHaH"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-335276a711cso13520112a91.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 09:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760547417; x=1761152217; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CbYRjcxiLRGKL2LIFUGAiQXkDS5QuVlAtEitSDKwgNo=;
        b=xZfHuHaHr50qUxcWSAsfZ93o/NF0RInPfvVWQgMU8C2JTojZsJzALd2nVEb5kPvhmC
         7EMbPZQLEb0rtIVeKfDyP2+0K/goCCstwDLEB/Xu3OKIXU9reBwhu/bvkTgcFDJEjFmh
         cwkJRisUmCl90OZWkMZwWtuu8dwac6tcAgD5EM31bYIJ01XNyL1f9QrbtdL2ayZM5Kd1
         ywiG0trtqjlBE5EBeZKwflJCvoc42OkdxGB0vXoWMFwK36qIJ0rmJItmvZwnBBe4W3LZ
         1ZyjnSDKEw9sV3JZizVUKbAJ1B/ZjgKo9URD5D8KEnU8iotvSb0DCAmPFwmANmFKEgg4
         j14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760547417; x=1761152217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CbYRjcxiLRGKL2LIFUGAiQXkDS5QuVlAtEitSDKwgNo=;
        b=TPO70Sxcaw4RIwTuzUAfi76Jf2WZWA3mEKRULW2L/uOOa/74NltZ1a8J9/W2DhDoDa
         5+kve7OSjRUG5SwpRFYrVFfwGp14hbelJRBgkvCggQPnkWPMJiXhEtBku7Zyvi7r8ZzV
         2PMF6W1YLCZIftETuniih7orHU+KM+FKUhYFY//6xboTwAB2qBSL2MMEtpBAx/Dr2AHV
         T80J/QHYGzdNhtsVfUeAdr6Ga60W2CjuhXPfyOjfo2g9fW0K+LWfefZUeHmgKllFIFRc
         fmG4lmJK+82252CgDKklhMqc+awD61lSqujyn6nlRJcpfL7rFQnNve2YeSfE0EXWnHpV
         OqdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSunzBi6LncdWQNefyDXNGGtGRXTCf4TP6ryCeGSPiT/D2ir5y3FKWd16sIz/BpX6neeIkkSs=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywm5oYKfMNQn8XfhXQXZphv6KCmITNAwJJrc0R9Nwd4YARmwjwp
	hGMnE357o8EL5JNdoWX9yMfh8MIFIYDGvlTikYConG7vCCWzgvmJkA3yRexWAKgNAkbb8+3FiDp
	2at1VWg==
X-Google-Smtp-Source: AGHT+IE8G6rCUXSY9kLglvAN1OT5mVOTch4nfQN3hIBfcNRFcG0ozBsKIivfelaBWpgamTPWwCFJi/Lz678=
X-Received: from pjbgj15.prod.google.com ([2002:a17:90b:108f:b0:330:72b8:fcc0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3843:b0:330:bca5:13d9
 with SMTP id 98e67ed59e1d1-33b513b4c9cmr36865790a91.32.1760547417511; Wed, 15
 Oct 2025 09:56:57 -0700 (PDT)
Date: Wed, 15 Oct 2025 09:56:55 -0700
In-Reply-To: <diqzv7kmfmio.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-6-seanjc@google.com>
 <diqzo6qfhgc9.fsf@google.com> <e9bd02ba-ff0e-47a3-a12e-9a53717dde9b@amd.com>
 <aOltikRvKzCy1DXN@google.com> <diqzv7kmfmio.fsf@google.com>
Message-ID: <aO_SV0ee6h8rK9dZ@google.com>
Subject: Re: [PATCH v12 05/12] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Shivank Garg <shivankg@amd.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 10, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Fri, Oct 10, 2025, Shivank Garg wrote:
> >> >> @@ -112,6 +114,19 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >> >>  	return r;
> >> >>  }
> >> >>  
> >> >> +static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
> >> >> +						   pgoff_t index)
> >> > 
> >> > How about kvm_gmem_get_index_policy() instead, since the policy is keyed
> >> > by index?
> >
> > But isn't the policy tied to the folio?  I assume/hope that something will split
> > folios if they have different policies for their indices when a folio contains
> > more than one page.  In other words, how will this work when hugepage support
> > comes along?
> >
> > So yeah, I agree that the lookup is keyed on the index, but conceptually aren't
> > we getting the policy for the folio?  The index is a means to an end.
> >
> 
> I think the policy is tied to the index.
> 
> When we mmap(), there may not be a folio at this index yet, so any folio
> that gets allocated for this index then is taken from the right NUMA
> node based on the policy.
> 
> If the folio is later truncated, the folio just goes back to the NUMA
> node, but the memory policy remains for the next folio to be allocated
> at this index.

Right.  Though thinking about this more, there's no reason to have "index" in
the name, kvm_gmem_get_policy() is sufficient.  E.g. we don't have "index" in
the name for things like kvm_get_vcpu().

Luckily, it's all made moot by Shivank's fixup :-)

> >> >> +{
> >> >> +#ifdef CONFIG_NUMA
> >> >> +	struct mempolicy *mpol;
> >> >> +
> >> >> +	mpol = mpol_shared_policy_lookup(&gi->policy, index);
> >> >> +	return mpol ? mpol : get_task_policy(current);
> >> > 
> >> > Should we be returning NULL if no shared policy was defined?
> >> > 
> >> > By returning NULL, __filemap_get_folio_mpol() can handle the case where
> >> > cpuset_do_page_mem_spread().
> >> > 
> >> > If we always return current's task policy, what if the user wants to use
> >> > cpuset_do_page_mem_spread()?
> >> > 
> >> 
> >> I initially followed shmem's approach here.
> >> I agree that returning NULL maintains consistency with the current default
> >> behavior of cpuset_do_page_mem_spread(), regardless of CONFIG_NUMA.
> >> 
> >> I'm curious what could be the practical implications of cpuset_do_page_mem_spread()
> >> v/s get_task_policy() as the fallback?
> >
> > Userspace could enable page spreading on the task that triggers guest_memfd
> > allocation.  I can't conjure up a reason to do that, but I've been surprised
> > more than once by KVM setups.
> >
> >> Which is more appropriate for guest_memfd when no policy is explicitly set
> >> via mbind()?
> >
> > I don't think we need to answer that question?  Userspace _has_ set a policy,
> > just through cpuset, not via mbind().  So while I can't imagine there's a sane
> > use case for cpuset_do_page_mem_spread() with guest_memfd, I also don't see a
> > reason why KVM should effectively disallow it.
> >
> > And unless I'm missing something, allocation will eventually fallback to
> > get_task_policy() (in alloc_frozen_pages_noprof()), so by explicitly getting the
> > task policy in guest_memfd, KVM is doing _more_ work than necessary _and_ is
> > unnecessarily restricting usersepace.
> >
> > Add in that returning NULL would align this code with the ->get_policy hook (and
> > could be shared again, I assume), and my vote is definitely to return NULL and
> > not get in the way.
> 
> ... although if we are going to return NULL then we can directly use
> mpol_shared_policy_lookup(), so the first discussion is moot.

Ha!  Great minds think alike, right!!?!

> Though looking slightly into the future, shareability (aka memory
> attributes or shared/private state within guest_memfd inodes) are also
> keyed by index, and is a property of the index and not the folio (since
> shared/private state is defined even before folios are allocated for a
> given index.

Yeah, which further reinforces that having "index" in the function name is
superfluous (and potentially confusing), e.g. IMO the proposed helpers:

  kvm_gmem_get_attributes()
  kvm_gmem_is_private_mem()
  kvm_gmem_is_shared_mem()

are far better than e.g.:

  kvm_gmem_get_index_attributes()
  kvm_gmem_is_index_private_mem()
  kvm_gmem_is_index_shared_mem()
