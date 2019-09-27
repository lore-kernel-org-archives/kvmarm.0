Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06940C4360C
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 10:43:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A2712146E
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 10:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="cz+U7PaC";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="cz+U7PaC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A2712146E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE154A744;
	Fri, 27 Sep 2019 06:43:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lyW6BlkhFHsV; Fri, 27 Sep 2019 06:43:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2B8A4A73C;
	Fri, 27 Sep 2019 06:43:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57E844A6A4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 06:11:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id weX+xDpDDZAR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 06:10:34 -0400 (EDT)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130075.outbound.protection.outlook.com [40.107.13.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 903A04A71E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 06:10:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mCgbSjpcicQutl8OZMW12/8vRt7tLcsTSj+sJ5NLIc=;
 b=cz+U7PaCmtkxbpmCy4mu8fba667EP1PNGZAU0ymegRmioqscJvfejbxNaVb6WKxh0Gp3n6SNB0xB8XqqjeL6tyozrDgaF7MBzFyEIQbu4m3nB0o+5knE2VEkOB1KO50Yo0cDbIvAVREJM+T/AMMDJYNW/yxg1JDtr5np43yCMsY=
Received: from DB7PR08CA0048.eurprd08.prod.outlook.com (2603:10a6:10:26::25)
 by DB6PR0802MB2582.eurprd08.prod.outlook.com (2603:10a6:4:a2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.25; Fri, 27 Sep
 2019 10:10:31 +0000
Received: from VE1EUR03FT038.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::202) by DB7PR08CA0048.outlook.office365.com
 (2603:10a6:10:26::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2305.15 via Frontend
 Transport; Fri, 27 Sep 2019 10:10:31 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT038.mail.protection.outlook.com (10.152.19.112) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Fri, 27 Sep 2019 10:10:29 +0000
Received: ("Tessian outbound 0cf06bf5c60e:v33");
 Fri, 27 Sep 2019 10:10:17 +0000
X-CR-MTA-TID: 64aa7808
Received: from 711ae29de496.4 (ip-172-16-0-2.eu-west-1.compute.internal
 [104.47.4.53]) by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 7D7C44AC-D6DA-4185-A205-6ED37E819C1E.1; 
 Fri, 27 Sep 2019 10:10:12 +0000
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2053.outbound.protection.outlook.com [104.47.4.53])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 711ae29de496.4
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
 Fri, 27 Sep 2019 10:10:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aS7UdA97NUUjXgNdb0+0lzOFUnEWglZv93v7fIGnkWiwAJHhkO2Y9N8D2DFV5g677FN33+BnAJ6Yc8u7UZDC/92LL25GWk51cDPu0Oe7J6BDn/NRQwn4ZylyaA9b+sPeshITnsE5fNPgS17Ch1L73r58xDu+RtbX/A7+Xthhz2dj5VrCP5eqqRTUgMwVKIvDA80EUqePCJgnPa7uaVNdyt4MTR8924QUfUfvnGye95qaUNKp+1vr3xAAH4Q5Jq04ONz/OnMGALE1s4oEGhFctIxxf+bFdW8da57d4/h2gn/kfsexGAFBk38Wqwd7QL+O+uOwHjfOw4VTV5F6eTC8NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mCgbSjpcicQutl8OZMW12/8vRt7tLcsTSj+sJ5NLIc=;
 b=le34nx5eJmYP1hsCwwqsWDZ95M8HCCbOy1/MH7NyHXH8ymvajg/YMDV1Csk/t2qEi5XBKivkGTR1yEDr0Rk991zy72cTmSetfOoPvjIVB3VG+zAdeFScbwCIiQ9lUEYEnE9zbvTw/ZHmfqID0CrNr7RsdiDIYi/J7Jfppv5e0mwZsvpUAohrDoY8ci/biTxGrMaofZJQJoP2uYFMpX/LFkx0SWuR6twjsnS9hViKgzKWmJoWNcwc/xzaBXzIzTT7GR8aQPXIBc48pyU8O5O/e5rlsuHRyhn04sB195qRhffbP7ZIiagu7JQy+RNM1eBnTFsxaOrqgX1QGLXtzmbNgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mCgbSjpcicQutl8OZMW12/8vRt7tLcsTSj+sJ5NLIc=;
 b=cz+U7PaCmtkxbpmCy4mu8fba667EP1PNGZAU0ymegRmioqscJvfejbxNaVb6WKxh0Gp3n6SNB0xB8XqqjeL6tyozrDgaF7MBzFyEIQbu4m3nB0o+5knE2VEkOB1KO50Yo0cDbIvAVREJM+T/AMMDJYNW/yxg1JDtr5np43yCMsY=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2041.eurprd08.prod.outlook.com (10.168.98.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Fri, 27 Sep 2019 10:10:10 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd%3]) with mapi id 15.20.2284.028; Fri, 27 Sep 2019
 10:10:10 +0000
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
Thread-Index: AQHVdF+Ft3UnKFEitUOtlQstSNDglqc97ZgAgAFgLEA=
Date: Fri, 27 Sep 2019 10:10:10 +0000
Message-ID: <HE1PR0801MB167630F7B983A7F9DBB473DFF4810@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190926114212.5322-1-jianyong.wu@arm.com>
 <20190926114212.5322-3-jianyong.wu@arm.com>
 <2f338b57-b0b2-e439-6089-72e5f5e4f017@arm.com>
In-Reply-To: <2f338b57-b0b2-e439-6089-72e5f5e4f017@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: c71b3542-34ef-4996-a434-864809ac6f26.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 6ace8ebf-53e7-46ab-0d18-08d74332ecc6
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0; PCL:0;
 RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);
 SRVR:HE1PR0801MB2041; 
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2041:|HE1PR0801MB2041:|DB6PR0802MB2582:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB258205F951A174B3D4C7D2DAF4810@DB6PR0802MB2582.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:7691;
x-forefront-prvs: 0173C6D4D5
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(13464003)(189003)(199004)(2906002)(52536014)(486006)(66556008)(9686003)(66476007)(64756008)(55016002)(66446008)(6246003)(11346002)(8936002)(446003)(71200400001)(71190400001)(2201001)(6436002)(86362001)(229853002)(476003)(7416002)(76116006)(66946007)(25786009)(2501003)(99286004)(478600001)(81166006)(81156014)(305945005)(74316002)(8676002)(76176011)(7736002)(14444005)(316002)(5660300002)(6116002)(186003)(14454004)(3846002)(256004)(66066001)(33656002)(102836004)(55236004)(54906003)(4326008)(6636002)(26005)(7696005)(110136005)(53546011)(6506007)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB2041;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; MX:1; A:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: 5df0i9w/dswQaqAUYzAkZQBp+Ivm1KJ3FqRsVlaEzcrkC/4pABljERNh0E4deM6Vai9nFtyXM9K+ddd/DiCRnr0Aoz0uP8//OdTh/n1Ai+xDOnCfAN12Ad7lbx1HzIoN2shOYy3r2vUDW8p7EcqWc8RyNNPqp5qoJ0ZKI3m5eYIw1T2KdGM/I6T2QaJdefDe79oFwgIiltOZOZKGg2AgLpanym+lfSC9IkiEgnc92St3LEtS76P29Zlk/Zo2l1PwgTTdI93k+BAQVuE00uXv/zPToLJ7ZyGGWdcALcK51BZO4J2svqNQbqigETFw4Yqhls1JhQ+QLnAY+gIrXQF5pXvDXkwYD542g5dyOhg4t7YVXcRCa+wRSNo1jy+YbTrvpn82BgcsDmE/93COc/SFhzNYeYOuOefwNlyGddkMcE4=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2041
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT038.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(13464003)(76176011)(336012)(2486003)(55016002)(14444005)(33656002)(126002)(305945005)(11346002)(2906002)(81166006)(110136005)(74316002)(50466002)(36906005)(63350400001)(436003)(7736002)(316002)(446003)(476003)(2501003)(8676002)(4326008)(229853002)(22756006)(76130400001)(486006)(2201001)(356004)(186003)(81156014)(8936002)(70206006)(26005)(66066001)(7696005)(53546011)(6506007)(25786009)(47776003)(99286004)(3846002)(14454004)(70586007)(54906003)(52536014)(478600001)(102836004)(6116002)(86362001)(6636002)(5660300002)(9686003)(26826003)(6246003)(23676004)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:DB6PR0802MB2582;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:TempError; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; MX:1; A:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 348b2373-ee90-4782-1798-08d74332e155
X-Microsoft-Antispam: BCL:0; PCL:0;
 RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);
 SRVR:DB6PR0802MB2582; 
NoDisclaimer: True
X-Forefront-PRVS: 0173C6D4D5
X-Microsoft-Antispam-Message-Info: PPkUN8PTpMtDdOu2fpxUjBSLy1XwqCTRsB/oNTHBvQXqNsz7vNSAyccH+csiQtQN+mbZ/VNYJA9Kya22pQf4ZjggxPARMSqOPDzs+TTu/+9ZATeUt9ZJtcHzxeoTSIJrccO/oIudD4micTaW8IrV39dsXPq3GdN34er2g3jkpE48tsXOdbKh5C022mvBxLMyGS8k2FDkk+6E2v+mhUWE2mN8pb/1xBOE3M54OHKEJR1dVRnMiRMnGVr8PqsPlPH/EAN6yx5vxKFI2sEorraTK6J69Bcbc86Sb8fJOpnHG/5CXXakHUmpaD1F/fFWEuEQ9XMq8ZSL4L3R1fcPU2XI3Hr/V/p7MzBkonyUKYHwiRfsPMco6HUIwh+O9DDzowGUNnfSVcgp2AUuOMrSMHs7UTy1qjaFi8pvPsfHKp012AY=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2019 10:10:29.5049 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ace8ebf-53e7-46ab-0d18-08d74332ecc6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2582
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
> Sent: Thursday, September 26, 2019 9:06 PM
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
> Hi Jianyong,
> 
> On 26/09/2019 12:42, Jianyong Wu wrote:
> > Currently, ptp_kvm modules implementation is only for x86 which
> > includs large part of arch-specific code.  This patch move all of
> > those code into new arch related file in the same directory.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >   drivers/ptp/Makefile                 |  1 +
> >   drivers/ptp/{ptp_kvm.c => kvm_ptp.c} | 77 ++++++------------------
> >   drivers/ptp/ptp_kvm_x86.c            | 87
> ++++++++++++++++++++++++++++
> >   include/asm-generic/ptp_kvm.h        | 12 ++++
> >   4 files changed, 118 insertions(+), 59 deletions(-)
> >   rename drivers/ptp/{ptp_kvm.c => kvm_ptp.c} (63%)
> 
> minor nit: Could we not skip renaming the file ? Given you are following the
> ptp_kvm_* for the arch specific files and the header files, wouldn't it be
> good to keep ptp_kvm.c ?
> 
If the module name ptp_kvm.ko is the same with its dependent object file ptp_kvm.o, warning will be given by compiler, 
So I change the ptp_kvm.c to kvm_ptp.c to avoid that conflict.

Thanks
Jianyong Wu

> Rest looks fine.
> 
> Cheers
> Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
