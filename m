Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8016C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 01:29:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 33E2625340
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 01:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="mkzOtE+C";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="mkzOtE+C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33E2625340
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EF8C4B162;
	Sun, 21 Jun 2020 21:29:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PHrq-eQVFhbk; Sun, 21 Jun 2020 21:29:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 620604B105;
	Sun, 21 Jun 2020 21:29:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79E3B4B0BC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Jun 2020 21:29:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dw50IUBk6QaE for <kvmarm@lists.cs.columbia.edu>;
 Sun, 21 Jun 2020 21:29:14 -0400 (EDT)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60071.outbound.protection.outlook.com [40.107.6.71])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0448B4A4A3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Jun 2020 21:29:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gakpibcmM1A6Z+y+LYAOXvkHa7C3zW96kd1mPW6FAk=;
 b=mkzOtE+CefvWgst6+zITplTyHL9vy60/vyh9i/bnuy8WTb1L24xZKkKkvXWwMs88TOlOVCQxV7FYEIVI+LPETwgznI6CBTl2FQ9DXBbSyw16XZ9mrhwGAOt/8t8xgQNES916zOqRv5TeSnV1WbSwX0mfO0wkCimxHf8UxlBdoXc=
Received: from DB6P18901CA0007.EURP189.PROD.OUTLOOK.COM (2603:10a6:4:16::17)
 by DB6PR0802MB2280.eurprd08.prod.outlook.com (2603:10a6:4:80::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Mon, 22 Jun
 2020 01:29:12 +0000
Received: from DB5EUR03FT047.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:16:cafe::9b) by DB6P18901CA0007.outlook.office365.com
 (2603:10a6:4:16::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend
 Transport; Mon, 22 Jun 2020 01:29:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT047.mail.protection.outlook.com (10.152.21.232) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 01:29:11 +0000
Received: ("Tessian outbound 022d32fb9a40:v59");
 Mon, 22 Jun 2020 01:29:11 +0000
X-CR-MTA-TID: 64aa7808
Received: from e0c85193323d.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 59CB9F53-E507-4DCF-B6E8-F3A93FE3B859.1; 
 Mon, 22 Jun 2020 01:29:06 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id e0c85193323d.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 22 Jun 2020 01:29:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MD8pEoe7PYsU6Uq7Z6dUSUToKc5dx3ZT5Xl9EOR6Y1j39z2nNgq3ghLc85beDXTLZgp7gIYEFkos+Ln54jxLDAK6A8vEMpBiU802iU4mh/YUw/GS8yRv4H2V8YQlxmRxXLanelzywf1dm6S5o49Jf0hyBBMW8qeHR97o71kVPJCl2jeeI+t5mg7FXXqinp0I6JNvWCt7u42T/H4ZtzyKrSxsdVtZAIH+RfM5Piagj6ipD8iNCMvboo6lYmdo32jJvuQsvXmuqVC+mSzjFbGPBPDsFvmh2Fl+ydOmpi6Hhf70KUiOWF6kr0Z9gfRITkju5s1fooqm9Qgk+UFPh3qodw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gakpibcmM1A6Z+y+LYAOXvkHa7C3zW96kd1mPW6FAk=;
 b=ZQ11lcEokei5wxzZPOyCD4QMI5ksgSGIabXadEamkzEminJakiRHlmez/SEXBvE88sbESaV0WQFaRHZMdf2/WUkUvV31/LxEslSsOtDmOFLpQiILB7KM7m27QlEIlfDKU88CH6bAiCaIZPjRaZY6RFcHB8hYE0mf3qQwFpUngt/ZZbVcXvoOfK7d8nJuMqhueuL98qxNG4WPS2zywRguQWsHeXUrktvNym0Vzmsjafu/jOrjG+fJlcsOb4AaEOIUNqgg9y0/yBTxsmAS+6zHHA8UVZ9fiaa3PtDZENBEjYOwxh4MFztRGwHxJbseHfdERkgF8pq3PY84VP7qMHXypw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gakpibcmM1A6Z+y+LYAOXvkHa7C3zW96kd1mPW6FAk=;
 b=mkzOtE+CefvWgst6+zITplTyHL9vy60/vyh9i/bnuy8WTb1L24xZKkKkvXWwMs88TOlOVCQxV7FYEIVI+LPETwgznI6CBTl2FQ9DXBbSyw16XZ9mrhwGAOt/8t8xgQNES916zOqRv5TeSnV1WbSwX0mfO0wkCimxHf8UxlBdoXc=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2441.eurprd08.prod.outlook.com (2603:10a6:3:de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 01:29:04 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a%6]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 01:29:04 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: RE: [PATCH v13 3/9] smccc: Export smccc conduit get helper.
Thread-Topic: [PATCH v13 3/9] smccc: Export smccc conduit get helper.
Thread-Index: AQHWRjnWZm9cCgyKw0Oi8fsDZXPjUajf9qAAgAPlsPA=
Date: Mon, 22 Jun 2020 01:29:04 +0000
Message-ID: <HE1PR0802MB25556C4CA5F4A49AED6795F4F4970@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200619130120.40556-1-jianyong.wu@arm.com>
 <20200619130120.40556-4-jianyong.wu@arm.com>
 <20200619135716.GA14308@infradead.org>
In-Reply-To: <20200619135716.GA14308@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 63f8f2c2-a11f-469a-9765-782abfe82fbc.1
x-checkrecipientchecked: true
Authentication-Results-Original: infradead.org; dkim=none (message not signed)
 header.d=none; infradead.org;
 dmarc=none action=none header.from=arm.com; 
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cace6f51-0d32-46cf-812c-08d8164baaf0
x-ms-traffictypediagnostic: HE1PR0802MB2441:|DB6PR0802MB2280:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB228065B18DB2FE67A46F4C30F4970@DB6PR0802MB2280.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1388;OLM:1388;
x-forefront-prvs: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: zoS5szs5n+3VpC5T2Xy1l7CzOCdMfWSqhwW4pkx0+yl3/CrkzTANj2YZgTz1RrgjiOVklckMPGtRtP1H1QbDpf9uZlDRIVw5Bn4h7vNd92nu3YUWUINWP5pDzLJuOLC7YCp2jWILy23TKsa77BzMLFtMgO/Z+MuxDVBWfCirmTW4CXMclgq+6HYebkl1cbnhoyBZI1sPyUQMIOO3zd+odjSO9ORO+JvJWj7hqixNcHYfEkPFi8Q2ZZgIsDA1PbbIyurSunDh5bsc3NCVEOAYdjMX0l6lGZd/YX8L6EP08gbxgCMBOO2hzFmwvSob5VrE+syITgSjER7C0xwUgEvx7w==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39850400004)(8936002)(64756008)(83380400001)(66556008)(66476007)(71200400001)(66446008)(55016002)(5660300002)(8676002)(7416002)(54906003)(7696005)(9686003)(76116006)(6506007)(6916009)(66946007)(53546011)(52536014)(86362001)(316002)(478600001)(2906002)(4326008)(186003)(26005)(33656002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: tdjvzkf1H1Bd/MhKMgfFnpkWZG+ruSgJx4e3JZEnI3mE5MQNXYD/FAnkHAFaH4U1lOL1wxuxlLye7as22DmhOh2Lya+S6GHtjjA0qbkTjewhZ6hwfcZUWgXOrd13Tu43iuRdXBxI+7eBKLB9HieUykzH0uURBW9OMN8zo2KyBmp6bLyfumi+VbpkZS4ouExqB7ics6/b8skfi7rz4pZZ3+BiVYfd9R99FVAKkvz2SNQyruGULVdWCP0FUXs4YnlVa9Bzh8x0g2iVZrFXd+Vdb1PtGdOoF4WsuIWOEdXfZ6rWr3k0ePxERVXPZ3zkg12spcZ2gPxv6qKGjmCs/YXx2cpT0ZcDqUA5rWZ0rRTOyU3D2KCvsg3Vt5oJqTils5ikZh8zh4BVBrckYLsJ8QAPGov1NNmvpkr0DKLxpXEoRULW42joGAJjkHSQP0bCOcacKvQXUATr+KjvNbHMxKOSdi/L9yrI3cYV3G/kY/BUE18=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2441
Original-Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none; infradead.org;
 dmarc=none action=none header.from=arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT047.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(396003)(39850400004)(346002)(136003)(376002)(46966005)(81166007)(47076004)(55016002)(54906003)(2906002)(52536014)(9686003)(107886003)(8936002)(83380400001)(186003)(26005)(82310400002)(6506007)(8676002)(53546011)(33656002)(356005)(478600001)(82740400003)(4326008)(336012)(70206006)(86362001)(7696005)(6862004)(70586007)(5660300002)(316002);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 41ca700a-8451-4c16-2c68-08d8164ba6a7
X-Forefront-PRVS: 0442E569BC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F+9VvPts0up7Bcv5NpLx5l6jMdxD6I7rXZLfSZLfCfGkwWv1dsA8NuX/i8vYGwae+7ePkecoZR/OELiqdvzgpitddOvZmoyLlNFRCDQoPIWgyrf33emBbv+BjwEUu1npsq/RlZgBK7Y+kRa5EoCIgW4IQ5ez95KPlpwAY11R4J2R3lC8uSRoyaHwRyhWR9zimYTcVifyRibtfUE+E0waQvxLFfla7CFIPHky73kVLitNjoORLIwkr/IAeTnoQYfAGv6GHG05Shw1wNi3F09pTZfSHFMj+rR8/yT1XZLgDRtUy/WTnUcW2Yu4PiqHfDJqxkeScoSSgFgdZ9B0bQzAx7UBVGuJbfW8c82MkhVz3l4i7GiVKyKgtn03pM+vKkP+jsw22pt27tq7804vgDzqXQ==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 01:29:11.9041 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cace6f51-0d32-46cf-812c-08d8164baaf0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2280
Cc: "maz@kernel.org" <maz@kernel.org>, Justin He <Justin.He@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Wei Chen <Wei.Chen@arm.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
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

Hi Christoph,

> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: Friday, June 19, 2020 9:57 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>; Justin
> He <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; linux-
> kernel@vger.kernel.org; Kaly Xin <Kaly.Xin@arm.com>; nd <nd@arm.com>;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v13 3/9] smccc: Export smccc conduit get helper.
> 
> On Fri, Jun 19, 2020 at 09:01:14PM +0800, Jianyong Wu wrote:
> > Export arm_smccc_1_1_get_conduit then modules can use smccc helper
> > which adopts it.
> >
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  drivers/firmware/smccc/smccc.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/firmware/smccc/smccc.c
> > b/drivers/firmware/smccc/smccc.c index 4e80921ee212..b855fe7b5c90
> > 100644
> > --- a/drivers/firmware/smccc/smccc.c
> > +++ b/drivers/firmware/smccc/smccc.c
> > @@ -24,6 +24,7 @@ enum arm_smccc_conduit
> > arm_smccc_1_1_get_conduit(void)
> >
> >  	return smccc_conduit;
> >  }
> > +EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
> 
> EXPORT_SYMBOL_GPL, please.

Ok, thanks.

Thanks
Jianyong 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
