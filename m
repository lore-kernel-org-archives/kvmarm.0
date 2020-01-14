Return-Path: <SRS0=/xEG=3D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0450FC33CB3
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jan 2020 10:22:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8630E24670
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jan 2020 10:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="V5ga9UcL";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="V5ga9UcL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8630E24670
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6E6D4B02B;
	Tue, 14 Jan 2020 05:22:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1AnRZLVEcKcF; Tue, 14 Jan 2020 05:22:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3822D4B035;
	Tue, 14 Jan 2020 05:22:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5731F4B018
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jan 2020 05:22:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O+D4qpeuUyjV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jan 2020 05:22:29 -0500 (EST)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2066.outbound.protection.outlook.com [40.107.20.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F9364B002
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jan 2020 05:22:29 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNVtQ06j6pnfKOgq8sEEsJ1ccefIriBHi4CNbo5eOlU=;
 b=V5ga9UcLJ6JLFnnYdKavORUGKktitF9NBAjJo6NjLDCkZsRkqZxq59QDnfUQ4qypIEr4W835UqFmiFTZ0kcONnIn4kBMhRWLsLEQMAIMA8uBnzK/7+YgAVFH9V+3vExrfP8AYDrkgq2Z69dt7TneVOQJZhB8UO7fAXQo28bQ41I=
Received: from VI1PR08CA0140.eurprd08.prod.outlook.com (2603:10a6:800:d5::18)
 by AM6PR08MB2984.eurprd08.prod.outlook.com (2603:10a6:209:4e::28)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10; Tue, 14 Jan
 2020 10:22:27 +0000
Received: from VE1EUR03FT014.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::206) by VI1PR08CA0140.outlook.office365.com
 (2603:10a6:800:d5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend
 Transport; Tue, 14 Jan 2020 10:22:27 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT014.mail.protection.outlook.com (10.152.19.38) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11 via Frontend Transport; Tue, 14 Jan 2020 10:22:26 +0000
Received: ("Tessian outbound 121a58c8f9bf:v40");
 Tue, 14 Jan 2020 10:22:26 +0000
X-CR-MTA-TID: 64aa7808
Received: from cb08708705ad.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 B0BB41E5-17BD-4063-9B4F-739D7E3A4326.1; 
 Tue, 14 Jan 2020 10:22:21 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id cb08708705ad.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 14 Jan 2020 10:22:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKP7kbDjN8MAWWxVlhF35+Lcb5365cJfGTSTaJeYWgXKmAAHh7rv2c0GIudoDKiD0CfV0yCJzrql9VBG3My3ZddHmnBTWYCfz32EeXZFgjsjLFq54NnxwX0IK6PFlp8MN+hwf/YQZnE/3n1DqzumBrBsf+yAfaJneuOpuuQJnTsckX/VOL7P32cH6JCsv39iQmRyp0Iz+52j11EjAqd4y6RuFevAsywoceX8f0anKa/J8jvVcRBUEWzxu+NptzT+UJ8aUDtqL31SR//LCN3H14aTiZXyDJxQJIOnArhEjHciTFHd8Fw45F+xtMASBFrhjDOXZmzQnWuXILANiJfxZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNVtQ06j6pnfKOgq8sEEsJ1ccefIriBHi4CNbo5eOlU=;
 b=QkNBjZ09X5CEakek/gsh/nExpwcCDI5bxDL8u9in27DGy1/PbntK9UU7l9hvb8VtGUSol/mfPmihFo4H9dVuv9ckibyT8m3hBLVBDs1U66pqd8G69dIUdDSg7GhTcjCB7kC9V63LW3OS/Jua5pIrlVbaWVn+zR9wJQnRwbB2g3LkDTsB6JtvNSXqUUFwob9RfrEemFY8GkVwf4jvhJMh14Wd0VdSDk0zWhZo06loNU+4I5KeDahfqMMXytfRO7R2QXYyKfhAnXdI8Fgw/tH13RsI3UaG1//59bIpt7YbbCCXmUgWbw/7XBIvMS8O34T+Uy2fnED1kTV/h0ITR/ro3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNVtQ06j6pnfKOgq8sEEsJ1ccefIriBHi4CNbo5eOlU=;
 b=V5ga9UcLJ6JLFnnYdKavORUGKktitF9NBAjJo6NjLDCkZsRkqZxq59QDnfUQ4qypIEr4W835UqFmiFTZ0kcONnIn4kBMhRWLsLEQMAIMA8uBnzK/7+YgAVFH9V+3vExrfP8AYDrkgq2Z69dt7TneVOQJZhB8UO7fAXQo28bQ41I=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1913.eurprd08.prod.outlook.com (10.168.95.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Tue, 14 Jan 2020 10:22:17 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f%8]) with mapi id 15.20.2623.017; Tue, 14 Jan 2020
 10:22:17 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHVrwu1ZTEnzkrQbEOo/hXDFqaU6affG9SAgALmpVCAADyUAIABmc4AgAAMSACABLWzgIAADjCAgAGBvhA=
Date: Tue, 14 Jan 2020 10:22:16 +0000
Message-ID: <HE1PR0801MB1676171BFAD5581E0A662E21F4340@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-8-jianyong.wu@arm.com>
 <ca162efb3a0de530e119f5237c006515@kernel.org>
 <HE1PR0801MB1676EE12CF0DB7C5BB8CC62DF4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ee801dacbf4143e8d41807d5bfad1409@kernel.org>
 <HE1PR0801MB16765B52E5DCD8EA480EDABFF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <a85deebc23c1fa77e6f70b6eaef22a34@kernel.org>
 <HE1PR0801MB16765F2905CD0F381E33AD9EF4350@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <a65143199c03230c74cb456586f75627@kernel.org>
In-Reply-To: <a65143199c03230c74cb456586f75627@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 58bb778f-1558-48a0-a28d-4ed41455670d.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 76270037-a2f1-4953-24de-08d798dba760
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1913:|HE1PR0801MB1913:|AM6PR08MB2984:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB2984A184B00D6ACD4166FF3CF4340@AM6PR08MB2984.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: True
x-ms-oob-tlc-oobclassifiers: OLM:3173;OLM:3173;
x-forefront-prvs: 028256169F
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(199004)(189003)(66946007)(81166006)(81156014)(478600001)(8676002)(66476007)(66556008)(76116006)(9686003)(26005)(186003)(55016002)(4326008)(2906002)(33656002)(64756008)(6916009)(7416002)(54906003)(71200400001)(52536014)(5660300002)(86362001)(66446008)(7696005)(8936002)(53546011)(55236004)(6506007)(316002);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB1913;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: zHe+omBBJ73VeSnPofRJm42/+7OS26IqM6dQFueeuwBURVFVSvJlzoph0s/KSIIM81zeT6y0EoYpSZb6AoiouS7KoAOMN1LX2pyCf12/JyYGAAjH+tAACiwZ9ws3ZIhtyJkctiqVZDTAuqdSRfd0veUkD1JkDHdFYueADkVtYCeTwH9DXwfg9te+Uw7IJTBMwWQnikOag7G2WOOrLGcVmgMNPM/rdLRe24DypvMA0nl7mxMbx9TTzREy1+nMJ5Kw+vOeY8ZuC98WZCfqXRLtjcYaRNd35R81kj6I9nlTGnSf3PUrHfZj+YoK1GMaAf0k0WL2O4qdi1NVa8T+n8x7j7YuRBJEFRBi/rpphmYxyNmFEcxXzo3h9yXjeCqc5nuJENbrhA9Mn5xK+2aKnYlMeEazKfGhjMal/CLcoElz2KlO9e1J5h6GoqYX01oMrp/f
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1913
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT014.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(376002)(39860400002)(346002)(396003)(136003)(199004)(189003)(5660300002)(356004)(52536014)(2906002)(86362001)(70586007)(8936002)(36906005)(81166006)(81156014)(8676002)(54906003)(316002)(26826003)(7696005)(6862004)(6506007)(53546011)(4326008)(478600001)(26005)(186003)(33656002)(70206006)(336012)(55016002)(9686003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:AM6PR08MB2984;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:Pass; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; A:1; MX:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9e40dab5-809c-4165-5778-08d798dba1ad
X-Forefront-PRVS: 028256169F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2TGhti9vcy9GBTTH/gbn2pjaTKYjjQh03EzqVqUiyZ3gae0HmlDoI0kIsTkAFp0l7y13e9eo9+hvrBSokVAo/nk8dZETPvQ3SvGy3i7Cw/vC6x5w5PIqEOJLdezwOYrn2QPCyceRwAWPoAkTmmSzsYzzO2sDh78KHtYcPn05yYCNdeLUSim5O2L8zQ/XzLTe8lv35MK2WQgbEVIchWMSyYTGPP0z6U9PPXLqIoIrk0G363GuPemGfYwcA9OOl61uR+nW5EL9CwfLk9IQTCc4VKDr6fZ9ZA5sIhJy1Uj3deGpX3Ura3yTIifFiZadG9O/4Ifs+p6TR0jDL0CcqOIdAf7bzhEDEqEfVp5JtSivahVt/Y6tqZtmVEuvmELQkNCcoT+66+QI5W0Sd/duFA42xiESq3YE+QB9HSYF/PEBpETNQJVqoAxUTbfyxpEx4TSz
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2020 10:22:26.8499 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76270037-a2f1-4953-24de-08d798dba760
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB2984
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
> Sent: Monday, January 13, 2020 7:21 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
> 
> On 2020-01-13 10:37, Jianyong Wu wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Friday, January 10, 2020 6:35 PM
> >> To: Jianyong Wu <Jianyong.Wu@arm.com>
> >> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com;
> >> john.stultz@linaro.org; tglx@linutronix.de; pbonzini@redhat.com;
> >> sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark
> >> Rutland <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> >> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>;
> >> linux-kernel@vger.kernel.org; linux-arm- kernel@lists.infradead.org;
> >> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> >> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> >> <Justin.He@arm.com>; nd <nd@arm.com>
> >> Subject: Re: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
> >>
> >> Hi Jianyong,
> >>
> >> On 2020-01-10 10:15, Jianyong Wu wrote:
> >> > Hi Marc,
> >>
> >> [...]
> >>
> >> >> >> > +	ktime_overall = hvc_res.a0 << 32 | hvc_res.a1;
> >> >> >> > +	*ts = ktime_to_timespec64(ktime_overall);
> >> >> >> > +	*cycle = hvc_res.a2 << 32 | hvc_res.a3;
> >> >> >>
> >> >> >> So why isn't that just a read of the virtual counter, given
> >> >> >> that what you do in the hypervisor seems to be "cntpct - cntvoff"?
> >> >> >>
> >> >> >> What am I missing here?
> >> >> >>
> >> >> > We need get clock time and counter cycle at the same time, so we
> >> >> > can't just read virtual counter at guest and must get it from host.
> >> >>
> >> >> See my comment in my reply to patch #6: *Must* seems like a very
> >> >> strong word, and you don't explain *why* that's better than just
> >> >> computing the total hypercall cost. Hint: given the frequency of
> >> >> the counter (in the few MHz
> >> >> range) vs the frequency of a CPU (in the multiple GHz range, and
> >> >> with an IPC close enough to 1), I doubt that you'll see the
> >> >> counter making much progress across a hypercall.
> >> >>
> >> > Sorry, I will avoid to use those strong words.
> >> >
> >> > It's really the case that the hypercall won't across cycle in general.
> >> > But sometimes, kernel preempt
> >> > may happen in the middle of the hypercall which we can't assume how
> >> > long before schedule back. so it's better capture them together at
> >> > the same time.
> >>
> >> Fair enough. Please document the rational, as I guess others will ask
> >> the same questions.
> >>
> > Ok
> >
> >> Then the problem to solve is that of the reference counter, as you so
> >> far assume the virtual counter. I guess you need to be able to let
> >> the guest select the reference counter when calling the PTP service.
> >>
> > I could not come up with an idea about the point where the guest give
> > this info of counter value.
> > Where we give that interface to ptp service, as it's not a user space
> > application.
> 
> Again: why don't you let the guest ask for the counter it wants as part of the
> SMC call? What is preventing this?
> 
Ok, let me try it

Thanks

>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
