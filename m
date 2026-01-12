Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010050.outbound.protection.outlook.com [52.101.193.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A53E301704
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238018; cv=fail; b=uqmTGa9e7S3rAwzph3KVIgMI2+INVdaQV7v4u+ltiY6A+2upoloyoE7ciEXt9j6Ag/o3nDzzpitmI2UEGZcSntxunrpc+4nXu5xMtydmCPdZqJPTGtvKBTd8Kegmka5MbFhx5XXBo9c29ZNCD7xhPA/MeTHq2Mlg4iLXHFmG8P4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238018; c=relaxed/simple;
	bh=M5B9kZm0VLh4SJ2uVvLoBQR1IebMbQm5boXvdGlAFS0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I8sicvMd8Jw0LrEb+fKbQQ4co2lO8oAEexbX8HHKi8G3kf/kJnHD+lHcBEvoIyEhXP5Nc914JUazflzcErdgbzFXfb2PfrC/Xtuj3UA71KRpZYt57BFgJ+6r52XgLr6rSSeJodH4wEEgF1WTKCJ346mdqVdeFNcChtPtm/lYOuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MqrJ1NqX; arc=fail smtp.client-ip=52.101.193.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MqrJ1NqX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KNEA8Z1nDutN4NPWETN07gss6vSEZoWRFKmJHOYU8FS43tUH8CbxHy9TjLuE2xL1V2+FHIOtCvG+4S57DIRzTOQOIOTDwY92CPlNJ0ouyPKrJT59FP1QfL5DWe3qB/54RHd15L/kRDbvR8lOezKsZchcaf1VZNlg9zl1p9HtbIzXLkvoo7P3Tp3Nw+V/3MVDeP2wzzMKexLHuiU1N8MLa8OmityYv4dFHAMLMQW2Wht+4aDuqt7Zyw1rVge0n8eDZdKEJqLvlaQuJCcpsnJkFySEOdYhGX7MpiYWAxLUvVZ5yS/Jwux5K//H2Ms6HyH/8Knmnr/mzHua+TBNirA8Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3azsx/TlupQuViYxPRjiHUozIX3kvS+yL4rNd/fuTqY=;
 b=aUlW8lVt4TWgYPK85QSFQ02gZ9L10NxJTapLQZZJqRPUIY1KkV3z4BA3Zh3lmwFJY6VqqRTIiG1lyISLuznnCQ+lVbKQMFbqGe3JSDlZ0hPwE6GKhntPX4NIKNGyiK/Y/9LAJSMn0zh+d0gT+z7vlEHkZpY3o8XVOu1mONy35S2rbLmmg8+jCQGHGMGB9PdMUI8ZGjaQLtZIgcADpRupEtq00BovOPGKFuXSpCUwrTyM760AvAsg57IY0gbQo+tAZImY95d3ATTHhvEgPhdimpjFpyz6q+lTAcMlZrcYnBoCXzjWayP5ywBI+vBtHcPAp0cYwmGOcubkhlYVWBLQcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3azsx/TlupQuViYxPRjiHUozIX3kvS+yL4rNd/fuTqY=;
 b=MqrJ1NqX1GvULiz1TZqaNV9N273Q6oeCfkvmnS+n8H+0w3+/BfSMMTgTFp/GXYYxU6gJWAAV+E3aLGP0imcJmZ2HW8QBB4UfLneWwj+hHp3SaeIBOftxDmJeagOhYJ5pnFQmY43VTmL7CvrPPOdIbwNCgvtDIMmdD+/v62nK2JpkQ7bJHz3A2rgS5iK2e3KR2jnFn5VJex3bnRAljXfX5dgmy+Ap8AfZ9QGdQBHW+ooziVGbqJQKUfjfycoZnKCkVpAycaYojqzTpM2p5VjPccn3tnXH+TL0zpVpmx7M/37UqZz0b72l/bGZJQbiJKmhjG6WBB9bnpV9mjNqN1JYqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 IA1PR12MB9029.namprd12.prod.outlook.com (2603:10b6:208:3f0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 17:13:28 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2%6]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 17:13:28 +0000
Message-ID: <69ca8e97-9bc5-42b9-b7d5-cb37a82633e7@nvidia.com>
Date: Mon, 12 Jan 2026 09:13:24 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/47] arm_mpam: Remove duplicate linux/srcu.h header
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
 Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
 Abaci Robot <abaci@linux.alibaba.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-2-ben.horgan@arm.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20260112165914.4086692-2-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:a03:254::18) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|IA1PR12MB9029:EE_
X-MS-Office365-Filtering-Correlation-Id: 98ed2143-edd1-40a3-2b2c-08de51fde73a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWRZd05nUC9YNk45dDRXUFJVTm9KczRmeDYxMVgzUytKcXVnT2NzUHpSWmlX?=
 =?utf-8?B?ZUZkZ04xR01jNFp6QWdRekdLWjVUZm53cGgwSnh3RGR4WWZBVmZTeTVEMW5i?=
 =?utf-8?B?WjFtQzN6QjM3YmtGb0hDdUU3STIzeXU2MTRhSHB1TmdPUTFTMHBKelgyUWxJ?=
 =?utf-8?B?UzlhZ1QrLzFSYzZvR3RodlR5VjIyU29Ob1o2dmN5Q1NrTEVGZndMV1ZPVWpK?=
 =?utf-8?B?eEFVYTNwbXpZTWZTV0NSSjNTb1JXVDQxZWluQXpScllQdS9oWkpMdklNWngw?=
 =?utf-8?B?bFBCSEhhNjg3dGdkOUx4STZ6ekl3RDdSS0VyR1NIVzZKdm5LU1BOZUVmbDh2?=
 =?utf-8?B?WVZNaW1mNUxJcndUdE42Tjl1aDNlb09TMCs1MGhXMWVjTUpIYlI3a1hXV3Ir?=
 =?utf-8?B?OWNERHdGUUcwcmdYRmlRTGJXRnJrSUl1ZUZYdWVLSk9leXFwcFgvUVpKcHNH?=
 =?utf-8?B?R2dtSys5V0x5MVhEYnBRVll3Y2RVWkpIQ29WZWtQZWs5RnhLTzgwQ0l1bTEy?=
 =?utf-8?B?SDdrRWUxdXdSOEowS1d0czU4TW01c3NJTU0vVEFHcHJ2Ymh2ODJPZk14dW1o?=
 =?utf-8?B?dzg2cGZZU1NyeU1nLzZXK0x1WUhHbDI1ZUFCajZJa1hCamZWR2FaT21qVGFL?=
 =?utf-8?B?L0xMZW9kRjFubENoSktNeHRyWmh4TXlpZ2tHVUc5aTRrM1ZHZExYV003LzZ2?=
 =?utf-8?B?Rk5FR2pxRlBBU3V0eGh0Ky9rYTl1YzlsSXRUMzM0aHM5MmJwbnNvOVRqcklE?=
 =?utf-8?B?VXorbmZZVStMUG1pcTBOZHdnYnNWQUFaWEtiUEFYZ1NZU29XamRtbjQ3SWw4?=
 =?utf-8?B?OEorRWUwVmN2Q2RabHdCQUQvWnhTZHhyNUhFcTJ5UlZ5T205RFdBdDVBVGp2?=
 =?utf-8?B?ZTRHb24xR3J2c2VSY3ppa2NGamQrRXpaNHJQcTB4WFkzY3U2YXdsWXpFUFQv?=
 =?utf-8?B?TXp4aVVCc04vQmJ3UjduZXZHcHZZa0J5RlNhZjFobXBMUndvUkh4Tm9jVXhh?=
 =?utf-8?B?aE1kK2I2S1JxZkgzemo0Yzc3YkY3T1UxR1VvWWN5KzlOdlVCeHc4WVlLWGVJ?=
 =?utf-8?B?VnFyS2pjSmZJRDBWR0IrRjYyem9TMFBpUmFseUpHQWk5bU04ckJJdGU2T1ZT?=
 =?utf-8?B?bDFLNTdQYW1pUHpGL1Q4YnE2MGl0c3NIVW9Tcnc4UEhOcjBEaTNCdnlXNEx6?=
 =?utf-8?B?S0lJdkVlWHBPbDBMSE9CbXJGaC94YUVUeE1qSC9BUytDaTJ5a2ZjN29vbTdp?=
 =?utf-8?B?YXJVOEVYamFqVnZWallJeDZSYlFoQ0dzYzNmZlZQeDk5TnZlQkt6cHBuNWdG?=
 =?utf-8?B?RDBHWXR3MWRoajBZUjJUbGJ4VkVveWdLQkh1VXNvODZKSm40aXJBbjgyOVEr?=
 =?utf-8?B?UjVOMk1kdndYKzVIRGh0dldTdHRLdDR0SEhvbCtMcWhJRHRyVGxiL2FhTU8v?=
 =?utf-8?B?VW1ZQUsrcDcwZ2VOQjljMjZrcUNwenRZRVBaWFFRUEZwa1FFTzEvUGwxczlm?=
 =?utf-8?B?ZitzVXV0Qmd0c1JWdkdqQ0toeHZTalQwWlFDdmpnRnJiM0RIM3h2Ynd0RWQv?=
 =?utf-8?B?Um1ibWRVZlpHdEZaaUR4SWJvM25EVjc0alFlc3VZVFdjeVV1ZkZ2MEloUkxD?=
 =?utf-8?B?ZFMvREM1eFhHWTJ3MFJhK04yUk9iZERUZXRTU1pTeDgvekpBRDJsaU5PaFFl?=
 =?utf-8?B?UjVRN3B5bktyN1lYR3plMENiTGhGTUF2bFI4QlFpdE9Qcll1cnZuaCsxN0VE?=
 =?utf-8?B?dFRrT3hlZm43NEo5VVVodEV3VTNwZFNTMkI1clB5RVdYWk1SaTJUajNIR3B2?=
 =?utf-8?B?RTNIbjB0b3J4YjNzb1ZTSWM4MzJHSFdheHA2UWlmSGhDRmdNeVBxbUkxY0VM?=
 =?utf-8?B?OWtDYkwxWDFReXNoUy96THBLL3BWVGZCcVFPalhobldWWDBtYmxOdXMxcW1C?=
 =?utf-8?Q?TqjD0RVWkmcQike5/BfcGeSeXgx65ske?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlFCNkVNV0R0a1Fzd0RuYkgwUTF3WHlqSEU0MTN1WUo1Q0o3cUhhaks2Mmkx?=
 =?utf-8?B?bHVRZXJhMGJEVDNXK2hjV3kxRHVLQ2VxWVJ4R0o2VWIwaExEWmtTZzNZMUx3?=
 =?utf-8?B?R2IxMTArbWZtdWNUOFBRMkZhM3BqRS9vWlBsYVlYSG15bWxubEd4eUFjcStS?=
 =?utf-8?B?MFRNYVNyVVhhb0hKL0NUSnptbXBzSkp1aks2SFBuak80YVNjb1FsOVNMQllD?=
 =?utf-8?B?d2UyM2hjY3MxajNLdTVUcnFZeWozYllLa3lCaGZ3WkhFSWplN2UzVmpkRlZy?=
 =?utf-8?B?ZEpnNUdySHJmRlJwczRKS2dqcURuL25aSkNrWEV6eXQ1NFNWMGl2UzQ0OXI4?=
 =?utf-8?B?WmJVNE5FaGVqOHRsWTBNNWpOWkxKdGRMdXpLekduSkJqcDVydnFrMGR0Zjli?=
 =?utf-8?B?b1B0SmFtenEvN1hheVV6clByOVJsekhrK2Y4Q09SR3VWSjZDVzM0c1Qzc01S?=
 =?utf-8?B?SG5FNTZiajF4dlFMSDNkKzdnaVMwM1ZvclpUMmxla0FGQ0h5OHpLK0d2Q0ky?=
 =?utf-8?B?RXZsSXRuRTVYTGNMS01tSTlRbHQxUkJnaWYzakZiUGJqR3VWNHMrYmRBeWsz?=
 =?utf-8?B?VzRKam9LZHBhVS9HOUxmZmZNZ2xCOGpLaEZneFg5YUxUVnU3ZzkwanBlb0hJ?=
 =?utf-8?B?NlNGQ0tsRm5WclR2UFBHRjlYK2JTQjZBVHY5bFBvdGtiUGM4QmRNMzRSYU9j?=
 =?utf-8?B?SVNEQ3Y4TWRqd0xTNXZWQno4VGUybmZOR0djeGdBTmgxOXFlOTdlWHFxMEt4?=
 =?utf-8?B?VEFVOUI4a1VxSjlpZzdrTkNkWEJNYXNBQm8zbGdFdmQ0cExJUTFlQTdOZy9W?=
 =?utf-8?B?YUpxcUxCTVoxSHdYRm1IUC9kMURMZWNUZzIreXE1OS9peXllaXBWK1o3d3Vk?=
 =?utf-8?B?VkVSZWYxZ2ZWWElmWmxaMGY0bm1Qb0k4WTF6OFdBb3dGa29LMTVxWDhrK3Ji?=
 =?utf-8?B?MWVsN1QvZkYxNnMyZlp6MSs0NGhWQzZqZlJLUVJQUUZKWTN0M3dzRkY5L1E4?=
 =?utf-8?B?OHRieWtQSEhOY09BUXFhSzFEdjF4YkJTbFB6cjVlNHp6Z1NaNDJPaGRseGRO?=
 =?utf-8?B?dmk1Z0Z6QnpwWEorY3NnNmc5amlJZVc4RW1QUW1WNGtmYkFWZ05SZVh1eDhk?=
 =?utf-8?B?Q01YdjJqeGNQUHY1aGRQRTkrQUJxY21BOFpmejREcUpqa3BLWmx2S2lEY1Yy?=
 =?utf-8?B?TzRzWml3SGdTV0FWcVpmZWRCWEVscy93emh2dUpTbllORHdraHUxRVlzcGM5?=
 =?utf-8?B?d292bzkrQ3JReGZPTjFEanU3cWtuWmJseUF1N254a2VDRnFKdzQ5amJ2Z08y?=
 =?utf-8?B?RFBsTDhIaTYwaUhwYzBBWlZhUEtxNkJKOEZ6RXZUK1VXUVZOdVMzdW1IRVA4?=
 =?utf-8?B?R2JES25GcUN0dkFXQkVoQUVSYXY3aGxMcHFFUnhNeWZXNkVMU2VJYlhzdGZ3?=
 =?utf-8?B?VXVEeFhJUmM4WnZrUVFjeXZqWTRCYS9MN3VtSlBac0pJTGNxSExhUVBRV1RE?=
 =?utf-8?B?Mmgwbi9HbTNueXJvTGJ3Y1pLYzdpbWhHenFreHJmZ2JZRzFncE9FQ0dReGht?=
 =?utf-8?B?ZUw0aUlXZWRKQmlxaVVmZXRieUFIUEl2OVVuT0hicTRha003OVYwVWMrUzhP?=
 =?utf-8?B?cFVHdzA1WXRkdVhOb2FTWmVabC9GSmt6bVNMQkFNMG1HclBqSHIvNFA5REJO?=
 =?utf-8?B?Tzc0N0ZsaFRKNTB4TmFoYUdsNTdUVHhzMUpVdENuMEhCYm9tdE9neXhQbzlQ?=
 =?utf-8?B?NksvTFpZS011Zm45aFBqa2s4WHhvTkdyZkJhdzZUZWRVd0haTk1WWTJLUU5j?=
 =?utf-8?B?Zk5NdEpjNElkeklXdDR0TkZTZlhVNGNnSURVaTd0aW5jSUxLUHZhU1lXM0ZY?=
 =?utf-8?B?eHAzS3JMcmpEOTEyRjNaNHF2WmVheDgzTkdlQmd5Ylhmb005YStZcXFEWk5i?=
 =?utf-8?B?ajdkWE01a2wrdHkrR2dvV2lkTmhTOUp5K0tJckRkcC9DZ3J6V041djdJOHpv?=
 =?utf-8?B?YXVmejVra0lJS0hTay93aGRlUFljOCtOTUladlFMUkVmWjgzT2xhWFJ5bUxV?=
 =?utf-8?B?N3FwRmw3NHl3blR6Um1Ca09UNm1DRENsc285Yit4WWVmeFdGQnFxbE1MY0FL?=
 =?utf-8?B?VmpWK3lFSU13QlJuL3ZwSHFLY0ZqL2IwTk1DS09Ca2FVWFNKV2w4bzl5ekhH?=
 =?utf-8?B?WlVwVVJtYXplM3dqaGJiMFdybVFERjY4bFN0RlpqV3ZGbGs3WEw4d0dsZkYv?=
 =?utf-8?B?MFZoeG5RUmpFMVJ2elpJR2VNVVBpM3BNQUpiRGtvMnJXMnVaVDZkSGl4RlNO?=
 =?utf-8?B?WXNyV3B2QVFLMTZEaXg2bFJaRzZjaDZUVlV0SFFGN3c3K0orTG5nUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ed2143-edd1-40a3-2b2c-08de51fde73a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 17:13:28.3294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VgxGNWC3lwF1R+5lR/yX74FJWdWRKTGFA3Bg5gmzZX4YxPWfxPBZLNBcLJ+5Np7WJqpgTXpZMYHZoMm2ELGYyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9029



On 1/12/26 08:58, Ben Horgan wrote:
> From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> ./drivers/resctrl/mpam_internal.h: linux/srcu.h is included more than once.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=27328
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Acked-by: James Morse <james.morse@arm.com>
> [BH: Keep alphabetical order]
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>

Thanks.

-Fenghua
