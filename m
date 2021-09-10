Return-Path: <SRS0=KxuI=OA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFEFC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 19:32:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6094A611EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 19:32:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6094A611EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D68134B1BA;
	Fri, 10 Sep 2021 15:32:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pBHNZFNoJLSz; Fri, 10 Sep 2021 15:32:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F52D4B1C9;
	Fri, 10 Sep 2021 15:32:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 537244B1BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 15:32:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tUa2QE1p8Z2y for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Sep 2021 15:32:11 -0400 (EDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 083504B173
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 15:32:11 -0400 (EDT)
Received: by mail-pj1-f50.google.com with SMTP id t20so2043539pju.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 12:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=gp/EtrgVV0pqgAxNAgUDSeBZ+pTvYj4FQRlJ1GMLFEU=;
 b=AuY6LIJxJFI0BygWczR7RWIpobT48uhXYq/QvfUlCY2F2I0YalDnxjBhUMIr62Sg8E
 4IlZDKKjWK7MLYPcreaZ0X1Ilrxo/tGZOrvIE1iOHXhCYxwEyKNddT2U1bQJron5k0Sx
 ZDrP2tbC8Bf35TrbfoqPaLSbT9sL/Fgv/5uIhDJiuO9wUtFqmLsqEXDIE55iiVi2SjUU
 qSBbiZFEzmFSwOwlFRTQStZ5ljt1Buo1xGWjG/u/EiIMmxjsKMQl2BiPAdde/Hj95btQ
 XO0Am4J0baDlBhg260FYw9vdd1rYHzVyl3sexJA3W3i7xgKEs2PAMMC0LxRhaJID/giR
 UGwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=gp/EtrgVV0pqgAxNAgUDSeBZ+pTvYj4FQRlJ1GMLFEU=;
 b=0z4834ER952NfAhlL4+BMeGXzcWE5Ba12dXkNJFr+NQM37pxZ/fhaVHvXt85j38nwf
 HxOqev7QgIz5H4DmrrrSZ+aH2SVaCL48sz4b880JE9u9o5vbmnv7jUiVK5Sp60C8fKWm
 QxDKyI5cQePEWDLKye1GVKxEpGPHBNJU9ZW/GGPJWmGJ8mL2U80+90YHmdkxcm6JZXWr
 x6mdb8pvhfLPs9YeH3zKt9jD+YtU2mIN1HztBuQens83BDFAp5yjTcVUDLgxobfLttVP
 b4vqAZSlMW2pAdWjH5bmbPWsMgPzgZHKSQuXLcazmJcwdNXh9osUGuVFbp94Avgyi5Zy
 4Z9g==
X-Gm-Message-State: AOAM530g+KeUY0/2zVKba8iL5SL8sT2zsK/VlckLEELndzXI5ZQ49zR8
 eiU8XOej/Kmj8uaqpJJmO1wGIQ==
X-Google-Smtp-Source: ABdhPJx7k1Xe3NcxnUviUrljAE+Zul5MGB53kScveWe4Yie9kWrVt15hLLhM0LFtFUt7WR4y2CTMGA==
X-Received: by 2002:a17:902:db05:b0:139:1b8:10c0 with SMTP id
 m5-20020a170902db0500b0013901b810c0mr8811814plx.26.1631302329725; 
 Fri, 10 Sep 2021 12:32:09 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id a71sm5922769pfd.86.2021.09.10.12.32.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 10 Sep 2021 12:32:09 -0700 (PDT)
Date: Fri, 10 Sep 2021 12:32:05 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
Message-ID: <YTuytfGTDlaoz0yH@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
 <YTo6kX7jGeR3XvPg@google.com>
 <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
 <80bdbdb3-1bff-aa99-c49b-76d6bd960aa9@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <80bdbdb3-1bff-aa99-c49b-76d6bd960aa9@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

Hi Alexandru and Eric,

On Fri, Sep 10, 2021 at 10:42:23AM +0200, Eric Auger wrote:
> Hi Alexandru,
> =

> On 9/10/21 10:28 AM, Alexandru Elisei wrote:
> > Hi Ricardo,
> >
> > On 9/9/21 5:47 PM, Ricardo Koller wrote:
> >> On Thu, Sep 09, 2021 at 11:20:15AM +0100, Alexandru Elisei wrote:
> >>> Hi Ricardo,
> >>>
> >>> On 9/8/21 10:03 PM, Ricardo Koller wrote:
> >>>> Extend vgic_v3_check_base() to verify that the redistributor regions
> >>>> don't go above the VM-specified IPA size (phys_size). This can happen
> >>>> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> >>>>
> >>>>   base + size > phys_size AND base < phys_size
> >>>>
> >>>> vgic_v3_check_base() is used to check the redist regions bases when
> >>>> setting them (with the vcpus added so far) and when attempting the f=
irst
> >>>> vcpu-run.
> >>>>
> >>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> >>>> ---
> >>>>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
> >>>>  1 file changed, 4 insertions(+)
> >>>>
> >>>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgi=
c-v3.c
> >>>> index 66004f61cd83..5afd9f6f68f6 100644
> >>>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> >>>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> >>>> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >>>>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >>>>  			rdreg->base)
> >>>>  			return false;
> >>>> +
> >>>> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> >>>> +			kvm_phys_size(kvm))
> >>>> +			return false;
> >>> Looks to me like this same check (and the overflow one before it) is =
done when
> >>> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set_r=
edist_base()
> >>> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as I =
can tell,
> >>> kvm_vgic_addr() handles both ways of setting the Redistributor addres=
s.
> >>>
> >>> Without this patch, did you manage to set a base address such that ba=
se + size >
> >>> kvm_phys_size()?
> >>>
> >> Yes, with the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API. The easiest way
> >> to get to this situation is with the selftest in patch 2.  I then tried
> >> an extra experiment: map the first redistributor, run the first vcpu,
> >> and access the redist from inside the guest. KVM didn't complain in any
> >> of these steps.
> > Yes, Eric pointed out that I was mistaken and there is no check being d=
one for
> > base + size > kvm_phys_size().
> >
> > What I was trying to say is that this check is better done when the use=
r creates a
> > Redistributor region, not when a VCPU is first run. We have everything =
we need to
> > make the check when a region is created, why wait until the VCPU is run?
> >
> > For example, vgic_v3_insert_redist_region() is called each time the add=
s a new
> > Redistributor region (via either of the two APIs), and already has a ch=
eck for the
> > upper limit overflowing (identical to the check in vgic_v3_check_base()=
). I would
> > add the check against the maximum IPA size there.
> you seem to refer to an old kernel as vgic_v3_insert_redist_region was
> renamed into=A0 vgic_v3_alloc_redist_region in
> e5a35635464b kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region()
> =

> I think in case you use the old rdist API you do not know yet the size
> of the redist region at this point (count=3D0), hence Ricardo's choice to
> do the check latter.

Just wanted to add one more detail. vgic_v3_check_base() is also called
when creating the redistributor region (via vgic_v3_set_redist_base ->
vgic_register_redist_iodev). This patch reuses that check for the old
redist API to also check for "base + size > kvm_phys_size()" with a size
calculated using the vcpus added so far.

> >
> > Also, because vgic_v3_insert_redist_region() already checks for overflo=
w, I
> > believe the overflow check in vgic_v3_check_base() is redundant.
> >

It's redundant for the new redist API, but still needed for the old
redist API.

> > As far as I can tell, vgic_v3_check_base() is there to make sure that t=
he
> > Distributor doesn't overlap with any of the Redistributors, and because=
 the
> > Redistributors and the Distributor can be created in any order, we defe=
r the check
> > until the first VCPU is run. I might be wrong about this, someone pleas=
e correct
> > me if I'm wrong.
> >
> > Also, did you verify that KVM is also doing this check for GICv2? KVM d=
oes
> > something similar and calls vgic_v2_check_base() when mapping the GIC r=
esources,
> > and I don't see a check for the maximum IPA size in that function eithe=
r.
> =

> I think vgic_check_ioaddr() called in kvm_vgic_addr() does the job (it
> checks the base @)
>

It seems that GICv2 suffers from the same problem. The cpu interface
base is checked but the end can extend above IPA size. Note that the cpu
interface is 8KBs and vgic_check_ioaddr() is only checking that its base
is 4KB aligned and below IPA size. The distributor region is 4KB so
vgic_check_ioaddr() is enough in that case.

What about the following?

I can work on the next version of this patch (v2 has the GICv2 issue)
which adds vgic_check_range(), which is like vgic_check_ioaddr() but
with a size arg.  kvm_vgic_addr() can then call vgic_check_range() and
do all the checks for GICv2 and GICv3. Note that for GICv2, there's no
need to wait until first vcpu run to do the check. Also note that I will
have to keep the change in vgic_v3_check_base() to check for the old v3
redist API at first vcpu run.

Thanks,
Ricardo

> Thanks
> =

> Eric
> >
> > Thanks,
> >
> > Alex
> >
> >> Thanks,
> >> Ricardo
> >>
> >>> Thanks,
> >>>
> >>> Alex
> >>>
> >>>>  	}
> >>>>  =

> >>>>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> =

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
