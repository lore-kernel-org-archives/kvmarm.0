Return-Path: <SRS0=NSI2=GT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FBDC433E0
	for <kvmarm@archiver.kernel.org>; Sat, 16 Jan 2021 08:47:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E12523A5E
	for <kvmarm@archiver.kernel.org>; Sat, 16 Jan 2021 08:47:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E12523A5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33B1B4B0EE;
	Sat, 16 Jan 2021 03:47:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a2P4Lv+PIkeQ; Sat, 16 Jan 2021 03:47:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C56D14B0E9;
	Sat, 16 Jan 2021 03:47:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 502C44B0CF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Jan 2021 03:47:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J1CnOeSjJmCf for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Jan 2021 03:47:06 -0500 (EST)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01hn2242.outbound.protection.outlook.com [52.100.6.242])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05C4C4B0C9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Jan 2021 03:47:05 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhjLCxy3WrG927cFbeSQYJ+q5Jhwu+ZI0MOvKBJcth4=;
 b=uam+iG3Fn1Dcng8a3vggDUmtX7o9ryYFFiupQJXR31g3WBfoneFS+YOPw9c02tlUTsc/sfSNGfWZ5uYYnBB8xjmqgAfviKqUEmkfp5q5Bgy18gWt0Jfea2fBgPDQWFT9vX/yqezjUwzIpTD74mV5yF0SwlwTPbDuf6VJ98U1wag=
Received: from DB6PR1001CA0001.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:4:b7::11)
 by VI1PR0801MB1805.eurprd08.prod.outlook.com (2603:10a6:800:58::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Sat, 16 Jan
 2021 08:47:03 +0000
Received: from DB5EUR03FT018.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:b7:cafe::a5) by DB6PR1001CA0001.outlook.office365.com
 (2603:10a6:4:b7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend
 Transport; Sat, 16 Jan 2021 08:47:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT018.mail.protection.outlook.com (10.152.20.69) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.12 via Frontend Transport; Sat, 16 Jan 2021 08:47:03 +0000
Received: ("Tessian outbound 4d8113405d55:v71");
 Sat, 16 Jan 2021 08:47:03 +0000
X-CR-MTA-TID: 64aa7808
Received: from c2d9e528c86d.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 EBE346B2-D29D-4423-AC39-E87A23E4F4DF.1; 
 Sat, 16 Jan 2021 08:46:58 +0000
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c2d9e528c86d.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Sat, 16 Jan 2021 08:46:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTJt07e8Zi/WX0hkZWoaVrQE0oj65gBiqxkBz+zsTqQw6OrfpFcrZbe0J0f/cs9t46vPjig9axsrXCPS8IvLNWPP8F/OLefPzKUlxTZs2kUQJXNzeZF1WjIZdPiylm63AfjqUjQPgEmKoMLqm7Mp1pq7QUmyF+cIq22hSUglDhMptUzW1KVFWvlMP+qA3TzicbX7DOLSDu5OFxNCocx1UYYoy4Hb2/dCQqWxX+iPSxUx+Eal7X603kN3Jh8FJzszaGed6VUbMdsai/0EmUUtTAOWkALTzeZ14GbjbqRI52ZiObspTjXfJk2AIEeie/GUh7kSwuQgD1CyjyxSRhyElg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhjLCxy3WrG927cFbeSQYJ+q5Jhwu+ZI0MOvKBJcth4=;
 b=Bo9erhynbz9Vwa6YqsFg5wG6N5YnI3LOSEBKnMAs7B97gtWC18Qkf8GRMS4OHIC+xhtTPm0awUa5AiFWtrNAbFuJlxup7xifuIoK6s1lzenTvjTJ7N0sfacJiwJM1WtM28nDj7W1j9XqDUbwCg3w9yYSd5dNCSTSgDIIPvyCiTq2xqD66P4qOj4aXJesmZQRNpLDB0qz7eNgBuetNcRZ1f5AVxrLPU4j8Zs22cIa2SbotICFottBWeSFglvIYTAitSJJ//oMB/CZDk8d7FPX/o0PkNYhQ0oiATDVl9fdPFg3bBylBd/F85PWlw1XPepbNyNy7lUhnAk9L6RG/GF9bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhjLCxy3WrG927cFbeSQYJ+q5Jhwu+ZI0MOvKBJcth4=;
 b=uam+iG3Fn1Dcng8a3vggDUmtX7o9ryYFFiupQJXR31g3WBfoneFS+YOPw9c02tlUTsc/sfSNGfWZ5uYYnBB8xjmqgAfviKqUEmkfp5q5Bgy18gWt0Jfea2fBgPDQWFT9vX/yqezjUwzIpTD74mV5yF0SwlwTPbDuf6VJ98U1wag=
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com (2603:10a6:802:a9::18)
 by VI1PR08MB3054.eurprd08.prod.outlook.com (2603:10a6:803:4a::32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Sat, 16 Jan
 2021 08:46:56 +0000
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8]) by VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8%2]) with mapi id 15.20.3763.010; Sat, 16 Jan 2021
 08:46:56 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Topic: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Index: AQHW6yEqdqBYWsMmd0S229FS8rLcnqooiq0AgAFUzWA=
Date: Sat, 16 Jan 2021 08:46:56 +0000
Message-ID: <VE1PR08MB47664805860F1156223A7615F4A60@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20210115093028.6504-1-jianyong.wu@arm.com>
 <6f5a2ce458e33f879635f45140293517@kernel.org>
In-Reply-To: <6f5a2ce458e33f879635f45140293517@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 381A9C1D93271045BFFDD766BBCE87DB.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e395f965-cdc2-4815-5669-08d8b9fb4bc5
x-ms-traffictypediagnostic: VI1PR08MB3054:|VI1PR0801MB1805:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0801MB1805E8AFC1198B50A69F128FF4A60@VI1PR0801MB1805.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: YA2f+ES3+71tuihXS/uYI6/0NwkEgaSuYbA4BYJA2+2ZubN4gQ4o/g0el0I9vdHooHzFDK4ylqbOONHxbTQHV1doRu1PS9nxa4UaBDpTLT/zAHpWL9K4QjhSpAorGZF9AsJlKBDYhSfxMJ2p8vAQ+F1GY8//0OVM/GokPY9Qm5XNg2x4DsUfPVaEQEGE4GgTiuDWTfBSRguF4CS2Re6X8+oVmBq5GvY5cpwyEi1TAOWBUgwLB/bxH/Rt1P8AhlypjghUIYTIIZ3vtgxkE1Z/MejkoiC6eMp0zO2qiymnJWenw2TubmrYk1/HFIDqaXs602UTe4yGJW/F7X0R4COsDnvBCWv3/0G8uFyGYfmqhNe0dCYQ1bM/Pdle11foPROwfvezyMw5q1LwKzwfBb94YQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VE1PR08MB4766.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(186003)(76116006)(66476007)(478600001)(52536014)(26005)(8676002)(66946007)(66556008)(5660300002)(2906002)(64756008)(66446008)(33656002)(9686003)(86362001)(83380400001)(8936002)(54906003)(7696005)(55016002)(4326008)(53546011)(316002)(6506007)(71200400001)(6916009);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jqzuCUPA5frkFAloJAliTq+OutCU+hKExOEd9Ah2XlHRF9NXmtaZAXbXvDYp?=
 =?us-ascii?Q?tfzXT8jvOYuwcJ+l7kQRMZrh5md+QxJVlwRoS5zd6VBuQYg0OZ85L9y0ipWj?=
 =?us-ascii?Q?Po/fh8pS1mo0xW6Rqb4iRx0m2Xu8U2aiMigQUmL/mI/XAi7dv5Gx/Kfu/e3K?=
 =?us-ascii?Q?b6U9597WBZ8D99fNMt9nCI7Hhco9xEACBv+er//qz5Eqk/VRg3MSOl5PV/4v?=
 =?us-ascii?Q?S+LLdzkifQui6ymXmwNLM9Ltv1O8Gz7l28831l7qFNYGVwWsC4HFEYl3HCEy?=
 =?us-ascii?Q?r4FphxsR8kBmnVRv7/M40nhE9iVw3xp2845YRKiEZhlJCDrkVOtuvQNQ21/3?=
 =?us-ascii?Q?i9tKB6pfKxlmIzuuPv+bXiO7dBZOJyH99gjMjUk7gmLdU9cJKU0fh5/aBtA/?=
 =?us-ascii?Q?ZPuf3BX7gPoB/06jFBoQg1dOBUbV1ZKnq3RmKdigLLOLNkn0JQCQH3r5JrR0?=
 =?us-ascii?Q?KoVxp1QUfPp1nLNck0cFY5weYGHjLK01TF3nwx+ehzHeqfmz/Z3rsxRj+XT8?=
 =?us-ascii?Q?BFz/Su+wLB1fkNt8jCrs/BCa8M5Rf1sBNG+il2avvfQv5EvoeviLGDfR947t?=
 =?us-ascii?Q?msJbit7GIYpyKmYlHrNnfS2oDhl5yheZ/NU2p4nUsqMIHDIWSCK56Z0klYXr?=
 =?us-ascii?Q?4rT68GxLe3Y1+POBRyd6DBzwIoGejtiJRLTMe1x4WdEGmkJzW4nQnEQYH4oF?=
 =?us-ascii?Q?4kqxkkWuq5gkGNvd2OtjrAcLFcnPQER2w+uB6emdPJh+GxH8j35pwB//ulvs?=
 =?us-ascii?Q?YY/l9LaHi8R22TtkWBCPzc5TdmMb5nCHJUpIsGI/vCtIScT3HwCbMFhdfp3H?=
 =?us-ascii?Q?n6VKZj1YAxH1uPmLKs0Bv8b9JF54sjA35ItX+/Eu5HxSbkgzM67MNty1j/xK?=
 =?us-ascii?Q?6r4H4/NwYMfK7gdBMjuYxPsNSsR7ub809kQsvMR/+ZOwqlInSwrLRQFZEGPw?=
 =?us-ascii?Q?ERJtjsvP28CTm0ybQLG5Lk+Ozp5dKDLR23Ykda/01l4=3D?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3054
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT018.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 6d00cc5e-f85a-4a74-e123-08d8b9fb47a8
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bnaSbu9ZifbjZSZNp1MKaKs8QsJOi7IhMONQ61jQ5lXeLv34F9+a9Dn7sHOosb41WDLmnkRtAhLgbJ/TXhxa7vb/YauE0yXcaQARPDEQvIZ7Oin0dvJtFVdJJF9jfQWpBQ6Yytg1lrhYMmtScGzPfuMFJ1D3TKFGeB09xAAkb9aOwqfl/EjwWSmX/bihaJgzyES06hq9JAvCOWYxLG3x1hMWEGNs0YbqtZwR/42/GcFS4nOezTFrXiPzF+rruFxsnVcUZRlTQaY93Gjg4LmC3M4IgewO3ssHZG4njhjJCQsvjVHfWeXrmBhk+ObGOEiqqF+qMsUFTvYwai/y9W/Miknvyp488yil7TDiXkngNFoQRfgUwrCKOktwoSXGD4HZk7GJ9TAlaMZ4ScoiT64MsjWkxPk2LYjcFZ/6FPTdx1SancmPtEo9YWijFyPrzc8IJI7K/HRhzdGe0mlLE+g5yROFQg4IKmmrYIaT/p8xPnywM/BPkVQhGC5oKRFej/cNSddQxzuRZn1tiaCjN+fwDCRv93X1rLdJVb9qDUwJPoT5Xv2qWi2U5XmWWLktvPZGsbZUSEtpiKb6YFnuRiotTw==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966006)(4326008)(478600001)(6862004)(52536014)(70586007)(70206006)(2906002)(356005)(83380400001)(336012)(5660300002)(186003)(34010700045)(316002)(6506007)(53546011)(26005)(86362001)(54906003)(82740400003)(8676002)(33656002)(7696005)(47076005)(81166007)(82310400003)(55016002)(9686003)(8936002);
 DIR:OUT; SFP:1501; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2021 08:47:03.1969 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e395f965-cdc2-4815-5669-08d8b9fb4bc5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT018.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1805
Cc: Justin He <Justin.He@arm.com>, nd <nd@arm.com>,
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
> Sent: Friday, January 15, 2021 7:21 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: James Morse <James.Morse@arm.com>; will@kernel.org; Suzuki
> Poulose <Suzuki.Poulose@arm.com>; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; Steve Capper <Steve.Capper@arm.com>;
> Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH] arm64/kvm: correct the error report in
> kvm_handle_guest_abort
> 
> On 2021-01-15 09:30, Jianyong Wu wrote:
> > Currently, error report when cache maintenance at read-only memory
> > range, like rom, is not clear enough and even not correct. As the
> > specific error is definitely known by kvm, it is obliged to give it
> > out.
> >
> > Fox example, in a qemu/kvm VM, if the guest do dc at the pflash range
> > from
> > 0 to 128M, error is reported by kvm as "Data abort outside memslots
> > with no valid syndrome info" which is not quite correct.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c index
> > 7d2257cc5438..de66b7e38a5b 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1022,9 +1022,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu
> > *vcpu)
> >  		 * So let's assume that the guest is just being
> >  		 * cautious, and skip the instruction.
> >  		 */
> > -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu))
> {
> > -			kvm_incr_pc(vcpu);
> > -			ret = 1;
> > +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> > +			if (kvm_is_error_hva(hva)) {
> > +				kvm_incr_pc(vcpu);
> > +				ret = 1;
> > +				goto out_unlock;
> > +			}
> > +
> > +			kvm_err("Do cache maintenance in the read-only
> memory range\n");
> 
> We don't scream on the console for guests bugs.
Ok

> 
> > +			ret = -EFAULT;
> >  			goto out_unlock;
> >  		}
> 
> And what is userspace going to do with that? To be honest, I'd rather not
> report it in any case:
> 
> - either it isn't mapped, and there is no cache to clean/invalidate
> - or it is mapped read-only:
>    - if it is a "DC IVAC", the guest should get the fault as per
>      the ARM ARM. But I don't think we can identify the particular CMO
>      at this stage, so actually performing an invalidation is the least
>      bad thing to do.
> 
> How about this (untested)?
> 
>          M.
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c index
> 7d2257cc5438..0f497faad131 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1013,16 +1013,27 @@ int kvm_handle_guest_abort(struct kvm_vcpu
> *vcpu)
>   		}
> 
>   		/*
> -		 * Check for a cache maintenance operation. Since we
> -		 * ended-up here, we know it is outside of any memory
> -		 * slot. But we can't find out if that is for a device,
> -		 * or if the guest is just being stupid. The only thing
> -		 * we know for sure is that this range cannot be cached.
> +		 * Check for a cache maintenance operation. Two cases:
>   		 *
> -		 * So let's assume that the guest is just being
> -		 * cautious, and skip the instruction.
> +		 * - It is outside of any memory slot. But we can't
> +		 *   find out if that is for a device, or if the guest
> +		 *   is just being stupid. The only thing we know for
> +		 *   sure is that this range cannot be cached.  So
> +		 *   let's assume that the guest is just being
> +		 *   cautious, and skip the instruction.
> +		 *
> +		 * - Otherwise, clean/invalidate the whole memslot. We
> +		 *   should special-case DC IVAC and inject a
> +		 *   permission fault, but we can't really identify it
> +		 *   in this context.
>   		 */
> -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu))
> {
> +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> +			if (!kvm_is_error_hva(hva)) {
> +				spin_lock(&vcpu->kvm->mmu_lock);
> +				stage2_flush_memslot(vcpu->kvm,
> memslot);
> +				spin_unlock(&vcpu->kvm->mmu_lock);
> +			}
> +
>   			kvm_incr_pc(vcpu);
>   			ret = 1;
>   			goto out_unlock;
> 
Thanks Marc, it's OK for me and I will do the test for it.

Thanks
Jianyong

> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
