Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBD8C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 17:55:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFF994B1D2;
	Wed, 27 Apr 2022 13:55:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qSQVLk75cxzy; Wed, 27 Apr 2022 13:55:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFAB249ECE;
	Wed, 27 Apr 2022 13:55:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31AE249E36
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 13:55:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EVq+k9FoP4o7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 13:55:00 -0400 (EDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E894149B0A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 13:54:59 -0400 (EDT)
Received: by mail-pf1-f180.google.com with SMTP id a11so2216136pff.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 10:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=MT32fDJjlSBzqa3QKuJ5nhMxgjthrXwBcbluFoTXiG8=;
 b=XrlZ0sC0DN1ViPQWIG+U1AYra+oQuWHZkOZa7i5jc3k++0oqDF0bxhJqZ7tVFcmarW
 6cJKqw2Q4vHIV6xRS2XNlsL859y9bSmxd1a1FPkc/wAFtBLNmF5MrhZXdovor6LdsEJk
 aYvOQM6rNaQIOXwonX+Ei9B6kNXnQxvQqeAwziq6/D92gSLXNnC4L+piFYKCw/UqE851
 HZ3KGyFTaRQeZYdCviIedcXzT3s/P5/bmRRZYuJ3XRjDMxjhHfVSDr5Ir6Dzz+/+P1J3
 2NtMoL+3dshT0GKulhTWOGITsveQVRxoKDuu4t+2qeULzydJSHhCFlUWNjmHb6SAi56N
 co9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MT32fDJjlSBzqa3QKuJ5nhMxgjthrXwBcbluFoTXiG8=;
 b=tIDUfkozsAVl/uN1ci2ZUB1jOPcbFc5pHzr4b7wW61zZU44hmQ/z0AVvAA6pZ+6X5j
 D1XpwRMaAyOX+vUeX7ZBuroHzfVgNDs0bNZFWK5P5io50T0XzBYAKmD5KhnuDa8Ge28g
 7DBEqFLVyhrCTsZhkpG3daEq2vdMFFos3/E1t7+e1oZWnd2f0UuBt+7Fa2r+zOT/2gYN
 v45vXWlbb6cO3JFLQRv6pexYtCaozNGCT0eAH9WRIIh+X122V1RmJPyIjMCbqXijYBD+
 tGEZKGE33iF940ex2WVPXuXPwdiYn/bHbPcYr8Al/kXehjb7HlDe/9SOj+gk1r2a5ylD
 PwZg==
X-Gm-Message-State: AOAM533dJqUUIggtedtJlzwNZEbxnySfZwxENYGORwsM3FbvIy0Ub+2x
 ahlei6jQ8iJTiVdEocQF2swncg==
X-Google-Smtp-Source: ABdhPJz5Dn0oFvNCe+SmriYc4GHgZrKoad23n7swbCCTGMvsAmMooBVrKAFcuF4wUp3NnwokJpfCOQ==
X-Received: by 2002:a63:4c0f:0:b0:39d:b7f6:fdb9 with SMTP id
 z15-20020a634c0f000000b0039db7f6fdb9mr25257993pga.601.1651082098525; 
 Wed, 27 Apr 2022 10:54:58 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 f16-20020aa78b10000000b0050a81508653sm19375044pfd.198.2022.04.27.10.54.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Apr 2022 10:54:57 -0700 (PDT)
Date: Wed, 27 Apr 2022 10:54:54 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/4] KVM: arm64: vgic: Check that new ITEs could be saved
 in guest memory
Message-ID: <YmmDbtOUHMbcg2nV@google.com>
References: <20220425185534.57011-1-ricarkol@google.com>
 <20220425185534.57011-2-ricarkol@google.com>
 <871qxkcws3.wl-maz@kernel.org> <Ymgb8+dOEs03GvAX@google.com>
 <8735hzague.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8735hzague.wl-maz@kernel.org>
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

On Tue, Apr 26, 2022 at 06:34:49PM +0100, Marc Zyngier wrote:
> On Tue, 26 Apr 2022 17:21:07 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Tue, Apr 26, 2022 at 05:07:40AM +0100, Marc Zyngier wrote:
> > > On Mon, 25 Apr 2022 19:55:31 +0100,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > 
> > > > A command that adds an entry into an ITS table that is not in guest
> > > > memory should fail, as any command should be treated as if it was
> > > > actually saving entries in guest memory (KVM doesn't until saving).
> > > > Add the corresponding check for the ITT when adding ITEs.
> > > > 
> > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > ---
> > > >  arch/arm64/kvm/vgic/vgic-its.c | 34 ++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 34 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > > > index 2e13402be3bd..d7c1a3a01af4 100644
> > > > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > > > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > > > @@ -976,6 +976,37 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
> > > >  	return ret;
> > > >  }
> > > >  
> > > > +/*
> > > > + * Check whether an event ID can be stored in the corresponding Interrupt
> > > > + * Translation Table, which starts at device->itt_addr.
> > > > + */
> > > > +static bool vgic_its_check_ite(struct vgic_its *its, struct its_device *device,
> > > > +		u32 event_id)
> > > > +{
> > > > +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> > > > +	int ite_esz = abi->ite_esz;
> > > > +	gpa_t gpa;
> > > > +	gfn_t gfn;
> > > > +	int idx;
> > > > +	bool ret;
> > > > +
> > > > +	/* max table size is: BIT_ULL(device->num_eventid_bits) * ite_esz */
> > > > +	if (event_id >= BIT_ULL(device->num_eventid_bits))
> > > > +		return false;
> > > 
> > > We have already checked this condition, it seems.
> > > 
> > > > +
> > > > +	gpa = device->itt_addr + event_id * ite_esz;
> > > > +	gfn = gpa >> PAGE_SHIFT;
> > > > +
> > > > +	idx = srcu_read_lock(&its->dev->kvm->srcu);
> > > > +	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
> > > > +	srcu_read_unlock(&its->dev->kvm->srcu, idx);
> > > > +	return ret;
> > > 
> > > Why should we care? If the guest doesn't give us the memory that is
> > > required, that's its problem.
> > 
> > The issue is that if the guest does that, then the pause will fail and
> > we won't be able to migrate the VM. This series objective is to help
> > with failed migrations due to the ITS. This commit tries to do it by
> > avoiding them.
> 
> But the guest is buggy, isn't it? No memory, no cookie! ;-)
> 
> I understand that you want save/restore to be predictable even when
> the guest is too crap for words. I think clarifying this in your
> commit message would help.
> 
> > > The only architectural requirement is
> > > that the EID fits into the device table. There is no guarantee that
> > > the ITS will actually write to the memory.
> > 
> > If I understand it correctly, failing the command in this case would
> > also be architectural (right?). If the ITS tries to write the new
> > entry into memory immediately, then the command would fail. This
> > proposed check is just making this assumption.
> 
> Neither behaviour is architectural (they are both allowed, but none
> is required). Not providing the memory, however, is unpredictable.
> 
> I'm OK with your approach because it makes things consistent (we fail
> early rather than late). But the commit message doesn't really reflect
> that (it sort of hints to it, but not in a clear way).
> 

Sounds good, will do that, thanks.

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
