Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F02C481AA0
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 21:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787263040; cv=fail; b=C5Us2Bm7ELHsaill8JH8deB1f6wSoUbq4V4GZjMflAEOQzmTyl4Amg9ergHcM3aebafsXEMRmrtwRlEiz+OiazDnokASI90GTxfLntm5saNzEEC3kgTyv528cT6NVXkYSFp7U2E0ZM9hhCNMaXGINfKYsP1t0kgYaSDn5dCp/Gg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787263040; c=relaxed/simple;
	bh=xb+udodLHIfoPeenAMLFFCRbsCCVPcRQjcoy2nM/X8c=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGtlJpnRa736Beqqs5k8vFlE4OcTYFvnqKb+CRMq58+6ehMZoM/zT/UYSlOFqF+RPGSbpIvl6HWzsk9/LgpfMMl5INHWFpEl9jxS8pzKZhOdbubsIKf7/xUppxbsT0J5l7E8a9roG+p0yxuQVgsuONPvCrFdSK3ZZkT/wirQsFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VNenTuXx; arc=fail smtp.client-ip=40.107.201.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VNenTuXx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IpA36bD28CGtI/FkJ+QiVBgK3NFCCNxdR1Zbl/k3FCq6u2eQLWjTGQjiMDJjrEzdyBnQzSzKr5qpD9ADurh+zJIRaoGjIBtbZEVfIzGCTRGyecDaLLzTdc5HJgrMBA28p7k9dRNkQmvPRLBd1P1LJKRyYlEhkhba1irHmB1e+6wti0J3ihEgWKj1bOsnEKgJCZ2W9Vt7t8oemfhPDJ8jE5n7hF6OMtfh2vQCbuUDyAUZsyooNYLR2F6GDiuWzpjg0fex07mVemlup28Tmm1oHf9HFRnBcIRRrl7+6fmpm/OQDqad9PbqBBe5CWPkSqurFtKtjDnjXC3i6ND6rrlTCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XoY3PJsNxOGbm0uPnIhjf9GixyLk7qeqjV2ARZe0tmk=;
 b=gJLesTaV7WE1w1WCMafogJ+KEWEEK8Mazt6wUqiBfcqOtvvYCP5T+t/R2E2KwBJTxnzYmvkOnsxzpQTZJNmIHfSEMpLVbMdk2Z68Bjhz0halCD/4Zr3Mp4kOOA+Idgb1JidsFohGJtPj3/+KH2hoOLMVL6i0L+R3uGEzI9npMhuctDrcFQ5MU+AGPOc1pb+AzeB7X3VQhBeSN+qpsz72Ka7hpaqzWS2OztxMFIv/HYm07pe3qnY9YBuvfkaHcqKVWCkkm3ljjUaFQBUy1XWIXvQduoY02RKpE49W3hwYIUoXCqFwyu9DpaX+B6/nu4tXSQwPhdw2cE0jIOSzN3usjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoY3PJsNxOGbm0uPnIhjf9GixyLk7qeqjV2ARZe0tmk=;
 b=VNenTuXxHYI8ksWWBKdYOcRyR9DbOic/v207GyzIy1BKNaOxh02id89Pqec41XTISwF/YZJEmQA+8RHa3u2t6ifQ/ZZ3Lem5+IZrBPnaV/j1i154PkZEI6RSX1v/OXKuEr20CPWAL8aqiRzuW9kQR22kNDHl3mGKEMa2eFESeto=
Received: from IA1P220CA0019.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:464::6)
 by DS4PR12MB9746.namprd12.prod.outlook.com (2603:10b6:8:2a4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 21:57:08 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:464:cafe::b) by IA1P220CA0019.outlook.office365.com
 (2603:10b6:208:464::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.10 via Frontend Transport; Thu,
 20 Aug 2026 21:57:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 20 Aug 2026 21:57:08 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 20 Aug
 2026 16:57:07 -0500
Date: Thu, 20 Aug 2026 16:56:44 -0500
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
Message-ID: <zb5krzhrg3soslplynegqo52brd53wk3meas45udqpjms6oluk@zecqwzn7zziy>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-2-5298f42d49bb@google.com>
 <j6bfvbzjivlcsu3slbnaoomxxqyypmfl2bupo3k5ipnt6fc5lo@e5ntbx7yd4qw>
 <CAEvNRgEruoa4d_8Y1MpkdzbHg3j1Yv=-Y6w6Yy=v6mJgPajjWw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgEruoa4d_8Y1MpkdzbHg3j1Yv=-Y6w6Yy=v6mJgPajjWw@mail.gmail.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|DS4PR12MB9746:EE_
X-MS-Office365-Filtering-Correlation-Id: 443aac8a-2a60-4431-1db9-08deff05fae1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|7416014|1800799024|23010399003|10067099003|56012099006|3023799007|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	QJvcNZEAVgmkZl3e7WA76TIBBdg+YabKsxNxfQ91fPJAqCIePQ+YnNEXgcNpfQKdokNfAuieFcO45HIAVZCdWALLzXtY1XDn1ehBECLMdIlWQ6L5k92EfT9XSnoV1d9M/46o8vx56UwHGK6s+aLoQcJMLyegniRDC1R6BefAnW74r85Z1Vl0OrRHRLq9O8LRotKab6ucC5y4ULKH9CiE3BGOHOsKlrh5BumNmHHJpdLiMbjVE4lAmMjgOd12Dx//zW54iCU8rqaK+yQtQZRApK+rG4fF1Kb8LipAg+CGFvYjjcPgTnieREExjQv6gCoGVReIs6SGJPH1F2Z4ybIhtjxji4iWzsv9y4dQphNJXn0NfQBjqzJx9uD7+6EYiGhfYKkp5PdcxLIb3rmCucUtf2GJtPLS/GQcpY1n85uZThQYlEHsA2wlxH37v5ats7RiWId1gkSigXqZr2r6IVg14ZTVaT8Y99NmiiW8SEYyjHPdRxZlOUsylVXKzfb4Mki5HcMmWSVPoTowAJ/yGx/PYqkq7PAwFqCT2IyMHy+KgC/nel70JHhVi6qTHuAiQgfy+sNSFeGmJ+DhPjZWhhCacOiK8Mr3BjSzHe26rSr0Cz7CGgqaQ3f4XrVGFedVLoII9amtfzQbqlTkQiu+4iD/S3f67I4oOEt1oUSkmK4k4SgpKPMOTmhhQDW3I0gjAAmilSc4tIhD304Lx1flB4D/lQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(7416014)(1800799024)(23010399003)(10067099003)(56012099006)(3023799007)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VozllIeDtKXLfs6FtN6yNnAJKanHFS3a7rgjZFUhFgcIwaBvmgA6QUJZGoAJH7Zf7BHtKP17t3oRp2pyV9KVBG5w32rBaEb2x03BdN4pniOl9MCYbXcI1eYQsqi7TT4+djFdZuWRtPTswmmJ6H1wQTnn2g/XzUgXieh76cAAVWNQJUTEjIz7dJlyPBSKZTENg7HmR4SGZWfoToGGN15S86HSbn7CGUCKnn9Pk+agpyZULmFFT/5QX7R3XJQ2ZgTQ1AenPQ4C9FfVuqHfbH0PzXN2zzyfuuAW/cPHkv/hUCFHj9rVUWr5qNEsD8ejHmKCoB6S0Tzk7+SPH2JKqUCArw8qHHs3AHNC4b6CJwQ7eLHAeQ72GH1bPsV8cpLX9DJkngcMh14tvXQhAB7vtsn3AOl14RDWaJpZ/Nb4YrGe1ocH3DdaTsTCZGj+uyRpdY1l
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 21:57:08.1890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 443aac8a-2a60-4431-1db9-08deff05fae1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9746

On Thu, Aug 20, 2026 at 07:58:19AM -0700, Ackerley Tng wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> > On Tue, Aug 18, 2026 at 09:15:53AM +0000, Ackerley Tng wrote:
> >> From: Sean Christopherson <seanjc@google.com>
> >>
> >> When handling an RMP fault, KVM retrieves the PFN for a private GPA from
> >> guest_memfd.
> >>
> >> Drop the page reference immediately after retrieving the PFN instead of
> >> holding it across the entire handler so that the later patch can follow up
> >> with completely not returning refcounted pages from kvm_gmem_get_pfn().
> >
> > Regarding this point:
> >
> >>
> >> On a first look, existing RMP table handling (psmash and checking for
> >> errors) might seem like it works fine, since truncation of the page from
> >> guest_memfd would have called rmp_make_shared() and removed the PFN from
> >> the RMP table. However, that is insufficient since a freed page may already
> >> be used in a different SNP VM.
> >
> > In the code this patch is applied on top of, I think the kvm_gmem_get_pfn()
> > ref is enough to avoid the reused-by-another-SNP-VM scenario until after
> > caller releases the ref, so I think the above explanation should be adjusted
> > to also be preparatory for "the later patch".
> >
> 
> I think this sequence of events is possible:
> 
> CPU 0: sev_handle_rmp_fault()
> CPU 0:   kvm_gmem_get_pfn()
> CPU 0:     filemap_invalidate_lock()
> CPU 0:     refcount++
> CPU 0:     filemap_invalidate_unlock()
> CPU 0:     refcount-- <<== because kvm_release_page_unused(page);

Prior to this patch, the kvm_release_page_unused() isn't done until
after the snp_lookup_rmpentry()/snp_rmptable_psmash().

It's possible CPU 1 truncate sequence below can run concurrently
after filemap_invalidate_unlock() above, but even though it calls
free_folio(), which might zap the RMP entry, the filemap code will
only put the refs that it has on the folio so it wouldn't actually
get freed back to the buggy allocator, so it doesn't seem like the
psmash-another-guest scenario is reachable. I could certainly be
misreading things though.

The psmash-a-now-shared-entry scenario because of a race with the
VMM/truncate path seems possible prior to this patch, but that's
pretty similar to the psmash-a-now-shared-entry because of a race
with the guest scenario and which would generate spurious warning
messages to console, and that would be similarly addressed via
patch 1 I think. I'm not sure 

-Mike

> 
> CPU 1: truncate()
> CPU 1:   filemap_invalidate_lock()
> CPU 1:   refcount--
> CPU 1:     kvm_gmem_free_folio()
> CPU 1:       sev_gmem_make_shared()
> CPU 1:     folio is freed
> CPU 1:   filemap_invalidate_unlock()
> 
> CPU 2: in some other SNP VM,
> CPU 2: kvm_gmem_get_pfn() gets the freed folio
> CPU 2:   sev_gmem_make_private()
> 
> CPU 0:   snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>            <<== it's assigned but to some other SNP VM
> CPU 0:   snp_rmptable_psmash(pfn);
>            <<== this psmash would be smashing in some other SNP VM
> 
> And hence I think we do need to check for invalidations using the MMU
> invalidation protocol.
> 
> > Other than that:
> >
> > Reviewed-by: Michael Roth <michael.roth@amd.com>
> >
> >>
> >> Hence, adopt the MMU invalidation protocol to guard committing anything
> >> based on the PFN.
> >>
> >> Signed-off-by: Sean Christopherson <seanjc@google.com>
> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >> ---
> >>  arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++++---------------
> >>  1 file changed, 24 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >> index b2738362a928b..b34b11d7f8fad 100644
> >> --- a/arch/x86/kvm/svm/sev.c
> >> +++ b/arch/x86/kvm/svm/sev.c
> >> @@ -5003,6 +5003,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> >>  	struct kvm_memory_slot *slot;
> >>  	struct kvm *kvm = vcpu->kvm;
> >>  	int order, rmp_level, ret;
> >> +	unsigned long mmu_seq;
> >>  	struct page *page;
> >>  	bool assigned;
> >>  	kvm_pfn_t pfn;
> >> @@ -5030,18 +5031,22 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> >>  		return;
> >>  	}
> >>
> >> +	mmu_seq = kvm->mmu_invalidate_seq;
> >> +	smp_rmb();
> >> +
> >>  	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
> >>  	if (ret) {
> >>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
> >>  				    gpa);
> >>  		return;
> >>  	}
> >> +	kvm_release_page_unused(page);
> >>
> >>  	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> >>  	if (ret || !assigned) {
> >>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
> >>  				    gpa, pfn, ret);
> >> -		goto out_no_trace;
> >> +		return;
> >>  	}
> >>
> >>  	/*
> >> @@ -5069,27 +5074,31 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> >>  	if (rmp_level == PG_LEVEL_4K)
> >>  		goto out;
> >>
> >> -	ret = snp_rmptable_psmash(pfn);
> >> -	if (ret) {
> >> -		/*
> >> -		 * Look it up again. If it's 4K now then the PSMASH may have
> >> -		 * raced with another process and the issue has already resolved
> >> -		 * itself. If it's not assigned, then this must have raced with
> >> -		 * another process that made this page shared.
> >> -		 */
> >> -		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
> >> -		    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
> >> +	scoped_guard(read_lock, &kvm->mmu_lock) {
> >> +		if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
> >>  			goto out;
> >>
> >> -		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
> >> -				    gpa, pfn, ret);
> >> +		ret = snp_rmptable_psmash(pfn);
> >> +		if (ret) {
> >> +			/*
> >> +			 * Look it up again. If it's 4K now then the PSMASH may
> >> +			 * have raced with another process and the issue has
> >> +			 * already resolved itself. If it's not assigned, then
> >> +			 * this must have raced with another process that made
> >> +			 * this page shared.
> >> +			 */
> >> +			if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
> >> +			    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
> >> +				goto out;
> >> +
> >> +			pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
> >> +					    gpa, pfn, ret);
> >> +		}
> >>  	}
> >>
> >>  	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
> >>  out:
> >>  	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
> >> -out_no_trace:
> >> -	kvm_release_page_unused(page);
> >>  }
> >>
> >>  static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> >>
> >> --
> >> 2.55.0.699.gb54405d56f-goog
> >>
