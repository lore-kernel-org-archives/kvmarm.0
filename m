Return-Path: <SRS0=UWlR=26=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA02C282DD
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 17:37:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E46720661
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 17:37:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LkpG5FFZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E46720661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 179CE4B038;
	Thu,  9 Jan 2020 12:37:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GH0B7gj+wHZk; Thu,  9 Jan 2020 12:37:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9916C4B23E;
	Thu,  9 Jan 2020 12:37:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C30F4AFE9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 12:37:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aLZNUZZnvL5h for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jan 2020 12:37:42 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B5754B237
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 12:37:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1578591461;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+hd1spx0j5nExGhcsZntaXPkm5mIhaB1M+8iBPreXT8=;
 b=LkpG5FFZxopiaShAMDqLMS/gS280WAIHuPYcB/sq7LdccPUTAF56IYi63RgbQatONqFHrq
 kEjMOofTj2FV/MFTlVfM6wFFGr9yxB20gfna++XWUapq1H5cvgTnh0BVrC5ohvsIMoCbyu
 HsZ+QHa3W0YMBLEeohPub3HyIS/h58c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-x2Z3y9lrNSyM08zcJ_75fg-1; Thu, 09 Jan 2020 12:37:38 -0500
X-MC-Unique: x2Z3y9lrNSyM08zcJ_75fg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E5B310054E3;
 Thu,  9 Jan 2020 17:37:36 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C210F10013A7;
 Thu,  9 Jan 2020 17:37:33 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 04/10] arm: pmu: Check Required Event
 Support
To: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
References: <20191216204757.4020-1-eric.auger@redhat.com>
 <20191216204757.4020-5-eric.auger@redhat.com>
 <20200103181251.72cfcae2@donnerap.cambridge.arm.com>
 <ce0ce49f-7e19-21d4-5eba-386dd2f96301@redhat.com>
 <380b27cb-a762-0622-af9c-1d2afc3a4b5e@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <c1831b6c-dc75-1bd3-6657-0375682c30af@redhat.com>
Date: Thu, 9 Jan 2020 18:37:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <380b27cb-a762-0622-af9c-1d2afc3a4b5e@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Andre,

On 1/9/20 6:30 PM, Andr=E9 Przywara wrote:
> On 09/01/2020 16:54, Auger Eric wrote:
> =

> Hi Eric,
> =

>> On 1/3/20 7:12 PM, Andre Przywara wrote:
>>> On Mon, 16 Dec 2019 21:47:51 +0100
>>> Eric Auger <eric.auger@redhat.com> wrote:
>>>
>>> Hi Eric,
>>>
>>>> If event counters are implemented check the common events
>>>> required by the PMUv3 are implemented.
>>>>
>>>> Some are unconditionally required (SW_INCR, CPU_CYCLES,
>>>> either INST_RETIRED or INST_SPEC). Some others only are
>>>> required if the implementation implements some other features.
>>>>
>>>> Check those wich are unconditionally required.
>>>>
>>>> This test currently fails on TCG as neither INST_RETIRED
>>>> or INST_SPEC are supported.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
>>>>
>>>> v1 ->v2:
>>>> - add a comment to explain the PMCEID0/1 splits
>>>> ---
>>>>  arm/pmu.c         | 71 +++++++++++++++++++++++++++++++++++++++++++++++
>>>>  arm/unittests.cfg |  6 ++++
>>>>  2 files changed, 77 insertions(+)
>>>>
>>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>>> index d24857e..d88ef22 100644
>>>> --- a/arm/pmu.c
>>>> +++ b/arm/pmu.c
>>>> @@ -101,6 +101,10 @@ static inline void precise_instrs_loop(int loop, =
uint32_t pmcr)
>>>>  	: [pmcr] "r" (pmcr), [z] "r" (0)
>>>>  	: "cc");
>>>>  }
>>>> +
>>>> +/* event counter tests only implemented for aarch64 */
>>>> +static void test_event_introspection(void) {}
>>>> +
>>>>  #elif defined(__aarch64__)
>>>>  #define ID_AA64DFR0_PERFMON_SHIFT 8
>>>>  #define ID_AA64DFR0_PERFMON_MASK  0xf
>>>> @@ -139,6 +143,70 @@ static inline void precise_instrs_loop(int loop, =
uint32_t pmcr)
>>>>  	: [pmcr] "r" (pmcr)
>>>>  	: "cc");
>>>>  }
>>>> +
>>>> +#define PMCEID1_EL0 sys_reg(11, 3, 9, 12, 7)
>>>> +
>>>> +static bool is_event_supported(uint32_t n, bool warn)
>>>> +{
>>>> +	uint64_t pmceid0 =3D read_sysreg(pmceid0_el0);
>>>> +	uint64_t pmceid1 =3D read_sysreg_s(PMCEID1_EL0);
>>>> +	bool supported;
>>>> +	uint32_t reg;
>>>> +
>>>> +	/*
>>>> +	 * The low 32-bits of PMCEID0/1 respectly describe
>>>> +	 * event support for events 0-31/32-63. Their High
>>>> +	 * 32-bits describe support for extended events
>>>> +	 * starting at 0x4000, using the same split.
>>>> +	 */
>>>> +	if (n >=3D 0x0  && n <=3D 0x1F)
>>>> +		reg =3D pmceid0 & 0xFFFFFFFF;
>>>> +	else if  (n >=3D 0x4000 && n <=3D 0x401F)
>>>> +		reg =3D pmceid0 >> 32;
>>>> +	else if (n >=3D 0x20  && n <=3D 0x3F)
>>>> +		reg =3D pmceid1 & 0xFFFFFFFF;
>>>> +	else if (n >=3D 0x4020 && n <=3D 0x403F)
>>>> +		reg =3D pmceid1 >> 32;
>>>> +	else
>>>> +		abort();
>>>> +
>>>> +	supported =3D  reg & (1 << n);
>>>
>>> Don't we need to mask off everything but the lowest 5 bits of "n"? Prob=
ably also using "1U" is better.
>> I added an assert to check n is less or equal than 0x3F
> =

> But "n" will definitely be bigger than that in case of an extended
> event, won't it? So you adjust "reg" accordingly, but miss to do
> something similar to "n"?
ouch yes. Sorry. I Will do what you suggest. Nethertheless this would be
test code error.
> =

>>>
>>>> +	if (!supported && warn)
>>>> +		report_info("event %d is not supported", n);
>>>> +	return supported;
>>>> +}
>>>> +
>>>> +static void test_event_introspection(void)
>>>
>>> "introspection" sounds quite sophisticated. Are you planning to extend =
this? If not, could we maybe rename it to "test_available_events"?
>> Yes this test is a placeholder for looking at the PMU characteristics
>> and we may add some other queries there.
>>>
>>>> +{
>>>> +	bool required_events;
>>>> +
>>>> +	if (!pmu.nb_implemented_counters) {
>>>> +		report_skip("No event counter, skip ...");
>>>> +		return;
>>>> +	}
>>>> +
>>>> +	/* PMUv3 requires an implementation includes some common events */
>>>> +	required_events =3D is_event_supported(0x0, true) /* SW_INCR */ &&
>>>> +			  is_event_supported(0x11, true) /* CPU_CYCLES */ &&
>>>> +			  (is_event_supported(0x8, true) /* INST_RETIRED */ ||
>>>> +			   is_event_supported(0x1B, true) /* INST_PREC */);
>>>> +
>>>> +	if (pmu.version =3D=3D 0x4) {
>>>> +		/* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
>>>> +		required_events =3D required_events ||
>>>> +				  is_event_supported(0x23, true) ||
>>>
>>> Shouldn't those two operators be '&&' instead?
>> yes definitively
>>>
>>>> +				  is_event_supported(0x24, true);
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * L1D_CACHE_REFILL(0x3) and L1D_CACHE(0x4) are only required if
>>>> +	 * L1 data / unified cache. BR_MIS_PRED(0x10), BR_PRED(0x12) are only
>>>> +	 * required if program-flow prediction is implemented.
>>>> +	 */
>>>
>>> Is this a TODO?
>> yes. Added TODO. I do not know how to check whether the conditions are
>> satisfied? Do you have any idea?
> =

> Well, AFAICS KVM doesn't filter PMCEIDn, right? So some basic checks are
> surely fine, but I wouldn't go crazy about checking every possible
> aspect of it. After all you would just check the hardware, as we pass
> this register on.

I agree I can skip those.

Thanks

Eric
> =

> Cheers,
> Andre.
> =

>> Thank you for the review!
>>
>> Eric
>>>
>>> Cheers,
>>> Andre
>>>
>>>
>>>> +
>>>> +	report(required_events, "Check required events are implemented");
>>>> +}
>>>> +
>>>>  #endif
>>>>  =

>>>>  /*
>>>> @@ -326,6 +394,9 @@ int main(int argc, char *argv[])
>>>>  		       "Monotonically increasing cycle count");
>>>>  		report(check_cpi(cpi), "Cycle/instruction ratio");
>>>>  		pmccntr64_test();
>>>> +	} else if (strcmp(argv[1], "event-introspection") =3D=3D 0) {
>>>> +		report_prefix_push(argv[1]);
>>>> +		test_event_introspection();
>>>>  	} else {
>>>>  		report_abort("Unknown sub-test '%s'", argv[1]);
>>>>  	}
>>>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>>>> index 79f0d7a..4433ef3 100644
>>>> --- a/arm/unittests.cfg
>>>> +++ b/arm/unittests.cfg
>>>> @@ -66,6 +66,12 @@ file =3D pmu.flat
>>>>  groups =3D pmu
>>>>  extra_params =3D -append 'cycle-counter 0'
>>>>  =

>>>> +[pmu-event-introspection]
>>>> +file =3D pmu.flat
>>>> +groups =3D pmu
>>>> +arch =3D arm64
>>>> +extra_params =3D -append 'event-introspection'
>>>> +
>>>>  # Test PMU support (TCG) with -icount IPC=3D1
>>>>  #[pmu-tcg-icount-1]
>>>>  #file =3D pmu.flat
>>>
>>
> =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
