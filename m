Return-Path: <SRS0=KLQI=YK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D293FA373A
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 10:29:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B82BA2082C
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 10:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="rJzxmKhT";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="rJzxmKhT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B82BA2082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70C0C4AA4C;
	Thu, 17 Oct 2019 06:29:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4E+oRCPCGz8I; Thu, 17 Oct 2019 06:29:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6D924AA5A;
	Thu, 17 Oct 2019 06:29:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9102F4A9E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 05:49:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WRtAp-rBVLJT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Oct 2019 05:49:08 -0400 (EDT)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr150084.outbound.protection.outlook.com [40.107.15.84])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B80A04A9E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 05:49:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md1nR1RKcd65vE73GmnLziOpKuVHsxBM/wC6YDptQMQ=;
 b=rJzxmKhToi3XOP7o48OaaNb6pmwjkemOR8HNU9P4fqjBPg27dsAEiuvqAVGjfxdhekI3+WY+wmtwl8nFj/chL7f21kiL4ES/+1PioBdTERoKbtpRoqLWKiTUUMzUNmWV2VeJq8TPRKjYmp+hKq0kEu6mb/kWOjElEhSiRL1uohk=
Received: from DB6PR0802CA0040.eurprd08.prod.outlook.com (2603:10a6:4:a3::26)
 by DB6PR0802MB2423.eurprd08.prod.outlook.com (2603:10a6:4:99::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.16; Wed, 16 Oct
 2019 09:49:04 +0000
Received: from VE1EUR03FT010.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::200) by DB6PR0802CA0040.outlook.office365.com
 (2603:10a6:4:a3::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.16 via Frontend
 Transport; Wed, 16 Oct 2019 09:49:04 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT010.mail.protection.outlook.com (10.152.18.113) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 16 Oct 2019 09:49:02 +0000
Received: ("Tessian outbound e4042aced47b:v33");
 Wed, 16 Oct 2019 09:48:52 +0000
X-CR-MTA-TID: 64aa7808
Received: from a94b262de10b.2 (ip-172-16-0-2.eu-west-1.compute.internal
 [104.47.10.51]) by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 EE9EE450-8095-41AA-A1E6-80ECD47E18E2.1; 
 Wed, 16 Oct 2019 09:48:47 +0000
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2051.outbound.protection.outlook.com [104.47.10.51])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a94b262de10b.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
 Wed, 16 Oct 2019 09:48:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C80+LbR2D9qOnBYC3+CHdrKI3OWh7f7ktLkeXRcVnm4mvRDArA+0f+LKsv2qxXWY5DlTtMK7/7/A3efA90bJSSLQVb49gvZfFwoCc4N44zHsKg48i2amwY7xsksu1c3C91BFzKTOgKZgTH9tttiutCc3HO9w3VUoBlJXSAzOLq2cYIcGZMJvXggHFaI66S30TKp/jG9S++2sMC3UXfpMLq87zYijY5AVcPP5v2vg6ZifqS67BxMne8PDXSp4ITkakfPT7FFzt5gyx4Ys5C+UCwiQUjHAZxmGm/rGZ8t4M6TWpWqy/JxhXmNjyVNTrlCry59zIdSNroLffF3HXOulUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md1nR1RKcd65vE73GmnLziOpKuVHsxBM/wC6YDptQMQ=;
 b=VwomxDPEapQkiBfO5XAftvOwoen8mOgtu997BtA3tlVXudDsguS2H8pRx2vFG9xWH+rBxEYO6gPWVfeYGtMFsTA1h3HKvqImASgkcdUHMQ+liR2MxtRLCIQTfVnD6JLX1KPpx1jgs8qtL1uyTBTATaS22ihA5AgUPdwOIdTE6l12lVYHoC1KK0/UDo8jDcjaU+/V+Ci3c/efbAwIV63r7ZVOxwy/FQ09Rv3ZlGj8cW5uu1cEeVN3kgsztowvtG7vagM4o7TMjNI4eS+lp5eAjoU5ILRBPyaPVKP3dz2DdKE6yjpxio4dXXm0UFSRf1t/WObJKTJONWnbQIZfwgrmtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md1nR1RKcd65vE73GmnLziOpKuVHsxBM/wC6YDptQMQ=;
 b=rJzxmKhToi3XOP7o48OaaNb6pmwjkemOR8HNU9P4fqjBPg27dsAEiuvqAVGjfxdhekI3+WY+wmtwl8nFj/chL7f21kiL4ES/+1PioBdTERoKbtpRoqLWKiTUUMzUNmWV2VeJq8TPRKjYmp+hKq0kEu6mb/kWOjElEhSiRL1uohk=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1996.eurprd08.prod.outlook.com (10.168.97.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 09:48:43 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 09:48:43 +0000
From: "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
Thread-Topic: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
Thread-Index: AQHVg0Y1dymHk2OcFEiql6VhclDWladb5yqAgAA8TwCAACgCAIAAlJeAgAAfkWA=
Date: Wed, 16 Oct 2019 09:48:43 +0000
Message-ID: <HE1PR0801MB1676EC775B7BFA5FC7E4F9D5F4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-4-jianyong.wu@arm.com>
 <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com>
 <alpine.DEB.2.21.1910152212580.2518@nanos.tec.linutronix.de>
 <aa1ec910-b7b6-2568-4583-5fa47aac367f@redhat.com>
 <alpine.DEB.2.21.1910160914230.2518@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1910160914230.2518@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: ad2c70a2-bd34-4e39-aaa2-98de92e436d4.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: d6e13972-88e4-4126-2e69-08d7521e13a8
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1996:|HE1PR0801MB1996:|DB6PR0802MB2423:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB24232F3FD265D42D903D4B38F4920@DB6PR0802MB2423.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 0192E812EC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(54534003)(13464003)(199004)(189003)(7416002)(66446008)(66556008)(14454004)(64756008)(33656002)(2906002)(11346002)(9686003)(66476007)(66066001)(7696005)(6246003)(74316002)(99286004)(446003)(186003)(76116006)(66946007)(76176011)(26005)(14444005)(256004)(6436002)(55016002)(25786009)(71200400001)(229853002)(81166006)(8676002)(102836004)(81156014)(6506007)(5660300002)(6116002)(8936002)(478600001)(53546011)(86362001)(4326008)(71190400001)(316002)(110136005)(54906003)(55236004)(486006)(305945005)(476003)(7736002)(52536014)(3846002);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB1996;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 9Snvoq8lL1JLJMP+38lHxCRE+PIej1tuIP3XSAk+w1B9yoRP10Mc3lTXjeM7kREmMYyJWLTOaWQxlgTc+2Cgex76TEnTUQugZ6SWKbnQUM8eiKnmspeoknnIR2n58axsJ8rgmVx23zlIZYY1eCXiX3tEnEjvllFjijiDThP6ecpVGAxeUP+waa7ZaHWLxtUx8inxkzbuGYN1xICYNOO/Drm1tAX1VmRNNEjjTwLV2BWo1WY9haRX0gcktRFELFylO1LEQejf0z8nmvGpbXyffc97mgRH5bravTWXdH0cpZ+pWUPWOnaCS3QVUtAuMZM7DbZDMyeU/3uM6u2EPa1ohIzXH3jay9YSpQ1LQmwfkLyKibraHW/tbUCyw3esRjUCRwLBMhz30r8wouFVBdJXUwTKhZoCkfeWwUMOI3G8vfM=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1996
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT010.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(39860400002)(13464003)(54534003)(189003)(199004)(486006)(11346002)(6116002)(9686003)(102836004)(356004)(5660300002)(63350400001)(2906002)(3846002)(66066001)(47776003)(23726003)(4326008)(126002)(55016002)(52536014)(33656002)(476003)(25786009)(446003)(97756001)(229853002)(478600001)(26005)(26826003)(6246003)(46406003)(50466002)(186003)(76130400001)(305945005)(36906005)(14444005)(316002)(14454004)(70206006)(70586007)(7736002)(8746002)(53546011)(8936002)(6506007)(8676002)(81156014)(22756006)(81166006)(7696005)(110136005)(336012)(99286004)(86362001)(54906003)(74316002)(76176011);
 DIR:OUT; SFP:1101; SCL:1; SRVR:DB6PR0802MB2423;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:TempError; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; MX:1; A:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: f9a840f1-f54a-4c21-bd4a-08d7521e0821
NoDisclaimer: True
X-Forefront-PRVS: 0192E812EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YebID904Npw/JTosW1FStOa5SDlQUjQHguxzb0+cw7VSbVcYmWY/LOFABN8PUUOpd7GLB4hFZNXomrrF81vKrcN7qT6qc83kUE41kLaDNGTYtI3DuxJmuhozRIlcUe/mMyTrcVwEaXkA7AxeaftYJ0EYqts2eZsAcq/S3rLV5ldtLVwp8EAJ6TN2nQhV0X+9vDH7citTzfNd3IwdAnkzLS9TdYf32W8HXn2YIw9MoCdDafYeqZPYfS4acolo43mubsikR7L1Rczzrt6M3TDIIK51/6j0pWU969vHRQjGZ8+CXVgSGgsUOk999W5glqqeBxT71fnpT78UY468djCiBGUzBWpRz8gzE44fzTN8WLbTfgEcsIKzZ4mqlz26kgYgS4JlhDZe1a5DA3HkikBC/F7e1jR0FinrPpzVxIuq0JA=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2019 09:49:02.7439 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e13972-88e4-4126-2e69-08d7521e13a8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2423
X-Mailman-Approved-At: Thu, 17 Oct 2019 06:29:20 -0400
Cc: "Justin He \(Arm Technology China\)" <Justin.He@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, nd <nd@arm.com>,
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
> Sent: Wednesday, October 16, 2019 3:29 PM
> To: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>;
> netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> sean.j.christopherson@intel.com; maz@kernel.org;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v5 3/6] timekeeping: Add clocksource to
> system_time_snapshot
> 
> On Wed, 16 Oct 2019, Paolo Bonzini wrote:
> > On 15/10/19 22:13, Thomas Gleixner wrote:
> > > On Tue, 15 Oct 2019, Paolo Bonzini wrote:
> > >> On 15/10/19 12:48, Jianyong Wu wrote:
> > >>>
> > >>>
> > >>
> > >> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > >
> > > You're sure about having reviewed that in detail?
> >
> > I did review the patch; the void* ugliness is not in this one, and I
> > do have some other qualms on that one.
> >
> > > This changelog is telling absolutely nothing WHY anything outside of
> > > the timekeeping core code needs access to the current clocksource.
> > > Neither does it tell why it is safe to provide the pointer to random callers.
> >
> > Agreed on the changelog, but the pointer to a clocksource is already
> > part of the timekeeping external API via struct system_counterval_t.
> > get_device_system_crosststamp for example expects a clocksource
> > pointer but provides no way to get such a pointer.
> 
> That's a completely different beast, really.
> 
> The clocksource pointer is handed in by the caller and the core code validates
> if the clocksource is the same as the current system clocksource and not the
> other way round.
> 
> So there is no need for getting that pointer from the core code because the
> caller knows already which clocksource needs to be active to make.the whole
> cross device timestamp correlation work. And in that case it's the callers
> responsibility to ensure that the pointer is valid which is the case for the
> current use cases.
> 
I thinks there is something misunderstanding of my patch. See patch 4/6, the reason why I add clocksource is that I want to check if the current clocksouce is
arm_arch_counter in virt/kvm/arm/psci.c and nothing to do with get_device_system_crosststamp.

So I really need a mechanism to do that check.

Thanks
Jianyong

> From your other reply:
> 
> > Why add a global id?  ARM can add it to archdata similar to how x86
> > has vclock_mode.  But I still think the right thing to do is to
> > include the full system_counterval_t in the result of
> > ktime_get_snapshot.  (More in a second, feel free to reply to the other
> email only).
> 
> No, the clocksource pointer is not going to be exposed as there is no
> guarantee that it will be still around after the call returns.
> 
> It's not even guaranteed to be correct when the store happens in Wu's patch
> simply because the store is done outside of the seqcount protected region.

Yeah, all of the elements in system_time_snapshot should be captured in consistency. So
I think the consistency will be guaranteed if the store ops added in the seqcount region.

> 
> Vs. arch data: arch data is an opaque struct, so you'd need to store a pointer
> which has the same issue as the clocksource pointer itself.
> 
> If we want to convey information then it has to be in the generic part of
> struct clocksource.
> 
> In fact we could even simplify the existing get_device_system_crosststamp()
> use case by using the ID field.
> 
> Thanks,
> 
> 	tglx
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
