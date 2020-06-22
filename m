Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE8EC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 02:25:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F422021527
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 02:25:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="2MFZ0jBW";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="2MFZ0jBW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F422021527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F6F84B122;
	Sun, 21 Jun 2020 22:25:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OClz+aybZ08u; Sun, 21 Jun 2020 22:25:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A19414B135;
	Sun, 21 Jun 2020 22:25:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D99BE4B125
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Jun 2020 22:25:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VIstxgOzuT-N for <kvmarm@lists.cs.columbia.edu>;
 Sun, 21 Jun 2020 22:25:41 -0400 (EDT)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2085.outbound.protection.outlook.com [40.107.22.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E48784B114
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Jun 2020 22:25:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+2wgkCfswpinypFIlzV4ZjoaDq7c3n4X+13S8yhCs=;
 b=2MFZ0jBW7ET5bqtdkbHSK6B7dO/HDEGG1leJ9u22eMDhUazH5FrpbGdfCbcF2d363ZnwEUR9xh23wzkRPf/I2Edzc1h839r5FRs8Elu8nNdGUowlgSIDyM/aJvLi/AXNgm2kEEDOOFoLt/CI3hZvSiPQksjHPyjRqtDv4LAgliU=
Received: from AM6P191CA0099.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::40)
 by AM6PR08MB4785.eurprd08.prod.outlook.com (2603:10a6:20b:d2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 02:25:37 +0000
Received: from VE1EUR03FT044.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8a:cafe::6f) by AM6P191CA0099.outlook.office365.com
 (2603:10a6:209:8a::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend
 Transport; Mon, 22 Jun 2020 02:25:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT044.mail.protection.outlook.com (10.152.19.106) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 02:25:37 +0000
Received: ("Tessian outbound da41658aa5d4:v59");
 Mon, 22 Jun 2020 02:25:36 +0000
X-CR-MTA-TID: 64aa7808
Received: from cda8fea7d4e9.3
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 C8F0FB60-374B-4D68-B388-6C246FCFADE0.1; 
 Mon, 22 Jun 2020 02:25:31 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id cda8fea7d4e9.3
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 22 Jun 2020 02:25:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oX72EJUQkN0E10fEpWlHPfxyymiL6FtPIZH5P8uyB2htnxmoGgLMKUeH2cPVogGVDxpehk9CbrTi2E7tbPbLo8eRaUjgJPTSuE5BL5XQeRd8n0tg58e9AkPRX9LsNXvedCtOkXA6S8hMKL1uQn2RfscRg7vAxu76GqMtPuC3cDID9qNWDgSmyAn9vtu/eHUAcUyzz8a1nSnH3gRHHd7G27MerghzLGRvG+yWvGcLU0BnuwyNrgFIFTt1xzT+1nuqMwXbxyOmkDDp7GPtHioVKsddzIjTiToNljcE/m1QTnDaT+1+iMKaWLiUi7ZKj104bX756pPF2CAn0xLHn+ksgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+2wgkCfswpinypFIlzV4ZjoaDq7c3n4X+13S8yhCs=;
 b=XtKgHxvkNlPiJu+/xIABormmXweAIp80eA03flevRCmURvdVZw2zqvkDrCSC8sTj0H3RX/iOYmt/FWJcgJ/JxLD+36Qg1PhXiebSBxCG9R4vIKiCdC4uOpYhAUb4VbZLvjJG4y6sBquKip2tcSnf72rU3MjmbKAcL4Kx2MdMi5UbctsFxfqfvknqlG9CA5edHeLvcS3nw2bxuGgjAV7lEsrMm9yoAi31f24A9dATZ1daFNdg2/vZ5lZuUoZACJGLPIV4SH/rqXJ3hOrYWucLucqdS2ZXkPlyWbXzEydAYZBNPNIYBVFkgSmMa+sv0shlHDD4X84GRS/vP2qgBkVj+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+2wgkCfswpinypFIlzV4ZjoaDq7c3n4X+13S8yhCs=;
 b=2MFZ0jBW7ET5bqtdkbHSK6B7dO/HDEGG1leJ9u22eMDhUazH5FrpbGdfCbcF2d363ZnwEUR9xh23wzkRPf/I2Edzc1h839r5FRs8Elu8nNdGUowlgSIDyM/aJvLi/AXNgm2kEEDOOFoLt/CI3hZvSiPQksjHPyjRqtDv4LAgliU=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2169.eurprd08.prod.outlook.com (2603:10a6:3:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 02:25:29 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a%6]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 02:25:29 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Steven Price <Steven.Price@arm.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "maz@kernel.org" <maz@kernel.org>, "richardcochran@gmail.com"
 <richardcochran@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>,
 "will@kernel.org" <will@kernel.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>
Subject: RE: [RFC PATCH v13 7/9] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Topic: [RFC PATCH v13 7/9] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Index: AQHWRhxz06Mst+c5/kmb7LupZG0AtqjfwQIAgAQdABA=
Date: Mon, 22 Jun 2020 02:25:28 +0000
Message-ID: <HE1PR0802MB25558F9A526C327134C7A7EEF4970@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200619093033.58344-1-jianyong.wu@arm.com>
 <20200619093033.58344-8-jianyong.wu@arm.com>
 <c56a5b56-8bcb-915c-ae7e-5de92161538c@arm.com>
In-Reply-To: <c56a5b56-8bcb-915c-ae7e-5de92161538c@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 8e68230a-6bd9-4394-b465-26611406ea1c.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1a75133c-483b-4191-b8d5-08d816538cb9
x-ms-traffictypediagnostic: HE1PR0802MB2169:|AM6PR08MB4785:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB47856F8D888FAB73DCC38558F4970@AM6PR08MB4785.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: s4u9hcUEDmZ6upZriXZs9u0gzSPWcCDXKOapDSqatV+PXQZyVOXMya1eczkmMCXmtgMF/CxcYV7/T8xX/CP8vbfaljFowQkSTlW3S8MiuElhZip/Q5sr71tHxWvoRMidtK6USp7HZPzvGFjXjpKnEODhqB8dDl/uJohGKonsT0FzzqXaWni0OAeinDMee4xQHTQM8qY8K8jisscE7EVytAeLN4g2MVyubu/w7/KnYaUbbh0DyC9s7vs4XxqsrnUSzuh4DPNWdfpOB1I6fsnXSt4y6ZQC7d0xM0mmluyBAK77X/Gn2KPGB7m4i1MkYu3dVNma0K3YtlllzVazCAzmZz3ZVNqDBwjrpGe8z+SIdh1HxvOK/tNU68NYlgqnSoyR
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(346002)(366004)(396003)(39850400004)(376002)(136003)(4326008)(66476007)(7416002)(71200400001)(316002)(7696005)(110136005)(478600001)(83380400001)(33656002)(54906003)(6636002)(5660300002)(55016002)(9686003)(64756008)(6506007)(53546011)(66446008)(52536014)(26005)(8936002)(66556008)(2906002)(8676002)(76116006)(66946007)(186003)(86362001)(921003);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: haS+UhtPdUkMQm/hn0ir6BtqzBTlSHyCICM6wdXLHnVvRSrOVZCK7lu5cWWlDhZv6+XQiRRqoKmOBYyA/3psom3nBx1EVnn3Xc+z3T3pchUn9V+3Dy9G8iaBTiABBneRgG/apQ1dXIlBpUW3Bf0y1DLe9v3dkVrT61ca08ePx7rdWFrtf3gvTdrJfFxX8b1ou6XUMySfzWLWB9aJHyeSg5FRUWSvmBIn75QoXAQgeYtbWeV2x86SOFZZdp2hkh91NKFi+LC13iu9U9v+kkoOfgG47yo46Kuu7eyAbf4b5nbdwCuk+1mrxKVm+WGGaieoASRh9yqvnz6TvzLNUm//OjmCKiMO0iF0nvESMAS0N5mrc6drDUM2cvWu4uqea15N1Zjq9vMXXeJMuDJnur/E+bD3/+FQ3/6rYblBfddbXQGE9M3RrQC5HWaUncz7Uwj4Vyfc7IG4GHh8f7J7VCf0mhkXiDHYWDZr3uS+sUwWl0c=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2169
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT044.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(376002)(346002)(396003)(39850400004)(136003)(46966005)(110136005)(83380400001)(8676002)(55016002)(5660300002)(7696005)(54906003)(53546011)(6506007)(70206006)(9686003)(70586007)(6636002)(86362001)(52536014)(81166007)(316002)(82310400002)(478600001)(336012)(8936002)(356005)(36906005)(2906002)(26005)(47076004)(33656002)(186003)(82740400003)(4326008)(921003);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9945d26c-0156-429c-d823-08d8165387f4
X-Forefront-PRVS: 0442E569BC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: foMqgYJJceDkwmuyS9kFhXChD8T2ZKW1HK+vocVydW21V5XJa0bkvMd9A9QrCct6kBNxoSF58NtZi/EZWF0n2gsFU4cSyPilb3iQ4Z2yaNE6etQ1dqihny3KgNUReAS7jr2YYeIlfemM8yDIfQkxg5Iy8FBBpdht49JmQMi2AtIcB+1ji1sqiwf4kdD7LdwFBguOrxra0SpRrF7jkzrznU3wxwKBASt288jQZPc1TPA58PQJETNg82mWOKf066DXVFd3huSXUWCrsF8Mr8+StCFn5IEm3kPOudXndcbBmBDSdMtTsX2J1MJNsmMQ/A6qpJsXZ3cSWvpX+nfAkydDdOisdZeLTMiAebxiwQxzXxAMTf2+ShOH7hnWlULNiE4KYv+AUAmtxNRI0zNe3yn9GqFTqlwqK4R+j+ImE8laAY0=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 02:25:37.0844 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a75133c-483b-4191-b8d5-08d816538cb9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4785
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
> Sent: Friday, June 19, 2020 6:45 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>; netdev@vger.kernel.org;
> yangbo.lu@nxp.com; john.stultz@linaro.org; tglx@linutronix.de;
> pbonzini@redhat.com; sean.j.christopherson@intel.com; maz@kernel.org;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v13 7/9] arm64/kvm: Add hypercall service for kvm
> ptp.
> 
> On 19/06/2020 10:30, Jianyong Wu wrote:
> > ptp_kvm will get this service through smccc call.
> > The service offers wall time and counter cycle of host for guest.
> > caller must explicitly determines which cycle of virtual counter or
> > physical counter to return if it needs counter cycle.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >   arch/arm64/kvm/Kconfig      |  6 +++++
> >   arch/arm64/kvm/hypercalls.c | 50
> +++++++++++++++++++++++++++++++++++++
> >   include/linux/arm-smccc.h   | 30 ++++++++++++++++++++++
> >   3 files changed, 86 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig index
> > 13489aff4440..79091f6e5e7a 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -60,6 +60,12 @@ config KVM_ARM_PMU
> >   config KVM_INDIRECT_VECTORS
> >   	def_bool HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS
> >
> > +config ARM64_KVM_PTP_HOST
> > +	bool "KVM PTP host service for arm64"
> > +	default y
> > +	help
> > +	  virtual kvm ptp clock hypercall service for arm64
> > +
> >   endif # KVM
> >
> >   endif # VIRTUALIZATION
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index db6dce3d0e23..366b0646c360 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
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
> > +	u64 cycles = 0;
> > +#endif
> >   	u32 func_id = smccc_get_function(vcpu);
> >   	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
> >   	u32 feature;
> > @@ -70,7 +75,52 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >   		break;
> >   	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >   		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> > +
> > +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> > +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP); #endif
> > +		break;
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
> > +		 * asked for is decided by the first argument of smccc
> > +		 * call. If no first argument or invalid argument, zero
> > +		 * counter value will return;
> > +		 */
> 
> It's not actually possible to have "no first argument" - there's no argument
> count, so whatever is in the register during the call with be passed. I'd also
> caution that "first argument" is ambigious: r0 could be the 'first' but is also the
> function number, here you mean r1.
> 
Sorry,  I really make mistake here, I really mean no r1 value.

> There's also a subtle cast to 32 bits here (feature is u32), which might be
> worth a comment before someone 'optimises' by removing the 'feature'
> variable.
> 
Yeah, it's better to add a note, but I think it's better add it at the first time calling smccc_get_arg1. 
WDYT?

> Finally I'm not sure if zero counter value is best - would it not be possible for
> this to be a valid counter value?

We have two different ways to call this service in ptp_kvm guest, one needs counter cycle,  the other
not. So I think it's vain to return a valid counter cycle back if the ptp_kvm does not needs it.

> 
> > +		feature = smccc_get_arg1(vcpu);
> > +		switch (feature) {
> > +		case ARM_PTP_VIRT_COUNTER:
> > +			cycles = systime_snapshot.cycles -
> > +			vcpu_vtimer(vcpu)->cntvoff;
> 
> Please indent the continuation line so that it's obvious.
Ok,

> 
> > +			break;
> > +		case ARM_PTP_PHY_COUNTER:
> > +			cycles = systime_snapshot.cycles;
> > +			break;
> > +		}
> > +		val[2] = upper_32_bits(cycles);
> > +		val[3] = lower_32_bits(cycles);
> >   		break;
> > +#endif
> > +
> >   	default:
> >   		return kvm_psci_call(vcpu);
> >   	}
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index 86ff30131e7b..e593ec515f82 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -98,6 +98,9 @@
> >
> >   /* KVM "vendor specific" services */
> >   #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> > +#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
> > +#define ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY		2
> > +#define ARM_SMCCC_KVM_FUNC_KVM_PTP_VIRT		3
> >   #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> >   #define ARM_SMCCC_KVM_NUM_FUNCS			128
> >
> > @@ -107,6 +110,33 @@
> >   			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> >   			   ARM_SMCCC_KVM_FUNC_FEATURES)
> >
> > +/*
> > + * kvm_ptp is a feature used for time sync between vm and host.
> > + * kvm_ptp module in guest kernel will get service from host using
> > + * this hypercall ID.
> > + */
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
> > +/*
> > + * kvm_ptp may get counter cycle from host and should ask for which
> > +of
> > + * physical counter or virtual counter by using ARM_PTP_PHY_COUNTER
> > +and
> > + * ARM_PTP_VIRT_COUNTER explicitly.
> > + */
> > +#define ARM_PTP_PHY_COUNTER
> 	\
> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> 		\
> > +			   ARM_SMCCC_SMC_32,
> 	\
> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> > +			   ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY)
> > +
> > +#define ARM_PTP_VIRT_COUNTER
> 	\
> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> 		\
> > +			   ARM_SMCCC_SMC_32,
> 	\
> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> > +			   ARM_SMCCC_KVM_FUNC_KVM_PTP_VIRT)
> 
> These two are not SMCCC calls themselves (just parameters to an SMCCC),
> so they really shouldn't be defined using ARM_SMCCC_CALL_VAL (it's just
> confusing and unnecessary). Can we not just pick small integers (e.g. 0 and 1)
> for these?
> 
Yeah, I think so, it's better to define these parameters ID as single number and not related to
SMCCC. What about keep these 2 macros and define it directly as a number in include/linux/arm-smccc.h.

> We also need some documentation of these SMCCC calls somewhere which
> would make this sort of review easier. For instance for paravirtualised stolen
> time there is Documentation/virt/kvm/arm/pvtime.rst (which also links to
> the published document from Arm).
> 
Good point, a documentation is needed to explain these new SMCCC funcs. 
Do you think we should do that in this patch serial? Does it beyond the scope of this patch set?

Thanks
Jianyong  

> Steve
> 
> >   #ifndef __ASSEMBLY__
> >
> >   #include <linux/linkage.h>
> >

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
