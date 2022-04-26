Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF86C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 16:21:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59F764B120;
	Tue, 26 Apr 2022 12:21:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wQ8a4N06ACAy; Tue, 26 Apr 2022 12:21:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E9A24B12C;
	Tue, 26 Apr 2022 12:21:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EFFE4B11A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 12:21:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tZGFPmUpNgJX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 12:21:13 -0400 (EDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBEDD4B10A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 12:21:13 -0400 (EDT)
Received: by mail-pf1-f170.google.com with SMTP id h1so18401264pfv.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 09:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hZjmwFR953j+9FBrL8+Ar/m4pDnF26BtXt1jByO7NsU=;
 b=kX5uMhRI06Zsiy58WolwAxzUv2cxPyUzmJKw0XRSFgW5xs87MilBIz0Sflh3XH4pvm
 KQMXAzCgYKaWscwiCziR1f0mUOwm6nRojFgLnb3kUod7qTW5nB1M52EGdmoSDJJz2J+R
 Tv/coLmbwo9jow6iwDFkUuGHdC5Q61c2ZzLOjveCaw7iqd5ejm+Rh9nh+r5rypbTgc1/
 uwVuFvXnxcVeWBshkP4mcuW8yqIwEuU/8bPLbGxuPBbQvip0FPIf7EfKS6B/JUfti41N
 GBoj86EqgLgFOMLG8OedNwfKcPColLQPq1ZpziRl3rLTB5dvacs/O8O8rgeX3J0MpL1P
 McZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hZjmwFR953j+9FBrL8+Ar/m4pDnF26BtXt1jByO7NsU=;
 b=vg9rboNMsgxCQ+3lp0fkAqgCIVTANybeDbJrvzmSvBYTEFI/w4Cq6cDjyx8RzscaX7
 JOUYGS/JoOsTlvHeMGBLWBiKreMInFX9QoBC3kkBEriBFEjup3ZedwE/9uu/4UQ779ZA
 MEgHXJ1o71EdBXhU9MaxVEnwT2uLi/g8EcoFOU1LSsENMCjMw/vnCaBQgK9wk/rzVVIl
 wnOxF3eks20WTDiSt58VaoCLun+9vL1eyxxsR4qFQ0ue4ZjbjlZ8i+/Kk/ovtYZSWVkk
 29egYQ/NVflauwaD0GJs1+DrqAMEZcIFwA4vBR/mSrDMjggrlmpihIlhvJZzSSvAEtu5
 6TRg==
X-Gm-Message-State: AOAM530mEK4toI73x2KQe2ksz89qYo1x0DFrvpcZoirMkY0jxPqqj49a
 djvB1YUTbBeX6lxqXR+HubNvJA==
X-Google-Smtp-Source: ABdhPJyuTwLSDrlPW+vJSqmNXhcMuxYhP8sjTWsgbQJo/+CPlkndXUjG8SLMh3kHUUE586++jZ0pHg==
X-Received: by 2002:a65:410a:0:b0:399:38b9:8ba with SMTP id
 w10-20020a65410a000000b0039938b908bamr19942856pgp.526.1650990072311; 
 Tue, 26 Apr 2022 09:21:12 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 t38-20020a634626000000b0039cc30b7c93sm13327699pga.82.2022.04.26.09.21.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Apr 2022 09:21:11 -0700 (PDT)
Date: Tue, 26 Apr 2022 09:21:07 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/4] KVM: arm64: vgic: Check that new ITEs could be saved
 in guest memory
Message-ID: <Ymgb8+dOEs03GvAX@google.com>
References: <20220425185534.57011-1-ricarkol@google.com>
 <20220425185534.57011-2-ricarkol@google.com>
 <871qxkcws3.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <871qxkcws3.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, pshier@google.com,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Apr 26, 2022 at 05:07:40AM +0100, Marc Zyngier wrote:
> On Mon, 25 Apr 2022 19:55:31 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > A command that adds an entry into an ITS table that is not in guest
> > memory should fail, as any command should be treated as if it was
> > actually saving entries in guest memory (KVM doesn't until saving).
> > Add the corresponding check for the ITT when adding ITEs.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index 2e13402be3bd..d7c1a3a01af4 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -976,6 +976,37 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
> >  	return ret;
> >  }
> >  
> > +/*
> > + * Check whether an event ID can be stored in the corresponding Interrupt
> > + * Translation Table, which starts at device->itt_addr.
> > + */
> > +static bool vgic_its_check_ite(struct vgic_its *its, struct its_device *device,
> > +		u32 event_id)
> > +{
> > +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> > +	int ite_esz = abi->ite_esz;
> > +	gpa_t gpa;
> > +	gfn_t gfn;
> > +	int idx;
> > +	bool ret;
> > +
> > +	/* max table size is: BIT_ULL(device->num_eventid_bits) * ite_esz */
> > +	if (event_id >= BIT_ULL(device->num_eventid_bits))
> > +		return false;
> 
> We have already checked this condition, it seems.
> 
> > +
> > +	gpa = device->itt_addr + event_id * ite_esz;
> > +	gfn = gpa >> PAGE_SHIFT;
> > +
> > +	idx = srcu_read_lock(&its->dev->kvm->srcu);
> > +	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
> > +	srcu_read_unlock(&its->dev->kvm->srcu, idx);
> > +	return ret;
> 
> Why should we care? If the guest doesn't give us the memory that is
> required, that's its problem.

The issue is that if the guest does that, then the pause will fail and
we won't be able to migrate the VM. This series objective is to help
with failed migrations due to the ITS. This commit tries to do it by
avoiding them.

> The only architectural requirement is
> that the EID fits into the device table. There is no guarantee that
> the ITS will actually write to the memory.

If I understand it correctly, failing the command in this case would
also be architectural (right?). If the ITS tries to write the new
entry into memory immediately, then the command would fail. This
proposed check is just making this assumption.

> 
> And if you feel that there is a strong need to have this, surely you
> can reuse some of the vgic_its_check_id() code.
> 

Sure, will do that.

> > +}
> > +
> > +/*
> > + * Adds a new collection into the ITS collection table.
> > + * Returns 0 on success, and a negative error value for generic errors.
> 
> Not only. A positive error can also be returned for an out of range
> condition.
> 

This is coming from a subsequent commit. It made it here by mistake
(most likely when I was reordering the commits). Will put it where it
belongs, sorry for that.

Thanks for the review,
Ricardo

> > + */
> >  static int vgic_its_alloc_collection(struct vgic_its *its,
> >  				     struct its_collection **colp,
> >  				     u32 coll_id)
> > @@ -1076,6 +1107,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  	if (find_ite(its, device_id, event_id))
> >  		return 0;
> >  
> > +	if (!vgic_its_check_ite(its, device, event_id))
> > +		return E_ITS_MAPTI_ID_OOR;
> > +
> >  	collection = find_collection(its, coll_id);
> >  	if (!collection) {
> >  		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
> > -- 
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> > 
> > 
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
