Return-Path: <SRS0=EFuC=5T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678E8C2BA17
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 09:38:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FFD520737
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 09:38:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="l1nKasdl";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="lBoO/pF6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FFD520737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=marvell.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC6E94B0EC;
	Fri,  3 Apr 2020 05:38:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@marvell.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@marvell.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KsPjWct7wb7Y; Fri,  3 Apr 2020 05:38:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A78264B0EF;
	Fri,  3 Apr 2020 05:38:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7458F4B108
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 05:36:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lPka1uMn484l for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Apr 2020 05:36:47 -0400 (EDT)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com
 [67.231.156.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D05A4B107
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 05:36:47 -0400 (EDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
 by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
 0339ZdgJ017561; Fri, 3 Apr 2020 02:36:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=cGb2wBmouhCx17lC8Fm43gboLcl8wrnu1Xh2z0Nn1Us=;
 b=l1nKasdlXk3QQiRdnljUEuDr+7qs2TNRwkBmngKxG9iTisHyeuttmkdNAaHb4JSD93TL
 RUMqKkC/zHeFzjEAl2pO660rGKfAS4dV3AZ3bdoxz0Vt7lSws6m5HgJjOMmvbCmGZZeS
 qjr9RRvT/MhaimtmxjysOvfHbpZk5Nl8SHlFiFNtfTd0pdL1klmjWl6bGO9nlwm8GI+Z
 QxlnbCkKUxFyyw8jkubuNQL6o44gaVXklliXKvBeGa6mD4GWN9mVkAewA+AcDTwfPLK5
 olWQ7Nmalp8o+tKKTLtgZZbFYvR4ss+eM6u4yi0Z5alFqJkeWaBOT9alaoI6WyXdj+hG xQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
 by mx0b-0016f401.pphosted.com with ESMTP id 3046h66b02-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
 Fri, 03 Apr 2020 02:36:35 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 02:36:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 3 Apr 2020 02:36:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTuVhLEaKdMmQ8eDdpqO9nYuUpUfug1efkRk6OBhf+BBhkgRUEMWU71VJFKAsmKyJQQIeszwK6ZzEBhvfYHL7wLVLBi6pYigjpPiwtVNGsZDoXdoFTyMPk1uuqQ0Mbz20h/UHgp5JhnCJ2/GITvFaVrHMmM3h+iPLl3w/LBf2Wl/L6G7dtNhy8/s/G4Y4Ff0teZokEN33BbqKcV2uENG4Ega3NRz5eqPlqUWbKnpPJdUB4+dD+bkKELWt6NinLJfyzZaCQnLay88THOsbi+8wceDEgVvZ4x6T2+qd6QWNXF8nfrFN4MG9gmMqJs/wB28RbKpyuwkovJtrA+VfHLTEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGb2wBmouhCx17lC8Fm43gboLcl8wrnu1Xh2z0Nn1Us=;
 b=APbDrB4sUFKfrUxZLCb+n0iu3VWT5dd/TNHCZQk/nLaCEOHLsLhvQ4aL9WZjwx1MT3b6xvZICYpIVzuMJ+6WEDHsQrVUGQ9YSocJogvWlrb8mva55ox/xMtn3UarEW5z3IB9N6eWknZ5mQw1g8zbFaoJDL9uUmv98cZcwEygtS4nvdxGbE8qqvsmu9Pv8isy4xlwQZqODeZCdGS8MLtLs0XMGfZ+domXju1mKFFXEbcMSwkWoGwYvvtU1NnYENWbnyIy3bliCZx0wAMVX6K5pI1XMjgyBBUtcpRDA9PAYlwP1QBJz5II7JZJV9tj+khxDLqvtHizeQhjiurEewc9gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGb2wBmouhCx17lC8Fm43gboLcl8wrnu1Xh2z0Nn1Us=;
 b=lBoO/pF6N8NtsLHDl4v0cj9wwLZvRjFqzoGC8CHYvXIn3NUduPPXN+cT3IW08tKWxeAiY+uQ/7Ta1tX8n4l6Gfq1Oss8uWlpolusVU8+fvyhRLxOzpA5GkgflHY7qa0nH+3Dk+WXliWC1TO8WsKJl15TSV3CjWn2ZAr2AR36HO8=
Received: from MN2PR18MB2686.namprd18.prod.outlook.com (2603:10b6:208:ad::30)
 by MN2PR18MB2477.namprd18.prod.outlook.com (2603:10b6:208:ae::24)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.19; Fri, 3 Apr
 2020 09:36:32 +0000
Received: from MN2PR18MB2686.namprd18.prod.outlook.com
 ([fe80::f9b3:90dc:bbf:4ebc]) by MN2PR18MB2686.namprd18.prod.outlook.com
 ([fe80::f9b3:90dc:bbf:4ebc%3]) with mapi id 15.20.2878.018; Fri, 3 Apr 2020
 09:36:32 +0000
From: George Cherian <gcherian@marvell.com>
To: "maz@kernel.org" <maz@kernel.org>
Subject: Re: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
 Virtualization support
Thread-Topic: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
 Virtualization support
Thread-Index: AdYJlBK1rICkZx4zTsKsIvAk2jZ4Fw==
Date: Fri, 3 Apr 2020 09:36:31 +0000
Message-ID: <MN2PR18MB2686F84659A6A994ECDF8031C5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [49.207.55.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cab9660-af7f-4cd3-4799-08d7d7b27e73
x-ms-traffictypediagnostic: MN2PR18MB2477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB247786A820201E4B93D85BB2C5C70@MN2PR18MB2477.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0362BF9FDB
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MN2PR18MB2686.namprd18.prod.outlook.com; PTR:; CAT:NONE;
 SFTY:;
 SFS:(10009020)(4636009)(39840400004)(396003)(136003)(376002)(346002)(366004)(316002)(54906003)(81156014)(8936002)(8676002)(81166006)(66446008)(64756008)(66556008)(66946007)(76116006)(52536014)(66476007)(53546011)(26005)(186003)(55016002)(7416002)(7696005)(9686003)(107886003)(6506007)(2906002)(5660300002)(4326008)(55236004)(6916009)(33656002)(478600001)(86362001)(71200400001);
 DIR:OUT; SFP:1101; 
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2wf7UwOvguMSo8jsU9dFbm4YXBf6IBefn8/fY1mROqrQQ4PJArb9W6R6eHo32YRxvEx85xxhN6Be89PTBrKGAcgvvT7S/Zbkj7OCU0BBQibJjF+Ff6QUhQqvz4keoj3/SHWwhItuiLxudIK5K3LvGF01uquDAvUOuZF2LhGjEniiOzjHqic0DMvn7reUpdJANUkqTTs5Nc6bVCzci9lMLv5DtAA/A862xXmQj59WCCRy2Funl3hDf/llFW1rCT1x02Shhx0U2FX8vHvRlcfWhakNld1lMOrHzo2a3RagAW2eEeSHx2vlhPt4KPmhDEkQZOE3DyZkfVytKExtUOVPPGu2IFtT8qZYuURGHsZXzCzUtI/EG+4xA2eytZhsdF4bkb0ywGYt5AiO5kiJzAMhDK1o58jIsJwPEkLQrl2LEmqipfkz8pQEtDUi17WADH2g
x-ms-exchange-antispam-messagedata: SOaU/lVQcHjn/6MPu2Xo6xGKbGOR4/bmpLgo0fruJWzNKJTNPtnmvM3KwvLeFnC6IcOHqVZMlXbTNNHuBYrl7neqDxl7fPxMvxNsr1XOg+3S4MgepcUqyWiQA/ivR2LhqS/0q8mAZ0w176eHoASC0Q==
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cab9660-af7f-4cd3-4799-08d7d7b27e73
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2020 09:36:32.1309 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mhuqdYxB8ItfKM12uKTcQ39U+CmRQynjoFotId7w7IQ23lo/N9ZRLGY9+8zR2o60FsRTPzV1Swlknqej8XvB5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2477
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138, 18.0.676
 definitions=2020-04-03_06:2020-04-02,
 2020-04-03 signatures=0
X-Mailman-Approved-At: Fri, 03 Apr 2020 05:38:42 -0400
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Ganapatrao Kulkarni <gkulkarni@marvell.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "andre.przywara@arm.com" <andre.przywara@arm.com>,
 "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Anil Kumar Reddy H <areddy3@marvell.com>
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



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Friday, April 3, 2020 1:32 PM
> To: George Cherian <gcherian@marvell.com>
> Cc: Dave.Martin@arm.com; alexandru.elisei@arm.com;
> andre.przywara@arm.com; christoffer.dall@arm.com;
> james.morse@arm.com; jintack@cs.columbia.edu;
> julien.thierry.kdev@gmail.com; kvm@vger.kernel.org;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org;
> suzuki.poulose@arm.com; Anil Kumar Reddy H <areddy3@marvell.com>;
> Ganapatrao Kulkarni <gkulkarni@marvell.com>
> Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
> Virtualization support
> 
> 
> ----------------------------------------------------------------------
> Hi George,
> 
> On 2020-04-03 08:27, George Cherian wrote:
> > Hi Marc,
> >
> > On 2/11/20 9:48 AM, Marc Zyngier wrote:
> >> This is a major rework of the NV series that I posted over 6 months
> >> ago[1], and a lot has changed since then:
> >>
> >> - Early ARMv8.4-NV support
> >> - ARMv8.4-TTL support in host and guest
> >> - ARMv8.5-GTG support in host and guest
> >> - Lots of comments addressed after the review
> >> - Rebased on v5.6-rc1
> >> - Way too many patches
> >>
> >> In my defence, the whole of the NV code is still smaller that the
> >> 32bit KVM/arm code I'm about to remove, so I feel less bad inflicting
> >> this on everyone! ;-)
> >>
> >> >From a functionality perspective, you can expect a L2 guest to work,
> >> but don't even think of L3, as we only partially emulate the
> >> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug,
> >> PMU, as well as anything that would require a Stage-1 PTW. What we
> >> want to achieve is that with NV disabled, there is no performance
> >> overhead and no regression.
> >>
> >> The series is roughly divided in 5 parts: exception handling, memory
> >> virtualization, interrupts and timers for ARMv8.3, followed by the
> >> ARMv8.4 support. There are of course some dependencies, but you'll
> >> hopefully get the gist of it.
> >>
> >> For the most courageous of you, I've put out a branch[2]. Of course,
> >> you'll need some userspace. Andre maintains a hacked version of
> >> kvmtool[3] that takes a --nested option, allowing the guest to be
> >> started at EL2. You can run the whole stack in the Foundation model.
> >> Don't be in a hurry ;-).
> >>
> > The full series was tested on both Foundation model as well as Marvell
> > ThunderX3
> > Emulation Platform.
> > Basic boot testing done for Guest Hypervisor and Guest Guest.
> >
> > Tested-by:  George Cherian <george.cherian@marvell.com>
> 
> Thanks for having given this a go.
> 
> However, without more details, it is pretty hard to find out what you have
> tested.
> What sort of guest have you booted, with what configuration, what
> workloads did you run in the L2 guests and what are the architectural
> features that TX3 implements?
> 

We have tried the following configurations and tests (GH - Guest Hypervisor GG- Guest Guest).
1 - configuration: Host:8cpus/4GB Mem, GH:4vcpus/3GB, GG: 2vcpus/2GB
Ran hackbench and Large Malloc tests (1GB allocations) across HOST,GH and GG. 

2 - configuration: Host:8cpus/4GB Mem, GH:1vcpu/3GB, GG: 1vcpu/2GB
Ran hackbench and Large Malloc tests across HOST,GH and GG. Host:

We used QEMU for all these testing. 

TX3 implements v8.4 Enhanced Nested Virtualization Support.

> The last point is specially important, as the NV architecture spans two major
> revisions of the architecture and affects tons of other extensions that are
> themselves optional. Without any detail on that front, I have no idea what
> the coverage of your testing is.
> 
> Thanks,
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
