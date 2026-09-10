Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010006.outbound.protection.outlook.com [52.101.201.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8253436A033
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789062490; cv=fail; b=qLwfWhBZaZH0wviLpTXREIpbFydNrNpIwDYENkSZMxzxcCPSherlEcapUV0wJh/HBbNpR05Q4nx6pV3DXGnWnLslg4AMySo3RPtZxAQAa9cW7E7wx+sNGsuFcm6BJfc0H2THTkF3ILiDF0LcGofbx+25RxDeGjsn+cUUliciwjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789062490; c=relaxed/simple;
	bh=b2Tz6zEG5gZI5sVbuAhItWn93C2GA2AJc3Ph+BdCMJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X8JWcWYjCRJOpBkasZuz2jZsoT+bj8oYs6JEYsGSZ6tz9fb8KL33fcEQA/ORZJBH31eM4/mJvNSzXbEtCFrwYLrMwJEWZaWZpUIZa0U9LSOiZ7ksEN5ZRyPA9bh3i1iDiHYhDXsbl7PnPM0e0fJjl1cvuweJAwXoVPxsm63Tjo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kJwGOic9; arc=fail smtp.client-ip=52.101.201.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kJwGOic9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wQ+5G0B1PpzlFO7B9xPawSjbZVvFwrDbgt8nbQPWjvGYSnkM2tMMdnKpuOPkcKJ3AQj6NdQ2D1AEj2qMYzZt2j4UtfEHsICDHYaU3AVkxcWHhtIxSPAgaL/qxwUdk3drJqMkZ4nZPMjj8w2JWNxI3mK1A3nk6aSpnb1VlqHpI+koCgs0UnnH1hc3WjKuqgjs8Q+hthkQmCalxlzco2KiF5DKtTMZgTKRPtMc8UNOauLU29Uctpwmj21th0S8oYWeEZKOch1jThbB/Nfi2U+XJcoM2IUmaY0xzU3JBzS/wE35JGJniZHQNwToSRuBvD6QaE094sTaL/X49PnY348DQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dKd7QR80oLZFNIOxPtqaVQEmjNbpvg9cYaMNwW0lJIQ=;
 b=u8N4poEjIueys6+iOUTyNB9mqofzmzMTJYs133FEHK0j+yYzKsoiHleXDIhEH0q6JCNOycsCeaidXJjceh6zfNAhy/YGmEQvQyMMO8OsihCace5LCc66qS1e34oIfIcXRNim1D9yuVkDv8m3i6ecHXv4z28RZFQvmWWnhsOCHoOr6rBVSZNZcum4rKp008zwLy3cYsR4z9UpTRcZKXJ8lcegYGSgqikakEdidgIyfZ/ZY8IgBabxmmoiQgzFDMqLbc9mE4M7HYQkdrmgzsOfrHZACAL7GVGbGD42WKTh+smB/wfnmMOCJu0hcXSbyHv2Le9WvhhVeJK+h42y60KgNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKd7QR80oLZFNIOxPtqaVQEmjNbpvg9cYaMNwW0lJIQ=;
 b=kJwGOic9vMzTMqzBmVw0yubN+0iGFwo5y/cmTPNL/2lsS0U84gFnoonRMSvbNCtGLxsFgY5l5qQB04Vqh0cCPJ9L+Ie9cphM6t/sLlgmhr3IwGVco+PW4szUV1eb0QiuW2X9HL7US+Pe6r3RQbyDyzgTLQ+c07QGL7GldDD+YpGwHYMlx5a4lgpg7b8hC68qisEL89CoAP+ma9icOpNCF2r9dLgGWgLQM+OKYMehIgTYUupvXiE5jnj37vAVlZhTIRQiFJJhudZAf5M1/sOtCHjs67v45HZfbNVUnijIVsSaoRvqhDZj6TH55RHmrHL9JxaEh3chk/V3xR4wPPoWhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB7623.namprd12.prod.outlook.com (2603:10b6:8:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 17:47:43 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 17:47:43 +0000
Date: Thu, 10 Sep 2026 14:47:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>,
	ackerleytng@google.com, fuad.tabba@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>, david@redhat.com,
	Pasha Tatashin <pasha.tatashin@soleen.com>, sagis@google.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>,
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com,
	michael.roth@amd.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, will@kernel.org, vannapurve@google.com,
	maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org,
	oliver.upton@linux.dev, kvmarm@lists.linux.dev,
	alexandru.elisei@arm.com, skhawaja@google.com,
	aneesh.kumar@kernel.org, linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com,
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live
 updates
Message-ID: <20260910174741.GG3968357@nvidia.com>
References: <2vxzpkzo51wg.fsf@kernel.org>
 <anssOQFNZ2LfihbU@google.com>
 <2vxzik5f311e.fsf@kernel.org>
 <anyObKiZIhfok5mk@google.com>
 <2vxzqzjz1x5f.fsf@kernel.org>
 <aoMcqp0gr06YXAPU@google.com>
 <2vxzy0e3zgqz.fsf@kernel.org>
 <aoSCCTTBn9D5hqzk@google.com>
 <20260905011956.GA856309@nvidia.com>
 <aqLU653FXjJjhbop@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqLU653FXjJjhbop@google.com>
X-ClientProxiedBy: MN0P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB7623:EE_
X-MS-Office365-Filtering-Correlation-Id: 955808a4-384d-4515-11e8-08df0f639d91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|3023799007|10067099003|4143699003|11063799006|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	iOkj1MhlmuWs3Q3Yka5GYsaQ6TZM66zt/vOEWATmoxG5O/uQppiNzFwdEDPUb7hdWnJxKUa5ydrbsg5Mr2vMoiL237PPoULNrp3d0qyqMzdxTyer91+BYKO6dSiY06hVefKMGUkqsk7H22sDrpoQNY2UCfYakigMFUT1iPjTxK9EYYC00kJ3TNI2aTxhNb6Y0HSxeugLLe7tZwOL+mNxOBM0mwalfAAHqGaDl1OPVMnJNvkdh7jJeSjQjGLsiohm6wYXcrW0j0IzGeUIOspZd3tnb0fkHYGwNPqucC363FRPYprYt5Hbxuo5lkqck4ag+fUY4+0AOBTNBXntIw+z04PB5ohwbYDBPUnTFEZmHZURi7WxtEY/VG2NDYtpaMdYJwEXJHaCbsumZhU6Om+Nm1ieAuTxmFqvKOQlwNWICAjNmyAM75u4yv03+39FcmsQelRCZCK4FBHFBRM6XYFxDwS4gmxRBVxWGg7oPZqHQiiISXwRJhvvB7k/T4nwBYksQryO7dShY6Xt6o+LeL26WUaX0f6z+7XwOCBr8POfP5YMqggoqdrlTopuI0vYgJAySzJ/niiCd5B+LAYYs8ipr46m0GiSzizDRA8aoFuT52DhGJ4HKckghczRsQVPRvp4HOFL75KjjvRuTlzUnbmY71XYwgWuqD/ZouuaPGiN97I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(3023799007)(10067099003)(4143699003)(11063799006)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CkcgztgA/Jzc1R1gVil2wLLNMW7/x8FpqEckdD3A7tisZhL6uHUAPDyhgKWu?=
 =?us-ascii?Q?qpAQDF43DrDtYz21P88z339Y6N4K+IDv7Hf30PUaXw+TpnjewFnmpq1VFfjd?=
 =?us-ascii?Q?xihf/FIg7qeeMAYF15glfPWpAWib8yEqykHrM/c26m/7lm2DDFEQyJUSMB0Q?=
 =?us-ascii?Q?/mBHOOXFIEv3yEEBGUGI4c+ItDWBztW1qko/l8nEdFckWh8k26JliUQIyMMm?=
 =?us-ascii?Q?S4LaXeRDbVUiZuKDqoRPwjJ/wiQsBXDhrLqxVUlsyrZCABhSrV6EOLGcBsQ2?=
 =?us-ascii?Q?lUOePxgZ7rJRONVOHJBrsxUBD2xIEiDQoxVbDOdxXJUxYOkEPRsVrh1JTsjE?=
 =?us-ascii?Q?bx/b/Ds4hFTuyC3VjdXlqMLfyRxPmE5VdALUAsf4CsynjF3i8NkQEyVnbeit?=
 =?us-ascii?Q?Ewjbx8F3abJ4atnT4iisNaugEiW/pzEwdN7DcRJQse5Ekl3B0a2gDMNmxuFd?=
 =?us-ascii?Q?ry5BsR1gkUJkGnPeJyr5ukMZJdAPhp6ZtVDMIidRju8rvlQLv+YHZ2X+mJ5g?=
 =?us-ascii?Q?GKojEMTY1Nj/cPIrfQAoqtJnQBIs3VNzAjy3OwR2iKsUq/c2/b/p+45mPYi7?=
 =?us-ascii?Q?FRCPhaOUZcI2WURlcwdJlkO+EReDfRsngDjN8wK2QtPNdoFPDjo1wcbiLGEI?=
 =?us-ascii?Q?MFCKZhcyYiSc1OSlflx+z1nua5p6I/tS6SWMC0Pr/qwqwKU0CGq0v3dQvbWH?=
 =?us-ascii?Q?JmiLZoVwDmesXQNXhIZDm/d+oxpJj5Qu7XrSNO8LfyuAKY9hlYLO2iWK9jkZ?=
 =?us-ascii?Q?V1VhrQlPCGvYoPo9Zh82rTyYmrjeZuOOWDKAPzwt+d0gi4izrP3uciztB90N?=
 =?us-ascii?Q?eZ4ozD+G0OiUsEHrUeZ2w2w+RdDHbuQUmAUonmHB/97o/lIJdCeoy49/NPvD?=
 =?us-ascii?Q?IZ+SYLbUfUYJjqO55TY/4cfBsrxZ5Kabd4Aw6nvOiTRUzEgAZ5ecY8XWxO9l?=
 =?us-ascii?Q?pncRD5l1ZxV4a/Gm8oaj9HFxm7vjWp1FHDIlMMuq384QWR2LSPd6QaVNBYav?=
 =?us-ascii?Q?uKHqA/uzfZMf7QmA8Yy3Rh1Imb95tWNT+VLmAXUf0UBXcg+cgQYjwwZ6QB28?=
 =?us-ascii?Q?3dHyOJ31urS1ApwqhcvZlG2kw45bHr2XF/PBmVT5N24RFecMk7qk90M585Mr?=
 =?us-ascii?Q?NAfkZeo7NCOhILbuma5woycCBs0vNkHisOUL8G4dn1F7SX3rwft3xoGX6+Sk?=
 =?us-ascii?Q?bCE0RbAOG76wrVqqt5P/u02ltRPCzcoN8AszrVfdgnBp+AEXG4IZHRfujr5O?=
 =?us-ascii?Q?pVsX5Zag2lmBwUbP/kg6UB+ugvK+ZTrUE5k0clTmmjU6dQLw+XJnMp4BNMHe?=
 =?us-ascii?Q?0KxyMJv3VipQAH2EknGHnBDmBoLhM8Si7DoeGg6jGj1Wnid6vomtEmkcPqZw?=
 =?us-ascii?Q?hkY6I+xZxoeqDeANpQawndqBgHUN9Gcc2cB/K/rStoTE8y1UaIoCqU0X3W8g?=
 =?us-ascii?Q?68LqY4011T2G3Y51SyyfJu939YDIlnXbQq0H5PcZRJ0js0psXT5mUhsW2qSv?=
 =?us-ascii?Q?SL7BwWHH1vgwMOHPZ+pRxde80s+7GzMfeRfc/KB/wQ3HZen0vYfODkfuo1bP?=
 =?us-ascii?Q?lB2azXL4rhXNt3ce096ItBnjTusMTCcj4dinuosAipbPgFfcpcWZtPxrIrhj?=
 =?us-ascii?Q?mh6l4M7mXA2owN608yeWON6WeBMRka+zssgWcwob5BShj4MQQpEx3d8Darfo?=
 =?us-ascii?Q?MDAwxPHvGywMQLsDjlP+A0hXgecrIOjc2EJ1/0rk6sUFW4qV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 955808a4-384d-4515-11e8-08df0f639d91
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:47:43.3653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CEWGcjsHshNcJsfMJji/1z3ihpwnDDTQqqI+ZjL8kHgbwryCscaLqAh64tCaFUxD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7623

On Thu, Sep 10, 2026 at 09:03:55AM -0700, Sean Christopherson wrote:

> From that perspective, what I am proposing actually goes a step further.  I'm
> saying don't commit to supporting *any* specific versions in upstream.  Express
> the feature requirements in the serialization payloads, and let userspace sort
> out what kernels are compatible based on their actual usage.  The kernel may need
> to provide additional discovery mechanisms, e.g. so that userspace can probe to
> see what is supported, but discovery is usually fairly simple to implement and
> maintain.

I'm not so fussed about the version number scheme itself. Alot of
different schemes have been proposed over the last year and half, and
some were very complicated. Nobody came with a more granular proposal
that also didn't have alot of complexity attached to it.

FWWI this started out with creating device tree fragments with a full
YAML schema, and the same kind of perfect ABI like you are talking
about. Yet it did not figure out how to make it discoverable, it was
super inefficient and very hard to code for.

It has to be discoverable from the ELF, restrictable on the export
side, easy on maintainers, and not complex to implement.

> No, the subsystem just needs to make sure that it serializes its data using the
> defined ABI (where ABI here means the format of the payload and the meaning of
> any flags in the header).  That should be *easier* for maintainers to handle than
> trying to support arbitrary versions, because it eliminates subjectivity and
> having to make judgment calls or remember magic version numbers.

I'm pretty sure I have something like PTSD from ABI definitions
adventures on the uAPI side. :( Please don't call it easier!

I really don't want more of those in the kernel process. I think
Linus's non-stable-api-nonsense is really a good thing for community
health.

With the simplification that upstream supports only one version at
once, a simple "id" to represent that ABI was the simplest, easiest on
maintainers thing. There is never a fight. Someone has a new idea,
great no worries, change the ID. Done.

I guess I should say my perspective is to prioritize not burdening the
maintainers.

> > I was told KVM had the smallest luo footprint of everything, so
> > perhaps your perspective is different.
> 
> Only because KVM already has a massive ABI surface for save/restore.  

Yeah, you are lucky, other subsystems haven't done that. Honestly, was
it easy to create?

> If you want to convince me that magic version numbers are the right
> approach, then show me how KVM's existing save/restore support would
> be made "better" and easier to maintain by throwing away all of
> KVM's save/restore uAPI and replacing it with a versioning scheme.

I don't know about KVM, but how do I manage something like serializing
an iommu page table?

I'm replacing all the iommu page table code. It behaves
differently. It supports different things that old kernels don't
understand. iommu page tables have to be under continuous active DMA
during kexec, so they cannot be serialized.

Setting the old stuff as V1 and the new suff as V2 is so easy and is
unconditionally correct. To my point about supporting only stable
branches this achieves it with minimal maintainer effort.

Yes, we could do some comprehensive analysis and try to determine
everything that changed and make micro feature bits, and some thing to
map the current layout to those bits and then hope all of this is
correct.. But that's *a lot* of work, probably will have gaps since it
will never be tested. Seriously, why bother? Explain to me why I
should spend my time on this and who benifits?

IMHO your KVM example has a much clearer answer to that question. It
is UAPI so you have to do it anyhow, and you have a robust open source
ecosystem with alot of VMMs that will consume it. Yeah, I'm on board,
makes sense.

> Have to, or choose to?  I have a very, very hard time believing that
> it's infeasible to define a serialization format that is decoupled
> from kernel internals.

Reduced perfectly everything should become grounded in either HW or
kernel UAPI definitions. Things are not perfect, the kernel has
limitations, it doesn't support every HW feature, stuff leaks
in.. Like my page table example, the new stuff supports ARM CONT, the
old stuff does not. That is kexec ABI breaking and is only happening
because of kernel internal details. In the page table work alone there
are probably ~10-20 micro features like that that would have to be
identified and delt with. Frankly I'm not confident I could even
capture them all.

Also there is the push to make kexec downtime lower. That puts
pressure to just retain kernel things exactly as is, and maybe even
keep kernel memory as-is. ie a sloppy job serializing to get better
performance.

> Only if the relevant subsystem defined a poor save/restore ABI in the first place.

I think KVM is the only subsystem that has save/restore :)

Jason
