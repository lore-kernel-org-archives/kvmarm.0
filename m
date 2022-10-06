Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD659C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  7 Oct 2022 18:45:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 289B740298;
	Fri,  7 Oct 2022 14:45:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Um4nUOKZT4gd; Fri,  7 Oct 2022 14:45:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C20FC49EFA;
	Fri,  7 Oct 2022 14:45:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3B3540B62
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2022 07:36:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jU912d1++AWP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Oct 2022 07:36:04 -0400 (EDT)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 540AB4089A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2022 07:36:04 -0400 (EDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296AdssK013705;
 Thu, 6 Oct 2022 11:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xBAxo2EkOugArJ52Sfd39C+wq2sM5YBocYR/lzajMfo=;
 b=oC+5GEsnGm9rrYikyqYL5trfaXCAd6WtsScnAE70OpNx2s2LSJ+88BWTDXI1YgRZG/38
 mTOmLKrlfkAQSxgFraiYTExz+fMnWmM8CW2rosqES1TtP1gfJocrjOUzW+GJSf1DwZTs
 lfOy4pregSJfi1+YSS7/n2XQfQV83ZhR1RuAbsG8/8I/rcopWIPTt2cNrC0O0uH8UAN+
 zTzEZdy11IlBHp5aUrTzG0KjndsM0Dv0RSLD3U6vO2G5ga2rQr9CUsV+1Lp7nabQpCoj
 tthjOV3Z85gqgqjXFaVHD9ORKRS8A7DPyTR/3/QBJw98b7Scapd2aMTemFiGRitl5wxG rA== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1vdgk931-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 06 Oct 2022 11:35:59 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 296BDvI7011186;
 Thu, 6 Oct 2022 11:35:59 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.99])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1vdgk929-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 06 Oct 2022 11:35:59 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
 by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 296BKA4U015827;
 Thu, 6 Oct 2022 11:35:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com
 (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
 by ppma04ams.nl.ibm.com with ESMTP id 3jxd696y36-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 06 Oct 2022 11:35:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com
 [9.149.105.62])
 by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 296BZtPJ3998344
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 6 Oct 2022 11:35:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 3F3B7AE053;
 Thu,  6 Oct 2022 11:35:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id E5DF2AE051;
 Thu,  6 Oct 2022 11:35:54 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
 by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Thu,  6 Oct 2022 11:35:54 +0000 (GMT)
Date: Thu, 6 Oct 2022 13:35:52 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] lib/vmalloc: Treat
 virt_to_pte_phys() as returning a physical address
Message-ID: <20221006133552.091bb41b@p-imbrenda>
In-Reply-To: <20221006111241.15083-2-alexandru.elisei@arm.com>
References: <20221006111241.15083-1-alexandru.elisei@arm.com>
 <20221006111241.15083-2-alexandru.elisei@arm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e7ZMMOL35d3PFHQ67elE1hlGAQjb0aWx
X-Proofpoint-GUID: iBeqeMI9KKYrzxwIWWz1_tk5kuKdV9aR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1011
 mlxscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210060069
X-Mailman-Approved-At: Fri, 07 Oct 2022 14:45:15 -0400
Cc: Laurent Vivier <lvivier@redhat.com>, thuth@redhat.com,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 andrew.jones@linux.dev, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu,  6 Oct 2022 12:12:39 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> All architectures that implements virt_to_pte_phys() (s390x, x86, arm and
> arm64) return a physical address from the function. Teach vmalloc to treat
> it as such, instead of confusing the return value with a page table entry.

I'm not sure I understand what you mean

> Changing things the other way around (having the function return a page
> table entry instead) is not feasible, because it is possible for an
> architecture to use the upper bits of the table entry to store metadata
> about the page.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Laurent Vivier <lvivier@redhat.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/vmalloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> index 572682576cc3..0696b5da8190 100644
> --- a/lib/vmalloc.c
> +++ b/lib/vmalloc.c
> @@ -169,7 +169,7 @@ static void vm_free(void *mem)
>  	/* the pointer is not page-aligned, it was a single-page allocation */
>  	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
>  		assert(GET_MAGIC(mem) == VM_MAGIC);
> -		page = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
> +		page = virt_to_pte_phys(page_root, mem);

this will break things for small allocations, though. if the pointer is
not aligned, then the result of virt_to_pte_phys will also not be
aligned....

>  		assert(page);
>  		free_page(phys_to_virt(page));

...and phys_to_virt will also return an unaligned address, and
free_page will complain about it.

>  		return;
> @@ -183,7 +183,7 @@ static void vm_free(void *mem)
>  	/* free all the pages including the metadata page */
>  	ptr = (uintptr_t)m & PAGE_MASK;

ptr gets page aligned here

>  	for (i = 0 ; i < m->npages + 1; i++, ptr += PAGE_SIZE) {
> -		page = virt_to_pte_phys(page_root, (void *)ptr) & PAGE_MASK;
> +		page = virt_to_pte_phys(page_root, (void *)ptr);

so virt_to_pte_phys will also return an aligned address;
I agree that & PAGE_MASK is redundant here

>  		assert(page);
>  		free_page(phys_to_virt(page));
>  	}

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
