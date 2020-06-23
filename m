Return-Path: <SRS0=SY/6=AE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A6BC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jun 2020 10:23:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BA3402072E
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jun 2020 10:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="9vNp7NBC";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="9vNp7NBC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA3402072E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E2594B0D2;
	Tue, 23 Jun 2020 06:23:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l3WDY9cPAMvS; Tue, 23 Jun 2020 06:23:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D7AE4B0B5;
	Tue, 23 Jun 2020 06:23:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 262634B0B1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2020 06:23:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w3tVQ5FcDZDj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jun 2020 06:23:33 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70081.outbound.protection.outlook.com [40.107.7.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9EFB4A551
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2020 06:23:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HiJESe1t04aQ70FifmeklprXLp7gGNzOFTuEJE086U=;
 b=9vNp7NBCB+fJOoSt54wCl0+QxultOsj9xItLUoz44USQSplPG9/LvHosmHb095qSr5+FJpRb8jGUlyS4MPIi+yf3I8RhPUujflPLUQYunoo5CAsLyGxk9BO67wMQY5GllvAL8EIvry6CZYZyl6deQsSDBvShFdn5GEJiDu3+09Q=
Received: from AM6PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:20b:2e::23)
 by AM0PR08MB3412.eurprd08.prod.outlook.com (2603:10a6:208:dc::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 10:23:28 +0000
Received: from AM5EUR03FT034.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:2e:cafe::f) by AM6PR05CA0010.outlook.office365.com
 (2603:10a6:20b:2e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend
 Transport; Tue, 23 Jun 2020 10:23:28 +0000
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
 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 10:23:28 +0000
Received: ("Tessian outbound da41658aa5d4:v59");
 Tue, 23 Jun 2020 10:23:28 +0000
X-CR-MTA-TID: 64aa7808
Received: from 248a3c0dc87e.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 F20CC0B6-D8E4-4834-BB6B-ED6281F3EEA3.1; 
 Tue, 23 Jun 2020 10:23:23 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 248a3c0dc87e.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 23 Jun 2020 10:23:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEMVKb4DUJzVDZhmO01Rb9K7Pb9Xkx2e7mj3qYVfflYSYUyxuTxjkIPLiDRR7YeahFNlhhBkRCS3dr3kArZVX68EwrLLOrg9pqSvFL7FTL9VsrLgU7O/Kw04i+13W3YCzC8FQL3ak7fR+NbIKbTmbzhqi85yQtLSUfa/29fBOdTb4FhemzdHaaAA6MO4H1UcQ0fa1+LT0G2wYYIUYbBFQvQnmDu6dLdYhJRbW8De4sbCkY9k50TEOTfaz1xu2Ui4atbTamFk1jU5hRAeGNxZfqcUbLDPO4QVsn8HK+h7wfxqAdm18AEUMapdtcxx2ZuyeUMFlAmGDq0oPFosZX1NtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HiJESe1t04aQ70FifmeklprXLp7gGNzOFTuEJE086U=;
 b=dQLTqeGZ1CT5q6hhYe04j30VcNfyERT164QEKKlCtrWcDpuBXrA20nHOl9tFCTFtJc/ewDjSRSAPlgwrx2YKCWfOg9SYuSLYzm3rWq04qe+cNG60Eipokb4sRPPInGUkpLMFBJBL8g7fw7IlbfMXn6J3lFE2NpU14C4gL0P6KtsBZy4EoyPJkK/fy8Ce42VZAlOpua+SZZ0gmc10Do0EgY/ikDqAEbzR1BKNXSWtPKThEvVmbV+IdnBfqZDWCYGLRZyCvxW2HDaINhmE2D5bxB+s6P2UWgzNOvrtwSef7oF3vtso32MJ+OI/cpQ2lLfceuO3FhQuL7eyn/EKWeNMzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HiJESe1t04aQ70FifmeklprXLp7gGNzOFTuEJE086U=;
 b=9vNp7NBCB+fJOoSt54wCl0+QxultOsj9xItLUoz44USQSplPG9/LvHosmHb095qSr5+FJpRb8jGUlyS4MPIi+yf3I8RhPUujflPLUQYunoo5CAsLyGxk9BO67wMQY5GllvAL8EIvry6CZYZyl6deQsSDBvShFdn5GEJiDu3+09Q=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2539.eurprd08.prod.outlook.com (2603:10a6:3:da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 10:23:20 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 10:23:19 +0000
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
Thread-Index: AQHWRhxz06Mst+c5/kmb7LupZG0AtqjfwQIAgAQdABCAAIscAIABjR8g
Date: Tue, 23 Jun 2020 10:23:19 +0000
Message-ID: <HE1PR0802MB2555318C0E7BCC653BC1D4F2F4940@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200619093033.58344-1-jianyong.wu@arm.com>
 <20200619093033.58344-8-jianyong.wu@arm.com>
 <c56a5b56-8bcb-915c-ae7e-5de92161538c@arm.com>
 <HE1PR0802MB25558F9A526C327134C7A7EEF4970@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <f331dc59-5642-33b0-9a37-553b7f536afe@arm.com>
In-Reply-To: <f331dc59-5642-33b0-9a37-553b7f536afe@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: f0caa67c-2ca3-4ae9-abee-fde16c26cb38.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 800ffb5f-b6ca-4306-428c-08d8175f789c
x-ms-traffictypediagnostic: HE1PR0802MB2539:|AM0PR08MB3412:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB34123D8DC33BA7340129A263F4940@AM0PR08MB3412.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: rcj7IV5zpBGplifIc2gOBTqrjmn/QL+l0K/gAny46KzrUDLDEmvSdUm+gD2lhEDMtfTd0lKrMo40Z+LNkD5iDX/FDOZ1qQ5RgyF/MgNMEGqvXf/tintv296iiE6RDpdi/qLmdDQkz6DZaDlogw+tVhECGHs11BECuipJQj2l4/+nLXS5e/82oFbkBJO1SyjKDotUoXT+Jk4M2HrBFcE2jqLja0d+8udVJDVi6QmdtgaP/mjmma4IBesIcZswbpUfR975iv607YtX0kw6tnSBbfMqwSMuVPS3nlGwwZfK2fKLC0OBexwHRFfRAUdOodvY1I8KDgrPzcF5kNT7TwMxhGC3b/qpeya5jQCKguB6VWdT+XhSqA2tldJkE0qVBYuM
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(6636002)(8676002)(5660300002)(52536014)(86362001)(8936002)(64756008)(66446008)(66476007)(71200400001)(83380400001)(66946007)(33656002)(76116006)(66556008)(4326008)(6506007)(53546011)(186003)(26005)(2906002)(55016002)(9686003)(478600001)(110136005)(316002)(54906003)(7696005)(7416002)(921003);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: pBp84UACRGVG/xMQ+MPPBUPb5cepU7HEsiGongCifA+btpCWiKja9XUnu8YOkADifP3EYE0BXup7ICYEPaWP1hQ7e8ki4lQ33eVcgZuqGYiMXqgoNHjtBv0ryJq53+1TGF7/T9pQzGss7nDr9R+SuTqfBRofEDmw5tvZE3+3no3AgQ3iS6CNF6MfGDZjTSgByFMbSR5t6QlXjSXj8kHAXwEqJYYKhNRz9SJD+pEhEk/svaPyJKsB8UmvetVq4sa9UKr/UgmhHvaZQyGoVgb5l1AJlDJdrfnNd4AOXB1PfnZ3/SGJ44KIFxJl4Qq5AvlpZUvMJD3KKfKmNTKEVmOrjeFUA5t12LLyiunMKfRqKDPFphSaUGIm5b7L/SqyGoGajQd47xjsyN1wWIT01WzCToiW40qr0WhYR5pfBMIXGo80/x9icGlSVfbAOfZG0VhRQ60XmcZKH/hwNauAsxvCEV2J83/nNoShqKio+JfT/0s=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2539
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT034.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966005)(6506007)(36906005)(356005)(82740400003)(70206006)(81166007)(4326008)(5660300002)(478600001)(336012)(6636002)(33656002)(47076004)(8936002)(86362001)(8676002)(7696005)(54906003)(53546011)(26005)(110136005)(70586007)(83380400001)(52536014)(186003)(316002)(55016002)(82310400002)(9686003)(2906002)(921003);
 DIR:OUT; SFP:1101; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: b6912019-afb5-4593-169f-08d8175f736a
X-Forefront-PRVS: 04433051BF
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QofFK7A1MjRGjwQG8bZIt3SCqfKcyD8eXzzuAo8Ny20OniQmIz0xohZkDc7KZx7rKM290i7WKBtNyWtRkIaa4F8f9U7G0RbU//jc4l7X7rUiHd+JGGqCQ2VpigfHEVvEZP1kajqfz5bEjx8ZvB40v8euGk0xg+k8yz7YwArbjXmd2y7YkCh3smy7YxtqR94UKmD1enXBBAwAU0xvs7P63FyPaofMp5Tb+WGIZwe2bNraa2BRHydL+Li76xn8+rHfPxH4rTmjXCPZaKwBFceFpG0YueuRxthxxJ4tpDBDKLGTsIyB4qTBOAKdlCOPK0btQZ8b2MI6P9pAnFT0ixuyNZjMUlNOqTe11IORQEWRp5es6BDgBEaq3moAcFhalIWDhFOZM6F9x7BXh1Jh+vtlrSA55PDxvlGoSyJAKwZym0w=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 10:23:28.5064 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 800ffb5f-b6ca-4306-428c-08d8175f789c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3412
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

Hi steven,

> -----Original Message-----
> From: Steven Price <steven.price@arm.com>
> Sent: Monday, June 22, 2020 5:51 PM
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
> On 22/06/2020 03:25, Jianyong Wu wrote:
> > Hi Steven,
> 
> Hi Jianyong
> 
> [...]
> >>> diff --git a/arch/arm64/kvm/hypercalls.c
> >>> b/arch/arm64/kvm/hypercalls.c index db6dce3d0e23..366b0646c360
> >>> 100644
> >>> --- a/arch/arm64/kvm/hypercalls.c
> >>> +++ b/arch/arm64/kvm/hypercalls.c
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
> >>> +	u64 cycles = 0;
> >>> +#endif
> >>>    	u32 func_id = smccc_get_function(vcpu);
> >>>    	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
> >>>    	u32 feature;
> >>> @@ -70,7 +75,52 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >>>    		break;
> >>>    	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >>>    		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> >>> +
> >>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> >>> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP); #endif
> >>> +		break;
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
> >>> +		 * asked for is decided by the first argument of smccc
> >>> +		 * call. If no first argument or invalid argument, zero
> >>> +		 * counter value will return;
> >>> +		 */
> >>
> >> It's not actually possible to have "no first argument" - there's no
> >> argument count, so whatever is in the register during the call with
> >> be passed. I'd also caution that "first argument" is ambigious: r0
> >> could be the 'first' but is also the function number, here you mean r1.
> >>
> > Sorry,  I really make mistake here, I really mean no r1 value.
> 
> My point is that it's not possible to have "no r1 value" - r1 always has a value.
> So you can have an "invalid argument" (r1 has a value which isn't valid), but
> it's not possible to have "no first argument". It would only be possible to
> have no argument if the interface told us how many arguments were valid,
> but SMCCC doesn't do that.
> 
Oh, sorry again, it should be "no valid r1 value". Thanks for clarifying this issue.

> >> There's also a subtle cast to 32 bits here (feature is u32), which
> >> might be worth a comment before someone 'optimises' by removing the
> 'feature'
> >> variable.
> >>
> > Yeah, it's better to add a note, but I think it's better add it at the first time
> calling smccc_get_arg1.
> > WDYT?
> 
> I'm a bit confused about where exactly you were suggesting. The assignment
> (and implicit cast) are just below, so this comment block seemed a sensible
> place to add the note. But I don't really mind exactly where you put it (as long
> as it's close), it's just a subtle detail that might get lost if there isn't a
> comment.
> 
Ok, I will add a note before smccc_get_arg1 called.

> >> Finally I'm not sure if zero counter value is best - would it not be
> >> possible for this to be a valid counter value?
> >
> > We have two different ways to call this service in ptp_kvm guest, one
> > needs counter cycle,  the other not. So I think it's vain to return a valid
> counter cycle back if the ptp_kvm does not needs it.
> 
> Sorry, I didn't write that very clearly. What I meant is that returning '0' in the
> case of an invalid argument might be difficult to recognise.
> '0' may be a valid reading of a counter (e.g. reading the counter just after the
> VM has been created if the counter increments very slowly). So it may be
> worth using a different value when an invalid argument has been specified.
> E.g. an "all ones" (-1) value may be more recognisable.
>
Ok, -1 is better than 0.
 
> In practice most counters increment fast enough that this may not actually be
> an issue, but this sort of thing is a pain to fix if it becomes a problem in the
> future.
> 
Yeah.
> >>
> >>> +		feature = smccc_get_arg1(vcpu);
> >>> +		switch (feature) {
> >>> +		case ARM_PTP_VIRT_COUNTER:
> >>> +			cycles = systime_snapshot.cycles -
> >>> +			vcpu_vtimer(vcpu)->cntvoff;
> >>
> >> Please indent the continuation line so that it's obvious.
> > Ok,
> >
> >>
> >>> +			break;
> >>> +		case ARM_PTP_PHY_COUNTER:
> >>> +			cycles = systime_snapshot.cycles;
> >>> +			break;
> >>> +		}
> >>> +		val[2] = upper_32_bits(cycles);
> >>> +		val[3] = lower_32_bits(cycles);
> >>>    		break;
> >>> +#endif
> >>> +
> >>>    	default:
> >>>    		return kvm_psci_call(vcpu);
> >>>    	}
> >>> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> >>> index 86ff30131e7b..e593ec515f82 100644
> >>> --- a/include/linux/arm-smccc.h
> >>> +++ b/include/linux/arm-smccc.h
> >>> @@ -98,6 +98,9 @@
> >>>
> >>>    /* KVM "vendor specific" services */
> >>>    #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> >>> +#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
> >>> +#define ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY		2
> >>> +#define ARM_SMCCC_KVM_FUNC_KVM_PTP_VIRT		3
> >>>    #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> >>>    #define ARM_SMCCC_KVM_NUM_FUNCS			128
> >>>
> >>> @@ -107,6 +110,33 @@
> >>>    			   ARM_SMCCC_OWNER_VENDOR_HYP,
> >> 		\
> >>>    			   ARM_SMCCC_KVM_FUNC_FEATURES)
> >>>
> >>> +/*
> >>> + * kvm_ptp is a feature used for time sync between vm and host.
> >>> + * kvm_ptp module in guest kernel will get service from host using
> >>> + * this hypercall ID.
> >>> + */
> >>> +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
> >> 		\
> >>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> >> 		\
> >>> +			   ARM_SMCCC_SMC_32,
> >> 	\
> >>> +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> >> 		\
> >>> +			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
> >>> +
> >>> +/*
> >>> + * kvm_ptp may get counter cycle from host and should ask for which
> >>> +of
> >>> + * physical counter or virtual counter by using
> ARM_PTP_PHY_COUNTER
> >>> +and
> >>> + * ARM_PTP_VIRT_COUNTER explicitly.
> >>> + */
> >>> +#define ARM_PTP_PHY_COUNTER
> >> 	\
> >>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> >> 		\
> >>> +			   ARM_SMCCC_SMC_32,
> >> 	\
> >>> +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> >> 		\
> >>> +			   ARM_SMCCC_KVM_FUNC_KVM_PTP_PHY)
> >>> +
> >>> +#define ARM_PTP_VIRT_COUNTER
> >> 	\
> >>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> >> 		\
> >>> +			   ARM_SMCCC_SMC_32,
> >> 	\
> >>> +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> >> 		\
> >>> +			   ARM_SMCCC_KVM_FUNC_KVM_PTP_VIRT)
> >>
> >> These two are not SMCCC calls themselves (just parameters to an
> >> SMCCC), so they really shouldn't be defined using
> ARM_SMCCC_CALL_VAL
> >> (it's just confusing and unnecessary). Can we not just pick small
> >> integers (e.g. 0 and 1) for these?
> >>
> > Yeah, I think so, it's better to define these parameters ID as single
> > number and not related to SMCCC. What about keep these 2 macros and
> define it directly as a number in include/linux/arm-smccc.h.
> 
> Yes that sounds good.
> 
> >> We also need some documentation of these SMCCC calls somewhere
> which
> >> would make this sort of review easier. For instance for
> >> paravirtualised stolen time there is
> >> Documentation/virt/kvm/arm/pvtime.rst (which also links to the
> published document from Arm).
> >>
> > Good point, a documentation is needed to explain these new SMCCC funcs.
> > Do you think we should do that in this patch serial? Does it beyond the
> scope of this patch set?
> 
> Adding it in this patch series seems like the right place to me.
> 
Ok, I will add the doc.  This new doc will be named "ptp_kvm.rst" and placed in the same
directory with pvtime.rst. I will compose this doc by reference to your pvtime.rst which is a good example.

Thanks
Jianyong 

> Thanks,
> 
> Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
