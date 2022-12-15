Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7308C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 15 Dec 2022 00:52:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8E84B994;
	Wed, 14 Dec 2022 19:52:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1x5419IA2OGz; Wed, 14 Dec 2022 19:52:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB2454B987;
	Wed, 14 Dec 2022 19:52:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FDF84B975
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2022 19:52:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mz2zo-KcZ103 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Dec 2022 19:52:34 -0500 (EST)
Received: from out-34.mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3BB44B974
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2022 19:52:34 -0500 (EST)
Date: Thu, 15 Dec 2022 00:52:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1671065553;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=W56Kw0JALwEcXuHS6+Lvrx1mQ8hK6mGSL4QamS06KBI=;
 b=XlqYWeEgw5SD53yZCSMnRc5PdeWN0d7GuYwAzWMEJaDY1z0I3BzxttXqK7ghburrQoYg67
 9rA3CH98a8HulGNjwwGrcP9yz1rHSEwwfYbRlHpYkYU0aT9eYSR6GCeQLtwKAB5arPpOJe
 fODfp8S1BmKABIT9TolQ4zY07bls6qo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v1 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm s2
Message-ID: <Y5pvzKYdZK79nyZw@google.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221206135930.3277585-1-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT
Cc: Marc Zyngier <maz@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Tue, Dec 06, 2022 at 01:59:18PM +0000, Ryan Roberts wrote:
> (appologies, I'm resending this series as I managed to send the cover letter to
> all but the following patches only to myself on first attempt).
> 
> This is my first upstream feature submission so please go easy ;-)

Welcome :)

> Support 52-bit Output Addresses: FEAT_LPA2 changes the format of the PTEs. The
> HW advertises support for LPA2 independently for stage 1 and stage 2, and
> therefore its possible to have it for one and not the other. I've assumed that
> there is a valid case for this if stage 1 is not supported but stage 2 is, KVM
> could still then use LPA2 at stage 2 to create a 52 bit IPA space (which could
> then be consumed by a 64KB page guest kernel with the help of FEAT_LPA). Because
> of this independence and the fact that the kvm pgtable library is used for both
> stage 1 and stage 2 tables, this means the library now has to remember the
> in-use format on a per-page-table basis. To do this, I had to rework some
> functions to take a `struct kvm_pgtable *` parameter, and as a result, there is
> a noisy patch to add this parameter.

Mismatch between the translation stages is an interesting problem...

Given that userspace is responsible for setting up the IPA space, I
can't really think of a strong use case for 52 bit IPAs with a 48 bit
VA. Sure, the VMM could construct a sparse IPA space or remap the same
HVA at multiple IPAs to artificially saturate the address space, but
neither seems terribly compelling.

Nonetheless, AFAICT we already allow this sort of mismatch on LPA &&
!LVA systems. A 48 bit userspace could construct a 52 bit IPA space for
its guest.

Marc, is there any real reason for this or is it just a byproduct of how
LPA support was added to KVM?

> Support 52-bit Input Addresses: The main difficulty here is that at stage 1 for
> 4KB pages, 52-bit IA requires a extra level of lookup, and that level is called
> '-1'. (Although stage 2 can use concatenated pages at the first level, and
> therefore still only uses 4 levels, the kvm pgtable library deals with both
> stage 1 and stage 2 tables). So there is another noisy patch to convert all
> level variables to signed.
> 
> This is all tested on the FVP, using a test harness I put together, which does a
> host + guest boot test for 180 configurations, built from all the (valid)
> combinations of various FVP, host kernel and guest kernel parameters:
> 
>  - hw_pa:		[48, lpa, lpa2]
>  - hw_va:		[48, 52]
>  - kvm_mode:		[vhe, nvhe, protected]
>  - host_page_size:	[4KB, 16KB, 64KB]
>  - host_pa:		[48, 52]
>  - host_va:		[48, 52]
>  - host_load_addr:	[low, high]
>  - guest_page_size:	[64KB]
>  - guest_pa:		[52]
>  - guest_va:		[52]
>  - guest_load_addr:	[low, high]

Wow, what a matrix!

In a later revision of this series it might be good to add support for
LPA2 guests in KVM selftests. We currently constrain the IPA size to
48bits on !64K kernels.

I'll have a deeper look at this series in the coming days.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
