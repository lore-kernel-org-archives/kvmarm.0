Return-Path: <SRS0=wisL=6F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA36C54FC9
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 09:51:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C750D2087E
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 09:51:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="VvcFFvUt";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="VvcFFvUt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C750D2087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 432ED4B117;
	Tue, 21 Apr 2020 05:51:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6b-qS9W6+53O; Tue, 21 Apr 2020 05:51:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 010214B11A;
	Tue, 21 Apr 2020 05:51:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC0224B109
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 05:51:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d9hbHSohN0vy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Apr 2020 05:51:37 -0400 (EDT)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A3E14B0F3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 05:51:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7hWKv4QbqZsJauysmPOco3Vxi3w0XxAAvCTb9O+6Hc=;
 b=VvcFFvUt2tDtuM76TpKw0Mr+yt5/mKvjTh5ETbPvQ5uBu4ACiE584w0rXJrValmdrwLLGUl+xO+gyu4qBwVEE0W6fW6DQFp7MQrR1cXJxtKJxfw2aIgDkKS64NV6vLtOUCIQoQr/Ab5+P4dGZJDlBp6/GWyuyVvtlbuCXlaY6i8=
Received: from AM6P194CA0100.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:8f::41)
 by DB8PR08MB5324.eurprd08.prod.outlook.com (2603:10a6:10:11e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Tue, 21 Apr
 2020 09:51:34 +0000
Received: from VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8f:cafe::5d) by AM6P194CA0100.outlook.office365.com
 (2603:10a6:209:8f::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend
 Transport; Tue, 21 Apr 2020 09:51:34 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT015.mail.protection.outlook.com (10.152.18.176) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.18 via Frontend Transport; Tue, 21 Apr 2020 09:51:33 +0000
Received: ("Tessian outbound ecb846ece464:v53");
 Tue, 21 Apr 2020 09:51:33 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5f959d203d53682b
X-CR-MTA-TID: 64aa7808
Received: from a26fae153160.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 C404701D-2669-471C-9EE8-A3AD6B44AD70.1; 
 Tue, 21 Apr 2020 09:51:27 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a26fae153160.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 21 Apr 2020 09:51:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UiSKc3kKFl7i7aTFhy9IENfL96RAvpf9MHLZLX627l1nBDlhiqcF0vJ+9aC55M5HwmEvR5KBegeXfPNzY1GjR3v4X0VSaEC1eUAFq3KRHvpnhOEzTzAPHuE5xVFtADSExa9/S5l/LwjK+yLW6TpeqXrVByHBg/TbMHcQw1TGOua5m5uHYl9e9uiZJhHAO5nGnL7Hnnt/oLxjf2j1uS+xFvueDXFQZ8+jAIIcOM7FbTtUJjn/Vl8GgBmMtDVx/tN3XjUt73hpm0C+DI3qPqYvvHzrZxniWRmpXtq012v/2OYjxxRNNXEG7tQ/a7nbYBvneS6hG7W7ntb+J6NBuhZlQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7hWKv4QbqZsJauysmPOco3Vxi3w0XxAAvCTb9O+6Hc=;
 b=NYA6aj/e0t8/5zosrBoYMczFsUNnRa/O7xt+sC3PKzNEuUgkxhjV40F0sQZv/8I5M8D6rGniP2rq1dum7U0FSe1sQvUqS0tarTSbymUZ/AlG6x+alilxj+HjbcAEO/IwA3NzTuC2Ph5Hhu8hZmg5yCJrHLCP8XEkijzeH0QJF1o3W1CdGGl7BGd4r3T/5QpgibSH8IG7Jjfk2Xil+nIclJv342mHL48yWLXeAWx6YT0xWSTjo5HRtegkbXz0LRPsGMvoi839Detpy7w9MFWIaVVcX2KMAG5u/lKD6YVQZC0NefCFrCyA+tAttG7kI2ZvQCYCoHwHD1CYkdQd4a3Dig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7hWKv4QbqZsJauysmPOco3Vxi3w0XxAAvCTb9O+6Hc=;
 b=VvcFFvUt2tDtuM76TpKw0Mr+yt5/mKvjTh5ETbPvQ5uBu4ACiE584w0rXJrValmdrwLLGUl+xO+gyu4qBwVEE0W6fW6DQFp7MQrR1cXJxtKJxfw2aIgDkKS64NV6vLtOUCIQoQr/Ab5+P4dGZJDlBp6/GWyuyVvtlbuCXlaY6i8=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2251.eurprd08.prod.outlook.com (2603:10a6:3:cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Tue, 21 Apr
 2020 09:51:25 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 09:51:25 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [RFC PATCH v11 1/9] psci: export psci conduit get helper.
Thread-Topic: [RFC PATCH v11 1/9] psci: export psci conduit get helper.
Thread-Index: AQHWF4xCog26uJuT5UavVEF5u0ShTaiDUtMAgACJBgA=
Date: Tue, 21 Apr 2020 09:51:25 +0000
Message-ID: <3F1930C1-5CBA-4401-9595-1432C16EE750@arm.com>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-2-jianyong.wu@arm.com>
 <20200421094058.GA16306@C02TD0UTHF1T.local>
In-Reply-To: <20200421094058.GA16306@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ef5f0e5-3023-45b9-d043-08d7e5d99359
x-ms-traffictypediagnostic: HE1PR0802MB2251:|HE1PR0802MB2251:|DB8PR08MB5324:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB5324A9AE8DE77ADE1AC03108F4D50@DB8PR08MB5324.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4941;OLM:4941;
x-forefront-prvs: 038002787A
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(26005)(7416002)(6486002)(8676002)(54906003)(4326008)(55236004)(6862004)(2616005)(6506007)(37006003)(2906002)(316002)(33656002)(6512007)(478600001)(76116006)(66556008)(66476007)(66946007)(64756008)(66446008)(81156014)(5660300002)(91956017)(86362001)(186003)(8936002)(71200400001)(6636002)(36756003);
 DIR:OUT; SFP:1101; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: +I4oOEzo61Vtp+ZY1LfM7pyFg25HxJvp3daQD2KkT+bwUL69m5N1/ZRFCt7d1O7fsDQzJqcGfCIQ11lcvLiBEAbXZhRpIlU0R9jWGBfuR9ybl4GSS/q+/h713fhE9O6Cj7zZYaRUbkz5j429BTnHs3cp0vwp2WtHMA278GeZ/Ba+9MFTdfLbH9bJs2PvvzWcVTcK6nLYggWQqgvw8Ng0sOUfy1nGnX+0rD/PR3QE2PKCj1rNK7og1/86AOM8uHCLAxZ8JzMY4cMhCyFoBv0KRrBhEJN0wwNYVgQHMu8AIL4Xz5X/X4ATMYZDCkXNDyws2wK+ExZwUdW8VGCfkECqzlrvNSvCOzigykn4GrrovA9CfBhweTUIUXWFIVvI7BXzh7JgaZ7IYRIT+ZNrKJJ0HNlHiu/SOsuynpgQvKNrkVHzrOvdGqIFHctyQ6Jb0yMo
x-ms-exchange-antispam-messagedata: Umxn/qEG7j66i589fh1wWJxDSlGUrYM2daF2MoYiZWPLvL7OMuzxkYSnmMWuyPaCuGmWapHwbZFzf4vHXdE2zsH2AD2HnNNtB9pBVzf7p7tt6kkAhuMLm979PlUs7L1uEqTPRl8GwmylDTBAhPFlYw==
Content-ID: <2C3C9D2110CAC3499E56C274878C1D4D@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2251
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(46966005)(70206006)(81156014)(6636002)(6862004)(5660300002)(8936002)(8676002)(4326008)(6486002)(47076004)(336012)(478600001)(63350400001)(6512007)(2616005)(2906002)(356005)(81166007)(36756003)(33656002)(26005)(82740400003)(86362001)(54906003)(37006003)(316002)(36906005)(6506007)(186003)(70586007);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: e7985c54-5911-48bf-967b-08d7e5d98e7f
X-Forefront-PRVS: 038002787A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A4cDN1swP5uUiIMYnJ7ICLp9/WEciY0myhQMAP1kXMXt9M99oACy+qR8XD68MPi4WXZzkA7vVLytjJQyPZV70xSAVvBCJH8AaH41Nsuoyj2zxzSm3gw/ohmKB0K9fSTdfol/BSmVE4rd1eNIl7doEYcm9Qx24BK6MaOFyl8R32ChdnmVFc+h2ZPZVQBFI/E2DqVJqusHpibl/8zbY9yua5YdZj6fhcWazV3PD3Hs9AxKQQOVUD4oiLH9HliDLK+xzv2VdQ+L+DkYuXbYMtLI8oHZbP2LSKwZdmKsStsHsWbDlnMUp/VSjLMq1WKG6eC/vyK90T2KC35rQoTq8k17bliK6EYG5Vrn/Vh1ydag5PyknFahej/DUnYR/4QsxQPhKCDOc7Ei3+vBTWwB633uX5Yaxcnrk2SwoSpuUjUl4QPmG3HBsnDTaG9ghgepUmtNZBDPUwXreK2XqU5MvwwOUMnG3D4M0G9GieUkLxWqwdRz4g30nsHvgmZO23mtIFgsMRIlT6tzkeVEYm9Bu/knZA==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 09:51:33.6943 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef5f0e5-3023-45b9-d043-08d7e5d99359
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5324
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyaywNCg0KDQrvu79PbiAyMDIwLzQvMjEsIDU6NDEgUE0sICJNYXJrIFJ1dGxhbmQiIDxt
YXJrLnJ1dGxhbmRAYXJtLmNvbT4gd3JvdGU6DQoNCiAgICBPbiBUdWUsIEFwciAyMSwgMjAyMCBh
dCAxMToyMjo1NkFNICswODAwLCBKaWFueW9uZyBXdSB3cm90ZToNCiAgICA+IEV4cG9ydCBhcm1f
c21jY2NfMV8xX2dldF9jb25kdWl0IHRoZW4gbW9kdWxlcyBjYW4gdXNlIHNtY2NjIGhlbHBlciB3
aGljaA0KICAgID4gYWRvcHRzIGl0Lg0KICAgID4gDQogICAgPiBTaWduZWQtb2ZmLWJ5OiBKaWFu
eW9uZyBXdSA8amlhbnlvbmcud3VAYXJtLmNvbT4NCg0KICAgIE5pdDogcGxlYXNlIHNheSAnc21j
Y2MgY29uZHVpdCcgaW4gdGhlIGNvbW1pdCB0aXRsZS4NCg0KT2ssIEkgd2lsbCBmaXggaXQgbmV4
dCB2ZXJzaW9uLg0KDQogICAgT3RoZXJ3aXNlLCBJIHNlZSBub3QgcHJvYmxlbSB3aXRoIHRoaXMg
cHJvdmlkZWQgYW4gaW4tdHJlZSBtb2R1bGUgdXNlcw0KICAgIHRoaXMsIHNvOg0KDQogICAgQWNr
ZWQtYnk6IE1hcmsgUnV0bGFuZCA8bWFyay5ydXRsYW5kQGFybS5jb20+DQoNClRoYW5rcyEgR2xh
ZCB0byBnZXQgdGhpcy4NCg0KQmVzdCByZWdhcmRzDQpKaWFueW9uZyANCg0KICAgIE1hcmsuDQoN
CiAgICA+IC0tLQ0KICAgID4gIGRyaXZlcnMvZmlybXdhcmUvcHNjaS9wc2NpLmMgfCAxICsNCiAg
ICA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCiAgICA+IA0KICAgID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvZmlybXdhcmUvcHNjaS9wc2NpLmMgYi9kcml2ZXJzL2Zpcm13YXJlL3Bz
Y2kvcHNjaS5jDQogICAgPiBpbmRleCAyOTM3ZDQ0YjVkZjQuLmZkM2M4OGYyMWI2YSAxMDA2NDQN
CiAgICA+IC0tLSBhL2RyaXZlcnMvZmlybXdhcmUvcHNjaS9wc2NpLmMNCiAgICA+ICsrKyBiL2Ry
aXZlcnMvZmlybXdhcmUvcHNjaS9wc2NpLmMNCiAgICA+IEBAIC02NCw2ICs2NCw3IEBAIGVudW0g
YXJtX3NtY2NjX2NvbmR1aXQgYXJtX3NtY2NjXzFfMV9nZXRfY29uZHVpdCh2b2lkKQ0KICAgID4g
IA0KICAgID4gIAlyZXR1cm4gcHNjaV9vcHMuY29uZHVpdDsNCiAgICA+ICB9DQogICAgPiArRVhQ
T1JUX1NZTUJPTChhcm1fc21jY2NfMV8xX2dldF9jb25kdWl0KTsNCiAgICA+ICANCiAgICA+ICB0
eXBlZGVmIHVuc2lnbmVkIGxvbmcgKHBzY2lfZm4pKHVuc2lnbmVkIGxvbmcsIHVuc2lnbmVkIGxv
bmcsDQogICAgPiAgCQkJCXVuc2lnbmVkIGxvbmcsIHVuc2lnbmVkIGxvbmcpOw0KICAgID4gLS0g
DQogICAgPiAyLjE3LjENCiAgICA+IA0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
