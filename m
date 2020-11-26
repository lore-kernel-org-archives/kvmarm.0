Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E2DC56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:05:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6875721D46
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="qJrNBt/Y";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="qJrNBt/Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6875721D46
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C7B14C131;
	Thu, 26 Nov 2020 10:05:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VpdgB7ukmHyw; Thu, 26 Nov 2020 10:05:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20C674C135;
	Thu, 26 Nov 2020 10:05:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F5C94C0DA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:05:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3KIagBJTfWTb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:05:31 -0500 (EST)
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-eopbgr30065.outbound.protection.outlook.com [40.107.3.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C9E14BAFF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:05:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33BVEX6LrMkZjmioMrLzM57ZcF5mndEI3AGVu4Y6nC0=;
 b=qJrNBt/Yyk4EWRrkECG8riQHenxDfRnz2nOe4fzCq/sOGTQGTnygM2Csslg63yXRsOGrwlcNNzWG4iCryKb5P23O5W7TxLeSza8oW2OYp6PX+iWY/UdUdoU4Jwgan8JPg1SAgE6LalpcgHb6n/zkyL3CTO73urdAUOr5QTsybv8=
Received: from DB6P18901CA0007.EURP189.PROD.OUTLOOK.COM (2603:10a6:4:16::17)
 by AM8PR08MB5730.eurprd08.prod.outlook.com (2603:10a6:20b:1d5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Thu, 26 Nov
 2020 15:05:28 +0000
Received: from DB5EUR03FT047.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:16:cafe::76) by DB6P18901CA0007.outlook.office365.com
 (2603:10a6:4:16::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend
 Transport; Thu, 26 Nov 2020 15:05:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT047.mail.protection.outlook.com (10.152.21.232) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Thu, 26 Nov 2020 15:05:28 +0000
Received: ("Tessian outbound d6c201accd3c:v71");
 Thu, 26 Nov 2020 15:05:28 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8daae7a8d65f9c90
X-CR-MTA-TID: 64aa7808
Received: from 1d9a9ad880bd.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 8682FF21-F154-4805-B19B-BDE0512CFE79.1; 
 Thu, 26 Nov 2020 15:05:19 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1d9a9ad880bd.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Thu, 26 Nov 2020 15:05:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yz3V3n0zn4JJKLRL6li/6ZFS0Bh2lugRlrfUgj9/uXpvCtIuxTrW9PO2/mI6XQ/FZJNuja9S9EVoDG7Rp3gIUU/CjgTtroGA5Z8vdE0yyaMMLWEI68Rhkmq5SkJad3niVQ6YJSJG5J2DUItY03VyxMdJMLKnOGDu0q3gTahNCAUvOu3F3pMJ0frFYGR05pasf2eAt42hg2+gD+ElwICjJbpWhIufimX03BdVSaz84A4vk4nWJRckS50RCVW62RYzV+vAyT32AX5ioE9jXoX2E+HZYuQeOmjeIuaZLz/JLNLVGAYY7Vwj0aitkcD726uDbIGWCBEedZ+M2dOtgVkw9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33BVEX6LrMkZjmioMrLzM57ZcF5mndEI3AGVu4Y6nC0=;
 b=eVhEqDbbkLU1vVznD6j7UTuzMYp+CMVJnhWW5A0bStIbUGmS6pSJnRL8zgsJA36igRpn8T879hquS45wBG8p3sCK/WKK4JO7m3Eks0nIIZ61WqZcvdmRivwIojLhyQTo4pKg5Mw73WRwPak/JhdPYR1hjxP8Od0GYSwWkTH7X1sODPGAXgJpMeUUzotufl/KpZsnefxAgg2Vy2ZjBFA7hFysJkb67rIEOXI8R7zSP+zAhwkAuUIyL+S4BX5yl/OxV8zhyNTngdP2wwfado85sDqGbU7mH2Qi+BSRgGmk+6PfoeLuPiarakAPtR7uJo1TYIDUq76HaLVnQ0C5z+I9qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33BVEX6LrMkZjmioMrLzM57ZcF5mndEI3AGVu4Y6nC0=;
 b=qJrNBt/Yyk4EWRrkECG8riQHenxDfRnz2nOe4fzCq/sOGTQGTnygM2Csslg63yXRsOGrwlcNNzWG4iCryKb5P23O5W7TxLeSza8oW2OYp6PX+iWY/UdUdoU4Jwgan8JPg1SAgE6LalpcgHb6n/zkyL3CTO73urdAUOr5QTsybv8=
Authentication-Results-Original: android.com; dkim=none (message not signed)
 header.d=none;android.com; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DBAPR08MB5797.eurprd08.prod.outlook.com (2603:10a6:10:1a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Thu, 26 Nov
 2020 15:05:18 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::cd1c:8191:28c1:3212]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::cd1c:8191:28c1:3212%7]) with mapi id 15.20.3589.025; Thu, 26 Nov 2020
 15:05:18 +0000
Subject: Re: [PATCH 5/8] KVM: arm64: Remove PMU RAZ/WI handling
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-6-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <cb7ebedb-5525-8493-007f-72c81b16189b@arm.com>
Date: Thu, 26 Nov 2020 15:06:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
In-Reply-To: <20201113182602.471776-6-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [86.140.241.21]
X-ClientProxiedBy: LO2P265CA0295.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::19) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.110] (86.140.241.21) by
 LO2P265CA0295.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a5::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.20 via Frontend Transport; Thu, 26 Nov 2020 15:05:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 27a7d373-f41c-4982-74f8-08d8921cb60d
X-MS-TrafficTypeDiagnostic: DBAPR08MB5797:|AM8PR08MB5730:
X-Microsoft-Antispam-PRVS: <AM8PR08MB573074693CA6A084A2B3875586F90@AM8PR08MB5730.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: WDvIg8y9BT/XBQmp2a0hQ6vvfS+w+KAr+TTC81kgZI0CGOyCvA9QYnkXuq/dPTqsnrNOx73LFxBUzWTJRXBSGCtxLs8/Lp5wNFKB/6rPWKjoavSht2AMi06Fukl71IV+12LPpz529dR+jki+9Wd/03DrWVAgHQ6KdF94VPQVAnI1PALQ0LDd119u7J/vQcv9NNeTHacv7DVoidXDIUwxxSCUXP4P+aIEbWEmlaHkiNZobeHKoOY2sRlnce0miaHvwzsBos/8xl9L53Ljoidb6ahpIRlk1G2fJ54Gokm36D6XW9iNJwOFG0IGWU7ucYj4dcE6JppA0c/akYt4i+6XXSmo7JPocHM3cQCPUg9n0LWQ+/haPoHixEt94YWj9oIk
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:DB8PR08MB5019.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(4326008)(2616005)(44832011)(6666004)(6486002)(66556008)(83380400001)(66476007)(66946007)(956004)(478600001)(36756003)(5660300002)(16576012)(8676002)(52116002)(316002)(8936002)(2906002)(186003)(31696002)(16526019)(53546011)(86362001)(31686004)(26005)(43740500002);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Mlc0eEtPTkQvOEV6dS9mVlFoeUc4U0VUaUF4anAwUWFFeXFEdi9xZ2l4T2Ry?=
 =?utf-8?B?eW1RL294UHQwbGFHY2lxQTczNkZBWG43YlJZb2VvM0w4bFBaSlIyQzg5NDkr?=
 =?utf-8?B?ZjRrcThYQlRadW9wRm1KdW5OK3FiVExNQnY3ZEp2aHNmUnJCSFc5ckxIZHIv?=
 =?utf-8?B?dmJaMFhsdEMxWk5Tc1hVakdSVThHYjluM3Zod2Q1Nis2Z2FpTEIySXYrT2Ny?=
 =?utf-8?B?bURQUUpNWWVEbmkvZDN4QkR3Mit6QjlibVRJZTk4NmZpMlRmMlBFYytYUm8x?=
 =?utf-8?B?VEM2dUtMTFZTeUJ0R3JTV3VGYWRCVzVxVlpkRlJ4WUpROFRVdmZEa2NUTkZs?=
 =?utf-8?B?R1YyUXk3MDR0MmRqKzNTSEhCb1JkNXpzTUxJNUJHSU8wWE0weUxVUnVSUTZr?=
 =?utf-8?B?bytnUEc2Tmlsc3I5aHVVOWFlaGt5b09QNXE0YVFNQzQxb0kwbk9Cc2dGZFht?=
 =?utf-8?B?WkJSbDVUMDl1bEo4cHQybC9ZT3lTMHBrWDVxcWtjcFA1SmUwY3kyMXh4YlFm?=
 =?utf-8?B?bm52WGZPZjNBSGtYejJwM3ptOWFUQVdBVk9GUUJBRmJXZXVGZ3dFcjJwb1Zk?=
 =?utf-8?B?NGFMbnQ1YjNoVUpxMURjeUZqWndEZ1ZpaWVJdmhIUi9UTE4wNzJ5U2hxWkwr?=
 =?utf-8?B?NjQ3bDVBNWRyTEVmNjU3bFZxbGJ2SHpCVjFSNTFsQTlpaml2MWsyM1gwbjJq?=
 =?utf-8?B?dEZ0d2pGT2VJNU1SLzJEdnM1R0todWgvSEhtazZlTUtlY2laZW1GV0l2bmYw?=
 =?utf-8?B?RXBuREI5ZmM5NEF3NmhFS243Ri9vaGE4dXYvMDZSVXlqSXFSMWp5VlZ1LzQy?=
 =?utf-8?B?SmJBRDJMM2pscXF1V0lFSlRETTlUUFVFNGRzUDZ2M1g3SzMrQ3BsUm9zWk1j?=
 =?utf-8?B?VWRmWXQrN0xDeklCdVY4Q1hRbWpBVk93cE5od3NSNUNsOU1hbzU4Wk1BbHlu?=
 =?utf-8?B?U21ETGpQYmF3ODd5aHhwYkhNcExzMytubUM3Um9kNURsTXhuMHJBeUYveHk2?=
 =?utf-8?B?Z1E5dDAvUDZpWmQrRlhvclFzWXprUi9lbi9HRkNqd1RtUzlTTWJhSVp5OTNU?=
 =?utf-8?B?QWxtdzJYMGN5dDRNYTNhLzBaTGNhdWIvV2QxYlZpQzNJTVJlckhuU2h4TE0z?=
 =?utf-8?B?dTVRTXpFVk9pb2ZNT1JaVXVGR2lweE0xbjBmc0ovaHJGYWdaVStoRFE3cWxK?=
 =?utf-8?B?RGs5aW82WHgrV2V5SkxlV3RHbnJMVmJ0SDJmc3pYZTUwSFZ5V2xUSnZLTWFJ?=
 =?utf-8?B?YUlqNWtzZDhNT2owZ203TnNBS2h5UUtqMDA2OXcyeHNVT3l5b0U4QThEYWdq?=
 =?utf-8?Q?9XjH9upSLFvlYeSU3X+6mebY/fLclF1Uqi?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5797
Original-Authentication-Results: android.com; dkim=none (message not signed)
 header.d=none;android.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT047.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: de219156-1977-4bda-fad6-08d8921cafad
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJsMkxNtu4+pb66mAyjE44HcK6Fiahe7tjR/YzwbDVnR5xfrVvuH84WoPjQyJYnzJgOCX31SnKo03dCfitODNUXzvwHbJ4cIBS/PGvr9ibM11Z+Ja+sraOKSD04RBoLxVO4anWRkXrk5EaL/7VEYj/I1+5eXZJwgSOzQwMEu9LRVQ9qVzHab1WC9rdeomQq2KzBs0XrpmZQtfpDCEMAjlXSOFJ3dWjPa48fP26p8471YUYovRdzMpPLSLFujzMh39Ww++Wpa5B5v+uDQqOb4yMV964286HZGyKgZb38DdfAtdlBXz0aAHr7G4NZL+43Iui+q2MJrhCjgJqMMo2ibgJXFwnN0YTqkkANW7yaCXGX6jLqjtg0c+PzIq7KWDKcnWhWOifitrfMIZ4l2IGp07HzJoKUoVQ9kzr8JJa+wMzGYDcngu7erf5jC46+yh8ML
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966005)(6486002)(31686004)(956004)(2616005)(8676002)(336012)(70206006)(70586007)(5660300002)(107886003)(53546011)(2906002)(6666004)(31696002)(81166007)(83380400001)(82740400003)(8936002)(47076004)(356005)(82310400003)(16576012)(26005)(4326008)(478600001)(316002)(44832011)(16526019)(86362001)(36756003)(186003)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2020 15:05:28.3930 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a7d373-f41c-4982-74f8-08d8921cb60d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT047.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5730
Cc: kernel-team@android.com
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

This patch looks correct to me, I checked in the Arm ARM DDI 0487F.b and indeed
all accesses to the PMU registers are UNDEFINED if the PMU is not present.

I checked all the accessors and now all the PMU registers that KVM emulates will
inject an undefined exception if the VCPU feature isn't set. There's one register
that we don't emulate, PMMIR_EL1, I suppose that's because it's part of PMU
ARMv8.4 and KVM advertises ARMv8.1; if the guest tries to access it, it will get
an undefined exception and KVM will print a warning in emulate_sys_reg().

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

On 11/13/20 6:25 PM, Marc Zyngier wrote:
> There is no RAZ/WI handling allowed for the PMU registers in the
> ARMv8 architecture. Nobody can remember how we cam to the conclusion
> that we could do this, but the ARMv8 ARM is pretty clear that we cannot.
>
> Remove the RAZ/WI handling of the PMU system registers when it is
> not configured.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 30 ------------------------------
>  1 file changed, 30 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b098d667bb42..3bd4cc40536b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -643,9 +643,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  {
>  	u64 val;
>  
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return trap_raz_wi(vcpu, p, r);
> -
>  	if (pmu_access_el0_disabled(vcpu))
>  		return false;
>  
> @@ -672,9 +669,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			  const struct sys_reg_desc *r)
>  {
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return trap_raz_wi(vcpu, p, r);
> -
>  	if (pmu_access_event_counter_el0_disabled(vcpu))
>  		return false;
>  
> @@ -693,9 +687,6 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  {
>  	u64 pmceid;
>  
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return trap_raz_wi(vcpu, p, r);
> -
>  	BUG_ON(p->is_write);
>  
>  	if (pmu_access_el0_disabled(vcpu))
> @@ -728,9 +719,6 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
>  {
>  	u64 idx;
>  
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return trap_raz_wi(vcpu, p, r);
> -
>  	if (r->CRn == 9 && r->CRm == 13) {
>  		if (r->Op2 == 2) {
>  			/* PMXEVCNTR_EL0 */
> @@ -784,9 +772,6 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  {
>  	u64 idx, reg;
>  
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return trap_raz_wi(vcpu, p, r);
> -
>  	if (pmu_access_el0_disabled(vcpu))
>  		return false;
>  
> @@ -824,9 +809,6 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  {
>  	u64 val, mask;
>  
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return trap_raz_wi(vcpu, p, r);
> -
>  	if (pmu_access_el0_disabled(vcpu))
>  		return false;
>  
> @@ -855,9 +837,6 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  {
>  	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
>  
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return trap_raz_wi(vcpu, p, r);
> -
>  	if (check_pmu_access_disabled(vcpu, 0))
>  		return false;
>  
> @@ -882,9 +861,6 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  {
>  	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
>  
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return trap_raz_wi(vcpu, p, r);
> -
>  	if (pmu_access_el0_disabled(vcpu))
>  		return false;
>  
> @@ -907,9 +883,6 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  {
>  	u64 mask;
>  
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return trap_raz_wi(vcpu, p, r);
> -
>  	if (!p->is_write)
>  		return read_from_write_only(vcpu, p, r);
>  
> @@ -924,9 +897,6 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			     const struct sys_reg_desc *r)
>  {
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return trap_raz_wi(vcpu, p, r);
> -
>  	if (!kvm_vcpu_has_pmu(vcpu)) {
>  		kvm_inject_undefined(vcpu);
>  		return false;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
