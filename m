Return-Path: <SRS0=yrt2=6Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18947C47259
	for <kvmarm@archiver.kernel.org>; Sat,  2 May 2020 09:09:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8730D21582
	for <kvmarm@archiver.kernel.org>; Sat,  2 May 2020 09:09:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="qQNwtR0+";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="qQNwtR0+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8730D21582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE28B4B6DE;
	Sat,  2 May 2020 05:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gGomnd9YBPjJ; Sat,  2 May 2020 05:09:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74A0F4B6D7;
	Sat,  2 May 2020 05:09:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 852184B6DB
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 May 2020 05:09:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hdnYFqGCYsBp for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 May 2020 05:09:27 -0400 (EDT)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130082.outbound.protection.outlook.com [40.107.13.82])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8B934B6D7
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 May 2020 05:09:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NBpM4vLQkQdo2i+JbrFsNSNQK5wnxZIzHw2suzRC6M=;
 b=qQNwtR0+GK/25ABzttbhMMF7SqvErPTsT3H3Lity9nmUWXlzTGaSYRKJq1SsUxG/2SeoI8Xk9vhM63UDnVwTvxLeQfs4cm9K6q5Un39hdFvio3pVNRpi5k1rOFvNglHNeY4IHjAw+NbDPBnKhfEbBYIAfW0A1hJRadq6zF6JQA8=
Received: from AM3PR05CA0098.eurprd05.prod.outlook.com (2603:10a6:207:1::24)
 by VI1PR0802MB2272.eurprd08.prod.outlook.com (2603:10a6:800:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Sat, 2 May
 2020 09:09:24 +0000
Received: from AM5EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:207:1:cafe::9d) by AM3PR05CA0098.outlook.office365.com
 (2603:10a6:207:1::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27 via Frontend
 Transport; Sat, 2 May 2020 09:09:24 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT041.mail.protection.outlook.com (10.152.17.186) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20 via Frontend Transport; Sat, 2 May 2020 09:09:23 +0000
Received: ("Tessian outbound 5abcb386707e:v54");
 Sat, 02 May 2020 09:09:22 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d7090e413c09c1e9
X-CR-MTA-TID: 64aa7808
Received: from 1392149b8590.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 CC8A66DC-EAD2-4B9C-9508-0A1780F8D052.1; 
 Sat, 02 May 2020 09:09:17 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1392149b8590.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Sat, 02 May 2020 09:09:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4o2EFsKMHNl9KDNuoQb9asyS9YVgmXJX/MACuWylimpnkUMrE+45ye2qFfiypTEu5+62Y0w5KBj4rcesSkDzoPAGc4UjYUEgcBPT2sBWowKk0UBjJ9SbX4F142E2tYgk7LFRBrxAC9UW/kUXpwve0K61horbQVulFOPHMJTU4K+jGgeAlf1ZXjQIwwdCFhVc9Lb3bE/6Yn+YqKAe6FCBDgW1WGA3yB2ZWWyUm3QyoAFUCDa5DDKKtbNoV/cbO0KXfk2vlfiBw+YD7Aa8a3HEf31lLrYMt1Y9gKy4+p/wWDymUzdtausglN+slDOb02XtvxbIk19n2sPRTeVZoG+Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NBpM4vLQkQdo2i+JbrFsNSNQK5wnxZIzHw2suzRC6M=;
 b=ngwX+O7DSBCfYKwUYtjZBuEBxDl5/nUIMf3OICnnnL2pGD+zJnfk7WFHvWswy/kXNLJI1t8fvQeCxXgIa60tNFiMC0iqu0Lscan6QdwjwDFLvxSs60x+K/2MHKYp23NP+f5xEV1mo7zMKvaiTQaA7c1dhbdBYbVog+o16bM2vqkwpNUrOwFXU8Hfjjwm7uI5KcYsDJQ2sX/VOq9Q3VfWsDwuL3P95bbak1Au6dIjgQkeiu92iggOK1+2JuXJAb4KvnQaXvsAn+hVUizveCMQ4yg9w+Qy2TZJX+hk9dLQFUnXQtIqWo6NFeIYIKFZd6swISSVY0svtIB+024UUhSKpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NBpM4vLQkQdo2i+JbrFsNSNQK5wnxZIzHw2suzRC6M=;
 b=qQNwtR0+GK/25ABzttbhMMF7SqvErPTsT3H3Lity9nmUWXlzTGaSYRKJq1SsUxG/2SeoI8Xk9vhM63UDnVwTvxLeQfs4cm9K6q5Un39hdFvio3pVNRpi5k1rOFvNglHNeY4IHjAw+NbDPBnKhfEbBYIAfW0A1hJRadq6zF6JQA8=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2348.eurprd08.prod.outlook.com (2603:10a6:3:c5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Sat, 2 May
 2020 09:09:14 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.2958.027; Sat, 2 May 2020
 09:09:14 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Thread-Topic: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Thread-Index: AQHWF4xRpK0ubTCCx0eiqM1JOH1VE6iDV3gAgAQ/ngCAAIMxgIAF/0YAgANt2ACAAwwzAA==
Date: Sat, 2 May 2020 09:09:13 +0000
Message-ID: <1d418fdc-1a5c-7723-3d30-448a22faac53@arm.com>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-6-jianyong.wu@arm.com>
 <20200421095736.GB16306@C02TD0UTHF1T.local>
 <ab629714-c08c-2155-dd13-ad25e7f60b39@arm.com>
 <20200424103953.GD1167@C02TD0UTHF1T.local>
 <b53b0a47-1fe6-ad92-05f4-80d50980c587@arm.com>
 <20200430103646.GB39784@C02TD0UTHF1T.local>
In-Reply-To: <20200430103646.GB39784@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3672043e-3ac3-484f-63ad-08d7ee788198
x-ms-traffictypediagnostic: HE1PR0802MB2348:|HE1PR0802MB2348:|VI1PR0802MB2272:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0802MB2272849A6DBD7E61635D473EF4A80@VI1PR0802MB2272.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 039178EF4A
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(6636002)(6512007)(4326008)(6862004)(31696002)(966005)(31686004)(478600001)(36756003)(66946007)(5660300002)(76116006)(86362001)(91956017)(186003)(66476007)(66556008)(64756008)(66446008)(55236004)(71200400001)(37006003)(2616005)(8676002)(54906003)(53546011)(6506007)(2906002)(6486002)(8936002)(26005)(7416002)(316002)(21314003);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: itaKgl9Od6qN5wKW4TU4wmqJvA4B/GNOxCzo3IOUxMc12rbOdQY+yNacCl6zXkvCHz6IybxCQBrhzmFk/5X5yvI8BlQSmoSMRR0Ag2j7U8x+cZvPim/c5FbE/IXlxGhakTPFOTANVVXrKKqdHZDevupEcN1Cq9Z15ZeTKwBnNGGyLsZueuhnztApC0lHxtrqr29VdGdSuKHfB6phj426Q5jy9kzbsnOrxFviD/MLCRbkdMFOg/5pskpmNMs8adddgqFAwahVzgyQB9AOWSdLOHDYOL+z4BU2dhnJml/wpXqhnUc9uvsd2B7L2kqwtu27N5FGFk1kEiOhreEojK9yoBHkvn0BpjrK+Evn7YP80mUdN60U9Z9MY++JaYToWuSbDY5rFDuAQsCqzGtouR47Tz7Zxg6vaQP1329ubphA2JfZvwozbUohU3QpJNPu4LdcBXpg0dJU51TWSulKbQfRmsBDpSkc8FpNjwn4DLT+dxXkTSwy5ZNHd+MKCFcVBnlkcYSvHih8kStxLRr+Juw95b820a8xSYNeWeXGhcfCe0e6hscFm7Y3ywbhqzotWRdm
x-ms-exchange-antispam-messagedata: Pzarievv2D2ov8nTlNNtin5xrV4qSO4QQCrg94omFBluCnKREVG/Vu0EdqqGVCb0esfx8Daq/J+LaDIXoawAJRUlUb/i1CWRguLrPIQSROUgpBl+YjF3x5C/7mgg8jl3jRtJOAN8vQheogTHwtV2DFPRqg3Yk4iLf05hAahDfiWvJNsERB0cnFvJpMq1wk4x+YZ0DDSvC+L8cSp/XjFW1jbeAfP2n8eGO5ZAXPmgAYul3EeESDybjHuVFCK5qYGWyxxNQZDzGinAOb/yWEJTqZwcCJBv1ccJzsRFOjdgzAlgbtmWbJ2qaKcWqH0qBqkjAmNjIkPcPd2JGlbPcOxcYrsOWq1Hq5Z/4/8LUk8FBvaiVPceIDKpaJ0gnU1oZ75qaIQ9iwmC+oLjlIZX3cunURSPkJe/eiY1O+K2OIVzGImfK4ZH9oWn3gMU0B8BlAI4YBJA11kTZUBkB63c0a+KzieVUxLV7f6LNI1LejenX0HFySdbKaN3I//mltbMCoo+NpfyZ1TY1r8UqwoNFoNZK56ltPofJKAdQOsJXKKa5VtV4wmbs9n3beLLdmBxsoThFpohTvKY/iwd4+rnvH21AslSuIL6Gy/+FRZpw+IHa0mACvsefXjy7kNDQ12LG2m0uKK+XpsMJr6ST4pdQU8nu+fDSfnOEfbxTgvTxnPYA+TfAxqDxAoBqOO6pPrq80jrYKlnbqvySnXpsrkn9XTzcaUWh1rcg3e8lEin0PrjScPBPU9qo78c3D4xBbJCV3IvOvBzyx9kiQ81kgRIVrhhUhMKoJAHGZFU5+4TOq2hSaQ=
Content-ID: <24C5D66CA26DA04ABEB7817FA2CB77FE@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2348
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(46966005)(2906002)(6636002)(53546011)(31696002)(6506007)(186003)(86362001)(336012)(36756003)(2616005)(6486002)(6512007)(31686004)(6862004)(26005)(4326008)(82740400003)(81166007)(70586007)(8676002)(70206006)(47076004)(8936002)(356005)(82310400002)(5660300002)(316002)(478600001)(966005)(36906005)(37006003)(54906003)(21314003);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 1a0d667d-2875-4fe6-8a87-08d7ee787c5d
X-Forefront-PRVS: 039178EF4A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hr0iAQXdRgB1buSNQ8CJRIcBNjdqmV8W/1U5n0lGAvY7Kkj3y89KRLCT6b0uYh7dKkAVZ1hRcsFJ96ycXlIbQo2M3AvghEWr8H3XpUkwud9RlKRS7yiEfzzldQmmBYDOdCXOdXD3/kb7pO6julVRhQvcZ16hArw5FFLVGYnxmBmSv3Vqh1kmOxNyY5HEyeyPc8rU/0DWxsOPUqx1xDS0oapNURDgIhqZFSdxsbj4U66f4Iy7ASHMj5aIlyS661FlqOGQEdZ9jMYujRGEzdcex062oLHvUFgvFw8oomXbZfWo+KUF/FYW4bEHoS4bQ8H4zlrdcAMvTzrXImAPAR/reG5dSAkPu1wYoPx+mS8uAn6NlUKFeyFXtt9BSK3L56tWuDYaGDybkkxowJ1Wd1cb6XQPZZnGHghDignLP9V1FcUlDlCpX/cBYWHAvdybHh7m4cMnyNQx+QgWOV4RFpbXUszH2tMgsATf58zUKNTN9Vk6QAbp5QaMg9rGHBCb4aty8S6NaEu3L5tJ2spNO6Sx3Q7s6y3dXRBiOOtbVuffbpj+zotPmX3fE+NR3KInbsxltgyr5MXu0Ifdhi7oaGK1BbBLRYV8mmFs0phkci65F51p9Xx92FUk69rGy9fGEEkH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2020 09:09:23.3098 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3672043e-3ac3-484f-63ad-08d7ee788198
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2272
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

On 2020/4/30 6:36 PM, Mark Rutland wrote:
> On Tue, Apr 28, 2020 at 07:14:52AM +0100, Jianyong Wu wrote:
>> On 2020/4/24 6:39 PM, Mark Rutland wrote:
>>> On Fri, Apr 24, 2020 at 03:50:22AM +0100, Jianyong Wu wrote:
>>>> On 2020/4/21 5:57 PM, Mark Rutland wrote:
>>>>> On Tue, Apr 21, 2020 at 11:23:00AM +0800, Jianyong Wu wrote:
>>>>>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
>>>>>> index 550dfa3e53cd..a5309c28d4dc 100644
>>>>>> --- a/virt/kvm/arm/hypercalls.c
>>>>>> +++ b/virt/kvm/arm/hypercalls.c
>>>>>> @@ -62,6 +66,44 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>>>>     if (gpa != GPA_INVALID)
>>>>>>     val = gpa;
>>>>>>     break;
>>>>>> +/*
>>>>>> + * This serves virtual kvm_ptp.
>>>>>> + * Four values will be passed back.
>>>>>> + * reg0 stores high 32-bit host ktime;
>>>>>> + * reg1 stores low 32-bit host ktime;
>>>>>> + * reg2 stores high 32-bit difference of host cycles and cntvoff;
>>>>>> + * reg3 stores low 32-bit difference of host cycles and cntvoff.
>>>>>> + */
>>>>>> +case ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
>>>>> Shouldn't the host opt-in to providing this to the guest, as with other
>>>>> features?
>>>> er, do you mean that "ARM_SMCCC_HV_PV_TIME_XXX" as "opt-in"? if so, I
>>>> think this
>>>>
>>>> kvm_ptp doesn't need a buddy. the driver in guest will call this service
>>>> in a definite way.
>>> I mean that when creating the VM, userspace should be able to choose
>>> whether the PTP service is provided to the guest. The host shouldn't
>>> always provide it as there may be cases where doing so is undesireable.
>>>
>> I think I have implemented in patch 9/9 that userspace can get the info
>> that if the host offers the kvm_ptp service. But for now, the host
>> kernel will always offer the kvm_ptp capability in the current
>> implementation. I think x86 follow the same behavior (see [1]). so I
>> have not considered when and how to disable this kvm_ptp service in
>> host. Do you think we should offer this opt-in?
> 
> I think taht should be opt-in, yes.

ok, what about adding "CONFIG_ARM64_KVM_PTP_HOST" in kvm_ptp host 
service to implement this "opt-in"?
> 
> [...]
> 
>>> It's also not clear to me what notion of host time is being exposed to
>>> the guest (and consequently how this would interact with time changes on
>>> the host, time namespaces, etc). Having some description of that would
>>> be very helpful.
>>
>> sorry to have not made it clear.
>>
>> Time will not change in host and only time in guest will change to sync
>> with host. host time is the target that time in guest want to adjust to.
>> guest need to get the host time then compute the different of the time
>> in guest and host, so the guest can adjust the time base on the difference.
> 
> I understood that host time wouldn't change here, but what was not clear
> is which notion of host time is being exposed to the guest.
> 
> e.g. is that a raw monotonic clock, or one subject to periodic adjument,
> or wall time in the host? What is the epoch of the host time?

sorry, I misunderstood your last comment.
I think it is one of the key part of kvm_ptp. I have confused with these 
clock time and expect to hear the comments from experts of kernel time 
subsystem like you.
IMO,kvm_ptp targets to sync time in VM with host and if all the VMs in 
the same host do so, they can get time sync from each other. with no 
kvm_ptp, both host and guest may affected by NTP, the time will diverge 
between them. kvm_ptp can avoid this issue. if the host time vary with 
something like NTP adjustment, guest will track this variation with the 
help of kvm_ptp. I acquire these knowledge originally from [2]. also ptp 
driver will compare the wall time(see [3]). so I think wall time clock 
which subject to NTP adjustment is a good choice for kvm_ptp. in the 
current implementation I get the wall time clock from ktime_get_snapshot.

I'm not sure if I give the correct knowledge of kvm_ptp and make a right 
choice of host clock time. So WDYT?

[2]https://opensource.com/article/17/6/timekeeping-linux-vms
[3] see PTP_SYS_OFFSET2 in ptp_ioctl in 
https://github.com/torvalds/linux/blob/master/drivers/ptp/ptp_chardev.c, 
it uses ktime_get_real_ts64 as the host time to calculate the difference 
between ptp time and host time.

Thanks
Jianyong

> 
>> I will add the base principle of time sync service in guest using
>> kvm_ptp in commit message.
> 
> That would be great; thanks!
> 
> Mark.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
