Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BFF3E6DE7;
	Thu, 10 Sep 2026 10:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036201; cv=none; b=t+U5tLUnNvnQdnnhvb5yx1BYYqh7Q4J3stgaarJfmgs4mZx6f4KS633V6vIGbdS8mX60C1RoYSg8yFrM1BMNVxzniNBO0Tipx3sXJzNfxxCe+RQG5ouj+Q/+OPg8dhtJlIafz44XMsscBj5g+jjyVtrQnOgOtCEWSZFoKGaJVFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036201; c=relaxed/simple;
	bh=GcYodoSjkW/CMdZq6BFrx6NEBOv9IxjdSHA9auhtjTc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g02zS95X4tNq26R2sB0ZpiLedh31QIXZQNkLhkQvVn7XNRuVqGzrxc0bK3+m9ZBP1BZmH6y89etpLYvtFV5lvieNQB8UWfMflrIJp+AcBsgaIF/of5EfFWqDtb5af8MR4R+ultrGyd4GogM7dqPJbNya6Gg19paQcNcbOZ0bhtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cbBoC1WU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cbBoC1WU"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A91QMg576514;
	Thu, 10 Sep 2026 10:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2v8eQT
	UiODkYCwW7fpRiVtvLEmXAN0QDrnYnUVfQNEQ=; b=cbBoC1WUvLIsh/Wj2cLPT2
	vjPz/azRP2Hrwlumw/k42MGAwm24W5evh90rCcbAHhlhipSVKSOfLluTbJtU1jt6
	Gx1m/p9cwc1yahl/k90Whze96rIxuzGLAWsoacYf1NXRxuNSdY2iIbvv9apQVJlc
	UMZI8mcGuPuZuBg96KgDjH1Pcigve3p2ynl7rfqYTHLKARJK6yDYgZPAH82YY4WR
	VAl1DJdg2jJ4oqrX3R8i38RcGwTWjtRRHNdV+FyDZlZBQqoJbTTQnBWLJIHA7E6v
	y6sCElhwjdI/2YfJdtQKBJsmaGNvwQ7+69t6sq49a5r086FtooX5B8DWFJH5dewg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8n3wd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 10:29:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 68AAQC9K004763;
	Thu, 10 Sep 2026 10:29:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkcr33uj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 10:29:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68AATWNH43188604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 10:29:32 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 878092004D;
	Thu, 10 Sep 2026 10:29:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00B2F2004F;
	Thu, 10 Sep 2026 10:29:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.48.108])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 10 Sep 2026 10:29:29 +0000 (GMT)
Date: Thu, 10 Sep 2026 12:25:31 +0200
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
Subject: Re: [PATCH v2 09/20] KVM: selftests: Use the innermost page
 allocator API in s390's IRQ routing test
Message-ID: <20260910122531.499b565b@p-imbrenda>
In-Reply-To: <20260902164123.2546762-10-seanjc@google.com>
References: <20260902164123.2546762-1-seanjc@google.com>
	<20260902164123.2546762-10-seanjc@google.com>
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
X-Authority-Analysis: v=2.4 cv=NMVAaE6g c=1 sm=1 tr=0 ts=6aa28691 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=1XWaLZrsAAAA:8
 a=omOdbC7AAAAA:8 a=VnNF1IyMAAAA:8 a=ncMTWhVeLHM-VX_LCFkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Se5IIme47yOD2YBAO0JHuYpxPj7OtfZR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDExNSBTYWx0ZWRfX5cTAuBi1pOw0
 eCaNg8ALKS6/QFSqT//okMnY45ig0qLvL0qlinYgrlkvM4y8dox1QEYYRVq1DSN5ZnVPcloYMzz
 qzTs+Pk68w6UnwFc5Fcytw4kHMzGKU9lWP8PiUAG2m+ymP9PrpTKt4qGBIczpWCt8vrcJ127ixD
 9cOEVmc3sD09VEDPEv4MbzyTBatBFAjMRySMq6Z7uKPsboCi1kWWNEaH0zm6HKcEagQuJAm1OpN
 tu1bwMh0zrZb1QtvY69KWvjYeUgL88ocCGgFWt5Kn7w04RiWEPHkblVyBo+h7CTLU/NVbmG19Go
 YqhGsu0rcwe7fP7uzCqijdqHBfQYTU+Kf++VDwhvVRuQKgfW9isJuHzl54TDJJgLK0PXPFqBZzf
 9fLBbTJ21IPM+xgRHVm03S/vZUCBKv5qnjJ6iLnNIWb5KV5w5oRjKx9vfb5EpXDcGmx6NAjtmbx
 3eggPh0QRJRm864ZYpA==
X-Proofpoint-ORIG-GUID: EeWyQkeZUCSSRdpkHyS1LNqruiFVZs4W
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDExNSBTYWx0ZWRfX6mMimO+EDNf/
 eJupQqfyq8zKgx+xjT0vGZK4TqN7lyOx+e+F0dUZro+XG34zrPAU7eBBA1hL2I4JHSa/bG9nlqQ
 X7lB6vw5V56GrdX2vG0c4Pn1Yf68Y1c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100115

On Wed,  2 Sep 2026 09:41:12 -0700
Sean Christopherson <seanjc@google.com> wrote:

> Use the quad-underscores page allocator in s390's IRQ routing test in
> anticipation of dropping the @min_gpa param from the primary APIs.
> 
> Note, it's not entirely clear that the test *needs* to use a very magical
> @min_gpa, i.e. it's possible a more elegant solution exists.  But that's a
> problem for a different day.
> 
> No functional change intended.
> 
> Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  tools/testing/selftests/kvm/s390/irq_routing.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/s390/irq_routing.c b/tools/testing/selftests/kvm/s390/irq_routing.c
> index f3839284ac08..cd26cc1aed80 100644
> --- a/tools/testing/selftests/kvm/s390/irq_routing.c
> +++ b/tools/testing/selftests/kvm/s390/irq_routing.c
> @@ -36,7 +36,7 @@ static void test(void)
>  	};
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> -	mem = vm_phy_pages_alloc(vm, 2, 4096 * 42, 0);
> +	mem = ____vm_phy_pages_alloc(vm, 2, 4096 * 42, 0, false, false);
>  
>  	routing = kvm_gsi_routing_create();
>  	routing->nr = 1;

