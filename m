Return-Path: <SRS0=SY58=OK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 407D1C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 21:01:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A617B61175
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 21:01:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A617B61175
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2209D4A49C;
	Mon, 20 Sep 2021 17:01:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vVfdydBJfaEW; Mon, 20 Sep 2021 17:01:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9989640874;
	Mon, 20 Sep 2021 17:01:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F11B540256
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 17:01:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jo3FFWFodz02 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 17:01:08 -0400 (EDT)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99CF2401A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 17:01:08 -0400 (EDT)
Received: by mail-pl1-f173.google.com with SMTP id w6so11914023pll.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 14:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=gMqOitjzmCQqPLydZxrgluXOWmrPfX3VRNVeCUVBy3o=;
 b=GX4yoFsrVJpe0FdNIt2y8W4WSc4Y8bWLY7KijA99Vuch9COJF7Ig4MqXcWat3byzTC
 +8xWx/2KlW6RzOLl/6W5IHqhL9TtkpTHpkTGAGIccc4ZtLjPXR+/SOJNkSQJbFq7esPP
 434AxG2LOS5BckxSdNf3rf9MxPnzzfqkek4JaGNhHrzGOWmAQNkAvwGTZB51LhI22hvC
 UMHVf8abdSVeQ/1mZCSwMCh/22L14HGjHgYMLNLC8Gsp7TZ9BlHGTHmrg4WdoFzcLdiG
 80rrD6qxAFUcHTHEKNTW10PJbhskK8bcNcPzvuK8+i0IDHAvU+b+hUPZZjXP7Kw+PL+q
 lKTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=gMqOitjzmCQqPLydZxrgluXOWmrPfX3VRNVeCUVBy3o=;
 b=5o8LWXJ4sSRBxlpDHooWYrnFCrqWoDKK3ZzaiZJyImdUsCkxCu7U/Nw6xGvn9AkASF
 7ibIcVnSk83UtZ5vTElCfH2vdJa68q/MwYiOd+q+M7O/r27ZbxtwlsZeO2+i6pNGYnHv
 kn3Lp6NAIBrubiNtGRREt3roz/uIiw+Vk3fv7tLYs7pEnU3+7mE5vZHJyPuFkPxSGXMF
 x7FtwXVFVLj9AF1OOAaY5ea7Tv/66Gx7LJ3RBGAsb9xitf/KXeCeH1LZUw2LONh5aYWn
 q8DPhTX1dRy5JlqUUi1laT+38nYoYWUAE7fScG25SqwoSZmHTS9RoJK90x05iLUb6aCI
 +BGQ==
X-Gm-Message-State: AOAM531ud8fVwyKS4fqGbi6LwRQGRILOOfJrJp3ZY7oWtituWvx7CYn0
 i87TMT1rAw6xSbwcZX8xJiA2lw==
X-Google-Smtp-Source: ABdhPJyg3oB/XzSpT9Kkd+vPQhvlDdWGP5AoHUUrvfiOBaz7mm7f66cwqigRfT7nvvS33rGlIkUing==
X-Received: by 2002:a17:902:bb81:b0:12d:a7ec:3d85 with SMTP id
 m1-20020a170902bb8100b0012da7ec3d85mr24339535pls.17.1632171667403; 
 Mon, 20 Sep 2021 14:01:07 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id g15sm2970307pfu.155.2021.09.20.14.01.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Sep 2021 14:01:06 -0700 (PDT)
Date: Mon, 20 Sep 2021 14:01:03 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
Message-ID: <YUj2j1tU/AVNlVh9@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
 <YTo6kX7jGeR3XvPg@google.com>
 <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
 <80bdbdb3-1bff-aa99-c49b-76d6bd960aa9@redhat.com>
 <YTuytfGTDlaoz0yH@google.com>
 <cc916884-9b76-9784-c3ce-3469cb7682ab@arm.com>
 <YUAVDfuSbG35WEOR@google.com>
 <1906a1cf-3fb5-0ecf-4422-bef1ac6eef90@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1906a1cf-3fb5-0ecf-4422-bef1ac6eef90@arm.com>
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

On Tue, Sep 14, 2021 at 12:00:35PM +0100, Alexandru Elisei wrote:
> Hi Ricardo,
> =

> (adding kvm@vger.kernel.org to CC because the email this is a reply to got
> rejected because of html content)
> =

> On 9/14/21 04:20, Ricardo Koller wrote:
> > Hi Alexandru, Eric,
> >
> > On Mon, Sep 13, 2021 at 11:15:33AM +0100, Alexandru Elisei wrote:
> >> Hi Eric, Ricardo,
> >>
> >> On 9/10/21 20:32, Ricardo Koller wrote:
> >>> Hi Alexandru and Eric,
> >>>
> >>> On Fri, Sep 10, 2021 at 10:42:23AM +0200, Eric Auger wrote:
> >>>> Hi Alexandru,
> >>>>
> >>>> On 9/10/21 10:28 AM, Alexandru Elisei wrote:
> >>>>> Hi Ricardo,
> >>>>>
> >>>>> On 9/9/21 5:47 PM, Ricardo Koller wrote:
> >>>>>> On Thu, Sep 09, 2021 at 11:20:15AM +0100, Alexandru Elisei wrote:
> >>>>>>> Hi Ricardo,
> >>>>>>>
> >>>>>>> On 9/8/21 10:03 PM, Ricardo Koller wrote:
> >>>>>>>> Extend vgic_v3_check_base() to verify that the redistributor reg=
ions
> >>>>>>>> don't go above the VM-specified IPA size (phys_size). This can h=
appen
> >>>>>>>> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute wit=
h:
> >>>>>>>>
> >>>>>>>>   base + size > phys_size AND base < phys_size
> >>>>>>>>
> >>>>>>>> vgic_v3_check_base() is used to check the redist regions bases w=
hen
> >>>>>>>> setting them (with the vcpus added so far) and when attempting t=
he first
> >>>>>>>> vcpu-run.
> >>>>>>>>
> >>>>>>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> >>>>>>>> ---
> >>>>>>>>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
> >>>>>>>>  1 file changed, 4 insertions(+)
> >>>>>>>>
> >>>>>>>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic=
/vgic-v3.c
> >>>>>>>> index 66004f61cd83..5afd9f6f68f6 100644
> >>>>>>>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> >>>>>>>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> >>>>>>>> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >>>>>>>>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >>>>>>>>  			rdreg->base)
> >>>>>>>>  			return false;
> >>>>>>>> +
> >>>>>>>> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> >>>>>>>> +			kvm_phys_size(kvm))
> >>>>>>>> +			return false;
> >>>>>>> Looks to me like this same check (and the overflow one before it)=
 is done when
> >>>>>>> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_s=
et_redist_base()
> >>>>>>> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far a=
s I can tell,
> >>>>>>> kvm_vgic_addr() handles both ways of setting the Redistributor ad=
dress.
> >>>>>>>
> >>>>>>> Without this patch, did you manage to set a base address such tha=
t base + size >
> >>>>>>> kvm_phys_size()?
> >>>>>>>
> >>>>>> Yes, with the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API. The easiest=
 way
> >>>>>> to get to this situation is with the selftest in patch 2.  I then =
tried
> >>>>>> an extra experiment: map the first redistributor, run the first vc=
pu,
> >>>>>> and access the redist from inside the guest. KVM didn't complain i=
n any
> >>>>>> of these steps.
> >>>>> Yes, Eric pointed out that I was mistaken and there is no check bei=
ng done for
> >>>>> base + size > kvm_phys_size().
> >>>>>
> >>>>> What I was trying to say is that this check is better done when the=
 user creates a
> >>>>> Redistributor region, not when a VCPU is first run. We have everyth=
ing we need to
> >>>>> make the check when a region is created, why wait until the VCPU is=
 run?
> >>>>>
> >>>>> For example, vgic_v3_insert_redist_region() is called each time the=
 adds a new
> >>>>> Redistributor region (via either of the two APIs), and already has =
a check for the
> >>>>> upper limit overflowing (identical to the check in vgic_v3_check_ba=
se()). I would
> >>>>> add the check against the maximum IPA size there.
> >>>> you seem to refer to an old kernel as vgic_v3_insert_redist_region w=
as
> >>>> renamed into=EF=BF=BD vgic_v3_alloc_redist_region in
> >>>> e5a35635464b kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_regi=
on()
> >>>>
> >>>> I think in case you use the old rdist API you do not know yet the si=
ze
> >>>> of the redist region at this point (count=3D0), hence Ricardo's choi=
ce to
> >>>> do the check latter.
> >>> Just wanted to add one more detail. vgic_v3_check_base() is also call=
ed
> >>> when creating the redistributor region (via vgic_v3_set_redist_base ->
> >>> vgic_register_redist_iodev). This patch reuses that check for the old
> >>> redist API to also check for "base + size > kvm_phys_size()" with a s=
ize
> >>> calculated using the vcpus added so far.
> >> @Eric: Indeed I was looking at an older kernel by mistake, thank you f=
or pointing
> >> that out!
> >>
> >> Thank you both for the explanations, the piece I was missing was the f=
act that
> >> KVM_VGIC_V3_ADDR_TYPE_REDIST specifies only the base address and the l=
imit for the
> >> region is the number of VCPUs * (KVM_VGIC_V3_REDIST_SIZE =3D 128K), wh=
ich makes it
> >> necessary to have the check when each VCPU is first run (as far as I c=
an tell,
> >> VCPUs can be created at any time).
> >>
> >>>>> Also, because vgic_v3_insert_redist_region() already checks for ove=
rflow, I
> >>>>> believe the overflow check in vgic_v3_check_base() is redundant.
> >>>>>
> >>> It's redundant for the new redist API, but still needed for the old
> >>> redist API.
> >> Indeed.
> >>
> >>>>> As far as I can tell, vgic_v3_check_base() is there to make sure th=
at the
> >>>>> Distributor doesn't overlap with any of the Redistributors, and bec=
ause the
> >>>>> Redistributors and the Distributor can be created in any order, we =
defer the check
> >>>>> until the first VCPU is run. I might be wrong about this, someone p=
lease correct
> >>>>> me if I'm wrong.
> >>>>>
> >>>>> Also, did you verify that KVM is also doing this check for GICv2? K=
VM does
> >>>>> something similar and calls vgic_v2_check_base() when mapping the G=
IC resources,
> >>>>> and I don't see a check for the maximum IPA size in that function e=
ither.
> >>>> I think vgic_check_ioaddr() called in kvm_vgic_addr() does the job (=
it
> >>>> checks the base @)
> >>>>
> >>> It seems that GICv2 suffers from the same problem. The cpu interface
> >>> base is checked but the end can extend above IPA size. Note that the =
cpu
> >>> interface is 8KBs and vgic_check_ioaddr() is only checking that its b=
ase
> >> ... except that the doc for KVM_VGIC_V2_ADDR_TYPE_CPU says that the CP=
U interface
> >> region is 4K, while the check in vgic_v2_check_base() is done against
> >> KVM_VGIC_V2_CPU_SIZE, which is 8K.
> > The "GIC virtual CPU interface" alone is slightly more than 4K: GICV_DIR
> > is at 0x1000. The documentation might need to be updated.
> >
> >> I suppose that the CPU interface region is 8K
> >> because ARM IHI 0048B.b strongly recommends that the virtual CPU inter=
face control
> >> registers are in a separate 4KB region, and KVM wants to emulate a GIC=
v2 as close
> >> to the real thing as possible?
> > Are the "virtual CPU interface control" registers the ones starting with
> > GICH_? If yes, then I'm a bit confused, as those are not exposed to the
> > guest (to my knowledge).
> =

> Yes, those are the ones, and I also did find that they are not exposed to=
 the guest.
> =

> Comparing the KVM documentation with what KVM actually does, I assumed th=
at the
> 8KB was a forward looking decision, in case nested virtualization will su=
pport
> GICv2, which means that the GICH_* registers would also have to be expose=
d. Making
> the CPU interface for a CPU 8KB from the start would avoid changes or add=
itions to
> the API if that happens.
> =

> However, after further digging through the spec, I found that the virtual=
 CPU
> interface is specified to be 8KB (Table 5-10 of ARM IHI 0048B.b). I think=
 that's
> the reason KVM treats it as 8KB.

Thanks for checking Alexandru. Will send a commit to update the
documentation as well then (v3).

Regards,
Ricardo

> =

> Thanks,
> =

> Alex
> =

> >
> >>> is 4KB aligned and below IPA size. The distributor region is 4KB so
> >>> vgic_check_ioaddr() is enough in that case.
> >>>
> >>> What about the following?
> >>>
> >>> I can work on the next version of this patch (v2 has the GICv2 issue)
> >>> which adds vgic_check_range(), which is like vgic_check_ioaddr() but
> >>> with a size arg.  kvm_vgic_addr() can then call vgic_check_range() and
> >>> do all the checks for GICv2 and GICv3. Note that for GICv2, there's no
> >>> need to wait until first vcpu run to do the check. Also note that I w=
ill
> >>> have to keep the change in vgic_v3_check_base() to check for the old =
v3
> >>> redist API at first vcpu run.
> >> Sounds good.
> >>
> >> Thanks,
> >>
> >> Alex
> >>
> >>> Thanks,
> >>> Ricardo
> >>>
> >>>> Thanks
> >>>>
> >>>> Eric
> > Will do, thank you both.
> >
> > Ricardo
> >
> >>>>> Thanks,
> >>>>>
> >>>>> Alex
> >>>>>
> >>>>>> Thanks,
> >>>>>> Ricardo
> >>>>>>
> >>>>>>> Thanks,
> >>>>>>>
> >>>>>>> Alex
> >>>>>>>
> >>>>>>>>  	}
> >>>>>>>>  =

> >>>>>>>>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
