Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E736DC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 06:06:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78D21207D3
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 06:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="EwJRcVvV";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="EwJRcVvV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78D21207D3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E35CE4B1E9;
	Wed, 27 May 2020 02:06:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HrOqyKg77vGW; Wed, 27 May 2020 02:06:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66D3A4B1D2;
	Wed, 27 May 2020 02:06:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 500314B17B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 02:06:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FIdBuqIirt9z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 02:06:39 -0400 (EDT)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr140042.outbound.protection.outlook.com [40.107.14.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E7244B153
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 02:06:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcitqLKeTaQgdeG0IEuCYAeGnXtBgywoOrz1kMhW950=;
 b=EwJRcVvVS3tKApLg2FlOs9ALv0sEFvcTkDfstp4P3031lPPZ+JkGqRM581qc+vH8hTuNjwsToO2/QRzZFUD4egNJnz6k53d3ezdA9OZxBhSBLeZ8S8vp0pLbvlM38AhM7j7M3FroyvJ/XvRNrVZ9C9JUzqPjSQRgf5fQOhVEQ/I=
Received: from AM0PR02CA0090.eurprd02.prod.outlook.com (2603:10a6:208:154::31)
 by DBBPR08MB4742.eurprd08.prod.outlook.com (2603:10a6:10:f5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 06:06:35 +0000
Received: from AM5EUR03FT034.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:208:154:cafe::5a) by AM0PR02CA0090.outlook.office365.com
 (2603:10a6:208:154::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend
 Transport; Wed, 27 May 2020 06:06:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT034.mail.protection.outlook.com (10.152.16.81) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Wed, 27 May 2020 06:06:34 +0000
Received: ("Tessian outbound 444e8e881ac1:v57");
 Wed, 27 May 2020 06:06:34 +0000
X-CR-MTA-TID: 64aa7808
Received: from 6e6718970187.3
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 1B9FFBDF-13B9-4A9B-BE95-C9EAAE0D8488.1; 
 Wed, 27 May 2020 06:06:29 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 6e6718970187.3
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 27 May 2020 06:06:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABQUEIK+6Anp41B+oKHhj7R61LCwn0lMhQZta3/RG6jKR04HoPPfnKrp3Js3keWv8kUGCWMXX3e3xLGCzcuLhhVbH6SGNpMKpJ1MSER4PQTMA2nWN7ZOs6zvNSE+OxXL2DBT9GuF9lPv43ksSX01qw7ZBUp7PENHB9Sm9WXc5w+lYMi9MoGYi3l1Lpvwq142Qrftsu7xXldmRYp4K6W/Vl8JtDyiQju5ITByZG32xors9XckHYXF3onzwY6iIhRuySNJZf1CcmOpVqQD4RyHY9PLeLoafQNAlRoobkN4bNJZAx+GXEKbcnnD4scuxe0a68FAB2LvMaw9vpEp6VcyxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcitqLKeTaQgdeG0IEuCYAeGnXtBgywoOrz1kMhW950=;
 b=hug9CNotI8JLo/sFeE0wAQ4L/Ul43cmimP7KooS5EaIMlgcqlUkRELQ4kyXrSMJL67GJ8Q+aqRUcRw7jnfp1MlPiAKGLj77xZxlvdpfcw5SiweYybtAn6wTyEXrwYumDIkOC3QjrtMwFrlURxoYyx6jljeoAac/z4tetHwyEIxCtJsrPc3NGk6o9+T/9nMAXtTtfCnlyJP66SVHgfgYxuN8KS+GmGUdNGE8tw3p9nyKY4SkNxy2TAEdZB2V/XhsKjlXJmVPvF3/sYvG8h/vxziSHO51AEr0vKqtUvSRkAMS4o4vou+iCVspqfvYT1044xXf8BaOY46k1F62zoC5Pdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcitqLKeTaQgdeG0IEuCYAeGnXtBgywoOrz1kMhW950=;
 b=EwJRcVvVS3tKApLg2FlOs9ALv0sEFvcTkDfstp4P3031lPPZ+JkGqRM581qc+vH8hTuNjwsToO2/QRzZFUD4egNJnz6k53d3ezdA9OZxBhSBLeZ8S8vp0pLbvlM38AhM7j7M3FroyvJ/XvRNrVZ9C9JUzqPjSQRgf5fQOhVEQ/I=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2169.eurprd08.prod.outlook.com (2603:10a6:3:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 06:06:21 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 06:06:21 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Steven Price <Steven.Price@arm.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "maz@kernel.org" <maz@kernel.org>, "richardcochran@gmail.com"
 <richardcochran@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>,
 "will@kernel.org" <will@kernel.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>
Subject: RE: [RFC PATCH v12 07/11] psci: Add hypercall service for kvm ptp.
Thread-Topic: [RFC PATCH v12 07/11] psci: Add hypercall service for kvm ptp.
Thread-Index: AQHWMBRiyrp0i3ftg0yKp1NgeF42Dqi0J4kAgAPjibCAAi7vgIABMhxA
Date: Wed, 27 May 2020 06:06:21 +0000
Message-ID: <HE1PR0802MB255517F2326218D49FF790CAF4B10@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-8-jianyong.wu@arm.com>
 <87fce07b-d0f5-47b0-05ce-dd664ce53eec@arm.com>
 <HE1PR0802MB2555A66F063927D5B855E1C6F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <d7ec2534-95e4-ae79-fc53-4d48a4ea628c@arm.com>
In-Reply-To: <d7ec2534-95e4-ae79-fc53-4d48a4ea628c@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 2cd23df7-1eb3-47eb-90a7-a33cca88abba.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9561234e-7453-48bb-2d2b-08d802041c20
x-ms-traffictypediagnostic: HE1PR0802MB2169:|DBBPR08MB4742:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB47424FAF3F0D7A31D12FD783F4B10@DBBPR08MB4742.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: NiWyQG6u4RdcukCIkTeODIr7eFa02yz3yxzEZH4tsO1FJ9ZtN59o2kd2rB+4+hi6KKGT5rMIIoHoTjr2+DQhzCxENVmt281xd5wOrX7LOHGXzb6413wiipCxAP4Kb/PyCrl39AqK/AO7sILgfh5uVCw3VIX7msW2pylAOylAx8/fUnJMmpf6nrK0trV98dv12KlHxpwzMhlj+hJzfEV5wvNG9nU+5WPLy2nIBO2eBZYDGEz0iWMlY6yCva7spwVc+0tTerBvxh6XmiW+agGqk3Ki8g1Qe7E7KqhD7QubItKxUYP7mcAX7+0gqU3+EE9qGJf2nMJXZm9xqvHIPSiBNvXRsZJ+12CcE2NoqoWy4zIOLt+1kfyPg59XVVdkGzDe
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(55016002)(26005)(64756008)(9686003)(186003)(54906003)(8936002)(110136005)(71200400001)(2906002)(83380400001)(8676002)(33656002)(6636002)(86362001)(5660300002)(316002)(52536014)(66446008)(66476007)(66946007)(66556008)(7416002)(76116006)(53546011)(7696005)(4326008)(6506007)(478600001)(921003);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: SWm53WceJrknF8fwVi76VQyKxHBokldasWp0pXrDwFjv2ypS8hkoOPyysocEVIsbVqypsAJjAKDbhYQScuNNlmoWm8JRS8D6FtoHvJc4jNhRrf1Hcpl/+szctNlhCVyCM8w5/7yJktBUaqNwZK9no2VPkwaqPED7X9+h7DHw6YbtZ0EBKyzY66hoK3I/VKKs4yVTTbigdpHfi8PHPXq2Xol78YDphi4iGgupNg/gDNGjhg/wCA+cjJr8oOUK56ezNwbW+tZmU/pEHfCzP+9xz9pVRKI7rT9YY3oV8D+atqm0GYBJv4Gy6k0WOy3vVHYsrvJKGU9fS1SOiWabSatGXkDY9oAg9bS/I6YWL4R5Cip3Ocyil4ULOxKx1KH9lCOhjmm4K364QMU6i73EhUySyNIsFC6GLK5n4t/F5XgInZFMoJwhm37BFT5Bl004MYKvNbovB+SQhYjuoiAasA+Yz3F9tdLilIJevJtm6JxX1kA=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2169
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT034.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(46966005)(478600001)(70586007)(70206006)(8936002)(53546011)(82740400003)(47076004)(6506007)(5660300002)(86362001)(83380400001)(9686003)(186003)(2906002)(110136005)(36906005)(52536014)(356005)(8676002)(316002)(55016002)(26005)(33656002)(336012)(7696005)(82310400002)(4326008)(54906003)(6636002)(81166007)(921003);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5337b053-3830-4ee4-c445-08d802041426
X-Forefront-PRVS: 04163EF38A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mkgFBpfgbgdPPzR1ZTfYJO+oTBV+y6c3/Ya0ZxFKCk9Yu+g8SFCNxIPAq4Gud9/WNu1iPsqU95bLULx1MFcv9rWWNoeWAk+tyaOWDabnz0BQYUTMtVlZ6TBDYfkZILktWZzuvZoaCXKzx7Evbs114dK1QE+UQYvRMR81D9r8r6z7rpJ0tzy8vUCQTFZLqhDzHzpXCqWaFHzfXOrftoU2BBUmSrB5+2imNaMmgYNr3ALjaDH5II8hc9KgixmRETbuR/wMbkfj+UaRHV1giey/i/le1MPuezRk69sdRlgaQX7OkRM8N0nXGby1C3liwIgU7yK9hQEJYrNKTsL5HKzQ+6XznuIpMLoU8BDnhBamUmaiaPoVaX1MOKqXODQKNSQ/iiRIv7Py3qpsP1A4sqvZCnmjm1iuJeUcqk8JE0B41zc=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 06:06:34.7051 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9561234e-7453-48bb-2d2b-08d802041c20
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4742
Cc: Justin He <Justin.He@arm.com>, Wei Chen <Wei.Chen@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd <nd@arm.com>,
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

Hi Steven,

> -----Original Message-----
> From: Steven Price <steven.price@arm.com>
> Sent: Tuesday, May 26, 2020 7:02 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>; netdev@vger.kernel.org;
> yangbo.lu@nxp.com; john.stultz@linaro.org; tglx@linutronix.de;
> pbonzini@redhat.com; sean.j.christopherson@intel.com; maz@kernel.org;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v12 07/11] psci: Add hypercall service for kvm ptp.
> 
> On 25/05/2020 03:11, Jianyong Wu wrote:
> > Hi Steven,
> 
> Hi Jianyong,
> 
> [...]>>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> >>> index db6dce3d0e23..c964122f8dae 100644
> >>> --- a/virt/kvm/arm/hypercalls.c
> >>> +++ b/virt/kvm/arm/hypercalls.c
> >>> @@ -3,6 +3,7 @@
> >>>
> >>>    #include <linux/arm-smccc.h>
> >>>    #include <linux/kvm_host.h>
> >>> +#include <linux/clocksource_ids.h>
> >>>
> >>>    #include <asm/kvm_emulate.h>
> >>>
> >>> @@ -11,6 +12,10 @@
> >>>
> >>>    int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >>>    {
> >>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> >>> +	struct system_time_snapshot systime_snapshot;
> >>> +	u64 cycles;
> >>> +#endif
> >>>    	u32 func_id = smccc_get_function(vcpu);
> >>>    	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
> >>>    	u32 feature;
> >>> @@ -70,7 +75,49 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >>>    		break;
> >>>    	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >>>    		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> >>> +
> >>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> >>> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP); #endif
> >>>    		break;
> >>> +
> >>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> >>> +	/*
> >>> +	 * This serves virtual kvm_ptp.
> >>> +	 * Four values will be passed back.
> >>> +	 * reg0 stores high 32-bit host ktime;
> >>> +	 * reg1 stores low 32-bit host ktime;
> >>> +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
> >>> +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
> >>> +	 */
> >>> +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> >>> +		/*
> >>> +		 * system time and counter value must captured in the same
> >>> +		 * time to keep consistency and precision.
> >>> +		 */
> >>> +		ktime_get_snapshot(&systime_snapshot);
> >>> +		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
> >>> +			break;
> >>> +		val[0] = upper_32_bits(systime_snapshot.real);
> >>> +		val[1] = lower_32_bits(systime_snapshot.real);
> >>> +		/*
> >>> +		 * which of virtual counter or physical counter being
> >>> +		 * asked for is decided by the first argument.
> >>> +		 */
> >>> +		feature = smccc_get_arg1(vcpu);
> >>> +		switch (feature) {
> >>> +		case ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID:
> >>> +			cycles = systime_snapshot.cycles;
> >>> +			break;
> >>> +		default:
> >>
> >> There's something a bit odd here.
> >>
> >> ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID and
> >> ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID look like they
> should be
> >> names of separate (top-level) functions, but actually the _PHY_ one
> >> is a parameter for the first. If the intention is to have a parameter
> >> then it would be better to pick a better name for the _PHY_ define
> >> and not define it using ARM_SMCCC_CALL_VAL.
> >>
> > Yeah, _PHY_ is not the same meaning with _PTP_FUNC_ID,  so I think it
> should be a different name.
> > What about ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_COUNTER?
> 
> Personally I'd go with something much shorter, e.g.
> ARM_PTP_PHY_COUNTER.
> This is just an argument to an SMCCC call so there's no need for most of the
> prefix, indeed if (for whatever reason) there was a non-SMCCC mechanism
> added to do the same thing it would be reasonable to reuse the same values.
> 
Ok ,  this shorter name is better.

> >> Second the use of "default:" means that there's no possibility to
> >> later extend this interface for more clocks if needed in the future.
> >>
> > I think we can add more clocks by adding more cases, this "default" means
> we can use no first arg to determine the default clock.
> 
> The problem with the 'default' is it means it's not possible to probe whether
> the kernel supports any more clocks. If we used a different value (that the
> kernel doesn't support) then we end up in the default case and have no idea
> whether the clock value is the one we requested or not.
> 
Yeah,  it's more meaningful. Should return the exact value back to user.

> It's generally better when defining an ABI to explicitly return an error for
> unknown parameters, that way a future user of the ABI can discover
> whether the call did what was expected or not.
> 

ok. I will fix it.

> >> Alternatively you could indeed implement as two top-level functions
> >> and change this to a...
> >>
> >> 	switch (func_id)
> >>
> >> ... along with multiple case labels as the functions would obviously
> >> be mostly the same.
> >>
> >> Also a minor style issue - you might want to consider splitting this
> >> into it's own function.
> >>
> > I think "switch (feature)" maybe better as this _PHY_ is not like a function
> id. Just like:
> > "
> > case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> >                  feature = smccc_get_arg1(vcpu);
> >                  switch (feature) {
> >                  case ARM_SMCCC_ARCH_WORKAROUND_1:
> > ...
> > "
> 
> I'm happy either way - it's purely that the definition/naming of
> ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID made it look like that
> was the intention. My preference would be to stick with the 'feature'
> approach as above because there's no need to "use up" the top-level SMCCC
> calls (but equally there's a large space so we'd have to work very hard to run
> out... ;) )
>
We can change the name of "_PHY_COUNTER", but it will remain in the same level with "_FUNC_ID" as
It will still occupy a place reserved for VENDOR SMCCC call.
Just like ARM_SMCCC_ARCH_WORKAROUND_1,

#define ARM_SMCCC_ARCH_WORKAROUND_1                                     \
        ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                         \
                           ARM_SMCCC_SMC_32,                            \
                           0, 0x8000)

 It will be a ARCH SMCCC call id from the view of its definition.

> >> Finally I do think it would be useful to add some documentation of
> >> the new SMC calls. It would be easier to review the interface based
> >> on that documentation rather than trying to reverse-engineer the
> >> interface from the code.
> >>
> > Yeah, more doc needed here.
> 
> Thanks, I think it's a good idea to get the ABI nailed down before worrying
> too much about the code, and it's easier to discuss based on documentation
> rather than code.
>
Yeah, a document here is in favor of code review.
 
Thanks
Jianyong 

> Thanks,
> 
> Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
