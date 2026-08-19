Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012039.outbound.protection.outlook.com [40.107.209.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615433B6BF2
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 00:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787099740; cv=fail; b=HDVEqzJSGHz4W+YtdqeR1bqHe6nY1lXHVDj2OZ1yJBUdNzpCmsmLYMoNt4KXAlta5F46xblLIBY5onJBp+FZR8i70xZ43Qh1Lqt9QHm2QpopDgud+wSlcjPskfwNpTBw62IuZBMRocf1pRLBcnsFSXZ5PGWDr2LrmnOrz/f/EA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787099740; c=relaxed/simple;
	bh=9z3t3ZArlF6zOOia1flA3+Nr8tHE4OFWuLlkSjacxhs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKKnUyQOPLux5cy+vtbqevDvGpAMaSA/JV9LyT8ZJ/+AzhiBV8iQXMZfI/+uc1coLczs9O9K741mPU2ZISiqBK9c7yscCGaNjjSb/YhVqiSG4hr79UWjDPGCL9t5pRKNUvyyfk7KmRYdEMOqyy+RMq3HXgS+7Tf8GffpmoPhb3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EHCWY/46; arc=fail smtp.client-ip=40.107.209.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EHCWY/46"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jn3F9fkgFV/h0+qZRCcQMlBy7imnJo7DRAwSCUkLbEsfLmf9PFj2jy3P/iT8UoDotPzBFMq3tKgZ4J2KazcxTQmV3bgeBb/TxqTHiVIge7GsGXThkGK+omwvbDh94gm5eVMN3I2sK9D3to0hGiMJ9NcVDba4VpjvvBNTwHAGqDBAvWFiiPvYvl4oA3Gu0M9RwPRxirHcieCRBkeTgGo2/VRCOQlXpuG9LwUQ0p3WYAV7BYv5OpfJMEgJ+AsexU3BZMasSMWlZHBnKkzqBTqpvwuJYBh2zwCIxo7BVO4WD5M8YXWBKtMsQS/0LWBuJ2kNXFHBLvfGuF3AkCKv0TgElQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wryGs4nCTFlVdFM3tzrIgTSxlK1IKQTXMJ8KY8m4RDY=;
 b=iELA4uw0SwJS3Cgv7lnGqNBNqPkqf20jsi/67YWjY069KYgnk2h080RCX9S/6sOp8R7QBKCxgEqxTQLI5+FQqiNOtBFE36c/fbLcDwPifrDahNm+lr0cztI7Xy4u015CPtCYZk7EAB9Q9/YhO63iXMvtBNvkmzwaEs8aaLJG7GCS7jedbQOFT8fwY2OJ6gij7EV1p6A81lDsCrYDSLkTR3B7/hHh4mL021cMSxRhY94lK8g+HCgL0X9/CxOIO5nQvW8fks9qQXut4YkXGWDA/aSMjS2zRRC73QfT1P050KFvTHQqTwLAe/BnKmdgY9QGWqZ4//8n+tWTdJNyeZ/s7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wryGs4nCTFlVdFM3tzrIgTSxlK1IKQTXMJ8KY8m4RDY=;
 b=EHCWY/463/3TGDd/rYaRTum7YmadL3PGy0tGfO8+okbuHzyJG9DL0KLheXd7TM301UrhL1lmB8ddu0AaB9yb1D56ey/UrHcHPWSZnIdt6fpJQcezxVKRhyBUIGKQuP5awvXGDvX94anqo+xRQ6v3z49sE3iVul4LQR/bg70XIB8=
Received: from PH3PEPF0000409C.namprd05.prod.outlook.com (2603:10b6:518:1::48)
 by CH2PR12MB9519.namprd12.prod.outlook.com (2603:10b6:610:27c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 00:35:28 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2a01:111:f403:f912::4) by PH3PEPF0000409C.outlook.office365.com
 (2603:1036:903:49::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Wed, 19
 Aug 2026 00:35:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Wed, 19 Aug 2026 00:35:27 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 18 Aug
 2026 19:35:25 -0500
Date: Tue, 18 Aug 2026 19:31:32 -0500
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
Subject: Re: [PATCH v2 3/4] KVM: SEV: Drop page refcount early in VMSA reload
Message-ID: <thruecnqp72ii7bx3lfzlzhxs3u7pypfiu4hvkhwkpe2otnksg@vbaawawu3qo4>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-3-5298f42d49bb@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260818-gmem-no-return-page-v2-3-5298f42d49bb@google.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|CH2PR12MB9519:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c240c65-28ae-40a7-501d-08defd89c3ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700016|1800799024|23010399003|10067099003|56012099006|4143699003|3023799007|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	yaGutIjuN1OtOQPXmxMN53e5csviZAsd2uNuGtZOpY510no1bSrZg9c+bQTdbxz0hh/T7Pms46BuomkCvbqEPYMNxzrfvfGOViYac0/NnQuIcNGsmU35sAeBWnqOIhPUAwL6zj9Sk+UCK4Qlz1oWX6NCAbX9kDVGoQBrHcmagcN6mGzZUNfVgH0WEdCGwR0ZP4LVP4Hic0s0T1GB4LbqolLCSURqsZFiGPl9N8VtGJSVIFje0srphQcBKuEKDZlxR9ISRSWifIeP7OKV/zWlczV5GT6aSDLQ87hYvt5O6BIlhfVQHOTJtMN8unyPvumkB83aoUdVB2aH355PoELaSf+NqNAfay+iWSGNwftOeMBTsyisxQiqmINWRDvthgzqPHoXopmUhf3EoeSl65AcUWBmcVYgijRPNqb4GQsLf80BSpbtau7EeVjYxPTnCTAa9EUIX+ks6FWkzluaDKFfvGwuPNl0bedxc1K2wzsdrIYi7X5p5FzqzcUngosFH9zK7ZUSfuMYTq2wDUBq6TnHgrtB/6NT1o9hRCJg8LaNaTsE/DbSOJTZI8zrYfmCg5fIqdGouRwrEqmIcWRxWB6QFMklzyPP+fN+2jNV+gPrPL4xxX2qvfkv/d4w6ufBYkSl1+xeJ/4CaigVmKPL7iqTcXkPuR7oESs4VtOTd+f5o+0dGweMPFtH9fBTPuMLC/iPPLu8uevm+N4VVjEwMH9Ggg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700016)(1800799024)(23010399003)(10067099003)(56012099006)(4143699003)(3023799007)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fs9rNTQZte4+kbjU6GNCCwHzpaHXDGK2oFmFR49fSjLdHk2RQPxhVoVJc8HefJyHTzHO9+5AceLRI4HEO0KySwUuJdwbxoqhYb7/CakrFuIPxcm9x6lJQlX06nTHObh/Q05/mX6cXeZVhrRFrHuD4zRq85/7oJmlT8fFQdlnp7eBBdMNJ1V/C8sZZN8eyFuODSTd58F03SOL42DTgiTlsDuL1Gddio4f9/87YjnkeSciXC6o0DrN2QXpx4hTQ5xVEOrJAwHq3hBNZEtrqv7ywvb8VeR23cCc/ga+snTh/44XdCIkcubJNT5wL3tYjUnyq/dC7YbQj8bkBj4D66Cs+XhWk1e2B9k3ewP+GQasrxsGfQTgwPwJOeGz1ORlZ+rhYJGF4LwsQB759ZRH4hzhOtmDS/uBSzlNDV3gBfCVXAmkaQyRgoDgyM4Hqcq3kjCO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 00:35:27.3330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c240c65-28ae-40a7-501d-08defd89c3ff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9519

On Tue, Aug 18, 2026 at 09:15:54AM +0000, Ackerley Tng wrote:
> When reloading the guest VMSA for an SEV-SNP vCPU, KVM retrieves the PFN
> from guest_memfd.
> 
> Drop the page reference immediately after retrieving the PFN instead of
> holding it across MMU lock acquisition in preparation for a follow-up patch
> to stop returning page pointers from guest_memfd PFN lookups.
> 
> This is safe because the page's validity and presence are governed by KVM's
> MMU invalidation protocol rather than the page reference.
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b34b11d7f8fad..d3d620bc04dce 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4062,6 +4062,7 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
>  	 */
>  	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
>  		return;
> +	kvm_release_page_clean(page);
>  
>  	read_lock(&kvm->mmu_lock);
>  	/*
> @@ -4076,8 +4077,6 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
>  	else
>  		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
>  	read_unlock(&kvm->mmu_lock);
> -
> -	kvm_release_page_clean(page);
>  }
>  
>  /*
> 
> -- 
> 2.55.0.699.gb54405d56f-goog
> 
