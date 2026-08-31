Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF34A3DCD95;
	Mon, 31 Aug 2026 11:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788176089; cv=none; b=XLBupDRM2rGLnOLKcimxMCNVuJ/gKUPWZTzRxXvNpwvz4+kAsjEUxOrGA7NKpGwRwiLAHkazfWgaSGOt2+b2cgiD3DA8bxNceOGncqjrJTfdOU2ddt7qgKWmvHZ1n4DNBvotXjOkUqL5UhYsr9qgeaTUfRNrdo0CjoOXpQ9uzCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788176089; c=relaxed/simple;
	bh=7PJSx1TPIkXUgfGs6YC28LZ0MeXxRVZHnnDxcel/S/U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EUR8fu2Opk7zd782Zr8KEt04uwWR3EhW4G9TxfENV2wGjXc1l0ly5PPr3vTZequeatqKFBH0lbUo7n5O3acKNt5fQ5KXQmbkKcrTJL+dUZXSUFxQOg6MzlItkoPdujQX2FPBb2ulW6FgFUH4q1ebzbBxfTwU9OYzOFPJKJcnXPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VPqd2baD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VPqd2baD"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VBVmid956691;
	Mon, 31 Aug 2026 11:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=aRirk3
	u9Lgkg4mvt96x9s0nI8fUpFoM850JLTd6I6yQ=; b=VPqd2baDC3My6bFwl4KZdC
	++UEg06J2fUvexHWKNc+19olv88u44nM3x/ZaK7i393BK2OSKPkHO1oTjREGNBIa
	Wlfn+GeaG2EsKRt1YEJRodpy2hvFNwIM5D57rZDo1wJqACky82LSvWsH7F7y6X5r
	j6hGIRqAHNp3MPAadX5ETu3cQUoZ2pOSveHzzxmpRhzqu+y/FMUmWXDdJSLiX4L3
	QGWOase4mrH1hwEExNfwGpxmcrQC5UCG0Eo6q8+bd1QdpXpofW8MF68HChP1/roy
	c6yBb2kbVkB9HQOS1mWV4gOE4TkqTdPwRaVm4MHyeWj2faeh6Agr6k+HbpvCT8pQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbnudgxcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 11:34:25 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67VBQIqR024526;
	Mon, 31 Aug 2026 11:34:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcb8h5gwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 11:34:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67VBYKJ348234992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 11:34:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEDAC2004E;
	Mon, 31 Aug 2026 11:34:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63DF92004D;
	Mon, 31 Aug 2026 11:34:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.224.75.30])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 31 Aug 2026 11:34:20 +0000 (GMT)
Date: Mon, 31 Aug 2026 13:34:18 +0200
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
Message-ID: <20260831133418.1594b410@p-imbrenda>
In-Reply-To: <apHOZouaLKs5CgpI@google.com>
References: <20260826230511.972824-1-seanjc@google.com>
	<20260826230511.972824-3-seanjc@google.com>
	<20260828195848.2d14e9aa@p-imbrenda>
	<apHOZouaLKs5CgpI@google.com>
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
X-Proofpoint-GUID: G-OCitu2TpWXDgPjgttj0SGbLIz_ECdc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA5OSBTYWx0ZWRfX4UatEpGoCD6o
 Kv1eA+dS2uJdH+4ManK2w/X6QyFrWWh7jd8KL6kiafdW3x+2ac/P/Zkz8HOZl+1VKLL8mqEiYNp
 +j6gQ5DWRR9ZLjH5RZ9q+jm2WEEvYWuCu+8CFvX4cAC1C9Vs/g74amZ4Oppy73+AeuLdlF2Q5M9
 tsOfQHTNMriNhBvEVpsU79JtekpA4ZZ6QS6aV6eUeLxVIC30m7f33YbB95d+awd7xHIciMoLHKu
 CSHQepUcB+t8wD8vZDWSRFe7dTAa4ibWzxCQlCdtJnbEBPoIp4skROGaDvCDVWJTK1VW/S4arjJ
 LNyvfSyOK9IYT9nFtTGYiRP05LMz259raqhxkHPwODSX0OnkUkV8kq6+RGlekjiIyFSS/0aWF4f
 g7/DukwXB5uHQDPuBbnmCWOHQjU0TbuawaWKzIPhnNWsyqy/wR4Tby3iuPc1P7EkbCvYr/zac9K
 QSdnbH+KYg1/rfkAONQ==
X-Proofpoint-ORIG-GUID: a8BXvl6k17QNNmEGXkIB4yyp26bklHpk
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA5OSBTYWx0ZWRfXwtaTiMJOBjFH
 tOMl0H4KERIHO7WfLS9yiOyzMOPcW6L7zLb7QkLf3GIfOSQtGS4DR3ikwAodhcbi8c8V/J48Qkq
 EtaWT5nrB08ZegHOb7IHlDrWnRHtJLc=
X-Authority-Analysis: v=2.4 cv=B92JFutM c=1 sm=1 tr=0 ts=6a9566c2 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=_FYIVZ8AZ4pq6tOtmQUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_04,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310099

On Fri, 28 Aug 2026 11:07:34 -0700
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Aug 28, 2026, Claudio Imbrenda wrote:
> > On Wed, 26 Aug 2026 16:04:53 -0700
> > Sean Christopherson <seanjc@google.com> wrote:
> >   
> > > Bump selftests completely arbitrary minimum GPA for page tables from
> > > 0x180000 to 0x200000 (LoongArch's minimum), so that LoongArch can use
> > > vm_alloc_page_table() instead of open coding a rough equivalent.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/include/kvm_util.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > > index 5a7a455b5387..70906a0d1003 100644
> > > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > > @@ -175,7 +175,7 @@ static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
> > >  
> > >  /* Minimum allocated guest virtual and physical addresses */
> > >  #define KVM_UTIL_MIN_VADDR		0x2000
> > > -#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
> > > +#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x200000
> > >  
> > >  #define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
> > >  #define DEFAULT_STACK_PGS		5  
> > 
> > this breaks s390/cmma_test
> > 
> > I tried a quick fix, but nope... I will need to actually invest some
> > time (i.e. next week) to understand why the quick fix is not enough,
> > and come up with a proper fix
> > 
> > the good news is: it seems like cmma_test is the only test that is
> > negatively affected by this series.  
> 
> Is it this change specifically that's problematic?  Because if so, you can probably

yesn't

wihtout this patch everything works for s390, but my quick fix should
have worked...

so I still need to debug why things don't work the way I expect, but at
least now my bug chase is independent from this series :)

> just do nothing, because Sashiko (argh, just remembered that Sashiko doesn't Cc
> everyone) pointed out that this will likely break some arm64 tests as well[*].
> 
> The LoongArch folks confirmed that using KVM_GUEST_PAGE_TABLE_MIN_PADDR as-is
> should be a-ok, so my plan is to drop this patch and instead have LoongArch use
> KVM_GUEST_PAGE_TABLE_MIN_PADDR.  I.e. make LoongArch match everyone else, instead
> of making everyone else match LoongArch.
> 
> [*] https://lore.kernel.org/all/20260826232224.782021F000E9@smtp.kernel.org
> 

if you respin without this patch I'll Ack
