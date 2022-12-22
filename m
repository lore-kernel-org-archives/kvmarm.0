Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55141C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 22 Dec 2022 20:58:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C46634BAD0;
	Thu, 22 Dec 2022 15:58:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j4qVXLWrL5LK; Thu, 22 Dec 2022 15:58:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C2AD4BAD2;
	Thu, 22 Dec 2022 15:58:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3D5F4BACF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Dec 2022 15:58:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LrYMHxIlWw-D for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Dec 2022 15:58:45 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7442C4BAD0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Dec 2022 15:58:45 -0500 (EST)
Date: Thu, 22 Dec 2022 20:58:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1671742723;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=A88a6NfVRxL2PmsR2uHcF7koD63KKHfsrryyz7ZbEMg=;
 b=GekcJjmcwCN5+4BBYAHuPzx/0eHRDr/6uMj/rLY5V7n/nDqPNtjolNlKTFHkvjtLIniNdY
 vpIKoEq20i0FGbhEfYB680aJy35ShWn5ABv2Hkdk2De4Wzrun0IaLOpqgiL8ZKst+985cy
 kAJCgpn9XrNKfaHQP/CR316ctF9WGvo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Handle S1PTW translation with TCR_HA set
 as a write
Message-ID: <Y6TFAClKlJgkFKef@google.com>
References: <20221220200923.1532710-1-maz@kernel.org>
 <20221220200923.1532710-3-maz@kernel.org>
 <Y6M4TqvJytAEq2ID@google.com> <Y6NGcFXLtwOt0+d6@google.com>
 <86ili3byn8.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86ili3byn8.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Dec 22, 2022 at 09:01:15AM +0000, Marc Zyngier wrote:
> On Wed, 21 Dec 2022 17:46:24 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> >  - When UFFD is in use, translation faults are reported to userspace as
> >    writes when from a RW memslot and reads when from an RO memslot.
> 
> Not quite: translation faults are reported as reads if TCR_EL1.HA
> isn't set, and as writes if it is. Ignoring TCR_EL1.HD for a moment,
> this matches exactly the behaviour of the page-table walker, which
> will update the S1 PTs only if this bit is set.

My bad, yes you're right. I conflated the use case here with the
architectural state.

I'm probably being way too pedantic, but I just wanted to make sure we
agree about the ensuing subtlety. More below:

> Or is it what userfaultfd does on its own? That'd be confusing...
> 
> > 
> >  - S1 page table memory is spuriously marked as dirty, as we presume a
> >    write immediately follows the translation fault. That isn't entirely
> >    senseless, as it would mean both the target page and the S1 PT that
> >    maps it are both old. This is nothing new I suppose, just weird.
> 
> s/old/young/ ?
> 
> I think you're confusing the PT access with the access that caused the
> PT access (I'll have that printed on a t-shirt, thank you very much).

I'd buy it!

> Here, we're not considering the cause of the PT access anymore. If
> TCR_EL1.HA is set, the S1 PT page will be marked as accessed even on a
> read, and only that page.

I think this is where the disconnect might be. TCR_EL1.HA == 1 suggests
a write could possibly follow, but I don't think it requires it. The
page table walker must first load the S1 PTE before writing to it.

From AArch64.S1Translate() (DDI0487H.a):

    (fault, descaddress, walkstate, descriptor) = AArch64.S1Walk(fault, walkparams, va, regime,
								 ss, acctype, iswrite, ispriv);

    [...]

    new_desc = descriptor;
    if walkparams.ha == '1' && AArch64.FaultAllowsSetAccessFlag(fault) then
      // Set descriptor AF bit
      new_desc<10> = '1';

    [...]

    // Either the access flag was clear or AP<2> is set
    if new_desc != descriptor then
      if regime == Regime_EL10 && EL2Enabled() then
        s1aarch64 = TRUE;
	s2fs1walk = TRUE;
	aligned = TRUE;
	iswrite = TRUE;
	(s2fault, descupdateaddress) = AArch64.S2Translate(fault, descaddress, s1aarch64,
							   ss, s2fs1walk, AccType_ATOMICRW,
							   aligned, iswrite, ispriv);

    if s2fault.statuscode != Fault_None then
      return (s2fault, AddressDescriptor UNKNOWN);
    else
      descupdateaddress = descaddress;

    (fault, mem_desc) = AArch64.MemSwapTableDesc(fault, descriptor, new_desc,
    						 walkparams.ee, descupdateaddress)

Buried in AArch64.S1Walk() is a stage-2 walk for a read to fetch the
descriptor. The second stage-2 walk for write is conditioned on having
already fetched the stage-1 descriptor and determining the AF needs
to be set.

Relating back to UFFD: if we expect KVM to do exactly what hardware
does, UFFD should see an attempted read when the first walk fails
because of an S2 translation fault. Based on this patch, though, we'd
promote it to a write if TCR_EL1.HA == 1.

This has the additional nuance of marking the S1 PT's IPA as dirty, even
though it might not actually have been written to. Having said that,
the false positive rate should be negligible given that S1 PTs ought to
account for a small amount of guest memory.

Like I said before, I'm probably being unnecessarily pedantic :) It just
seems to me that the view we're giving userspace of S1PTW aborts isn't
exactly architectural and I want to make sure that is explicitly
intentional.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
