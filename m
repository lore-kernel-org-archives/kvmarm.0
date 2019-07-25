Return-Path: <SRS0=xsle=VW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78715C7618B
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jul 2019 12:12:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EADD4229F3
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jul 2019 12:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="VGTfK9sU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EADD4229F3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 436EB4A57A;
	Thu, 25 Jul 2019 08:12:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sIVXvPevMxRa; Thu, 25 Jul 2019 08:12:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 297CB4A57D;
	Thu, 25 Jul 2019 08:12:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 411C04A574
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jul 2019 08:12:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2qgerRZs73f7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jul 2019 08:12:37 -0400 (EDT)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com
 [207.171.184.29])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70F4C4A54C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jul 2019 08:12:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1564056757; x=1595592757;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=Ab1CWKE+OztaUGMWuWyRMVWvhP5S22Y2ZduWwOWxgdY=;
 b=VGTfK9sUk9iv1MGUZUrF/cZ8o1CDaPMrQyKv4vUWRiPbTxZNu+oNNwvU
 JlH5NyCE06g6xg7nSJmWPTxwzOAX1V9Vq2e3Iotf8piTiffcImHPxyvFd
 pnJ93F3prBSevOc71SQxGA8SsdHK86cLJ/4Y9OLIvLTyBMqZ0YP6ig4fN s=;
X-IronPort-AV: E=Sophos;i="5.64,306,1559520000"; d="scan'208";a="687871196"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO
 email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.22.34])
 by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP;
 25 Jul 2019 12:12:27 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
 by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS
 id E59CCA2636; Thu, 25 Jul 2019 12:12:24 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 25 Jul 2019 12:12:24 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.30) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 25 Jul 2019 12:12:22 +0000
Subject: Re: [PATCH kvm-unit-tests v2] arm: Add PL031 test
To: Andrew Jones <drjones@redhat.com>
References: <20190712091938.492-1-graf@amazon.com>
 <20190715164235.z2xar7nqi5guqfuf@kamzik.brq.redhat.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <02a38777-3ec0-0354-8d49-d8ce337e5660@amazon.com>
Date: Thu, 25 Jul 2019 14:12:19 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190715164235.z2xar7nqi5guqfuf@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.30]
X-ClientProxiedBy: EX13D24UWA004.ant.amazon.com (10.43.160.233) To
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



On 15.07.19 18:42, Andrew Jones wrote:
> On Fri, Jul 12, 2019 at 11:19:38AM +0200, Alexander Graf wrote:
>> This patch adds a unit test for the PL031 RTC that is used in the virt machine.
>> It just pokes basic functionality. I've mostly written it to familiarize myself
>> with the device, but I suppose having the test around does not hurt, as it also
>> exercises the GIC SPI interrupt path.
>>
>> Signed-off-by: Alexander Graf <graf@amazon.com>
>>
>> ---
>>
>> v1 -> v2:
>>
>>    - Use FDT to find base, irq and existence
>>    - Put isb after timer read
>>    - Use dist_base for gicv3
>> ---
>>   arm/Makefile.common |   1 +
>>   arm/pl031.c         | 265 ++++++++++++++++++++++++++++++++++++++++++++
>>   lib/arm/asm/gic.h   |   1 +
>>   3 files changed, 267 insertions(+)
>>   create mode 100644 arm/pl031.c
>>
>> diff --git a/arm/Makefile.common b/arm/Makefile.common
>> index f0c4b5d..b8988f2 100644
>> --- a/arm/Makefile.common
>> +++ b/arm/Makefile.common
>> @@ -11,6 +11,7 @@ tests-common += $(TEST_DIR)/pmu.flat
>>   tests-common += $(TEST_DIR)/gic.flat
>>   tests-common += $(TEST_DIR)/psci.flat
>>   tests-common += $(TEST_DIR)/sieve.flat
>> +tests-common += $(TEST_DIR)/pl031.flat
> 
> Makefile.common is for both arm32 and arm64, but this code is only
> compilable on arm64. As there's no reason for it to be arm64 only,
> then ideally we'd modify the code to allow compiling and running
> on both, but otherwise we need to move this to Makefile.arm64.

D'oh. Sorry, I completely missed that bit. Of course we want to test on 
32bit ARM as well! I'll fix it up :).


[...]

>> +static int rtc_fdt_init(void)
>> +{
>> +	const struct fdt_property *prop;
>> +	const void *fdt = dt_fdt();
>> +	int node, len;
>> +	u32 *data;
>> +
>> +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,pl031");
>> +	if (node < 0)
>> +		return -1;
>> +
>> +	prop = fdt_get_property(fdt, node, "interrupts", &len);
>> +	assert(prop && len == (3 * sizeof(u32)));
>> +	data = (u32 *)prop->data;
>> +	assert(data[0] == 0); /* SPI */
>> +	pl031_irq = SPI(fdt32_to_cpu(data[1]));
> 
> Nit: Ideally we'd add some more devicetree API to get interrupts. With
> that, and the existing devicetree API, we could remove all low-level fdt
> related code in this function.

Well, we probably want some really high level fdt API that can traverse 
reg properly to map bus regs into physical addresses. As long as we 
don't have all that magic, I see little point in inventing anything that 
looks more sophisticated but doesn't actually take the difficult 
problems into account :).

> 
>> +
>> +	prop = fdt_get_property(fdt, node, "reg", &len);
>> +	assert(prop && len == (2 * sizeof(u64)));
>> +	data = (u32 *)prop->data;
>> +	pl031 = (void*)((ulong)fdt32_to_cpu(data[0]) << 32 | fdt32_to_cpu(data[1]));
> 
> This works because we currently ID map all the physical memory. I usually
> try to remember to use an ioremap in these cases anyway though.

Great idea - it allows me to get rid of a bit of casting too.


Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
