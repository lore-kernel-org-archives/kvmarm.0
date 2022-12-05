Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EA2C4321E
	for <kvmarm@archiver.kernel.org>; Mon,  5 Dec 2022 14:06:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C4014B28D;
	Mon,  5 Dec 2022 09:06:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hBZr7R58sHzh; Mon,  5 Dec 2022 09:06:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B83DE40801;
	Mon,  5 Dec 2022 09:06:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A7940762
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 09:06:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CGzoudwV-hZr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2022 09:06:26 -0500 (EST)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05on2088.outbound.protection.outlook.com [40.107.21.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1A934012A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 09:06:26 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhUex2p1RBoBlBw7Eh7n61AhN6Pv5H/JHk70ywuBvuQvZMbHtMHCy2xcBvga+CuRzRu8Ahtc8jsFrYO55Aa/qEjGzTv2lJBxDVNyIkO71JGCDUMwldaOntsxPkoabE0hevsFIzVdNTB+QUCM5rO1MQapuhRApvcHv10KqZAvYPyN0wLFTfB3DsSIeBeu0sFU8TIxllMTRZZz4YP13KszxkVhXWf8nYtDyM4g2RK+YEIA5xPyhtL34U4kDczxRuCcweTmLNvQ+ccHfgaCFN7TbeSMQTkyTpjlTv2CY43RAMgSu7fJmyVPVEAkjGKBjFw2CT9rn6dYsML2JGWAeaX5ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dPH6P9dt8XhZ4gqnX01wMWSvXPCpy0tdW/tILcZ5Vg=;
 b=FFXQoquBXZGTb+9OQ6s8U9jVOsygxByfyFvI8layA/8jzw6E+vR+HnFqoDLqzKGqUIL0Rt4sSmgFfz07blSuZR7xWLxM9SQoumnwC1NuEB7zY2a0wzsyZZhevLZStJ2pT9gRmHERGAnvlFMyb+tMiJ8MuOwFrs0oZiubuhykIK1+hwyc/+h7tJe4t+7HrN0YO8B0vG0yubo3Yx+Lvm/0dS/5gUEnvbaeFmmHHQ4qt9zseYF7H6Epc8LIElHD56q7WjuQRMXfj89F83fOOHYm1sxnwTDorYfoPVexBwvCPC1DAHOWtyT9hNlcrlk2o0PG9olkeLOzFQM5WTqk/B7u0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dPH6P9dt8XhZ4gqnX01wMWSvXPCpy0tdW/tILcZ5Vg=;
 b=XGE3xlhy/8Df0teboJaJJxOdAlNrZwIlbK65BA8PdLa0BILG1bwAbBefQkH/PC6afeh65hTC5c0QyrOxYQRDG5EnIwYmlv7y7PQ9K/qC6yCqPpA3rLIYJyQvWvpl27DiCtDACQVvTepLSFy906XJqpz6vYXBarxXB2M7jFnnXY4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by AS8PR08MB8970.eurprd08.prod.outlook.com (2603:10a6:20b:5b3::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 14:06:23 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::e825:ff01:1f8:4c1f]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::e825:ff01:1f8:4c1f%5]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 14:06:23 +0000
Message-ID: <2661234e-9e2f-e0cf-b644-d571ea2e3012@arm.com>
Date: Mon, 5 Dec 2022 14:06:21 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH v1] KVM: arm64: Fix benign bug with incorrect use of
 VA_BITS.
To: Marc Zyngier <maz@kernel.org>
References: <20221205114031.3972780-1-ryan.roberts@arm.com>
 <86y1rmkljx.wl-maz@kernel.org>
Content-Language: en-US
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <86y1rmkljx.wl-maz@kernel.org>
X-ClientProxiedBy: LO4P123CA0403.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::12) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR08MB6995:EE_|AS8PR08MB8970:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c157153-a740-4172-f1b4-08dad6c9e462
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1011ATi0hiTHh/1n3oGKXY+mK6a5HwvYPCnnqrYZCsAwN+hZ872qL7DwE+K6JukemZpad2/pueR7RK+rFVmG3EmSQ/DlmR/JY4Siy/UNq1DAstGiZNWeb29Vcn4cMQj29yskFn3XRSSRYFr2gEihXkJ3RA76adGFIg2P6ocoNuBq3Ey6/REGbrIAiJr9Xza2cxZApELHl0A8I7sZxQnwjIZ/nfzeJZfr5AXIE5b9EmuoGYlFjlUAp4LQ1jab+3kWYHH71r6eexS3dmdkTdLNG8DqpImcKrq554ps3PrILqxSA2c7awz9xkUeS0nMQDY1JFy1ckmAfOn148SuVa+vBCc5HjATiEETQGjQPNHN2j7BfBtlVLgejwbw5stOCzFVAcEr0fVZ+NmyNlaxoda6jv2ES4pXuFfAw/60eaHyWfsAMSZRc2oAYBH2ss2BE0t9Q1VlTko7/JZX1pgMx1iCiaPZ48GSKTQa32rC8KWGnw+ZMCF0N4etbMGeAEjgEoqV7uLJbg8VLwsrnrm3GJEL5hngmGSEBdyAyxuKQRUd55m+avP7myAieVlzuC+mdQfmp7P1/bObcxTfHOjyOBR2ufu9IQr8GRajpSQnXvD9/aAGjBXIX4y6YgfKJkcW6a3uzJ7z0IBNxTOtBJBxW9ZdfGSFSNzjoAI9i/cVvM9e7K6nhI2muBtFGwgzxaEW/a9ahAOuq0CJNWfDpCmg93fkkRkhC6HryAfE/X9LGoVeYT7m0Ha67r2j9c62LW7qIK2c
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR08MB6995.eurprd08.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199015)(38100700002)(66476007)(86362001)(6486002)(4326008)(31696002)(66556008)(66946007)(54906003)(8676002)(8936002)(6916009)(44832011)(41300700001)(316002)(2906002)(186003)(2616005)(5660300002)(83380400001)(478600001)(966005)(6512007)(6506007)(53546011)(26005)(31686004)(36756003)(45980500001)(43740500002);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjZpbEY5U1g2a0NnT0s3NWtkUGpUbzZEdjV2TGhtK1RyYnNxRFhqSFcyeDBK?=
 =?utf-8?B?NlBYZENCL2tmb1hLRVdLM2tzZFZmamNQUjRueGRDaXNtc2pSd2FVOTgvY1RW?=
 =?utf-8?B?VnFJd1Q2dUtCeGIzYnZocDNrem8vTFVUMUxOVmovWG5vVnlveEZVWUNsRjFY?=
 =?utf-8?B?aGN0NGpjb0I0aUhsY0RGRWRPKzFZdUgzQ01Gc2JoUEl2d3dRb2dxVWI3V0xZ?=
 =?utf-8?B?Y3Ryc1ZPbkI0b1RURzc1MEx3YVpQUXN5YXpVdDNmbmpiTTcxZnhSMk1SeEpl?=
 =?utf-8?B?VTBzMFR2WStPeEQzQmJJd2I2ZHliRHJHWUJGVWZ6akRldDg1dnlYYzF5M1Va?=
 =?utf-8?B?VHNGS3RCUlF0ZWRlY2x5eTVVUG1tV25qeVpEbXlna0FqcGpSRjVDNGVLbXBj?=
 =?utf-8?B?NmxUMlZCQlRFMUFaVGVrd2MxL0d5SU84RHJ0S3lsZ3l6cWpFaDBEVUwyak1i?=
 =?utf-8?B?dXR0TWRGamwzQUxEYUhnZ1VQblNQa2hicDNSNEI1djlLRitwcGk4b29uYXFy?=
 =?utf-8?B?cExkeXByR21yUm1QWHQ5elU0WTRJWGJVK0ZybWgwUDVxcFpSUWJBQ2w3WlJv?=
 =?utf-8?B?UDVJQ2kzZnpNcDUzWnFBazFLbFhXR0huTFh2QlEyZzI2cUlOV28yZEZieHpl?=
 =?utf-8?B?ZUhnMXdDQTFDQUZBeCsxb0NtY1IwTTFuYkdSNEpVejc5dTY4Qkl4UmM1eW1a?=
 =?utf-8?B?T3BxSENMWWs0ME1iQlhpZUVzTWNucENvbW1qeFY3RVNLWVR5dncyRWc2WnZG?=
 =?utf-8?B?bWR4ZEphRXg1NnpLMjV5SGxnc3pWbWpEZ2wzWkU5dTI1R2s2RjE2UE9PTnNs?=
 =?utf-8?B?SU42T243TVJmVXVKRG5tZU53MDZTOGRSbjBydjJoejhYejI0MGJvd0xVUmd3?=
 =?utf-8?B?bFp6c1Rva1dhSFNvSjdKMFhTMUtLYS9zNUprWHhZM2JPeEtEN2ZGcG1qbDVo?=
 =?utf-8?B?eGkrM0EwRkpVQmRDVDBQdngvaUJwL0xpUGI4L1I0c3A3S3ZmOUFGL1NiODVT?=
 =?utf-8?B?UmFQS0VZVjM4N1p5elFIT0p6Vko5UWtWOUFBcm9HWmhqZWRBaENkZXJMcVJs?=
 =?utf-8?B?aEx6eGNidS80MEhnN2thUUxHVll5V1lsK3IwT2tQeHFBbEwwbXFhRTNNVDdk?=
 =?utf-8?B?SzlRdGlhVVA0amFPOEVLZ2tTM0JaaVg2dkROaENWTGZkbDYrcFhaMUtHeW5o?=
 =?utf-8?B?OUJSUVYxR3BiSlh3ek9tWkxxSUF3YlJRSWNOWG1oZkM1MmIxdCtNemFsbElt?=
 =?utf-8?B?MmtxeFN0cWVyZlZ6aWc3Q0NlNllrc3Nac1FkTHBVMExVZHJBWXlkbDJTVmVk?=
 =?utf-8?B?WmdEZ2VoQWU5U3RldWNkc3ZxRjBKRTJuVHgyY2YvV1E0azZtN3pZeU84THg2?=
 =?utf-8?B?QmxPRVJZM0hEUytOdHBaYkdVRUF0YU5KYjFFdHZpVlFKbi9xM3ZqZmp6QnRh?=
 =?utf-8?B?OENsTkZtTXhFNzZUSkF2MnVoTmtqOHBMTVdNQ0JlMDRoVGRHbmlhMFJLTEVP?=
 =?utf-8?B?dHh0clZ2NStkWGpqTXNOVkZUZkNMc0RPdVBoZU1FWUhTNTk0WXYrd0NWVDlD?=
 =?utf-8?B?ZDRLSGRGVUU0MVZidVVyMVYvRXNqUm5hSmdVcUh3cE1VK2k3U1FUY05idTA0?=
 =?utf-8?B?VnRNVzlXM3V1WGJMMkVjdGJ0ZzI5YnpFYjhKQWE1eXovMzhVNitFWVBQSjUr?=
 =?utf-8?B?MHZGWGp0RHBUbzBGblhNamFKNXJpYjBTVnFNdkVKZkh1SXlyMkhtQU5SSXJt?=
 =?utf-8?B?QUU2ZFpKaXdYb2QvWXpnT0VwM3JTSGQxVkdmaVNnZEE5R1RBMEYxTDd3QTl0?=
 =?utf-8?B?MWJDNktvVHVvZDcrVG9RbE5GVHQyUHo4dHRmaStEYm84bnk4ME14UmFHVXl6?=
 =?utf-8?B?YkNoRFpZOEo3bnJ1WTBMM0h0N1RtSWV5V2pJUUkzcVgxY2w2RllwVEoyVEtt?=
 =?utf-8?B?V09oUitFUnJMK2NTMUlYWVFHZHV5MTZNcFVHa1BSOW5MWHVkdkEwalZ0WjEz?=
 =?utf-8?B?MGFJTDhWcGxzUm1JVHI1SHRMYm5qYW5EMXgxdjJndlU4WDFERU1oOTlYWXph?=
 =?utf-8?B?TEZKNzNmOU9iVzhjelFjMUJHMTJmbmpvUUZzU0pyVlpWTmlneG4vaUJsVWR5?=
 =?utf-8?Q?+ILz49JXeYukKvFDyrkEVvWHl?=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c157153-a740-4172-f1b4-08dad6c9e462
X-MS-Exchange-CrossTenant-AuthSource: AS8PR08MB6995.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:06:23.7931 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eSpoxXp4rUfJxH2o3CON6MOkf6T7GC4n5Y+Co2Vz3hWoCc+Cz5Ew2xDB5jQhO3zzbcPQtzc09DmIU0brtQIgGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8970
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 05/12/2022 13:49, Marc Zyngier wrote:
> Hi Ryan,
> 
> Thanks for that.
> 
> On Mon, 05 Dec 2022 11:40:31 +0000,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> get_user_mapping_size() uses kvm's pgtable library to walk a user space
>> page table created by the kernel, and in doing so, fakes up the metadata
>> that the library needs, including ia_bits, which defines the size of the
>> input address.
> 
> It isn't supposed to "fake" anything. It simply provides the
> information that the walker needs to correctly parse the page tables.

Apologies - poor choice of words.

> 
>>
>> For the case where the kernel is compiled for 52 VA bits but runs on HW
>> that does not support LVA, it will fall back to 48 VA bits at runtime.
>> Therefore we must use vabits_actual rather than VA_BITS to get the true
>> address size.
>>
>> This is benign in the current code base because the pgtable library only
>> uses it for error checking.
>>
>> Fixes: 6011cf68c885 ("KVM: arm64: Walk userspace page tables to compute
>> the THP mapping size")
> 
> nit: this should appear on a single line, without a line-break in the
> middle [1]...>
>>
> 
> ... without a blank line between Fixes: and the rest of the tags.

Ahh, thanks for the pointer. I'll admit that checkpatch did raise this but I
assumed it was a false positive, because assumed the 75 chars per line rule
would override.

> 
> And while I'm on the "trivial remarks" train, drop the full stop at
> the end of the subject line.

Yep, will do.

> 
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>  arch/arm64/kvm/mmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 4efb983cff43..1ef0704420d9 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -641,7 +641,7 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
>>  {
>>  	struct kvm_pgtable pgt = {
>>  		.pgd		= (kvm_pte_t *)kvm->mm->pgd,
>> -		.ia_bits	= VA_BITS,
>> +		.ia_bits	= vabits_actual,
>>  		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
>>  				   CONFIG_PGTABLE_LEVELS),
>>  		.mm_ops		= &kvm_user_mm_ops,
>> --
>> 2.25.1
>>
>>
> 
> Other than the above nits, this is well spotted. I need to regenerate
> the kvmarm/next branch after the sysreg attack from James, so I'll try
> and fold that in.

Sounds like you are happy to tend to the nits and don't need me to repost?

> 
> Thanks,
> 
> 	M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n139
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
