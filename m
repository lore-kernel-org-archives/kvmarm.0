Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4641CC89F
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 15:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728575565; cv=none; b=H2J7/paAakRD8YX90E4oq7tXrRaiLxVQWQxQifwVunVaWzWfdal9HjLA/NEmnESxoKTx6A+62HaOd+MD4Qi/ZEsBwp1Nfrar+6L8TC8j1zBaGMK68zYtqxku3X4Tq26cVbRpH+aUf8xJQMcdLC9bJqKxUi7efWEQz/2KlNIDJJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728575565; c=relaxed/simple;
	bh=UD6gE8Ajbe1yu0kKtf5syRQL8hngYhpGDpczsNaYu0M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y9M+4Vfs5tMBc9CmnVsWHmr9UklW1s/f/VoYeov/PlxF4W5D0Tueg/bWyHoRdkIb/bd5XlepSIF0sqMd3ps8ZG5Dr9n3ye66fp0pCopv6aWcziGxLkt0mim+qDGgtzp5Y+aA1+GHWJxy6VMUQmPEWKJpBEh444MWwHUKJYhHmyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=XwnHlW6X; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="XwnHlW6X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1728575564; x=1760111564;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kkum1blv47enqgyq2aUGev7ra3ELmRp0dUTOAbl+I58=;
  b=XwnHlW6XYoJPa/bv9C261CUd1VGONwodjKce/FrKZxkkdr/HqFFXS8h3
   GVXkI+wtuH9Cao+FaP5X/HHHsM5ngppua8lu5Bjy2vVkE1lzTUlisk0ED
   KROfQaXHoKF5VKpDhytdbcHIf4DGNfCeFBqS5FnmEaDaTRiryObr47z8F
   4=;
X-IronPort-AV: E=Sophos;i="6.11,193,1725321600"; 
   d="scan'208";a="238327105"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 15:52:39 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:23851]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.18.228:2525] with esmtp (Farcaster)
 id 646efd08-675e-4746-8ba7-c38ece7edc16; Thu, 10 Oct 2024 15:52:37 +0000 (UTC)
X-Farcaster-Flow-ID: 646efd08-675e-4746-8ba7-c38ece7edc16
Received: from EX19D033EUB001.ant.amazon.com (10.252.61.11) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 10 Oct 2024 15:52:28 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D033EUB001.ant.amazon.com (10.252.61.11) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 10 Oct 2024 15:52:27 +0000
Received: from email-imr-corp-prod-iad-1box-1a-9bbde7a3.us-east-1.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Thu, 10 Oct 2024 15:52:27 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com [10.253.79.181])
	by email-imr-corp-prod-iad-1box-1a-9bbde7a3.us-east-1.amazon.com (Postfix) with ESMTPS id 229F342252;
	Thu, 10 Oct 2024 15:52:25 +0000 (UTC)
From: Fares Mehanna <faresx@amazon.de>
To: <david@redhat.com>
CC: <akpm@linux-foundation.org>, <ardb@kernel.org>, <arnd@arndb.de>,
	<bhelgaas@google.com>, <broonie@kernel.org>, <catalin.marinas@arm.com>,
	<faresx@amazon.de>, <james.morse@arm.com>, <javierm@redhat.com>,
	<jean-philippe@linaro.org>, <joey.gouly@arm.com>,
	<kristina.martsenko@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <mark.rutland@arm.com>, <maz@kernel.org>,
	<nh-open-source@amazon.com>, <oliver.upton@linux.dev>, <ptosi@google.com>,
	<rdunlap@infradead.org>, <rkagan@amazon.de>, <rppt@kernel.org>,
	<shikemeng@huaweicloud.com>, <suzuki.poulose@arm.com>, <tabba@google.com>,
	<will@kernel.org>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH 0/7] support for mm-local memory allocations and use it
Date: Thu, 10 Oct 2024 15:52:10 +0000
Message-ID: <20241010155210.13321-1-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <813b9bcb-afde-40b6-a604-cdb71b4b6d7a@redhat.com>
References: <813b9bcb-afde-40b6-a604-cdb71b4b6d7a@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> > In a series posted a few years ago [1], a proposal was put forward to allow the
> > kernel to allocate memory local to a mm and thus push it out of reach for
> > current and future speculation-based cross-process attacks.  We still believe
> > this is a nice thing to have.
> > 
> > However, in the time passed since that post Linux mm has grown quite a few new
> > goodies, so we'd like to explore possibilities to implement this functionality
> > with less effort and churn leveraging the now available facilities.
> > 
> > An RFC was posted few months back [2] to show the proof of concept and a simple
> > test driver.
> > 
> > In this RFC, we're using the same approach of implementing mm-local allocations
> > piggy-backing on memfd_secret(), using regular user addresses but pinning the
> > pages and flipping the user/supervisor flag on the respective PTEs to make them
> > directly accessible from kernel.
> > In addition to that we are submitting 5 patches to use the secret memory to hide
> > the vCPU gp-regs and fp-regs on arm64 VHE systems.
> 
> I'm a bit lost on what exactly we want to achieve. The point where we 
> start flipping user/supervisor flags confuses me :)
> 
> With secretmem, you'd get memory allocated that
> (a) Is accessible by user space -- mapped into user space.
> (b) Is inaccessible by kernel space -- not mapped into the direct map
> (c) GUP will fail, but copy_from / copy_to user will work.
> 
> 
> Another way, without secretmem, would be to consider these "secrets" 
> kernel allocations that can be mapped into user space using mmap() of a 
> special fd. That is, they wouldn't have their origin in secretmem, but 
> in KVM as a kernel allocation. It could be achieved by using VM_MIXEDMAP 
> with vm_insert_pages(), manually removing them from the directmap.
> 
> But, I am not sure who is supposed to access what. Let's explore the 
> requirements. I assume we want:
> 
> (a) Pages accessible by user space -- mapped into user space.
> (b) Pages inaccessible by kernel space -- not mapped into the direct map
> (c) GUP to fail (no direct map).
> (d) copy_from / copy_to user to fail?
> 
> And on top of that, some way to access these pages on demand from kernel 
> space? (temporary CPU-local mapping?)
> 
> Or how would the kernel make use of these allocations?
> 
> -- 
> Cheers,
> 
> David / dhildenb

Hi David,

Thanks for taking a look at the patches!

We're trying to allocate a kernel memory that is accessible to the kernel but
only when the context of the process is loaded.

So this is a kernel memory that is not needed to operate the kernel itself, it
is to store & process data on behalf of a process. The requirement for this
memory is that it would never be touched unless the process is scheduled on this
core. otherwise any other access will crash the kernel.

So this memory should only be directly readable and writable by the kernel, but
only when the process context is loaded. The memory shouldn't be readable or
writable by the owner process at all.

This is basically done by removing those pages from kernel linear address and
attaching them only in the process mm_struct. So during context switching the
kernel loses access to the secret memory scheduled out and gain access to the
new process secret memory.

This generally protects against speculation attacks, and if other process managed
to trick the kernel to leak data from memory. In this case the kernel will crash
if it tries to access other processes secret memory.

Since this memory is special in the sense that it is kernel memory but only make
sense in the term of the owner process, I tried in this patch series to explore
the possibility of reusing memfd_secret() to allocate this memory in user virtual
address space, manage it in a VMA, flipping the permissions while keeping the
control of the mapping exclusively with the kernel.

Right now it is:
(a) Pages not accessible by user space -- even though they are mapped into user
    space, the PTEs are marked for kernel usage.
(b) Pages accessible by kernel space -- even though they are not mapped into the
    direct map, the PTEs in uvaddr are marked for kernel usage.
(c) copy_from / copy_to user won't fail -- because it is in the user range, but
    this can be fixed by allocating specific range in user vaddr to this feature
    and check against this range there.
(d) The secret memory vaddr is guessable by the owner process -- that can also
    be fixed by allocating bigger chunk of user vaddr for this feature and
    randomly placing the secret memory there.
(e) Mapping is off-limits to the owner process by marking the VMA as locked,
    sealed and special.

Other alternative (that was implemented in the first submission) is to track those
allocations in a non-shared kernel PGD per process, then handle creating, forking
and context-switching this PGD.

What I like about the memfd_secret() approach is the simplicity and being arch
agnostic, what I don't like is the increased attack surface by using VMAs to
track those allocations.

I'm thinking of working on a PoC to implement the first approach of using a
non-shared kernel PGD for secret memory allocations on arm64. This includes
adding kernel page table per process where all PGDs are shared but one which
will be used for secret allocations mapping. And handle the fork & context
switching (TTBR1 switching(?)) correctly for the secret memory PGD.

What do you think? I'd really appreciate opinions and possible ways forward.

Thanks!
Fares.




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

