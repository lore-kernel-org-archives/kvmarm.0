Return-Path: <SRS0=I38I=X5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5902C4360C
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 09:13:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53DAE20867
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 09:13:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53DAE20867
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B348D4A662;
	Fri,  4 Oct 2019 05:13:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mG9mekUc4ab3; Fri,  4 Oct 2019 05:13:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B24EB4A658;
	Fri,  4 Oct 2019 05:13:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E548D4A654
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 05:13:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XSIP8FQFpMhu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Oct 2019 05:13:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C98D04A54B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 05:13:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7066C1597;
 Fri,  4 Oct 2019 02:13:43 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FCE83F739;
 Fri,  4 Oct 2019 02:13:41 -0700 (PDT)
Subject: Re: [PATCH v5 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To: Andrew Jones <drjones@redhat.com>
References: <20191002145037.51630-1-steven.price@arm.com>
 <20191002145037.51630-6-steven.price@arm.com>
 <20191003132235.ruanyfmdim5s6npj@kamzik.brq.redhat.com>
 <20191004070301.d7ari5rjlu3uuara@kamzik.brq.redhat.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <b107c1ca-6804-dc47-af25-fcd0b201472f@arm.com>
Date: Fri, 4 Oct 2019 10:13:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191004070301.d7ari5rjlu3uuara@kamzik.brq.redhat.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 04/10/2019 08:03, Andrew Jones wrote:
> On Thu, Oct 03, 2019 at 03:22:35PM +0200, Andrew Jones wrote:
>> On Wed, Oct 02, 2019 at 03:50:32PM +0100, Steven Price wrote:
>>> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
>>> +{
>>> +	struct kvm *kvm = vcpu->kvm;
>>> +	u64 steal;
>>> +	u64 steal_le;
>>> +	u64 offset;
>>> +	int idx;
>>> +	u64 base = vcpu->arch.steal.base;
>>> +
>>> +	if (base == GPA_INVALID)
>>> +		return -ENOTSUPP;
>>> +
>>> +	/* Let's do the local bookkeeping */
>>> +	steal = vcpu->arch.steal.steal;
>>> +	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
>>> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
>>> +	vcpu->arch.steal.steal = steal;
>>> +
>>> +	steal_le = cpu_to_le64(steal);
>>
>> Agreeing on a byte order for this interface makes sense, but I don't see
>> it documented anywhere. Is this an SMCCC thing? Because I skimmed some
>> of those specs and other users too but didn't see anything obvious. Anyway
>> even if everybody but me knows that all data returned from SMCCC calls
>> should be LE, it might be nice to document that in the pvtime doc.

A very good point - I'll document this in the Linux document and feed
that back for DEN0057A.

> 
> I have another [potentially dumb] SMCCC byte order question. If we need
> to worry about using LE for the members of this structure, then why don't
> we need to worry about the actual return values of the SMCCC calls? Like
> the IPA of the structure?

The SMCCC calls pass values in registers. It's only when reading/writing
these values from/to memory that the endianness actually has any meaning.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
