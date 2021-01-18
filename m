Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4339EC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:39:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E49D22252
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:39:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E49D22252
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 141734B134;
	Mon, 18 Jan 2021 08:39:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uGqrlJHPBoOa; Mon, 18 Jan 2021 08:38:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A20C4B26B;
	Mon, 18 Jan 2021 08:38:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAFF04B134
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:38:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pbkbps6Jr+ky for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 08:38:56 -0500 (EST)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05hn2245.outbound.protection.outlook.com [52.100.20.245])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9B7A4B0DA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:38:55 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVwSGZtEm5SIQPcRil3quPAq4UYPykxYxXynq66/VvQ=;
 b=G8oIzmr/cVLILr11OCICiWwDe6WEmCgPWw7UoLu+rZQr2VdibpGBPZMObHSm1bfLY/aMrnYOfkLMfI7ZxkUtsw9oE8DmvesakRaErqIY0xuJf/OJ4+WHHUpLmveqN8MJxjqD0LxZlL4C1RPQBXsP3nfHrx+BlciKrFx2YCtJUdI=
Received: from DB6PR0301CA0002.eurprd03.prod.outlook.com (2603:10a6:4:3e::12)
 by VI1PR0801MB1869.eurprd08.prod.outlook.com (2603:10a6:800:88::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 13:38:53 +0000
Received: from DB5EUR03FT062.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:3e:cafe::6e) by DB6PR0301CA0002.outlook.office365.com
 (2603:10a6:4:3e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend
 Transport; Mon, 18 Jan 2021 13:38:53 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 63.35.35.123) smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass
 (signature was verified) header.d=armh.onmicrosoft.com; lists.cs.columbia.edu; 
 dmarc=temperror action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT062.mail.protection.outlook.com (10.152.20.197) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.12 via Frontend Transport; Mon, 18 Jan 2021 13:38:52 +0000
Received: ("Tessian outbound f362b81824dc:v71");
 Mon, 18 Jan 2021 13:38:52 +0000
X-CR-MTA-TID: 64aa7808
Received: from 514ec1a946cf.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 38D752F5-8ECD-49DA-AD2D-B92CB94137FD.1; 
 Mon, 18 Jan 2021 13:38:47 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 514ec1a946cf.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 18 Jan 2021 13:38:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nL6z1rF7Zi+hNR+R6dUMnnmgTyjWjxE4wl+cCxUYHvX0uUMGx1H2mUxGduqpkpw7UEp1MdrT35K6lvnu7fpbNF27DodLtaHhLimoRRg6jsexoSmsOuJgyx3GRN1pqbYVcHU6t96FpCOTosUEE/cRTqLrFfqU1BPg4TcZeQoezKbFDoFFJWRHHWK9WH9jsrsPVxbQp4z3t395ZT9f4YS2wAWt+WpH1zJRvLJJN7oMBkLSLRCGyTNA5LUJrbPnqkjVZHTdHUBdnevUmYBHAM9VbIC+jySjWmCK8Bqr9+RigWL8YyqKAcwwbN30qpBJ2jLyF3TrQPVZXNfXs81XVwChWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVwSGZtEm5SIQPcRil3quPAq4UYPykxYxXynq66/VvQ=;
 b=HeKuyHEovw55V8tzTRSDF9xQM8u3YJ+n9Mpqd+nbpS9PC8eR5PeH7fiVJ710X7o0WWk3afbTRgxQmZjbKNpkH2r//IPBF/plqheo2XRB+kBcROUxCDOcNnOaMhvzgyVpf1Z37eeVoPFJnfgCO0BXHcBOMjBPMDsjYobFbLtav5C9MmFZ2rTvoLCGo6jkDdn7WfMNWN8ItNcReCC65bkOuBADmVNFkvNZPyGeLQs4z8Su9tRGXvptXRi4D+2hHJzGJ3MnugyMDrXChTt0N+i+iK8BaKXkzLnKcw2K4EHuNvsqZllYf8+rTyt8EvkOFNd67+RjL+8D6+pDTf/iQX5TaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVwSGZtEm5SIQPcRil3quPAq4UYPykxYxXynq66/VvQ=;
 b=G8oIzmr/cVLILr11OCICiWwDe6WEmCgPWw7UoLu+rZQr2VdibpGBPZMObHSm1bfLY/aMrnYOfkLMfI7ZxkUtsw9oE8DmvesakRaErqIY0xuJf/OJ4+WHHUpLmveqN8MJxjqD0LxZlL4C1RPQBXsP3nfHrx+BlciKrFx2YCtJUdI=
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com (2603:10a6:802:a9::18)
 by VI1PR0801MB1885.eurprd08.prod.outlook.com (2603:10a6:800:84::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 13:38:45 +0000
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8]) by VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8%2]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 13:38:45 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Topic: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Index: AQHW6yEqdqBYWsMmd0S229FS8rLcnqooiq0AgAFUzWCAA3ehMIAADZUAgAADSBA=
Date: Mon, 18 Jan 2021 13:38:44 +0000
Message-ID: <VE1PR08MB4766C8FE66A84082326A4090F4A40@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20210115093028.6504-1-jianyong.wu@arm.com>
 <6f5a2ce458e33f879635f45140293517@kernel.org>
 <VE1PR08MB47664805860F1156223A7615F4A60@VE1PR08MB4766.eurprd08.prod.outlook.com>
 <VE1PR08MB47669476FED079360D67B5FEF4A40@VE1PR08MB4766.eurprd08.prod.outlook.com>
 <31dd6e2f8b3980337c8093d2ab626636@kernel.org>
In-Reply-To: <31dd6e2f8b3980337c8093d2ab626636@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 64934BC0568419499F0191BA403E0EF7.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0e3b2db6-b625-4f2f-df05-08d8bbb6651d
x-ms-traffictypediagnostic: VI1PR0801MB1885:|VI1PR0801MB1869:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0801MB18699CFE39A6B09CB51394EDF4A40@VI1PR0801MB1869.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 9IHqosuXfs9O1Gg3VcHXJ2iMOEdSy+078PnWO63/7I1MJdEXMg10SjYmfqrCt0d4DIuRn4hhWJzloAP4i85aNGixu0hNgzQdzj1dOiAkEJAQkw0Kof9mr1JbvY4A5vszLtQWxidyQ8isEQTfFYzDciN0hHYG/2h9iPhwNzztXrguuimUE6/gyYCYFwCQUSM0R7r+jESRv0BxWfeMh+oyKoA6W8lnE4OenKxI//K+tHLg7d5Flc2b2Ok87M3oTrD2vgnf3HsMlUB1Zpc/Do2qpyGQm+HKNruXDeNXvVdxbRfs73Gi6XDnJDopkvNYKhi/G0PvvWjNr5yUkj2IlPEicePQdN32e9C2KmkV8PTmnZg4+fRutpH83Vwm8PAG7cNIoQ9fH5HUwoWyZ3PFR0AHtg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VE1PR08MB4766.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(376002)(396003)(39850400004)(346002)(366004)(136003)(55016002)(5660300002)(9686003)(52536014)(76116006)(66556008)(71200400001)(7696005)(478600001)(2906002)(26005)(86362001)(66476007)(66946007)(66446008)(8676002)(64756008)(53546011)(6506007)(8936002)(54906003)(6916009)(186003)(4326008)(33656002)(83380400001)(316002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gopDk/V+RLP3BCsIjIG4sNzDXez7QXaTr+ZMJJaj6Zu5LHgAtPJnBtcqhpds?=
 =?us-ascii?Q?4t+juSoLpG6pUguBWG6ywhtdbjEoPbKawtgGidi6vSlPjQ96rJ9kuh9fF3gX?=
 =?us-ascii?Q?3KCEZywXX/chxdmHu42OcIqS00lWLNhwI0OHz2Ko6d2XMOjQZqG3HWrj5BAx?=
 =?us-ascii?Q?TktPMdYSg6s6gxORduBa9fW7hp5gcxivt+bD/XlEDC1byDvPypw6KsofYwzN?=
 =?us-ascii?Q?A+GHrrBObqNFrKShwfENjmmW2excBnlbv5IAQVkNSTYL7g6hqdm1cW9XtIlS?=
 =?us-ascii?Q?HYRkCoYlUrXJ4sdMl5RCN4DAsJZq/7yssXL/NQONGOlJrEJmeZKPX4Mgw2WM?=
 =?us-ascii?Q?tUyIwDTgolOuo3Fqh60n2j6HwVYKcIjT5+Sbd6+/FykMO5wEQFiVo0a2E2dE?=
 =?us-ascii?Q?oxs88msz5aKNCzBAmxXilAJmobFr+cNW3Py8c6AyAgeoxFEmdRxlrJkBU5vO?=
 =?us-ascii?Q?wLs10SQ0zlUWoRYxgAG1p5z6u9mrOfGmHYGk/6yjLSoDpo+6ZwX0rFtA+wJG?=
 =?us-ascii?Q?rkiNAgehkLfsJuwXzO8q1qPK/96ekfyd7G15lv1rB5QnvYYGD1cf8mMqArue?=
 =?us-ascii?Q?782SHCABpremW2tf0ioS/sHXcv5s+risqNRKQx8UTs/b5cMITbcj6lHhUdIl?=
 =?us-ascii?Q?DTaYNWtbQIP4FvX7PmQAfz26sygnrY0Y/VNKHxkpzSei1RWYDX6ViyF6zyy3?=
 =?us-ascii?Q?Gs4BH10IEYcAFX6UVGZufwQyVq5Z1hQyOgWMbMeW4yOE72L7JvPXucJRAy20?=
 =?us-ascii?Q?gflnSHQZ4148Sh8okQPrPpl34MhMrFAKQwCACFTS/WWoxGjiq1j0BhnXcRT/?=
 =?us-ascii?Q?NtGDM9VArlqOaQLo+MKEZIoWacvM+d7yVy+0FM5qh4I+xrVqlnKUh552p8YA?=
 =?us-ascii?Q?+6n4JHeRy2vof65ckFBJ8dzDhIsp4yk3EQiZUFaps8a1UWaWFed8GkJECMA/?=
 =?us-ascii?Q?TI7n0ntyT+nbicCWqGtwfMyYPxOatTLuRTbWljNhMBg=3D?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1885
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT062.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: bfdbb74a-2944-4181-9381-08d8bbb66080
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ybnHVowOab4ztxpKWxxbYW5pjAxHN7oBUS5ILurpPiQhkI3NJCFM5cmLVmTNkhJJgy/8gRAhmdjFc1uty2S+B6hIYHGsLEbUvOLYsiD5+uLATLHCX6kPmv5ZlpINJOqF40urFu8ZwOL+iSo7ZbfSKPM2MmypRuDd8+cI6jyXg+cCsE53140TXzmOczmiB6IGQlSBRewTgCk/PROP2kDosmT2GaF+oYaG5xn0FeAxji8a14uS+lgFdGPxFi7JbwgY8GVFYRa1CqcilLgNibunw+kUQffXwZ9qWrCZV+/fxNt2+s9bF3UHk1zAI0iuQ0MQ1dCW80EdittqILLDGbWKpBeWJNbpC/UOwwn51QNIlULjgLTSWwWXSBaHFIpxsmyxuSz8HytbHcjmVCsd0qNGBSsAG+hZux//GDf/SFwV9xRMs/YLlXippHTH82H0FJ8XUGLS11W7HB/GjUsrnt7/g==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(5660300002)(52536014)(8676002)(107886003)(86362001)(9686003)(63350400001)(336012)(2906002)(8936002)(82310400003)(70206006)(81166007)(26005)(34010700045)(356005)(70586007)(4326008)(83380400001)(82740400003)(6862004)(53546011)(6506007)(54906003)(478600001)(55016002)(7696005)(63370400001)(186003)(316002)(47076005)(33656002);
 DIR:OUT; SFP:1501; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 13:38:52.7753 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3b2db6-b625-4f2f-df05-08d8bbb6651d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT062.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1869
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
> Sent: Monday, January 18, 2021 9:26 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: Justin He <Justin.He@arm.com>; nd <nd@arm.com>; will@kernel.org;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] arm64/kvm: correct the error report in
> kvm_handle_guest_abort
> 
> On 2021-01-18 13:04, Jianyong Wu wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: kvmarm-bounces@lists.cs.columbia.edu <kvmarm-
> >> bounces@lists.cs.columbia.edu> On Behalf Of Jianyong Wu
> >> Sent: Saturday, January 16, 2021 4:47 PM
> >> To: Marc Zyngier <maz@kernel.org>
> >> Cc: Justin He <Justin.He@arm.com>; nd <nd@arm.com>; will@kernel.org;
> >> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> >> Subject: RE: [PATCH] arm64/kvm: correct the error report in
> >> kvm_handle_guest_abort
> >>
> >> Hi Marc,
> >>
> >> > -----Original Message-----
> >> > From: Marc Zyngier <maz@kernel.org>
> >> > Sent: Friday, January 15, 2021 7:21 PM
> >> > To: Jianyong Wu <Jianyong.Wu@arm.com>
> >> > Cc: James Morse <James.Morse@arm.com>; will@kernel.org; Suzuki
> >> Poulose
> >> > <Suzuki.Poulose@arm.com>; linux-arm-kernel@lists.infradead.org;
> >> > kvmarm@lists.cs.columbia.edu; Steve Capper
> <Steve.Capper@arm.com>;
> >> > Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> >> > Subject: Re: [PATCH] arm64/kvm: correct the error report in
> >> > kvm_handle_guest_abort
> >> >
> >> > On 2021-01-15 09:30, Jianyong Wu wrote:
> >> > > Currently, error report when cache maintenance at read-only
> >> > > memory range, like rom, is not clear enough and even not correct.
> >> > > As the specific error is definitely known by kvm, it is obliged
> >> > > to give it out.
> >> > >
> >> > > Fox example, in a qemu/kvm VM, if the guest do dc at the pflash
> >> > > range from
> >> > > 0 to 128M, error is reported by kvm as "Data abort outside
> >> > > memslots with no valid syndrome info" which is not quite correct.
> >> > >
> >> > > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> >> > > ---
> >> > >  arch/arm64/kvm/mmu.c | 12 +++++++++---
> >> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> >> > >
> >> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c index
> >> > > 7d2257cc5438..de66b7e38a5b 100644
> >> > > --- a/arch/arm64/kvm/mmu.c
> >> > > +++ b/arch/arm64/kvm/mmu.c
> >> > > @@ -1022,9 +1022,15 @@ int kvm_handle_guest_abort(struct
> kvm_vcpu
> >> > > *vcpu)
> >> > >  		 * So let's assume that the guest is just being
> >> > >  		 * cautious, and skip the instruction.
> >> > >  		 */
> >> > > -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu))
> >> > {
> >> > > -			kvm_incr_pc(vcpu);
> >> > > -			ret = 1;
> >> > > +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> >> > > +			if (kvm_is_error_hva(hva)) {
> >> > > +				kvm_incr_pc(vcpu);
> >> > > +				ret = 1;
> >> > > +				goto out_unlock;
> >> > > +			}
> >> > > +
> >> > > +			kvm_err("Do cache maintenance in the read-
> only
> >> > memory range\n");
> >> >
> >> > We don't scream on the console for guests bugs.
> >> Ok
> >>
> >> >
> >> > > +			ret = -EFAULT;
> >> > >  			goto out_unlock;
> >> > >  		}
> >> >
> >> > And what is userspace going to do with that? To be honest, I'd
> >> > rather not report it in any case:
> >> >
> >> > - either it isn't mapped, and there is no cache to clean/invalidate
> >> > - or it is mapped read-only:
> >> >    - if it is a "DC IVAC", the guest should get the fault as per
> >> >      the ARM ARM. But I don't think we can identify the particular CMO
> >> >      at this stage, so actually performing an invalidation is the least
> >> >      bad thing to do.
> >> >
> >> > How about this (untested)?
> >
> > I have tested for this. It works that DC ops can pass on memory range
> > for rom. But there is performance issue. It takes too long a time that
> > do DC on rom range compared with on  normal memory range. Here is
> some
> > data:
> > Ops                  memory type                                size
> >                   time
> > dc civac         rom memory                                128M
> >        6700ms;
> > dc civac       writable normal memory             128M
> > 300ms;
> >
> > It's a single thread test and may be worse on multi thread. I'm not
> > sure we can bear it. WDYT?
> 
> The problem is that the guest is invalidating one cache-line at a time, but we
> invalidate 128M at a time in your example.
> 
> I would say that I really don't care how slow it is. We cannot know which
> address the guest is trying to invalidate (as your commit message shows,
> there is no syndrome information available).
> 
> So it seems our only choices are:
> - don't do any invalidation, which is likely to break the guest
> - invalidate everything, always
> 
> Given that, I'd rather have a slow guest. Also, it very much looks like no
> existing SW does this, so I cannot say I care much.

OK, get it.

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
