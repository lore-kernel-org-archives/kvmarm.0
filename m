Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F24BC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Dec 2022 17:46:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A7B14B8A9;
	Wed, 21 Dec 2022 12:46:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TvkMdSytUuzX; Wed, 21 Dec 2022 12:46:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 745F34B8AA;
	Wed, 21 Dec 2022 12:46:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EDA04B8A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 12:46:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QetQKUUxz3B7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Dec 2022 12:46:28 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCBFB4B7F7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 12:46:28 -0500 (EST)
Date: Wed, 21 Dec 2022 17:46:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1671644788;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Lq0/8mv7tU3gkv2tPiEwF0HZqzKvAv+MhTUPgiXCBig=;
 b=BAHGWDxCiyH5CBuau1zbxP1aS3Nr/dlcsmE6N41OxCbyOrAoBs1dvdD4dkxNQ9kGfEhDEJ
 hMjnzKwzTaX1ELWgQn6MkBecf0shN38nKabz4kcn7hb1MWroIJDVsTs3ErL/A/Llv19dUO
 bEGY77OWkXqds/w8vnUhdgA5sFtyYik=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Handle S1PTW translation with TCR_HA set
 as a write
Message-ID: <Y6NGcFXLtwOt0+d6@google.com>
References: <20221220200923.1532710-1-maz@kernel.org>
 <20221220200923.1532710-3-maz@kernel.org>
 <Y6M4TqvJytAEq2ID@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y6M4TqvJytAEq2ID@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Dec 21, 2022 at 08:46:06AM -0800, Ricardo Koller wrote:

[...]

> > -			return false;
> > +			/* Can't introspect TCR_EL1 with pKVM */
> > +			if (kvm_vm_is_protected(vcpu->kvm))
> > +				return false;
> > +
> > +			mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > +			afdb = cpuid_feature_extract_unsigned_field(mmfr1, ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
> > +
> > +			if (afdb == ID_AA64MMFR1_EL1_HAFDBS_NI)
> > +				return false;
> > +
> > +			return (vcpu_read_sys_reg(vcpu, TCR_EL1) & TCR_HA);
> 
> Also tested this specific case using page_fault_test when the PT page is
> marked for dirty logging with and without AF. In both cases there's a
> single _FSC_FAULT (no PERM_FAUT) as expected, and the PT page is marked dirty
> in the AF case. The RO and UFFD cases also work as expected.
> 
> Need to send some changes for page_fault_test as many tests assume that
> any S1PTW is always a PT write, and are failing. Also need to add some new
> tests for PTs in RO memslots (as it didn't make much sense before this
> change).

So I actually wanted to bring up the issue of user visibility, glad your
test picked up something.

This has two implications, which are rather odd.

 - When UFFD is in use, translation faults are reported to userspace as
   writes when from a RW memslot and reads when from an RO memslot.

 - S1 page table memory is spuriously marked as dirty, as we presume a
   write immediately follows the translation fault. That isn't entirely
   senseless, as it would mean both the target page and the S1 PT that
   maps it are both old. This is nothing new I suppose, just weird.

Marc, do you have any concerns about leaving this as-is for the time
being? At least before we were doing the same thing (write fault) every
time.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
