Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9207C4361B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 08:03:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D77323A51
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 08:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D77323A51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E5DF4B223;
	Tue,  8 Dec 2020 03:03:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6ZPZ2j35291i; Tue,  8 Dec 2020 03:03:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2057B4B287;
	Tue,  8 Dec 2020 03:03:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 559E14B22F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 17:29:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bdYpoGnrEtJU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 17:29:28 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2EFC4B22E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 17:29:27 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607380167;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dnq+i3yZayEsCRTsORUaBjCp2YrShEJlkF9DEDSVxdE=;
 b=PZps4qJmjQuuMRi6bPW8dgj7Ej0m5lWYkrd/t7of68h3kJaZAYknmQOs9HVgHHRUp+CXK3
 7nAM9Mks6ixLZCPNiWDIvhy2F4efK1oQjuy+JfmOlv9AHjElZA0GvlJKskRaVq7VPvrEn4
 J1+wow4yQjzMoMDVjVRmTC5uE3KIj4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-LYy_wIK2Mn6kox2nNyHnaA-1; Mon, 07 Dec 2020 17:29:23 -0500
X-MC-Unique: LYy_wIK2Mn6kox2nNyHnaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3BDC180A086;
 Mon,  7 Dec 2020 22:29:20 +0000 (UTC)
Received: from ovpn-66-220.rdu2.redhat.com (ovpn-66-220.rdu2.redhat.com
 [10.10.66.220])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 28B046B8E5;
 Mon,  7 Dec 2020 22:29:18 +0000 (UTC)
Message-ID: <1835d0c3d0f6024b7c6778d9d84f1120291eacad.camel@redhat.com>
Subject: Re: [PATCH v4 17/26] kvm: arm64: Add offset for hyp VA <-> PA
 conversion
From: Qian Cai <qcai@redhat.com>
To: David Brazdil <dbrazdil@google.com>, kvmarm@lists.cs.columbia.edu, Marc
 Zyngier <maz@kernel.org>
Date: Mon, 07 Dec 2020 17:29:17 -0500
In-Reply-To: <20201202184122.26046-18-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
 <20201202184122.26046-18-dbrazdil@google.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mailman-Approved-At: Tue, 08 Dec 2020 03:03:32 -0500
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Will Deacon <will@kernel.org>, linux-doc@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org
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

On Wed, 2020-12-02 at 18:41 +0000, David Brazdil wrote:
> Add a host-initialized constant to KVM nVHE hyp code for converting
> between EL2 linear map virtual addresses and physical addresses.
> Also add `__hyp_pa` macro that performs the conversion.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 +++
>  arch/arm64/kvm/va_layout.c           | 30 +++++++++++++++++++++++++---
>  2 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> index 61375d4571c2..70b42f433449 100644
> --- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> +++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> @@ -18,6 +18,9 @@
>  /* Config options set by the host. */
>  __ro_after_init u32 kvm_host_psci_version;
>  __ro_after_init struct psci_0_1_function_ids kvm_host_psci_0_1_function_ids;
> +__ro_after_init s64 hyp_physvirt_offset;
> +
> +#define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
>  
>  static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
>  {
> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
> index 4130b72e6891..d8cc51bd60bf 100644
> --- a/arch/arm64/kvm/va_layout.c
> +++ b/arch/arm64/kvm/va_layout.c
> @@ -23,6 +23,30 @@ static u8 tag_lsb;
>  static u64 tag_val;
>  static u64 va_mask;
>  
> +/*
> + * Compute HYP VA by using the same computation as kern_hyp_va().
> + */
> +static u64 __early_kern_hyp_va(u64 addr)
> +{
> +	addr &= va_mask;
> +	addr |= tag_val << tag_lsb;
> +	return addr;
> +}
> +
> +/*
> + * Store a hyp VA <-> PA offset into a hyp-owned variable.
> + */
> +static void init_hyp_physvirt_offset(void)
> +{
> +	extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
> +	u64 kern_va, hyp_va;
> +
> +	/* Compute the offset from the hyp VA and PA of a random symbol. */
> +	kern_va = (u64)kvm_ksym_ref(__hyp_text_start);
> +	hyp_va = __early_kern_hyp_va(kern_va);
> +	CHOOSE_NVHE_SYM(hyp_physvirt_offset) = (s64)__pa(kern_va) - (s64)hyp_va;

The code here introduced a warning on TX2 from today's linux-next.

.config: https://cailca.coding.net/public/linux/mm/git/files/master/arm64.config

[   29.356963] CPU255: Booted secondary processor 0x0000011f03 [0x431f0af1]
[   29.358301] smp: Brought up 2 nodes, 256 CPUs
[   29.364962] SMP: Total of 256 processors activated.
[   29.364985] CPU features: detected: Privileged Access Never
[   29.365003] CPU features: detected: LSE atomic instructions
[   29.365023] CPU features: detected: CRC32 instructions
[   29.431660] CPU: All CPU(s) started at EL2
[   29.431685] ------------[ cut here ]------------
[   29.431713] virt_to_phys used for non-linear address: (____ptrval____) (__hyp_idmap_text_end+0x0/0x534)
[   29.431744] WARNING: CPU: 0 PID: 1 at arch/arm64/mm/physaddr.c:15 __virt_to_phys+0x80/0xc0
[   29.431759] Modules linked in:
[   29.431787] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.0-rc6-next-20201207+ #2
[   29.431804] pstate: 10400009 (nzcV daif +PAN -UAO -TCO BTYPE=--)
[   29.431819] pc : __virt_to_phys+0x80/0xc0
[   29.431834] lr : __virt_to_phys+0x80/0xc0
[   29.431848] sp : ffff000005fefc90
[   29.431862] x29: ffff000005fefc90 x28: ffff8000191c9010 
[   29.431891] x27: ffff000005f21228 x26: b14e19fe279ae3eb 
[   29.431920] x25: ffff8000191c9010 x24: ffff8000191c9000 
[   29.431948] x23: ffff8000191c9000 x22: 000f800011235acc 
[   29.431975] x21: 0000000000000001 x20: 000f800000000000 
[   29.432003] x19: ffff800011235acc x18: ffff6001cedcc336 
[   29.432031] x17: 0000000000001308 x16: 0000000000000002 
[   29.432058] x15: 0000000000000000 x14: 7261656e696c2d6e 
[   29.432086] x13: ffff600000bfdee7 x12: 1fffe00000bfdee6 
[   29.432113] x11: 1fffe00000bfdee6 x10: ffff600000bfdee6 
[   29.432141] x9 : ffff80001020a928 x8 : ffff000005fef737 
[   29.432169] x7 : 0000000000000001 x6 : ffff600000bfdee7 
[   29.432196] x5 : ffff600000bfdee7 x4 : 1fffe00000bfdedc 
[   29.432223] x3 : 1fffe00000be4009 x2 : ffff600000bfdf5c 
[   29.432251] x1 : 8fd448c3d76ca800 x0 : 0000000000000000 
[   29.432279] Call trace:
[   29.432294]  __virt_to_phys+0x80/0xc0
[   29.432312]  kvm_compute_layout+0x21c/0x264
init_hyp_physvirt_offset at arch/arm64/kvm/va_layout.c:47
(inlined by) kvm_compute_layout at arch/arm64/kvm/va_layout.c:82
[   29.432327]  smp_cpus_done+0x164/0x17c
[   29.432342]  smp_init+0xc4/0xd8
[   29.432358]  kernel_init_freeable+0x4ec/0x734
[   29.432375]  kernel_init+0x18/0x12c
[   29.432391]  ret_from_fork+0x10/0x1c
[   29.432405] irq event stamp: 490612
[   29.432424] hardirqs last  enabled at (490611): [<ffff800010207f60>] console_unlock+0x8e0/0xca0
[   29.432440] hardirqs last disabled at (490612): [<ffff800011212f44>] el1_dbg+0x24/0x50
[   29.432455] softirqs last  enabled at (487946): [<ffff800010010a98>] _stext+0xa98/0x113c
[   29.432473] softirqs last disabled at (487939): [<ffff8000100ec5e8>] irq_exit+0x500/0x5e0
[   29.432492] ---[ end trace 96247b4cbbdf9333 ]---

> +}
> +
>  /*
>   * We want to generate a hyp VA with the following format (with V ==
>   * vabits_actual):
> @@ -54,6 +78,8 @@ __init void kvm_compute_layout(void)
>  		tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
>  	}
>  	tag_val >>= tag_lsb;
> +
> +	init_hyp_physvirt_offset();
>  }
>  
>  static u32 compute_instruction(int n, u32 rd, u32 rn)
> @@ -146,9 +172,7 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
>  	/*
>  	 * Compute HYP VA by using the same computation as kern_hyp_va()
>  	 */
> -	addr = (uintptr_t)kvm_ksym_ref(__kvm_hyp_vector);
> -	addr &= va_mask;
> -	addr |= tag_val << tag_lsb;
> +	addr = __early_kern_hyp_va((u64)kvm_ksym_ref(__kvm_hyp_vector));
>  
>  	/* Use PC[10:7] to branch to the same vector in KVM */
>  	addr |= ((u64)origptr & GENMASK_ULL(10, 7));

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
