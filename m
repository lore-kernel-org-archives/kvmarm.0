Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6F4C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 14:25:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D006022BF3
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 14:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D006022BF3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 058EE4B2D8;
	Mon, 18 Jan 2021 09:25:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OdLvrG6ciQf0; Mon, 18 Jan 2021 09:25:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73AE44B2CC;
	Mon, 18 Jan 2021 09:25:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79C194B2AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 09:25:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zWJ3DkhV2W5O for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 09:25:04 -0500 (EST)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05hn2218.outbound.protection.outlook.com [52.100.174.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B2C14B2A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 09:25:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tJzjAgWdBavjgnfHT85NUv8U0wERfEgm7hldBS/Z1A=;
 b=PzhAMcn4xbImStSzH+yCrh47oRiDZC3Hja8vG2aow4BI6hbjJhZooq363TTEijGCTIkFAxe5BavqdZ8HC5sZkcjW+2YrDaOR29qbY/MqfAdcmV31w1AbqCsSZnvOWp1UIBHW74KY7i8y9RG/uxMYCZIKoZon5aRizhtjbxYm6Wg=
Received: from AS8PR04CA0092.eurprd04.prod.outlook.com (2603:10a6:20b:31e::7)
 by DB6PR0802MB2389.eurprd08.prod.outlook.com (2603:10a6:4:9e::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 18 Jan
 2021 14:24:59 +0000
Received: from VE1EUR03FT034.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:31e:cafe::11) by AS8PR04CA0092.outlook.office365.com
 (2603:10a6:20b:31e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend
 Transport; Mon, 18 Jan 2021 14:24:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT034.mail.protection.outlook.com (10.152.18.85) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.12 via Frontend Transport; Mon, 18 Jan 2021 14:24:57 +0000
Received: ("Tessian outbound 587c3d093005:v71");
 Mon, 18 Jan 2021 14:24:57 +0000
X-CR-MTA-TID: 64aa7808
Received: from b9d79c9fbb85.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 3463A298-229C-454A-BF5C-4FC0B68308FE.1; 
 Mon, 18 Jan 2021 14:24:52 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b9d79c9fbb85.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 18 Jan 2021 14:24:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oW3k/TE1yHlUSXil3LsAaGSc2dOvSCJsArUGuLBNA4da2DmueIBpb5NZXz3ysH3bBt60CSKTlB/Q9xnp0oKdKhVWmA5urkPvS8T6gky0D7kzMX+dMnf86m4vil9/x6Ya5+ZKe1a747z6Q+JsheDe1g/DiZb83+2CyL4uv4+C5xVntPWKEAv+E9V+VbQpuEVpqYsD/m65+GxtK7QWuLv3U9dP/++TOw2eVioYcKJp/+2Y0e+ervuKVclNkD4nyss8KDmg80eBtxGzOmhx0R00yMD23sRvLM+tHM3pmKUkPKbOcyZo2raxrIU+av4bi3VSEqhLs5qzpHyjBOAHFNXtuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tJzjAgWdBavjgnfHT85NUv8U0wERfEgm7hldBS/Z1A=;
 b=EeDmZPEzLDuSwfm2cb7r3PSgO5OezPmuURYjqOw01nbtNVXSxqXlSapPzqkjOiZTO0xh56b0OsHT3f42+7W8NBMJVsCVSrB+TWcF1BpDR3cPWQFqdoaJKGes3BaMyTB7G1kQTtZ/TT/N/mxuLpahPqf5CQ8+Y6A7b5ixCmvs9orcUY7EIAgONH5E82dWwaZi07YsDZhoRUFT9Q1jsBwjt0jqnIMkKfifATo9yrkx4QBXem95yWfx+oZPjpQzBj3uqtJXeJd1CEHpMVze3c+cvGIIPz74/WG+7F05tKHiqsDLqOF0TMaOkeYX21qzFSNiuCOrq9Vf6pvtn5Sa5sZHpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tJzjAgWdBavjgnfHT85NUv8U0wERfEgm7hldBS/Z1A=;
 b=PzhAMcn4xbImStSzH+yCrh47oRiDZC3Hja8vG2aow4BI6hbjJhZooq363TTEijGCTIkFAxe5BavqdZ8HC5sZkcjW+2YrDaOR29qbY/MqfAdcmV31w1AbqCsSZnvOWp1UIBHW74KY7i8y9RG/uxMYCZIKoZon5aRizhtjbxYm6Wg=
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com (2603:10a6:802:a9::18)
 by VE1PR08MB5565.eurprd08.prod.outlook.com (2603:10a6:800:1b2::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 18 Jan
 2021 14:24:49 +0000
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8]) by VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8%2]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 14:24:49 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Topic: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Index: AQHW6yEqdqBYWsMmd0S229FS8rLcnqooiq0AgAFUzWCAA3ehMIAADZUAgAADSBCAAAG/gIAAAXlw
Date: Mon, 18 Jan 2021 14:24:49 +0000
Message-ID: <VE1PR08MB4766C32A030F964D6D620F58F4A40@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20210115093028.6504-1-jianyong.wu@arm.com>
 <6f5a2ce458e33f879635f45140293517@kernel.org>
 <VE1PR08MB47664805860F1156223A7615F4A60@VE1PR08MB4766.eurprd08.prod.outlook.com>
 <VE1PR08MB47669476FED079360D67B5FEF4A40@VE1PR08MB4766.eurprd08.prod.outlook.com>
 <31dd6e2f8b3980337c8093d2ab626636@kernel.org>
 <VE1PR08MB4766C8FE66A84082326A4090F4A40@VE1PR08MB4766.eurprd08.prod.outlook.com>
 <f612e22b00f32a4de9dcfeafd7c441a2@kernel.org>
In-Reply-To: <f612e22b00f32a4de9dcfeafd7c441a2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6FAC325B4EDFFD46AD3546150C91EFBB.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [120.204.102.143]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6f3629f9-d874-48d8-ba22-08d8bbbcd562
x-ms-traffictypediagnostic: VE1PR08MB5565:|DB6PR0802MB2389:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB23890844F74A9BD17DCDA7A1F4A40@DB6PR0802MB2389.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: S1KfOIAZBvh1+KIuDB8y7nYeXShOxsdTJo/R+OgobB+0ralCxfmyRgL62hFsgZDxTHJUEDuqWWPA44wiKSpFCgp5CpHRgX9YJ7jgkAIiDqe1ewls43023NZYuu9uKGPTAPhZyemxDodgiRZs+4Ki/BpVSgVAipnfjq6TvHqW3MIouG7yuaNkGP9YFtz7uksDKwnJ6vnG0DIATKVKLV8emJsAeJUVL8kY+0oEZSKQG2G1t+L4aFgV0MJoxYymR8QA0KPhhO5zHXYtfUGvNjkqAFC8rPEpgV14HNGZ4k7GhN4Y2UBqkITOQmNHjdE6IU+AIYZz6zFOPd9Qk2V+nOzrbg/ofaWyhewwHahfIUFg2M1wWPlH6EAcOdAw3Ojo3fQ+HTPvNWKeyQTLXsqLHGEXhVSXQqfc6otrSVwdE4YKuJJal9gvSTjvj4KdY9xAfzUO4Ii+GDbIDvLe66vm1rO4r50zcYfGEFiUvlwhfZytmXJS7bmwb/KvHxlZS6PzXeEvWP/Fh/DynDO3H2P06IJqZuuYPhxG4dcnK22CM1sEjGY2iO55k0o3MVFVdHWf8m14u9zrcj/5UKLso4tJVM1D4C2XuByXCLava5inCIqMbOk=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VE1PR08MB4766.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(316002)(54906003)(7696005)(8676002)(83380400001)(86362001)(9686003)(52536014)(55016002)(66446008)(966005)(6506007)(478600001)(66476007)(4326008)(33656002)(53546011)(66556008)(64756008)(26005)(8936002)(76116006)(186003)(6916009)(66946007)(71200400001)(2906002)(5660300002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OVKCxfznYwKDKlLbm+i6zE5jLoBYwNcOKc7TmDcrYgS6Jc2+oosSx+16Ivz1?=
 =?us-ascii?Q?sCAAQBTW0x68XglCadHU76wXFr0NIsA6l/wIx4N4Lvir9T7Gwrfu6TXJP3NI?=
 =?us-ascii?Q?WVBjYwt2YbpZt98hdIlnoJnYF3qM2KP8WhMBfbYmCmZDk2YwaOFptExaohod?=
 =?us-ascii?Q?VqHRQZYvtjJas3SEJtR8AYOmkHMDkowgmH5yNEtcIVpqNJegd4qCQSUe110p?=
 =?us-ascii?Q?SpXQ8c+/d9oxRyD3lyLmssLWwc+FjEq0QPFmwa19Gy7k04gTAWE2IuNZBavl?=
 =?us-ascii?Q?1FgiWoe3/Cv53swAYViFxPRUDyoODwZge0XKRKNiwbxvQ4c/crZeOU1DyGam?=
 =?us-ascii?Q?kqJBOdjuJuwKaxadtPtgJAIsj77s9brwoO3b2OQrZKoCpEIYfCw/Q5PQjy9U?=
 =?us-ascii?Q?s6A16tbZL7DG3ELhr4Y9BNrF6xrzbp2lgKfIQEroUWuOnTYDfxS7jH3IEeF1?=
 =?us-ascii?Q?9NkQWDKbJEhLeitOM9cY3KzdgHYHxb2Bc4DSA1rBWKBOa66oFU31Z5fEScwV?=
 =?us-ascii?Q?y2uBvGYVI90ha+zHnhgeaQeFVzPMGGtx/5CN3KvUxZBmuIIENXxbYyk0t97P?=
 =?us-ascii?Q?3pWLjL9HkkVnZC4O/6p+4C3AzChy2Uq5T4bv7EB1uCpG2pTyaFd/xGEhpfyg?=
 =?us-ascii?Q?DlP0dNOtHa+zFlQiNwNk5L7ZInggh106tPzHx2zBauICDLTcpSO8ggMkdsJG?=
 =?us-ascii?Q?U78RctPzmvyFlKnn2w02RoZGSahwel5aDUk2Njp7VCXz+CKqPjEVwFERS84K?=
 =?us-ascii?Q?oR/4ybLl2RrkUnFwtoc+2J32ustpCj38/EuDPOv/vHVXG8yvlyltTRBci/y+?=
 =?us-ascii?Q?c/JWQPx8Pcim0e4hsQAiBfgdE5P/urZavVNhM7TS1TR+8UPtrRjHEzUiOInY?=
 =?us-ascii?Q?gITMdzHvK2e4PAJAnDSC8oMKAXcP19sc5SGHj5bgIVC00n2NTrdWOSW23T53?=
 =?us-ascii?Q?weHdrQR7l3jGpOR75QsUWTRaLCkHfx95f1O3ghT3Sdo=3D?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5565
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT034.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: f89ca4a7-4c1e-4c2d-b405-08d8bbbcd03d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mAUb/UUVCuxMlYKBtmM9+8SZyX+gSDl2WWOduS1Rhpmn2s8TWm77qLS9s0eS3rUBgkUle5KJ58Bqpzx6z3o/BSm7qgDh6K2cMKC2dIkAcZFu0GknPmyc9XxTfxYY9eUY+zstxLbF3yUlg59+IQfQ65SaLVf1UURDQYTUHS6NHwKRmkjGHV/7kO9sDhjs59tDYC7KuH3oPCjQVsuq2amUdJF3uXRHbfQAGXIxNt/n+DYjFeIv96nISFgGOCWJyCe6qrIUYSFGkBjchhY6Dy0SSpFOqAk755eGvKsSq2Um6n+rSF5Ip4jmsbvpIQa5Ddk1D9t8gCx2RgZnUyvSLf78FAiH22lnvB3vKVLJBPpKpX8et4MmLjUaYqsNbYJ0UF5b9EP4zm7mfnI35aAt5Qrlnu4tUpAUDac9KafyJFGfyw5fewwFDfseESQffT7yVavWQZmv4RR8sEMzy5aTmuOmpngmxJ9Tivy8hLwGESPubArr9GXT52vcx1nWzeLUfChknlE1AaVyvag5dqdpzrfjT9zJqPEFOfjDeCwKtLT6w5s=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(346002)(396003)(376002)(39850400004)(136003)(46966006)(47076005)(81166007)(356005)(2906002)(8936002)(478600001)(9686003)(5660300002)(186003)(26005)(316002)(8676002)(86362001)(83380400001)(336012)(34010700045)(70586007)(70206006)(6862004)(7696005)(54906003)(966005)(107886003)(82310400003)(52536014)(53546011)(55016002)(82740400003)(33656002)(4326008)(6506007);
 DIR:OUT; SFP:1501; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 14:24:57.9469 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3629f9-d874-48d8-ba22-08d8bbbcd562
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT034.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2389
Cc: "will@kernel.org" <will@kernel.org>, nd <nd@arm.com>,
 Justin He <Justin.He@arm.com>,
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



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Monday, January 18, 2021 9:44 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: Justin He <Justin.He@arm.com>; nd <nd@arm.com>; will@kernel.org;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] arm64/kvm: correct the error report in
> kvm_handle_guest_abort
> 
> On 2021-01-18 13:38, Jianyong Wu wrote:
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Monday, January 18, 2021 9:26 PM
> >> To: Jianyong Wu <Jianyong.Wu@arm.com>
> >> Cc: Justin He <Justin.He@arm.com>; nd <nd@arm.com>; will@kernel.org;
> >> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> >> Subject: Re: [PATCH] arm64/kvm: correct the error report in
> >> kvm_handle_guest_abort
> >>
> >> On 2021-01-18 13:04, Jianyong Wu wrote:
> >> > Hi Marc,
> >> >
> >> >> -----Original Message-----
> >> >> From: kvmarm-bounces@lists.cs.columbia.edu <kvmarm-
> >> >> bounces@lists.cs.columbia.edu> On Behalf Of Jianyong Wu
> >> >> Sent: Saturday, January 16, 2021 4:47 PM
> >> >> To: Marc Zyngier <maz@kernel.org>
> >> >> Cc: Justin He <Justin.He@arm.com>; nd <nd@arm.com>;
> >> >> will@kernel.org; kvmarm@lists.cs.columbia.edu;
> >> >> linux-arm-kernel@lists.infradead.org
> >> >> Subject: RE: [PATCH] arm64/kvm: correct the error report in
> >> >> kvm_handle_guest_abort
> >> >>
> >> >> Hi Marc,
> >> >>
> >> >> > -----Original Message-----
> >> >> > From: Marc Zyngier <maz@kernel.org>
> >> >> > Sent: Friday, January 15, 2021 7:21 PM
> >> >> > To: Jianyong Wu <Jianyong.Wu@arm.com>
> >> >> > Cc: James Morse <James.Morse@arm.com>; will@kernel.org; Suzuki
> >> >> Poulose
> >> >> > <Suzuki.Poulose@arm.com>; linux-arm-kernel@lists.infradead.org;
> >> >> > kvmarm@lists.cs.columbia.edu; Steve Capper
> >> <Steve.Capper@arm.com>;
> >> >> > Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> >> >> > Subject: Re: [PATCH] arm64/kvm: correct the error report in
> >> >> > kvm_handle_guest_abort
> >> >> >
> >> >> > On 2021-01-15 09:30, Jianyong Wu wrote:
> >> >> > > Currently, error report when cache maintenance at read-only
> >> >> > > memory range, like rom, is not clear enough and even not correct.
> >> >> > > As the specific error is definitely known by kvm, it is
> >> >> > > obliged to give it out.
> >> >> > >
> >> >> > > Fox example, in a qemu/kvm VM, if the guest do dc at the
> >> >> > > pflash range from
> >> >> > > 0 to 128M, error is reported by kvm as "Data abort outside
> >> >> > > memslots with no valid syndrome info" which is not quite correct.
> >> >> > >
> >> >> > > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> >> >> > > ---
> >> >> > >  arch/arm64/kvm/mmu.c | 12 +++++++++---
> >> >> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> >> >> > >
> >> >> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index
> >> >> > > 7d2257cc5438..de66b7e38a5b 100644
> >> >> > > --- a/arch/arm64/kvm/mmu.c
> >> >> > > +++ b/arch/arm64/kvm/mmu.c
> >> >> > > @@ -1022,9 +1022,15 @@ int kvm_handle_guest_abort(struct
> >> kvm_vcpu
> >> >> > > *vcpu)
> >> >> > >  		 * So let's assume that the guest is just being
> >> >> > >  		 * cautious, and skip the instruction.
> >> >> > >  		 */
> >> >> > > -		if (kvm_is_error_hva(hva) &&
> kvm_vcpu_dabt_is_cm(vcpu))
> >> >> > {
> >> >> > > -			kvm_incr_pc(vcpu);
> >> >> > > -			ret = 1;
> >> >> > > +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> >> >> > > +			if (kvm_is_error_hva(hva)) {
> >> >> > > +				kvm_incr_pc(vcpu);
> >> >> > > +				ret = 1;
> >> >> > > +				goto out_unlock;
> >> >> > > +			}
> >> >> > > +
> >> >> > > +			kvm_err("Do cache maintenance in the read-
> >> only
> >> >> > memory range\n");
> >> >> >
> >> >> > We don't scream on the console for guests bugs.
> >> >> Ok
> >> >>
> >> >> >
> >> >> > > +			ret = -EFAULT;
> >> >> > >  			goto out_unlock;
> >> >> > >  		}
> >> >> >
> >> >> > And what is userspace going to do with that? To be honest, I'd
> >> >> > rather not report it in any case:
> >> >> >
> >> >> > - either it isn't mapped, and there is no cache to
> >> >> > clean/invalidate
> >> >> > - or it is mapped read-only:
> >> >> >    - if it is a "DC IVAC", the guest should get the fault as per
> >> >> >      the ARM ARM. But I don't think we can identify the particular CMO
> >> >> >      at this stage, so actually performing an invalidation is the least
> >> >> >      bad thing to do.
> >> >> >
> >> >> > How about this (untested)?
> >> >
> >> > I have tested for this. It works that DC ops can pass on memory
> >> > range for rom. But there is performance issue. It takes too long a
> >> > time that do DC on rom range compared with on  normal memory range.
> >> > Here is
> >> some
> >> > data:
> >> > Ops                  memory type                                size
> >> >                   time
> >> > dc civac         rom memory                                128M
> >> >        6700ms;
> >> > dc civac       writable normal memory             128M
> >> > 300ms;
> >> >
> >> > It's a single thread test and may be worse on multi thread. I'm not
> >> > sure we can bear it. WDYT?
> >>
> >> The problem is that the guest is invalidating one cache-line at a
> >> time, but we invalidate 128M at a time in your example.
> >>
> >> I would say that I really don't care how slow it is. We cannot know
> >> which address the guest is trying to invalidate (as your commit
> >> message shows, there is no syndrome information available).
> >>
> >> So it seems our only choices are:
> >> - don't do any invalidation, which is likely to break the guest
> >> - invalidate everything, always
> >>
> >> Given that, I'd rather have a slow guest. Also, it very much looks
> >> like no existing SW does this, so I cannot say I care much.
> >
> > OK, get it.
> 
> Actually, there could be a way to make this a bit faster. Once we have
> cleaned+invalidated the memslot, we could unmap it, speeding up the
> following cache invalidations (nothing will be mapped).
> 
> Could you please share your test case?

Yeah, here is my test method:
*Make sure your arm64 server supports gic-v2.
git clone https://github.com/unikraft/unikraft  #unikraft is a unikernel
cd unikraft
vim plat/kvm/arm/entry.S
before jumping to clean_and_invalidate_dcache_range set x0 as base address and x1 as the memory size.
For the qemu/virt, rom address is 0~128M, normal memory starts 1G. like:
...
/*
         * set x0 to the location stores dtb as the base address of the
         * memory range to be cache maintained
         */
        mov x0, 0
        mov x1, 0x08000000
        bl clean_and_invalidate_dcache_range
...
Build unikraft using "make", before build, using "make menuconfig" to choose the armv8 as architecture and kvm as platform.
Run it using qemu:
qemu-system-aarch64 \
        -machine virt,gic-version=2,accel=kvm \
        -m 1024 \
         -display none  \
        -nographic -nodefaults \
        -serial stdio -kernel build/unikraft_kvm-arm64.dbg \
        -cpu host -smp 1

Also I inject debug info into qemu to measure the time consumed by "ioctl(cpu->kvm_fd, type, arg)" in "kvm_vcpu_ioctl". Like:
//accel/kvm/kvm-all.c
int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
{
...
	gettimeofday(&tv1,NULL);
 	ret = ioctl(cpu->kvm_fd, type, arg);
	gettimeofday(&tv2,NULL);
	us = tv2.tv_usec - tv1.tv_usec;
	sec = tv2.tv_sec - tv1.tv_sec;
	if (sec > 0 || us > 50000) {
        	    printf("++++++ kvm_vcpu_ioctl, time is %ds, %dus ++++\n", count, sec, us);
	  }
.,..
}
You can have a try.

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
