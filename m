Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69057471CEE
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787066940; cv=none; b=GHaGT3jf6ihVxvTaKKxC6XNQ8HNeqEHSLM3S+DvmYpMUBhHKZu7pHTU3gyXICmzFTGaV9kA1uz2yU60MGkO2XfAOe3YITMIo66OdV3LUlMIDbNPy6oI/tlwLk0hRJjflz41dVzcVng9rPGcLk6/4VkDhbQjylO4Y2RJnhNO15uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787066940; c=relaxed/simple;
	bh=WpotjfIgWZsgcEPpZdpCYdJlrUAim1GcgkLdwoPRpjo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cy51ZQk/GZaMy6w8KAiN2UkPNtlD7gqixIk005qFAs5wO678uNiPbvqGvSIxeutefGmQpUkqEnGrVKwF5qajNUKi1Sd9U3yOe8SuBg1Jc4b6iW7tGB5Ax5sN/moIvm6eGOv3LSoixr24vWcfP6ke25zg9T/35LiiNUPjZ04NGIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KB3arowr; arc=none smtp.client-ip=209.85.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KB3arowr"
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a1b48b4528so5147646a12.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 08:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787066937; x=1787671737; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MCqv9FjqzX9J6sE+mm4dR8DQFjLQZx0WW3HAG/YPlNE=;
        b=KB3arowrTlSyJtPe/lBnQbl7dZpNnq5qqCvFLSo/CyvJuHY1nJzZnOjT4iqeItTVCy
         38htClOj8hQgHBA0rUAG3I4ioIPZ/zF8QyY4JMx2IxqxibE0Xv6GGAXUmteJJnzYMf/f
         iMTwM8gm8xJz56u/Mc3Kg0WHR7ZaFgAueeXJ2GkDQQKpk0SIkbKxWKEtwkSLghmUkzcx
         PC1h1+DTK7UT+0uvCMxgdDWCVbHjVWlnb1f/oTRccLtDn30e623Qu2DVeq8FK83E6E37
         RKebm9fmVgtH0Q8Yhx0/gS8QO49T1H3KaBfeaE7+nUC2gm19JBU7l8rVN4rWug0T1tge
         gn9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787066937; x=1787671737;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MCqv9FjqzX9J6sE+mm4dR8DQFjLQZx0WW3HAG/YPlNE=;
        b=iwGr7hnOhBvRKRozSwk/7RfYnaKi1u86llcclQNsGVc/R1VLfUI2Ayi04tApih4gIa
         40Fedpz2FTCHldrgQSxDBb+QjR99Rmw1AEwHiWP2fyTWihmL43n5mkL5h32ZQ2mRvpEo
         PjpE2i8N8SFJjlbgFt/9p1ybkW2j8pJjCKCq3+6fflIN1AiuYl38LVVLqLXKt/68E//5
         pXPs9UEDduh/ciKVMwCDNJcwMxtIiGJ+mpml+hIJqszCgVgoFvY57QNOe2QzhnmpRAnU
         bS/+ytuY97CYtTd3997aE3/0rGhJZBWW0wcCaz63XAfl30X8nh8oi2hb8btue2GFmKbJ
         HfHg==
X-Forwarded-Encrypted: i=1; AHgh+RrujU/U/xD/A/PB/nVu4tQpGh2NDkccLjuyz0+vD3DDrbrRb7Q3GhBN1iFd4XYJ1CzGCoyDzXc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyt0onbtV7qdYQ8RQw/fz/tgl0IB5v65QVGCN7Cr7OkUlEOiLAG
	cz9xbrIz5Jkqembl3vNptsVRidCbEAOxtnVuStblZYAEUg2IyR0WnLr0P3VlWxCDz16Vobc8J1X
	0Ax56gg/NwGGFhpLQWg==
X-Received: from edru23.prod.google.com ([2002:aa7:d557:0:b0:6a1:f3cf:4285])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:c1d6:b0:6a3:9e00:8ed2 with SMTP id 4fb4d7f45d1cf-6a39e008fb0mr9583691a12.16.1787066936333;
 Tue, 18 Aug 2026 08:28:56 -0700 (PDT)
Date: Tue, 18 Aug 2026 15:28:55 +0000
In-Reply-To: <2vxzqzjz1x5f.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-6-tarunsahu@google.com> <anphyjFv3FhF61iB@google.com>
 <2vxzpkzo51wg.fsf@kernel.org> <anssOQFNZ2LfihbU@google.com>
 <2vxzik5f311e.fsf@kernel.org> <anyObKiZIhfok5mk@google.com> <2vxzqzjz1x5f.fsf@kernel.org>
Message-ID: <9huzv797v45k.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live updates
From: tarunsahu@google.com
To: Pratyush Yadav <pratyush@kernel.org>, Sean Christopherson <seanjc@google.com>, loganodell@google.com
Cc: Pratyush Yadav <pratyush@kernel.org>, ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Pratyush Yadav <pratyush@kernel.org> writes:

> On Wed, Aug 12 2026, Sean Christopherson wrote:
>
>> On Wed, Aug 12, 2026, Pratyush Yadav wrote:
>>> On Tue, Aug 11 2026, Sean Christopherson wrote:
> [...]
>> But that's all beside the point.  What I'm saying is that SNP and TDX *must* use
>> guest_memfd, whereas guest_memfd is optional for all other VM types.  And so adding
>> LUO support for guest_memfd without even sketching out a plan for CoCo VMs feels
>> backwards.
>>
>> I'm not necessarily opposed to gradual guest_memfd support, but there needs to be
>> a clear plan of how all of this is going to fit together.  It doesn't need to be
>> perfect, and I'm sure we'll make mistakes along the way, but I want to at least
>> try not to paint ourselves into a corner, especially with respect to the ABI.
>
> Right. I think landing shared guest_memfd is the first step. It is
> simple enough and doesn't need to preserve the more complicated
> architecture specific things like secure EPT, etc. The CoCo support
> can build on top of this.
>
> There is work underway already for an RFC of TDX live update, but Tarun
> knows the details better than me so I'll let him fill in the details for
> the next version of this series.

Right, I am keeping things minimal for this version just addressing the
non-cocovm guest_memfd to be preserved. On top of it, We will buidl
support for the cocoVM preservation. And Sagi (sagis@google.com) is
already working on it.

Why not implement both in the same series:
1. This series focus on finalizing the design, How guest_memfd will be
preserved, So Any user (Not now) but in future will use guest_memfd in
non cocoVM case, This alone feature will be used.

2. guest_memfd cocoVM preservation support will be built on top of
in-place conversion series and I preferred not to complicate two topics
in single series, Instead to develop gradually.

I agree to your answer for have Borader Roadmap. I tried to answer in
Cover-letter. Which I am re-stating it here:

This series support guest_memfd preservation for non-COCOVM only. cocoVM
Support will be built on top of that. Which includes the following
stages.
non cocoVM guest_memfd preservation -> TDX preservation -> in-place
convertable private guest_memfd preservation -> in-place convertable
private guest_memfd preservation backed by hugetlb.

End Goal is to support guest_memfd preservation on cocoVM backed by
hugetlb.

The question remains:
Why we are preserving KVM and only vm_type there.

I will try to answer this on the thread of VM preservation to not loose
the context.

>
>>
>>> >> > E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
>>> >> > is going to be in knowing what to save/restore, and how, which is much more about
>>> >> > KVM than it is about liveupdate.
>>> >> 
>>> >> I think it is fine if you want to take these changes through the KVM
>>> >> tree, but I would like live update maintainers to be listed as reviewers
>>> >> at least.
>>> >
>>> > Why not simply add a file pattern match to the LIVE UPDATE entry?
>>> >
>>> > diff --git MAINTAINERS MAINTAINERS
>>> > index 8014b9f8253e..2eb57b22c37f 100644
>>> > --- MAINTAINERS
>>> > +++ MAINTAINERS
>>> > @@ -15052,8 +15052,8 @@ F:      include/linux/liveupdate.h
>>> >  F:     include/uapi/linux/liveupdate.h
>>> >  F:     kernel/liveupdate/
>>> >  F:     lib/tests/liveupdate.c
>>> > -F:     mm/memfd_luo.c
>>> >  F:     tools/testing/selftests/liveupdate/
>>> > +N:     [^a-z]luo
>>> >  
>>> >  LLC (802.2)
>>> >  L:     netdev@vger.kernel.org
>>> 
>>> This would list us as maintainers of kvm_luo.c and the tree as liveupdate.git, 
>>
>> It would list both "LIVE UPDATE" and "KERNEL VIRTUAL MACHINE (KVM)", as KVM would
>> still cover the files via "F:	virt/kvm/*".  And my read of MAINTAINERS is that
>> N: and K: entries are "secondary" if the files/scope is covered by an F: entry.
>>
>> E.g. arch/x86/kvm/vmx/tdx.c is covered by "KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)"
>> via "F:	arch/x86/kvm/*/", and also by "X86 TRUST DOMAIN EXTENSIONS (TDX)" via
>> "N:	tdx" (or maybe "K:	\b(tdx)"?  I haven't bothered to check which one
>> triggers).  And while I don't think there was ever any formal discussion, AFAIK
>> everyone reads the situation as KVM still being the primary maintainer/tree for
>> that code.
>>
>>> both of which is something you're saying you _don't_ want.
>>
>> No, what I don't want is a dedicated "KVM LIVE UPDATE" entry, because I think most
>> people would read "F:     virt/kvm/kvm_luo.c" and "F:     virt/kvm/guest_memfd_luo.c"
>> as being more precise than KVM's "F:   virt/kvm/*" and thus would read things as
>> "KVM LIVE UPDATE" being the primary maintainer.
>>
>> In other words, I'm more than ok with LUO being looped in on KVM LUO changes and
>> having the authority to object to problematic changes, but I'm not ok with LUO
>> taking primary ownership of KVM code.
>
> Sure, that sounds good to me.
>
>>
>> I realize there's more than a bit of nuance in my interpretation of N: and K:,
>> but again my experience with TDX is that so long as the maintainers are aligned
>> on expectations, it's a non-issue in practice.
>
> Yep, as long as we agree among ourselves I don't think the red tape
> around which entry has higher priority matters much.

Agree!
>
>>
>>> >> At the same time, I also keep being (pleasantly)
>>> >> surprised at preservation being relatively simple. For example, the code
>>> >> to preserve a shmem file (via memfd) is roughly 600 lines, a big chunk
>>> >> of which is comments. The code of course has some limitations, but it is
>>> >> good enough for use in production.
>>> >> 
>>> >> For one, we care about ABI breakages and versioning. 
>>> >
>>> > Which is amusing to me because that implies KVM does not, and I would hazard to
>>> 
>>> No, it doesn't. What I'm saying is I care about changes to the _live
>>> update ABI_. Just like you probably care about changes to KVM ABI but
>>> not so much about BPF for example.
>>> 
>>> > guess that KVM has the biggest ABI surface of any subsystem in the kernel by a
>>> > country mile (though I'm probably wildly underestimating the effective ABI surface
>>> > of filesystems).
>>> >
>>> >> The serialized state is a part of live update ABI and changes to it should be
>>> >> ACKed by us. 
>>> >
>>> > Meh, "Don't break userspace" is a universal rule in the kernel, I genuinely don't
>>> > see why liveupdate needs special treatment.
>>> 
>>> Ironically enough, you miss my point. I'm not talking about userspace
>>> ABI. We all know not to break that. I am talking about live update
>>> _serialization ABI_. See the stuff under include/linux/kho/abi. This
>>> series also adds things there.
>>
>> No, I understand exactly what ABI you're talking about.
>>
>>> This is ABI between kernels. It needs to be stable-ish so you can move
>>> from one kernel version to another. At the same time, unlike userspace
>>> ABI, it can change.
>>
>> Uh, yeah, so KVM has been managing such immutable ABI for practically its entire
>> existence.  KVM's save/restore uAPI has exactly what you're describing: serialization
>> ABI that needs to be backwards and forwards compatible between different kernels
>> in order to support both upgrade and rollback scenarios via live migration.
>
> I think there is a slight difference between KVM's save/resture uAPI and
> live update's ABI. With KVM's uAPI, you need to maintain strict
> backwards compatibility because userspace reads what you output. So if
> you change the layout, userspace will interpret it wrong and might
> break.
>
> With live update, the ABI never gets to userspace. It is used to talk
> between kernels directly. So if you do break that, your userspace keeps
> working fine, you just might not be able to live update to the
> incompatible kernel.
>
> So with live update, we don't need to keep backwards compatibility in
> the ABI forever. Of course, it is good to minimize changes, but we have
> more freedom to change it.
>
> The current idea is we change the ABI whenever needed. This is because
> live update is still in development so we are likely to see a lot more
> changes before we settle down into something that mostly works. At some
> point, we want to start being more strict between incompatible ABI
> changes. The current idea is that we would like to keep backwards
> compatibility across LTS kernels. But none of that is set in stone yet.
>

True, I also understand Sean's Concern. I will try to explain why
bacward compatibility with padding does not solve the problem here.

Kernel V1                        -> Kernel V2
guest_memfd_luo ABI v1           -> guest_memfd_luo ABI v2

(No Userspace involvement here: userspace only determine if the upcoming
kernel V2 can support the V1 preserved files, if return true: liveupdate()
elif: no_liveupdate())

When Kernel V1, preserve the data, it has preserved based on ABI v1.
then serializes it to make it transferable to next kernel via fdt.

Now Kernel V2 boots up, and it needs to deserialize the data and restore
the file which was preserved before. But this kernel V2 expect guest_memfd
preservation ABI V2. These ABI V2 might be because of multiple reasons,
for e.g.
1. A new feature in guest_memfd_luo (preserving more flags, or the
private/shared state of folios etc)

2. A new feature in guest_memfd itself, guest_memfd kernel APIs
(guest_memfd_create(..., new_args) or a new init call for guest_memfd after
guest_memfd_create(), or an older field/flog is dropped). So new kernel
should be able to retrieve old guest_memfd and populate in new
guest_memfd for backward compatibility.

Now, What will happen to these new fields or arguments that are needed,
Kernel V2->guest_memfd_luo V2 will take care of setting them to default.

Is setting them to default acceptable? Not always? So that is where the
negotiation comes in picture:  Kernel V2 should know if it can support
retrieving kernel V1 or otherwise userspace must not transition to V2 using
liveupdate if V2 does not have compatibility with V1.

Now to support this backward compatibility, the retrieval APIs and
deserialization APIs in V2 kernel should be able to provide the
deserialization/retrieval for V1 preserved data.

Kernel V1 -> serialize data ---kexec ----> kernel V2 -> deserialization -> retrieve

Now deserialization/retrival is aware of V1/V2 comptatibility then it
can set the new fields, parse the preserved data of V1 into V2 (or
directly give it to guest_memfd APIs with setting any new expected
fields to default.)

Now having a padding fields in kernel guest_memfd_luo ABIs does not help
here. As support for deserialization and parsing from V1-> V2 in kernel
V2 will determine if kernel V2 is backward compatible with V1. which can
also take care of setting the extra needed fields in V2 to default
value or remove the unwanted flags/fields not needed in kernel V2.


Now Questions is, if there isa  need for rollback to previous kernel
(V2 -> V1)?

There are two options,
1. kernel V2 is aware that it is going to get kexec to V1. then
serialization function on preservation will serialize the
data in guest_memfd_luo ABIs V1 compatible format.

2. kernel V1 guest_memfd_luo ABIs had the padding in their ABIs
structures which even if kernel V2 will set those field, will be ignored
by kernel V1. This will not require saperate
deserialization/preservation mechanism for guest_memfd_luo V1 in kernel
V2. This will not work in every case, As there might be different
parsers are in guest_memfd_luo V2 and V1. then serialized data preserved
by guest_memfd_luo V2 can not be parsed by guest_memfd_luo V1 after kexec.

So,

Kernel V2 _must have_ to support backward compatibility with kernel V1:
1. guest_memfd_luo V1 context aware deserialization/retrieval mechanism
2. guest_memfd_luo V1 context aware serialization/preservation mechanism

Kernel V1/V2 may have:
1. padding (hard to determine, can have heuristically) to ease the job
of deserialization/retrieval/serialization/preservation apis. But does
not solve backward compatibility alone.


Once we will keep updating the host, There will be a point when we are at
V15 but we dont want V1 backward compatiblity anymore, So we drop the
deserialization/retrieval/serialization/preservation for V1 from V15.

Would love to hear your thoughts?

Looping Logan (loganodell@google.com) for his insights on this as well.

~Tarun


> That's why I would like to have an explicit ACK from the live update
> group for ABI changes. I would like to enforce these compatibility
> windows.
>
>>
>> KVM also has immutable ABI between itself and guest kernels, including implicit
>> "ABI" in the form of not changing guest-visible behavior.
>>
>>> Today we don't have any rules and let you change things freely as long as you
>>> do a version bump. But at a later point, the plan is to add some stability
>>> requirements to the ABI so you can actually upgrade the kernel across major
>>> versions.
>>> 
>>> So at least for ABI changes, there should be an explicit ACK from the
>>> live update group.
>>
>> I don't entirely agree.  I get where you're coming from, and I 100% agree that
>> the more eyeballs on changes that may affect ABI, the better.
>>
>> Where I have problems with the above is that it doesn't account for the nuances
>> of save/restore across different kernels.  The literal format of the serialized
>> data is the most obvious form of ABI, but it's absolutely possible to change ABI
>> without changing the data format.
>>
>> E.g. say there's a flags field in some serialization structure, and flags X and Y
>> are mutually exclusive in current kernels.  If a future kernel relaxes that
>> restriction for whatever reason, then the effective ABI has been broken because
>> state created and saved on new kernels can't be restored on old kernels.  And
>> this is not a theoretical concern, KVM has run afoul of this a few times (though
>> thankfully very rarely).
>
> That's a bug, and should be fixed.
>
> I am talking here about intentional ABI changes. As I mentioned above we
> _can_ change the ABI, we just need to be careful about it.
>
>>
>> I don't think it's reasonable to expect LUO maintainers to gain enough expertise
>> in each subsystem to be able to ensure changes are forwards and backwards
>> compatible.  The only way I see LUO being successful in the long term is to get
>> subsystem maintainers/contributors to understand *and buy-in* to the LUO model
>> and rules, so that each subsystem can largely be self-sustatining.  I.e. setting
>> yourselves up as literal gatekeepers will help prevent blatant breakage, but it's
>> less likely to help guard against more subtle breakage, and in my experience,
>> subtle breakage is by far harder to detect and more painful to deal with.
>
> Outside of enforcing the ABI compatibility windows, I think this makes
> sense.
>
> In principle at least, though from my experience the maintainer appetite
> to care about live update varies. The feeling I've got from MM for
> example is more along the lines of "you break it, you buy it". Which is
> also a valid model IMO. The person who wrote the live update code for a
> subsystem is well equipped to understand these nuances.
>
>>
>> Somewhat of a side topic: in my experience, using monotonically increasing version
>> numbers is a horrible way to enumerate features/content.  So for me, allowing
>> KVM's LUO ABI to change with a verson bump is probably a non-starter.  I.e.
>> whatever gets merged needs to be more future-proof than "we'll deal with it later".
>
> As I wrote above, the compatibility model for live update allows
> breaking ABI with version bumps. Userspace keeps working fine, it only
> restricts the set of kernels that you can go to. So the "we'll deal with
> it later" is not as harmful because our choices here are not permanent.
>
> Also, there is work underway to allow transitions between versions [0].
>
> But still, I am not opposed to a more flexible guest_memfd ABI. I think
> we can reserve some space for feature flags to let us add things in the
> future.
>
> [0] https://lore.kernel.org/kexec/20260731215224.831696-1-loganodell@google.com/
>
> -- 
> Regards,
> Pratyush Yadav
