Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5945539BFFE
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 23:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787268976; cv=none; b=bZD2RSvhqdzBBhkbrOxR+IsC0HoBK8x6n+Nssjo9jK78K+PPsooonoivZnyFjVwRxExzMrF0gAuNvFJmnXnr78UQUcNafpOBPH27NqBD7M8NLWLxJBhzFJvSwkxo2Le9lS5IS+m65Poky2jPrwXVP67GvtaLBj/0InH2T0hZxrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787268976; c=relaxed/simple;
	bh=mUhbrxi5Wl4bcx3T2WtFkFet1O+S4n63de4seDdAqcw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O8DJPfoDBEkR6zQ5sxZ8rpd2c4BpzEV+jbY01UPnKIl44hq0l240i/Slnb5JtXa3Gq5wi8Mi//b0oXNAsmoEHQa0CXzDUXA7BCBwvgbdaDd36N5cX4gtJFo+lwV5UORvGlvPLCK1Wtdp6I2CgPaVO9oIC8n07Q2YTttsL4AnfDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jV6t/vg0; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jV6t/vg0"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so358171a12.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 16:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787268975; x=1787873775; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7FsF+dC/ofr8sxGFtHAB/t3yjlu1tenoFlMvm24uheM=;
        b=jV6t/vg0jzwAJ7LiFxzPuA1zXp7uNNf0gDOkGCXDPtUCKNRVemsBseI2HrzSQURwvF
         l8SSj/dznQCKs6SZX8lPkZSD651tLQ0yZzHxQ9PskDhGSR7DYgu2agKEIkzeDDx/asr4
         vikI41prWfvVrD7LC3omQ/zO1HpMyWDgrbMLa4wftyIEkFowezRnFs21aPzvBjnLjjZ+
         LOFw+EaaAHeDiy60yR1fxBWXH00u2M1WSuAKh/cG9Vnot8lMBKv+q9cYA46uDzDysMsF
         hizkt9ScTTHGKe7m4Jaq9h2LBJffskTVDoahLmBSbvwrQsGQ79KX+J5JVLlKKfEyiwBe
         hT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787268975; x=1787873775;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7FsF+dC/ofr8sxGFtHAB/t3yjlu1tenoFlMvm24uheM=;
        b=ftIGxW8Uj3752OPNyUNbiS1sq3IBWJF813Z49SNp3RX5vv65uhesHjbhYBdjDZeXF2
         we3OfG1L2mlVtPl1LqNxxSYRlsJF8EfZ3z39TacOy7Okqi7VMBb8XDMTz1XJlIs7ECzq
         9t4RGSXFpKNhtSRJOgYmeEQd6I/eBu8/+5u4Jh/xlQyvYgx6WPMgNa9Xb9TD8xhKuoPe
         n6A1q4VzOnHUIyi5inl61BzPT79NWekzPoh/gAwELO05Mk0rLle6uCWdQ+xfS21nZccl
         M40q0hTYvsRuci5X6TqaFlntJKVjnM1mbR98d0CBUQ7WAqbwzKHrwtsyf75NQPa9x0sY
         Yc7w==
X-Forwarded-Encrypted: i=1; AHgh+RrEU5VxHckA8FB2vM1sH4rViCywsaWQtwupMdvFiTqp8wxX4RE1zoPDhmGEzk8SGx1IC/tCiWk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRyEWgUhWlswp29fTfn3dBeGVzaGP9YU44QGaLDyyloqcLLjQ+
	YWrt8Gb5Ko9ycPQt2tBYg91cLf0PZVUCEH7pJopMDRwJOBkQnwo8H8WTJAvZ0hwHgseGdr6mTpt
	r9N1gXw==
X-Received: from pgmj16.prod.google.com ([2002:a63:5950:0:b0:c97:228f:37ae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6001:b0:3cc:fb7d:a9ab
 with SMTP id adf61e73a8af0-3cd2fd8e99emr4211436637.2.1787268974429; Thu, 20
 Aug 2026 16:36:14 -0700 (PDT)
Date: Thu, 20 Aug 2026 16:36:13 -0700
In-Reply-To: <7kapvdum7qk7l4epbeqvrybqxapuhvwltz7axfprxldw2utozh@t4url3mqbpom>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-2-5298f42d49bb@google.com>
 <j6bfvbzjivlcsu3slbnaoomxxqyypmfl2bupo3k5ipnt6fc5lo@e5ntbx7yd4qw>
 <CAEvNRgEruoa4d_8Y1MpkdzbHg3j1Yv=-Y6w6Yy=v6mJgPajjWw@mail.gmail.com>
 <zb5krzhrg3soslplynegqo52brd53wk3meas45udqpjms6oluk@zecqwzn7zziy>
 <CAEvNRgEHEE67+vjQqJjYD3M4yuwuR+4-36Hw4-sp5caYzmxbkQ@mail.gmail.com> <7kapvdum7qk7l4epbeqvrybqxapuhvwltz7axfprxldw2utozh@t4url3mqbpom>
Message-ID: <aoePba0sbVFzUl_9@google.com>
Subject: Re: [PATCH v2 2/4] KVM: SEV: Drop page refcount early during RMP
 fault handling
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Brijesh Singh <brijesh.singh@amd.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 20, 2026, Michael Roth wrote:
> On Thu, Aug 20, 2026 at 03:35:31PM -0700, Ackerley Tng wrote:
> > Michael Roth <michael.roth@amd.com> writes:
> > Ah I see what you mean. I think we mean the same thing, let me add to
> > the commit message that I meant after dropping the refcount early. Does
> > this help?
> > 
> >   The filemap_invalidate_lock() is already dropped in kvm_gmem_get_pfn()
> >   before returning to sev_handle_rmp_fault(). After dropping the
> >   refcount earlier with kvm_release_page_unused(), these scenarios are
> >   possible:
> > 
> >   1. Since the filemap_invalidate_lock() is dropped, the page can be
> >      truncated (or in future, converted), and the RMP entry is now
> >      shared.
> > 
> >      In this case, existing RMP table handling (psmash and checking for
> >      errors) would be sufficient. On finding a shared entry, psmashing
> >      would fail gracefully and no warning would be emitted.
> > 
> >   2. The page is truncated and freed, and then re-allocated to another
> >      SNP VM. The RMP entry is now assigned, but to another SNP VM.
> > 
> >      To address this, adopt the MMU invalidation protocol to guard
> >      psmashing.
> 
> This reads kinda weird to me, as if with #2 we're documenting a "bug" that
> this patch fixes, but the bug would only exist if we partially applied the
> bits of this patch the drops the ref counts earlier and left out the
> bits of the patch that introduce the mmu notifier logic that replaces it.
> 
> I think with patch 1 applied (which covers the
> psmash-a-now-shared-entry case while retaining the original refcount
> logic), the only thing this patch is doing is replacing the elevated
> refcount logic with the MMU invalidation logic as prep for dropping
> reliance of refcounts entirely.

(I had already typed this up before I saw Ackerley's response, so dagnabbit I'm
hitting send).

Agreed.  Less is more in this case, unless you want to explain all of the gory
details of how KVM handles MMU invalidations.

  Rework KVM's handling of RMP faults to rely on MMU invalidation logic for
  safety, instead of the current approach of holding onto a folio reference
  until the RMP operations are complete.  I.e. drop the reference gifted by
  guest_memfd immediately after getting the PFN, and instead do RMP updates
  under mmu_lock, after checking for relevant MMU invalidations.

  This will allow dropping guest_memfd's reference gifting entirely, which is
  ideally how KVM would operate for all "follow PFN" operations (GUP has many
  more complications, which is why KVM holds a reference across page faults
  *on top* of the standard MMU invalidation logic).
