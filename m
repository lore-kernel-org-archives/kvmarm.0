Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A752C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 17:01:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABD784B19F;
	Wed,  4 May 2022 13:01:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6an0MEGC2Axf; Wed,  4 May 2022 13:01:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A7DA49E35;
	Wed,  4 May 2022 13:01:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 838CD49E35
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 13:01:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U4VIl5f1wfGV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 13:01:38 -0400 (EDT)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 675B149E1A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 13:01:38 -0400 (EDT)
Received: by mail-pl1-f173.google.com with SMTP id s14so1946585plk.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 May 2022 10:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=djBQAYzvnQPbFywsSGq+qFa7/2dyAx9kLA8TA/q8bGo=;
 b=EQnT+GQA+QopGtj4oWguMQr9Pf+0kt81+7p6or40nKj8qqLlnW/2CzJ3KRMNOC8cK4
 BM+qNmTjnKOm4b6OH3BHOdD29tTWaXf+h1wwwhkk4irzdLAb7MPqlQyH3oKNCyIZZIkZ
 hR3Bt2rL7emEA7K+RafpNp2Auv2bMcaj7Sz0mhrVukvWu2FTc2O5e94QXC7DpTEsAE+S
 WCdfOcTqCYp1fzRj9sbueDW12WgrwJudP4eO6Mgym5pclcdcld+UFVd81mbhdueAhPjX
 21TOTzw0mw/btHPkg1VZxJmkjhIy7SZoaJd4CWqeNoEUZtmyfO/bA+1/hlhv5dEUFi6E
 6ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=djBQAYzvnQPbFywsSGq+qFa7/2dyAx9kLA8TA/q8bGo=;
 b=7fprBYBhtf266EwCw7wMXzwAmIRAFVggPF1U6pNdWPi9Uq/u3JZyw1j7m2+fa5x6ws
 2Uqv2HrOYvFWtvOuC2a43YtFwHvvFxoCSd5y1QtVy/NFqQVmz0NeAFE692KG6DNRu9g1
 w8vCLsW5JaK5m6R5iu9yXGaUP0kKHi4uRlgzKlaZ4H6vhq1QrM1+5dc762F2Ecolpw9W
 T9uGyA5xPTnFC3+FxZ1DZ18aF63PAb1cuFkpv5sRBwZ9a0OEeQbUbwU18tzP9N8go3WN
 U7jJs6QdOLV9RkEpw9LTW0E0RuNgyHbHhtBKrE9mUEL/70jEdzyvZnSZWwYmX6gQR6I/
 8bDg==
X-Gm-Message-State: AOAM5336m4+eIMkzdmPe/p9QpWL7A5Z4FThs9i75Ia0jNHT9h8MOQQ0j
 V2taGbfq+MULmQR8OkqyDFA92g==
X-Google-Smtp-Source: ABdhPJyHGZtJJE7ghhsABggO5pUuiqRUIGw57QKov6Pnk6fPav91MXGYb4OeJ1ZzBHb+JxPxPFrHzw==
X-Received: by 2002:a17:902:f682:b0:15e:951b:8091 with SMTP id
 l2-20020a170902f68200b0015e951b8091mr19189721plg.106.1651683697042; 
 Wed, 04 May 2022 10:01:37 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 x18-20020aa793b2000000b0050dc76281fcsm8401395pff.214.2022.05.04.10.01.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 May 2022 10:01:36 -0700 (PDT)
Date: Wed, 4 May 2022 10:01:32 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Add more checks when restoring
 ITS tables
Message-ID: <YnKxbNuf4U1Zgjx5@google.com>
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-3-ricarkol@google.com>
 <b29fcba7-2599-bf1b-0720-26b05cc37fd4@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b29fcba7-2599-bf1b-0720-26b05cc37fd4@redhat.com>
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, pshier@google.com,
 maz@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Tue, May 03, 2022 at 07:14:19PM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 4/27/22 20:48, Ricardo Koller wrote:
> > Try to improve the predictability of ITS save/restores (and debuggability
> > of failed ITS saves) by failing early on restore when trying to read
> > corrupted tables.
> >
> > Restoring the ITS tables does some checks for corrupted tables, but not as
> > many as in a save: an overflowing device ID will be detected on save but
> > not on restore.  The consequence is that restoring a corrupted table won't
> > be detected until the next save; including the ITS not working as expected
> > after the restore.  As an example, if the guest sets tables overlapping
> > each other, which would most likely result in some corrupted table, this is
> > what we would see from the host point of view:
> >
> > 	guest sets base addresses that overlap each other
> > 	save ioctl
> > 	restore ioctl
> > 	save ioctl (fails)
> >
> > Ideally, we would like the first save to fail, but overlapping tables could
> > actually be intended by the guest. So, let's at least fail on the restore
> > with some checks: like checking that device and event IDs don't overflow
> > their tables.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index e14790750958..fb2d26a73880 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -2198,6 +2198,12 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
> >  	if (!collection)
> >  		return -EINVAL;
> >  
> > +	if (find_ite(its, dev->device_id, event_id))
> > +		return -EINVAL;
> Unsure about that. Nothing in the arm-vgic-its.rst doc says that the
> KVM_DEV_ARM_ITS_RESTORE_TABLES ioctl cannot be called several times
> (although obviously useless)

In that case, maybe we could ignore the new repeated entry? or
overwrite the old one?  find_ite() only returns the first (device_id,
event_id) match. So, it's like the new one is ignored already.  The
arm arm says this about MAPI commands in this situation:

    If there is an existing mapping for the EventID-DeviceID
    combination, behavior is UNPREDICTABLE.

And, just in case, the main reason for adding this check was to avoid
failing the next ITS save. The idea is to try to fail as soon as
possible, not in possibly many days during the next migration attempt.

> > +
> > +	if (!vgic_its_check_event_id(its, dev, event_id))
> > +		return -EINVAL;
> > +
> >  	ite = vgic_its_alloc_ite(dev, collection, event_id);
> >  	if (IS_ERR(ite))
> >  		return PTR_ERR(ite);
> > @@ -2319,6 +2325,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
> >  				void *ptr, void *opaque)
> >  {
> >  	struct its_device *dev;
> > +	u64 baser = its->baser_device_table;
> >  	gpa_t itt_addr;
> >  	u8 num_eventid_bits;
> >  	u64 entry = *(u64 *)ptr;
> > @@ -2339,6 +2346,12 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
> >  	/* dte entry is valid */
> >  	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
> >  
> > +	if (find_its_device(its, id))
> > +		return -EINVAL;
> same here.
> > +
> > +	if (!vgic_its_check_id(its, baser, id, NULL))
> > +		return -EINVAL;
> > +
> >  	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
> >  	if (IS_ERR(dev))
> >  		return PTR_ERR(dev);
> Thanks
> 
> Eric
>

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
