Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F87C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 10:14:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D25BE206FA
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 10:14:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="9Z8CkJfu";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="9Z8CkJfu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D25BE206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3AA64BD46;
	Tue, 24 Nov 2020 05:14:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XQDxP5Hv-1Je; Tue, 24 Nov 2020 05:14:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA684BD86;
	Tue, 24 Nov 2020 05:14:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ECDF4BD4D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 05:14:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HAl-VUzuLEXo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 05:14:37 -0500 (EST)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 278C54BD4C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 05:14:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/Te3bGJdq/nS5Kyt4BmoAvBIKDLvV878/EeuaU4Dqs=;
 b=9Z8CkJfuasxzLlu2vYG65hTy2Ko4cztoc+cIyYr5RjfnSzUHKXaL9yBiZ2In81fb/XDDZIUp3kQATY92iDYdp82v5Pjfydp/RWmgrOMXr2b5p7OmvU0ToaERqleeSkz+FSxBV+mkaYCiuaHOF5BTX2mMVy85/dAcGWzbSX+MPVU=
Received: from DB3PR08CA0015.eurprd08.prod.outlook.com (2603:10a6:8::28) by
 DBBPR08MB6314.eurprd08.prod.outlook.com (2603:10a6:10:20f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.21; Tue, 24 Nov 2020 10:14:33 +0000
Received: from DB5EUR03FT037.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:8:0:cafe::fb) by DB3PR08CA0015.outlook.office365.com
 (2603:10a6:8::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.24 via Frontend
 Transport; Tue, 24 Nov 2020 10:14:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT037.mail.protection.outlook.com (10.152.20.215) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 10:14:33 +0000
Received: ("Tessian outbound e0cdfd2b0406:v71");
 Tue, 24 Nov 2020 10:14:32 +0000
X-CR-MTA-TID: 64aa7808
Received: from 10cc60184369.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 2356AA53-166A-43C4-B4D2-5549FA9A8132.1; 
 Tue, 24 Nov 2020 10:14:27 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 10cc60184369.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 24 Nov 2020 10:14:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/XMK/FiSbn1qJDuQP37B0sEKrT3lymuvMDwJBGsrFXrGxzW+nJadWk+o/4UGMwtfm81Qsnw3VIzqGRDi6Ct4GTGPbvsDxKMvqEfcjg6myew4t3P+jIrYjFyCmSTQddbWJgqGDkGIPk9xmX0NaUdW86JdRZbIu6C67FwTrdezMhR7jvnA+r/g8k/UeQmQWsMqUkOxRPWZ14UYII4JvI7g2GIsTfwgY5MkMcuCDExpqTTTBkUHPk/TOX6rrxRFlrwRHWPKwEWb5LkDmuE32D6PJiL9IUqRP5MoQVid0qAze6TFmAD23nEriJ02jeHy4wPpKhEj91u9bgQGTL1m9QF0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/Te3bGJdq/nS5Kyt4BmoAvBIKDLvV878/EeuaU4Dqs=;
 b=ksnp2LpRw4r90zOC6ubaPtgZs6tEh3JD52RGi0jcIphktGF4Gt3Bev8iTNQ9vjIbFIP98XVtPLsYxnIxzGsYnjacboV8qX2fJmB2vE3k4ELcfX4NN/yOkMXJhiWu5E7LKrVj9XKUr+SJ5P4nHlHhxG8X3cu6In4xXKGLMizsZLbMaDa4irTIJPCBHcgkqHs6TRmSn4Q49paD2aLW+8g5ZPwrJ20g8+DlBZe3UEHFui9K/T0hAz/49L5aZBX5QjJqG5miU41AdOGgdcHcnugWDbMdVltdJ4HhBsabXSe9SxHmllOX9apVPe7b5xhpV0up+DAUgCnrK/t/gn7EdFQTUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/Te3bGJdq/nS5Kyt4BmoAvBIKDLvV878/EeuaU4Dqs=;
 b=9Z8CkJfuasxzLlu2vYG65hTy2Ko4cztoc+cIyYr5RjfnSzUHKXaL9yBiZ2In81fb/XDDZIUp3kQATY92iDYdp82v5Pjfydp/RWmgrOMXr2b5p7OmvU0ToaERqleeSkz+FSxBV+mkaYCiuaHOF5BTX2mMVy85/dAcGWzbSX+MPVU=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB1722.eurprd08.prod.outlook.com (2603:10a6:3:87::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Tue, 24 Nov
 2020 10:14:23 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 10:14:23 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Topic: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Index: AQHWt/MyY3F2SxWQTkCP3WjcSZqyYKnVm0IAgAE1lUCAAEGfAIAAEqEQ
Date: Tue, 24 Nov 2020 10:14:23 +0000
Message-ID: <HE1PR0802MB2555FE5AE7D96B7CB25CBE1EF4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-7-jianyong.wu@arm.com>
 <d409aa1cb7cfcbf4351e6c5fc34d9c7e@kernel.org>
 <HE1PR0802MB255534CF7A04FB5A6CE99A67F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <9133f26699c5fc08d0ea72acfa9aca3b@kernel.org>
In-Reply-To: <9133f26699c5fc08d0ea72acfa9aca3b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: A60D24C566063C40A89C0ABD70FE477F.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c31f2ba0-70a3-4b1e-e15d-08d89061bd33
x-ms-traffictypediagnostic: HE1PR0801MB1722:|DBBPR08MB6314:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB63149A60BC4AAFD0B8268080F4FB0@DBBPR08MB6314.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:139;OLM:139;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: EDtfTunj0vN6JCN2O4bjggD8LZLhIg3bG/zFB+W6Kc8B5dTn9jVCY0XizfOfPAsR4/sQ1uNBXkJlCVI8sv7h3ECZbmFIUTgRSh71PLn4qk0AjMtyz+x0L+J+gYWxoAAL55tnjmiGLnk2AY/L94P1+purolDf5RZI/teDgInd3m++IvnA7DHk+u02Roidd00y8SUiMPC1Kk09dPmT9AGCetGN64u3IQpkyco4iH9UaysFrtY8FhU59REylZwJE0OKMO0rVOfRzTAXqhe64mYb2w/q6PuoEQrUSgo1OUxDJU8Wlr0xJZgLa5wmDFymWiBF2GdUXuGoJzybt2YeT3BAyQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(71200400001)(7416002)(5660300002)(55016002)(9686003)(66556008)(66946007)(76116006)(33656002)(4326008)(4001150100001)(64756008)(8676002)(66446008)(478600001)(66476007)(8936002)(6916009)(86362001)(2906002)(52536014)(6506007)(316002)(54906003)(186003)(7696005)(26005)(53546011)(83380400001);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: u5cja79b+paQXscUANShvwlSIPgo62WPGMpsm5JMyynWPeN5d9+evKk6uqTGMI8iMQnpn5PDlqtaQiNb5DT8bougveRbMHvvgN4NgUlsBdfHg+Z3V/e5oeUkP2NuuLDqoHuOq3ZljLLgAnr8wbXl+2XHLWNiRpm7oRxWGDX+aIKx34Qcri/4ooIgwC0C3u/T3U7MYTRZ7GjwmKXl5iWJ8IU6bQiFQXX6HnCIXjfVRnpHVKhn4nmKBxdFe3Jb/b91qHxeVAKvO4jSqVnSxI21yhCoWdhpyiHMQ0hTvMwze3AxbmCUPu77NAlKuvBige9Q4+1koKknbYfTA2oc+30MEa/MgK6iddwjWggUhF+5i39YT1EpAWky9e9dEwD3OdjIpRh+Lq9AUHw36y6F/4N9DrlB5WZyuC6rPzTj4SQUNQOc6436bkWuySMMvdUE4HSUyBTNczGLG3QYwNImCaUgv6aRhLKP6RqlQByXtAWMaPlODkoDFuXGrTgQCvAR7l0CEzHI09RQ7SkzLXGskeCMxIqrLbTPg5Y18dwKCWcKJEKWbQBwO/Q5X+L/A9xB1ty304K7qgU6/y/DiICHBbm6H82YqxexCSkXm1mQwzGybHjbhYXF4ePgmdCAeLe+EnzUHxFsn5nVo+WwTZ7epRXCVq+k1ay8cDILaFDs1rYAr+uIVGSYO0PInbVNaf1XeaLUoi5qraD5uyJshggGhnOvra59OIK1zgwcCtlSJZrbtLNi2RKjHmezb4I7vL8n3fZU1H67NVRFhmT2s390T4q9Au3hKe6IadlW9R2D+m9II74ihMk2gO60ehyTp6O7P7xwhakFCmWWlfyAqiTrXSNYyZ8eBb/4JtMAruyg3/xfPPlqxQhoD52CpsxSpM1FaE+3TRnTylFG0VgNsi+Cr2ekaQ==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1722
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT037.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: f78ccf59-cdc5-43b5-6e73-08d89061b77b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zA6qRM0NR9IzVvUklqYoQajf+dfOzh3NZlpxp/rKfjAs5iIpg1CPttuGa5Yq+8uypkPtdgpu1iDnK5TW1f8KnXa2c+TqOaxlxnoyQIpqIXsVpSGX7qiruVNa7FHYkydWGZmZ0w2pIiNUDTNCk9PnDSIsDtv74/fNIzfNdsvJdsJ2285j9L9g2zxpZdaE6r8C1jAk8CXvb0tyMeG9WrmMIcBR0cLR2IIqAiKHgEWiaB+2G+C0HILTJK8Tk+g+3AIJiHN/DvjsjQb3d7AZtGAGQZL9DGozgRU/b8JdHNHFpJ9V1QjHoAojgzx9aqUf7SsCQmLVQrNEAZEo8nxoQLnKPPdTS6CMuIFBDllTT2Kbuk5BOiMMpPJO3AJBUR9xJ/Exqd1Olzy2wZrI+1FKXb/2PA==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(46966005)(336012)(186003)(26005)(6506007)(83380400001)(55016002)(7696005)(9686003)(53546011)(52536014)(356005)(54906003)(8936002)(4001150100001)(82310400003)(478600001)(70206006)(82740400003)(47076004)(316002)(5660300002)(4326008)(81166007)(2906002)(33656002)(8676002)(6862004)(86362001)(70586007);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 10:14:33.3366 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c31f2ba0-70a3-4b1e-e15d-08d89061bd33
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT037.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6314
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
> Sent: Tuesday, November 24, 2020 5:07 PM
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
> Subject: Re: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
> 
> On 2020-11-24 05:20, Jianyong Wu wrote:
> > Hi Marc,
> 
> [...]
> 
> >> > +/* ptp_kvm counter type ID */
> >> > +#define ARM_PTP_VIRT_COUNTER			0
> >> > +#define ARM_PTP_PHY_COUNTER			1
> >> > +#define ARM_PTP_NONE_COUNTER			2
> >>
> >> The architecture definitely doesn't have this last counter.
> >
> > Yeah, this is just represent no counter data needed from guest.
> > Some annotation should be added here.
> 
> I'd rather you remove it entirely, or explain why you really cannot do without
> a fake counter.

OK, I will remove it.

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
