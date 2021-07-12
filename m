Return-Path: <SRS0=bTo6=ME=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416C7C07E99
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 15:56:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A7EF36102A
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 15:56:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7EF36102A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D17B407A0;
	Mon, 12 Jul 2021 11:56:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UUvPYscPuJp5; Mon, 12 Jul 2021 11:56:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBA924083E;
	Mon, 12 Jul 2021 11:56:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20AE740799
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 11:56:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jGeZ6n99xmr4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Jul 2021 11:56:08 -0400 (EDT)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB7EF40294
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 11:56:08 -0400 (EDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
 16CFfCNA016257; Mon, 12 Jul 2021 15:56:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7hms17+ywCyyULtIV0EsVEoAPUsUW9fgiAzK4WWV0/I=;
 b=vcnwxp7u+7asuKnkGezOFUnNMu2gZuSrPdCChf22cORJjOr+yIyQdcImX/iJu19jpW+T
 I73LvQ1m7WjpOF7MS+x/H/sGatR1+DwcGuf9VXX3ltDM+Q2nRyAQAw5JlqIFUi4W6YWv
 XvlEQXWwYdMdsB9PDYBuLoMsqXsxYl8dvbXHoSe0gMj0mV3xClR/n4XDSXftOkwxlrkW
 /jsXhNB/Wc8+c5tnB1UGUFWbVE49l2cxrFc8jR4S9CmABQ+VA8sBa5R/ePJTgP7Prwm0
 mai9jWWmzblC6WO8b8/V+ie8Ce4vvuAZD9mnINOEjt8Aob6Vs+eTmb119cCWKOpzdome Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
 by mx0b-00069f02.pphosted.com with ESMTP id 39rnxdgffh-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 12 Jul 2021 15:56:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
 by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16CFenis089948;
 Mon, 12 Jul 2021 15:56:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
 by aserp3030.oracle.com with ESMTP id 39qycs55ck-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 12 Jul 2021 15:56:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGc8x8uUGgfuX+JXf0InIGpSgmywoFy2yvRA63Bk4VjBThJTUvO0TzkAWcyx9AHVCIMqu2ZtYChKDZbwsPtwP25AndeUiVZsQLinygzd48mWes8/H2sAQvizXCZIYUENRs+n+aGQXq7gtblSeuNGasfaTsDTuM2HMqk8nYXjc0Dzo4EM35lVk+3V28NxbZkM2i9PqXgcCOtlyXhvy6mhYGM4BZO/jb73YsnbvLShXXyP4yekwu5j+Kpd6hjMkP3duI1Hcs6ek/ez2RXMH6kmiPRgdT71SjRshRrjJZUy4YllOn+mDDJ3jtmhp5eZcHP57YpbTR73oC6xiZsAdXhF0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hms17+ywCyyULtIV0EsVEoAPUsUW9fgiAzK4WWV0/I=;
 b=EneB0lmosuNXuOAQRTIMVqBR34tuMN8HmQVJxXB78g0xPODCATBRjazg2LLCiJzZ0MhKq5CEiT1nRZMbUN2SWIM6Q1AZmZXJe0REOvKPKpLomnuYGLpFV+U0G5Zc6lKkx8shyVAB6lH8ZtnQI2yu0iRM9ClhCu7Y13uYLFQlE79ozlszdBsB7VeN0e1sXc2AnRbkS4kP6Aojq02fB67ylaQd3cKsymCbR+33ni58GJv+IECN+HFNteXrHURA9DQfdJzZMhb1W66bfXUIJ7CRdoftkTAsmNgYI3K+Sned8bJ/J5N31ruUwtQgTOvJKTLM9tScHy2WRIVuqeUwni3UvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hms17+ywCyyULtIV0EsVEoAPUsUW9fgiAzK4WWV0/I=;
 b=w0hZ60ajCFxv0//06k0FiaXx4ZDJ6ZRkIaKjTqwcbND1j6stnoC90oTkHIKaRWcyUG7tNGl2BcPA2H5TdQLeIU/memqcoKifrx4mFvFLL5HYbPKeGOMDfg1/Tih1R1+EPT/qZ65Dzc3RqIAs/X9svy9YJ63fZB/dm1a5Tz/WveY=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH2PR10MB4165.namprd10.prod.outlook.com (2603:10b6:610:a5::24)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:55:53 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15%4]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:55:53 +0000
Subject: Re: [PATCH v2] KVM: arm64: Disabling disabled PMU counters wastes a
 lot of time
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Robin Murphy <robin.murphy@arm.com>, maz@kernel.org, will@kernel.org,
 catalin.marinas@arm.com, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20210712151700.654819-1-alexandre.chartre@oracle.com>
 <d4646297-da3a-c629-d0b2-b830cce6a656@arm.com>
 <90b0b99b-505c-c46c-6c2c-a45192135f5a@arm.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <a7663dbe-4ff9-0b1b-29ca-aab16d896217@oracle.com>
Date: Mon, 12 Jul 2021 17:55:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <90b0b99b-505c-c46c-6c2c-a45192135f5a@arm.com>
Content-Language: en-US
X-ClientProxiedBy: LO3P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::8) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2.7.202.103) by
 LO3P265CA0003.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:bb::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.21 via Frontend Transport; Mon, 12 Jul 2021 15:55:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 499af761-1ea7-4eda-de6f-08d9454d873d
X-MS-TrafficTypeDiagnostic: CH2PR10MB4165:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR10MB416549F0BE5777427D5A84759A159@CH2PR10MB4165.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VqjIdHjkU/Nl2ObSjWBp6g6lLFXx+d2+xGlPDZEAj0N1hOTpR7XhjW2MZe1q29ukFKvnGj1ZqVo/iIFuE/m/7UbLd+uz+A4uv7bB24Nk3/Nr5uLz4uKRdoh0Ve+ySzU05fJXe/ksPWTBXFkF6IDcJdRYeSrdk3SzHEFuI0gdiFiRCT3S1MGJ4QUlOgM3nA/gCjC03q8rc+exS7Rn4cwEvOvEepMJRm8xI1G4hqrwNXnA4qjQ3Vm+MVHvDclTsGMFpH3i8Y1L8ifS21Q7y7+q028xaPo2IoXvpGYIyDppR5/zeSsPdOUBOIPS8ym4MKudUfNBBOKYw30kG1wHXETLbdoFQE29yl9Vkw5G1UYSECV+EZ9mPUalyeCkNxhrmOdE1wfoVNASg2W1Dx9fjufKawQ3h1GXG43XonnJE+JwLUg97LQK0hOWs00kQ6SH7yQ5n0sWgkOoOOu9FhzmS0pbsGJ4UTR2txNWtI80IQ0eVw9ePo8JbfFb9aRdY8Uastf7pdGF8PIXWvACpwiAsciXeXtaXgBcQ8eFx1lJGmEBTzzO/6Fbj6Vhyss/a9uCkoc8v3ll1H177JWXj5xAWF1Ugmx1BjhyRFLxUoMDSqHDV4XmNoliS8DD9fUrF9BNJ3+LshOBtQkujI5EXTJyhgmrOfRpfarZejhGCBHT1WMxdxbjrW1ogpzdOCV0/fj9aTfXE4bKbosdZfAU2JzvNR+DMazlyRsCuyla6V5+0RE0bYLWPXLEzts11SGbxPfYZnE0T3cUlDOgGHJEO511ZwcpgX75cIQ94f8dnik6UwUMfG/1xsJKjFAuHpvclH6uuVydi+MkeEecnEMrKPO1S9dx2hy5wm3m6+HHS55hNs7RiqiVFNs0iYAx1CRg+LLboBdP
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:CH2PR10MB4391.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(36756003)(86362001)(31686004)(2906002)(966005)(6666004)(31696002)(6512007)(4326008)(316002)(107886003)(6486002)(921005)(44832011)(7416002)(956004)(2616005)(186003)(53546011)(6506007)(110136005)(5660300002)(26005)(478600001)(38100700002)(66476007)(66946007)(8936002)(66556008)(83380400001)(8676002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWorOExvL2hRKzRoOURsb2g4amtITjFwWUZKb1dkdnMybit0THNJK3IwcFV0?=
 =?utf-8?B?cFNTRUZkVjBZa3lidm51a2lQem9yV3lodmRsM2ZpMDd1WnU2MjQvbHNlcUlz?=
 =?utf-8?B?S3lvQ2VUaUEvalRBaEY2OUdudHI5VEFYSHc2R256cS9xMkgzQjZCWkQwTjFx?=
 =?utf-8?B?Wm1QN3NrOWg4M2dmMzZ5bjBPbUNqTEhkUllrME1ORExHakV3SXMwa0JVSnJn?=
 =?utf-8?B?YjRjcE5Dd2pwSk5ZWVNuQ1dUWHl1UGlBMndBeGwvNFFOS3BMOS9JUGtKeWxN?=
 =?utf-8?B?SktxQlg2QzJpWHpoMzlGaFJncHNPRmJXOElRNHVrNFBuQngyV1VDcnB1TjV3?=
 =?utf-8?B?elBQbWhvTklSVFNNbGoybUpCaTltNkJBMCtoTXp0bUVmWDhlN1JLSkhnaDVP?=
 =?utf-8?B?bkowblNYek94Vk5rTGZTbWZUN1FFZC94VFp1Z0lVY05PaFVkY1d4cHE4N2FX?=
 =?utf-8?B?eEllRTEzcVhmdCt2WmlYRVhTVnlRMVcwMytPdWtTWFprVytoR2x2QWQram9a?=
 =?utf-8?B?R2hMN1BnbUxWekZDeUl2ZHJzc3owZmttWlNiRmRaSkcyNVpDcXBRYll1c0RZ?=
 =?utf-8?B?SzVDUUZJbkNia2hQV3ppVWdzbVJ2a0xYU1FQY1U5T2xhdGloQVk4bytUQXo5?=
 =?utf-8?B?dGtOcEJBbXZabG5ySHFSd0xPZEFJOVpWZDVxOWMyb0JxdWpxSndzWDVrdWtT?=
 =?utf-8?B?WjFQUWlhZGFMUjJQdkpDRmJvaC93S25TNXU3WlBCYkFrb0ZQaWs5RXdLcnBy?=
 =?utf-8?B?RTMzNWR5Nm5Wb2dWSDRocnNmaGFYWS9MVFQyNHNZalpPcHM4c3RVTlh0Y1Nt?=
 =?utf-8?B?aWx6Rk12MFExK3ZvbjFGelg3Y3pGdEJIREZQQVhuQm5MdVNDbVIzUW9kOWJJ?=
 =?utf-8?B?bndya3RmNHhaaUc1LzRlNkp0STZZY1VBaXloa3dvQkxQakZKcWhXOFN4aEx6?=
 =?utf-8?B?UFJGQWxCdzEvSW9aeVJPSlVsM3hoanZkb3M2amkralMxYjhhYzR3NmFNbW1R?=
 =?utf-8?B?ZFBQU0VHYXNEZDVaWkpTZHJRMUlFTVpjL2lyWjR0OVlYVnprR1M2UUFzTEM5?=
 =?utf-8?B?aEJBT1NIRWRxR3k0SWIxemRRVGdDZ2g3enAvRzA1SktuSHc3NXdsaVJUMzc5?=
 =?utf-8?B?bGtJSE1KOWxDQWZmaXRZa0tSMmFoa0xlQ0hJcG5HSVo0bk4vMEkrOGpmYWlo?=
 =?utf-8?B?RHA3bktrS0RUUTBZVlg3ZnBncGhodFgwUlovcG5ZNGEyTVRBUDkvQjlIYmFk?=
 =?utf-8?B?YVVqby9WdzcwZ0x4dmNGN0VyWVErcUVxbjBrYVRmN0FGQklGWGFTdm82d1Av?=
 =?utf-8?B?Z2NYUzl2UXE5SFZXUEdBQURRaHhzYzM1eHhwenBaSkpubjc2TmR4b1h0cnJH?=
 =?utf-8?B?RUc3aUw2S3ExSVc5aGduU2RUb1RnNThYRENkVVM4STRraWpRaXEyVGtNb0Np?=
 =?utf-8?B?aC9yQXAwKzlrYmh2dnMrc0ttRmpBTW1tRkl5ZDgvcHJzY3ptNHo1WGVNc0Qx?=
 =?utf-8?B?T2NCMVhZbk9lam1yQ0hpaURWbjlzVk8wckZVSkFhRGM0eDR3L0E3K1RXNDh1?=
 =?utf-8?B?a21YZVJJOXlrUVFBS2M0UXorLzUzaWJTbjRmRXRmWjNaNkg0RHJRNVNWR1Q3?=
 =?utf-8?B?WG5HQlYwTjIrSnhYSnF4SXRsc2FhVGQrSWZLRTZGUTBDenIxS083NHVhbmJi?=
 =?utf-8?B?a1pyNDBoNlRGYndsNmxqRXdzZU5zSnE3dGJMclhvREVubitiRWovcmx5MG9v?=
 =?utf-8?Q?IcJ9sjyV1MvN3MxEZKAKM+I9O1rNVdSpWBQkACg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 499af761-1ea7-4eda-de6f-08d9454d873d
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:55:53.4328 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bLpsbrI7BHUcF2dFWwzXQjJzCsCZvI4L0W6tSGMoF1SXyZzreC+DCzV1NCI0UczuWf+xWFu7dWDK1sxzfOc56ia8ogWkQzukfhSJStWapuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4165
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043
 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120121
X-Proofpoint-GUID: 2ijBziU_6z06QF6himcroU2tlbXvq9J8
X-Proofpoint-ORIG-GUID: 2ijBziU_6z06QF6himcroU2tlbXvq9J8
Cc: konrad.wilk@oracle.com
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

CgpPbiA3LzEyLzIxIDU6NTEgUE0sIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4gSGkgUm9iaW4s
Cj4gCj4gT24gNy8xMi8yMSA0OjQ0IFBNLCBSb2JpbiBNdXJwaHkgd3JvdGU6Cj4+IE9uIDIwMjEt
MDctMTIgMTY6MTcsIEFsZXhhbmRyZSBDaGFydHJlIHdyb3RlOgo+Pj4gSW4gYSBLVk0gZ3Vlc3Qg
b24gYXJtNjQsIHBlcmZvcm1hbmNlIGNvdW50ZXJzIGludGVycnVwdHMgaGF2ZSBhbgo+Pj4gdW5u
ZWNlc3Nhcnkgb3ZlcmhlYWQgd2hpY2ggc2xvd3MgZG93biBleGVjdXRpb24gd2hlbiB1c2luZyB0
aGUgInBlcmYKPj4+IHJlY29yZCIgY29tbWFuZCBhbmQgbGltaXRzIHRoZSAicGVyZiByZWNvcmQi
IHNhbXBsaW5nIHBlcmlvZC4KPj4+Cj4+PiBUaGUgcHJvYmxlbSBpcyB0aGF0IHdoZW4gYSBndWVz
dCBWTSBkaXNhYmxlcyBjb3VudGVycyBieSBjbGVhcmluZyB0aGUKPj4+IFBNQ1JfRUwwLkUgYml0
IChiaXQgMCksIEtWTSB3aWxsIGRpc2FibGUgYWxsIGNvdW50ZXJzIGRlZmluZWQgaW4KPj4+IFBN
Q1JfRUwwIGV2ZW4gaWYgdGhleSBhcmUgbm90IGVuYWJsZWQgaW4gUE1DTlRFTlNFVF9FTDAuCj4+
Pgo+Pj4gS1ZNIGRpc2FibGVzIGEgY291bnRlciBieSBjYWxsaW5nIGludG8gdGhlIHBlcmYgZnJh
bWV3b3JrLCBpbiBwYXJ0aWN1bGFyCj4+PiBieSBjYWxsaW5nIHBlcmZfZXZlbnRfY3JlYXRlX2tl
cm5lbF9jb3VudGVyKCkgd2hpY2ggaXMgYSB0aW1lIGNvbnN1bWluZwo+Pj4gb3BlcmF0aW9uLiBT
bywgZm9yIGV4YW1wbGUsIHdpdGggYSBOZW92ZXJzZSBOMSBDUFUgY29yZSB3aGljaCBoYXMgNiBl
dmVudAo+Pj4gY291bnRlcnMgYW5kIG9uZSBjeWNsZSBjb3VudGVyLCBLVk0gd2lsbCBhbHdheXMg
ZGlzYWJsZSBhbGwgNyBjb3VudGVycwo+Pj4gZXZlbiBpZiBvbmx5IG9uZSBpcyBlbmFibGVkLgo+
Pj4KPj4+IFRoaXMgdHlwaWNhbGx5IGhhcHBlbnMgd2hlbiB1c2luZyB0aGUgInBlcmYgcmVjb3Jk
IiBjb21tYW5kIGluIGEgZ3Vlc3QKPj4+IFZNOiBwZXJmIHdpbGwgZGlzYWJsZSBhbGwgZXZlbnQg
Y291bnRlcnMgd2l0aCBQTUNOVEVOVFNFVF9FTDAgYW5kIG9ubHkKPj4+IHVzZXMgdGhlIGN5Y2xl
IGNvdW50ZXIuIEFuZCB3aGVuIHVzaW5nIHRoZSAicGVyZiByZWNvcmQiIC1GIG9wdGlvbiB3aXRo
Cj4+PiBhIGhpZ2ggcHJvZmlsaW5nIGZyZXF1ZW5jeSwgdGhlIG92ZXJoZWFkIG9mIEtWTSBkaXNh
YmxpbmcgYWxsIGNvdW50ZXJzCj4+PiBpbnN0ZWFkIG9mIG9uZSBvbiBldmVyeSBjb3VudGVyIGlu
dGVycnVwdCBiZWNvbWVzIHZlcnkgbm90aWNlYWJsZS4KPj4+Cj4+PiBUaGUgcHJvYmxlbSBpcyBm
aXhlZCBieSBoYXZpbmcgS1ZNIGRpc2FibGUgb25seSBjb3VudGVycyB3aGljaCBhcmUKPj4+IGVu
YWJsZWQgaW4gUE1DTlRFTlNFVF9FTDAuIElmIGEgY291bnRlciBpcyBub3QgZW5hYmxlZCBpbiBQ
TUNOVEVOU0VUX0VMMAo+Pj4gdGhlbiBLVk0gd2lsbCBub3QgZW5hYmxlIGl0IHdoZW4gc2V0dGlu
ZyBQTUNSX0VMMC5FIGFuZCBpdCB3aWxsIHJlbWFpbgo+Pj4gZGlzYWJsZWQgYXMgbG9uZyBhcyBp
dCBpcyBub3QgZW5hYmxlZCBpbiBQTUNOVEVOU0VUX0VMMC4gU28gdGhlcmUgaXMKPj4+IGVmZmVj
dGl2ZWx5IG5vIG5lZWQgdG8gZGlzYWJsZSBhIGNvdW50ZXIgd2hlbiBjbGVhcmluZyBQTUNSX0VM
MC5FIGlmIGl0Cj4+PiBpcyBub3QgZW5hYmxlZCBQTUNOVEVOU0VUX0VMMC4KPj4+Cj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBBbGV4YW5kcmUgQ2hhcnRyZSA8YWxleGFuZHJlLmNoYXJ0cmVAb3JhY2xlLmNv
bT4KPj4+IC0tLQo+Pj4gVGhlIHBhdGNoIGlzIGJhc2VkIG9uCj4+PiBodHRwczovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9tYXovYXJtLXBsYXRmb3Jtcy5naXQvbG9n
Lz9oPWt2bS1hcm02NC9wbXUvcmVzZXQtdmFsdWVzCj4+Pgo+Pj4gIMKgIGFyY2gvYXJtNjQva3Zt
L3BtdS1lbXVsLmMgfCA4ICsrKysrLS0tCj4+PiAgwqAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9r
dm0vcG11LWVtdWwuYyBiL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4+IGluZGV4IGZhZTRl
OTViNTg2Yy4uMWYzMTdjM2RhYzYxIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vcG11
LWVtdWwuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYwo+Pj4gQEAgLTU2Mywy
MSArNTYzLDIzIEBAIHZvaWQga3ZtX3BtdV9zb2Z0d2FyZV9pbmNyZW1lbnQoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LAo+Pj4gdTY0IHZhbCkKPj4+ICDCoMKgICovCj4+PiAgwqAgdm9pZCBrdm1fcG11
X2hhbmRsZV9wbWNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IHZhbCkKPj4+ICDCoCB7Cj4+
PiAtwqDCoMKgIHVuc2lnbmVkIGxvbmcgbWFzayA9IGt2bV9wbXVfdmFsaWRfY291bnRlcl9tYXNr
KHZjcHUpOwo+Pj4gK8KgwqDCoCB1bnNpZ25lZCBsb25nIG1hc2s7Cj4+PiAgwqDCoMKgwqDCoCBp
bnQgaTsKPj4+ICDCoCDCoMKgwqDCoMKgIGlmICh2YWwgJiBBUk1WOF9QTVVfUE1DUl9FKSB7Cj4+
PiAgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9wbXVfZW5hYmxlX2NvdW50ZXJfbWFzayh2Y3B1LAo+
Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fdmNwdV9zeXNfcmVnKHZjcHUs
IFBNQ05URU5TRVRfRUwwKSk7Cj4+PiAgwqDCoMKgwqDCoCB9IGVsc2Ugewo+Pj4gLcKgwqDCoMKg
wqDCoMKgIGt2bV9wbXVfZGlzYWJsZV9jb3VudGVyX21hc2sodmNwdSwgbWFzayk7Cj4+PiArwqDC
oMKgwqDCoMKgwqAga3ZtX3BtdV9kaXNhYmxlX2NvdW50ZXJfbWFzayh2Y3B1LAo+Pj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX192Y3B1X3N5c19yZWcodmNwdSwgUE1DTlRFTlNFVF9F
TDApKTsKPj4+ICDCoMKgwqDCoMKgIH0KPj4+ICDCoCDCoMKgwqDCoMKgIGlmICh2YWwgJiBBUk1W
OF9QTVVfUE1DUl9DKQo+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fcG11X3NldF9jb3VudGVy
X3ZhbHVlKHZjcHUsIEFSTVY4X1BNVV9DWUNMRV9JRFgsIDApOwo+Pj4gIMKgIMKgwqDCoMKgwqAg
aWYgKHZhbCAmIEFSTVY4X1BNVV9QTUNSX1ApIHsKPj4+IC3CoMKgwqDCoMKgwqDCoCBtYXNrICY9
IH5CSVQoQVJNVjhfUE1VX0NZQ0xFX0lEWCk7Cj4+PiArwqDCoMKgwqDCoMKgwqAgbWFzayA9IGt2
bV9wbXVfdmFsaWRfY291bnRlcl9tYXNrKHZjcHUpCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCAmIEJJVChBUk1WOF9QTVVfQ1lDTEVfSURYKTsKPj4KPj4gVGhpcyBsb29rcyBzdXNwaWNpb3Vz
bHkgb3Bwb3NpdGUgb2Ygd2hhdCBpdCByZXBsYWNlczsKPiAKPiBJdCBhbHdheXMgc2V0cyB0aGUg
Yml0LCB3aGljaCBnb2VzIGFnYWluc3QgdGhlIGFyY2hpdGVjdHVyZSBhbmQgdGhlIGNvZGUgaXQg
d2FzCj4gcmVwbGFjaW5nLCB5ZXMuCj4gCgpNeSBiYWQsIEkgc2NyZXcgdXAgYW5kIEkgZHJvcHBl
ZCB0aGUgfi4gSSB3aWxsIHJlc2VuZC4KClNvcnJ5LAoKYWxleC4KCj4+IGhvd2V2ZXIgZGlkIHdl
IGV2ZW4gbmVlZCB0byBkbyBhIGJpdHdpc2Ugb3BlcmF0aW9uIGhlcmUgaW4gdGhlIGZpcnN0IHBs
YWNlPwo+PiBDb3VsZG4ndCB3ZSBza2lwIHRoZSBjeWNsZSBjb3VudGVyIGJ5IGp1c3QgbGltaXRp
bmcgdGhlIGZvcl9lYWNoX3NldF9iaXQKPj4gaXRlcmF0aW9uIGJlbG93IHRvIDMxIGJpdHM/Cj4g
Cj4gVG8gcXVvdGUgbXlzZWxmIFsxXToKPiAKPiAiRW50ZXJ0YWluZWQgdGhlIGlkZWEgb2YgcmVz
dHJpY3RpbmcgdGhlIG51bWJlciBvZiBiaXRzIGluIGZvcl9lYWNoX3NldF9iaXQoKSB0bwo+IDMx
IHNpbmNlIExpbnV4IChhbmQgdGhlIGFyY2hpdGVjdHVyZSwgdG8gc29tZSBkZWdyZWUpIHRyZWF0
cyB0aGUgY3ljbGUgY291bnQKPiByZWdpc3RlciBhcyB0aGUgMzJuZCBldmVudCBjb3VudGVyLiBT
ZXR0bGVkIG9uIHRoaXMgYXBwcm9hY2ggYmVjYXVzZSBJIHRoaW5rIGl0J3MKPiBjbGVhcmVyLiIK
PiAKPiBUbyBleHBhbmQgb24gdGhhdCwgaW5jb3JyZWN0bHkgcmVzZXR0aW5nIHRoZSBjeWNsZSBj
b3VudGVyIHdhcyBpbnRyb2R1Y2VkIGJ5IGEKPiByZWZhY3RvcmluZywgc28gSSBwcmVmZXJyZWQg
bWFraW5nIGl0IHZlcnkgY2xlYXIgdGhhdCBQTUNSX0VMMC5QIGlzIG5vdCBzdXBwb3NlZAo+IHRv
IGNsZWFyIHRoZSBjeWNsZSBjb3VudGVyLgo+IAo+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9rdm1hcm0vMjAyMTA2MTgxMDUxMzkuODM3OTUtMS1hbGV4YW5kcnUuZWxpc2VpQGFybS5jb20v
Cj4gCj4gVGhhbmtzLAo+IAo+IEFsZXgKPiAKPj4KPj4gUm9iaW4uCj4+Cj4+PiAgwqDCoMKgwqDC
oMKgwqDCoMKgIGZvcl9lYWNoX3NldF9iaXQoaSwgJm1hc2ssIDMyKQo+Pj4gIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGt2bV9wbXVfc2V0X2NvdW50ZXJfdmFsdWUodmNwdSwgaSwgMCk7Cj4+
PiAgwqDCoMKgwqDCoCB9Cj4+Pgo+Pj4gYmFzZS1jb21taXQ6IDgzZjg3MGE2NjM1OTI3OTdjNTc2
ODQ2ZGIzNjExZTBhMTY2NGVkYTIKPj4+Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
