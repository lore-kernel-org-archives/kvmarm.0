Return-Path: <SRS0=mXZs=LT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956BAC2B9F4
	for <kvmarm@archiver.kernel.org>; Fri, 25 Jun 2021 07:59:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01FA36141E
	for <kvmarm@archiver.kernel.org>; Fri, 25 Jun 2021 07:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01FA36141E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C89B4B1A5;
	Fri, 25 Jun 2021 03:59:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8xkKbs4phHwW; Fri, 25 Jun 2021 03:59:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2274B4B1AB;
	Fri, 25 Jun 2021 03:59:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32E0C4B191
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 03:59:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wvbBki-vgN8I for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jun 2021 03:59:43 -0400 (EDT)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E77CC4B151
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 03:59:42 -0400 (EDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
 15P7XgSr163083; Fri, 25 Jun 2021 03:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dKTZ5LGvIvXYN5hrxescceB4a+549WmZAfPHPpWY4Mw=;
 b=aWt4tRZtCOJ+mGxI9BelzcO6ojLT44Ap4RkL67WA0yRy5mvyPnuqGbe+PsHDDjroEZnK
 FS+4fhDv0x9lSbkNQ20IeeRSmOX20wRyZcHQ60otM2zfSiJweJ3Z8Vf45GOaUWPzobb8
 MejQbpDGQafNC4WT9B02wBAo9AqLsXQSkd3kwHpc2q95cCQ3DYomcOnUvl4WYqwEFnXX
 NYXfv0TrMrf05Ba4xE1Em4vtML0qExLnMyxGpsyQy0dYdt+OQzr/RXLybgWT/YTrvmqL
 ED/DcP4NIOtA5OjUKTQweH+acU1yfsolWy4TgAu7HFWO35IHHhU+QmU/Ed6/r0QvScw+ bg== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com with ESMTP id 39d9h6bhph-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 25 Jun 2021 03:58:34 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15P7Xs32163940;
 Fri, 25 Jun 2021 03:58:34 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.98])
 by mx0a-001b2d01.pphosted.com with ESMTP id 39d9h6bhnp-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 25 Jun 2021 03:58:33 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
 by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15P7rV4f015718;
 Fri, 25 Jun 2021 07:58:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com
 (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
 by ppma03ams.nl.ibm.com with ESMTP id 399878awsw-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 25 Jun 2021 07:58:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com
 [9.149.105.62])
 by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 15P7wTYI22413732
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 25 Jun 2021 07:58:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 71C89AE057;
 Fri, 25 Jun 2021 07:58:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id DA31DAE04D;
 Fri, 25 Jun 2021 07:58:27 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.31.44])
 by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Fri, 25 Jun 2021 07:58:27 +0000 (GMT)
Subject: Re: [PATCH v2 1/5] KVM: do not allow mapping valid but non-refcounted
 pages
To: David Stevens <stevensd@chromium.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Nick Piggin <npiggin@gmail.com>
References: <20210625073616.2184426-1-stevensd@google.com>
 <20210625073616.2184426-2-stevensd@google.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <183b71c1-6bb0-8d05-e2ce-e452253259a8@de.ibm.com>
Date: Fri, 25 Jun 2021 09:58:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625073616.2184426-2-stevensd@google.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BdtyyjbTQMfPEY6MWTdYEs3ooRdifkK5
X-Proofpoint-GUID: vG6ohtKq4JE7ZH-Uvo7-8RgtHyEscIYL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.790
 definitions=2021-06-25_02:2021-06-24,
 2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 spamscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250043
Cc: kvm-ppc@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
 Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Joerg Roedel <joro@8bytes.org>, linuxppc-dev@lists.ozlabs.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, linux-mips@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, intel-gfx@lists.freedesktop.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Zhi Wang <zhi.a.wang@intel.com>, Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 25.06.21 09:36, David Stevens wrote:
> From: Nicholas Piggin <npiggin@gmail.com>
> 
> It's possible to create a region which maps valid but non-refcounted
> pages (e.g., tail pages of non-compound higher order allocations). These
> host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
> of APIs, which take a reference to the page, which takes it from 0 to 1.
> When the reference is dropped, this will free the page incorrectly.
> 
> Fix this by only taking a reference on the page if it was non-zero,
> which indicates it is participating in normal refcounting (and can be
> released with put_page).
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

I guess this would be the small fix for stable? Do we want to add that cc?

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   virt/kvm/kvm_main.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3dcc2abbfc60..f7445c3bcd90 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2175,6 +2175,13 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
>   	return true;
>   }
> 
> +static int kvm_try_get_pfn(kvm_pfn_t pfn)
> +{
> +	if (kvm_is_reserved_pfn(pfn))
> +		return 1;
> +	return get_page_unless_zero(pfn_to_page(pfn));
> +}
> +
>   static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   			       unsigned long addr, bool *async,
>   			       bool write_fault, bool *writable,
> @@ -2224,13 +2231,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   	 * Whoever called remap_pfn_range is also going to call e.g.
>   	 * unmap_mapping_range before the underlying pages are freed,
>   	 * causing a call to our MMU notifier.
> +	 *
> +	 * Certain IO or PFNMAP mappings can be backed with valid
> +	 * struct pages, but be allocated without refcounting e.g.,
> +	 * tail pages of non-compound higher order allocations, which
> +	 * would then underflow the refcount when the caller does the
> +	 * required put_page. Don't allow those pages here.
>   	 */
> -	kvm_get_pfn(pfn);
> +	if (!kvm_try_get_pfn(pfn))
> +		r = -EFAULT;
> 
>   out:
>   	pte_unmap_unlock(ptep, ptl);
>   	*p_pfn = pfn;
> -	return 0;
> +
> +	return r;
>   }
> 
>   /*
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
