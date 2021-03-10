Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D048EC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 11:16:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B88E64FE8
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 11:16:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B88E64FE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5404C4B39C;
	Wed, 10 Mar 2021 06:16:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id clqP4c1xVmRJ; Wed, 10 Mar 2021 06:16:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F201D4B618;
	Wed, 10 Mar 2021 06:16:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D49FE4B614
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 06:16:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Ivez0MEFBwo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 06:16:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A50C04B60E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 06:16:08 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6FF4A64FCB;
 Wed, 10 Mar 2021 11:16:07 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lJwov-000k4U-8H; Wed, 10 Mar 2021 11:16:05 +0000
MIME-Version: 1.0
Date: Wed, 10 Mar 2021 11:16:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Reject VM creation when the default
 IPA size is unsupported
In-Reply-To: <c8de95cb-57dc-14df-f133-6c12b921de2b@redhat.com>
References: <20210310104208.3819061-1-maz@kernel.org>
 <20210310104208.3819061-2-maz@kernel.org>
 <c8de95cb-57dc-14df-f133-6c12b921de2b@redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <8d5468231157016aaf301c2be3b4a12c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org,
 drjones@redhat.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On 2021-03-10 10:59, Auger Eric wrote:
> Hi Marc,
> 
> On 3/10/21 11:42 AM, Marc Zyngier wrote:
>> KVM/arm64 has forever used a 40bit default IPA space, partially
>> due to its 32bit heritage (where the only choice is 40bit).
>> 
>> However, there are implementations in the wild that have a *cough*
>> much smaller *cough* IPA space, which leads to a misprogramming of
>> VTCR_EL2, and a guest that is stuck on its first memory access
>> if userspace dares to ask for the default IPA setting (which most
>> VMMs do).
>> 
>> Instead, blundly reject the creation of such VM, as we can't
>> satisfy the requirements from userspace (with a one-off warning).
>> Also clarify the boot warning, and document that the VM creation
>> will fail when an unsupported IPA size is probided.
>> 
>> Although this is an ABI change, it doesn't really change much
>> for userspace:
>> 
>> - the guest couldn't run before this change, but no error was
>>   returned. At least userspace knows what is happening.
>> 
>> - a memory slot that was accepted because it did fit the default
>>   IPA space now doesn't even get a chance to be registered.
>> 
>> The other thing that is left doing is to convince userspace to
>> actually use the IPA space setting instead of relying on the
>> antiquated default.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  Documentation/virt/kvm/api.rst |  3 +++
>>  arch/arm64/kvm/reset.c         | 12 ++++++++----
>>  2 files changed, 11 insertions(+), 4 deletions(-)
>> 
>> diff --git a/Documentation/virt/kvm/api.rst 
>> b/Documentation/virt/kvm/api.rst
>> index 1a2b5210cdbf..38e327d4b479 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -182,6 +182,9 @@ is dependent on the CPU capability and the kernel 
>> configuration. The limit can
>>  be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the KVM_CHECK_EXTENSION
>>  ioctl() at run-time.
>> 
>> +Creation of the VM will fail if the requested IPA size (whether it is
>> +implicit or explicit) is unsupported on the host.
>> +
>>  Please note that configuring the IPA size does not affect the 
>> capability
>>  exposed by the guest CPUs in ID_AA64MMFR0_EL1[PARange]. It only 
>> affects
>>  size of the address translated by the stage2 level (guest physical to
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 47f3f035f3ea..f1a38405934e 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -324,10 +324,9 @@ int kvm_set_ipa_limit(void)
>>  	}
>> 
>>  	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
>> -	WARN(kvm_ipa_limit < KVM_PHYS_SHIFT,
>> -	     "KVM IPA Size Limit (%d bits) is smaller than default size\n",
>> -	     kvm_ipa_limit);
>> -	kvm_info("IPA Size Limit: %d bits\n", kvm_ipa_limit);
>> +	kvm_info("IPA Size Limit: %d bits%s\n", kvm_ipa_limit,
>> +		 ((kvm_ipa_limit < KVM_PHYS_SHIFT) ?
>> +		  " (Reduced IPA size, limited VM/VMM compatibility)" : ""));
>> 
>>  	return 0;
>>  }
>> @@ -356,6 +355,11 @@ int kvm_arm_setup_stage2(struct kvm *kvm, 
>> unsigned long type)
>>  			return -EINVAL;
>>  	} else {
>>  		phys_shift = KVM_PHYS_SHIFT;
>> +		if (phys_shift > kvm_ipa_limit) {
>> +			pr_warn_once("%s using unsupported default IPA limit, upgrade your 
>> VMM\n",
>> +				     current->comm, kvm_ipa_limit);
> don't you have a trouble with the args here?
> 
> Otherwise looks sensible to me.

This is what happens when you do a last minute change and push it out
without thinking.

My apologies, I'll fix that.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
