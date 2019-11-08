Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A047C5DF60
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 02:35:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 837F22085B
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 02:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="s7Edlzih";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="s7Edlzih"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 837F22085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5B7C4AEDA;
	Thu,  7 Nov 2019 21:35:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eAeNgzH9DmQL; Thu,  7 Nov 2019 21:35:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CC394AEC2;
	Thu,  7 Nov 2019 21:35:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49C6C4AEC2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Nov 2019 21:35:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W24cOz3JWeeL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Nov 2019 21:35:14 -0500 (EST)
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr10047.outbound.protection.outlook.com [40.107.1.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C83A4ACD4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Nov 2019 21:35:14 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIliT+ZwJAQ302yB2UMh7uMoHcc1AWzo6q6WGkj6Z6M=;
 b=s7EdlzihSAIHNyWg/HOQmXeG+Gqqdh0lmjPnpQQRdmyNMT5D02fwtvkbp/0gAGsXKl/GP3hzHqQBDVTvgeF8Jvg7mVeatllW8z8VzMAvHzzJb+5LGXg8f1udT3OBBW8wqrsT5ZqkAUYukxawN0cum5qV+beXg0Xlq9ojnMx2s+s=
Received: from VI1PR0801CA0081.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::25) by HE1PR08MB2780.eurprd08.prod.outlook.com
 (2603:10a6:7:31::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.20; Fri, 8 Nov
 2019 02:35:10 +0000
Received: from AM5EUR03FT057.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::206) by VI1PR0801CA0081.outlook.office365.com
 (2603:10a6:800:7d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2430.20 via Frontend
 Transport; Fri, 8 Nov 2019 02:35:10 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT057.mail.protection.outlook.com (10.152.17.44) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2430.21 via Frontend Transport; Fri, 8 Nov 2019 02:35:09 +0000
Received: ("Tessian outbound 3fba803f6da3:v33");
 Fri, 08 Nov 2019 02:35:06 +0000
X-CR-MTA-TID: 64aa7808
Received: from 88a04053134b.2 (cr-mta-lb-1.cr-mta-net [104.47.0.52])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 A96A875F-18B3-4220-954F-2F1A74F3A608.1; 
 Fri, 08 Nov 2019 02:35:01 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2052.outbound.protection.outlook.com [104.47.0.52])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 88a04053134b.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 08 Nov 2019 02:35:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWXfaidLUpOj/1qpmMklKDxTmVdGj1Gi8upqTC/DulGa79dRnSkP7AbcFucK7ZI1fRVA8XX53SE1noqZhrvJYIp5bH6ALWEJcUyG1Rht4gtT6rNHDnrQlVs9HKW3z8PTtbcNoFkjIe0mhG7ZO7g+4/aXKBSGrGTG8fFJkXBqudGwyDuVQm4nqORdqFuqqX5X/UzB5FICJEpWoTgNyB7Jk/U1295Ftc6IBAGvTd+PzvsF1qRg3J4a9Ut5pn6rE2p+vlkr/WXTJmvLmZo8JWjVURoNVRqydcOjCXxTYzUTqRCn3QtAhsUM0hNA5k4wie1N331f2+3N2V1s2oKBVQPZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIliT+ZwJAQ302yB2UMh7uMoHcc1AWzo6q6WGkj6Z6M=;
 b=UYlcNIClOvLiugGo0fTYuUOoLNBiU/Ixn7NvcRMz1+VDVgITeRti2u3rN3mKP/qavo5/FWV1zIEJJKWVdwAr93yCmD7OLiv/TBHkzARJfWpfVTXrNw8WXxbxX4NpJd6452hwJtvCqtpzbUOkH26CJc3n1O0cjy6h/HmUAa7bT/Cdkama9EmAixrmp0K3KfszSeIrX/paueXTR+Ef7WXBaaEq/AiPvyUGBgNtqUenb8N8Xisg//v2NScFsU36qM88CtXIjfZ/CpJB2O5QKxV2IuDdL4rO/cAn9uZYjtYjP3hWUogA3k5xmidkNPDpMky7uAeSANeHL/Z2SwIoR6V9mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIliT+ZwJAQ302yB2UMh7uMoHcc1AWzo6q6WGkj6Z6M=;
 b=s7EdlzihSAIHNyWg/HOQmXeG+Gqqdh0lmjPnpQQRdmyNMT5D02fwtvkbp/0gAGsXKl/GP3hzHqQBDVTvgeF8Jvg7mVeatllW8z8VzMAvHzzJb+5LGXg8f1udT3OBBW8wqrsT5ZqkAUYukxawN0cum5qV+beXg0Xlq9ojnMx2s+s=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1642.eurprd08.prod.outlook.com (10.168.149.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 02:34:58 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::453c:d9b6:5398:2294]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::453c:d9b6:5398:2294%8]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 02:34:57 +0000
From: "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [RFC PATCH v6 4/7] time: Add mechanism to recognize clocksource
 in time_get_snapshot
Thread-Topic: [RFC PATCH v6 4/7] time: Add mechanism to recognize clocksource
 in time_get_snapshot
Thread-Index: AQHVilqW9INaaa6hrkmF99YEVswOAKd/bNoAgAEv+oA=
Date: Fri, 8 Nov 2019 02:34:57 +0000
Message-ID: <HE1PR0801MB16767168475257E9119C3550F47B0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191024110209.21328-1-jianyong.wu@arm.com>
 <20191024110209.21328-5-jianyong.wu@arm.com>
 <alpine.DEB.2.21.1911070852551.1869@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1911070852551.1869@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 9726902c-df6f-42b3-93a3-231d59260141.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8fac3265-458d-4d85-40f8-08d763f44658
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1642:|HE1PR0801MB1642:|HE1PR08MB2780:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <HE1PR08MB27807C16CFD974D57D3B2461F47B0@HE1PR08MB2780.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 0215D7173F
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(189003)(199004)(13464003)(71190400001)(71200400001)(74316002)(55016002)(3846002)(8676002)(6916009)(25786009)(9686003)(6116002)(81166006)(81156014)(2906002)(6436002)(7736002)(256004)(7416002)(14454004)(4326008)(229853002)(52536014)(6246003)(14444005)(305945005)(316002)(6506007)(54906003)(26005)(99286004)(7696005)(86362001)(76176011)(5660300002)(76116006)(102836004)(55236004)(53546011)(486006)(11346002)(476003)(446003)(478600001)(8936002)(66066001)(186003)(64756008)(66556008)(66446008)(33656002)(66476007)(66946007)(87944003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB1642;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; MX:1; A:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 0sDQ5v4bsIlURXo9/J6EIcRpiTRwufiFwIdJLM+1sYVZoJpj62Hw9tbqHL1wrCRXHMxQ70NuU14MGqxwZPdk5dmlSBBCsnj5XNj3PtnldRplsYtJz3dYHS0sKlzzR3M7wSS2xIiWnxnb8KjA+bd+GrBRLGRYqZr6PcFznuci4Ikv2IThN9nHFuIU6XCLOLy7ZwADkoVvR8EtGI48z4FB3sAHFQovSTl3y+3xxbcN5HA54EMnUrCGEkyar/cnDVzE9cdKz3oFfkWryDE2cMogyzftobqCa2ZIeeK5vX8qhcA40DoRD2cnDi4pg616Qywk8Szzean0hP7UTReh0W5N+8AW0i145/5UMFcoVAOXAGW66/YEq8sl1xvt8om1sRIG6o9MnjTZbCmgyYs42/IvN0OeKUnw07JcjqTyXfYKhpEd35q0c/QM3VduEi2hteTg
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1642
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT057.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(136003)(346002)(396003)(376002)(39860400002)(1110001)(339900001)(13464003)(189003)(199004)(6862004)(476003)(81166006)(99286004)(36906005)(2906002)(8936002)(26005)(316002)(50466002)(3846002)(8746002)(14454004)(26826003)(478600001)(23726003)(97756001)(81156014)(47776003)(486006)(66066001)(126002)(6506007)(53546011)(33656002)(86362001)(25786009)(336012)(305945005)(76176011)(7736002)(229853002)(7696005)(46406003)(74316002)(356004)(102836004)(54906003)(8676002)(6116002)(186003)(14444005)(11346002)(446003)(70586007)(105606002)(70206006)(22756006)(55016002)(4326008)(9686003)(76130400001)(52536014)(6246003)(5660300002)(87944003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR08MB2780;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:Fail; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; MX:1; A:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: af5d8f6a-ae40-4735-84c2-08d763f43f2d
NoDisclaimer: True
X-Forefront-PRVS: 0215D7173F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pXmAroA2UlGEqhrVSb8w+wnQYUq8uMP89kuwBD/vKq+qMgoieB3EXabgrzinqb02+9G8ePMpNTA/TGb9/MpZJcLHvncDBgujGkR4F7K3/PzDtfWggRZGkSIWb/nWGTvbJEFkN6akVClLLJzx8xIbfFxSwO8oL+WnD8IwyXxaTB6cmuryGoOzZeNB9LifLxqGUipi+VxAA6cAq1Rdyu1JkjBF6fWp2Wz7XGC/eIVlNM0yRglH/n82yvoYbMCk3mmiQbYVVmDzcE3UMi7eevUxJcLQvrrJ1rFxRBSSGvE8TxEOna5/sj1RNqvjFErp19h/TiQVfIefxHNKrhCkwDjLhr49JZzd6RknPjRaI45xtNVZMP4ScH8VLoGHpPUFYzX9qOkbr5NxF1jc8GKnsv3hqwXEIDjOFfjgSkqXVbseNWDoHi4zKDd60pf7Oo8QDbOa
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2019 02:35:09.9013 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fac3265-458d-4d85-40f8-08d763f44658
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR08MB2780
Cc: "Justin He \(Arm Technology China\)" <Justin.He@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, nd <nd@arm.com>,
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

Hi tglx,

> -----Original Message-----
> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Thursday, November 7, 2019 3:56 PM
> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> pbonzini@redhat.com; sean.j.christopherson@intel.com; maz@kernel.org;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v6 4/7] time: Add mechanism to recognize
> clocksource in time_get_snapshot
> 
> On Thu, 24 Oct 2019, Jianyong Wu wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> >
> > In some scenario like return device time to ptp_kvm guest, we need
> > identify the current clocksource outside core time code.
> >
> > This patch add a mechanism to recognize the current clocksource by
> > export clocksource id in time_get_snapshot.
> 
> Please check Documentation/process/submitting-patches.rst and search for
> 'This patch'.
> 

Yeah, the expression should be more impersonal.

> > diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> > index b21db536fd52..ac8016b22734 100644
> > --- a/include/linux/clocksource.h
> > +++ b/include/linux/clocksource.h
> > @@ -19,6 +19,7 @@
> >  #include <linux/of.h>
> >  #include <asm/div64.h>
> >  #include <asm/io.h>
> > +#include <linux/clocksource_ids.h>
> 
> Please place that include to the other linux includes. You might notice that
> there is ordering here.
>
Ok, 
 
> But where is that include? It's not part of that series, so how is this supposed
> to compile?

OMG! Sorry, I added this file when I prepared my patches but missed to include it into this patch! This must be avoid latter.

Thanks
Jianyong

> 
> Thanks,
> 
> 	tglx
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
