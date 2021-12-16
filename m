Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5151C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 17 Dec 2021 10:56:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 431ED4B2C6;
	Fri, 17 Dec 2021 05:56:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(invalid, public key: not available)
	header.i=@amperemail.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y5osY11QfbAO; Fri, 17 Dec 2021 05:56:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25F6E4B2A7;
	Fri, 17 Dec 2021 05:56:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F97C4B21C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 18:33:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BUyPKxdgxxaX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Dec 2021 18:33:18 -0500 (EST)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com
 (mail-bn1nam07on2116.outbound.protection.outlook.com [40.107.212.116])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CCE84B1D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 18:33:18 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5aTp5oPfqEDzjC3pvVFm6nBIBdSceoxzYzFnVSlDT4aCADxSDayEUBIVphxRWxpxL7+QHDURxGh3VRRb7kYsv0GiTM4wxZVUQt0MuEw8AZW9jSse9Y7BFtIsUlGxBzp4F5v5pn0cbERMCkWsdki1AxZLOZDuTqO3SWvq8AgFfnZ7iCqW1/w+fwJjfUDqmH++cweqF/mcT6i4NoykIJa1yEveEuvyXEnxWBSn21yOA/Ozd3x7Vkc2205wNJd21XyZH9HfBrMVhlTKp5Sk4f31b58sXhjXsgNk6FinQ5KRqf25L2nHzk5mTe3hcVTNyeaz78+3dvs17Iz4Z6A/0+BCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibAQDggaQVso1YbpDoD8grnwzd+2xLbMe/l0oh+qJ0Q=;
 b=On0ff5G/zevPWvEYClZjuL+LWcmwAUHF4Z95/Q09wZ0xN1lO4j+XiGSm2+2T7b6j88aM31l92pcvaipNeFi7UIHaUuaqytvdn54NYcldq/xf5D/dLylazAdRdGBJRwhVU/UFoLk0oorgfXrDVZz5Edtvi17DcgJjAO8CUmHCnL4IAqiAmri4LRo1SsgCkH6tG645F8Cm+uS9kCiIoWjYdV6H8lPQBI8rNbuMIZZ4vSNZh7wXLnubNMofqwgj1CsINIVYHWcP4xojTqS9oRajou2fnQy11zejRWsKB4l2eKBJhm15Bf71K52Brj1R6wQPp6w0SkEIfu5UexLEUtTsKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibAQDggaQVso1YbpDoD8grnwzd+2xLbMe/l0oh+qJ0Q=;
 b=HhhYUx9DSnXvpGkhWCYp3vmfgSlOJ57Jw5hMIfTWGVYKq9jMqkKRjQbPI4jNVmM1viTUnzSxd/2DFL86JGM4clYkmA2TXke5dP3GgU+oPIV8c/w2sBFH+WFmTHrniY4+rSJD7ZFdiUhtmUJK2Sfwlus3ET1aLQI0QjAzkEk4W2Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from CH0PR01MB7033.prod.exchangelabs.com (2603:10b6:610:107::16) by
 CH0PR01MB6889.prod.exchangelabs.com (2603:10b6:610:102::9) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.16; Thu, 16 Dec 2021 23:33:16 +0000
Received: from CH0PR01MB7033.prod.exchangelabs.com
 ([fe80::c8fb:e830:d7e5:bdf7]) by CH0PR01MB7033.prod.exchangelabs.com
 ([fe80::c8fb:e830:d7e5:bdf7%9]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 23:33:16 +0000
Message-ID: <9330bbfb-d016-0283-a5ed-e2f4d5446759@amperemail.onmicrosoft.com>
Date: Thu, 16 Dec 2021 18:33:11 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/2] ACPI/AEST: Initial AEST driver
Content-Language: en-US
To: "ishii.shuuichir@fujitsu.com" <ishii.shuuichir@fujitsu.com>,
 'Tyler Baicar' <baicar@os.amperecomputing.com>,
 "patches@amperecomputing.com" <patches@amperecomputing.com>,
 "abdulhamid@os.amperecomputing.com" <abdulhamid@os.amperecomputing.com>,
 "darren@os.amperecomputing.com" <darren@os.amperecomputing.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
 "guohanjun@huawei.com" <guohanjun@huawei.com>,
 "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
 "rafael@kernel.org" <rafael@kernel.org>, "lenb@kernel.org"
 <lenb@kernel.org>, "tony.luck@intel.com" <tony.luck@intel.com>,
 "bp@alien8.de" <bp@alien8.de>, "mark.rutland@arm.com"
 <mark.rutland@arm.com>, "anshuman.khandual@arm.com"
 <anshuman.khandual@arm.com>,
 "vincenzo.frascino@arm.com" <vincenzo.frascino@arm.com>,
 "tabba@google.com" <tabba@google.com>, "marcan@marcan.st"
 <marcan@marcan.st>, "keescook@chromium.org" <keescook@chromium.org>,
 "jthierry@redhat.com" <jthierry@redhat.com>,
 "masahiroy@kernel.org" <masahiroy@kernel.org>,
 "samitolvanen@google.com" <samitolvanen@google.com>,
 "john.garry@huawei.com" <john.garry@huawei.com>,
 "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
 "gor@linux.ibm.com" <gor@linux.ibm.com>,
 "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
 "tmricht@linux.ibm.com" <tmricht@linux.ibm.com>,
 "dchinner@redhat.com" <dchinner@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "Vineeth.Pillai@microsoft.com" <Vineeth.Pillai@microsoft.com>
References: <20211124170708.3874-1-baicar@os.amperecomputing.com>
 <20211124170708.3874-2-baicar@os.amperecomputing.com>
 <TYCPR01MB6160D05580A6E8C9510D25A5E9709@TYCPR01MB6160.jpnprd01.prod.outlook.com>
From: Tyler Baicar <baicar@amperemail.onmicrosoft.com>
In-Reply-To: <TYCPR01MB6160D05580A6E8C9510D25A5E9709@TYCPR01MB6160.jpnprd01.prod.outlook.com>
X-ClientProxiedBy: CH0PR03CA0415.namprd03.prod.outlook.com
 (2603:10b6:610:11b::26) To CH0PR01MB7033.prod.exchangelabs.com
 (2603:10b6:610:107::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48bdbc92-aff1-4976-15ac-08d9c0ec6eff
X-MS-TrafficTypeDiagnostic: CH0PR01MB6889:EE_
X-Microsoft-Antispam-PRVS: <CH0PR01MB688961AB48AB9A38CCC1FEACE3779@CH0PR01MB6889.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QAkvjVMQO7xkxa6wkLFzQNbV5wSdO0AAypyrL14/wBAUWHP/SU1QPwG0afUH8Zmga4/5PGyzI64fnUMICROFU1Jm6FP58katyDh+BeY8xE3/jfU3+QxIuU5iLMWZEKmEL875UgjbfIAlZJWdujbW/BXTANqdJNjY5vv3xvjj2z8rewkTYbkAG2ueCi9Cj48AH+4CuAUX5xN8f1kfOW7xqVgraWRdaXROxhLN1lnrCiKHXJZsWJ3uhZFDvGk+2bA/PlBxYEbEdldaWjZpZ7rBHs3L4rwtrs3rmiXThOtvyh6YWc83yIElbpuFWmTHfIRIeT6f5zBhtKCp5v64tiQ8mqJKqvtjp2aammLnKjNOwLVTETaCNhjKmjkCTCV4CfugtoaLIY6d5PVeiSdYkiDVZkXw0+28mvF9ECajE3WYOsy9t2Olb4h+fw5IOYyWCkP0MY7S9gEygdgeG9pD0C5kdSP0Wceb4a9K/gu77Nu8A1Ap7CIPrX86dsw8QmQX2j1QwO5bqtu0kXyp7JzKKdiTi2LqjtZiHzT4ld+Zh8GADuAxMQ23VTevJdp1PjghWCgk6Y4b/aho0FwXp21tDAlyXreXxFCuyVyQ7nuBvNW7bPtYrfCtkTvVCN/IfoMdwe6qUr4KiWHgdjreenrwxJFKVuINwL+xYDkWc8rHj+WOufYo4M731wkMu+JkPuXyByh6EkOhI0YFc4DQgS7QzgrM1Pcd6zJpDEEc4NxO5lN+T2Qb0rPD6rkrjNaJa2VIZxeP
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:CH0PR01MB7033.prod.exchangelabs.com; PTR:; CAT:NONE;
 SFS:(4636009)(366004)(66556008)(5660300002)(2616005)(26005)(38100700002)(83380400001)(66946007)(6506007)(921005)(6512007)(38350700002)(53546011)(6486002)(83170400001)(110136005)(31686004)(66476007)(2906002)(316002)(8936002)(6666004)(8676002)(52116002)(7416002)(186003)(31696002)(508600001)(42882007)(7406005)(43740500002);
 DIR:OUT; SFP:1102; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHphYXRmdjdPYTBGVWw2c1dwdFJkWlBhc3JiSGFnYWxrRDVSdlhVVGtmSk1h?=
 =?utf-8?B?MTlHWnVyQUJkcys3bjJKenZuS0NNNlhzSVFKWEZGVmdma1lIOGViM1VMWkpM?=
 =?utf-8?B?c3oyY1E0Qk5YR3pRZi9kRFpSM1UvcnRJaitCeGdLZC83enl1MkV0bmc1azkx?=
 =?utf-8?B?b0k4UGFpaHNHeHkzQUpzSkdOWFpGOUZVVm9WemlhZXJhaVdkK3JRcFJmOEJv?=
 =?utf-8?B?ZkhVU3E1cXFHbHpTaERUS2VtczFROVlXZDVyaVg4Z2RJeEFmQWVVcDV4TEND?=
 =?utf-8?B?SFl4bVgybldaZW9HZjMwVit4ZENjM1Rpcy84bDVSbmxEODQ0K1pjZml5dVc2?=
 =?utf-8?B?MkFRN2dqdnUyaWhQRkhJaFY0RHJsdzF0cUdtNFRvOWU0aFh1SDJ2WFNXV0tL?=
 =?utf-8?B?cDR2dVV1Qk9Dc1Ztdy9vMVNFWE1hVmFoYVkxMlNwTU1Hb1ZDS1JUSXpZU3Fa?=
 =?utf-8?B?WjRVVjBVbVRnbEQ5TTJuNFFldC9EZkoxVHYrWDNYanA1eklvVjk5WU1RUHFw?=
 =?utf-8?B?emE1aEFYb2Uxc3h2SlNxcUcycFpnd3hVdkVrdWxIcmlUNU0rM042bndoajc5?=
 =?utf-8?B?N0FOK1U4TGVici8vSDR2MmNiRmh1NlRqN09PaTduV0ZRSDlhNU95b1hTdHIx?=
 =?utf-8?B?WlUwT3ZQL1VhYjIxVW84Um5iZWRSWVk4SkllNlVJd0xsaG9jeEc3dStLc2dG?=
 =?utf-8?B?ZUU0R1o4UGgreXZha2FrMWlzZ01ndytjeDdDRFgzU0ZLOXZHL0VscXRnTzRM?=
 =?utf-8?B?b3FValRNcDJoZ0lNbnhsSGhtcFpZaHpIMCtadkdJTHdFZHozbzc1Y0kxNTVx?=
 =?utf-8?B?VjUzOEFWNlJNRVE4UFBuQ0hyd0h0ZWZLSGhSRmZJNlNqSkJGSml5NmxOV3FO?=
 =?utf-8?B?eWQ3cjVzV2VnYVpVQjZMMGx6VnVmSEJnL1RLUXQxNGNyeEk5dS93RnBJYzlK?=
 =?utf-8?B?YW81cFFQSGpNUjBPTTBlWVJHUHFwUlIvWk1pWHNUYjFUQyt2djdLUmE5NWtw?=
 =?utf-8?B?OFJNL3RNeGhGUXp4cm85Y3NVVTJNUDBIeHp3YzdqdUltOTNPb1ZXZWptM1Bz?=
 =?utf-8?B?dHUzL0RNS1Z6bEF6QjJBRTdvb0drSnlpMnYwNjNCVWUzb1JOUEg1ajlEZjRp?=
 =?utf-8?B?RW1tOGpNN05va09pUG5OZ3ZGU3BTV3RSMjJrWlpENTI0S0ZVWmdRZ210dWVL?=
 =?utf-8?B?alI4dU1CdG1RMmJ2cUFZeDN4eW5Tb1Z5TU5STzJLUHdsc3pmNndDZllrV0Jv?=
 =?utf-8?B?dXNnYzFZUTFBN3pLZFlJWXROSnFLWVZhNGp2dDR1SDk0QnA4djcvcGE0d1Rv?=
 =?utf-8?B?NWtKMVpNb1RyMmcwUmUza0hQaXE3VDZVK0JqYmlvZzlFUkxxVkJDVXg5Qnds?=
 =?utf-8?B?WnhuZnNFTnUrdWNFVWdCNStXV1I5elVFQkRUb3hnQXVnbHdnbFN0U0ZYaExN?=
 =?utf-8?B?R09KR1dQVnpabld2WW41WWlzNmVIclZZcDgvMkdoOVJpRDQ5U21BckN1bTN1?=
 =?utf-8?B?cEZWaHZTeDJpUWVtUkt1cXQ5RVJoZDFIV0dEZGhVSWswQlJOM21YWm1HQ3VH?=
 =?utf-8?B?LzhId1F0a2FxZzlsTlJ5TlFEb2VFYWI2N1ZkYmk3Z2tnOWJqRWxSckJGVmt0?=
 =?utf-8?B?VnkwN0VTMDhNdFR3cmkzUW9ISzhCLzNwREE2Zi9GWVp1VFBYSnRidjFEVW12?=
 =?utf-8?B?NnBzYWpsWVE0RFNWMUJyMTZPVE9RbnFySVYwVTlxTDNseEM5Y2lJa0hUOFBY?=
 =?utf-8?B?cXJLeCtJQk5KTHI0MTlldHRCK2JkYWtPK0M4Y3BUYlhWMEI4ZXdkY2g4U0No?=
 =?utf-8?B?b0dGKzcrME1hamxURUJtS2g5azgwMExNRWZ0aW1uWnpad3R1VkVUVGRWL0My?=
 =?utf-8?B?M1pVdFg0d2ZGajREclRzME1ZQThTU2RpMElhQ3diSUh6WDBwQzg3VUlmeWRt?=
 =?utf-8?B?Y1NSZWdhb2dUbkEzTCtxZXQwNVFvVW82YjE0eG43ZVpzOTkxKzBwUmtFbVdh?=
 =?utf-8?B?YUo2TnlsVElXb2hsT0U1RGx0VTNUZlRucUFkOHJMb0wrbFN5TzNabUVlTGZC?=
 =?utf-8?B?TndxYTdwMFkzTDhxcVBiTlVqbWNPNGhQa20yV0g2UGU3UzZJd1hEZURZNTht?=
 =?utf-8?B?aEJkWlBVMW1IZzVmSndTdC83dVl6UVk5RHA4TjlVTW5KVjN5aTVoQURXa3J4?=
 =?utf-8?B?ZUllVGJKcFBuQWdubHBsLzRYeVBjbGFOOE13VUtaNWVVTXYycEpPUVh3Z2Ex?=
 =?utf-8?B?dXh1WEg1V3hmNjduS09OSSt4MVFwZ3VlQTRMcVdqRFZqRWlDRE4xWGtoQThL?=
 =?utf-8?B?SWwvMitnMzBRYnM2WmpHc2I2UFBDVXYvdGpkbElndHB3SlVKMXhGZz09?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48bdbc92-aff1-4976-15ac-08d9c0ec6eff
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7033.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 23:33:15.9344 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rD4Rtnw0ekXcbHIh4lAeDZzJf5YUtgw8bbeHn2t0EupLtfHrLDf8x6/TmxGojWeQ7GvS7FC9VwFBgJ4uJIPRORlJECsow4RQhD/TNrF6kliJaw90SjcUMrCqxvEFHN3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB6889
X-Mailman-Approved-At: Fri, 17 Dec 2021 05:56:13 -0500
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

SGkgU2h1dWljaGlyb3UsCgpUaGFuayB5b3UgZm9yIHlvdXIgZmVlZGJhY2shCgpPbiAxMi85LzIw
MjEgMzoxMCBBTSwgaXNoaWkuc2h1dWljaGlyQGZ1aml0c3UuY29tIHdyb3RlOgo+IEhpLCBUeWxl
ci4KPgo+IFdlIHdvdWxkIGxpa2UgdG8gbWFrZSBhIGZldyBjb21tZW50cy4KPgo+PiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQo+PiBGcm9tOiBUeWxlciBCYWljYXIgPGJhaWNhckBvcy5hbXBl
cmVjb21wdXRpbmcuY29tPgo+PiBTZW50OiBUaHVyc2RheSwgTm92ZW1iZXIgMjUsIDIwMjEgMjow
NyBBTQo+PiBUbzogcGF0Y2hlc0BhbXBlcmVjb21wdXRpbmcuY29tOyBhYmR1bGhhbWlkQG9zLmFt
cGVyZWNvbXB1dGluZy5jb207Cj4+IGRhcnJlbkBvcy5hbXBlcmVjb21wdXRpbmcuY29tOyBjYXRh
bGluLm1hcmluYXNAYXJtLmNvbTsgd2lsbEBrZXJuZWwub3JnOwo+PiBtYXpAa2VybmVsLm9yZzsg
amFtZXMubW9yc2VAYXJtLmNvbTsgYWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tOwo+PiBzdXp1a2ku
cG91bG9zZUBhcm0uY29tOyBsb3JlbnpvLnBpZXJhbGlzaUBhcm0uY29tOyBndW9oYW5qdW5AaHVh
d2VpLmNvbTsKPj4gc3VkZWVwLmhvbGxhQGFybS5jb207IHJhZmFlbEBrZXJuZWwub3JnOyBsZW5i
QGtlcm5lbC5vcmc7Cj4+IHRvbnkubHVja0BpbnRlbC5jb207IGJwQGFsaWVuOC5kZTsgbWFyay5y
dXRsYW5kQGFybS5jb207Cj4+IGFuc2h1bWFuLmtoYW5kdWFsQGFybS5jb207IHZpbmNlbnpvLmZy
YXNjaW5vQGFybS5jb207Cj4+IHRhYmJhQGdvb2dsZS5jb207IG1hcmNhbkBtYXJjYW4uc3Q7IGtl
ZXNjb29rQGNocm9taXVtLm9yZzsKPj4ganRoaWVycnlAcmVkaGF0LmNvbTsgbWFzYWhpcm95QGtl
cm5lbC5vcmc7IHNhbWl0b2x2YW5lbkBnb29nbGUuY29tOwo+PiBqb2huLmdhcnJ5QGh1YXdlaS5j
b207IGRhbmllbC5sZXpjYW5vQGxpbmFyby5vcmc7IGdvckBsaW51eC5pYm0uY29tOwo+PiB6aGFu
Z3NoYW9rdW5AaGlzaWxpY29uLmNvbTsgdG1yaWNodEBsaW51eC5pYm0uY29tOyBkY2hpbm5lckBy
ZWRoYXQuY29tOwo+PiB0Z2x4QGxpbnV0cm9uaXguZGU7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmc7Cj4+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsga3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdTsKPj4gbGludXgtYWNwaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWVkYWNAdmdlci5rZXJuZWwub3JnOyBJc2hpaSwgU2h1dWljaGlyb3Uv55+z5LqVCj4+IOWRqOS4
gOmDjiA8aXNoaWkuc2h1dWljaGlyQGZ1aml0c3UuY29tPjsgVmluZWV0aC5QaWxsYWlAbWljcm9z
b2Z0LmNvbQo+PiBDYzogVHlsZXIgQmFpY2FyIDxiYWljYXJAb3MuYW1wZXJlY29tcHV0aW5nLmNv
bT4KPj4gU3ViamVjdDogW1BBVENIIDEvMl0gQUNQSS9BRVNUOiBJbml0aWFsIEFFU1QgZHJpdmVy
Cj4+Cj4+IEFkZCBzdXBwb3J0IGZvciBwYXJzaW5nIHRoZSBBUk0gRXJyb3IgU291cmNlIFRhYmxl
IGFuZCBiYXNpYyBoYW5kbGluZyBvZgo+PiBlcnJvcnMgcmVwb3J0ZWQgdGhyb3VnaCBib3RoIG1l
bW9yeSBtYXBwZWQgYW5kIHN5c3RlbSByZWdpc3RlciBpbnRlcmZhY2VzLgo+Pgo+PiBBc3N1bWUg
c3lzdGVtIHJlZ2lzdGVyIGludGVyZmFjZXMgYXJlIG9ubHkgcmVnaXN0ZXJlZCB3aXRoIHByaXZh
dGUKPj4gcGVyaXBoZXJhbCBpbnRlcnJ1cHRzIChQUElzKTsgb3RoZXJ3aXNlIHRoZXJlIGlzIG5v
IGd1YXJhbnRlZSB0aGUKPj4gY29yZSBoYW5kbGluZyB0aGUgZXJyb3IgaXMgdGhlIGNvcmUgd2hp
Y2ggdG9vayB0aGUgZXJyb3IgYW5kIGhhcyB0aGUKPj4gc3luZHJvbWUgaW5mbyBpbiBpdHMgc3lz
dGVtIHJlZ2lzdGVycy4KPj4KPj4gQWRkIGxvZ2dpbmcgZm9yIGFsbCBkZXRlY3RlZCBlcnJvcnMg
YW5kIHRyaWdnZXIgYSBrZXJuZWwgcGFuaWMgaWYgdGhlcmUgaXMKPj4gYW55IHVuY29ycmVjdGVk
IGVycm9yIHByZXNlbnQuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFR5bGVyIEJhaWNhciA8YmFpY2Fy
QG9zLmFtcGVyZWNvbXB1dGluZy5jb20+Cj4+IC0tLQo+IFsuLi5dCj4KPj4gK3N0YXRpYyBpbnQg
X19pbml0IGFlc3RfaW5pdF9ub2RlKHN0cnVjdCBhY3BpX2Flc3RfaGRyICpub2RlKQo+PiArewo+
PiArCXVuaW9uIGFjcGlfYWVzdF9wcm9jZXNzb3JfZGF0YSAqcHJvY19kYXRhOwo+PiArCXVuaW9u
IGFlc3Rfbm9kZV9zcGVjICpub2RlX3NwZWM7Cj4+ICsJc3RydWN0IGFlc3Rfbm9kZV9kYXRhICpk
YXRhOwo+PiArCWludCByZXQ7Cj4+ICsKPj4gKwlkYXRhID0ga3phbGxvYyhzaXplb2Yoc3RydWN0
IGFlc3Rfbm9kZV9kYXRhKSwgR0ZQX0tFUk5FTCk7Cj4+ICsJaWYgKCFkYXRhKQo+PiArCQlyZXR1
cm4gLUVOT01FTTsKPj4gKwo+PiArCWRhdGEtPm5vZGVfdHlwZSA9IG5vZGUtPnR5cGU7Cj4+ICsK
Pj4gKwlub2RlX3NwZWMgPSBBQ1BJX0FERF9QVFIodW5pb24gYWVzdF9ub2RlX3NwZWMsIG5vZGUs
Cj4+IG5vZGUtPm5vZGVfc3BlY2lmaWNfb2Zmc2V0KTsKPj4gKwo+PiArCXN3aXRjaCAobm9kZS0+
dHlwZSkgewo+PiArCWNhc2UgQUNQSV9BRVNUX1BST0NFU1NPUl9FUlJPUl9OT0RFOgo+PiArCQlt
ZW1jcHkoJmRhdGEtPmRhdGEsIG5vZGVfc3BlYywgc2l6ZW9mKHN0cnVjdAo+PiBhY3BpX2Flc3Rf
cHJvY2Vzc29yKSk7Cj4+ICsJCWJyZWFrOwo+PiArCWNhc2UgQUNQSV9BRVNUX01FTU9SWV9FUlJP
Ul9OT0RFOgo+PiArCQltZW1jcHkoJmRhdGEtPmRhdGEsIG5vZGVfc3BlYywgc2l6ZW9mKHN0cnVj
dAo+PiBhY3BpX2Flc3RfbWVtb3J5KSk7Cj4+ICsJCWJyZWFrOwo+PiArCWNhc2UgQUNQSV9BRVNU
X1NNTVVfRVJST1JfTk9ERToKPj4gKwkJbWVtY3B5KCZkYXRhLT5kYXRhLCBub2RlX3NwZWMsIHNp
emVvZihzdHJ1Y3QKPj4gYWNwaV9hZXN0X3NtbXUpKTsKPj4gKwkJYnJlYWs7Cj4+ICsJY2FzZSBB
Q1BJX0FFU1RfVkVORE9SX0VSUk9SX05PREU6Cj4+ICsJCW1lbWNweSgmZGF0YS0+ZGF0YSwgbm9k
ZV9zcGVjLCBzaXplb2Yoc3RydWN0Cj4+IGFjcGlfYWVzdF92ZW5kb3IpKTsKPj4gKwkJYnJlYWs7
Cj4+ICsJY2FzZSBBQ1BJX0FFU1RfR0lDX0VSUk9SX05PREU6Cj4+ICsJCW1lbWNweSgmZGF0YS0+
ZGF0YSwgbm9kZV9zcGVjLCBzaXplb2Yoc3RydWN0Cj4+IGFjcGlfYWVzdF9naWMpKTsKPj4gKwkJ
YnJlYWs7Cj4+ICsJZGVmYXVsdDoKPj4gKwkJa2ZyZWUoZGF0YSk7Cj4+ICsJCXJldHVybiAtRUlO
VkFMOwo+PiArCX0KPj4gKwo+PiArCWlmIChub2RlLT50eXBlID09IEFDUElfQUVTVF9QUk9DRVNT
T1JfRVJST1JfTk9ERSkgewo+PiArCQlwcm9jX2RhdGEgPSBBQ1BJX0FERF9QVFIodW5pb24gYWNw
aV9hZXN0X3Byb2Nlc3Nvcl9kYXRhLAo+PiBub2RlX3NwZWMsCj4+ICsJCQkJCSBzaXplb2YoYWNw
aV9hZXN0X3Byb2Nlc3NvcikpOwo+PiArCj4+ICsJCXN3aXRjaCAoZGF0YS0+ZGF0YS5wcm9jZXNz
b3IucmVzb3VyY2VfdHlwZSkgewo+PiArCQljYXNlIEFDUElfQUVTVF9DQUNIRV9SRVNPVVJDRToK
Pj4gKwkJCW1lbWNweSgmZGF0YS0+cHJvY19kYXRhLCBwcm9jX2RhdGEsCj4+ICsJCQkgICAgICAg
c2l6ZW9mKHN0cnVjdCBhY3BpX2Flc3RfcHJvY2Vzc29yX2NhY2hlKSk7Cj4+ICsJCQlicmVhazsK
Pj4gKwkJY2FzZSBBQ1BJX0FFU1RfVExCX1JFU09VUkNFOgo+PiArCQkJbWVtY3B5KCZkYXRhLT5w
cm9jX2RhdGEsIHByb2NfZGF0YSwKPj4gKwkJCSAgICAgICBzaXplb2Yoc3RydWN0IGFjcGlfYWVz
dF9wcm9jZXNzb3JfdGxiKSk7Cj4+ICsJCQlicmVhazsKPj4gKwkJY2FzZSBBQ1BJX0FFU1RfR0VO
RVJJQ19SRVNPVVJDRToKPj4gKwkJCW1lbWNweSgmZGF0YS0+cHJvY19kYXRhLCBwcm9jX2RhdGEs
Cj4+ICsJCQkgICAgICAgc2l6ZW9mKHN0cnVjdCBhY3BpX2Flc3RfcHJvY2Vzc29yX2dlbmVyaWMp
KTsKPj4gKwkJCWJyZWFrOwo+PiArCQl9Cj4+ICsJfQo+PiArCj4+ICsJcmV0ID0gYWVzdF9pbml0
X2ludGVyZmFjZShub2RlLCBkYXRhKTsKPj4gKwlpZiAocmV0KSB7Cj4+ICsJCWtmcmVlKGRhdGEp
Owo+PiArCQlyZXR1cm4gcmV0Owo+PiArCX0KPj4gKwo+PiArCXJldHVybiBhZXN0X2luaXRfaW50
ZXJydXB0cyhub2RlLCBkYXRhKTsKPiBJZiBhZXN0X2luaXRfaW50ZXJydXB0cygpIGZhaWxlZCwg
aXMgaXQgbmVjZXNzYXJ5IHRvIHJlbGVhc2UKPiB0aGUgZGF0YSBwb2ludGVyIGFjcXVpcmVkIGJ5
IGt6YWxsb2M/CmFlc3RfaW5pdF9pbnRlcnJ1cHRzKCkgcmV0dXJucyBhbiBlcnJvciBpZiBhbnkg
b2YgdGhlIGludGVycnVwdHMgaW4gdGhlIAppbnRlcnJ1cHQgbGlzdCBmYWlscywgYnV0IGl0J3Mg
cG9zc2libGUgdGhhdCBzb21lIGludGVycnVwdHMgaW4gdGhlIGxpc3QgCnJlZ2lzdGVyZWQgc3Vj
Y2Vzc2Z1bGx5LiBTbyB3ZSBhdHRlbXB0IHRvIGtlZXAgY2h1Z2dpbmcgYWxvbmcgaW4gdGhhdCAK
c2NlbmFyaW8gYmVjYXVzZSBzb21lIGludGVycnVwdHMgbWF5IGJlIGVuYWJsZWQgYW5kIHJlZ2lz
dGVyZWQgd2l0aCB0aGUgCmludGVyZmFjZSBzdWNjZXNzZnVsbHkuIElmIGFueSBpbnRlcnJ1cHQg
cmVnaXN0cmF0aW9uIGZhaWxzLCB0aGVyZSB3aWxsIApiZSBhIHByaW50IG5vdGlmeWluZyB0aGF0
IHRoZXJlIHdhcyBhIGZhaWx1cmUgd2hlbiBpbml0aWFsaXppbmcgdGhhdCBub2RlLgo+PiArfQo+
PiArCj4+ICtzdGF0aWMgdm9pZCBhZXN0X2NvdW50X3BwaShzdHJ1Y3QgYWNwaV9hZXN0X2hkciAq
bm9kZSkKPj4gK3sKPj4gKwlzdHJ1Y3QgYWNwaV9hZXN0X25vZGVfaW50ZXJydXB0ICppbnRlcnJ1
cHQ7Cj4+ICsJaW50IGk7Cj4+ICsKPj4gKwlpbnRlcnJ1cHQgPSBBQ1BJX0FERF9QVFIoc3RydWN0
IGFjcGlfYWVzdF9ub2RlX2ludGVycnVwdCwgbm9kZSwKPj4gKwkJCQkgbm9kZS0+bm9kZV9pbnRl
cnJ1cHRfb2Zmc2V0KTsKPj4gKwo+PiArCWZvciAoaSA9IDA7IGkgPCBub2RlLT5ub2RlX2ludGVy
cnVwdF9jb3VudDsgaSsrLCBpbnRlcnJ1cHQrKykgewo+PiArCQlpZiAoaW50ZXJydXB0LT5nc2l2
ID49IDE2ICYmIGludGVycnVwdC0+Z3NpdiA8IDMyKQo+PiArCQkJbnVtX3BwaSsrOwo+PiArCX0K
Pj4gK30KPj4gKwo+PiArc3RhdGljIGludCBhZXN0X3N0YXJ0aW5nX2NwdSh1bnNpZ25lZCBpbnQg
Y3B1KQo+PiArewo+PiArCWludCBpOwo+PiArCj4+ICsJZm9yIChpID0gMDsgaSA8IG51bV9wcGk7
IGkrKykKPj4gKwkJZW5hYmxlX3BlcmNwdV9pcnEocHBpX2lycXNbaV0sIElSUV9UWVBFX05PTkUp
Owo+PiArCj4+ICsJcmV0dXJuIDA7Cj4+ICt9Cj4+ICsKPj4gK3N0YXRpYyBpbnQgYWVzdF9keWlu
Z19jcHUodW5zaWduZWQgaW50IGNwdSkKPj4gK3sKPiBXb3VsZG4ndCBpdCBiZSBiZXR0ZXIgdG8g
ZXhlY3V0ZSBkaXNhYmxlX3BlcmNwdV9pcnEoKSwgd2hpY2ggaXMgcGFpcmVkCj4gd2l0aCBlbmFi
bGVfcGVyY3B1X2lycSgpLCBpbiBhZXN0X2R5aW5nX2NwdSgpPwoKR29vZCBwb2ludC4gSSB3aWxs
IGFkZCB0aGF0IGluIHRoZSBuZXh0IHZlcnNpb24uCgpUaGFua3MsCgpUeWxlcgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
