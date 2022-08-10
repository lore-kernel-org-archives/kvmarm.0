Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD48C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 17:23:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A89764DBA9;
	Wed, 10 Aug 2022 13:23:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X-CxHj+w1FYd; Wed, 10 Aug 2022 13:23:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85AEA4DBAA;
	Wed, 10 Aug 2022 13:23:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 886DE4DBA8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 13:23:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bQWJmD6FF6sd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 13:23:39 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50A9D4DBA7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 13:23:39 -0400 (EDT)
Date: Wed, 10 Aug 2022 12:23:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660152218;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=63Gw+QB8vRS1+zYg8ibY6LGRmceSmZAbiOInDTS2pJo=;
 b=fLhuFpjBq/Aj72N9srr+JxCLmQlfAhvoommxDwsCiGyQrcjEv9sa2/IhNJgqnPYWGHscaE
 FHEgBi+DNTT1zkIzBtMIsAQpaFewHMbypa5ScBM6ExQRlkgsnPw81EvyA55+AKbzY/TG0G
 5TkHmoZ+EVJ4AnDHcqMiQvL0FlYv5VU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 4/9] KVM: arm64: PMU: Add counter_index_to_*reg() helpers
Message-ID: <YvPplp8qRpWpzL3o@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-5-maz@kernel.org>
 <YvNboA7nla0NcKwa@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YvNboA7nla0NcKwa@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Wed, Aug 10, 2022 at 02:17:52AM -0500, Oliver Upton wrote:
> On Fri, Aug 05, 2022 at 02:58:08PM +0100, Marc Zyngier wrote:
> > In order to reduce the boilerplate code, add two helpers returning
> > the counter register index (resp. the event register) in the vcpu
> > register file from the counter index.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 27 +++++++++++++++------------
> >  1 file changed, 15 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 0ab6f59f433c..9be485d23416 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -75,6 +75,16 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> >  	return container_of(vcpu_arch, struct kvm_vcpu, arch);
> >  }
> >  
> > +static u32 counter_index_to_reg(u64 idx)
> > +{
> > +	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + idx;
> > +}
> > +
> > +static u32 counter_index_to_evtreg(u64 idx)
> > +{
> > +	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
> > +}
> > +

After reading the series, do you think these helpers could be applied to
kvm_pmu_counter_increment() as well?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
