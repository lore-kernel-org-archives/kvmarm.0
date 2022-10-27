Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0565CECAAA1
	for <kvmarm@archiver.kernel.org>; Thu, 27 Oct 2022 15:21:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 612E140431;
	Thu, 27 Oct 2022 11:21:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F5U5AVAZ3C8Q; Thu, 27 Oct 2022 11:21:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E5184086D;
	Thu, 27 Oct 2022 11:21:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 316DB40755
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 11:21:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id at7FJAHVV888 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 11:21:34 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2C4A40431
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 11:21:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 8E4F2B825E3;
 Thu, 27 Oct 2022 15:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48301C433C1;
 Thu, 27 Oct 2022 15:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666884091;
 bh=H9WUjCzGGNN06EF+TlX9yvE8arkV5DGJVVT0ALe9MQM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=YAel0MsaU6b9iw+V6SqZfCenO14l6YoNOssEiNX0pq4BLbUN/2N0iukDE3J5SpVWD
 Sai+B/Hvv5+ZtwLr0kU7CiyGmY5nopq7lszd1WJfAIr3P/u4byZatGvNz2hCpJmcZ2
 tYh+H8rTvwyHf/NX75p3sRI8xaTe1txYgpcB5HI8JE86lwZPiiwcGTt4YWm2YcyDB3
 UXV71CkWqAStvsfX+fu2UTVEz4mRSzZ9+O59sEKfE4A5HWflAYBJlfq3n2Ee1H9dmC
 UUM+OBpdky72YQ3ialxejhS4+lmICYzTqhpluzzC6GB5qGlIpsgVwb8d9SVlE9waCU
 iW4gZZX037IQA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oo4hE-0021wH-He;
 Thu, 27 Oct 2022 16:21:29 +0100
MIME-Version: 1.0
Date: Thu, 27 Oct 2022 16:21:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 1/9] KVM: arm64: PMU: Align chained counter implementation
 with architecture pseudocode
In-Reply-To: <CAAeT=FzbYp58Yw6QXqD92w4UMG8x+O81i6hoC+_jeOEL0vFjGA@mail.gmail.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-2-maz@kernel.org>
 <CAAeT=Fz55H09PWpmMu1sBkV=iUEHWezwhghJskaWAoqQsi2N0A@mail.gmail.com>
 <86zgdlms58.wl-maz@kernel.org>
 <CAAeT=FzbYp58Yw6QXqD92w4UMG8x+O81i6hoC+_jeOEL0vFjGA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <cf1bb582d44cf2a40a3dfc12d21f24fa@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reijiw@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

On 2022-10-27 15:33, Reiji Watanabe wrote:
> Hi Marc,
> 
>> > > +static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>> > > +                                     unsigned long mask, u32 event)
>> > > +{
>> > > +       int i;
>> > > +
>> > > +       if (!kvm_vcpu_has_pmu(vcpu))
>> > > +               return;
>> > > +
>> > > +       if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
>> > > +               return;
>> > > +
>> > > +       /* Weed out disabled counters */
>> > > +       mask &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>> > > +
>> > > +       for_each_set_bit(i, &mask, ARMV8_PMU_CYCLE_IDX) {
>> > > +               u64 type, reg;
>> > > +
>> > > +               /* Filter on event type */
>> > > +               type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
>> > > +               type &= kvm_pmu_event_mask(vcpu->kvm);
>> > > +               if (type != event)
>> > > +                       continue;
>> > > +
>> > > +               /* Increment this counter */
>> > > +               reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
>> > > +               reg = lower_32_bits(reg);
>> > > +               __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
>> > > +
>> > > +               if (reg) /* No overflow? move on */
>> > > +                       continue;
>> > > +
>> > > +               /* Mark overflow */
>> > > +               __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
>> >
>> > Perhaps it might be useful to create another helper that takes
>> > care of just one counter (it would essentially do the code above
>> > in the loop). The helper could be used (in addition to the above
>> > loop) from the code below for the CHAIN event case and from
>> > kvm_pmu_perf_overflow(). Then unnecessary execution of
>> > for_each_set_bit() could be avoided for these two cases.
>> 
>> I'm not sure it really helps. We would still need to check whether the
>> counter is enabled, and we'd need to bring that into the helper
>> instead of keeping it outside of the loop.
> 
> That's true. It seems that I overlooked that.
> Although it appears checking with kvm_vcpu_has_pmu() is unnecessary
> (redundant), the check with PMCR_EL0.E is necessary.

Ah indeed, I'll drop the kvm_vcpu_has_pmu() check.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
