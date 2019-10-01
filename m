Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C81ECE58A
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 17:19:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B349205C9
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 17:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B349205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E8924A6D3;
	Tue,  1 Oct 2019 13:19:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X5QxqJWF6TL5; Tue,  1 Oct 2019 13:19:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3E834A69F;
	Tue,  1 Oct 2019 13:19:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88CA14A67F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 13:19:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kuA6n2cE+VNr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 13:19:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41CCD4A65C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 13:19:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B28001570;
 Tue,  1 Oct 2019 10:19:40 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0BF1A3F918;
 Tue,  1 Oct 2019 10:19:32 -0700 (PDT)
Subject: Re: [RFC PATCH 2/2] kvm/arm64: expose hypercall_forwarding capability
To: Heyi Guo <guoheyi@huawei.com>
References: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
 <1569338454-26202-3-git-send-email-guoheyi@huawei.com>
From: James Morse <james.morse@arm.com>
Message-ID: <bd2c398b-7703-03a2-052b-1414630d0b43@arm.com>
Date: Tue, 1 Oct 2019 18:19:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1569338454-26202-3-git-send-email-guoheyi@huawei.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Heyi,

On 24/09/2019 16:20, Heyi Guo wrote:
> Add new KVM capability "KVM_CAP_FORWARD_HYPERCALL" for user space to
> probe whether KVM supports forwarding hypercall.
> 
> The capability should be enabled by user space explicitly, for we
> don't want user space application to deal with unexpected hypercall
> exits. We also use an additional argument to pass exception bit mask,
> to request KVM to forward all hypercalls except the classes specified
> in the bit mask.
> 
> Currently only PSCI can be set as exception, so that we can still keep
> consistent with the old PSCI processing flow.

I agree this needs to be default-on, but I don't think this exclusion mechanism is extensible.


> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index f4a8ae9..2201b62 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -102,6 +105,28 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	return r;
>  }
>  
> +int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> +			    struct kvm_enable_cap *cap)
> +{
> +	if (cap->flags)
> +		return -EINVAL;
> +
> +	switch (cap->cap) {
> +	case KVM_CAP_FORWARD_HYPERCALL: {
> +		__u64 exclude_flags = cap->args[0];

and if there are more than 64 things to exclude?


> +		/* Only support excluding PSCI right now */
> +		if (exclude_flags & ~KVM_CAP_FORWARD_HYPERCALL_EXCL_PSCI)
> +			return -EINVAL;

Once we have a 65th bit, older kernels will let user-space set it, but nothing happens.


> +		kvm->arch.hypercall_forward = true;
> +		if (exclude_flags & KVM_CAP_FORWARD_HYPERCALL_EXCL_PSCI)
> +			kvm->arch.hypercall_excl_psci = true;
> +		return 0;
> +	}
> +	}
> +
> +	return -EINVAL;
> +}

While 4*64 'named bits' for SMC/HVC ranges might be enough, it is tricky to work with.
Both the kernel and user-space have to maintain a list of bit->name and
name->call-number-range, which may change over time.

A case in point: According to PSCI's History (Section 7 of DEN022D), PSCIv1.1 added
SYSTEM_RESET2, MEM_PROTECT and MEM_PROTECT_CHECK_RANGE.

I think its simpler for the HYPERCALL thing to act as a catch-all, and we provide
something to enumerate the list of function id's the kernel implements.

We can then add controls to disable the PSCI (which I think is the only one we have a case
for disabling). I think the PSCI disable should wait until it has a user.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
