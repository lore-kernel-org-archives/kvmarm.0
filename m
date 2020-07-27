Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B72C433E3
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 03:45:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D554206E7
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 03:45:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="V5yI0nGh";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="V5yI0nGh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D554206E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02FEA4B891;
	Sun, 26 Jul 2020 23:45:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kmx20r3AvrIu; Sun, 26 Jul 2020 23:45:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD1304B89C;
	Sun, 26 Jul 2020 23:45:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 358C04B896
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Jul 2020 23:45:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GG99gJRuXuAc for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 Jul 2020 23:45:51 -0400 (EDT)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50040.outbound.protection.outlook.com [40.107.5.40])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 199D04B891
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Jul 2020 23:45:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEQ1fmccigd/EKhvUdPNXcLeuhZrdSDq/GbhK88qvm0=;
 b=V5yI0nGhtptQKnsd7IhVC/fo9G9u8OUkcktqIQfTFws+yBU6qZW34aZvBaj1Gx06gkA/3ufQQCBPHpl2w6shgTKf1SV0cPfMf02LV7Q0SDHXXLRbLESS2qRZa5t8UT3CwkbtLybX0DJMQ7x3DaNvOQEGKKL/qNIw4IXCr+KM+ng=
Received: from FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::28) by
 AM0PR08MB3108.eurprd08.prod.outlook.com (2603:10a6:208:5c::33) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.20; Mon, 27 Jul 2020 03:45:48 +0000
Received: from VE1EUR03FT064.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:d10:a:cafe::26) by FR2P281CA0018.outlook.office365.com
 (2603:10a6:d10:a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.10 via Frontend
 Transport; Mon, 27 Jul 2020 03:45:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT064.mail.protection.outlook.com (10.152.19.210) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.10 via Frontend Transport; Mon, 27 Jul 2020 03:45:47 +0000
Received: ("Tessian outbound c4059ed8d7bf:v62");
 Mon, 27 Jul 2020 03:45:47 +0000
X-CR-MTA-TID: 64aa7808
Received: from 90e106e78736.3
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 58FE98A4-75EE-402A-A1E7-A4481B6D32D9.1; 
 Mon, 27 Jul 2020 03:45:42 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 90e106e78736.3
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 27 Jul 2020 03:45:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbXqfGgRjHggC0xRGeJ6+205PHXLMnppkK7bgWUrTcz+060Zq1VmWXAiylgeWf4qbiRM0jrD6LqXgqfLWZ5k8N8PqiSZ4NcE0xUO/kUWGL411uwxNpkge2w90B0OL7Uk8tWzGOuCugm+ytNR+y94HlDgbpiJtAnq8VuUQrHMCSzVSUMiT3DCO1kBNHlvXBeMFItkacTo/MEcoBwJCDqJg/AdBceH0ysuos/gwEIIGyFRwThxj+XEEC6+MCyeHHOTgvDd7PX9iJGEHV2tdcyyzY+haP79xReHn7Yj0ffYoLtSG+Md+V0vXDP87PrMIW/OmIk24Ng1/tN0GMo8ZTyLog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEQ1fmccigd/EKhvUdPNXcLeuhZrdSDq/GbhK88qvm0=;
 b=C/i6XOXE02DohjwK+iwKj5XtV3lz9qGMaxvmtJt7APkBXTv+wAwG7TUccuRYcVzMifk1JfGcfBoCZzUEUskygEJHiKnDHFuRbFpOaG4LdCnFzaqDF5x41t0UtOyO6sk5I20aBtCizFgjBdRELG2Q+urVwEgevaZyc9Jo82dFhowM2p4jqhVwguGa1xBQF9/yvxT3SEs3Jr8cm+vtc51yZ4WYw5XermelQQP5pStk0kahJVdArTb0ih6Q5pnf0deZS46fkoBncUo9n2axtrDQ6/u4eI5fApfhNTwbl+merIPL7uETVRhriPqTfYZpht9Jd4uon9A64owjE57T9CPveA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEQ1fmccigd/EKhvUdPNXcLeuhZrdSDq/GbhK88qvm0=;
 b=V5yI0nGhtptQKnsd7IhVC/fo9G9u8OUkcktqIQfTFws+yBU6qZW34aZvBaj1Gx06gkA/3ufQQCBPHpl2w6shgTKf1SV0cPfMf02LV7Q0SDHXXLRbLESS2qRZa5t8UT3CwkbtLybX0DJMQ7x3DaNvOQEGKKL/qNIw4IXCr+KM+ng=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR08MB2825.eurprd08.prod.outlook.com (2603:10a6:7:35::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Mon, 27 Jul
 2020 03:45:38 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a%6]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 03:45:38 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Jianyong Wu <Jianyong.Wu@arm.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "maz@kernel.org" <maz@kernel.org>, "richardcochran@gmail.com"
 <richardcochran@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>,
 "will@kernel.org" <will@kernel.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>, 
 Steven Price <Steven.Price@arm.com>
Subject: RE: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via
 SMCCC
Thread-Topic: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via
 SMCCC
Thread-Index: AQHWRjnTCp2aKUWCLkK9Y7ZKWPQzQKka//qw
Date: Mon, 27 Jul 2020 03:45:37 +0000
Message-ID: <HE1PR0802MB255577943C260898A6C686ABF4720@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200619130120.40556-1-jianyong.wu@arm.com>
 <20200619130120.40556-3-jianyong.wu@arm.com>
In-Reply-To: <20200619130120.40556-3-jianyong.wu@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: d6719f89-de16-48fd-8ed7-b913cb3ead80.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8e4a6a3a-c241-4808-a67c-08d831df8c85
x-ms-traffictypediagnostic: HE1PR08MB2825:|AM0PR08MB3108:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB3108E1370CDCB3ECAF04997DF4720@AM0PR08MB3108.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: XDqt/J4uIemQjxLaYbQIyK5PMbmTHtTtDFL8gIxg1MmCr7pdMDJO6bSnuWdbgXak+szQg/pAeKSnMvmbzO283Z9JI0rItJJKi/M6uW0EaqTO6MhB4GUoz8YQIs20p+eNN+Cp6aRCJOrDJCyeP/GXNqSRO+wrMnj1tPj67ywUu6vsZ6V7TyoCZNuBl5XAv7BDsa8Qzscm5RczbsQA8tgk2qska6/MmtfgwHKwRW+daU9joUJbF54vEWTmo0UAWdVUob1e66NmfoV0tIu0H06QIU7ri64Y/E1hnNBULiI8CGGId/9W7YU2jwqjhfKzhc44gX4v7QJrBaAAbv5DXymmPB6ZHxvDsciw2O5XDUWptMGgElXfR7KNbqJb8jJIuJNW
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(366004)(346002)(396003)(39850400004)(376002)(136003)(52536014)(76116006)(6636002)(66946007)(110136005)(54906003)(86362001)(316002)(478600001)(71200400001)(8676002)(26005)(8936002)(186003)(9686003)(2906002)(55016002)(33656002)(83380400001)(7416002)(66476007)(64756008)(66556008)(53546011)(6506007)(66446008)(4326008)(5660300002)(7696005)(921003);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: 9iLzsfxb0jk16hLiT/+ZMmaDcyB8wTpfEX8jRzneh+kAj06z6iOiwv1jSsK/Uo84eLcIAXgrhYqHsv6DUiUAc5jJ9FtJVNta52+QX+eljqu59Jdu72UnM4kQ+wIi+0bMyBnqbu+wNnLf6Nz6I0lQy2sWH9ntlOz/xDWGERlE3d/eih63XCec47UaGwUYuxMhS7vi45lm6z/VeMnUEFlWDU3e0mK3myXA84TzmzWwCoEYEyYlf1C1tyxe6GN1K8VfZqAppPmV8s+KFq5JkvR+L8KAE4vhQgOpu4OYE2WlqtLZq0BqrHkPISrDzMAHcXP+toM1Q2hcgyrycMk62PvwLD9G6Jd5d3Tu7m/f2GFePJ5KNrLXpLPFsCxuRjOlMISOddIdH6yLy3LN41RaMEwkX0s7m+ObXJs0fFSf37VFxCEcrumK40ty7FASN+srWwgrWxT6tAbstJki/18PA7P6ieiT/LDbUncQ9wVlzQ187jA=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR08MB2825
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 66de0f24-c9e1-465d-a09d-08d831df86b0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mh3zhK9214Ro2KyilIx+0rOaUW+C9IMT2SOPu9fmk0FOzYhGHBwqi1QIXp0Se6pJ2iD6QTjIMhTLFiOg3dQ2PC5TSMPgtAv6LFp0t/VPW/bOblkthRHiI0iSX8bq0ODoTqf4uOR6op2SNSQHvsjqT8LhF4fXCsAZhC850uMLJ5PoVw/MA3igkdXUxsf+Z/kq1xqt0Ep6bXXEVT0+efvxkdaPq4SlyhOTED9MheQ1qTjHgkM9x2aFYlmi9xFKaq+AkibhihSXJJjPpr2US+waskN/H2nEk8UD0hi9zzGatHrIPRkw1XIl/KxGDEMXyOZywLhKE5xxVLVzPvN9GOVc4CpDO1+kyBdvO2KB4RhRavX9tNvcZ5BV5LF1Ogpyy5ucqRHZvDSgodFHn/A4fEAE1uUrksTIKa0I17RhuYEfiEQ=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(376002)(346002)(136003)(39850400004)(396003)(46966005)(70206006)(4326008)(7696005)(33656002)(336012)(6636002)(9686003)(8936002)(55016002)(2906002)(5660300002)(70586007)(47076004)(36906005)(81166007)(53546011)(52536014)(86362001)(83380400001)(8676002)(186003)(54906003)(478600001)(6506007)(110136005)(26005)(316002)(82740400003)(82310400002)(356005)(921003);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 03:45:47.6852 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4a6a3a-c241-4808-a67c-08d831df8c85
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3108
Cc: Justin He <Justin.He@arm.com>, Wei Chen <Wei.Chen@arm.com>,
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

Hi Will,

> -----Original Message-----
> From: Jianyong Wu <jianyong.wu@arm.com>
> Sent: Friday, June 19, 2020 9:01 PM
> To: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>; Jianyong Wu
> <Jianyong.Wu@arm.com>; nd <nd@arm.com>
> Subject: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via
> SMCCC
> 
> From: Will Deacon <will@kernel.org>
> 
> We can advertise ourselves to guests as KVM and provide a basic features
> bitmap for discoverability of future hypervisor services.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  arch/arm64/kvm/hypercalls.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 550dfa3e53cd..db6dce3d0e23 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -12,13 +12,13 @@
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
>  	u32 func_id = smccc_get_function(vcpu);
> -	long val = SMCCC_RET_NOT_SUPPORTED;
> +	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};

There is a risk as this u32 value will return here and a u64 value will be obtained in guest. For example,
The val[0] is initialized as -1 of 0xffffffff and the guest get 0xffffffff then it will be compared with -1 of 0xffffffffffffffff
Also this problem exists for the transfer of address in u64 type. So the following assignment to "val" should be split into
two u32 value and assign to val[0] and val[1] respectively.
WDYT?

Thanks
Jianyong 

>  	u32 feature;
>  	gpa_t gpa;
> 
>  	switch (func_id) {
>  	case ARM_SMCCC_VERSION_FUNC_ID:
> -		val = ARM_SMCCC_VERSION_1_1;
> +		val[0] = ARM_SMCCC_VERSION_1_1;
>  		break;
>  	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
>  		feature = smccc_get_arg1(vcpu);
> @@ -28,10 +28,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  			case KVM_BP_HARDEN_UNKNOWN:
>  				break;
>  			case KVM_BP_HARDEN_WA_NEEDED:
> -				val = SMCCC_RET_SUCCESS;
> +				val[0] = SMCCC_RET_SUCCESS;
>  				break;
>  			case KVM_BP_HARDEN_NOT_REQUIRED:
> -				val = SMCCC_RET_NOT_REQUIRED;
> +				val[0] = SMCCC_RET_NOT_REQUIRED;
>  				break;
>  			}
>  			break;
> @@ -41,31 +41,40 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  			case KVM_SSBD_UNKNOWN:
>  				break;
>  			case KVM_SSBD_KERNEL:
> -				val = SMCCC_RET_SUCCESS;
> +				val[0] = SMCCC_RET_SUCCESS;
>  				break;
>  			case KVM_SSBD_FORCE_ENABLE:
>  			case KVM_SSBD_MITIGATED:
> -				val = SMCCC_RET_NOT_REQUIRED;
> +				val[0] = SMCCC_RET_NOT_REQUIRED;
>  				break;
>  			}
>  			break;
>  		case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -			val = SMCCC_RET_SUCCESS;
> +			val[0] = SMCCC_RET_SUCCESS;
>  			break;
>  		}
>  		break;
>  	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -		val = kvm_hypercall_pv_features(vcpu);
> +		val[0] = kvm_hypercall_pv_features(vcpu);
>  		break;
>  	case ARM_SMCCC_HV_PV_TIME_ST:
>  		gpa = kvm_init_stolen_time(vcpu);
>  		if (gpa != GPA_INVALID)
> -			val = gpa;
> +			val[0] = gpa;
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> +		val[0] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0;
> +		val[1] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1;
> +		val[2] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2;
> +		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> +		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>  		break;
>  	default:
>  		return kvm_psci_call(vcpu);
>  	}
> 
> -	smccc_set_retval(vcpu, val, 0, 0, 0);
> +	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
>  	return 1;
>  }
> --
> 2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
