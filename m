Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA316125
	for <kvmarm@lists.linux.dev>; Mon, 28 Aug 2023 12:17:00 +0000 (UTC)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20230828121653euoutp02e164cc2247f6ac1b5d6745b5d9bb63d1~-iy27dQdu3022830228euoutp02Y
	for <kvmarm@lists.linux.dev>; Mon, 28 Aug 2023 12:16:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20230828121653euoutp02e164cc2247f6ac1b5d6745b5d9bb63d1~-iy27dQdu3022830228euoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1693225013;
	bh=uvoTK016IZgSk7JotayXG2sTTMzK5gJOcuCoYWScSDA=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=OD5KtGoigDGrEgNw5NM0hwqFGgzGTjKPSdxNeic6RWEzV2T6n19ZYVrYTo6kbWxyx
	 SA3wpHmVQ0mrAtt9FiS+lGK2yV1OFDiKItjet8JIG5rwJp6MkRdYTG+/OCYCo3agzo
	 UV1XmN3wgpUNUDVULO4l/d4bV6jY2j3ddWwVDot4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230828121653eucas1p1606ecf195ec97c3669bddf715e7099fc~-iy2lmyKj2116221162eucas1p1A;
	Mon, 28 Aug 2023 12:16:53 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id C4.B6.11320.4309CE46; Mon, 28
	Aug 2023 13:16:52 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20230828121652eucas1p11cc5921bd55c7e90f83d1938a358237f~-iy2Up_zy3154831548eucas1p11;
	Mon, 28 Aug 2023 12:16:52 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230828121652eusmtrp13c1e9938219b2f951a67d80dfc1b5d85~-iy2UB7EE1568215682eusmtrp1_;
	Mon, 28 Aug 2023 12:16:52 +0000 (GMT)
X-AuditID: cbfec7f4-97dff70000022c38-46-64ec90341454
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 93.D3.10549.4309CE46; Mon, 28
	Aug 2023 13:16:52 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230828121652eusmtip1b210ab49a9082c5ab053b7882ae28b4c~-iy1mSp5s0642006420eusmtip1G;
	Mon, 28 Aug 2023 12:16:51 +0000 (GMT)
Message-ID: <79b0ad6e-0c2a-f777-d504-e40e8123d81d@samsung.com>
Date: Mon, 28 Aug 2023 14:16:51 +0200
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
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
	oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, qperret@google.com, smostafa@google.com,
	kaleshsingh@google.com, linux-arm-kernel@lists.infradead.org,
	kernel-team@android.com, will@kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20230811112037.1147863-1-vdonnefort@google.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se1BMcRj123t3u63Z5rZiP9EwO+SVUtLcIVF2xmWYYYzHYGi1V6LCbpG8
	VpmsHanpMez2sNHMqklNS2trJSLZSTuE6CXvsrU1kT/yaLXd0H/nnO/75pzzmx+BCcu5nkRU
	bBwjj5VGi3l83PhoyLowML1XtuiqPZhKuqtxoUy3PSjbrQc4ZfjQzKUqcy1cKnuol0c9MRhx
	SlPTj6hrLUUc6mz7kpV82mg2cmmdIZ42FJ/n0QXKbIy+WXia7r6pQRt42/nBMiY66ggj9wsJ
	5++74ChGh4zihO9f73GVyOylRq4EkIHQ7KjkqBGfEJLXEZSa6jCWDCK4WJA/Rr4hKGtRob8n
	Z9usODvQIxhOezZGBhCUq97ynFsCMgQuv3yLOTFOzob68heI1d3BovmIO/FkkoHPrbkuTjyJ
	3AX67hyuE2OkCFo/XuE4sQe5FUzdqtGAGFmGwGBIHh3wSH9Q29WjZq7kcujp6UDs8QxIrsgZ
	zQ3kIAElve9wNrcE7rZaOSyeBLb6Wy4sng4NmRdw9uAcAt3PTg5L0hEou1rHWi+DduuPETti
	xGIelFX5sXIoZDx4gpwykG7w2u7OhnCDDOMljJUFoEoRstveoK0v/Wd7/2kTlo7E2nHvoh3X
	Xzuujva/rw7hxUjExCtiIhlFQCxz1FchjVHEx0b6RhyMMaCRX9UwXD9oQnrbgG8t4hCoFgGB
	iT0ETaE2mVAgkx5LZOQHd8vjoxlFLZpG4GKRYMFyS4SQjJTGMQcY5hAj/zvlEK6eSs7RjPJ1
	Lxd8nbNS70jdZPCR6ETHvDb1bOyvq5y4SyZaagvb0rcoZNanvNSgPJ/A/ua4eUV3PiW1dOH9
	Dipn7+POHW6WzlOnXtEVLX1rEvd4xfAtH0zdJe8Tq8NT3pzMPd5Gbgufmry+KuHZcMnPdPu7
	0ktNZmVvBOYiXCHdYaFVA/bdpTWiNQ3nshx+M7mBOQ8LJNaOogTvb8n3aMn5lF+v93quC8if
	kFLtqR/MaywMiyrU6/xPvvi9+oxf3+fQxY2rykyFmrTvFVO+aDQ9J6qDJB123yOVO7Gwzfu5
	7jembwyuUTfiPsNZAQJ+89CdTn6Qea3F2JU9N/HLrKqQ54frMpPEuGKf1H8+JldI/wBqTd++
	xAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t/xu7omE96kGOy+pmXRtG8mu8WO7SIW
	r7YcZrHY9Pgaq8XOOSdZLab+fMNmcWbTNhaLmfvfM1osvrmSyaLljqkDl8e23dtYPRZsKvXY
	tKqTzWNhw1Rmj81L6j1ebJ7JGMAWpWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtl
	ZKqkb2eTkpqTWZZapG+XoJfR838VY8E2pYqvnw6wNjDulu1i5OSQEDCRaLl9jqWLkYtDSGAp
	o8ThybNYIBIyEienNbBC2MISf651sUEUvWeU6P6wlR0kwStgJzHj6gNmEJtFQFXi+MYrjBBx
	QYmTM5+ADRIVSJX4fmsfG4gtLBAnsfzFbLChzALiEreezGcCsUUEwiXuHv7OCLKAWWA9o8TV
	501gDUICNhINLfPBBrEJGEp0ve0Ci3MK2Eq8fn2XEWKQmUTX1i4oW16ieets5gmMQrOQ3DEL
	yb5ZSFpmIWlZwMiyilEktbQ4Nz232FCvODG3uDQvXS85P3cTIzAytx37uXkH47xXH/UOMTJx
	MB5ilOBgVhLhveT4KkWINyWxsiq1KD++qDQntfgQoykwMCYyS4km5wNTQ15JvKGZgamhiZml
	gamlmbGSOK9nQUeikEB6YklqdmpqQWoRTB8TB6dUA5PqSlPvX9pJH2ZwslhVLX04v+Xo2gU6
	CsXzgqx2FK5rcGBjNO60/yPp5Xl8u7LkcXv9tbv0tKaWhxttZXJo7CzbHr2y2Hb6Hi+b33H3
	OpU/N27Z8mfB0WSu4hpJZaXzuwrtA5M78/bFpnpzX7+5ePXfyy33dM2WmJ1qi+sQrz3G1Pu0
	/Ezp09IWjeTI3I1ffSWmxV8rYsyeY242X+nMFx49V91Fty6sFoxJObtU26Rn2wop5UvR1W5T
	En36uV9INWVxsrHfS42/XM9uu+CI2kL+yKYw/kOiVROel+/LvXLSK0ZcwX9mxMrf/JaRPptn
	fj44rV86ZHlE5JzOG++OHi8wnvZ17R9GRruCGUJHlViKMxINtZiLihMBSrSc/lUDAAA=
X-CMS-MailID: 20230828121652eucas1p11cc5921bd55c7e90f83d1938a358237f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20230828121652eucas1p11cc5921bd55c7e90f83d1938a358237f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230828121652eucas1p11cc5921bd55c7e90f83d1938a358237f
References: <20230811112037.1147863-1-vdonnefort@google.com>
	<CGME20230828121652eucas1p11cc5921bd55c7e90f83d1938a358237f@eucas1p1.samsung.com>

On 11.08.2023 13:20, Vincent Donnefort wrote:
> commit f922c13e778d ("KVM: arm64: Introduce
> pkvm_alloc_private_va_range()") and commit 92abe0f81e13 ("KVM: arm64:
> Introduce hyp_alloc_private_va_range()") added an alignment for the
> start address of any allocation into the nVHE hypervisor private VA
> range.
>
> This alignment (order of the size of the allocation) intends to enable
> efficient stack verification (if the PAGE_SHIFT bit is zero, the stack
> pointer is on the guard page and a stack overflow occurred).
>
> But this is only necessary for stack allocation and can waste a lot of
> VA space. So instead make stack-specific functions, handling the guard
> page requirements, while other users (e.g.  fixmap) will only get page
> alignment.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

This change, merged to linux-next as f156a7d13fc3 ("KVM: arm64: Remove 
size-order align in the nVHE hyp private VA range"), introduced the 
following regression on Raspberry Pi4b board. Here is a log observed on 
linux next-20230828 release:

--->8---

kvm [1]: IPA Size Limit: 44 bits
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at arch/arm64/kvm/hyp/pgtable.c:453 
hyp_map_walker+0xb0/0x120
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.5.0-next-20230828 #13889
Hardware name: Raspberry Pi 4 Model B (DT)
pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : hyp_map_walker+0xb0/0x120
lr : hyp_map_walker+0x30/0x120
...
Call trace:
  hyp_map_walker+0xb0/0x120
  kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
  __kvm_pgtable_walk+0x1dc/0x32c
  __kvm_pgtable_walk+0xd0/0x32c
  __kvm_pgtable_walk+0xd0/0x32c
  __kvm_pgtable_walk+0xd0/0x32c
  kvm_pgtable_walk+0xd0/0x224
  kvm_pgtable_hyp_map+0x8c/0xf0
  __create_hyp_mappings+0x98/0xc0
  __create_hyp_private_mapping+0xf0/0x14c
  create_hyp_io_mappings+0x8c/0x118
  vgic_v2_probe+0xbc/0x1ec
  kvm_vgic_hyp_init+0xcc/0x210
  kvm_arm_init+0x6a4/0x1040
  do_one_initcall+0x74/0x2f0
  kernel_init_freeable+0x28c/0x4dc
  kernel_init+0x24/0x1dc
  ret_from_fork+0x10/0x20
irq event stamp: 72194
hardirqs last  enabled at (72193): [<ffff8000811f2c48>] 
_raw_spin_unlock_irqrestore+0x74/0x78
hardirqs last disabled at (72194): [<ffff8000811df128>] el1_dbg+0x24/0x8c
softirqs last  enabled at (72182): [<ffff800080010a10>] 
__do_softirq+0x438/0x4ec
softirqs last disabled at (72173): [<ffff800080016980>] 
____do_softirq+0x10/0x1c
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at arch/arm64/kvm/hyp/pgtable.c:470 
hyp_map_walker+0x10c/0x120
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W 6.5.0-next-20230828 #13889
Hardware name: Raspberry Pi 4 Model B (DT)
pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : hyp_map_walker+0x10c/0x120
lr : hyp_map_walker+0x30/0x120
...
Call trace:
  hyp_map_walker+0x10c/0x120
  kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
  __kvm_pgtable_walk+0x1dc/0x32c
  __kvm_pgtable_walk+0xd0/0x32c
  __kvm_pgtable_walk+0xd0/0x32c
  __kvm_pgtable_walk+0xd0/0x32c
  kvm_pgtable_walk+0xd0/0x224
  kvm_pgtable_hyp_map+0x8c/0xf0
  __create_hyp_mappings+0x98/0xc0
  __create_hyp_private_mapping+0xf0/0x14c
  create_hyp_io_mappings+0x8c/0x118
  vgic_v2_probe+0xbc/0x1ec
  kvm_vgic_hyp_init+0xcc/0x210
  kvm_arm_init+0x6a4/0x1040
  do_one_initcall+0x74/0x2f0
  kernel_init_freeable+0x28c/0x4dc
  kernel_init+0x24/0x1dc
  ret_from_fork+0x10/0x20
irq event stamp: 72214
hardirqs last  enabled at (72213): [<ffff8000811df8f8>] 
exit_to_kernel_mode+0x34/0x124
hardirqs last disabled at (72214): [<ffff8000811df128>] el1_dbg+0x24/0x8c
softirqs last  enabled at (72212): [<ffff800080010a10>] 
__do_softirq+0x438/0x4ec
softirqs last disabled at (72197): [<ffff800080016980>] 
____do_softirq+0x10/0x1c
---[ end trace 0000000000000000 ]---
kvm [1]: Cannot map VCTRL into hyp

-------


With $subject patch reverted on top of next-20230828, kvm initializes 
properly on Raspberry Pi4b:

--->8---
kvm [1]: IPA Size Limit: 44 bits
kvm [1]: vgic interrupt IRQ9
kvm [1]: Hyp mode initialized successfully

-------

Let me know if I can help somehow debugging this issue.


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

