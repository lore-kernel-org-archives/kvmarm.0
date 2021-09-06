Return-Path: <SRS0=OUTu=OC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7651C433F5
	for <kvmarm@archiver.kernel.org>; Sun, 12 Sep 2021 16:33:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17E8360F25
	for <kvmarm@archiver.kernel.org>; Sun, 12 Sep 2021 16:33:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 17E8360F25
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80A9F4B1A5;
	Sun, 12 Sep 2021 12:33:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7nRFCTm2c25b; Sun, 12 Sep 2021 12:33:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6252C4B1ED;
	Sun, 12 Sep 2021 12:33:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 925474B240
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 14:03:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TVpQi2fbyFJP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Sep 2021 14:03:49 -0400 (EDT)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B8144B23C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 14:03:49 -0400 (EDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 186GSuvH028664; 
 Mon, 6 Sep 2021 18:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DihQvp1oh2lgTsz6RpAw7UOhzyalUdKTFKuwVtJY9nc=;
 b=yd06W7gfgZuOU9t5YNn7PQQNVbRHUkjP+1laO8xyQyB+VcrJpJ9ttlmYm3wNv4MGwGGj
 UN4RcdlmYNmvkPTDxxMQ/3LVzlT6v/u5PJiWdPT2Ud9dMXRyCRwU+/J22yNX0Ic5X18t
 4np968yHAsFmGlZec39rrSz2zV2A99mfcNPBILNrABY50JrXxPVbWpr0+aUgqtNLcBp2
 62Wi/QRTw1bR0t9yC6Osff5r3+5FXfNJOlQdYl4MVubLnHJLlbifXX99brUEu9pdbAb0
 wnIyTb/fETQ5D0l6jD2Tl76Oj/kualsXBsi9fMgKFtRIH83+cqxH3D1U6c0gnPEyJ0o6 YA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DihQvp1oh2lgTsz6RpAw7UOhzyalUdKTFKuwVtJY9nc=;
 b=ubXiEHIWHaJc8n8PW1WMNrTWZYr3fzP/ptTZxnSt/egYNP+BILlvlYfba4tFqzhJh14L
 m1/wmdqd7B1y/ZWY6FOYSTu8nQCm1GK1yCgEZob9if+V3bGnqcsNQ4MLEzLajcZt+iup
 UREKz89jUrwIDkH+IgoWYjAI9fUo7oh+iJ4IQ8U3nPrMG1fsUgCnH7773oQ89BnjwUU0
 zGe/d08SQdoB9R22VyxGXn53lQBJm5Lnny3icnlHyoXEQ6z9aOEsKyLqyv8SQSAGSzcm
 bNtNNQPJPSwcj2JTOiPkFTsURYnqSdopG86q7RrE8bpxRsSjSovS8sLPQM4oyV6mzwqr ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
 by mx0b-00069f02.pphosted.com with ESMTP id 3avy77jn71-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 06 Sep 2021 18:03:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
 by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 186I0AJS005532;
 Mon, 6 Sep 2021 18:03:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
 by userp3020.oracle.com with ESMTP id 3avqtcnp3v-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 06 Sep 2021 18:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GOBbhjdFYgmjKYrL9EIaV+JKO07HDeiN896NsYK5ntAyGlHajMgtXVcD9BeBEE+k6In7WugWGQqr33TiqiwdLGg9DoJseSd0hqucorZ5Js+RaZ1E1mvd/IfUbgmOh63RM2MGP45ikVz5hlA6oWM3HU/5PuvL0UAgpXvxFJp0YVv863rnCTTukeH+l/nUtWNk9RG7yzlma5Zqu3wJ9fxQBntAcpX75ttOyBxEmt9+/2ByCK0eN8VgdYtzjyWAv6/e0FL1EkdbsZtVgJjtEv+BZP6J7wHajvezIx+F3RnW7CUr1S64/E4eQGJfTbnsY4eefJIvNuyvIyNpFOUXw6cdLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version; 
 bh=DihQvp1oh2lgTsz6RpAw7UOhzyalUdKTFKuwVtJY9nc=;
 b=mH726d7vczEsihhfF95Z1KV2P6cUtRYVbTFlRxhKT416ABBn2BMMfpBoWjKr06iSuTrfT6mtRHA351JDuH8ACNKOG5AwJlwNcGgMf5inX/oqz9rqMPGk3vDIZ6NMAE2N0dxI/vAogVQWb6DZeUr2tQ6pCbGnc7EIVHrAwyVTgWJHZmnotC+Dc/QIGFiV98WJF1wTtG40qFuY/zlKeakWRll3HbuW7oqIxWBk61WQigdFdHKgzLMrpYNbdx4CIVjVGmbnA36zZnoTowD8rc6BLAB47KeHKhx+seAwWNKpz8xHE+sL4ZaUJNrJKr6VS3OSWaivkmBkR/CW3SNSeZyJ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DihQvp1oh2lgTsz6RpAw7UOhzyalUdKTFKuwVtJY9nc=;
 b=GGc+a6FOd+wBkEQ8BInSlvOrH3XlwwYxQ5r9mV+xWrrT2uYl304pBRe7iLBH2lVrzGQ2cnVGzyHpirdySMoOZZa0M+AsneBMgp+uj7kLGZ8EqkHZgrAO7IYuU2+vmMYW+8MO7fDaamZNqKcMfW5ikNG7vQmQpG1nC6M0jvT6tm4=
Authentication-Results: lists.cs.columbia.edu; dkim=none (message not signed)
 header.d=none; lists.cs.columbia.edu;
 dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5243.namprd10.prod.outlook.com (2603:10b6:610:dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.24; Mon, 6 Sep
 2021 18:03:42 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::18f4:28d6:63f1:58e8]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::18f4:28d6:63f1:58e8%5]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 18:03:42 +0000
From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 1/2] KVM: selftests: make memslot_perf_test arch
 independent
To: Ricardo Koller <ricarkol@google.com>
References: <20210903231154.25091-1-ricarkol@google.com>
 <20210903231154.25091-2-ricarkol@google.com>
Message-ID: <6082c051-03f1-653d-6188-b09974c62512@oracle.com>
Date: Mon, 6 Sep 2021 20:03:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210903231154.25091-2-ricarkol@google.com>
Content-Language: en-US
X-ClientProxiedBy: AM3PR03CA0075.eurprd03.prod.outlook.com
 (2603:10a6:207:5::33) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.175.250) by
 AM3PR03CA0075.eurprd03.prod.outlook.com (2603:10a6:207:5::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19 via Frontend Transport; Mon, 6 Sep 2021 18:03:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30f9db95-36aa-4d79-bc6c-08d97160a97b
X-MS-TrafficTypeDiagnostic: CH0PR10MB5243:
X-Microsoft-Antispam-PRVS: <CH0PR10MB524365D9FCBE27BDE8F02D25FFD29@CH0PR10MB5243.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HN5rf425KQd4FQJtI9OTipkJiT1DNTWFn0xYZ5YTUZYG0Osbrt4QEsKcjEm/dwWh++BeJZTGdcwqjHfgnNmtu7sQzk/u66oMkzKUP3gIJiKpXDurgFsNH1M9fSe6zpzyap7um1aypH5Y8pH6dPv4SNZekfMVEkZl1b3BnyRUFn1sZVcxA3zk40k7HOCDhxPMhpfpZ119Z8bzTcg2aoSXQlj0PguCfkkn9pfGF330zCV3Evd1ldqYVR3UrWgngFCLOXy9UEwbKV+B9RuLn8WzS/CVVhfZUJ27YCsUbObXbZRxK+dcPPfkVRx7svEQBudxPpmijgYNuOuklSmWZDLQUdiWjLmTxVkvNPoIvbEuVjCcaWBHwg9u2vvGmnVaE6In9SHo2j5iqIMQICoxYL0FFWfgrUfPmJi17d/STyGJeeEuDHqccfX4G16GoR57iXx7czAg/NFFcAF8Rr5RvcNR6IPmJUTVt3RzCbuVIQPDXAvDWvFeVaww3RLoU2g4r78axy0cw6PohNuckLEomS1D7t9gxMw9s0d6IfZiTph+oitcrHS65NExsCeKCW9NcB8olnvHo7AqJb2D8I7wT0iFHdoMGYNzncU2LJ5u14iNhwFsxuB+FkEnUNNeF/uqoymiS+1hWLLa5/X9GkR+sdCQ/0bUyUmhG6U6TTRn49RSH6o3AvOssnuQo+3PifjnhPzaPDdhDvfQwKDnocnWGMHE+xW75GTYj1a/V4/7B9QXwjA=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:CH2PR10MB4008.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(366004)(136003)(376002)(39860400002)(346002)(396003)(53546011)(2616005)(8936002)(7416002)(4326008)(31686004)(38100700002)(86362001)(5660300002)(31696002)(6916009)(36756003)(6666004)(316002)(4744005)(8676002)(66946007)(186003)(6486002)(66476007)(66556008)(956004)(26005)(478600001)(16576012)(2906002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm1uSGdmQWI3dVlOMGNVcGcwWUtuVDlHdit5NXd6SW9nOVhGcUxlNVhjbzQ3?=
 =?utf-8?B?NHA4Q0d2bTBMRDF1TUF0SHY3UjRNeUhvMENjTkpvVW5icHN5S05UdXNBR05n?=
 =?utf-8?B?T3pDRUxnSXhVL3liLzZRMERtWFFZcUZDZXFMdEZYNVVmOEtLTGQvaTdSNG9O?=
 =?utf-8?B?ZUxNbkNZRG9UajRxSWlBS0x6aFI2QlRaeHg5MVpQTVB2TEV1LzhwTUJ4Y2NH?=
 =?utf-8?B?MktVTUhzYkx6RTNUV1JpZ0NUbWJBNUVmSmNUV2hzK1FEUzUwV2swQThDU2ZV?=
 =?utf-8?B?NjJ0UWpMM1psSWtzaExpUk5JVENkYldWamF6RGRndzFqNDVqNkNYbjhGM0pF?=
 =?utf-8?B?M0prSVNHeXMvTS9zaEF5QmUybEhJTWVZNmk4TVNIeWxDM2hNTnJBc0s1UWNJ?=
 =?utf-8?B?cGRUd2gwV3JKWTlaMGxYRDc3MjlMcHdMbXg1Vi9MbTBzRXlnN0NoWFJBbVRD?=
 =?utf-8?B?Wno1RmlqakxnWW52Vkxvd2NiMlZzSXhOQWVFNE9DakRhbTJSSng4Rm12ek1N?=
 =?utf-8?B?RVg1ano0azh2NTBzY1FkZmgrc1p5WUZxUUhQTWhsWHZvWnpuVzgwUThWWmFO?=
 =?utf-8?B?VWhaaXFMOTBZTmh4UlJRS2tpM3cvdHh1WFhIL1YxeGhjKzhzWmU4RkZ5TXNw?=
 =?utf-8?B?Rm00MDU2STJBNy83ZmFmdm5BUlZFNVNUcS80aFpVWTMwL1VEWVF1TG5LOTdu?=
 =?utf-8?B?cDcxK1dPOVE1YlFPc3VGeGR3WCtwcDhIakFTTXlFNzJ2MWlhT3NoODFpbUND?=
 =?utf-8?B?N0Iyck9zekhTamFlSzFseUk0Uk5wVEpOanBMbXdwaFRpcjJqS3BiVWpBdnFD?=
 =?utf-8?B?NWVIaml1RDNOc0dTc1dVRzZLZjBMejVVQU5uVy9ILzdYRkI0ZE00OGhFZVpB?=
 =?utf-8?B?R1Q2OXQ2T2tKN3ZFYkJOTmE4b21ucVROS0pwMGJ4Z0EvdHUxV1BVc1BBT3Bo?=
 =?utf-8?B?bjI2MmFGdUR2RFo4MWcwcHdmZno0a1kxTy8xeWRaYkZRYVArdzVIR05WUG9n?=
 =?utf-8?B?VmtwQjF0ankvck5yZkI1SDBJTnN5bzFPalMwSUZmcmlMZFNCRXBEOHozbHJ1?=
 =?utf-8?B?TjNlTHV1QTJQVmFrSnJrTFVIVnhZK09KMDFvV3pJY2g5aVk1REtMcGFCZ1B5?=
 =?utf-8?B?V01aL0dnY0ZkWWNrYzNRYkREd2RMTXF4TnEyNHdRV0ZNT1B6RzY0Z0lNWUh3?=
 =?utf-8?B?YzY1dGpvOWsxZHYvWk9yTzFHd1dKU0tlUm1TRXNEa0w3SW9waWdnQ1NSUXlK?=
 =?utf-8?B?UTNwYzhQYmJOYVJNUVQwelV2SnhOYVRwUDdEck16NTM1ZlZjK3I2ZnoyUjk5?=
 =?utf-8?B?QjZQQW5OWmVMaVBWRVI3cmVHa2tDWGhYSGc4dVV6NGFISTJnMlBKQXNubktl?=
 =?utf-8?B?aG1FckNZQUlua1VGZzlsMnIvU0ExZiszajhBZjlxUFB2L3hMSTVHWDFTcEV2?=
 =?utf-8?B?Z0tlOE9aanZZRjN0RlFObTc1Q2xRa2JoVzF1a0FRenlrZ3N3dkFIZE5TV0x6?=
 =?utf-8?B?Mi93TlBmTVRyNlpUODFsRDc0QXM4d3htRnJycWZIOFE2Y0ZyY0hKK0xacTRt?=
 =?utf-8?B?UmZpZTVuRW9XaG5kOUg2eEpoK1VjL3hyZ25KNkYyRTI2NC92NkVHUFl4dkNO?=
 =?utf-8?B?Z3o4WUltY1FLTzc2L201NTNHM1g4U0g1ZnVQMmllSGlSNzRndkM1cXpEZ3l4?=
 =?utf-8?B?cWUrUEpVZWJXTExkVFA2K01HZ1dkck1oOHdWcVovTE11OWk5eVlGRk5BdHR1?=
 =?utf-8?Q?rn48ajG7ykmJJjKHXoEzM+Mdmm/bY9FszHYQssH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f9db95-36aa-4d79-bc6c-08d97160a97b
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2021 18:03:42.6312 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5OjfSgTqAPKYW6t/mJRsu1175sAYWBoYJxsnVdtxQKyG7l/OKIwcYG+lTAfjF3jG4P8Jpd512WR2dWgwZSHEQEVmG9LW6lBWr0WhRArxZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5243
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099
 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060115
X-Proofpoint-ORIG-GUID: jfn79EwcB4W31k_b_dXNf1uxzkX5qD4t
X-Proofpoint-GUID: jfn79EwcB4W31k_b_dXNf1uxzkX5qD4t
X-Mailman-Approved-At: Sun, 12 Sep 2021 12:33:05 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 04.09.2021 01:11, Ricardo Koller wrote:
> memslot_perf_test uses ucalls for synchronization between guest and
> host. Ucalls API is architecture independent: tests do not need know
> what kind of exit they generate on a specific arch.  More specifically,
> there is no need to check whether an exit is KVM_EXIT_IO in x86 for the
> host to know that the exit is ucall related, as get_ucall() already
> makes that check.
> 
> Change memslot_perf_test to not require specifying what exit does a
> ucall generate. Also add a missing ucall_init.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
