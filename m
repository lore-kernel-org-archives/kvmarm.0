Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795646218;
	b=D6jW87PY0XzB+bkuv9Z/8iV8434gfv9aJXnUieDy/vVh7qkhjWCuSL3x+dd4rH6bZ9LC
	 A9pap0BkLevb+grga5224Wgi1U+CTafuCbjAQkHN+XrFIpQRriHksxfUH31fOJPpaCZBX
	 eKCaDUQCDA/wS/F3iSKhWQw1bQAurZXEyc8OtblzXn0PXsilPBCdOt62JZlWYjC23yrtR
	 UmeW3uRgKsQ9l5tW1JYkQHb9ZkXGFaPaZDqHrm8EABcpGA6DCS9rqy83EvCK4W8IN5YAe
	 zmA5DdgTXyiHwiGvjPuVp22D+ukp0GQXeRTLaOb0KUQM9Bl96E0ueR6nJLrj+zJQrig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795646218;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=5lG6hjWpaomtDK0cBZVisErvnCecq5m9FWgBUcR09l8=;
	b=ek+wyuB6TuNfnBc5Z1bt8OyGGl064g3YT3XmbGxytB16OTKgX1cqM3xnQOVW34cBuPBJ
	 Qp4SeEU0LbdQQeRuzgSvpjw84vneHvkmxPXlEeF2PY/oSgL1CgzkvNb4kkdAsOh0R2ZW8
	 m2eKEm4sHqLS9x7meka2aPo2Uy4wTezRE+dX2N0gn/jr97fVo6aWxMlFm3G51iEvYVBER
	 DKDNsn0srvuDQ3dP6UpPtYVhJuSpnWwDGr7eiWQgxFMdOO57BulyTmEaEUUxPszEenICa
	 /NMQzPuru3UxJwvFNDofi0llpE6ioIsz6baQcBRdzhA+Vxo4Rf7YRQgjkpJn+H0IgGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WjEd3r5k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.8
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013008.outbound.protection.outlook.com [40.107.201.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5F2606A321
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 22:36:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C5F2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WjEd3r5k
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yTn9iaAPyUCMNS+F6SfANNaB4vyln5Y0TRF347I0TB6neWHb+LAofFchWk9BdT8p8ZQ6S/1kRmCAh4wiejgcrdyTwJhoRnbsYud2kYew4ihgHrbIySdf1vV2XSbHT2AP9U+UAzwfGxXaRsS0ETlq0iApxGY4TRHMb9o2jWw2SLUO6+m7GGjoa9ZzGikUZmObxiDixNz52O10IMD/KN+z9vngfBWeoKbn1qp5RBqtMv3bXSKnXHSXXI1l+Yr+Tb+YgOCFSMRYcizNYPKNj+AbVtL6APz0b3x2vFJp0/YY8sGSx77utjOwJWMd1Xz/nqJV2i/PX4C9DEdwg44l6LRqJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lG6hjWpaomtDK0cBZVisErvnCecq5m9FWgBUcR09l8=;
 b=PFY1Vs2t8zxa8QHN9i1aTUXeC3ZOEZoh4kKJtUO1mrUtXcbAUJ/pkVl758SjephE0XRrTWbvy8Hyqo7zC3CYm79mQP5Z2qDgAR1IUZqa9EdBODJCNzKGYw0W+9U4sn43va6hFjjiEM6mbcRhX77xNzU8W3UEPzq5iC4ph/g5pGRzNJEwPaH8mylenUd+N1R1uPOiNC6LSU/qMz5eSEfJLpjVk0Ps2497mc8ipM0p3txoEGlUfA20RmtUk+c/3mi3L93TiiaJRMmVgmTT2VRC7x3lKV8TkN3T8Z7WxMtxt2KQ25fTHti0cBZUb12cawKjJUeKAiFuvAgREYjpr1BY4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lG6hjWpaomtDK0cBZVisErvnCecq5m9FWgBUcR09l8=;
 b=WjEd3r5k2GGUAmGinfIy7sEck7FBO/+Z7gDGFFS6Z9VPL4+3HBl6KY0sdJ8cVhJKLi5y35B1Jd7sePEsiSSL5acl+H9dbH8xVsK9E4AzFY6y5fZbcFEwvuHbiFm1cSmRpl9mgEgM2+0VYVubIlWP7zTqD/+Cnzau3cagX/DGUr4IysgYZgBrdJR6BPdsUCABbTOhoYrd3lDTcF2Z8Jh1e6T8M51PKXvv5582538RqArTR/BRUvjyYDPM8hAThTOOBYYYLOEmtkyA6NRkEQ4HUiXvb8bVbcFy8YNyuoGS3XI5Kd8aBwwaMlNn0E9AlyVrgAkzNkzghAJ98zhXW7O6Nw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:389::15)
 by DS0PR12MB7629.namprd12.prod.outlook.com (2603:10b6:8:13e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 22:36:52 +0000
Received: from DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720]) by DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720%3]) with mapi id 15.21.0662.001; Wed, 25 Nov 2026
 22:36:52 +0000
Message-ID: <6bed8c59-476b-442d-a8a5-158fa0d9d978@nvidia.com>
Date: Wed, 25 Nov 2026 14:36:49 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] KVM: arm64: nv: Grow the shadow S2 MMU pool on
 demand
To: Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Joey Gouly <joey.gouly@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>,
 Marc Zyngier <maz@kernel.org>, Tom Matthias <tmatthias@nvidia.com>,
 Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Julian Miller <julianmiller@nvidia.com>
References: <20261124211218.2751086-1-nathanc@nvidia.com>
 <awYPtXVeY1NYeTla@kernel.org>
Content-Language: en-US
From: Nathan Chen <nathanc@nvidia.com>
In-Reply-To: <awYPtXVeY1NYeTla@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::8) To DM4PR12MB5390.namprd12.prod.outlook.com
 (2603:10b6:5:389::15)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5390:EE_|DS0PR12MB7629:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ef06fd8-49a5-4840-0245-08df4b4499c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|22082099003|56012099006|4143699003|5023799004|11063799006|261102123227099003|10067099003|261026140227099003|261022105027099003|261022075727099003|261026121527099003|261021121427099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	BZgaWtuuACH3QWU2uBnyY1QSUpYJdp8XgGrxrAFCjPe3WkSmsk73jmJcEhLV19QZcwNgcjZC9v9SOCkXtUvYYdILm+2rSp/N/Ovz2f1jy32h38EACPui2GrHYX77OdLzDlwqeGAY+O+PQie4YqE/9MZK+SkTRlL8ykwyX/MQd8XSbcqA7UD3VhU1bgQjszVClr/PbzaIF/QmGb3Vid/7Mh4u2R3bSGT6ZhfIx2IQ8hr25iBGvSdXqMIzFahTPM1kFFIqt8AB8ZhpVALzk3uCesTHP8UuQV5v9fTOWkEpXT4fuSkKf1pZbHPIJS9+QZLSQ+8gRtcZCvCCe6GgBA924QhfPA9rQ8tnhrasLziYO+P8AAI+4gXaY0uqHi/Ji33u6DPq3GOoL0MoGo5mqeETDJSutEAg0e+0zLXlG5BM0RHqTPqs1sWQy3F6aSDbWKNyq7GzKs075iuNKPnyeQtyAXqTYNquS0Qc0ElsmsRHL7p3gOE9Wn+Bu8zFLpIOM38iZOLoZXzskPTAB65Qs6+8Cgl/GFM0QpizMmjq5grg6DzBvyDgQ4jHH39dehnYcG5el1SxN4TDTkme5V6LUb4eT5Po5chkoH3rd7ZFTrxjMMAGPQ3gt6AQWyaNQiZWta7qTh5GEQqXzqdTKftTa8fTo4AqSUuQ/0nLCpCI02XDTyY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(4143699003)(5023799004)(11063799006)(261102123227099003)(10067099003)(261026140227099003)(261022105027099003)(261022075727099003)(261026121527099003)(261021121427099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnZtaENEckpRZkJSNit2bVBqYTRjYjZsY2ZnazBaNG5XaUphTTFwUFdxNDJW?=
 =?utf-8?B?WERLRFY2OHZFNXdkYnI5eldSTndjTmFscjdrSU1LdUFQa05rekhJL3hKK3Zn?=
 =?utf-8?B?cHgzUThkQjJKUE10bjNHcGVabFFvUk0zcktDaXArQTlacjVpN0piTzd5ZUI3?=
 =?utf-8?B?V29RVjRiZjdNdTVQSm04OVFaWExzbDAwdzdsVVlwYmdlRFZBd0FkemYxcnpn?=
 =?utf-8?B?S0s2RGlpWi9XUDIwSldVY3FmVk5kNy9VdWJkUk4yck1WbHA0M1dtczdISXdm?=
 =?utf-8?B?L2V1UXYvamZkR2tmNkRUSzRpV1UwREpJb3U5T2FFQzkraU0wT2JOYnpXM2Ry?=
 =?utf-8?B?TVdUZ3FTWWdSMUx5RUwzNHRyTVNyNHpnQlBYYkZGSjBYZkt6VGwxRElUUmVo?=
 =?utf-8?B?cW5SL3FSMTkybC9qeG5aZ1NBWUE3RlJ4UUNMUmwzZzcwc0VqMDJUcnZsZS8r?=
 =?utf-8?B?akFHN3lLczBPbFVYZFRmeStsalFzRGI4TVRRTCtXVzhrSmswOXJUTHplNk1G?=
 =?utf-8?B?anRodUQveTkrNU1idE03VEZGRnJaT0tYSnE2UWVxUU5BaWRiaDVLMWFSQUl5?=
 =?utf-8?B?Y2kxaEJmNWpMRjBtMmU1RmZ6QTJjV3ZpRWVyRGYzQ2pxSk5ycVFUTVBaNllm?=
 =?utf-8?B?Ulk1SjVlQXNiSjFFa2FtRW9FdWg1OStBRXVBa1hrMUczOXc4UkJiV0k3WTMr?=
 =?utf-8?B?NnMwaWQ0SFU3dUMxQlU4TDFYZGNPcVZYSk1FT0R0Y0V1bXhhVW4yUmxCTEdP?=
 =?utf-8?B?YzFtZTVGT2xtWjNZVk1RRitDVDBQbllsVXZvbnZXMlNNTDFUSHFZdjJ5Rk5j?=
 =?utf-8?B?SEpiSHBoeSs2YUg5R3BKTzdMTFVzYjlrMEY5YXIweU1UMlY3LzBHMHlDL1lQ?=
 =?utf-8?B?RlFuSmUxUm15c3FPUmdTSFJnTEl2ZmtXRVAwRThPZS9lZk15SUs2NWhGZHlN?=
 =?utf-8?B?ekc1UzBzZVByZXZUeEwvbHZ0cFhnU2RtOGdVMUppWE44QVZtVmdQaXJmTHNt?=
 =?utf-8?B?Nk1IVmxrZEx6clhDUm8wVTNKZE9UNTh5dHdKbGJ1MGVGSmJoaEtwUkpnTFhZ?=
 =?utf-8?B?ejM0TnF6SEIxN2lYSUQyclBpcm8wWDFSdVBRR1pBeWUwVlBmVGw5dTBsNWRm?=
 =?utf-8?B?U2ZlMW5sS0ZuMGVaWmFJVUNkc2p5M0ozT3FsU0J5VFRiNjF3eXZWWklrd3Bu?=
 =?utf-8?B?c3BFOWt2WGR0Mlk3NXUrM090UVpIb0RWMTcrZ3hvSWRxcFo5emdqQ3FaRFV5?=
 =?utf-8?B?eWp4dEpPcFVvNkEzTC9KUzZqRHZvcnY0ekRDQlZ4T29ncU9uNUJlam9IdGxJ?=
 =?utf-8?B?eXNCT2FtQXhiU2FmT3lHdlV0amdBbkxrdSs2aHFNN3RnTHpKcGZXQkU4WFJL?=
 =?utf-8?B?ZkpTM1V4a0l4U096S2JlMzJKeWFwQ2xQN0FIZmdzSDB2RVp0R0FLeTYzUm1V?=
 =?utf-8?B?eWI4SmRKc2xhVXYxSzRQZ2pTMjRRSjdMOUZ4ZlpBNHZybmtQdzVXMFNQZ2E2?=
 =?utf-8?B?WnB0aDVOMGpTOWZIbFE3eTNxZTNvbUxLY3hOSTNubVRucWJRS1Nnd01say9v?=
 =?utf-8?B?cXRvVktqWGRJZ29kOE4zYUhzUmFTRnMvRGtPQ3pNc3JxOWxiaDdIM1FKL3hr?=
 =?utf-8?B?V0hBa2dxMVpRMlh2MTJFNXFUOE91MnNIOUtLZkYzUGVXajFEVzF5aWhyNUpX?=
 =?utf-8?B?U09vUWZCZHRORGx5WFFmTTgyTEdHTEFEamJUWThTaDFFZzF4Q2llQ0RPSU12?=
 =?utf-8?B?eGpmNUFZL2x4cUNnZ1BQTDNvcmQzb0lpS3lIR2RPSzZ5Ykl4dUZPamdpbXpT?=
 =?utf-8?B?V2tOZlNyZDU3QjJGdWIwUUNHWVpFRi8zcUdTejhUbXJNWFhwaDNUK1IwZTBM?=
 =?utf-8?B?bmxBZkRJeThTdnFjYVA0R0lNdGQzU0w4QXM0Y3FxTk9nVmx4WjhFUm80Zm5p?=
 =?utf-8?B?V2tpOVZrTll0bmhvYUdHbEJvZWt5ZkhjckZnNTBsYVMycEUwVUdEWDlxWmVX?=
 =?utf-8?B?OFk5UEZ3ZSs4R0RZSTNERFZZTFUzZ00wblFndXVrdENVNlRvbExpdU9XUXc4?=
 =?utf-8?B?WGJEdFlPOFo1bnZLVW84RmZjS0dmMHlZeGRyazRvWmtYRmh6ZUZBVnRBNGFq?=
 =?utf-8?B?bU84MUlPWDZ5V2l4TU0wNVRDOUtoU1hkSzhPWEpZMC95Z3podjZ0N25FUS9V?=
 =?utf-8?B?WWJseU01bGpLRnkraE9HTVR5WEU3NEpvNUFrdkUrU0Y3cFRBeHdGeG1qajRn?=
 =?utf-8?B?Z0VlUWpUUEdkZ3liQnJEK1NwNXY2STFlaHVwdnpzeWdSTDN2SEwzR1IyOFUx?=
 =?utf-8?B?VWUxb3lTaFBPdWJMZ1BvVURqSktGNzBEMk1xVTF5WDdQQ0taSFRzdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef06fd8-49a5-4840-0245-08df4b4499c0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 22:36:52.0653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XBZSCjvWjHi95DAlv3c7QjKQhZ8q5BHinr79RDWKwO2byzRL1uZKEp3RxhFit/a6kloRtV/F9HYsjYY6VC6QPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7629

Hi Oliver,

On 11/24/2026 2:29 PM, Oliver Upton wrote:
> On Tue, Nov 24, 2026 at 01:12:12PM -0800, Nathan Chen wrote:
>> A nested-capable VM gets 2 shadow stage-2 MMUs per vcpu. Once the guest
>> hypervisor runs more nested VMs than that, nearly every nested context
>> switch recycles a live MMU and spikes host CPU usage.
>>
>> This series lets KVM grow the shadow MMU pool on demand when the pool
>> is too small, up to a host-wide VMID budget. It also parks grown MMUs
>> on a guest TLBI ALLE1 and when a guest range invalidation leaves them
>> empty, in order to return unused capacity.
> Thanks for taking a look at the problem. There's no argument that we
> need to do something, the existing MMU allocation policy was good enough
> for doing nested development and would get replaced eventually.
> 
> With that said, I feel rather strongly that we should not invest further
> in the MMU array because it is quite inflexible. On top of that we need
> an actual eviction policy that selects cold MMUs as victims instead of
> the current round robin approach. I don't think you need to do anything
> special on the invalidation side with a good eviction policy.
> 
> I think this is what we need:
> 
>   - A VM-wide hashtable for storing stage-2 MMUs, keyed off of
>     {VTCR_EL2, VTTBR_EL2, HCR_EL2.VM} to align with how we handle TLB
>     match at stage-2. The hashtable can be dimensioned based on a
>     configurable VM limit for shadow stage-2 MMUs.
> 
>   - A state tracking mechanism for victim selection. An LRU list seems
>     like a reasonable starting point.
> 
>   - RCU replacement of the evicted MMU. I need to think about it a bit
>     more but you should be able to reuse the PGD in the new MMU context
>     as well since we know that no vCPU holds a reference on the victim.
>     That ought to be the goal anyway.
> 
> That should allow us to dynamically allocate MMUs while also improving
> upon the current behavior for constrained MMU allocations.

Thanks for the detailed direction, that makes sense. I'll drop the
array-based approach, including the invalidation-side parking, and
rework the series around the approach you mentioned above.

For the per-VM limit, should we keep it capped at
S2_MMU_PER_VCPU * nr_vcpus by default? And should it be overridable
via a module parameter or per-VM capability, or would you prefer no
per-VM cap at all, with the pool growing on demand and only evicting
when allocation fails?

Thanks,
Nathan
