Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED741C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 01:38:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7052B2076C
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 01:38:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="mPlvlPps";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="mPlvlPps"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7052B2076C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3A474B14D;
	Sun, 24 May 2020 21:38:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1WOEbW132B-x; Sun, 24 May 2020 21:38:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EB714B17F;
	Sun, 24 May 2020 21:38:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2102A4B19E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 May 2020 21:38:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pzf3sCeCEVKx for <kvmarm@lists.cs.columbia.edu>;
 Sun, 24 May 2020 21:38:10 -0400 (EDT)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50082.outbound.protection.outlook.com [40.107.5.82])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C6E04B1B4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 May 2020 21:38:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKpqPWiXwX1s9oHxaslGI9pPpxzD4WzD+JjXBLEXAPk=;
 b=mPlvlPpsypkcTTy3bE5rLRARa6PKR2zVzdFADqh58TmohK8o9DcaXE1kyN5ZvVFWfieg39PiyRIyCSxMO21gf+bav+Kx+MXWqUa1ja7UUP31rXAxqhZ5X7ZtokpAsH1sfkYO5s58Jhqg+J4bKeu49/z/iJd4ZVowfFYs8dj58YA=
Received: from DBBPR09CA0026.eurprd09.prod.outlook.com (2603:10a6:10:d4::14)
 by DB6PR0802MB2279.eurprd08.prod.outlook.com (2603:10a6:4:86::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Mon, 25 May
 2020 01:38:07 +0000
Received: from DB5EUR03FT061.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:d4:cafe::18) by DBBPR09CA0026.outlook.office365.com
 (2603:10a6:10:d4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend
 Transport; Mon, 25 May 2020 01:38:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT061.mail.protection.outlook.com (10.152.21.234) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 01:38:07 +0000
Received: ("Tessian outbound 14e212f6ce41:v57");
 Mon, 25 May 2020 01:38:06 +0000
X-CR-MTA-TID: 64aa7808
Received: from c2b5a79ceaa6.3
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 693EC451-4575-4919-98F1-8F17DF37F683.1; 
 Mon, 25 May 2020 01:38:01 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c2b5a79ceaa6.3
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 25 May 2020 01:38:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6jCtbtPIBNyIY40zKtu/lhZsWJPyOGCDI2BTGWq75zPYGVrsU+sVv62vf2lnJW/PgT5yjTN/8fERaLFo8G9noE5D5rmPKCoWCe3EaRmS03RQ2A/rMsAKf2BRkVLieuEAa6TrYFxGkdHlhQlcNKS+XH4wrHuuEow3B40Wl2QsFLZkpgwj7ZdXwJHOKcWrlxfupENOg+30X4qaioBKyiYiesf4moouRQkeaNolZvI0p+7sETVuILxbi0aOT5KdxpnIWhB34HJvLBG3Z0mn7tvdpCEf5IZJFUHnZJxu+fYbVxXMFQrXNpC2yBs5wTC2Fz76Oo9Zc2jo9UsQmTx6Vybww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKpqPWiXwX1s9oHxaslGI9pPpxzD4WzD+JjXBLEXAPk=;
 b=hmih+ze/ueyMQMevSSm2Sd41Ujcu4RjeiWJt0hEmZRZcvLihyN61eXROvx+PSCY1gZZdIcby6FYDKmhICCf48PNSryvHk67zDuYskxm5jtmEJS+xRPXtesZIY2jCHqlTES7jmke7leYyC9RYCoFaEnyd9pb755hhll/6nXaml5Wi/vE6QUJ0xHDcvHpCcc+3U1ZzmB9O4dwdESmQijdFmOxuUzdMtSONjryYfMllN57vsln1gpQEvVnI1anHNoCkTHOTzKvoRwOKKObbDep/q7up+fHQDjCpY52MdQpSHkdS3xydDtm+177aUfAxQs7Ppl7Ic04SWtywhZxqfJW7ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKpqPWiXwX1s9oHxaslGI9pPpxzD4WzD+JjXBLEXAPk=;
 b=mPlvlPpsypkcTTy3bE5rLRARa6PKR2zVzdFADqh58TmohK8o9DcaXE1kyN5ZvVFWfieg39PiyRIyCSxMO21gf+bav+Kx+MXWqUa1ja7UUP31rXAxqhZ5X7ZtokpAsH1sfkYO5s58Jhqg+J4bKeu49/z/iJd4ZVowfFYs8dj58YA=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2571.eurprd08.prod.outlook.com (2603:10a6:3:e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Mon, 25 May
 2020 01:37:56 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 01:37:56 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Subject: RE: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
Thread-Topic: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
Thread-Index: AQHWMBRUBAdOXBezXUymOTKynRIElai0FQYAgAP0TiA=
Date: Mon, 25 May 2020 01:37:56 +0000
Message-ID: <HE1PR0802MB255537CD21C5E7F7F4A899A2F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-4-jianyong.wu@arm.com> <20200522131206.GA15171@bogus>
In-Reply-To: <20200522131206.GA15171@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: aa67b612-5610-41a8-b27b-75dee5aeebf7.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6cc5f05c-9bd4-4e4f-39de-08d8004c4656
x-ms-traffictypediagnostic: HE1PR0802MB2571:|DB6PR0802MB2279:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB227977E4AFEE53EE9630F294F4B30@DB6PR0802MB2279.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: He+6Q0V00nxFHrY1xEK0fd8S4PAkqovfrtOloOzV0luMwAELHPf4X6nPfCL9SVzUvdWgvdb3vNTOJzHLHDYwSnKaJKTiwCVVdSZXmo5Dvkrq4sWWXuEyFRxchgXXJLAIojvYiq4EgqSOL8wm+IBhmhyJCj/6adMhpou3Ku2qoLMsoYVRZYD3zav/TiLqwvvn3E5ts/0f8tIjuGPIRVAIFbeAVX0G3OFwDbHRXiBBK48+mGhZV6Mbx6cGH1rZv+k8rcH3k+4sR1IqhPEzeRtnEOrueuuwy/UAObe4RZ0J92RMqA2zxNCZ7V89+poUATqhYs7GWwdO6kzKo8zO+vIrbH1+WCVOunexMFwIx9SFwXOHghxtL1K7LPjvGkHk4uxKAdovr28V3XJ4n3wLuSc7rg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(136003)(39850400004)(376002)(396003)(366004)(346002)(66946007)(7696005)(186003)(4326008)(6862004)(316002)(26005)(71200400001)(966005)(478600001)(6506007)(66556008)(76116006)(64756008)(66476007)(53546011)(66446008)(2906002)(6636002)(8676002)(52536014)(5660300002)(33656002)(8936002)(86362001)(7416002)(55016002)(9686003)(54906003);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: IX4exGaJJO0u81zqwTPgVsxsRWpw8zIg7OH2kYV02gHPbNmdRp3/+eqer3cVv0ux1Eyha29s+giRxo2AFA0b2ZkslOygM0Exu+8Mf5om+aREiwzzOm8cUvo9TUeoHbQpQ66TKV5wIG51/bABpbI6TT1cOiwts28uKhc2yRICVUJRhru7K7kYBMYuhsMnFtVFkB+m7zWcFI9rKZdgdY+kHiFN6J9U00OQkhXCjEyRZoCalO5EqD5eOtYNvwchRDBUT1zjMOh0Sids2Dbbun6oqA2lGM/HxZp2umqKimwxJhS2ITT+jcFzoHQs2ng7B84RXI+FMwPjFhVaat0LFVcLlSCdeUCkGjto1cXsYmWXTdD63/z1nqdizl7psZ95qoJhG+yCb57QEzn7dGFqiIK/PS9IWduFADyMuboLdgGvmvaM1VdtPtjcS2qH17LRnSuIbLGK7K/EMQ5rwl76LcQhJwY6KjGXrVYPXGvjtHWzrpw=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2571
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT061.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(396003)(39850400004)(136003)(346002)(376002)(46966005)(47076004)(356005)(82740400003)(81166007)(4326008)(86362001)(6506007)(8936002)(107886003)(26005)(186003)(53546011)(336012)(70586007)(6862004)(8676002)(7696005)(70206006)(55016002)(6636002)(316002)(9686003)(82310400002)(966005)(52536014)(54906003)(2906002)(478600001)(5660300002)(33656002);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: d651fffb-09ca-4a5c-058f-08d8004c4036
X-Forefront-PRVS: 0414DF926F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C4IbBQBbh5mrfifAsFwN8nCVCqzoeNVSLitQGITrXd4LGg1/61KOc6P8o3xuv5f4WqtIzIuLv5cpgoJWsCPkgV/7nlVMDfiKKAj8E0Ob6Nk7nwMUPmc4XebhQR4s2cO+S4NrGoQeUuzoAof0S31lPhqePL8YTI3ENbD4aEZmx+QTZ8BrvnKy7Litrtu6Iy/ZZDHWvMglf5Ebk/eAbSPpMnZxh22KobdRbp7fslMzBCahz/eo0jbNgqAmfbCbS9M0X7eUCH+4V+WeiAo06KXw4gCUbD7Gq4oMNp4vZov/+x7iPgP/xTs7hlSiOr5hzz/nmg3GMO33S/fYEqfKsqNlOLJX8D8dTOcGqCvYcZMdslR9l2BrFkcKaai1sy1UpOWmVBIHT8iW3/8fYQKayDoKSfjPcsYvLTP0BidBVNof1LB5oGRHNf+/MCM8R5G64GNfTlamkNNtQ+NJFqXo1FGlaQYDOf2GBrw50UTprHFOiGQ=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 01:38:07.0285 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cc5f05c-9bd4-4e4f-39de-08d8004c4656
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2279
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Justin He <Justin.He@arm.com>, Wei Chen <Wei.Chen@arm.com>,
 "maz@kernel.org" <maz@kernel.org>, Steven Price <Steven.Price@arm.com>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>, nd <nd@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Sudeep Holla <Sudeep.Holla@arm.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
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

Hi Sudeep,

> -----Original Message-----
> From: Sudeep Holla <sudeep.holla@arm.com>
> Sent: Friday, May 22, 2020 9:12 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>; Justin
> He <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; linux-
> kernel@vger.kernel.org; Kaly Xin <Kaly.Xin@arm.com>; nd <nd@arm.com>;
> Sudeep Holla <Sudeep.Holla@arm.com>; kvmarm@lists.cs.columbia.edu;
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
> 
> On Fri, May 22, 2020 at 04:37:16PM +0800, Jianyong Wu wrote:
> > Export arm_smccc_1_1_get_conduit then modules can use smccc helper
> > which adopts it.
> >
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  drivers/firmware/psci/psci.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/firmware/psci/psci.c
> > b/drivers/firmware/psci/psci.c index 2937d44b5df4..fd3c88f21b6a 100644
> > --- a/drivers/firmware/psci/psci.c
> > +++ b/drivers/firmware/psci/psci.c
> > @@ -64,6 +64,7 @@ enum arm_smccc_conduit
> > arm_smccc_1_1_get_conduit(void)
> >
> >  	return psci_ops.conduit;
> >  }
> > +EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
> >
> 
> I have moved this into drivers/firmware/smccc/smccc.c [1] Please update
> this accordingly.

Ok, I will remove this patch next version.
> 
> Also this series is floating on the list for a while now, it is time to drop "RFC"
> unless anyone has strong objection to the idea here.
Yeah.
> 
Thanks
Jianyong 
> --
> Regards,
> Sudeep
> 
> [1] https://git.kernel.org/arm64/c/f2ae97062a48
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
