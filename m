Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9ECC4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 15:30:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 430B46104F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 15:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 430B46104F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1F274A003;
	Tue,  3 Aug 2021 11:30:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yl8sJFZ1oAPp; Tue,  3 Aug 2021 11:30:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CC7B49FB7;
	Tue,  3 Aug 2021 11:30:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1A6049F8F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 11:30:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rgNydEKeu7wl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 11:30:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B229640825
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 11:30:43 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7489260F94;
 Tue,  3 Aug 2021 15:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628004642;
 bh=HTCLwdKyT6siX/NNQAkgV9S50hfCToi2PQiR46wzJOA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=UNa36HzG2X5o+mXj0JkamR1gwcNOzeK4UjQ7rYywhP8Aj5lkxhXxNONBj21H9y3hc
 LBDzzuDvwA6CsUouIl/cS0FGo0rVrLORLPxEucgSxg2RF2fZeLJ1oi4DzULM24kT17
 vg/lxy+sNjTy/FyuWZ+Y1N+ttGVEdMSE5BUWCCeOnNZEZh7Z8SXYJtXsVp0qBxKTRY
 w/pRHZ8m8Nf8RSBhpE8AXQR/OGyjpAGqXi42WBkAfhYj/TwmJRQiYEUfhGNBgrU2MD
 MlEGZNh6pSYXVkhHmY/v0Wfg/6c4OeyMHLI2r8d6U6PxfCE84mLxlSZUjkARU+p7+8
 cMDi/re1tKgIA==
Date: Tue, 3 Aug 2021 16:30:37 +0100
From: Will Deacon <will@kernel.org>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule out
Message-ID: <20210803153036.GA31125@willie-the-truck>
References: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
 <20210729104009.382-5-shameerali.kolothum.thodi@huawei.com>
 <20210803114034.GB30853@willie-the-truck>
 <ee2863107d614ef8a36006b5aa912eca@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ee2863107d614ef8a36006b5aa912eca@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Tue, Aug 03, 2021 at 12:55:25PM +0000, Shameerali Kolothum Thodi wrote:
> > > diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
> > > index 5584e84aed95..5fd51f5445c1 100644
> > > --- a/arch/arm64/kvm/vmid.c
> > > +++ b/arch/arm64/kvm/vmid.c
> > > @@ -116,6 +116,12 @@ static u64 new_vmid(struct kvm_vmid
> > *kvm_vmid)
> > >  	return idx2vmid(vmid) | generation;
> > >  }
> > >
> > > +/* Call with preemption disabled */
> > > +void kvm_arm_vmid_clear_active(void)
> > > +{
> > > +	atomic64_set(this_cpu_ptr(&active_vmids), 0);
> > > +}
> > 
> > I think this is very broken, as it will force everybody to take the
> > slow-path when they see an active_vmid of 0.
> 
> Yes. I have seen that happening in my test setup.

Why didn't you say so?!

> > It also doesn't solve the issue I mentioned before, as an active_vmid of 0
> > means that the reserved vmid is preserved.
> > 
> > Needs more thought...
> 
> How about we clear all the active_vmids in kvm_arch_free_vm() if it
> matches the kvm_vmid->id ? But we may have to hold the lock 
> there

I think we have to be really careful not to run into the "suspended
animation" problem described in ae120d9edfe9 ("ARM: 7767/1: let the ASID
allocator handle suspended animation") if we go down this road.

Maybe something along the lines of:

ROLLOVER

  * Take lock
  * Inc generation
    => This will force everybody down the slow path
  * Record active VMIDs
  * Broadcast TLBI
    => Only active VMIDs can be dirty
    => Reserve active VMIDs and mark as allocated

VCPU SCHED IN

  * Set active VMID
  * Check generation
  * If mismatch then:
        * Take lock
        * Try to match a reserved VMID
        * If no reserved VMID, allocate new

VCPU SCHED OUT

  * Clear active VMID

but I'm not daft enough to think I got it right first time. I think it
needs both implementing *and* modelling in TLA+ before we merge it!

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
