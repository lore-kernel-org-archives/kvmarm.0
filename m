Return-Path: <SRS0=3tuy=W2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A5EC3A5A4
	for <kvmarm@archiver.kernel.org>; Fri, 30 Aug 2019 09:52:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83DA12186A
	for <kvmarm@archiver.kernel.org>; Fri, 30 Aug 2019 09:52:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83DA12186A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9CD04A562;
	Fri, 30 Aug 2019 05:52:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qEqs26vT145e; Fri, 30 Aug 2019 05:52:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B28254A52E;
	Fri, 30 Aug 2019 05:52:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF27C4A529
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Aug 2019 05:52:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v4ezoN3qzKsA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Aug 2019 05:52:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5220A4A4AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Aug 2019 05:52:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C85E8344;
 Fri, 30 Aug 2019 02:52:08 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 23C263F718;
 Fri, 30 Aug 2019 02:52:07 -0700 (PDT)
Subject: Re: [PATCH v4 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To: Christoffer Dall <christoffer.dall@arm.com>
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190830084255.55113-6-steven.price@arm.com>
 <20190830094245.GB5307@e113682-lin.lund.arm.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <bf45fea9-f2f7-1ff3-c90c-cb9623cbd959@arm.com>
Date: Fri, 30 Aug 2019 10:52:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190830094245.GB5307@e113682-lin.lund.arm.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Russell King <linux@armlinux.org.uk>,
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

On 30/08/2019 10:42, Christoffer Dall wrote:
> On Fri, Aug 30, 2019 at 09:42:50AM +0100, Steven Price wrote:
>> Implement the service call for configuring a shared structure between a
>> VCPU and the hypervisor in which the hypervisor can write the time
>> stolen from the VCPU's execution time by other tasks on the host.
>>
>> The hypervisor allocates memory which is placed at an IPA chosen by user
>> space. The hypervisor then updates the shared structure using
>> kvm_put_guest() to ensure single copy atomicity of the 64-bit value
>> reporting the stolen time in nanoseconds.
>>
>> Whenever stolen time is enabled by the guest, the stolen time counter is
>> reset.
>>
>> The stolen time itself is retrieved from the sched_info structure
>> maintained by the Linux scheduler code. We enable SCHEDSTATS when
>> selecting KVM Kconfig to ensure this value is meaningful.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
[...]
>> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	u64 steal;
>> +	u64 steal_le;
>> +	u64 offset;
>> +	int idx;
>> +	u64 base = vcpu->arch.steal.base;
>> +
>> +	if (base == GPA_INVALID)
>> +		return -ENOTSUPP;
>> +
>> +	/* Let's do the local bookkeeping */
>> +	steal = vcpu->arch.steal.steal;
>> +	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
>> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
>> +	vcpu->arch.steal.steal = steal;
>> +
>> +	steal_le = cpu_to_le64(steal);
>> +	idx = srcu_read_lock(&kvm->srcu);
>> +	if (init) {
>> +		struct pvclock_vcpu_stolen_time init_values = {
>> +			.revision = 0,
>> +			.attributes = 0
>> +		};
>> +		kvm_write_guest(kvm, base, &init_values,
>> +				sizeof(init_values));
>> +	}
>> +	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
>> +	kvm_put_guest(kvm, base + offset, steal_le, u64);
> 
> Let's hope we don't have thousands of memslots through which we have to
> do a linear scan on every vcpu load after this.  If that were the case,
> I think the memslot search path would have to be updated anyhow.

Yes I'm not sure with the current memslot implementation it is actually
beneficial to split up the stolen time structures into separate
memslots. But there's nothing requiring the use of so many memslots.

If this is really a problem it would be possible to implement a
memslot-caching kvm_put_guest(), but I'd want to wait until someone
shows there's actually a problem first.

> Otherwise looks reasonable to me.

Great, thanks for the review.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
