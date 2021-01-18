Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FC0C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:02:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EB5322231F
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:02:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB5322231F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C7894B0B4;
	Mon, 18 Jan 2021 08:02:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ziJqqMETM1+Z; Mon, 18 Jan 2021 08:02:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8435E4B0BB;
	Mon, 18 Jan 2021 08:02:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BCDA4B0B1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:01:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uiM7DGz0-5PF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 08:01:55 -0500 (EST)
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02hn2212.outbound.protection.outlook.com [52.100.10.212])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94B774B276
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:01:55 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ativNa9Gt5NkzzVRdKNxxokSruuQCC/CycARCpBk8QU=;
 b=8Cj4zx91CLyKx2FpsK8msefEDQjGCOMpF2p/XVVbVZU7Hd55pDQ6kcum+/DlQx7mPPybrUsFX1KiXxNiJklb40hRq2Af45W8z3nFXHa46FPHr5ZKdHqcYXwvmq4HNAr4+xLMdjAlgx3d9ChZAdpWE2U+1V4g3LXd8n6OUKlLhf0=
Received: from DB6PR0301CA0100.eurprd03.prod.outlook.com (2603:10a6:6:30::47)
 by DBBPR08MB4396.eurprd08.prod.outlook.com (2603:10a6:10:ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 13:01:52 +0000
Received: from DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:30:cafe::1f) by DB6PR0301CA0100.outlook.office365.com
 (2603:10a6:6:30::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend
 Transport; Mon, 18 Jan 2021 13:01:52 +0000
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
 15.20.3763.12 via Frontend Transport; Mon, 18 Jan 2021 13:01:52 +0000
Received: ("Tessian outbound 4d8113405d55:v71");
 Mon, 18 Jan 2021 13:01:52 +0000
X-CR-MTA-TID: 64aa7808
Received: from 93327bfbc085.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 488E1ADF-59B5-4DB8-BC68-1EE2F176E7CE.1; 
 Mon, 18 Jan 2021 13:01:46 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 93327bfbc085.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 18 Jan 2021 13:01:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6yg83QtmoD+sO7Jl8nctC2SiTrqY6AFqd7Rdq6jYixuEZdaxo44Aw8T6E12blqy49g6CHsqncL+jP6C1sz5RCF/r/mjqe04VtR1I1hth/Yl9G8Gi/gQOhr0iad3sj5ULyHcsXjUlPiH5CPqkcljFYbIxDTzoN505yuh6+dzHn7jBMmS7Qc46TBqk5t7e3R4WwcsYvJdddtddZQwYUcaKFlmErHR9vTAyS5Nu/LgGerWgkT5DI3Oh+FFOlBJhUqvKiIf7SACra2zK9fkiiVTcToLrpUEjRhAcqNmOnNqFa5S0JWRhmw/TjChVzCI1fYJYty8vFxrV6BfbNkXjYZdtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ativNa9Gt5NkzzVRdKNxxokSruuQCC/CycARCpBk8QU=;
 b=lGasUSG4S036U2e9+fAi4yAwtcMtBApeg8yeGNGw62/7VQloiQroPdU/lUpNAm1LLGa4TlUqTx+33PviicerW10C81PvCGnwnLmF9F73pNsMKFLCpeVJzxh4TMdbz2YP7ESNdq8OB0X2egFw1f008aNoqRXE5YUvxeyn0IbibWrqKOR1FWoudTBILm4r4KY56q7cRK2qpZ3hv8B/U98lTdI85jvmDc0Z7nDixLdbRtfHO00EkRMJ5fzwB47HvD8fLa8jXjklVKesIZQfRIdjVeBntWiyE4GkGPtlfQp8NHmipgHyXpLr6eOLsoFFt+xDHvrfSbZyi+TqWMe9SSA0dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ativNa9Gt5NkzzVRdKNxxokSruuQCC/CycARCpBk8QU=;
 b=8Cj4zx91CLyKx2FpsK8msefEDQjGCOMpF2p/XVVbVZU7Hd55pDQ6kcum+/DlQx7mPPybrUsFX1KiXxNiJklb40hRq2Af45W8z3nFXHa46FPHr5ZKdHqcYXwvmq4HNAr4+xLMdjAlgx3d9ChZAdpWE2U+1V4g3LXd8n6OUKlLhf0=
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com (2603:10a6:802:a9::18)
 by VI1PR0801MB2126.eurprd08.prod.outlook.com (2603:10a6:800:51::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 13:01:44 +0000
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8]) by VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8%2]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 13:01:44 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Jianyong Wu <Jianyong.Wu@arm.com>, Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Topic: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Index: AQHW6yEqdqBYWsMmd0S229FS8rLcnqooiq0AgAFUzWCAA3ehMA==
Date: Mon, 18 Jan 2021 13:01:44 +0000
Message-ID: <VE1PR08MB47661301EAF47BE10BBD788CF4A40@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20210115093028.6504-1-jianyong.wu@arm.com>
 <6f5a2ce458e33f879635f45140293517@kernel.org>
 <VE1PR08MB47664805860F1156223A7615F4A60@VE1PR08MB4766.eurprd08.prod.outlook.com>
In-Reply-To: <VE1PR08MB47664805860F1156223A7615F4A60@VE1PR08MB4766.eurprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: F435AF92602E2A40BEF3F8564FB4B811.0
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b79b15b-dd36-49ae-e868-08d8bbb13983
x-ms-traffictypediagnostic: VI1PR0801MB2126:|DBBPR08MB4396:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB4396422E5ED7792722D20112F4A40@DBBPR08MB4396.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: EqV/QbZVFZxsvJbaTLIyBMpih4eQlAemshw2D5hMIOewqHT+3gAcpd7Yy7qeL0mcKG1jadnbaV+um0y7GpOH876VqiLE8VE/seJBPkUx/aeBdYoBAA77KCRVcjvG4/SrzZR/HO4lQIR6bO1t3g+113nXbqb1G795HS9zIyf6DXXEQSwo2iKpkXCBaB4LmSQhsZV+F9PpuaFx9YTgA6y0BqNLN1TgsINOsuvUCvhxt2cu2gfk7knl5ptG7ynlMtvzQpljnYxfcQBjKQhHo4+StnzxgY4WO5WQ0o0sJQpR2AebG2PviDD/TUgX4k20ANMIZE9wcl10ronv2BYAqrRkK/9uHYlsWBvURowprPcB/ZR8DzSvAzko0iBXj3QVeYscWKoguWWKULhJlYp1NBzYXSrBMC9u3xlBEKG8NXUhlc8pwS67t0PreKa1xuvdq6PP7AOs3MPhN3oLTBHgN341+A==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VE1PR08MB4766.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(2906002)(66476007)(55016002)(8936002)(66556008)(66946007)(9686003)(64756008)(186003)(33656002)(478600001)(83380400001)(52536014)(8676002)(66446008)(26005)(7696005)(966005)(71200400001)(110136005)(54906003)(4326008)(86362001)(316002)(5660300002)(53546011)(6506007)(76116006);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?wE6ywyfboIYNPZFWlWbTv7eMu/AEr3kJfqHm0Q3RJf6x255yKMnUeeEPJpus?=
 =?us-ascii?Q?Dchutrw6jwk3nFQQPbYiUOLO/GH8zEaH68wGDu98pGtjPNZQRpx29Ffk/Lw0?=
 =?us-ascii?Q?Eufg1JUYZGXxVZcyreqZ0yjXf8GurqMGUCABIgcVaq9IP/x2F79hy57btvWH?=
 =?us-ascii?Q?b6qrxY+Vm8RXnvjcjTwM+70ylQAeHHF6ukvP9S/NJKxf9TvBTyNdX7MnhaLk?=
 =?us-ascii?Q?jLtyfG8mF+ucK8YfXF8zIbNBOc9loykiDuWrVToazMBzX6WfOu5Sdo3cKmqe?=
 =?us-ascii?Q?49zqUPluhb13WFQ1biuhrvSlk1x/0gdf20sz8lcHafBLpdw7oVOtetgOZQxF?=
 =?us-ascii?Q?Qoj7pGhs7OX9rxD5th0EoDEGxwZPnMQwAebVfz7bhxKmCtlUKDAQ5a81f2Xn?=
 =?us-ascii?Q?xeIThdwHsLOpw2gTtE2mo8a1G1WZx9lA2BFQouIk0GVuvrJ2D9f6ORF4caps?=
 =?us-ascii?Q?lbyVJcy9zYwUwLLEhQFNIYLJ67ay4LlRlSS77XbG07EErSKwSlNZOcrlDP/g?=
 =?us-ascii?Q?6PVniOwT2MGJDsP53YrTjOaqHZUv4R+85nKEU5elhT0rGYJ9R/IrlZaBHBp3?=
 =?us-ascii?Q?/LtBiEeCkRUNzaW6qZqnl0xtqBuDoswCejJQrD8k4to5oMngVVnYIqHveKym?=
 =?us-ascii?Q?CF21Zz2OwSxu5L5IHRWgCAM+Klr/VeegS6AxleYsxQlugyngUan8LWLH3OEz?=
 =?us-ascii?Q?7yKbu3ej84eA49SQ/je+FyhQ4QSB/ogbk43mgFrd4m57SqULju578NMpjvDU?=
 =?us-ascii?Q?TLvKrZuc/YpWTESiTAUrayS3Sj7/iroAPiKvRmuiN9SWdGcyMwBZMGTtjMuL?=
 =?us-ascii?Q?Wf1oNn0jSlgPVBD6/W7VEUWgblGqmD5p6fzJ7yCjTXnU/XOe0iLHXk3arBp/?=
 =?us-ascii?Q?OM6eW3+DmoKHbb18l/gtYyZqpCkWtuPnh+tI9hQyzMcSlDQbFz8rTS+5w5CE?=
 =?us-ascii?Q?7baw5iYn+A+qN84xDon404nXGOR5L4knYkhqh65j1gI=3D?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB2126
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: a4a58675-f1c1-4caf-b740-08d8bbb134fb
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kEqgCBZ1PPjH8gwuA/dE7aWt80zG4fTHP2S4avSrvCNFoXs5cDhv/dEgd9hvEsBmj7ps3Cc4fLozbG3q0sXbCrbW9coZjYQgZCvWA/ZNcuwHsLkuXc48N9EE6rrY7Oa8jo5cGf6BlWmHI/og1Y+BdKVM+yVUgsAn2ADfP9gasciIZanEnjvNO50US4sy+FElmR/URw8onb32/HXoAVePEcpfeOee3TscgliBWie2QxFYRU9HyH2/2XJndJi2LD1vAmSzM9u9ROmBVbsvuyORj160BZ2d12iO6RGgmjSJ7DSXhj/ZKzPLNkAR/5CPtn/GHy4UEG7XG/e6r0OpVbsihX8CkL/T04RUJBzoGhcTh3Hz/0V4SUV4GdaFWtVTuAxOZ+OKDET+Npp5qRCcb9xG5e+T1tcR+v3OyNZ0gXEo9avWxIEoarWifPH2h5ZL+lHKh1B3Ur7bmaYKW8dC5poqvjx9alOiJK6azoM9HQGE1HclRCqedbhmI3RuRbTLtxJ1sZ1hY6M5NQOPa1pHSKaLHH8PMOdWGerIskkAR1Anej4=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(46966006)(2906002)(7696005)(5660300002)(33656002)(9686003)(186003)(107886003)(47076005)(82310400003)(70206006)(83380400001)(6506007)(26005)(53546011)(54906003)(316002)(55016002)(8676002)(34010700045)(110136005)(52536014)(81166007)(70586007)(356005)(336012)(4326008)(8936002)(966005)(86362001)(82740400003)(478600001);
 DIR:OUT; SFP:1501; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 13:01:52.1406 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b79b15b-dd36-49ae-e868-08d8bbb13983
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4396
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

Hi Marc,

> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu <kvmarm-
> bounces@lists.cs.columbia.edu> On Behalf Of Jianyong Wu
> Sent: Saturday, January 16, 2021 4:47 PM
> To: Marc Zyngier <maz@kernel.org>
> Cc: Justin He <Justin.He@arm.com>; nd <nd@arm.com>; will@kernel.org;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Subject: RE: [PATCH] arm64/kvm: correct the error report in
> kvm_handle_guest_abort
> 
> Hi Marc,
> 
> > -----Original Message-----
> > From: Marc Zyngier <maz@kernel.org>
> > Sent: Friday, January 15, 2021 7:21 PM
> > To: Jianyong Wu <Jianyong.Wu@arm.com>
> > Cc: James Morse <James.Morse@arm.com>; will@kernel.org; Suzuki
> Poulose
> > <Suzuki.Poulose@arm.com>; linux-arm-kernel@lists.infradead.org;
> > kvmarm@lists.cs.columbia.edu; Steve Capper <Steve.Capper@arm.com>;
> > Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> > Subject: Re: [PATCH] arm64/kvm: correct the error report in
> > kvm_handle_guest_abort
> >
> > On 2021-01-15 09:30, Jianyong Wu wrote:
> > > Currently, error report when cache maintenance at read-only memory
> > > range, like rom, is not clear enough and even not correct. As the
> > > specific error is definitely known by kvm, it is obliged to give it
> > > out.
> > >
> > > Fox example, in a qemu/kvm VM, if the guest do dc at the pflash
> > > range from
> > > 0 to 128M, error is reported by kvm as "Data abort outside memslots
> > > with no valid syndrome info" which is not quite correct.
> > >
> > > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > > ---
> > >  arch/arm64/kvm/mmu.c | 12 +++++++++---
> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c index
> > > 7d2257cc5438..de66b7e38a5b 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -1022,9 +1022,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu
> > > *vcpu)
> > >  		 * So let's assume that the guest is just being
> > >  		 * cautious, and skip the instruction.
> > >  		 */
> > > -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu))
> > {
> > > -			kvm_incr_pc(vcpu);
> > > -			ret = 1;
> > > +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> > > +			if (kvm_is_error_hva(hva)) {
> > > +				kvm_incr_pc(vcpu);
> > > +				ret = 1;
> > > +				goto out_unlock;
> > > +			}
> > > +
> > > +			kvm_err("Do cache maintenance in the read-only
> > memory range\n");
> >
> > We don't scream on the console for guests bugs.
> Ok
> 
> >
> > > +			ret = -EFAULT;
> > >  			goto out_unlock;
> > >  		}
> >
> > And what is userspace going to do with that? To be honest, I'd rather
> > not report it in any case:
> >
> > - either it isn't mapped, and there is no cache to clean/invalidate
> > - or it is mapped read-only:
> >    - if it is a "DC IVAC", the guest should get the fault as per
> >      the ARM ARM. But I don't think we can identify the particular CMO
> >      at this stage, so actually performing an invalidation is the least
> >      bad thing to do.
> >
> > How about this (untested)?

I have tested for this. It works that DC ops can pass on memory range for rom. But there is performance issue. It takes too long a time that do DC on rom range compared with on  normal memory range. Here is some data:
Ops                  memory type                                size                     time
dc civac         rom memory                                128M               6700ms;
dc civac       writable normal memory             128M                300ms;

It's a single thread test and may be worse on multi thread. I'm not sure we can bear it. WDYT?

Thanks
Jianyong 

> >
> >          M.
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c index
> > 7d2257cc5438..0f497faad131 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1013,16 +1013,27 @@ int kvm_handle_guest_abort(struct kvm_vcpu
> > *vcpu)
> >   		}
> >
> >   		/*
> > -		 * Check for a cache maintenance operation. Since we
> > -		 * ended-up here, we know it is outside of any memory
> > -		 * slot. But we can't find out if that is for a device,
> > -		 * or if the guest is just being stupid. The only thing
> > -		 * we know for sure is that this range cannot be cached.
> > +		 * Check for a cache maintenance operation. Two cases:
> >   		 *
> > -		 * So let's assume that the guest is just being
> > -		 * cautious, and skip the instruction.
> > +		 * - It is outside of any memory slot. But we can't
> > +		 *   find out if that is for a device, or if the guest
> > +		 *   is just being stupid. The only thing we know for
> > +		 *   sure is that this range cannot be cached.  So
> > +		 *   let's assume that the guest is just being
> > +		 *   cautious, and skip the instruction.
> > +		 *
> > +		 * - Otherwise, clean/invalidate the whole memslot. We
> > +		 *   should special-case DC IVAC and inject a
> > +		 *   permission fault, but we can't really identify it
> > +		 *   in this context.
> >   		 */
> > -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu))
> > {
> > +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> > +			if (!kvm_is_error_hva(hva)) {
> > +				spin_lock(&vcpu->kvm->mmu_lock);
> > +				stage2_flush_memslot(vcpu->kvm,
> > memslot);
> > +				spin_unlock(&vcpu->kvm->mmu_lock);
> > +			}
> > +
> >   			kvm_incr_pc(vcpu);
> >   			ret = 1;
> >   			goto out_unlock;
> >
> Thanks Marc, it's OK for me and I will do the test for it.
> 
> Thanks
> Jianyong
> 
> > --
> > Jazz is not dead. It just smells funny...
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
