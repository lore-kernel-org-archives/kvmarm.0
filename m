Return-Path: <SRS0=vB6B=MO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947A1C6377A
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 02:50:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 13B8360FEA
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 02:50:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13B8360FEA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80C2F4B0FD;
	Wed, 21 Jul 2021 22:50:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JKzjQOqxF9KY; Wed, 21 Jul 2021 22:50:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 334C44B0F3;
	Wed, 21 Jul 2021 22:50:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A441A4B0B1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 22:50:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pK65Hgnx4tBj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 22:50:03 -0400 (EDT)
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr10084.outbound.protection.outlook.com [40.107.1.84])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0E664A522
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 22:50:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC1q7Ps98cUKlNLpWRGfupweHDrAOwh0eB/Lsy4Cuc4=;
 b=w0WTbI/f5coomlHD4waWbSAHdAFyLg8GQmPWkeEVHdBjL8M2MTmIiCKr157l5ztoQy8f43Pnwq65t5WbgDjxTA6YzWy9W1qSmgN/6O9oTitUFZEZ9aonE1x1wQelSydITirxkA1VOud5SVcfiUeOAv1r43b/uZ/pwG8GQZTQcls=
Received: from DB8PR03CA0021.eurprd03.prod.outlook.com (2603:10a6:10:be::34)
 by HE1PR08MB2809.eurprd08.prod.outlook.com (2603:10a6:7:35::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.32; Thu, 22 Jul
 2021 02:49:59 +0000
Received: from DB5EUR03FT058.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:be:cafe::b5) by DB8PR03CA0021.outlook.office365.com
 (2603:10a6:10:be::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23 via Frontend
 Transport; Thu, 22 Jul 2021 02:49:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT058.mail.protection.outlook.com (10.152.20.255) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 02:49:59 +0000
Received: ("Tessian outbound 664b93226e0b:v99");
 Thu, 22 Jul 2021 02:49:59 +0000
X-CR-MTA-TID: 64aa7808
Received: from f5c932105ff2.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 C1FFD6DC-D51C-4901-AFF9-213BA6602163.1; 
 Thu, 22 Jul 2021 02:49:54 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f5c932105ff2.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Thu, 22 Jul 2021 02:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kG2u+n3w76AGpHxtyFVDv8Uv4h5PaP0Hrcq27s6dsbSRNfsVh8yZhfQAavbGM1h67fU7LyNCShy4KLoRcDjHzQ6x1sVFBjIIYT8+AwbjGLzUZOV+jd7L0PHz6E/ZI3a0NZY7a3HDXxGYzTNvcYHy7XMp/EO9zuT+3ulnYkRZZl19u2mlC7/4CeLku2VvtB3StEbWl7Po2P5KXKdfjr8lrgZ3/Yj3ZvGg0Q5PFyFe9AEzUFvfSLuEgAlkTF/HCq/8enG76Zd750PfEcUkQqTSmYAGead9Rcsjc/qK/h6b7N/0w37EQnX/Om6FtpfIkN6476CjNIR2nEqaVuuhyGQivg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC1q7Ps98cUKlNLpWRGfupweHDrAOwh0eB/Lsy4Cuc4=;
 b=RZlo1bCho6tlYB+32xikCuciCLmbdAH2mhoIDZglwu41PrB0zy7lBngu0dLDocMuyYCs3dlrWw1nDuUZcdYDcIBgRHVMgNP7t7sz8+J7/dEViEYuU4PAH2mPf+/9Wvn3rmiFWuOeK0UoLcsZIacjfE9KYpEw98VlcoYMIF6LKxNdNMfwj1d6kqNHyfAIWS/pcC7um76nmTbtNFIhVkl4G2s2zFb1CFAZNwrD/IUfy/ZwAv77tsxjvpupAwCFfW6zsDYMj9F7MOgFBE1qi2YeLrgvwPyrOFEfqITAmDmzW1aQB4OheDyqlvmc9gPo3mFFnHJJGfIEue77O2SKG2mS7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC1q7Ps98cUKlNLpWRGfupweHDrAOwh0eB/Lsy4Cuc4=;
 b=w0WTbI/f5coomlHD4waWbSAHdAFyLg8GQmPWkeEVHdBjL8M2MTmIiCKr157l5ztoQy8f43Pnwq65t5WbgDjxTA6YzWy9W1qSmgN/6O9oTitUFZEZ9aonE1x1wQelSydITirxkA1VOud5SVcfiUeOAv1r43b/uZ/pwG8GQZTQcls=
Received: from AM9PR08MB7276.eurprd08.prod.outlook.com (2603:10a6:20b:437::11)
 by AM9PR08MB7119.eurprd08.prod.outlook.com (2603:10a6:20b:41f::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Thu, 22 Jul
 2021 02:49:52 +0000
Received: from AM9PR08MB7276.eurprd08.prod.outlook.com
 ([fe80::418f:7877:8c88:5b6e]) by AM9PR08MB7276.eurprd08.prod.outlook.com
 ([fe80::418f:7877:8c88:5b6e%5]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 02:49:52 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] doc/arm: take care restore order of GICR_* in ITS restore
Thread-Topic: [PATCH] doc/arm: take care restore order of GICR_* in ITS restore
Thread-Index: AQHXfhHId+GcJ7DQt0CbtBH7VL2wwqtNMGmAgAETNNA=
Date: Thu, 22 Jul 2021 02:49:52 +0000
Message-ID: <AM9PR08MB727690189F03ED71450B8EB3F4E49@AM9PR08MB7276.eurprd08.prod.outlook.com>
References: <20210721092019.144088-1-jianyong.wu@arm.com>
 <87czrc2dsu.wl-maz@kernel.org>
In-Reply-To: <87czrc2dsu.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 0BAB9F8C41060C4880A4AAEDE2B9F37C.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 88b7778b-f3a7-4375-2a13-08d94cbb6583
x-ms-traffictypediagnostic: AM9PR08MB7119:|HE1PR08MB2809:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <HE1PR08MB2809B7259AFDA4B07E18532EF4E49@HE1PR08MB2809.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: OUTuunrfhkf+KcxJ7RP1G05o19h8i7Xo4qEjVkPJsRx1FzqsUl3jxGR56BBfW4dYr3Ou99uPx9jbw5tMBa5RYrBTyY1ipxUoOJlhioZyilMyNSF46arSGKS8/F+w/1KuPBwYkfduF9W0yH7mD9bnna2B1F8hKT64vLSFrePnmJyP4Ra+81qMRgrDaw7osRA8t+JQqlpszehqyyNy/q8n1HI88Vf8kroZ6GCh6U5M0ozS4DuO74kGQQDhWXA0s9Dz74hdGP3HkngbOo7OblP4vEuzcbt9TdK9vDJiCKbpJcD1mS80cP5sXi/kNKU37WOPARS9vi2sWURlqz1BvJdvQPBOIJUt8k2h8FkJn0crt8v6QR24NKyg404pGn2e9G8xGmzVa7n1I/NqVKjyajvex/sWo7DhP9xsmh0bPRubsZuV4J2fiDLe4iGHK8TCFarxUkTto7ocY45LMCeR2fOobBgFgjKA2Y0254yjbpF5G0oW6TM15tHnUQcIMamF4Ir/F8uepY7zBqfVZmhvgMrlr3LWwZyTiFsTLpZabvgyIe8ND5dCfdo58rZXzymOj7rhmt/Iq2azKoWQ0K162J5Y8FAPBc74cdhUQ53kEy48+Le5JSdG5XjcYW6L11xCQcGRz/efa6QdSL3fWZgGAckkqsUZgT3eKbmzvDIJjkYxwhd2rjyKTZenhXDXTODd9BSsyzPsY7xUfFkkHHZlJqTYBw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AM9PR08MB7276.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(136003)(346002)(39850400004)(366004)(396003)(376002)(4326008)(186003)(53546011)(8676002)(2906002)(86362001)(33656002)(66476007)(26005)(66946007)(71200400001)(64756008)(76116006)(66556008)(52536014)(8936002)(66446008)(5660300002)(83380400001)(316002)(55016002)(6916009)(6506007)(478600001)(54906003)(7696005)(122000001)(38100700002)(9686003)(38070700004);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qmlx7XsYcY0OEw4ctdJ6etrrCWUROEabAEJo0OdjAZ9dTOIv8rvwYFExc+Cq?=
 =?us-ascii?Q?LsAWGtPpZIw4G62zJTSOrp6opanOE6Kmh/ISYnExKp9S59w9pM3pViTy6F65?=
 =?us-ascii?Q?IkM32K6xzNdKepgPdCK2H/4a28l+1U7uA4mt7mKkpQOll0R0R4sCdTuexuTz?=
 =?us-ascii?Q?lRTfp6xqp/y523wWVyjmqncfHMuEwQM4VJmYapRjhDn4M6BKFNMuVxXfiOLh?=
 =?us-ascii?Q?9vYvvX5nvP6ewM+yslXisMQ29ZBwzIu1EPj+pQYIwiHFCRRrnLAulfV7oJ5+?=
 =?us-ascii?Q?dkrz5mmeyXAyJbpTruKMIHm/NL7SrTI68TOI0FrFo3wuESRLLnQVldQEf8He?=
 =?us-ascii?Q?f2WroSmtKS6Blub4SzY/NW0YBR0pR6OtxlcoTsvIkr2O43Dtg99CBbE+P4UO?=
 =?us-ascii?Q?pwhsBO6r0zK0ObncH91UVs2DPlkeuF81D2/w0yKeoTImLk1GF5Fn87kYejYK?=
 =?us-ascii?Q?5wJQSSY2vcZTw68gKF+IXBIMzstmwuwbS1ifcFDI6Mi2oj7jAX8TR/zFXcwg?=
 =?us-ascii?Q?O3LrQ5McKqCnTeou+l1Gb38JVoi1S+IAEg/b427vMW+Ny09aOplYBlsKm9Xd?=
 =?us-ascii?Q?mIyx5bdPZsWlb3BDC532AdZDiq0PGalRSjSjvdtJW0UZG+GNyaRWqh3Iu5OU?=
 =?us-ascii?Q?tmOUZPkhJCDDrJgp7yrv8ytNmeN3RKBbvVlgbZ6XZeACUQjpo20Sn7lRLIRb?=
 =?us-ascii?Q?DcNz35p1OuAeC3pvwMwIgpR60oZWTBp2b6JKh2I+AztwOpH7UdYj5J7k8UyP?=
 =?us-ascii?Q?0hHAeuanbmsu4VwIDx1LW6ydx7jDTm0oxB3MO21pVEDEvzMOtMKUZYzIkyzI?=
 =?us-ascii?Q?g9AlPdCIgvo6MJiX6rCXSJa4VVSO6cEHfWGehLcllYZiVrfggMvDdcwZTfph?=
 =?us-ascii?Q?D/hkQJNKjG+OOQRkvxkwhyx7gLKkgLRbW3vKt1T9OA7fumqrbir8pTrKwoId?=
 =?us-ascii?Q?OkHNZCuyty6+gAoVqoe5yvGJ4cjaOitqH5ygAq+li1gW/vMfWWk+E44PztfB?=
 =?us-ascii?Q?LQx/33X0pZSRqaeHO68AkrnGTHyTMRsS/k2y6hZ68TSd05869bTSpxQDvQL1?=
 =?us-ascii?Q?ec+Kzo5dMUr7lNjBEOtaAmZEn37nr+igoxVxS+mdNzGzc3PKtxw1t1P8FRp1?=
 =?us-ascii?Q?2mwFDx8vpAMa3+yh8XQVj5Deyzua7xG/MKGpsPONw2q1yEe9Uvg+9ks7J2fO?=
 =?us-ascii?Q?1mj8URfd55dGFiKRzIOVw7zff3JQWSx4xwG4nCe++pMHxH+S583DPboboDEy?=
 =?us-ascii?Q?BUshXZEYeKA+nXsic2SYwGCSQeLDMghsopdT1Wd3DLslh1dkknTqvWxwOFtx?=
 =?us-ascii?Q?WYGUW7x47fYd6UHA9NIwBreo?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB7119
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 3a9b4bb6-bff5-4d97-1cbb-08d94cbb6181
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zhS9CyGC6e/nFUumIcnyH6HCVsL9mgRMm/GdRddCEcwZgTnFgez4RoZwyie8cXTuDKpGfw5MPyU2xAXRBnkD4+V3n7SyJ31/RzjZHl0ysLOPbZEsZ+OuWrZCaZyAqvMWrHjpZbOvELO5bHqz7Lqw1l2tXp8aXXuEuhjVzXa1pQ1/K9U7jPxjttrOpMvOn81RyMio6WIxUolCgbda4IJBZBt2x528HXt5Bf6OokVuotNt81DBD0wedK68Wowga/WTR44Lz+Wsv9aEw9vgkuz6QGI3MQVIbQ15ZRKECZ7qGS1sr4H9VHCzamA4i7AX1EmARbIoEPI6XwVb1+Le5SLFmSPaaUeMKSvts5W+C1zeM/u3uFeB/8PDIfN0lexX7UOv1Q0k4ZxXtfCmwojndEGWPtXuR2hxRopAV/MgCK7aXILSAs23CCow8nzTYHd3VYcjCOV07ioh+uByXgcFYNwyHxO4Cr42t/EqKJVHLmHkLvgNJFBK1L0WahAmoTgEcviuZd0NubQR9I9748ZGXGMx4K9qgyrVpwSCymB5VNa2jSn28pLGBcrqlE67mblbvY/H2uJfnjheSNaOYZttOJhhbh7nBr6MpQqSz4EhrWrHLcPmZ20IZ0KQZu3vn6+15ayFWyDxL0TRIPookpfkZKT5iqlbHAFuRtNB+qQRienI4cj3K1TaOJv8WelZLbAQO43igu+40ykEZFFvDwMuctKrg==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(136003)(396003)(376002)(39850400004)(346002)(46966006)(36840700001)(7696005)(82310400003)(9686003)(47076005)(6862004)(53546011)(356005)(2906002)(81166007)(6506007)(86362001)(36860700001)(82740400003)(186003)(4326008)(8676002)(5660300002)(33656002)(52536014)(70206006)(70586007)(8936002)(316002)(54906003)(478600001)(336012)(26005)(55016002)(83380400001);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 02:49:59.5256 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b7778b-f3a7-4375-2a13-08d94cbb6583
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR08MB2809
Cc: Justin He <Justin.He@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 Andre Przywara <Andre.Przywara@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lushenming@huawei.com" <lushenming@huawei.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

Hello Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Wednesday, July 21, 2021 5:54 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: James Morse <James.Morse@arm.com>; Andre Przywara
> <Andre.Przywara@arm.com>; lushenming@huawei.com;
> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; Justin He
> <Justin.He@arm.com>
> Subject: Re: [PATCH] doc/arm: take care restore order of GICR_* in ITS
> restore
>
> On Wed, 21 Jul 2021 10:20:19 +0100,
> Jianyong Wu <jianyong.wu@arm.com> wrote:
> >
> > When restore GIC/ITS, GICR_CTLR must be restored after GICR_PROPBASER
> > and GICR_PENDBASER. That is important, as both of GICR_PROPBASER and
> > GICR_PENDBASER will fail to be loaded when lpi has enabled yet in
> > GICR_CTLR. Keep the restore order above will avoid that issue.
> > Shout it out at the doc is very helpful that may avoid lots of debug work.
>
> But that's something that is already mandated by the architecture, isn't it?
> See "5.1 LPIs" in the architecture spec:
>
> <quote>
>
> If GICR_PROPBASER is updated when GICR_CTLR.EnableLPIs == 1, the effects
> are UNPREDICTABLE.
>
> [...]
>
> If GICR_PENDBASER is updated when GICR_CTLR.EnableLPIs == 1, the effects
> are UNPREDICTABLE.
>

I think this "UNPREDICTABLE" related with the "physical machine". Am I right?
In virtualization environment, kernel gives the definite answer that we should not enable GICR_CTLR.EnableLPIs before restoring GICR_PROPBASER(GICR_PENDBASER either)  when restore GIC ITS in VMM, see [1]. Thus, should we consider the virtualization environment as a special case?

[1] linux/arch/arm64/kvm/vgic/vgic-mmio-v3.c
static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
                                     gpa_t addr, unsigned int len,
                                     unsigned long val)
{
        struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
        struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
        u64 old_propbaser, propbaser;

        /* Storing a value with LPIs already enabled is undefined */
        if (vgic_cpu->lpis_enabled)
           return;
...
}

Thanks
Jianyong

> </quote>
>
> The point of this documentation is to make it explicit what is *not* covered
> by the architecture. Anything that is in the architecture still applies, and
> shouldn't be overlooked.
>
> Thanks,
>
>       M.
>
> --
> Without deviation from the norm, progress is not possible.
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
