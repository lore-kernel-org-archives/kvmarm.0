Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2107.outbound.protection.outlook.com [40.107.223.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9044221F07
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 23:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744847216; cv=fail; b=MlOEETiQll70tb/t5Vdlo26deqFofmZn6sqNb2oIW9qwywp6xgUYC9GryqNP6uJbkMIWkgYiDcoQZz3ji5tGi7ra2ANapitsIllm2/0fGSf+jrFQ6ifkXOay4UW1jEft0vBV6fjiMPn0pUi/aCgCiaZOUJu3l4jZpS2p76e3Bac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744847216; c=relaxed/simple;
	bh=DRQbTBLbBkiGap39ewOAC9LnPNgwBoo8EtsnDWlPGUc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=CTF3qJh7QGXvXkJT+Q8nDmRQKpkxK4xtv0Y/bzfhmDDNDln+7st2k/OJqdAVgYjU+iWxa7dmuz+gOtNuVlnIbH++nuixZS542jzLeKalSTIqNII0ESzNunM5W7BfDc65zu7DAH1YjecO3JxQ/5boB1QmKwL+Uz32Sr+eV2kfS98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=VdcHCAj9; arc=fail smtp.client-ip=40.107.223.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="VdcHCAj9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o31YOEC6wObrvvm/e8OGi8t8JeMw0ORj21O+FexgvNwJomr/XZMBjBrQKpt9rb9qT1+XnPA8bxkolzzOKUDourMwfNhsOsB0CfkkCwdmMe//udFOuujqkHej8vpy7jIm2+pc0ocOci1VKdF4wN5wv+UvrF+u+Xj7o1KIgBWUp4hKEuJiBaZ/CRIlHRpkCUmkSWM/jYby5gx7AzhH2RZI/jSKhk5vJCGQXUViBt2j7AvsIyhjBJMLHilgpcIUAva8JgjGDWtiY0dV8129Ug5dmho+amVy1Efew4Z9PWFVDE1yi4Fcrq8EmrgqoUz4iLZNBb1F7FTgvq8tlaEcApc95A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfAMt/qGnbnF3B3ukDM+Fm9a0gCEH4GtSe4R/UEIRDY=;
 b=tlighLxzYQv4J8CSnHYALQN3S6gbwSvkv/E4gqncRNav4ntyn7xeJaU0VdPbjdS/fYWbC1ShmDj0rMjhLg5hsWM9k6D6cbhooLBcY+uA8c+Pav9e2uLLOM26CYnsWY2wXervS48oACzFCpWuJlfejYeoffUfPw6OM8++pGSquy5pBQIOz/nhcUCOZj9l6AGtT3hhn2UWJCg2VR8ooFM6RKB9eXCPIm3iFq8oOTtwXHVkw+RdwXVOgZDKnNVjnP5UTTgCwHCi43s+Ax1n3fG+tDphGL56xPTMZ/J6+kXezBF4oBefDkTI+BQgsEszZJURkZ0UklV9jyHu1leh9kTZrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfAMt/qGnbnF3B3ukDM+Fm9a0gCEH4GtSe4R/UEIRDY=;
 b=VdcHCAj9Q62l5yWDWX9M8vYG+ghInY8wESsgPcsi3LGipshTdidhPrRQbkUzwvitjhNVyb2cmu5f+zLQNFTUf/K/vB+Xq/8C1oIVqRl4RO4q6kZ2fNfzCP7g/7u3fpR1NJ0G3exDxN4Ej3FgozzUzzjQqR2tHBjd+cnucQSaWao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 CO1PR01MB9009.prod.exchangelabs.com (2603:10b6:303:275::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.22; Wed, 16 Apr 2025 23:46:51 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8655.022; Wed, 16 Apr 2025
 23:46:51 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, James Clark <james.clark@linaro.org>, James
 Morse <james.morse@arm.com>, Joey Gouly <joey.gouly@arm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Mark Brown <broonie@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, "Rob Herring (Arm)" <robh@kernel.org>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Shiqi Liu
 <shiqiliu@hust.edu.cn>, Will Deacon <will@kernel.org>, Yicong Yang
 <yangyicong@hisilicon.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm64: errata: Work around AmpereOne's erratum
 AC04_CPU_23
In-Reply-To: <Z_753eQ29wP7OQlg@linux.dev>
References: <20250415154711.1698544-1-scott@os.amperecomputing.com>
 <20250415154711.1698544-2-scott@os.amperecomputing.com>
 <Z_6SKjdvje1Lpeo3@linux.dev>
 <864iypgjjc.fsf@scott-ph-mail.amperecomputing.com>
 <Z_753eQ29wP7OQlg@linux.dev>
Date: Wed, 16 Apr 2025 16:05:19 -0700
Message-ID: <86plhbyafk.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: CY5PR19CA0039.namprd19.prod.outlook.com
 (2603:10b6:930:1a::29) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|CO1PR01MB9009:EE_
X-MS-Office365-Filtering-Correlation-Id: f1507d4f-7cd2-45ff-8cae-08dd7d40f5f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|7416014|376014|1800799024|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eSZwLW6g39/9lzNEk41KcqX8Bdaz4C6XWnGzZc9X2W2Q3zo4xaCUTu48UcXI?=
 =?us-ascii?Q?ixCH4WEE2W7ZMbLc51i9v3Cwe4HXJ/vOdIvO3hInFpXWG8GSYhdAfdn7zeXs?=
 =?us-ascii?Q?/VS+zJIE03ODOnwhrDSlnoRBDZHz0Tt5N3cNmyW4rOyZHC5saVblvYyEZllu?=
 =?us-ascii?Q?WPNd6vIiYv4pEFRcY6rcW65+l2+gqFI3iqywco59rNNgB1jL//CoOVvL9qVV?=
 =?us-ascii?Q?50BEWp7ClL7/konGAM+2/UOUhjrjUq+o4NGl9Gc9NrlQXf2DdfCxJcyzR1R9?=
 =?us-ascii?Q?Y4QZTu0HfO+EIG4f9OxQAP9DqoudH1i+OUYzzaGDhV37OBz80j/6n1Ka26IK?=
 =?us-ascii?Q?RSn7qAv7YHrqlfrAxjE32O1YI424Aq07xBa7e+3SOYIJv9EYPukUyJAH9niC?=
 =?us-ascii?Q?ShzhdezH5/CnbijkENgu8+rnbIDlOX54pNpjDIU6W/RRF5k/jowbup25SYjx?=
 =?us-ascii?Q?GVM05DspLFRyASxduiLz9tuZycrrifC+rf0zSWaETv0jKqIYtIWyppFOuppl?=
 =?us-ascii?Q?ZMAKXFgW+1hy3hZczB4rVgwp07GOp8Tm/lAAo4OXwby0BnDqpLv0mWL6b3SX?=
 =?us-ascii?Q?Rd6N11NIwc/AJxYDF4/tUTERT1QoAEPO1yIeyEOo4v//J/ko/pu57mc0eXe7?=
 =?us-ascii?Q?6k+eaNeb1aWzWHKGyigVKPLPwc9lIvGlMJJnbyvg4+ROHwdsBKbYagRPlEeT?=
 =?us-ascii?Q?HadQiaezwXUlciUBF3aTm3xO9XDZnFVuZcsrWoVWjtPcu2YO1AO6jon5YSbE?=
 =?us-ascii?Q?XaD9aZ7jdDKzWaa7tRPJifeoN/mgBoP46lacXnMl1prHXpqPkWyb6amQg/Pp?=
 =?us-ascii?Q?4pVk0QqPuU22av6f7Eg0vRCgJrCAeDgZTxxE0NBFhgmm4JmqCRXIwNgs+lt+?=
 =?us-ascii?Q?zm6nnAbbA7hdELE/FhQaSkbYH8Gagt8DZhLgwiSfTFhlUJx2+W4vrZmnk/UM?=
 =?us-ascii?Q?iZHzfH4EU97q29eOjTqIIS2gzzbwzPy4NaAiplyE1BTITGwWLlQQImttCak9?=
 =?us-ascii?Q?A8KsnmzHEtEuUJn5oyJJOoDi3eRhg/jqOjhcqmjECx+La0bOPUQtGe1RLF+V?=
 =?us-ascii?Q?QmKISgzYX8qUZ6fZk8BeMGxHtEzJ/4tqL6ebpa3tZAnL4xVDBBEtKB0Sy89p?=
 =?us-ascii?Q?ru8rdLGIaJg1lW3gEWtZEN5EBfkBmFvTc49nL57QMGCITktF3wiGmllbyF7q?=
 =?us-ascii?Q?agI2Xy0ftq1823TPX/KRS3fOr+ggOK9q41SomFOIWP/3t4a5wUXuzyJeAnaK?=
 =?us-ascii?Q?1AP9KjUaMB98cw47DlfP6IrDTfs97RHc2IYzD8zXsCC0ttYEpAesRl35KoYW?=
 =?us-ascii?Q?Ch3H7Wr82Tecz9+iuE240Tg9OToFBRDJxqzhWun5rosJRzyUvlSJIMGi2JhT?=
 =?us-ascii?Q?dOvmqDmlN2xj9QeZN2oFsXfFo3haeKxOGrN/+5d1vJSuO57Y/BNIQH2a9b83?=
 =?us-ascii?Q?faCuzIYHjPzCn9Xh3CGY3MVhpofjChAzST310WNVgjlDrhOToMBZAg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(7416014)(376014)(1800799024)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9qvq8oXQAINDZ3i+eclWm51H6wNwN405th7evJJtwaXfBQ3rfTEtliNq58nv?=
 =?us-ascii?Q?Uj6r2Au7+VtuTqg/04vfO+Mqxk7ftzAYEPriuZNYL/DoCdXm9aRmO6212H3e?=
 =?us-ascii?Q?SqDpvaxifLija8TsnXH6vD01Q7ReBm850ZlUtpL3XQzJNZGmb/YUPa2XZdMq?=
 =?us-ascii?Q?z9nv5FBwyG1zo9QxaqwYnaZBj0NxWxznoA+sC9pCRe3qfZEXJkNgj13jslfi?=
 =?us-ascii?Q?l/yBlAR4e+BBAny5u3dN7Ptl94GDa09acbfxNwfvJVCep1UnRBM2QCXMMxXG?=
 =?us-ascii?Q?vtin8r4HLSbAAvxCXFZqJH4iOSdBfoF9e/FX1gO+UPhK90aglQOwQwsE83f1?=
 =?us-ascii?Q?HVGvQm8jDCXSWfCh5LVo29U1cGh0xzWKv1ygYW18MKk7eJK6agzVaCwpQhA+?=
 =?us-ascii?Q?UIMKEr3FdAQ/Vk+ZELMq3aQ5CLjNQCOcQsYb0tvs1sXQYZDKNyuWz6xTB41J?=
 =?us-ascii?Q?20DZhHoEO/uZKKvP/JXjOcJn8l+bwqQF6RgpJzg3JaNRWErBRphNzZrk0+R0?=
 =?us-ascii?Q?ztTuq4Kd8ipLyHYHdfeflf086uvBf6rxRcujMDJ8hSRhD7XWvqSpun4lzEC2?=
 =?us-ascii?Q?GNO+w6za0ZAUNmVZuxjLc6ajxU6kjKSdVqida8J8pK1cftKB2xgOKE808Jrj?=
 =?us-ascii?Q?/b//Mrpo6SOVrDhwTrGbuJAl/ThrNVWKVx0imOZ7li+l5V6Y42gnPnnwGN2w?=
 =?us-ascii?Q?ECGECXfm4FC6kbQV9xAsJMPsIZCl733qQahgjUaSR06tgMDVyOAxQOGBHdZQ?=
 =?us-ascii?Q?t5GWcDsZjeBi0Fs35hvL6jCZbjWwpPQrEKrJe2vT21QuAAcqskfMdM/l/sCA?=
 =?us-ascii?Q?f7f4irDe3cLjxDXOgrKJ3VZ7cJ3/0qs9FQiGWQpaqKH6K63eCI/EXVSdpEVc?=
 =?us-ascii?Q?NetoqE76FwiPK4aG14YVWxpZuJp/y75K+HGkODdH9EprSDWGaJHgiVg1uknj?=
 =?us-ascii?Q?goXnBq/J0nJmV7x3JhR8eEPleq2I3uAsjMadF38JFGwTMf55APpVRLrFLRkt?=
 =?us-ascii?Q?y3QLrfwY81u1jRA8d0KwH2uWiUGHRuRGNNDtOT7qUw8vtz6jZx0wrd0a7sv5?=
 =?us-ascii?Q?Wr1tKTwVTyKlwZlnjfnkbtK8pvNlq7SLGB/2i9dSfEsLQ/KPhe4Z908qM6kG?=
 =?us-ascii?Q?DCLm0brlMft3/k0rzd6ToV3VTJhZ0tXyuNRHGxP+hmsl3EVEdcFkVsNrw88Y?=
 =?us-ascii?Q?NHt49GHQUPdhY0fety30Q7XM+Z2RKbC+G3y56dZFulS1a19j+lSLNo2D6dCY?=
 =?us-ascii?Q?2hj2gkXKvwBHgvutX5iCaAt66XkVFk3Q9eAEque/tyBA1FkcMa+xmhRmZd20?=
 =?us-ascii?Q?gzV9ugynUXYxRFNQSYxDW8feppqX/ltW3aUz4gN1O3zvoVhdKv4Nm53zbiaV?=
 =?us-ascii?Q?oYredeHdNHA6to1m/eAkimyvxtHwRTicZVCqD+KnbSecXdCepm7qIkIo5mDh?=
 =?us-ascii?Q?r5JaBcxOpUU38LhIxLiakU8ni7W5ojVy0OjUa0sV22XkDU60llQdbR04zEOA?=
 =?us-ascii?Q?k3k2xhXsY/C3jbj5q/XvlPOAIIUN8On94MBvmlGOjLhU9CVt/EXzJxNqcQS9?=
 =?us-ascii?Q?cLdqwSUsGjrdfc3+6GFqHyjUiKweYpaffb9q3ZTqn4lUcjjT7ue0eyf0EKaE?=
 =?us-ascii?Q?K1kaxQ30xakYeCc9mO/7pJY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1507d4f-7cd2-45ff-8cae-08dd7d40f5f9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 23:46:51.6044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kRFig8TiYE2j6mYmueH0lVpKLhpqCw71GNbrRREefBsaG/aWK7z9iYaB3ftTOOFiAldyGFTEUctTD2shD5X4o+ddUMchUAZnrO/GqG807YKn9rD+HV4qVQrYBF1n2KG3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB9009

Oliver Upton <oliver.upton@linux.dev> writes:

> On Tue, Apr 15, 2025 at 03:13:43PM -0700, D Scott Phillips wrote:
>> > At least from your erratum description it isn't clear to me that this
>> > eliminates the problem and only narrows the window of opportunity.
>> > Couldn't the implementation speculatively fetch translations with an
>> > unsynchronized HCR up to the ISB? Do we know what translation regimes
>> > are affected by the erratum?
>> 
>> Hi Oliver, I got some clarification from the core folks. The issue
>> affects the data side of the core only, not the instruction side.  I'll
>> update my description to include that.
>> 
>> Speculation after the `msr hcr_el2` couldn't launch a problem
>> translation when the `msr` is followed by an `isb` like this.
>
> Thanks, agree that the subsequent ISB protects against speculative
> behavior relating to the instruction stream. To be absolutely certain,
> there's no risk of, say, a TLB prefetcher pulling in a problematic
> translation in this window? IOW, there's no behavior that meets the ARM
> ARM definition of a Speculative operation that can lead to a corrupted
> translation.

Yes, that's right, it's just translations from load/store instructions,
and the DSB before closes the window where earlier instructions can get
corrupted, and then the ISB after prevents the window for corruption
from later instructions from overlapping with the write to HCR.

> Sorry to hassle about these issues but they're helpful for maintaining
> the workaround in the future. If you can fold all the extra details into
> the patch for v2 that'd be great.

No worries, and sorry to not have the description more clear
originally. I'll include a more complete description in the next
version.
