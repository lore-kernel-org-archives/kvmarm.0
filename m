Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4932C43461
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 08:52:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7A8A20757
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 08:52:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="1djd4SmD";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="1djd4SmD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7A8A20757
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 142794B5B2;
	Mon,  7 Sep 2020 04:52:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DJtRHczjjpUY; Mon,  7 Sep 2020 04:52:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38F914B5CD;
	Mon,  7 Sep 2020 04:52:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A75534B5B6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 04:52:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oFif+0pieRw4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 04:52:05 -0400 (EDT)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130072.outbound.protection.outlook.com [40.107.13.72])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B859F4B5B2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 04:52:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQ7stNXprT8Trh/xBD5j++ObG8jHTUlBy3EPWr4RtUo=;
 b=1djd4SmD/BKslsEJkZ2R3HiiFO2jvu2Q2S5/LOFxnekczKCROEepFHXBZqpQwdZFtODyx1yAhE5rgZUwgh5m6sApfmHMk3tygIWvEVhIQwvQrtfEMUsIBQRN+LWLo3jOXEQBCygIwjZuTssHV6uOKBQlSPfuV6Vj4lLVuIK2vUQ=
Received: from AM6PR08CA0032.eurprd08.prod.outlook.com (2603:10a6:20b:c0::20)
 by DB7PR08MB2969.eurprd08.prod.outlook.com (2603:10a6:5:20::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 08:52:02 +0000
Received: from AM5EUR03FT050.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:c0:cafe::b9) by AM6PR08CA0032.outlook.office365.com
 (2603:10a6:20b:c0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend
 Transport; Mon, 7 Sep 2020 08:52:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT050.mail.protection.outlook.com (10.152.17.47) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 08:52:01 +0000
Received: ("Tessian outbound 34b830c8a0ef:v64");
 Mon, 07 Sep 2020 08:51:34 +0000
X-CR-MTA-TID: 64aa7808
Received: from 8a851988fa69.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 D801B859-B3EF-48A1-BA3A-A87327655408.1; 
 Mon, 07 Sep 2020 08:51:29 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8a851988fa69.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 07 Sep 2020 08:51:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=an2nE3ZXn94e62ZFvjVRcxbVloMJEZu/lAi7idgOi6YuiG8YEl3EwaetyuhW7VHzM2amVdVj+s+Z6HnOrYZfDHWue2B7PDfWWxYiq+kN/BVTviWseYPt3wVR0tzEYd207qZ2+BvzXeHrZiM16ntWnxQXo3HVk2Mwra8pYk+T87jnC3vWe/zzLoePCbq4wy2SBqXvDmSK/suUFlZuMwZOQ7P3h8ciMZFOQ2LTXIjjwLw5myoW1M8b1BSUApwustpCAxxCW3MARn8jskUhLKTCQKvnqMOvqSIK4/+FCZSDlTgAyl50W2hlKbAd06mXtZmL/1rhhrGmJshHDyvmgB0RxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQ7stNXprT8Trh/xBD5j++ObG8jHTUlBy3EPWr4RtUo=;
 b=m3Bkz+SxmFnzrF/s+DXW7N8Axx/XbY0uBAHfo36mcsTUp7YpD9TUthzlZdVTqWvWM+wOalK5BTDvXffMTmIscdFI/snpyVtkzFqI/JNART+E5q69+Kh6ms9W4F2aOoJpVQp4PsbcKWLAQAS7v/XliY30gE1OfvW3BdOqpOs2gcHcmOi0vS3PQQidd40bcblCzQTNd23DIJpYvZdTo2DNuj+R4XCpe5Do+OoEBcmKXRG1xg4ABWiG+YvK4N2Tav149PLuUNkh5VDQKkOIJLm2XpbxjzWBLZQXir+5o7sERtL7lW7dhiyv+pdMUoxSFR+RiBYuL2+HYeTEZda4e0LRiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQ7stNXprT8Trh/xBD5j++ObG8jHTUlBy3EPWr4RtUo=;
 b=1djd4SmD/BKslsEJkZ2R3HiiFO2jvu2Q2S5/LOFxnekczKCROEepFHXBZqpQwdZFtODyx1yAhE5rgZUwgh5m6sApfmHMk3tygIWvEVhIQwvQrtfEMUsIBQRN+LWLo3jOXEQBCygIwjZuTssHV6uOKBQlSPfuV6Vj4lLVuIK2vUQ=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR08MB2700.eurprd08.prod.outlook.com (2603:10a6:7:39::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.19; Mon, 7 Sep
 2020 08:51:24 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00%5]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 08:51:24 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHWgp4Q48WtGxJp4kuFSJTL6o01LqlZ63wAgAL0nPA=
Date: Mon, 7 Sep 2020 08:51:23 +0000
Message-ID: <HE1PR0802MB2555BAE6E8A0EC054258EDC6F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
 <20200904092744.167655-9-jianyong.wu@arm.com> <871rjgmpa5.wl-maz@kernel.org>
In-Reply-To: <871rjgmpa5.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: A510A2A5DD1BA649A57E134BFC576325.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 61908597-b1bd-4457-3e8e-08d8530b49eb
x-ms-traffictypediagnostic: HE1PR08MB2700:|DB7PR08MB2969:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB296947770E5D02A43BA9CB7EF4280@DB7PR08MB2969.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: CoSRw4dX70UCoKUhaz5EmpGoQqk4KnA79NFQto9YD/SAb5VCv9rByrSXH7lCydKIq9COgNyHKuTAxQUFYIl7SfpUG54TASTUj4pssmcFp+aiiwQvmPlEf6TAJBa83rtEBiaAp8Eo/r9MgIb+xZWU/CpeO7SRELUkARUYT5mJhiif1OrRcgunW4LpfuYD8syy+A/SBOFykPdnETNSsRc2WMjwoMbgE7Tc1Bki8Zep32Kt+WoK3z+GAQVMd6jzw9cGHEvWebIn0gy1YYfFLJq0nUX0cXqxVo1gl0gZASpIuiUPoCwAdDesKKGWQMQsGvyGKsOvP2NhhyLw06P7pngfJg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(316002)(54906003)(9686003)(8676002)(2906002)(5660300002)(53546011)(52536014)(7696005)(186003)(71200400001)(26005)(6916009)(55016002)(86362001)(83380400001)(478600001)(6506007)(66446008)(66556008)(66476007)(7416002)(8936002)(66946007)(64756008)(76116006)(33656002)(4326008);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: JSSa5tEGjvIxzO393PMtC5jTSS318irIguqwrdFjmNtqAC7BDaC2P09O7JAZGcO/JCQovhvpj7S9Pinake8s5cMW4S7hBEmtWMCBMDLI1oUIpgyRPA0tw76Ebw7wpySZNs5VjPhvqV46v0TlejlXQ2Kq+I4gde+UsB1Q5x+1YoydOzPeLStGRv6ATyhiA92EglBzcAvMdmNwmbcMwUI9G7wSYXU0tWYj1sipu5iq+9ELhLMVgmMdV2e0xQ0+XrzGl2R4I7Eh56WkdG7uxrce/14f+wIDB2wwnvtiBFnbDy404grQ9PwCdNpY2CbgmrTFpsLbzXeJFgj/hSERLXeeRuV56mpcdDr/O52er6pFFK3be0OEADsedr/tYApEc6NO56khZkrlNiyYYi0dt2M198SdD5GsRE4QfxEaL7OmcitCuBMPXRGi8UACCzqjHJtLbvTs7LIWr2Wq1xeq7KFKnEbR4QCSbps1Ip51tqUjSZUZJnxDmkzZeSZr8hvAZOWV8Abkvy+4qMTlNLNBdibraly42tqEATbepVTItrE0BZfdKwYxyL3X3l7POmnK15CTkqnKUJxXZJ/yIV0Dq2F9WMl2M844/JZLx7TIGd2EIY9iMQBGQcgUBe97pPBXmIsG85YFSJ+d4ntdgZO4z0kPng==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR08MB2700
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: cc190cae-e3bb-4342-8c49-08d8530b3343
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sMwgcbuazV+TqcvQRnWK5nDKLN31LuqTLPmnics9fZuPYx81c1FWR6OTH84JCWHpLU0Wip9eR/RNztFUGhm1OwYWfgU51bvpFrfWCYGVE6KKy4ux/hCNm1aIjM8sKX7sx/iSLRA+AyMDQPxqaqCrB7M4zsTv69eXscEaDXTfli/tdAWYeawf18tNASHoEM1OKAw7LYO+V1FZMaVPDI4T/ZgFJcu+lLcT/42bqigumLLIhCX+NJrnY7RriSbfPBEQ0wvTHMAVO1ppl5nPg8iQb77Ew4EcSZqdrB1C5cAI58aAQfkLJjRtF6jM3Rl5YrOSPlq8xRh/CCUFPrf1mmr/zMsEDpTjn8qgCrW8WPnJORNahF8PrCCkgvv4hDH27StHODTSHyBwYOaOKO8hErpvmg==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966005)(7696005)(478600001)(33656002)(26005)(186003)(8936002)(2906002)(81166007)(356005)(82740400003)(82310400003)(83380400001)(47076004)(5660300002)(54906003)(86362001)(9686003)(52536014)(70206006)(70586007)(6862004)(336012)(6506007)(53546011)(36906005)(316002)(8676002)(4326008)(55016002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 08:52:01.2479 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61908597-b1bd-4457-3e8e-08d8530b49eb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB2969
Cc: Justin He <Justin.He@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Saturday, September 5, 2020 7:33 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
> 
> On Fri, 04 Sep 2020 10:27:42 +0100,
> Jianyong Wu <jianyong.wu@arm.com> wrote:
> >
> > Currently, there is no mechanism to keep time sync between guest and
> > host in arm64 virtualization environment. Time in guest will drift
> > compared with host after boot up as they may both use third party time
> > sources to correct their time respectively. The time deviation will be
> > in order of milliseconds. But in some scenarios,like in cloud
> > envirenment, we ask for higher time precision.
> >
> > kvm ptp clock, which choose the host clock source as a reference clock
> > to sync time between guest and host, has been adopted by x86 which
> > makes the time sync order from milliseconds to nanoseconds.
> >
> > This patch enables kvm ptp clock for arm64 and improve clock sync
> > precison significantly.
> >
> > Test result comparisons between with kvm ptp clock and without it in
> > arm64 are as follows. This test derived from the result of command
> > 'chronyc sources'. we should take more care of the last sample column
> > which shows the offset between the local clock and the source at the last
> measurement.
> >
> > no kvm ptp in guest:
> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >
> ==========================================================
> ==============
> > ^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-   21ms
> > ^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-   21ms
> > ^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-   21ms
> > ^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-   21ms
> > ^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-   21ms
> > ^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-   21ms
> > ^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-   21ms
> > ^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-   21ms
> > ^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-   21ms
> > ^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-   21ms
> >
> > in host:
> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >
> ==========================================================
> ==============
> > ^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-   18ms
> > ^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-   18ms
> > ^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-   18ms
> > ^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-   17ms
> > ^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-   17ms
> > ^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-   17ms
> > ^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-   17ms
> > ^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-   17ms
> > ^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-   17ms
> > ^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-   17ms
> >
> > The dns1.synet.edu.cn is the network reference clock for guest and
> > 120.25.115.20 is the network reference clock for host. we can't get
> > the clock error between guest and host directly, but a roughly
> > estimated value will be in order of hundreds of us to ms.
> >
> > with kvm ptp in guest:
> > chrony has been disabled in host to remove the disturb by network clock.
> >
> > MS Name/IP address         Stratum Poll Reach LastRx Last sample
> >
> ==========================================================
> ==============
> > * PHC0                    0   3   377     8     -7ns[   +1ns] +/-    3ns
> > * PHC0                    0   3   377     8     +1ns[  +16ns] +/-    3ns
> > * PHC0                    0   3   377     6     -4ns[   -0ns] +/-    6ns
> > * PHC0                    0   3   377     6     -8ns[  -12ns] +/-    5ns
> > * PHC0                    0   3   377     5     +2ns[   +4ns] +/-    4ns
> > * PHC0                    0   3   377    13     +2ns[   +4ns] +/-    4ns
> > * PHC0                    0   3   377    12     -4ns[   -6ns] +/-    4ns
> > * PHC0                    0   3   377    11     -8ns[  -11ns] +/-    6ns
> > * PHC0                    0   3   377    10    -14ns[  -20ns] +/-    4ns
> > * PHC0                    0   3   377     8     +4ns[   +5ns] +/-    4ns
> >
> > The PHC0 is the ptp clock which choose the host clock as its source
> > clock. So we can see that the clock difference between host and guest
> > is in order of ns.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  drivers/clocksource/arm_arch_timer.c | 24 +++++++++++++
> >  drivers/ptp/Kconfig                  |  2 +-
> >  drivers/ptp/ptp_kvm_arm64.c          | 53
> ++++++++++++++++++++++++++++
> >  3 files changed, 78 insertions(+), 1 deletion(-)  create mode 100644
> > drivers/ptp/ptp_kvm_arm64.c
> 
> And I missed that one earlier:
> 
> > diff --git a/drivers/clocksource/arm_arch_timer.c
> > b/drivers/clocksource/arm_arch_timer.c
> > index d55acffb0b90..aaf286e90092 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -1650,3 +1650,27 @@ static int __init arch_timer_acpi_init(struct
> > acpi_table_header *table)  }  TIMER_ACPI_DECLARE(arch_timer,
> > ACPI_SIG_GTDT, arch_timer_acpi_init);  #endif
> > +
> > +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
> > +#include <linux/arm-smccc.h>
> 
> No conditional includes, please.
> 
Ok.

> > +int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct
> timespec64 *ts,
> > +			      struct clocksource **cs)
> > +{
> > +	struct arm_smccc_res hvc_res;
> > +	ktime_t ktime;
> > +
> > +	/* Currently, linux guest will always use the virtual counter */
> > +
> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> NC_ID,
> > +			     ARM_PTP_VIRT_COUNTER, &hvc_res);
> 
> You don't need to assume anything. This driver already provides you with the
> information you need to tell the hypervisor which counter to
> use:
> 
> 	if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
> 		ptp_counter = ARM_PTP_VIRT_COUNTER;
> 	else
> 		ptp_counter = ARM_PTP_PHYS_COUNTER;
> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> NC_ID,
> 			     ptp_counter, &hvc_res);
> 
> At least, this is vaguely future proof.
> 
> The hypervisor will still have to discriminate between a call between a call
> from vEL1 or vEL2 to decide whether to subtract the offset from the counter
> value, but that's out of scope for now.

Very kind of you!

Thanks
Jianyong 
> 
> 	M.
> 
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
