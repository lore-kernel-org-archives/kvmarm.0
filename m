Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D654C6379F
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 05:12:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1AD4B206FB
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 05:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="yCWLUAfG";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="yCWLUAfG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AD4B206FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CBB74BCA8;
	Tue, 24 Nov 2020 00:12:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wRdcrFp7c0Gf; Tue, 24 Nov 2020 00:12:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20E4E4BCEC;
	Tue, 24 Nov 2020 00:12:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 596F84BCAB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 00:12:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cf7Okv25tQZh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 00:12:04 -0500 (EST)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2057.outbound.protection.outlook.com [40.107.20.57])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81B994BCEF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 00:12:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfHVBy7CtP3lQRqzHVJgReq8c+egPpZl4kDDnebz3M0=;
 b=yCWLUAfGfogSGM3OwAz8T0Rmyv4Z/LeIPTNmQPinEDsiBVKCD05QQsyZx2/8KQC/cYLeS6PpnK+SGw8cY3DY3UuhjUfn1aWGXJ+yyuFSzMMCyC1XdNabkMfrfh44olJLbLw189ed8UBvgbUwzV5rdiJkcvcSBF7QkPxJTZFp/wM=
Received: from DB7PR03CA0099.eurprd03.prod.outlook.com (2603:10a6:10:72::40)
 by DB8PR08MB4041.eurprd08.prod.outlook.com (2603:10a6:10:ad::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.24; Tue, 24 Nov
 2020 05:12:01 +0000
Received: from DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:72:cafe::2e) by DB7PR03CA0099.outlook.office365.com
 (2603:10a6:10:72::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Tue, 24 Nov 2020 05:12:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT013.mail.protection.outlook.com (10.152.20.105) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 05:12:01 +0000
Received: ("Tessian outbound 814be617737e:v71");
 Tue, 24 Nov 2020 05:12:00 +0000
X-CR-MTA-TID: 64aa7808
Received: from dbb23b81dfe5.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 C35D8D60-38C3-4CB2-BCA0-D0EC20C38A5A.1; 
 Tue, 24 Nov 2020 05:11:55 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id dbb23b81dfe5.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 24 Nov 2020 05:11:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCkOiFm7v3MKAJNNe0uXpshBc4m3PzURPLDJEbJf40/l5iCJ93t37N/WiR7dYGpcWE0O25NZz/rGMSubGVI3AikP12rxODr81fUgfOygAcpa5V6ghGa5zj8uMX0iVbggGYlbe6J23xiP8a666U9xyBWKK/qmjc3wZ0kMPDrLgw/PFxZi3lT3T/NnD09jGA9gtYY+l6BkbyNEncMlNMhN9eQ3EjuIef9iYXd1VIXrSplM17x5I5oe0+z59VrGSvlnWs/yT+X0gYn0Npgb4UAcKMw00NLAszafCc0ppT2xEmVz6O50uOyi8BxEKqDvp9zV6Ge7zMzSS0sFRx8uaUzpBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfHVBy7CtP3lQRqzHVJgReq8c+egPpZl4kDDnebz3M0=;
 b=YvSHYEti/OQK7ap6X4jBh9s70Ff7tvzx8cv+iAq3QKsA6quOnf7uhmYQCDF0YadFDlXH23D7ygFTNFLo1HmxdVKV+ERHlnFL09U6nbM38xB+l0xwl5D1EB5SPI08b7kHxvx4DyW3+sUz14ATTAdXYrhfrfYrbNEdgyxRw6GvPR+x7bPnrAhtz55Et9PUu2HPkCnTKWUaJ8BEhdyYZj6QFd8LpPoH3vMC38qzK/3maJ5SObE6WC8dSmmjbVxEwPws8MVzz8qdTKAySzPcbdD+R2xQgujs/dKif2Ax8wzeXjG3xFZA1KhGluGGxrEzhQxUfWaQUDhYuXZeactAhNNU8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfHVBy7CtP3lQRqzHVJgReq8c+egPpZl4kDDnebz3M0=;
 b=yCWLUAfGfogSGM3OwAz8T0Rmyv4Z/LeIPTNmQPinEDsiBVKCD05QQsyZx2/8KQC/cYLeS6PpnK+SGw8cY3DY3UuhjUfn1aWGXJ+yyuFSzMMCyC1XdNabkMfrfh44olJLbLw189ed8UBvgbUwzV5rdiJkcvcSBF7QkPxJTZFp/wM=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR08MB2825.eurprd08.prod.outlook.com (2603:10a6:7:35::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.29; Tue, 24 Nov
 2020 05:11:52 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 05:11:52 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Topic: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Index: AQHWt/MyY3F2SxWQTkCP3WjcSZqyYKnVm0IAgAAU8YCAARLH4A==
Date: Tue, 24 Nov 2020 05:11:52 +0000
Message-ID: <HE1PR0802MB2555E9997B3DD956430F9185F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-7-jianyong.wu@arm.com>
 <d409aa1cb7cfcbf4351e6c5fc34d9c7e@kernel.org>
 <276428d3d291f703e2f0c2c323194e98@kernel.org>
In-Reply-To: <276428d3d291f703e2f0c2c323194e98@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 7237C864A062D444AA8EC14287DE9BDD.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 10191ef2-2f7a-417a-78b5-08d890377992
x-ms-traffictypediagnostic: HE1PR08MB2825:|DB8PR08MB4041:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB40410C37649A7444C822141AF4FB0@DB8PR08MB4041.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1360;OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: sauOZ6oeofIQrluhEVL/ofYA8Mrq1B6GWEf6ykghEhWMS7IiMJN/HVdsdIt1I5b7iYBJXk87Rnp/uMcYfF3qqNfekd90RFTzywpvtGVttre48smf3EDOY0ioIeE9AhdJmTLhqzYSTMEj3e/L4zM6kxCvb8WflPukdqskW98PON/INcrjP8ypfveCkM/96v7S/cL75/0TdCEwAHIOELigKCmx+DP0cZDhHln6XNfQTAmeaRkWNb4k+9e59WxyaxDchHNiVQOJPD82EczdT7HH8wztmUnzCKQEfssDUE0b/aK+7DC57oHLGjTze/yBoOI5tUoZBVa+essuDFmZRgY9gA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(2906002)(8936002)(6916009)(8676002)(83380400001)(316002)(186003)(86362001)(26005)(7416002)(54906003)(66946007)(71200400001)(76116006)(66556008)(64756008)(4001150100001)(66476007)(66446008)(6506007)(53546011)(4326008)(52536014)(7696005)(5660300002)(478600001)(55016002)(9686003)(33656002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: pdI0o3FFzvNShK6dXLEaQN8QPdxx4ml3Vb+Qn5tskgyKGcLwUCLsCZ6qL/zpfWjCEIkN4x83ViX1fxQQgITIe4EuClxsXDbcF3Z9pIlCZub59E35DWdxPCm8He6te4XbhS0Nxi7u/lxYvNwq9+hq3BKYtY+GWO09vOPKOC3AZ6hRqtlHiemx9EJTESIt3ia35Ztds2Ro38d1PxzflA1dhaL3EC4NBmtud81ad3NCjgfvbWH6Za5PobtVVl+4XnFHGb6RGs4ZvfpZXT0mvgESP24le26RhvF+BrcyVOwUNiy82yZoCrRBMAnsgzlKkMBZhLYoC4uaAyti9nQzRttqdghEdagebgMVMAEi2T98y8rIL4DOK57hVlXKJHhdmJuFn32/Vwc0AkS1UpVq5Qx6N7FJByo9DK9wr5C88H4gnOlgLHFowZfhEvbeGCMzzxoGAHKTUWUW7O/YzoLNeD1xnQplUfz27G05XONYIxABuKcvpzjTbriafhh4i1kFzJ7BSze364N1SR4gXlBqN+AQEZquXXReXnxYvd1mCY8launDThMpJpA/nDkFPLSxCrLhnt3Zx0nmQOtP8lQdKQcbxwVujSz5ACYqmsnk8Hv9TfEwu/yNWe0FNMesrW0Zsn/G6cyWcGiKBJAERCxWFbYAz0KokLm65iiunsIwBE1QXyZK6CP0ecFLdarS2cM+U8EurX4iCEfSykt9e+IW0tb2qnEOkcjCYZCEEOkdpZ4r+mwYTiFkcBxPcYZnbzzaO30Z36MuaTx1g3+cF0OwZEmooNC2ToTu17AHxKUaJglnphxddJIx7tPgyCogDJnKXiwLIifrP49WJ59OWYQAOFFlPWQYz5cPaQ9NIU/kxvX4+N8KBEXGn+0nxvMIadqIMuTBzCwqkD2oR6l7cC689F+ZrQ==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR08MB2825
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 99e3d3ba-7719-4867-3532-08d890377467
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFssuitSUzadzegKuANPzOsdWuhgGyLssp0TAuWbpLfxSC162wcGWCOOfSSGzIyB4vmEEz46CRWF5e0OIJFGoGAbARS0FRcrevmnko5DTsp6FmPtSH0nMhH6Rn44tIitYmu6r8wh0zlEUrTAu0AcqyBMsbWPKh+kgPG7yeips+T+eqrULJ9KcEGfClsj61K9u31nD+K9UaEWFG1suoTThdhXY3F74HFlNVvteiZSi09vFtdMbL+rmgroUtXnzw4jgmu8G1sDWbUqd/HZwqNPjiV1tpYYusPPRore34FkWMyhZ0/ftnMlmC5bm/mQKjvqHao9UAdUSXMOZknHHGWYVxFqThK2EA5oRmTY0IQT2VMxj1RLr4CXkEpWH4kcxX8iBc0ErRr5/VunVWLDyiRSzg==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(46966005)(7696005)(107886003)(83380400001)(82310400003)(2906002)(478600001)(6862004)(86362001)(70586007)(5660300002)(70206006)(33656002)(47076004)(55016002)(26005)(52536014)(9686003)(316002)(356005)(186003)(54906003)(6506007)(82740400003)(4001150100001)(81166007)(4326008)(336012)(8676002)(53546011)(8936002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 05:12:01.0098 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10191ef2-2f7a-417a-78b5-08d890377992
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4041
Cc: Justin He <Justin.He@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Steven Price <Steven.Price@arm.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 Andre Przywara <Andre.Przywara@arm.com>,
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
> Sent: Monday, November 23, 2020 7:59 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: Justin He <Justin.He@arm.com>; kvm@vger.kernel.org;
> netdev@vger.kernel.org; richardcochran@gmail.com; linux-
> kernel@vger.kernel.org; sean.j.christopherson@intel.com; Steven Price
> <Steven.Price@arm.com>; Andre Przywara <Andre.Przywara@arm.com>;
> john.stultz@linaro.org; yangbo.lu@nxp.com; pbonzini@redhat.com;
> tglx@linutronix.de; nd <nd@arm.com>; will@kernel.org;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
> 
> On 2020-11-23 10:44, Marc Zyngier wrote:
> > On 2020-11-11 06:22, Jianyong Wu wrote:
> >> ptp_kvm will get this service through SMCC call.
> >> The service offers wall time and cycle count of host to guest.
> >> The caller must specify whether they want the host cycle count or the
> >> difference between host cycle count and cntvoff.
> >>
> >> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> >> ---
> >>  arch/arm64/kvm/hypercalls.c | 61
> >> +++++++++++++++++++++++++++++++++++++
> >>  include/linux/arm-smccc.h   | 17 +++++++++++
> >>  2 files changed, 78 insertions(+)
> >>
> >> diff --git a/arch/arm64/kvm/hypercalls.c
> >> b/arch/arm64/kvm/hypercalls.c index b9d8607083eb..f7d189563f3d
> 100644
> >> --- a/arch/arm64/kvm/hypercalls.c
> >> +++ b/arch/arm64/kvm/hypercalls.c
> >> @@ -9,6 +9,51 @@
> >>  #include <kvm/arm_hypercalls.h>
> >>  #include <kvm/arm_psci.h>
> >>
> >> +static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val) {
> >> +	struct system_time_snapshot systime_snapshot;
> >> +	u64 cycles = ~0UL;
> >> +	u32 feature;
> >> +
> >> +	/*
> >> +	 * system time and counter value must captured in the same
> >> +	 * time to keep consistency and precision.
> >> +	 */
> >> +	ktime_get_snapshot(&systime_snapshot);
> >> +
> >> +	// binding ptp_kvm clocksource to arm_arch_counter
> >> +	if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
> >> +		return;
> >> +
> >> +	val[0] = upper_32_bits(systime_snapshot.real);
> >> +	val[1] = lower_32_bits(systime_snapshot.real);
> >
> > What is the endianness of these values? I can't see it defined
> > anywhere, and this is likely not to work if guest and hypervisor don't
> > align.
> 
> Scratch that. This is all passed via registers, so the endianness of the data is
> irrelevant. Please discard any comment about endianness I made in this
> review.
> 
Yeah, these data process and transfer are no relationship with endianness. Thanks.

> The documentation aspect still requires to be beefed up.

So the endianness description will be "no endianness restriction".

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
