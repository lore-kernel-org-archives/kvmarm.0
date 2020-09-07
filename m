Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011A5C43461
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 08:10:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4EC32208C7
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 08:10:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="AqsqDy/4";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="AqsqDy/4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EC32208C7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91DF74B3C2;
	Mon,  7 Sep 2020 04:10:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qzGvzndqZatT; Mon,  7 Sep 2020 04:10:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F4274B403;
	Mon,  7 Sep 2020 04:10:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DDD54B3D3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 04:10:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i86BEiI8KU09 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 04:10:36 -0400 (EDT)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2078.outbound.protection.outlook.com [40.107.22.78])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74BA34B3C2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 04:10:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbomYQuq98mdC7txqyvr2DAMeVh5dYTdY3ezixIenMI=;
 b=AqsqDy/4r7XI38pqKDkfk4mBEURFY4+WhzgrCrVlCHHasG7BKn7CC1hfjPqwukDF15l9bYJ4pL0sbLkWGQfal5f+zhU7CJn1c2TrmK9lJzKNAfqfZQJaMiJipSjeWPpORyDPOE0lJfTM56VvvBSNwr7WkIk40TSPkXawOSa4oUs=
Received: from AM6P191CA0100.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::41)
 by VI1PR08MB3551.eurprd08.prod.outlook.com (2603:10a6:803:79::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.18; Mon, 7 Sep
 2020 08:10:33 +0000
Received: from VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8a:cafe::e0) by AM6P191CA0100.outlook.office365.com
 (2603:10a6:209:8a::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend
 Transport; Mon, 7 Sep 2020 08:10:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT015.mail.protection.outlook.com (10.152.18.176) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 08:10:32 +0000
Received: ("Tessian outbound a0bffebca527:v64");
 Mon, 07 Sep 2020 08:10:32 +0000
X-CR-MTA-TID: 64aa7808
Received: from af51c5d0360e.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 D6925066-E116-4384-B3C3-B77A11220064.1; 
 Mon, 07 Sep 2020 08:10:27 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id af51c5d0360e.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 07 Sep 2020 08:10:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzbN8fzi44U//3u4TLCL/F2yT+lFFCgtb69Qn0ECUCruKZ3+GSvg6wJgIVNGYN8D6F+E9sktzzVFJe/m45L8f37MuFR+DGZmemMDi1ylWhxHDZ3BB6pto1XSinEdH820wa3zYREUxLNSM+8zCJMpF+ZMtXUnDJ2kpXLF8t4USxsMZWW0ORY1dakiQIUD3EAyLGFTcLbGGHLX1f0kVrTq+R6Ne6ZQl3sikxCdguWIhjHnxYwV6FGgmv2ezMFCEofnH5HnbLii3DkbAb+vmDkWJlcRgQXVIaW0apijoopM+1t2qfFR4mkvnU2g29cpPSZnO2qpYSiYhpSvBQbjO/b2SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbomYQuq98mdC7txqyvr2DAMeVh5dYTdY3ezixIenMI=;
 b=e47jHGeM9fiefV+WsSISBwXwzGOpKHwE+bIpAbVFpm9t04RV1vRnoPN6DJwpMvNNIju9ukd63I8fwJlbcY3tUJIzsJLohn5AXrUrr684q0SZgSpAwR6dzTKLHj/ZDwOR3JfM5aWP7y0Hcs6ld0s7sm5h2aUaDDBlqT7s0XOlFnY8xZtFoBwEzOhEJKff65W5pNiaKEc7P8KwUJzuJZWArpYHj3v85xejV2Dk17T816Fj6AT4pootMHSQBAOJQnMk4HTfISztS3GejQ7at6vPxWbVom/35PeVaGWAKJoDNuTc09+sCs748if5QvjJ2lHhwCq0/ltTe5rdwWc2VMozYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbomYQuq98mdC7txqyvr2DAMeVh5dYTdY3ezixIenMI=;
 b=AqsqDy/4r7XI38pqKDkfk4mBEURFY4+WhzgrCrVlCHHasG7BKn7CC1hfjPqwukDF15l9bYJ4pL0sbLkWGQfal5f+zhU7CJn1c2TrmK9lJzKNAfqfZQJaMiJipSjeWPpORyDPOE0lJfTM56VvvBSNwr7WkIk40TSPkXawOSa4oUs=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2442.eurprd08.prod.outlook.com (2603:10a6:3:e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 08:10:18 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00%5]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 08:10:18 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v14 07/10] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Topic: [PATCH v14 07/10] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Index: AQHWgp30ocMxzsQpy0OAzPdSdzfgH6lYp9iAgAQrilA=
Date: Mon, 7 Sep 2020 08:10:18 +0000
Message-ID: <HE1PR0802MB2555626C7B115C88306B429FF4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
 <20200904092744.167655-8-jianyong.wu@arm.com> <87eenhr01m.wl-maz@kernel.org>
In-Reply-To: <87eenhr01m.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: A2BE30E98BBD6D418036B19794D502EF.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5be5e06a-28f2-4b0d-263c-08d853057e12
x-ms-traffictypediagnostic: HE1PR0802MB2442:|VI1PR08MB3551:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB3551FFEFD99BCA66FE4A690BF4280@VI1PR08MB3551.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: ywRKWk7uiAUkFPO2s5VhtohUKxWh5YdS2DYkYNZmD9NUcDKBluqMKcyZMe7MKpkdn9oojXbxiGnsgHQRJistTsbTj7x+xNlBcEqI9L6wbaL/agBHAVRuvnRUk+0VL/GzP52aYEYiN7PDdNE7uiwkJt9+yiYcaVW3UK9nrKsdZIbIxYa9GV3ZHolXJSILnpCur5AHZ8BkNOtx8OTTn5pQH4NKYe9ptqxDy2/zkNLL0b9BRBlFnJCJCKcUf4MMTBhB1vKRgnKhOVcKkqP5ToiFw2sI0U4tvPAR5CZSPG8x0IWMXzBTAVE+6TNVXGyc2CkWjpCyXqheBr64yp6U1y9Pkg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(7696005)(52536014)(8936002)(4326008)(66946007)(5660300002)(2906002)(71200400001)(54906003)(478600001)(26005)(76116006)(53546011)(86362001)(64756008)(66556008)(186003)(66476007)(9686003)(55016002)(66446008)(8676002)(316002)(6506007)(83380400001)(33656002)(7416002)(6916009);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: qIZKKepTx5jqp7uMdXlJUyn9H6HWwEJWXzpTL0+RnHM+/3kZXMVeFuxK1xEdpOwCXn9JBwXvrWRRNDsJRq2ELxSPgchpwrMuRiGmpTH02qgNtpmPLTf3/iQ777hYuiyk6sETdZ6NbvdEwTsdHzMDulSVVI7fuaXXA7S0C35YfzcIj3KuvJzXRi69dq9Hag6Y48MRcuJ7pgGrd8Cx5x95CYsUVQnyzTUraNdJf3PaElAesANGNGf7ZyfxV8WBkrTer5J5MMXsXiQ9aXi74Gak+8/Do/vXTWoTwmd4Q6zHYzpShNgjAEo1PXgiDT6zTFx7AvRJF8cD5EtfM/vIdJmAioYoZJiPnLadnKmKuxU0DMJ57KuRyFZUEiY3x6VsNEe9CJJYfhIcLFIIw+absu6SXAheynGZAUQIWCcbywpqms6u6+ag1IxG6N2TNlNRbTO40PpNOLUyi7Z/IBz12OqVSoUj6DaU61/QLv2ICFCgAp/ycrbBfxB9D4VY4vC086aaUAvHaC1yuqYHg25WkOWRxa5+D7RRAE5x+Ew3IobEV0I81qjCWWN0qxcb+O1hSt6NwWS5o/bQVU9+bUto3UKSXJbvstXSO88MMIUvZMYCu4t2LnFpMZ4dDziUc/fChvRieV0avMVzy9mHmfKAZWU1Ew==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2442
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: d743de07-a622-4e19-18aa-08d8530575ca
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U18jmSwUUQACeCa+wQROFs9YzqJ0NSF9J7rHmMrwCMEIKBPV+NHdinSu1RTxajpaq2a/mAHOaHIZICC1z0Y7iaEYsypQdXQBPLkNDsynGvbs9ENeFyS3MmEbTxR4fju8phbrlMX9EZykwnMD7x9r1EqLjagDBhTn7GryZ1P5PLA70z5ACoPvRqXnoKGM4vqRDJnZmo2bBWrVBSjqz2uTkrJbDnd3AvdJcqLb/LZkKFqISnkFh492K/hVO+Qk7g3n1M2bGgJvxaTj0Hm1ba8sAqTh9TF8K6LMPOw0mF1Yu86u/W2Zj6WOqS3LLeTZxHsNMzQxXKjYmDu5M6mJcg87CPeNSVN0vAX1EQTk2qnooIWWJkXlLpmsHq2gWeKhEJxDSh2jiXblOigFSulcMxUhVA==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(46966005)(4326008)(33656002)(70586007)(186003)(2906002)(54906003)(9686003)(55016002)(82310400003)(83380400001)(26005)(316002)(36906005)(336012)(5660300002)(52536014)(86362001)(53546011)(6506007)(356005)(478600001)(70206006)(7696005)(81166007)(47076004)(8676002)(6862004)(8936002)(82740400003);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 08:10:32.6436 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be5e06a-28f2-4b0d-263c-08d853057e12
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3551
Cc: Justin He <Justin.He@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Steven Price <Steven.Price@arm.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, nd <nd@arm.com>,
 "will@kernel.org" <will@kernel.org>,
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

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Saturday, September 5, 2020 12:15 AM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v14 07/10] arm64/kvm: Add hypercall service for kvm
> ptp.
> 
> On Fri, 04 Sep 2020 10:27:41 +0100,
> Jianyong Wu <jianyong.wu@arm.com> wrote:
> >
> > ptp_kvm will get this service through smccc call.
> > The service offers wall time and counter cycle of host for guest.
> > caller must explicitly determines which cycle of virtual counter or
> > physical counter to return if it needs counter cycle.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  arch/arm64/kvm/Kconfig       |  6 +++++
> >  arch/arm64/kvm/arch_timer.c  |  2 +-
> >  arch/arm64/kvm/hypercalls.c  | 49
> > ++++++++++++++++++++++++++++++++++++
> >  include/kvm/arm_arch_timer.h |  1 +
> >  include/linux/arm-smccc.h    | 16 ++++++++++++
> >  5 files changed, 73 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig index
> > 318c8f2df245..bbdfacec4813 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -60,6 +60,12 @@ config KVM_ARM_PMU
> >  config KVM_INDIRECT_VECTORS
> >  	def_bool HARDEN_BRANCH_PREDICTOR || RANDOMIZE_BASE
> >
> > +config ARM64_KVM_PTP_HOST
> > +	bool "KVM PTP clock host service for arm64"
> 
> The "for arm64" is not that useful.
Yeah,

> 
> > +	default y
> > +	help
> > +	  virtual kvm ptp clock hypercall service for arm64
> > +
> 
> I'm not keen on making this a compile option, because whatever is not
> always on ends up bit-rotting. Please drop the option.
> 
Ok, I will remove this option next time.

> >  endif # KVM
> >
> >  endif # VIRTUALIZATION
> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> > index 32ba6fbc3814..eb85f6701845 100644
> > --- a/arch/arm64/kvm/arch_timer.c
> > +++ b/arch/arm64/kvm/arch_timer.c
> > @@ -81,7 +81,7 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
> >  	}
> >  }
> >
> > -static u64 timer_get_offset(struct arch_timer_context *ctxt)
> > +u64 timer_get_offset(struct arch_timer_context *ctxt)
> >  {
> >  	struct kvm_vcpu *vcpu = ctxt->vcpu;
> >
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 901c60f119c2..2628ddc13abd 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -3,6 +3,7 @@
> >
> >  #include <linux/arm-smccc.h>
> >  #include <linux/kvm_host.h>
> > +#include <linux/clocksource_ids.h>
> >
> >  #include <asm/kvm_emulate.h>
> >
> > @@ -11,6 +12,10 @@
> >
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
> > +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> > +	struct system_time_snapshot systime_snapshot;
> > +	u64 cycles = -1;
> > +#endif
> 
> Please move all the PTP-related code to its own function, rather than
> keeping it in the main HVC dispatcher. Also assigning a negative value to
> something that is unsigned hurts my eyes. Consider using ~0UL instead.
> See the comment below though.

Ok, much better.

> 
> >  	u32 func_id = smccc_get_function(vcpu);
> >  	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
> >  	u32 feature;
> > @@ -21,6 +26,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  		val[0] = ARM_SMCCC_VERSION_1_1;
> >  		break;
> >  	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > +		/*
> > +		 * Note: keep in mind that feature is u32 and smccc_get_arg1
> > +		 * will return u64, so need auto cast here.
> > +		 */
> >  		feature = smccc_get_arg1(vcpu);
> >  		switch (feature) {
> >  		case ARM_SMCCC_ARCH_WORKAROUND_1:
> > @@ -70,7 +79,47 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  		break;
> >  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> > +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> > +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP); #endif
> >  		break;
> > +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> > +	/*
> > +	 * This serves virtual kvm_ptp.
> > +	 * Four values will be passed back.
> > +	 * reg0 stores high 32-bit host ktime;
> > +	 * reg1 stores low 32-bit host ktime;
> > +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
> > +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
> 
> This comment doesn't match what I read below.
>
Sorry, should have changed according this time. But should keep this next time as
we really need use 32-bits value to support HVC32.
 
> > +	 */
> > +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > +		/*
> > +		 * system time and counter value must captured in the same
> > +		 * time to keep consistency and precision.
> > +		 */
> > +		ktime_get_snapshot(&systime_snapshot);
> > +		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
> > +			break;
> > +		val[0] = systime_snapshot.real;
> > +		/*
> > +		 * which of virtual counter or physical counter being
> > +		 * asked for is decided by the r1 value of smccc
> 
> nit: s/smccc/SMCCC/
Thanks

> 
> > +		 * call. If no invalid r1 value offered, default cycle
> 
> nit: If r1 is an invalid value...
> 
> > +		 * value(-1) will return.
> 
> nit: will be returned.
> 
Yeah.

> > +		 */
> > +		feature = smccc_get_arg1(vcpu);
> > +		switch (feature) {
> > +		case ARM_PTP_VIRT_COUNTER:
> > +			cycles = systime_snapshot.cycles -
> > +				 vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
> 
> nit: On a single line, please.
Ok.
> 
> > +			break;
> > +		case ARM_PTP_PHY_COUNTER:
> > +			cycles = systime_snapshot.cycles;
> > +			break;
> 
> It'd be a lot clearer if you had a default: case here, handling the invalid case.

Ok, much better.

> 
> > +		}
> > +		val[1] = cycles;
> 
> Given that cycles is a 64bit value, how does it work for a 32bit guest? Or have
> you removed support for 32bit guests altogether?
> 
Yeah, I will arm32 support back.

Thanks
Jianyong 
> > +		break;
> > +#endif
> >  	default:
> >  		return kvm_psci_call(vcpu);
> >  	}
> > diff --git a/include/kvm/arm_arch_timer.h
> > b/include/kvm/arm_arch_timer.h index 51c19381108c..5a2b6da9be7a
> 100644
> > --- a/include/kvm/arm_arch_timer.h
> > +++ b/include/kvm/arm_arch_timer.h
> > @@ -105,5 +105,6 @@ void kvm_arm_timer_write_sysreg(struct
> kvm_vcpu
> > *vcpu,
> >  /* Needed for tracing */
> >  u32 timer_get_ctl(struct arch_timer_context *ctxt);
> >  u64 timer_get_cval(struct arch_timer_context *ctxt);
> > +u64 timer_get_offset(struct arch_timer_context *ctxt);
> >
> >  #endif
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index f7b5dd7dbf9f..0724840eb5f7 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -103,6 +103,7 @@
> >
> >  /* KVM "vendor specific" services */
> >  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> > +#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
> >  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> >  #define ARM_SMCCC_KVM_NUM_FUNCS			128
> >
> > @@ -112,6 +113,21 @@
> >  			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> >  			   ARM_SMCCC_KVM_FUNC_FEATURES)
> >
> > +/*
> > + * ptp_kvm is a feature used for time sync between vm and host.
> > + * ptp_kvm module in guest kernel will get service from host using
> > + * this hypercall ID.
> > + */
> > +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID                           \
> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                         \
> > +			   ARM_SMCCC_SMC_32,                            \
> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,                  \
> > +			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
> > +
> > +/* ptp_kvm counter type ID */
> > +#define ARM_PTP_VIRT_COUNTER			0
> > +#define ARM_PTP_PHY_COUNTER			1
> > +
> >  /* Paravirtualised time calls (defined by ARM DEN0057A) */
> >  #define ARM_SMCCC_HV_PV_TIME_FEATURES
> 	\
> >  	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> 	\
> > --
> > 2.17.1
> >
> >
> 
> Thanks,
> 
> 	M.
> 
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
