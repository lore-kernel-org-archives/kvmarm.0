Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2102.outbound.protection.outlook.com [40.107.244.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA7022318
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 03:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749784576; cv=fail; b=Y73DhV6blgz0Ew3VMmChZMQflsn/0hl4nrKrYPhQYnTR9P03C15/8b0OCj8XAzWU+hbvnzjL+jvgICNHY1Umvtq8lnAGUkv5RernTyiy40o9d4MtXIor3vA2Ysq6MapDE4eYa2FFdDffmiBFpuIW9r+nv5W13Wups7ecH3PjWkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749784576; c=relaxed/simple;
	bh=7642wQDsyBNxcIJQoiUXST/teBr3fRBsnyWMQdp0op0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V0ZViU4WYXtJfWbMNvkFrD2la275J6wabz4EAkPV/A+F8pvFHEBbUgFW4wLmeJB9C15sgLGbbF29nU+lwzHFEPY9cz2CCR/B1UelldTbuiAwXUMloJX0nxFtAfTjoRE9gZCZF++PE43SBDvbYb2deAs0G2rIFqoqYxBPAfVt9eU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amperemail.onmicrosoft.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=fail (0-bit key) header.d=amperemail.onmicrosoft.com header.i=@amperemail.onmicrosoft.com header.b=ozzq/Lc3 reason="key not found in DNS"; arc=fail smtp.client-ip=40.107.244.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amperemail.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=amperemail.onmicrosoft.com header.i=@amperemail.onmicrosoft.com header.b="ozzq/Lc3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BNSQwbbPj1wjcH5h5MKtv3TkKgBGX517m8PUckxyfHbQyYHtRot6NkgI8BMK+e44CIAQzpXopB0Np+y2iHtEpFPW9Q12qJTM1rRmkPdgaajMxUOdgS8R/U3Ywq4Q4MzfsgtnR3l24CUe4zTMS9fYTi0LTxjEJOtk1R0XEYC6Z/18sl+ksRzEKFro9xn/gnymxzIb91vM+ujvCS65wM6mWJImuQz/vnSWaT3AMacAwieqM0k5cBRliqtXXjBB1DUV6Xg9MJK5smf4yUTuZmtDIPvJzuLe3wF3cnhI8OxchcctRC3kdgIcM76P6zoQMRdqH/B1gbsX0UwtTSOg2MkcOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wu1Rbj5R9TlTeIj2nUkeEzz5Dw4zTebJyl0NRk8rX/w=;
 b=Jj96mtFvwjFrRFOyfdcz3GdW6tQvMcs3mN93csDQ1DSVB+VlPLBcwRNhJYxcgw81YTeYzwsMaLR3GLAWnCXO9b0VLy7Y+MUvNuR7F02pUzATgUtsBK8X7UP+5+6co4qubRY3G6EKPLIvx5/Q9tOAp9gpK0u7TA8uPchhRq9GLkukfFVpW4subIdLPANcM5fvlMZmq9gUDgFNyU5sVaVgSiIZoHkbf6QD4i6cS4PIVDhNC/+ZiRfH22QCTQioGecG14C8y71GpQV8S0JurnUHF2PKo5P7Z8qfzipngChBZ2dT4N7whxqZfljU2vjbtn6gXt2CbSBgJuesEg+gsr7Www==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wu1Rbj5R9TlTeIj2nUkeEzz5Dw4zTebJyl0NRk8rX/w=;
 b=ozzq/Lc3apgcw/EGHhIA2ogJZuAfCULGSkpAGOpzFMzyoAXEFgbxHEvow2mruzGpmtmN5uAIwVkzi9zpC/jzCV6+ExU8lgdydat/uKg/08e6nV0/26ih2IDKF6M10DV27zo4UHrt8sLJV6qfooVq6eMKLAqvvylUbEcepPThcxM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from BN3PR01MB9212.prod.exchangelabs.com (2603:10b6:408:2cb::8) by
 SA1PR01MB8564.prod.exchangelabs.com (2603:10b6:806:37b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.18; Fri, 13 Jun 2025 03:16:08 +0000
Received: from BN3PR01MB9212.prod.exchangelabs.com
 ([fe80::3513:ad6e:208c:5dbd]) by BN3PR01MB9212.prod.exchangelabs.com
 ([fe80::3513:ad6e:208c:5dbd%3]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 03:16:08 +0000
Message-ID: <b78b635b-a39c-4629-b7d8-a9d85c171819@amperemail.onmicrosoft.com>
Date: Thu, 12 Jun 2025 23:16:06 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 2/4] arm64: Handle BRBE booting requirements
To: "Rob Herring (Arm)" <robh@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250611-arm-brbe-v19-v23-0-e7775563036e@kernel.org>
 <20250611-arm-brbe-v19-v23-2-e7775563036e@kernel.org>
Content-Language: en-US
From: Adam Young <admiyo@amperemail.onmicrosoft.com>
In-Reply-To: <20250611-arm-brbe-v19-v23-2-e7775563036e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0044.namprd19.prod.outlook.com
 (2603:10b6:208:19b::21) To BN3PR01MB9212.prod.exchangelabs.com
 (2603:10b6:408:2cb::8)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PR01MB9212:EE_|SA1PR01MB8564:EE_
X-MS-Office365-Filtering-Correlation-Id: a0468c8e-4a7a-45d9-389c-08ddaa28a3e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|10070799003|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SW04aXlOTGEwRUxDN0YvcWlCZlpSdzJXS2xpODRtakJ6V3lQVmtYOFR6TFFR?=
 =?utf-8?B?ZjBLbktoUkg4aEtpRm0zQ1BlRlVaNDBkK1ZyejN6N0x1WG9lU0JYVTRXQ2Q4?=
 =?utf-8?B?ZG03cVFvZ0lvZy9ybmJib3MySFFiWGFmR29pT1FuRlpSNmJtMXc3MTFseUcx?=
 =?utf-8?B?WGpQMno2OVpXb1RmaU91ZTBPUzg5eER5QVRJOVpHVlo0alRLVmhxZWg4aHB1?=
 =?utf-8?B?cnpqQlhITjFCRzNxUGxPbXN0ai9SSGFEQ0t1eUtmUjBYT0JMWlRBZ2pyY1Iv?=
 =?utf-8?B?VlA1aHNVVTRpV2J5V3Bqb1pkYWhRaTVXbUY5aEFULzVEQW0zT3NZOS9uWmV4?=
 =?utf-8?B?NkVXZzRxUVFWRDNjSm5SM0wweXRCRWJkODhISmZnY0N0TTl0UzE3ek5raHY1?=
 =?utf-8?B?QjVEMW4xUXJNcXBRZU1aVi9ZTTV3SlJ0cENrMmNWbVhaVHZWUTMrQ1NXeXcx?=
 =?utf-8?B?YnBjbURubHFoM08vTFVsK2ZwVDJOOGdSUmlyMjFCaDMxZDVUNmpnNHdFZGpl?=
 =?utf-8?B?elpkR29CbWE1TFJPYU4rQU9XSUJ2WXp3YUJPdmkwbXQ5L0doMVZreWdtWG1Y?=
 =?utf-8?B?aFd3bEV1QWFkV0JFeGhmMU5nZUtHMk82WllZdnExUWg5S3BQNjFoakRXVWhx?=
 =?utf-8?B?R2lSNnhaZHkrUWI0cm1xN2pnbnB5UXpJZnBiS3Vrdi9XcjNxVDJaTndUWFVW?=
 =?utf-8?B?NlU1TGV0dEdWbWI2MzQzTWZFUmgvVEpPWEZ3bmY0VllEZVA3QjVjYWdtYVJu?=
 =?utf-8?B?SnRFMzh5WmpySVpna1ZzZmg0NTIwbVdyaWRFemt0ZEVPUnVCbjNJQ3pEZlVK?=
 =?utf-8?B?M1kvSzZuaHJ5YnZCSVdaZTdZS08wS1BwQnNsejdpbU50d3hTTXpRZENMUXJ6?=
 =?utf-8?B?MHllSVVkVVR4bkFFV2RiWUwrRTdyR2hOdlZZTlhzeGEwNWgxNUVtTFo4U0Zw?=
 =?utf-8?B?TXYyY0Vtd01QZFlkVTZMVlg4MEV2c3dDRFFnTnZGYUdSbWZEdXRzaGdpNXRP?=
 =?utf-8?B?dmFFd25Wa2F3Nk5XRy92Z3JyZHVCc0pMTC9UeThsZUJCZjlFdnZZQWwya1dM?=
 =?utf-8?B?KzliN2RKdUJNV1g4RE5UTjlpb3UwWDhxamZ1Zk02VnloWDd1cExsY0J6UGs4?=
 =?utf-8?B?aG5QRllrVDhVb002WTNqU2ZERjVWY2ZjcitsR3ZkTVBPNFNyMWtmcFh2SzZ6?=
 =?utf-8?B?VmtDV0xIWGFOYkpleXZ0RUpCZ2FqQW45WkpzQ29CUml4SmhSR3lOZ0VlWWZl?=
 =?utf-8?B?VkM3RFlJalphSndJSWtjZks0Q2o4R0dnZmlIU3hRM21GL3BvdmpFa2duOXR0?=
 =?utf-8?B?cWlSYnJuNk94OUgraXlsbmd5SEpSUm10NTBUdjBKVXNYbW1qZ1RtTXlpRU05?=
 =?utf-8?B?dTYrVC9pdzdQOVNpcEpWdjNjWWduZFRpRlc0eHg3UjF4Ny9SYU92R0VaV0xK?=
 =?utf-8?B?NG1lRDhVc0txcFMya2pLYnZXOVRhSjlGdU5jUnVDK01EOU5VTDN1WS9wWEN5?=
 =?utf-8?B?ck1lbDl4Q05SNDJuSHB2MWROVE5pUWNlSUN5NDNZZDRoM2hUM2pwWXQvTG5F?=
 =?utf-8?B?SURqS3FoNzczNjk2MHFRaFdLS0hkT1Q2dmMwU2oyQnRrUG1RcDR1VzVmcURE?=
 =?utf-8?B?UWdFVXRmUHVaVWlBNDE0SjhFZjh3dlpwQmtOOSsrTlg1V01VeFI1VzBMalJP?=
 =?utf-8?B?OWpEVU4xQnVCQVRmSGhybHNSYytQbzBxM1FXVW1iT1QxUjNPSUVmbVNpcmQv?=
 =?utf-8?B?anRsWXdmVDg5SVc5NXUrdGNFaUhQNHpkZXRzbWNmNVJEZ3BvRjR5K3Z3U2NM?=
 =?utf-8?B?cndIcTlhbmxHRDV6RU1ha3Q4K1p3dzJUeFVCY2g4T1BJTGhoRWFEVXpEdkFr?=
 =?utf-8?B?Y081bGpIcXd3cmEvT2xSMkExMHJZTHhaOVBTeW80VkVvcW5uRFFIWksxcUcw?=
 =?utf-8?B?b2lEcHY5UFJYRXpOSkI1T0hoWFZnS0dyb3I1eTh5dTJCQSs0clladzl5cmkz?=
 =?utf-8?B?bmJadDFnUTR3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN3PR01MB9212.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(10070799003)(921020)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmhIVWFKNTRCSzZTZFFaSVB5d1JpUHdVUlZ0U3Z2NlVSM0IzR1ZUb0R1LzRs?=
 =?utf-8?B?ZG10SVNCQkFDMmkzSWdNNmRxb0N1anQyNk1FeWFrRWFJeXdFcENySnFydWI2?=
 =?utf-8?B?UDdOTDd4N3ZLUWxSdC84WWpCakZXbGQ2UHNzVHpVTWdXNXBBQlorUmptLzRT?=
 =?utf-8?B?cWQ1RjRiYlJ6di9mdTNFdzV6NDFNbWxJdENTcFhuRzRRZFlPKzFVRHRFcnUv?=
 =?utf-8?B?Nm5FN0ZWUG5jWFJNZzNBakNDcC80dFkvTGZuck9jVEVqazdreFU2bnozRnMy?=
 =?utf-8?B?SWxlQ0FHUzQzbklEV2lYQklCeitxcWVOUFpoYmNwaVYzSHpCcFVBSWFEVEY4?=
 =?utf-8?B?RXY4aEwwcDlhOXRjYUhuZjEzK2l0MlRnQzIyd3NZSTFzYzNXQ3RXQytaZVNG?=
 =?utf-8?B?aDAreFQ2NGVWRExTUC9JM241MzZsNlE2T0VGY0ZJS0piM2lSRCt2QkFFNHFj?=
 =?utf-8?B?WlA4SGJ1YTNRQzBtcTZ0MVpCOTd0MlhBUS85NXBOL0hDL3UzeWZ5d1dmR0lK?=
 =?utf-8?B?ZnptS3MyMWJVUVNuNzVuL2tFVnpxMGt6NktWK0pKWVVjTkRZWUpxRkJOR1R4?=
 =?utf-8?B?VUFrTXEvN0hkTnBkamJCUjVBR0F5UTBQdzNUbUYyNngyU0FabmpxTndmY1cx?=
 =?utf-8?B?blRPRHJ3bkQyUFJYUGsrQXVkMkZ6VXBiM0VXVHdzY2lrc3JXN1VNMUl6aTJr?=
 =?utf-8?B?UDBPTzN5bWdsbndNVzFZd3NEcVFWUnR3ZVdpSHBjMlR6bHJSRURPK2c2WjZp?=
 =?utf-8?B?ZTNicTlrNmMxNkFTUk9rNFRYRUlQOTdjTlpwVUlYbGNkRzVHbm9CdTlSVGNw?=
 =?utf-8?B?a0pTMWJXVnY5VkFDWmJHdWdSVGQ5MmVUQ3E3SFhUNmFHbzJMZmNBVDlkNjNH?=
 =?utf-8?B?Qy9HQ2V2eldoSlkwUE9NUGRINWJ2YVh4ZGplcWxMN1lOZ0xmY2JVYjF3Snlt?=
 =?utf-8?B?ZGNGbFNEUkI5b0o5ajRUWGNZamFyUmpKTnQrZTA2N3hTMXFMaVN5RU81T3gx?=
 =?utf-8?B?YU1Kb1BQUkV0U2p4WmdWcWNkNi93NzZ6SGNzSjhHVkhwaUx0RDR5VHU0Ull6?=
 =?utf-8?B?QWpxTnpjVkFxNzdoK2ZaV0diVk5uOGhjRXIzSjBPR3Z0aWhZcXQvcTJWL0lG?=
 =?utf-8?B?cHB1WTZaRTFFZTZmNnY1MWswU2pqQW10eFZCRjRlS3F5Z2g4UEFramErR3hW?=
 =?utf-8?B?bHd2UGUrUFhjM3NqMDV3MGJMVWFoUVRYSEozY0o2aFp2SWJ0VVh0dlYwdFZp?=
 =?utf-8?B?YkJRQWJEZDk2NEVoSjgxVXpiYVpGVS9lQ3VSOWwyMU5rVGxxQ2JvUUpWWno5?=
 =?utf-8?B?dURhTENQQ016YUliZHdBbGl5Q2hYL3FpYk1LL3B1aEYrNHRUWGZlR0lneXl4?=
 =?utf-8?B?V2JjalczSU0rRU9MTmxSOG42dFVaME43aFVGMlN0eHNCMU45ajZQVU9ZZVBE?=
 =?utf-8?B?aExwdldONW03cDZPT282TFdycjhTcnZrSkpNVGg3Vmtjd1lBdS9nWlVYaFZR?=
 =?utf-8?B?cnBWeW1zZ0dLR2dlYlhNMHhqV2w0b0lQNjlNY0xGMEJNNUx6Zkg3a20ySDc2?=
 =?utf-8?B?cFVIWHJpd2ZKVlJzSENLVFhwYmxvZ0hPRTQrTmlyWFpHU09BRlR5d3JpN0tQ?=
 =?utf-8?B?QzRSMWNsNDc5L0Vaa1FkcVRFblhXd3l5NmVCMGwrZkxNRDlPb1hUL0NVUHV5?=
 =?utf-8?B?N0JRYlRBYmk3dUtuTXlpd2dPM2RhWlJFVlJWNlhtaWlDb2ZZYW1lUVRlem1i?=
 =?utf-8?B?bm9Sa0N3aW5nSzJlRnNnd1Y2M3lPQ0hzVGh5enJRS3BHdXdGVlJUaW5YWG5j?=
 =?utf-8?B?bXNtUVIyckVSM1E5aThsa0tveHJ3MWFXQmdVUlJaRDJCTkRPVVhhSGtzM00y?=
 =?utf-8?B?UXVyck1vMU1BeldMREpEYTZXVXBmdUFRVXpsWmU0QlpiKzlMWldvallVZTR6?=
 =?utf-8?B?WE52TEdKODd4eG9hSU1BUDR3QVE0S0YvUEd0TWo4UGFZR3pkZXlWdGJBcW50?=
 =?utf-8?B?ZkhrcWRDVE9TamtEN1UxRkJRd0h1bXJmT0Q5NWVGZm5VVml0UHNmenRoNjk1?=
 =?utf-8?B?MEtQczhpaFBWMEJYbjVMSjhiUGozTE5wYm9UV3lJZGtsM1VaTWRUWEExWUlZ?=
 =?utf-8?B?Qk1hck55UC9UWkI2S2ZxdW9vMTVQWVNUdmJBTnFkRFhaSVo5a1dxTk5Cc1NU?=
 =?utf-8?B?MUM0STE3eUJwZEZ0aXhOMFpsT3MxQVJxQmVVZFI3cW1wR1NvVFNONGhLYkNG?=
 =?utf-8?Q?wPU1TAD1zGkaKTbbkU0duWZpRXKWh7P7UIb1Uk+SXI=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0468c8e-4a7a-45d9-389c-08ddaa28a3e7
X-MS-Exchange-CrossTenant-AuthSource: BN3PR01MB9212.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 03:16:08.3186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Prf0nwYWncWIZoQodULp3l5IlB+ml7HifvESu0+0IR7f7/qABXycZUX22SmWqKBf7Ui5WeEg0/iHOpMPzqHAYsNENOA6Wj9PWuedXbF18Jv8XftOJy01IubIMgavwRBX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8564


On 6/11/25 14:01, Rob Herring (Arm) wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
>
> To use the Branch Record Buffer Extension (BRBE), some configuration is
> necessary at EL3 and EL2. This patch documents the requirements and adds
> the initial EL2 setup code, which largely consists of configuring the
> fine-grained traps and initializing a couple of BRBE control registers.
>
> Before this patch, __init_el2_fgt() would initialize HDFGRTR_EL2 and
> HDFGWTR_EL2 with the same value, relying on the read/write trap controls
> for a register occupying the same bit position in either register. The
> 'nBRBIDR' trap control only exists in bit 59 of HDFGRTR_EL2, while bit
> 59 of HDFGWTR_EL2 is RES0, and so this assumption no longer holds.
>
> To handle HDFGRTR_EL2 and HDFGWTR_EL2 having (slightly) different bit
> layouts, __init_el2_fgt() is changed to accumulate the HDFGRTR_EL2 and
> HDFGWTR_EL2 control bits separately. While making this change the
> open-coded value (1 << 62) is replaced with
> HDFG{R,W}TR_EL2_nPMSNEVFR_EL1_MASK.
>
> The BRBCR_EL1 and BRBCR_EL2 registers are unusual and require special
> initialisation: even though they are subject to E2H renaming, both have
> an effect regardless of HCR_EL2.TGE, even when running at EL2. So we
> must initialize BRBCR_EL2 in case we run in nVHE mode. This is handled
> in __init_el2_brbe() with a comment to explain the situation.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Leo Yan <leo.yan@arm.com>
> Tested-by: James Clark <james.clark@linaro.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> [Mark: rewrite commit message, fix typo in comment]
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Co-developed-by: "Rob Herring (Arm)" <robh@kernel.org>
> Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
> ---
> v22:
> - Reword booting.rst section name (s/feature/the/) and move next to
>    other PMU related features instead of in the middle of SME features.
> - Drop setting SYS_BRBCR_EL1
> - Drop CONFIG_ARM64_BRBE ifdef
> - Rework initialization of HFGITR_EL2
>
> v20:
>   - Document that MDCR_EL3.SBRBE can be 0b01 also
>   - Fix "HDFGWTR_EL2 is RES0" in commit msg
> ---
>   Documentation/arch/arm64/booting.rst | 21 +++++++++++
>   arch/arm64/include/asm/el2_setup.h   | 71 ++++++++++++++++++++++++++++++++++--
>   2 files changed, 89 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index dee7b6de864f..fbdc4b071755 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -388,6 +388,27 @@ Before jumping into the kernel, the following conditions must be met:
>   
>       - SMCR_EL2.EZT0 (bit 30) must be initialised to 0b1.
>   
> +  For CPUs with the Branch Record Buffer Extension (FEAT_BRBE):
> +
> +  - If EL3 is present:
> +
> +    - MDCR_EL3.SBRBE (bits 33:32) must be initialised to 0b01 or 0b11.
> +
> +  - If the kernel is entered at EL1 and EL2 is present:
> +
> +    - BRBCR_EL2.CC (bit 3) must be initialised to 0b1.
> +    - BRBCR_EL2.MPRED (bit 4) must be initialised to 0b1.
> +
> +    - HDFGRTR_EL2.nBRBDATA (bit 61) must be initialised to 0b1.
> +    - HDFGRTR_EL2.nBRBCTL  (bit 60) must be initialised to 0b1.
> +    - HDFGRTR_EL2.nBRBIDR  (bit 59) must be initialised to 0b1.
> +
> +    - HDFGWTR_EL2.nBRBDATA (bit 61) must be initialised to 0b1.
> +    - HDFGWTR_EL2.nBRBCTL  (bit 60) must be initialised to 0b1.
> +
> +    - HFGITR_EL2.nBRBIALL (bit 56) must be initialised to 0b1.
> +    - HFGITR_EL2.nBRBINJ  (bit 55) must be initialised to 0b1.
> +
>     For CPUs with the Performance Monitors Extension (FEAT_PMUv3p9):
>   
>    - If EL3 is present:
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index ba5df0df02a4..de8a57f728c5 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -189,6 +189,28 @@
>   .Lskip_set_cptr_\@:
>   .endm
>   
> +/*
> + * Configure BRBE to permit recording cycle counts and branch mispredicts.
> + *
> + * At any EL, to record cycle counts BRBE requires that both BRBCR_EL2.CC=1 and
> + * BRBCR_EL1.CC=1.
> + *
> + * At any EL, to record branch mispredicts BRBE requires that both
> + * BRBCR_EL2.MPRED=1 and BRBCR_EL1.MPRED=1.
> + *
> + * Set {CC,MPRED} in BRBCR_EL2 in case nVHE mode is used and we are
> + * executing in EL1.
> + */
> +.macro __init_el2_brbe
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
> +	cbz	x1, .Lskip_brbe_\@
> +
> +	mov_q	x0, BRBCR_ELx_CC | BRBCR_ELx_MPRED
> +	msr_s	SYS_BRBCR_EL2, x0
> +.Lskip_brbe_\@:
> +.endm
> +
>   /* Disable any fine grained traps */
>   .macro __init_el2_fgt
>   	mrs	x1, id_aa64mmfr0_el1
> @@ -196,20 +218,62 @@
>   	cbz	x1, .Lskip_fgt_\@
>   
>   	mov	x0, xzr
> +	mov	x2, xzr
>   	mrs	x1, id_aa64dfr0_el1
>   	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
>   	cmp	x1, #3
>   	b.lt	.Lskip_spe_fgt_\@
>   	/* Disable PMSNEVFR_EL1 read and write traps */
> -	orr	x0, x0, #(1 << 62)
> +	orr	x0, x0, #HDFGRTR_EL2_nPMSNEVFR_EL1_MASK
> +	orr	x2, x2, #HDFGWTR_EL2_nPMSNEVFR_EL1_MASK
>   
>   .Lskip_spe_fgt_\@:
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
> +	cbz	x1, .Lskip_brbe_fgt_\@
> +
> +	/*
> +	 * Disable read traps for the following registers
> +	 *
> +	 * [BRBSRC|BRBTGT|RBINF]_EL1
> +	 * [BRBSRCINJ|BRBTGTINJ|BRBINFINJ|BRBTS]_EL1
> +	 */
> +	orr	x0, x0, #HDFGRTR_EL2_nBRBDATA_MASK
> +
> +	/*
> +	 * Disable write traps for the following registers
> +	 *
> +	 * [BRBSRCINJ|BRBTGTINJ|BRBINFINJ|BRBTS]_EL1
> +	 */
> +	orr	x2, x2, #HDFGWTR_EL2_nBRBDATA_MASK
> +
> +	/* Disable read and write traps for [BRBCR|BRBFCR]_EL1 */
> +	orr	x0, x0, #HDFGRTR_EL2_nBRBCTL_MASK
> +	orr	x2, x2, #HDFGWTR_EL2_nBRBCTL_MASK
> +
> +	/* Disable read traps for BRBIDR_EL1 */
> +	orr	x0, x0, #HDFGRTR_EL2_nBRBIDR_MASK
> +
> +.Lskip_brbe_fgt_\@:
>   
>   .Lset_debug_fgt_\@:
>   	msr_s	SYS_HDFGRTR_EL2, x0
> -	msr_s	SYS_HDFGWTR_EL2, x0
> +	msr_s	SYS_HDFGWTR_EL2, x2
>   
>   	mov	x0, xzr
> +	mov	x2, xzr
> +
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
> +	cbz	x1, .Lskip_brbe_insn_fgt_\@
> +
> +	/* Disable traps for BRBIALL instruction */
> +	orr	x2, x2, #HFGITR_EL2_nBRBIALL_MASK
> +
> +	/* Disable traps for BRBINJ instruction */
> +	orr	x2, x2, #HFGITR_EL2_nBRBINJ_MASK
> +
> +.Lskip_brbe_insn_fgt_\@:
>   	mrs	x1, id_aa64pfr1_el1
>   	ubfx	x1, x1, #ID_AA64PFR1_EL1_SME_SHIFT, #4
>   	cbz	x1, .Lskip_sme_fgt_\@
> @@ -250,7 +314,7 @@
>   .Lset_fgt_\@:
>   	msr_s	SYS_HFGRTR_EL2, x0
>   	msr_s	SYS_HFGWTR_EL2, x0
> -	msr_s	SYS_HFGITR_EL2, xzr
> +	msr_s	SYS_HFGITR_EL2, x2
>   
>   	mrs	x1, id_aa64pfr0_el1		// AMU traps UNDEF without AMU
>   	ubfx	x1, x1, #ID_AA64PFR0_EL1_AMU_SHIFT, #4
> @@ -311,6 +375,7 @@
>   	__init_el2_hcrx
>   	__init_el2_timers
>   	__init_el2_debug
> +	__init_el2_brbe
>   	__init_el2_lor
>   	__init_el2_stage2
>   	__init_el2_gicv3
>
tested-by: Adam Young<admiyo@os.amperecomputing.com>


Built and run on a BRBE capable machine.
Built userland perf tool can run

perf record --branch-filter any,save_type,u true

as well as

perf record --branch-filter any,save_type,u ./sort

And will generate a perf.data file.
The mechanism applies cleanly and produced what looks like sane output.

Using autofdo to convert to a gcov format created a file that could be 
included in a gcc build as profiling data.



