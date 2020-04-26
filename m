Return-Path: <SRS0=8W4i=6K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D81BC2BA1A
	for <kvmarm@archiver.kernel.org>; Sun, 26 Apr 2020 05:02:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACFEA2074F
	for <kvmarm@archiver.kernel.org>; Sun, 26 Apr 2020 05:02:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="ZqnVYdz8";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="ZqnVYdz8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACFEA2074F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 025D74B142;
	Sun, 26 Apr 2020 01:02:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3InTucPwklHK; Sun, 26 Apr 2020 01:02:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A1F94B0FA;
	Sun, 26 Apr 2020 01:02:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BA314B0FA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Apr 2020 01:02:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7wQVRbprCrLs for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 Apr 2020 01:02:36 -0400 (EDT)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2075.outbound.protection.outlook.com [40.107.20.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E6434B0E7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Apr 2020 01:02:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGpU5QInuQeGmJBko4qLhEULEinS+3LwactJLhP5+1s=;
 b=ZqnVYdz8rXmunm1yaj5uA5gXpx2iua2bzDi6S//QDoducl25aEXyH/RXZimJPAbB5ITL7/ZVeoWxc8AgWi/hFLrLDvBzxXFpOLXIeUx3NMYgoe60o4OBO+WF315en1DyhbZh+f28yanC6bs6ULjEjcfq5rgJi/J/qBF49pELK+A=
Received: from AM6PR05CA0019.eurprd05.prod.outlook.com (2603:10a6:20b:2e::32)
 by VE1PR08MB5263.eurprd08.prod.outlook.com (2603:10a6:803:116::27)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Sun, 26 Apr
 2020 05:02:34 +0000
Received: from VE1EUR03FT039.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:2e:cafe::49) by AM6PR05CA0019.outlook.office365.com
 (2603:10a6:20b:2e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Sun, 26 Apr 2020 05:02:34 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT039.mail.protection.outlook.com (10.152.19.196) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Sun, 26 Apr 2020 05:02:32 +0000
Received: ("Tessian outbound 567b75aed2b9:v54");
 Sun, 26 Apr 2020 05:02:32 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 9023903f6c922ded
X-CR-MTA-TID: 64aa7808
Received: from 4acd5a481e9d.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 DDE8CD0F-4C49-4A20-A7D7-D7EAD8DFEB3F.1; 
 Sun, 26 Apr 2020 05:02:26 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 4acd5a481e9d.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Sun, 26 Apr 2020 05:02:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5gTRVbBV5mTNu6wpyAkalgWPMyfdcUervlqj76nFRDyvy6MIhPm39vY9RfIkslr98S0IY5AGg0iArh7pHMHzHRblq20iQaC9rQcF16ekfv4DJIrR7rrCTahfEQ/L9fC8zcPcPmV4kKfNXeDojenqMWpgeLAjbcUdL4f4BMj3zoydXV+dP4JONB75Ue/VIvwlCdGJvNRqNRQ4mzU6lCxhJ+UgyvhHbGf3GyF09yYDWTfe9vPL8InRlAmXR0lL+TQpVoptp1Kg2+3sIT0/aXJrwtkoHYQVWaXgNXBoQAycbDbUybbNQVGFwDCRnil/3uZoGBeif8Amy7v34nZ0920+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGpU5QInuQeGmJBko4qLhEULEinS+3LwactJLhP5+1s=;
 b=FTpKIiNFxsE83QoshGckN8CbnEgjUJdZhV2IWs62rytxhfuts2SePyAc0iBu8SmHnH4bZ943PXxGCTkq6EqwlsqPco09UgH2a7rAE3nk0aSyY7hAk9xxWqGPtlRl3Fpo8RUCpZqnJtP/K+tZM0TGtV9+/LJoICLGApPpwFMkakJPd7ZTATAKlyxC6kUj7KoFPRpTAx6g6qYvoAkECsiVlk88GK5iySGYUthLU0SrD16Shg60gx7dDz2SoxeSA+jw7xIMzOAeXEi40e35mIe8dDIDf+lQI6YHgbFGaVdZnnktjomiaHDmc4zrvOX2Jl4SchYwBQ2YZpkEC8P2K+cNFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGpU5QInuQeGmJBko4qLhEULEinS+3LwactJLhP5+1s=;
 b=ZqnVYdz8rXmunm1yaj5uA5gXpx2iua2bzDi6S//QDoducl25aEXyH/RXZimJPAbB5ITL7/ZVeoWxc8AgWi/hFLrLDvBzxXFpOLXIeUx3NMYgoe60o4OBO+WF315en1DyhbZh+f28yanC6bs6ULjEjcfq5rgJi/J/qBF49pELK+A=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2217.eurprd08.prod.outlook.com (2603:10a6:3:c4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Sun, 26 Apr
 2020 05:02:23 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.2937.020; Sun, 26 Apr 2020
 05:02:23 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Thread-Topic: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Thread-Index: AQHWF4xRpK0ubTCCx0eiqM1JOH1VE6iDV3gAgAQ/ngCAAIMxgIACxluA
Date: Sun, 26 Apr 2020 05:02:23 +0000
Message-ID: <b005e2c8-ed9f-3dc6-dbfa-5e6db5183f3c@arm.com>
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
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb1c40a1-0db2-4594-b795-08d7e99f076f
x-ms-traffictypediagnostic: HE1PR0802MB2217:|HE1PR0802MB2217:|VE1PR08MB5263:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB5263D1B6836DA3DA1EC5016DF4AE0@VE1PR08MB5263.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;OLM:8273;
x-forefront-prvs: 03853D523D
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(376002)(39850400004)(136003)(346002)(366004)(396003)(31696002)(53546011)(91956017)(76116006)(86362001)(6486002)(6512007)(6862004)(36756003)(316002)(4326008)(37006003)(64756008)(66476007)(66556008)(66446008)(66946007)(54906003)(6636002)(71200400001)(2906002)(7416002)(6506007)(55236004)(5660300002)(8676002)(26005)(2616005)(8936002)(186003)(31686004)(478600001)(81156014)(21314003);
 DIR:OUT; SFP:1101; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: gfXyf8PSzsx+t8rZHiUAv9nzTmGF48u2wH+5YoGX7SbkLczyzL9Y/uljOk6gDW56k3uFOJn4eWpq1uBA8HhjWxOWXxtROfD4Q+OCBdnsmnphmkt6YJgAtpYziHeXKEIpCGxQMFA5wPBqfD2iogHlDBNJ0ZL30dJUrMEqKLovnToUbaRO0O9rRgWl8G4FmEN9IPhc1tICMovmtnkHqP9QuBllf3HBbg0xTXQyi4nPSAOHlR6hczM4jvRGpfarU1hwVQB5br1hQSAI5Y378rBkPLvmBrDci9u8d00g9UZHw++T0b8fJP3Mh90O5Bw6CgJfm5Pw7KyUxZAXcsxmt+Xs/LR8SWxle3qvb0uG5/O6JAlXrTXSg9ptqzihD45s/xOPWFiHInmOF1EMgOXI5V6QTOuz9l80jTIFdNgPnp3/LbejUCEMB61vdYDgZyaNCgD1Ks/IURZmR+OR2fORpwmmXpVFrbLpS9d/g+StzkIC2sYn/QhXmC7SrffR9s+axoHv
x-ms-exchange-antispam-messagedata: 0Y6bez5irNuxsZ+3xPazsEK7mAVGjGR2o5ONlhJqyddUlUsKFfZaPCZJ7IhBUEF8CpN8KJWRPQR6+b6aluuVtkGHQutLfOPbWhsBCqotdWDPCw0GwTbdqXQiTdtjA5ZNB4u5uIy4RBSBvozq53ddqB7YSbwegyEWleilPzSkJe0BEscr4ecazoasZS3w/rjGcYGDmkY5P7opng2JOdf1aEgk/wWzW+0vdpwx+nCPxsEiJI1dnfilPoRNMsHHH3Sne3CRUaMi8vS40VxsCqb5jXh/3yOSpJD61CyTR5Gks0wrJCm0BY9rYnlFwv0umhGIo2L+WXY9q3t+FhGMUA16k6b550uT8dYBhDw+f/t9MPkr0hy1yLpsVcTwOTrYgj6iZhaCZ6I6sChHsUNrVJ3TePLEV5G0yZL7IRfkgwntRN35Y5CSzv6y4sHGDK61ZIdUxRSLQqSdqVTHhvysR9cAJvkDm0v+GlrhECOMFNkZJlV4F7BkL1sRoNNq/elSeJsWtjtUxkgHJcGG8844zUJr5sqgx9Zk+AuWb918/QrWMQZoAdrYosE6Wu7A2gGJ3qYzAtxGkZSWXbjqYX1PjX7EFOHuOxqi86qhC3yRUuCcq8x2msmSGGT47VLn/Jmo+7CflF+Vzn3IZOLSTMy637rE7UiIN0iiVG8BjCzQl0SPMovDE0kG0lTICu0SS1iVRE6ucjB1Ie4ct0fiJvQKhIyVbbwbXZEeBODDPS8hgMDdB+DqCrFh2pmrjcOco1fbDPX5SRP4gbZRu78q2Z2ZK2GGk7j+UDw7v5fmV/9/fBaGgtc=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2217
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT039.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(346002)(396003)(376002)(136003)(39850400004)(46966005)(36906005)(5660300002)(47076004)(81166007)(31686004)(6862004)(4326008)(356005)(186003)(26005)(6486002)(6506007)(33964004)(82740400003)(82310400002)(54906003)(6512007)(53546011)(37006003)(336012)(6636002)(2616005)(36756003)(8936002)(70586007)(316002)(45080400002)(86362001)(31696002)(2906002)(478600001)(8676002)(81156014)(70206006)(21314003);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 91ae3afe-28ab-453f-fe90-08d7e99f01d0
X-Forefront-PRVS: 03853D523D
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mVbGQc0sImQW183xHE7j/wSjdaltfXlfR8X/SJ+bxsFse/w64jKjCw22fpaE9rpFzYIweAH/F/KNVUqy0+YurAiRpgBDVJ311SMOd6XAY/HoLxMxLMDaL2r1EUnY9a3djHtdQIqrfbSGBIxnyYe42hsWanELq+AQMCfLfpq72nudXMbuaMPyaZko3EftFQrjEvNMi8tI8QQlAsQQt9yBpL6omOusCtBK3Q1t/yyYpkKNHPHe5HjcZaz5RumcLTCXuJu8GJOekU2R2sw+L48DrAZeNTBqdHBPsTJ/k8fgJ/T/mrOdPOYkF+OFWtcknZA81bNqffW5i8RTN+XASUVqVHzxxkG+zvvJtBoQriMhCX3n460wA6OMqwV1Qv3av78dYYwuDB1g7+EsXw8WbBewxGqCke5cXhrgJAiPnadOZzz8o1ykAlAQR7mpOfbiv7RhC1v9VNMqGiSZk5OGlUEm+8k7Jx3GEtowUmd29KhkzfuqyGD1jSG1TDvijO12SULIoV5PI4Z5CFRuesF+cCRNAqYH4nV9maRQdZzCFr+Ex4c=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2020 05:02:32.8719 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1c40a1-0db2-4594-b795-08d7e99f076f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5263
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
Content-Type: multipart/mixed; boundary="===============5480819594048221605=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============5480819594048221605==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_b005e2c8ed9f3dc6dbfa5e6db5183f3carmcom_"

--_000_b005e2c8ed9f3dc6dbfa5e6db5183f3carmcom_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjAyMC80LzI0IDY6MzkgUE0sIE1hcmsgUnV0bGFuZCB3cm90ZToNCg0KT24gRnJpLCBBcHIg
MjQsIDIwMjAgYXQgMDM6NTA6MjJBTSArMDEwMCwgSmlhbnlvbmcgV3Ugd3JvdGU6DQoNCg0KT24g
MjAyMC80LzIxIDU6NTcgUE0sIE1hcmsgUnV0bGFuZCB3cm90ZToNCg0KDQpPbiBUdWUsIEFwciAy
MSwgMjAyMCBhdCAxMToyMzowMEFNICswODAwLCBKaWFueW9uZyBXdSB3cm90ZToNCg0KDQpkaWZm
IC0tZ2l0IGEvdmlydC9rdm0vYXJtL2h5cGVyY2FsbHMuYyBiL3ZpcnQva3ZtL2FybS9oeXBlcmNh
bGxzLmMNCmluZGV4IDU1MGRmYTNlNTNjZC4uYTUzMDljMjhkNGRjIDEwMDY0NA0KLS0tIGEvdmly
dC9rdm0vYXJtL2h5cGVyY2FsbHMuYw0KKysrIGIvdmlydC9rdm0vYXJtL2h5cGVyY2FsbHMuYw0K
DQoNCg0KDQoNCkBAIC02Miw2ICs2Niw0NCBAQCBpbnQga3ZtX2h2Y19jYWxsX2hhbmRsZXIoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1KQ0KICBpZiAoZ3BhICE9IEdQQV9JTlZBTElEKQ0KICB2YWwgPSBn
cGE7DQogIGJyZWFrOw0KKy8qDQorICogVGhpcyBzZXJ2ZXMgdmlydHVhbCBrdm1fcHRwLg0KKyAq
IEZvdXIgdmFsdWVzIHdpbGwgYmUgcGFzc2VkIGJhY2suDQorICogcmVnMCBzdG9yZXMgaGlnaCAz
Mi1iaXQgaG9zdCBrdGltZTsNCisgKiByZWcxIHN0b3JlcyBsb3cgMzItYml0IGhvc3Qga3RpbWU7
DQorICogcmVnMiBzdG9yZXMgaGlnaCAzMi1iaXQgZGlmZmVyZW5jZSBvZiBob3N0IGN5Y2xlcyBh
bmQgY250dm9mZjsNCisgKiByZWczIHN0b3JlcyBsb3cgMzItYml0IGRpZmZlcmVuY2Ugb2YgaG9z
dCBjeWNsZXMgYW5kIGNudHZvZmYuDQorICovDQorY2FzZSBBUk1fU01DQ0NfSFlQX0tWTV9QVFBf
RlVOQ19JRDoNCg0KDQpTaG91bGRuJ3QgdGhlIGhvc3Qgb3B0LWluIHRvIHByb3ZpZGluZyB0aGlz
IHRvIHRoZSBndWVzdCwgYXMgd2l0aCBvdGhlcg0KZmVhdHVyZXM/DQoNCg0KDQplciwgZG8geW91
IG1lYW4gdGhhdCAiQVJNX1NNQ0NDX0hWX1BWX1RJTUVfWFhYIiBhcyAib3B0LWluIj8gaWYgc28s
IEkNCnRoaW5rIHRoaXMNCg0Ka3ZtX3B0cCBkb2Vzbid0IG5lZWQgYSBidWRkeS4gdGhlIGRyaXZl
ciBpbiBndWVzdCB3aWxsIGNhbGwgdGhpcyBzZXJ2aWNlDQppbiBhIGRlZmluaXRlIHdheS4NCg0K
DQoNCkkgbWVhbiB0aGF0IHdoZW4gY3JlYXRpbmcgdGhlIFZNLCB1c2Vyc3BhY2Ugc2hvdWxkIGJl
IGFibGUgdG8gY2hvb3NlDQp3aGV0aGVyIHRoZSBQVFAgc2VydmljZSBpcyBwcm92aWRlZCB0byB0
aGUgZ3Vlc3QuIFRoZSBob3N0IHNob3VsZG4ndA0KYWx3YXlzIHByb3ZpZGUgaXQgYXMgdGhlcmUg
bWF5IGJlIGNhc2VzIHdoZXJlIGRvaW5nIHNvIGlzIHVuZGVzaXJlYWJsZS4NCg0KDQoNCkkgdGhp
bmsgSSBoYXZlIGltcGxlbWVudGVkIGluIHBhdGNoIDkvOSB0aGF0IHVzZXJzcGFjZSBjYW4gZ2V0
IHRoZSBpbmZvIHRoYXQgaWYgdGhlIGhvc3Qgb2ZmZXJzIHRoZSBrdm1fcHRwIHNlcnZpY2UuIEJ1
dCBmb3Igbm93LCB0aGUgaG9zdCBrZXJuZWwgd2lsbCBhbHdheXMgb2ZmZXIgdGhlIGt2bV9wdHAg
Y2FwYWJpbGl0eSBpbiB0aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbi4gSSB0aGluayB4ODYgZm9s
bG93IHRoZSBzYW1lIGJlaGF2aW9yIChzZWUgWzFdKS4gc28gSSBoYXZlIG5vdCBjb25zaWRlcmVk
IHdoZW4gYW5kIGhvdyB0byBkaXNhYmxlIHRoaXMga3ZtX3B0cCBzZXJ2aWNlIGluIGhvc3QuIERv
IHlvdSB0aGluayB3ZSBzaG91bGQgb2ZmZXIgdGhpcyBvcHQtaW4/DQo=

--_000_b005e2c8ed9f3dc6dbfa5e6db5183f3carmcom_
Content-Type: text/html; charset="utf-8"
Content-ID: <32A0C9E11781574EB47056DB2A9FE30C@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64

PGh0bWw+DQo8aGVhZD4NCjxtZXRhIGh0dHAtZXF1aXY9IkNvbnRlbnQtVHlwZSIgY29udGVudD0i
dGV4dC9odG1sOyBjaGFyc2V0PXV0Zi04Ij4NCjwvaGVhZD4NCjxib2R5Pg0KPGRpdiBjbGFzcz0i
bW96LWNpdGUtcHJlZml4Ij5PbiAyMDIwLzQvMjQgNjozOSBQTSwgTWFyayBSdXRsYW5kIHdyb3Rl
Ojxicj4NCjwvZGl2Pg0KPGJsb2NrcXVvdGUgdHlwZT0iY2l0ZSIgY2l0ZT0ibWlkOjIwMjAwNDI0
MTAzOTUzLkdEMTE2N0BDMDJURDBVVEhGMVQubG9jYWwiPg0KPHByZSBjbGFzcz0ibW96LXF1b3Rl
LXByZSIgd3JhcD0iIj5PbiBGcmksIEFwciAyNCwgMjAyMCBhdCAwMzo1MDoyMkFNICYjNDM7MDEw
MCwgSmlhbnlvbmcgV3Ugd3JvdGU6DQo8L3ByZT4NCjxibG9ja3F1b3RlIHR5cGU9ImNpdGUiPg0K
PHByZSBjbGFzcz0ibW96LXF1b3RlLXByZSIgd3JhcD0iIj5PbiAyMDIwLzQvMjEgNTo1NyBQTSwg
TWFyayBSdXRsYW5kIHdyb3RlOg0KPC9wcmU+DQo8YmxvY2txdW90ZSB0eXBlPSJjaXRlIj4NCjxw
cmUgY2xhc3M9Im1vei1xdW90ZS1wcmUiIHdyYXA9IiI+T24gVHVlLCBBcHIgMjEsIDIwMjAgYXQg
MTE6MjM6MDBBTSAmIzQzOzA4MDAsIEppYW55b25nIFd1IHdyb3RlOg0KPC9wcmU+DQo8YmxvY2tx
dW90ZSB0eXBlPSJjaXRlIj4NCjxwcmUgY2xhc3M9Im1vei1xdW90ZS1wcmUiIHdyYXA9IiI+ZGlm
ZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9oeXBlcmNhbGxzLmMgYi92aXJ0L2t2bS9hcm0vaHlwZXJj
YWxscy5jDQppbmRleCA1NTBkZmEzZTUzY2QuLmE1MzA5YzI4ZDRkYyAxMDA2NDQNCi0tLSBhL3Zp
cnQva3ZtL2FybS9oeXBlcmNhbGxzLmMNCiYjNDM7JiM0MzsmIzQzOyBiL3ZpcnQva3ZtL2FybS9o
eXBlcmNhbGxzLmMNCjwvcHJlPg0KPC9ibG9ja3F1b3RlPg0KPC9ibG9ja3F1b3RlPg0KPC9ibG9j
a3F1b3RlPg0KPHByZSBjbGFzcz0ibW96LXF1b3RlLXByZSIgd3JhcD0iIj4NCjwvcHJlPg0KPGJs
b2NrcXVvdGUgdHlwZT0iY2l0ZSI+DQo8YmxvY2txdW90ZSB0eXBlPSJjaXRlIj4NCjxibG9ja3F1
b3RlIHR5cGU9ImNpdGUiPg0KPHByZSBjbGFzcz0ibW96LXF1b3RlLXByZSIgd3JhcD0iIj5AQCAt
NjIsNiAmIzQzOzY2LDQ0IEBAIGludCBrdm1faHZjX2NhbGxfaGFuZGxlcihzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpDQogIGlmIChncGEgIT0gR1BBX0lOVkFMSUQpDQogIHZhbCA9IGdwYTsNCiAgYnJl
YWs7DQomIzQzOy8qDQomIzQzOyAqIFRoaXMgc2VydmVzIHZpcnR1YWwga3ZtX3B0cC4NCiYjNDM7
ICogRm91ciB2YWx1ZXMgd2lsbCBiZSBwYXNzZWQgYmFjay4NCiYjNDM7ICogcmVnMCBzdG9yZXMg
aGlnaCAzMi1iaXQgaG9zdCBrdGltZTsNCiYjNDM7ICogcmVnMSBzdG9yZXMgbG93IDMyLWJpdCBo
b3N0IGt0aW1lOw0KJiM0MzsgKiByZWcyIHN0b3JlcyBoaWdoIDMyLWJpdCBkaWZmZXJlbmNlIG9m
IGhvc3QgY3ljbGVzIGFuZCBjbnR2b2ZmOw0KJiM0MzsgKiByZWczIHN0b3JlcyBsb3cgMzItYml0
IGRpZmZlcmVuY2Ugb2YgaG9zdCBjeWNsZXMgYW5kIGNudHZvZmYuDQomIzQzOyAqLw0KJiM0Mztj
YXNlIEFSTV9TTUNDQ19IWVBfS1ZNX1BUUF9GVU5DX0lEOg0KPC9wcmU+DQo8L2Jsb2NrcXVvdGU+
DQo8cHJlIGNsYXNzPSJtb3otcXVvdGUtcHJlIiB3cmFwPSIiPlNob3VsZG4ndCB0aGUgaG9zdCBv
cHQtaW4gdG8gcHJvdmlkaW5nIHRoaXMgdG8gdGhlIGd1ZXN0LCBhcyB3aXRoIG90aGVyDQpmZWF0
dXJlcz8NCjwvcHJlPg0KPC9ibG9ja3F1b3RlPg0KPHByZSBjbGFzcz0ibW96LXF1b3RlLXByZSIg
d3JhcD0iIj4NCmVyLCBkbyB5b3UgbWVhbiB0aGF0ICZxdW90O0FSTV9TTUNDQ19IVl9QVl9USU1F
X1hYWCZxdW90OyBhcyAmcXVvdDtvcHQtaW4mcXVvdDs/IGlmIHNvLCBJDQp0aGluayB0aGlzDQoN
Cmt2bV9wdHAgZG9lc24ndCBuZWVkIGEgYnVkZHkuIHRoZSBkcml2ZXIgaW4gZ3Vlc3Qgd2lsbCBj
YWxsIHRoaXMgc2VydmljZQ0KaW4gYSBkZWZpbml0ZSB3YXkuDQo8L3ByZT4NCjwvYmxvY2txdW90
ZT4NCjxwcmUgY2xhc3M9Im1vei1xdW90ZS1wcmUiIHdyYXA9IiI+DQpJIG1lYW4gdGhhdCB3aGVu
IGNyZWF0aW5nIHRoZSBWTSwgdXNlcnNwYWNlIHNob3VsZCBiZSBhYmxlIHRvIGNob29zZQ0Kd2hl
dGhlciB0aGUgUFRQIHNlcnZpY2UgaXMgcHJvdmlkZWQgdG8gdGhlIGd1ZXN0LiBUaGUgaG9zdCBz
aG91bGRuJ3QNCmFsd2F5cyBwcm92aWRlIGl0IGFzIHRoZXJlIG1heSBiZSBjYXNlcyB3aGVyZSBk
b2luZyBzbyBpcyB1bmRlc2lyZWFibGUuDQoNCjwvcHJlPg0KPC9ibG9ja3F1b3RlPg0KPHAgY2xh
c3M9Ik1zb1BsYWluVGV4dCI+PHNwYW4gc3R5bGU9ImNvbG9yOmJsYWNrO21zby1hbnNpLWxhbmd1
YWdlOg0KICAgICAgICBFTi1VUyIgbGFuZz0iRU4tVVMiPkkgdGhpbmsgSSBoYXZlIGltcGxlbWVu
dGVkIGluIHBhdGNoIDkvOSB0aGF0IHVzZXJzcGFjZSBjYW4gZ2V0IHRoZSBpbmZvIHRoYXQgaWYg
dGhlIGhvc3Qgb2ZmZXJzIHRoZSBrdm1fcHRwIHNlcnZpY2UuIEJ1dCBmb3Igbm93LCB0aGUgaG9z
dCBrZXJuZWwgd2lsbCBhbHdheXMgb2ZmZXINCiB0aGUga3ZtX3B0cCBjYXBhYmlsaXR5IGluIHRo
ZSBjdXJyZW50IGltcGxlbWVudGF0aW9uLiBJIHRoaW5rIHg4NiBmb2xsb3cgdGhlIHNhbWUgYmVo
YXZpb3IgKHNlZSBbMV0pLiBzbyBJIGhhdmUgbm90IGNvbnNpZGVyZWQgd2hlbiBhbmQgaG93IHRv
IGRpc2FibGUgdGhpcyBrdm1fcHRwIHNlcnZpY2UgaW4gaG9zdC4gRG8geW91IHRoaW5rIHdlIHNo
b3VsZCBvZmZlciB0aGlzIG9wdC1pbj88L3NwYW4+PC9wPg0KPHN0eWxlPg0KPCEtLQ0KIC8qIEZv
bnQgRGVmaW5pdGlvbnMgKi8NCiBAZm9udC1mYWNlDQoJe2ZvbnQtZmFtaWx5OiJDYW1icmlhIE1h
dGgiOw0KCXBhbm9zZS0xOjIgNCA1IDMgNSA0IDYgMyAyIDQ7DQoJbXNvLWZvbnQtY2hhcnNldDow
Ow0KCW1zby1nZW5lcmljLWZvbnQtZmFtaWx5OnJvbWFuOw0KCW1zby1mb250LXBpdGNoOnZhcmlh
YmxlOw0KCW1zby1mb250LXNpZ25hdHVyZTozIDAgMCAwIDEgMDt9DQpAZm9udC1mYWNlDQoJe2Zv
bnQtZmFtaWx5OkRlbmdYaWFuOw0KCXBhbm9zZS0xOjIgMSA2IDAgMyAxIDEgMSAxIDE7DQoJbXNv
LWZvbnQtYWx0Ouetiee6vzsNCgltc28tZm9udC1jaGFyc2V0OjEzNDsNCgltc28tZ2VuZXJpYy1m
b250LWZhbWlseTphdXRvOw0KCW1zby1mb250LXBpdGNoOnZhcmlhYmxlOw0KCW1zby1mb250LXNp
Z25hdHVyZTotMTYxMDYxMjAzMyA5NTMxMjIwNDIgMjIgMCAyNjIxNTkgMDt9DQpAZm9udC1mYWNl
DQoJe2ZvbnQtZmFtaWx5OkNhbGlicmk7DQoJcGFub3NlLTE6MiAxNSA1IDIgMiAyIDQgMyAyIDQ7
DQoJbXNvLWZvbnQtY2hhcnNldDowOw0KCW1zby1nZW5lcmljLWZvbnQtZmFtaWx5OnN3aXNzOw0K
CW1zby1mb250LXBpdGNoOnZhcmlhYmxlOw0KCW1zby1mb250LXNpZ25hdHVyZTotNTM2ODU5OTA1
IC0xMDczNzMyNDg1IDkgMCA1MTEgMDt9DQpAZm9udC1mYWNlDQoJe2ZvbnQtZmFtaWx5OiJcQERl
bmdYaWFuIjsNCglwYW5vc2UtMToyIDEgNiAwIDMgMSAxIDEgMSAxOw0KCW1zby1mb250LWNoYXJz
ZXQ6MTM0Ow0KCW1zby1nZW5lcmljLWZvbnQtZmFtaWx5OmF1dG87DQoJbXNvLWZvbnQtcGl0Y2g6
dmFyaWFibGU7DQoJbXNvLWZvbnQtc2lnbmF0dXJlOi0xNjEwNjEyMDMzIDk1MzEyMjA0MiAyMiAw
IDI2MjE1OSAwO30NCiAvKiBTdHlsZSBEZWZpbml0aW9ucyAqLw0KIHAuTXNvTm9ybWFsLCBsaS5N
c29Ob3JtYWwsIGRpdi5Nc29Ob3JtYWwNCgl7bXNvLXN0eWxlLXVuaGlkZTpubzsNCgltc28tc3R5
bGUtcWZvcm1hdDp5ZXM7DQoJbXNvLXN0eWxlLXBhcmVudDoiIjsNCgltYXJnaW46MGNtOw0KCW1h
cmdpbi1ib3R0b206LjAwMDFwdDsNCgltc28tcGFnaW5hdGlvbjp3aWRvdy1vcnBoYW47DQoJZm9u
dC1zaXplOjEyLjBwdDsNCglmb250LWZhbWlseToiQ2FsaWJyaSIsc2Fucy1zZXJpZjsNCgltc28t
YXNjaWktZm9udC1mYW1pbHk6Q2FsaWJyaTsNCgltc28tYXNjaWktdGhlbWUtZm9udDptaW5vci1s
YXRpbjsNCgltc28tZmFyZWFzdC1mb250LWZhbWlseTpEZW5nWGlhbjsNCgltc28tZmFyZWFzdC10
aGVtZS1mb250Om1pbm9yLWZhcmVhc3Q7DQoJbXNvLWhhbnNpLWZvbnQtZmFtaWx5OkNhbGlicmk7
DQoJbXNvLWhhbnNpLXRoZW1lLWZvbnQ6bWlub3ItbGF0aW47DQoJbXNvLWJpZGktZm9udC1mYW1p
bHk6IlRpbWVzIE5ldyBSb21hbiI7DQoJbXNvLWJpZGktdGhlbWUtZm9udDptaW5vci1iaWRpO30N
CnAuTXNvUGxhaW5UZXh0LCBsaS5Nc29QbGFpblRleHQsIGRpdi5Nc29QbGFpblRleHQNCgl7bXNv
LXN0eWxlLXByaW9yaXR5Ojk5Ow0KCW1zby1zdHlsZS1saW5rOiJQbGFpbiBUZXh0IENoYXIiOw0K
CW1hcmdpbjowY207DQoJbWFyZ2luLWJvdHRvbTouMDAwMXB0Ow0KCW1zby1wYWdpbmF0aW9uOndp
ZG93LW9ycGhhbjsNCglmb250LXNpemU6MTEuMHB0Ow0KCW1zby1iaWRpLWZvbnQtc2l6ZToxMC41
cHQ7DQoJZm9udC1mYW1pbHk6IkNhbGlicmkiLHNhbnMtc2VyaWY7DQoJbXNvLWZhcmVhc3QtZm9u
dC1mYW1pbHk6RGVuZ1hpYW47DQoJbXNvLWZhcmVhc3QtdGhlbWUtZm9udDptaW5vci1mYXJlYXN0
Ow0KCW1zby1iaWRpLWZvbnQtZmFtaWx5OiJUaW1lcyBOZXcgUm9tYW4iOw0KCW1zby1iaWRpLXRo
ZW1lLWZvbnQ6bWlub3ItYmlkaTt9DQpzcGFuLlBsYWluVGV4dENoYXINCgl7bXNvLXN0eWxlLW5h
bWU6IlBsYWluIFRleHQgQ2hhciI7DQoJbXNvLXN0eWxlLXByaW9yaXR5Ojk5Ow0KCW1zby1zdHls
ZS11bmhpZGU6bm87DQoJbXNvLXN0eWxlLWxvY2tlZDp5ZXM7DQoJbXNvLXN0eWxlLWxpbms6IlBs
YWluIFRleHQiOw0KCW1zby1hbnNpLWZvbnQtc2l6ZToxMS4wcHQ7DQoJbXNvLWJpZGktZm9udC1z
aXplOjEwLjVwdDsNCglmb250LWZhbWlseToiQ2FsaWJyaSIsc2Fucy1zZXJpZjsNCgltc28tYXNj
aWktZm9udC1mYW1pbHk6Q2FsaWJyaTsNCgltc28taGFuc2ktZm9udC1mYW1pbHk6Q2FsaWJyaTt9
DQouTXNvQ2hwRGVmYXVsdA0KCXttc28tc3R5bGUtdHlwZTpleHBvcnQtb25seTsNCgltc28tZGVm
YXVsdC1wcm9wczp5ZXM7DQoJZm9udC1zaXplOjEyLjBwdDsNCgltc28tYW5zaS1mb250LXNpemU6
MTIuMHB0Ow0KCW1zby1iaWRpLWZvbnQtc2l6ZToxMi4wcHQ7DQoJZm9udC1mYW1pbHk6IkNhbGli
cmkiLHNhbnMtc2VyaWY7DQoJbXNvLWFzY2lpLWZvbnQtZmFtaWx5OkNhbGlicmk7DQoJbXNvLWFz
Y2lpLXRoZW1lLWZvbnQ6bWlub3ItbGF0aW47DQoJbXNvLWZhcmVhc3QtZm9udC1mYW1pbHk6RGVu
Z1hpYW47DQoJbXNvLWZhcmVhc3QtdGhlbWUtZm9udDptaW5vci1mYXJlYXN0Ow0KCW1zby1oYW5z
aS1mb250LWZhbWlseTpDYWxpYnJpOw0KCW1zby1oYW5zaS10aGVtZS1mb250Om1pbm9yLWxhdGlu
Ow0KCW1zby1iaWRpLWZvbnQtZmFtaWx5OiJUaW1lcyBOZXcgUm9tYW4iOw0KCW1zby1iaWRpLXRo
ZW1lLWZvbnQ6bWlub3ItYmlkaTt9c2l6ZTo2MTIuMHB0IDc5Mi4wcHQ7DQoJbWFyZ2luOjcyLjBw
dCA3Mi4wcHQgNzIuMHB0IDcyLjBwdDsNCgltc28taGVhZGVyLW1hcmdpbjozNi4wcHQ7DQoJbXNv
LWZvb3Rlci1tYXJnaW46MzYuMHB0Ow0KCW1zby1wYXBlci1zb3VyY2U6MDt9DQpkaXYuV29yZFNl
Y3Rpb24xDQoJe3BhZ2U6V29yZFNlY3Rpb24xO308L3N0eWxlPg0KICAgIDxibG9ja3F1b3RlIHR5
cGU9ImNpdGUiDQogICAgICBjaXRlPSJtaWQ6MjAyMDA0MjQxMDM5NTMuR0QxMTY3QEMwMlREMFVU
SEYxVC5sb2NhbCI+DQogICAgICA8YmxvY2txdW90ZSB0eXBlPSJjaXRlIj4NCiAgICAgICAgPGJs
b2NrcXVvdGUgdHlwZT0iY2l0ZSI+DQogICAgICAgICAgPGJsb2NrcXVvdGUgdHlwZT0iY2l0ZSI+
DQogICAgICAgICAgICA8cHJlIGNsYXNzPSJtb3otcXVvdGUtcHJlIiB3cmFwPSIiPisvKg0KKyAq
IHN5c3RlbSB0aW1lIGFuZCBjb3VudGVyIHZhbHVlIG11c3QgY2FwdHVyZWQgaW4gdGhlIHNhbWUN
CisgKiB0aW1lIHRvIGtlZXAgY29uc2lzdGVuY3kgYW5kIHByZWNpc2lvbi4NCisgKi8NCitrdGlt
ZV9nZXRfc25hcHNob3QoJmFtcDtzeXN0aW1lX3NuYXBzaG90KTsNCitpZiAoc3lzdGltZV9zbmFw
c2hvdC5jc19pZCAhPSBDU0lEX0FSTV9BUkNIX0NPVU5URVIpDQorYnJlYWs7DQorYXJnWzBdID0g
dXBwZXJfMzJfYml0cyhzeXN0aW1lX3NuYXBzaG90LnJlYWwpOw0KK2FyZ1sxXSA9IGxvd2VyXzMy
X2JpdHMoc3lzdGltZV9zbmFwc2hvdC5yZWFsKTsNCjwvcHJlPg0KICAgICAgICAgIDwvYmxvY2tx
dW90ZT4NCiAgICAgICAgICA8cHJlIGNsYXNzPSJtb3otcXVvdGUtcHJlIiB3cmFwPSIiPldoeSBl
eGFjdGx5IGRvZXMgdGhlIGd1ZXN0IG5lZWQgdGhlIGhvc3QncyByZWFsIHRpbWU/IE5laXRoZXIg
dGhlIGNvdmVyDQpsZXR0ZXIgbm9yIHRoaXMgY29tbWl0IG1lc3NhZ2UgaGF2ZSBleHBsYWluZWQg
dGhhdCwgYW5kIGZvciB0aG9zZSBvZiB1cw0KdW5mYW1saWFyIHdpdGggUFRQIGl0IHdvdWxkIGJl
IHZlcnkgaGVscGZ1bCB0byBrbm93IHRoYXQgdG8gdW5kZXJzdGFuZA0Kd2hhdCdzIGdvaW5nIG9u
Lg0KPC9wcmU+DQogICAgICAgIDwvYmxvY2txdW90ZT4NCiAgICAgICAgPHByZSBjbGFzcz0ibW96
LXF1b3RlLXByZSIgd3JhcD0iIj4NCm9oLCBzb3JyeSwgSSBzaG91bGQgaGF2ZSBhZGRlZCBtb3Jl
IGJhY2tncm91bmQga25vd2xlZGdlIGhlcmUuDQoNCmp1c3QgZ2l2ZSBzb21lIGhpbnRzIGhlcmU6
DQoNCnRoZSBrdm1fcHRwIHRhcmdldHMgdG8gc3luYyBndWVzdCB0aW1lIHdpdGggaG9zdC4gc29t
ZSBzZXJ2aWNlcyBpbiB1c2VyDQpzcGFjZQ0KDQpsaWtlIGNocm9ueSBjYW4gZG8gdGltZSBzeW5j
IGJ5IGlucHV0aW5nIHRpbWUoaW4ga3ZtX3B0cCBhbHNvIGNsb2NrDQpjb3VudGVyIHNvbWV0aW1l
cykgZnJvbQ0KDQpyZW1vdGUgY2xvY2tzb3VyY2Uob2Z0ZW4gbmV0d29yayBjbG9ja3NvdXJjZSku
IFRoaXMga3ZtX3B0cCBkcml2ZXIgY2FuDQpvZmZlciBhIGludGVyZmFjZSBmb3INCg0KdGhvc2Ug
dXNlciBzcGFjZSBzZXJ2aWNlIGluIGd1ZXN0IHRvIGdldCB0aGUgaG9zdCB0aW1lIHRvIGRvIHRp
bWUgc3luYw0KaW4gZ3Vlc3QuDQo8L3ByZT4NCiAgICAgIDwvYmxvY2txdW90ZT4NCiAgICAgIDxw
cmUgY2xhc3M9Im1vei1xdW90ZS1wcmUiIHdyYXA9IiI+DQpJIHRoaW5rIGl0IHdvdWxkIGJlIHZl
cnkgaGVscGZ1bCBmb3IgdGhlIGNvbW1pdCBtZXNzYWdlIGFuZC9vciBjb3Zlcg0KbGV0dGVyIHRv
IGhhdmUgYSBoaWdoLWxldmVsIGRlc2N0aXB0aW9uIG9mIHdoYXQgUFRQIGlzIG1lYW50IHRvIGRv
LCBhbmQNCmFuIG91dGxpbmUgb2YgdGhlIGFsZ29yaXRobW0gKGNsZWFybHkgc3BsaXR0aW5nIHRo
ZSBob3N0IGFuZCBndWVzdA0KYml0cykuDQo8L3ByZT4NCiAgICA8L2Jsb2NrcXVvdGU+DQogICAg
b2ssIEkgd2lsbCBhZGQgaGlnaC1sZXZlbCBwcmluY2lwbGUgb2Yga3ZtX3B0cCBpbiBjb21taXQg
bWVzc2FnZS48YnI+DQogICAgPGJsb2NrcXVvdGUgdHlwZT0iY2l0ZSINCiAgICAgIGNpdGU9Im1p
ZDoyMDIwMDQyNDEwMzk1My5HRDExNjdAQzAyVEQwVVRIRjFULmxvY2FsIj4NCiAgICAgIDxwcmUg
Y2xhc3M9Im1vei1xdW90ZS1wcmUiIHdyYXA9IiI+DQpJdCdzIGFsc28gbm90IGNsZWFyIHRvIG1l
IHdoYXQgbm90aW9uIG9mIGhvc3QgdGltZSBpcyBiZWluZyBleHBvc2VkIHRvDQp0aGUgZ3Vlc3Qg
KGFuZCBjb25zZXF1ZW50bHkgaG93IHRoaXMgd291bGQgaW50ZXJhY3Qgd2l0aCB0aW1lIGNoYW5n
ZXMgb24NCnRoZSBob3N0LCB0aW1lIG5hbWVzcGFjZXMsIGV0YykuIEhhdmluZyBzb21lIGRlc2Ny
aXB0aW9uIG9mIHRoYXQgd291bGQNCmJlIHZlcnkgaGVscGZ1bC4NCjwvcHJlPg0KICAgIDwvYmxv
Y2txdW90ZT4NCiAgICA8cD5zb3JyeSwgSSBoYXZlIG5vdCBtYWRlIGl0IGNsZWFyLjwvcD4NCiAg
ICA8cD50aW1lIHdpbGwgbm90IGNoYW5nZSBpbiBob3N0IGFuZCBvbmx5IHRpbWUgaW4gZ3Vlc3Qg
d2lsbCBjaGFuZ2UNCiAgICAgIHRvIHN5bmMgd2l0aCBob3N0LiBob3N0IHRpbWUgaXMgdGhlIHRh
cmdldCB0aGF0IHRpbWUgaW4gZ3Vlc3Qgd2FudA0KICAgICAgdG8gcnVuIGludG8uIGd1ZXN0IG5l
ZWQgdG8gZ2V0IHRoZSBob3N0IHRpbWUgdGhlbiBjb21wdXRlIHRoZQ0KICAgICAgZGlmZmVyZW50
IG9mIHRoZSB0aW1lIGluIGd1ZXN0IGFuZCBob3N0LCBzbyB0aGUgZ3Vlc3QgY2FuIGFkanVzdA0K
ICAgICAgdGhlIHRpbWUgYmFzZSBvbiB0aGUgZGlmZmVyZW5jZS48L3A+DQogICAgPHA+SSB3aWxs
IGFkZCB0aGUgYmFzZSBwcmluY2lwbGUgb2YgdGltZSBzeW5jIHNlcnZpY2UgaW4gZ3Vlc3QgdXNp
bmcNCiAgICAgIGt2bV9wdHAgaW4gY29tbWl0IG1lc3NhZ2UuIDxicj4NCiAgICA8L3A+DQogICAg
PHA+PGJyPg0KICAgIDwvcD4NCiAgICA8cD5UaGFua3M8L3A+DQogICAgPHA+SmlhbnlvbmcgPGJy
Pg0KICAgIDwvcD4NCiAgICA8YmxvY2txdW90ZSB0eXBlPSJjaXRlIg0KICAgICAgY2l0ZT0ibWlk
OjIwMjAwNDI0MTAzOTUzLkdEMTE2N0BDMDJURDBVVEhGMVQubG9jYWwiPg0KICAgICAgPHByZSBj
bGFzcz0ibW96LXF1b3RlLXByZSIgd3JhcD0iIj4NClRoYW5rcywNCk1hcmsuDQo8L3ByZT4NCiAg
ICA8L2Jsb2NrcXVvdGU+DQogICAgPHA+PGJyPg0KICAgIDwvcD4NCiAgPC9ib2R5Pg0KPC9odG1s
Pg0KLS0+PC9zdHlsZT4NCjwvYm9keT4NCjwvaHRtbD4NCg==

--_000_b005e2c8ed9f3dc6dbfa5e6db5183f3carmcom_--

--===============5480819594048221605==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5480819594048221605==--
