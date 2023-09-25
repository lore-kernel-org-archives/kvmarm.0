Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2102.outbound.protection.outlook.com [40.107.220.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2D63CB
	for <kvmarm@lists.linux.dev>; Mon, 25 Sep 2023 05:35:19 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4PL1XIOSjmwoy6gdf7vyVsXuOmZuuMVKa6rTMK65C/5hWR17lJOKXNMJDLjFLEQYSsjZdm3XM+2yOyEKBlVmNAB0w+7e7R2SaiVbXjVaxWTK6jlaT1hSWbDlzMhZcfEU9wkGtzgcQtRXul2CerxKDb5HbVn8p2kbCp+JmEh5qwC5p7F6SJ5zI6VEgMZM/U3i9KzyItStvyedWAq1jua1INRDBMkhz7S+Zx7//kBRED6uR6ZXQZyEGxmVCQYzWLE0lr4cBnCvDbj4fUlkI+6GOlLgtkAcErhIdKQv5BYeqx6Qsgq4qlPuJpX41lz6gYzf/Fdnx2YIOj1oPnuEru3EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RETtGZR03y1MrVCKuHzhmdPWQgwDDdKkhQhCKpcJis=;
 b=SeamloV2ywC4ZVs+GX9xrLkeuschgpDoyEVAFmY//HndMHOVE/zP0jfTIq9pIv88qOB+N1oQIaX3nwftbPS1uAzMeIoeU0ZgYv2Kgnh5qWyAUsWwlzesRhnKPs8XH5ZhvGp4uVKIyEsfdwAvHg1DTjfi/Hq5JmPXFnoq3n2KrbTER1Y0X8QKWjd3mUWujHRpyuxR0XpPgY4iP0myiTYCODIj97szqaFQmq2Mu5BkiHw3e87VM93bFXSjunp0jUa6lUSZEHIdyQUW/Mqb7uDfXEtuee3nfvUxqUNvqLbHENYUrysQugstveyQ9yZmbe8kznygYw7Q0GmrDbBE3xik7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RETtGZR03y1MrVCKuHzhmdPWQgwDDdKkhQhCKpcJis=;
 b=ZOGHFqKpF3FJlieJqjja92f/kGJo5tZ5t5RoTIZYt0VWejTL3D1jkUiVoT546mDhKk4nKv3Vkq+AXiwP68Y8frJgXTDRVJzQjY6obvEwIYlrHdctNm8taSeIFpaUstSNGoB0Y7tprxZdHPjiZQAeKNHE9DuewaQEhZfFNn/HkoU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BL3PR01MB6964.prod.exchangelabs.com (2603:10b6:208:35b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.28; Mon, 25 Sep 2023 05:35:15 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d686:ac07:89b3:e724]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d686:ac07:89b3:e724%3]) with mapi id 15.20.6792.026; Mon, 25 Sep 2023
 05:35:14 +0000
Message-ID: <45a2d1c6-821e-d55f-f59f-c214a11e0df0@os.amperecomputing.com>
Date: Mon, 25 Sep 2023 11:05:03 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/2] KVM: arm64: timers: Save restore CVAL of a ptimer
 across guest entry and exits
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, Christoffer.Dall@arm.com,
 eauger@redhat.com, miguel.luis@oracle.com, darren@os.amperecomputing.com,
 scott@os.amperecomputing.com
References: <20230904114218.590304-1-gankulkarni@os.amperecomputing.com>
 <20230904114218.590304-3-gankulkarni@os.amperecomputing.com>
 <86bkeadzf0.wl-maz@kernel.org>
 <ec322123-bfe7-6019-7f35-de326ee7b6c3@os.amperecomputing.com>
 <8634zben3d.wl-maz@kernel.org>
 <38722ba7-b7d9-368b-f946-b6c0c0a661b8@os.amperecomputing.com>
 <87v8bz52bq.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87v8bz52bq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY8PR12CA0065.namprd12.prod.outlook.com
 (2603:10b6:930:4c::9) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BL3PR01MB6964:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ba1edb9-6dfe-40e5-1311-08dbbd89312b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6KLQCm7xwVdmBWb0f8tOKuvZJ38yNdYtJ7T8/fzaG3TRUQuq1DyVkxxP8whDAXAv5P2AITJexD5yC66oZ6P7k3ApQrAICClGartWiDVDr2tuWkNIPRD9CR88lsH7F+geLn54ysjJZE8dX1mNODDPFxoftntpBKijdYPVvclQD06YbU+YgHLW2dAiYFOpZ/5iqXktwnqocPwBPJDQngDzwUrfSgUB32vovjUz243d+JKlzjDgq1uABtK+SPaJ1wbWKmXh/38f55c8SKGVVXp820zw5ZmvH3gk2ghwKiZ04SsuCYdnA7Cb3zjJtcALhbooOHOZogoeR/tIaNmmwpR/CQb/CTUt1AdVt6oAU4IzFgE/T+gMvXJy320+pv5sYRG7JmkEXe+Yp6P3j0XKBUT5MqBpJwi6mDK/qxp+eMVkcih764l7h0S7s+spVSyzwMib9Dv21nL1Z65KEuJj9wqupRhb0LBRAu0+0lfyOL1/Fq45X7fkgWHWBskxBaWvbb4/la3DvLj3ROKGzYpGw57ZH0W+VwFtwqsnvS9qjZ6mobwo46+niBhyxdUYO1qaweXQn765R3Pne1n3j6JeCk1Y8gPhDo787J4OtN/Rx6rCNCSUB3Xkg6+ciIdTmxGwsX0M
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39850400004)(346002)(396003)(376002)(366004)(230922051799003)(1800799009)(451199024)(186009)(107886003)(2616005)(26005)(6506007)(6486002)(6512007)(53546011)(38100700002)(31696002)(86362001)(83380400001)(4326008)(8676002)(8936002)(41300700001)(6916009)(316002)(66946007)(66476007)(66556008)(5660300002)(31686004)(2906002)(6666004)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWtvaFVySTlrODl4VCtZZEgreE5oYld2aE9aK1lQeDRXbGlWWXRTTldBVHo5?=
 =?utf-8?B?bFlOVllVdllqY1ZmL0dLT3BHTGUyMXJxYlk3TE5zYmZjaXNPcHFteEd6QVg4?=
 =?utf-8?B?VFZCM3RJZlpqeHV1c2lOQ2lraWg3RXFEc2k1ZUdMSm5FSzBtM1R2K3lSZHlX?=
 =?utf-8?B?d0VMb1dwOHB6NWgwN2p6ZEtYbHNORXViVENoeWJwR1hVTXo0MTNIQjNKOGQ3?=
 =?utf-8?B?QkhFN2Y1L3pvVStEbDRoQUZDbGplMUlYSTRLRVNEYi8vYzBwQXFtQWEyU1hI?=
 =?utf-8?B?Q2pIekVEZmo5Y0NlV3ZOanBUOS9RQ3U1VGVKY3dJOVNCNDB2TkhCT3FETXBk?=
 =?utf-8?B?cmZjNjkzcTFiMElLWENmWVloQ2lJUmV3dFZmems3UGFCcnVPUDBTYnE4V3ZG?=
 =?utf-8?B?NlhWRVZINHJBa3ZVaUFnMDlSTlJkSE4xby9sSFRRcU1XRDQxWlpBVFJXbGJ5?=
 =?utf-8?B?V3NqL2RoR0cwSStZaHVIalJUbE1TSTRpN2xuN1p3VTNKZ2xYS0poaXlmUDZR?=
 =?utf-8?B?TVVjRTJTcWhOaFhXNVhEZzZCL0h3NlZWRmRadlhQTHZsYzlHdnZrUytYT2px?=
 =?utf-8?B?SXlWeXZRa0c5YzEwdFBWeGlkbEU3YW1Kd1JzSkpzbzF5QnhIWFRqdGFDcXFx?=
 =?utf-8?B?R0FaZG1VYWM5TDRtVTEwU2F5NElmYi9xQnIzbGhOQzcrUzNpQlRHMXZGZ0Yr?=
 =?utf-8?B?bm5ZaWVMYTkxU0ZLOHg1ci9JMGlPMnk1Vzd1N1RUWXhjRDVjNDd3ZlpiQjQ5?=
 =?utf-8?B?NXBDbjhkeU9FY1VHcWx4ZHh5Q2VLNVlPZ2lrZ1VWUDJyM0VvZ3AxQXFDaUFO?=
 =?utf-8?B?aXp1VElGY2x4ckRsR3JDZ1hEK0pQci9VOHB1Q0kraFo1V1JjeHpLeXBOQ0xF?=
 =?utf-8?B?cDhiczQzYiszZTZhUllRb25EUytKcitpbFVOOUFuSGd1MTBndms3VjV5N1NU?=
 =?utf-8?B?UFRPRDJ6ZS9sSlJSRU1UM3kzZjBKVUFxUVJkdHYwZU5GcllUUVpJTEtjcnI1?=
 =?utf-8?B?YUEwT0lMK3ZMcXNrWEh0ZlNkUjNLNVEwZGdkYmlTelJucUFIOUJVNFlHWGE2?=
 =?utf-8?B?bGkzN1h5QTBpcmxMcG9oQktLMHV6MHgyT3hEaGdZejNkOFVjbUZQaGNteTRQ?=
 =?utf-8?B?dFRoVThJL1V3SDRnUkgxUmY0ek45cGZld1hxWHV1bFltMmFBRVB0dSs3RmFY?=
 =?utf-8?B?a3NuazFHN3gxRmxDSVZmQW1pdGhUdCtlSlA2cytWYXY2S3FrZVEzS2JEMHg4?=
 =?utf-8?B?K2w4MDREWFp4KzNucXBPcHJYK0tCK28vSk5STDlPcU9rS2oxMWZvZEQreU5U?=
 =?utf-8?B?R25nSkFpQ0VoQm9yZkdIR1gvT2p1WnFIaHltY2FRdDBJVzQ1RHljUFlTWmZu?=
 =?utf-8?B?aEh6Njdxb2pDK01mL0dkM3A1WW82Y3ExcEZXazRqR2JMY1BRd2UvRm4vMVlw?=
 =?utf-8?B?YkY5a1dpbGlYU05MZkVaTURNc04wNzFncjhOWlUyRFFYeTM2Z1lsYk5UQWxj?=
 =?utf-8?B?bzJHWW5JSW03OXZtb2RyYmYxdUdTUisxOEhBdTU5NDhZWFI5djkvbW9hZytV?=
 =?utf-8?B?eEtmcjQ3UVZtOGVNejNaSERKdzByUVdNYlhzYkQrOFA0MGhSTHZuNG56MWgz?=
 =?utf-8?B?TndFMTM2NERKQVZZYkxERVZrWkh0VWxUZ1VrK1duZ1I5Y2E2VS9zaWQzLzRz?=
 =?utf-8?B?WVExOXk5eWl5ZWdKSEpGWmcybXZSWG1WQTBra2pKNDNZdkxLMitxcmIrRWlt?=
 =?utf-8?B?WnZjdDZFWjVaczdMT0wzSVNRcjlndUhrT1pnVG5sMkgveDFDZHVodWhKM2xq?=
 =?utf-8?B?T1BEV0ZTWCtCc0VvenZNd0VNN0NoSzl0NFZzTEVzSkkrc09uY0pZZ2tiTUN1?=
 =?utf-8?B?bGg4KzdGMXBlTmZDZk1PT3MzdURLeVBreXQrQjNkMEZCMjlQQW5FQmVOblps?=
 =?utf-8?B?R1dtMWVTelVzL2lRNEQ5TEwwOEtZRTROaXlQaVphRFVIak9QRXh0UlRJeXZE?=
 =?utf-8?B?c2JwdnNzUTBMeVBvalkxMW90YVZXZFFvQzVXYXc1YXg2THZCYUxMcXM2WjNz?=
 =?utf-8?B?aHpIdzhFa09neDN4aGlDSWdlaEEzZlc3UXI0cnFVMGpJclBVUzBjU2szT01E?=
 =?utf-8?B?OHRWbVJKZmo2U2dlL2pJQmc5WHIzMm1Td25jYy9kMWNXSmxYU1M5RHhJT2gv?=
 =?utf-8?Q?nZxB90OXWxgVRTVTdGEm6W5O/+DisoSQxbQUkxwFZTkk?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba1edb9-6dfe-40e5-1311-08dbbd89312b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 05:35:14.1730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: km0HLRBwXfNvdGhGcCgNWB5M76VAEza8yWr1nOAP9YV9di4Q4/mkoHv6qMZMxJ4zcqiOXc8zBsc87eiMd3H04Nbc3dZ+Q64ch/nZ1CR0o4N9W14bmkePoNv0PwZc0BLb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB6964



On 24-09-2023 03:18 pm, Marc Zyngier wrote:
> On Tue, 19 Sep 2023 07:15:44 +0100,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 18-09-2023 04:59 pm, Marc Zyngier wrote:
>>> On Fri, 15 Sep 2023 10:57:46 +0100,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>> This patch did not work.
>>>> After adding changes as in below diff, it is started working.
>>>
>>> Thanks for looking into this.
>>>
>>>>
>>>> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c
>>>> b/arch/arm64/kvm/hyp/vhe/switch.c
>>>> index b0b07658f77d..91d2cfb03e26 100644
>>>> --- a/arch/arm64/kvm/hyp/vhe/switch.c
>>>> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
>>>> @@ -117,7 +117,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>>>>                           val = __vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2);
>>>>
>>>>                   if (map.direct_ptimer) {
>>>> -                       write_sysreg_s(val, SYS_CNTP_CVAL_EL0);
>>>> +                       write_sysreg_el0(val, SYS_CNTP_CVAL);
>>>
>>> Duh, of course. Silly me.
>>>
>>>>                           isb();
>>>>                   }
>>>>           }
>>>> @@ -161,8 +161,6 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>>>>
>>>>           ___deactivate_traps(vcpu);
>>>>
>>>> -       write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
>>>> -
>>>>           if (has_cntpoff()) {
>>>>                   struct timer_map map;
>>>>                   u64 val, offset;
>>>> @@ -173,7 +171,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>>>>                    * We're exiting the guest. Save the latest CVAL value
>>>>                    * to memory and apply the offset now that TGE is set.
>>>>                    */
>>>> -               val = read_sysreg_s(SYS_CNTP_CVAL_EL0);
>>>> +               val = read_sysreg_el0(SYS_CNTP_CVAL);
>>>>                   if (map.direct_ptimer == vcpu_ptimer(vcpu))
>>>>                           __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) = val;
>>>>                   if (map.direct_ptimer == vcpu_hptimer(vcpu))
>>>> @@ -182,12 +180,13 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>>>>                   offset = read_sysreg_s(SYS_CNTPOFF_EL2);
>>>>
>>>>                   if (map.direct_ptimer && offset) {
>>>> -                       offset = read_sysreg_s(SYS_CNTPOFF_EL2);
>>>> -                       write_sysreg_s(val + offset, SYS_CNTP_CVAL_EL0);
>>>> +                       write_sysreg_el0(val + offset, SYS_CNTP_CVAL);
>>>>                           isb();
>>>>                   }
>>>>           }
>>>>
>>>> +       write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
>>>
>>> Why moving the HCR_EL2 update? I don't grok what it changes. Or is it
>>
>> This the line of code which flips the TGE and making timer cval ready
>> to handle the TGE flip is more safe way(avoids even corner case of
>> false interrupt triggers) than changing after the flipping?
> 
> That's pretty dubious. Do you actually see it firing on your HW?
> 
>>
>>> that you end-up with spurious interrupts because your GIC is slow to
>>> retire interrupts that are transiently pending?
>>
>> IIUC, If there are any transient interrupts or asserted already,
>> anyway they will be handled when irq is unmasked.
> 
> That's the idea. But my question is whether you observe spurious
> interrupts when not changing the ordering.

I tried with keeping the ordering (i.e flip TGE then change cval) and i 
don't see any issue as such. IMO, it is better to have cval updated 
before TGE flip, anyway either way works for us.

> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat
