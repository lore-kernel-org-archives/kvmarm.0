Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9638A468C11;
	Tue, 18 Aug 2026 13:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787060605; cv=none; b=LoxG+QNvCmJFjOij4giamvzJV0CZSV7djSz762M8jvM22KTMvFdY4SWuzsMp3d1OjYIbYviRff4c+HlZcpvzny5RUp2YusXYD9dj8ppwQdZ7StgC436Xv8rJ4ANbHhjL2C7EyDLO5vhvto8VPirj4ordz2myTmM4paO4dkr4894=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787060605; c=relaxed/simple;
	bh=uY2e62TGWkZpxEzYpDvfnnHcFMOjTOKr3KB9V/QxwgM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VKsQSshb9GVvdYreelxnmSdHHleeGiBNpA07rM0O5jXRiRHgaK0wTc5u/HBcjkZaKMq6LrKOudw4TCvcH7D5ECwR6Tmaysh93/GL2BRbL0wgghsGOEV56uZII/zHj/PAr2ebk2EMfdZXtaeMU20vJhSb1iV1+ESoDpcJra2IAmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNqkvMTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNqkvMTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0CB1F000E9;
	Tue, 18 Aug 2026 13:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787060604;
	bh=nCaPyvw2iFSAtJp+/S0lPXfdeu+F7EyJ6au4lKiWYEc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CNqkvMTJLXNXiEeYKsDcJ5vMCl9APuMbVQIu0B3nogx96ycdVcxhEfA8Y935rOFQB
	 DwbNjFOYTMnBcvSeBREzeVOMYq7oUx9+JWYNVQm4Q0PKS+TKPkUhGIwiw2tE5w+5Ve
	 LAEdg6oApkQLyaWE+1c4QN377ZwYbBFYC0UH/Ok81z64U3FaYuILqh5ogSr2NI8qW5
	 Ege/V5Ma8jQasI6rRqF3rtGgJBIUlCgSKy5x8PZPaKbx9kzGG3jWEalwW+u9kH3QZa
	 hA+6ZSEFatqG59DQNkEy9P9hX2+kEigKQsIcMrgm1kYnd9bXj74pxxwXASSs+5JduV
	 qiO3xv/HZavsA==
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
In-Reply-To: <aoMcqp0gr06YXAPU@google.com> (Sean Christopherson's message of
	"Mon, 17 Aug 2026 07:37:30 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-6-tarunsahu@google.com>
	<anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
	<anssOQFNZ2LfihbU@google.com> <2vxzik5f311e.fsf@kernel.org>
	<anyObKiZIhfok5mk@google.com> <2vxzqzjz1x5f.fsf@kernel.org>
	<aoMcqp0gr06YXAPU@google.com>
Date: Tue, 18 Aug 2026 15:43:16 +0200
Message-ID: <2vxzy0e3zgqz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Hi Sean,

On Mon, Aug 17 2026, Sean Christopherson wrote:

> On Sat, Aug 15, 2026, Pratyush Yadav wrote:
>> On Wed, Aug 12 2026, Sean Christopherson wrote:
>> > On Wed, Aug 12, 2026, Pratyush Yadav wrote:
>> >> This is ABI between kernels. It needs to be stable-ish so you can move
>> >> from one kernel version to another. At the same time, unlike userspace
>> >> ABI, it can change.
>> >
>> > Uh, yeah, so KVM has been managing such immutable ABI for practically its entire
>> > existence.  KVM's save/restore uAPI has exactly what you're describing: serialization
>> > ABI that needs to be backwards and forwards compatible between different kernels
>> > in order to support both upgrade and rollback scenarios via live migration.
>> 
>> I think there is a slight difference between KVM's save/resture uAPI and
>> live update's ABI. With KVM's uAPI, you need to maintain strict
>> backwards compatibility because userspace reads what you output. So if
>> you change the layout, userspace will interpret it wrong and might
>> break.
>> 
>> With live update, the ABI never gets to userspace. It is used to talk
>> between kernels directly. So if you do break that, your userspace keeps
>> working fine, you just might not be able to live update to the
>> incompatible kernel.
>> 
>> So with live update, we don't need to keep backwards compatibility in
>> the ABI forever. Of course, it is good to minimize changes, but we have
>> more freedom to change it.
>
> Ah.  So this is the heart of the disconnect.  I very strongly disagree with the
> statement that live update doesn't need to support backwards compatibility.  I
> can totally believe that the folks working on live update are ok breaking backwards
> compatibility because their use cases are "fine" with such breakage.  And I can
> also believe live update as an upstream kernel feature being developed by those
> same folks is also ok with breaking backwards compatibility.
>
> But with my upstream KVM maintainer hat on, I am not ok with that.  I did not agree
> to support a world where KVM is allowed to break backwards compatibility, so long
> as it's done "carefully" or whatever.  If y'all want to deal with the resulting
> complexity, that's fine by me, but you'll be doing it without KVM.

Let's step back a bit. I don't think backwards compatibility in the
_ABI_ is all that important in live update's context. What is important
is that our users are able to live update from kernel version X to Y.
The line format the kernel uses to describe its state is an
implementation detail. Our users never see it.

The high level idea is that when you need to make a change to the ABI so
the kernel can better describe the objects/resources/files it is
passing, you create a new version of the ABI and allow transitions from
older versions.

Say you make some changes and need an ABI version v5. You don't get rid
of v4. You keep it around. LUO core will facilitate picking the right
version for the next kernel. So it will be possible to seamlessly
upgrade your kernel that speaks v4 to a new kernel that speaks v4 and
v5. Now this kernel can start speaking v5 if its successor speaks v5
too. And so on for going to v6 and v7, etc.

After a "reasonable" time given for upgrades, you deprecate v4. v4 has
been around long enough and our users have had a chance to go to kernels
speaking newer versions. That's when you remove the code for v4 from the
kernel.

We can argue what "reasonable" means, but the core idea stays. 

It will still be possible to go back to v4 or earlier, but you'd need an
extra stop along the way. And of course, vendors can keep a wider
support matrix downstream if they see the need for it.

Does this idea of "backwards compatibility" sound acceptable to you, at
least at a high level?

Now coming back to today's reality. We don't yet support this version
transition. I proposed the idea at LPC 2025 [0]. Logan Odell has taken
over the work since I have other things on my plate, but it is something
being actively developed. Logan recently sent some RFCs [1] for this
too, though TBH I haven't yet gotten to those patches. We also have
proposed a talk about this at LPC 2026, it would be great if you could
attend (if the talk gets accepted).

If you say that we should figure this version transition out and land it
upstream before we land the KVM code, I think that's a fair ask. I can
work with that.

But I think we first need to agree on the principles of the
compatibility model I described above.

[0] https://lpc.events/event/19/contributions/2049/
[1] https://lore.kernel.org/kexec/20260731215224.831696-1-loganodell@google.com/T/#u

>
> I totally understand that exploratory work and initial development is best done
> in private and/or in a small working groups.  But decisions that will significantly
> impact multiple subsystems need to be made *with* those subystems.  I mean,
> obviously it's possible to make a decision in a small group and then "publish"
> the result later, but then as is happening here, the community and subsystem
> maintainers like me may refuse to play ball if they disagree.

The design of live update was discussed and agreed upon in the open.
David Rientjes (and now Pasha) has been hosting the live update
biweeklies [2] from the very start of the project. The series is open to
everyone and notes shared for those who couldn't join. This meeting was
attended by a lot of people from different companies and different
subsystem backgrounds.

There have also been a microconference at LPC 2025 where topics around
live update in PCI, MM, VFIO, IOMMU, etc. were discussed, along with
presentations at subsystem tracks in other conferences.

Of course, it is impossible to get all maintainers of all subsystems to
attend these sessions or conferences. That's fine.

But I think it is quite unfair to say that live update is developed in
private or in small groups.

[2] https://lore.kernel.org/all/?q=s%3A%22%5BHypervisor+Live+Update%5D%22

-- 
Regards,
Pratyush Yadav
