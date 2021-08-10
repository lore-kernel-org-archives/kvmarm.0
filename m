Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D132C432BE
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 15:10:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0387C60F25
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 15:10:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0387C60F25
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7254140FC7;
	Tue, 10 Aug 2021 11:10:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z3SRyuP6j-L4; Tue, 10 Aug 2021 11:10:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C85C340856;
	Tue, 10 Aug 2021 11:10:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21A1440856
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 11:10:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ztmXbICOtLKB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 11:10:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 050A240839
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 11:10:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B3E61FB;
 Tue, 10 Aug 2021 08:10:26 -0700 (PDT)
Received: from [10.163.67.89] (unknown [10.163.67.89])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D40C3F718;
 Tue, 10 Aug 2021 08:10:23 -0700 (PDT)
Subject: Re: [PATCH 2/5] KVM: arm64: Drop init_common_resources()
To: Will Deacon <will@kernel.org>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
 <1628578961-29097-3-git-send-email-anshuman.khandual@arm.com>
 <20210810132123.GB2946@willie-the-truck>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <0480869b-bb08-747a-f4f1-3f77ba4bbed9@arm.com>
Date: Tue, 10 Aug 2021 20:41:16 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210810132123.GB2946@willie-the-truck>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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



On 8/10/21 6:51 PM, Will Deacon wrote:
> On Tue, Aug 10, 2021 at 12:32:38PM +0530, Anshuman Khandual wrote:
>> Could do without this additional indirection via init_common_resources() by
>> just calling kvm_set_ipa_limit() directly instead. This change saves memory
>> and cycles.
> 
> Does it? Really?

TBH, I did not really measure them to be sure. It was more like an intuitive
assumption. But do you suspect that the compiler might be already optimizing
this out, hence giving memory and CPU cycle benefits ? Regardless this still
drops an unnecessary function.

> 
> Will
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index e9a2b8f27792..19560e457c11 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1696,11 +1696,6 @@ static bool init_psci_relay(void)
>>  	return true;
>>  }
>>  
>> -static int init_common_resources(void)
>> -{
>> -	return kvm_set_ipa_limit();
>> -}
>> -
>>  static int init_subsystems(void)
>>  {
>>  	int err = 0;
>> @@ -2102,7 +2097,7 @@ int kvm_arch_init(void *opaque)
>>  		}
>>  	}
>>  
>> -	err = init_common_resources();
>> +	err = kvm_set_ipa_limit();
>>  	if (err)
>>  		return err;
>>  
>> -- 
>> 2.20.1
>>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
