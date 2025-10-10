Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7941DDC33
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 20:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760128398; cv=none; b=QFlcjvSR8lObQGICvmbFheUlYZ1LBmgXsMtmCRFQvcQ9mJNM8QgbaLLzF9k2qheUwv6v7yYR5OYGz9tE9jH0Kyl1VVOktYm2nQUqQlaPi2UTHV9KpA9CDBmqrzDFUj4yWm3r0Bf4DwbH0L1bLwxgUdImD/VyQrEI5yaL59N7dmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760128398; c=relaxed/simple;
	bh=X0w1t+jGMBVtCc8oN5Do4EjNj28nEcw8nzBfMN0pS4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T1ynHYWFECmEcL0xY4qYclZyqLPqAweVcLPAD9ClqKBInGtWk87tLssVTPRPiJ1W4PcUtJUHNMJdABHjNDMqIJf5neQlHLqzEejz9wb62v0lNYVmEecTn3sWPF31TWcvAOcEnSgiLzucJjt6E0BtI2kmDwg/sfDIIt6R9jsiGUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kfCt7UsG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kfCt7UsG"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-277f0ea6fc6so105205295ad.2
        for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 13:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760128396; x=1760733196; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L4WKjl2E9WbuIFhs5JLmpEcHpxZyN+nyEAJYdJG5kGQ=;
        b=kfCt7UsGo1PSrWbGIOTdlais9uiJV28VNCf59HSq36Xw7gewxBy80GfHDrLnBaij3K
         PcLdDlWew4nd4dkjHi3+tWvsjMcendZpCr6O+Fk61wxKahi+Qg5lFYzfEqsvk1wVF9NG
         kef9JJoApEBNlYVb4Jr8fihWG8fur1og8Ef7N/rFlTPBVikjQeTOjUWT6nZBvV27HOTs
         rc++3eq8LSH5sfeambOcPGmPklELWhyCZQ/4ghYSDza+mkwl64mqnvNvvjUnLVdx6TjU
         XVgChApwgL21xVh9xriv8pyKjuv94txzXIUY358jYKlmI2Bi9qMcGFzVbLfNDIDGtwf0
         I7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760128396; x=1760733196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L4WKjl2E9WbuIFhs5JLmpEcHpxZyN+nyEAJYdJG5kGQ=;
        b=X2AU9yWvfgnuwwzvy8d1cj6s7wS1sepPmxJJjZVKDpKERUhorxlKIJ0Khq7DKr7kZj
         uP50yENFGuyRON9SG0Ux2mIrrrcvbbOHqdNL67gMcpE3XAV847Qx1qd7OSMJGBR+vvEn
         Ns4cdkDwTB4QXzuXZZ831K/kYjPsRXl/fI+YUv7Pl5S3JBljRRJaVIUnaqC9+Ld9UTvq
         7J2jwpzCkfH8sOGpkfi8mZAu3O/JgYf5hze0XkwB9vOb1R+oZXyA9dSBYenm4j/f8Kjm
         Bf9ZiCVno4gYxmAYTHUuh+xPx3trmzYvamIrNk1LRXE7gAdvmFiSpqf8FA+vkGu6zctn
         y3JQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeNF+klr32u2OGbIuD8m1m4bdNyZVpN/W0fM2T3hrTlRYx7NPJuMzbT2j9Z4SrbaktJ95hPqA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmaH71jVXZTD9bu/5AC9hCDhfjtGUTTcJ9pczH5xmHjNK+iUL/
	kk1gl5AihXTUiHjIRNOhDP9uBYoLI12YpyJA1kq75QmJrwa4h0g1I9iNdvEke3bnElqJ94RFuHR
	XajlQRQ==
X-Google-Smtp-Source: AGHT+IHFcGHBjt5WD8SXsC1G25bD9P3AfNkPCXsvq/nAV+y/iv/KTrwq4V0pmquBSd24rCSDN6ZBdmCxlM8=
X-Received: from plpo9.prod.google.com ([2002:a17:903:3e09:b0:27e:ed03:b5a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3bc7:b0:269:8404:9a6b
 with SMTP id d9443c01a7336-2902741e466mr159655195ad.57.1760128395608; Fri, 10
 Oct 2025 13:33:15 -0700 (PDT)
Date: Fri, 10 Oct 2025 13:33:14 -0700
In-Reply-To: <e9bd02ba-ff0e-47a3-a12e-9a53717dde9b@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-6-seanjc@google.com>
 <diqzo6qfhgc9.fsf@google.com> <e9bd02ba-ff0e-47a3-a12e-9a53717dde9b@amd.com>
Message-ID: <aOltikRvKzCy1DXN@google.com>
Subject: Re: [PATCH v12 05/12] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 10, 2025, Shivank Garg wrote:
> >> @@ -112,6 +114,19 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >>  	return r;
> >>  }
> >>  
> >> +static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
> >> +						   pgoff_t index)
> > 
> > How about kvm_gmem_get_index_policy() instead, since the policy is keyed
> > by index?

But isn't the policy tied to the folio?  I assume/hope that something will split
folios if they have different policies for their indices when a folio contains
more than one page.  In other words, how will this work when hugepage support
comes along?

So yeah, I agree that the lookup is keyed on the index, but conceptually aren't
we getting the policy for the folio?  The index is a means to an end.

> >> +{
> >> +#ifdef CONFIG_NUMA
> >> +	struct mempolicy *mpol;
> >> +
> >> +	mpol = mpol_shared_policy_lookup(&gi->policy, index);
> >> +	return mpol ? mpol : get_task_policy(current);
> > 
> > Should we be returning NULL if no shared policy was defined?
> > 
> > By returning NULL, __filemap_get_folio_mpol() can handle the case where
> > cpuset_do_page_mem_spread().
> > 
> > If we always return current's task policy, what if the user wants to use
> > cpuset_do_page_mem_spread()?
> > 
> 
> I initially followed shmem's approach here.
> I agree that returning NULL maintains consistency with the current default
> behavior of cpuset_do_page_mem_spread(), regardless of CONFIG_NUMA.
> 
> I'm curious what could be the practical implications of cpuset_do_page_mem_spread()
> v/s get_task_policy() as the fallback?

Userspace could enable page spreading on the task that triggers guest_memfd
allocation.  I can't conjure up a reason to do that, but I've been surprised
more than once by KVM setups.

> Which is more appropriate for guest_memfd when no policy is explicitly set
> via mbind()?

I don't think we need to answer that question?  Userspace _has_ set a policy,
just through cpuset, not via mbind().  So while I can't imagine there's a sane
use case for cpuset_do_page_mem_spread() with guest_memfd, I also don't see a
reason why KVM should effectively disallow it.

And unless I'm missing something, allocation will eventually fallback to
get_task_policy() (in alloc_frozen_pages_noprof()), so by explicitly getting the
task policy in guest_memfd, KVM is doing _more_ work than necessary _and_ is
unnecessarily restricting usersepace.

Add in that returning NULL would align this code with the ->get_policy hook (and
could be shared again, I assume), and my vote is definitely to return NULL and
not get in the way.
