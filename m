Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_NONE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6709CC43461
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 11:02:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA054208DB
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 11:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="b1dr7Of+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA054208DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4724A4B44E;
	Tue,  8 Sep 2020 07:02:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yqL5GJpLcqoU; Tue,  8 Sep 2020 07:02:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5115D4B4F1;
	Tue,  8 Sep 2020 07:02:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A01F14B44E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 07:02:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lFSztV71KLpJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 07:02:28 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 993124B30B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 07:02:28 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id l9so16718098wme.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Sep 2020 04:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ukRFS2c9kQoV0ZHewMEPqAGuZjsAWs/CsNrEJEq1jGs=;
 b=b1dr7Of+AcozrYtjVhgnYWTfqOAe7Go1Ua1gItyhju31PiiJ7B/fFjWmmzjrHoSWP7
 XHfsdP3Gm+o+STk+0YuHKk2Su/kBsxqqVZhMD2zUjOpzMZKHWUNN7zEAB07Zd8y4u01I
 k+cIkt33uhxUp9c/fq+LoDXkUZK+Tf7AFLIRVF0rFJsCSO5BA0zPIQD0f5iQadkqxL7O
 8oK9MZfIHlR3uoJmh92Dg+5nFjkwWa8GKph2UFBDnmFX8RUMT7sb3A105Q0QVyqRQC00
 tUAUh/ActjmP5C506NPrTPF+YqAzkyQB5LnimOQIApIkUU6N2S9KsEoN4nTewa21gftr
 O5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ukRFS2c9kQoV0ZHewMEPqAGuZjsAWs/CsNrEJEq1jGs=;
 b=CejNya4tPGMMwW4DRIlPazdqcBjS2OksFIqOoqzxhEeEKPM20jFZmhbh+bKnu42Fnq
 16//MpM6ys+MD9Adc+EJ+YIIRhaBLgeb0Lq2EtH7X8U6wpRDxw5uwPjBeY8ilOvG6jzL
 oQ9vxC4jK/Co4n8sO3q3ODwnWgjEpmJyhh/EGkSKwmjFXqr9pVhMoeyIj5cb/Jjt9smy
 cVk0M8HeuXo58g3C4upzv0JfTioPtaRVS4HMdpgtmxChQEkpPUKgUG/X68sF0SHtKok+
 eB/JPocuYhhYJhP7vz7AFKw3SAzvbM8dl22apUoSw4C0abWVaXl7yZtHIx8cxJys0EZs
 3GqA==
X-Gm-Message-State: AOAM532KWAt3ECHG4PnzEY1hIM/43ruTR/SAaaZI8rqonjc88kJXHOCf
 Kjgk3+kc/7gpXj6xNlsivStHwg==
X-Google-Smtp-Source: ABdhPJwoSvNMFVJfZn/T4Sse44Bn5jyzINix2w2Rt4VLmZDdUQPWjxIJJJ2/pU1GAZwXegW0S1VY5Q==
X-Received: by 2002:a1c:ba42:: with SMTP id k63mr3749849wmf.31.1599562947440; 
 Tue, 08 Sep 2020 04:02:27 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id 8sm36211588wrl.7.2020.09.08.04.02.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Sep 2020 04:02:26 -0700 (PDT)
Date: Tue, 8 Sep 2020 12:02:22 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 16/18] KVM: arm64: nVHE: Migrate hyp interface to SMCCC
Message-ID: <20200908110222.GF3268721@google.com>
References: <20200903135307.251331-1-ascull@google.com>
 <20200903135307.251331-17-ascull@google.com>
 <87o8mhlld4.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87o8mhlld4.wl-maz@kernel.org>
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

On Mon, Sep 07, 2020 at 03:20:07PM +0100, Marc Zyngier wrote:
> On Thu, 03 Sep 2020 14:53:05 +0100,
> Andrew Scull <ascull@google.com> wrote:
> > 
> > Rather than passing arbitrary function pointers to run at hyp, define
> > and equivalent set of SMCCC functions.
> > 
> > Since the SMCCC functions are strongly tied to the original function
> > prototypes, it is not expected for the host to ever call an invalid ID
> > but a warning is raised if this does ever occur.
> > 
> > As __kvm_vcpu_run is used for every switch between the host and a guest,
> > it is explicitly singled out to be identified before the other function
> > IDs to improve the performance of the hot path.
> > 
> > Signed-off-by: Andrew Scull <ascull@google.com>
> > Signed-off-by: David Brazdil <dbrazdil@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   |  24 ++++++
> >  arch/arm64/include/asm/kvm_host.h  |  25 ++++---
> >  arch/arm64/kvm/arm.c               |   2 +-
> >  arch/arm64/kvm/hyp.S               |  24 ++----
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 113 +++++++++++++++++++++++++----
> >  5 files changed, 145 insertions(+), 43 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 4bbde3d3989c..4a73f1349151 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -38,6 +38,30 @@
> >  
> >  #define __SMCCC_WORKAROUND_1_SMC_SZ 36
> >  
> > +#define KVM_HOST_SMCCC_ID(id)						\
> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> > +			   ARM_SMCCC_SMC_64,				\
> > +			   ARM_SMCCC_OWNER_STANDARD_HYP,		\
> > +			   (id))
> > +
> > +#define KVM_HOST_SMCCC_FUNC(name) KVM_HOST_SMCCC_ID(__KVM_HOST_SMCCC_FUNC_##name)
> > +
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_hyp_init			0
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		1
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		2
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		3
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_local_vmid	4
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		5
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run			6
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_ich_vtr_el2		8
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr		9
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr		10
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs		11
> > +#define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		12
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
> > +#define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
> 
> Wait. This looks broken. How do you distinguish between these and the
> stubs?

The __KVM_HOST_SMCCC_FUNC_* definitions are just the function ID part of
the SMCCC x0 argument. KVM_HOST_SMCCC_ID builds it into a 64-bit
fastcall owner by the hypervisor. The stubs fall into the legacy region
so these don't conflict.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
