Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A8CC433E2
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 07:41:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 115EB20825
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 07:41:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IphAvfkg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 115EB20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBD9E4B165;
	Mon, 18 May 2020 03:41:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fPBGNTFINK7t; Mon, 18 May 2020 03:41:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A042D4B173;
	Mon, 18 May 2020 03:41:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77F0B4B167
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 03:41:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5CElKfRpYv+T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 03:41:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 617874B165
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 03:41:51 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 18311207D4;
 Mon, 18 May 2020 07:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1589787710;
 bh=eZnFuYYyPmvrr3tdg9h+knOZFa/PBdnftNG94u6XzeQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=IphAvfkgCBgfqc9vaFcSMYFB8uUZ/vcDxWqucwuujWu0tuCIy916EzUa3QELsAq40
 vxGZz7AZgReTXGedcdeeF6cDxFvJNkiVcjZiUM2h0k6EtmFfes0XieR42j9T8Y3p1A
 buuDrASbT1N/9MVFiAQqG1XXs7B1p4JzGSl59FRE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jaaPE-00DB3j-5a; Mon, 18 May 2020 08:41:48 +0100
MIME-Version: 1.0
Date: Mon, 18 May 2020 08:41:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: Anastassios Nanos <ananos@nubificus.co.uk>
Subject: Re: [PATCH 1/2] KVMM: export needed symbols
In-Reply-To: <33dddce13cd34448620b95db80a28b7b0bb906ad.1589784221.git.ananos@nubificus.co.uk>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
 <33dddce13cd34448620b95db80a28b7b0bb906ad.1589784221.git.ananos@nubificus.co.uk>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <4de58dad6d27aa35fd967d1d77133e55@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ananos@nubificus.co.uk, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
 sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
 jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Thomas Gleixner <tglx@linutronix.de>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-05-18 07:58, Anastassios Nanos wrote:
> Expose a set of KVM functions to the kernel, in order to be
> able to spawn a VM instance without assistance from user-space.
> To handle a guest instance, the system needs access to the following
> functions:
> 
>     kvm_arch_vcpu_run_map_fp
>     kvm_arch_vcpu_ioctl_get_regs
>     kvm_arch_vcpu_ioctl_set_regs
>     kvm_arm_get_reg
>     kvm_arm_set_reg
>     kvm_arch_vcpu_ioctl_get_sregs
>     kvm_arch_vcpu_ioctl_set_sregs
>     kvm_vcpu_preferred_target
>     kvm_vcpu_ioctl_set_cpuid2
>     kvm_vcpu_ioctl_get_cpuid2
>     kvm_dev_ioctl_get_cpuid
>     kvm_arch_vcpu_ioctl_run
>     kvm_arch_vcpu_ioctl_get_regs
>     kvm_arch_vcpu_ioctl_set_regs
>     kvm_arch_vcpu_ioctl_get_sregs
>     kvm_arch_vcpu_ioctl_set_sregs
>     kvm_vcpu_initialized
>     kvm_arch_vcpu_ioctl_run
>     kvm_arch_vcpu_ioctl_vcpu_init
>     kvm_coalesced_mmio_init
>     kvm_create_vm
>     kvm_destroy_vm
>     kvm_vm_ioctl_set_memory_region
>     kvm_vm_ioctl_create_vcpu
> 
> Signed-off-by: Anastassios Nanos <ananos@nubificus.co.uk>
> Signed-off-by: Charalampos Mainas <cmainas@nubificus.co.uk>
> Signed-off-by: Konstantinos Papazafeiropoulos <kostis@nubificus.co.uk>
> Signed-off-by: Stratos Psomadakis <psomas@nubificus.co.uk>
> ---
>  arch/arm64/include/asm/kvm_host.h |  6 ++++
>  arch/arm64/kvm/fpsimd.c           |  6 ++++
>  arch/arm64/kvm/guest.c            | 48 +++++++++++++++++++++++++++++++
>  arch/x86/kvm/cpuid.c              | 25 ++++++++++++++++
>  arch/x86/kvm/x86.c                | 31 ++++++++++++++++++++
>  include/linux/kvm_host.h          | 24 ++++++++++++++++
>  virt/kvm/arm/arm.c                | 18 ++++++++++++
>  virt/kvm/coalesced_mmio.c         |  6 ++++
>  virt/kvm/kvm_main.c               | 23 +++++++++++++++
>  9 files changed, 187 insertions(+)

In general, we don't export synbols without a user in the tree.
And if/when we do, the sensible thing to do would be to export
them as GPL only.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
