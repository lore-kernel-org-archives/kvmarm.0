Return-Path: <SRS0=VgM6=WY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FB2C41514
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 15:40:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C4CBA208CB
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 15:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="3E2L0hWD";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="X8vV8U6K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4CBA208CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 681524A593;
	Wed, 28 Aug 2019 11:40:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NuJ1dYC-Yng2; Wed, 28 Aug 2019 11:40:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 083D74A57B;
	Wed, 28 Aug 2019 11:40:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BE9E4A563
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 11:40:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sSHGpxYIMNrO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 11:40:16 -0400 (EDT)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-eopbgr80087.outbound.protection.outlook.com [40.107.8.87])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09EF34A52B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 11:40:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fw2NMfXyT3wVuBSfA0YQ27t5lz4JwRg6YaHMGY1/4H0=;
 b=3E2L0hWDa9SzKUtXSTO+ymoGscM8gjOZUvtTnaIznU90Mx/cCMBltmRrxaEg/ZC8OLztlZp7/kaPNjbDLnM0FsUdxHzD3oT+8VPvfQLCRjNNFBnVPeQOI47k5ZALjwyTXZJECk6iUpsAPK6b68QN6uqoQvpKXTMk1lmnb2y/sH4=
Received: from AM6PR08CA0044.eurprd08.prod.outlook.com (2603:10a6:20b:c0::32)
 by DB6PR0801MB1848.eurprd08.prod.outlook.com (2603:10a6:4:38::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.21; Wed, 28 Aug
 2019 15:40:12 +0000
Received: from VE1EUR03FT009.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::206) by AM6PR08CA0044.outlook.office365.com
 (2603:10a6:20b:c0::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2199.15 via Frontend
 Transport; Wed, 28 Aug 2019 15:40:12 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=temperror action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT009.mail.protection.outlook.com (10.152.18.92) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2220.16 via Frontend Transport; Wed, 28 Aug 2019 15:40:10 +0000
Received: ("Tessian outbound d33df262a6a7:v27");
 Wed, 28 Aug 2019 15:40:07 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 175d16f4609560c1
X-CR-MTA-TID: 64aa7808
Received: from a48569f31930.2 (ip-172-16-0-2.eu-west-1.compute.internal
 [104.47.0.55]) by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 13103645-40C7-4ED8-BBFA-869E3976C9AF.1; 
 Wed, 28 Aug 2019 15:40:02 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2055.outbound.protection.outlook.com [104.47.0.55])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a48569f31930.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 28 Aug 2019 15:40:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejuq6AfgfPe2jYlPj2X93ijyHg7iVmBnAzmxBirDpqlWiDhrMeFusp81besB7SYStheAqRDbNOptfOM5K3xbrLF0CjLW0KBJGVjk/pqbenjheW0qPRana1jEVDVXZvlYxBmknK7rTgUQ++SACW27wAtnXiTSJ8WOU2W7rf9Tv49iUbSiQZG+vjyPPLGOwUjVgd1kt09B6WZ2Om3Cdz0tJ/lZXIMLmjLLKShkX/lHMFDjatdTF08kyarxQjVBpB9CpCcRWbc0kedUx5IyBxoqtYCaP59CghSeY3BeKf3OCwE0qPKCxp+K2XKV7P2tL56hnQoZFQvRuyo008A/aYzjwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYhgYAB36mCOYHB7dVJXkcZB/9ya13FlWc2PVnuNQ5o=;
 b=oDwki3Vrs7VxCIxfgoErR6d1DY7Ax5xTgkNJFGA7+71qJwlrvjP44iTpAALqBjSQRNdP3gTIg20LDzHGPElrJ4tRkmdNtIFsC1x9Jh6KzIAlwLJbmYdzHs3ozLMV6dpy3ssYghNRrCZEdpjRMtHbSeAlE7g6SsR0Oc5NRds4H4R4yiTBV4QrikoW9yQ6EtS5ZDok102JYDADd4Wm/ZYET5ttSR0+udw34KWoe8k6pdyfTB4BmlCylcqIJzfyojTy1PRUJJUVyu1rAhlKqocJyvodsfroYNVt4d8NCl1Xq5bBP1gsvoAgow6y8NtCNrVEuU/NORAbMfnGMzh2/hz+jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYhgYAB36mCOYHB7dVJXkcZB/9ya13FlWc2PVnuNQ5o=;
 b=X8vV8U6Kt67xu0DHlq7Ul2Ibt2iwOeghYQjKUKMi3RT1tcBHegADzQBdNTUBCyVOH7Ez+d4El8KikrhUcuVnAvYjl7HnT9nzZNmSo9I5L4UPuMK1c3CTSY4CYYhWIv/Gup9ZvCho3Q0Dd1NKwMCO5UCce2m70vFL7lywZv725l4=
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (10.255.99.17) by
 AM6PR08MB4165.eurprd08.prod.outlook.com (20.179.0.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 15:40:00 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::bd59:b56b:f215:e6e6]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::bd59:b56b:f215:e6e6%7]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 15:40:00 +0000
From: Alexandru Elisei <Alexandru.Elisei@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests RFC PATCH 01/16] arm: selftest.c: Remove
 redundant check for Exception Level
Thread-Topic: [kvm-unit-tests RFC PATCH 01/16] arm: selftest.c: Remove
 redundant check for Exception Level
Thread-Index: AQHVXaXxTNH3yny/0kighetsJPueYqcQn44AgAAS2IA=
Date: Wed, 28 Aug 2019 15:39:59 +0000
Message-ID: <7fe6365c-4495-99fd-66e6-4ad2dec2b4d9@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-2-git-send-email-alexandru.elisei@arm.com>
 <20190828143232.nffx5tko3zbjbnbf@kamzik.brq.redhat.com>
In-Reply-To: <20190828143232.nffx5tko3zbjbnbf@kamzik.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0145.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::13) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.140.106.51]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: ec323cee-d0fd-43f5-68fb-08d72bce02c7
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0; PCL:0;
 RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);
 SRVR:AM6PR08MB4165; 
X-MS-TrafficTypeDiagnostic: AM6PR08MB4165:|DB6PR0801MB1848:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0801MB1848738ECC74F18C5CFF951986A30@DB6PR0801MB1848.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:6790;OLM:6790;
x-forefront-prvs: 014304E855
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(66066001)(31686004)(6116002)(4744005)(3846002)(486006)(44832011)(64756008)(11346002)(66946007)(386003)(52116002)(229853002)(256004)(102836004)(26005)(6916009)(446003)(66446008)(71190400001)(71200400001)(53546011)(6506007)(66476007)(66556008)(476003)(99286004)(2616005)(186003)(76176011)(6486002)(5660300002)(2906002)(6436002)(8676002)(36756003)(7736002)(305945005)(54906003)(4326008)(316002)(14454004)(6512007)(86362001)(31696002)(8936002)(81166006)(81156014)(6246003)(25786009)(53936002)(478600001);
 DIR:OUT; SFP:1101; SCL:1; SRVR:AM6PR08MB4165;
 H:AM6PR08MB4756.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: voKCe7vb+NwqLPyMxCAitI3YY3Iix4SBLvpci+MN+p0Vh3GPP26xBMP0bk9CwJvMLMuyvupQDfwkB6ynDjsd7JXQIQzCmMM8nus5kZ31IGTZqQ1MzGW8W6koXRtITgu6uaeOQDuan1UAcY7ZlAm39xNv5o7J38QhDUcbEI/xuxQhsx21KYRlAWqTXJcv5MgTpiYt0QvMVENmKJelAGVYhykSSzIwZqrh6OkcRD4yREw2G5R4rLGvJsU61ipGVD5it1Aesoq4d9yPzVkzE32NTqc86VhyraXtKPvHS5GJjf+AS2jwZHtKYc2yXa1uSxnkXbra7Ff6AbLYodLNb2vVB7rBJKt+LP+XEONII/DIEMbtKtqmh7QP+eF2MUoaBZrw7mUIA/ngVKAJ38ocMBIoMpkZtbwTQsdXRgbXfjmYhi4=
Content-ID: <C67D3EE090D44E47B359990FC28E9DD6@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4165
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT009.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(2980300002)(199004)(189003)(40434004)(6512007)(70206006)(478600001)(66066001)(31686004)(86362001)(81156014)(81166006)(7736002)(5660300002)(63370400001)(36906005)(186003)(8676002)(22756006)(6116002)(8936002)(36756003)(356004)(70586007)(6506007)(6486002)(2486003)(23676004)(31696002)(2906002)(3846002)(76130400001)(26826003)(6246003)(486006)(2616005)(25786009)(476003)(26005)(126002)(446003)(336012)(102836004)(47776003)(5024004)(14444005)(99286004)(14454004)(11346002)(4326008)(436003)(54906003)(229853002)(6862004)(316002)(63350400001)(386003)(50466002)(76176011)(53546011)(305945005);
 DIR:OUT; SFP:1101; SCL:1; SRVR:DB6PR0801MB1848;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:TempError; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; A:1; MX:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: f744cb4a-dca3-4194-1430-08d72bcdfc57
X-Microsoft-Antispam: BCL:0; PCL:0;
 RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(710020)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);
 SRVR:DB6PR0801MB1848; 
X-Forefront-PRVS: 014304E855
X-Microsoft-Antispam-Message-Info: 34UDE1GncXBz7SubI+6d78AiSKXhWWq8OgknJdLzDZgQqjPmVTO6gtvTPRix0SdIz6F27DDuOO5zjryYm2/4etKYNHOrA00G/M0ycPL6KSQNPPtODkolJBIx0AYYUL4QZmtNYZ7OJwnL18mMYe4Ov/A6k50nwdqGZw3sGMURqx4YCNyqRWX25VCYlNSp2YH4Cp8sJcV4iFLYirGhBxVGOseMjfvS8XirTX+atCcJGgrvwpkp72dmGRa71P24kxMdeJZcW2jJy3N48NNjzwrPyLOBJ+Q8XyoTcuMD60vBOCTMwohPOaNc3I+gSmhPXWJM9/R1DbriKhzEmgZ9BdiCEwIKSSxPaEr/EG/9p+dy7O2Z70oaHpkVF/2wzc2dacJJt4VcfZFNMjFLJY9HGhgqKEU5yd3bN8+GcMNhdNH5/aA=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2019 15:40:10.4783 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec323cee-d0fd-43f5-68fb-08d72bce02c7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1848
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "maz@kernel.org" <maz@kernel.org>, Andre Przywara <Andre.Przywara@arm.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

On 8/28/19 3:32 PM, Andrew Jones wrote:
> On Wed, Aug 28, 2019 at 02:38:16PM +0100, Alexandru Elisei wrote:
>> expected_regs.pstate already has PSR_MODE_EL1h set as the expected
>> Exception Level.
> That's true for selftest-vectors-kernel, but not for
> selftest-vectors-user.

Oops, that's true. This patch is definitely wrong, I'll drop it.

Thanks,
Alex
>
> Thanks,
> drew
>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/selftest.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/arm/selftest.c b/arm/selftest.c
>> index 28a17f7a7531..176231f32ee1 100644
>> --- a/arm/selftest.c
>> +++ b/arm/selftest.c
>> @@ -213,10 +213,6 @@ static bool check_regs(struct pt_regs *regs)
>>  {
>>      unsigned i;
>>
>> -    /* exception handlers should always run in EL1 */
>> -    if (current_level() != CurrentEL_EL1)
>> -            return false;
>> -
>>      for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
>>              if (regs->regs[i] != expected_regs.regs[i])
>>                      return false;
>> --
>> 2.7.4
>>
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
