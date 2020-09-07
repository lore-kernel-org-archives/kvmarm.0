Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759A2C43461
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 09:28:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96892208C7
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 09:28:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="cxHIgqtU";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="cxHIgqtU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96892208C7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3784B5E3;
	Mon,  7 Sep 2020 05:28:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rTqubcp583+z; Mon,  7 Sep 2020 05:28:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59CDA4B578;
	Mon,  7 Sep 2020 05:28:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C02AB4B578
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 05:28:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fbpinC0cM6Ud for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 05:28:18 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70071.outbound.protection.outlook.com [40.107.7.71])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50A9B4B53C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 05:28:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+LIRbyS7mirD2uo0rjpTaYxaNJIbnZAyoeU7Egu2LM=;
 b=cxHIgqtUpMiTEdgzKpXt0OctKngyjNFS89BXiHGFoUja8JmnT5YysX6f5XMTBCXCWgJuT6gg2VkaX8ZDMc+7HyeWlayHCZJ891ufJCEiGLSmGnly5g3pYNNNkFBqCHfoFgXzes9piM37aANCs+gy5Svp6I3GXCz1+d5ydG6Su1o=
Received: from AM5PR0201CA0022.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::32) by DB6PR0802MB2424.eurprd08.prod.outlook.com
 (2603:10a6:4:a0::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 09:28:15 +0000
Received: from AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:3d:cafe::a4) by AM5PR0201CA0022.outlook.office365.com
 (2603:10a6:203:3d::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend
 Transport; Mon, 7 Sep 2020 09:28:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT031.mail.protection.outlook.com (10.152.16.111) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 09:28:13 +0000
Received: ("Tessian outbound 195a290eb161:v64");
 Mon, 07 Sep 2020 09:28:13 +0000
X-CR-MTA-TID: 64aa7808
Received: from f8e596ab0ae9.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 672D886F-B51D-442A-A468-AFF621A70880.1; 
 Mon, 07 Sep 2020 09:28:08 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f8e596ab0ae9.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 07 Sep 2020 09:28:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atcFvWU097ck/38YWCo9EoUc1D8YT0WRwZzXakLyWtai12/ZyNFWli9Elm3jZA4dzo/53wsd8bbX47xwr6/BnZg3hwnqXTFlV3XvmEA1326E5/itThuQP913AbP+f0/NL45871LSRqrtiB+IjL+7gff9DllWWpzXrFGNvSDSPiVbP+HjUYtrZjIUUbyoGaFegachJRWUBBmBkoJra459UJ76HW8EFiBClMlQhdeU2fr1NWYIkQ2lF9DwH/fyoZrozW7dOwN7Vt/LoR6veAmr84t36s1vBe6eO4WOn/o37wZQrAaYosJ0KH8Fp+a8p81WdJmyCprlEhpB23OUJ9R4Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+LIRbyS7mirD2uo0rjpTaYxaNJIbnZAyoeU7Egu2LM=;
 b=RngVqezZm7fVvRzd587v3SxlNi9fUMJeSJIoOU3YuIX0DnsOEO0W7nL3Ocl4zcwfUCeiYNGhyWsvUzqZ3v96qK3B7juiOCavQjZP32cnnGIA+VAKkTTfE3qp3ivIUhcFC1PX3m/M9yzU/lvdL6uIvQHMeeAegJ28G2mTSaMucl87UXuZhcYDEdP6AjT5aaHWgvDWTQjtM0GP/Jv0Kyjq8PH9xuRkM0RmZ0ATYevE+5EqHpuSNL7OK61oMc8nZ7pb9wfxfMDFvdU+brH9T/n1w34sgG4v4gFxMf9+vU7YUMQQW2hxSmZoBfHMU426fRG62MBy2DHt5FtRCBSXdxM4Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+LIRbyS7mirD2uo0rjpTaYxaNJIbnZAyoeU7Egu2LM=;
 b=cxHIgqtUpMiTEdgzKpXt0OctKngyjNFS89BXiHGFoUja8JmnT5YysX6f5XMTBCXCWgJuT6gg2VkaX8ZDMc+7HyeWlayHCZJ891ufJCEiGLSmGnly5g3pYNNNkFBqCHfoFgXzes9piM37aANCs+gy5Svp6I3GXCz1+d5ydG6Su1o=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2251.eurprd08.prod.outlook.com (2603:10a6:3:cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Mon, 7 Sep
 2020 09:28:03 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00%5]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 09:28:03 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHWgp4Q48WtGxJp4kuFSJTL6o01LqlZ4qMAgAL3/tCAAAlCgIAABDCQ
Date: Mon, 7 Sep 2020 09:28:02 +0000
Message-ID: <HE1PR0802MB25551446DC85DB3684D09211F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
 <20200904092744.167655-9-jianyong.wu@arm.com> <874kocmqqx.wl-maz@kernel.org>
 <HE1PR0802MB2555CC56351616836A95FB19F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <366387fa507f9c5d5044549cea958ce1@kernel.org>
In-Reply-To: <366387fa507f9c5d5044549cea958ce1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 8B17ACBF26669E4D86F0DDB84E900C84.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8aa5ca0e-33a4-431e-a86e-08d853105847
x-ms-traffictypediagnostic: HE1PR0802MB2251:|DB6PR0802MB2424:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB2424C8EF22244C327CFEF0C0F4280@DB6PR0802MB2424.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4502;OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: x/f0PLbhq7NvDZad5h+FRhplCb1UC+tbeWJRxGZinvG1CascCWVUEpXCFu06/rkyKZyEgxlyUMZRwbypTNHPAERXOOvBrdeXesvzDpugQlP/F6ZSR7YEp8KcERHS3jx6yEPBxGVtoS1gB6lM1rV8i+zVUW1bWFjNWBa/IxIma3CVOUuiZ6hgOT2yXDQtxbsYBg38/rO5bvwXnRYSWP2JdRCyWO2vRhNI83SoucEoY93pMJrZsapArGyM9AyjC1WXjqHMRHSB8BTb6oRPc5c50Wr+B6VTE8uLuZfrNG0zyN1MMTsQWaoHH6b3M5Os3WTA
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(186003)(52536014)(6916009)(55016002)(478600001)(71200400001)(66946007)(66476007)(83380400001)(76116006)(5660300002)(2906002)(9686003)(64756008)(7416002)(316002)(66446008)(86362001)(66556008)(54906003)(33656002)(8936002)(53546011)(26005)(4326008)(7696005)(6506007)(8676002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: 1aXwki9yBhqKzSsk7+4c9N4r4SlMaLDSypeIPZ8DK3vNsYTc+rwVoqBzk7lYAsUwMWjEfy+zdQgQ+naTcdGzNjD2HW9or6oSuSYrCrC4B16Jczk3BXw4Vumow1NOzmydOfXsNo15ZDDkugdUtVGhdfp/nF2sIYzQXmYGcu7OHRveBwXpXkZEieo13mo/HxzyOdzwvSDpsXPh18O1p5/svdTHZNfIBDe3VM03dSfhsIDXPb0g6mDB9TEcuZrJoEok96bs4JMY7ehCUxFQ595XbxbH2Grg/0FJ3yIXOpg6XkNsQ9b4lPHBmVfG4zQ+nlCqOzsyTtxSVQBRI60iKtE/rN9d9Z9oOX61ikObQjUzr8dmsrtpHr+j2W8cYE9a9fz7mGv3Ro7how/6fRaEhZLDErlHVV4MXDVo9Pc/qpb2BVUcuJhbxdHMUR9cYxLjKkKrWHJLZHXNdeoFGwGNVDGy29FRnQGVKZPe6PgybROenHFFz13qOkQTpzs30lhD3bJElO7XCAKb1XLoTcNIiao5sBB0UG3pLL9R3PDgUfOiv502G1+C2YtahZmp3PFBsPQON4gXrMYZerxh/r7oblU0PTSndEJsMZgEY3YdxGh0oHla+eQWu9vfTSuGOkml76fc483LtEh89M6a6RxYXI9jcw==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2251
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: c46a92c6-d509-4a27-9e0f-08d85310521a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wiIgvPANm3Um0cjwkvzA/JSFiS3mFYqzUJgahwRYLyQ+AAroWcjroZ10G1jdum7Mvs3uqhmKvL8PHhrtxVqAaz3ZIz/rjJZPj+DTEC82e2wO3Q+83USGmGWZn74b/WhSvSsyfVCzO266roFz5KpAcljh+rGB4QnoUNcmXIXfRMVYu9IUpgjVg3uIB2t99aPM4lX1BmIQoI3UlGubeQLASC1FJndgr79WFttpbm/099/oG51s8Q0geBE1FeRR7Su7iUQ3GT3YM3EnmcVieMkSWWS2L4aAu/5A/LO4KolHD4j7ECemKaTyfjIFgaVZxOur+2Za5FDiUTCS2Bw5pM0IyY83ROes4SErBqtaGc50ZHwzRi0QAMSYw5eTg3r5qRXEhykPT+Tyviyog/bnsvfNcQ==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966005)(6862004)(53546011)(6506007)(7696005)(86362001)(8936002)(33656002)(70586007)(2906002)(70206006)(478600001)(8676002)(36906005)(5660300002)(52536014)(26005)(186003)(356005)(81166007)(55016002)(336012)(83380400001)(82740400003)(9686003)(47076004)(82310400003)(4326008)(54906003)(316002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 09:28:13.7938 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa5ca0e-33a4-431e-a86e-08d853105847
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2424
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



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Monday, September 7, 2020 4:55 PM
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
> On 2020-09-07 09:40, Jianyong Wu wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Saturday, September 5, 2020 7:02 PM
> >> To: Jianyong Wu <Jianyong.Wu@arm.com>
> >> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com;
> >> john.stultz@linaro.org; tglx@linutronix.de; pbonzini@redhat.com;
> >> sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark
> >> Rutland <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> >> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>;
> >> linux-kernel@vger.kernel.org; linux-arm- kernel@lists.infradead.org;
> >> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> >> <Steve.Capper@arm.com>; Justin He <Justin.He@arm.com>; nd
> >> <nd@arm.com>
> >> Subject: Re: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
> >>
> >> On Fri, 04 Sep 2020 10:27:42 +0100,
> >> Jianyong Wu <jianyong.wu@arm.com> wrote:
> >> >
> >> > Currently, there is no mechanism to keep time sync between guest
> >> > and host in arm64 virtualization environment. Time in guest will
> >> > drift compared with host after boot up as they may both use third
> >> > party time sources to correct their time respectively. The time
> >> > deviation will be in order of milliseconds. But in some
> >> > scenarios,like in cloud envirenment, we ask for higher time precision.
> >> >
> >> > kvm ptp clock, which choose the host clock source as a reference
> >> > clock to sync time between guest and host, has been adopted by x86
> >> > which makes the time sync order from milliseconds to nanoseconds.
> >> >
> >> > This patch enables kvm ptp clock for arm64 and improve clock sync
> >> > precison significantly.
> >> >
> >> > Test result comparisons between with kvm ptp clock and without it
> >> > in
> >> > arm64 are as follows. This test derived from the result of command
> >> > 'chronyc sources'. we should take more care of the last sample
> >> > column which shows the offset between the local clock and the
> >> > source at the last
> >> measurement.
> >> >
> >> > no kvm ptp in guest:
> >> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >> >
> >>
> ==========================================================
> >> ==============
> >> > ^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-   21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-   21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-   21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-   21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-   21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-   21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-   21ms
> >> > ^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-   21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-   21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-   21ms
> >> >
> >> > in host:
> >> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >> >
> >>
> ==========================================================
> >> ==============
> >> > ^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-   18ms
> >> > ^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-   18ms
> >> > ^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-   18ms
> >> > ^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-   17ms
> >> > ^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-   17ms
> >> > ^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-   17ms
> >> > ^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-   17ms
> >> > ^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-   17ms
> >> > ^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-   17ms
> >> > ^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-   17ms
> >> >
> >> > The dns1.synet.edu.cn is the network reference clock for guest and
> >> > 120.25.115.20 is the network reference clock for host. we can't get
> >> > the clock error between guest and host directly, but a roughly
> >> > estimated value will be in order of hundreds of us to ms.
> >> >
> >> > with kvm ptp in guest:
> >> > chrony has been disabled in host to remove the disturb by network
> clock.
> >> >
> >> > MS Name/IP address         Stratum Poll Reach LastRx Last sample
> >> >
> >>
> ==========================================================
> >> ==============
> >> > * PHC0                    0   3   377     8     -7ns[   +1ns] +/-    3ns
> >> > * PHC0                    0   3   377     8     +1ns[  +16ns] +/-    3ns
> >> > * PHC0                    0   3   377     6     -4ns[   -0ns] +/-    6ns
> >> > * PHC0                    0   3   377     6     -8ns[  -12ns] +/-    5ns
> >> > * PHC0                    0   3   377     5     +2ns[   +4ns] +/-    4ns
> >> > * PHC0                    0   3   377    13     +2ns[   +4ns] +/-    4ns
> >> > * PHC0                    0   3   377    12     -4ns[   -6ns] +/-    4ns
> >> > * PHC0                    0   3   377    11     -8ns[  -11ns] +/-    6ns
> >> > * PHC0                    0   3   377    10    -14ns[  -20ns] +/-    4ns
> >> > * PHC0                    0   3   377     8     +4ns[   +5ns] +/-    4ns
> >> >
> >> > The PHC0 is the ptp clock which choose the host clock as its source
> >> > clock. So we can see that the clock difference between host and
> >> > guest is in order of ns.
> >> >
> >> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> >> > ---
> >> >  drivers/clocksource/arm_arch_timer.c | 24 +++++++++++++
> >> >  drivers/ptp/Kconfig                  |  2 +-
> >> >  drivers/ptp/ptp_kvm_arm64.c          | 53
> >> ++++++++++++++++++++++++++++
> >> >  3 files changed, 78 insertions(+), 1 deletion(-)  create mode
> >> > 100644 drivers/ptp/ptp_kvm_arm64.c
> >> >
> >> > diff --git a/drivers/clocksource/arm_arch_timer.c
> >> > b/drivers/clocksource/arm_arch_timer.c
> >> > index d55acffb0b90..aaf286e90092 100644
> >> > --- a/drivers/clocksource/arm_arch_timer.c
> >> > +++ b/drivers/clocksource/arm_arch_timer.c
> >> > @@ -1650,3 +1650,27 @@ static int __init
> >> > arch_timer_acpi_init(struct acpi_table_header *table)  }
> >> > TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT,
> >> > arch_timer_acpi_init);  #endif
> >> > +
> >> > +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
> >> > +#include <linux/arm-smccc.h>
> >> > +int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct
> >> timespec64 *ts,
> >> > +			      struct clocksource **cs)
> >> > +{
> >> > +	struct arm_smccc_res hvc_res;
> >> > +	ktime_t ktime;
> >> > +
> >> > +	/* Currently, linux guest will always use the virtual counter */
> >> > +
> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> >> NC_ID,
> >> > +			     ARM_PTP_VIRT_COUNTER, &hvc_res);
> >> > +	if ((long long)(hvc_res.a0) < 0)
> >> > +		return -EOPNOTSUPP;
> >> > +
> >> > +	ktime = (long long)hvc_res.a0;
> >> > +	*ts = ktime_to_timespec64(ktime);
> >> > +	*cycle = (long long)hvc_res.a1;
> >> > +	*cs = &clocksource_counter;
> >> > +
> >> > +	return 0;
> >> > +}
> >> > +EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
> >> > +#endif
> >> > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig index
> >> > 942f72d8151d..127e96f14f89 100644
> >> > --- a/drivers/ptp/Kconfig
> >> > +++ b/drivers/ptp/Kconfig
> >> > @@ -106,7 +106,7 @@ config PTP_1588_CLOCK_PCH  config
> >> > PTP_1588_CLOCK_KVM
> >> >  	tristate "KVM virtual PTP clock"
> >> >  	depends on PTP_1588_CLOCK
> >> > -	depends on KVM_GUEST && X86
> >> > +	depends on KVM_GUEST && X86 || ARM64 && ARM_ARCH_TIMER
> >> &&
> >> > +ARM_PSCI_FW
> >> >  	default y
> >> >  	help
> >> >  	  This driver adds support for using kvm infrastructure as a PTP
> >> > diff --git a/drivers/ptp/ptp_kvm_arm64.c
> >> > b/drivers/ptp/ptp_kvm_arm64.c new file mode 100644 index
> >> > 000000000000..961abed93dfd
> >> > --- /dev/null
> >> > +++ b/drivers/ptp/ptp_kvm_arm64.c
> >> > @@ -0,0 +1,53 @@
> >> > +// SPDX-License-Identifier: GPL-2.0-only
> >> > +/*
> >> > + *  Virtual PTP 1588 clock for use with KVM guests
> >> > + *  Copyright (C) 2019 ARM Ltd.
> >> > + *  All Rights Reserved
> >> > + */
> >> > +
> >> > +#include <linux/kernel.h>
> >> > +#include <linux/err.h>
> >> > +#include <asm/hypervisor.h>
> >> > +#include <linux/module.h>
> >> > +#include <linux/psci.h>
> >> > +#include <linux/arm-smccc.h>
> >> > +#include <linux/timecounter.h>
> >> > +#include <linux/sched/clock.h>
> >> > +#include <asm/arch_timer.h>
> >> > +
> >> > +int kvm_arch_ptp_init(void)
> >> > +{
> >> > +	struct arm_smccc_res hvc_res;
> >> > +
> >> > +
> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATUR
> >> ES_FUNC_ID,
> >> > +			     &hvc_res);
> >> > +	if (!(hvc_res.a0 | BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
> >> > +		return -EOPNOTSUPP;
> >> > +
> >> > +	return 0;
> >>
> >> What happens if the
> >> ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID function isn't
> implemented
> >> (on an old kernel or a non-KVM hypervisor)? The expected behaviour is
> >> that a0 will contain SMCCC_RET_NOT_SUPPORTED, which is -1.
> >> The result is that this function always returns "supported". Not an
> >> acceptable behaviour.
> >>
> > Oh!  it's really a stupid mistake, should be "&" not "|".
> 
> But even then. (-1 & whatever) is always true.

Yeah, what about checking if a0 is non-negative first? Like:
if (hvc_res.a0 < 0 || !(hvc_res.a0 & BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
	return -EOPNOTSUPP;

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
