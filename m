Return-Path: <SRS0=hKGY=6M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8491C83004
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 06:15:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5619920730
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 06:15:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="d+/5Z0xP";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="d+/5Z0xP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5619920730
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F5A4B202;
	Tue, 28 Apr 2020 02:15:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fosHO+rUsxmY; Tue, 28 Apr 2020 02:15:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A3884B221;
	Tue, 28 Apr 2020 02:15:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11F544B202
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 02:15:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yzyvf6icu+w5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2020 02:15:05 -0400 (EDT)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr140073.outbound.protection.outlook.com [40.107.14.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DC974B161
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 02:15:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPr3Vr6TWZPdPtYl0j8ft01290WNWZw8bWF3tmEpssk=;
 b=d+/5Z0xP50CUQhVyU6d+OvAVGmDR8gyXn9sz8o/7EM3qNHalkg8o4OC6FC4buTqXeV3nqS10XtWbP89jwN+bD2xEjAEr2DfqNL8uo7gyYfzng5NKYAV5ipG28QYZ6RTPbfgwSi9nz3nO8xIM4haE1ymynOHUMol4JI1aGIZGvGw=
Received: from AM7PR02CA0024.eurprd02.prod.outlook.com (2603:10a6:20b:100::34)
 by VI1PR08MB4525.eurprd08.prod.outlook.com (2603:10a6:803:101::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 06:15:01 +0000
Received: from AM5EUR03FT059.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:100:cafe::2f) by AM7PR02CA0024.outlook.office365.com
 (2603:10a6:20b:100::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Tue, 28 Apr 2020 06:15:01 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT059.mail.protection.outlook.com (10.152.17.193) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Tue, 28 Apr 2020 06:15:01 +0000
Received: ("Tessian outbound fb9de21a7e90:v54");
 Tue, 28 Apr 2020 06:15:00 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f629d18fc52ee4c7
X-CR-MTA-TID: 64aa7808
Received: from 0290c1ce7e80.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 1E74BF0C-578F-4E27-83C3-AE9C8BF93A20.1; 
 Tue, 28 Apr 2020 06:14:55 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0290c1ce7e80.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 28 Apr 2020 06:14:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+wjXmdEL69azDzg4CpxBCs2yb7LetkkslG/jB0xi6ZkH02U0GU8cy/IXfVjH385BcOk7sS0sgeO82J8K23XfYbSBTeO3Km4mWAnuIlcKoQa8W2fyKzDnlTTdtiaup0CHiGYYQ5ge4QwCA9lKnLCryQgPnjA3sQH6VcwBqRHg/bFMG4MecoZhbGLdmYDBfDOvie0vd4XVu1j2AiCMAo0Qt9gdlffdg1h4Y0oT7h3VhwqCCA1g9QDZE5kkOKGDpHjYZBlKgp5HMYwdYABDmD8xVUxAVPn+R9n+f1GttvwaHizArDAvDO2UfJO+4riiGYb2b/oSOFAQu3xt4FI0HrPxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPr3Vr6TWZPdPtYl0j8ft01290WNWZw8bWF3tmEpssk=;
 b=oSlWzLcMKRHaTeQ2Edx9dlSZ1AdCSwIJRjs5KxX18eWH/G9X7YsUJdRQOfjjntt6FGTkFAgU9H1un5pKxUb28TGJLFFjz+PebxT/XZLaCSbZjbTBaqtAPB3GVfcPwhvp6oTGy50P27uiNkDqH89CX9vC4q05gIkXW/UiKiYie7CtUWnTI4yQtEWeZCdL5CIQH8QTtJbG6jOpCE0LhAEYMgtkrt1qsNWnLnIQxGZT3IH9lANRVLe6lgX9NnhmTwuqlu5cL40PuM02+k0TSro3jJH4MNLKNRHpk/ZUKV1bNVOLIdvXG17om4HL2u9WXOxzjBHwtATqE0l3EgaW016+Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPr3Vr6TWZPdPtYl0j8ft01290WNWZw8bWF3tmEpssk=;
 b=d+/5Z0xP50CUQhVyU6d+OvAVGmDR8gyXn9sz8o/7EM3qNHalkg8o4OC6FC4buTqXeV3nqS10XtWbP89jwN+bD2xEjAEr2DfqNL8uo7gyYfzng5NKYAV5ipG28QYZ6RTPbfgwSi9nz3nO8xIM4haE1ymynOHUMol4JI1aGIZGvGw=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2409.eurprd08.prod.outlook.com (2603:10a6:3:dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 06:14:52 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 06:14:52 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Thread-Topic: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Thread-Index: AQHWF4xRpK0ubTCCx0eiqM1JOH1VE6iDV3gAgAQ/ngCAAIMxgIAF/0YA
Date: Tue, 28 Apr 2020 06:14:52 +0000
Message-ID: <b53b0a47-1fe6-ad92-05f4-80d50980c587@arm.com>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-6-jianyong.wu@arm.com>
 <20200421095736.GB16306@C02TD0UTHF1T.local>
 <ab629714-c08c-2155-dd13-ad25e7f60b39@arm.com>
 <20200424103953.GD1167@C02TD0UTHF1T.local>
In-Reply-To: <20200424103953.GD1167@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f936ec9a-8120-4b15-2f76-08d7eb3b7bf6
x-ms-traffictypediagnostic: HE1PR0802MB2409:|HE1PR0802MB2409:|VI1PR08MB4525:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB45253BC75398F1463B5ED2CAF4AC0@VI1PR08MB4525.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 0387D64A71
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(66556008)(66946007)(66446008)(91956017)(76116006)(66476007)(64756008)(37006003)(2616005)(54906003)(2906002)(316002)(7416002)(5660300002)(71200400001)(36756003)(6862004)(6636002)(31686004)(31696002)(6486002)(26005)(8676002)(966005)(186003)(8936002)(81156014)(478600001)(86362001)(6512007)(4326008)(6506007)(53546011)(55236004)(21314003);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: k0YuxqipcGgklTBhUmRLYgbAR9JQQtES+5mTXORWXOox85LnwOVfxpgo2acKI3T3dxKxvBfv1vJgYyKGClyPuMjizVYSTJBywEFfOZzYXa3nX8H8HiuD4zaZApKiKDIY/kaGfP2RjkBtjY6YwqMxmKrOZAcXmSgkSFsm8HC99K+nzVX7TGPl39v+SuV4px2lqUF9eMsQGuXrNGs3bqrTsgOaCDdUsSjmIkS7euy82WQ/au9sGtZGhZqllwt4Fd4FXvDr7GGkfHpGtsOXWMDoKfpUvzzGeUVdWSQEatHTKyTDs1Gejvy1C6fK9D2P5ZPHQFeXxzWFFSa9nx9XEuRnjknkr5yGRzbo0u3WGcl+FrVDbjrXU5LXAtIVopahYvdnufJC8HuEwPW1u/rsVfCiDvUEjPe06xzRaorUkJM3csyIhrQhHzk/6ybxX7tn8ly+yaTfFmDJVjbKcPypFWJEQMAzee2+AeSknaxq0S0VHv5OonwpBFeVRTo1GT+f8lUqJL5FBAGT0nhKO6kb2M1UYyqw5Y2PEGLGlbV3FdDbXyvBl4tzojZ26fi+jo3PLnYQ
x-ms-exchange-antispam-messagedata: iMUI5KkIEXOFBX7wprG2+LOR3xr8PEteplyfSvkzw9VX9yHGQFmapxMu41v2OW5iEBdJHIs+6J79WKdzkiBjzj+grRSpF65M2yf16hVQ9vjv+Mti3QGMjmxHXSgtSSc3R4FjfB+BrHxwMWDmseJpROhD2tuh1D1vLn4Vq9Vnfth26LT3kH3QSrcDMFFdZ2xK0mgSY8u2wIJ5aAy6P+96nj/lNfQ3dwsihHb0J6sdBxeB8ApAmlouhgLPhwDk1UsymI56f8ZIOKXjF1Vh3rg/EOmIXcGiba3ZXvP1fC/6+Zk8DboPvXfJrbSl5CCL4qfHm879wxJXktpNk/PrdNS0jBAmjca69KYhR9G7q2xZxrgoAVRgUq0Yccqx86bOcd7xyONTO2lFAFsHTxw+pb+BCiI1I5GvwPHNs4RdAzXSJEvwTQPziaMcxma9isMXXP9Wh9XrI0ZClajrvpvABXOhg9nq1jg9oCk7PcIHzHsSzIvK/8LlrgsXOPap95TwYMwJV0GzSWyz/bjjqeKE8lXQMr1qVWWAGzXFlM9PexNp1TrNUlfJmxzArIn6kO8/vKXCNGYK7GlnlhL7A75Q0yjpDkLkqW/gyyiV9v2vYQFOVUTSdcxfgHc/xao13Geh/ngYsbmudZCf0n+TdjnKJZExsLn2cFFrEBmX8e7IQHQuD68TE6dQFy7c88PO0hnXZP/gINZ1l9jSYt0rmh/tFpRC3WO1QxNklDsOGow1ocOiFxe62fYwVAzOskz7eT4ZaDlK26xItn6bBuqLlYPbHSLll20HyvhrbI+y5jM19sEvo5k=
Content-ID: <457310EB5B4E5C4C8A3486656E7C6391@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2409
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT059.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(46966005)(6636002)(6862004)(4326008)(336012)(82740400003)(36756003)(6512007)(2616005)(81166007)(82310400002)(356005)(2906002)(70586007)(6486002)(70206006)(6506007)(54906003)(31686004)(316002)(8676002)(53546011)(86362001)(5660300002)(47076004)(966005)(37006003)(26005)(478600001)(186003)(81156014)(31696002)(36906005)(8936002)(21314003);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: b4aceafe-ef1e-4932-5afd-08d7eb3b76c4
X-Forefront-PRVS: 0387D64A71
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VLDp4YD97sZYCSSEJOdKLXG4S3Y4JLB2XJnSwpTmcaP3TwCXCm0RPDNKenJDGuFQKEGnYyen+NGY1i34tIk+YPLNpH6JKIFveFv+HEoF1Go5NyK2uXSU47VkkKHHB7aRCGeG5imgxUowjKVHgoXLca4SJBWrepMfw0/mtztBV2vZHo9lBY5IJGZ5jDNHbkeX6CSSIa4Dvs3Q9M3Wv76oEFya3mC0POLo0H5+Qa8D9ND5fD/PMPNUmjUGiiuznt9UGPB5zbH6PqhLpKfLjM/nih/UM5qbbR4UYLTp/0e9mFBaMnoeq6FK0a23FyxDju9QxokKEuJvhOV1sJ8kdYUHORm88gf8anNI4YvkSE12Rzw1Nx/G2xd0uYL0vMPr4OoOkbQnwhdV0QErLpNdX17NiXUQKbCkgxiHeUN+23nf+iBjiwMYELHEmpoN2KmwAFF7NIUQoPuxf0+6Tzr1F9gpVzK2nTNEBwFukTJuxYHCk6viavbQA8tCUYG1ueo8dyUjsP4h/U/S/qxem0wLYtz6BMdP64vS2ozgSKUUjPHehI1QmawnbbuWhOx1efc/Br+KAYQbNGKVU9g+u2J8Lqx4PSBp1Wgj46lwPapJIg3R6pA=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 06:15:01.0765 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f936ec9a-8120-4b15-2f76-08d7eb3b7bf6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4525
Cc: "maz@kernel.org" <maz@kernel.org>, Justin He <Justin.He@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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

On 2020/4/24 6:39 PM, Mark Rutland wrote:

it's a resend of the last email, please ignore if you have received this.

Hi Mark,

thank you for remainder, I hope this email is in the correct format.

> On Fri, Apr 24, 2020 at 03:50:22AM +0100, Jianyong Wu wrote:
>> On 2020/4/21 5:57 PM, Mark Rutland wrote:
>>> On Tue, Apr 21, 2020 at 11:23:00AM +0800, Jianyong Wu wrote:
>>>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
>>>> index 550dfa3e53cd..a5309c28d4dc 100644
>>>> --- a/virt/kvm/arm/hypercalls.c
>>>> +++ b/virt/kvm/arm/hypercalls.c
>>>> @@ -62,6 +66,44 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>>    if (gpa != GPA_INVALID)
>>>>    val = gpa;
>>>>    break;
>>>> +/*
>>>> + * This serves virtual kvm_ptp.
>>>> + * Four values will be passed back.
>>>> + * reg0 stores high 32-bit host ktime;
>>>> + * reg1 stores low 32-bit host ktime;
>>>> + * reg2 stores high 32-bit difference of host cycles and cntvoff;
>>>> + * reg3 stores low 32-bit difference of host cycles and cntvoff.
>>>> + */
>>>> +case ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
>>> Shouldn't the host opt-in to providing this to the guest, as with other
>>> features?
>> er, do you mean that "ARM_SMCCC_HV_PV_TIME_XXX" as "opt-in"? if so, I
>> think this
>>
>> kvm_ptp doesn't need a buddy. the driver in guest will call this service
>> in a definite way.
> I mean that when creating the VM, userspace should be able to choose
> whether the PTP service is provided to the guest. The host shouldn't
> always provide it as there may be cases where doing so is undesireable.
>
I think I have implemented in patch 9/9 that userspace can get the info 
that if the host offers the kvm_ptp service. But for now, the host 
kernel will always offer the kvm_ptp capability in the current 
implementation. I think x86 follow the same behavior (see [1]). so I 
have not considered when and how to disable this kvm_ptp service in 
host. Do you think we should offer this opt-in?

[1] kvm_pv_clock_pairing() in 
https://github.com/torvalds/linux/blob/master/arch/x86/kvm/x86.c

>>>> +/*
>>>> + * system time and counter value must captured in the same
>>>> + * time to keep consistency and precision.
>>>> + */
>>>> +ktime_get_snapshot(&systime_snapshot);
>>>> +if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
>>>> +break;
>>>> +arg[0] = upper_32_bits(systime_snapshot.real);
>>>> +arg[1] = lower_32_bits(systime_snapshot.real);
>>> Why exactly does the guest need the host's real time? Neither the cover
>>> letter nor this commit message have explained that, and for those of us
>>> unfamliar with PTP it would be very helpful to know that to understand
>>> what's going on.
>> oh, sorry, I should have added more background knowledge here.
>>
>> just give some hints here:
>>
>> the kvm_ptp targets to sync guest time with host. some services in user
>> space
>>
>> like chrony can do time sync by inputing time(in kvm_ptp also clock
>> counter sometimes) from
>>
>> remote clocksource(often network clocksource). This kvm_ptp driver can
>> offer a interface for
>>
>> those user space service in guest to get the host time to do time sync
>> in guest.
> I think it would be very helpful for the commit message and/or cover
> letter to have a high-level desctiption of what PTP is meant to do, and
> an outline of the algorithmm (clearly splitting the host and guest
> bits).

ok, I will add high-level principle of kvm_ptp in commit message.

> It's also not clear to me what notion of host time is being exposed to
> the guest (and consequently how this would interact with time changes on
> the host, time namespaces, etc). Having some description of that would
> be very helpful.

sorry to have not made it clear.

Time will not change in host and only time in guest will change to sync 
with host. host time is the target that time in guest want to adjust to. 
guest need to get the host time then compute the different of the time 
in guest and host, so the guest can adjust the time base on the difference.

I will add the base principle of time sync service in guest using 
kvm_ptp in commit message.


Thanks

Jianyong

> Thanks,
> Mark.


-->
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
