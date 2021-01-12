Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1780C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 15:39:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DDF22311B
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 15:39:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DDF22311B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CE244B18C;
	Tue, 12 Jan 2021 10:39:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mp4MmrFZY3JG; Tue, 12 Jan 2021 10:39:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35D0C4B1AB;
	Tue, 12 Jan 2021 10:39:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 513234B18C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 10:39:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LbTijmott3zs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 10:39:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2000D4B151
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 10:39:47 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FACC1FB;
 Tue, 12 Jan 2021 07:39:46 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92BFB3F719;
 Tue, 12 Jan 2021 07:39:44 -0800 (PST)
Subject: Re: [PATCH 6/9] docs: kvm: devices/arm-vgic-v3: enhance
 KVM_DEV_ARM_VGIC_CTRL_INIT doc
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-7-eric.auger@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4c0b3988-904c-a922-d0be-87a354c3203c@arm.com>
Date: Tue, 12 Jan 2021 15:39:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201212185010.26579-7-eric.auger@redhat.com>
Content-Language: en-US
Cc: shuah@kernel.org, pbonzini@redhat.com
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

Hi Eric,

On 12/12/20 6:50 PM, Eric Auger wrote:
> kvm_arch_vcpu_precreate() returns -EBUSY if the vgic is
> already initialized. So let's document that KVM_DEV_ARM_VGIC_CTRL_INIT
> must be called after all vcpu creations.

Checked and this is indeed the case,
kvm_vm_ioctl_create_vcpu()->kvm_arch_vcpu_precreate() returns -EBUSY is
vgic_initialized() is true.

>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  Documentation/virt/kvm/devices/arm-vgic-v3.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> index 5dd3bff51978..322de6aebdec 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> @@ -228,7 +228,7 @@ Groups:
>  
>      KVM_DEV_ARM_VGIC_CTRL_INIT
>        request the initialization of the VGIC, no additional parameter in
> -      kvm_device_attr.addr.
> +      kvm_device_attr.addr. Must be called after all vcpu creations.

Nitpick here: the document writes VCPU with all caps. This also sounds a bit
weird, I think something like "Must be called after all VCPUs have been created"
is clearer.

Thanks,
Alex
>      KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
>        save all LPI pending bits into guest RAM pending tables.
>  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
