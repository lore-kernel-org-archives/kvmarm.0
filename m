Return-Path: <SRS0=KLQI=YK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43575FA373B
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 10:29:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA34E2082C
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 10:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="ItVmx7kC";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="ItVmx7kC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA34E2082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A29E94AA36;
	Thu, 17 Oct 2019 06:29:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1I8hvA6DRHVk; Thu, 17 Oct 2019 06:29:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6836B4AA64;
	Thu, 17 Oct 2019 06:29:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00DA24A9A4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 06:20:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tUxNb0uy6Qqi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Oct 2019 06:20:42 -0400 (EDT)
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr20067.outbound.protection.outlook.com [40.107.2.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 431FA4A8F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 06:20:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDp2fnDxHPIWeFnZ5sV7PZ6gyFHF27CUL9JVJA8iIG8=;
 b=ItVmx7kCTQoqHaPd2x1E08X99ZztQVyOIdzrzqP/HTt6x2tjG73FD4nsoIvEZHQ7VPPyqmAYmskRE731TjEY1UsqjqruoRUkpxvNwgT5w15EjI/xlbmO3XMr6U1P4vIxPKUfGzn2Lc6o/W0PRnDKFLnD7OYFLaL1uZb5+oNjmOc=
Received: from VI1PR08CA0252.eurprd08.prod.outlook.com (2603:10a6:803:dc::25)
 by AM6PR08MB3351.eurprd08.prod.outlook.com (2603:10a6:209:48::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.21; Wed, 16 Oct
 2019 10:20:38 +0000
Received: from DB5EUR03FT052.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::202) by VI1PR08CA0252.outlook.office365.com
 (2603:10a6:803:dc::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.16 via Frontend
 Transport; Wed, 16 Oct 2019 10:20:38 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT052.mail.protection.outlook.com (10.152.21.82) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 16 Oct 2019 10:20:37 +0000
Received: ("Tessian outbound 0cf06bf5c60e:v33");
 Wed, 16 Oct 2019 10:20:26 +0000
X-CR-MTA-TID: 64aa7808
Received: from c6101318b283.2 (ip-172-16-0-2.eu-west-1.compute.internal
 [104.47.13.55]) by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 69016E91-2A83-4FC6-8012-600F676F5E84.1; 
 Wed, 16 Oct 2019 10:20:21 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2055.outbound.protection.outlook.com [104.47.13.55])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c6101318b283.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 16 Oct 2019 10:20:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbOLwIIk6Z28jaIfCnlEP6absjRIULfvVGsJn2ijo6vBpp7jS1oT5WU1kY0tSkroogNxKBiIUrvtgLQOvt6deveZGWfGLhwGC7DsYG6gnmUMsp5lrpSLBbYYEkYSwR2vNO9VMwqpadgBYj1nplHbexCCWmaCiM4gGdzE7fJ1zGPEYrGredEx9xuhyl29Y1/uGKkFeiTOIQZb6AMqEZb4jVbjEu+hJXMuhDGIHkviMTYiVdwu9ar2hzX8vSjO1gp6wid4GXdJRKVH4ZPT4i6f1MWXujpomAMgSncl3Hfcq+NorORzfgmbiRS+ZFqu8eLwRsyv576sJiQfJg0gZluMsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDp2fnDxHPIWeFnZ5sV7PZ6gyFHF27CUL9JVJA8iIG8=;
 b=O1kFKxkZauvO+a805UJa7+gvurCqxxic0cZ9PFFfH/ALDlaPtkTYjYyk+LMKa3AW8n+11Hf9gqCNCwK9LU7vJUfAGx3R3FnbNIs1RLrsSYt3KsZB+1yqXry4HVUHBJ6QvJEeSS7wbXdHH1VXh9f9pZqzzHqQrxzYlncjCoo3ANENa0K9PLqcgVkorGNScrp/P/aOMCAI5R9wc2AP7N51D1E9iYTiq84N2xtqUt8T5fce1j+i/YA4pht5aE0/vLxE37FNDMuJbMUO3PWGYg8DhG3mqTfYXO09+e7RWfqX0/wy0LuW4IYWJBQGLuNqZ9j8sL5FP07fTT422zxn+u6meg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDp2fnDxHPIWeFnZ5sV7PZ6gyFHF27CUL9JVJA8iIG8=;
 b=ItVmx7kCTQoqHaPd2x1E08X99ZztQVyOIdzrzqP/HTt6x2tjG73FD4nsoIvEZHQ7VPPyqmAYmskRE731TjEY1UsqjqruoRUkpxvNwgT5w15EjI/xlbmO3XMr6U1P4vIxPKUfGzn2Lc6o/W0PRnDKFLnD7OYFLaL1uZb5+oNjmOc=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1964.eurprd08.prod.outlook.com (10.168.94.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Wed, 16 Oct 2019 10:20:19 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 10:20:19 +0000
From: "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "sean.j.christopherson@intel.com"
 <sean.j.christopherson@intel.com>, "maz@kernel.org" <maz@kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>, Mark Rutland
 <Mark.Rutland@arm.com>, "will@kernel.org" <will@kernel.org>, Suzuki Poulose
 <Suzuki.Poulose@arm.com>
Subject: RE: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
Thread-Topic: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
Thread-Index: AQHVg0Y6ldpzPhPiCEmlQj9Y39l92adc3w8AgAAwgWA=
Date: Wed, 16 Oct 2019 10:20:19 +0000
Message-ID: <HE1PR0801MB16762F7310EC28FE8DDEAC2EF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-5-jianyong.wu@arm.com>
 <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
In-Reply-To: <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 94428382-265b-4841-b3fb-4bd68ecd7167.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: a88a34f7-38da-4a75-fdb1-08d752227cbe
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1964:|HE1PR0801MB1964:|AM6PR08MB3351:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB335193CA9E25685CBE1D811CF4920@AM6PR08MB3351.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:7691;
x-forefront-prvs: 0192E812EC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(199004)(189003)(13464003)(25786009)(66446008)(2201001)(71200400001)(102836004)(86362001)(8676002)(2906002)(6636002)(74316002)(478600001)(76116006)(66946007)(71190400001)(81166006)(33656002)(81156014)(99286004)(66556008)(6116002)(64756008)(66476007)(3846002)(4326008)(256004)(5660300002)(55236004)(8936002)(6506007)(6246003)(53546011)(7416002)(186003)(54906003)(9686003)(6436002)(7736002)(316002)(2501003)(446003)(52536014)(14454004)(55016002)(305945005)(110136005)(229853002)(76176011)(476003)(66066001)(11346002)(486006)(7696005)(26005)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:HE1PR0801MB1964;
 H:HE1PR0801MB1676.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: I1w2hbVbICQ9mMusbQX4PqCCA8pFB/i2aKV5CKr0K6eHJEHbkia21eb10F0waxU0rrGBxHkEpSQ1WJFf+4tVFRqxfX7cBM7MUpluZSOUdP9Bwl6Zt2GzIqS2xbfJm/0ujeNDJ0i3gYh7om1zLpfuL+x8dvB3sLGF+saCcMbrkQHJ8/LZsEWFAJYEC8VzEsbMzuKEAuzhsA+VdLgNJqNLlLhbPUGL2cl4xcAyo3f2Z0BeIyc8BKtXGDHJjcC3CC0nkjF8TYvSQBB0NxrCF4MHnhQdEOPzX+23o4nCVDcraqrXh+lSF22hErTr0KeU3H/vTJ19wKgHlX4EramCING8mJitfRBdZ3CB5lhIfI4Na43c0Pnt61zG5fky9oYroN//r61a1b6Lbwqle0516UqRrrMWORweq5mP6IkquPDdxeE=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1964
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT052.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(13464003)(189003)(199004)(336012)(7696005)(74316002)(99286004)(356004)(23676004)(2906002)(26826003)(8676002)(3846002)(478600001)(6116002)(126002)(14454004)(486006)(476003)(76176011)(2486003)(11346002)(81166006)(8936002)(81156014)(26005)(7736002)(186003)(33656002)(63350400001)(6636002)(436003)(25786009)(102836004)(305945005)(6506007)(53546011)(446003)(50466002)(5660300002)(2201001)(4326008)(86362001)(70206006)(66066001)(2501003)(70586007)(47776003)(22756006)(9686003)(55016002)(6246003)(52536014)(229853002)(316002)(110136005)(76130400001)(54906003)(921003)(1121003);
 DIR:OUT; SFP:1101; SCL:1; SRVR:AM6PR08MB3351;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:TempError; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; MX:1; A:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: eb38ac53-4990-4f53-aa7d-08d75222722a
NoDisclaimer: True
X-Forefront-PRVS: 0192E812EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SlZLWRKlTFQaAOGkRAasm3qoZ3KaZ2tvzZxVFPdM6io8MHL2+jnWAFEfreA/CGldzDJiw/nyNrbBjzYYQBrUhMQIZwbxK+eIv/jLTk3fPVQl9r/2JaU8ZMS9LEQbUnneRp/irjLPCBTR3H7KT1xKx+un5QuAYeiXPRYCkrjInTBYu6rsFDdiNosT52+v2JCf5le0eE0LLs1TAumM38pe7Q40ddLMxE0UkdNTMF9NUajwX0vOAp1HYsrVZdyPx+f0Ra63fy+AfQxjNm6e0M/+naIuyb2OZMmeZWUCIY7aL1JNBB0XV0TuZbOFyOUwzy2srxEGtQU0s8231nfQ/2bqln/BvEUbqdX7PInFT9ijOGKM1kmCMTEyhPoyQSVqi1tNcv4PtMvKsfYVJPNjC5vuKIfo6CfaOa7qSh0anu+V2PQ=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2019 10:20:37.0941 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a88a34f7-38da-4a75-fdb1-08d752227cbe
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3351
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
> Sent: Wednesday, October 16, 2019 3:25 PM
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
> Subject: Re: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
> 
> On 15/10/19 12:48, Jianyong Wu wrote:
> > diff --git a/drivers/clocksource/arm_arch_timer.c
> > b/drivers/clocksource/arm_arch_timer.c
> > index 07e57a49d1e8..3597f1f27b10 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -1634,3 +1634,8 @@ static int __init arch_timer_acpi_init(struct
> > acpi_table_header *table)  }  TIMER_ACPI_DECLARE(arch_timer,
> > ACPI_SIG_GTDT, arch_timer_acpi_init);  #endif
> > +
> > +bool is_arm_arch_counter(void *cs)
> > +{
> > +	return (struct clocksource *)cs == &clocksource_counter; }
> 
> As Thomas pointed out, any reason to have a void * here?

Need fix.

Thanks
Jianyong 

> 
> However, since he didn't like modifying the struct, here is an alternative idea:
> 
> 1) add a "struct clocksource*" argument to ktime_get_snapshot
> 
> 2) return -ENODEV if the argument is not NULL and is not the current
> clocksource
> 
> 3) move the implementation of the hypercall to
> drivers/clocksource/arm_arch_timer.c, so that it can call
> ktime_get_snapshot(&systime_snapshot, &clocksource_counter);
> 
> Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
