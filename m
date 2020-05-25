Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4407C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 14:18:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71728208B8
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 14:18:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="ugytelhM";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="ugytelhM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71728208B8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A43024B223;
	Mon, 25 May 2020 10:18:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LE1wfsm9lgGy; Mon, 25 May 2020 10:18:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B89B4B22B;
	Mon, 25 May 2020 10:18:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 124234B223
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 10:18:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZhkoOHftDUsx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 10:18:34 -0400 (EDT)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130080.outbound.protection.outlook.com [40.107.13.80])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51BDD4B18E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 10:18:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKFrZC72eywz4TTbhJBvYjqDboasfI7bZV0zw7jB36I=;
 b=ugytelhML+1rx3YqkJNov4fiHAl/f2vi6B50n8zs7VbKj/yxR94o2C3UWGBGo6N6QIrCBbbr0+dg1pvCbHgHO62zzpVDCI4R1bn82/CBv/SFgIyDMboELPGMjJYiuNeSefqdRXjdmKegMGp7Xj/EXHsKy0U2mO/2AzPdvV+3jl0=
Received: from MR2P264CA0111.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::27)
 by AM0PR08MB3026.eurprd08.prod.outlook.com (2603:10a6:208:65::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 14:18:31 +0000
Received: from VE1EUR03FT014.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:33:cafe::bb) by MR2P264CA0111.outlook.office365.com
 (2603:10a6:500:33::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend
 Transport; Mon, 25 May 2020 14:18:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT014.mail.protection.outlook.com (10.152.19.38) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 14:18:29 +0000
Received: ("Tessian outbound d078647f4174:v57");
 Mon, 25 May 2020 14:18:28 +0000
X-CR-MTA-TID: 64aa7808
Received: from e96576a1cfc4.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 79FB7BE8-3268-49FF-BC3C-A6FE0D420115.1; 
 Mon, 25 May 2020 14:18:23 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id e96576a1cfc4.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 25 May 2020 14:18:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beko6XrsU5s8eeO+AaLwFcOjFtxNZ0QteRfwUPqrw8Z1+Z9WA4vZeEV00ZgTEpXEXohQAxwcX+8CVp84BbZ/ZLi+x7BveIMsdPAiNzpyx7EbDmfJfRQjFo8VaB4p6xuS4GDUCyfdMqRyLNxQnaA96k6XFyy5FA57q1o/KZtZPoFN/r5M780+A2yHpn1JQHdoYw8zKxaq56WpkDBtZLGH3+n7eilusVwKr5hiaxbfy9hyUHH8dSKbtKwkxiTk3YYml0hlUthvEELbLbNubwJyH9Qza5mjK5AlV1lB9QqZmIEg6RTeaXI0uvioElcFHbv08IEgbDNmUv3c3PqmprUXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKFrZC72eywz4TTbhJBvYjqDboasfI7bZV0zw7jB36I=;
 b=G9erLdzc6HUbmKuAbPbvYZZAf/Al2ugV+dkCdvHlHtqIUaJNY5dL4qVQLDO6zS9GPnC1ebFjkPDl1CyBrSOqI1PsqX7pqr1EpOkHP6gbu9pbdXAo4zjbK+cMWBkecMbGKfnPVNdH+G2hYCZYbt880VfOD2aMxXBAIVLWMGf6oVmbLFravzDIYTD6EvG56AMmpcMyslI1sAG3ZLiXs6I4iwPAmTh/Q/iB4vt4B5mIqyCAt1wNN4vAICm112HDH7t1thnft0lWJBWi5kQLdAwR0drDIzXzhN3AbFI+zrEGeF3ZMJFQ5skb9qHF2Jo+j9iRiWpZxevd9GzBSaUzKEgHhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKFrZC72eywz4TTbhJBvYjqDboasfI7bZV0zw7jB36I=;
 b=ugytelhML+1rx3YqkJNov4fiHAl/f2vi6B50n8zs7VbKj/yxR94o2C3UWGBGo6N6QIrCBbbr0+dg1pvCbHgHO62zzpVDCI4R1bn82/CBv/SFgIyDMboELPGMjJYiuNeSefqdRXjdmKegMGp7Xj/EXHsKy0U2mO/2AzPdvV+3jl0=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2569.eurprd08.prod.outlook.com (2603:10a6:3:e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Mon, 25 May
 2020 14:18:19 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 14:18:19 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>, Richard Cochran <richardcochran@gmail.com>
Subject: RE: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Thread-Topic: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Thread-Index: AQHWMBRtHtaBVLC+ukSXkuIjkrpVgai2gQEAgAIJaQCAAEKwQA==
Date: Mon, 25 May 2020 14:18:18 +0000
Message-ID: <HE1PR0802MB2555E64BD5C076E5AF08E644F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-11-jianyong.wu@arm.com>
 <20200524021106.GC335@localhost>
 <306951e4945b9e486dc98818ba24466d@kernel.org>
In-Reply-To: <306951e4945b9e486dc98818ba24466d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: f812874b-8ee4-45b7-9487-bdd76b3898df.1
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 13601f0e-71cc-4aa2-4c80-08d800b67f57
x-ms-traffictypediagnostic: HE1PR0802MB2569:|AM0PR08MB3026:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB30264AC2AFEA9279FF744BA5F4B30@AM0PR08MB3026.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:3968;OLM:3968;
x-forefront-prvs: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: y7yiNx0fKY+qCRVM7wagG0wDb1dCvT7uPv0IOzFV61P58sZAArp9gjpANHIBWgp4gQQOx/cMRF7LZFgpjIZ7E3BYymdzb88n2sa9aAjA/UnQ82STV2iqHBIQMwo15Uh25LslBYTlk+YGtbRTTWYP514KNJcX1FrXHOIxKuNhVZ7nK+JjRsCOtPWujupS4jY3Dpuek5XJdQFKCONW8VoEUxCqIJxqfjsWFgqvyWwZAxbdQB6L9LZ7LAlIlPzKc/Dt7Iu7/2wrvvD34z7SDVhjQjbwc9RwmbL/J+hueg6lP9CvdUXY3DfcoDk66drwBBWqk+2KNJCWZ8gIei20bDKs8A==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(26005)(86362001)(2906002)(66556008)(64756008)(76116006)(66476007)(53546011)(7416002)(66446008)(33656002)(4326008)(7696005)(6506007)(66946007)(8676002)(186003)(55016002)(52536014)(110136005)(54906003)(478600001)(71200400001)(9686003)(316002)(8936002)(5660300002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: 7Tq+8iOuK3bfeL++D4bln3s+Jwwaklp0U6jb7E19HoGkQ+fJlXWmHsCrM31cPPY48z1Y4IrRKImrb/RIN+pzOwnZD8tmFJM+Lf44h3Ju0q/80gb+t4Arz0isACUYvk7GCAmvzpHzmH0OaX6V7+rTFQMZwB5GU/NT/MDBnd28j/aHHqrlwCUXk1AACgMvkZR0ZaPkam3hMhiHDG+0govyIYXfEw/bnYxluW66px3Zf5nMWR0rQXKseSCRvVOehb82WKSKlA9FgmNCtTOj1b0LFZRhF459TPoz0vU7NTK+6l8kEz7Q8dPz30EMiRToQiHTALKelZsZPQy6OKWnkOB4PUVSCXxQgVmlte7bnllrxXtrHWkQChW1gfJE6/iczFPkbs4uK5xMcUM+H+vlhXn3jnt9PFlNim0iC2XgTi5zEEywLfKKLBVjrkg1SNbin/bTWYGxpOzSZ5KrMyRQgfglWReJj6SbGFuuGCOu/7sdcLU=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2569
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT014.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(46966005)(86362001)(82310400002)(81166007)(356005)(82740400003)(47076004)(5660300002)(478600001)(33656002)(52536014)(70206006)(70586007)(110136005)(2906002)(26005)(336012)(316002)(36906005)(9686003)(55016002)(53546011)(6506007)(54906003)(4326008)(186003)(7696005)(8936002)(8676002);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: cf8685cc-81c1-4ff3-3952-08d800b6793b
X-Forefront-PRVS: 0414DF926F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qlJ66zNb/WYe1XBftj2toEl4CC3aFITb8kH6ANhdbWzL3AviHVvaS1mVQXIHsSh1XEPy0JcCqB1G0F7ElVZUZ1xkyRl/g214eHBJtkgpHDendZxnFqmVAuG/5TCWaeZHmb8SKQbN/FBRMKTKcgxLaH0dxK9Q2lwq720ONa9URHvV5iN/6dOKpmNEfuKOxu3FH5gf8uHW1hJP5wM27TD7uDFCu1dzSyeBgnF0uPrHmOpG3hdliS3ZBo/pasbAB9Lg7/peh8K+S2z9OGoCW+o/o0zXDjimWaag+Q0QHDhDxFbF4TEAzLzntQ0/UG5p1KMGTCs0N5DETVoOkYj4tXmclpTzwDhQDpCPGbQMNk9R75M0tK28ZjG91eJSJN7GnS0PBH0zF9wcR0v6ohFBDipv0Q==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 14:18:29.2321 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13601f0e-71cc-4aa2-4c80-08d800b67f57
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3026
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

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Monday, May 25, 2020 5:17 PM
> To: Richard Cochran <richardcochran@gmail.com>; Jianyong Wu
> <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> Mark Rutland <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user
> choose which counter to return
> 
> On 2020-05-24 03:11, Richard Cochran wrote:
> > On Fri, May 22, 2020 at 04:37:23PM +0800, Jianyong Wu wrote:
> >> In general, vm inside will use virtual counter compered with host use
> >> phyical counter. But in some special scenarios, like nested
> >> virtualization, phyical counter maybe used by vm. A interface added
> >> in ptp_kvm driver to offer a mechanism to let user choose which
> >> counter should be return from host.
> >
> > Sounds like you have two time sources, one for normal guest, and one
> > for nested.  Why not simply offer the correct one to user space
> > automatically?  If that cannot be done, then just offer two PHC
> > devices with descriptive names.
> 
> There is no such thing as a distinction between nested or non-nested.
> Both counters are available to the guest at all times, and said guest can
> choose whichever it wants to use. So the hypervisor (KVM) has to support
> both counters as a reference.
> 
It's great that we can decide which counter to return in guest kernel. So we can abandon these code, including patch 9/11 and 10/11, that expose the interface to userspace to do the decision.

> For a Linux guest, we always know which reference we're using (the virtual
> counter). So it is pointless to expose the choice to userspace at all.
> 
So, we should throw these code of deciding counter type in linux driver away and just keep the hypercall service of providing both virtual counter and physical counter in linux to server non-linux guest.
Am I right?

> >
> >> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> >> index fef72f29f3c8..8b0a7b328bcd 100644
> >> --- a/drivers/ptp/ptp_chardev.c
> >> +++ b/drivers/ptp/ptp_chardev.c
> >> @@ -123,6 +123,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned
> >> int cmd, unsigned long arg)
> >>  	struct timespec64 ts;
> >>  	int enable, err = 0;
> >>
> >> +#ifdef CONFIG_ARM64
> >> +	static long flag;
> >
> > static?  This is not going to fly.
> >
> >> +		 * In most cases, we just need virtual counter from host and
> >> +		 * there is limited scenario using this to get physical counter
> >> +		 * in guest.
> >> +		 * Be careful to use this as there is no way to set it back
> >> +		 * unless you reinstall the module.
> >
> > How on earth is the user supposed to know this?
> >
> > From your description, this "flag" really should be a module
> > parameter.
> 
> Not even that. If anything, the driver can obtain full knowledge of which
> counter is in use without any help. And the hard truth is that it is
> *always* the virtual counter as far as Linux is concerned.

Good!

Thanks
Jianyong 
 
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
