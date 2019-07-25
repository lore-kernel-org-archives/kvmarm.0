Return-Path: <SRS0=xsle=VW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8D0C7618B
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jul 2019 12:58:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9642221951
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jul 2019 12:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="kWp+6bdn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9642221951
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14B1E4A5D1;
	Thu, 25 Jul 2019 08:58:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ra6wityqXYBN; Thu, 25 Jul 2019 08:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F187E4A5C1;
	Thu, 25 Jul 2019 08:58:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97E8E4A5A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jul 2019 08:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aYQBa-VFHYLC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jul 2019 08:58:49 -0400 (EDT)
Received: from smtp-fw-4101.amazon.com (smtp-fw-4101.amazon.com [72.21.198.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 876A14A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jul 2019 08:58:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1564059529; x=1595595529;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=qFECzT41lBG2MySNnYOUd1oQJ9XZpzRrKW7TJx5bGVw=;
 b=kWp+6bdnn8aku8gJOArblTd7dZ74RAlhjeQGwweLsLIDGma3GxYvWR2p
 NmikyrpXLgifB3Zlh/CeSaxmREN3phaeQWcdBPT/WSEHMsbAXxbtO8Jqi
 g6K/x1JRVrv49L2T/zNBL+Nfr39p8za1Rjb1MOTWlP8espDRnfKN9TRo1 8=;
X-IronPort-AV: E=Sophos;i="5.64,306,1559520000"; d="scan'208";a="776211028"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.124.125.6])
 by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP;
 25 Jul 2019 12:58:48 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
 by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS
 id 7F8B4A2EB7; Thu, 25 Jul 2019 12:58:46 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 25 Jul 2019 12:58:45 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.67) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 25 Jul 2019 12:58:43 +0000
Subject: Re: [PATCH kvm-unit-tests v2] arm: Add PL031 test
To: Andrew Jones <drjones@redhat.com>
References: <20190712091938.492-1-graf@amazon.com>
 <20190715164235.z2xar7nqi5guqfuf@kamzik.brq.redhat.com>
 <02a38777-3ec0-0354-8d49-d8ce337e5660@amazon.com>
 <20190725123344.4lmeopzyl4jdnsp7@kamzik.brq.redhat.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <67336ba0-c7dd-e6e5-9910-a85dba46c947@amazon.com>
Date: Thu, 25 Jul 2019 14:58:41 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725123344.4lmeopzyl4jdnsp7@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.67]
X-ClientProxiedBy: EX13D01UWA003.ant.amazon.com (10.43.160.107) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Precedence: Bulk
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
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



On 25.07.19 14:33, Andrew Jones wrote:
> On Thu, Jul 25, 2019 at 02:12:19PM +0200, Alexander Graf wrote:
>>
>>
>> On 15.07.19 18:42, Andrew Jones wrote:
>>> On Fri, Jul 12, 2019 at 11:19:38AM +0200, Alexander Graf wrote:
>>>> This patch adds a unit test for the PL031 RTC that is used in the virt machine.
>>>> It just pokes basic functionality. I've mostly written it to familiarize myself
>>>> with the device, but I suppose having the test around does not hurt, as it also
>>>> exercises the GIC SPI interrupt path.
>>>>
>>>> Signed-off-by: Alexander Graf <graf@amazon.com>
>>>>
>>>> ---
>>>>
>>>> v1 -> v2:
>>>>
>>>>     - Use FDT to find base, irq and existence
>>>>     - Put isb after timer read
>>>>     - Use dist_base for gicv3
>>>> ---
>>>>    arm/Makefile.common |   1 +
>>>>    arm/pl031.c         | 265 ++++++++++++++++++++++++++++++++++++++++++++
>>>>    lib/arm/asm/gic.h   |   1 +
>>>>    3 files changed, 267 insertions(+)
>>>>    create mode 100644 arm/pl031.c
>>>>
>>>> diff --git a/arm/Makefile.common b/arm/Makefile.common
>>>> index f0c4b5d..b8988f2 100644
>>>> --- a/arm/Makefile.common
>>>> +++ b/arm/Makefile.common
>>>> @@ -11,6 +11,7 @@ tests-common += $(TEST_DIR)/pmu.flat
>>>>    tests-common += $(TEST_DIR)/gic.flat
>>>>    tests-common += $(TEST_DIR)/psci.flat
>>>>    tests-common += $(TEST_DIR)/sieve.flat
>>>> +tests-common += $(TEST_DIR)/pl031.flat
>>>
>>> Makefile.common is for both arm32 and arm64, but this code is only
>>> compilable on arm64. As there's no reason for it to be arm64 only,
>>> then ideally we'd modify the code to allow compiling and running
>>> on both, but otherwise we need to move this to Makefile.arm64.
>>
>> D'oh. Sorry, I completely missed that bit. Of course we want to test on
>> 32bit ARM as well! I'll fix it up :).
>>
>>
>> [...]
>>
>>>> +static int rtc_fdt_init(void)
>>>> +{
>>>> +	const struct fdt_property *prop;
>>>> +	const void *fdt = dt_fdt();
>>>> +	int node, len;
>>>> +	u32 *data;
>>>> +
>>>> +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,pl031");
>>>> +	if (node < 0)
>>>> +		return -1;
>>>> +
>>>> +	prop = fdt_get_property(fdt, node, "interrupts", &len);
>>>> +	assert(prop && len == (3 * sizeof(u32)));
>>>> +	data = (u32 *)prop->data;
>>>> +	assert(data[0] == 0); /* SPI */
>>>> +	pl031_irq = SPI(fdt32_to_cpu(data[1]));
>>>
>>> Nit: Ideally we'd add some more devicetree API to get interrupts. With
>>> that, and the existing devicetree API, we could remove all low-level fdt
>>> related code in this function.
>>
>> Well, we probably want some really high level fdt API that can traverse reg
>> properly to map bus regs into physical addresses. As long as we don't have
>> all that magic,
> 
> We do have much of that magic already. Skim through lib/devicetree.h to
> see what's available.

Hum, interesting. There really is some good code in there :).

> 
>> I see little point in inventing anything that looks more
>> sophisticated but doesn't actually take the difficult problems into account
>> :).
> 
> Well, for this case, the "interrupts" decoding isn't difficult and could
> be shared among other devices if we added it to devicetree.c. And the
> reg decoding below to get the base address is already supported by the
> devicetree API.

The main problem with interrupts is that its semantics are not generic. 
Items like "SPI/LPI", "EDGE/Level", "vector" are all target defined.

> All that said, it's just a nit that I won't insist on though, because it's
> hard enough to get unit test contributors without asking that they also
> contribute to the framework.

:)


Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
