Return-Path: <SRS0=T+3t=CE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301DEC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 26 Aug 2020 18:10:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A31B3207DF
	for <kvmarm@archiver.kernel.org>; Wed, 26 Aug 2020 18:10:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A31B3207DF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06D354BD23;
	Wed, 26 Aug 2020 14:10:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RhjZrudnW6Ut; Wed, 26 Aug 2020 14:10:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0E3B4BB85;
	Wed, 26 Aug 2020 14:10:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52AA54BB3F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Aug 2020 14:10:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id liHaBwFbmSaa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Aug 2020 14:10:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3842F4BB25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Aug 2020 14:10:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 762C5101E;
 Wed, 26 Aug 2020 11:10:01 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8293A3F71F;
 Wed, 26 Aug 2020 11:09:58 -0700 (PDT)
Subject: Re: [PATCH] arm(64)/kvm: improve the documentation about HVC calls
To: Pingfan Liu <kernelfans@gmail.com>
References: <1597241133-3630-1-git-send-email-kernelfans@gmail.com>
From: James Morse <james.morse@arm.com>
Message-ID: <50ccd1aa-797f-bc97-d675-8d6732d9ae06@arm.com>
Date: Wed, 26 Aug 2020 19:09:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1597241133-3630-1-git-send-email-kernelfans@gmail.com>
Content-Language: en-GB
Cc: Marc Zyngier <maz@kernel.org>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

Hi Pingfan,

On 12/08/2020 15:05, Pingfan Liu wrote:
> Both arm and arm64 kernel entry point have the following prerequisite:
>   MMU = off, D-cache = off, I-cache = dont care.
> 
> HVC_SOFT_RESTART call should meet this prerequisite before jumping to the
> new kernel.

I think you have this the wrong way up. This should describe what HVC_SOFT_RESTART does.

We want to remove some extra work kexec does on arm64, and both implementations of
HVC_SOFT_RESTART on arm64 already do what we need. The change here should be to document
that the D/I bits are cleared after a HVC_SOFT_RESTART on arm64.


> Furthermore, on arm64, el2_setup doesn't set I+C bits and keeps EL2 MMU
> off, and KVM resets them when its unload. These are achieved by
> HVC_RESET_VECTORS call.
> 
> Improve the document.


> diff --git a/Documentation/virt/kvm/arm/hyp-abi.rst b/Documentation/virt/kvm/arm/hyp-abi.rst
> index d9eba93..a95bc30 100644
> --- a/Documentation/virt/kvm/arm/hyp-abi.rst
> +++ b/Documentation/virt/kvm/arm/hyp-abi.rst
> @@ -40,9 +40,9 @@ these functions (see arch/arm{,64}/include/asm/virt.h):
>  
>  * ::
>  
> -    r0/x0 = HVC_RESET_VECTORS
> +    x0 = HVC_RESET_VECTORS (arm64 only)
>  
> -  Turn HYP/EL2 MMU off, and reset HVBAR/VBAR_EL2 to the initials
> +  Disable HYP/EL2 MMU and D-cache, and reset HVBAR/VBAR_EL2 to the initials
>    stubs' exception vector value. This effectively disables an existing
>    hypervisor.

I don't think we should remove this. KVM on 32bit was the only implementer, but if there
ever is another, this is how it should work.


> @@ -54,7 +54,7 @@ these functions (see arch/arm{,64}/include/asm/virt.h):
>      x3 = x1's value when entering the next payload (arm64)
>      x4 = x2's value when entering the next payload (arm64)
>  
> -  Mask all exceptions, disable the MMU, move the arguments into place
> +  Mask all exceptions, disable the MMU and D-cache, move the arguments into place
>    (arm64 only), and jump to the restart address while at HYP/EL2. This
>    hypercall is not expected to return to its caller.

(I don't think disable the D-cache is what the bit does, it forces the attributes that are
used for a data access).

Please just describe this as the on arm64 the D and I bits are cleared.
(it might be true on 32bit, I can't work the assembly out).


Thanks,

James



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
