Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8593CC63777
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 05:37:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D861220719
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 05:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="M7f8z1xV";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="M7f8z1xV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D861220719
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CBC84BC87;
	Tue, 24 Nov 2020 00:37:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rNgzhURDKeCD; Tue, 24 Nov 2020 00:37:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DA5F4BC60;
	Tue, 24 Nov 2020 00:37:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 478254BC40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 00:37:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gvMDqboolncV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 00:37:38 -0500 (EST)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 025C64B8A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 00:37:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPcSd9et9D9kYd1nzxxQUUu7Rndy/ovi5rtgozcAL2A=;
 b=M7f8z1xVJuvm5gdEDTijmTvnb2B7WoT/dwQykeAdNuqtVtrNle21Iwfai2nx+J/f1OsENm1pqtrq8vGz9xBMjy0nJa2CPxmnBGVo/YWSAVdSwIyrOOWrBRQsS7dDwW+9JXSw9L5Jkf4WbdkDONbIyLGBU6LoNXmhvWro85TG/m4=
Received: from AM6P195CA0048.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::25)
 by VE1PR08MB4655.eurprd08.prod.outlook.com (2603:10a6:802:b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.29; Tue, 24 Nov
 2020 05:37:33 +0000
Received: from VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:87:cafe::3b) by AM6P195CA0048.outlook.office365.com
 (2603:10a6:209:87::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Tue, 24 Nov 2020 05:37:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT041.mail.protection.outlook.com (10.152.19.163) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 05:37:30 +0000
Received: ("Tessian outbound e0cdfd2b0406:v71");
 Tue, 24 Nov 2020 05:37:30 +0000
X-CR-MTA-TID: 64aa7808
Received: from 8bbd5a06462b.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 6DCDF244-920A-45C3-8A2D-E32A8D7B0847.1; 
 Tue, 24 Nov 2020 05:37:25 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8bbd5a06462b.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 24 Nov 2020 05:37:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gA/ZovE8sdCPmqbNMWtHS+5WQsiC/fqSIokjGD23dWzBMHmLutnpoKnNOYa8or1N1XXUuUQkHEMVvxldtK/NQsdxXA1pXMjDMhhgbAlBeV7vgl26RFupyom/91UyuH1Rs5S1DJ0aMl9QSdQRHgZwklbx2F7GcK6gt907HQ4OHkRDRLIFFu5MadVVtGewsfWCp70x76E9/qDTwknk7NsdCtplBLWN7Gr1++fmQlM4bwKqdez6eFATr8Lnyyy7H8TE+/u/TfUcGNRTXyCnSIhoeDxSvvE9Lj1l0/VgJ5lqzlDEIuGDP5NEiuMddXIQP50iYc5LtU5zJ7758NMICWP+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPcSd9et9D9kYd1nzxxQUUu7Rndy/ovi5rtgozcAL2A=;
 b=ZOXhRHbgcvVDTucDniBDqjlSxcOpRxkOUmmxw7fwi6NjGOlugoZLfzQrVoG91dij3gS/3VhCs8MoCFbL+w+ZLyXvnALuMA9Q0XCRF3WzlC32Zt6yemd5GKQ8+2VTX+4RxpGdb0lMrJxHbHnvE8U3geThB9RaPfW/xuNer7AQK4o0pkEp4fVtS1Tt1LlfsKSchpJHVwbbBJBqpmRNA+k1sXEtiVEHVf9jK5MvRVMTJYIea7NX+pUzxnMwA/xhznqVI/lilguYj5GdgXctSn5dcc0YW5PyP06V6DwB8aY2yy+UK1sRfBSTCGQSeycA8PtPpHZdR3m83mA93XQhkjCahQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPcSd9et9D9kYd1nzxxQUUu7Rndy/ovi5rtgozcAL2A=;
 b=M7f8z1xVJuvm5gdEDTijmTvnb2B7WoT/dwQykeAdNuqtVtrNle21Iwfai2nx+J/f1OsENm1pqtrq8vGz9xBMjy0nJa2CPxmnBGVo/YWSAVdSwIyrOOWrBRQsS7dDwW+9JXSw9L5Jkf4WbdkDONbIyLGBU6LoNXmhvWro85TG/m4=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB1881.eurprd08.prod.outlook.com (2603:10a6:3:55::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Tue, 24 Nov
 2020 05:37:22 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 05:37:22 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
Thread-Topic: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
Thread-Index: AQHWt/M8TW7h8ytFwE22PYJVJt7LOKnVnLWAgAE22MA=
Date: Tue, 24 Nov 2020 05:37:21 +0000
Message-ID: <HE1PR0802MB2555C5D09EA2BF0BA369BE37F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-8-jianyong.wu@arm.com>
 <7bd3a66253ca4b7adbe2294eb598a23f@kernel.org>
In-Reply-To: <7bd3a66253ca4b7adbe2294eb598a23f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6326F7F8614FA349943B6F4E755C265E.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5b6336a-77e6-47b2-daf9-08d8903b0965
x-ms-traffictypediagnostic: HE1PR0801MB1881:|VE1PR08MB4655:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB46552EB6EF968F60050B1F5CF4FB0@VE1PR08MB4655.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: QmrcusFpBuuZXZXc6oSVZp0dWrP3PB7Uvh+uxCvHIMdVTfW9JJmL3Lr3xRiu+RFG+7iyavk/9+KfiRB1o+Orm+WkKsITMQsWNushcTzC+6Oo1nzDPL0lBBF2ahaUlqpxiJi8gSupTSpSYzzp/PQNmulS2wwuxOiDIPfR8kqNqvOH9G9GkRuDCGjRnP/heJlQCvkh0foWZUUPy3ptcNJ+ihSoOe7qVrP4BBNRS2IpSoPWr0ejCPs6aw+MLzKoaq+gOvbSZUaAlU3fxeZWqfC3mgEWXqmrHDTJOQDXXeEURo6zXSqbZI8ssXjy7XGeiaen
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(76116006)(66476007)(52536014)(186003)(5660300002)(26005)(66946007)(55016002)(86362001)(4326008)(4001150100001)(9686003)(316002)(7416002)(33656002)(6916009)(54906003)(2906002)(66446008)(66556008)(478600001)(6506007)(7696005)(8936002)(83380400001)(53546011)(8676002)(71200400001)(64756008);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: 44nlNso5msO92xsJVDqXUoGnKJVWV7XVa1gbDKAioHMEBQZ+nNYAmPrTIacwf1j5d1NdHaHWMZyIguKlrckUygulnwRo4aIJWQ5dEuJGnm5eHssShiPbveL47Xlm9YhutdG6qNLxMO5fBgGnXfHmi0LYLltDKQeBKSwSWB8+I0K77RZj0RIGvOcSbSe8kOqRugyfuLcxnFmoVMlV4+185QGXzqIA4+Jfup5nwqQKhHRg130o8cUUVMW6eQAHpWEdm1TQozO3VDFpDr4Yw/dE83en2Lrt/Pp3DDnVucZbEPBRjoWJqSI6Bj6T73g1oB96effW2LZMT5iL4oQx4dqFPPAvaamCFVkY/5hxcMzZ4bEbBS1Oky8v3zD5yhECkrbRmlGbOUnbwwN+QnpzixvWAJvccI1v4TLNFUvxpeC3c2Sq+zJduXz64uTeRhG06CDqGbcCoiAJHNEv+Tvv97GotwKqygxZkcwGAP1D72pqSPXgMHtGIbfGII7Pa5pPnn9++GVeMkkAs9e2ahKPwts44k4leTvdG8qPAJP3e9u9PYLmbDiEESbGAQrryEJaUMq7Y6ZoYI0zORhLRS1V45gk0Worn6JqLtYFFw2BomJ76zlV53zctKqi2A0zxcFiPeZPuE3EFlCN7UaQSy+FBMnBSLo3Op1P2iAcBKI3OX7Pnx48YUscju87liaveUZqCn0qoqM5n0ZKsNnfHykZBL9kMXwwB3fjGr1GJWWlR2q/BBVZGqMoZtiippOJGKTFGKtsfmZDVsOEshsV0L+Y5TAXkF1/9DVvPK/NtJa7pqyoX4Oh+qCgv9VwcwKcoJf+7NPk0ztzc1jPCjejHAA0843s3YTKxofmZT+kD0J5DkFlwIdW6UnmeHx5yxvv2gzllBdnykurRYF+q1ngQNTV4AWaPQ==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1881
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: b554fa0d-892c-41f1-80dd-08d8903b0438
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1sufHIIv5F5VozV+ETLf5czMfgyh94kkc5NlMO9RT0HfdFdvNkeI640+3uO+Qeyp2Unzobhka5kZMsiGKiaQX+GvmxWh6AFg9/yTWDjIDM4Vo3J3igI7xkUSfxhv/Vpbxr9+tuyOBi6HKZdSwZVYu2s3eKqdRtGy0/H2beGesa4wRew0CI9aoL0Yy+brNu7JQLXk7vg6vlqxcUPD8POh4JfYpZa/d/QYJeSEyIw+LeZajlcTMKLn5boqasvB4s7qoCfXBoQNyalJgxs/mJtXPLtNgvrGjoDKYGAsw3L9RUjE7BMBa4yT830TJEdN6kZOu/CBcKoiZVSw682lLeSBmRp9ZvcnsGFD0ft/rB07v7l+BcbLVS7s5WHXlesm7ffcQh2oLAmkgPbBCGc6heOKqg==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(46966005)(8676002)(55016002)(5660300002)(86362001)(186003)(83380400001)(53546011)(7696005)(33656002)(6862004)(478600001)(4326008)(82310400003)(336012)(6506007)(81166007)(54906003)(316002)(4001150100001)(356005)(52536014)(2906002)(8936002)(47076004)(70206006)(70586007)(26005)(9686003)(82740400003);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 05:37:30.6186 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b6336a-77e6-47b2-daf9-08d8903b0965
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4655
Cc: Justin He <Justin.He@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Steven Price <Steven.Price@arm.com>, Andre Przywara <Andre.Przywara@arm.com>,
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
> Sent: Monday, November 23, 2020 6:49 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Andre
> Przywara <Andre.Przywara@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for
> arm/arm64
> 
> On 2020-11-11 06:22, Jianyong Wu wrote:
> > Currently, there is no mechanism to keep time sync between guest and
> > host in arm/arm64 virtualization environment. Time in guest will drift
> > compared with host after boot up as they may both use third party time
> > sources to correct their time respectively. The time deviation will be
> > in order of milliseconds. But in some scenarios,like in cloud
> > envirenment, we ask
> 
> environment
> 
OK

> > for higher time precision.
> >
> > kvm ptp clock, which chooses the host clock source as a reference
> > clock to sync time between guest and host, has been adopted by x86
> > which takes the time sync order from milliseconds to nanoseconds.
> >
> > This patch enables kvm ptp clock for arm/arm64 and improves clock sync
> > precison
> 
> precision
>
OK
 
> > significantly.
> >
> > Test result comparisons between with kvm ptp clock and without it in
> > arm/arm64
> > are as follows. This test derived from the result of command 'chronyc
> > sources'. we should take more care of the last sample column which
> > shows the offset between the local clock and the source at the last
> > measurement.
> >
> > no kvm ptp in guest:
> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >
> ==========================================================
> ==============
> > ^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-
> > 21ms
> >
> > in host:
> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >
> ==========================================================
> ==============
> > ^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-
> > 18ms
> > ^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-
> > 18ms
> > ^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-
> > 18ms
> > ^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-
> > 17ms
> >
> > The dns1.synet.edu.cn is the network reference clock for guest and
> > 120.25.115.20 is the network reference clock for host. we can't get
> > the clock error between guest and host directly, but a roughly
> > estimated value will be in order of hundreds of us to ms.
> >
> > with kvm ptp in guest:
> > chrony has been disabled in host to remove the disturb by network
> > clock.
> >
> > MS Name/IP address         Stratum Poll Reach LastRx Last sample
> >
> ==========================================================
> ==============
> > * PHC0                    0   3   377     8     -7ns[   +1ns] +/-
> > 3ns
> > * PHC0                    0   3   377     8     +1ns[  +16ns] +/-
> > 3ns
> > * PHC0                    0   3   377     6     -4ns[   -0ns] +/-
> > 6ns
> > * PHC0                    0   3   377     6     -8ns[  -12ns] +/-
> > 5ns
> > * PHC0                    0   3   377     5     +2ns[   +4ns] +/-
> > 4ns
> > * PHC0                    0   3   377    13     +2ns[   +4ns] +/-
> > 4ns
> > * PHC0                    0   3   377    12     -4ns[   -6ns] +/-
> > 4ns
> > * PHC0                    0   3   377    11     -8ns[  -11ns] +/-
> > 6ns
> > * PHC0                    0   3   377    10    -14ns[  -20ns] +/-
> > 4ns
> > * PHC0                    0   3   377     8     +4ns[   +5ns] +/-
> > 4ns
> >
> > The PHC0 is the ptp clock which choose the host clock as its source
> > clock. So we can see that the clock difference between host and guest
> > is in order of ns.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  drivers/clocksource/arm_arch_timer.c | 28 ++++++++++++++++++
> >  drivers/ptp/Kconfig                  |  2 +-
> >  drivers/ptp/Makefile                 |  1 +
> >  drivers/ptp/ptp_kvm_arm.c            | 44
> ++++++++++++++++++++++++++++
> >  4 files changed, 74 insertions(+), 1 deletion(-)  create mode 100644
> > drivers/ptp/ptp_kvm_arm.c
> >
> > diff --git a/drivers/clocksource/arm_arch_timer.c
> > b/drivers/clocksource/arm_arch_timer.c
> > index d55acffb0b90..b33c5a663d30 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/sched/clock.h>
> >  #include <linux/sched_clock.h>
> >  #include <linux/acpi.h>
> > +#include <linux/arm-smccc.h>
> >
> >  #include <asm/arch_timer.h>
> >  #include <asm/virt.h>
> > @@ -1650,3 +1651,30 @@ static int __init arch_timer_acpi_init(struct
> > acpi_table_header *table)  }  TIMER_ACPI_DECLARE(arch_timer,
> > ACPI_SIG_GTDT, arch_timer_acpi_init);  #endif
> > +
> > +int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *ts,
> > +			      struct clocksource **cs)
> > +{
> > +	struct arm_smccc_res hvc_res;
> > +	ktime_t ktime;
> > +	u32 ptp_counter;
> > +
> > +	if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
> > +		ptp_counter = ARM_PTP_VIRT_COUNTER;
> > +	else
> > +		ptp_counter = ARM_PTP_PHY_COUNTER;
> > +
> > +
> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> NC_ID,
> > +			     ptp_counter, &hvc_res);
> > +
> > +	if ((int)(hvc_res.a0) < 0)
> > +		return -EOPNOTSUPP;
> > +
> > +	ktime = (u64)hvc_res.a0 << 32 | hvc_res.a1;
> > +	*ts = ktime_to_timespec64(ktime);
> > +	*cycle = (u64)hvc_res.a2 << 32 | hvc_res.a3;
> 
> Endianness.
> 
> > +	*cs = &clocksource_counter;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
> > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig index
> > 942f72d8151d..677c7f696b70 100644
> > --- a/drivers/ptp/Kconfig
> > +++ b/drivers/ptp/Kconfig
> > @@ -106,7 +106,7 @@ config PTP_1588_CLOCK_PCH  config
> > PTP_1588_CLOCK_KVM
> >  	tristate "KVM virtual PTP clock"
> >  	depends on PTP_1588_CLOCK
> > -	depends on KVM_GUEST && X86
> > +	depends on KVM_GUEST && X86 ||
> (HAVE_ARM_SMCCC_DISCOVERY &&
> > ARM_ARCH_TIMER)
> >  	default y
> >  	help
> >  	  This driver adds support for using kvm infrastructure as a PTP
> > diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile index
> > 699a4e4d19c2..9fa5ede44b2b 100644
> > --- a/drivers/ptp/Makefile
> > +++ b/drivers/ptp/Makefile
> > @@ -5,6 +5,7 @@
> >
> >  ptp-y					:= ptp_clock.o ptp_chardev.o
> ptp_sysfs.o
> >  ptp_kvm-$(CONFIG_X86)			:= ptp_kvm_x86.o
> ptp_kvm_common.o
> > +ptp_kvm-$(CONFIG_HAVE_ARM_SMCCC)	:= ptp_kvm_arm.o
> ptp_kvm_common.o
> >  obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
> >  obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
> >  obj-$(CONFIG_PTP_1588_CLOCK_INES)	+= ptp_ines.o
> > diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c new
> > file mode 100644 index 000000000000..2212827c0384
> > --- /dev/null
> > +++ b/drivers/ptp/ptp_kvm_arm.c
> > @@ -0,0 +1,44 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + *  Virtual PTP 1588 clock for use with KVM guests
> > + *  Copyright (C) 2019 ARM Ltd.
> > + *  All Rights Reserved
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/err.h>
> > +#include <asm/hypervisor.h>
> > +#include <linux/module.h>
> > +#include <linux/psci.h>
> > +#include <linux/arm-smccc.h>
> > +#include <linux/timecounter.h>
> > +#include <linux/sched/clock.h>
> > +#include <asm/arch_timer.h>
> > +#include <asm/hypervisor.h>
> > +
> > +int kvm_arch_ptp_init(void)
> > +{
> > +	int ret;
> > +
> > +	ret =
> kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_KVM_PTP);
> > +	if (ret <= 0)
> > +		return -EOPNOTSUPP;
> > +
> > +	return 0;
> > +}
> > +
> > +int kvm_arch_ptp_get_clock(struct timespec64 *ts) {
> > +	ktime_t ktime;
> > +	struct arm_smccc_res hvc_res;
> > +
> > +
> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> NC_ID,
> > +			     ARM_PTP_NONE_COUNTER, &hvc_res);
> 
> I really don't see the need to use a non-architectural counter ID.
> Using the virtual counter ID should just be fine, and shouldn't lead to any
> issue.
> 

> Am I missing something?

In this function, no counter data is needed. If virtual counter ID is used here, user may be confused with why we get virtual counter
data and do nothing with it. So I explicitly add a new "NONE" counter ID to make it clear.

WDYT?

Thanks
Jianyong
> 
> > +	if ((int)(hvc_res.a0) < 0)
> > +		return -EOPNOTSUPP;
> > +
> > +	ktime = (u64)hvc_res.a0 << 32 | hvc_res.a1;
> 
> Endianness.
> 
> > +	*ts = ktime_to_timespec64(ktime);
> > +
> > +	return 0;
> > +}
> 
> Thanks,
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
