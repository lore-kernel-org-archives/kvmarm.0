Return-Path: <SRS0=KLQI=YK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE59FECE58E
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 10:29:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D2882082C
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 10:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="py/zl2cJ";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="py/zl2cJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D2882082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 241264AA51;
	Thu, 17 Oct 2019 06:29:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p42b9kxD07oG; Thu, 17 Oct 2019 06:29:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4BD04AA55;
	Thu, 17 Oct 2019 06:29:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FCCC4A9A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 23:52:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CMU83BN9tpYm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Oct 2019 23:52:41 -0400 (EDT)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr150053.outbound.protection.outlook.com [40.107.15.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F39B44A99D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 23:52:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Hl8etiZDmKfpa+NAQsVrHee7fMzkNj8HZZVi7E0Lzk=;
 b=py/zl2cJEdDzmik7xGHO3Q1V1crQi/AnEXqChSEm/gk+msEq/L8pZfLCpWmqbPW/Enr4v4QCTin9iAHHm6Y66pyfZ2uQKX7g1ltbAvO4/YPOtaK1vjv0oABSA6wcxhzn/b05yz/20ftWcXderaftBfEipXvKAVkvDtGfCMbTuzs=
Received: from DB7PR08CA0044.eurprd08.prod.outlook.com (2603:10a6:10:26::21)
 by DB7PR08MB3275.eurprd08.prod.outlook.com (2603:10a6:5:24::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.19; Wed, 16 Oct
 2019 03:52:37 +0000
Received: from VE1EUR03FT050.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::200) by DB7PR08CA0044.outlook.office365.com
 (2603:10a6:10:26::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.17 via Frontend
 Transport; Wed, 16 Oct 2019 03:52:37 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT050.mail.protection.outlook.com (10.152.19.209) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 16 Oct 2019 03:52:36 +0000
Received: ("Tessian outbound 927f2cdd66cc:v33");
 Wed, 16 Oct 2019 03:52:26 +0000
X-CR-MTA-TID: 64aa7808
Received: from c7fb7a3fb8cd.2 (ip-172-16-0-2.eu-west-1.compute.internal
 [104.47.14.58]) by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 3ECE13BA-B552-43D5-A38C-55A8FDE17978.1; 
 Wed, 16 Oct 2019 03:52:21 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c7fb7a3fb8cd.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 16 Oct 2019 03:52:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0TbVXG8sfPJFObAAbieW+na4zDrPyTdNZbR3lSoTBEzZqCp8Aue1sNRPP7U+czJsqHYEsrZpdm3R3YEs5X/vSVe0RrbWdpsbTY35UyQaRZa0izDkU1U+84OSAZ+UtmG7rikPnDUCbFyXGHOoqb8eFzLWt8/ul+DbM6rkfnh9CINupMEyZL5Aq2owAuLSXsKX5uLqE1cErI+vuABxcutA0L5R0H8FG4kiYoxu2noPtvmsDn519nxMuTflFZGSRoCGIwk4eZh73UBb87VwxSwuCFMLKI2HoRjYqfG7+zuHYMlERZsPjGmYpH7jVQFlDBjERECo5ntGmGI1FJbcDDn1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Hl8etiZDmKfpa+NAQsVrHee7fMzkNj8HZZVi7E0Lzk=;
 b=A8ZWRWC0QX6SmkytpCb14kAq5BZszqD1iQ5lhnWaIx79MiCsDhk2HNWjptwypvt472jaL+wR4ufl8OKU7e6RXCCiv/Dv3TIyt9P+Q7lNgFDUU7Ac2k1BLVPxxGYjE/ufU2WdmshKEoZkak9ljkROf/D5LKFMU//x8tTyHKft/kuVuAtumYFdvK0V85GdL1ys5rWfwd4ElQksbDde7xMolAFWMM6XmF4N7cnPRICotujQyIwySw5oYs7cOipZZzXrj/dDgbXSAIjt2YscfBTCXFiENAy9fPqFAo9rIbqXJJqxf8l4RD7mR1hMHXKm5J2waZkCjMxq1cNPO8zf5c40YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Hl8etiZDmKfpa+NAQsVrHee7fMzkNj8HZZVi7E0Lzk=;
 b=py/zl2cJEdDzmik7xGHO3Q1V1crQi/AnEXqChSEm/gk+msEq/L8pZfLCpWmqbPW/Enr4v4QCTin9iAHHm6Y66pyfZ2uQKX7g1ltbAvO4/YPOtaK1vjv0oABSA6wcxhzn/b05yz/20ftWcXderaftBfEipXvKAVkvDtGfCMbTuzs=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2122.eurprd08.prod.outlook.com (10.168.150.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Wed, 16 Oct 2019 03:52:17 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 03:52:17 +0000
From: "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "sean.j.christopherson@intel.com"
 <sean.j.christopherson@intel.com>, "maz@kernel.org" <maz@kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>, Mark Rutland
 <Mark.Rutland@arm.com>, "will@kernel.org" <will@kernel.org>, Suzuki Poulose
 <Suzuki.Poulose@arm.com>
Subject: RE: [PATCH v5 5/6] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [PATCH v5 5/6] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHVg0Y6A4wUAbusSUOkn5f/2HpSwadb56wAgAC7jVA=
Date: Wed, 16 Oct 2019 03:52:17 +0000
Message-ID: <HE1PR0801MB167654440A67AF072E28FFFDF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-6-jianyong.wu@arm.com>
 <da62c327-9402-9a5c-d694-c1a4378822e0@redhat.com>
In-Reply-To: <da62c327-9402-9a5c-d694-c1a4378822e0@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: a44c36d3-bcd2-4cf3-924a-6fc36127fde1.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: e5474daa-a829-487a-dbad-08d751ec4857
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2122:|HE1PR0801MB2122:|DB7PR08MB3275:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB3275F7D666D78F3848CE3824F4920@DB7PR08MB3275.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:2657;OLM:2657;
x-forefront-prvs: 0192E812EC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(13464003)(199004)(189003)(229853002)(76176011)(256004)(7696005)(2906002)(8936002)(33656002)(9686003)(316002)(478600001)(53546011)(6506007)(3846002)(6116002)(8676002)(55016002)(6436002)(81166006)(102836004)(4326008)(55236004)(81156014)(6246003)(11346002)(52536014)(446003)(476003)(25786009)(486006)(74316002)(99286004)(86362001)(186003)(26005)(305945005)(7416002)(71200400001)(71190400001)(54906003)(6636002)(110136005)(7736002)(2201001)(5660300002)(14454004)(76116006)(66446008)(2501003)(66946007)(66476007)(64756008)(66556008)(66066001)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB2122;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: aU1JMWWTxT808qT8BjGNWrwfRgUS/bk5rOoy5/srOXs7T35IXOOENSrj+VTBeFgu/tFr/500a3xdwgQvMlVOvmWR0bwvWAlOwpBza+mEwPv66bxxzVuloARo7dE1HcO9H2pWOjymuONAi3aefbV7JCkUpT21KI7mJXqbyk99ZzLnz7PG1sirYzGMWm06CxOddhUQQje8mzH6aS3aZ0ZDolVw3TVyDVPnzuEeX98W4YJUCGGz1p3stR8Bpd7otCVKYyVhHpc9OkqvLMF9ZenFRz789/k0ktLYLCbG87VoKD2133YHGfT3qhVV4Ck0Gbm9awI/AplVNsIZ2jfWxYcjAD3Rl25KkFMpi82qhiqAXYwHBm3FHJ64p6odh7j0wHJcENTumfX13sI1prtYefdrR2+d8S/1I7u0xKvOd9U7+WM=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2122
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(39860400002)(396003)(136003)(376002)(346002)(199004)(189003)(13464003)(26005)(102836004)(6116002)(3846002)(5660300002)(6636002)(53546011)(6506007)(50466002)(2486003)(23676004)(76176011)(7696005)(186003)(7736002)(126002)(486006)(476003)(4326008)(81156014)(8676002)(25786009)(86362001)(478600001)(26826003)(2201001)(33656002)(76130400001)(74316002)(70206006)(70586007)(305945005)(81166006)(2501003)(66066001)(356004)(47776003)(52536014)(55016002)(316002)(36906005)(99286004)(22756006)(63350400001)(6246003)(436003)(229853002)(336012)(2906002)(110136005)(11346002)(14454004)(446003)(54906003)(9686003)(8936002)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:DB7PR08MB3275;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:TempError; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; A:1; MX:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 8f059bff-4640-4875-c0a8-08d751ec3d36
NoDisclaimer: True
X-Forefront-PRVS: 0192E812EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHmnIIlhTAzjQlucYhXXRYTJL167sDA0sPcjHy+hprBa3eIgYErtvUKSJS0DJJSWTZtnZ4U8zcK8F6xT5k54l+wYieOlfNr3kURsWyZbooa44eCTjqNaaoWZsxQga7mFRMCbz4bwWJofsC4DSCm93NIOazSwr/BfnBinvfIXCEbP07QD9Rl+WFEzba+amj/GZ2uEKPLXwq/0h/8fnKWjIkKkxSlTP3/52rx9DmZo2GC6SXUqCfqLdGKCmq97mJAn97WfQYCnjXwcwX+uM1IuuZRnD9hGD+SjfwcdNhxSx0FabpHP/Tq9G0UP9lcSc4VcRyIq2g3bYjuxy/M532IlKqD1YoIBjtlgdSHOM7ph+61adfScsaQFt455wahQnQk5Cb/qtx5qK3IH5Azc4stcxROlGdj9Ox9kuFVHE9xThsE=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2019 03:52:36.3012 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5474daa-a829-487a-dbad-08d751ec4857
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3275
X-Mailman-Approved-At: Thu, 17 Oct 2019 06:29:20 -0400
Cc: "Justin He \(Arm Technology China\)" <Justin.He@arm.com>,
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

Hi Paolo,

> -----Original Message-----
> From: Paolo Bonzini <pbonzini@redhat.com>
> Sent: Wednesday, October 16, 2019 12:39 AM
> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>;
> netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; sean.j.christopherson@intel.com; maz@kernel.org;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v5 5/6] ptp: arm64: Enable ptp_kvm for arm64
> 
> On 15/10/19 12:48, Jianyong Wu wrote:
> > +int kvm_arch_ptp_get_clock_generic(struct timespec64 *ts,
> > +				   struct arm_smccc_res *hvc_res) {
> > +	u64 ns;
> > +	ktime_t ktime_overall;
> > +
> > +
> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> NC_ID,
> > +				  hvc_res);
> > +	if ((long)(hvc_res->a0) < 0)
> > +		return -EOPNOTSUPP;
> > +
> > +	ktime_overall = hvc_res->a0 << 32 | hvc_res->a1;
> > +	*ts = ktime_to_timespec64(ktime_overall);
> > +
> > +	return 0;
> > +}
> > +
> 
> This seems wrong, who uses kvm_arch_ptp_get_clock_fn?
> 
This func used only by kvm_arch_ptp_get_clock and nothing to do with kvm_arch_ptp_get_clock_fn.
Also it can be merged into kvm_arch_ptp_get_clock.

> Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
