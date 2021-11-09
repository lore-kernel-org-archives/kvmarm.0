Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077E9C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 10:50:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC19B61159
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 10:50:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AC19B61159
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E4CD4B27B;
	Tue,  9 Nov 2021 05:50:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G-WyhsfsVw0b; Tue,  9 Nov 2021 05:50:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31FA74B224;
	Tue,  9 Nov 2021 05:50:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C827C4B15E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 19:39:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JL50vwSRVewi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 19:39:38 -0500 (EST)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE4584B15C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 19:39:38 -0500 (EST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A901Cwr001193; 
 Tue, 9 Nov 2021 00:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZqwU7SO5kjgZo4KWX5CGyMPfC1kSpvIAS3Z54e4T9DA=;
 b=uKb4UEOEBoTqgdj4s1vQYPVOU0uHwiniuOiQKTjc7bYyow4jFNm+FAXrNnC6aFiQdD7b
 1GPloGZtbz2L/7s2FShb/lP5wDYneBiYjBtKEr1liedlBZBM0E7s7nNVghoF+mvvni5G
 VJeuYcLwBfKOtP5HUD/8WyoizWLwFa/QSgwYhdoFTAeQea/3N9XPDLtbr1rFAyVolQTo
 RbMUpJyX7VAme5dkp0M2RP2iX7H6clk6gxOybXLFwko5K7j7dgqo1s4J2gIHdSwpPfDr
 WhpewzBfdE1HN26QfqD/krlX4/y6Y8VnWGtHqXP5jdglHlIEIVR6/ljQmn5YqoL4B5wp ZA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
 by mx0b-00069f02.pphosted.com with ESMTP id 3c6uh4fnpd-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Nov 2021 00:39:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
 by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90aa17054111;
 Tue, 9 Nov 2021 00:39:29 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com
 (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
 by userp3020.oracle.com with ESMTP id 3c63fs5e6e-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Nov 2021 00:39:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFAanhkCWS8idvosbWxH5H4mDtc1XpRsTF2QhHBRteSuBfOKUOSG+FSvzbWrbhdJpgn1VhkNm3ZiSERVrplHdhRVNu4Ha5f/7ifhZ83ypa3tqwXz+jaP7eEe4TYJovJUvz30YX683rOHR55W3lSt0re5oKUShpO80bFPglh+8Dh93y1J5+vAYQhQ8rNtLcB3gb0d9lUqMna31FORHaLiyZuR4wSk38fKqjx7M0dCr+4HEVAdV6WrjU1YL3kSecGrz8ZsuwYrr4mOeYAlqC69czvTUPepwJ8wfBv2JOev91M1nNO9J24+qf+sJy8plEcdbmgjB65cH9IoY7LH4kV4Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqwU7SO5kjgZo4KWX5CGyMPfC1kSpvIAS3Z54e4T9DA=;
 b=HXyL2rXUYTT2IT7GM2zDWdf/R3o179e+0hc4H+3zAuY4c1isUNv1n7bhtfVO7Et1FbWUYzoRw/fnU+h0qUKqf7Lp81hGumz+85pT88DESFBw2I2KzohZlWnUbetdcxdRGkdxWAWL4YwAqheZ+bjV8N2IaRQrv6A1VmZGIEHiW/EK7Lo1WbWBBYBXxEQvYenCbmSfXSOSL+VrI627CDZy0LEWXvBj7pJ7Jq4waox83OWGCNkUnEfPXb5iO6y0vkC6OlRABkyEwQ16E+P/WvKwVB97hUm7aN6CI4j+KzT+m1gEMmdTF8oeCcDjwCzd2zhJEJMzIXEwpGCzEIhPBjncHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqwU7SO5kjgZo4KWX5CGyMPfC1kSpvIAS3Z54e4T9DA=;
 b=MBuVbwDSBBfF97Hog8JlYOu9k4JN9rqnxUL6EGtXGsR9POrrWuNJ+53pVz52MTIIIXp++KtoLZDIknBwACIY+0nptku5bDDdHxsIY281K9wfwZct0Hcjtnka6ooML/MAhBI47wvbRXEsKBwL7kAI6RmLcLLR5ZtlpN+qSSzsldA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5273.namprd10.prod.outlook.com (2603:10b6:610:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:39:26 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:39:26 +0000
From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 06/30] KVM: Use "new" memslot's address space ID
 instead of dedicated param
To: Sean Christopherson <seanjc@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-7-seanjc@google.com>
Message-ID: <eab8516c-eaf3-263f-d512-e7ac585ecab8@oracle.com>
Date: Tue, 9 Nov 2021 01:39:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-7-seanjc@google.com>
Content-Language: en-US
X-ClientProxiedBy: FR0P281CA0002.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::7) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by
 FR0P281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.6 via Frontend Transport; Tue, 9 Nov 2021 00:39:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2c4333a-3fa8-4c08-583b-08d9a3196202
X-MS-TrafficTypeDiagnostic: CH0PR10MB5273:
X-Microsoft-Antispam-PRVS: <CH0PR10MB5273DD3861088D0A837CB7BDFF929@CH0PR10MB5273.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4f1o8Wszyc1K1X3gM3R523/+b8MfrsQwBrMHrjRFqBPe1LtraMdGmlJ+G32Sr+E9Co2znoaMPMA2trvRUWEtOU4DHrNoCsgS1auKKn5QDHWV1MwkpL/u76++mlvDjS9nEYWL3rMYNCzVK6ANVrlUcLfAu3Jmm0rzP16ziqgCfmNZK6tYbuWGXlbsMR5VLK4rFK+vAntdGG8Ltqao5RbIt2x3wHUoe30Y+2pFuRiY16q6mtLEsF8/USt2K6HkDDmFAaFiV+BIBdkyIQP724/Z4BYnHonC2AKfJpr4RN1d+klB/1YSH6i53yoetNruwd6ZhzaIKGNRa4ZskBxFkAR/50gSHxSOyrlEjAMzWhYlCVaIW1AvTogCKJH6YE2/oQE0AFv5eiV6x6hy1hLhBLGoyXARoAIgW6etLntsfPKDGprdScO9ZH+1csUBQejrIvL3CQGbX8Gf9XA4t+yAsNjWE49QIerXNxV2slqNXae14oWDAz7rgSeG61pEubHxDFAuJiHgcbBDTpe9fzH5SK8OQIgTAzOk419mur8djukVC+u3VnmKnxYf7joOm26GpwvhCm7DGueF32ZAnwIy/4O+B5Z/MZEbvuDp7hB9uf/m/N3QdXr0unI6Ll9C2lN8wkG1yx+5Ei7L6FJLQ3YgzJtIrh7oIhu5FGUkjTbR4HMRCnprRxlY/hbcEWyJVqv670vEUlqpYDftMxGvm6iJiuycIVHjCX3m9TL7TVF6laI0Qk=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:CH2PR10MB4008.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(366004)(6666004)(83380400001)(8936002)(7416002)(508600001)(2906002)(316002)(7406005)(38100700002)(86362001)(186003)(53546011)(4744005)(5660300002)(6916009)(31686004)(4326008)(956004)(31696002)(6486002)(66946007)(36756003)(54906003)(26005)(2616005)(66476007)(66556008)(16576012)(8676002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akxQVzBFODh4OVhNSkVKVjV0L28yc3F4VThqdk9CSTZMZ29IKzdaUVFzaHR2?=
 =?utf-8?B?Q01ZNS8rNWFCTFFaUXlZLy9NcW9RdDNaR2NxSEU0WElkaHJWWW5XZnhMdEhI?=
 =?utf-8?B?UFJZaFJFOXZ3K1o0WlRJeGtNV2ZQWUZlbGl1VjRJMHNzRnk3b2M4OTBYbzBz?=
 =?utf-8?B?ZFdmYktjR0wyTHJkKytKYjJsbjJOSVAwUnliY1ZaYXdtUm5rWWF0WTBFSGlh?=
 =?utf-8?B?RlA3UE9Cc3czQlhmVThLUWZITFNDZi9ZMngyQ3dBYmE5MHNKcU1LVkFoaEs4?=
 =?utf-8?B?cEZxOVB4MkFvYjB2ZFNiRk4wWk1TRGdQSWQ5N2RPRy8vcSt4dHE3Q0dwUUc5?=
 =?utf-8?B?Vk5zM1F1Zm04Rk5LOWd3N1QyVE9MUzBJZ0hKalJTTGdYRmRUbDVtalZ3NUxU?=
 =?utf-8?B?amxOU0ZXMXpBSnYrVjhUTkNJRWpWSDhxUVBZbGZGamFyczFUL3BsSkNMVFpO?=
 =?utf-8?B?NmFqcVQxMU44ZUhoUE04TkFRUU0vVWI5UFNiT0hUUXdrYWJmTXJWeVBzZi9q?=
 =?utf-8?B?R0c0SW5hQnpsamxNOWxFbm4vajlkRUpHQlRaazRhT3BPanh4ZHRGaGpVS25G?=
 =?utf-8?B?ZytSa1N3WkpUTTZKR29qOEoxVGpsb2FzMFVPNS96RmlzTDlCT2FueXR4cTVx?=
 =?utf-8?B?UGhHemxSK2NkRnhUeVoxcUFYbHpUakgzeU8vbTNLTk13a1drWGlGSXZIbXQ4?=
 =?utf-8?B?ZElFSnlpY2dqTXpNd2pLZDUza2R3UzlGRitteFQ2cVlYV0pubXlkU0pWL1Bz?=
 =?utf-8?B?Rzk5elJKSnFaRkh2aGNwRHBEM1dZRlZqMkNiNXlQbTFVaXlVT3N4cTRaZ0lJ?=
 =?utf-8?B?NGNBRWZ1R21wb0hKWWdPZ1hSZm1VRXMxK0NHbnhMbVRaUnJOakdBczBDT0tj?=
 =?utf-8?B?M3pKOFNENG9ZdGV2MERPNEp1TUc5QWdMenZRUDUxV25ObmpCUnB5dk9wdCtH?=
 =?utf-8?B?anY5YndqK1p0Lzh1dHJhMU9nT2R6NG50RHJRbU9JMjRXOTg4L2tRU0hnb0Zl?=
 =?utf-8?B?YXNwMHVXZVBqVkxUZXQ4OHhFczVRd0lTRXliZDY5dzJqTGVTM1MxZHpXV0da?=
 =?utf-8?B?ME1LWEVEcTBVcmU2OVR4aXJkMytWYVMwN3dqWkM1a0VEMGkyc0pzY0xmQmc5?=
 =?utf-8?B?SzJZYUthc0FEcTZsbXF2OUNJR24vb1dnVWlxTUVKYzhlVUNYZlNNMGIwbC95?=
 =?utf-8?B?REo3KytUSW1qUUZjazlnalp3cVFqVTRiNHVsRVBXMjRsMkcrSm1MUXM0dzJU?=
 =?utf-8?B?Ulk4TzM0Wk15YXZSTkxaUmxwTjF1azdoSlpWSU56L3hlUE8xY2ZxSzQ3S1o4?=
 =?utf-8?B?NTkvV1BrOXJZMmcxVG44UFVvemg1V09tVS8xNytBcE9xVVdSYllOeE9XLytT?=
 =?utf-8?B?SFVpTDZIS0hPK3hSM241R243cW8wUkc1K3hDNXlSTkNSaThLK0VrRVIwV01u?=
 =?utf-8?B?RU9rZm9DaDI2TTk3clZaTHcxOHJBSmJpTEROLzFsbU96aXp2cU53WnM3bnNy?=
 =?utf-8?B?NWIveUZBWXd3bUF4OWRSZDJEUVJDRXU0VEczWjJiQ3J2aFlPUThMenlqSkJJ?=
 =?utf-8?B?VGdFcW5PZHJRVUQ1R3hldUxvTjFiL0xhUFdVNTRaTFVHV2dxWUlYdWh6NWw0?=
 =?utf-8?B?THRZSngvSURuNERFNU5iSHFLZWNOdHhxTHVhMGYxb2xWL3ZLWHRYY2dvbW5i?=
 =?utf-8?B?QXIrSGdRaHNWN3V2TnNoRlROYVA4cUlFSkdHbDIvc0NVM1Jtb0Z3RUZ3YlJp?=
 =?utf-8?B?RW5hNkZzTWJBL01KWE1yUCtSQkNBOFF4aVVlNDFEcEtTZnFuRk94MGw3ZVlR?=
 =?utf-8?B?WjFwYytRZ1A5OEQ0RWpsakh3SDN2YVhyeHR1Zkx4NU1SV1ppY0J4REFlZTFw?=
 =?utf-8?B?bWVCQ0pMRUk3UDl1SHRleG9nQjdERlZUbVloWkhuTTcrNHphcHFHQlpJMGNT?=
 =?utf-8?B?dGQvMXQyZWluQUU1eTR6YVV5K3JiM2ZLTGs4YUFXak81WWo5RHZmT0dURjJq?=
 =?utf-8?B?c0tBclo4ekc4cWFuYmtGaVlrN2NCM3R6N25ZSFptazZCSTBxb0N5VGpKQm1E?=
 =?utf-8?B?U0IxeGMvNHFpYnJVWjlqRlhlbnE4d2FkVXdOTHFVTmxkNlVrMmJjWFR5MEFM?=
 =?utf-8?B?RzJnUnlDNHVValo0cDUyQk5aRUpWZXpJb2I2SmJ6R2ZRcXZ6RTh3UTdmZTJL?=
 =?utf-8?B?MXJLM0JQc2t4b2lXdGJhcE1VQnNjeks0b1VROEdlL25xSEpqazBEbnNBNUZW?=
 =?utf-8?B?UTNrZzJydGhZUktPZ0kxcS92THBBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c4333a-3fa8-4c08-583b-08d9a3196202
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:39:26.5155 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cxCFGmTPJyJZ5LJ4YVddwIbewWTqfEgdm+DkLsSnysNYmAUBudb9W56GinqXL50s3gf/ue8WWWUBtcVRkAaAvEZFOX6i1lXn7I48iYkDol0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5273
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162
 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-ORIG-GUID: 1T4ZO6QSVDt0a7g_M3PscLQp6uSHLZe6
X-Proofpoint-GUID: 1T4ZO6QSVDt0a7g_M3PscLQp6uSHLZe6
X-Mailman-Approved-At: Tue, 09 Nov 2021 05:50:26 -0500
Cc: Anup Patel <anup.patel@wdc.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 kvm-ppc@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 04.11.2021 01:25, Sean Christopherson wrote:
> Now that the address space ID is stored in every slot, including fake
> slots used for deletion, use the slot's as_id instead of passing in the
> redundant information as a param to kvm_set_memslot().  This will greatly
> simplify future memslot work by avoiding passing a large number of
> variables around purely to honor @as_id.
> 
> Drop a comment in the DELETE path about new->as_id being provided purely
> for debug, as that's now a lie.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
