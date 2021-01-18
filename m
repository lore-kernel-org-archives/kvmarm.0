Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED11C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:04:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2DB322B4E
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:04:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2DB322B4E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33CAD4B29C;
	Mon, 18 Jan 2021 08:04:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X7taH5QYKr+q; Mon, 18 Jan 2021 08:04:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01F774B2A4;
	Mon, 18 Jan 2021 08:04:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2794B29C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:04:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JcooXYz-IQ4r for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 08:04:13 -0500 (EST)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05hn2225.outbound.protection.outlook.com [52.100.20.225])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2BF14B0B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:04:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ativNa9Gt5NkzzVRdKNxxokSruuQCC/CycARCpBk8QU=;
 b=k6k7B+H2nYR3pmXoLtLa0DYkqF6jJxkn8nY3P4ELpnkujJ/i3lW4Yu0BKsO1och+KzFUTlFgrb5K008z0+7IlajGkLug9Bt8x2zPNr5lt73vNrPF7os9LCt+sle3EOE2joX4hm1pZdEx+laP+K076x/Dwxtz1Z7FVqAStOnmKS4=
Received: from AM5PR0202CA0010.eurprd02.prod.outlook.com
 (2603:10a6:203:69::20) by VE1PR08MB5024.eurprd08.prod.outlook.com
 (2603:10a6:803:106::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 13:04:09 +0000
Received: from AM5EUR03FT029.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:69:cafe::9e) by AM5PR0202CA0010.outlook.office365.com
 (2603:10a6:203:69::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend
 Transport; Mon, 18 Jan 2021 13:04:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT029.mail.protection.outlook.com (10.152.16.150) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.12 via Frontend Transport; Mon, 18 Jan 2021 13:04:08 +0000
Received: ("Tessian outbound f362b81824dc:v71");
 Mon, 18 Jan 2021 13:04:08 +0000
X-CR-MTA-TID: 64aa7808
Received: from 6d996256b2e9.3
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 1236262B-FF7E-451B-A2DC-778E029545C5.1; 
 Mon, 18 Jan 2021 13:04:03 +0000
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 6d996256b2e9.3
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 18 Jan 2021 13:04:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6L1a5doo67fC/iltk4vdQncCnFXdcLjS6AQyIh7OGZH4fmgzTALdyXRTQSVYWbQR/0xX/NRoDKkG0mBDJe01gRXl5BMKMb1wa+yXRYK8FL+LzpRFFCMZZv3Wd1h1uf7tUqnc/urNe8uQ2G8H44rJjoGIR5d3OGyL2cyGzP+rAFcEh2vBU+Yil4OoB4HpbyzGThg9QIJX4p0TQRiFqD1/9GfepUf4WZoI6aesEZadPKScB+pAWZLZ3Cs2DaqEBIEjz1xk19T6/Wv8UFra+T3rTj+PX7424u7eL/2xxNW+wrOzdMNNvBlEoUN9NuJ8c78Nh6MuzZURCsPbzCHKy9YIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ativNa9Gt5NkzzVRdKNxxokSruuQCC/CycARCpBk8QU=;
 b=lNoPMPWihoovPZfRA8EJXfXMyME8CY3SMAlgpJfCpF9H5h7/U84Ycs92hWlhjcs4c96ktZNhKXkFxNLt9uM0Ph3DobFIM/+fpP8q2/O8aKs3jQ52xYRDoqkp48/8IqIdSuxvjXZCxEts2D4v3wz1pdWmfBuHGhO7IIyeWD31hfNhEyYaSlsYoaWWiBMEt+6rtVSACuKIVclsfuIRCUs0RpH0/+C23zjMjZDeH5JOvYAp9nf7bGTYExQ36fnlfBQySYEc3aqqi1uLHLnLojz+NhHYMlY0JFUa3xm6APrjm7n74GgZa+Hq+Q+M95fr/GSg3LVUwIcjkyOah7ny0YKODQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ativNa9Gt5NkzzVRdKNxxokSruuQCC/CycARCpBk8QU=;
 b=k6k7B+H2nYR3pmXoLtLa0DYkqF6jJxkn8nY3P4ELpnkujJ/i3lW4Yu0BKsO1och+KzFUTlFgrb5K008z0+7IlajGkLug9Bt8x2zPNr5lt73vNrPF7os9LCt+sle3EOE2joX4hm1pZdEx+laP+K076x/Dwxtz1Z7FVqAStOnmKS4=
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com (2603:10a6:802:a9::18)
 by VI1PR08MB5327.eurprd08.prod.outlook.com (2603:10a6:803:13b::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 13:04:01 +0000
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8]) by VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8%2]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 13:04:01 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Jianyong Wu <Jianyong.Wu@arm.com>, Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Topic: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Index: AQHW6yEqdqBYWsMmd0S229FS8rLcnqooiq0AgAFUzWCAA3ehMA==
Date: Mon, 18 Jan 2021 13:04:01 +0000
Message-ID: <VE1PR08MB47669476FED079360D67B5FEF4A40@VE1PR08MB4766.eurprd08.prod.outlook.com>
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
X-MS-Office365-Filtering-Correlation-Id: f26ed356-c9c3-49b8-0140-08d8bbb18b15
x-ms-traffictypediagnostic: VI1PR08MB5327:|VE1PR08MB5024:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB502454CA401475B71CC3D6A9F4A40@VE1PR08MB5024.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: xWB/v9JWnLrD4ICB4l4QkbVN8M9IWo6CBN9hkg+jcf4JwWhJ2x3KRXE2TyfeGuN32CkTll3t9j8wi4BHmkLvbeR4ZMTADDxGb29K1Y1K+aeNJaWMMRdSmf8FAqrlKCzo+NsEVV21ZMqnIKoSZZPL146wyW8NDn5PIi4arOZH9HdtnSQN4bDqT9EtIqgnI0rFOl8LDaq1mHtLkksikRaV4+/aPYhQ6bZJfydUel4WGq3TUEyK+0/DOxJc5n/Hy4wrf3SqGwWC2uZC3GM0OOE5LFA+14WGF20sSgkqB1z14BR+ceYPOeRQZhwQmnRyN1fgMMyqiZpUrfy6yJr3tEmTSZyABEOV+faLU3JvLJRk5xvqqh74w72/8BLyo4yXx49qN5MRYuuqFcyoAdjmMkrGSLKrQJheiJgAiIA8foki50FmWapysbkZxkDXhUjesjHXwSNRffca8gIFJrgevUNQNg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VE1PR08MB4766.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(2906002)(7696005)(8936002)(478600001)(316002)(966005)(110136005)(71200400001)(52536014)(186003)(5660300002)(66556008)(53546011)(6506007)(54906003)(66446008)(33656002)(76116006)(9686003)(66476007)(64756008)(55016002)(66946007)(8676002)(86362001)(26005)(4326008)(83380400001);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?g3LWSgTmwYq1eey3IJReHnwkLtQ38ckr0oCSZQA/z4X0qK9nChCIP79B6P29?=
 =?us-ascii?Q?KhMrCyrlDEdTGEFYmtIh/jRQjjmigpW+JTygnD0nElsueSAY5xHuMPnt98hI?=
 =?us-ascii?Q?DNsH6pnUADKGAillmDkOxtFNS8qLihyZZV69PX2BlQizGQUL0tbLBv9plOBy?=
 =?us-ascii?Q?LB4WkZWBBNUu2uK2sVPSIj5U20xcZl7EniV/M7Nx6M/amQfdFGZXqCkcWk1d?=
 =?us-ascii?Q?GNq4RbdOsaNJbSL9RfzCSgEvGVndRgvGTTD71xCYaIUZBlYA6Rd9YZ40yMJW?=
 =?us-ascii?Q?ghnNI1LZVXrgaX7phdXeJmJQf+23sg1YSxTXi2VdEH9i1U9vXnocMT0FZONx?=
 =?us-ascii?Q?4DNDAAZjXrKAVmwad0Zv/fw6/tXVVWLO122CTiIQqdKVLSSx7tvGn502aQMo?=
 =?us-ascii?Q?assSDbusjrSLbQkCrFfMT2bgLcWc5RdAep+zmQwyVUj0ShyDi75TE8NtNyC9?=
 =?us-ascii?Q?2uPYNc50ManelPS8+LyP3HSFYto9u4lsRRal0HH9u9Pfo51e4wPR0o7dfVvt?=
 =?us-ascii?Q?ZMdD4B2/HjxJJUUkWhQ18SQWMFg0CUznlQ7HSB5Kx4hY7aJSjngQsAcS1ZEs?=
 =?us-ascii?Q?6PteyToN9vurzxBypF4SUmv8rQ8hGymh8Gz1Hlwl9zWwitHivxtgeMdbHkbf?=
 =?us-ascii?Q?XY8qpijz3004QKfpvnkgcPPwmHlplLADWSd3Y72hQDlckE7ckMRyRIQw/Dp3?=
 =?us-ascii?Q?RONFNhDC/MMTmu5ecein7bvka8OQvXjdUhSsCyBAH2+ZOk0+GQisI7cReQp6?=
 =?us-ascii?Q?yetEcks+mtJevbcm59BmypXuTb3RYyvSiHhxOOuS8skUuhTV3Hh804dBK53R?=
 =?us-ascii?Q?hDqCdvfJ407CkFoOoca5EV59m8GBAib6eqpCcA/rdi0AqyfqgjOD6qA5BiGn?=
 =?us-ascii?Q?T5JHmK7Mo+VdJLGzvEdq7W2i4F6mdVwgYRXVcjvgAVaSMZaDHL9CoYADet0b?=
 =?us-ascii?Q?VvAaa6jgttnF0aVottapoOe54B3l0SAUXFrMWyfNu4U=3D?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5327
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT029.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 1948bc1a-02d0-4224-9371-08d8bbb186e4
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WTXdVEqElgtcjg+dSjew6f9tKYg1FqMoskaDwbWTQVgC0zwQD6L5QmHdCWlfH4ntRhP1b8wxPzRxQWZJ/Vvnn8APo57rbY2+ySI7fKMOjqUOlpDYNcYVZt9b8IqDash46J9ezmuHcdtGHWuVtEvCwyS4vi5yL+pzl/4IjTnGLX+bUpkf3gBvTGJmHxQKptzsQOLuWTxmf7R6puTH4IbABhaOBv0rFxBRzAwQyKwpHE6kpAzOwZoIdYIdGqCuNgMyG+fYN7uOG0Xn+Z5CNsbF4FdYYJ/FwsE5OZb8lbtCoeuJFuM6EGpknKvAaO0teAgTHndJwOwkvHhKjXoPvZwzcMNx3kvjHBjAldmIivMAnTDLrTC5Qlu3rwP/PgEkkUw7zFoNR0T7tVA/b678UP18K4VQEtqpB2kKPUiaoIQYkeiAsZrnBKrMf27B+p35e1dEl+VgaHstBmJaujovzBDowyxg8z2uWwtgAaszmfAqI3d2NSr/oTQ0Fp3qsQhWpeead3evXeFca9FZuNG8fspv89whpmc0PtOJPs4J9Jlb/jE=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(39850400004)(396003)(346002)(136003)(376002)(46966006)(356005)(47076005)(70586007)(83380400001)(52536014)(186003)(33656002)(8676002)(82740400003)(70206006)(26005)(8936002)(82310400003)(81166007)(34010700045)(2906002)(86362001)(7696005)(4326008)(966005)(107886003)(54906003)(316002)(478600001)(53546011)(9686003)(6506007)(55016002)(336012)(5660300002)(110136005);
 DIR:OUT; SFP:1501; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 13:04:08.9300 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f26ed356-c9c3-49b8-0140-08d8bbb18b15
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT029.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5024
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
