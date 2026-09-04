Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8701F3B85;
	Fri,  4 Sep 2026 11:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522049; cv=none; b=Uiuftv1qXbN9N2V6PyQtH6G1RxLZaIWqO02WV5iU/ATpS5dzaNk9v3wKN9+SLjycqEkkezEH0s9zU+/hAOmFUVDu1CfHLOwjCyEhblgRqdWk/OZx45R60aMYkGrFD4h1961HnZX1RXeoToh4y4l8bNKZ4jYwHJjFuWBC2vFlh5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522049; c=relaxed/simple;
	bh=YuthCpoYgaozUFT0RrDPnJmeZiHeMQLHKD/NWI5I3wM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2fU7GX+utUtQa/2NGmlZvBcOEyMwrf0u4ZXDw/fd/wbzZgp8cYK6xxIGwsNdoLnzNRj3AHQ0AKEc9vCdoaqVYB3KFLPVYeB5dar7fkqwgWKaFk5hN9OSUbKO/SkkEme8bPwPsQzK7w6F0C9LKmWWGt7zYjUv6VMGTyjGXivCG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GZbQELKW; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GZbQELKW"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684AVe9p3807368;
	Fri, 4 Sep 2026 11:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=/QhYY3cMo6ujVyxyegvMNjhHF60Bsa
	MDpEUgMPs1h/w=; b=GZbQELKWWF8sx4n3RybtSDqlSIK16+tkdry7lNkR9F5aEv
	puq05mIghaIOmFtd6OKsxftRG7IzY5Y6RBQfNhGx6iza1l/Cz8htaA1WxAbS8etp
	NhBjtFNz9zGKkHGVmWsDPlquW+ciwcqZjjlM7H+LdKCIpDq5A1fl6i3+rfjHHHUX
	5KqWThYT9LtVPdkz+s/ccSKoWBpm8gQDwbeeah5kfKpOQsvpKEYzMwZcs570xOvs
	C9oEjVaJh9gK/GtFua7nZMnYKi2eROtCMZNMjWNo4CLaCmBPu3o7DSWwkq8EF0CM
	RiZxGnCHIp1D9tq6Vi10F5YILfKaWakDOHjOlH4g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq3rtfd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Sep 2026 11:40:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 684BQTwE010821;
	Fri, 4 Sep 2026 11:40:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gecjaw6xd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Sep 2026 11:40:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 684BeJ3D49545618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Sep 2026 11:40:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4AAF82004B;
	Fri,  4 Sep 2026 11:40:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0387320040;
	Fri,  4 Sep 2026 11:40:14 +0000 (GMT)
Received: from dhcp-9-123-3-18.bl1-in.ibm.com (unknown [9.123.3.18])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  4 Sep 2026 11:40:13 +0000 (GMT)
Date: Fri, 4 Sep 2026 17:10:11 +0530
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
Subject: Re: [PATCH v2 05/20] KVM: selftests: Use goto instead of do-while to
 retry finding unused physical pages
Message-ID: <apquG3ZPgTio1ckj@dhcp-9-123-3-18.bl1-in.ibm.com>
References: <20260902164123.2546762-1-seanjc@google.com>
 <20260902164123.2546762-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902164123.2546762-6-seanjc@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=EIc2FVZC c=1 sm=1 tr=0 ts=6a9aae29 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8
 a=omOdbC7AAAAA:8 a=1XWaLZrsAAAA:8 a=VnNF1IyMAAAA:8 a=ltp-RmMtnFz0lCvsd_sA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDEwNCBTYWx0ZWRfX/MfmOk+n849g
 itvdrttGkm0Wq5bsa2if3gCckUIyBuzuARTO71mudv9BASDtKDIsHtL/woQBUHKi8oDonptgR2Y
 Y3xtuyV2KY4kJWq+F2zX+yS4lxgeazdGj4Vm2M8aw2H4drLQMJ4Dkx3sXHUbiXfiTM4KCYx6pvG
 jRkS8K9ANvnQzdldsxZRV6gVWQqd28AeecGwFgWDmwECvirHH/P7ITSc4M+3+jMYvJ1S35n3vyI
 aAl+MJ+B9OXIJgFAENFnf/++eLNJ1yPxq+OJG5EmwhMRZUivC89f0NlYYwJCoTaF1PuME/oAvza
 bFO/djsVJQu1cj/ZJxD0F7QMpKZn5DFWONWav6CPhn/+AUtUjNtiy/fqogl55M0dwOv4Hbzy+VP
 eMp0Y66De0BWooL0dAGNy5Gvyhj76AZMJY4c503JArOtIDTzTIUtBRP2xpnFe/GAocl9rgUq4XL
 xdEFq0LXUv02wr4vpHg==
X-Proofpoint-GUID: SOMG99MybV1SAPOTbg_7Iu48ydPZpa9w
X-Proofpoint-ORIG-GUID: -Y1DSPNiCw8Ie2zXzwOPQQvkszDJwqsH
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDEwNCBTYWx0ZWRfX+oE+5AD7/bGP
 Gq8dC/XQH9lfiTYA8sDpVENbQyWvOfRnhjTp+Z1I6RAzgIxO9pHJBI/rW6OWRSOmmSerC80cVU7
 1mVQoqP8lIuNVY31rMT5VqN9/6vrDRg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-04_03,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 clxscore=1011
 phishscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609040104

On Wed, Sep 02, 2026 at 09:41:08AM -0700, Sean Christopherson wrote:
> From: Nicholas Piggin <npiggin@gmail.com>
> 
> Rework the core loop of the physical page allocator to use a goto instead
> of do-while loop when retrying with a new base address.  The do-while loop
> obviously works, but it obfuscates the success vs. failure paths, and in
> general is convoluted.
> 
> For all intents and purposes, no functional change intended.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> [Rebased to latest mainline tree]
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> [sean: separate from alignment change, use enomem label, write changelog]
> Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 32 +++++++++++-----------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index b071d77dd301..bbf6d7684c0c 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2049,23 +2049,15 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
>  	TEST_ASSERT(!protected || region->protected_phy_pages,
>  		    "Region doesn't support protected memory");
>  
> -	base = pg = min_gpa >> vm->page_shift;
> -	do {
> -		for (; pg < base + nr_pages; ++pg) {
> -			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
> -				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
> -				break;
> -			}
> +	base = min_gpa >> vm->page_shift;
> +again:
> +	for (pg = base; pg < base + nr_pages; ++pg) {
> +		if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
> +			base = sparsebit_next_set(region->unused_phy_pages, pg);
> +			if (!base)
> +				goto enomem;
> +			goto again;
>  		}
> -	} while (pg && pg != base + nr_pages);
> -
> -	if (pg == 0) {
> -		fprintf(stderr, "No guest physical page available, "
> -			"min_gpa: 0x%lx page_size: 0x%x memslot: %u\n",
> -			min_gpa, vm->page_size, memslot);
> -		fputs("---- vm dump ----\n", stderr);
> -		vm_dump(stderr, vm, 2);
> -		abort();
>  	}
>  
>  	for (pg = base; pg < base + nr_pages; ++pg) {
> @@ -2075,6 +2067,14 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
>  	}
>  
>  	return base * vm->page_size;
> +
> +enomem:
> +	fprintf(stderr, "No guest physical page available, min_gpa: 0x%lx page_size: 0x%x memslot: %u\n",
> +		min_gpa, vm->page_size, memslot);
> +	fputs("---- vm dump ----\n", stderr);
> +	vm_dump(stderr, vm, 2);
> +	abort();
> +	__builtin_unreachable();
>  }
>  
>  gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa, u32 memslot)
> -- 
> 2.55.0.966.g6673acef38-goog
> 

Acked-by: Gautam Menghani <gautam@linux.ibm.com>
