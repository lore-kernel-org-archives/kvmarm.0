Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020130.outbound.protection.outlook.com [52.101.56.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905AF1C6893
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.130
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724777655; cv=fail; b=NCeC5rXVwXyL0VGYYvpG3kKgGa/oDIDQ1COKweX7Rhaziit3rZHIz5Zgrhe7KwO3/1SWP4winisbd7dgEK+yWwJEzAvBU9UueVVYSd7pKstKzIWOyelEFqWMszpq1jSAfBuOgdYLi3AAuxYoQ88+nju7VZZGjlFDv+7TnxOlOIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724777655; c=relaxed/simple;
	bh=6Lq/o/1B3btATZSO50VBzDR0DYzEWf7kTAYc6D+1w6I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=OtNnYZGJeDTSwcJErelD7CYdE3reuaTMBAgmMlLfqNZywFcEQBKpfdsoGytf0IItLjMt2qhYWOh14N/ztX10GQcCTtCAdPWXWIGUmnqsxUbSDsGeZjVtUClosQxKtBLbcjWzE5hR9cr0tTUT2xKeWRnLOka5AgZ33EyH0FFdzR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=Gg0d7dp1; arc=fail smtp.client-ip=52.101.56.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="Gg0d7dp1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZkGNO4xNGchfLUYIbsz55bAksWekfVy6c2ngc8tOm9P6KIwAem4z6XRFpZE2Gz+oKLurIsjIu9vS6BfbW8FOsIPh8GF/nl8U4pl6eaXPMb9vdGYNNlJFDXfQsPw+sjIeMhjbXyaGKAKnQbFHtmotUrBmJ6yVChOnMo8cAy6PD9H77npS1ppVueynuW1wU4VDi1S/q9HRJunCY1ag7yOGRqcU/znwgbf+5KiliNW65gqWi/r9N4jZpPs9zsu4CE8XL8TTOQNmhxWWPDBv64b2CJIqRk9j00rJVag8EWxNYnk3KKKQHOeN8uf6TvL/+GmpF5sAASBBzjZIWm0hXs4AnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BTJJooAIsiNvWaH3T7kLHuPL2VURzAcZzdTI50pUV4U=;
 b=P41GoMUVN5iUBDRc1nuLJospEDhgu/Ks+hYtOwIsXK1guGfxkFVPYzxA3siHppksNnYXry/hqmBMw2i4QfaRE/4kvtPNCMjyoK0GFfISIYiA1Ryxy1IRl+DkafuPnwAgbS33U97/s0cj/IqkXjRbJEjqiTtS8sgZXN3FvuEMBDSyEw8n6Bf9/3Y7nFCIP4hlLqPh8wyehn6unXGq2HKsSwIfJYaR90sa3u9uUcxTOxeKsXWx87jboPa8bvnobXCr0c/grv7XlFK92uewIyMb8MaobihemUbLR+/wHD/xwtY/YeFFqSnW+gRiTjL6soQfQMOjkIVGSzEDwtWyQAJmpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTJJooAIsiNvWaH3T7kLHuPL2VURzAcZzdTI50pUV4U=;
 b=Gg0d7dp1wjG097yM+JfXgfj7n7UhzgcTkFF4gLlVjg0KzWc96lVjxIaLm7g5BNtan4YIqi9hCqR+FuDGN9gDqY9E4r2pofSl8cSoNlUhkLHmEIXkrfkNPvopBftJIK3eKiB50VhFYSGwB1O/9qRA5YP1LNaRiq6/GU/mEoA2LSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 SA1PR01MB8325.prod.exchangelabs.com (2603:10b6:806:387::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.26; Tue, 27 Aug 2024 16:54:10 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%6]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 16:54:09 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>, Oliver Upton
 <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Mark Rutland
 <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, Besar Wicaksono <bwicaksono@nvidia.com>, Easwar
 Hariharan <eahariha@linux.microsoft.com>, Rob Herring <robh@kernel.org>,
 Andre Przywara <andre.przywara@arm.com>, linux-kernel@vger.kernel.org,
 patches@amperecomputing.com, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] arm64: errata: Enable the AC03_CPU_38 workaround for
 ampere1a
In-Reply-To: <314b8893-2ffd-4148-974b-725cfaa97d18@arm.com>
References: <20240826215933.1263453-1-scott@os.amperecomputing.com>
 <Zs0OelXKn_-6jtqN@linux.dev>
 <314b8893-2ffd-4148-974b-725cfaa97d18@arm.com>
Date: Tue, 27 Aug 2024 09:02:58 -0700
Message-ID: <86zfoy2bt9.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0316.namprd04.prod.outlook.com
 (2603:10b6:303:82::21) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|SA1PR01MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: ff0287ab-6cef-44c5-b067-08dcc6b8dea9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|7416014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x2k4kDNo2U7mblMIoYA9imQhx7jCzvdHvmS7zUX9fYaQWdQHrVeTM+4wn5LZ?=
 =?us-ascii?Q?A2wBd0Z4HT3G0qU9vOZnA7fhWJK5BRD31cSCFtgsCyIJZfeTpt5Dcp4gDmwD?=
 =?us-ascii?Q?ZBeW7edRZw5fd12Ga0wNxfuxUlvLIZVtIQ3sgFA3RTCF3l8kT00Kswpn5Jaf?=
 =?us-ascii?Q?xk3zw8yycoYCiNF5ERsIOSawMMTvXEsIG1rL0guqC0hw+apgkyblQ5xEcgCZ?=
 =?us-ascii?Q?AgSmD7CGZpIM6towJzj0/zCI/HwFStGIyHK19A0GiHzv02ShwBmPPwpcWvXB?=
 =?us-ascii?Q?ZzaljU+RaGbxN+1MXp46a7gOQKhHFO78Bu3Mn8zUK2h5ZR1oA8OOVEMZLLoY?=
 =?us-ascii?Q?OwHZt05PaDdKQ6GrrfCkVC8q5zEPE3Yi//07FO0ANExuQ5/jHgHVCsxc6KO3?=
 =?us-ascii?Q?pJsdz9kS1QaOTog2rY+r5Omi2+f7TeY53RiNziRV0pi8GZP6P1bXlbrO/wBm?=
 =?us-ascii?Q?uf30TOjtZXPCMo2zNkrjlwPJ/O7CveK0efHg5Awk3HddOukbxBzA8MOjIOlU?=
 =?us-ascii?Q?vcEi/x+S/lk7QR96DwhacPiS6b7EmbDRJoIAaoVpxIM8YNBvl1GFQymSkjzT?=
 =?us-ascii?Q?/aYwQYWJPTa6vxcETIJiLZGkVEZRnzRrZoyMHP5WaezYTbYuV0rMAWnb0yMv?=
 =?us-ascii?Q?nEk7VPA4Wz1o2d17KsdytzUlapsejF4wexMbixxF0qlrN54dFYkaqqCMbfhU?=
 =?us-ascii?Q?VD+gB5JKMR+tGQckRo32wZikz5av2ttUFGbqj2XphiWUuIAKpU13VtDFc/+D?=
 =?us-ascii?Q?OTzhNvf1CnH/gjmMqaIMsJ+nCmhQMC2z6Ci1hVg4s55DRW7FA3i3ZrYDXWJI?=
 =?us-ascii?Q?FOwBGn0bdoHSXLbbt2fU0vbM9E+oXXrRfoffcd6MkD0o5Z0bEg6wl6EiClkt?=
 =?us-ascii?Q?fQQpgSAaes1zLU/XlSQHvT1DNrbnlqLiR2u6wPpY2wQSchD7Wnb6bFtDr3Tc?=
 =?us-ascii?Q?wu26K9v8QjRLGV1ajoZRC0POV8C3tie3b9lHwGgkul3lzt2bFO/NcB5Din7Q?=
 =?us-ascii?Q?fZBWy4ALahHjavvB/eZ7kFA+LNxYjKx4fuy57lFehsUnnUv7cl60u+RkVQ08?=
 =?us-ascii?Q?0fgaxSvHz6ohRJED2dSw7bOCYbbebyIc04Mc0ouAr1bU3ErcneQQtAROrXRO?=
 =?us-ascii?Q?7zTxXMOEeY7EEeinlifE9hR8/SW7owyRZdSde+ueUyetWL7hlymMnxPwvjYV?=
 =?us-ascii?Q?MYZjelIr5PpVMTQylaFg0mLmTwoGh/+tr/L44MDF9LLGgrRmyVHd8jUbzTsW?=
 =?us-ascii?Q?RrBX9DQhVhMXSC90sIw0S7JsBCQsRqRG6e7xRAKgzcvSP7kURAvTtMOV5A9n?=
 =?us-ascii?Q?WcyKrp3OdN9Fxsy5ZG0QOe+Yy5af0wKou/ai5RYnQka++HSvTOMklyWPCUDU?=
 =?us-ascii?Q?l4MG8AqNkBWMvQN+iki62j3jOKp+TfIf1J5ZnVsd+z8YcVd9NQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(7416014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n1gl3o0S4YEXVCzxfn2vwGfB4mrV58QQGsfbSb2BZTFOrJJBZMSUvfkW+fpm?=
 =?us-ascii?Q?u4hQocE4U1Qom4uYFSGhFVYwzms6XeQeYzFH+b3rCqnGjPrhj8WfluW7qWml?=
 =?us-ascii?Q?Bd+39qmAMKrDAndpW89m9LUjnY2LCqmDUO14aVIzh7QiNxIm6oHGkgeRGr98?=
 =?us-ascii?Q?jeF/dVVNdqGx/veF1UpN/D+QD7+1bGJb5+KW+gWEFwSXjW2bwEhKtu20bcGj?=
 =?us-ascii?Q?HLbAGvhI081soar7x2w/0OYMn8724zUrcA3Vf9zUVq0priSqLd9Oxukn6U7u?=
 =?us-ascii?Q?QjFnVKERl+qreIsz7QJvjiFsJ4MM7cA4F99nc9QNPnn+NwcwGoAvyTtGfXTT?=
 =?us-ascii?Q?6D0Sss9LkrBEKBPJFcWAlY7XDhSwwk2W5LYUFCFb2fUNXLCLL/aWua8K1vtP?=
 =?us-ascii?Q?jIv79pRmgdH9PTVbFfxIURrJMm5HuSavFNiFtPAxzNbqX3ZL23sU81qSMFvB?=
 =?us-ascii?Q?rMXjagwmY/2gWrMkfhI6BMmcN0E/eCU5tsgvY2U7lsIOTVY7stbl4tGDmqcD?=
 =?us-ascii?Q?WhRJ7QAI+bskBJtVJzDRiok84gwMgCYeuImuTFfO7q193+z8X6biZcygCu4c?=
 =?us-ascii?Q?GJKl5+edkQgOlQiSZKuk7huppA2qTATZPUD+MmyrbSO6mZHMKVyiVuFXnxQd?=
 =?us-ascii?Q?vzhndlJRTq/SzSjFRBVuvNjeZKpATFFXdMnfQz9Gce4gS4qRFwkMfucHiDuW?=
 =?us-ascii?Q?1q3eoAwKGri+EyYZcEu7w9tfrdgNRrBRmB3avHD5yYjYa+kreKNKXWYPXUc+?=
 =?us-ascii?Q?bBxh0ncQFcQW532ywwtolhOzjdaJTXj+ZJXx//lc9hwwTjAsiNQmNY6k4qt4?=
 =?us-ascii?Q?j2t8AheqsxWTe/tPbDoWCOx64H9UfCdlY2ujbktLnzuCOlm7P1a+MItwuoKe?=
 =?us-ascii?Q?nxPPmsoYnoviX4FAzb8z5zMsiofhUI2epSQyQX8w6fLB2CUyfmNkGnUHCNq3?=
 =?us-ascii?Q?9WAwMILmJ5B+L60p4nedRyzkQeezZx7TosOch48CMcVtE/g3IZRT52V1n2Il?=
 =?us-ascii?Q?lTJoPRp0p5lRmHs3Vx58kBOkD68VrhW5ETCwbjgdUx4mgmS9wt9tqkqh1rrx?=
 =?us-ascii?Q?wDb9sk/2p8q+THF3kVLK/HzZRjCD+2DcIbwW6L5jAtt0L+43cukUDp1Do1hk?=
 =?us-ascii?Q?kBTjfXJaX84ffkF/fUlZKgmSousmTY3/WgBRPhm1FMqKtF8o5QgJvMzZLMCB?=
 =?us-ascii?Q?Xb2zdI55WEPEwOgBHRck9nw6s4CoR4bC5Az/ZL/0GJ0+fxexG+mxFo1FZ0NM?=
 =?us-ascii?Q?0CAfaJRjH+fofbTNkFciQ1MOpx/czue4KUJWtFhH8a1DAZaMdVFD0FdYNoUe?=
 =?us-ascii?Q?GAMuaydFsdZ+ce4RTp6gBWqxrwk2Wk6ML7Q64uTKCq56fS/MlhtCz3CrrEZp?=
 =?us-ascii?Q?YFLtesY3W+9ywqbSE45wy8Q/v3JazoY9w9GMoYikFH17SPoB4kIsoS5/sFrY?=
 =?us-ascii?Q?fcI1xFszewzqE3oOLpqciIviIw1WTs/WY2yqHTiaGNwXDIXUg5kbEVy3cEOx?=
 =?us-ascii?Q?MbuevgIBI8j9pzeLm3rwUoNkbYGQ0TkW7vviiJDG+DanwR9dfDVg0DWB43+s?=
 =?us-ascii?Q?+ABhLDAeQsOuAarer/c9tO0XDs5hOYF375r0pQfvZ3afYd8n3GZwmA7jHteu?=
 =?us-ascii?Q?udVD75es+REX5d+2xMqAapg=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff0287ab-6cef-44c5-b067-08dcc6b8dea9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 16:54:09.6002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w+fU+ovy49WIaEbBAoBxu9uHw8Sa9UYxBpM5hB4aa2BQOZ8mohjc1AUnW1eh7i3NmWmxjF4/L9G3wA8APCADSkg9VQ5KGC7q7V/0OR01jonyuJA+As+BKVppXx/nsmMC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8325

Anshuman Khandual <anshuman.khandual@arm.com> writes:

> On 8/27/24 04:53, Oliver Upton wrote:
>> Hi D Scott,
>> 
>> On Mon, Aug 26, 2024 at 02:59:33PM -0700, D Scott Phillips wrote:
>>> The ampere1a cpu is affected by erratum AC04_CPU_10 which is the same
>>> bug as AC03_CPU38. Add ampere1a to the AC03_CPU_38 workaround midr list.
>>>
>>> Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
>>> ---
>>>  Documentation/arch/arm64/silicon-errata.rst | 2 ++
>>>  arch/arm64/Kconfig                          | 2 +-
>>>  arch/arm64/include/asm/cputype.h            | 2 ++
>>>  arch/arm64/kernel/cpu_errata.c              | 1 +
>>>  4 files changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
>>> index 50327c05be8d1..39c52385f11fb 100644
>>> --- a/Documentation/arch/arm64/silicon-errata.rst
>>> +++ b/Documentation/arch/arm64/silicon-errata.rst
>>> @@ -55,6 +55,8 @@ stable kernels.
>>>  +----------------+-----------------+-----------------+-----------------------------+
>>>  | Ampere         | AmpereOne       | AC03_CPU_38     | AMPERE_ERRATUM_AC03_CPU_38  |
>>>  +----------------+-----------------+-----------------+-----------------------------+
>>> +| Ampere         | AmpereOne AC04  | AC04_CPU_10     | AMPERE_ERRATUM_AC03_CPU_38  |
>>> ++----------------+-----------------+-----------------+-----------------------------+
>> 
>> We tend to stick the marketing term for a part in the second column so
>> it is more recognizable for the user. Is this a placeholder for something
>> different from "ampere1a"?
>
> Agreed, even the MIDR being added here is for AMPERE1A. Probably something
> like 'AmpereOneA' might be more suitable.

"AmpereOne AC04" was given to me by our marketing department, so that
should be the user visible name of the part when they buy/use
it. ampere1a is the name of the core in the SoC and the thing you can
use in gcc's --mtune=, similar to "neoverse-n1" within "Ampere Altra".

>> 
>>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>>> index f6b6b45073571..748aa536446ae 100644
>>> --- a/arch/arm64/kernel/cpu_errata.c
>>> +++ b/arch/arm64/kernel/cpu_errata.c
>>> @@ -773,6 +773,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>>>  		.desc = "AmpereOne erratum AC03_CPU_38",
>>>  		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
>>>  		ERRATA_MIDR_ALL_VERSIONS(MIDR_AMPERE1),
>>> +		ERRATA_MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
>> 
>> This will break the workaround on AC03, since the second macro reassigns
>> ::midr_range.
>> 
>> You'll want to use ERRATA_MIDR_RANGE_LIST() instead w/ an array of
>> affected MIDRs.
>> 
>
> +1
>
> Although ERRATA_MIDR_RANGE_LIST() in turn creates such a list.

Oops, my mistake. I'll fix this.
