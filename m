Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EEDC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 07:38:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0A274B086;
	Thu, 24 Mar 2022 03:38:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i-Sg4lzlyjKC; Thu, 24 Mar 2022 03:38:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64BC14A119;
	Thu, 24 Mar 2022 03:38:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B1EA4A0FE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 03:38:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TsdpvBXKrfvm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 03:38:01 -0400 (EDT)
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com
 [209.85.166.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11D2B4A0FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 03:38:00 -0400 (EDT)
Received: by mail-il1-f171.google.com with SMTP id e18so2636243ilr.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 00:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=qEd63tIHMzkTiVmix/zg5Kepcn4SZRubYZZ/89R7on8=;
 b=jKz9hFzC1npUxMvPjw2v2QBb2R3g5FzAGFs0wFMmeWF2nY8HLH+jyEA6rg6Ry39w8v
 FDsopU9fYI7Pc7UgQFdshHTKC70tg6pKTUtRzBHs98YU6fwEjdhCPtxxRx8EH3+d8KcY
 n5ke898/AG6x//tWxLv+g9iryK6mDQbODSbM+DUA9WGjyKugNl1fPSNrSkQxrzK0jW02
 xr10uHLGt2xYo1COLDQGU8hni9ZD7CXr7inEXZa6ZzsYRZGg9aDZo6HGdwUjClnHrXon
 2Jv3P6FRFO3kyZB+Y2mCXM6ic1j2uSjqLXWiNrMXwM7nIlhVD4qs7J7dIuSW3h5VYe1O
 ZLNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qEd63tIHMzkTiVmix/zg5Kepcn4SZRubYZZ/89R7on8=;
 b=0FbwFZ2H5gFwL+estos11i52cyD/RYz/CdLYv8QNiIue9nVAdLbnGCegNidBzje0CA
 OY99qg8QGp5uFIJR7xRNpWa8+Y+KYCpAcnIpQB+TtDwrFEa4ZZnQXg1rxGJqrZH8c/5X
 Llh/cvBlTSa4zFZ30cos+0y0noLnXbAo+U9kbLEpC6l7zUynXsUfyapZx+puDhdevrJQ
 ltiBqmvi8ChUUuRvBh8g81OryHvxDtdutOMjde+ivkrO+degAfQSH0XOWrJV+dJCYv+Z
 HCYqlsqI1UXYzTlGizhqH5hWutf5UFEPu322QTqTxGntZR6USNL9CN4fvZzcmSgr/0m6
 XzAQ==
X-Gm-Message-State: AOAM530Vn76dAveZsEpxGwbi1jlIiyMa01aSkRT+QFGfpVvyohZ5UqAM
 zHThhkYLJcEw1f6FUN3gh563Pg==
X-Google-Smtp-Source: ABdhPJzC+kBxrijRCsVFsazTYtmdKoMBi4MqBzTj6FEmvblV/o8eXsvmpCIHcyepqbMA6aJNEcp91Q==
X-Received: by 2002:a05:6e02:16c7:b0:2c7:e458:d863 with SMTP id
 7-20020a056e0216c700b002c7e458d863mr1997250ilx.71.1648107480057; 
 Thu, 24 Mar 2022 00:38:00 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 f4-20020a92b504000000b002c21ef70a81sm1201411ile.7.2022.03.24.00.37.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 00:37:59 -0700 (PDT)
Date: Thu, 24 Mar 2022 07:37:56 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v6 01/25] KVM: arm64: Introduce a validation function for
 an ID register
Message-ID: <Yjwf1BpigvzlT8r9@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-2-reijiw@google.com>
 <Yjl96UQ7lUovKBWD@google.com>
 <CAAeT=FzELqXZiWjZ9aRNqYRbX0zx6LdhETiZUS+CMvax2vLRQw@mail.gmail.com>
 <YjrG0xiubC108tIN@google.com>
 <CAAeT=FxEwuwg310vhWQeBJ9UouHNaJNcPqvbLYh7nXp7aFFq=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FxEwuwg310vhWQeBJ9UouHNaJNcPqvbLYh7nXp7aFFq=Q@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

On Wed, Mar 23, 2022 at 11:00:25PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> > > > I have some concerns regarding the API between cpufeature and KVM that's
> > > > being proposed here. It would appear that we are adding some of KVM's
> > > > implementation details into the cpufeature code. In particular, I see
> > > > that KVM's limitations on AA64DFR0 are being copied here.
> > >
> > > I assume "KVM's limitation details" you meant is about
> > > ftr_id_aa64dfr0_kvm.
> > > Entries in arm64_ftr_bits_kvm_override shouldn't be added based
> > > on KVM's implementation.  When cpufeature.c doesn't handle lower level
> > > of (or fewer) features as the "safe" value for fields, the field should
> > > be added to arm64_ftr_bits_kvm_override.  As PMUVER and DEBUGVER are not
> > > treated as LOWER_SAFE, they were added in arm64_ftr_bits_kvm_override.
> >
> > I believe the fact that KVM is more permissive on PMUVER and DEBUGVER
> > than cpufeature is in fact a detail of KVM, no? read_id_reg() already
> 
> What cpufeature knows is that consumers of the validation function
> needs the validation of each field based on ID register schemes that
> are described in Arm ARM (basically lower safe).
> As lower values of PMUVER/DEBUGVER indicates lower level of features
> or fewer level of features, those entries are to provide validation
> based on that.  So, entries in arm64_ftr_bits_kvm_override will be added
> to adjust cpufeture's behavior based on ID register schemes, and KVM may
> or may not use them.
> 
> I need to remove the word "kvm" from variable/function/structure names
> and put more clear comments:)

I'll admit I definitely drilled down on the fact that KVM is the only
actual user of these, and not the fact that it was realigning the fields
with the Arm ARM :)

> > implicitly trusts the cpufeature code filtering and applies additional
> > limitations on top of what we get back. Similarly, there are fields
> > where KVM is more restrictive than cpufeature (ID_AA64DFR0_PMSVER).
> >
> > Each of those constraints could theoretically be expressed as an
> > arm64_ftr_bits structure within KVM.
> 
> It's not impossible but it's a bit tricky (With __arm64_ftr_reg_valid(),
> it might look straight forward, but I don't think that treats FTR_EXACT
> correctly. Please see update_cpu_ftr_reg).
>

Ah right. __arm64_ftr_reg_valid() needs to trust either the value that
comes from the boot CPU, or ->safe_val if the cores are different in the
system. And what does it mean if the caller specified FTR_EXACT?

I'll think on this more if I have any other suggestions.

[...]

> > It also seems to me that if I wanted to raise the permitted DEBUGVER for KVM,
> > would I have to make a change outside of KVM.
> 
> Could you elaborate this a little more?

Urgh. Ignore me, I fixated to heavily on the SAFE_VAL you used for
DEBUGVER, not the fact that it was LOWER_SAFE.

> More specific concern I have about providing the override (with the
> existing arm64_ftr_bits) would be when field values of arm64_ftr_bits
> (i.e. LOWER_SAFE to EXACT) in cpufeature are changed due to kernel's
> implementation reasons, which might affect KVM (may need to pass
> extra override to arm64_ftr_reg_valid).
> But, by having cpufeature provide the validation based on the ID
> register schemes, cpufeature should be changed to provide the same
> validation in that case (i.e. if DFR0.PERFMON is changed from LOWER_SAFE
> to EXACT like AA64DFR0.PMUVER, DFR0.PERFMON should be added in
> arm64_ftr_bits_kvm_override with LOWER_SAFE).
> 
> So, if I go with the option to provide override to cpufeature, IMHO it
> would be preferable for cpufeature to provide the validation based
> on ID schemes instead of with the current need-based policy (, which
> might get changed) for clear separation.

Sounds good. Per your suggestion above, changing the
naming/documentation around what is being added to cpufeature removes
the confusion that it relates to KVM and really is a precise
implementation of the rules in the Arm ARM.

> > > Another option that I considered earlier was having a full set of
> > > arm64_ftr_bits in KVM for its validation. At the time, I thought
> > > statically) having a full set of arm64_ftr_bits in KVM is not good in
> > > terms of maintenance.  But, considering that again, since most of
> > > fields are unsigned and lower safe fields, and KVM doesn't necessarily
> > > have to statically have a full set of arm64_ftr_bits
> >
> > I think the argument could be made for KVM having its own static +
> > verbose cpufeature tables. We've already been bitten by scenarios where
> 
> What does "verbose cpufeature tables" mean ?

Currently KVM implements a sparsely-defined denylist on top of whatever
we get back from read_sanitised_ftr_reg(). We do not have an absolute
upper bound for all fields in the feature registers, so there are times
where unsupported features leak through to the guest much like the SPE
commit I mentioned below.

What I am suggesting is that KVM define an absolute limit on what it
virtualizes for *all* fields, including what is presently RAZ. We have
absolutely no idea whether or not we can virtualize new features that
come in later revisions of the spec. It does mean we will need to
raise those limits from time to time, but would rather do that than
accidentally expose a feature we cannot virtualize.

> > cpufeature exposes a feature that we simply do not virtualize in KVM.
> > That really can become a game of whack-a-mole. commit 96f4f6809bee
> > ("KVM: arm64: Don't advertise FEAT_SPE to guests") is a good example,
> > and I can really see no end to these sorts of issues without an
> > overhaul. We'd need to also find a way to leverage the existing
> > infrasturcture for working out a system-wide safe value, but this time
> > with KVM's table of registers.
> > KVM would then need to take a change to expose any new feature that has
> > no involvement of EL2. Personally, I'd take that over the possibility of
> > another unhandled feature slipping through and blowing up a guest kernel
> > when running on newer hardware.
> 
> Userspace with configurable ID registers would eliminate such problems
> on known systems, but I agree that KVM itself should prevent it.
> It will be inconvenient for some people, but it would be safer in general.

We cannot require userspace to write to these registers to run a guest
given the fact that the present ABI doesn't. Given that fact, KVM is
still responsible for having sane default values for these registers.

If a field that we do not handle implies a feature we do not virtualize
on newer hardware, invariably our guest will see it and likely panic
when it realizes the vCPU is out of spec.

Maybe the feature bits tables is a bit extreme given the fact that it
does define the architected handling of each field. I think the upper
bound on register values I mentioned above would do the trick and avoid
copy/pasting a whole set of structures we don't desperately need.

> > > (dynamically generate during KVM's initialization)
> >
> > This was another one of my concerns with the current state of this
> > patch. I found the register table construction at runtime hard to
> > follow. I think it could be avoided with a helper that has a prescribed
> > set of rules (caller-provided field definition takes precedence over the
> > general one).
> 
> Sure, I will improve that if I continue to keep the current way.
> With the option of having a separate KVM's arm64_ftr_bits,
> the code will be very different, but I will keep that in mind.

arm64_ftr_bits might be a bit extreme in KVM after all, I'll retract
that suggestion in favor of what I said above :)

Thanks for being patient working through all of this with me.

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
