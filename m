Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECA73DF00B
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 16:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787068940; cv=none; b=J9mQox5U6TlrxVQPZDtdBqHnZ1j5bBbvC+kDXeFapJ+iMUxWsQ+m+Vsmn2UtyQ9nxgJjcD4oAUN26O0tf8Kgr9Z0L9nmvm2QaExoEv3CH1TVv90NP/DLsX/UOlhUH9YjZXC53t06ayUxKSdgWRZrTxRxLfS/FscdaCoO0GjHW8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787068940; c=relaxed/simple;
	bh=+Wcc8wz6m0+2T4ZtMRQJqeP7DGPsFLUeJ6j0YPPSbaw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SbjnyPhO5u3it4b/vBQgkMDbm6KHmeartprqwhpueIS14U+Ll0aZ6dugTQ4Aza8YT0DAqljSjmpzhBlrFAH9gyjG1JXgkAEl8T2m53PAIasEngkIQ/aMymX8Rly3GV4lUQi3WhZ1ULD0/jOxYoXnh7WOofQae9bFWsXimLmxPks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FDC7b/a/; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FDC7b/a/"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbedb8673ceso4098852a12.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787068938; x=1787673738; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hTu8rIIeaYeWexH+JKqzOvDmozZVoZIeVfoU7C4RXZA=;
        b=FDC7b/a/l35YGDZTPCjfLtizb9QKYkbQ34OgylzdaofTuaPR9mkPGLtKS4eTnAn9k+
         ghRwy+X4ULyS4BIe2N7KsBIIsOmoAyvUGghdfp3XF8jKtz6LdvmJydmFSf2J+FjOEVsk
         YmYYgt2us0kKSkT2YnP+gYWr1ZXDYtWKcpVui1VtAquVVtzB84hKmub1U6BvWTo/4l/+
         0Wj6vB5xRaJesJ+UFJ/pxPPUHrXYps+G1NXE/cRTNG4ceX+YUwJ6jX7WXQw5th9Sly9x
         Ze8vQ9RBaWWc/4zBsR9jIGG04K1in4tdarqGV0KyuQ1XeZZPijDEKvuqQ0uL9B8kJ6ZB
         ndMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787068938; x=1787673738;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hTu8rIIeaYeWexH+JKqzOvDmozZVoZIeVfoU7C4RXZA=;
        b=kXmNFovdgA8Do+Q54+Z1vahMQjJd/38K3B42l3vv2mr0KzCUE7PRm2TRscvNqtAFVP
         w+/FG/SAK99q6oePUka33uPnXf2mq3R88cG0GCSkAsk6oqtIm2b8YskQnJO2/4OfDGrG
         /LblDMlF6jW44CpOPDGlmzUZc5p5XuxPhRdnva/xIE5pr0nuL9W4OCeJo+Lyu7MdrPzW
         WZLLaSopRFjZRp6RIKeEtN51HetvN8rJsiN0cFd/dvsNK6DEXo9WU/TGXxLoqJUjxDGD
         1gJvl6OTKB/+K0eMOhfPgy306ZWMXnSBKMDV0aRqgX0CwFmQ9oLl9y/2zrXBv52tg7qg
         /4FA==
X-Forwarded-Encrypted: i=1; AHgh+RqJ5BQM8drlSpPy2DrdgjdIn3P/oaJkWFS6PZMjE5pTaDXbxNTl0UuFsvASxbnuzRhYYoJXe4s=@lists.linux.dev
X-Gm-Message-State: AOJu0YySWhUhSb10f7kQ0AZ7kGUCPSxt1L97o2Qj3WSQW6vbiUOYnmv2
	OFMWJZQBCpNI3pVHUoXPm3pD9C3n2X6t5oWuNPfQTk8UtEBbc3lKtV+Fce4rGbc0CZVN2DHuqn0
	KvU1VwQ==
X-Received: from pgvc22.prod.google.com ([2002:a65:6196:0:b0:cbf:d9a:2fcf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f99:b0:3c3:9df0:2d66
 with SMTP id adf61e73a8af0-3cc719fe453mr37508125637.6.1787068937949; Tue, 18
 Aug 2026 09:02:17 -0700 (PDT)
Date: Tue, 18 Aug 2026 09:02:17 -0700
In-Reply-To: <2vxzy0e3zgqz.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-6-tarunsahu@google.com> <anphyjFv3FhF61iB@google.com>
 <2vxzpkzo51wg.fsf@kernel.org> <anssOQFNZ2LfihbU@google.com>
 <2vxzik5f311e.fsf@kernel.org> <anyObKiZIhfok5mk@google.com>
 <2vxzqzjz1x5f.fsf@kernel.org> <aoMcqp0gr06YXAPU@google.com> <2vxzy0e3zgqz.fsf@kernel.org>
Message-ID: <aoSCCTTBn9D5hqzk@google.com>
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live updates
From: Sean Christopherson <seanjc@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>, ackerleytng@google.com, fuad.tabba@linux.dev, 
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
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 18, 2026, Pratyush Yadav wrote:
> Hi Sean,
> 
> On Mon, Aug 17 2026, Sean Christopherson wrote:
> 
> > On Sat, Aug 15, 2026, Pratyush Yadav wrote:
> >> On Wed, Aug 12 2026, Sean Christopherson wrote:
> >> > On Wed, Aug 12, 2026, Pratyush Yadav wrote:
> >> So with live update, we don't need to keep backwards compatibility in
> >> the ABI forever. Of course, it is good to minimize changes, but we have
> >> more freedom to change it.
> >
> > Ah.  So this is the heart of the disconnect.  I very strongly disagree with the
> > statement that live update doesn't need to support backwards compatibility.  I
> > can totally believe that the folks working on live update are ok breaking backwards
> > compatibility because their use cases are "fine" with such breakage.  And I can
> > also believe live update as an upstream kernel feature being developed by those
> > same folks is also ok with breaking backwards compatibility.
> >
> > But with my upstream KVM maintainer hat on, I am not ok with that.  I did not agree
> > to support a world where KVM is allowed to break backwards compatibility, so long
> > as it's done "carefully" or whatever.  If y'all want to deal with the resulting
> > complexity, that's fine by me, but you'll be doing it without KVM.
> 
> Let's step back a bit. I don't think backwards compatibility in the
> _ABI_ is all that important in live update's context. What is important
> is that our users are able to live update from kernel version X to Y.
> The line format the kernel uses to describe its state is an
> implementation detail. Our users never see it.

The rule is thou shalt not break userspace.  Whether or not the breakage is the
result of an explicit ABI change is irrelevant.

> The high level idea is that when you need to make a change to the ABI so
> the kernel can better describe the objects/resources/files it is
> passing, you create a new version of the ABI and allow transitions from
> older versions.
> 
> Say you make some changes and need an ABI version v5. You don't get rid
> of v4. You keep it around. LUO core will facilitate picking the right
> version for the next kernel. So it will be possible to seamlessly
> upgrade your kernel that speaks v4 to a new kernel that speaks v4 and
> v5. Now this kernel can start speaking v5 if its successor speaks v5
> too. And so on for going to v6 and v7, etc.
> 
> After a "reasonable" time given for upgrades, you deprecate v4. v4 has
> been around long enough and our users have had a chance to go to kernels
> speaking newer versions. That's when you remove the code for v4 from the
> kernel.
> 
> We can argue what "reasonable" means, but the core idea stays. 
> 
> It will still be possible to go back to v4 or earlier, but you'd need an
> extra stop along the way. And of course, vendors can keep a wider
> support matrix downstream if they see the need for it.
> 
> Does this idea of "backwards compatibility" sound acceptable to you, at
> least at a high level?

No.

It's probably fine for Google and other large companies that tightly control their
kernels and use cases, and have the resources to juggle the resulting complexity,
e.g. have kernel engineers on staff to track feature and dependencies, coordinate
and plan kernel upgrades, etc.

It's not acceptable for upstream, where downstream consumers often run a distro
kernel, have much more varied use cases, and don't always have a horde of kernel
engineers on staff to help them thread the needle you describe above.  And if
supporting live update as a general feature for all users of the kernel isn't
being factored into design considerations, then that needs to change, otherwise
this is all dead in the water.

I also don't see the point.  Maintaining a rigid save/restore ABI is annoying,
but it's not _hard_ (or at least, not _that_ hard), especially if there's a set
of well-documented best known practices that subsystems can follow, e.g. so that
individual subsystems don't need to learn painful lessons first-hand.  I genuinely
believe that maintaining the version hell you describe above would be more costly
in the long run than simply committing to full backwards compatibility within a
given subsystem.  I can imagine that enumerating what subsystems' information is
in the payload will require a different scheme, but for a given subsystem, I don't
see any reason to aim for anything less than full backwards compatibility.
