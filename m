Return-Path: <SRS0=3CJn=MP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4C7C4338F
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 13:30:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5CFE560EFD
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 13:30:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5CFE560EFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D40444B11A;
	Fri, 23 Jul 2021 09:30:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KFuI-S0uhtUD; Fri, 23 Jul 2021 09:30:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99E564B139;
	Fri, 23 Jul 2021 09:30:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CF2A4B11A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 09:30:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sSjCLSvF1UfE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Jul 2021 09:30:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29A3F4B117
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 09:30:16 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3A3D360EB4;
 Fri, 23 Jul 2021 13:30:15 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m6vFl-000UyF-5x; Fri, 23 Jul 2021 14:30:13 +0100
MIME-Version: 1.0
Date: Fri, 23 Jul 2021 14:30:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
In-Reply-To: <20210721211743.hb2cxghhwl2y22yh@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-11-maz@kernel.org>
 <20210721211743.hb2cxghhwl2y22yh@gator>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <60d8e9e95ee4640cf3b457c53cb4cc7a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@android.com, vatsa@codeaurora.org,
 sdonthineni@nvidia.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, will@kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kernel-team@android.com,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-07-21 22:17, Andrew Jones wrote:
> On Thu, Jul 15, 2021 at 05:31:53PM +0100, Marc Zyngier wrote:
>> Document the hypercalls user for the MMIO guard infrastructure.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  Documentation/virt/kvm/arm/index.rst      |  1 +
>>  Documentation/virt/kvm/arm/mmio-guard.rst | 73 
>> +++++++++++++++++++++++
>>  2 files changed, 74 insertions(+)
>>  create mode 100644 Documentation/virt/kvm/arm/mmio-guard.rst
>> 
>> diff --git a/Documentation/virt/kvm/arm/index.rst 
>> b/Documentation/virt/kvm/arm/index.rst
>> index 78a9b670aafe..e77a0ee2e2d4 100644
>> --- a/Documentation/virt/kvm/arm/index.rst
>> +++ b/Documentation/virt/kvm/arm/index.rst
>> @@ -11,3 +11,4 @@ ARM
>>     psci
>>     pvtime
>>     ptp_kvm
>> +   mmio-guard
>> diff --git a/Documentation/virt/kvm/arm/mmio-guard.rst 
>> b/Documentation/virt/kvm/arm/mmio-guard.rst
>> new file mode 100644
>> index 000000000000..a5563a3e12cc
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/arm/mmio-guard.rst
>> @@ -0,0 +1,73 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +==============
>> +KVM MMIO guard
>> +==============
>> +
>> +KVM implements device emulation by handling translation faults to any
>> +IPA range that is not contained a memory slot. Such translation fault
>                                   ^ in                ^ a
> 
>> +is in most cases passed on to userspace (or in rare cases to the host
>> +kernel) with the address, size and possibly data of the access for
>> +emulation.
>> +
>> +Should the guest exit with an address that is not one that 
>> corresponds
>> +to an emulatable device, userspace may take measures that are not the
>> +most graceful as far as the guest is concerned (such as terminating 
>> it
>> +or delivering a fatal exception).
>> +
>> +There is also an element of trust: by forwarding the request to
>> +userspace, the kernel asumes that the guest trusts userspace to do 
>> the
> 
> assumes
> 
>> +right thing.
>> +
>> +The KVM MMIO guard offers a way to mitigate this last point: a guest
>> +can request that only certainly regions of the IPA space are valid as
> 
> certain

Thanks, all corrections applied.

> 
>> +MMIO. Only these regions will be handled as an MMIO, and any other
>> +will result in an exception being delivered to the guest.
>> +
>> +This relies on a set of hypercalls defined in the KVM-specific range,
>> +using the HVC64 calling convention.
>> +
>> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO
>> +
>> +    ==============    ========    ================================
>> +    Function ID:      (uint32)    0xC6000002
>> +    Arguments:        none
>> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
>> +                      (uint64)    Protection Granule (PG) size in
>> +		                  bytes (r0)
>> +    ==============    ========    ================================
>> +
>> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL
>> +
>> +    ==============    ========    ==============================
>> +    Function ID:      (uint32)    0xC6000003
>> +    Arguments:        none
>> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
>> +                                  RET_SUCCESS(0) (r0)
>> +    ==============    ========    ==============================
>> +
>> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP
>> +
>> +    ==============    ========    
>> ======================================
>> +    Function ID:      (uint32)    0xC6000004
>> +    Arguments:        (uint64)    The base of the PG-sized IPA range
>> +                                  that is allowed to be accessed as
>> +				  MMIO. Must aligned to the PG size (r1)
> 
> align

Hmmm. Ugly mix of tab and spaces. I have no idea what the norm
is here, so I'll just put spaces. I'm sure someone will let me
know if I'm wrong! ;-)

> 
>> +                      (uint64)    Index in the MAIR_EL1 register
>> +		                  providing the memory attribute that
>> +				  is used by the guest (r2)
>> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
>> +                                  RET_SUCCESS(0) (r0)
>> +    ==============    ========    
>> ======================================
>> +
>> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP
>> +
>> +    ==============    ========    
>> ======================================
>> +    Function ID:      (uint32)    0xC6000004
> 
> copy+paste error, should be 0xC6000005

Gah, well cpotted.

> 
>> +    Arguments:        (uint64)    The base of the PG-sized IPA range
>> +                                  that is forbidden to be accessed as
> 
> is now forbidden
> 
> or
> 
> was allowed
> 
> or just drop that part of the sentence because its covered by the "and
> have been previously mapped" part. Something like
> 
> PG-sized IPA range aligned to the PG size which has been previously 
> mapped
> (r1)

Picked the latter.

Thanks again,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
