Return-Path: <SRS0=Qg2m=27=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA63DC33CA4
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 09:51:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52E0F2072E
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 09:51:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="8FQ7PeEm";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="8FQ7PeEm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52E0F2072E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A35FE4B179;
	Fri, 10 Jan 2020 04:51:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p8skeo0gp+Wj; Fri, 10 Jan 2020 04:51:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1981E4B19B;
	Fri, 10 Jan 2020 04:51:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE6FD4B14E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 04:51:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uWJs9OoBNSl3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jan 2020 04:51:14 -0500 (EST)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-eopbgr80044.outbound.protection.outlook.com [40.107.8.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55B964B121
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 04:51:14 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpOxh8Ck9WWCfMNgHMOLPoOZgn4b+fCTsO88KvX3vfQ=;
 b=8FQ7PeEm7yBB4SBI4hGg24Yd+x5kvAHSrcrlWSQU6JpLUb4n3wAtxPMJ1j5aYS/n9wXjq3cNeJ0irPy88A9ju19x5821y6eWkhwsNwGMLlWK365a5/Ghs8xoMkLynugC2V4LJYqdfilrN7jcYT8HniPhIJ7ox/OqUZO3AJwevTY=
Received: from HE1PR08CA0062.eurprd08.prod.outlook.com (2603:10a6:7:2a::33) by
 DB6PR0801MB2006.eurprd08.prod.outlook.com (2603:10a6:4:79::13) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 10 Jan 2020 09:51:11 +0000
Received: from AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::209) by HE1PR08CA0062.outlook.office365.com
 (2603:10a6:7:2a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend
 Transport; Fri, 10 Jan 2020 09:51:11 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT031.mail.protection.outlook.com (10.152.16.111) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11 via Frontend Transport; Fri, 10 Jan 2020 09:51:10 +0000
Received: ("Tessian outbound 28955e0c1ca8:v40");
 Fri, 10 Jan 2020 09:51:10 +0000
X-CR-MTA-TID: 64aa7808
Received: from ef822ac32c86.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 7423F90E-C564-4349-B2A7-0CD8414F21D6.1; 
 Fri, 10 Jan 2020 09:51:05 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ef822ac32c86.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 10 Jan 2020 09:51:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqaNw3gGyUGsLAV6nwkgaY6w+Hs7SxgkC2FKckmAh/+K7fgOuVhfZo9rcXxH9Aj33kUEQByuFbKOIAzlHP2t4Xutyxqg5tiRj7gSBQrzUtwoHVB57cUmoNGZlpRFgq2XaeNrIXuh34LNe5JBEPVz49N6hkteivifsR0c7Z1Q/mGeqc5VpBNjNv0RqJhjn1hXZcozQN5eb2q3Otpc404B2yZfu6aZaZlmjGYxKFQLrdyo3jwq0HNzyckrAr43QnkIxZn4tSJMmIrm1mpO/n1KnpqD0c5UYVYji9sM6Kgx5ztOw6dlNQ9gqkiGQ61/TbL5iD/k6mnYwgvgPkq8c8IUNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpOxh8Ck9WWCfMNgHMOLPoOZgn4b+fCTsO88KvX3vfQ=;
 b=mx0BWR002S7DA9ed95LDbyEvWtxVXY8PCAyiGE3rNNHPXwMvUC9MmRF34pQyzjsTOUVlH0EUtQrxA4YsedUOdejrfTXbOXnHWmuDcpcjACFztXFryZT0UmlLUrOPEmvHb23fZiknldSQ36+bbO+tUFmt/S3/cqm6dAM0s4fVDhoNELxs7WxfYCQ7s9nffGWA/4BzRPfF6Pq8weaefAZFjBpv1hmQ9Syc7+qX9hSW5MYxa+HTrb4ShZnR0S3Q4DTJMPUuz/xywdKp2aDmPqT3nZP7xPdUfEAu2osyovTEiK1memsBRUIA2jsagNEaV91JZw36rp9WZjzJ/x0Omqy4Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpOxh8Ck9WWCfMNgHMOLPoOZgn4b+fCTsO88KvX3vfQ=;
 b=8FQ7PeEm7yBB4SBI4hGg24Yd+x5kvAHSrcrlWSQU6JpLUb4n3wAtxPMJ1j5aYS/n9wXjq3cNeJ0irPy88A9ju19x5821y6eWkhwsNwGMLlWK365a5/Ghs8xoMkLynugC2V4LJYqdfilrN7jcYT8HniPhIJ7ox/OqUZO3AJwevTY=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1978.eurprd08.prod.outlook.com (10.168.96.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Fri, 10 Jan 2020 09:51:01 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f%8]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 09:51:01 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [RFC PATCH v9 6/8] psci: Add hvc call service for ptp_kvm.
Thread-Topic: [RFC PATCH v9 6/8] psci: Add hvc call service for ptp_kvm.
Thread-Index: AQHVrwuxR+1ZEaCriEa+CGCL3lP4K6ffGBkAgALhg9CAAEMegIABkMMA
Date: Fri, 10 Jan 2020 09:51:01 +0000
Message-ID: <HE1PR0801MB16765B507D9B5A1A7827078BF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-7-jianyong.wu@arm.com>
 <7383dc06897bba253f174cd21a19b5c0@kernel.org>
 <HE1PR0801MB1676AB738138AB24E2158AD4F4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <099a26ffef5d554b88a5e33d7f2a6e3a@kernel.org>
In-Reply-To: <099a26ffef5d554b88a5e33d7f2a6e3a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 7d87b698-0ad5-49aa-adcb-f8ae0f578508.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e8a0821a-29c0-4643-81e1-08d795b29f34
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1978:|HE1PR0801MB1978:|DB6PR0801MB2006:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0801MB200631E0CFDCD625E7886A03F4380@DB6PR0801MB2006.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: True
x-ms-oob-tlc-oobclassifiers: OLM:1850;OLM:1850;
x-forefront-prvs: 02788FF38E
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(13464003)(199004)(189003)(7696005)(53546011)(55016002)(86362001)(6506007)(7416002)(6916009)(52536014)(9686003)(316002)(71200400001)(55236004)(8936002)(66446008)(966005)(4001150100001)(33656002)(81156014)(76116006)(54906003)(66556008)(186003)(2906002)(4326008)(26005)(81166006)(66946007)(64756008)(8676002)(5660300002)(478600001)(66476007);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB1978;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: oRkGsVNMjxE5Gdp7ZfbaWvlBB14kjc0n/fYhBVzWLvJ0Mfm1F9QVPgMmS026Hzu6tpeyo+v7lOFdl9QhTU3pc46wLRgYv2SahhF2+1nhyQDG/pS/s8Pv+uuIls2gd5LPVm7u7RDpncWbNkmhSQcd5WgUykRiGS8WAILuQdbfugnVQrIM9TX0k2rRpOHB1Zuclx3sn76b5WB7mNPmRXNGz4Kj6JmK51g6kqbZdXxDNlWVaXimUHx6eTVqT/AgaSGSSYP5PP7FbQQ4xMKn422f6+b6uXiOY9p2ZSH8OVti4R6EQtkFqxXT4f0HThpc2lttLf5TqP1NYsEZFilenMSLhSCEm4oLkIYzokoAB1X1yQNOWbgk7n8A9L7xHb9xACa346iaIscRPykkQFCb8NPl0OAqrSFNrOwj7FGfCnFHkS2d66K66XNklosr8ZIopXJHdaG76/EJutpZgppODt+qStriVpOGEEeFkdsSv5wlQssYOqeSB2MoCKhy+0cLOHzvs4M8czfV8jdZsptk83spcPPqBfbuBkthViDF7x4Mx3s=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1978
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(376002)(13464003)(199004)(189003)(26005)(33656002)(186003)(4326008)(8676002)(81166006)(356004)(81156014)(4001150100001)(966005)(55016002)(36906005)(316002)(26826003)(478600001)(86362001)(7696005)(54906003)(9686003)(2906002)(336012)(52536014)(5660300002)(70586007)(8936002)(70206006)(53546011)(6862004)(6506007);
 DIR:OUT; SFP:1101; SCL:1; SRVR:DB6PR0801MB2006;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:Pass; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; A:1; MX:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: c104dbeb-b2ac-474d-5662-08d795b299d0
X-Forefront-PRVS: 02788FF38E
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tr9lP2b0ndIUF2foFsK7VeUn5Gt9XvO/A7pWb0tCdw9hIXbNatd/xMvs9RM+9ErLnk/fHMc7YRBZBeKhZy7WulKh1R9/5jEzwKOm6OcF5sg7l790x+rjt+Dqq77npkPy1R87If6bJurEbAPN/HQC2ZI2fo18e1S8ZUgQzN9hMB2nBWKWi8oFd+xEIjL3EwkViU842EF5jMz9/40uucK2wZqQaxQhw71ReEhijGfctyNWZXSAJGreemHzwszeOHfdrDUsb1xA2RtgYLXVAItteITZJ1RZBIggk9LTxVfmcw+F8ypGoFtmEeusL/UKku+EvCKc3xHbvjmvIdnIITNCOrzWmpXiFEE+TVQTDRsWkcuM78CvrXVMLUz+nkY8KccbJ3Mvra7HrmgpC/kL20FOVH65x/n2pJqXDOuHjd5xIdvkSP/pRSNCj+L4ITkYEFw7+rogxruTMZydVapksnb8fhvdOOjjme2D6/AQWUdgyxiRSu/cPPR4REZvGi56de1cxGULCl1EXG4911NdmqIn5YqOTh1DBmoLIrKDfqhc7Ps=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2020 09:51:10.3269 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a0821a-29c0-4643-81e1-08d795b29f34
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB2006
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
> Sent: Thursday, January 9, 2020 5:16 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v9 6/8] psci: Add hvc call service for ptp_kvm.
> 
> On 2020-01-09 05:45, Jianyong Wu wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Tuesday, January 7, 2020 5:16 PM
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
> >> Subject: Re: [RFC PATCH v9 6/8] psci: Add hvc call service for
> >> ptp_kvm.
> >>
> >> On 2019-12-10 03:40, Jianyong Wu wrote:
> >> > ptp_kvm modules will call hvc to get this service.
> >> > The service offers real time and counter cycle of host for guest.
> >> >
> >> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> >> > ---
> >> >  include/linux/arm-smccc.h | 12 ++++++++++++
> >> >  virt/kvm/arm/psci.c       | 22 ++++++++++++++++++++++
> >> >  2 files changed, 34 insertions(+)
> >> >
> >> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> >> > index 6f82c87308ed..aafb6bac167d 100644
> >> > --- a/include/linux/arm-smccc.h
> >> > +++ b/include/linux/arm-smccc.h
> >> > @@ -94,6 +94,7 @@
> >> >
> >> >  /* KVM "vendor specific" services */
> >> >  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> >> > +#define ARM_SMCCC_KVM_PTP			1
> >> >  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> >> >  #define ARM_SMCCC_KVM_NUM_FUNCS			128
> >> >
> >> > @@ -103,6 +104,17 @@
> >> >  			   ARM_SMCCC_OWNER_VENDOR_HYP,
> >> 		\
> >> >  			   ARM_SMCCC_KVM_FUNC_FEATURES)
> >> >
> >> > +/*
> >> > + * This ID used for virtual ptp kvm clock and it will pass second
> >> > value
> >> > + * and nanosecond value of host real time and system counter by
> >> > +vcpu
> >> > + * register to guest.
> >> > + */
> >> > +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
> >> 		\
> >> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> >> 		\
> >> > +			   ARM_SMCCC_SMC_32,
> >> 	\
> >> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> >> 		\
> >> > +			   ARM_SMCCC_KVM_PTP)
> >> > +
> >>
> >> All of this depends on patches that have never need posted to any ML,
> >> and just linger in Will's tree. You need to pick them up and post
> >> them as part of this series so that they can at least be reviewed.
> >>
> > Ok, I will add them next version.
> >
> >> >  #ifndef __ASSEMBLY__
> >> >
> >> >  #include <linux/linkage.h>
> >> > diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c index
> >> > 0debf49bf259..682d892d6717 100644
> >> > --- a/virt/kvm/arm/psci.c
> >> > +++ b/virt/kvm/arm/psci.c
> >> > @@ -9,6 +9,7 @@
> >> >  #include <linux/kvm_host.h>
> >> >  #include <linux/uaccess.h>
> >> >  #include <linux/wait.h>
> >> > +#include <linux/clocksource_ids.h>
> >> >
> >> >  #include <asm/cputype.h>
> >> >  #include <asm/kvm_emulate.h>
> >> > @@ -389,6 +390,8 @@ static int kvm_psci_call(struct kvm_vcpu *vcpu)
> >> >
> >> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
> >> > +	struct system_time_snapshot systime_snapshot;
> >> > +	u64 cycles;
> >> >  	u32 func_id = smccc_get_function(vcpu);
> >> >  	u32 val[4] = {};
> >> >  	u32 option;
> >> > @@ -431,6 +434,25 @@ int kvm_hvc_call_handler(struct kvm_vcpu
> *vcpu)
> >> >  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >> >  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> >> >  		break;
> >> > +	/*
> >> > +	 * This will used for virtual ptp kvm clock. three
> >> > +	 * values will be passed back.
> >> > +	 * reg0 stores high 32-bit host ktime;
> >> > +	 * reg1 stores low 32-bit host ktime;
> >> > +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
> >> > +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
> >>
> >> That's either two or four values, and not three as you claim above.
> >>
> > Sorry, I'm not sure what do you mean "three", the registers here is 4
> > from reg0 to reg3.
> 
> Please read the comment you have written above...

oh, I see it.

> 
> >> Also, I fail to understand the meaning of the host cycle vs cntvoff
> >> comparison.
> >> This is something that guest can perform on its own (it has access to
> >> both physical and virtual timers, and can compute cntvoff without
> >> intervention of the hypervisor).
> >>
> > To keep consistency and precision, clock time and counter cycle must
> > captured at the same time. It will perform at ktime_get_snapshot.
> 
> Fair enough. It would vertainly help if you documented it. It would also help if
> you explained why it is so much worse to read the counter in the guest
> before *and* after the call, and assume that the clock time read happened
> right in the middle?
> 
ok, I will give explain in comments.

> That aside, what you are returning is something that *looks* like the virtual
> counter. What if the guest is using the physical counter, which is likely to be
> the case with nested virt? Do you expect the guest to always use the virtual
> counter? This isn't going to fly.

To be honest, I have little knowledge of nested virtualization for arm and I'm confused with that
guest'guest will use physical counter.

IMO, ptp_kvm will call hvc to trap to its hypervisor adjacent to it. So guest'guest will trap to hypervisor in guest and will
get guest's counter cycle then calculate guest'guest's counter cycle by something like offset to sync time with it. So only if the
guest's hypervisor can calculate the guest'guest's counter value, can ptp_kvm works.

the implementation of calculating the return value of counter cycle vary with the way deriving counter cycle from hypervisor to guest.

If considering nested virt here, we need the basic knowledge of how guest'guest's counter cycle is calculated from its hypervisor and how to determine 
we are in guest's hypervisor or guest'guest's hypervisor.
If it is the case, can you give me some knowledge, something like a document, about that?

> 
> >> Finally, how does it work with nested virt, where cntvoff is for the
> >> the vEL2 guest?
> >>
> > For now, I have not considered ptp_kvm in nested virtualization. Also
> > I'm not sure about if nested virtualization is ready on arm64 , as I
> > need test ptp_kvm on it. If so, I can consider it.
> 
> It is not about testing. It is about taking the architecture into account.
> And ready or not doesn't come into play here. What you're defining here is
> an ABI, and it better be totally future proof.
> 
Yeah, should included it in design.

> But if you want to test, help yourself to [1] and have fun!
> >
Thanks

> >> > +	 */
> >> > +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> >> > +		ktime_get_snapshot(&systime_snapshot);
> >> > +		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
> >> > +			return kvm_psci_call(vcpu);
> >>
> >> What does this mean? Calling PSCI because you've failed to identify
> >> the clock source? What result do you expect from this? Hint: this
> >> isn't a PSCI call.
> >>
> > Sorry, what I want to do here is that return to guest with the error
> > info.
> > Maybe I should set val[0] to -1 and break to let the guest know that
> > error comes, as the guest will check if val[0] is positive to
> > determine the next step.
> 
> What you should do is handle it like a normal SMCCC failure.
> 
Yeah, I will fix it.

Thanks
Jianyong 

>          M.
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-
> platforms.git/log/?h=kvm-arm64/nv-5.5-rc4-WIP
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
