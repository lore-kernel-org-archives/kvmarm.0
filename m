Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1539F2DC78D
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 17:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767979886; cv=none; b=iErTdUYu/sRFBVmIqKym300BQnm5hcQI46SKjmxeBIVffV44VRny1OykWRkYRN9fw5fqqFns4pW+lk7A4AE3MrZ+x39tPeGeBn8cgo5z7Lzr3Fg6RsF7BKnVZPLeAFInK5ff5QH0gersaWmJYYX0HX/d2/JtehacWOToVrIdl2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767979886; c=relaxed/simple;
	bh=BrZ9A58ydXdyMMAnrrNnZo68A5Ff3iX5K/JBi/tnrjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LaSBaPlBFuVHrInBimAS8H6iYvmcgPpW3hCKGe1xipfHs5muYfQZC1+TjXEo5ImMS0Yfe3ZOyQ64ITGzsTUIuq2gfw7AXAI3/utbuo03sxO9MmxXzRmjO33qgMw5qDo6gA6ONtWWZJRCoMl+Py8VFBCdXbQdEOg7am5Vofbip+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOXJ/P1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOXJ/P1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590D0C4CEF1;
	Fri,  9 Jan 2026 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767979885;
	bh=BrZ9A58ydXdyMMAnrrNnZo68A5Ff3iX5K/JBi/tnrjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jOXJ/P1JA9vHZ+0rqhvHKoGBET45H1OPkIafPVChNqBzofTVFmK91WygRgCQUThua
	 JQAbbpe4GYFaI17tc2hwJrsX+q+c5upCis5cq5mg4Y8ofI61+DQo6TKuow7jc1fCuh
	 rZ1v8o30LU9v17mOzw+BV3XGZwwUgXQwFPqUAFSO2T9lzkhOtvY/3WrDuDaNcMMBhu
	 cVyOQPSH4AIYQq5nilwnkygfjv9DPk8QbBPhzbZUOCZyQgc+iUSuEQzs3FRrKIJt7h
	 3zalE4G523yzGkFLj7QzVz0jQwLlP7VgJ9w2WBzFvkNu3O9dgI4XQ6QUGouzGhF/vA
	 h2If3WfqcI6qw==
Date: Fri, 9 Jan 2026 17:31:20 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 02/30] KVM: arm64: Remove redundant 'pgt' pointer checks
 from MMU notifiers
Message-ID: <aWE7aMOqQUUAyi3X@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-3-will@kernel.org>
 <7g66xbfmfqf67qcowjuu725h3l33ecxhkffmlzxsjtbusk5eor@khlpkp7jdfzr>
 <aWERVxw-57pzi6ko@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWERVxw-57pzi6ko@willie-the-truck>

WARNING: long and boring reply, but I might find this helpful in future
so I'm sending it anyway. The short answer is, you're right and this
patch is busted :)

On Fri, Jan 09, 2026 at 02:31:51PM +0000, Will Deacon wrote:
> On Tue, Jan 06, 2026 at 02:32:12PM +0000, Quentin Perret wrote:
> > On Monday 05 Jan 2026 at 15:49:10 (+0000), Will Deacon wrote:
> > > The MMU notifiers are registered by kvm_init_mmu_notifier() only after
> > > kvm_arch_init_vm() has returned successfully. Since the latter function
> > > initialises the 'kvm->arch.mmu.pgt' pointer (and allocates the VM handle
> > > when pKVM is enabled), the initialisation checks in the MMU notifiers
> > > are not required.
> > 
> > It took me a while to remember, but I think these checks are needed for
> > the free path rather than init. In particular, the doc for
> > mmu_notifier_ops::release() (from which we free the pgt) says that it
> > "can run concurrently with other mmu notifier" (see mmu_notifier.h), which
> > is fun.
> > 
> > Had you considered that path? If so, probably worth expanding in the
> > commit description why this is safe?
> 
> 
> Urgh....
> 
> Let me get back to you on that :)

Ok, so the 'pgt' is set to NULL by kvm_free_stage2_pgd() with
'kvm->mmu_lock' held for write. There are three notifier callbacks that
I'm changing not to check for a NULL pgt:

1. kvm_unmap_gfn_range()
	=> Runs with the MMU lock held for write. See how
	kvm_mmu_notifier_invalidate_range_start() calls
	kvm_handle_hva_range() with '.lockless' unset (i.e. false) in
	'hva_range'

2. kvm_age_gfn()
	=> Takes the lock unless KVM_MMU_LOCKLESS_AGING, which isn't
	selected for arm64

3. kvm_test_age_gfn()
	=> Same as above.

so I think that means we're serialised with teardown.

Looking at it a different way, suppose that the notifiers *could* run
concurrently with kvm_free_stage2_pgd(). In that case, the check of the
pgt wouldn't buy us anything because the pgt could be cleared (and the
page-table freed) right after we checked that it wasn't NULL but before
we tried touching the page-table.

The next question is whether we can simply run _after_ the page-table
teardown?

For the usual teardown case via exit_mmap(), it looks pretty hard to
trigger since the release notifier is only called once 'mm_users' hits
zero and the 'mm' has been NULLified.

The more obvious case is when the release notifier is run from
mmu_notifier_unregister() by kvm_destroy_vm(). In this case, there's a
synchronize_srcu() but only _after_ calling ->release() and so there is
a small window where another notifier could run into the NULL pgt.

I hacked in an mdelay(5000) between calling ->release and removing
the MMU notifier subscription and then bodged kvmtool to use
MAP_POPULATE for guest memory and to close the VM fd after creating the
memslots. Sure enough, that was enough to trigger the crash (see below).

So I'll rework this patch to preserve the NULL checks on the pgt but
I'll keep the part moving the handle check out of
__pkvm_pgtable_stage2_unmap(), as the handle is cleared by
kvm_arch_destroy_vm() after the notifiers really have gone away.

Cheers,

Will

--->8

[ 1607.241011] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[ 1607.241145] Mem abort info:
[ 1607.241395]   ESR = 0x0000000096000004
[ 1607.241441]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 1607.241597]   SET = 0, FnV = 0
[ 1607.241618]   EA = 0, S1PTW = 0
[ 1607.241643]   FSC = 0x04: level 0 translation fault
[ 1607.241686] Data abort info:
[ 1607.241711]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[ 1607.241733]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[ 1607.241759]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[ 1607.241883] user pgtable: 4k pages, 52-bit VAs, pgdp=00000000400ad400
[ 1607.241915] [0000000000000000] pgd=080000004550e403, p4d=0000000000000000
[ 1607.242828] Internal error: Oops: 0000000096000004 [#1]  SMP
[ 1607.246029] Modules linked in:
[ 1607.246394] CPU: 0 UID: 0 PID: 51 Comm: kswapd0 Not tainted 6.19.0-rc4-00030-g93ba3d7c3693-dirty #3 PREEMPT 
[ 1607.246823] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
[ 1607.247213] pstate: 81402009 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[ 1607.247584] pc : kvm_pgtable_walk+0x54/0x150
[ 1607.247988] lr : kvm_pgtable_stage2_test_clear_young+0x48/0x80
[ 1607.248434] sp : ffff800080463510
[ 1607.248717] x29: ffff800080463540 x28: fff0000004512488 x27: 0000000000000001
[ 1607.249129] x26: fff0000001241d50 x25: 0000ffff869fffff x24: 0000ffff86800000
[ 1607.249455] x23: 0000000082400000 x22: 0000000082200000 x21: 0000000000000001
[ 1607.249796] x20: 0000000000000000 x19: ffff800080463588 x18: ffff9bea62668cc0
[ 1607.250154] x17: 001ada185af13066 x16: 0000000000000028 x15: ffffc1ffc0000000
[ 1607.250500] x14: 0010000000000000 x13: 0000ffff86800000 x12: 0000000000080000
[ 1607.250827] x11: 0000000000080000 x10: 0000ffff84600000 x9 : 0000000000000001
[ 1607.251186] x8 : 0000000082400fff x7 : 0c8a13c0ffff8660 x6 : 0c8a43e0ffff867f
[ 1607.251731] x5 : fff00000070fa1c0 x4 : 0000000000000000 x3 : ffff800080463588
[ 1607.252312] x2 : 0000000000200000 x1 : 0000000082200000 x0 : 0000000000000000
[ 1607.252719] Call trace:
[ 1607.252909]  kvm_pgtable_walk+0x54/0x150 (P)
[ 1607.253133]  kvm_pgtable_stage2_test_clear_young+0x48/0x80
[ 1607.253391]  kvm_age_gfn+0x44/0x88
[ 1607.253580]  kvm_mmu_notifier_clear_flush_young+0xc4/0x240
[ 1607.253842]  __mmu_notifier_clear_flush_young+0xa0/0xb0
[ 1607.254096]  folio_referenced_one+0x260/0x3b8
[ 1607.254312]  rmap_walk_anon+0x148/0x1d4
[ 1607.254501]  folio_referenced+0x118/0x200
[ 1607.254691]  shrink_folio_list+0x3c8/0x1100
[ 1607.254896]  shrink_lruvec+0x720/0xbec
[ 1607.255122]  shrink_node+0x4cc/0x8e4
[ 1607.255311]  balance_pgdat+0x488/0x77c
[ 1607.255521]  kswapd+0x260/0x2e0
[ 1607.255691]  kthread+0x1bc/0x200
[ 1607.255898]  ret_from_fork+0x10/0x20
[ 1607.256326] Code: 9274cd17 a901dff6 36180049 9402bc60 (b9400288) 
[ 1607.257126] ---[ end trace 0000000000000000 ]---

