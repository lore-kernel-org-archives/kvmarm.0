Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8180043E48D;
	Fri,  4 Sep 2026 11:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522171; cv=none; b=RtlK2/95ZaeZgAcqZ+qyn3tdN27FYi0HguetMToO1vtEhH+AQOPu2H+OyiRDFzerwGnE6meYTg8PJE+7z/SI5/48LnO1E1oukaQCxvLL4RwSRzIzDKFdXThrNoaifa8D63QjSZrjQL9k1AD9EiBWMZVvFWJy5SP1VwKHtUoTgpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522171; c=relaxed/simple;
	bh=RqBV+FCCJMPhhS4Hj+fmI/FrEC3rPKwpyIsRAiEgqTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsWpk6Nat+9GvB++RPv4iEBK6ql7vK4w2fBURSEP9s+SEKB5PDYKBbcYiA5KL53hg7Xbl0EN/m9myWbxW7/wFRA6gEQdJilmZMkRKVO/7XvlKdItIdO/CyD1GQjT/KuOgYjq9DULe8nPCsPxuj4WkysnrawCDUYCiHjWl2ceIVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nTnws8er; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nTnws8er"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684AVjYt1490808;
	Fri, 4 Sep 2026 11:42:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=4WuBTyk+7ZTl6/gJBor58BJdLTP04b
	Wzoe7W6rw9K+4=; b=nTnws8erhXkreeNw0t3p2smI/8V6K5SqBAIhw/3l0xHAcv
	Erm6mQlRqxvWIJWa/75sWhhYQQGO7OG3KROguMrNg96E/UcRUtRAuGT7vlZfVEXa
	+LB2L+vN11Ir2RcBtltMXPIgNs72wMpUT5MvFd1QuXm0p5mEOMRSBbZ2YChBp+Nn
	wQrqfAj2n8lfJ+dDiyMIOjQApePFDdC+TSl9b9i/lsPUgpc1IDxNNjhH/DkR9pyy
	S4kYXim9axqPSxn8ouoZdOdNIJQRNCK5pYYtkuAPKO2jij4MHvu09pnh9MU7EhwS
	DdhQR/JnhRATbV548EfbGygGySlWx7IO8rv8gltw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx62fwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Sep 2026 11:42:30 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 684BfJ35010880;
	Fri, 4 Sep 2026 11:42:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcarkmthc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Sep 2026 11:42:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 684BgOtV45875696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Sep 2026 11:42:24 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A4B52004E;
	Fri,  4 Sep 2026 11:42:24 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C56DE20040;
	Fri,  4 Sep 2026 11:42:18 +0000 (GMT)
Received: from dhcp-9-123-3-18.bl1-in.ibm.com (unknown [9.123.3.18])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  4 Sep 2026 11:42:18 +0000 (GMT)
Date: Fri, 4 Sep 2026 17:12:16 +0530
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
        linux-kernel@vger.kernel.org,
        Itaru Kitayama <itaru.kitayama@fujitsu.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH v2 11/20] KVM: selftests: Initialize vm->memslots[] with
 invalid memslots during creation
Message-ID: <apqumGjtfOspqygY@dhcp-9-123-3-18.bl1-in.ibm.com>
References: <20260902164123.2546762-1-seanjc@google.com>
 <20260902164123.2546762-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902164123.2546762-12-seanjc@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a9aaea7 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=omOdbC7AAAAA:8
 a=1XWaLZrsAAAA:8 a=VnNF1IyMAAAA:8 a=j0vlev5UKZ0XSpOR6SEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: K127SOBQgi0IcTlk75m4H1_Q2ziHQ3DQ
X-Proofpoint-ORIG-GUID: 95cSaeGsDM3YPyi_8Bstk2nmoY8f_6SX
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDEwNCBTYWx0ZWRfX+sgzR96uIskc
 L1xC/tLwzlhM8mk95oqvrIZaclLg66tCMY22rFeIBPrTvv5ihmMWj6eNhMSs1srj+rCxliAdcON
 MB1TT718cfBrt3yTqsdZISpFSiS2+DM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDEwNCBTYWx0ZWRfX+Ixd/av42HBX
 ozSfb9Bg9GTIg9InKsUPb+Q1ECRhKMO6cfjbAyHxXXuyaO05TIoiGrLl5DZTkYqrgQTv3EF9zJi
 bAx4/ZXSBoOszmum71DGEDteU6eN1I/I88w2wX++X2arV+IBlNmTQc68Ea5hlBXI7r5ufl8CTGK
 rWVD+fZEWvX61zZ9uGC6KqLxsBuQnTzSLV80Uo/SeerZTFh5kAeYBuXvh1tzu0k/XMjR0NxJLbX
 yccoMxaKlczM4Vnsq9AnuLszNasGW4x+lM8ZPWDBaImP3Hm6ct8vqXzQl00tcXBRIUIJHaVssZk
 cukJoCzk5UbokxVLYh785GdUKARY87LKbBCocVhCQ2UFGYcjnt8JIIa5biitmwGT7opLjW6SPKk
 ppoSCGPvqIU0ODB99ArygJ+62g+HIbiPijs30FoEN3zlFgj9U8NkvOkL4RUlZPzW8CjyiX/fPpo
 WdXIQg2mS1vo/oJwbEQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-04_03,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609040104

On Wed, Sep 02, 2026 at 09:41:14AM -0700, Sean Christopherson wrote:
> Initialize vm->memslots[] with an invalid memslots value during very
> initial VM creation so that failure to configure the core memory regions
> generates an immediate assert instead of potential weirdness, e.g. if slot0
> is coincidentally valid.  This will also allow hardening the region APIs to
> guard overriding a region's memslot multiple times.
> 
> Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h  | 2 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
>  tools/testing/selftests/kvm/lib/x86/processor.c | 5 ++++-
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index c56f342b16fd..304ef6af3268 100644
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
> 2.55.0.966.g6673acef38-goog
> 


Acked-by: Gautam Menghani <gautam@linux.ibm.com>
