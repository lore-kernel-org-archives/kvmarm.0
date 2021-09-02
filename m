Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685E7C4320E
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 12:37:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D51A3610A2
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 12:37:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D51A3610A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52F594B0FC;
	Thu,  2 Sep 2021 08:37:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T2t6U9nzlnDx; Thu,  2 Sep 2021 08:37:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4514B126;
	Thu,  2 Sep 2021 08:37:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF3C64B126
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 08:37:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2AmxzW8U95ex for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 08:37:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E04C24B0FC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 08:37:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630586221;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=XjZNhaTHu2G7qvKup1PDbiF+IV6d0VDmwJ2nyMbiAo4=;
 b=hTc+0nOGWv3vnX0quMZEGLL03iWamMRUPh3a82A4At0YGNUZnZ8vkKOuVrc0cK9iRNni5V
 /eU2iYtPNX/7may8JybFEo3ITkUZKDLqMqrtIE9FDt6SHrCcx8a8MSXaU1w11cMSRPaDH/
 KWAPzXbv+HPLLv+StuMgASZWgBPZaZ0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-HQOLOIj0PXezeiqokBdxiA-1; Thu, 02 Sep 2021 08:36:59 -0400
X-MC-Unique: HQOLOIj0PXezeiqokBdxiA-1
Received: by mail-wr1-f70.google.com with SMTP id
 v6-20020adfe4c6000000b001574f9d8336so485254wrm.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 05:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XjZNhaTHu2G7qvKup1PDbiF+IV6d0VDmwJ2nyMbiAo4=;
 b=uHDXfYtz/gC/jp/S6Qtq+4ccgUxeih7vLPxy8wvrwMkXJDSpweTAL4o2Akl1PyALtK
 hXsiGarSht6ojUjhyQ0m1n7OXpnP0i84QqaF3p5m3qi2gwgbVi+UggUeYEkCLhsqNitl
 rU3BsQBEWu+t4pLp3WCSeuQYqNQ4FChw8I2dq8UaJm4rm7ltIWQ0LRmEdsbkkUlWCx44
 hDMstDJ2KO/Ntmk8pluWKNxwDtcd5P10TzVKy64kjLoUgl6O/yx55/N2ed82itNefJes
 nCQIIX5iWk9DGLcVsqUCHk1mcGOPFksf4bgaNaewdHzyHma7cLEG4vKdGOaPW33QYFMj
 JsQw==
X-Gm-Message-State: AOAM530Ye5ptHuLcoOG2w8u7M02neaUasiVBib3t2MbLZoyoT0eRAe6R
 08imiYrTjxYCl5Qu9likxHOcdri2EQdZHRQqJz+sZX0Xflj2iDw5T0oVHdQ9qkJDSsT5sqfrq/p
 5j5I4a+Brocc9vinRGvJL0aeK
X-Received: by 2002:adf:dfc5:: with SMTP id q5mr3490261wrn.5.1630586218650;
 Thu, 02 Sep 2021 05:36:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyda7YkzbAIwptDdwUxeFFJ3yXbh0EqmH9ayktJ/+cOAYBlktEFMuEzHFWPK2Zg6EPNQDNukw==
X-Received: by 2002:adf:dfc5:: with SMTP id q5mr3490239wrn.5.1630586218485;
 Thu, 02 Sep 2021 05:36:58 -0700 (PDT)
Received: from gator (nat-pool-brq-t.redhat.com. [213.175.37.10])
 by smtp.gmail.com with ESMTPSA id k16sm1774372wrx.87.2021.09.02.05.36.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 05:36:58 -0700 (PDT)
Date: Thu, 2 Sep 2021 14:36:56 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 07/12] KVM: arm64: selftests: Add support to get the
 vcpuid from MPIDR_EL1
Message-ID: <20210902123656.lfzwqrlw5kbvckah@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-8-rananta@google.com>
 <YTARPBhMHXjgcPlg@google.com>
MIME-Version: 1.0
In-Reply-To: <YTARPBhMHXjgcPlg@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

On Wed, Sep 01, 2021 at 11:48:12PM +0000, Oliver Upton wrote:
> On Wed, Sep 01, 2021 at 09:14:07PM +0000, Raghavendra Rao Ananta wrote:
> > At times, such as when in the interrupt handler, the guest wants to
> > get the vCPU-id that it's running on. As a result, introduce
> > get_vcpuid() that parses the MPIDR_EL1 and returns the vcpuid to the
> > requested caller.
> > 
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/processor.h | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index c35bb7b8e870..8b372cd427da 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -251,4 +251,23 @@ static inline void local_irq_disable(void)
> >  	asm volatile("msr daifset, #3" : : : "memory");
> >  }
> >  
> > +#define MPIDR_LEVEL_BITS 8
> > +#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
> > +#define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
> > +#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
> > +	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK)
> > +
> > +static inline uint32_t get_vcpuid(void)
> > +{
> > +	uint32_t vcpuid = 0;
> > +	uint64_t mpidr = read_sysreg(mpidr_el1);
> > +
> > +	/* KVM limits only 16 vCPUs at level 0 */
> > +	vcpuid = mpidr & 0x0f;
> > +	vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 1) << 4;
> > +	vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 2) << 12;
> > +
> > +	return vcpuid;
> > +}
> 
> Are we guaranteed that KVM will always compose vCPU IDs the same way? I
> do not believe this is guaranteed ABI.

I don't believe we are. At least in QEMU we take pains to avoid that
assumption.

> 
> For the base case, you could pass the vCPU ID as an arg to the guest
> function.
> 
> I do agree that finding the vCPU ID is a bit more challenging in an
> interrupt context. Maybe use a ucall to ask userspace? But of course,
> every test implements its own run loop, so its yet another case that
> tests need to handle.
> 
> Or, you could allocate an array at runtime of length KVM_CAP_MAX_VCPUS
> (use the KVM_CHECK_EXTENSION ioctl to get the value). Once all vCPUs are
> instantiated, iterate over them from userspace to populate the {MPIDR,
> VCPU_ID} map. You'd need to guarantee that callers initialize the vGIC
> *after* adding vCPUs to the guest.

I agree with this approach. It may even make sense to create a common
function that returns a {cpu_id,vcpu_index} map for other tests to use.

Thanks,
drew

> 
> --
> Thanks,
> Oliver
> 
> >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
