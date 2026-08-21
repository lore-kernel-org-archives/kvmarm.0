Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824AB3CAE9B;
	Fri, 21 Aug 2026 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787319800; cv=none; b=RCvguncT0gzTWsx0U/X2IGZmeS8e6b1GBMkGUUjkAImggFm6jJLW77se3EdsqpgT9kO7G/GEcJ9WSd68KudoyBMDllLn99qN3ldgBeu2ZELlTtmKMmsv7dSjSe/Fh6mbkwTZIpYgwlbzDdl+kvOffTdTpfMiErejLIwDA/1Fuj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787319800; c=relaxed/simple;
	bh=fG13yd2nhvZlgt2VOFWDG5OqawaYkDaA3JuDhTjhpy8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JEPu/FZL1MPJywMNLT4ThBCpXPMEJlsrEX5YpTngdtoTSZIgsY5R5q26w/HyX1ZanMVVwlDBL1/tFhyU24GZnmJpHXJtTe7XdTDes6fvdJ/mvJXenXBsOkaRvNCwufe+uhqgdiCFJVPLFTrG0rzT3GuoyResTyq3hVESiVqGMK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sqfou5ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sqfou5ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E1B1F00A3A;
	Fri, 21 Aug 2026 13:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787319791;
	bh=QZVuBsFPO7y/+P0oUWt1MocdFg1Mb540trEFoGS+/XI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Sqfou5ckAPcZDBKBlY5L6E32jhVWknn+BnkCBXSzAHC7pfl9T3qdvget9Zkc+r6W7
	 NpjLzhmEdGkPzoP6YkEDGZj6TgnB/x880a3qegXWBJNqoR++tXsgs/b8o2l4cRPEnX
	 3tNFRlhTDjZsd6m/DepQ44NryZkeOlVBijE4gBgmqx85Z1hWgeFmONtrKsSWm5AdLo
	 mlkIuqxVEuLtN1t8qiRcyXmdm5KWgBkPBQtUtFOfwqzl4VdKeEQ8V408M2WPxi2b5E
	 A0squiaZSky8+YbGL0adr/sq8XFJjmk9Q7C1Zpk7ZcIJCc0HV2x3hpXDQjBzlwW7DP
	 RTIBuEBMJN+Ew==
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
In-Reply-To: <aoSCCTTBn9D5hqzk@google.com> (Sean Christopherson's message of
	"Tue, 18 Aug 2026 09:02:17 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-6-tarunsahu@google.com>
	<anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
	<anssOQFNZ2LfihbU@google.com> <2vxzik5f311e.fsf@kernel.org>
	<anyObKiZIhfok5mk@google.com> <2vxzqzjz1x5f.fsf@kernel.org>
	<aoMcqp0gr06YXAPU@google.com> <2vxzy0e3zgqz.fsf@kernel.org>
	<aoSCCTTBn9D5hqzk@google.com>
Date: Fri, 21 Aug 2026 15:43:04 +0200
Message-ID: <2vxzy0dzy4gn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Hi Sean,

On Tue, Aug 18 2026, Sean Christopherson wrote:

> On Tue, Aug 18, 2026, Pratyush Yadav wrote:
>> Hi Sean,
>> 
>> On Mon, Aug 17 2026, Sean Christopherson wrote:
>> 
>> > On Sat, Aug 15, 2026, Pratyush Yadav wrote:
>> >> On Wed, Aug 12 2026, Sean Christopherson wrote:
>> >> > On Wed, Aug 12, 2026, Pratyush Yadav wrote:
>> >> So with live update, we don't need to keep backwards compatibility in
>> >> the ABI forever. Of course, it is good to minimize changes, but we have
>> >> more freedom to change it.
>> >
>> > Ah.  So this is the heart of the disconnect.  I very strongly disagree with the
>> > statement that live update doesn't need to support backwards compatibility.  I
>> > can totally believe that the folks working on live update are ok breaking backwards
>> > compatibility because their use cases are "fine" with such breakage.  And I can
>> > also believe live update as an upstream kernel feature being developed by those
>> > same folks is also ok with breaking backwards compatibility.
>> >
>> > But with my upstream KVM maintainer hat on, I am not ok with that.  I did not agree
>> > to support a world where KVM is allowed to break backwards compatibility, so long
>> > as it's done "carefully" or whatever.  If y'all want to deal with the resulting
>> > complexity, that's fine by me, but you'll be doing it without KVM.
>> 
>> Let's step back a bit. I don't think backwards compatibility in the
>> _ABI_ is all that important in live update's context. What is important
>> is that our users are able to live update from kernel version X to Y.
>> The line format the kernel uses to describe its state is an
>> implementation detail. Our users never see it.
>
> The rule is thou shalt not break userspace.  Whether or not the breakage is the
> result of an explicit ABI change is irrelevant.
>
>> The high level idea is that when you need to make a change to the ABI so
>> the kernel can better describe the objects/resources/files it is
>> passing, you create a new version of the ABI and allow transitions from
>> older versions.
>> 
>> Say you make some changes and need an ABI version v5. You don't get rid
>> of v4. You keep it around. LUO core will facilitate picking the right
>> version for the next kernel. So it will be possible to seamlessly
>> upgrade your kernel that speaks v4 to a new kernel that speaks v4 and
>> v5. Now this kernel can start speaking v5 if its successor speaks v5
>> too. And so on for going to v6 and v7, etc.
>> 
>> After a "reasonable" time given for upgrades, you deprecate v4. v4 has
>> been around long enough and our users have had a chance to go to kernels
>> speaking newer versions. That's when you remove the code for v4 from the
>> kernel.
>> 
>> We can argue what "reasonable" means, but the core idea stays. 
>> 
>> It will still be possible to go back to v4 or earlier, but you'd need an
>> extra stop along the way. And of course, vendors can keep a wider
>> support matrix downstream if they see the need for it.
>> 
>> Does this idea of "backwards compatibility" sound acceptable to you, at
>> least at a high level?
>
> No.
>
> It's probably fine for Google and other large companies that tightly control their
> kernels and use cases, and have the resources to juggle the resulting complexity,
> e.g. have kernel engineers on staff to track feature and dependencies, coordinate
> and plan kernel upgrades, etc.
>
> It's not acceptable for upstream, where downstream consumers often run a distro
> kernel, have much more varied use cases, and don't always have a horde of kernel
> engineers on staff to help them thread the needle you describe above.  And if
> supporting live update as a general feature for all users of the kernel isn't
> being factored into design considerations, then that needs to change, otherwise
> this is all dead in the water.
>
> I also don't see the point.  Maintaining a rigid save/restore ABI is annoying,
> but it's not _hard_ (or at least, not _that_ hard), especially if there's a set
> of well-documented best known practices that subsystems can follow, e.g. so that
> individual subsystems don't need to learn painful lessons first-hand.  I genuinely
> believe that maintaining the version hell you describe above would be more costly
> in the long run than simply committing to full backwards compatibility within a
> given subsystem.  I can imagine that enumerating what subsystems' information is
> in the payload will require a different scheme, but for a given subsystem, I don't
> see any reason to aim for anything less than full backwards compatibility.

Let's say for argument's sake that we commit for a fully stable
backwards compatible ABI. Even then, you have to deal with multiple ABI
versions.

Live update's ABI is more complex compared to KVM's save/restore ABI.
For the KVM save/restore uAPI, you are largely describing architectural
state like CPU registers, etc. These things don't evolve as fast and
more or less stay the same.

Live update needs to describe the state of kernel objects. These are
more complex and evolve faster.

For example, say you merge guest_memfd preservation today. Some time
later, someone comes up with a more efficient data structure to track
the folios in the file. You _have_ to make a backwards-incompatible ABI
change to use this data structure.

Or say you add a new memory backend (like the HugeTLB patches in
flight). That likely will need a different ABI to describe the state of
the guest_memfd.

So you will end up with multiple ABI versions that aren't always
backwards compatible.

If you refuse that idea too, then KVM live update will be dead in the
water for a different reason. It will be damn near useless because it
can't keep up with an evolving subsystem.

Now once you get multiple ABI versions and you can seamlessly go from
old to new one, say you have a version that was superseded 5 years ago.
It would be completely reasonable to say that this version is old enough
and no one should be going from a 5 year old kernel to a modern one. So
you deprecate this ABI. Deprecating old unused uAPIs is not
unprecedented.

I think we are better off formalizing this deprecation period from the
get go.

A somewhat tangential example is BPF kfuncs. My BPF program that works
in kernel X might not work in kernel Y because the kfunc has changed or
been removed.

The argument they make in kfuncs.rst is that kfuncs "provide a kernel
<-> kernel API, and thus are not bound by any of the strict stability
restrictions associated with kernel <-> user UAPIs". For LUO as well,
this is a kernel -> kernel API. Users can also still do a regular kexec
or reboot. They just won't get the performance optimization of LUO.

Regardless of if you agree with the last bit about deprecating old
versions, ABIs evolving with the subsystem is a ground reality of live
update and it would be foolish to think we can do with only
backwards-compatible ABI changes forever.

-- 
Regards,
Pratyush Yadav
