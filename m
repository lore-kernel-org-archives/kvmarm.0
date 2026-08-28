Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96202343D86;
	Fri, 28 Aug 2026 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787939953; cv=none; b=CHLqt7Fv478Eb2ciK8zmDisKQhIA+PHtsHbWLKVyrexTbqVGN42hHYkypFaMP2GxvL676cNnufp7ReDhPjuZ8jKJFK4XpRKwu8LNqHLfamcqWr8XS9Iep6dUsg7wZs+CjuQENBRyWzbIr3722rzT90yKmc8xOuaJPDF3/O9oJ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787939953; c=relaxed/simple;
	bh=AXZDVDkzkAENtUyn357mFS4vmqmHwbxegiYqabISVi8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZPDimc83PCpyT4knP4Wd5FwV5tM1TQlHptiOHJUu4fHjjAito1w8/a0LiJIJflZgma30qJWYyG5esS9cmHKPJCRENPYyVI5nH3Q2KFvwJS3TRHWRIebmt9DshB7ATwsrvb1QuWf9xu1l3OzIV8xGB/wxBcn4x7MxNlVN3gfRBK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pFEzQ2Wr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pFEzQ2Wr"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67SGVluO721927;
	Fri, 28 Aug 2026 17:58:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AZFBZK
	lZxOOnh7LYWP8T1WR9V2U7Ewlnl/05R2xnW1w=; b=pFEzQ2Wrc0RQAapmmBD6W2
	GKyaFb0C3hjy2/vyaTApogAFCjrZ/timR10B8bIJckCxkX5I3dz7BnaOfraFk3tO
	tkBnbLAepDkYENxlTFqQLPAJqQfDFHTmSmzVtQIU8M76oTzE7YRFqIdjtjOPAhd7
	vD5k6zT1FQKzUArFLbkkhNT3QC5OUNb4hjCfAcWPFI9dqasPHHP7X6u3XmVxEuEZ
	QkHDi07Lb0S6Jkdu9+icPYAyIv7lbI0Pbj4qXkflPyllXE6NCrXXc76fQA2uipPD
	LKj6Wrqs4w6IdnFXw7mbU7WB5JdEyRgQ4vrXikpcGexzZo/Ka2q9VLI5PTVb5IWw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73ere7uh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 17:58:55 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67SHuWfi008298;
	Fri, 28 Aug 2026 17:58:54 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7rsyqqjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 17:58:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67SHwo5W38338878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Aug 2026 17:58:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 831A020040;
	Fri, 28 Aug 2026 17:58:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20D1E20043;
	Fri, 28 Aug 2026 17:58:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.224.75.30])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 28 Aug 2026 17:58:50 +0000 (GMT)
Date: Fri, 28 Aug 2026 19:58:48 +0200
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
        linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Ritesh
 Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 02/20] KVM: selftests: Bump the minimum GPA for page
 tables to 0x200000
Message-ID: <20260828195848.2d14e9aa@p-imbrenda>
In-Reply-To: <20260826230511.972824-3-seanjc@google.com>
References: <20260826230511.972824-1-seanjc@google.com>
	<20260826230511.972824-3-seanjc@google.com>
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
X-Proofpoint-GUID: 6HLzcE55zTkKQP62ckFMr43JzrkoC_oe
X-Proofpoint-ORIG-GUID: _S2ZlVd_KKoZRw557abXl1I420nQqrgM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI4MDE1MyBTYWx0ZWRfX0qLLxglo25xX
 c0LNE8XwpN3clTQ27kM5obCN/mEKCM9T/V2UrYDQGoDeLX/sVrfZOyt/r6/j4m6ZL9tZwwdloCX
 4ypWX+xcPPxfyFFj9CzHJ+H1Jy+Nesr9gJfeq0vFd2dplKnzTWJssOegw+X8u4WcEZkJzQEUZze
 fMhRqtdMmDyXsI5MbPZ0klTINPE7IkclPa0O3GRO+hXLWMcECgv1UVnO0USv3G3nQs2z/fAyFHt
 gNF+rh3+M4hf2TlE3OLLpCOZzZ0quhk9kQX7DNKwRaTTPu9yI5FGeBiu38rACVpkLaS76RTvvwk
 ELUm+pM5KW56fI0RwGoW8Y541MsPZt4YlDLI0plXmqCecpK+KMoc14R0xuC6t5Q+da6p9BTxg9I
 Z2MJP0donTGv3lcaG4UoyVdwmTdFs+WvA2dxyIbg21fJJAVArBBYfJ7ZgKbehjiHOWklyrh9NP/
 jx1EDxOnKwX5OS/aUiA==
X-Authority-Analysis: v=2.4 cv=QsRuG1yd c=1 sm=1 tr=0 ts=6a91cc60 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=1XWaLZrsAAAA:8
 a=Rex0ZKQa4XsKW5WIoWMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI4MDE1MyBTYWx0ZWRfX/pS+uSLiiIVc
 dz0zFaQHlHiFiK9bsIl+xi1GR3ZuN8ixPgN9QIrOdnh1lnLipbWGJZ07LBCw2zrVE6icQuqM30v
 TB/vJ8xy+UMB1HVhNbAWSTx71V1+vCs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-28_05,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1011 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608280153

On Wed, 26 Aug 2026 16:04:53 -0700
Sean Christopherson <seanjc@google.com> wrote:

> Bump selftests completely arbitrary minimum GPA for page tables from
> 0x180000 to 0x200000 (LoongArch's minimum), so that LoongArch can use
> vm_alloc_page_table() instead of open coding a rough equivalent.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 5a7a455b5387..70906a0d1003 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -175,7 +175,7 @@ static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
>  
>  /* Minimum allocated guest virtual and physical addresses */
>  #define KVM_UTIL_MIN_VADDR		0x2000
> -#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
> +#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x200000
>  
>  #define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
>  #define DEFAULT_STACK_PGS		5

this breaks s390/cmma_test

I tried a quick fix, but nope... I will need to actually invest some
time (i.e. next week) to understand why the quick fix is not enough,
and come up with a proper fix

the good news is: it seems like cmma_test is the only test that is
negatively affected by this series.
