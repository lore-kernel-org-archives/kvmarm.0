Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FDFC433E2
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 07:40:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 770CC214F1
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 07:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="ZywYr5qg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 770CC214F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC4B04B2A4;
	Fri, 11 Sep 2020 03:40:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W6cnIrTbnDpo; Fri, 11 Sep 2020 03:40:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C6634B2D7;
	Fri, 11 Sep 2020 03:40:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56FB24B2AB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 03:40:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ztFNB1seT4n for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 03:40:13 -0400 (EDT)
Received: from smtp-fw-9101.amazon.com (smtp-fw-9101.amazon.com
 [207.171.184.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 10E144B2A4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 03:40:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1599810013; x=1631346013;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=UtU8cHk7dC7NJ+X6wTkUmJT4/ZJ7Wx++LRb1OyZmff4=;
 b=ZywYr5qgbPqRiw+NcwXi6EzvioIoDfI3fxsKtQJk2F/P+BkOxokVjRR2
 TVlx+3bxVxMqmeeU4euXyeavEFucB6ymn6YRdTYIB1xyakMLkbqXl5L0S
 9PSu3o0ZimxNNcqesztf+F1O7IvRdIzS3qlvhO6ioYCysVHJO6ncDlwyR w=;
X-IronPort-AV: E=Sophos;i="5.76,414,1592870400"; d="scan'208";a="67167348"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO
 email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
 by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP;
 11 Sep 2020 07:40:11 +0000
Received: from EX13MTAUWC002.ant.amazon.com
 (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
 by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS
 id EAA65A213F; Fri, 11 Sep 2020 07:40:09 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Sep 2020 07:40:09 +0000
Received: from Alexanders-MacBook-Air.local (10.43.162.73) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Sep 2020 07:40:06 +0000
Subject: Re: [PATCH v3] KVM: arm64: Preserve PMCR immutable values across reset
To: Andrew Jones <drjones@redhat.com>
References: <20200910164243.29253-1-graf@amazon.com>
 <20200910173609.niujn2ngnjzvx7ub@kamzik.brq.redhat.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <2938f7ef-a723-2ee3-0a87-25cbde177d23@amazon.com>
Date: Fri, 11 Sep 2020 09:40:04 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910173609.niujn2ngnjzvx7ub@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D49UWB003.ant.amazon.com (10.43.163.121) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>,
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



On 10.09.20 19:36, Andrew Jones wrote:
> 
> On Thu, Sep 10, 2020 at 06:42:43PM +0200, Alexander Graf wrote:
>> We allow user space to set the PMCR register to any value. However,
>> when time comes for a vcpu reset (for example on PSCI online), PMCR
>> is reset to the hardware capabilities.
>>
>> I would like to explicitly expose different PMU capabilities (number
>> of supported event counters) to the guest than hardware supports.
>> Ideally across vcpu resets.
>>
>> So this patch adopts the reset path to only populate the immutable
>> PMCR register bits from hardware when they were not initialized
>> previously. This effectively means that on a normal reset, only the
>> guest settable fields are reset, while on vcpu creation the register
>> gets populated from hardware like before.
>>
>> With this in place and a change in user space to invoke SET_ONE_REG
>> on the PMCR for every vcpu, I can reliably set the PMU event counter
>> number to arbitrary values.
>>
>> Signed-off-by: Alexander Graf <graf@amazon.com>
>> ---
>>   arch/arm64/kvm/sys_regs.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 20ab2a7d37ca..28f67550db7f 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -663,7 +663,14 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>   {
>>        u64 pmcr, val;
>>
>> -     pmcr = read_sysreg(pmcr_el0);
>> +     /*
>> +      * If we already received PMCR from a previous ONE_REG call,
>> +      * maintain its immutable flags
>> +      */
>> +     pmcr = __vcpu_sys_reg(vcpu, r->reg);
>> +     if (!__vcpu_sys_reg(vcpu, r->reg))
>> +             pmcr = read_sysreg(pmcr_el0);
>> +
>>        /*
>>         * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN
>>         * except PMCR.E resetting to zero.
>> --
>> 2.16.4
>>
> 
> Aha, a much simpler patch than I expected. With this approach we don't
> need a get_user() function, or to use 'val', but don't we still want to
> add sanity checks with a set_user() function? At least to ensure immutable
> flags match and that PMCR_EL0.N isn't too big?

We don't check for any flags today, so in a way adding checks would be 
ABI breakage.

And as Marc pointed out, all of the counters are basically virtual 
through perf. So if you report 31 counters, you end up spawning 31 perf 
counters which get multiplexed, so it would work (albeit not be terribly 
accurate).

That leaves identification bits as something we can check for. But do we 
really have to? What's the worst thing that can happen? KVM user space 
can shoot themselves in the foot. Well, they can also set PC to an 
invalid value. If you do bad things you get bad results :). As long as 
it's not a security risk, I'm not sure the benefits of checking outweigh 
the risks.

> Silently changing the user's input, which I see we also do for e.g. MPIDR,
> isn't super user friendly.

Yes :).


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
