Return-Path: <SRS0=RzzQ=U2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19135C48BD7
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jun 2019 09:44:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8CD7C2080C
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jun 2019 09:44:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=fujitsu.onmicrosoft.com header.i=@fujitsu.onmicrosoft.com header.b="SXGozLCa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CD7C2080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F9974A4BE;
	Thu, 27 Jun 2019 05:44:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@fujitsu.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vVVryAoqzCV6; Thu, 27 Jun 2019 05:44:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C588D4A507;
	Thu, 27 Jun 2019 05:44:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E51F4A4FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jun 2019 05:42:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CSYCAlL74SNB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jun 2019 05:42:54 -0400 (EDT)
Received: from esa20.fujitsucc.c3s2.iphmx.com (esa20.fujitsucc.c3s2.iphmx.com
 [216.71.158.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 111914A4BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jun 2019 05:42:53 -0400 (EDT)
X-IronPort-AV: E=McAfee;i="6000,8403,9300"; a="4700467"
X-IronPort-AV: E=Sophos;i="5.63,423,1557154800"; 
   d="scan'208";a="4700467"
Received: from mail-os2jpn01lp2051.outbound.protection.outlook.com (HELO
 JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.51])
 by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/AES256-SHA256;
 27 Jun 2019 18:41:46 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector1-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Xau6Txq9jQewfvZAJs10LxHpWFjBeu+ae//TvuxrF4=;
 b=SXGozLCa+Le0qXnwncW6dt7JbMMFXRK1cQztjrhqpDDj86gVTqjrXrNcIVbyfzNHk2SpaHOLEisxOLy5F1cqwnL2OPv3LA/EYL+R/2URf+29ZyJqF80K59EW8EZQcQHsjRlb0S11UiGalPNGRXToP2EGymuUpS3RxwG+AUaDyCY=
Received: from OSAPR01MB4993.jpnprd01.prod.outlook.com (20.179.178.151) by
 OSAPR01MB2179.jpnprd01.prod.outlook.com (52.134.234.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.17; Thu, 27 Jun 2019 09:41:43 +0000
Received: from OSAPR01MB4993.jpnprd01.prod.outlook.com
 ([fe80::59f0:837d:b06f:9dbd]) by OSAPR01MB4993.jpnprd01.prod.outlook.com
 ([fe80::59f0:837d:b06f:9dbd%5]) with mapi id 15.20.2008.017; Thu, 27 Jun 2019
 09:41:43 +0000
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
To: Will Deacon <will@kernel.org>, Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
Thread-Topic: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
Thread-Index: AQHU4ARcPz9tm+J3xUqwKj8A/ooqYqaNvxWAgBVs3wCAAA0vgIAAMV6AgANNMoCAA0uhgIABKgAAgASsFgA=
Date: Thu, 27 Jun 2019 09:41:42 +0000
Message-ID: <c5be6baa-91aa-c178-6698-c83d4d82a217@jp.fujitsu.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <CAJF2gTStSR7Jmu7=HaO5Wxz=Zn8A5-RD8ktori3oKEhM9vozAA@mail.gmail.com>
 <20190621141606.GF18954@arrakis.emea.arm.com>
 <CAJF2gTTVUToRkRtxTmtWDotMGXy5YQCpL1h_2neTBuN3e6oz1w@mail.gmail.com>
 <20190624102209.ngwtosgr5fvp3ler@willie-the-truck>
In-Reply-To: <20190624102209.ngwtosgr5fvp3ler@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qi.fuli@fujitsu.com; 
x-originating-ip: [211.13.147.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e67b46a7-e10b-44ac-f919-08d6fae3a9b3
x-microsoft-antispam: BCL:0; PCL:0;
 RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);
 SRVR:OSAPR01MB2179; 
x-ms-traffictypediagnostic: OSAPR01MB2179:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <OSAPR01MB21797B3EF4119D4D4EB1B736F7FD0@OSAPR01MB2179.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;
 SFS:(10009020)(376002)(346002)(366004)(136003)(39860400002)(396003)(189003)(199004)(31696002)(14444005)(256004)(6306002)(6512007)(53936002)(6436002)(6486002)(5660300002)(76116006)(73956011)(6246003)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(71190400001)(966005)(31686004)(316002)(229853002)(2906002)(54906003)(110136005)(14454004)(76176011)(7736002)(66066001)(99286004)(8936002)(6506007)(68736007)(85182001)(4326008)(25786009)(102836004)(26005)(476003)(53546011)(8676002)(186003)(7416002)(81166006)(81156014)(486006)(11346002)(478600001)(86362001)(6116002)(3846002)(446003)(305945005)(3714002)(777600001);
 DIR:OUT; SFP:1101; SCL:1; SRVR:OSAPR01MB2179;
 H:OSAPR01MB4993.jpnprd01.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; MX:1; A:1; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zVoC3YR9MYzDJEChb14qJgO2JqQHqjnYYNSCYmultvC+waI3cGko/WW5cp8QCdjSeFli69QotZRwIWaPfu/pearC6ydL1lMChYHEU6dP/QPEhN5aIFHuRYbhDnWXR4ADRNlGQB0bJOUrr1+Fl4MNWgUesp8q+1g+BqPtTQRHVKUez7AVeiunKkykAssuLFGA2mbOXBfgkvYMB/MofffS4x5yVDobN+xAYsO7rdomu/HU0tx/ABvq3WnubLzaphZikVxNy75WJaZyxwmgPrtnW1XJqp+IF+nuHWUBkCV1Gnd/ikma4/g2bxR6yiLE+UHcIdg8jXEXrlGm4h2amHtGmId89opcFbTluAGXMn4uziiXswsGahJCJ0Qorw+tgFfTM/K5E9oelMT/2nLyuJIhwzLw2NAOWzGN1Nxcv4cc1UM=
Content-ID: <FD4886E71D71804996690C96B064C95D@jpnprd01.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e67b46a7-e10b-44ac-f919-08d6fae3a9b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 09:41:43.0328 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qi.fuli@jp.fujitsu.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2179
X-Mailman-Approved-At: Thu, 27 Jun 2019 05:44:44 -0400
Cc: Julien Grall <julien.grall@arm.com>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
 "hch@infradead.org" <hch@infradead.org>, Atish Patra <Atish.Patra@wdc.com>,
 Anup Patel <anup.Patel@wdc.com>, "gary@garyguo.net" <gary@garyguo.net>,
 Palmer Dabbelt <palmer@sifive.com>,
 "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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


On 6/24/19 7:22 PM, Will Deacon wrote:
> On Mon, Jun 24, 2019 at 12:35:35AM +0800, Guo Ren wrote:
>> On Fri, Jun 21, 2019 at 10:16 PM Catalin Marinas
>> <catalin.marinas@arm.com> wrote:
>>> On Wed, Jun 19, 2019 at 07:51:03PM +0800, Guo Ren wrote:
>>>> On Wed, Jun 19, 2019 at 4:54 PM Julien Grall <julien.grall@arm.com> wrote:
>>>>> On 6/19/19 9:07 AM, Guo Ren wrote:
>>>>>> Move arm asid allocator code in a generic one is a agood idea, I've
>>>>>> made a patchset for C-SKY and test is on processing, See:
>>>>>> https://lore.kernel.org/linux-csky/1560930553-26502-1-git-send-email-guoren@kernel.org/
>>>>>>
>>>>>> If you plan to seperate it into generic one, I could co-work with you.
>>>>> Was the ASID allocator work out of box on C-Sky?
>>>> Almost done, but one question:
>>>> arm64 remove the code in switch_mm:
>>>>    cpumask_clear_cpu(cpu, mm_cpumask(prev));
>>>>    cpumask_set_cpu(cpu, mm_cpumask(next));
>>>>
>>>> Why? Although arm64 cache operations could affect all harts with CTC
>>>> method of interconnect, I think we should keep these code for
>>>> primitive integrity in linux. Because cpu_bitmap is in mm_struct
>>>> instead of mm->context.
>>> We didn't have a use for this in the arm64 code, so no point in
>>> maintaining the mm_cpumask. On some arm32 systems (ARMv6) with no
>>> hardware broadcast of some TLB/cache operations, we use it to track
>>> where the task has run to issue IPI for TLB invalidation or some
>>> deferred I-cache invalidation.
>> The operation of set/clear mm_cpumask was removed in arm64 compared to
>> arm32. It seems no side effect on current arm64 system, but from
>> software meaning it's wrong.
>> I think we should keep mm_cpumask just like arm32.
> It was a while ago now, but I remember the atomic update of the mm_cpumask
> being quite expensive when I was profiling this stuff, so I removed it
> because we don't need it for arm64 (at least, it doesn't allow us to
> optimise our shootdowns in practice).

Hi Will,

I think mm_cpumask can be used for filtering the cpus that there are TBL 
entries on.
The OS jitter can be reduced by invalidating TLB entries only on the 
CPUs specified by mm_cpumask(mm).
As I mentioned in an earlier email, the 2.5% OS jitter can result in 
over a factor of 20 slowdown for the same application [1].
Though it may be an extreme example, reducing the OS jitter has been an 
issue in HPC environment.
I would like to avoid broadcast TLBI by using mm_cpumask on arm64, cloud 
you please tell me more about the costs caused by updating mm_cpumask?

Here is my patch:
https://lkml.org/lkml/2019/6/17/703

[1] Ferreira, Kurt B., Patrick Bridges, and Ron Brightwell. 
"Characterizing application sensitivity to OS interference using 
kernel-level noise injection." Proceedings of the 2008 ACM/IEEE 
conference on Supercomputing. IEEE Press, 2008.

Thanks,
QI Fuli

> I still think this is over-engineered for what you want on c-sky and making
> this code generic is a mistake.
>
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
