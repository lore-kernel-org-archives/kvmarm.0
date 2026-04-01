Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA1C366068
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775087779; cv=fail; b=nIafWZ9/OEf7vF0QDhz8DRJVskTuOxnccVcC3Pg+iKeEcYcVmaUAyppV8JOxXI51edmwswOgNEPGVoA8yGdsxcPOZ+ZgPtoqCmN19vs0fQD1mqV8vt2qIwCx8NKX0UBvogdmZrCpC86a34+BmXLIRHcOlyBVdzLcHEF3r6EU/94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775087779; c=relaxed/simple;
	bh=7HbXlmKCm4w6pIjB+Csk9OzBEn8lemTbKTNMPgOm9wM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lJ/cPzuB36EQaAYL9gPrQkiKba5VIe+lm7/RN0Hcrx/uKGJ3z6lC5vYrQRE9lsbFZTMVYN0pdHf5OzS0UlKDj81NDzD5ArIqIDULQKPpwDJ0MUHrvFKImHJPJr/+RtbD/tMKYHtCuWtsMhmcEN41ZKw3S4n918X+e6UZf4KCNcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HBxTPNp1; arc=fail smtp.client-ip=40.107.200.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HBxTPNp1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s4FzAvpVjZv1UUWfRHgH9NAbVfEtHDq2dN0hxLiw2P2EZ55QzXjadoyaSCC09OtX7NflCzrv52ghtN21JNxAPiuRD/ekX+6j+2kgCRmV8ZDwkqm8wiKsaO8C132kfAoP3zv4MY/dtakEeC+l8db5ieCcHaSa3ZYrfQ4MUcXfwcqgj3OfRgkse1EOmDNBnuY4AsX/J4sJDyeCCJtzRoW5wOd2wA8BLBBovZrXdJfxKrqq0p1yWHPxS8UJdgL94xn6ZWpdANh4BKsXPJJjOnG5VnDgIGjqGpsg9+nJAeX1q9J9fFDGL/2KvZyokySh09VYOZXDQzBwdy/FWLCyEmYSdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/OMoArjNXvRr/s+aqDBMrrV+TcjwLcLLcOxLzU8oyY=;
 b=vCX5ZbMrDxaQfLHFMb3QNdjJX+KajM5xFAyhGhwPfRqmaFH5adRP2vEEl2vIZrPlggyxdkZbaKcHHSPQHNkhUIvWMouCMa86G+/TtsFSyMVGIZpxWVOZQbuWTtmDWlqEMgdo+9RXW9PwHSq22ipopSINsacH3qx1AflaMuaRzuPXmmc18P4fpBHr5rqwb32nj0gzjTnRRm2VJlMvtmiGg3nhfx1f/JcnGdHuAJqczvwDC7zK8RgmpAxNVyEByfMjYqAogEItge0p/lNsxtcuSuzHXsfN7u9UEZEoSrs3ab6jPtcdnZzOKkHdJsDq2SvwsUHc807sI5i3kC0DPC8rgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/OMoArjNXvRr/s+aqDBMrrV+TcjwLcLLcOxLzU8oyY=;
 b=HBxTPNp1VUlqBjFFrec+TUeZBwqyCZ/5oawBkSHqO6iEn7XjrifLKd9YoFm/rsbT/wQzMY848Z04/k7AK76FQYsT12DR1h4lCJFJz5HbmkzW9Af9VQN+vNUeCjHn3zH3WE1nViffBtleN0E17k0Iq3rvPkAOACmfAKYyMzPM1eLpXxSh1JahOjQxZCe92LH5+wobi07j+bBk9GRiFnsBEpb7gsRgSGtb2f7tJ5OydaAlucwyS++PRQBe6PL8lBxgIVKw0XcY4aWRt6V5x2W+b6HNvdhj7+gKZxZxtcayPUOaV4ci56TZnXwactTSXHgaz9YGRuH3hTBd3ALUubwMrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 SN7PR12MB7204.namprd12.prod.outlook.com (2603:10b6:806:2ab::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.15; Wed, 1 Apr 2026 23:56:12 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b%6]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 23:56:12 +0000
Message-ID: <8c4f8019-f6eb-4a3b-a6cf-96e533bfa15f@nvidia.com>
Date: Wed, 1 Apr 2026 16:56:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 gshan@redhat.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org
References: <20260313144617.3420416-1-ben.horgan@arm.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20260313144617.3420416-1-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0099.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::40) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|SN7PR12MB7204:EE_
X-MS-Office365-Filtering-Correlation-Id: bea33135-c5df-4629-1ea6-08de904a3ff3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zt2VmHDkmRHEVm7q5SeL2sY9EZE408tOfEcSXLUrz+XadwaslK6qO9psBQIVZDHppQ8M9SRoBcbW7h4kSfdQ+btClFKytnN4sTadPu1cr0BKKsg8uKQ87xfUGgmAf4SRUExiTgPbX0opLUuHNFxel2icDvXtSo96J2TwZ3y4oDhZ67EqXn1WhEnRm4ZGKuCI2KEFC3XFWgEC7BS3v8KLKzyR0oKD9MmoL0gPNgAlVXG0jbjLc4n+k3QeT+PcyVRCCZ9J82Gf2RQHJ74uOASy66rs0WZDwokf3Nql84g6FGL48Ihn+1kjU9Un2vkVtFKG1j3QukkKzNuAxpGZYs2esPAvjlGRNQ6FodKo41ilnpovmq6NkOPCIwFhzW3oZZNEdGd+cweMDGl9JlYK7l88EBL3XIxh4uBfIXlslqeZlkkjX/sLrV5oi/TKS3mlR9b6xMvME068IBZhBnwB8raaA4x9IaKS2Jecn0/Dc0PBqByapdh+OjBcQjO5AZvQi3gKWXuaLpuFXdiCXV8epPd1hiFjIE7Z5BhYgShAhqiOUPnrLegkZ0NaLyH11xpldrOqU42VaC3olaZ1HrxKdgezDR170iI68aXA+jWxF72nK/NWTFlhe52jqy/Qh2Y9G0vlS8q13SsnX4/jywpHkgxcvqRuwSsqCZd1MGuh0ZAFg1Y+sLDkmpU2VdokRJpa1WyYVYZPgRr5IuUUvi4XaZnZDdcuw6+8rgqfe3ApkF8a5K4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUIwS0RjK2IySHB1eDNaQytleU9BV1Nua2N6dDVSTFJxNGk0SERPZ0l4YTAy?=
 =?utf-8?B?clF4bFZmNnZoczAzdkVNS3hTWjFVQmlRWnhNcWVDeVptR0J2MzFVR3dUakJ2?=
 =?utf-8?B?bnBYbGZBMFJpK29tVFVRbDF2aW1oZTFDZjF0WWU4YmpFOHFZQzVKTk8zNDd0?=
 =?utf-8?B?N2pib0lPRW9Pd2ppMnBQNms5MHJ3YXc4VHVXUXBKeC96TytPZEg1d3NmNkM2?=
 =?utf-8?B?aGtkclR6c2pSbzFiRGZNMzJmT2NuYS9FUFFwN1hZQXJTT2g4VE1GOGdHUEhm?=
 =?utf-8?B?QTVuMy9lZW1WajhvaHdlcnlCbExRbkhKclpIN1pFOElEb0EvQVF4djdWQ2hE?=
 =?utf-8?B?dXp6eVYrR1ZwQnJzUXVMaDIxQUtHQllERHFpb2QxdGRJamlQdU13aWhESGFF?=
 =?utf-8?B?UlZHWlNqbUNEanZYanlSRkJ3VXNXR3JzNnFhZk12T09heTFhOElTVklUNkU3?=
 =?utf-8?B?WTNnb1V4akhJZTV0MkVnV3RpNS9MajVWMXltOGF3M1ltU1NzdjI3NWZ6Ri9E?=
 =?utf-8?B?RjVwMkRtN2t4bTdsWXdQZWhZZnhqUGpzL2lkYmJ2YkxqSjhCNngxUTlYWjdj?=
 =?utf-8?B?blFIcHBtMnhUVmNMNlowbThnOUhMVFB0YWZPNUZIVmtsTjlTVmo1Vzk5OG96?=
 =?utf-8?B?M2IveXdqQkRkaVVlMUZJSlZoa094d0M2TzYySk5Rbzc1WC91TW9JMFNuU1ls?=
 =?utf-8?B?R1UxZ0o0SDZTRmdRWXExQTVyelFyUnJaU0x6TW5xSWE4dWFZMTY1akFKUE1X?=
 =?utf-8?B?V2I5dUlkcUV6cTJCbUQ5aC9qTWZGSHphTytyODJIUXNwc2tzTHo3WllNOVpV?=
 =?utf-8?B?MVExTmE5Y3d2dVRzVnBGaU1Ya1RURng1UjNTQTROemhuZnlnVU51dGtEeUNi?=
 =?utf-8?B?YnJNS094Ymx3Nkpxem9yYWZndkxUQ3duOG5OczUvLzRiQVZxRnNpMEdnU1lG?=
 =?utf-8?B?eGhqbU5yc0plNVNJOFRmNUo1ZEJLNFRlQUlvTm96T1p0Z291Zm9TSEJUOFd4?=
 =?utf-8?B?emx2M1drekt6V3JLcEIyRnlLTXZZcVV5bGZvcHlhanE1N3p4NmQ2SkI5TDZ2?=
 =?utf-8?B?MC9MRDcySGxGUlM1TU1SN3JIODVEcTFLV0h5NmRyMTUwcnJGRXhWYURkQk8y?=
 =?utf-8?B?WCt0U0tMZTNubkpadGI4M1JaM3hBOStOSVIrSEM0N3puSHZhNEEwS0tXMHZT?=
 =?utf-8?B?YWhNcHhDcHpRcW53NGMreVBzOVRlc0huRW5vNkxEaWliNUczYTBpZzVzc0Yw?=
 =?utf-8?B?bERwWUhLNWJGUm5rTkZ6MEN3ZVZEL2FGd3duSWdMYzRDeVp0VGkrRW5wV0JJ?=
 =?utf-8?B?SjIzVk1IOEowcE51dG0yRVlvV0t1WmVHS0xuNXE4Q1QrSjIxa3g0bXJCM1p6?=
 =?utf-8?B?UC9SN3VGQWZlNERoOGxFV1NCendZQXc2ckJvL1JqSWV2V3Z4cUQ1OWVrTC90?=
 =?utf-8?B?WmRmdjlkRVhTREdVa0REc2FsS05PeW5pSlJ4enpGU1BkQUNDUCswNkZCcHFJ?=
 =?utf-8?B?RFh6TWZ1UHVsVWl0d1BucU80ajB6bUsxZ2pUVHNDN0YrK1RwTnNDWE9hR1Fl?=
 =?utf-8?B?SUF3L1hCaE5Nd2ZUSzVVZGZJUVJhRkM2dGNNRmdJVzk2WVFneDRUbUdqNlpa?=
 =?utf-8?B?cnVDNjl4V2VnOFJHY2FVTTdpaVgxa05hNDNnWVF3UVdqb3ozTnZPMVA4SEVa?=
 =?utf-8?B?cUxxVEMzekV2NUJGZS9qOGlLb1JWbjFtOFlTU2FHN0FuU3A4dVFCbjNRemNz?=
 =?utf-8?B?SUVqYUtBRDVXamNPNHlCbmNoWFAxL0llKytuR3BvZUpiWHg1VTZ2SytxT0h1?=
 =?utf-8?B?ZjcvblduWDlZVXNXWncwWENLNGFON0lXQUE0KzhHSkUvUkFMVHlpc2Y0SEg2?=
 =?utf-8?B?M0lKLzJnMjQxUEQ3NVZGY2ExL0dkZllwODRwZENuR1lIUzB6ZVRLUWdicUta?=
 =?utf-8?B?dG1zdkNkU0k2Y0Z6NXFqODd0U2hVejhBYWxXVVNPNTFpQ0xCd3lEaEtoZ1ZS?=
 =?utf-8?B?K1Jkd3htWWlBSlV1U0JoTDJCYTJiTm5qUzNuSWpmM0tidmJlUHNDS1Foc1F2?=
 =?utf-8?B?eHhURDlqWVpXNHUvWnMvOENScnphcjhUMnk5MXNxZTNCYTZ6aVBWMmdlRXB6?=
 =?utf-8?B?eVorbGRndmgycnVlK0xRdVMyeGdXVVoxVEtsMFdTOWw1Qkl1S0xhOFF2U2VW?=
 =?utf-8?B?QXpGek1leG9ydThWZ0YrRmJxS21hdGlqZGc1aHI1Y2t1YS8wWE9zVzBKSEZZ?=
 =?utf-8?B?MFY3SWhCRHFPV3AvSVorSFBVVm5ZRnI4YXh5a1hsd1BUQmt5aG8rV2R6K2RP?=
 =?utf-8?B?SW9uL01hdzFpNW1aSzZKSTZWN3FpNTZxS0FIZzlLaUlYNGJjRUJ1QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bea33135-c5df-4629-1ea6-08de904a3ff3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 23:56:12.1012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFQvAyEFdPW7XNAGoaw60Hd5UL6E9UL9WX7870ePg7lIe1dDEGoTL3u/QZuSV4joL1Mx0t6B5YDu1H6IDNHsHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7204



On 3/13/26 07:45, Ben Horgan wrote:
> This version of the mpam missing pieces series sees a couple of things
> dropped or hidden. Memory bandwith utilization with free-running counters
> is dropped in preference of just always using 'mbm_event' mode (ABMC
> emulation) which simplifies the code and allows for, in the future,
> filtering by read/write traffic. So, for the interim, there is no memory
> bandwidth utilization support. CDP is hidden behind config expert as
> remount of resctrl fs could potentially lead to out of range PARTIDs being
> used and the fix requires a change in fs/resctrl. The setting of MPAM2_EL2
> (for pkvm/nvhe) is dropped as too expensive a write for not much value.
> 
> There are a couple of 'fixes' at the start of the series which address
> problems in the base driver but are only user visible due to this series.

Tested-by: Fenghua Yu <fenghuay@nvidia.com>

Thanks.

-Fenghua
