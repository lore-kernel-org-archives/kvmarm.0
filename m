Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1097032F76D;
	Sat, 15 Aug 2026 10:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786790645; cv=none; b=h80jnSMO4LK84V05f1i2TY2bsCtDG2kW/ZJ8Dgebk4myi85eqvyCh1uiVxQoVBv+ZQrDJLYeq+sL4BpBnj1p6r+1AYL3wp+UZHVn2yG/kapYnhskjV/ClWoNKEyUxhkGqS+0HQCmVa/w0pPfjOoqhCGNRrIxpMiN99UeEBnLgKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786790645; c=relaxed/simple;
	bh=nQZrTvfC6EO03hbr3kZVz+TiErP5GDAhGHqxIztZ+F4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=acQUANAnaCf/H3FU/G+hhHgAuSWWqUpRZV9StdyciiQsysZ4bUpzLkzGA9kChZ8xvUBsXH6DQosauvlbCwVBzjPlWouO+lrot6F4xrf8aq6RxjCcsNxwrdzZOt9gHxWsQEiYMV6bP/4x6dpt5qBcd6xDX69MPpBtE828uybni5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kr/Tf5ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kr/Tf5ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D271F000E9;
	Sat, 15 Aug 2026 10:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786790643;
	bh=EHN97m9JW2ZgHxLPFLcOKL8ZOHela7pDZzqoNJfQP5E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kr/Tf5ckh5K3hOdAtZRNaMYJfcRPbGlwjMHHlS0bf7W+6jLe5uTUgjrP9S+5f/IC/
	 Ka/suzsag9pVo5MAFE5sUh0OdSOq15rVwKacT8p8g/2vLXGvNF6wyqDL/oQEHFwKNE
	 uW0VRb45EN4jcoJ7gWykJKxHTXlr/mPQcjZ/7sibTUOtZlTPD7FkwaCSvI56oP4lze
	 WYAMKxEpRdAEdaOxik7UE4xE+40VQZc/EdlggdhzMRACQMooZmNlts0xGE/K0+tEkl
	 Xm1O4rjqoZBEa8az6uvNKeelMuWGoGXGMg4E4Z8cRr209WzF2prepZEjHbJND/nln1
	 63kwlbLLevOoQ==
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
In-Reply-To: <anyObKiZIhfok5mk@google.com> (Sean Christopherson's message of
	"Wed, 12 Aug 2026 08:17:00 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-6-tarunsahu@google.com>
	<anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
	<anssOQFNZ2LfihbU@google.com> <2vxzik5f311e.fsf@kernel.org>
	<anyObKiZIhfok5mk@google.com>
Date: Sat, 15 Aug 2026 12:43:56 +0200
Message-ID: <2vxzqzjz1x5f.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Aug 12 2026, Sean Christopherson wrote:

> On Wed, Aug 12, 2026, Pratyush Yadav wrote:
>> On Tue, Aug 11 2026, Sean Christopherson wrote:
[...]
> But that's all beside the point.  What I'm saying is that SNP and TDX *must* use
> guest_memfd, whereas guest_memfd is optional for all other VM types.  And so adding
> LUO support for guest_memfd without even sketching out a plan for CoCo VMs feels
> backwards.
>
> I'm not necessarily opposed to gradual guest_memfd support, but there needs to be
> a clear plan of how all of this is going to fit together.  It doesn't need to be
> perfect, and I'm sure we'll make mistakes along the way, but I want to at least
> try not to paint ourselves into a corner, especially with respect to the ABI.

Right. I think landing shared guest_memfd is the first step. It is
simple enough and doesn't need to preserve the more complicated
architecture specific things like secure EPT, etc. The CoCo support
can build on top of this.

There is work underway already for an RFC of TDX live update, but Tarun
knows the details better than me so I'll let him fill in the details for
the next version of this series.

>
>> >> > E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
>> >> > is going to be in knowing what to save/restore, and how, which is much more about
>> >> > KVM than it is about liveupdate.
>> >> 
>> >> I think it is fine if you want to take these changes through the KVM
>> >> tree, but I would like live update maintainers to be listed as reviewers
>> >> at least.
>> >
>> > Why not simply add a file pattern match to the LIVE UPDATE entry?
>> >
>> > diff --git MAINTAINERS MAINTAINERS
>> > index 8014b9f8253e..2eb57b22c37f 100644
>> > --- MAINTAINERS
>> > +++ MAINTAINERS
>> > @@ -15052,8 +15052,8 @@ F:      include/linux/liveupdate.h
>> >  F:     include/uapi/linux/liveupdate.h
>> >  F:     kernel/liveupdate/
>> >  F:     lib/tests/liveupdate.c
>> > -F:     mm/memfd_luo.c
>> >  F:     tools/testing/selftests/liveupdate/
>> > +N:     [^a-z]luo
>> >  
>> >  LLC (802.2)
>> >  L:     netdev@vger.kernel.org
>> 
>> This would list us as maintainers of kvm_luo.c and the tree as liveupdate.git, 
>
> It would list both "LIVE UPDATE" and "KERNEL VIRTUAL MACHINE (KVM)", as KVM would
> still cover the files via "F:	virt/kvm/*".  And my read of MAINTAINERS is that
> N: and K: entries are "secondary" if the files/scope is covered by an F: entry.
>
> E.g. arch/x86/kvm/vmx/tdx.c is covered by "KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)"
> via "F:	arch/x86/kvm/*/", and also by "X86 TRUST DOMAIN EXTENSIONS (TDX)" via
> "N:	tdx" (or maybe "K:	\b(tdx)"?  I haven't bothered to check which one
> triggers).  And while I don't think there was ever any formal discussion, AFAIK
> everyone reads the situation as KVM still being the primary maintainer/tree for
> that code.
>
>> both of which is something you're saying you _don't_ want.
>
> No, what I don't want is a dedicated "KVM LIVE UPDATE" entry, because I think most
> people would read "F:     virt/kvm/kvm_luo.c" and "F:     virt/kvm/guest_memfd_luo.c"
> as being more precise than KVM's "F:   virt/kvm/*" and thus would read things as
> "KVM LIVE UPDATE" being the primary maintainer.
>
> In other words, I'm more than ok with LUO being looped in on KVM LUO changes and
> having the authority to object to problematic changes, but I'm not ok with LUO
> taking primary ownership of KVM code.

Sure, that sounds good to me.

>
> I realize there's more than a bit of nuance in my interpretation of N: and K:,
> but again my experience with TDX is that so long as the maintainers are aligned
> on expectations, it's a non-issue in practice.

Yep, as long as we agree among ourselves I don't think the red tape
around which entry has higher priority matters much.

>
>> >> At the same time, I also keep being (pleasantly)
>> >> surprised at preservation being relatively simple. For example, the code
>> >> to preserve a shmem file (via memfd) is roughly 600 lines, a big chunk
>> >> of which is comments. The code of course has some limitations, but it is
>> >> good enough for use in production.
>> >> 
>> >> For one, we care about ABI breakages and versioning. 
>> >
>> > Which is amusing to me because that implies KVM does not, and I would hazard to
>> 
>> No, it doesn't. What I'm saying is I care about changes to the _live
>> update ABI_. Just like you probably care about changes to KVM ABI but
>> not so much about BPF for example.
>> 
>> > guess that KVM has the biggest ABI surface of any subsystem in the kernel by a
>> > country mile (though I'm probably wildly underestimating the effective ABI surface
>> > of filesystems).
>> >
>> >> The serialized state is a part of live update ABI and changes to it should be
>> >> ACKed by us. 
>> >
>> > Meh, "Don't break userspace" is a universal rule in the kernel, I genuinely don't
>> > see why liveupdate needs special treatment.
>> 
>> Ironically enough, you miss my point. I'm not talking about userspace
>> ABI. We all know not to break that. I am talking about live update
>> _serialization ABI_. See the stuff under include/linux/kho/abi. This
>> series also adds things there.
>
> No, I understand exactly what ABI you're talking about.
>
>> This is ABI between kernels. It needs to be stable-ish so you can move
>> from one kernel version to another. At the same time, unlike userspace
>> ABI, it can change.
>
> Uh, yeah, so KVM has been managing such immutable ABI for practically its entire
> existence.  KVM's save/restore uAPI has exactly what you're describing: serialization
> ABI that needs to be backwards and forwards compatible between different kernels
> in order to support both upgrade and rollback scenarios via live migration.

I think there is a slight difference between KVM's save/resture uAPI and
live update's ABI. With KVM's uAPI, you need to maintain strict
backwards compatibility because userspace reads what you output. So if
you change the layout, userspace will interpret it wrong and might
break.

With live update, the ABI never gets to userspace. It is used to talk
between kernels directly. So if you do break that, your userspace keeps
working fine, you just might not be able to live update to the
incompatible kernel.

So with live update, we don't need to keep backwards compatibility in
the ABI forever. Of course, it is good to minimize changes, but we have
more freedom to change it.

The current idea is we change the ABI whenever needed. This is because
live update is still in development so we are likely to see a lot more
changes before we settle down into something that mostly works. At some
point, we want to start being more strict between incompatible ABI
changes. The current idea is that we would like to keep backwards
compatibility across LTS kernels. But none of that is set in stone yet.

That's why I would like to have an explicit ACK from the live update
group for ABI changes. I would like to enforce these compatibility
windows.

>
> KVM also has immutable ABI between itself and guest kernels, including implicit
> "ABI" in the form of not changing guest-visible behavior.
>
>> Today we don't have any rules and let you change things freely as long as you
>> do a version bump. But at a later point, the plan is to add some stability
>> requirements to the ABI so you can actually upgrade the kernel across major
>> versions.
>> 
>> So at least for ABI changes, there should be an explicit ACK from the
>> live update group.
>
> I don't entirely agree.  I get where you're coming from, and I 100% agree that
> the more eyeballs on changes that may affect ABI, the better.
>
> Where I have problems with the above is that it doesn't account for the nuances
> of save/restore across different kernels.  The literal format of the serialized
> data is the most obvious form of ABI, but it's absolutely possible to change ABI
> without changing the data format.
>
> E.g. say there's a flags field in some serialization structure, and flags X and Y
> are mutually exclusive in current kernels.  If a future kernel relaxes that
> restriction for whatever reason, then the effective ABI has been broken because
> state created and saved on new kernels can't be restored on old kernels.  And
> this is not a theoretical concern, KVM has run afoul of this a few times (though
> thankfully very rarely).

That's a bug, and should be fixed.

I am talking here about intentional ABI changes. As I mentioned above we
_can_ change the ABI, we just need to be careful about it.

>
> I don't think it's reasonable to expect LUO maintainers to gain enough expertise
> in each subsystem to be able to ensure changes are forwards and backwards
> compatible.  The only way I see LUO being successful in the long term is to get
> subsystem maintainers/contributors to understand *and buy-in* to the LUO model
> and rules, so that each subsystem can largely be self-sustatining.  I.e. setting
> yourselves up as literal gatekeepers will help prevent blatant breakage, but it's
> less likely to help guard against more subtle breakage, and in my experience,
> subtle breakage is by far harder to detect and more painful to deal with.

Outside of enforcing the ABI compatibility windows, I think this makes
sense.

In principle at least, though from my experience the maintainer appetite
to care about live update varies. The feeling I've got from MM for
example is more along the lines of "you break it, you buy it". Which is
also a valid model IMO. The person who wrote the live update code for a
subsystem is well equipped to understand these nuances.

>
> Somewhat of a side topic: in my experience, using monotonically increasing version
> numbers is a horrible way to enumerate features/content.  So for me, allowing
> KVM's LUO ABI to change with a verson bump is probably a non-starter.  I.e.
> whatever gets merged needs to be more future-proof than "we'll deal with it later".

As I wrote above, the compatibility model for live update allows
breaking ABI with version bumps. Userspace keeps working fine, it only
restricts the set of kernels that you can go to. So the "we'll deal with
it later" is not as harmful because our choices here are not permanent.

Also, there is work underway to allow transitions between versions [0].

But still, I am not opposed to a more flexible guest_memfd ABI. I think
we can reserve some space for feature flags to let us add things in the
future.

[0] https://lore.kernel.org/kexec/20260731215224.831696-1-loganodell@google.com/

-- 
Regards,
Pratyush Yadav
