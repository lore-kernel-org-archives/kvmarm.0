Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A95BC2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 10:19:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5FDBD20782
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 10:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="Z6lfIbJc";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="Z6lfIbJc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FDBD20782
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AE004BD86;
	Tue, 24 Nov 2020 05:19:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S8ml5jPpB+Km; Tue, 24 Nov 2020 05:19:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D1FC4BD46;
	Tue, 24 Nov 2020 05:19:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 211504BD12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 05:19:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GcSboISnwMMz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 05:19:00 -0500 (EST)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr150059.outbound.protection.outlook.com [40.107.15.59])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AA454BD10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 05:19:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5ZM0YbzVNLfTgEOggSw2Ayc/XGetNdHpoJdwlwHejA=;
 b=Z6lfIbJcDcjHQ/970fS+IPyjiisSIK/umspDaz/2Jw33EHnlYZKASih9bHAQzD3WhCRUaAI/DuYa5DUAZ4bLZKoNx2cqZwe/D97LI71XhuGi+rsBcJRCdFk8JyB7qxIznql/2fRcz7k578VOvvNAey6cmk6dpkG5yAVOu3c2MHE=
Received: from DB6P193CA0015.EURP193.PROD.OUTLOOK.COM (2603:10a6:6:29::25) by
 AM6PR08MB4501.eurprd08.prod.outlook.com (2603:10a6:20b:b5::21) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.20; Tue, 24 Nov 2020 10:18:56 +0000
Received: from DB5EUR03FT010.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:29:cafe::f5) by DB6P193CA0015.outlook.office365.com
 (2603:10a6:6:29::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Tue, 24 Nov 2020 10:18:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT010.mail.protection.outlook.com (10.152.20.96) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 10:18:53 +0000
Received: ("Tessian outbound 39167997cde8:v71");
 Tue, 24 Nov 2020 10:18:51 +0000
X-CR-MTA-TID: 64aa7808
Received: from 207553ae8e72.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 0B403D2B-F03D-4364-9D68-1F039F6F03DC.1; 
 Tue, 24 Nov 2020 10:18:45 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 207553ae8e72.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 24 Nov 2020 10:18:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1SnG39kvykEk7Z7s8fTboS3EYmCx0caiF0IJsQy1WF1Kz7q5xGfWbSP2NkyOrAK1ucai0rN84GnUx29K1IPGzHKarJACinHQl7lSvv6uL7yXi/qML112LJ+C7NJELCtQ6Aoj8dNTC0Cu8R5nhJFjfYiweUJ8+1WckTsK0Hdpfzjyf7hqdgK8gpSofyYUhsdiSmwFOM/D8OlxXWNdunGS1dRXAqUAeUplB16+qGhNb2v02D5jC79264Qfhx0bD6G1mR1O3WxiirmbIQrAiaKlpKaTQZQleepy55SWHIHKverorzhBIyXZYzb1DIhyBt/3yemXapUKyRLL57ntomsSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5ZM0YbzVNLfTgEOggSw2Ayc/XGetNdHpoJdwlwHejA=;
 b=VP8SF6zGA9dzjTYVcGoohsI8UaFL6LAPiROieJjgO8vK95u1iRa7Kg+qsmzEU7hzkTK/TVAirHcNfa+pcJZ65MHQ07aQQCiwVe/tvPaZaqct7HrPPM7RhWqHB+2OooQAhIfmFsNn94a2qlqqZnk0kbohyNqDEBo6dKoWB8AcereNR7Xmli1od4MjGhZRfTitxo/J0dA/XOtYelbYQRAdNthj4062oel+ICodjQfb8UDs+rJuVwDzUnbik1jWQL8pIJLtlFPa5XsfKwPYUrpbWyJHzk4GBF3aUrQ0wls6LzPsg2/MjqhCKt+lTVzn65yqQNeftimSnY/DnwZHRjJy9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5ZM0YbzVNLfTgEOggSw2Ayc/XGetNdHpoJdwlwHejA=;
 b=Z6lfIbJcDcjHQ/970fS+IPyjiisSIK/umspDaz/2Jw33EHnlYZKASih9bHAQzD3WhCRUaAI/DuYa5DUAZ4bLZKoNx2cqZwe/D97LI71XhuGi+rsBcJRCdFk8JyB7qxIznql/2fRcz7k578VOvvNAey6cmk6dpkG5yAVOu3c2MHE=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2345.eurprd08.prod.outlook.com (2603:10a6:3:ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.25; Tue, 24 Nov
 2020 10:18:41 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 10:18:41 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
Thread-Topic: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
Thread-Index: AQHWt/M8TW7h8ytFwE22PYJVJt7LOKnVnLWAgAE22MCAAD5PgIAAE2zg
Date: Tue, 24 Nov 2020 10:18:41 +0000
Message-ID: <HE1PR0802MB25557885DA7391D52353B7C5F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-8-jianyong.wu@arm.com>
 <7bd3a66253ca4b7adbe2294eb598a23f@kernel.org>
 <HE1PR0802MB2555C5D09EA2BF0BA369BE37F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <5dc5480d125ace6566ae616206c3ce3f@kernel.org>
In-Reply-To: <5dc5480d125ace6566ae616206c3ce3f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6C9A8ECA3BBD124CA8B1E58DDB01C145.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: da89a3f1-f285-494d-f92e-08d89062582d
x-ms-traffictypediagnostic: HE1PR0802MB2345:|AM6PR08MB4501:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB450116B9C5469E86DB12D198F4FB0@AM6PR08MB4501.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1303;OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: w9l1jtjjkYnDW+DErIKgqqauzHfZ7rAzPreYqNR0rVyGXKAwYDmZXSNje4XGJ4fgqsaRZiiD8HS8ztrS9/JhlyB6qyD8vW7S41+RfR86S7bTuZxRHSKrAI3mr9GJAMeE96cD5722I4tqtleC6qzfegl9bQx9tbbRL/AFMdFQDqnCIUbGgJQGeSJJdVDrW+SuKJK7PA5FZSvJ/ON3unv1jBB2DkD6p+hmyz6zahyL1UPrpjNuWLXTzCtaCrAc0bUBVsv7NUS9wI1vMcLhjyd4SfmDRcPGNPTehLGB1Pami2yBWQeY4tNUw5Sz2DrGQmyYRxCxVAf4ohj4r6JQOjLIXQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(4001150100001)(66556008)(64756008)(66476007)(66446008)(5660300002)(76116006)(66946007)(86362001)(2906002)(26005)(4326008)(52536014)(316002)(8936002)(71200400001)(186003)(83380400001)(478600001)(7696005)(54906003)(6916009)(7416002)(9686003)(8676002)(33656002)(53546011)(55016002)(6506007);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: cgtQvvJpM3NGMhe7EV0TnLAkHegiCRq9mXLcv8MdYZnmRhsd/a3yL3jHUxzSc6/TPNPgYTGTwte7EjTjzY7Q4tiFAAoIiisHa+/f5sEZ7v4gtQgAypnlcXYLwDTtpHrz6I7mduAMWWbD7YFBzMs0qzTFHexMRtKLypxiY8k0Hi1iC5MSvE29yCbTqJBuZV7WSbyTp9fl0GoNp7p1wFA5BpQoRKYgLij5ZMlnNqWSUyewvAW4iHtSC6CXuBIBYTRo0JVeuN2kWmDtfBcBIvLIR9hDi1VsfTeIvIdj+wQqMZj0AbUbtxMXugD8vSj0KaT76cQpYaMU02oEWWGzy2Fi95w1A3xMzuNMX0Pf3MSVxXOiScawFrSAOKkd0KduCN92oOYrLUDINPV1sc/dwqzH4C/GXZ76bGPDaQNB/AsERrw752nguyHKNTgRd4dXzPZJennyVk//G/zCSh3iGlUR/fkgXsj+Va53JrALTI5cYypIuV9bUAIdg4sSdnvL6wtG9GcUQEChFr5OSx/D6i3HVQI8GFf3c4kJYgaIy/vn08JID0S4+ienyzO6qLYIcCG2mY/p5CYDPbBro+0dqbRMb6Qh37vE1JdRTK6X9gkHQI9M3BaJsnB9sxNGbgCmuAG5xsL124cgU3t63cQsLHb/wdTI7nky+aF044PuUkCmEgNkJx9r3YZW5U+PQivO8buZv8c4vP0SIbrhC9FroVClgJl8ZRYSLHbwurs1fS2k0umoD9Drh5Xw/k7NYfcSGM8WqyXI4Z0i9zO+LJ12AbxgNYNjZWPwtoDt+2iLRP7wHEpS99cZurcD8EM6Ct9JnB6MHrq0gp8Ya8OKw2S/ZtZjCNm9/4Of0ZIbjxWHoV0BiZwsOcHa3/iRgrLaPO+zfEsM+Vhvqds63USUP3lCew6efA==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2345
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT010.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: c9794146-e0e3-4b76-830a-08d890625137
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mgPtX+7rpRY1obqV4aIiZUfJdOX4tMoSZsAM6X5hsf0O1kNgzPyeXy0aoM+WcDi0Tm//c2Yw+Sda5mqsJP/poixTUcjz93t5iFFm7CBJW2iGoI4KT5gjBOXZmkvffGWGb2N2Iv9nhN7U6PTMlaJKrmEKpmSdrX7epVGhT+RxkSuJGOU5elxzy7Jrq3pcHprCWWkapcXA3UYBtQpzRzCzLcH45p82+hFJvqWcR+aUS9zz83eXFyuMAxMzcj+aTtEEBxfQLTwm1niYx/vbT3F7WEOif5YHDj4Cd6+BhQj5P4w/PpQz1/lqyltcLqPjHngnUlCnKEnjxeyizVv7E1YdHfVrdZHiA+H8gnWSEmlLJqU0+dKKaYpwsakWk/mQN1faJit6mY91sVH2g1n+QxHbkw==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(46966005)(81166007)(356005)(9686003)(52536014)(8676002)(316002)(33656002)(55016002)(2906002)(47076004)(82740400003)(70206006)(70586007)(8936002)(83380400001)(4001150100001)(336012)(82310400003)(478600001)(86362001)(7696005)(4326008)(186003)(6862004)(26005)(6506007)(53546011)(5660300002)(54906003);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 10:18:53.3307 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da89a3f1-f285-494d-f92e-08d89062582d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT010.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4501
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
> Sent: Tuesday, November 24, 2020 5:05 PM
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
> Jianyong,
> 
> On 2020-11-24 05:37, Jianyong Wu wrote:
> > Hi Marc,
> 
> [...]
> 
> >> > +
> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> >> NC_ID,
> >> > +			     ARM_PTP_NONE_COUNTER, &hvc_res);
> >>
> >> I really don't see the need to use a non-architectural counter ID.
> >> Using the virtual counter ID should just be fine, and shouldn't lead
> >> to any issue.
> >>
> >
> >> Am I missing something?
> >
> > In this function, no counter data is needed. If virtual counter ID is
> > used here, user may be confused with why we get virtual counter
> > data and do nothing with it. So I explicitly add a new "NONE" counter
> > ID to make it clear.
> >
> > WDYT?
> 
> ITIABI (I Think It's A Bad Idea). There are two counters, and the API
> allows to retrieve the data for any of these two. If the "user" doesn't
> want to do anything with the data, that's their problem.
> 
> Here, you can just sue the virtual counter, and that will give you the
> exact same semantic, without inventing non-architectural state.
> 
OK, that's it.

Thanks
Jianyong Wu

> Thanks,
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
