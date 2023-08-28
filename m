Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F1111CA0
	for <kvmarm@lists.linux.dev>; Mon, 28 Aug 2023 13:43:09 +0000 (UTC)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20230828134307euoutp01650b502a814d12afbb6a73eb6eb67079~-j_JioC2J1434214342euoutp010
	for <kvmarm@lists.linux.dev>; Mon, 28 Aug 2023 13:43:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20230828134307euoutp01650b502a814d12afbb6a73eb6eb67079~-j_JioC2J1434214342euoutp010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1693230187;
	bh=SeOrcY+FfpHtdj4eUlFk/9OtAUm4ElEXtz27fbq5FJo=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=YiJfVRUQr/Q5V2ebgP3hm7aBkrFndWrXzzZwyEOf2dQSwxuFR8IWG3HUPZZEBheku
	 jS7qcQJiwyW7iWxlMvAoOysEE2LYqZ3St3GgzuWx83C3wevb+d5OJOVEHH4pvkaBwT
	 3b6mB58/5BQx/sd3gK/5gK/0cx3Vvmal22L4qDVM=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230828134307eucas1p2daf469a8a7a54d2021063d226147148f~-j_JVlYLI0535505355eucas1p2n;
	Mon, 28 Aug 2023 13:43:07 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id A9.23.37758.B64ACE46; Mon, 28
	Aug 2023 14:43:07 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20230828134306eucas1p2de9738bcb846bf48969950bcf7cb635f~-j_JB7XRx1783117831eucas1p2u;
	Mon, 28 Aug 2023 13:43:06 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230828134306eusmtrp196bb70b0fdfc460a9bb2b8f0a67d3cf0~-j_JBTZs50292602926eusmtrp1a;
	Mon, 28 Aug 2023 13:43:06 +0000 (GMT)
X-AuditID: cbfec7f5-815ff7000002937e-bc-64eca46bbff4
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id C0.F3.14344.A64ACE46; Mon, 28
	Aug 2023 14:43:06 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230828134306eusmtip2f68472c50c7cb44880efcae848082fcc~-j_IVFW4p1453014530eusmtip2v;
	Mon, 28 Aug 2023 13:43:06 +0000 (GMT)
Message-ID: <f407976d-04eb-e163-404d-ab41c469bf92@samsung.com>
Date: Mon, 28 Aug 2023 15:43:06 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0)
	Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2] KVM: arm64: Remove size-order align in the nVHE hyp
 private VA range
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, oliver.upton@linux.dev,
	kvmarm@lists.linux.dev, qperret@google.com, smostafa@google.com,
	kaleshsingh@google.com, linux-arm-kernel@lists.infradead.org,
	kernel-team@android.com, will@kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <861qfnfgnx.wl-maz@kernel.org>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsWy7djPc7rZS96kGNx+yWbRtG8mu8WO7SIW
	r7YcZrHY9Pgaq8XOOSdZLab+fMNmcWbTNhaLmfvfM1osvrmSyaLljqkDl8e23dtYPRZsKvXY
	tKqTzWNhw1Rmj81L6j1ebJ7JGMAWxWWTkpqTWZZapG+XwJVx5OMFloIl4hWvr3eyNzAuE+5i
	5OSQEDCROLOri6WLkYtDSGAFo8TNVatZIZwvjBJvPl1kg3A+M0psfv6KHablatcjRhBbSGA5
	o8TOHykQRR8ZJR5decsKkuAVsJM42dDDBGKzCKhK/LmzjA0iLihxcuYTFhBbVCBV4tmtOWBD
	hQXiJJa/mA3WyywgLnHryXywXhEBRYlPF04yQsSBTpq0hA/EZhMwlOh62wU2k1NAW2Ljs6VQ
	vfISzVtnM0Mc+oNDYufVmC5GDiDbReLj5wKIsLDEq+NboH6RkTg9uQfsfQmBdkaJBb/vM0E4
	ExglGp7fYoSospa4c+4XG8ggZgFNifW79CHCjhKTDp9hhJjPJ3HjrSDECXwSk7ZNZ4YI80p0
	tAlBVKtJzDq+Dm7twQuXmCcwKs1CCpRZSJ6fheSZWQh7FzCyrGIUTy0tzk1PLTbOSy3XK07M
	LS7NS9dLzs/dxAhMUaf/Hf+6g3HFq496hxiZOBgPMUpwMCuJ8F5yfJUixJuSWFmVWpQfX1Sa
	k1p8iFGag0VJnFfb9mSykEB6YklqdmpqQWoRTJaJg1OqgYl31cYA/59P809VMqQHCJ566/Vs
	xiK1+oPzFlyMuvD77sf11jwvJ5nwK+zY0lL9u+msgOYlz77vm+axn0pQY639vp7DJc5JLrKk
	JXd7wcHm8GkyC1JXXu/K7fvk+7jiePBFy4jXXzMfrYqKvFFRv2bGV/tLQkeyDnrde6OT++zt
	reXnOS9mrEiZ37NdcnJOX9kWFfu917f9Sr/WtOaL3D0XtbwFqpkl54JfO3P4fl95+tLFA3sq
	fDZ8zxRNl+3qVX5y4fzqIPV6zzLJh7WHsh9wSNyf8bZ7TUngeofLpm/ahR9mHCqP4lSYeG2e
	noeKV1ACw7WIrCt7hez5uL0j2k123BRbkynz+1+923dL01QlluKMREMt5qLiRABa/7b7wAMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t/xe7pZS96kGHzv1rNo2jeT3WLHdhGL
	V1sOs1hsenyN1WLnnJOsFlN/vmGzOLNpG4vFzP3vGS0W31zJZNFyx9SBy2Pb7m2sHgs2lXps
	WtXJ5rGwYSqzx+Yl9R4vNs9kDGCL0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7Uy
	MlXSt7NJSc3JLEst0rdL0Ms48vECS8ES8YrX1zvZGxiXCXcxcnJICJhIXO16xNjFyMUhJLCU
	UWLSzgXMEAkZiZPTGlghbGGJP9e62CCK3jNKnLv0AayIV8BO4mRDDxOIzSKgKvHnzjI2iLig
	xMmZT1hAbFGBVInvt/aBxYUF4iSWv5gNNpRZQFzi1pP5YL0iAooSny6cBLuCWeALo8TEq4dZ
	IbY9Y5R48OcXO0gVm4ChRNfbLrBJnALaEhufLYWaZCbRtbWLEcKWl2jeOpt5AqPQLCSHzEKy
	cBaSlllIWhYwsqxiFEktLc5Nzy020itOzC0uzUvXS87P3cQIjM1tx35u2cG48tVHvUOMTByM
	hxglOJiVRHgvOb5KEeJNSaysSi3Kjy8qzUktPsRoCgyNicxSosn5wOSQVxJvaGZgamhiZmlg
	amlmrCTO61nQkSgkkJ5YkpqdmlqQWgTTx8TBKdXAlB8l0eL1430f38Rq8f5DBU9ZXzFf2XNH
	51NH3xWX2VVS2f7HTxzmYp2yVEBjnjOD9q9TOaYlb+/xnJprqeo0YfrnOonl27jPJE2eult+
	ccn/Gu+HFmarN/N02LgwmOWZBZebPS9l2aVyZ13AQ6tHqg9OXXN1dbq3c7/2pIxL63/lXWlc
	Nvf/R9GquStv3Zlza4P/sdWucbfNlkXwyTVPWJqTPPkiy7w1fC9O/qqQ8PE4tXW/6OEFf1jl
	ChZHvnd+uyD+xPKXSRek9xsulDjS9m29/9+Ew5UFLB07kn9/tt8qlXo5d4G2j2CLOu83Pib+
	PwdPcTBVz9TiSJ7cl/rn/PGjrD+LPSf8O/XiHJvefAMlluKMREMt5qLiRAClYJGAVgMAAA==
X-CMS-MailID: 20230828134306eucas1p2de9738bcb846bf48969950bcf7cb635f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20230828121652eucas1p11cc5921bd55c7e90f83d1938a358237f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230828121652eucas1p11cc5921bd55c7e90f83d1938a358237f
References: <20230811112037.1147863-1-vdonnefort@google.com>
	<CGME20230828121652eucas1p11cc5921bd55c7e90f83d1938a358237f@eucas1p1.samsung.com>
	<79b0ad6e-0c2a-f777-d504-e40e8123d81d@samsung.com>
	<861qfnfgnx.wl-maz@kernel.org>

On 28.08.2023 15:19, Marc Zyngier wrote:
> On Mon, 28 Aug 2023 13:16:51 +0100,
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>> On 11.08.2023 13:20, Vincent Donnefort wrote:
>>> commit f922c13e778d ("KVM: arm64: Introduce
>>> pkvm_alloc_private_va_range()") and commit 92abe0f81e13 ("KVM: arm64:
>>> Introduce hyp_alloc_private_va_range()") added an alignment for the
>>> start address of any allocation into the nVHE hypervisor private VA
>>> range.
>>>
>>> This alignment (order of the size of the allocation) intends to enable
>>> efficient stack verification (if the PAGE_SHIFT bit is zero, the stack
>>> pointer is on the guard page and a stack overflow occurred).
>>>
>>> But this is only necessary for stack allocation and can waste a lot of
>>> VA space. So instead make stack-specific functions, handling the guard
>>> page requirements, while other users (e.g.  fixmap) will only get page
>>> alignment.
>>>
>>> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>> This change, merged to linux-next as f156a7d13fc3 ("KVM: arm64: Remove
>> size-order align in the nVHE hyp private VA range"), introduced the
>> following regression on Raspberry Pi4b board. Here is a log observed on
>> linux next-20230828 release:
>>
>> --->8---
>>
>> kvm [1]: IPA Size Limit: 44 bits
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 1 at arch/arm64/kvm/hyp/pgtable.c:453
>> hyp_map_walker+0xb0/0x120
>> Modules linked in:
>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.5.0-next-20230828 #13889
>> Hardware name: Raspberry Pi 4 Model B (DT)
>> pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : hyp_map_walker+0xb0/0x120
>> lr : hyp_map_walker+0x30/0x120
>> ...
>> Call trace:
>>    hyp_map_walker+0xb0/0x120
>>    kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
>>    __kvm_pgtable_walk+0x1dc/0x32c
>>    __kvm_pgtable_walk+0xd0/0x32c
>>    __kvm_pgtable_walk+0xd0/0x32c
>>    __kvm_pgtable_walk+0xd0/0x32c
>>    kvm_pgtable_walk+0xd0/0x224
>>    kvm_pgtable_hyp_map+0x8c/0xf0
>>    __create_hyp_mappings+0x98/0xc0
>>    __create_hyp_private_mapping+0xf0/0x14c
>>    create_hyp_io_mappings+0x8c/0x118
>>    vgic_v2_probe+0xbc/0x1ec
>>    kvm_vgic_hyp_init+0xcc/0x210
>>    kvm_arm_init+0x6a4/0x1040
> Ah, wonderful. Can you give the snippet below a go?
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 11c1d786c506..50be51cc40cc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -652,6 +652,9 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
>   
>   	mutex_unlock(&kvm_hyp_pgd_mutex);
>   
> +	if (!ret)
> +		*haddr = base;
> +
>   	return ret;
>   }
>   

This fixed the regression. Feel free to add:

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

