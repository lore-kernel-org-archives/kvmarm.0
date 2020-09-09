Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C609C43461
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 08:30:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E0C3215A4
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 08:30:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="PoOUXp6N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E0C3215A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD80A4B5EC;
	Wed,  9 Sep 2020 04:30:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vvyExLuvw1OL; Wed,  9 Sep 2020 04:30:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C50E24B5B6;
	Wed,  9 Sep 2020 04:30:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C53414B5B6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 04:30:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BhPqIa4hOivq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 04:30:45 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A08D54B5AE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 04:30:45 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id a17so1953914wrn.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2020 01:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=vNr2Ku1gGljilbGPEXcAx4EZtt5jVI1d5RcXLInGtb4=;
 b=PoOUXp6NbO1PbgnGP/chdt9lnZCh95AhtuD3rox2+jyV9udkzI+tqmzOuBsywgaRox
 gnpwwMffZ0fAkR3+xn7wEju6UAZWSxk3yVHDrDsitM6IMGZonEXRXovNQ8sdOl5hYG3x
 E5r7YDVfX663k4hv/BGAHOWjMF8GMctg9gJh7SLxtGZjeV+fCPdS7kWkLbYFbW/q6uMC
 BvAnLHnxz8m3tbaomWp+TGOWAaUUEaMyDh7zPuJFyhEVcew9xzEY+L41AeHveLONrl8T
 y/prKnlsJq4zFq48GweKTMJiey7EtHcWdWbg8dS0zPgyG855wkVyVRUcpp9tTwxYm0Xt
 F1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vNr2Ku1gGljilbGPEXcAx4EZtt5jVI1d5RcXLInGtb4=;
 b=NJ8f4a0IFZrdVtBIgZkcnq0awBl6JcxaVtg3RdH7c9C+N3yBDpIvLoOOdL23XUnVTw
 Fc1+sIM0+ysyN4CJZUmvxCkpCDAuAjB6BBxxrKJ4q+poxdqRrGDBomI5buegmtPvYxr9
 RuYMGrFQhNI4g/m225ZQx7GiMpGF/9DKPREpdjVCSKWF3rI5P4vocaktZht9/5aiRwnu
 LC9osIdyqnALORzUGY3ks85Z3hGJjBza1kXLGBUrCGFMwUed1oM0DFrh1EQA3nX76r2c
 wVqFlAL6HZiaM3j6839QjLu9djDOsNWjqkaMCy7g7eC9dX3udhzrTBPUkij+NSU6+kqw
 XhHA==
X-Gm-Message-State: AOAM532rMXUeYn76nRuZQgnDflS8/hMEVBW3VCdH83KS9PJPg5RXZuiu
 u3bRqDAfJqykfkmAKS94JVtf/w==
X-Google-Smtp-Source: ABdhPJw+71hj8Nq8tqsAAF8sQjgZxHrQ2bOt+j5Y9np5WDNJVjmT47uqrLWSNezwkBA1xUJZ09fWKQ==
X-Received: by 2002:a5d:67d2:: with SMTP id n18mr2614673wrw.223.1599640244388; 
 Wed, 09 Sep 2020 01:30:44 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id u66sm2872821wme.12.2020.09.09.01.30.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Sep 2020 01:30:43 -0700 (PDT)
Date: Wed, 9 Sep 2020 09:30:39 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 16/18] KVM: arm64: nVHE: Migrate hyp interface to SMCCC
Message-ID: <20200909083039.GA93664@google.com>
References: <20200903135307.251331-1-ascull@google.com>
 <20200903135307.251331-17-ascull@google.com>
 <87o8mhlld4.wl-maz@kernel.org>
 <20200908110222.GF3268721@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200908110222.GF3268721@google.com>
Cc: kernel-team@android.com, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 08, 2020 at 12:02:22PM +0100, Andrew Scull wrote:
> On Mon, Sep 07, 2020 at 03:20:07PM +0100, Marc Zyngier wrote:
> > On Thu, 03 Sep 2020 14:53:05 +0100,
> > Andrew Scull <ascull@google.com> wrote:
> > > 
> > > Rather than passing arbitrary function pointers to run at hyp, define
> > > and equivalent set of SMCCC functions.
> > > 
> > > Since the SMCCC functions are strongly tied to the original function
> > > prototypes, it is not expected for the host to ever call an invalid ID
> > > but a warning is raised if this does ever occur.
> > > 
> > > As __kvm_vcpu_run is used for every switch between the host and a guest,
> > > it is explicitly singled out to be identified before the other function
> > > IDs to improve the performance of the hot path.
> > > 
> > > Signed-off-by: Andrew Scull <ascull@google.com>
> > > Signed-off-by: David Brazdil <dbrazdil@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_asm.h   |  24 ++++++
> > >  arch/arm64/include/asm/kvm_host.h  |  25 ++++---
> > >  arch/arm64/kvm/arm.c               |   2 +-
> > >  arch/arm64/kvm/hyp.S               |  24 ++----
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 113 +++++++++++++++++++++++++----
> > >  5 files changed, 145 insertions(+), 43 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > > index 4bbde3d3989c..4a73f1349151 100644
> > > --- a/arch/arm64/include/asm/kvm_asm.h
> > > +++ b/arch/arm64/include/asm/kvm_asm.h
> > > @@ -38,6 +38,30 @@
> > >  
> > >  #define __SMCCC_WORKAROUND_1_SMC_SZ 36
> > >  
> > > +#define KVM_HOST_SMCCC_ID(id)						\
> > > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> > > +			   ARM_SMCCC_SMC_64,				\
> > > +			   ARM_SMCCC_OWNER_STANDARD_HYP,		\
> > > +			   (id))
> > > +
> > > +#define KVM_HOST_SMCCC_FUNC(name) KVM_HOST_SMCCC_ID(__KVM_HOST_SMCCC_FUNC_##name)
> > > +
> > > +#define __KVM_HOST_SMCCC_FUNC___kvm_hyp_init			0
> > > +#define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		1
> > > +#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		2
> > > +#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		3
> > > +#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_local_vmid	4
> > > +#define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		5
> > > +#define __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run			6
> > > +#define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
> > > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_ich_vtr_el2		8
> > > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr		9
> > > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr		10
> > > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs		11
> > > +#define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		12
> > > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
> > > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
> > 
> > Wait. This looks broken. How do you distinguish between these and the
> > stubs?
> 
> The __KVM_HOST_SMCCC_FUNC_* definitions are just the function ID part of
> the SMCCC x0 argument. KVM_HOST_SMCCC_ID builds it into a 64-bit
> fastcall owner by the hypervisor. The stubs fall into the legacy region
> so these don't conflict.

Looking again made me realize that I was using the service call region
for hypervisor standards rather than vendor hypervisors so I'll be
defining the vendor hyp region in arm-smccc.h to make use of here.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
