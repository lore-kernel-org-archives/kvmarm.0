Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010005.outbound.protection.outlook.com [52.101.85.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3CF37189B
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 23:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787267354; cv=fail; b=uLuEaYyC8+cCpcoiF8GgmOyePMqAAecOmMx3t7BQa6lL1FnT8qrLAy3gLf3lCUjJkBf9ajnP7+nrhqCccOhJuCcHBr3m+38ByctW3+CrfZRmOQVRdFwCrF/kixEQMWsl7giixpFCcW8AuhrkODxDouSb/wVAWCBDi/92lfok3dQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787267354; c=relaxed/simple;
	bh=7/1LxdIb2sFSTAhRKKEj75DK9/a4cKWU5qa837L72dk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQsKVVj2u7sXhNpUZd/4Hhoe23A9710GKNZwIc+D1q7vPDh3BnOV6txFlFVPtbWg7B0Ap2G6OWLzmxbHR6jhF3fYEnnjsC1opS86QtasFVTv38v4SKFZCcTXsBr2m+K5TM6GVfyaib/O9ERXeeQODL61A9Yst2e0lchrL6W+C04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NsAYFAGB; arc=fail smtp.client-ip=52.101.85.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NsAYFAGB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wN8y2PGlgQrt0XHc+UsU46je6cVR6rxwDDuQW+Gie8frG3HyYCDE0kURv3dSnn8/1+wb+aLF5Njoog/T4x/gjXt54W9WOBgOrhjheUkXkj7M9OdFGFyECe3NwBoCI+q+niygmggOK/qdoNdX0kgrRKW3FLm8bjEWh5AVK1bRQ4hIVGmxVZGdkmpfNe/RpiglpcR9gsXnybyu+oRv5NvQwwoDQcm0qKXhbSNgwTq7ctPSWOAGc3ZX66gmfyil5bsma08bumZcwm3ag4J1bbsYPeuCI8jL7hWCttz+zOTXVWPnw116F9z68Evv+s/60OjB0ZUwok9iBOKdjRSdjAhTbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V+7nzX6CXugCFvhzU1BmsTxY95ud9Z/nyXFzgDBHils=;
 b=R9VCTi6fjARacfWeECalURtTxfSdeFHsA2RR4osIb9qP4LbWfIIMhCqSNIF1CYli+AzeILHX6+yjQQK5TBn5jpWfw1FNl719zt81J9vr3bLOW9XB1dbnCKf0e/pkjquDZdSZ+pmwG3t0wuVoIbCCJaQL1qouGma8nFqOybyQvD1uCWVg44AwQrmwi3H0fg3dB3/eq/WgYkk/esvspMcPQQvBDEzgIBmDZdmfmxAqYRfOzLccg4WRwkZocAa8nysgEOWiqi42uXzFYqb9LAAlpAxGchnh+bQ+08cPUw/jkVWtncVIHNfVukbZeyZ8dBRx5fttlx1t4qRDPxx1xWPk6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+7nzX6CXugCFvhzU1BmsTxY95ud9Z/nyXFzgDBHils=;
 b=NsAYFAGBwuRVxLTxwd24awWuuvsGQp19vY/FnxvFFiBUCxFCQtqEKpCpEvfL2WuMum+pGMBsyW3weP4pWWAObkyugouAD4ZrTlLKIIngThhKpsyl5BHRXbOXwMoI62Q23EN8i812aiQNA7lQyKq1J4NyXVKbOed6cH6alpdEEas=
Received: from BN0PR04CA0069.namprd04.prod.outlook.com (2603:10b6:408:ea::14)
 by DM4PR12MB7526.namprd12.prod.outlook.com (2603:10b6:8:112::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Thu, 20 Aug
 2026 23:09:02 +0000
Received: from BL02EPF00021F6B.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::42) by BN0PR04CA0069.outlook.office365.com
 (2603:10b6:408:ea::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.10 via Frontend Transport; Thu,
 20 Aug 2026 23:09:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00021F6B.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 20 Aug 2026 23:09:02 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 20 Aug
 2026 18:09:01 -0500
Date: Thu, 20 Aug 2026 18:08:47 -0500
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
Subject: Re: [PATCH v2 2/4] KVM: SEV: Drop page refcount early during RMP
 fault handling
Message-ID: <7kapvdum7qk7l4epbeqvrybqxapuhvwltz7axfprxldw2utozh@t4url3mqbpom>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-2-5298f42d49bb@google.com>
 <j6bfvbzjivlcsu3slbnaoomxxqyypmfl2bupo3k5ipnt6fc5lo@e5ntbx7yd4qw>
 <CAEvNRgEruoa4d_8Y1MpkdzbHg3j1Yv=-Y6w6Yy=v6mJgPajjWw@mail.gmail.com>
 <zb5krzhrg3soslplynegqo52brd53wk3meas45udqpjms6oluk@zecqwzn7zziy>
 <CAEvNRgEHEE67+vjQqJjYD3M4yuwuR+4-36Hw4-sp5caYzmxbkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgEHEE67+vjQqJjYD3M4yuwuR+4-36Hw4-sp5caYzmxbkQ@mail.gmail.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6B:EE_|DM4PR12MB7526:EE_
X-MS-Office365-Filtering-Correlation-Id: 46a30435-df31-49bd-1676-08deff100634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|23010399003|376014|36860700016|56012099006|10067099003|3023799007|6133799003|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	kfj2fw+Z6GW93OO21yGQqWIh5r5OeObF4E2wsYW0wXcwYSTWGknVQQ2KmFJpGBfnJCZR8w/dr3cQdM/NgF4Y1aiYsa5EFwUafLSbFoEHH4JiuNB5WbbkCGpVP49ZbnGoxXO/bwx5vYjWXm3arvFYpTeBcv4/+hWNl1pUAXN83cQx+sJtrBjEKfZc2m7/Rww7GxoSL3QA521wHuVROcTq+WnEZWXlIN7YkZXCrc+HUyXN/bCiDpGSYPQLUp2WbKI3UkEwGdvJVr4r+iMpXN681Lsc2BMluAWee0OxzCE2sJeUbtRwDmt9TooyMT3pqchVdql+Lwbh7Q+npyPKQTXOypuNZIfFc+8hFxxmiISw+a9YhfqmgAuBVZOAoMBW0AReDPSIGXIFwTBMGWVECQ6O7KjW+VcdBCGBhOYXyXFfpwW+bEy+eTvK3lIqT1tTrb8D5Xberf7Ym8EZxGzZ5LiR6RiP4TXviWPKaawCBQggpAZYpHfEjIDYG2DYPffJuTxXtYXp6qt74gPrfNDIlmeBETHUr0QCtX/RPnHMsOlWTEoVVNXZLcJqqxBrZfNkaDWE8+Lcv+DeOhsftLEHtthgZQLtRvVjQvvEKIKXiTI8itArmqAf5H5dgzerKzyry3reLfhIviJ6F/Um+k1qaC56VS0keJQEgM0S04vP/oKUesdwRaWRQzU5n/H8g+PXABAJztPiUljgb6cniUZRDKmL4Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(23010399003)(376014)(36860700016)(56012099006)(10067099003)(3023799007)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	N9HZUAO9v/iq3RBOAzjBWceoQIWLgNPJ5oredt3e+2t0opNRE/xH094Ji0jcU9aUnDZwBQRozHw5BJT9Cx4RLZNgI0VZhjmxsM8aUbrWn9a3vv+3MEqpiP9JERI54PQqt4psfa/K2FJkILsgcSTEiHy2kLvLBu5YoKsNlUlJCB8rjLIZgrPaTVlplqI/x4s6oCVMVQrHjOo6pUTPpYzmRHW/EAPdcvRBVsD/wcdBM7uokd51+FZgUyBFuBJSTl/XN8Fif+xlluDdqFocm2iCczV/N/kculo7Bw1krvuljTbp9N0YJPoWgooO9nvNMJJzGN8TTkTWxDJr5ymf73i1/k9W3oFpqKaha2uyMeMQr2zatqz2r1AOYYPcOmJ95hh/E6zI4BbF/peuZg6UO5+Z0lAJ00PB2gt0nRUlJkuae8Y1S/qRWMfPFG3xxUfmv1ag
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 23:09:02.1486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46a30435-df31-49bd-1676-08deff100634
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7526

On Thu, Aug 20, 2026 at 03:35:31PM -0700, Ackerley Tng wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> > On Thu, Aug 20, 2026 at 07:58:19AM -0700, Ackerley Tng wrote:
> >> Michael Roth <michael.roth@amd.com> writes:
> >>
> >> > On Tue, Aug 18, 2026 at 09:15:53AM +0000, Ackerley Tng wrote:
> >> >> From: Sean Christopherson <seanjc@google.com>
> >> >>
> >> >> When handling an RMP fault, KVM retrieves the PFN for a private GPA from
> >> >> guest_memfd.
> >> >>
> >> >> Drop the page reference immediately after retrieving the PFN instead of
> >> >> holding it across the entire handler so that the later patch can follow up
> >> >> with completely not returning refcounted pages from kvm_gmem_get_pfn().
> >> >
> >> > Regarding this point:
> >> >
> >> >>
> >> >> On a first look, existing RMP table handling (psmash and checking for
> >> >> errors) might seem like it works fine, since truncation of the page from
> >> >> guest_memfd would have called rmp_make_shared() and removed the PFN from
> >> >> the RMP table. However, that is insufficient since a freed page may already
> >> >> be used in a different SNP VM.
> >> >
> >> > In the code this patch is applied on top of, I think the kvm_gmem_get_pfn()
> >> > ref is enough to avoid the reused-by-another-SNP-VM scenario until after
> >> > caller releases the ref, so I think the above explanation should be adjusted
> >> > to also be preparatory for "the later patch".
> >> >
> >>
> >> I think this sequence of events is possible:
> >>
> >> CPU 0: sev_handle_rmp_fault()
> >> CPU 0:   kvm_gmem_get_pfn()
> >> CPU 0:     filemap_invalidate_lock()
> >> CPU 0:     refcount++
> >> CPU 0:     filemap_invalidate_unlock()
> >> CPU 0:     refcount-- <<== because kvm_release_page_unused(page);
> >
> > Prior to this patch, the kvm_release_page_unused() isn't done until
> > after the snp_lookup_rmpentry()/snp_rmptable_psmash().
> >
> > It's possible CPU 1 truncate sequence below can run concurrently
> > after filemap_invalidate_unlock() above, but even though it calls
> > free_folio(), which might zap the RMP entry, the filemap code will
> > only put the refs that it has on the folio so it wouldn't actually
> > get freed back to the buggy allocator, so it doesn't seem like the
> > psmash-another-guest scenario is reachable. I could certainly be
> > misreading things though.
> >
> 
> Ah I see what you mean. I think we mean the same thing, let me add to
> the commit message that I meant after dropping the refcount early. Does
> this help?
> 
>   The filemap_invalidate_lock() is already dropped in kvm_gmem_get_pfn()
>   before returning to sev_handle_rmp_fault(). After dropping the
>   refcount earlier with kvm_release_page_unused(), these scenarios are
>   possible:
> 
>   1. Since the filemap_invalidate_lock() is dropped, the page can be
>      truncated (or in future, converted), and the RMP entry is now
>      shared.
> 
>      In this case, existing RMP table handling (psmash and checking for
>      errors) would be sufficient. On finding a shared entry, psmashing
>      would fail gracefully and no warning would be emitted.
> 
>   2. The page is truncated and freed, and then re-allocated to another
>      SNP VM. The RMP entry is now assigned, but to another SNP VM.
> 
>      To address this, adopt the MMU invalidation protocol to guard
>      psmashing.

This reads kinda weird to me, as if with #2 we're documenting a "bug" that
this patch fixes, but the bug would only exist if we partially applied the
bits of this patch the drops the ref counts earlier and left out the
bits of the patch that introduce the mmu notifier logic that replaces it.

I think with patch 1 applied (which covers the
psmash-a-now-shared-entry case while retaining the original refcount
logic), the only thing this patch is doing is replacing the elevated
refcount logic with the MMU invalidation logic as prep for dropping
reliance of refcounts entirely.

I think if the wording was simplified to just say something to that effect
it would make it clearer that this and patch #3 are prep for #4, and that
patch #1 is the only patch here that would make potentially make sense for
a downstream to backport without the other bits.

-Mike

> 
> > The psmash-a-now-shared-entry scenario because of a race with the
> > VMM/truncate path seems possible prior to this patch, but that's
> > pretty similar to the psmash-a-now-shared-entry because of a race
> > with the guest scenario and which would generate spurious warning
> > messages to console, and that would be similarly addressed via
> > patch 1 I think. I'm not sure
> >
> 
> Yup. I like your psmash-another-guest vs psmash-a-now-shared-entry
> classification.
> 
> > -Mike
> >
> >>
> >> CPU 1: truncate()
> >> CPU 1:   filemap_invalidate_lock()
> >> CPU 1:   refcount--
> >> CPU 1:     kvm_gmem_free_folio()
> >> CPU 1:       sev_gmem_make_shared()
> >> CPU 1:     folio is freed
> >> CPU 1:   filemap_invalidate_unlock()
> >>
> >> CPU 2: in some other SNP VM,
> >> CPU 2: kvm_gmem_get_pfn() gets the freed folio
> >> CPU 2:   sev_gmem_make_private()
> >>
> >> CPU 0:   snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> >>            <<== it's assigned but to some other SNP VM
> >> CPU 0:   snp_rmptable_psmash(pfn);
> >>            <<== this psmash would be smashing in some other SNP VM
> >>
> >> And hence I think we do need to check for invalidations using the MMU
> >> invalidation protocol.
> >>
> >> > Other than that:
> >> >
> >> > Reviewed-by: Michael Roth <michael.roth@amd.com>
> >> >
> >> >>
> >> >> Hence, adopt the MMU invalidation protocol to guard committing anything
> >> >> based on the PFN.
> >> >>
> >> >> Signed-off-by: Sean Christopherson <seanjc@google.com>
> >> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >> >> ---
> >> >>  arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++++---------------
> >> >>  1 file changed, 24 insertions(+), 15 deletions(-)
> >> >>
> >> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >> >> index b2738362a928b..b34b11d7f8fad 100644
> >> >> --- a/arch/x86/kvm/svm/sev.c
> >> >> +++ b/arch/x86/kvm/svm/sev.c
> >> >> @@ -5003,6 +5003,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> >> >>  	struct kvm_memory_slot *slot;
> >> >>  	struct kvm *kvm = vcpu->kvm;
> >> >>  	int order, rmp_level, ret;
> >> >> +	unsigned long mmu_seq;
> >> >>  	struct page *page;
> >> >>  	bool assigned;
> >> >>  	kvm_pfn_t pfn;
> >> >> @@ -5030,18 +5031,22 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> >> >>  		return;
> >> >>  	}
> >> >>
> >> >> +	mmu_seq = kvm->mmu_invalidate_seq;
> >> >> +	smp_rmb();
> >> >> +
> >> >>  	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
> >> >>  	if (ret) {
> >> >>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
> >> >>  				    gpa);
> >> >>  		return;
> >> >>  	}
> >> >> +	kvm_release_page_unused(page);
> >> >>
> >> >>  	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> >> >>  	if (ret || !assigned) {
> >> >>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
> >> >>  				    gpa, pfn, ret);
> >> >> -		goto out_no_trace;
> >> >> +		return;
> >> >>  	}
> >> >>
> >> >>  	/*
> >> >> @@ -5069,27 +5074,31 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> >> >>  	if (rmp_level == PG_LEVEL_4K)
> >> >>  		goto out;
> >> >>
> >> >> -	ret = snp_rmptable_psmash(pfn);
> >> >> -	if (ret) {
> >> >> -		/*
> >> >> -		 * Look it up again. If it's 4K now then the PSMASH may have
> >> >> -		 * raced with another process and the issue has already resolved
> >> >> -		 * itself. If it's not assigned, then this must have raced with
> >> >> -		 * another process that made this page shared.
> >> >> -		 */
> >> >> -		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
> >> >> -		    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
> >> >> +	scoped_guard(read_lock, &kvm->mmu_lock) {
> >> >> +		if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
> >> >>  			goto out;
> >> >>
> >> >> -		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
> >> >> -				    gpa, pfn, ret);
> >> >> +		ret = snp_rmptable_psmash(pfn);
> >> >> +		if (ret) {
> >> >> +			/*
> >> >> +			 * Look it up again. If it's 4K now then the PSMASH may
> >> >> +			 * have raced with another process and the issue has
> >> >> +			 * already resolved itself. If it's not assigned, then
> >> >> +			 * this must have raced with another process that made
> >> >> +			 * this page shared.
> >> >> +			 */
> >> >> +			if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
> >> >> +			    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
> >> >> +				goto out;
> >> >> +
> >> >> +			pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
> >> >> +					    gpa, pfn, ret);
> >> >> +		}
> >> >>  	}
> >> >>
> >> >>  	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
> >> >>  out:
> >> >>  	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
> >> >> -out_no_trace:
> >> >> -	kvm_release_page_unused(page);
> >> >>  }
> >> >>
> >> >>  static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> >> >>
> >> >> --
> >> >> 2.55.0.699.gb54405d56f-goog
> >> >>
