Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A88031D389
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 19:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592814; cv=none; b=juODNM+Eon5vdfXrOsNZAhouMmMFqBPVkarPzS5Z/EZoIFkdl4VU/1lHQF48piIsQhtp1c+d5UXenufCnCPZPejuJVIX1jrJtXWs3UKUYWVpsVcwiscRAQWcOd/A1ZhNmqB94Sv26Ro24rvBPFkWjIEDSKwiSgtRSfbjJ+eQtb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592814; c=relaxed/simple;
	bh=VJkG8MUTQ0ibSOiw5y5AGTqWzk7c71W2hsTJzLp4sxo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=svhhUoZd0V57Y1T/Dze6/UzLwvN8B5Ky2x4D82n++LO8ba5nVRubjAL9/d4Ha7l+/DyYUib4hGDv9PC/4DjnPRnxE5Cbhvrkppa6OelNjJRRvULoPfwp6VdDdlQkR7afwN4sNPYUheewJnElLE65Ew4Uogx8KTApQ/0IbgMgrq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e3WSHxZ6; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e3WSHxZ6"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-294a938fa37so45156835ad.2
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 12:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761592812; x=1762197612; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GJ/ihzhnBg2h+OIog5s51f1nDJzu1yBHwy2SCCUQ1bo=;
        b=e3WSHxZ6S6p40jmZRq9ArvECO6wFzVbFBJmZTGHmHRhIrBre2E/STPcaD9Gj8SMXWD
         loB4ooy5AECwb0BxZpUC+kSq3AyG2tli9Mx9xGpmPvEpUeAmjMEUXTGoSanntS/vZ1J7
         QzxclTMRh0k6zINCKjPmSgPRBZMwsXcIAR5HKuDm9hSXAnHEXJEfhya5/TJqcTJB/MED
         TstlXtnyb/NefTULzgzhXrSUuw+ooMxUOGFLo3ilkkunBZwGTM9sArUrV+8qOTIOKeW2
         tClED8BEHBRId1dD8w79Mso3Bs0S43vvZN6kmjSyBINIhTnTi/6K5BKTz2jTAgieH5TV
         m7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761592812; x=1762197612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GJ/ihzhnBg2h+OIog5s51f1nDJzu1yBHwy2SCCUQ1bo=;
        b=JbwoOpihPRCIZvXT69NcI9EkK4mC1WmtjpYj+9HP/992dXx0Oz6p7WDHCX1vLDzSmX
         ePK8sZRqS5/yrGmD6hbq3Lt2FDSVAcS/Y4if5af950JgmA2wCA5JBX28AL/Y+3ESxoVs
         sSBuwdoM1H6LPLhNhhE5ZAilI3jcvY0CcEp4Veq2l2hDM5iU/BVtQbWW5FdBCXR/F0ji
         yy7bifBPBZrH/h7Yft5ITd7ZqHyV2C+8mtXaH/T2LoFQZPMgWwlFjKBpiJbbF34jWPh+
         /e+XwiYpHJwViLfMlVnRP3Kpzl7Yxl3ZBwjgvuVzd5xGhevWIi+Ka5OeeWvt+vtOLXfR
         v8Hw==
X-Forwarded-Encrypted: i=1; AJvYcCWIHbK1baNTwI8MN15Sv40E8lAD0dSoiRHKtBAn/MFDgYMQBjCRlhQMxIWnUYTkxzxyPWkRJPw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3S1wC2SPPWYVisrTB2hMZuxjkJ4hu2SwBlqhZahOoRDdgPsog
	UEd+NTOK9CtyYg93lbZTBXb0VIQwUnwzrle9KNIDppkS1y8dWwwdYt5Mw5JZQUzDvK9IQVGDruZ
	IRtrRRQ==
X-Google-Smtp-Source: AGHT+IGEzxKOsu0TIx9JeJ8jo0iJqVMcVQCTPniC3ps1TgJ3BGzDUda18OgqbILlA0+mvKP7+G2jd9/+Iec=
X-Received: from pjbrs15.prod.google.com ([2002:a17:90b:2b8f:b0:33b:51fe:1a73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e5c4:b0:25d:1640:1d59
 with SMTP id d9443c01a7336-294cb378610mr8002455ad.8.1761592811798; Mon, 27
 Oct 2025 12:20:11 -0700 (PDT)
Date: Mon, 27 Oct 2025 12:20:10 -0700
In-Reply-To: <4809644b0ba02d0987ac56f4be7c426d0724cdef.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-21-seanjc@google.com>
 <4809644b0ba02d0987ac56f4be7c426d0724cdef.camel@intel.com>
Message-ID: <aP_F6tmzomRtdbpU@google.com>
Subject: Re: [PATCH v3 20/25] KVM: TDX: Add macro to retry SEAMCALLs when
 forcing vCPUs out of guest
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"kas@kernel.org" <kas@kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, 
	"zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, Vishal Annapurve <vannapurve@google.com>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 24, 2025, Kai Huang wrote:
> On Thu, 2025-10-16 at 17:32 -0700, Sean Christopherson wrote:
> > Add a macro to handle kicking vCPUs out of the guest and retrying
> > SEAMCALLs on -EBUSY instead of providing small helpers to be used by each
> > SEAMCALL.  Wrapping the SEAMCALLs in a macro makes it a little harder to
> > tease out which SEAMCALL is being made, but significantly reduces the
> > amount of copy+paste code and makes it all but impossible to leave an
> > elevated wait_for_sept_zap.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 72 ++++++++++++++----------------------------
> >  1 file changed, 23 insertions(+), 49 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index f6782b0ffa98..2e2dab89c98f 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -294,25 +294,24 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> >  	vcpu->cpu = -1;
> >  }
> >  
> > -static void tdx_no_vcpus_enter_start(struct kvm *kvm)
> > -{
> > -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > -
> > -	lockdep_assert_held_write(&kvm->mmu_lock);
> > -
> > -	WRITE_ONCE(kvm_tdx->wait_for_sept_zap, true);
> > -
> > -	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
> > -}
> > -
> > -static void tdx_no_vcpus_enter_stop(struct kvm *kvm)
> > -{
> > -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > -
> > -	lockdep_assert_held_write(&kvm->mmu_lock);
> > -
> > -	WRITE_ONCE(kvm_tdx->wait_for_sept_zap, false);
> > -}
> > +#define tdh_do_no_vcpus(tdh_func, kvm, args...)					\
> > +({										\
> > +	struct kvm_tdx *__kvm_tdx = to_kvm_tdx(kvm);				\
> > +	u64 __err;								\
> > +										\
> > +	lockdep_assert_held_write(&kvm->mmu_lock);				\
> > +										\
> > +	__err = tdh_func(args);							\
> > +	if (unlikely(tdx_operand_busy(__err))) {				\
> > +		WRITE_ONCE(__kvm_tdx->wait_for_sept_zap, true);			\
> > +		kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);	\
> > +										\
> > +		__err = tdh_func(args);						\
> > +										\
> > +		WRITE_ONCE(__kvm_tdx->wait_for_sept_zap, false);		\
> > +	}									\
> > +	__err;									\
> > +})
> 
> The comment which says "the second retry should succeed" is lost, could we
> add it to tdh_do_no_vcpus()?

+1, definitely needs a comment.

/*
 * Execute a SEAMCALL related to removing/blocking S-EPT entries, with a single
 * retry (if necessary) after forcing vCPUs to exit and wait for the operation
 * to complete.  All flows that remove/block S-EPT entries run with mmu_lock
 * held for write, i.e. are mutually exlusive with each other, but they aren't
 * mutually exclusive with vCPUs running (because that would be overkill), and
 * so can fail with "operand busy" if a vCPU acquires a required lock in the
 * TDX-Module.
 *
 * Note, the retry is guaranteed to succeed, absent KVM and/or TDX-Module bugs.
 */
 
> Also, perhaps we can just TDX_BUG_ON() inside tdh_do_no_vcpus() when the
> second call of tdh_func() fails?

Heh, this also caught my eye when typing up the comment.  Unfortunately, I don't
think it's worth doing the TDX_BUG_ON() inside the macro as that would require
plumbing in the UPPERCASE name, and doesn't work well with the variadic arguments,
e.g. TRACK wants TDX_BUG_ON(), but REMOVE and BLOCK want TDX_BUG_ON_2().

Given that REMOVE and BLOCK need to check the return value, getting the TDX_BUG_ON()
call into the macro wouldn't buy that much.
