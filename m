Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB584C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 23 Dec 2022 00:33:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47B014BB3A;
	Thu, 22 Dec 2022 19:33:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V8nKjJxAzoLp; Thu, 22 Dec 2022 19:33:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F336F4BB17;
	Thu, 22 Dec 2022 19:33:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DE7F4BB31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Dec 2022 19:33:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yXOYlY7WyZQ6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Dec 2022 19:33:36 -0500 (EST)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E9524BB16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Dec 2022 19:33:36 -0500 (EST)
Received: by mail-pj1-f50.google.com with SMTP id
 o1-20020a17090a678100b00219cf69e5f0so7352533pjj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Dec 2022 16:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=3SnnWK2Yn0kyk7GHu2M0DJEtHKPpePG30TC/rB02220=;
 b=pux3Eczt9o7v57Vha09NoD0CZwgZukOQ8CNR88RBhCONIrU7gn+hgrP53dVZpTYpgB
 XNsOnhlwYkKxxLuz3iR6gtBOwCK2JAjhhB195u2s1pykEt0IUu1A0MAZ/iT86mPgmroV
 R5jkXUOJf0oiDWOfuhnqYka5nAhY5MVcVET556Nh/gqIOeCADwVXiPUz5Rubz+ZCZkRG
 KhTeq9+TBch7q0lzkGmMRS/CoXRJlfE7w+qVkeKudJuEeCp54JdqnEp+pptDc54VBMxL
 l3fcx3TkbRihSBQGeuFp2OM8CbeaaXWJVKyeiJ6SjQi7m/76MA5gxQUWa0Z4cM3v8TLy
 ueFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=3SnnWK2Yn0kyk7GHu2M0DJEtHKPpePG30TC/rB02220=;
 b=mn2FThLno/xjx/m+gtz9lXSHr6rGD7dfdbhlY2hB6X1h3mIgxPG+l6vw1g4zpFS09Q
 lR9M7feUuCpjTG7U0crMFsmPXgx1aE3N+mhsjt18aIwNBq9iVdreG/RPCXdBsWdaMzYH
 32PQ5Sy2BDxsZM9rqLz0lTShL3CkXk0Az6KUjnJfPCjXRU9LMOXRKfhWMWOf8TuvURzY
 6UBtuajrTDiHP97WjfhhjJoDsfc5prBkzB2xf/8eDbiRdxw+sRKLX3nM90A7fJ0lPzxK
 GoWh+bPKhezsDhJRSeGHFE4IO+ODUw6P6NNhOVODTmYng7qo2vlyZVccif+F0tFu7qVB
 Qk/Q==
X-Gm-Message-State: AFqh2krSUmLSiOdyo5doiloDYa+TnlB8rQ2hIYuJygPi5jlsdxYmi+zA
 JDtXAiRWHE8Djk6ioiq+rZySrQ==
X-Google-Smtp-Source: AMrXdXvQgA5PcrwGJ6ExX4g/wBYdgRBMgQzBvslBOJ24nda1rowog9Yon9hIjf2jj7oDDELe19sSmg==
X-Received: by 2002:a05:6a20:2a9f:b0:a4:efde:2ed8 with SMTP id
 v31-20020a056a202a9f00b000a4efde2ed8mr1644018pzh.0.1671755615505; 
 Thu, 22 Dec 2022 16:33:35 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 d6-20020a170902654600b0019255ab4dc8sm1118649pln.66.2022.12.22.16.33.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Dec 2022 16:33:34 -0800 (PST)
Date: Thu, 22 Dec 2022 16:33:31 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Handle S1PTW translation with TCR_HA set
 as a write
Message-ID: <Y6T3W9qtA3v42d0z@google.com>
References: <20221220200923.1532710-1-maz@kernel.org>
 <20221220200923.1532710-3-maz@kernel.org>
 <Y6M4TqvJytAEq2ID@google.com> <86len0bql4.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86len0bql4.wl-maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
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

Hi Marc,

On Wed, Dec 21, 2022 at 05:43:03PM +0000, Marc Zyngier wrote:
> Hi Ricardo,
> 
> On Wed, 21 Dec 2022 16:46:06 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Hello,
> > 
> > On Tue, Dec 20, 2022 at 08:09:22PM +0000, Marc Zyngier wrote:
> > > As a minor optimisation, we can retrofit the "S1PTW is a write
> > > even on translation fault" concept *if* the vcpu is using the
> > > HW-managed Access Flag, as setting TCR_EL1.HA is guaranteed
> > > to result in an update of the PTE.
> > > 
> > > However, we cannot do the same thing for DB, as it would require
> > > us to parse the PTs to find out if the DBM bit is set there.
> > > This is not going to happen.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/kvm_emulate.h | 20 +++++++++++++++++++-
> > >  1 file changed, 19 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > > index fd6ad8b21f85..4ee467065042 100644
> > > --- a/arch/arm64/include/asm/kvm_emulate.h
> > > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > > @@ -374,6 +374,9 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
> > >  static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
> > >  {
> > >  	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> > > +		unsigned int afdb;
> > > +		u64 mmfr1;
> > > +
> > >  		/*
> > >  		 * Only a permission fault on a S1PTW should be
> > >  		 * considered as a write. Otherwise, page tables baked
> > > @@ -385,12 +388,27 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
> > >  		 * to map the page containing the PT (read only at
> > >  		 * first), then a permission fault to allow the flags
> > >  		 * to be set.
> > > +		 *
> > > +		 * We can improve things if the guest uses AF, as this
> > > +		 * is guaranteed to result in a write to the PTE. For
> > > +		 * DB, however, we'd need to parse the guest's PTs,
> > > +		 * and that's not on. DB is crap anyway.
> > >  		 */
> > >  		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
> > 
> > Nit: fault_status is calculated once when taking the fault, and passed
> > around to all users (like user_mem_abort()). Not sure if this is because
> > of the extra cycles needed to get it, or just style. Anyway, maybe it
> > applies here.
> 
> All these things are just fields in ESR_EL2, which we keep looking at
> all the time. The compiler actually does a pretty good job at keeping
> that around, specially considering that this function is inlined (at
> least here, kvm_handle_guest_abort and kvm_user_mem_abort are merged
> into a single monster).
> 
> So passing the parameter wouldn't change a thing, and I find the above
> more readable (I know that all the information in this function are
> derived from the same data structure).
>

Got it, thanks for the info.

> > 
> > >  		case ESR_ELx_FSC_PERM:
> > >  			return true;
> > >  		default:
> > > -			return false;
> > > +			/* Can't introspect TCR_EL1 with pKVM */
> > > +			if (kvm_vm_is_protected(vcpu->kvm))
> > > +				return false;
> > > +
> > > +			mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > > +			afdb = cpuid_feature_extract_unsigned_field(mmfr1, ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
> > > +
> > > +			if (afdb == ID_AA64MMFR1_EL1_HAFDBS_NI)
> > > +				return false;
> > > +
> > > +			return (vcpu_read_sys_reg(vcpu, TCR_EL1) & TCR_HA);
> > 
> > Also tested this specific case using page_fault_test when the PT page is
> > marked for dirty logging with and without AF. In both cases there's a
> > single _FSC_FAULT (no PERM_FAUT) as expected, and the PT page is marked dirty
> > in the AF case. The RO and UFFD cases also work as expected.
> 
> Ah, thanks for checking this.
> 
> > 
> > Need to send some changes for page_fault_test as many tests assume that
> > any S1PTW is always a PT write, and are failing. Also need to add some new
> > tests for PTs in RO memslots (as it didn't make much sense before this
> > change).
> 
> I think this is what I really quite didn't grok in these tests. They
> seem to verify the KVM behaviour, which is not what we should check
> for.
> 
> Instead, we should check for the architectural behaviour, which is
> that if HAFDBS is enabled, we can observe updates to the PTs even when
> we do not write to them directly.

There are some tests checking that case (e.g., AF set by HW), but they
also do it while interacting with dirty-logging, userfaultfd, and/or RO
memslots. Some checks are clearly dealing with architectural behavior,
while others are not that clear. Let me use this sample test to get more
specific.  This test deals with HW setting the AF bit on a punched hole
backed by userfaultfd:

TEST_UFFD(guest_exec, with_af, CMD_HOLE_PT, ...):
	1. set TCR_EL1.HA and clear the AF in the test-data PTE,
	2. punch a hole on the test-data PTE page, and register it for
	   userfaultfd,
	3. execute code in the test-data page; this triggers a S1PTW,
	4. assert that there is a userfaultfd _write_ fault on the PT page,
	5. assert that the test-data instruction was executed,
	6. assert that the AF is set on the test-data PTE,

IIUC, only checking for architectural behavior implies skipping step 4.
And I agree, it might be a good idea to skip 4, as it actually depends
on whether the kernel has only the previous commit, or both the previous
and this one. The fault is a _write_ at this commit, and a _read_ at the
previous.

The issue is that there are some cases where checking KVM behavior could
be useful. For example, this dirty_logging test can also help (besides
testing dirty-logging) for checking regressions of commit c4ad98e4b72c
("KVM: arm64: Assume write fault on S1PTW permission fault on
instruction fetch"):

TEST_DIRTY_LOG(guest_exec, with_af, ...)
	1. set TCR_EL1.HA and clear the AF in the test-data PTE,
	2. enable dirty logging on the PT memslot,
	3. execute code in the test-data page; this triggers a S1PTW,
	4. assert that the test-data PTE page is dirty on the log,
	5. assert that the test-data instruction was executed,
	6. assert that the AF is set on the test-data PTE,

Step 4 above is not exactly checking architectural behavior, but I think
it's still useful.

So, regarding what to do with page_fault_test. As a start, I need to go
through all tests and make sure they pass at both this and the previous
commit. Next, I have to identify other tests that also need to be
relaxed a bit (removing some test asserts).

Thanks,
Ricardo

> 
> > 
> > >  		}
> > >  	}
> > >  
> > > -- 
> > > 2.34.1
> > > 
> > > _______________________________________________
> > > kvmarm mailing list
> > > kvmarm@lists.cs.columbia.edu
> > > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> > 
> > Reviewed-by: Ricardo Koller <ricarkol@google.com>
> 
> Thanks!
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
