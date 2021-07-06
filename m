Return-Path: <SRS0=37/+=L6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19ECDC07E9C
	for <kvmarm@archiver.kernel.org>; Tue,  6 Jul 2021 15:35:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8139F61C1C
	for <kvmarm@archiver.kernel.org>; Tue,  6 Jul 2021 15:35:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8139F61C1C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF4B4B0BB;
	Tue,  6 Jul 2021 11:35:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qRLC+HjuYq4d; Tue,  6 Jul 2021 11:35:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFDC74B0C0;
	Tue,  6 Jul 2021 11:35:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CA574B0B8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jul 2021 11:35:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tocANuBKMpRW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jul 2021 11:35:50 -0400 (EDT)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08EA54B09C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jul 2021 11:35:49 -0400 (EDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
 166FWJdf007221; Tue, 6 Jul 2021 15:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=r4AiR5xoOb6sRA5+WPOgMSQNGIo492iKgBnGCJntJ3o=;
 b=vRv6vC9oXX2ERernF/lXTIYE06RTMoeC9AIABnftd/bTFRmnKD43wypeVbIqSMy0dhAl
 0gT5fI9LCcHyVvU0puzO3SIv/RbCn4pdSuIINIXvtw2OkmKYeQtmmfaMmJm61UT+C60C
 5LRncT4D4exZ/jSRMVCy9KtHndE3iaTaKpz9kwvgN3Zu/yJvJZ7hmCR/xS3ch80aKRsw
 CJyNWcjSG3DHLp3SP0d8dFK4eTveEDFwEOdIPOlfDHbuZdPZAq8KUEynbYONcnwtMChP
 3p/bBeEA3DBlAuIN5ZfRjGciZwNS4DMjg5LLkJ97eRYX6ar0mJknQ601oKFpVcqwSLD8 yA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
 by mx0b-00069f02.pphosted.com with ESMTP id 39m3mha2rv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 06 Jul 2021 15:35:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
 by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 166FUXYe127235;
 Tue, 6 Jul 2021 15:35:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
 by aserp3030.oracle.com with ESMTP id 39jdxhceth-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 06 Jul 2021 15:35:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5y9xRIiLfAh+LHsDu5NV6XiovyZ9ai0AhKwoKDVFLWhYNlO9/ivN1xvW+4gKEaJ/YPHz20Berqce/lWQJi6pZGLGW0DyfXvOrqhmZxJy62YX0AIHPM/jzUdOSHK7RdD1sR046rOuIdXGaCnkSTJPRmxoH8CjIlmXSvPFjcpbZS8bL07R6tsLLdY/ZLPR3Zi21E1f/TXu5RUmfFiOL1IVH7ZfqvID5bDdWsa8uexODCk1jl67uqJiM+Ym9ULLeGMDm9L6XEOCq9x/iP2UBapfj8w/BrBAi9t/IhX1m/Y2wep05YX6+0m6WvAAwcpGaCMPjfvwE5ph79KgNGW2YhlIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4AiR5xoOb6sRA5+WPOgMSQNGIo492iKgBnGCJntJ3o=;
 b=TaeSFPJcNHlRfff18o9wSjKdC8Oavbm7h3F3NFyDHSuQYngHIUtt9fflmwzwswAvTlVIhPeF68JHP1BCZ0BdVyWwFWJjKmG0JsoBSIqL/TPvM9/uTolVHhmN8pSjqgDugdG4NGEjawXF66AgSktH0zRmOocysOLOtJDtUUM/IMxwViS+mf/QGKDNbTFzSmn936VBdDptwcb0m+ZObwH0n6EpWKu8V9ppGx54OxJLByY/qQWvrMWwizp6S0Af25XoWZHHqngUeGEyrlel+kDzXjSuC15lfjKuIlzbqB15EAzlmI2wAOnHvHp5tPtZEesoiqaqyDKKX3Jel8tFUqFG3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4AiR5xoOb6sRA5+WPOgMSQNGIo492iKgBnGCJntJ3o=;
 b=J4GWCrt6mz3WeQhIXeyaswH+IIbYkOgvbp/iCZ3j/0f1Wvj/7ADKJT+1ERK2iA1NdDNe51U6AUAJsvkgqxlD3LiH/Y5kSWn+NAHPcYBzLp0kbgr1hYXyfEx4cSFtrsuikbUAMUyqOClM7ZZyfbYVVkpd6vh+h7Pvi30QrDN2pgg=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH0PR10MB5498.namprd10.prod.outlook.com (2603:10b6:610:ed::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Tue, 6 Jul
 2021 15:35:43 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15%4]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 15:35:43 +0000
Subject: Re: [PATCH] KVM: arm64: Disabling disabled PMU counters wastes a lot
 of time
To: Marc Zyngier <maz@kernel.org>
References: <20210628161925.401343-1-alexandre.chartre@oracle.com>
 <878s2tavks.wl-maz@kernel.org>
 <e3843c2c-e20a-ef58-c795-1ba8f1d91ff6@oracle.com>
 <ed86299d-c0d4-f73e-ff7d-86eefd2de650@oracle.com>
 <87y2aj7av5.wl-maz@kernel.org>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <cfe6b72b-9e87-8c24-b54b-a315d929fe0b@oracle.com>
Date: Tue, 6 Jul 2021 17:35:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <87y2aj7av5.wl-maz@kernel.org>
Content-Language: en-US
X-ClientProxiedBy: LO2P123CA0094.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::9) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2.7.202.103) by
 LO2P123CA0094.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:139::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23 via Frontend Transport; Tue, 6 Jul 2021 15:35:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5343025-e3fe-4920-7225-08d94093b73f
X-MS-TrafficTypeDiagnostic: CH0PR10MB5498:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH0PR10MB5498AC894C3C74F06A56BE4D9A1B9@CH0PR10MB5498.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fonp3CH3oWXUYtLhF/KXMnavDWcdl2fFdZ7CbomOVyX2wGbsLmltqAjRAzLU94eu8N+1qPGTHtvYPN5UL0z/uRQHq+mA+UJBW/nzRiN5shBkWTYijOCYYbeBPO/NfzByPqVuiDmm3n9CYTmOtCPvNP/SmA8fsOXcoTYioBzN58e4R1y6LaN1Zc9WCUxCz2G+EewUsIbP0zMnT8iEhYb5Oiqoyi02iKkYYzlAWyp8S+UvXQsoT0mtDb5W3ChsEQjcut8AwpjV9l3U9kj1gMQEy2kCqPRczzc0tUtILGBEY350g2LB3z7aNSenNZa4rGGoUlZTrx06Jt6ry70kn66upURhzNpA/nzfjt8HN3glMwG7YOCnTzDgF8zO7bCSWpsmfD/9ys8dBK531yJAdPRjnhfT7hy5f9GbMAzpas7sydrwO6PwRLH/RyzrZ1u++Kv+7nRh3C0pvPadHKjInIzCO2+18F9pKXPpp3xZ559A++gwkharzAsa7wzMLEjeGJumUKA9ul2JYzJl/t/2BKIPeRGUqwmd/f+bfOQC5SiSzYeWZsB8rE46qw6N2uFZSGGKHOxrrVcsfpa5DV9T8maSz4aTj0RF0c8tiTeYCB2/cIPObPigeqEOwTEvbbuRTqf/hzipCPlPXo4Mlkb52+dEF0fvfDQctY2h3sDfvN8kW0JRpRYljXUH/dB+8tvVBY0P9snCMV5iu2i96TjlOJ5O70z6+bRztuonOdpaqNprJZo=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:CH2PR10MB4391.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(346002)(39860400002)(136003)(396003)(376002)(366004)(86362001)(83380400001)(4326008)(478600001)(2616005)(5660300002)(107886003)(26005)(31686004)(36756003)(316002)(31696002)(2906002)(6916009)(44832011)(186003)(8676002)(66476007)(6506007)(38100700002)(66946007)(53546011)(8936002)(66556008)(6486002)(6512007)(956004)(6666004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjBuMG5uck8vcU5pb3VZTzArWHhLWlJubjNBSWNWclJuRlV1WkJ2MGhPUm5q?=
 =?utf-8?B?S0JrcW5rRGFuWkJ3K2Fhc1VnT2cvVVF2YWd2eU55eTZoWENmSGs4Ni9Rd1g1?=
 =?utf-8?B?OXhWRFpPam9DWStIcFIrSnhWTXZKU29wSSt5V2ZtUnlpeVg4ekdqLzQ1R2Vu?=
 =?utf-8?B?d0U0ZmJGdlU5ckdtWlViNWdITGlhUGpVTTkwcnlGWXlEcS9udGs4dktnV2Fj?=
 =?utf-8?B?WTJXMHJvdVZnYkIva0hXQnpEQldteWoxY1Y1VkJwWUFmS2c1ZGI3bGdlSEts?=
 =?utf-8?B?dXp1VFliOWpOV0IrMjVUZUlySmU3dXBmNGJnZ0RBdGJOL1dKSUZmM1dMYnRF?=
 =?utf-8?B?bkdpK3FUa1JLeUxpUzNhSEdMUzl4VVBuN3hTWVcvVmthYStsUHF5d1M2WjZo?=
 =?utf-8?B?MlQrekY3SkE5ZzdSZWtmL0RyVTBrWWFQVXRhM2hjeWdLcUpGV25wSlFvcDZG?=
 =?utf-8?B?WktrcWxzTTcyajhxc2tzMVBaQ0JSaGZkUWtvQ29oRnZyRVVmYVZLaEVwUlYv?=
 =?utf-8?B?bnM3bEpvY3ZCUkUzTzRtTkNxRldWeHd0QTBmc3Z3WUJWZnVKSmN2UWRSdUJR?=
 =?utf-8?B?bzBabkFycGFCUXFtTFZYMGNZVmtrRWZielhVYjhOZ2xBcExKck9ZUytCUGNY?=
 =?utf-8?B?WjlLTFA5MjN1a0lENnVNS084WW12b2hjbVFndG1PUDVWMDdZNytWVmsxS2Ji?=
 =?utf-8?B?VEVqa2ZmSVZPb3o2UWk3M2lvalVwbVJDaEZ5OUJqOWo2VVpFMWh5cXlrbWhr?=
 =?utf-8?B?YVA1ZVZrYWFoenpKMHgxbGQvNFdWK0lkalUrTFNHb01CYXB2K2VmVFppczN6?=
 =?utf-8?B?T3JqdzI3V0JGYWZDOFl5L09zeVdvVUtFTDduK2dvQThwYy9jRzVBQTdaaGFz?=
 =?utf-8?B?Y21KOWN3d2NLd0REdy9YZnVyaTBPbXlNTGpIK3VWV1E3R3pkNnJQejZNbDVo?=
 =?utf-8?B?YnNzckduaThLR1djNUVsd2hGVW5NaUNBM3ZQV1RGcjFIdTJHeWFpWTl5SVBZ?=
 =?utf-8?B?YmxxNU0yNS9BME4rWkFtNnYwOFh3YVo3dkhlZEdHSUE3NDFKY0ZJVG5yS3NH?=
 =?utf-8?B?Um05akcrWTFqU2MwdGdiQ2wzL1FlRWZlNWI5V3pzOExSeXhpUEJaR09NcWRr?=
 =?utf-8?B?ZlQ2SW5hTjNHcXppRndPN1BSay9IZTlTa3kyWDIzUk1FVTh1VkJtQlcxRjZN?=
 =?utf-8?B?cXVla1lXU01DbTYzUGZsTUlwZnRQS3NqOUVBZDJKUmVRbkZyckh5QjN2eVRK?=
 =?utf-8?B?ODdOOW5XMmFTQ255RFBLdVVDR1NTUGRPYTFvTU94RFd3cXdiRU1sdzNqSklE?=
 =?utf-8?B?TmhBMDBXdktER1YwZHZ3V09YeWNxbWhFalZDNFBJMDFLSGN2NlhPdXZJL1l0?=
 =?utf-8?B?TXN0aEErNUxNS0FFZjNaVThNUEhtbGlBaVBuREEweVBjc2cyb3JvcmhsWEVv?=
 =?utf-8?B?NGZ3TERhWXRuRTFhQTFhOGpYK1JzU2lHZ3BCKzZvdjM1ckFJdmNJSXRHMGQ4?=
 =?utf-8?B?dzFNSFk2SlQvT0FFUXFXbjdwajgyd3AxbWV3cUlhL21ldk9Ec1lySnAzdWxF?=
 =?utf-8?B?MGhva1diUVUydWJYNWY0Rmkxa3hCYVpCVGlwVDlPNnR2TDlzcUc4S0FiV2hk?=
 =?utf-8?B?ZUcvUU11SFNqLzFEdHQxKzNUaUdSNHRjRm1PNFRJeEdrTEtBNDB3MklHQUZj?=
 =?utf-8?B?SHpNcTNMNGhsTFZVZWxETkRGc3hUY2VSVG9QSXp1MUZleUkxMTZRYVpHZnU1?=
 =?utf-8?Q?7htxodD8UpRfKucaYPPre5QT5RIXWHwiExp8RqP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5343025-e3fe-4920-7225-08d94093b73f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 15:35:42.9798 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vpqpJDt47H3UWxbm+f8hno+BqCItqga6GawX3XXobg6NX6jBy7yVRID6gyIgPSbTZ9z+JyDRJEXVFetHrwlZz6MQkf6/5Tc+ngJFBWSuuAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5498
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037
 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060071
X-Proofpoint-GUID: 920qnSY5NcRBQY4eMwwvMHTkKO1_IKz1
X-Proofpoint-ORIG-GUID: 920qnSY5NcRBQY4eMwwvMHTkKO1_IKz1
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, konrad.wilk@oracle.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

CgpPbiA3LzYvMjEgNDo1MiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIFR1ZSwgMDYgSnVs
IDIwMjEgMTQ6NTA6MzUgKzAxMDAsCj4gQWxleGFuZHJlIENoYXJ0cmUgPGFsZXhhbmRyZS5jaGFy
dHJlQG9yYWNsZS5jb20+IHdyb3RlOgo+Pgo+Pgo+PiBIaSBNYXJjLAo+Pgo+PiBPbiA2LzI5LzIx
IDM6MTYgUE0sIEFsZXhhbmRyZSBDaGFydHJlIHdyb3RlOgo+Pj4gT24gNi8yOS8yMSAxMTowNiBB
TSwgTWFyYyBaeW5naWVyIHdyb3RlCj4+PiBbLi4uXQo+Pj4+IFNvwqB0aGXCoHN5c3JlZ8KgaXPC
oHRoZcKgb25secKgdGhpbmfCoHdlwqBzaG91bGTCoGNvbnNpZGVyLMKgYW5kwqBJwqB0aGlua8Kg
d2UKPj4+PiBzaG91bGTCoGRyb3DCoHRoZcKgdXNlbGVzc8KgbWFza2luZy7CoFRoZXJlwqBpc8Kg
YXTCoGxlYXN0wqBhbm90aGVywqBpbnN0YW5jZcKgb2YKPj4+PiB0aGlzwqBpbsKgdGhlwqBQTVXC
oGNvZGXCoChrdm1fcG11X292ZXJmbG93X3N0YXR1cygpKSzCoGFuZMKgYXBhcnTCoGZyb20KPj4+
PiBrdm1fcG11X3ZjcHVfcmVzZXQoKSzCoG9ubHnCoHRoZcKgc3lzcmVnwqBhY2Nlc3NvcnPCoHNo
b3VsZMKgY2FyZcKgYWJvdXTCoHRoZQo+Pj4+IG1hc2tpbmfCoHRvwqBzYW5pdGlzZcKgYWNjZXNz
ZXMuCj4+Pj4KPj4+PiBXaGF0wqBkb8KgeW91wqB0aGluaz8KPj4+Pgo+Pj4KPj4+IEnCoHRoaW5r
wqB5b3XCoGFyZcKgcmlnaHQuwqBQTUNOVEVOU0VUX0VMMMKgaXPCoGFscmVhZHnCoG1hc2tlZMKg
d2l0aMKga3ZtX3BtdV92YWxpZF9jb3VudGVyX21hc2soKQo+Pj4gc2/CoHRoZXJlJ3PCoGVmZmVj
dGl2ZWx5wqBub8KgbmVlZMKgdG/CoG1hc2vCoGl0wqBhZ2FpbsKgd2hlbsKgd2XCoHVzZcKgaXQu
wqBJwqB3aWxswqBzZW5kwqBhbsKgYWRkaXRpb25hbAo+Pj4gcGF0Y2jCoChvbsKgdG9wwqBvZsKg
dGhpc8Kgb25lKcKgdG/CoHJlbW92ZcKgdXNlbGVzc8KgbWFza2luZy7CoEJhc2ljYWxseSzCoGNo
YW5nZXPCoHdvdWxkwqBiZToKPj4KPj4gSSBoYWQgYSBjbG9zZXIgbG9vayBhbmQgd2UgY2FuJ3Qg
cmVtb3ZlIHRoZSBtYXNrLiBUaGUgYWNjZXNzCj4+IGZ1bmN0aW9ucyAoZm9yIHBtY250ZW4sIHBt
aW50ZW4sIHBtb3ZzKSwgY2xlYXIgb3Igc2V0IG9ubHkgdGhlCj4+IHNwZWNpZmllZCB2YWxpZCBj
b3VudGVyIGJpdHMuIFRoaXMgbWVhbnMgdGhhdCBiaXRzIG90aGVyIHRoYW4gdGhlCj4+IHZhbGlk
IGNvdW50ZXIgYml0cyBuZXZlciBjaGFuZ2UgaW4gX192Y3B1X3N5c19yZWcoKSwgYW5kIHRob3Nl
IGJpdHMKPj4gYXJlIG5vdCBuZWNlc3NhcmlseSB6ZXJvIGJlY2F1c2UgdGhlIGluaXRpYWwgdmFs
dWUgaXMKPj4gMHgxZGU3ZWM3ZWRiYWRjMGRlVUxMIChzZXQgYnkgcmVzZXRfdW5rbm93bigpKS4K
PiAKPiBUaGF0J3MgYSBidWcgdGhhdCBzaG91bGQgYmUgZml4ZWQgb24gaXRzIG93bi4gQml0cyB0
aGF0IGFyZSBSQVovV0kgaW4KPiB0aGUgYXJjaGl0ZWN0dXJlIHNob3VsZG4ndCBiZSBrZXB0IGlu
IHRoZSBzaGFkb3cgcmVnaXN0ZXJzIHRoZSBmaXJzdAo+IHBsYWNlLiBJJ2xsIGhhdmUgYSBsb29r
Lgo+IAo+PiBTbyBJIHdpbGwgcmVzdWJtaXQgaW5pdGlhbCBwYXRjaCwgd2l0aCBqdXN0IHRoZSBj
b21taXQgbWVzc2FnZQo+PiBjaGFuZ2VzLgo+IAo+IFBsZWFzZSBkb24ndC4gSSdtIG5vdCBwYXBl
cmluZyBvdmVyIHRoaXMga2luZCBvZiBidWcuCj4gCgpSaWdodCwgSSBtZWFudCBJIHdpbGwgcmVz
dWJtaXQgYWZ0ZXIgLXJjMSBhcyB5b3UgcmVxdWVzdGVkLgoKVGhhbmtzLAoKYWxleC4KCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
