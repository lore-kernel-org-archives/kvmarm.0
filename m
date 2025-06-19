Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9BF15A856
	for <kvmarm@lists.linux.dev>; Thu, 19 Jun 2025 14:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750342598; cv=fail; b=cV7Zlr4qrdo31CxwQe7kfDP1lATyxQXnRvCdK+VoRxBqz3hwtDkNe1zXtW7JOpwgkH1X3/hUqlvwhw7URS8iv2HDyK2PkAwawYKtc3ActgyhJz2ZyYnlTf2wVYkQrthjpT5P1+W+Scgj2hJtMW/zsKlpfO+aQbNPLdgmNQTwhIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750342598; c=relaxed/simple;
	bh=928bX/Ox0H11CAkPkXrYgttwUgcYT8WAjfDzvZ209nE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j2MGbJ0nTXzt/VAB2OOfviH4bw7PSOQheS+k7HFjs681PkFjBPma89x5k8t35TEveKepxzxDCBbUq2z9lYM9s5HIETRtokh2hto7h7cNDuCj6Jckh9hSpqIH55boZw/yGT5vwH4T8o3PelsxZ4HpPaktsOmI3H67gBALSY2bREQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fReZ+zXR; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fReZ+zXR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PoH+QhxRMpF5Nsj1vDEDixRl/Pmr54ZsOnHvIkHrsj89jWXlbvI+UvXPmJohE2onI5UyHJ0PiZikILloZFO3SpEe5bJjcHzY6RG2olsBbinifoMzc2ftxk8aJRQYvHxtiOKdAN4hWs10VNGEXdFvQj/SaTIiUFLHMUbknu+x6Ow9lb8tn4jDXpPFcijp8eNHC3szIJGhmXESz0jx3u22He1vi6lQ44VtqScIMvX/4gB3tSBBsiCFJ2wWXCFP1fvFUXqcsQmX+5YmdcLC0pqjQFH9UovB6jo9CLrlddWqC8t3nDHqlJJHUQh6o3gkLML6VcDs1ZUpasNPlLKB51/0Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GP8ITf76pzLUyJ6VYOmu7AkHnGjW9CsLRLYSLcXv3pA=;
 b=nYZUeOHLL5+Vr7mJtsiiIdcg8PjSfP7FUjffv0dNS7bO65VqrSYq340W+zGcPb8DgrrzDuMm/ZU4iuRFbHGiSisxD/9EsrDuQnJs3gmJ8db6EMrd2B6RAy39S4CaU4RuVo44oGHsFqeVjhIVdgePvzLSsYeuuvGecBINr8fi7tAujwSMc5DoiuTEF0X/anZryW+bHJo11UDufLBddGZqdENWu2OANEgHxgQi0AbeRhYw9PV7rAqf65Q9xht+q4q3w8fEHe4vwqPvJuVQWNGCFrcge1A2209R8a493sAE4cgjteDIqWfAg8E145sWYsgRGr/QCKmFW/Hbgw0YYpGtEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GP8ITf76pzLUyJ6VYOmu7AkHnGjW9CsLRLYSLcXv3pA=;
 b=fReZ+zXRO1WbIYlD6s1sOcOP5oTN4Y9p3iXEhM2uV9UEBkRfwbPDoOuvXKjCxc9ss4NTUJJ7r+wtv1I8CgFWUqbafnUnm15Y6w9IqOh5ia5OA2aCBx7qhT/ukT8VoVYVTn7M6hqqmz9Fh2pPaUqU0DaoFE0EIWeJstZzhiOhEt6RoogEz7Fzyo8OmrqZQhlOTIWTWThRyCpzvoHQz8KQ9lzQG0R6sPzIZt/JUxfXBlDWFnRvblgHVOAdG7Gwk/Kbe+LDrKaFZlvYdv3OM8SgTRIFjYez16R0EOKrq4rqAro4sdQfQM8dzcWzLEAKCxZeKNGrqh2iZ/IE+S40gUWUCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV3PR12MB9144.namprd12.prod.outlook.com (2603:10b6:408:19d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Thu, 19 Jun
 2025 14:16:33 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 14:16:33 +0000
Date: Thu, 19 Jun 2025 11:16:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>
Subject: Re: [PATCH v7 4/5] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250619141631.GD1643312@nvidia.com>
References: <20250618065541.50049-1-ankita@nvidia.com>
 <20250618065541.50049-5-ankita@nvidia.com>
 <aFLqiAyXZLoOTepi@arm.com>
 <20250618163836.GA1629589@nvidia.com>
 <SA1PR12MB7199835E63E1EF48C7C7638DB07DA@SA1PR12MB7199.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA1PR12MB7199835E63E1EF48C7C7638DB07DA@SA1PR12MB7199.namprd12.prod.outlook.com>
X-ClientProxiedBy: YT3PR01CA0141.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV3PR12MB9144:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cca3f8e-ea0b-4339-736a-08ddaf3be44f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDN3N0FKRWV5YWpBYUZmVTc1NWdRNzRoYy9FdVBNSmlXRDl5UVJJTFJ0Q0Jq?=
 =?utf-8?B?M290RnNTemh0Qy9HbTllL0RkSWc5RDZCQzNuOEVvNm1ZcjJpZW1DUzRHakRM?=
 =?utf-8?B?TmVOL2ptNVEzTWtMbkRJUHpLdGlSaXpZRVBOM0NRV05mVHFxZThBNytIakxD?=
 =?utf-8?B?UmFZVjJ6S1ppMVkrQUVyRVZiaGd4eUs5K3pCTlJLT1BUTWxsbTRiZ1RtblZz?=
 =?utf-8?B?b0tHMXlOWTJJdnJobmtkdWFDTTRYeWNrY1F1ckpHZzNFY3hQWWZJektKMnJp?=
 =?utf-8?B?dGZ4NkFFSTQ3S3YzaE1yUmsybllnUU96MVdTNExqb2dPZnNyMkNjcXZuL0wx?=
 =?utf-8?B?YWlsVnNhZ01PcFFZRHQxdGVKRVFNeXVBSVBtVlFVbVV1UEZlNEwvZVVqVGVP?=
 =?utf-8?B?SFIraldXOXZqRmVmQ2s0NWdGV1YyRjNiL3ZWMWpZN3hjZWtRYmZodjVPcHdH?=
 =?utf-8?B?YldnWDlRWk1EMitrSGVzZzYyUlV4NmUrMWcreGRXRnJSck1vSk1qVEYxZTNu?=
 =?utf-8?B?Q3BxbEFHR2pXN09kanZ4bHlvOXNpOFo4bm95ZkROemRHdzlRZDBUYmtGOEJs?=
 =?utf-8?B?T0s5Ty9kNXkvYXhqSG9kc2I0TEJRWDFmOU9meHlBbk9GZVZ3SUJqeFRFbm8x?=
 =?utf-8?B?ZGU2U1BYcEhNblBISm5qeUJZRHZoeXlFVm5TYVN3azlqNnNnWk1wYkFoVkQx?=
 =?utf-8?B?SnJ2SnFjK3hwcWlScEl5Z1NxanFiQitPL3l5NXBOV0d5b2p0ZS9YRG03ODZC?=
 =?utf-8?B?dTFLT2dIZkVQM2NQc2RVaTAwdVVBeHE0SDVnZlZ0MU5JLzMwTFVMbTBiWW5q?=
 =?utf-8?B?Y1VOUVNiZnl1NlJWa1NwUVhoY0I4YzdaV3pJK3A3eHp4U2tjZWZjSVFIaGVI?=
 =?utf-8?B?bWVuamppclk0SkJEeEEwcjE2dWZ1R3NFRE9XRnNWTE1zYWpPNlVZSXVyZ2xO?=
 =?utf-8?B?cjZHSDZvTENrZ2xKcS85OXZrZzhDSzVsNWhuTnlRL3R1UDVhak9hUDVYTlZ0?=
 =?utf-8?B?VXJlOEwwM3hGTC9IVGxXRWZsNUY0YUpPVEZTdzRhdXJmNE11bHlQV3lRbytj?=
 =?utf-8?B?U0UxUHAyb2Eya1kyMktETkFZMTF2anRsRXNEdGhVdVo5U3h4N0p4djFWc1pU?=
 =?utf-8?B?bXF0akZnT0tQR29mK2JySEp5amJCT1RtM0dNYjMrbUlzRjdqZC9lQ3VmaDBq?=
 =?utf-8?B?b09CME5EbFUzKzREcTFiZkRwVHkxeUJ6VXlMeWIxNUU2YWJqR3dwOEdycndz?=
 =?utf-8?B?eVRDYTVpS2gySG04TElHWFdwWWpWNFgvcDFZUHozTTJtT3hvUnQ5T2ZjeWVZ?=
 =?utf-8?B?M2NpMXVrY3BWOW1lYnY0NnZJM0o4c0tyWTlkeFJlOVRaV3FpdjJnU2RHK2RF?=
 =?utf-8?B?YjhqYS9ubFA4dXhra0dWYmxnVUJCNmk5SHpaTEJ3OVArK0w5YUw3NE5FbHRH?=
 =?utf-8?B?THF1Q28wNWRsVkhZblZsOXhZQVM4dXFtOXcxMXZMTUx3SWQ1UXpKbkVXTjc3?=
 =?utf-8?B?cXBQRFlOdmF1RmoxdHF3MGphVnA5RVJxTWJaaXRINjlRbUJaek1CVVVNdnFw?=
 =?utf-8?B?dVJFMXVqV0FwSVRyK3dkSm1Uc3c3Z3NYcTJxTzdFQjloS2dRcHN0eXlEVVJn?=
 =?utf-8?B?TTVOUDV4SUROUWpKNXRMcElMSUhxbnp5SURpZnh1SUVPZkE3YTFleWRwSGZw?=
 =?utf-8?B?Y2Q4SDhJSktKKzF3SVR5NHRkT2JGU3lMK1VoVXE2QldRdkhqemR5M1FaYVZ4?=
 =?utf-8?B?cjNrZDIrT1VWUXhNanJJUWtsOUdlU0lLbW1FVyt4TzhRVmlLdjMrQ2V2UGdX?=
 =?utf-8?B?ZWFVWW53b3RxSFNxWTJPa2RVVmFNSk4zTHFzbUZ6YnYvbjJlQjFESkI4cE1k?=
 =?utf-8?B?RXI1N01NTU4xVUc5ZDBlRDFzdHJGQ0tDL3hmb2RKV2M2T1hiNXdrdEJEVmRp?=
 =?utf-8?Q?UBBMJShz1bg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXNpSnJFM3gyQlpEL2Y5enVDa3Y5cUg2bXEydmdkV3FJQjhROExyZ29yMGxX?=
 =?utf-8?B?dVR4Rm54Z2ZHbDBkWEJYcHkxRlA3OHhLMzljRS9SRDhremJqUDlDV3FJSzhS?=
 =?utf-8?B?VEtaUTlML2RRalVDY2d5R0dUNFFFdXdxcllVWHlPcGczTC9TajVuc3Y4UFFj?=
 =?utf-8?B?SUwxYnV0SENxckRLM3AzYlA5Nzk0elVpWGFLQ2psanpZUjNIVWxpa2h1clli?=
 =?utf-8?B?ajBjOHo5K0NyV3VQZlNTc2xXbnJJVUV1VG1hOGovZmhOSHlIMlZFNCtORVBP?=
 =?utf-8?B?MXBESGlYTFZheGV3b3J1MmxHLy83ako0d2kxRzRkb0lzOFFZQmwvMG1XL1VU?=
 =?utf-8?B?cnkyZkFCcTVLSUVlMEt0NWZjaVd2SElOVTVtRm5oZ3poMmVEV3Q2VmZWd2xy?=
 =?utf-8?B?T1lGbXlTYWVNTEJkS3F1RFFCbk5KdFlsNkt4TTJINVNvNnMzd0I3aEt1Qmds?=
 =?utf-8?B?MEZsaGxNRmZUaXRwazM1ai9acEZIejY4RlJyMDZiQ3NHcTJubkhIbXZWVXMw?=
 =?utf-8?B?NHhaaFVBZlBtNHdZMnJReGtGN0tObFBrbFhKd1pWclAwUzlXaXo4MkdDTGlP?=
 =?utf-8?B?TzVNT3NKOWgyeDVlelN2NTJjRkhpWkZHb0I4ZEFZUXRuMUJJcHhmcHFnU0ds?=
 =?utf-8?B?dlRFNUllazAwS2JiUUNVN1ZWTnZDTUU3RlZFTFRkUEwzaEozZ2M0VWhWVERI?=
 =?utf-8?B?T29ZSkVZWnhVeUw4Y2ovNVovekVUVytWOEw2QjZxUkhJUVJtK3poTDMwMHgr?=
 =?utf-8?B?T2Q5UHVEOEx3a2xrR01sdHdCUGhYLzJLVWdsTDdLbktXU1N3NldzcXlLenlY?=
 =?utf-8?B?LyttZTliZjdWclU1YmdoZlpWYSswRDlncFF4YnZEQjZ2T096U1RxL3NJSmZQ?=
 =?utf-8?B?OC8rNTQ5Ui8rSjZrQ056cXJadzlvWktyblRYL2RMbnVENHdMaExMdjhseUpz?=
 =?utf-8?B?YTlkYW01MzdidDAzUzJsaTkybGpTdTBveDRiMThhbEVTdEFwdEFPVUVLeCtY?=
 =?utf-8?B?T0Q1cTJXdXAzRkpsOHdqN21sejRTVFFWcEU0UTNpWUlvRitkYXcxZXJnckVy?=
 =?utf-8?B?NDZlRTg0Z2pvckxlZzRSZU5JdGVJMER1a3dMdmR0Z0h2dDgwNytXZUNHUlgv?=
 =?utf-8?B?UUxMcmtQSkVMUWFXRDd1NWZWZ0VqaVFPNDVxTzJQZkVWWVJNYUEwSlFTV041?=
 =?utf-8?B?UnFuSTBEOUJVM1EyZ0p5eEdFS3l1T1VGcjRkTTg2UUZMT3RkZFVrSDZuYitz?=
 =?utf-8?B?dWxjcU1DNlh1Q2FyejR2dVQvNi9tZW1mTUFIV1lEL21JbS92REVETTF0QU54?=
 =?utf-8?B?VVJjUHNjY2xqWWdRYVdob0FXaTVHT0FNNHNMSU1JOGsvUitXcGhvTG9zMFU1?=
 =?utf-8?B?OE51Rlcvb3dReFh2VXVtcXNPUDJYdGlCaHI4bGhpVHQ0UGFVUEZML3l4K1M0?=
 =?utf-8?B?bXhKanFLNlVveG9lckNmS3pkanAzK0NYUW9WNWhtLzZxakpNTnNIN2tVMVRK?=
 =?utf-8?B?TUVWSGR0blJjRzVOKy9PQ2V5S3Jld1VHMmZWU3MxNnk1MTlYOURLTkhWVmN1?=
 =?utf-8?B?Zk5vQ3VLY3FpK3Urc3E2Q0lVdmo1TndFV2RPUVFvdjN3SHJWYXphTEFTSnN4?=
 =?utf-8?B?NGVWeTYwK1FzZEIvQ0IzcFFmVkhUK0tjcGxrclYrb2FIRCsxVld4N1M4N3V6?=
 =?utf-8?B?OE9MaEZJc1psTzcvSkYyODZGUVVIZGhFOFNnQ2Z2WTFTMUg2b3RmV2JUSTVo?=
 =?utf-8?B?M3E5VG4vbVEzaytMUWtXdkVPSW5EeDhPRzdUT3Q0K0FXQy9ib1FDREdCUUNN?=
 =?utf-8?B?Q3J5M1BPVWN6QWU0VmVydGd4elp5bDZSdC9TbTlBaDMvbUZzUlZXajV1bjZC?=
 =?utf-8?B?akZ2REN6ejRTR0NydnphTW1QaXBidFpTNzZpYmszV1Y5VUdhR3VzRFdsYkJ0?=
 =?utf-8?B?NzJ3cFE4cnVJTzd0K3lZNTN1Y1J4SXRxMVVhaFIwQi93SzZDREl1WEhaTHM3?=
 =?utf-8?B?aVcrNnBKR01zZkRJWEcwRklYNHpMeXZNbkRzaUh1cUx0MkRMRlBWcXM3bTlZ?=
 =?utf-8?B?NWdTaWw5MkN2TFVZN0tIbUZzaUg1VDdzMVlxVHFkRjVGSmRmRHlsNFc3TjFF?=
 =?utf-8?Q?6ISCeBQFTUwI3RFJcI44XjPn8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cca3f8e-ea0b-4339-736a-08ddaf3be44f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 14:16:32.8666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3Cu7RiVqVyTlLijedD2pTqAs5Zy5LnZ0Wckdr0a0XL9qzqDPKMCI8/90ESlBDtW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

On Thu, Jun 19, 2025 at 12:14:38PM +0000, Ankit Agrawal wrote:
> >> > -           disable_cmo = true;
> >> > +           if (!is_vma_cacheable)
> >> > +                   disable_cmo = true;
> >>
> >> I'm tempted to stick to the 'device' variable name. Or something like
> >> s2_noncacheable. As I commented, it's not just about disabling CMOs.
> >
> > I think it would be clearer to have two concepts/variable then because
> > the cases where it is really about preventing cachable access to
> > prevent aborts are not linked to the logic that checks pfn valid. We
> > have to detect those cases separately (through the VMA flags was it?).
> >
> > Having these two things together is IMHO confusing..
> >
> > Jason
> 
> Thanks Catalin and Jason for the comments.
> 
> Considering the feedback, I think we may do the following here:
> 1. Rename the device variable to S2_noncacheable to represent if the S2
>     is going to be marked non cacheable. Otherwise S2 will be mapped
>     NORMAL.

How about "s2_force_noncachable" for extra clarity what is going on.

> 2. Detect what PFN has to be marked S2_noncacheable. If a PFN is not in the
>     kernel map, mark as S2 except for PFNMAP + VMA cacheable.
> 3. Prohibit cacheable PFNMAP if hardware doesn't support FWB and CACHE DIC.
> 4. Prohibit S2 non cached mapping for cacheable VMA for all cases, whether
>     pre-FWB hardware or not.

Logic sounds right
 
> This would be how the patch would look.
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 339194441a25..979668d475bd 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1516,8 +1516,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  {
>         int ret = 0;
>         bool write_fault, writable, force_pte = false;
> -       bool exec_fault, mte_allowed, is_vma_cacheable;
> -       bool device = false, vfio_allow_any_uc = false;
> +       bool exec_fault, mte_allowed, is_vma_cacheable, cacheable_pfnmap = false;
> +       bool s2_noncacheable = false, vfio_allow_any_uc = false;
>         unsigned long mmu_seq;
>         phys_addr_t ipa = fault_ipa;
>         struct kvm *kvm = vcpu->kvm;
> @@ -1660,6 +1660,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> 
>         is_vma_cacheable = kvm_vma_is_cacheable(vma);
> 
> +       if (vma->vm_flags & VM_PFNMAP) {
> +               /* Reject COW VM_PFNMAP */
> +               if (is_cow_mapping(vma->vm_flags))
> +                       return -EINVAL;

The comment should explain why we have to reject COW PFNMAP, it is
obvious that is what the code does.

> +
> +               if (is_vma_cacheable)
> +                       cacheable_pfnmap = true;
> +       }
> +
>         /* Don't use the VMA after the unlock -- it may have vanished */
>         vma = NULL;
> 
> @@ -1684,8 +1693,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 return -EFAULT;
> 
>         if (kvm_is_device_pfn(pfn)) {

We are changing this to !pfn_is_map_memory() ?

We should really only call pfn_is_map_memory() if VM_PFNMAP or
VM_MIXEDMAP, otherwise the VMA has only struct pages in it.

Can it look more like this?

if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory()) {
   /* the memory is non-struct page memory, it cannot be cache flushed
       and may be unsafe to be accessed as cachable */

       if (cachable_pfnmap) {
           /* the VMA owner has said the physical address is safe for cachable
              access. When FWB ..... */
	   if (!kvm_arch_supports_cacheable_pfnmap())
	       return -EFAULT;
	   /* Cannot degrade cachable to non cachable */
	   if (s2_force_noncachable)
	   	   return -EINVAL;
       } else {
           /* Assume the address is unsafe for cachable access */
	   s2_force_noncachable = true;
      }
}
/* nothing beyond here writes to s2_forcE_noncachable? */

Jason
