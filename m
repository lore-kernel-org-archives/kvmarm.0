Return-Path: <SRS0=sT9x=ZS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872A2C432C0
	for <kvmarm@archiver.kernel.org>; Tue, 26 Nov 2019 08:31:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 09A32206BF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Nov 2019 08:31:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="DCVKv5M/";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="DCVKv5M/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09A32206BF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F1664AE95;
	Tue, 26 Nov 2019 03:31:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YElglsOqSq+9; Tue, 26 Nov 2019 03:31:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD7AC4AC89;
	Tue, 26 Nov 2019 03:31:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C1E94A8E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 03:31:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30BL29FF5-VJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Nov 2019 03:31:11 -0500 (EST)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50044.outbound.protection.outlook.com [40.107.5.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43C2D4A542
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 03:31:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gh7o1PaB51MDokxlVtsTJm7/H2ENFR/NWoNxMTPOxs=;
 b=DCVKv5M/wH6YlXPtrsh8Dt2sanLV2PkpVMYdW3soc2FK/ZaXznYGWBL2SSRoYvKtyeCdp+NxzaEEAOwMgj2mlS00O/51aDdLcqW9tcScQErb40x9+SBgw52WoWXX1m3CWwRIjW1r839+QLdaozLaXTw0xfyRH6quwDWTRLRvDg4=
Received: from AM4PR08CA0061.eurprd08.prod.outlook.com (2603:10a6:205:2::32)
 by AM0PR08MB4211.eurprd08.prod.outlook.com (2603:10a6:208:101::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.18; Tue, 26 Nov
 2019 08:31:08 +0000
Received: from VE1EUR03FT008.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::208) by AM4PR08CA0061.outlook.office365.com
 (2603:10a6:205:2::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17 via Frontend
 Transport; Tue, 26 Nov 2019 08:31:08 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT008.mail.protection.outlook.com (10.152.18.75) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17 via Frontend Transport; Tue, 26 Nov 2019 08:31:08 +0000
Received: ("Tessian outbound f7868d7ede10:v33");
 Tue, 26 Nov 2019 08:31:04 +0000
X-CR-MTA-TID: 64aa7808
Received: from 473ca04911d7.2 (ip-172-16-0-2.eu-west-1.compute.internal
 [104.47.2.50]) by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 B4020F65-33DE-4F9F-B1FD-73763AF0D7A7.1; 
 Tue, 26 Nov 2019 08:30:59 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2050.outbound.protection.outlook.com [104.47.2.50])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 473ca04911d7.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 26 Nov 2019 08:30:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRyOHXukHH1RgaX9E1kcvZBTzlU7yhZypQYK+Sv6LDmM4qY0IKAGOFQLTastCRE9FjEUkDmjv2sFvFRXX5bRVzRMYIRabjz7wxAlQ24kdcgePubvZDgktoXTsVB97cFz98+zBy386xVAkuNeRmqNl4ejAwdzRN//QEdo/ay+DzfYBcMOJO7HWYVUGzj1DELWsrnTn4dpFGa/mDBF9EpBRPpElGnoYCDuM/flej3glhWk2aylNb3gQhguoFUTsIqrRas/Z/BmoYWXfIcA/PmN4GEf90Y4q9Z1L+34hfUVpPu1an8fUkHNOeO8W8vXuXb0ujfXgFE3isRUs1ulb+e0Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gh7o1PaB51MDokxlVtsTJm7/H2ENFR/NWoNxMTPOxs=;
 b=TjAXW8tHInpEMrP8lpeX3qtZ5ALjgqzIdmOvxH6gQRIp4Zt19vIMK6xj9CUi7uYT2ArFDngG2oVnUhq5YWdkT+lrQvARLKNdC9WDSv+hI4EMl+JEYttZuUzRcXER/c7yfBgW41EIvOwlzJE7+WND3LlW9Gf69oooGHthhvjwNvZi3Y5Kphl/PoJ8Rb9RISW1xruaEALErLkqUGFSVOJQmiQaVd+0v2Hkm6Egq3GgyBTlB7Yg2tOQUyTJQu/nCrY9vg4pdzQf+7FMuwZmXOVaGbk7yeNa+oZscVCCdt/taX8Doou8MrRabQhnOr/daAl249qkVoHBVbPhIhTJ20eleA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gh7o1PaB51MDokxlVtsTJm7/H2ENFR/NWoNxMTPOxs=;
 b=DCVKv5M/wH6YlXPtrsh8Dt2sanLV2PkpVMYdW3soc2FK/ZaXznYGWBL2SSRoYvKtyeCdp+NxzaEEAOwMgj2mlS00O/51aDdLcqW9tcScQErb40x9+SBgw52WoWXX1m3CWwRIjW1r839+QLdaozLaXTw0xfyRH6quwDWTRLRvDg4=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2090.eurprd08.prod.outlook.com (10.168.93.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Tue, 26 Nov 2019 08:30:57 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::453c:d9b6:5398:2294]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::453c:d9b6:5398:2294%8]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 08:30:56 +0000
From: "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [RFC PATCH v8 3/8] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Topic: [RFC PATCH v8 3/8] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Index: AQHVo32GHa+cuSKk4Ea1AvmwxiCr5KecCFoAgAEQ+AA=
Date: Tue, 26 Nov 2019 08:30:56 +0000
Message-ID: <HE1PR0801MB1676DCFA2490D1DB58C14A4AF4450@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191125104506.36850-1-jianyong.wu@arm.com>
 <20191125104506.36850-4-jianyong.wu@arm.com>
 <a13a4f9554f36a46781308358fc63519@www.loen.fr>
In-Reply-To: <a13a4f9554f36a46781308358fc63519@www.loen.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: eab09f93-49f9-45f2-95e1-7cc5d9b54db5.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f4874727-bf8c-43b7-063f-08d7724afc5d
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2090:|HE1PR0801MB2090:|AM0PR08MB4211:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB42111BD36E0C9D58C185970BF4450@AM0PR08MB4211.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:1169;OLM:1169;
x-forefront-prvs: 0233768B38
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(13464003)(189003)(199004)(7696005)(4326008)(5660300002)(76116006)(186003)(76176011)(66476007)(99286004)(66446008)(64756008)(66556008)(66946007)(55016002)(52536014)(9686003)(25786009)(316002)(6436002)(256004)(446003)(11346002)(81156014)(71200400001)(7416002)(8936002)(478600001)(6916009)(54906003)(66066001)(74316002)(3846002)(33656002)(7736002)(6116002)(55236004)(102836004)(6506007)(4001150100001)(53546011)(6246003)(81166006)(8676002)(26005)(14454004)(86362001)(229853002)(305945005)(2906002)(71190400001);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB2090;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; MX:1; A:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: KfWg/d16QuwQByxjM04tH7Spmgy7WBbpSnXmDQaCEVoDPEVb5MKKK1e+Sm6477D0CTkFbgQxI8ZP/UoAcYl+SQImeDlvjf/tErzKpouv32vArq4erj3MQtbP03kuhiDHO51zFogk02JrBmyhDQ83OBYMZbU1ot8J1qEHYaC17WPPkaCw42FuojYx3H3La31DDLp/YgXYYWDnt28nr/nhPqIvD28ttBbRez1TMXTOh+UJQ66v7wlCFyO10KqmbrakBH49nPAvyFidsQwpIvN4UjbKqUBzPXve1O9TOM4B76cPkkXZah3QEAUd8k6pZjbGAmh3CWxFm/7PmpxhwzF2I/e5p17SpswBZAtmha4SbpOtn5n+mCz8KeJ5Kk2l74pUepKHmTjaox2t66bMi2pV9YPB0oLc8wLdqd5xgfxkBboikmScyn4EzPcHy8wWnqLX
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2090
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT008.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(13464003)(189003)(199004)(26826003)(356004)(70206006)(70586007)(478600001)(336012)(436003)(2486003)(66066001)(7696005)(11346002)(86362001)(446003)(76176011)(186003)(5660300002)(23676004)(14454004)(102836004)(25786009)(76130400001)(6506007)(53546011)(4001150100001)(9686003)(7736002)(55016002)(2906002)(305945005)(52536014)(26005)(74316002)(229853002)(8936002)(316002)(6862004)(4326008)(6246003)(36906005)(106002)(54906003)(22756006)(81156014)(6116002)(50466002)(81166006)(3846002)(33656002)(99286004)(8676002)(47776003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:AM0PR08MB4211;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:Pass; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; MX:1; A:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 019346ed-ce47-4a0e-81ff-08d7724af583
NoDisclaimer: True
X-Forefront-PRVS: 0233768B38
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4sy4H4/IX7O8eOfpMn1k/JuUVCiKAKHbYWJBZ9aqt+Qgi3eoNyi6CwWClfpmEibkXNi+FaDou4Tz5glkWMpaHtAAsaKLGXHEanXQpI45fztUMIBysoixPcWPTQrW60jK9caanYngkZS75FJzrzuO1ai/9y07JVoWzuqOcm4+t3CvPsVhZpWnQRAxQ0s4qVPS7eoZcTh5CyyiJpG/Y9Tmbbor5bdLj46oigg/ZC9UJMGhE7ingHfKXIog4cuuZhCWjS/vV1jlUDbyO/BMEEA6eKqWx1aKbSGaHZOAt4I9EaW+CxItpQzWbYaDQBYdo73BaMSA5n1n4NMddcqLSqTn1sGr6+jkPyd0sDRIMHyqqFSPjo71DldLOjNEQFwvvKJVu8MIN2ztBjHUf3QVG7bn4uKIGysWqzHH/OnB1YAKnVnDTfExvemICDMGuqWaBn9T
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2019 08:31:08.2224 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4874727-bf8c-43b7-063f-08d7724afc5d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4211
Cc: "Justin He \(Arm Technology China\)" <Justin.He@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
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
> Sent: Monday, November 25, 2019 11:48 PM
> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v8 3/8] ptp: Reorganize ptp_kvm modules to make it
> arch-independent.
> 
> On 2019-11-25 10:45, Jianyong Wu wrote:
> > Currently, ptp_kvm modules implementation is only for x86 which
> > includs large part of arch-specific code.  This patch move all of
> > those code into new arch related file in the same directory.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  drivers/ptp/Makefile                        |  1 +
> >  drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 77 +++++-------------
> >  drivers/ptp/ptp_kvm_x86.c                   | 87
> > +++++++++++++++++++++
> >  include/asm-generic/ptp_kvm.h               | 12 +++
> >  4 files changed, 118 insertions(+), 59 deletions(-)  rename
> > drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (63%)  create mode
> 100644
> > drivers/ptp/ptp_kvm_x86.c  create mode 100644
> > include/asm-generic/ptp_kvm.h
> 
> [...]
> 
> > diff --git a/include/asm-generic/ptp_kvm.h
> > b/include/asm-generic/ptp_kvm.h new file mode 100644 index
> > 000000000000..e5dd386f6664
> > --- /dev/null
> > +++ b/include/asm-generic/ptp_kvm.h
> > @@ -0,0 +1,12 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + *  Virtual PTP 1588 clock for use with KVM guests
> > + *
> > + *  Copyright (C) 2019 ARM Ltd.
> 
> I think you should live the original copyright assignment here.
> This really isn't anything new.
> 

Ok,

> > + *  All Rights Reserved
> > + */
> > +
> > +int kvm_arch_ptp_init(void);
> > +int kvm_arch_ptp_get_clock(struct timespec64 *ts); int
> > +kvm_arch_ptp_get_crosststamp(unsigned long *cycle,
> > +		struct timespec64 *tspec, void *cs);
> 
> Why is this include file in asm-generic? This isn't a kernel-wide API.
> 
> I think it should be sitting in drivers/ptp, as it is only shared between the
> generic and arch-specific stuff.

Ok, all these APIs used under driver/ptp, so it's better to move that header file into it.

Thanks
Jianyong
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
