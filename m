Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB95C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 18:43:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42ABA61007
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 18:43:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42ABA61007
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C20B64B4D6;
	Wed, 31 Mar 2021 14:43:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6VWtNhlq9bgI; Wed, 31 Mar 2021 14:43:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D07D4B4CA;
	Wed, 31 Mar 2021 14:43:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72C084B4C1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 14:43:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aqf5-CX98FnA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 14:43:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2641C4B4C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 14:43:19 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1FED606A5;
 Wed, 31 Mar 2021 18:43:14 +0000 (UTC)
Date: Wed, 31 Mar 2021 19:43:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v10 2/6] arm64: kvm: Introduce MTE VM feature
Message-ID: <20210331184311.GA10737@arm.com>
References: <20210312151902.17853-1-steven.price@arm.com>
 <20210312151902.17853-3-steven.price@arm.com>
 <20210327152324.GA28167@arm.com> <20210328122131.GB17535@arm.com>
 <e0b88560-34e1-dcc4-aaa7-9a7a5b771824@arm.com>
 <20210330103013.GD18075@arm.com>
 <8977120b-841d-4882-2472-6e403bc9c797@redhat.com>
 <20210331092109.GA21921@arm.com>
 <d545a051-a02a-4c3a-0afe-66612839ba32@redhat.com>
 <86a968c8-7a0e-44a4-28c3-bac62c2b7d65@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86a968c8-7a0e-44a4-28c3-bac62c2b7d65@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: David Hildenbrand <david@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Juan Quintela <quintela@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
 linux-kernel@vger.kernel.org
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Mar 31, 2021 at 11:41:20AM +0100, Steven Price wrote:
> On 31/03/2021 10:32, David Hildenbrand wrote:
> > On 31.03.21 11:21, Catalin Marinas wrote:
> > > On Wed, Mar 31, 2021 at 09:34:44AM +0200, David Hildenbrand wrote:
> > > > On 30.03.21 12:30, Catalin Marinas wrote:
> > > > > On Mon, Mar 29, 2021 at 05:06:51PM +0100, Steven Price wrote:
> > > > > > On 28/03/2021 13:21, Catalin Marinas wrote:
> > > > > > > However, the bigger issue is that Stage 2 cannot disable
> > > > > > > tagging for Stage 1 unless the memory is Non-cacheable or
> > > > > > > Device at S2. Is there a way to detect what gets mapped in
> > > > > > > the guest as Normal Cacheable memory and make sure it's
> > > > > > > only early memory or hotplug but no ZONE_DEVICE (or
> > > > > > > something else like on-chip memory)?=A0 If we can't
> > > > > > > guarantee that all Cacheable memory given to a guest
> > > > > > > supports tags, we should disable the feature altogether.
> > > > > > =

> > > > > > In stage 2 I believe we only have two types of mapping -
> > > > > > 'normal' or DEVICE_nGnRE (see stage2_map_set_prot_attr()).
> > > > > > Filtering out the latter is a case of checking the 'device'
> > > > > > variable, and makes sense to avoid the overhead you
> > > > > > describe.
> > > > > > =

> > > > > > This should also guarantee that all stage-2 cacheable
> > > > > > memory supports tags,
> > > > > > as kvm_is_device_pfn() is simply !pfn_valid(), and
> > > > > > pfn_valid() should only
> > > > > > be true for memory that Linux considers "normal".
> > > > =

> > > > If you think "normal" =3D=3D "normal System RAM", that's wrong; see
> > > > below.
> > > =

> > > By "normal" I think both Steven and I meant the Normal Cacheable memo=
ry
> > > attribute (another being the Device memory attribute).
> =

> Sadly there's no good standardised terminology here. Aarch64 provides the
> "normal (cacheable)" definition. Memory which is mapped as "Normal
> Cacheable" is implicitly MTE capable when shared with a guest (because the
> stage 2 mappings don't allow restricting MTE other than mapping it as Dev=
ice
> memory).
> =

> So MTE also forces us to have a definition of memory which is "bog standa=
rd
> memory"[1] separate from the mapping attributes. This is the main memory
> which fully supports MTE.
> =

> Separate from the "bog standard" we have the "special"[1] memory, e.g.
> ZONE_DEVICE memory may be mapped as "Normal Cacheable" at stage 1 but that
> memory may not support MTE tags. This memory can only be safely shared wi=
th
> a guest in the following situations:
> =

>  1. MTE is completely disabled for the guest
> =

>  2. The stage 2 mappings are 'device' (e.g. DEVICE_nGnRE)
> =

>  3. We have some guarantee that guest MTE access are in some way safe.
> =

> (1) is the situation today (without this patch series). But it prevents t=
he
> guest from using MTE in any form.
> =

> (2) is pretty terrible for general memory, but is the get-out clause for
> mapping devices into the guest.
> =

> (3) isn't something we have any architectural way of discovering. We'd ne=
ed
> to know what the device did with the MTE accesses (and any caches between
> the CPU and the device) to ensure there aren't any side-channels or h/w
> lockup issues. We'd also need some way of describing this memory to the
> guest.
> =

> So at least for the time being the approach is to avoid letting a guest w=
ith
> MTE enabled have access to this sort of memory.

When a slot is added by the VMM, if it asked MTE in guest (I guess
that's an opt-in by the VMM, haven't checked the other patches), can we
reject it if it's is going to be mapped as Normal Cacheable but it is a
ZONE_DEVICE (i.e. !kvm_is_device_pfn() + one of David's suggestions to
check for ZONE_DEVICE)? This way we don't need to do more expensive
checks in set_pte_at().

We could simplify the set_pte_at() further if we require that the VMM
has a PROT_MTE mapping. This does not mean it cannot have two mappings,
the other without PROT_MTE. But at least we get a set_pte_at() when
swapping in which has PROT_MTE.

We could add another PROT_TAGGED or something which means PG_mte_tagged
set but still mapped as Normal Untagged. It's just that we are short of
pte bits for another flag.

Can we somehow identify when the S2 pte is set and can we get access to
the prior swap pte? This way we could avoid changes to set_pte_at() for
S2 faults.

-- =

Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
