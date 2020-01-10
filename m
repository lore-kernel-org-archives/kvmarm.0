Return-Path: <SRS0=Qg2m=27=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22F8C33CA3
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 10:15:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 303EF206ED
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 10:15:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="DQoYhK8o";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="DQoYhK8o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 303EF206ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 672FC4B1C6;
	Fri, 10 Jan 2020 05:15:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DLz4ACPaakpN; Fri, 10 Jan 2020 05:15:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6FA64B1B8;
	Fri, 10 Jan 2020 05:15:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85EB24B1AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 05:15:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gU6sPRVzEe3d for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jan 2020 05:15:19 -0500 (EST)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05on2048.outbound.protection.outlook.com [40.107.21.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B12B4B0FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 05:15:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AEjMsUrseAf90qT+Z0OehLac26IXVM3JdC5KWmLUS0=;
 b=DQoYhK8oB5TsLDmDS7vjle1/kiykeC0rV17v1Y177oLBclyqcLxlbgwggeOZRDTq5n2saYHor1TdeECjoCW9SDkD4mJ/s45hh8Un5IBPeX+v0fsJMMJsd3h9kmo92RjV64F/gG4QYnRKRtmP7ZuSpSMQEEygZd8jFRDNu+w6S0E=
Received: from VI1PR0802CA0047.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::33) by VI1PR08MB3887.eurprd08.prod.outlook.com
 (2603:10a6:803:c2::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9; Fri, 10 Jan
 2020 10:15:16 +0000
Received: from DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::207) by VI1PR0802CA0047.outlook.office365.com
 (2603:10a6:800:a9::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.8 via Frontend
 Transport; Fri, 10 Jan 2020 10:15:16 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT007.mail.protection.outlook.com (10.152.20.148) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11 via Frontend Transport; Fri, 10 Jan 2020 10:15:16 +0000
Received: ("Tessian outbound 28955e0c1ca8:v40");
 Fri, 10 Jan 2020 10:15:15 +0000
X-CR-MTA-TID: 64aa7808
Received: from d613faf3656f.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 13A71204-3F44-4011-BEFA-79C2B423EA1A.1; 
 Fri, 10 Jan 2020 10:15:10 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id d613faf3656f.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 10 Jan 2020 10:15:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mo9Dn9OPOAMTBCPlIMOwF+7dbCacXK0WE6uldDVf74ivbfikLp+VZNxgU66VEJ/GlYeO4AAhFA87fm33vsmqSr4mTF4irO+aQ3xwryuP3epM9MmyEcZKfNyOFA89qX4BlVKmgyFX+f4ZfPJJnFx7I8L94oi7ACeO8XyLmvvWZhMGD2a8PBZTlXmgXaf0clexgxozth0I1lwr4zV4eICqNVm7Bxi/ooktywdoiNf49gsw0hR9iZiMITkYsDs31lhnf0izEJyjykZpce0c63byo9YYrLsSn0yT9BfVNqrx8DGtV7tAgRzsok2jOoWWGaoSXVAw09zRzfQzWW2Hv16w0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AEjMsUrseAf90qT+Z0OehLac26IXVM3JdC5KWmLUS0=;
 b=h6rQFKneLlvcfZraiXaJy7GG2NSeSSTrPZuldQeV9DCbX8ljtbjTf1pH+6zJPaZ2hV6xnJuuFg/7nTtVRgQrQTrNmhv5EuqPgzfTTFPhREUXE2x5riFTtc1Dr+AfCPciERxfRJm2Q4E2qj7wUa+FsbF7jTjH8wBKl+SPE2gvVDKd3zMepB9KhHZ0ghIh6+1fwoM/nwoYNYnWY8wEQNQTildn1rcVevMMPbg8h9yR7GHFeh/B4QhXc93vSQ++M6i3cP20cKxZ//fXdhf28g+BF9EN5qnwUdssljwfyS1dEKZeWv1i1i0guEP5XFAsSZAhLJF8AaDl91Tp6Qgupiq1KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AEjMsUrseAf90qT+Z0OehLac26IXVM3JdC5KWmLUS0=;
 b=DQoYhK8oB5TsLDmDS7vjle1/kiykeC0rV17v1Y177oLBclyqcLxlbgwggeOZRDTq5n2saYHor1TdeECjoCW9SDkD4mJ/s45hh8Un5IBPeX+v0fsJMMJsd3h9kmo92RjV64F/gG4QYnRKRtmP7ZuSpSMQEEygZd8jFRDNu+w6S0E=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1883.eurprd08.prod.outlook.com (10.168.94.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 10:15:07 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f%8]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 10:15:07 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHVrwu1ZTEnzkrQbEOo/hXDFqaU6affG9SAgALmpVCAADyUAIABmc4A
Date: Fri, 10 Jan 2020 10:15:07 +0000
Message-ID: <HE1PR0801MB16765B52E5DCD8EA480EDABFF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-8-jianyong.wu@arm.com>
 <ca162efb3a0de530e119f5237c006515@kernel.org>
 <HE1PR0801MB1676EE12CF0DB7C5BB8CC62DF4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ee801dacbf4143e8d41807d5bfad1409@kernel.org>
In-Reply-To: <ee801dacbf4143e8d41807d5bfad1409@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: fdcedd1e-5194-4357-9cb7-8e2d77cd7500.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ddf5805-bd89-4796-f4e4-08d795b5fceb
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1883:|HE1PR0801MB1883:|VI1PR08MB3887:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB388781510C8F80C0F86FBC09F4380@VI1PR08MB3887.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 02788FF38E
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(199004)(189003)(13464003)(55016002)(316002)(4001150100001)(55236004)(26005)(81156014)(8676002)(6916009)(54906003)(8936002)(81166006)(5660300002)(4326008)(7416002)(64756008)(71200400001)(66946007)(66476007)(66556008)(66446008)(7696005)(2906002)(76116006)(478600001)(52536014)(86362001)(30864003)(6506007)(9686003)(33656002)(53546011)(186003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB1883;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Pz3Tlrkb0QODjpoVbCOa6kauY66U6LCS8on+O56/9A5W5BoVnJK3bhd4uxr75ZHNn0AYff2korfT4Vlop8YpklKeHie9CenOLqbFqXp4NJ/ghoHwGyO3ky7tVOzRJVoijh4Ax45slStn2ILOXRqkFXumUmypb763h52XnMG5abLr4eHy4zTvlLj0DMQigH68dfPzWq+xAiYxr+JqE3a/uQstXIZ2uokGEYWdXg72syrCTArytiGpNMOnPyZGMzZeRmRIv221JKA2wjFdmaKV3+zKkfsCQADSSm+Jbv/+iMXMyo+nLhnw8EnvFmocVf49H3cY+YBwtgNgnu9wUUCuMn1rC0CQ8RbOy7NxPFzxI8Et82hjohWFBs6GMxezj3Q2dkvV+KD7YQH3RYEI8GVxBqb2UCpurqnWLDj56yMdyRsut1ZfwN5i5WDYzGZvQCbpgioKdBBmfLZeoklArp8F8fyd1xyVmE764kmNq1AAmjDMBX+opqC+oGIpaKLdCCJo
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1883
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(396003)(13464003)(199004)(189003)(478600001)(26826003)(70586007)(33656002)(81156014)(8936002)(52536014)(5660300002)(70206006)(4001150100001)(26005)(4326008)(8676002)(86362001)(336012)(186003)(2906002)(6506007)(30864003)(81166006)(7696005)(356004)(53546011)(55016002)(6862004)(9686003)(316002)(54906003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:VI1PR08MB3887;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:Pass; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; A:1; MX:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 86505b31-9a77-47fb-7d80-08d795b5f7f3
X-Forefront-PRVS: 02788FF38E
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MU764rSNj4oowURPENE6zViF0xPRSp/D7S+HahpivbIh2M5n3kyy+Whn910Ls27rMSmcAcv4RHyZFfkZ5TpzIP6LokiOEvQM5QWL+2GznYAGOX38/q5JOWGPJmyJPt8X9xTgnQLcj/mPn0eOqLgXa3VgP+5z2c9u8AecUBB5xKVwYakIH1548GMH8CyDM27dZInwcStXV7INDI3sLNxq/MvTqTyX53vi3SNZmQreQyHluHRD52hc38cabH7DfIsuAagvIoqXrTHe3Gyr+Z3ha3PwnObNtu6dG5IHTV+koXIvRS7CI1G93xws2Wb0NFhwxLjNAhmTCXl/J5VG7zoWd0QJ3lSEvFEFg+VaPWYQGZRMso4Bes8ZyQM/C11tj3NuvbO6kk0pFn1vZPhexZCCDeP2lyzcg3xUzqBOtdCXhxIVhbLYpsXD68MujgM4q+rNVWQEdHPLPxIudhq4so0z7uFco3GYEMWKvW5/+JTHRwGGbrKSBIPextzwEu+WQtFD
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2020 10:15:16.0455 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ddf5805-bd89-4796-f4e4-08d795b5fceb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3887
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
> Sent: Thursday, January 9, 2020 5:24 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
> 
> On 2020-01-09 05:59, Jianyong Wu wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Tuesday, January 7, 2020 5:29 PM
> >> To: Jianyong Wu <Jianyong.Wu@arm.com>
> >> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com;
> >> john.stultz@linaro.org; tglx@linutronix.de; pbonzini@redhat.com;
> >> sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark
> >> Rutland <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> >> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>;
> >> linux-kernel@vger.kernel.org; linux-arm- kernel@lists.infradead.org;
> >> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> >> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> >> <Justin.He@arm.com>; nd <nd@arm.com>
> >> Subject: Re: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
> >>
> >> On 2019-12-10 03:40, Jianyong Wu wrote:
> >> > Currently in arm64 virtualization environment, there is no
> >> > mechanism to keep time sync between guest and host. Time in guest
> >> > will drift compared with host after boot up as they may both use
> >> > third party time sources to correct their time respectively. The
> >> > time deviation will be in order of milliseconds but some scenarios
> >> > ask for higher time precision, like in cloud envirenment, we want
> >> > all the VMs running in the host aquire the same level accuracy from host
> clock.
> >> >
> >> > Use of kvm ptp clock, which choose the host clock source clock as a
> >> > reference clock to sync time clock between guest and host has been
> >> > adopted by x86 which makes the time sync order from milliseconds to
> >> > nanoseconds.
> >> >
> >> > This patch enable kvm ptp on arm64 and we get the similar clock
> >> > drift as found with x86 with kvm ptp.
> >> >
> >> > Test result comparison between with kvm ptp and without it in arm64
> >> > are as follows. This test derived from the result of command
> >> > 'chronyc sources'. we should take more cure of the last sample
> >> > column which shows the offset between the local clock and the
> >> > source at the last measurement.
> >> >
> >> > no kvm ptp in guest:
> >> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >> >
> >>
> ==========================================================
> >> ==============
> >> > ^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-
> >> > 21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-
> >> > 21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-
> >> > 21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-
> >> > 21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-
> >> > 21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-
> >> > 21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-
> >> > 21ms
> >> > ^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-
> >> > 21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-
> >> > 21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-
> >> > 21ms
> >> >
> >> > in host:
> >> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >> >
> >>
> ==========================================================
> >> ==============
> >> > ^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-
> >> > 18ms
> >> > ^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-
> >> > 18ms
> >> > ^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-
> >> > 18ms
> >> > ^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-
> >> > 17ms
> >> > ^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-
> >> > 17ms
> >> > ^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-
> >> > 17ms
> >> > ^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-
> >> > 17ms
> >> > ^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-
> >> > 17ms
> >> > ^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-
> >> > 17ms
> >> > ^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-
> >> > 17ms
> >> >
> >> > The dns1.synet.edu.cn is the network reference clock for guest and
> >> > 120.25.115.20 is the network reference clock for host. we can't get
> >> > the clock error between guest and host directly, but a roughly
> >> > estimated value will be in order of hundreds of us to ms.
> >> >
> >> > with kvm ptp in guest:
> >> > chrony has been disabled in host to remove the disturb by network
> >> > clock.
> >> >
> >> > MS Name/IP address         Stratum Poll Reach LastRx Last sample
> >> >
> >>
> ==========================================================
> >> ==============
> >> > * PHC0                    0   3   377     8     -7ns[   +1ns] +/-
> >> > 3ns
> >> > * PHC0                    0   3   377     8     +1ns[  +16ns] +/-
> >> > 3ns
> >> > * PHC0                    0   3   377     6     -4ns[   -0ns] +/-
> >> > 6ns
> >> > * PHC0                    0   3   377     6     -8ns[  -12ns] +/-
> >> > 5ns
> >> > * PHC0                    0   3   377     5     +2ns[   +4ns] +/-
> >> > 4ns
> >> > * PHC0                    0   3   377    13     +2ns[   +4ns] +/-
> >> > 4ns
> >> > * PHC0                    0   3   377    12     -4ns[   -6ns] +/-
> >> > 4ns
> >> > * PHC0                    0   3   377    11     -8ns[  -11ns] +/-
> >> > 6ns
> >> > * PHC0                    0   3   377    10    -14ns[  -20ns] +/-
> >> > 4ns
> >> > * PHC0                    0   3   377     8     +4ns[   +5ns] +/-
> >> > 4ns
> >> >
> >> > The PHC0 is the ptp clock which choose the host clock as its source
> >> > clock. So we can be sure to say that the clock error between host
> >> > and guest is in order of ns.
> >> >
> >> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> >> > ---
> >> >  drivers/clocksource/arm_arch_timer.c | 22 ++++++++++++
> >> >  drivers/ptp/Kconfig                  |  2 +-
> >> >  drivers/ptp/ptp_kvm_arm64.c          | 53
> >> ++++++++++++++++++++++++++++
> >> >  3 files changed, 76 insertions(+), 1 deletion(-)  create mode
> >> > 100644 drivers/ptp/ptp_kvm_arm64.c
> >> >
> >> > diff --git a/drivers/clocksource/arm_arch_timer.c
> >> > b/drivers/clocksource/arm_arch_timer.c
> >> > index 277846decd33..72260b66f02e 100644
> >> > --- a/drivers/clocksource/arm_arch_timer.c
> >> > +++ b/drivers/clocksource/arm_arch_timer.c
> >> > @@ -1636,3 +1636,25 @@ static int __init
> >> > arch_timer_acpi_init(struct acpi_table_header *table)  }
> >> > TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT,
> >> > arch_timer_acpi_init);  #endif
> >> > +
> >> > +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
> >> > +#include <linux/arm-smccc.h>
> >> > +int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct
> >> > timespec64 *ts,
> >> > +			      struct clocksource **cs)
> >> > +{
> >> > +	struct arm_smccc_res hvc_res;
> >> > +	ktime_t ktime_overall;
> >> > +
> >> > +
> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> >> NC_ID, &hvc_res);
> >> > +	if ((long)(hvc_res.a0) < 0)
> >> > +		return -EOPNOTSUPP;
> >> > +
> >> > +	ktime_overall = hvc_res.a0 << 32 | hvc_res.a1;
> >> > +	*ts = ktime_to_timespec64(ktime_overall);
> >> > +	*cycle = hvc_res.a2 << 32 | hvc_res.a3;
> >>
> >> So why isn't that just a read of the virtual counter, given that what
> >> you do in the hypervisor seems to be "cntpct - cntvoff"?
> >>
> >> What am I missing here?
> >>
> > We need get clock time and counter cycle at the same time, so we can't
> > just read virtual counter at guest and must get it from host.
> 
> See my comment in my reply to patch #6: *Must* seems like a very strong
> word, and you don't explain *why* that's better than just computing the
> total hypercall cost. Hint: given the frequency of the counter (in the few MHz
> range) vs the frequency of a CPU (in the multiple GHz range, and with an IPC
> close enough to 1), I doubt that you'll see the counter making much progress
> across a hypercall.
> 
Sorry, I will avoid to use those strong words.

It's really the case that the hypercall won't across cycle in general. But sometimes, kernel preempt 
may happen in the middle of the hypercall which we can't assume how long before schedule back. so it's better capture them
together at the same time.

> >
> >> > +	*cs = &clocksource_counter;
> >> > +
> >> > +	return 0;
> >> > +}
> >> > +EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
> >> > +#endif
> >> > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig index
> >> > 9b8fee5178e8..3c31ff8eb05f 100644
> >> > --- a/drivers/ptp/Kconfig
> >> > +++ b/drivers/ptp/Kconfig
> >> > @@ -110,7 +110,7 @@ config PTP_1588_CLOCK_PCH  config
> >> > PTP_1588_CLOCK_KVM
> >> >  	tristate "KVM virtual PTP clock"
> >> >  	depends on PTP_1588_CLOCK
> >> > -	depends on KVM_GUEST && X86
> >> > +	depends on KVM_GUEST && X86 || ARM64 && ARM_ARCH_TIMER
> >> >  	default y
> >> >  	help
> >> >  	  This driver adds support for using kvm infrastructure as a PTP
> >> > diff --git a/drivers/ptp/ptp_kvm_arm64.c
> >> > b/drivers/ptp/ptp_kvm_arm64.c new file mode 100644 index
> >> > 000000000000..f3f957117865
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
> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> >> NC_ID,
> >> > +			     &hvc_res);
> >> > +	if ((long)(hvc_res.a0) < 0)
> >> > +		return -EOPNOTSUPP;
> >> > +
> >> > +	return 0;
> >> > +}
> >> > +
> >> > +int kvm_arch_ptp_get_clock_generic(struct timespec64 *ts,
> >> > +				   struct arm_smccc_res *hvc_res) {
> >> > +	ktime_t ktime_overall;
> >> > +
> >> > +
> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> >> NC_ID,
> >> > +				  hvc_res);
> >> > +	if ((long)(hvc_res->a0) < 0)
> >> > +		return -EOPNOTSUPP;
> >> > +
> >> > +	ktime_overall = hvc_res->a0 << 32 | hvc_res->a1;
> >> > +	*ts = ktime_to_timespec64(ktime_overall);
> >> > +
> >> > +	return 0;
> >> > +}
> >> > +
> >> > +int kvm_arch_ptp_get_clock(struct timespec64 *ts) {
> >> > +	struct arm_smccc_res hvc_res;
> >> > +
> >> > +	kvm_arch_ptp_get_clock_generic(ts, &hvc_res);
> >> > +
> >> > +	return 0;
> >> > +}
> >>
> >> I also wonder why this is all arm64 specific, while everything should
> >> also work just fine on 32bit.
> >>
> > ptp_kvm is a feature for cloud computing to keep time consistency from
> > container to container and to host on server,
> 
> Cloud computing? Never heard of that. Will probably never catch on.
> 
Eh...

> > So we focus it on arm64. Also I have never tested it on arm32 machine
> > ( we lack of arm32 machine)
> 
> I'm sure your employer can provide you with such a box. I can probably even
> tell you which cupboard they are stored in... ;-)
> 
I'm working on building environment for arm32 from now.

> > Do you think it's necessary to enable ptp_kvm on arm32? If so, I can
> > do that.
> 
> I can't see why we wouldn't, given that it should be a zero effort task (none
> of the code here is arch specific).

Ok, I will test it on arm32.
By the way, does nested virtualization diff between arm64 and arm32?

Thanks
Jianyong
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
