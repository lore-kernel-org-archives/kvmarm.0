Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8D9C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 02:12:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA7012075F
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 02:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="d3PWjUhX";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="d3PWjUhX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA7012075F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E7E44B1BA;
	Sun, 24 May 2020 22:12:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C1AxAgOwxc5I; Sun, 24 May 2020 22:12:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C566D4B186;
	Sun, 24 May 2020 22:12:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5288F4B17C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 May 2020 22:12:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nCC5ffRjI8t8 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 24 May 2020 22:12:01 -0400 (EDT)
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr20063.outbound.protection.outlook.com [40.107.2.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 492E84B15F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 May 2020 22:12:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1YoSmT7WS0Ndsv47A1pmnmGimdg5mugN7lyM40VV+o=;
 b=d3PWjUhXz3bc3ZzZVFEiOzFRMs9RKXlp5peJLeShtjTONojKwhnb50/inwPM7x0bbk9R5407UglasyxaVxp6eNbGBUx9QrI1rv1SdELvYVNIg/gWtoiLLIRGhm9OxiwTLTu72FUVkHnkNJP1rI42aJLqo6gfGvuVqfyXjhG/RkI=
Received: from AM3PR07CA0112.eurprd07.prod.outlook.com (2603:10a6:207:7::22)
 by DB6PR0801MB1767.eurprd08.prod.outlook.com (2603:10a6:4:2e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Mon, 25 May
 2020 02:11:58 +0000
Received: from AM5EUR03FT056.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:207:7:cafe::4d) by AM3PR07CA0112.outlook.office365.com
 (2603:10a6:207:7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.7 via Frontend
 Transport; Mon, 25 May 2020 02:11:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT056.mail.protection.outlook.com (10.152.17.224) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 02:11:57 +0000
Received: ("Tessian outbound facc38080784:v57");
 Mon, 25 May 2020 02:11:57 +0000
X-CR-MTA-TID: 64aa7808
Received: from 10dd158996a5.3
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 BA220C70-94CC-4857-A31B-FE3EE6AC0425.1; 
 Mon, 25 May 2020 02:11:52 +0000
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 10dd158996a5.3
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 25 May 2020 02:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXpgNEsa0tqK5CdY/Jj79NnH0p1GPPgthSzW4ec34A7Il9y5phzbd4iEU7QnFgFEC/z/PwcBAKsQdiLBAZzDp+xvC0N+Y6kXFc5jl/rHCfvyh4PTe70NtqITD/UhiK3xvcDSS38lwutWVvTcriVnjy6d8ytfVk48x4BVW8Tp03IC+fCOTjimkAW9hSfMgIPkCACTsOz45khJU4EpZ1Hn+BE0iQ6XZWdFbSL/h8fPd/AxwfhnrUowz5G9f3oxL1YKD8YXkFBn2iyPav5lZEeeQGfVEN51ebBmqRVYEbu+42B25VfpLXYRtsd/qSv1x0owuUVxd3ijEkQyMTsIYU3yMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1YoSmT7WS0Ndsv47A1pmnmGimdg5mugN7lyM40VV+o=;
 b=lwqQMXb5zUI7SrXCDgLWBhZ7Cr9uA1rd86sZaORa1t42VWp5TTyfWuxO4jhqvSKC/AN/TFs0olN5GOgwz5DW5NLFtzmjp361RaJ/CcL0ypDC6fHJwH2Gg/MnXBwE5NUnWAM3pGQ0lvm9js/4p6+SDHC3ePRM7h4Rdb4V/rilaFAZVYUTAgd6lLm9Kay4DJcdpODk6f/zAv+IsvELsGlFmi+p+PinGTbPcKMJtFkOkGnsoTDa1AE0WFzAW+PfNJv9HnmApN7dX0Diq+LgojCCpVI+YgRIF83ziG2FG3Rp8AFu5l/mLTuAyUoDhu7BE563GzF4UNdaloG1R/mEKsaIsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1YoSmT7WS0Ndsv47A1pmnmGimdg5mugN7lyM40VV+o=;
 b=d3PWjUhXz3bc3ZzZVFEiOzFRMs9RKXlp5peJLeShtjTONojKwhnb50/inwPM7x0bbk9R5407UglasyxaVxp6eNbGBUx9QrI1rv1SdELvYVNIg/gWtoiLLIRGhm9OxiwTLTu72FUVkHnkNJP1rI42aJLqo6gfGvuVqfyXjhG/RkI=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2443.eurprd08.prod.outlook.com (2603:10a6:3:d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Mon, 25 May
 2020 02:11:48 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 02:11:48 +0000
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
Thread-Index: AQHWMBRiyrp0i3ftg0yKp1NgeF42Dqi0J4kAgAPjibA=
Date: Mon, 25 May 2020 02:11:48 +0000
Message-ID: <HE1PR0802MB2555A66F063927D5B855E1C6F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-8-jianyong.wu@arm.com>
 <87fce07b-d0f5-47b0-05ce-dd664ce53eec@arm.com>
In-Reply-To: <87fce07b-d0f5-47b0-05ce-dd664ce53eec@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: ce3b9103-893c-4ae7-915c-be7da61ac5e9.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 91174930-7fa9-4481-ed8b-08d800510084
x-ms-traffictypediagnostic: HE1PR0802MB2443:|DB6PR0801MB1767:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0801MB1767BC461DF5793F8C291956F4B30@DB6PR0801MB1767.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: +zaMIu5jRJzSeLCnoFbFR4aEOOMCpbAq7AeEn93OldWUps4bmEUhCf7Glyoas4WSzKEEY/ea1NITrSsL9DevrhSurumEs50mNwbpBQ1jGtIcb5fAs79s8ZvmRZKV5HDmvBb50CWWjsDveymhiU2cYQwjtfLYOPpB22ohMhsAE7VQByMKWt+Q6xq9UFDdygj1zMQIMr7CUW8gww32NyHHhTiFmL3B1KWe+38RE7x+07NBjOlAIU1IKi8Hd7Mtq67iZrc5ddkjUl1pbwwN5mt7uxL/0lOpPMv9c0v6N5Z1a0+kJirUjMdSsv4JGzymWTgVz2lMKpTA0fjrDkEKOI5SmEQBGNwa50CpHajVrwubMszCGXx+qHpnC0bVDs1N3ST6
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(39850400004)(366004)(396003)(136003)(346002)(376002)(66556008)(55016002)(64756008)(8676002)(6636002)(66476007)(66946007)(186003)(86362001)(52536014)(33656002)(66446008)(2906002)(110136005)(5660300002)(54906003)(4326008)(7416002)(6506007)(71200400001)(53546011)(26005)(8936002)(316002)(9686003)(478600001)(76116006)(7696005)(921003);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: 5VmSj1yL4DaQ0nweIlNUKH1FJGnygou4FaNtmYzoqvxyK05oAtIOaIYvJQ9u4HjPfc0VPs5J72DSN4t3QaLyr9vZTlbm/xqytpdJb0Lu+Qs8k3HxpkFM1u+o9G/07WYtxW2D+pNQSRYuaoB+gKpgMErE2xwdpnaYF8zd2IXbVIvxDSTPex8NkjrZ+SdquLuvLhKStz3WVKs5kfAf3uGZHExJk7wd6Lp8dYsjRo96CueGfP+J6X0J11frglLK4oaXUJakyrntyPwdKkrgaX33LY772nBKxct3IzbqIwigVh1JCViJXgEuy9CHbb5o35jJk/MFJxm8/7+EKk570bJMWB5q141Vd+TsIAEYOPTqZBfwYYCS4VwWvTf++cep1v73gASSFdiss7cliCBVYnMYJKO9ZosxcG8kFMP33tCtKBlrSIMISdideI6v+U0vNj2G7Djw8N7ZoACsR7scXPRpVRhT6VOrejwiKIRfBZiIbjY=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2443
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT056.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(46966005)(53546011)(6506007)(8936002)(26005)(36906005)(5660300002)(2906002)(110136005)(356005)(4326008)(54906003)(316002)(82310400002)(81166007)(7696005)(478600001)(336012)(9686003)(6636002)(70586007)(70206006)(8676002)(55016002)(82740400003)(186003)(52536014)(86362001)(47076004)(33656002)(921003);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 81e19192-6ecb-446b-64e0-08d80050fb18
X-Forefront-PRVS: 0414DF926F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6PkK5K9YOTem0JAq8D+BKMTG+Y5T4ZbwUmnmBuafI1sHW2FVwlmS9wq2JEsOYPEGhT/tfam+4NiNxMU21Wwkz4TshYWyxFEUTKsKIjdf8wWVI5xxVUOtHbApKkxqjOQMG40i7YEPkIA31B1eGIFJq7OM1l+VS02noeB3nrNxxzRJoAdCtm4C5mX9Nvtp5MPgupDBwk9aTAAamFwaQ/IUD/37RAJ4l5jEKh/Y9LKJDPXJHO4+FPCPxjWB+zqPNfWZQ/Gu2rtnBGAC5L5qmCWuhtU+1clwD5qEIlJMUkDBJlbsWalvHDllJ0q1goCt4nQtBTsM04Ly9ZLvFz+PmWcbz/t0iTb6wGS1KAPWiInGznN9dKHY1may8qkLUxvrzl8LuZOCXIN/FoPFZfh8n5sAttpClX1CY7fp7ZJ3nZuGmrI=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 02:11:57.3108 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91174930-7fa9-4481-ed8b-08d800510084
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1767
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
> Sent: Friday, May 22, 2020 10:18 PM
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
> On 22/05/2020 09:37, Jianyong Wu wrote:
> > ptp_kvm modules will get this service through smccc call.
> > The service offers real time and counter cycle of host for guest.
> > Also let caller determine which cycle of virtual counter or physical
> > counter to return.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >   include/linux/arm-smccc.h | 14 ++++++++++++
> >   virt/kvm/Kconfig          |  4 ++++
> >   virt/kvm/arm/hypercalls.c | 47
> +++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 65 insertions(+)
> >
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index bdc0124a064a..badadc390809 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -94,6 +94,8 @@
> >
> >   /* KVM "vendor specific" services */
> >   #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> > +#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
> > +#define ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY		2
> >   #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> >   #define ARM_SMCCC_KVM_NUM_FUNCS			128
> >
> > @@ -103,6 +105,18 @@
> >   			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> >   			   ARM_SMCCC_KVM_FUNC_FEATURES)
> >
> > +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
> 		\
> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> 		\
> > +			   ARM_SMCCC_SMC_32,
> 	\
> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> > +			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
> > +
> > +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID
> 		\
> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> 		\
> > +			   ARM_SMCCC_SMC_32,
> 	\
> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> > +			   ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY)
> > +
> >   #ifndef __ASSEMBLY__
> >
> >   #include <linux/linkage.h>
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig index
> > aad9284c043a..bf820811e815 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -60,3 +60,7 @@ config HAVE_KVM_VCPU_RUN_PID_CHANGE
> >
> >   config HAVE_KVM_NO_POLL
> >          bool
> > +
> > +config ARM64_KVM_PTP_HOST
> > +       def_bool y
> > +       depends on ARM64 && KVM
> > diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> > index db6dce3d0e23..c964122f8dae 100644
> > --- a/virt/kvm/arm/hypercalls.c
> > +++ b/virt/kvm/arm/hypercalls.c
> > @@ -3,6 +3,7 @@
> >
> >   #include <linux/arm-smccc.h>
> >   #include <linux/kvm_host.h>
> > +#include <linux/clocksource_ids.h>
> >
> >   #include <asm/kvm_emulate.h>
> >
> > @@ -11,6 +12,10 @@
> >
> >   int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >   {
> > +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> > +	struct system_time_snapshot systime_snapshot;
> > +	u64 cycles;
> > +#endif
> >   	u32 func_id = smccc_get_function(vcpu);
> >   	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
> >   	u32 feature;
> > @@ -70,7 +75,49 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >   		break;
> >   	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >   		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> > +
> > +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> > +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP); #endif
> >   		break;
> > +
> > +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> > +	/*
> > +	 * This serves virtual kvm_ptp.
> > +	 * Four values will be passed back.
> > +	 * reg0 stores high 32-bit host ktime;
> > +	 * reg1 stores low 32-bit host ktime;
> > +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
> > +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
> > +	 */
> > +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > +		/*
> > +		 * system time and counter value must captured in the same
> > +		 * time to keep consistency and precision.
> > +		 */
> > +		ktime_get_snapshot(&systime_snapshot);
> > +		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
> > +			break;
> > +		val[0] = upper_32_bits(systime_snapshot.real);
> > +		val[1] = lower_32_bits(systime_snapshot.real);
> > +		/*
> > +		 * which of virtual counter or physical counter being
> > +		 * asked for is decided by the first argument.
> > +		 */
> > +		feature = smccc_get_arg1(vcpu);
> > +		switch (feature) {
> > +		case ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID:
> > +			cycles = systime_snapshot.cycles;
> > +			break;
> > +		default:
> 
> There's something a bit odd here.
> 
> ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID and
> ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID look like they should
> be names of separate (top-level) functions, but actually the _PHY_ one is a
> parameter for the first. If the intention is to have a parameter then it would
> be better to pick a better name for the _PHY_ define and not define it using
> ARM_SMCCC_CALL_VAL.
> 
Yeah, _PHY_ is not the same meaning with _PTP_FUNC_ID,  so I think it should be a different name.
What about ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_COUNTER?

> Second the use of "default:" means that there's no possibility to later extend
> this interface for more clocks if needed in the future.
> 
I think we can add more clocks by adding more cases, this "default" means we can use no first arg to determine the default clock.

> Alternatively you could indeed implement as two top-level functions and
> change this to a...
> 
> 	switch (func_id)
> 
> ... along with multiple case labels as the functions would obviously be mostly
> the same.
> 
> Also a minor style issue - you might want to consider splitting this into it's
> own function.
> 
I think "switch (feature)" maybe better as this _PHY_ is not like a function id. Just like:
"
case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
                feature = smccc_get_arg1(vcpu);
                switch (feature) {
                case ARM_SMCCC_ARCH_WORKAROUND_1:
...
"
> Finally I do think it would be useful to add some documentation of the new
> SMC calls. It would be easier to review the interface based on that
> documentation rather than trying to reverse-engineer the interface from the
> code.
> 
Yeah, more doc needed here.

Thanks
Jianyong 

> Steve
> 
> > +			cycles = systime_snapshot.cycles -
> > +				 vcpu_vtimer(vcpu)->cntvoff;
> > +		}
> > +		val[2] = upper_32_bits(cycles);
> > +		val[3] = lower_32_bits(cycles);
> > +		break;
> > +#endif
> > +
> >   	default:
> >   		return kvm_psci_call(vcpu);
> >   	}
> >

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
