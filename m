Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CFC3C352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 18:09:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14DEF206DB
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 18:09:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YExdHBH4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14DEF206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5272C4AF12;
	Tue, 11 Feb 2020 13:09:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hD6D5fN4QAnb; Tue, 11 Feb 2020 13:09:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B00E4AF0F;
	Tue, 11 Feb 2020 13:09:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A13064AF0C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 13:09:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gARURFFq5WDP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 13:09:11 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 858A94AF0F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 13:09:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581444551;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cvWT08/WflUIvbNwwiYodUIPz5SYW+7c7HDtxodvSyY=;
 b=YExdHBH4PoWU6hhp/GF0TjZPe9u1Zl8aSMpMTQ2M+jlFfKeXqpcbRka8VnCvM6yEIiGdzn
 vSGTI76UFerIk8tng1O1/143wKJsEL2KlpLKgiokYuDZDIs0kxm9ZALFTx1SrCz68LyTEi
 GJL+j6pBJIlPyGDMyUEW0lBsj9zfw4I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-OeXjBtt3PWWnfP3RTAnh4g-1; Tue, 11 Feb 2020 13:09:08 -0500
X-MC-Unique: OeXjBtt3PWWnfP3RTAnh4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC05918A8C8B;
 Tue, 11 Feb 2020 18:09:06 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB2A360499;
 Tue, 11 Feb 2020 18:09:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 4/9] arm: pmu: Check Required Event
 Support
To: Peter Maydell <peter.maydell@linaro.org>
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-5-eric.auger@redhat.com>
 <CAFEAcA9rsncts+s4tVn4tY4zaMHKeqyJj1O4J=Ufx33fb=Nrcg@mail.gmail.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <45a29624-764f-acb2-dcc8-294bc591032e@redhat.com>
Date: Tue, 11 Feb 2020 19:08:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9rsncts+s4tVn4tY4zaMHKeqyJj1O4J=Ufx33fb=Nrcg@mail.gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
 Andre Przywara <andre.przywara@arm.com>, Andrew Murray <andrew.murray@arm.com>,
 kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger.pro@gmail.com>
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

Hi Peter,

On 2/11/20 4:33 PM, Peter Maydell wrote:
> On Thu, 30 Jan 2020 at 11:25, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> If event counters are implemented check the common events
>> required by the PMUv3 are implemented.
>>
>> Some are unconditionally required (SW_INCR, CPU_CYCLES,
>> either INST_RETIRED or INST_SPEC). Some others only are
>> required if the implementation implements some other features.
>>
>> Check those wich are unconditionally required.
>>
>> This test currently fails on TCG as neither INST_RETIRED
>> or INST_SPEC are supported.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
> 
>> +static bool is_event_supported(uint32_t n, bool warn)
>> +{
>> +       uint64_t pmceid0 = read_sysreg(pmceid0_el0);
>> +       uint64_t pmceid1 = read_sysreg_s(PMCEID1_EL0);
>> +       bool supported;
>> +       uint64_t reg;
>> +
>> +       /*
>> +        * The low 32-bits of PMCEID0/1 respectly describe
> 
> "respectively"
> 
>> +        * event support for events 0-31/32-63. Their High
>> +        * 32-bits describe support for extended events
>> +        * starting at 0x4000, using the same split.
>> +        */
>> +       if (n >= 0x0  && n <= 0x3F)
>> +               reg = (pmceid0 & 0xFFFFFFFF) | ((pmceid1 & 0xFFFFFFFF) << 32);
>> +       else if  (n >= 0x4000 && n <= 0x403F)
>> +               reg = (pmceid0 >> 32) | ((pmceid1 >> 32) << 32);
>> +       else
>> +               abort();
>> +
>> +       supported =  reg & (1UL << (n & 0x3F));
>> +
>> +       if (!supported && warn)
>> +               report_info("event %d is not supported", n);
>> +       return supported;
>> +}
>> +
>> +static void test_event_introspection(void)
>> +{
>> +       bool required_events;
>> +
>> +       if (!pmu.nb_implemented_counters) {
>> +               report_skip("No event counter, skip ...");
>> +               return;
>> +       }
>> +
>> +       /* PMUv3 requires an implementation includes some common events */
>> +       required_events = is_event_supported(0x0, true) /* SW_INCR */ &&
>> +                         is_event_supported(0x11, true) /* CPU_CYCLES */ &&
>> +                         (is_event_supported(0x8, true) /* INST_RETIRED */ ||
>> +                          is_event_supported(0x1B, true) /* INST_PREC */);
>> +
>> +       if (pmu.version == 0x4) {
> 
> This condition will only test for v8.1-required events if the PMU
> is exactly 8.1, so you lose coverage if the implementation happens
> to support ARMv8.4-PMU. Hopefully you have already bailed out
> for "ID_AA64DFR0_EL1.PMUVer == 0xf" which means "non-standard IMPDEF
> PMU", in which case you can just check >= 0x4.
OK thanks

Eric
> 
>> +               /* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
>> +               required_events = required_events &&
>> +                                 is_event_supported(0x23, true) &&
>> +                                 is_event_supported(0x24, true);
>> +       }
>> +
>> +       report(required_events, "Check required events are implemented");
>> +}
>> +
>>  #endif
> 
> thanks
> -- PMM
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
