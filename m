Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F54FC433F5
	for <kvmarm@archiver.kernel.org>; Sun, 21 Nov 2021 21:13:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 497DE4B086;
	Sun, 21 Nov 2021 16:13:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@nextfourgroupoy.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rHwE8susTw9O; Sun, 21 Nov 2021 16:13:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 970514B1CA;
	Sun, 21 Nov 2021 16:13:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D19344B0EF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Nov 2021 11:30:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QlcznwSQqEiH for <kvmarm@lists.cs.columbia.edu>;
 Sat, 20 Nov 2021 11:30:25 -0500 (EST)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr150040.outbound.protection.outlook.com [40.107.15.40])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D384040C88
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Nov 2021 11:30:25 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qe+YSg/8CiCLVhCAuNIOhD130WyPrkAVkSVm1dNJwittJ+F2qKqjh4WdzjjS3rubdw2UFk5imxOdxHZWrbmEu4ocy7U2SRDyrMsOmojuekIkd5mOezo/uALnCzXXV4Pp2B7qoRsC+F/KbpKFmZykI+bbEfx/DdZV+4bfUBkf0JbpCwfSJhIjRqHGl9RiYjyH0ZrfKx/3fJ/SIiJinA8RWW0hus+yJ66vB0iCommV8S4y5eRs/7DrfEKWD/sIY4A+rsuo1LVQrde6xP6Jj/2nulxtLQxvfu0QtiC9aDS5/13LA+sCWA9FZgQCIjbl82LLyXvhVthWlbi3RN/EJvSb/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fuorUIDJ10syTZ83FH4BhOwXIcTWC2m2jgrIkRDpEec=;
 b=VpxdTo7IMF7jnnCzAwhj57qdM5NmcBsxLllXgllyeDv8pBA2cG33Zr+J+BuQYiwqJj4wxu9oV0yuXa+rF2w8oP0vdzdLBj3qjBRL207Tvg4ohqXySGMkUl0/Tsq3u+WZeT04s3RSeuiK3KWX2QR0DSnlR/l2BVyPqva3Npg45ZGB/EMbj1H/EEZ6mIl8XRIipXRajlFORFGOEIluW1fEMCjcWP9ESWF0+nJ2XWNWsVoJ+KInz4C4GywaaOrJhy4jQOlhajTWEVOfoYGp+1MRYq1gjnHN64nO6RlUmlWH5uT4niXVC120c9D0uavCmWFAZR1/WHLlVMgD3qQkqLqjYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuorUIDJ10syTZ83FH4BhOwXIcTWC2m2jgrIkRDpEec=;
 b=Souxx6s8HSiJfrWOuEcH8gfbTskVQ2yM2WjxlAJ3xpD6J5GPLyD0AdKnjRZiRYiwfwL+77HvdAd8YVd7tZfgkq2y0hSVOZK8wAmo1S676DFj5Zpe9s6FqCo9CRXfKRDoKsd/vanHZtjS5Yk2K1u+quRMtrbDnYBYcZXYSTDGDb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nextfour.com;
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com (2603:10a6:10:194::6)
 by DB8PR03MB5546.eurprd03.prod.outlook.com (2603:10a6:10:106::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sat, 20 Nov
 2021 16:30:23 +0000
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::78b9:c389:1d86:b28e]) by DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::78b9:c389:1d86:b28e%8]) with mapi id 15.20.4713.024; Sat, 20 Nov 2021
 16:30:23 +0000
Subject: Re: [PATCH v4 11/11] KVM: x86: First attempt at converting nested
 virtual APIC page to gpc
To: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
References: <20211120102810.8858-1-dwmw2@infradead.org>
 <20211120102810.8858-12-dwmw2@infradead.org>
 <d87de1ec-8be7-3967-87b2-c8906c1ab1b3@nextfour.com>
 <8f434989aebd257a36cafcb414edcc5906c02728.camel@infradead.org>
From: =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Message-ID: <b806de35-167a-4c7c-f143-cff3ec279491@nextfour.com>
Date: Sat, 20 Nov 2021 18:30:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <8f434989aebd257a36cafcb414edcc5906c02728.camel@infradead.org>
Content-Language: en-US
X-ClientProxiedBy: HE1PR05CA0307.eurprd05.prod.outlook.com
 (2603:10a6:7:93::38) To DBAPR03MB6630.eurprd03.prod.outlook.com
 (2603:10a6:10:194::6)
MIME-Version: 1.0
Received: from [192.168.1.121] (91.145.109.188) by
 HE1PR05CA0307.eurprd05.prod.outlook.com (2603:10a6:7:93::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.19 via Frontend Transport; Sat, 20 Nov 2021 16:30:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81f9dad8-862d-4ed8-b579-08d9ac430cf2
X-MS-TrafficTypeDiagnostic: DB8PR03MB5546:
X-Microsoft-Antispam-PRVS: <DB8PR03MB55469B336CDBAE0A8F71AB1D839D9@DB8PR03MB5546.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +JoNZ1kg7O3Ltu/OYsQfTWwJqqh0QigBQs5kaGf+nhbMrMvz3G6si0TclBBs/NPQHEvIFfFBUstyu2i4JeqFJz3q1ceze9yQPDnfUkNNO0yMpmsQYa+x6hSw9umqRTFHOPYojicq5+9J8F3ge5PMXY+Xvz47Yq0kT0/I9yBr5vPuF/fL5MuiAXfrVaLQ5XCVwoOm+qCNleDIzknxx+tG72++T5i1+qK9/Ssr0hRqk5iXjGZFB714mL81vqXQV+wldmAebboWNTja5ZhbWGUBe8Dmh+znlJvrb/mec98uil2AmNgwVfQrBeR3L05FsflqlcGRVAey/aK3tSd529kZ4r7VMcCtVuS7mz8lXSqckLuKQvIzR7G5U4ZcngQDftnms08aVRrXx7dja8yQTRlf182tyHNlYJdb5hLPT9l77OuPwWa6ClQ8bJXyAqvzcPNXYOJFUlQF4qvRrX18vLZnCXGO9Fue8NR7mHJNRcdkeVuaR1U1/m4qMyZWn5glYOlYcCD1m9YQ67uo3kFW9BrYMXsCXvcxMgZQs8Cp6oV7QEn/ee40OJ2+Z1wFB4+pivA0wtpG9tM9TZBk2aoSspbjHsrE6lIzBqFnpfno7KKojb6kPu/75dmSY7iV33FIjPTUYEkBuh/Yh35cBtk+Hos1unNwSOZm1fFe5ipvYuEqSaJMIjEC/9dx0xNPY/Ydmi3YmZZeGy0ZA+NQTybLj5oNvMMLwWgFYKtq1FSFrn2NTD3qLnibA8wnpzPMe5DZ3w/OHs15FlheUAo17Jl91kYTMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DBAPR03MB6630.eurprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(39830400003)(346002)(376002)(366004)(396003)(136003)(8936002)(86362001)(6486002)(38350700002)(38100700002)(7416002)(7406005)(8676002)(83380400001)(2616005)(956004)(66476007)(186003)(31696002)(508600001)(5660300002)(4001150100001)(31686004)(26005)(66556008)(2906002)(4744005)(36756003)(316002)(16576012)(66946007)(54906003)(4326008)(110136005)(52116002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDdua0tkWkJ2U0pRU3RpZVhtL1FzNndndlRWeTdwdnFmVnZGazdiY1pUUGFT?=
 =?utf-8?B?bms5eFdnL25rUDVXa240ZmFrN3gySU9jMmhDUFN2ZmIwdDVkVDU3cmU4V010?=
 =?utf-8?B?SEdLN3I3VVExam9RNUF5eXJTR2xlZ2lSRjgxa1hJNXgwL09UUWI1Y0hzTkRt?=
 =?utf-8?B?QUU3L0J5TXROWFlQZkVBWDJZd1J2OEFzSDV6OTRNbWF5cjdFV2g1ekQxR25r?=
 =?utf-8?B?Y0VIemtBckJ1eHVxeTBRbW9HRll6V3EvRHBvUXRENFRBVG9oU2k0MTNsZ0F3?=
 =?utf-8?B?TjFoZkpDekdrdGVNcWlTdGw0clhVOHpXdlJhZVNDUmZkUTRObzlWZG5XRTNT?=
 =?utf-8?B?RWRRaFJ6MEtBWDNhK3VIUmZpT0pKRW9aUGNSZFVPUjZOMnYxNEk1SHNTRnVC?=
 =?utf-8?B?ZTZweXlhejU1elV0cUEyWUw5Q1dIbTVsaTlTMm5rQ1MyNTBrSGpvZ3d5eWR2?=
 =?utf-8?B?Y2Q5d3RXZ2dDcmtRK0xld1lQamlXc2xwbnZsVU9pZ09tUzA2WnJ4Z0lGVVBC?=
 =?utf-8?B?alE4aSt6MGl5cTZoN1pSczFHZHZXamg2RGltWTlmdmVPU200N1pUNHVPaVp0?=
 =?utf-8?B?MzBBT1pGRjh5bndZK0E5V29DRyszaGxOWkRwLytKVEkrYTlsejNLaUNSWVpS?=
 =?utf-8?B?a214amRBNklLclhSVGE3K2o2R0czSjhHK0M5c2lveG1MckJ1T2RWQWxYeDQw?=
 =?utf-8?B?blJCcFM0M08vWWs3am5iU1d4MmtrUDk4aE5SQ3pGMkYvYWp6SmlhcVNON1NK?=
 =?utf-8?B?azJ1NFpxSnlDZS9jNDZPYytDbTkvZjY5L1N5MFdqZlJjQ1hObjhZSjVMY2Ex?=
 =?utf-8?B?V3N6UjAyWCt6M2dsbktSeXB1VFlPTXBsa0UvNk9XUWJwWk5jVjlUbXF5S1V1?=
 =?utf-8?B?SnY0Tnc2ajhQaFZ1N1V1bXV3dGhOWjcreTd0eHhhL1NaWkt6SS9uZGF2N3Uz?=
 =?utf-8?B?NFdqV3FSbGVGdm95ZzBpaXNSTXVBYWsyR2U2cG5ONTIzTEpVeGJtdC9rcVlE?=
 =?utf-8?B?QkJNbWVrS1gwclBoVUR6SHFhTGpSaEg0NGt2UkRvazJ1WERFaUNlUHJWTm9J?=
 =?utf-8?B?cnJNcTVQOUhWdDFhbnBBalJLV2luSFNWSFV3WCtZOEJHRWRzVFFyTUVVQ1pG?=
 =?utf-8?B?OFNXbUxkQnV5bDhQaHROWDhFeVA2L3FRaVZlZDVsUWtmSmVqbTZ2aWpqekph?=
 =?utf-8?B?akNtR0Vsc1pBZEVoa1JaVHhmQmYwdHlrazIrczZRTHhPY1BqL08waWdPeDJn?=
 =?utf-8?B?OTNNbDFlTmh2TkRyLzhBeFozcWU0VFlEbHppb3VSdVJRRDhGUDhFOThUZU5O?=
 =?utf-8?B?ampWK2ppS1NJMjRlS2ZlTVVBOFhNcmN0Y2ZrYjkzYlBtRjUzSFBnem5YUkpE?=
 =?utf-8?B?SkxZNnpGQkIwWlFQRFpXUkZRY3QvamF2Q3hqNUF0NkNNWEdyMEtUck16dTZ1?=
 =?utf-8?B?TitubVVQZjQxaUtpWnZDMC9za3ZGN2tFckhNUjlubDVrcTlMcmsyRkdlYnJG?=
 =?utf-8?B?MnZmUDl6NlVQQTA5OU0xdk1BQUJPaG9BV2d0ZkxKUzF4QmZHZGtkYWY1TlBy?=
 =?utf-8?B?dGd2eTE2bkM2czVqOU5UZzlDcHQzNVJHU2oyK3MrVis5VnRCQ1hrSGVSaS93?=
 =?utf-8?B?c1JZM3dKUXlFamt4S3pIcml6bjZRcVRTcGxVMngyNzd0UFQ5cWdvalk0OFdm?=
 =?utf-8?B?cVZ2N3RQZlZpV09Qb21Vc1FDRHNrTWdINzJqTVVXM0lmdGtPaDVvSXl2Nnlt?=
 =?utf-8?B?bXhuVUdFRmcreXpVWXR2WmNYbHdIczJ5NVBmdFBOMG5BQlovV2dFdWdqUnQr?=
 =?utf-8?B?YlRGS0hOOTJUMndHTTJobTBJRmhZQmNkL2VWUEdBbEg4alRNNXg2MFVoTktx?=
 =?utf-8?B?UWFFVzUwdS9sTE1zYWtTKzdTQVdxUnNvMVpPNWtwRVJYUy9ySzdCWHFMYkgy?=
 =?utf-8?B?TzRiUEhFMmJReVN6SE93UXd0MmxoYWVBMFJJNWl1TGlmc2phMG9oL0lMOXVl?=
 =?utf-8?B?UE1rWmluOWhLNTNoMDkwR09Uek1rVXlIWVhHZk11d3IxT0JwaWNFcEhWRmJy?=
 =?utf-8?B?N0Z0NUt1L2llSW1jQzdzZHZmeUpuMmhVeVIrajh6TzlkQTJsL3BHaFhpb1Zl?=
 =?utf-8?B?N3BsSkVQWHU3UDVJcTBrV2VVTFQ1WGI4TUpqd00zbGp6R3JtME5DbVFwcjhj?=
 =?utf-8?B?bklzWjFVVlE0SE84c0xpQkRCcGJrRnlzV01KTmFJRS9rVVArNjZBS2JjVm1T?=
 =?utf-8?B?Sms0c2FvOWMxQWoxV3ZEeU5YMTZBPT0=?=
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81f9dad8-862d-4ed8-b579-08d9ac430cf2
X-MS-Exchange-CrossTenant-AuthSource: DBAPR03MB6630.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 16:30:23.1128 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHbOCN26dQF83LOG6qSJq/RLg4PcEjkWKMjmDqspL3Y/6v/Ao4HzOXwGrpAARrlZAKqOX/U1dS2FW1dD2FCTcooK4xVz3MuTLhOqaOPH8G8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5546
X-Mailman-Approved-At: Sun, 21 Nov 2021 16:13:30 -0500
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

CgpPbiAyMC4xMS4yMDIxIDE4LjIxLCBEYXZpZCBXb29kaG91c2Ugd3JvdGU6Cj4gT24gU2F0LCAy
MDIxLTExLTIwIGF0IDE3OjQ4ICswMjAwLCBNaWthIFBlbnR0aWzDpCB3cm90ZToKPj4+IEBAIC05
Nzg1LDYgKzk3ODcsMTQgQEAgc3RhdGljIGludCB2Y3B1X2VudGVyX2d1ZXN0KHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkKPj4+ICAgICAgICAgbG9jYWxfaXJxX2Rpc2FibGUoKTsKPj4+ICAgICAgICAg
dmNwdS0+bW9kZSA9IElOX0dVRVNUX01PREU7Cj4+PiAgICAgCj4+PiArICAgICAvKgo+Pj4gKyAg
ICAgICogSWYgdGhlIGd1ZXN0IHJlcXVpcmVzIGRpcmVjdCBhY2Nlc3MgdG8gbWFwcGVkIEwxIHBh
Z2VzLCBjaGVjawo+Pj4gKyAgICAgICogdGhlIGNhY2hlcyBhcmUgdmFsaWQuIFdpbGwgcmFpc2Ug
S1ZNX1JFUV9HRVRfTkVTVEVEX1NUQVRFX1BBR0VTCj4+PiArICAgICAgKiB0byBnbyBhbmQgcmV2
YWxpZGF0ZSB0aGVtLCBpZiBuZWNlc3NhcnkuCj4+PiArICAgICAgKi8KPj4+ICsgICAgIGlmIChp
c19ndWVzdF9tb2RlKHZjcHUpICYmIGt2bV94ODZfb3BzLm5lc3RlZF9vcHMtPmNoZWNrX2d1ZXN0
X21hcHMpCj4+PiArICAgICAgICAgICAgIGt2bV94ODZfb3BzLm5lc3RlZF9vcHMtPmNoZWNrX2d1
ZXN0X21hcHModmNwdSk7Cj4+IEJ1dCBLVk1fUkVRX0dFVF9ORVNURURfU1RBVEVfUEFHRVMgaXMg
bm90IGNoZWNrIHVudGlsIG5leHQKPj4gdmNwdV9lbnRlcl9ndWVzdCgpIGVudHJ5ID8KPiBTdXJl
LCBidXQgdGhhdCdzIHdoeSB0aGlzIGNhbGwgdG8gLT5jaGVja19ndWVzdF9tYXBzKCkgY29tZXMg
anVzdCBhIGZldwo+IGxpbmVzICpiZWZvcmUqIHRoZSAnaWYgKGt2bV9jcHVfZXhpdF9yZXF1ZXN0
KHZjcHUpKScgdGhhdCB3aWxsIGJvdW5jZQo+IHVzIGJhY2sgb3V0IHNvIHRoYXQgd2UgZ28gdGhy
b3VnaCB2Y3B1X2VudGVyX2d1ZXN0KCkgZnJvbSB0aGUgc3RhcnQKPiBhZ2Fpbj8KWWVzLCBJIGhh
ZCBmb3Jnb3R0ZW4gdGhhdC4uLgoKVGhhbmtzLApNaWthCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
