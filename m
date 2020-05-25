Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4070C433E2
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 06:29:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F8B4207FB
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 06:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="h24bf90/";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="h24bf90/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F8B4207FB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B95DB4B17A;
	Mon, 25 May 2020 02:29:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wapydgdHby4a; Mon, 25 May 2020 02:29:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A337D4B181;
	Mon, 25 May 2020 02:29:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A78E4B17A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 02:29:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TJWza67zbGgc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 02:29:51 -0400 (EDT)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130049.outbound.protection.outlook.com [40.107.13.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D38F4B178
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 02:29:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tv1jqUYENvo6g+B9+/K4FqJigiAnUJw8oDZVDnXfIwk=;
 b=h24bf90/6sweDGx8M8jhvP8vxxBZvxk9bDgShvzkhIG4wgrDmDeOx+1Ar2bqea/GZZ/wjV3Ui64mqv9rZ+PTWEx9T3wK1DSfpjfluBhe3QI0V075GxviMM9e5uvAZaJtusx7OyJ/tuLP3OrFdLbSv9fgXqZctjOsHiIX+ezAx8Y=
Received: from DB6PR0601CA0011.eurprd06.prod.outlook.com (2603:10a6:4:7b::21)
 by VI1PR08MB4462.eurprd08.prod.outlook.com (2603:10a6:803:f9::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Mon, 25 May
 2020 06:29:47 +0000
Received: from DB5EUR03FT017.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:7b:cafe::d) by DB6PR0601CA0011.outlook.office365.com
 (2603:10a6:4:7b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend
 Transport; Mon, 25 May 2020 06:29:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT017.mail.protection.outlook.com (10.152.20.114) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 06:29:46 +0000
Received: ("Tessian outbound 952576a3272a:v57");
 Mon, 25 May 2020 06:29:46 +0000
X-CR-MTA-TID: 64aa7808
Received: from 321a59c5948d.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 F730ED51-801B-4B63-9D6A-674A705BFED7.1; 
 Mon, 25 May 2020 06:29:41 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 321a59c5948d.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 25 May 2020 06:29:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSypO2YUKNPTsemCIcScehxAoTNKhWxDi6O4Pxlb5PaER+9G3EyPd7+M/459te6FoiGt0n4B3pQ8hCwKbzhUY0UjdPxmcBuyuC/gvqWKVXCs/okBZ8AWRwV+eU4o/6rMWDry2PCgh4G6QdiP0yGPMpQsp18h9LRpEJMK5wQvYMJ3z/whPy7S8OdgiXu6MDyg1Xc3stL2Sw2kWcvPTY2Kv5YOZGfYix8P7AwvrfgD9VpFTQgSk0/IXFGgHBDgBiC1zenzEylwsljE5TUwhXBAAnUw4hQV+SggM4UY7mogiYJdkzPBaqWTHBOQlfzpfiRMsPnbcUTHUW7vk4PlG/aQqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tv1jqUYENvo6g+B9+/K4FqJigiAnUJw8oDZVDnXfIwk=;
 b=gsofweYC2SQmt1RAJQE/4qFiZlNHWMnD4b/naj8mkhw779EkCVSkkJpjKRAiXjOiNp4/KHF587SftEnLpKs27ego+cNTHaEDq2MiYdnCT58e4j0qTHYUKbubfenWrrZnITMlRyakqsS7CZ3BdWNPZrNd9kRj8WiketJ6s6hjUM/C/AAIJ9U4gT/7cwoKib1tVXP0iln027QnlVyVOxhEgPobTVflIolJvShfR4qjrx3E5wWbaRmwmdAGjPM8SEFgb+uOX6rssv99qP0s2ZiLsSR1z24Ikjjn4FtNQrp0kp9zrchjRu7+dA5G+8L+BzqEYz6V/ORNJQvBmk/9TQ1PsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tv1jqUYENvo6g+B9+/K4FqJigiAnUJw8oDZVDnXfIwk=;
 b=h24bf90/6sweDGx8M8jhvP8vxxBZvxk9bDgShvzkhIG4wgrDmDeOx+1Ar2bqea/GZZ/wjV3Ui64mqv9rZ+PTWEx9T3wK1DSfpjfluBhe3QI0V075GxviMM9e5uvAZaJtusx7OyJ/tuLP3OrFdLbSv9fgXqZctjOsHiIX+ezAx8Y=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2441.eurprd08.prod.outlook.com (2603:10a6:3:de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Mon, 25 May
 2020 06:29:37 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 06:29:37 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Richard Cochran <richardcochran@gmail.com>, "maz@kernel.org"
 <maz@kernel.org>
Subject: RE: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Thread-Topic: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Thread-Index: AQHWMBRtHtaBVLC+ukSXkuIjkrpVgai2gQEAgAGkltCAADJFAIAAAXkA
Date: Mon, 25 May 2020 06:29:37 +0000
Message-ID: <HE1PR0802MB25551DE2A81168AEAF4E06C4F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-11-jianyong.wu@arm.com>
 <20200524021106.GC335@localhost>
 <HE1PR0802MB25552E7C792D3BB9CBE2D2C7F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <20200525061622.GA13679@localhost>
In-Reply-To: <20200525061622.GA13679@localhost>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: maz@kernel.org
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 7aca3425-c140-4ec0-a6d0-95fe58e99f46.0
x-checkrecipientchecked: true
Authentication-Results-Original: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed78d4c5-da25-42bc-efc2-08d8007504c8
x-ms-traffictypediagnostic: HE1PR0802MB2441:|VI1PR08MB4462:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB446228DF075B31D433531306F4B30@VI1PR08MB4462.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:6790;OLM:6790;
x-forefront-prvs: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: ZW6JlXmZhwemS2eMQPwVx7hxLr4GjHypV0+jWz9PVdVzEO+h1o/cOJbJmDq/e1wBQUH3dQ9c3n05Xcjr/u4L8yCEb442mOurjNvjqLB7DI/2a5vwS9RaXr8cM+fJIPrplRA5OZPRJugTkm8JE8a89w+i2ti+OpigdHR0qwJ9ENzT1d42tNEbv/CPkIGXXsMkUiQN4GIMp4WuqFzYLOrLSn3ydIoy00GOFYRey+TS4+tiananRecR2qbjPzDaiGGqdJsGuRB6ZZz2Aj0hEY3r+C79MNL7S3iYcc8w1yGjmYmxOdL4TIz3H4kH7f8EbFlK8qVBS1Wj1k1Uh+EuJhKJ8g==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(316002)(8936002)(6506007)(53546011)(186003)(7416002)(478600001)(7696005)(86362001)(2906002)(33656002)(4326008)(26005)(52536014)(76116006)(5660300002)(66946007)(66446008)(66556008)(71200400001)(66476007)(64756008)(54906003)(9686003)(55016002)(8676002)(110136005);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: 3pq7bl41IpQu3mwWMb39oU2EtGjqeWgcpZavkd2cDgxXESzMVfEnidOmlX+fZOYE97fAFoc0AQKl6A826g3fG8Escr5jJ9yImoxbq819Bkrs/EipvYqZ69LnrfF9Z6PJw3HCKqL1Sye+uQes4BOLIywlF2KSePAx6DuV5ZEh1S6IXeeDCsDrI88OX4Pu0u8E5pR5WHAPxcu3fl5AWjb1/AzxHt9C0CGNRGGCRB69OP210G6cVC8/yA4FjQhHaVRbaqeXuq7JbF6VEeehhShE6a+njFEC9q53qR2iVR6i0BONrJXv7C7/y/sMCU7U2brsTTR8l+evt9WxnrnqnjtGDDRwbNjl55H67zDpz7R+sbi4eG1HR8PsKI/JBIDrWTS4j5pNKfHgBydHiy5AsJuVkYCBa2DVkVhkRQeUROCKhGbBrvCF0TFOk2g6iMlAOX0INXvpdg7x0ETofsw3f/nGEWbemQqjKK+PRsQncqTGqFo=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2441
Original-Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT017.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(46966005)(8676002)(52536014)(33656002)(5660300002)(9686003)(110136005)(54906003)(8936002)(86362001)(55016002)(4326008)(26005)(356005)(336012)(82310400002)(7696005)(186003)(70206006)(70586007)(53546011)(47076004)(82740400003)(2906002)(81166007)(6506007)(478600001)(316002);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: c89ad0ca-5804-4989-8f3a-08d80074ffa9
X-Forefront-PRVS: 0414DF926F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ziDeTz0dja+Cww4aF8/PvR4YS9RZtLWqrFGQCGXIOvH9QzwxrJIhjggSUxi34z5WXT19LKT4dFoyHYgVeBn7+xBhGNUAQ3Q3QeOd1A7QXg3qgtV/SSXBsGuCtyIu1lXhyGcJ5VcPdXJqkIVTaTe/ajlSrCUInThGJCirNRcxU9P4dcs9/QyMe86vQSuVMYzH6og17cLJRvpgMOOitORwR2VmOlKNhO7Kz8Ot2FSLTGCfbELk6HKWI//IAIZMOYx8tChpukSk6e15MisSOFhWWLxhqaJB2Ra4l+UcVm58W5LKyw+vsSQnzAGT821yftTE2vF/aPzW3m9f3uQrON36ChIdlVRbuUJm9TwnPIVzAqm53MsTyjQzIGYVKnhDeWg7vqRl7RZGmd4/e+N1IJ5Vvw==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 06:29:46.4311 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed78d4c5-da25-42bc-efc2-08d8007504c8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4462
Cc: Justin He <Justin.He@arm.com>, Wei Chen <Wei.Chen@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Richard,

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Monday, May 25, 2020 2:16 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: maz@kernel.org; netdev@vger.kernel.org; yangbo.lu@nxp.com;
> john.stultz@linaro.org; tglx@linutronix.de; pbonzini@redhat.com;
> sean.j.christopherson@intel.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; Wei Chen
> <Wei.Chen@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
> which counter to return
> 
> On Mon, May 25, 2020 at 04:50:28AM +0000, Jianyong Wu wrote:
> > How about adding an extra argument in struct ptp_clock_info to serve as a
> flag, then we can control this flag using IOCTL to determine the counter type.
> 
> no, No, NO!
> 
Ok, 

> > > From your description, this "flag" really should be a module parameter.
> > Maybe use flag as a module parameter is a better way.
> 
> Yes.
> 
It's fine for me, if @maz@kernel.org is not against with it.
 
Thanks
Jianyong 

> Thanks,
> Richard
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
