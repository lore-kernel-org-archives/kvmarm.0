Return-Path: <SRS0=KLQI=YK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA79DFA373C
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 10:29:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A306E21835
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 10:29:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="VnZlvFbC";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="VnZlvFbC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A306E21835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C1994AA58;
	Thu, 17 Oct 2019 06:29:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8JoNxGEbWZjV; Thu, 17 Oct 2019 06:29:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 307E54AA5F;
	Thu, 17 Oct 2019 06:29:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA5654A98F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 06:05:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tx9d1qWrZRUz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Oct 2019 06:05:07 -0400 (EDT)
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr10046.outbound.protection.outlook.com [40.107.1.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36AAA4A98A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 06:05:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJQGczWTScr5w+6CN4LiAycC4W1vCOYvima47Au+h8Y=;
 b=VnZlvFbCFOalu0ZgqPwQYzXCpT3Ds+mHvNprLVJ529f2aubOeCLB9UsWP8JnkCRGhtc9co9LrpIHN0frzWPFwn7NraOZvG5SNVQOTpgLpk7th7IlDJwt1Fl5EkNepRbYVtJPLKha8KhsKudmhXWNJuRymP8rTduGvD6kVd2Pses=
Received: from DB6PR0801CA0064.eurprd08.prod.outlook.com (2603:10a6:4:2b::32)
 by VI1PR08MB2654.eurprd08.prod.outlook.com (2603:10a6:802:25::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.21; Wed, 16 Oct
 2019 10:05:03 +0000
Received: from VE1EUR03FT063.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::208) by DB6PR0801CA0064.outlook.office365.com
 (2603:10a6:4:2b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.16 via Frontend
 Transport; Wed, 16 Oct 2019 10:05:03 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT063.mail.protection.outlook.com (10.152.18.236) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 16 Oct 2019 10:05:02 +0000
Received: ("Tessian outbound 851a1162fca7:v33");
 Wed, 16 Oct 2019 10:04:51 +0000
X-CR-MTA-TID: 64aa7808
Received: from 826696268afc.1 (ip-172-16-0-2.eu-west-1.compute.internal
 [104.47.14.59]) by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 890A5724-0D73-4B48-9524-DA7DF9F4AD28.1; 
 Wed, 16 Oct 2019 10:04:46 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 826696268afc.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
 Wed, 16 Oct 2019 10:04:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pa9wSs6v2ufdWB+TzQ26BgiClPtKSEtk7UJlA7RV0aRbla4eCY0RtAcLg/dLTWM+kuUjcyp4V+24oW9iJzJQy5NC8q+c+AdyAN1ia2Yeu9i/mHL7ngjzfj4iSg675TReWSNxwj+j1bkhkNv2iretEQ/4PYJFk2lIk092ZqVMJ2UCX7zr+ncX6pplh6tncMnhbvNGXuqCLtr+7nEuWawQ9H3iF5s7vx3lqDe+dY4zVzYcKvyj3zupAdRQTTgMvc4ZQtl5eX8QZORDlEgI8FBCJWNMmwiXrS5Un7o1lJflANUfLxZ+YN+6Qzqb4R6tXKM7szw9XaqFF/+9vnQW4wiPaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJQGczWTScr5w+6CN4LiAycC4W1vCOYvima47Au+h8Y=;
 b=ofdSrNLzR7e69S+3PjyjcZcGf5EF8CgFZSkv5R9DOmp8C+UXuOxN8OBo3mhAVELMKm9vG8uV0rbZ2uMqtmYQ4ZiKfqMvKCOsYE7DOfPAItohJXTTljy5vWVwSXGhM5O14U9A88PqzCnqd0lfCiDakoBB95lD58NcmebKPtqtTFHCe2Q/0bZksysncKXBUdS16VJVErSYFCELA3j/m2nW7fNmk5xl8Gnlymc8FF9RBTgDwtbonQ/7EAdPgANjMUQ0Qd86tGV7DZQwfudUiHGAwZ6zTwB5dCkFMCZ2TcouG0Av3MYassHYWJS3YyKc1M7v4/osM0zgeOzreamNWt9qjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJQGczWTScr5w+6CN4LiAycC4W1vCOYvima47Au+h8Y=;
 b=VnZlvFbCFOalu0ZgqPwQYzXCpT3Ds+mHvNprLVJ529f2aubOeCLB9UsWP8JnkCRGhtc9co9LrpIHN0frzWPFwn7NraOZvG5SNVQOTpgLpk7th7IlDJwt1Fl5EkNepRbYVtJPLKha8KhsKudmhXWNJuRymP8rTduGvD6kVd2Pses=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1865.eurprd08.prod.outlook.com (10.168.94.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Wed, 16 Oct 2019 10:04:43 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 10:04:43 +0000
From: "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "sean.j.christopherson@intel.com"
 <sean.j.christopherson@intel.com>, "maz@kernel.org" <maz@kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>, Mark Rutland
 <Mark.Rutland@arm.com>, "will@kernel.org" <will@kernel.org>, Suzuki Poulose
 <Suzuki.Poulose@arm.com>
Subject: RE: [PATCH v5 2/6] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Topic: [PATCH v5 2/6] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Index: AQHVg0Yy3IKxJp51oU6H7J1V0yQ+3Kdc2u8AgAAwgwA=
Date: Wed, 16 Oct 2019 10:04:43 +0000
Message-ID: <HE1PR0801MB1676A5DA4C0B996FEDB2D47BF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-3-jianyong.wu@arm.com>
 <e0260f51-ad29-02ba-a46f-ebaa68f7a9ea@redhat.com>
In-Reply-To: <e0260f51-ad29-02ba-a46f-ebaa68f7a9ea@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 224ccb43-40ba-42fe-bb9c-f48f986e50d3.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 3a3a2804-9729-4b51-0beb-08d752204f7b
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1865:|HE1PR0801MB1865:|VI1PR08MB2654:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB2654CEBFC7F3F4E4D035525AF4920@VI1PR08MB2654.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7219;OLM:7219;
x-forefront-prvs: 0192E812EC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(13464003)(189003)(199004)(9686003)(86362001)(6436002)(55016002)(316002)(2201001)(3846002)(71200400001)(229853002)(11346002)(486006)(446003)(6116002)(66066001)(476003)(71190400001)(6636002)(76176011)(186003)(55236004)(6506007)(110136005)(99286004)(53546011)(54906003)(2501003)(7696005)(256004)(102836004)(26005)(4744005)(33656002)(7736002)(7416002)(74316002)(305945005)(52536014)(5660300002)(25786009)(2906002)(478600001)(8936002)(76116006)(66946007)(4326008)(66556008)(66446008)(64756008)(6246003)(14454004)(81166006)(66476007)(81156014)(8676002)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB1865;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; MX:1; A:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: KA8atxduN7y7VJWTypMr4oOoPQJZK2+A9jCrfRzSjua2VSCl8wHq+yYTUZSB+H/gVmvq3HPl3Hj8ZU3WbHggWain+8An8Lkr3LYXLVsrBAplNSwiKbE326TKuTCTbeQnEL4mfcBgECDsxJxIWTZ9pzY/ZLqoi1qJ8NwVt1nxIcqzr28pRu2qx6SjRAPrW3LhTi66EPg/jOJt67NiSD9np/LHbUQjg78YRgvOjQxR7nxJWrsqW53LD/rDcxbRjpgMMFm9WoS/3I9xsTD0hRpfG6j5vxk3YL/FGnVD35Oo9QIxNT+VjR1h0mSENWMNFS748u580xmf3ERPW+pDcyC/ehhIvtrumAK8ni9iPfD8N2QR7i4HEo++sGKk+X8uxMPfFfb6zTm84EHwwajZau3NOiT5InCH9QVEGjvdqJNeOWA=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1865
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(13464003)(189003)(199004)(23676004)(11346002)(81166006)(102836004)(8936002)(53546011)(436003)(86362001)(6506007)(478600001)(76130400001)(6636002)(50466002)(6116002)(22756006)(76176011)(2501003)(5660300002)(55016002)(229853002)(2486003)(52536014)(356004)(336012)(66066001)(486006)(47776003)(63350400001)(9686003)(7696005)(81156014)(126002)(26005)(446003)(8676002)(186003)(476003)(3846002)(36906005)(14454004)(7736002)(54906003)(74316002)(316002)(99286004)(70586007)(33656002)(2906002)(4326008)(26826003)(305945005)(2201001)(25786009)(110136005)(70206006)(6246003)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:VI1PR08MB2654;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:TempError; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; MX:1; A:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 89cf402e-eeb9-4982-23dd-08d752204445
NoDisclaimer: True
X-Forefront-PRVS: 0192E812EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /5ZCjUWpM6xllF8ohrE1zDHU+0DQiG3RUAqFycz3W8x/adcPoSYya3gVnvUux4agjDntLEEVwqsTtbctQNwhIjSVPbjKWarsNxELtSjwfW5YLOrpImv+ClLj2HSBWLiV/9JvXkWgcKCUlQiiL7zON7ju6kk2uv78iQbNJrNaX/yy24dQALNwdA7vu9YIyOEvUjQnNQ3hwz4d/d1FkInUARTNhGeR1o7nQ9j2FPX2FJm0I8jk5idF6zJixs3btwXh2Eds0OV+FaIlneY3MHDdyZ++DQBMNdFLYBQT3F+1/s9DKm1TpvYMk4l86bt6uKkqZh7wzO+7eotBEXbd/wgXOHwET+H10rDT4p2+mr3OCo04lQx5/wqRpKmeUFKmX819wt7mpp5Eln4ppEOS9vFDezClmxlCqB4z3nUxKKBYo5c=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2019 10:05:02.1028 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3a2804-9729-4b51-0beb-08d752204f7b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2654
X-Mailman-Approved-At: Thu, 17 Oct 2019 06:29:20 -0400
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

Hi Paolo,

> -----Original Message-----
> From: Paolo Bonzini <pbonzini@redhat.com>
> Sent: Wednesday, October 16, 2019 3:10 PM
> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>;
> netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; sean.j.christopherson@intel.com; maz@kernel.org;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v5 2/6] ptp: Reorganize ptp_kvm modules to make it
> arch-independent.
> 
> On 15/10/19 12:48, Jianyong Wu wrote:
> > +	ret = kvm_arch_ptp_init();
> > +	if (!ret)
> > +		return -EOPNOTSUPP;
> 
> This should be "if (ret)".
> 

Yeah, I change this at patch 5/6, but need change it here.

Thanks
Jianyong

> Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
