Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16357C433E2
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 10:11:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D16120C09
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 10:11:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3vyRu4Lr";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3vyRu4Lr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D16120C09
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B3104B552;
	Mon,  7 Sep 2020 06:11:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4XSXHOQMO2EB; Mon,  7 Sep 2020 06:11:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C70E4B5C3;
	Mon,  7 Sep 2020 06:11:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD72E4B5BF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 06:11:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G+OhgY0woSvt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 06:11:44 -0400 (EDT)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130089.outbound.protection.outlook.com [40.107.13.89])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97E734B552
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 06:11:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vvzw5DhaKrGwAtB8KKuKhk66j1wAgDbGFCqeFtR93TA=;
 b=3vyRu4LrPoXZrJXlpJmbtJPVyXa0+B3ovZ586c+D21aXpC0aqNfoJd2AI3d5hIXwzduvr+TL6fCwqNCgGcfqlZ6JtlKh5x6Hh2NaGBZXShKmL4q02GxpZpDoKtCvZEivTcoTqi9mHApcuqBNkeIwpFlHv52LgCuiy5IqufSGusg=
Received: from AM6P193CA0079.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::20)
 by AM0PR08MB4305.eurprd08.prod.outlook.com (2603:10a6:208:140::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Mon, 7 Sep
 2020 10:11:41 +0000
Received: from VE1EUR03FT027.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:88:cafe::4d) by AM6P193CA0079.outlook.office365.com
 (2603:10a6:209:88::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend
 Transport; Mon, 7 Sep 2020 10:11:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT027.mail.protection.outlook.com (10.152.18.154) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:11:41 +0000
Received: ("Tessian outbound e8cdb8c6f386:v64");
 Mon, 07 Sep 2020 10:11:40 +0000
X-CR-MTA-TID: 64aa7808
Received: from 8898891310c6.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 DFF1148A-ECE5-4434-AB08-59DBF40F3874.1; 
 Mon, 07 Sep 2020 10:11:35 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8898891310c6.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 07 Sep 2020 10:11:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gb4ZrTmuDaPW7xZoQmi2zDtIEiOTQggZXebilw0U1SvsaJ/HHH8F1e6GrMguokwPdJqJK+/zEwvudUU66/QyulvmqBosK7bsxqJ9zbT5aC+OOTv9Ybrf4zFOnLcQ2jpYrFpgpSMoK/iwFdbhTxB4gMK1Q/QQL7wpgo5PzaGqR44KGcM4686aP0VuE6jLYHNbNeofbWV03gKqVEZeadyWWButfld5F01z+72dtUYruLJLYTuXeLla+ZmzzcssO27YrHvNqBALk5x8mBqEUrno7YVX4EUn4Yu3dNRJ8ipkTukMRQ3XvJ3oOvA0icI1POQdYuUbG48JiHdXeIDshaX8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vvzw5DhaKrGwAtB8KKuKhk66j1wAgDbGFCqeFtR93TA=;
 b=HNG0r5rjPai/ui7ULeKtwnvKpRza9o9HpGL+oEq3iBGBYcI9kCsDUIOk27OIpH3CXoNm63pW4Rd4LFy88dVCQwaFD47tEmsNE4o/oy6vtYAz893o2ZNah5pU0GNDsEcRq4q5QI4yBkKjvwHkwZltcyZnmo4eu+LHghV/W0aZ8XCK7JIDqUj1Vb9EKVMym0qWyjWylhT027WzHXVV+1Um2uttKCWinfpaSQeJAuIXR8jyb1f3rCMiXOhTwCWFueYfi7i8WU1gewZvpfyMNj0y5qtl/Kj1O3V9iEL06SHHhW48zwnPDCK9sYe33nTD0TSQXz1PpipLybeydRPOiS79pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vvzw5DhaKrGwAtB8KKuKhk66j1wAgDbGFCqeFtR93TA=;
 b=3vyRu4LrPoXZrJXlpJmbtJPVyXa0+B3ovZ586c+D21aXpC0aqNfoJd2AI3d5hIXwzduvr+TL6fCwqNCgGcfqlZ6JtlKh5x6Hh2NaGBZXShKmL4q02GxpZpDoKtCvZEivTcoTqi9mHApcuqBNkeIwpFlHv52LgCuiy5IqufSGusg=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2556.eurprd08.prod.outlook.com (2603:10a6:3:e1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:11:32 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00%5]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:11:32 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHWgp4Q48WtGxJp4kuFSJTL6o01LqlZ4qMAgAL3/tCAAAlCgIAABDCQgAAKXICAAAXbMA==
Date: Mon, 7 Sep 2020 10:11:31 +0000
Message-ID: <HE1PR0802MB25551E16B77F968412E2D456F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
 <20200904092744.167655-9-jianyong.wu@arm.com> <874kocmqqx.wl-maz@kernel.org>
 <HE1PR0802MB2555CC56351616836A95FB19F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <366387fa507f9c5d5044549cea958ce1@kernel.org>
 <HE1PR0802MB25551446DC85DB3684D09211F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <67f3381467d02c8d3f25682cd99898e9@kernel.org>
In-Reply-To: <67f3381467d02c8d3f25682cd99898e9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: B5C9977602E0B848B1A8C8F7B329373C.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: da0678da-6d36-40a8-a192-08d853166a57
x-ms-traffictypediagnostic: HE1PR0802MB2556:|AM0PR08MB4305:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB4305B3496BC51E5AE247D627F4280@AM0PR08MB4305.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:97;OLM:97;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: O1Wy0JjDZD1moM4VTdp+QMXxhuOoV/dzGKt2Eue7xzwvnAGesOGlpOuToQ9L5rwaElVfYJKf9+JBtGhMHN1V9r4O3Q4vcz5bXvmy98iKHlmzH/zSo7ibQfRmVGbPtI96aJDRwma4Wt/HQQJ1XURC2Q0GK4tBszv+ZeGy6scWuGtM4eOLin2L00FoNYtV97K0HnlAmHpBs7ISIdxVZq+OOvVBq1r/5IOSUuOCgsem/vxutauuKbeYfBHPpv6ka9yzU3ZhjULf28OnN06okrH9RjA0+2qcAhZFvAQ19dNNpA+sXFYVF7vC3YWdpFVW6oHh6lmVFKZno1kRkvXaVNOJEQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(86362001)(66446008)(478600001)(64756008)(66556008)(66946007)(66476007)(52536014)(76116006)(7416002)(6916009)(53546011)(83380400001)(71200400001)(6506007)(5660300002)(8676002)(316002)(54906003)(8936002)(4326008)(55016002)(33656002)(9686003)(186003)(26005)(7696005)(2906002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: vP2VINxfpSa+OUVIIK+3tV7saqH8rWvKNYVJ298y8fKZv+fju6VHrxehV26C1DrNHbPTgBkYGvOps6pNI4MUxWFW7ZnigG3uahJI5LZBTuZpLeLwZVdvSFtHkoTMx1SUYNZ5MthkjRhYwBSUfkT03Vce/pULvYXPIW/Rbn9fmjpqyTWsskSpHOREnRvKLgZAHU1VIBnV96tDqaSg0sB5AGGKlktRIIK63d7j8tjnp38r08LlaLwJI4f0FHHp6iE2bZiXvwbFFXWw+LvCSW5Svi5bfbwAO2yN0CgjDHqzvHVO2ppqEJrIkXHB+Zt2SfHabSA3LkZLz/gn+iUMeO+vyqRKv99EEOZYs01wsZ081XtlGyuDGp7VtLLCmW8+9kc8HBi+9O44r6EXKQYrxNseg+Pni8k99drwVwtO1ks+dDWRXb+Z/FtpM6qJ4k6MI79+FYvLuNmF4JfUvKBKFmaVURey9RmnhpEH6WQW23FL8nbzA+GaB1sPFhteY0N6Y2Mr0q8j1f5Uf96ov1SMK5CkrtmGDDyHDjZUsvFS9cq0AneSD5ZzkSwfwEcy5awan/+EOUwYvrVQGHunWIVJjDO/kU8He5aSB+Ae38h/Ef6mx0dvFpvCczRxKnB1l4Sa6dMfwhi/sedDGpamZuQ5MLM4Gg==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2556
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT027.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 3c78c92b-c022-4d5a-75df-08d853166509
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ADyJdpo6mEW4VgJAGI1NXkkAFigxXQCyr5cYXcpNdg19rLZLAEYb9oIH096xfiAvG49wWPXsZ94EmGIk9v85XFyDmuqC5BOtVK6u27cdTcAjikPMR1IA2oH5CO303+L4DWQUynaDjOJOYyE5kNzUNhHpO/cRvcSe8yh6QuG3F3Yh0s4CmeJ/27trVADzmsSW+bJhC5SXSi+vH4qITk+JHpSVma4RHBzYG578geEziaZAMaipY4f2FuR5j3dUE5XHHSKZ7r4O5a23BcM7XXvq3PVjZrXmlOnHGDmbXge+d3xaJvZep2q6edlvZg80Ajv9nKWaAurZOKaCJQXUUQO1aGhSRE40GnqI4AY6m3t5ii3ig3GBha0j693KWzSrS78gzpYG4MHg6gCMpeiTqCbARQ==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(46966005)(82310400003)(82740400003)(8676002)(316002)(36906005)(47076004)(55016002)(9686003)(53546011)(2906002)(6862004)(54906003)(7696005)(26005)(5660300002)(186003)(6506007)(336012)(8936002)(4326008)(81166007)(33656002)(86362001)(52536014)(70586007)(83380400001)(356005)(478600001)(70206006);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:11:41.0379 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da0678da-6d36-40a8-a192-08d853166a57
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT027.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4305
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
> Sent: Monday, September 7, 2020 5:47 PM
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
> On 2020-09-07 10:28, Jianyong Wu wrote:
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Monday, September 7, 2020 4:55 PM
> >> To: Jianyong Wu <Jianyong.Wu@arm.com>
> 
> [...]
> 
> >> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATUR
> >> >> ES_FUNC_ID,
> >> >> > +			     &hvc_res);
> >> >> > +	if (!(hvc_res.a0 | BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
> >> >> > +		return -EOPNOTSUPP;
> >> >> > +
> >> >> > +	return 0;
> >> >>
> >> >> What happens if the
> >> >> ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID function isn't
> >> implemented
> >> >> (on an old kernel or a non-KVM hypervisor)? The expected behaviour
> >> >> is that a0 will contain SMCCC_RET_NOT_SUPPORTED, which is -1.
> >> >> The result is that this function always returns "supported". Not
> >> >> an acceptable behaviour.
> >> >>
> >> > Oh!  it's really a stupid mistake, should be "&" not "|".
> >>
> >> But even then. (-1 & whatever) is always true.
> >
> > Yeah, what about checking if a0 is non-negative first? Like:
> > if (hvc_res.a0 < 0 || !(hvc_res.a0 &
> BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
> > 	return -EOPNOTSUPP;
> 
> I don't get it. You already carry a patch from Will that gives you a way to check
> for a service (kvm_arm_hyp_service_available()).
> 
> Why do you need to reinvent the wheel?

Sorry, I should have changed this code according to Will's patch. Thanks for reminder!

Thanks
jianyong
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
