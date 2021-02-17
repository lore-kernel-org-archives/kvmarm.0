Return-Path: <SRS0=BQox=HT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5847BC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 17 Feb 2021 16:29:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A3B0664DE0
	for <kvmarm@archiver.kernel.org>; Wed, 17 Feb 2021 16:29:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3B0664DE0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16F954B598;
	Wed, 17 Feb 2021 11:29:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id boHO2nZjQxhq; Wed, 17 Feb 2021 11:29:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D037C4B5A1;
	Wed, 17 Feb 2021 11:29:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C76124B5A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 11:27:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5C7JZNntVS3E for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2021 11:27:28 -0500 (EST)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60081.outbound.protection.outlook.com [40.107.6.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5EF54B598
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 11:27:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGXj2UHiqLgaM+AzohHWDrL/jxqFuNy0NOeRr+qfBB4=;
 b=WOyCpwFR+mMeb3o59tMtZKOm3sbaoskR4+qFwg9VXo3DqeNCAp2yr5rIqCOjK7OCKuGD0AHmcYJbHc3q/Vdgy4WADsSZyQ8mKsOn5rcUeqRziB3E3oDCVL0DkL2XLoqLbI152U39FTJzKeoG+P7XoWvpVsYgg/X9OXi1C4jXr70=
Received: from DB6PR07CA0079.eurprd07.prod.outlook.com (2603:10a6:6:2b::17) by
 DB7PR08MB3465.eurprd08.prod.outlook.com (2603:10a6:10:50::13) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.38; Wed, 17 Feb 2021 16:27:25 +0000
Received: from DB5EUR03FT022.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:2b:cafe::ec) by DB6PR07CA0079.outlook.office365.com
 (2603:10a6:6:2b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.12 via Frontend
 Transport; Wed, 17 Feb 2021 16:27:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT022.mail.protection.outlook.com (10.152.20.171) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 16:27:25 +0000
Received: ("Tessian outbound c07266d0ef38:v71");
 Wed, 17 Feb 2021 16:27:25 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: fb0c2897f460c740
X-CR-MTA-TID: 64aa7808
Received: from 431922f5d27a.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 B66FD966-BCDB-4F3A-B380-78F4B8205ECE.1; 
 Wed, 17 Feb 2021 16:27:19 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 431922f5d27a.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 17 Feb 2021 16:27:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GigsYGxgcHIwHcTOHINM5K3z794F6oj+WOPmJELVXIWKnr9aOAG4zbGo2EL6t/oFcQKji08LgZprgPkeHxwUCfIi1dVx3lrzzIylKrAUHvvpCzuPGDwkCVbMzteFJiCt6AcvA+85X5SIeQnu+zKfS/pjCzxtmjtsQub5LKvZGiBycabgVo+hTT9k1/VYLXhMfotTylmuXWO97MW52s0UqjEhj7sNppBevVD4WBQhquwJpWJZC6numsO9vAYXovVRlq0ZxxaFQRxOpBIP3Fsib0e0XX7cPzc3hT9O3M0iEiA0ged8yKT6ksBBczXUUrRYSwYQKuts94tMqFYKlQ3m+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGXj2UHiqLgaM+AzohHWDrL/jxqFuNy0NOeRr+qfBB4=;
 b=Ih2NDpqxC4lSi+Jg6gFjjV9bl+rI3UXuDn4cPjzI5seGw8YH9zqD77dRCMX9HknlstMLWu2ezq1Oo3Y1UHrTQX3aEmPoJrtjXQgN5csJo8eRjMETM33lpiU+dWY35hk7rwxZOVtxguuQzif+0IxqyWNqZtl8efQKWe2m8H4RKkv69L9jiqraZj089FghDAzpsCzMAQ7VL8+y26tJ8JTOwitHuJe2Sql6FxagPFXb1AgqQVVizpxq8ocHwO1g/DgmagvXQmaiyyA6etb0nEUMF1UgyRVJxnXSR9Y0KqjfO5GRqTGuZ5StEKHLZmNrtBxWp1rDtv8mm653ukfIPO2qiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGXj2UHiqLgaM+AzohHWDrL/jxqFuNy0NOeRr+qfBB4=;
 b=WOyCpwFR+mMeb3o59tMtZKOm3sbaoskR4+qFwg9VXo3DqeNCAp2yr5rIqCOjK7OCKuGD0AHmcYJbHc3q/Vdgy4WADsSZyQ8mKsOn5rcUeqRziB3E3oDCVL0DkL2XLoqLbI152U39FTJzKeoG+P7XoWvpVsYgg/X9OXi1C4jXr70=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3568.eurprd08.prod.outlook.com (2603:10a6:803:7f::19)
 by VE1PR08MB4736.eurprd08.prod.outlook.com (2603:10a6:802:a6::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 16:27:11 +0000
Received: from VI1PR08MB3568.eurprd08.prod.outlook.com
 ([fe80::c91c:227a:cba9:456e]) by VI1PR08MB3568.eurprd08.prod.outlook.com
 ([fe80::c91c:227a:cba9:456e%6]) with mapi id 15.20.3846.038; Wed, 17 Feb 2021
 16:27:10 +0000
From: Mate Toth-Pal <mate.toth-pal@arm.com>
Subject: Re: [RFC PATCH v2 00/26] KVM/arm64: A stage 2 for the host
To: Quentin Perret <qperret@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Rob Herring <robh+dt@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>
References: <20210108121524.656872-1-qperret@google.com>
Message-ID: <18756e24-ca87-9c98-0e20-7c7a4c4d5433@arm.com>
Date: Wed, 17 Feb 2021 17:27:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Content-Language: en-US
X-Originating-IP: [188.142.195.117]
X-ClientProxiedBy: LO2P265CA0264.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::36) To VI1PR08MB3568.eurprd08.prod.outlook.com
 (2603:10a6:803:7f::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.45] (188.142.195.117) by
 LO2P265CA0264.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:8a::36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.38 via Frontend Transport; Wed, 17 Feb 2021 16:27:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45a71414-8801-4c79-e2b9-08d8d360e902
X-MS-TrafficTypeDiagnostic: VE1PR08MB4736:|DB7PR08MB3465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB34655B2F90292E32AA52A41EAF869@DB7PR08MB3465.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: GlU2MrG9Uwcq8qM2M1RFvPLBzBwAsMf+CeLvHOz8kH+VQIt6yhyA5fVrspYWU5reMyDBpwUI9/nyGZzmDpRB4WrlNzwcjFpIFPvFf3821DCoCLnCqw3bTlO3z97uurEb9oxkL8jV6bKnBJSzlADROR8Ljbr5i8P66zNjE7pW1NsbCKnQDq9fOxpemTAmVb5DbC3aihP1X7j3MYCN/YZPhZRwR6SAPP1K57TU9se+oSr3YSlb1AhqMcn4rNGVGPdxjiZOqpQoCWehHkuSuJI0MqAxuZMAq3SLmqGzh+bTF7WBqIPXltZ3+BU3AB6S0L8f4i/gFsE3ffNGWudMht00xUjd4PAgarwR+6hdJetBnnGDyYCMtLzStYmq0+YRKzpdxZZ5IIfjEcxKngr7tAeMRDV7695DLIyzI7VGHOeHvQ+8QKtBu4Ee9um7yrhGOOH4/zxj0t9BS6m2jJlLNMyBXu2Zx13XjJy6nW1Tqhu/97jqWpRu46U0CPgeAE+YC6ml1poJ5F8W/Qacz71XleC63ttSQkEeOHdWiyYGRg0NN7YYurRdBr8A6wWTPGz4uJmoHQ2wi5c8u9/FKzWdV75pfiluZ0tIB1UuG9d7AHjcHA1RHJhlBpueoQ7fJVi2galqXlYmC4LNP6Kyj5HHDaxARqHNRi+Y8dY+sjtrWbDBhvHegFOqk/Oc40vl+Fe4UteC
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VI1PR08MB3568.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(26005)(31686004)(2616005)(6486002)(956004)(186003)(4326008)(55236004)(53546011)(16526019)(2906002)(8676002)(478600001)(966005)(66946007)(8936002)(5660300002)(31696002)(86362001)(7416002)(316002)(36756003)(66556008)(16576012)(110136005)(54906003)(66476007)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Zmh3Y1RlcWsxYmp0WGFheTBUbDFkQk1HUjBQSS9uL3dKMk03Q1FQRklIdVZn?=
 =?utf-8?B?UHgwTTBYSTJ6d3pmK3pBVmRId1NJZXhPUnZvZUpvTHVycmdTZ1Jna0VHQjIr?=
 =?utf-8?B?ZGVRU3J4blZ1L0tuM1RPaEkvaFFrYTVmWnpnSmlkd1UzaSs3VzBxbGFZMC95?=
 =?utf-8?B?RExlS0ZIWlFzVmdxQnhzSW42U0VLVlhDT3diY09zQkQrOU9tdHppREJOZnBE?=
 =?utf-8?B?eGVQaWVyRUhwd0VrWXRHS3ZSOFhmZksxN0VJbXpUK2NDcVZlbVVzMlpRRWp4?=
 =?utf-8?B?SlJmeGlWR29YS0xod1NZd2pjR2U5ZnJrUXRKZjJ1amRPc2c5VkZYK1dDeGla?=
 =?utf-8?B?dG5LTzhYUUh5T0RsSWRxVkVVbWFocU1iNUVRSTZLZkhlem03djdoNWRQSGlS?=
 =?utf-8?B?V3kzT3dhMkpYNDlpNWdMdkt3ajBjUjVVeXhFeW41M1hzb3ZFTzZNcGpHc2Rr?=
 =?utf-8?B?WFEydmVIUC85enZJd3BVN3NHT2NESzU4UXhKQko2aGdQS29qQ2ZFTlVxTWph?=
 =?utf-8?B?Nm96RXFZS0h2T3BTOGh3Z2lQcHBwcFF0elIzL3plalBxaWQ3ZmowdEl0SXpn?=
 =?utf-8?B?OU1KNVVtR0J4S1MzSG1XMUNobE1LUmVkTHdCTmJsSlZxdlNWWjIrSzJ4cENW?=
 =?utf-8?B?ZzUwMWFjc2syTmVTdW1yS2p2UjhrODlIUGZXYkZXVml5eTZFRWFROElDd2dU?=
 =?utf-8?B?SkRpTjFjZmxJZ1djd1Qxd2JwWWpKSUdMQTJIMzdibGRuQWNjVXhFaVFXd3J5?=
 =?utf-8?B?WVdXaXl2N2s3OUFLSzcxb2tsQTROQk15cHJSek9qamZRTSt1RlNXQlhETWtE?=
 =?utf-8?B?YmlCK0NiS1F6dkE5cW0vMDRqQ1NQbWhleGtNanVDU3Erb2FLUVQvT3RNNWtB?=
 =?utf-8?B?YVIrVUxpR2tuUDhwMWg0Y2M1cnJwVDRVYzJ5dnV0VnhWWStLSXora0hQMldv?=
 =?utf-8?B?dHhheVhTSWtsa25sSEhyM0IwbjJKTUxkclJBVWxyZFcvTHpsUWQxSUphZ0dH?=
 =?utf-8?B?QVFCbGxTTnRONFhaTHFiZkFvQW5RdnRldzhpK2hHWFBSc1FGQ1VmNm9oSkFh?=
 =?utf-8?B?UzVFcmVjUGVDTHY5Y3E5WTVWeEJJK1ZyY1pYRDJaSzJYU2VaSHo1ZWRmTURs?=
 =?utf-8?B?NjVmQ2x6czl3RmZaSjFOWVpBeEQ2SnpqbEJrSFJDVUNtUjN6MWZ0WGRCRHRs?=
 =?utf-8?B?Sm5jVUdPYTFQcktlWlYvWkU1VFNlNzR5ajZtQ1JCc0t5cWpzUS9FbDJLRTBm?=
 =?utf-8?B?YnhveHZxUyt5VTMxdDFRRjVSa2p0dTJTNXI1SDhock1Kd3RqTE03dElhTEE1?=
 =?utf-8?B?U2x6bS9XbHVrV0dzN1Q0QXZZRGthZlFHamVPSDJOSlkxZ1dxTmYrOVZnRkd5?=
 =?utf-8?B?K1o1ZVA1K09MRnkyRWdsRWk3SHlFdDJ3dGFKaklHaVlkbjJkVWd5RmFuemlQ?=
 =?utf-8?B?REZmUlR4VkNlOWRoZldLeEVYSmNHL0R4ZlVlalh0LzZRazloVGVDUVJLa3d6?=
 =?utf-8?B?TkF0d2RHcWlEVjVQQ3RwSXRsU3hMc3BzVDVWVmVzVDFicU54SFFNNlQyTjZO?=
 =?utf-8?B?Tk5DSWx0dkVkTE9jV2lQVFFDQnBuN1hydXMwZS8wNVNtdVhLOTJWK2RzSlJG?=
 =?utf-8?B?eVhOTmNoWk5iVzFFSWhPUVRmZmVPa3RidXlQd2plTXM1R2ZrYkRkbllCT0w3?=
 =?utf-8?B?L0NHaWJEbGI0OUNaaXNkRzZqcndNSE00MVIvVXdTOHRzUkFaQkd4VjNwbmhP?=
 =?utf-8?Q?Y09jMpFgayyPMn2+yXotHLGSb40o7vhoWcV7cgO?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4736
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT022.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 51ecbf98-f2d5-4982-07d0-08d8d360e012
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0eBeLa9mNsp5TJoEPrUxlyPlZBenokruwcsLeeAB3J15AeOvA+LYAvblsEZz0pip3E7f8Q+YRtO9dB53UOtDPYLHEfGFn0b2aAThD4lG0EZqm+TFRhonSf8xIqrYG6sXKhzsOgDQ2su4zN4+J+wWeB6BwmiUfVjsWqVpG8BsZlDzfC/WKnih3pVWJ8AZ7d+dzshXshKC2ZuApTT14EmdSYuaH3lT9iDNwRGfz0amcxT847HLLDKeFHBOpFzCUgevK6IFNBTduNPmiqBmyZDg1Lh64SFl37Y37jcCU0G0ReLQe5oTtqzwHFhIJrmZI8FngXsbXIPfqKUwySVzEj9fVsZ7UEZBAngjKGmFiBDJTuSnbpl8Mvwozsl4V++VjySWIpCco6kEUY69O2JkzEw1thEcbx2zmgrKGJuJMfPHTDy/Ua3iYFdq31zS6icnFUloE4s5tgy9QyKMXpS1meWsI0VtXcpf+lM1LpGSfFkaLEaASCmgfFmdWfBG+t6/1CMiKTJgl3duUlFuM4ae2XHTetR5hauz7lA6TPkkscNin/V3Pw9ouDTdiTwiQRlefqTAVEVXxH5g0WUwOFzWzSN1Jbg5Hk4T1Il0T2thL9h6HA5a4uxjFysU36ZOdD1QxFLQXwrDWkUnl00KP76R1FgPIg2df7maYPYriLYdB6iLcMB0WDS4xrLcMeHB0BPeCAdKdKDELVCY/m6zHLV5vIyq2hqH5bZOJ/2bA61dfC7rP9/lLiPICOcWrgiobyRASPs8R8e8MSwll52Jv87wzgIt7g==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(36840700001)(46966006)(6486002)(70586007)(70206006)(54906003)(26005)(36756003)(82740400003)(16576012)(966005)(31686004)(2906002)(110136005)(316002)(186003)(4326008)(47076005)(8936002)(8676002)(5660300002)(86362001)(16526019)(82310400003)(81166007)(478600001)(356005)(956004)(36860700001)(336012)(53546011)(31696002)(55236004)(2616005)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 16:27:25.2456 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45a71414-8801-4c79-e2b9-08d8d360e902
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT022.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3465
X-Mailman-Approved-At: Wed, 17 Feb 2021 11:29:38 -0500
Cc: devicetree@vger.kernel.org, nd@arm.com, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgUXVlbnRpbiwKCgpPbiAyMDIxLTAxLTA4IDEzOjE0LCBRdWVudGluIFBlcnJldCB3cm90ZToK
PiBIaSBhbGwsCj4KPiBUaGlzIGlzIHRoZSB2MiBvZiB0aGUgc2VyaWVzIHByZXZpb3VzbHkgcG9z
dGVkIGhlcmU6Cj4KPiAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm1hcm0vMjAyMDExMTcx
ODE2MDcuMTc2MTUxNi0xLXFwZXJyZXRAZ29vZ2xlLmNvbS8KPgo+IFRoaXMgYmFzaWNhbGx5IGFs
bG93cyB1cyB0byB3cmFwIHRoZSBob3N0IHdpdGggYSBzdGFnZSAyIHdoZW4gcnVubmluZyBpbgo+
IG5WSEUsIGhlbmNlIHBhdmluZyB0aGUgd2F5IGZvciBwcm90ZWN0aW5nIGd1ZXN0IG1lbW9yeSBm
cm9tIHRoZSBob3N0IGluCj4gdGhlIGZ1dHVyZSAoYW1vbmcgb3RoZXIgdXNlLWNhc2VzKS4gRm9y
IG1vcmUgZGV0YWlscyBhYm91dCB0aGUKPiBtb3RpdmF0aW9uIGFuZCB0aGUgZGVzaWduIGFuZ2xl
IHRha2VuIGhlcmUsIEkgd291bGQgcmVjb21tZW5kIHRvIGhhdmUgYQo+IGxvb2sgYXQgdGhlIGNv
dmVyIGxldHRlciBvZiB2MSwgYW5kL29yIHRvIHdhdGNoIHRoZXNlIHByZXNlbnRhdGlvbnMgYXQK
PiBMUEMgWzFdIGFuZCBLVk0gZm9ydW0gMjAyMCBbMl0uCgoKV2UgdGVzdGVkIHRoZSBwS1ZNIGNo
YW5nZXMgcHVsbGVkIGZyb20gaGVyZToKCgo+ICAgICAgaHR0cHM6Ly9hbmRyb2lkLWt2bS5nb29n
bGVzb3VyY2UuY29tL2xpbnV4IHFwZXJyZXQvaG9zdC1zdGFnZTItdjIKCgpXZSB3ZXJlIHVzaW5n
IGEgdGFyZ2V0IHdpdGggQXJtIGFyY2hpdGVjdHVyZSB3aXRoIEZFQVRfUzJGV0IsIGFuZCBmb3Vu
ZCAKdGhhdCB0aGVyZSBpcyBhIGJ1ZyBpbiB0aGUgcGF0Y2guCgoKSXQgdHVybmVkIG91dCB0aGF0
IHRoZSBLZXJuZWwgY2hlY2tzIGZvciB0aGUgZXh0ZW5zaW9uLCBhbmQgc2V0cyB1cCB0aGUgCnN0
YWdlIDIgdHJhbnNsYXRpb24gc28gdGhhdCBpdCBmb3JjZXMgdGhlIGhvc3QgbWVtb3J5IHR5cGUg
dG8gCndyaXRlLXRocm91Z2guIEhvd2V2ZXIgaXQgc2VlbXMgdGhhdCB0aGUgY29kZSBkb2Vzbid0
IHR1cm4gb24gdGhlIApmZWF0dXJlIGluIHRoZSBIQ1JfRUwyIHJlZ2lzdGVyLgoKCldlIHdlcmUg
YWJsZSB0byBmaXggdGhlIGlzc3VlIGJ5IGFwcGx5aW5nIHRoZSBmb2xsb3dpbmcgcGF0Y2g6CgoK
ZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhlL21lbV9wcm90ZWN0LmMgCmIvYXJj
aC9hcm02NC9rdm0vaHlwL252aGUvbWVtX3Byb3RlY3QuYwppbmRleCAwY2QzZWIxNzhmM2IuLmU4
NTIxYTA3MmVhNiAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vaHlwL252aGUvbWVtX3Byb3Rl
Y3QuYworKysgYi9hcmNoL2FybTY0L2t2bS9oeXAvbnZoZS9tZW1fcHJvdGVjdC5jCkBAIC0xMDUs
NiArMTA1LDggQEAgaW50IGt2bV9ob3N0X3ByZXBhcmVfc3RhZ2UyKHZvaWQgKm1lbV9wZ3RfcG9v
bCwgdm9pZCAKKmRldl9wZ3RfcG9vbCkKIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBw
YXJhbXMtPnZ0dGJyID0ga3ZtX2dldF92dHRicihtbXUpOwogwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHBhcmFtcy0+dnRjciA9IGhvc3Rfa3ZtLmFyY2gudnRjcjsKIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBwYXJhbXMtPmhjcl9lbDIgfD0gSENSX1ZNOworwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoY3B1c19oYXZlX2NvbnN0X2NhcChBUk02NF9IQVNfU1RB
R0UyX0ZXQikpCivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBw
YXJhbXMtPmhjcl9lbDIgfD0gSENSX0ZXQjsKIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBfX2ZsdXNoX2RjYWNoZV9hcmVhKHBhcmFtcywgc2l6ZW9mKCpwYXJhbXMpKTsKIMKgwqDCoMKg
wqDCoMKgIH0KCgpCZXN0IHJlZ2FyZHMsCk1hdGUgVG90aC1QYWwKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
