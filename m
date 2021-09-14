Return-Path: <SRS0=7Ft5=OE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F94C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 03:20:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62E8A6113E
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 03:20:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 62E8A6113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D40774B0C2;
	Mon, 13 Sep 2021 23:20:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F5UXB3kTx2Uw; Mon, 13 Sep 2021 23:20:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE624B187;
	Mon, 13 Sep 2021 23:20:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EB554B0C2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 23:20:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u3ZQJt24Cpu3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 23:20:50 -0400 (EDT)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39432401A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 23:20:50 -0400 (EDT)
Received: by mail-pg1-f181.google.com with SMTP id g184so11373860pgc.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 20:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=pUjEFPKNx1O9WzlN4Kw5jO3Lwl0ZxDuARimA6uJp1m0=;
 b=g2CNxhF0mDFL+5WB2rhy2fUthXDWMK4oFBPJ/CTC7ECkycYskSddAsVq8J5eVMhXIz
 alsmIoruq3w5FQ9gvwE8cR8cItAo4gWvXnSjmHRsLG1DrBGx2Qku8jBYHYwhs5mRKJts
 KFiNTmZhTOXgWQ0btiR6v8P8GGz5Dj1G6q8AUAqSzp9AON90DG8hjDD+MaKskJKwDm/8
 QZBEMRDKwroS/VD87J3Tk8VTKjek22vdtmMO2C3hqpoa0xqczKiw4o2K8H/uX0BnTm6o
 O30mAvnGcN5FnrNM8IaVCWcUjcyGtnh4Ljr1R5vNkC/h5NsDRyKpy/MGY8E+0awerJap
 b1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=pUjEFPKNx1O9WzlN4Kw5jO3Lwl0ZxDuARimA6uJp1m0=;
 b=DyFU0tRJeEt4R9i7e00Y+0jimDXPNweW8RoSKrfvcY9owRhx06mQ+4Eg4NtzKVaity
 UDnUsMW3wkn/piM3VV+IzQ+5c6P5yBtaFJH3Ua8U8yimhHLulX2lWbpCiOFbDECgrjyx
 Uf9MfUE0fvLT4LfA0vRwEU+iSqPQ5ON+QwN0InEOl4nwhjnz0SR8zSi927JulrIZKZxh
 eKv3gU7NGScrWDj/3mz3HF9GYMjoyDKnotdy6XB6yn10kBnmLS+ajhTJYzbLZHJeLzmI
 J/JQcoNjp8seUzheVxRKCWxkF+RF3ZjfAV/pIyTaaZ9gblRcs+ApZQ6RivOxTHAJGxsc
 preg==
X-Gm-Message-State: AOAM531Z7o9W3WtDZD6/8cs2MsA8Xwy1wRm+omCPMLEyVla5sqZot6Si
 5EmIkbacqTVPAuocxUtD0AxT+Q==
X-Google-Smtp-Source: ABdhPJwiJ3D2WvPMeBUyHqVRvyWDRMXgUJoPNHGaY5arhbRTW9Ek+/U6cSANzpykRzS4BHwBP3/8bw==
X-Received: by 2002:a63:1717:: with SMTP id x23mr13795189pgl.182.1631589649074; 
 Mon, 13 Sep 2021 20:20:49 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id z14sm5799380pfr.154.2021.09.13.20.20.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Sep 2021 20:20:48 -0700 (PDT)
Date: Mon, 13 Sep 2021 20:20:45 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
Message-ID: <YUAVDfuSbG35WEOR@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
 <YTo6kX7jGeR3XvPg@google.com>
 <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
 <80bdbdb3-1bff-aa99-c49b-76d6bd960aa9@redhat.com>
 <YTuytfGTDlaoz0yH@google.com>
 <cc916884-9b76-9784-c3ce-3469cb7682ab@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cc916884-9b76-9784-c3ce-3469cb7682ab@arm.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

Hi Alexandru, Eric,

On Mon, Sep 13, 2021 at 11:15:33AM +0100, Alexandru Elisei wrote:
> Hi Eric, Ricardo,
> =

> On 9/10/21 20:32, Ricardo Koller wrote:
> > Hi Alexandru and Eric,
> >
> > On Fri, Sep 10, 2021 at 10:42:23AM +0200, Eric Auger wrote:
> >> Hi Alexandru,
> >>
> >> On 9/10/21 10:28 AM, Alexandru Elisei wrote:
> >>> Hi Ricardo,
> >>>
> >>> On 9/9/21 5:47 PM, Ricardo Koller wrote:
> >>>> On Thu, Sep 09, 2021 at 11:20:15AM +0100, Alexandru Elisei wrote:
> >>>>> Hi Ricardo,
> >>>>>
> >>>>> On 9/8/21 10:03 PM, Ricardo Koller wrote:
> >>>>>> Extend vgic_v3_check_base() to verify that the redistributor regio=
ns
> >>>>>> don't go above the VM-specified IPA size (phys_size). This can hap=
pen
> >>>>>> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> >>>>>>
> >>>>>>   base + size > phys_size AND base < phys_size
> >>>>>>
> >>>>>> vgic_v3_check_base() is used to check the redist regions bases when
> >>>>>> setting them (with the vcpus added so far) and when attempting the=
 first
> >>>>>> vcpu-run.
> >>>>>>
> >>>>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> >>>>>> ---
> >>>>>>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
> >>>>>>  1 file changed, 4 insertions(+)
> >>>>>>
> >>>>>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/v=
gic-v3.c
> >>>>>> index 66004f61cd83..5afd9f6f68f6 100644
> >>>>>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> >>>>>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> >>>>>> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >>>>>>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >>>>>>  			rdreg->base)
> >>>>>>  			return false;
> >>>>>> +
> >>>>>> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> >>>>>> +			kvm_phys_size(kvm))
> >>>>>> +			return false;
> >>>>> Looks to me like this same check (and the overflow one before it) i=
s done when
> >>>>> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set=
_redist_base()
> >>>>> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as =
I can tell,
> >>>>> kvm_vgic_addr() handles both ways of setting the Redistributor addr=
ess.
> >>>>>
> >>>>> Without this patch, did you manage to set a base address such that =
base + size >
> >>>>> kvm_phys_size()?
> >>>>>
> >>>> Yes, with the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API. The easiest w=
ay
> >>>> to get to this situation is with the selftest in patch 2.  I then tr=
ied
> >>>> an extra experiment: map the first redistributor, run the first vcpu,
> >>>> and access the redist from inside the guest. KVM didn't complain in =
any
> >>>> of these steps.
> >>> Yes, Eric pointed out that I was mistaken and there is no check being=
 done for
> >>> base + size > kvm_phys_size().
> >>>
> >>> What I was trying to say is that this check is better done when the u=
ser creates a
> >>> Redistributor region, not when a VCPU is first run. We have everythin=
g we need to
> >>> make the check when a region is created, why wait until the VCPU is r=
un?
> >>>
> >>> For example, vgic_v3_insert_redist_region() is called each time the a=
dds a new
> >>> Redistributor region (via either of the two APIs), and already has a =
check for the
> >>> upper limit overflowing (identical to the check in vgic_v3_check_base=
()). I would
> >>> add the check against the maximum IPA size there.
> >> you seem to refer to an old kernel as vgic_v3_insert_redist_region was
> >> renamed into=EF=BF=BD vgic_v3_alloc_redist_region in
> >> e5a35635464b kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region=
()
> >>
> >> I think in case you use the old rdist API you do not know yet the size
> >> of the redist region at this point (count=3D0), hence Ricardo's choice=
 to
> >> do the check latter.
> > Just wanted to add one more detail. vgic_v3_check_base() is also called
> > when creating the redistributor region (via vgic_v3_set_redist_base ->
> > vgic_register_redist_iodev). This patch reuses that check for the old
> > redist API to also check for "base + size > kvm_phys_size()" with a size
> > calculated using the vcpus added so far.
> =

> @Eric: Indeed I was looking at an older kernel by mistake, thank you for =
pointing
> that out!
> =

> Thank you both for the explanations, the piece I was missing was the fact=
 that
> KVM_VGIC_V3_ADDR_TYPE_REDIST specifies only the base address and the limi=
t for the
> region is the number of VCPUs * (KVM_VGIC_V3_REDIST_SIZE =3D 128K), which=
 makes it
> necessary to have the check when each VCPU is first run (as far as I can =
tell,
> VCPUs can be created at any time).
> =

> >
> >>> Also, because vgic_v3_insert_redist_region() already checks for overf=
low, I
> >>> believe the overflow check in vgic_v3_check_base() is redundant.
> >>>
> > It's redundant for the new redist API, but still needed for the old
> > redist API.
> =

> Indeed.
> =

> >
> >>> As far as I can tell, vgic_v3_check_base() is there to make sure that=
 the
> >>> Distributor doesn't overlap with any of the Redistributors, and becau=
se the
> >>> Redistributors and the Distributor can be created in any order, we de=
fer the check
> >>> until the first VCPU is run. I might be wrong about this, someone ple=
ase correct
> >>> me if I'm wrong.
> >>>
> >>> Also, did you verify that KVM is also doing this check for GICv2? KVM=
 does
> >>> something similar and calls vgic_v2_check_base() when mapping the GIC=
 resources,
> >>> and I don't see a check for the maximum IPA size in that function eit=
her.
> >> I think vgic_check_ioaddr() called in kvm_vgic_addr() does the job (it
> >> checks the base @)
> >>
> > It seems that GICv2 suffers from the same problem. The cpu interface
> > base is checked but the end can extend above IPA size. Note that the cpu
> > interface is 8KBs and vgic_check_ioaddr() is only checking that its base
> =

> ... except that the doc for KVM_VGIC_V2_ADDR_TYPE_CPU says that the CPU i=
nterface
> region is 4K, while the check in vgic_v2_check_base() is done against
> KVM_VGIC_V2_CPU_SIZE, which is 8K.

The "GIC virtual CPU interface" alone is slightly more than 4K: GICV_DIR
is at 0x1000. The documentation might need to be updated.

> I suppose that the CPU interface region is 8K
> because ARM IHI 0048B.b strongly recommends that the virtual CPU interfac=
e control
> registers are in a separate 4KB region, and KVM wants to emulate a GICv2 =
as close
> to the real thing as possible?

Are the "virtual CPU interface control" registers the ones starting with
GICH_? If yes, then I'm a bit confused, as those are not exposed to the
guest (to my knowledge).

> =

> > is 4KB aligned and below IPA size. The distributor region is 4KB so
> > vgic_check_ioaddr() is enough in that case.
> >
> > What about the following?
> >
> > I can work on the next version of this patch (v2 has the GICv2 issue)
> > which adds vgic_check_range(), which is like vgic_check_ioaddr() but
> > with a size arg.  kvm_vgic_addr() can then call vgic_check_range() and
> > do all the checks for GICv2 and GICv3. Note that for GICv2, there's no
> > need to wait until first vcpu run to do the check. Also note that I will
> > have to keep the change in vgic_v3_check_base() to check for the old v3
> > redist API at first vcpu run.
> =

> Sounds good.
> =

> Thanks,
> =

> Alex
> =

> >
> > Thanks,
> > Ricardo
> >
> >> Thanks
> >>
> >> Eric

Will do, thank you both.

Ricardo

> >>> Thanks,
> >>>
> >>> Alex
> >>>
> >>>> Thanks,
> >>>> Ricardo
> >>>>
> >>>>> Thanks,
> >>>>>
> >>>>> Alex
> >>>>>
> >>>>>>  	}
> >>>>>>  =

> >>>>>>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
