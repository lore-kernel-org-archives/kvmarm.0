Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13B5361966;
	Tue, 29 Sep 2026 07:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790666173; cv=none; b=HJDgLODr2hlwfE/OJpuHx7pwJRXXHzr+dYS+qv/fXfJtIFrFCan6XBZyx6n+c3/E7jQA4/fCPFlJpN4X/qE7knEWG9b6UgfF+MNFeNgfEpamfFOE4qrZ1cZQpRSe6lQdbvZfZk1hdUcDqgOql+mCC4bTMz+QawBCI8eD3SQGSYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790666173; c=relaxed/simple;
	bh=1KNSDVRh0rJHFPY3GyssGJ8thgeS3VYVzNRHLPdERFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c/pMLv0MYTtkaCgpTAnCahWzsp+Zm8U/az6/Z6hXjuZpC+TTk4eI7/p29gHaPqvTGFaReMXctub+A29ChQZgdAmDz+59d5CNZiUDH3X063Z/7tySI1r9Xu8ZIYYEVWHjp9Ss95KpyrqMzFMQFrf+bEvNSkm04SRXaMRJ3tuKNZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pnv94pym; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pnv94pym"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68T46KHA3076706;
	Tue, 29 Sep 2026 07:15:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FZ9Juu
	Ss/D+akfl91xU7OP2eBpxBAvfXWSZY4zEvYBU=; b=pnv94pymYS0IkF3b2G50M4
	RVkV8lncqhwY25+KxnAPc7KJwZVwdpd0iKVIrj4PwxwfYDMRh5T+oR2yEtuzPbH2
	kdv9XrbE4eQtQLFmYta2zPltzRW7rhH586EJ2ybEDNqh8OSAuakepqe+7Pt4n5mP
	DGX5X/mETzLJG1sXOqDhr2Rb9wpxG36dw3L/5R+pFX+nps9uXskpE6ZIFYlEJcWJ
	g08Vtu+2FfMj+4am4v8c63suUwZPSmRO2N3qPwVCozQd+Ycy+/YuLD8AUcNxhXzb
	L8/IXF/12LKdKDVVQyMOqk7m12zbbTGC4wNJ68wXadbZIqsb5kDKowEw1/TRnTvQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5j55tup-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 07:15:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68T4HjaP4070253;
	Tue, 29 Sep 2026 07:15:47 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxtkg8h5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 07:15:47 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68T7F1jI63111648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Sep 2026 07:15:01 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B92B5803F;
	Tue, 29 Sep 2026 07:15:45 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7B0358056;
	Tue, 29 Sep 2026 07:15:33 +0000 (GMT)
Received: from [9.39.21.128] (unknown [9.39.21.128])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 29 Sep 2026 07:15:33 +0000 (GMT)
Message-ID: <e5a70518-9dfb-47e5-ac32-58b75c07a858@ibm.com>
Date: Tue, 29 Sep 2026 12:45:30 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/20] KVM: selftests: PPC pre-enabling
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>,
        David Hildenbrand <david@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        Itaru Kitayama
 <itaru.kitayama@fujitsu.com>,
        Nicholas Piggin <npiggin@gmail.com>
References: <20260902164123.2546762-1-seanjc@google.com>
Content-Language: en-US
From: Anushree Mathur <anushree.mathur2@ibm.com>
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDAyOCBTYWx0ZWRfX4W62F1yk8l8n
 XRhO7dxw6DEBdNCkzVHNd7rm217fvhWBjLGNh2KVb7AZ6oSj/1GseOaZgbN6WYJGep0nXfw82O7
 jJOdA+BHclkxjO9Ket6CpoVz9mTJDmQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDAyOCBTYWx0ZWRfX29hXdJK+LPTK
 cxwZVEFGcWGq/Mgo5FUIs2Vb4htVFQjwN8KlZwtb4sjWi5GeUTQcnBZbpE1O091Ihohaeuh5qkR
 SLpswNapgrgeZaNwRvBWGshWh7SXpWZgnE3wlbUUG8uCHLJnYNHq3PzZ/6PO4ms+P9cf1E8kgMY
 9/GzKedeG8bpauhAcmM9Si0xRO+IzkXkqqbrkBV2yTKLPErnsIB9vtqbLM3S8SvO+uhIRBKupnc
 XLHQRfxTuk3WJIgYj1huHrtlzo4qHBfCjMIkb+EXNecZLXBk7ls9pat6npTqb56LiPtrNmbg5/h
 v1nDPuLvnwRP6XLiA4YRRw9MfHFT5zP1/vQQh/rgnHbqWeHrsgLfHlR5NVZK4aZy05CsaHl5QEA
 sPXalB7Hzb37c68E5EyXRywagkkFFrGZ1FcWNV4uV2zUQPqqU/b51FTOrRFYoqOZnQSvrSVpsWY
 iup3H4jBaxT2Nyul/yw==
X-Proofpoint-GUID: lq-aGJq6ZdFWNGe-LVvOh1HYDcJzNXa4
X-Authority-Analysis: v=2.4 cv=RKcmjIi+ c=1 sm=1 tr=0 ts=6abb65a5 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=zvVxG0z6fLcq2R3n2ywA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: pfPYA5yzPUw02pptXEK0MLlNkLCDJqba
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290028


On 02/09/26 10:11 PM, Sean Christopherson wrote:
> This is a big pile of cleanups and refactoring to prepare for PPC support in
> KVM selftests.  PPC has paging modes that require multi-page page tables, and
> those page tables need to be naturally aligned.  The original proposal was to
> plumb in an @align param to the page allocators[*], but I didn't love the idea
> of adding another rarely used param to the allocators.
>
> v2:
>   - Collect tags. [Itaru, Bibo]
>   - Use 0x180000 as the min GPA for page table pages on LoongArch, instead of
>     changing every other arch to use 0x200000. [Sashiko, Bibo]
>   - Opportunistically move the vGIC LPI stress test's global "gpa_base" variable
>     into setup_memslot(). [Sashiko]
>
> v1: https://lore.kernel.org/all/20260826230511.972824-1-seanjc@google.com
>
> [*] https://lore.kernel.org/all/df86b5ccdbdafc3509d9538bd5e6796737bab2db.1781093720.git.ritesh.list@gmail.com
>
> Nicholas Piggin (1):
>    KVM: selftests: Use goto instead of do-while to retry finding unused
>      physical pages
>
> Sean Christopherson (19):
>    KVM: selftests: Use MEM_REGION_PT memslot instead of '0' for s390
>      regions/segments
>    KVM: selftests: Use the common minimum GPA for page tables on
>      LoongArch
>    KVM: selftests: Use vm_alloc_page_table() to allocate LoongArch page
>      tables
>    KVM: selftests: Rename "num" param to "nr_pages" for physical page
>      allocators
>    KVM: selftests: Extend page allocator to support naturally aligned
>      allocations
>    KVM: selftests: Make the single-page allocator APIs static inline
>    KVM: selftests: Use the innermost page allocator API in the memslot
>      perf test
>    KVM: selftests: Use the innermost page allocator API in s390's IRQ
>      routing test
>    KVM: selftests: Add a wrapper API to allocate multiple page table
>      pages
>    KVM: selftests: Initialize vm->memslots[] with invalid memslots during
>      creation
>    KVM: selftests: Add APIs to override memory region types with custom
>      memslots
>    KVM: selftests: Add TEST_EXTRA memory region type for "special"
>      memslots
>    KVM: selftests: Use TEST_EXTRA region in arm64's vGIC LPI stress test
>    KVM: selftests: Use TEST_EXTRA region in x86's smaller MAXPHYADDR test
>    KVM: selftests: Use TEST_EXTRA region in set memory region test
>    KVM: selftests: Take the memory region type, not memslot, in page
>      allocators
>    KVM: selftests: Use TEST_ASSERT(), not assert(), in
>      vm_get_mem_region()
>    KVM: selftests: Automatically pick min_gpa for allocations based on
>      region type
>    KVM: selftests: Add arch hook to force page tables to be naturally
>      aligned
>
>   .../selftests/kvm/arm64/page_fault_test.c     |  18 ++-
>   .../selftests/kvm/arm64/vgic_lpi_stress.c     |  21 ++-
>   .../testing/selftests/kvm/include/kvm_util.h  | 106 +++++++++++++--
>   tools/testing/selftests/kvm/include/x86/smm.h |   2 +-
>   .../selftests/kvm/lib/arm64/processor.c       |   4 +-
>   tools/testing/selftests/kvm/lib/kvm_util.c    | 127 +++++++++++-------
>   .../selftests/kvm/lib/loongarch/processor.c   |   5 +-
>   .../selftests/kvm/lib/riscv/processor.c       |   4 +-
>   .../selftests/kvm/lib/s390/processor.c        |   7 +-
>   .../testing/selftests/kvm/lib/x86/processor.c |  15 ++-
>   .../testing/selftests/kvm/memslot_perf_test.c |   3 +-
>   tools/testing/selftests/kvm/s390/cmma_test.c  |  19 +--
>   .../testing/selftests/kvm/s390/irq_routing.c  |   2 +-
>   .../selftests/kvm/set_memory_region_test.c    |   8 +-
>   .../x86/smaller_maxphyaddr_emulation_test.c   |   9 +-
>   15 files changed, 221 insertions(+), 129 deletions(-)
>
>
> base-commit: 76671054f9a1ff6abb976583cd8da37650acdc97

Hi Sean,

Thanks for working on this patch series. I tested this series (v2) as a 
base
for Ritesh's PowerPC KVM selftest series (v5) [1] on two real 
PowerPC(ppc64le)
PowerVM & PowerNV systems. Your patches applied cleanly and the core 
infrastructure
changes worked correctly on PowerPC — exactly the foundation Ritesh's 
series needed.


Ritesh's patch series : 
https://lore.kernel.org/linuxppc-dev/cover.1790101179.git.ritesh.list@gmail.com/

Full test suite summary (make run_tests):
-----------------------------------------
                                    LPAR    bare-metal
   demand_paging_test               PASS      PASS
   dirty_log_test                   PASS      PASS
   dirty_log_perf_test              PASS      PASS
   guest_print_test                 PASS      PASS
   hardware_disable_test            PASS      PASS
   kvm_binary_stats_test            PASS      PASS
   kvm_create_max_vcpus             PASS      PASS
   kvm_page_table_test              PASS      PASS
   set_memory_region_test           PASS      PASS
   memslot_modification_stress_test PASS      PASS
   memslot_perf_test                PASS      PASS
   access_tracking_perf_test        PASS      PASS
   irqfd_test                       SKIP      SKIP
   vm_types_test                    SKIP      SKIP
   --------------------------------------------------
   Total                         12 PASS   12 PASS
                                  2 SKIP    2 SKIP

My Detailed testing analysis for your patches on PowerPC (ppc64le):
-------------------------------------------------
Patches 1-5 [Page allocator and memslot refactoring]
   Core page allocator and memslot infrastructure exercised by all 14
   tests on both systems — no regressions observed.

Patches 6-10 [Extended page allocator APIs]
   Exercised via kvm_create_max_vcpus and memslot_perf_test on both
   systems — APIs work correctly on PowerPC.

Patches 11-13, 16 [Memslot initialization and TEST_EXTRA region]
   set_memory_region_test and memslot_modification_stress_test ran
   successfully on both systems — memslot init, TEST_EXTRA region, and
   its usage in set_memory_region_test all working correctly.

Patch 17 [Memory region type API]
   Exercised by set_memory_region_test — PASS on both systems.

Patch 18 [Use TEST_ASSERT() in kvm_util.c]
   Exercised by all tests — no assertion failures observed.

Patch 19 [Auto-pick min_gpa for PowerPC]
   This is the critical patch for PPC — guest physical test memory
   was correctly placed above 256M on both systems:
     LPAR:       guest physical test memory: [0xfffffbfff0000, 
0xfffffffff0000)
     bare-metal: guest physical test memory: [0xfffffbfff0000, 
0xfffffffff0000)

Patch 20 [Add arch hook to force page table setup]
   lib/powerpc/processor.c correctly hooks into this — guest page
   tables set up correctly on both systems.

Note: Patches 14 and 15 (arm64/x86-specific TEST_EXTRA usage) were
not exercised as those tests don't build on PowerPC — as expected.


Please feel free to add :

Tested-by: Anushree Mathur <anushree.mathur@linux.ibm.com>

Thank you,
Anushree Mathur

