Return-Path: <SRS0=/xEG=3D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B89C33CB1
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jan 2020 10:35:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2491F24670
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jan 2020 10:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="TtzYkCof";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="TtzYkCof"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2491F24670
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8996A4B016;
	Tue, 14 Jan 2020 05:35:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gWvfcdRN72Dw; Tue, 14 Jan 2020 05:35:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2C174B02D;
	Tue, 14 Jan 2020 05:35:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57CB44B02B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jan 2020 05:35:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kpN2uaqCYzea for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jan 2020 05:35:01 -0500 (EST)
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr20063.outbound.protection.outlook.com [40.107.2.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68C7C4B027
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jan 2020 05:35:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMcY0I41udNF+2uESqSRzcDBBUmCzMhHhGmFdsv3MdU=;
 b=TtzYkCofO4VWT/73TqESbF5XVqA0cmdObMMDm1zloZN5CGruOZw3gcJSNRHcrvwRuOaB/JuSoC2qpogMlvo8zTQrjCc88Se0c+CYUhN9qJC+oreFTfwghSxx7/220/2cvhoY5OPrHf2AzQV2M9shHGrBRCt0R1t0ML/8aMp7hsQ=
Received: from VI1PR08CA0256.eurprd08.prod.outlook.com (2603:10a6:803:dc::29)
 by DB7PR08MB3884.eurprd08.prod.outlook.com (2603:10a6:10:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10; Tue, 14 Jan
 2020 10:34:59 +0000
Received: from DB5EUR03FT053.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::206) by VI1PR08CA0256.outlook.office365.com
 (2603:10a6:803:dc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.11 via Frontend
 Transport; Tue, 14 Jan 2020 10:34:59 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT053.mail.protection.outlook.com (10.152.21.119) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11 via Frontend Transport; Tue, 14 Jan 2020 10:34:58 +0000
Received: ("Tessian outbound 121a58c8f9bf:v40");
 Tue, 14 Jan 2020 10:34:58 +0000
X-CR-MTA-TID: 64aa7808
Received: from b6e565f55bc2.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 59396DE5-C495-44D7-AF14-D39CA66F96DF.1; 
 Tue, 14 Jan 2020 10:34:53 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b6e565f55bc2.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 14 Jan 2020 10:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GO9NFD1Wgc9hOaWhJZQg7pfIdVdflKJHZdodQPiryEm/jLbb5UEeeNkkaWnUkTjBv7Ex0vb6HigTxqwdfkoV8H5mgpl/kQ+133LT+/J7NRgg2iaTmDD1pD/aIoIQyjcJ8r2fLZw7i0JVMKwm2gQpx5G0ZG5xP4mbSRtt3suWf13AVxf0BJcEN8n3KCPlvaNGFZa/z/2xqJwhFHBEZpUFF/jnrZvBGLSiyqhyvo4PNEgUXEgsiZZFBJ8ZoogF3q/UeQr2eD/5lI7n9urGkH1SNqmaHzBU7zh2uXiHM4CpDtLvsKa7UI53gi5MiVkeyxmezHk+zPrYpEe/pDmT/YXtWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMcY0I41udNF+2uESqSRzcDBBUmCzMhHhGmFdsv3MdU=;
 b=bbC2TeA32a8IqyhgVRlO86yhEtc86oH87FhV11Vvx94+VYsGUfwkAnjCQiv7D9Fcg0UgHpkwM/KXwI2bfzUqkFYohe1uj3aCSp0esnurVWejf6+2neD8dIOKOXl9IvUBTKrQsRo82yJVB09n2t0c6Lg57ZgduVEW1QFi6Oj9chjUvkn5/N4a15cH3ZzrwETNpNxen0qr80F0Ci+ggfDg3Sjsb0RDr58dZ3hJfXnndo5yA8wfHAfJlsaWzPmG8nwiHZN4DwDFcZhgidXhQHJRxhhQcN3/pO/+puMN7+Uj3oy982w8sE2+uiI0Ok92Ta1GagnejjhQRu5wizOmLNszxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMcY0I41udNF+2uESqSRzcDBBUmCzMhHhGmFdsv3MdU=;
 b=TtzYkCofO4VWT/73TqESbF5XVqA0cmdObMMDm1zloZN5CGruOZw3gcJSNRHcrvwRuOaB/JuSoC2qpogMlvo8zTQrjCc88Se0c+CYUhN9qJC+oreFTfwghSxx7/220/2cvhoY5OPrHf2AzQV2M9shHGrBRCt0R1t0ML/8aMp7hsQ=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Tue, 14 Jan 2020 10:34:51 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f%8]) with mapi id 15.20.2623.017; Tue, 14 Jan 2020
 10:34:51 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [RFC PATCH v9 6/8] psci: Add hvc call service for ptp_kvm.
Thread-Topic: [RFC PATCH v9 6/8] psci: Add hvc call service for ptp_kvm.
Thread-Index: AQHVrwuxR+1ZEaCriEa+CGCL3lP4K6ffGBkAgALhg9CAAEMegIABkMMAgAAdn4CABKu08IAAEOIAgAGFg8A=
Date: Tue, 14 Jan 2020 10:34:51 +0000
Message-ID: <HE1PR0801MB1676C93AF0AA7980F4A79B3FF4340@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-7-jianyong.wu@arm.com>
 <7383dc06897bba253f174cd21a19b5c0@kernel.org>
 <HE1PR0801MB1676AB738138AB24E2158AD4F4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <099a26ffef5d554b88a5e33d7f2a6e3a@kernel.org>
 <HE1PR0801MB16765B507D9B5A1A7827078BF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ca80d88f5e00937fca7ee80be8f5c962@kernel.org>
 <HE1PR0801MB167693BFB769ACEEA8A6B007F4350@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <22ba1283a7b82f018c1fdf85414e5bfe@kernel.org>
In-Reply-To: <22ba1283a7b82f018c1fdf85414e5bfe@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 30ff59ce-40fd-40e8-bd50-0c283624fabb.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b7ffd35-68ca-4203-02ee-08d798dd675a
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1676:|HE1PR0801MB1676:|DB7PR08MB3884:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB38847CE6B76E82C5C42924CCF4340@DB7PR08MB3884.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: True
x-ms-oob-tlc-oobclassifiers: OLM:6430;OLM:6430;
x-forefront-prvs: 028256169F
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(199004)(189003)(2906002)(54906003)(316002)(5660300002)(52536014)(478600001)(33656002)(86362001)(4326008)(6916009)(55016002)(7416002)(7696005)(71200400001)(8936002)(81156014)(186003)(81166006)(9686003)(8676002)(66556008)(6506007)(53546011)(26005)(64756008)(66476007)(66946007)(76116006)(55236004)(66446008);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB1676;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Nk98rnE1mlVgCWC4ypXsAgy0trOdNDzrcZiAu/NaxJ3DsQlyHH6L65mWmQwU39jlk1XSScG0tLjPQwEy6KGvt2bgBRYSrabd1K5v49CH/fa68rmxwjJpBOmaTwLIp0BWyeibB5CD99qx6ZMTiG4S7vL4oQvR59ZsVwJvGB4Ik098VYKF8pdVlAEWSYmb6dDo0/FxIqcwGoh1W3HhCffQqGddMgHBy3/qFtfUfTVTpFY0NQLuDE9yEvvqTh42L+kqyehggiiwo4xtXk8HaKtd5CHRatpkH2ykpykbHbCFbn2SEVsyPwuVLorK+KoCgsjVLMwiWnF9ANMc4vgsetZFbwMlKLrOUUHS5mJiHwCmsRJjurgQic02erBcnhAe0R4NAe6AGx3076vWtQPxmwIMgLIdHIo0oNVoHbRy+LnMP4v3/TaeBGxDpNnnwOfAfi45
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1676
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT053.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(39860400002)(136003)(346002)(376002)(396003)(199004)(189003)(7696005)(26826003)(2906002)(5660300002)(52536014)(53546011)(70206006)(8936002)(316002)(54906003)(6506007)(186003)(33656002)(86362001)(356004)(478600001)(8676002)(4326008)(6862004)(9686003)(336012)(81166006)(70586007)(55016002)(26005)(81156014);
 DIR:OUT; SFP:1101; SCL:1; SRVR:DB7PR08MB3884;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:Pass; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; A:1; MX:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: bfcdd766-b44b-487a-a34b-08d798dd6320
X-Forefront-PRVS: 028256169F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 03gD5aCP8EagrisjSq+l4/oXWgRRZbIeuC/RDSyMXqal9J9TjZAbVxPNleCUrFZnheNEEVXbmYXwi15WlIH//rR6t6x6BrrbCYoCGVjFnCMT6F38MQa2uckEvWE37w7Ill6U2hvxMk4UcDkOLVTAJNFYsO8cSAsnlFweHkaajFcjLm2fzhrzozFM5N03+Nz+r3iSWKHh6Ncg0A/mvq3x/W7gaD+gz/PIVz3lfpsr1KM1M+RUZthKajLwEEkejB3eH+ADGj22WY6dtscP21uGIRJqGEkQVxHFQI8HAkynIzw6fZGBxcfmAMTLXWcN/uHP/yqoiikOjry1XNBsMV65BuUShOftiBKbbcv1zJzKljCweH+22AnAzCSyCKqI2dsLC3Ha+BwDmy6OAsCOyovl7A9Xhk1y7I/h1UxclPST3sCe4BozeKRlw3MaNlB/7Zzr
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2020 10:34:58.4870 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7ffd35-68ca-4203-02ee-08d798dd675a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3884
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
> Sent: Monday, January 13, 2020 7:16 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v9 6/8] psci: Add hvc call service for ptp_kvm.
> 
> Hi Jianyong,
> 
> On 2020-01-13 10:30, Jianyong Wu wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Friday, January 10, 2020 6:56 PM NV breaks that assumtion,
> >> because the guest hypervisor is using the physical counter. Also,
> >> let's not forget that the hypercall isn't Linux specific.
> >> I can write my own non-Linux guest and still use this hypercall.
> >> Nothing in
> >> there says that I can't use the physical counter if I want to.
> >>
> >> So somehow, you need to convey the the hypervisor the notion of
> >> *which*
> >> counter the guest uses.
> >>
> >> Does it make sense? Or am I missing something?
> >>
> > I know what you say. Let me try to solve this problem.
> > 	Step 0, summary out all the conditions we should process, which will
> > sever as branch condition.(now only normal virt and nested virt, I
> > think)
> 
> No. You shouldn't think of the various use cases, but of which time
> references a guest can use. You don't need nested virt to use the physical
> counter, for example.
Ok,

> 
> > 	Step 1, figure out the set of reference counter value used by guest
> > in all condition.
> 
> That should be for the guest to tell you when it calls into the PV service.
> 
Yeah

> > 	Step 2, determine which reference counter value will be used by
> guest
> > in a certain condition in hypercall.
> > In step 1, can we give the set only 2 elements that one is physical
> > counter the other is virtual counter?
> 
> I don't think returning the two values is useful. Just return what the guest
> asks for.
> 
> > For step 2, I have no idea for that now. can you give me some hint
> > about it?
> 
> Just expand your SMC call to take a parameter indicating the reference
> counter, and return the sampled (or computed) value corresponding to that
> counter.
Get it, I'll try it.

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
