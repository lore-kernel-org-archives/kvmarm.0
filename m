Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFD128FC
	for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 17:46:29 +0000 (UTC)
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Handle S1PTW translation with TCR_HA set
 as a write
Message-ID: <Y6NGcFXLtwOt0+d6@google.com>
References: <20221220200923.1532710-1-maz@kernel.org>
 <20221220200923.1532710-3-maz@kernel.org>
 <Y6M4TqvJytAEq2ID@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6M4TqvJytAEq2ID@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221221174624.LyZZj1ZVlXL0g6UPOPI-ulLHy5IGsG_9xGzG-ujAMm8@z>

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
