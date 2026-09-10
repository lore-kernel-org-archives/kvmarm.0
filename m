Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A75E3AC0E4;
	Thu, 10 Sep 2026 10:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036187; cv=none; b=UpPKgHgaOMq0V0Eta7lXEnR6PREvPhLKV4cthWj0ndoO3q0Hke9+aVr3axZfFSXQYudMjBCmFfNGgES3RhsCnVx168EXOGT72x+XVp4BACeMZfUIaUC9tLAJF2456IM5agrcugHAJYd3lojVbVy64iJnvffPCm6fCMb2okUZCRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036187; c=relaxed/simple;
	bh=X/ExvWMbnC9BjKuES/JAQGjX1zpRKHVbT9dgRuCqoiE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q5MMcc7oBnL65PabAWs7U5nIXEVUxig0nUcUn1d/fw8QtLe2YLeMoJfTA2OWkb95Tmna1xiUL6mKGxyCC1u+h8bPzWJVJ4LTytQULPI+KZzsWMSP+BLRZC3VaTNjDHrhV7bGqZq567UsQA+oPsltk0q7cl7BugQBWHv1IF/P3Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PzGzUJvI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PzGzUJvI"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A91RYP2446610;
	Thu, 10 Sep 2026 10:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=waamOS
	IbHPnfCUnZfts+Hg3jdCVNrRkST8I/4+mXjcU=; b=PzGzUJvIA41pEq8kh7MK6Q
	4uSkOuVBWinXgCITqDlrC0tt8uc/qLThj7oljQkvhv7t6o8mWumAb845b5Qi3B1M
	qcFKDYWPVmb8rRFQdX5pqGpAnzflSQvNPZALJhqaISetL4UAOzApNFPNdGC6kOSK
	ytD4kHgT69jL3TSY5yJQg5nxhpX1wzsQ3mWF78e6lok/6mCweWfGlWVKtGML0Bxk
	c74O5K1jobLc2V9sG46rMTtshl5mqzl1n2800UPwR0tSE2VHW8qm/6EC/uf5OIei
	2vlrHaVCbgGveno3qrtgpoOMSttsXfbNR0RN+GPjVwN+ix4HC4MX1jPOGt7VpZkQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8pkwj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 10:29:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 68AAQKfn031287;
	Thu, 10 Sep 2026 10:29:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkcr3bvdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 10:29:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68AATI0Y34079172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 10:29:18 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 310972004D;
	Thu, 10 Sep 2026 10:29:18 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CAC0D2004B;
	Thu, 10 Sep 2026 10:29:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.48.108])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 10 Sep 2026 10:29:15 +0000 (GMT)
Date: Thu, 10 Sep 2026 12:24:14 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Paolo
 Bonzini <pbonzini@redhat.com>,
        Tianrui Zhao <zhaotianrui@loongson.cn>,
        Bibo
 Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
        Anup Patel
 <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
        Palmer Dabbelt
 <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly
 <joey.gouly@arm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Suzuki K
 Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Atish
 Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>,
        David
 Hildenbrand <david@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, loongarch@lists.linux.dev,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Itaru Kitayama <itaru.kitayama@fujitsu.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH v2 01/20] KVM: selftests: Use MEM_REGION_PT memslot
 instead of '0' for s390 regions/segments
Message-ID: <20260910122414.5c442a45@p-imbrenda>
In-Reply-To: <20260902164123.2546762-2-seanjc@google.com>
References: <20260902164123.2546762-1-seanjc@google.com>
	<20260902164123.2546762-2-seanjc@google.com>
Organization: IBM
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=eM2GH3p1 c=1 sm=1 tr=0 ts=6aa28684 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=1XWaLZrsAAAA:8
 a=omOdbC7AAAAA:8 a=VnNF1IyMAAAA:8 a=hQRZ-KwT_607qTx81aAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: EI-6TEyGnobs-jfk7mjk7oOMjUqKJfUX
X-Proofpoint-GUID: PmHBFQMOSiPjT9cSxDj_2mJ3vQDK-9Am
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDExNSBTYWx0ZWRfXw05gKMgq5FQE
 A5EFyYi79yUlvRQ5PUEw5pNrXcdWhpSF0mkHopyKPAIBM6kOsbtCe0miXsR2sw8xf24PyR6slr2
 0bg43/214DH4AQhkn0rx4VZv6jZCtLE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDExNSBTYWx0ZWRfX5IiV9GewViX5
 pm5vhl3+c0M2Sq8zJJrljb6KRh4GRxnZseL6dHi2M6AmNyIukE9is3BkBsgBxWaaPZQIO1Fe7K1
 Pc2GoAKCN3gaIOH8rcehWJbTCPsBoDJUNdzwz9XoxNiFxx602IJ/jdLDon2lDxAa6iQGrcvukxV
 zW/eWVQ/DjLMOcOQaVxvnCl2vrSgcuN9m0Nc23MB/8uLQjdPtEvkfWTk9pR9QJFI3k6WgVErMSY
 RyRfFZeqN+3eTDy+MkDYue1fiojJ+ZLMlkHAaQP7uRCs4jNBdtLChB6zSaAodux2PXYps/sVbjD
 +PloHOtmYldrmzgiyXNCzb3tcc9SatlycNVYdz2Hs4HXr6orTw578Beqgv1qajiAJtmZ+HGcRCt
 cS41Sy2x+Dxmwl1o4CcLP4vUKtu6XWAySGyDChjUdyoWCgMgfemDsuSRxWXKFp7tB/04F+s3QcR
 4pzbRudrjqu9Luw5Pvg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100115

On Wed,  2 Sep 2026 09:41:04 -0700
Sean Christopherson <seanjc@google.com> wrote:

> Use MEM_REGION_PT to indirectly specify memslot '0' instead of hardcoding
> the memslot in s390's virtual memory allocator, as a first step towards
> taking the allocation type instead of the exact, raw memslot in the
> physical memory allocator.
> 
> Note, the only tests that set MEM_REGION_PT to a memslot other than '0' are
> arm64-only, i.e. s390 always uses memslot '0' for page tables.
> 
> No functional change intended.
> 
> Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  tools/testing/selftests/kvm/lib/s390/processor.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
> index a9adb3782b35..fb9dab92d4d1 100644
> --- a/tools/testing/selftests/kvm/lib/s390/processor.c
> +++ b/tools/testing/selftests/kvm/lib/s390/processor.c
> @@ -39,7 +39,8 @@ static u64 virt_alloc_region(struct kvm_vm *vm, int ri)
>  	u64 taddr;
>  
>  	taddr = vm_phy_pages_alloc(vm,  ri < 4 ? PAGES_PER_REGION : 1,
> -				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> +				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> +				   vm->memslots[MEM_REGION_PT]);
>  	memset(addr_gpa2hva(vm, taddr), 0xff, PAGES_PER_REGION * vm->page_size);
>  
>  	return (taddr & REGION_ENTRY_ORIGIN)

