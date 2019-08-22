Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F52C3A59D
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 08:30:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 838932342F
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 08:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 838932342F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E72784A5A9;
	Thu, 22 Aug 2019 04:30:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1DZkNPTG0Jr0; Thu, 22 Aug 2019 04:30:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6BEA4A581;
	Thu, 22 Aug 2019 04:30:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76CD34A57F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 04:30:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XStMxUVzIK4U for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 04:30:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EF7F4A55D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 04:30:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3E0D344;
 Thu, 22 Aug 2019 01:30:46 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 E11A33F706; Thu, 22 Aug 2019 01:30:45 -0700 (PDT)
Subject: Re: [PATCH] arm64: KVM: Only skip MMIO insn once
To: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190821195030.2569-1-drjones@redhat.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <177091d5-2d2c-6a75-472c-92702ee98e86@kernel.org>
Date: Thu, 22 Aug 2019 09:30:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821195030.2569-1-drjones@redhat.com>
Content-Language: en-US
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

Hi Drew,

On 21/08/2019 20:50, Andrew Jones wrote:
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
> ---
>  virt/kvm/arm/arm.c  | 3 ++-
>  virt/kvm/arm/mmio.c | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 35a069815baf..322cf9030bbe 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -669,7 +669,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	if (ret)
>  		return ret;
>  
> -	if (run->exit_reason == KVM_EXIT_MMIO) {
> +	if (vcpu->mmio_needed) {
> +		vcpu->mmio_needed = 0;
>  		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
>  		if (ret)
>  			return ret;
> diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> index a8a6a0c883f1..2d9b5e064ae0 100644
> --- a/virt/kvm/arm/mmio.c
> +++ b/virt/kvm/arm/mmio.c
> @@ -201,6 +201,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	if (is_write)
>  		memcpy(run->mmio.data, data_buf, len);
>  	vcpu->stat.mmio_exit_user++;
> +	vcpu->mmio_needed	= 1;
>  	run->exit_reason	= KVM_EXIT_MMIO;
>  	return 0;
>  }
> 

Thanks for this. That's quite embarrassing. Out of curiosity,
how was this spotted?

Patch wise, I'd have a small preference for the following (untested)
patch, as it keeps the mmio_needed accesses close together, making
it easier to read (at least for me). What do you think?

	M.

diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index a8a6a0c883f1..6af5c91337f2 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -86,6 +86,12 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	unsigned int len;
 	int mask;
 
+	/* Detect an already handled MMIO return */
+	if (unlikely(!vcpu->mmio_needed))
+		return 0;
+
+	vcpu->mmio_needed = 0;
+
 	if (!run->mmio.is_write) {
 		len = run->mmio.len;
 		if (len > sizeof(unsigned long))
@@ -188,6 +194,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	run->mmio.is_write	= is_write;
 	run->mmio.phys_addr	= fault_ipa;
 	run->mmio.len		= len;
+	vcpu->mmio_needed	= 1;
 
 	if (!ret) {
 		/* We handled the access successfully in the kernel. */
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
