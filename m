Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1733FC63798
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 05:22:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B1272085B
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 05:22:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="nU2IWDN0";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="nU2IWDN0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B1272085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACC974BCAB;
	Tue, 24 Nov 2020 00:22:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NkuyV9Z8Od8d; Tue, 24 Nov 2020 00:22:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37E414BB79;
	Tue, 24 Nov 2020 00:22:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D17274BB57
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 00:22:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N62jx8kLYAX7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 00:22:02 -0500 (EST)
Received: from FRA01-PR2-obe.outbound.protection.outlook.com
 (mail-eopbgr120058.outbound.protection.outlook.com [40.107.12.58])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 541F54BB31
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 00:22:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAMcHFUpHfYscir3212kekOoJuVQONeTUk7iu2FfxBo=;
 b=nU2IWDN0buyZwIw4Ft7KEgMeN3BpdAIfGjvZaNjbw95gJWs/zRAu82xEK8a1/tfF1kbxt7sv/h7OnplnYcQW8MgsT99cgngBKJUO7dh1QozblV6rB/CZDhntbG2AUfS2QV3MNTmj5+VL2mIpdbub35ZBIx2yhklITmYjoe1h0K0=
Received: from AM6PR10CA0019.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::32)
 by PR2PR08MB4777.eurprd08.prod.outlook.com (2603:10a6:101:26::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Tue, 24 Nov
 2020 05:21:59 +0000
Received: from AM5EUR03FT024.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:89:cafe::a5) by AM6PR10CA0019.outlook.office365.com
 (2603:10a6:209:89::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Tue, 24 Nov 2020 05:21:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT024.mail.protection.outlook.com (10.152.16.175) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 05:21:58 +0000
Received: ("Tessian outbound 814be617737e:v71");
 Tue, 24 Nov 2020 05:21:58 +0000
X-CR-MTA-TID: 64aa7808
Received: from 33b21df39ac0.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 8411E29B-2C51-420C-94D6-5B8AC7BCDF9E.1; 
 Tue, 24 Nov 2020 05:21:53 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 33b21df39ac0.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 24 Nov 2020 05:21:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HigVNubI4o/OPPw8bICHVASrhTGBDTthV2TUp5JcFkIlkQrhlH9CK95/brzXrpyl12a2Csadg0rUOZuTejoqUgRBc7pmqwYAOdUUI+WKGC3FTbFFV6zDdgfc+9LSz3yhQszDNTGgvWMSG2O4IlDUXgqmiuqlUXZrTtdaRPQP/YssdIgDj9bubRDTHpZrYdJYoEHKuvG0xjIldMqC2SydN+vkVevKR8zZLIqWWnVv8jIAQihWBMooWD2S4NOeoWrBrq58qrHJvcPGfdpsFnSRV+F34T8CHaf5NuwOs9ok92w27EndKZ1oedkQexD2LQs39FfNnklI6tMxigNUOVvCCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAMcHFUpHfYscir3212kekOoJuVQONeTUk7iu2FfxBo=;
 b=IwulHk6vSGIoKYKoDk+jlmoT6r9gD8vyIyrGXLahZarVIT/E98zqS7fj7xVfTHlEJ+l4ZH4m6mRdTcX2VbwgO6Pm5q36J7ACyAPrpdS+CC9+7EzE7WSawRxJFhQvAxwybkq1nSs9LKXSGDCsYA/VbWj1WdXY51Z8T7PSTczX9yrGlRIGUq3VmK/6MNuhZFqeGyFRA3TsXlpo+y8eAA0VmkVy+Ur3SznPIUVqm5j60tvQeptJ59oMg4ufC61s4n4Tlsk183f785Z0pcl4UH4kdoCvCNaDtM513MKoCMViXil1/oNGh7/AT+eUGvljNAT+sWUO/BEqpkVgFP2luImu4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAMcHFUpHfYscir3212kekOoJuVQONeTUk7iu2FfxBo=;
 b=nU2IWDN0buyZwIw4Ft7KEgMeN3BpdAIfGjvZaNjbw95gJWs/zRAu82xEK8a1/tfF1kbxt7sv/h7OnplnYcQW8MgsT99cgngBKJUO7dh1QozblV6rB/CZDhntbG2AUfS2QV3MNTmj5+VL2mIpdbub35ZBIx2yhklITmYjoe1h0K0=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2250.eurprd08.prod.outlook.com (2603:10a6:3:c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Tue, 24 Nov
 2020 05:21:51 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 05:21:51 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v15 8/9] doc: add ptp_kvm introduction for arm64 support
Thread-Topic: [PATCH v15 8/9] doc: add ptp_kvm introduction for arm64 support
Thread-Index: AQHWt/NFDHcZq7JlmEiPhjJ99jyBiKnVnyWAgAE0KVA=
Date: Tue, 24 Nov 2020 05:21:51 +0000
Message-ID: <HE1PR0802MB25553458B5878B8B32372960F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-9-jianyong.wu@arm.com>
 <38fad448a3a465e4c35994ce61f4d8dd@kernel.org>
In-Reply-To: <38fad448a3a465e4c35994ce61f4d8dd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6075EE547CF5F44BA7DA3D606C509743.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 42a16443-166a-4d7b-9dcc-08d89038ddea
x-ms-traffictypediagnostic: HE1PR0802MB2250:|PR2PR08MB4777:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <PR2PR08MB47770212B635DA98A1425BF6F4FB0@PR2PR08MB4777.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:3513;OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: b0HzNshnIBHAG5zhWC9FSqtlh3pV+gWSQ+iYA9RtB6/K9fuKqxPyPqHQCJl6xxdRAJro85vX2PaQjFsf1tEiHZUlrk71jgdhwaUOiQ8CxSzYN6YNIM8klnh/wuJQeOx4pb+NFvpCpS164Eckc0Y3+wJOzaaNThoR/PnZZFtOD0kV1Y95VJJiVTp4yIJ1jsn76pnd4XBgj6LTuFt+SidVF0K97HtBxbqc5iu2P6yOq8Q2KGo9SH0b6mhFvg5lXpFv+mwCV/6tbMg1Y7aQMSSyflLI7tIQ2XNh4S0mGzhV6u/cbVjDn/czCF+KnycBC2uT
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(478600001)(8676002)(71200400001)(54906003)(6506007)(53546011)(316002)(186003)(33656002)(8936002)(52536014)(55016002)(5660300002)(9686003)(83380400001)(26005)(7696005)(7416002)(66446008)(6916009)(66476007)(64756008)(4001150100001)(66946007)(66556008)(4326008)(2906002)(86362001)(76116006);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: zW2+MZMZ0qcnKd2rx1J6FZLRZY2ssq/OdodZJfANlzSN61V/gTFBm77R5BxA4mMUEE38D8VP+yr/puKMjSwExTZBmoZ17HlMATyc1QEskCIbMeJh/clwlnxyS1akpczGWalOt0wH5X0dV9wAVNH+GD+FhKS+P+X72KHzVVu6fXsuvbfmyd26M9TNyt/kcBnAqs4VBO5QNd6KhGMnuTS3P20K1+RQ7AHADEQxBSN30ppcUhxgyQjgc7h6O6O94eBxD7gXzNIfWeC4btO6GvsA+nqIQeDkeUcOl/NBtACf2K2EY/UoqQXvcgK+Gj2HaXQzXuxDptA462W6Lpx5DuZvL8MjkfLcHEOqjwhKOJ7r6PoRnzClsN6lspkVRM7uGTwfB4+HCObHbzdTzktm9PaLNMFb7i/iwwKSfthPamizVi37MNRF+OMyiAIrZ5G+0y7I8ddOi2tuxA5ezDnchxK6iGG/qdYuAhkmDYtZFKI4NDHR1H0dPPISIO6Y6rJIfsuFYZgSbsSatYMz9/2DkN4SLXYW0uHiVethDcUGZQ3Cvq0hF6sVhOVnOSYT8lNaS1JWfQIzsS/XM0YkR4VL8vZGh6EE6y6Kh4fAQcPdWPXBwVP4PgmHHdYw/BlV/9AFK4TY6ouk35l98IrPe1uSRZcoecB00OwyJo+w0ZEn6W/O+JkgKqdO5m1FQuO9qb0pdyhGfvai4DTDzcsnm/hE2EfRk7taaLXR17jysnaooGRxi/VIzQNCDk98PsR8b3sEqqjkips4N0mKz0WNmq20btOhrDoOawu+0k3m+0bUAplliyhn1x5lyXQZHpX4U2Ak4RNyPUZPSL2jmxjVJpB1l864UV+JIEiauccBrFj5K9mWlcpz0vokLlDRLKYI8u9pLnz6mt364OwEiz4Qi/qbs77nyQ==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2250
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT024.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: a3fe8848-0b08-48a0-4a3e-08d89038d99f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NTjtATbCOdLDfl2xMqNLFCY44ifHiTJpgeqg9BCC68QrwB2GVza/rVFWY6osUjSkGuRpXVhgn0RllNI0rojvzGS/6faJfKrOYS9+EbP0cplkt6rPGZylK8FMJxAdiIbzwETzkAqSadUqBwq9EXkUgg1yk6mNCYsSXgiFx1ysXwFYaWQwXx5khRcPPh4rXC5ifwn0l4sUHFawuQRfEkigVjI5veZYWtBfWTtSLXJX1aOMa18egs9h/rLzJYWY4XABXht5KTY8pzUEn0t9ibyk7/KtncNd+I0TjTMJW73lITDIuis2NMgRTv6E29fo18a0uHVffVvK+vM7QomrOjVBqjrO+N6vlr6ou+LfFHLGmiErWfWDC4QP94VfmBsCRN7+V5jn95Tl/YeFlzBpty514w==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(46966005)(356005)(54906003)(8936002)(4001150100001)(6506007)(36906005)(4326008)(81166007)(70206006)(82310400003)(26005)(86362001)(2906002)(52536014)(53546011)(6862004)(186003)(82740400003)(47076004)(478600001)(316002)(8676002)(55016002)(70586007)(33656002)(336012)(83380400001)(5660300002)(9686003)(7696005);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 05:21:58.7594 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a16443-166a-4d7b-9dcc-08d89038ddea
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT024.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR08MB4777
Cc: Justin He <Justin.He@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Steven Price <Steven.Price@arm.com>, Andre Przywara <Andre.Przywara@arm.com>,
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
> Sent: Monday, November 23, 2020 6:58 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Andre
> Przywara <Andre.Przywara@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v15 8/9] doc: add ptp_kvm introduction for arm64
> support
> 
> On 2020-11-11 06:22, Jianyong Wu wrote:
> > PTP_KVM implementation depends on hypercall using SMCCC. So we
> > introduce a new SMCCC service ID. This doc explains how does the ID
> > define and how does PTP_KVM works on arm/arm64.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  Documentation/virt/kvm/api.rst         |  9 +++++++
> >  Documentation/virt/kvm/arm/index.rst   |  1 +
> >  Documentation/virt/kvm/arm/ptp_kvm.rst | 29
> +++++++++++++++++++++
> > Documentation/virt/kvm/timekeeping.rst | 35
> ++++++++++++++++++++++++++
> >  4 files changed, 74 insertions(+)
> >  create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst
> >
> > diff --git a/Documentation/virt/kvm/api.rst
> > b/Documentation/virt/kvm/api.rst index 36d5f1f3c6dd..9843dbcbf770
> > 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6391,3 +6391,12 @@ When enabled, KVM will disable paravirtual
> > features provided to the  guest according to the bits in the
> > KVM_CPUID_FEATURES CPUID leaf  (0x40000001). Otherwise, a guest may
> > use the paravirtual features  regardless of what has actually been
> > exposed through the CPUID leaf.
> > +
> > +8.27 KVM_CAP_PTP_KVM
> > +--------------------
> > +
> > +:Architectures: arm64
> > +
> > +This capability indicates that KVM virtual PTP service is supported
> > +in
> > host.
> > +It must company with the implementation of KVM virtual PTP service in
> > host
> > +so VMM can probe if there is the service in host by checking this
> > capability.
> > diff --git a/Documentation/virt/kvm/arm/index.rst
> > b/Documentation/virt/kvm/arm/index.rst
> > index 3e2b2aba90fc..78a9b670aafe 100644
> > --- a/Documentation/virt/kvm/arm/index.rst
> > +++ b/Documentation/virt/kvm/arm/index.rst
> > @@ -10,3 +10,4 @@ ARM
> >     hyp-abi
> >     psci
> >     pvtime
> > +   ptp_kvm
> > diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst
> > b/Documentation/virt/kvm/arm/ptp_kvm.rst
> > new file mode 100644
> > index 000000000000..bb1e6cfefe44
> > --- /dev/null
> > +++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
> > @@ -0,0 +1,29 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +PTP_KVM support for arm/arm64
> > +=============================
> > +
> > +PTP_KVM is used for time sync between guest and host in a high
> > precision.
> > +It needs to get the wall time and counter value from the host and
> > transfer these
> > +to guest via hypercall service. So one more hypercall service has
> > +been
> > added.
> > +
> > +This new SMCCC hypercall is defined as:
> > +
> > +* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001
> > +
> > +As both 32 and 64-bits ptp_kvm client should be supported, we choose
> > SMC32/HVC32
> > +calling convention.
> > +
> > +ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
> > +
> > +    =============    ==========    ==========
> > +    Function ID:     (uint32)      0x86000001
> > +    Arguments:	     (uint32)      ARM_PTP_PHY_COUNTER(1) or
> > ARM_PTP_VIRT_COUNTER(0)
> > +                                   which indicate acquiring physical
> > counter or
> > +                                   virtual counter respectively.
> > +    return value:    (uint32)      NOT_SUPPORTED(-1) or val0 and val1
> > represent
> > +                                   wall clock time and val2 and val3
> > represent
> > +                                   counter cycle.
> 
> This needs a lot more description:
> 
> - Which word contains what part of the data (upper/lower part of the 64bit
> data)
> - The endianness of the data returned

OK.

Thanks
Jianyong 
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
