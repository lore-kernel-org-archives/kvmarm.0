Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0CAC3A5A1
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 11:59:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA311233A0
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 11:59:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA311233A0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02F594A5E0;
	Thu, 22 Aug 2019 07:59:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JSGJErd9sMJ3; Thu, 22 Aug 2019 07:59:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC10A4A5CF;
	Thu, 22 Aug 2019 07:59:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7F654A5CF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 07:59:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P4UQW0qOyWkJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 07:59:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FC7C4A59E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 07:59:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27330337;
 Thu, 22 Aug 2019 04:59:32 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74E833F718;
 Thu, 22 Aug 2019 04:59:31 -0700 (PDT)
Date: Thu, 22 Aug 2019 12:59:23 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2] arm64: KVM: Only skip MMIO insn once
Message-ID: <20190822115923.GA33080@lakrids.cambridge.arm.com>
References: <20190822110305.18035-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190822110305.18035-1-drjones@redhat.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Thu, Aug 22, 2019 at 01:03:05PM +0200, Andrew Jones wrote:
> If after an MMIO exit to userspace a VCPU is immediately run with an
> immediate_exit request, such as when a signal is delivered or an MMIO
> emulation completion is needed, then the VCPU completes the MMIO
> emulation and immediately returns to userspace. As the exit_reason
> does not get changed from KVM_EXIT_MMIO in these cases we have to
> be careful not to complete the MMIO emulation again, when the VCPU is
> eventually run again, because the emulation does an instruction skip
> (and doing too many skips would be a waste of guest code :-) We need
> to use additional VCPU state to track if the emulation is complete.
> As luck would have it, we already have 'mmio_needed', which even
> appears to be used in this way by other architectures already.
> 
> Fixes: 0d640732dbeb ("arm64: KVM: Skip MMIO insn after emulation")
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Ouch; sorry about this!

I haven't dug too deeply, but from the commit message, the below makes
sense to me. FWIW:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
> v2: move mmio_needed use closer to other mmio state use [maz]
> 
>  virt/kvm/arm/mmio.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> index a8a6a0c883f1..6af5c91337f2 100644
> --- a/virt/kvm/arm/mmio.c
> +++ b/virt/kvm/arm/mmio.c
> @@ -86,6 +86,12 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	unsigned int len;
>  	int mask;
>  
> +	/* Detect an already handled MMIO return */
> +	if (unlikely(!vcpu->mmio_needed))
> +		return 0;
> +
> +	vcpu->mmio_needed = 0;
> +
>  	if (!run->mmio.is_write) {
>  		len = run->mmio.len;
>  		if (len > sizeof(unsigned long))
> @@ -188,6 +194,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	run->mmio.is_write	= is_write;
>  	run->mmio.phys_addr	= fault_ipa;
>  	run->mmio.len		= len;
> +	vcpu->mmio_needed	= 1;
>  
>  	if (!ret) {
>  		/* We handled the access successfully in the kernel. */
> -- 
> 2.18.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
