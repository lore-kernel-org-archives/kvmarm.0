Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F672F5498;
	Wed, 12 Aug 2026 13:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786542343; cv=none; b=ZCEmZmY5ChMTJHmU+zqBpZpUbPmOKdytVkMUJUt2AOR8tdNbtH0moAXS7xWdLKxH9rE9GvPi65o6rUXDtYkHp6h8E85cGY4keHs2Ls5w3yEnyoB/IzaPpJiefacZcAfaoyJlPofqpSGiHMzAc10/VV6sJ7lU8dOJOFEw4QkDDLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786542343; c=relaxed/simple;
	bh=Dmae2hchImuBaj7AEOTmEj6uicvxS19A+J/TxOhSczc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IcpFdcG5K3qyF+YUI9uambeX+8/JWblTSh6kX7PE/NJWqPMS8sFBbGtnJyucuLtr+SWB9ZvM/XWfb32zxGDx41CPiw62npM3CG6oXE708jaR/Ed3FgFS6sZ6/5VZ8QRq97IpDtKAvPDGJHlqTCDL7XQHzHNKppl9N5gEaZXfBhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LpJEWQYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LpJEWQYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD88A1F000E9;
	Wed, 12 Aug 2026 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786542340;
	bh=2D2UytTyVCCTSaKgj888w4OMsi/TDP+60oG0TxSPgjk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LpJEWQYDUauNRIazj3NboFIQsYaibbSbmybL0dWgwYglieJ7fo+1PRVn6tKMTC4YC
	 ICBXKfukOcSlb0pehHMISA5A5FHghk/9aQujs1dn5GSC7C7yz6v8MuSz56k8KuRVpu
	 ds0OkgiHG549Zr3jwkrWxwr5izFu8E+ueexMQ7dNkKaM3dWCdGPouNDTKchvi8vitt
	 aWNTY0v2KYMHUGtpCGpzqaO5kIOrG0s9sAQD4wwZA/U3tSN85Qzb+5l4iKBgAH6btw
	 lBcwrGDiExL5oX69DuBZPs3Lr7DkA41Bn6bpJBgQw3RHdrvl9bRk/uV2a5X23I9r/z
	 nS0M4nA93r+LQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Tarun Sahu
 <tarunsahu@google.com>,  ackerleytng@google.com,  fuad.tabba@linux.dev,
  Andrew Morton <akpm@linux-foundation.org>,  dmatlack@google.com,  Shuah
 Khan <skhan@linuxfoundation.org>,  Jonathan Corbet <corbet@lwn.net>,
  david@redhat.com,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  sagis@google.com,  Paolo Bonzini <pbonzini@redhat.com>,  Mike Rapoport
 <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  linux-kselftest@vger.kernel.org,  andre.przywara@arm.com,
  michael.roth@amd.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  will@kernel.org,  vannapurve@google.com,  maz@kernel.org,
  fvdl@google.com,  kvm@vger.kernel.org,  oliver.upton@linux.dev,
  kvmarm@lists.linux.dev,  alexandru.elisei@arm.com,  skhawaja@google.com,
  aneesh.kumar@kernel.org,  linux-doc@vger.kernel.org,  David Hildenbrand
 <david@kernel.org>,  yan.y.zhao@intel.com,  kexec@lists.infradead.org,
  suzuki.poulose@arm.com
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live
 updates
In-Reply-To: <anssOQFNZ2LfihbU@google.com> (Sean Christopherson's message of
	"Tue, 11 Aug 2026 07:05:45 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-6-tarunsahu@google.com>
	<anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
	<anssOQFNZ2LfihbU@google.com>
Date: Wed, 12 Aug 2026 15:45:33 +0200
Message-ID: <2vxzik5f311e.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Aug 11 2026, Sean Christopherson wrote:

> On Tue, Aug 11, 2026, Pratyush Yadav wrote:
>> On Mon, Aug 10 2026, Sean Christopherson wrote:
>> 
>> > On Tue, Jul 28, 2026, Tarun Sahu wrote:
>> >> Register a Live Update Orchestrator (LUO) file handler for KVM VM files
>> >> to serialize and deserialize VM state across kexec live updates.
>> >> 
>> >> Currently, Only VM type (e.g. arch.vm_type on x86) is preserved as part
>> >> of VM preservation.
>> >
>> > Why?
>> >
>> >> On retrieval, kvm_luo_retrieve() recreates the KVM VM file via
>> >> kvm_create_vm_file() and use an atomically incremented ID for the internal
>> >> fdname, as the final fdname assigned by userspace is not yet known during
>> >> retrieval. As this fdname is only used in debugfs infra, This will not break
>> >> any UAPI.
>> >> 
>> >> This infrastructure establishes the foundation for preserving guest_memfd
>> >> instances across live updates, and can be expanded in the future to
>> >> preserve additional VM state.
>> >
>> > Uh, why guest_memfd?  As much as I want to push guest_memfd adoption, it seems
>> > guest_memfd should be the _last_ thing we support, not the first.  As evidenced
>> > by the last two decades, it's very doable to have KVM VMs without guest_memfd,
>> > but it's rather hard to have VMs without vCPUs.
>> 
>> You _can_ preserve vCPUs today using KVM_{GET,SET}_REGS, they just won't
>> run in the background during the reboot.
>
> What about x86 CoCo VMs?  Which are quite literally _the_ reason guest_memfd was
> created in the first place.  

I don't know much about the history but I thought these days guest_memfd
is used for more than just encrypted memory. I have seen talk of it
being used for non-confidential VMs. For example these patches [0][1][2].

The CoCo parts can follow, but IIUC guest_memfd is being used to back
guest memory on non-CoCo VMs too.

[0] https://lore.kernel.org/all/20250430165655.605595-1-tabba@google.com/
[1] https://lore.kernel.org/all/20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com/
[2] https://lore.kernel.org/all/20250828093902.2719-1-roypat@amazon.co.uk/

>
>> This series can save you from dumping VM memory to disk if it is backed by
>> guest_memfd.
>
> Or to word it another way, one _can_ save guest_memfd, it's just slower.  My

Sure. But making things faster is the entire point of live update.

Guest memory is one piece of that puzzle. Devices are another, and
that's why there is a lot of work going on with VFIO, PCI, and IOMMU
preservation. vCPUs are also a piece, but I think those will be the
hardest to live update.

> point is that this series needs to provide a _lot_ more information about the
> bigger KVM picture.  For those of us that are on the very fringes of live update,
> it's practically impossible to review because, to us, it seems very arbitrary.

That's valid criticism. This series should do a better job of laying out
the high level plan and where things fit.

>
> The part that's especially confusing is the saving of the VM type.  That comes
> straight from userspace, so it's super bizarre to automatically save/restore that,
> but nothing else.
>
>> >> +KVM LIVE UPDATE
>> >> +M:	Pasha Tatashin <pasha.tatashin@soleen.com>
>> >> +M:	Mike Rapoport <rppt@kernel.org>
>> >> +M:	Pratyush Yadav <pratyush@kernel.org>
>> >> +R:	Tarun Sahu <tarunsahu@google.com>
>> >> +L:	kexec@lists.infradead.org
>> >> +L:	kvm@vger.kernel.org
>> >> +S:	Maintained
>> >> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
>> >
>> > NAK on taking changes through a different tree.  This is KVM code, period.
>> >
>> > In general, I'm skeptical of the dedicated MAINTAINERS entry.  It's extremely
>> > difficult to tell since this series is little more than a skeleton (either that
>> > or liveupdate is way simpler that I was expecting), but I suspect that maintaining
>
> ...
>
>> > E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
>> > is going to be in knowing what to save/restore, and how, which is much more about
>> > KVM than it is about liveupdate.
>> 
>> I think it is fine if you want to take these changes through the KVM
>> tree, but I would like live update maintainers to be listed as reviewers
>> at least.
>
> Why not simply add a file pattern match to the LIVE UPDATE entry?
>
> diff --git MAINTAINERS MAINTAINERS
> index 8014b9f8253e..2eb57b22c37f 100644
> --- MAINTAINERS
> +++ MAINTAINERS
> @@ -15052,8 +15052,8 @@ F:      include/linux/liveupdate.h
>  F:     include/uapi/linux/liveupdate.h
>  F:     kernel/liveupdate/
>  F:     lib/tests/liveupdate.c
> -F:     mm/memfd_luo.c
>  F:     tools/testing/selftests/liveupdate/
> +N:     [^a-z]luo
>  
>  LLC (802.2)
>  L:     netdev@vger.kernel.org

This would list us as maintainers of kvm_luo.c and the tree as
liveupdate.git, both of which is something you're saying you _don't_
want.

>
>> At the same time, I also keep being (pleasantly)
>> surprised at preservation being relatively simple. For example, the code
>> to preserve a shmem file (via memfd) is roughly 600 lines, a big chunk
>> of which is comments. The code of course has some limitations, but it is
>> good enough for use in production.
>> 
>> For one, we care about ABI breakages and versioning. 
>
> Which is amusing to me because that implies KVM does not, and I would hazard to

No, it doesn't. What I'm saying is I care about changes to the _live
update ABI_. Just like you probably care about changes to KVM ABI but
not so much about BPF for example.

> guess that KVM has the biggest ABI surface of any subsystem in the kernel by a
> country mile (though I'm probably wildly underestimating the effective ABI surface
> of filesystems).
>
>> The serialized state is a part of live update ABI and changes to it should be
>> ACKed by us. 
>
> Meh, "Don't break userspace" is a universal rule in the kernel, I genuinely don't
> see why liveupdate needs special treatment.

Ironically enough, you miss my point. I'm not talking about userspace
ABI. We all know not to break that. I am talking about live update
_serialization ABI_. See the stuff under include/linux/kho/abi. This
series also adds things there.

This is ABI between kernels. It needs to be stable-ish so you can move
from one kernel version to another. At the same time, unlike userspace
ABI, it can change. Today we don't have any rules and let you change
things freely as long as you do a version bump. But at a later point,
the plan is to add some stability requirements to the ABI so you can
actually upgrade the kernel across major versions.

So at least for ABI changes, there should be an explicit ACK from the
live update group. For code changes, I'd be flexible if you'd prefer
that. More on it below.

>
>> For another, how the file handlers interact with their dependencies can
>> affect the behaviour that VMMs observe. Those changes should also pass by
>> some live update eyes.
>
> Perhaps in the short term, but IMO, that's not a winning strategy in the long
> term.  From my perspective, that like saying the PAGE CACHE maintainers should
> review every usage of the filemap APIs, because how the APIs are used impacts
> the page cache and affects userspace-visible behavior.  There are myriad analogies
> like that throughout the kernel.

I've heard kernel maintainers complain many times about people or
companies throwing code over the wall and not staying around to deal
with the mess it might make.

I'd like to avoid that with live update and help you maintain this. As
you've said, you are not as familiar with live update, and perhaps you
might not even be as interested in it. So why not let the people who are
help review the code?

Ultimately it is your subsystem so it is your call. And as I've said
before, if you want to take it through the KVM tree and have a veto I
think that is perfectly fine.

As an alternate example, with memfd_luo, the MM folks are rarely
involved and the maintenance and review is done largely by me because I
wrote that code. Mainly because the contents in memfd_luo.c are all live
update related and don't matter much to core MM or memfd. I have heard
similar desire for the HugeTLB live update work I am doing.

We can figure out what works best for KVM.

>
> Yes, liveupdate is new and shiny, but IMO for it to be successful and maintainable,
> it needs to be treated like any other core infrastructure in the kernel, not a
> special snowflake whose details are known only by a handful of people.  Because
> I think it's likely liveupdate goes one of two ways: either liveupdate becomes a
> very niche thing that is used sparingly throughout the kernel, or it becomes a
> broadly used feature that is supported by many filesystems and subsystems.
>
> If liveupdate is relegated to niche status, then it probably isn't going to see
> a significant amount of ongoing development, at which point the folks working on
> liveupdate will naturally migrate to other projects, and maintenance will largely
> be left to subsystem maintainers.
>
> If liveupdate is broadly used, then having a single group of people maintain
> every subsystem's usage won't scale, and maintenance will again largely fall on
> the shoulder of subsystem maintainers.  Which is totally fine and working as
> intended, because that's exactly what subystem maintainers are signing up for
> by merging support for liveupdate.

-- 
Regards,
Pratyush Yadav
