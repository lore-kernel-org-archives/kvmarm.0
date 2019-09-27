Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A660C352AB
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 10:43:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01099217D9
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 10:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="WkjJKGtp";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="WkjJKGtp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01099217D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 823FB4A748;
	Fri, 27 Sep 2019 06:43:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cwSOJw8DY0Tu; Fri, 27 Sep 2019 06:43:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDBB44A745;
	Fri, 27 Sep 2019 06:43:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FF334A728
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 06:14:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1CSbAW8gfHGY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 06:14:49 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70045.outbound.protection.outlook.com [40.107.7.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 858D24A71E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 06:14:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ae2gF2Swg9uwp0X/Fea/eKeMEPpP3YEBWTiwK95iYjc=;
 b=WkjJKGtpXmRLuMMtdysdV/T9BGEOcuxILw8dJgc4g5BrqjT4b8WzBkMd8lbjcxz497rg3CTo+WlLs0Erovv5t+KTyMDcVYxYfBWKl4PE6xh10fZtao5VomzOxmKkB3fobkxTy7EpPEeiM33rbKcn41Q3Q4UVuIP6zl3RfSLq8+4=
Received: from VI1PR08CA0165.eurprd08.prod.outlook.com (2603:10a6:800:d1::19)
 by AM6PR08MB5254.eurprd08.prod.outlook.com (2603:10a6:20b:d6::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.23; Fri, 27 Sep
 2019 10:14:45 +0000
Received: from DB5EUR03FT021.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::205) by VI1PR08CA0165.outlook.office365.com
 (2603:10a6:800:d1::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2305.17 via Frontend
 Transport; Fri, 27 Sep 2019 10:14:44 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT021.mail.protection.outlook.com (10.152.20.238) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15 via Frontend Transport; Fri, 27 Sep 2019 10:14:43 +0000
Received: ("Tessian outbound 3fba803f6da3:v33");
 Fri, 27 Sep 2019 10:14:30 +0000
X-CR-MTA-TID: 64aa7808
Received: from 335722af9282.4 (ip-172-16-0-2.eu-west-1.compute.internal
 [104.47.14.59]) by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 942D3DAB-609D-4273-9071-B272EDB697AB.1; 
 Fri, 27 Sep 2019 10:14:25 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 335722af9282.4
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
 Fri, 27 Sep 2019 10:14:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBQnLgUc+e6tol24I/TqgNVa4e4/LDRIIZLAUtUtbbnTd5c+LOJ5f0Wafxc6yzzUzVPBoMUgK12mrhdB4xS0N4YoAjElYLOz8kKYUVk43cvgZYd4CAJ4WBxBMmK91P1asSeE7o2xv86kFQ32mERrwmLJNJg8jiRqLURfxBvQ4bf0WDL6d0hjbEGtzBnvsGoax96DR+w4di3PnKlsXMQjweoMOunLYO2Gbz4zLVv1c+6R8Wq+b6YOGay0l1Pz+ViYcOPAY3YKYWTpYD3sFhnWshblvbCQ5R9Ccd+2iptODeDtt5aDDOzIBvzVxdQGc4kQ4qnXQec/jj1ozu0xD9Qw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ae2gF2Swg9uwp0X/Fea/eKeMEPpP3YEBWTiwK95iYjc=;
 b=YU+SsWHmxl3oUAKiSJgQr5F0xpHJjR0mP9u2o0jGAssKnpChWCBIN0sMtLIbDwaU9fACg3N7XNXl+KM7sbscfshxyzjOTeVEDuuIPpe1sIWvRr2Z+ltYTtPgDoDnsTJKyqknIJw3VCTIWHdeqOCANh1bYGlZxUqrarklOoSZtdFbkmECLMNxJQu5mzI3WX7g2aoEXEZWN18puDOlI2XJdIkRp1laBxjKVvXGqThNrv3u6zrtuYyfMDzHmKpM4ntOkaH5yumRY1mwaS9wpefEb3kqAo74s4cx5m+9tu/Be7XqjWtzkyN3R+ieCoFjiGrXWgkRI9Ihlu62GE1xhjLodg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ae2gF2Swg9uwp0X/Fea/eKeMEPpP3YEBWTiwK95iYjc=;
 b=WkjJKGtpXmRLuMMtdysdV/T9BGEOcuxILw8dJgc4g5BrqjT4b8WzBkMd8lbjcxz497rg3CTo+WlLs0Erovv5t+KTyMDcVYxYfBWKl4PE6xh10fZtao5VomzOxmKkB3fobkxTy7EpPEeiM33rbKcn41Q3Q4UVuIP6zl3RfSLq8+4=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1627.eurprd08.prod.outlook.com (10.168.146.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Fri, 27 Sep 2019 10:14:20 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd%3]) with mapi id 15.20.2284.028; Fri, 27 Sep 2019
 10:14:20 +0000
From: "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To: Suzuki Poulose <Suzuki.Poulose@arm.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "maz@kernel.org" <maz@kernel.org>, "richardcochran@gmail.com"
 <richardcochran@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>, Will Deacon
 <Will.Deacon@arm.com>
Subject: RE: [RFC PATCH v4 2/5] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Topic: [RFC PATCH v4 2/5] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Index: AQHVdF+Ft3UnKFEitUOtlQstSNDglqc97ZgAgAFgLECAAAGAgIAAAEGA
Date: Fri, 27 Sep 2019 10:14:20 +0000
Message-ID: <HE1PR0801MB1676139461D06C2E421FA7BAF4810@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190926114212.5322-1-jianyong.wu@arm.com>
 <20190926114212.5322-3-jianyong.wu@arm.com>
 <2f338b57-b0b2-e439-6089-72e5f5e4f017@arm.com>
 <HE1PR0801MB167630F7B983A7F9DBB473DFF4810@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <4337dcf0-bd60-4db8-6c9f-cd718b89d2a4@arm.com>
In-Reply-To: <4337dcf0-bd60-4db8-6c9f-cd718b89d2a4@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: cf23ba1a-bbd7-4b56-9a4d-63540697cb1e.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: b4e17a8f-62e2-4594-62c1-08d74333842c
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1627:|HE1PR0801MB1627:|AM6PR08MB5254:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB52543E8B2AA238E5C8DDC56AF4810@AM6PR08MB5254.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:7691;
x-forefront-prvs: 0173C6D4D5
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(13464003)(189003)(199004)(71190400001)(6246003)(55236004)(6436002)(71200400001)(53546011)(102836004)(26005)(7416002)(186003)(6506007)(81166006)(81156014)(2501003)(52536014)(5660300002)(8936002)(8676002)(74316002)(66476007)(6636002)(66946007)(64756008)(66556008)(229853002)(476003)(11346002)(305945005)(76116006)(76176011)(54906003)(110136005)(478600001)(316002)(14444005)(256004)(14454004)(7736002)(66446008)(486006)(25786009)(66066001)(86362001)(99286004)(6116002)(2906002)(33656002)(3846002)(446003)(4326008)(55016002)(7696005)(2201001)(9686003)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB1627;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; MX:1; A:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 3rtQeFkR11YtJNa7B8rr2pVOz1j1KNiPoMmWTcnoopAGKt5FPU5Skq3UtG322E5jABVXaHVqx1+dCoHUyxOA3CCnQu0r9RLrT2fx0OC3+ZCdpec4NF+DkGPVzLL3N36H7mbBC/mMCDCM9rMG2E0jtjKUKxTEqMoJh8jj/6SRicyVItbP1SCu5lr/6M9Vn375sKswLhVOBH2dG3O1gaQylddrctiVuUGRIzMMBwktNunEHlg7bMWoPsTi58F7Mbwa3vzvfVyWPkyXk0BZH/VdOm9uoddB+450xDCwLQzttQX2scDzsnwvtuaWWZOTsO1DuVexj2LIv8zSvFL+nPC7KFVeBjKN2cOSFyAItAq41/qP/qNWJ6bUKAra18wDeU3stqIVBYmmr5Lxq1Yc206rBOQhZ5j4gfcx9vDaWrF50B0=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1627
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT021.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(376002)(39860400002)(136003)(346002)(396003)(13464003)(189003)(199004)(76130400001)(53546011)(102836004)(356004)(81166006)(6506007)(99286004)(22756006)(2486003)(7696005)(6116002)(76176011)(33656002)(50466002)(2201001)(66066001)(74316002)(47776003)(316002)(305945005)(23676004)(2501003)(7736002)(3846002)(2906002)(6636002)(63350400001)(478600001)(14454004)(436003)(446003)(8936002)(336012)(86362001)(110136005)(486006)(126002)(11346002)(52536014)(25786009)(476003)(9686003)(4326008)(55016002)(54906003)(5660300002)(6246003)(70206006)(229853002)(8676002)(70586007)(186003)(26005)(26826003)(14444005)(81156014)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:AM6PR08MB5254;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:TempError; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; MX:1; A:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 872ef3cd-1b83-4a22-c404-08d743337660
X-Microsoft-Antispam: BCL:0; PCL:0;
 RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);
 SRVR:AM6PR08MB5254; 
NoDisclaimer: True
X-Forefront-PRVS: 0173C6D4D5
X-Microsoft-Antispam-Message-Info: Fj8Zc0tPhwuFCXyfYFHao5oxjHuL60iJDJpwaGiVgJswi9VpoSakhjt6Q6wulkuXFMbzgOUMJprZYoV4s/qcx9LZyiOE4cTtueQDNHMEhWDegOfpcHkg3fPq4ewsXF6vpUOnFA5E3c7H4NnAG1/bgMdXnUVb7ePtVtzX5RPhRnddq7fQQHhIN55P/SLlGIRIg3jQRXgE/9i6zzD9AHGAw/1PrhlbRlS9yHlZiypdz09HTzmYWRx4DLQIdXEmsUYpt1Mnip2sojQNsPW9MXdda0J4QD3NmERkM02o3NWAghEMeHT+QF3QN1yf0RQgJ1h8LvejYlR+VsE4A/MXxnD4Hce8IQgLQfIIhEVSjbFypTIN0QTWIe/XzN3HmEJb8AOOU6/BhLznPpg388IKutVn6wWv3rAr1R3ODH87YXN1bdI=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2019 10:14:43.5618 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e17a8f-62e2-4594-62c1-08d74333842c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5254
X-Mailman-Approved-At: Fri, 27 Sep 2019 06:43:42 -0400
Cc: "Justin He \(Arm Technology China\)" <Justin.He@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd <nd@arm.com>,
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

Hi Suzuki,

> -----Original Message-----
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> Sent: Friday, September 27, 2019 6:12 PM
> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>;
> netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; Will Deacon <Will.Deacon@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v4 2/5] ptp: Reorganize ptp_kvm modules to make it
> arch-independent.
> 
> 
> 
> On 27/09/2019 11:10, Jianyong Wu (Arm Technology China) wrote:
> > Hi Suzuki,
> >
> >> -----Original Message-----
> >> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> >> Sent: Thursday, September 26, 2019 9:06 PM
> >> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>;
> >> netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> >> tglx@linutronix.de; pbonzini@redhat.com;
> >> sean.j.christopherson@intel.com; maz@kernel.org;
> >> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> Will
> >> Deacon <Will.Deacon@arm.com>
> >> Cc: linux-kernel@vger.kernel.org;
> >> linux-arm-kernel@lists.infradead.org;
> >> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> >> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> >> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> >> <Justin.He@arm.com>; nd <nd@arm.com>
> >> Subject: Re: [RFC PATCH v4 2/5] ptp: Reorganize ptp_kvm modules to
> >> make it arch-independent.
> >>
> >> Hi Jianyong,
> >>
> >> On 26/09/2019 12:42, Jianyong Wu wrote:
> >>> Currently, ptp_kvm modules implementation is only for x86 which
> >>> includs large part of arch-specific code.  This patch move all of
> >>> those code into new arch related file in the same directory.
> >>>
> >>> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> >>> ---
> >>>    drivers/ptp/Makefile                 |  1 +
> >>>    drivers/ptp/{ptp_kvm.c => kvm_ptp.c} | 77 ++++++------------------
> >>>    drivers/ptp/ptp_kvm_x86.c            | 87
> >> ++++++++++++++++++++++++++++
> >>>    include/asm-generic/ptp_kvm.h        | 12 ++++
> >>>    4 files changed, 118 insertions(+), 59 deletions(-)
> >>>    rename drivers/ptp/{ptp_kvm.c => kvm_ptp.c} (63%)
> >>
> >> minor nit: Could we not skip renaming the file ? Given you are
> >> following the
> >> ptp_kvm_* for the arch specific files and the header files, wouldn't
> >> it be good to keep ptp_kvm.c ?
> >>
> > If the module name ptp_kvm.ko is the same with its dependent object
> > file ptp_kvm.o, warning will be given by compiler, So I change the
> ptp_kvm.c to kvm_ptp.c to avoid that conflict.
> 
> Hmm, ok. How about ptp_kvm_common.c instead of kvm_ptp.c ?

Yeah, it's a better name, I will change it next version.

Thanks
Jianyong Wu
> 
> Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
