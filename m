Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF73C11F68
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 11:22:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C7FD613F9
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 11:22:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C7FD613F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A43914B0B5;
	Fri,  2 Jul 2021 07:22:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cIsJONDfhe48; Fri,  2 Jul 2021 07:22:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9CC24B0B8;
	Fri,  2 Jul 2021 07:22:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8E374B0B5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 07:22:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sz9JXeOG27MM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 07:22:46 -0400 (EDT)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D14874B08B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 07:22:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=O5Uqso+ww5amQ01DKigcD3vJJ7N3bwtD7LxAeQZ8NGo=; b=JYJbKRCaTtVjDzb/7N8Vg5ALJK
 Z9z+lgf5/nby+DFt32t6/4uiGrBJeKjTLVqqlBekOg4CgVhfQqk4bd+I/0DRjmpHrmNI77IlDRhYn
 JTJlDJI2+gb1fvdiaPk1sAjttTyO6N8hHeBFR/6wiUzGir5xO+zjr18vT2GDa7ueMv3jA0DvapxgS
 sORLkZ7+5aVcnyqMrOOh2sxuewdQjUzEt/H8Pa02qexOzNdz5irUkHr2OVQIQ7TUGNBbfjA6/qU55
 KLYzKy4dbIvNoL9okqBh6IPngAIxJ8W8lD+1vYchcUWAbhBempd1bUMgvDJN85yD8fulHZbpEdfXJ
 Z5/MAk+w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=noisy.programming.kicks-ass.net)
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1lzHFD-00DqNT-HJ; Fri, 02 Jul 2021 11:22:03 +0000
Received: from hirez.programming.kicks-ass.net
 (hirez.programming.kicks-ass.net [192.168.1.225])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (Client did not present a certificate)
 by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 43862300091;
 Fri,  2 Jul 2021 13:22:00 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
 id D797A20244CE2; Fri,  2 Jul 2021 13:22:00 +0200 (CEST)
Date: Fri, 2 Jul 2021 13:22:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-2-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210622094306.8336-2-lingshan.zhu@intel.com>
Cc: wanpengli@tencent.com, Like Xu <like.xu@linux.intel.com>,
 eranian@google.com, weijiang.yang@intel.com, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kan.liang@linux.intel.com, ak@linux.intel.com,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, linux-csky@vger.kernel.org, wei.w.wang@intel.com,
 xen-devel@lists.xenproject.org, liuxiangdong5@huawei.com, bp@alien8.de,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 like.xu.linux@gmail.com, Nick Hu <nickhu@andestech.com>, seanjc@google.com,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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

On Tue, Jun 22, 2021 at 05:42:49PM +0800, Zhu Lingshan wrote:
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 8f71dd72ef95..c71af4cfba9b 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -90,6 +90,27 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_pmu.pebs_aliases);
>   */
>  DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_msrs);
>  
> +DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
> +DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
> +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
> +
> +void arch_perf_update_guest_cbs(void)
> +{
> +	static_call_update(x86_guest_state, (void *)&__static_call_return0);
> +	static_call_update(x86_guest_get_ip, (void *)&__static_call_return0);
> +	static_call_update(x86_guest_handle_intel_pt_intr, (void *)&__static_call_return0);
> +
> +	if (perf_guest_cbs && perf_guest_cbs->state)
> +		static_call_update(x86_guest_state, perf_guest_cbs->state);
> +
> +	if (perf_guest_cbs && perf_guest_cbs->get_ip)
> +		static_call_update(x86_guest_get_ip, perf_guest_cbs->get_ip);
> +
> +	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
> +		static_call_update(x86_guest_handle_intel_pt_intr,
> +				   perf_guest_cbs->handle_intel_pt_intr);
> +}

Coding style wants { } on that last if().
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
