Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B766375AC6;
	Wed,  2 Sep 2026 17:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371608; cv=none; b=RvwxXH/iD90r4JaAaljljZKrnPzelxabAeyZRAKJ+lywClvBuLaRztZe8Lt7zdbDRIbdVCMn/TbnY2KfAn8KvDPLoo61z5gxNGdSreMTFtuHS5IUSJ9GW1NdtbwJGxi8zVVOsZ1i1lDp61ZOstfXNaAyGOUp+ikWH/v8+/lzvXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371608; c=relaxed/simple;
	bh=dyh7ILGt/5bnqrxN/82cJKg11APh3cjiuInQFL4QqTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=twEQnp/MiPxyHiD6lf6UssGC8YmXfcaYw7zpjM9T5jkgGWfb2GT+FSYrqCnTgWHUfs1WcQk48rRkl2vy9/06F8XfwbydTwsDpCiHNjRsGMLr05cLhjLO1ylHTPsHvMuG2V0h1O7d6H5Out/SRZzudlKFhx3C2o1c5MvXgmQcE1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Kl7F9Iaj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Kl7F9Iaj"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682HVXkT661027;
	Wed, 2 Sep 2026 17:53:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Z5Mx7pUcQEWw6958PrVztMt4sVddKW
	IBqx2O5XqkO4g=; b=Kl7F9Iaj1Wj0WVPY06x0K3s7OieHalr8udYeelTcQj4IFg
	QspF/kV6Coe4W9VNbHy3XurvuE9Hz5jM0eeuW1HZiNd5BnP+as1p+pWzfKD2mVUw
	fA0JQRaJq1R57yWL9CQGSZmp3ddzzd1l/eZ8zbS0s0CcDee7NYl/4bIE7l9+jEDL
	J4HvH6BIO1L6PbHpxpYmOzvuzZ2IOalt3EeNOxxTczPPt9sYR9XRFRESVfmPJfcw
	Rd/6yHCDMOBuIDMyI7EsqSmipPcFhX0pL0KiVXR1Y8hR+dcoVOtOZ4+lshw006HJ
	pR6tmyyMqvMpXuK0SR4L4yVbLjgtIe+RckoK7TnQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx5reet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 17:53:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 682HQqsN023357;
	Wed, 2 Sep 2026 17:53:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gc9rqkk9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 17:53:08 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 682Hr5jQ41025946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Sep 2026 17:53:05 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23BAA20043;
	Wed,  2 Sep 2026 17:53:05 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94A1020040;
	Wed,  2 Sep 2026 17:52:58 +0000 (GMT)
Received: from Gautams-MacBook-Pro.local (unknown [9.124.221.176])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  2 Sep 2026 17:52:58 +0000 (GMT)
Date: Wed, 2 Sep 2026 23:22:55 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>,
        Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, loongarch@lists.linux.dev,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 11/20] KVM: selftests: Initialize vm->memslots[] with
 invalid memslots during creation
Message-ID: <aphidyVJw_j5b8pL@Gautams-MacBook-Pro.local>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826230511.972824-12-seanjc@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a986286 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=1XWaLZrsAAAA:8
 a=VnNF1IyMAAAA:8 a=j0vlev5UKZ0XSpOR6SEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: B-26trKXd9pVuyMcjGDdunnEDwdCRBn4
X-Proofpoint-ORIG-GUID: SVpS2ZNVk7INULrkMzze52nCa4H5mh38
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE1NCBTYWx0ZWRfX5veu8oVSGtFL
 favKqRfMMPGUpjq4PTqJ18XSkuPQYzWpfq5wf2GXUmfefiq71VDO1NarNlp3jSmkqF61O7ekxl+
 A1nCjtO2k+K0ZXc18KRI2vfHVH3745s=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE1NCBTYWx0ZWRfX5d6AwSpOb0Y/
 FyBCcxlZIE+eC4Sp0qMzuoS0AMYRuLuOT2NyASUAT4cImQEIJ7uoRRwzgZ/65UUcs9wQH1OBaNy
 CRDTAA+QRJWF3llei9ZPnAJvxvirdYRiW1kMgZE0fSSHjibvUNi5yvxIszacfXkkB+Wx5m6Lp19
 T2GwOgxzrFlM8A0dAiEJHCmZEz36KUxIp6PSqV4qrHPuDOa8PtdbzANtBnkWsNGVXW+FXvJoVtJ
 cKE6OVQNNvIiWjGgixQQI/4gY0XLIgdSwrpaAQ+Ke4YZxbw2eTVviJHQM9EXkj3tu25Uj3Ox217
 BH8DCTfoGr+bQuoOrMtFMA8A7pUPwIcmiHEKA78S3VpIpq+02I98RAhGPA1o8UXOrK2MZ9tuQ++
 kZ2mumsQFns9oz1g9ozsENzDL9svHMSymwm9SC7489wKpmLu3DVoOqWn1r85Ws3vxwd/2nb8+N7
 JDV3Gtusc99qmVIYp/w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_04,2026-09-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020154

On Wed, Aug 26, 2026 at 04:05:02PM -0700, Sean Christopherson wrote:
> Initialize vm->memslots[] with an invalid memslots value during very
> initial VM creation so that failure to configure the core memory regions
> generates an immediate assert instead of potential weirdness, e.g. if slot0
> is coincidentally valid.  This will also allow hardening the region APIs to
> guard overriding a region's memslot multiple times.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h  | 2 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
>  tools/testing/selftests/kvm/lib/x86/processor.c | 5 ++++-
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 21354434de0a..70e77992dd2f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -33,6 +33,8 @@
>  
>  #define NSEC_PER_SEC 1000000000L
>  
> +#define KVM_INVALID_MEMSLOT UINT_MAX
> +
>  struct userspace_mem_region {
>  	struct kvm_userspace_memory_region2 region;
>  	struct sparsebit *unused_phy_pages;
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index ce0d8fba4624..56df5b1d9c79 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -288,6 +288,7 @@ __weak void vm_populate_gva_bitmap(struct kvm_vm *vm)
>  struct kvm_vm *____vm_create(struct vm_shape shape)
>  {
>  	struct kvm_vm *vm;
> +	int i;
>  
>  	vm = calloc(1, sizeof(*vm));
>  	TEST_ASSERT(vm != NULL, "Insufficient Memory");
> @@ -296,6 +297,8 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
>  	vm->regions.gpa_tree = RB_ROOT;
>  	vm->regions.hva_tree = RB_ROOT;
>  	hash_init(vm->regions.slot_hash);
> +	for (i = 0; i < NR_MEM_REGIONS; i++)
> +		vm->memslots[i] = KVM_INVALID_MEMSLOT;
>  
>  	vm->mode = shape.mode;
>  	vm->type = shape.type;
> @@ -1190,6 +1193,8 @@ memslot2region(struct kvm_vm *vm, u32 memslot)
>  {
>  	struct userspace_mem_region *region;
>  
> +	TEST_ASSERT(memslot != KVM_INVALID_MEMSLOT, "vm->memslots[] unpopulated?");
> +
>  	hash_for_each_possible(vm->regions.slot_hash, region, slot_node,
>  			       memslot)
>  		if (region->region.slot == memslot)
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index d31fa81ea075..ea5fa59888af 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -529,7 +529,10 @@ void tdp_identity_map_default_memslots(struct kvm_vm *vm)
>  
>  	/* Only memslot 0 is mapped here, ensure it's the only one being used */
>  	for (s = 0; s < NR_MEM_REGIONS; s++)
> -		TEST_ASSERT_EQ(vm->memslots[s], 0);
> +		TEST_ASSERT(!vm->memslots[s] ||
> +			    vm->memslots[s] == KVM_INVALID_MEMSLOT,
> +			    "Unhandled memslot '%u' for type '%u'",
> +			    vm->memslots[s], s);
>  
>  	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
>  	last = i + (region->region.memory_size >> vm->page_shift);
> -- 
> 2.55.0.887.g758fc8c411-goog
> 

Acked-by: Gautam Menghani <gautam@linux.ibm.com>
