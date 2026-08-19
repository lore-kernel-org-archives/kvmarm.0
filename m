Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675833B38BB
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 00:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787099696; cv=fail; b=kdyqsAICesg9d8iv+Q/vnzJjZiDkgoT8Ate09Lkf+aAc7gKwF+vgTmurbvzCoTblo3Y1n5UvaNxF3bStG7nonH8e9tQAwasohTp2XZMnbBT9UsThGOge2bY5VLvflX3klnGVPxHTX+zNPljU+X23nH6ElqiFUxwXDzJ/dhjTPZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787099696; c=relaxed/simple;
	bh=hxNjnRRJ2urWLS2jbj4js7LqqPcaofZHeK59TP/Tj3U=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVadvkIU+UBXU01vcFIM7V3K2rixcjqM2bvQ14JucJtWO+9vNCNuUHThg+vC6CISHmgwLDSzhQI5YPMmxWgqpWxYwEjEbZwSoJ/jwHR0f+6JR0OYTEUVUDY3a+YjTSe4rDoLshv2dacOL/miXmR3ZEXUrj/migSCNXv8wt74XkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d/gsZpxp; arc=fail smtp.client-ip=52.101.61.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d/gsZpxp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ProqmdIF1M1hC0d2voaAFIzQNtPfvZxPKe2mPLBv6C6YPgigsURPxz44/J4sc8opMFNfPm3ytLtAoO6e9h9e22vniT8jObmzcIHj8V44UYg8mVK2zSmwUX24cSPDaVOQcPfoipIdFZBO0cmagtyap7bjti2jRkgXvgAu/MOV/LLn5injtjNoqqruVDZ/wl1vPr0FHueJwB9Zdh0KQ0sS+Mj2ioeKevwx/oK9UjncavkgmpYXK5fkNti9+mAkRVRJ77SGYRONkc90/ihvYx5z9MSf/qFma3miMh0zCGGiA99dQeyooAzaFHw1w8vLIFhnbJBzEKamTWQVOWXXpai5Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHW9hDlHcLP0Imdf6E94b8UU85HwGySJstnRAf/EN7o=;
 b=I8tkPXTX8lZbN57uwhszn1JUSy2CO99QBc/KqVrshNCMkzVmadoMlXj15utytfTWasAxSID4SGXoAPaZPU5+FK1drtxBBSmeraVd/V3BBRECvf+Xnj6LZWzE5W6JNa0gVASehuz4g0aaHcHIiD6EsAr6P0+kM8abTGxgBrvh4DRHc44QjY9NgXlqEg8rIPO1ZBkbEce6OoO/8eQrjS8A94Bdxi4fCYhc+I3ZNRuzX9eHYYhFGiKR+RLmaIpiUw2zUJ/YW81CHJi+KF1HORL4Tfl3gJtVkKuz7lTyyLqeUHH2zBDug+s3MwEjKAot+fTNoooxoDkQS5hIgpw682TbRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHW9hDlHcLP0Imdf6E94b8UU85HwGySJstnRAf/EN7o=;
 b=d/gsZpxpCHuTwSA/3oSQ8F8Vm39eKrnXRmAsZCuy/lH1zwGp/BRC6AzuBumk6kSOoCjy0hOgVSLtSbiU/cYrGG3GI7BqL2mYSIhtyYlhV9Y/BDC587SlDJa3ACRrpE+HliSdFMqJUPTsiCZZuabPF439cw+8VkylVcFdRgO54Bg=
Received: from CY5PR15CA0182.namprd15.prod.outlook.com (2603:10b6:930:81::26)
 by PH8PR12MB6964.namprd12.prod.outlook.com (2603:10b6:510:1bf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 00:34:45 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:930:81:cafe::67) by CY5PR15CA0182.outlook.office365.com
 (2603:10b6:930:81::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Wed, 19
 Aug 2026 00:34:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Wed, 19 Aug 2026 00:34:44 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 18 Aug
 2026 19:34:43 -0500
Date: Tue, 18 Aug 2026 19:11:06 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, Brijesh Singh
	<brijesh.singh@amd.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden
	<seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, David Hildenbrand <david@kernel.org>, Fuad Tabba
	<tabba@google.com>, Yan Zhao <yan.y.zhao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v2 1/4] KVM: SEV: Treat unassigned RMP entry as benign
 race on PSMASH failure
Message-ID: <tomptwvdtajhavyuf47fwtx5fn43l2eg7vg7uuwt5fkf5qm3vp@tpb2uvedqdxv>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-1-5298f42d49bb@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260818-gmem-no-return-page-v2-1-5298f42d49bb@google.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|PH8PR12MB6964:EE_
X-MS-Office365-Filtering-Correlation-Id: d7689ac8-76d5-41fd-4041-08defd89aa50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|1800799024|376014|7416014|56012099006|10067099003|22082099003|18002099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	bL6j4BPA7xqC2t94Zr6hiYNH+BfvVp51o1xvsylyM7nfUBHrn38T+6wyz7HTuegoXRXlUxMpBQcgfgEIEO5G2S8NeNftg39ETaatJb5x1ILtE4o5VPrkZF4TGVnjIJd4y1IK5WqHaH2Rd2/GwRyEwieCFTuo2wA8Tbp1C+yk+TRaIsHIl7Y48QD1RVue9tv/u0nLgBwXH/7EbLwwKyvKUmBuSMp5inEDrHqEl1WettmnvpEs2Pt7ImV+CdzS61rULwSk5+rVy44Dpu2Ik39gC9olrGkQ48dqGuMr1CrqViPsSSKrC9nuihi5Mw0/lcQR/ajo1c9KfxXT/lkQ2LhFtrUpklXmQsjGa6vmTfBiIex9dOhvKNa1b8HKInewBgPTw9zKx1YyqQgrDJpQUsUvrJvk9sMfgrwlqftmc/8ToAo5/Y4tib0pN5rI1hl9pXHKb3ejvxTVucpmmVPp3bolrdjGswVvU6S2c94EwhxHaUZLW0Co3635BVGsi/uy5gAAxnaJtkDhVRoGvwmYLRTNj9oJg/Ql3us2r89O2rp2IJMN4395TwGTHeRKu9xAxruKimJX6YY86IQRdH89y6qYSnemyoCIbXpfdg06ktDpKBvEV83FNcnLwYVqeJ8zHqNONnPCNQfdlQdq73uCdwWNdcyNqUL3lvYt6romMPqAkjwhfC1ucuUYuKM9GsjEVqx/hm8tgG5syz/7TylszsUYFw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(1800799024)(376014)(7416014)(56012099006)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8vzMSW5zuOmzjs0sAuXyFAlp0/kjwZq6tWqtS1hyPzr/o9BuU+VvAsUzhbxbEq150y2i55jdIMbDjwHcUuvfkRYROxcjWqtYwsyUxROVgb3Hpk4j0hFdw6GfiIu9frNPfzIZf0g4FhxN7os8xRbn7CNh8+tEbU1mxR6y3RlqqGnQOMvW0Na0YbzwIjAjC+EyTk8eHRIwpuL8ax4WWyccMHbnCEooBTTz/IhJRfZ8Zli9Qe18Fo/CIWtr+oRatv9zJa1j9ZbmlSoT5aLN6ranR+ZKqn0YdPfRDb/9fAFsjgW48+HDbT7gkEJEfJCuqmdNXS/vyiA59/q9cb1oKNBfzeRxX9YNnJ+J0EpcKwL5p7mB4tBTB8VfUb4B1vGeixGgv1av+QJ60MpCLrmf/m8umDtQCUR/gaAPn6ZSPqHMECTYuFnaG39L0CckOXDOxBTx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 00:34:44.2422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7689ac8-76d5-41fd-4041-08defd89aa50
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6964

On Tue, Aug 18, 2026 at 09:15:52AM +0000, Ackerley Tng wrote:
> When handling an RMP fault, KVM attempts to split a 2MB page via PSMASH.
> If PSMASH fails, the only expected return value is FAIL_BADADDR, which does
> not distinguish the reason for the bad address. Hence, another RMP entry
> lookup is required to determine whether the failure was benign.
> 
> Specifically, KVM re-checks the RMP entry to determine if another CPU raced
> and already smashed the entry into 4KB pages.
> 
> A concurrent operation (such as guest_memfd truncation or hole punching)
> can also race and transition the page to shared, removing the page from the
> RMP table and causing PSMASH to fail. This can happen even if the page is
> still referenced by KVM, because guest_memfd reclaim transitions the RMP
> entry to shared when the folio is removed from the page cache.
> 
> Treat an unassigned RMP entry as an expected race when re-checking after a
> failed PSMASH, and skip logging an error warning.
> 
> Fixes: c63cf135cc99 ("KVM: SEV: Add support to handle RMP nested page faults")
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index fcb41dfde4c02..b2738362a928b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -5074,10 +5074,11 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>  		/*
>  		 * Look it up again. If it's 4K now then the PSMASH may have
>  		 * raced with another process and the issue has already resolved
> -		 * itself.
> +		 * itself. If it's not assigned, then this must have raced with
> +		 * another process that made this page shared.
>  		 */
>  		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
> -		    assigned && rmp_level == PG_LEVEL_4K)
> +		    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
>  			goto out;
>  
>  		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
> 
> -- 
> 2.55.0.699.gb54405d56f-goog
> 
