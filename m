Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE299C433E6
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 13:44:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7885F64F65
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 13:44:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7885F64F65
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 183A44B17E;
	Tue,  2 Feb 2021 08:44:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O8QqeXvN6wHO; Tue,  2 Feb 2021 08:44:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A6484B171;
	Tue,  2 Feb 2021 08:44:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C33894B171
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 08:44:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p2e8w8R6onKb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 08:44:50 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B46384B14E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 08:44:50 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A4B2764FDB;
 Tue,  2 Feb 2021 13:44:49 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l6vz5-00BVMI-JP; Tue, 02 Feb 2021 13:44:47 +0000
MIME-Version: 1.0
Date: Tue, 02 Feb 2021 13:44:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [PATCH v16 9/9] arm64: Add kvm capability check extension for
 ptp_kvm
In-Reply-To: <20201209060932.212364-10-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
 <20201209060932.212364-10-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <13893254f802799ba44b9a35317b32f5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org,
 yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
 pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com,
 Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
 Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: justin.he@arm.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
 richardcochran@gmail.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, steven.price@arm.com, Andre.Przywara@arm.com,
 john.stultz@linaro.org, yangbo.lu@nxp.com, pbonzini@redhat.com,
 tglx@linutronix.de, nd@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-12-09 06:09, Jianyong Wu wrote:
> Let userspace check if there is kvm ptp service in host.
> Before VMs migrate to another host, VMM may check if this
> cap is available to determine the next behavior.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c     | 1 +
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index f60f4a5e1a22..1bb1f64f9bb5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -199,6 +199,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
> long ext)
>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_VCPU_ATTRIBUTES:
> +	case KVM_CAP_PTP_KVM:
>  		r = 1;
>  		break;
>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..797c40bbc31f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1053,6 +1053,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_X86_USER_SPACE_MSR 188
>  #define KVM_CAP_X86_MSR_FILTER 189
>  #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
> +#define KVM_CAP_PTP_KVM 191
> 
>  #ifdef KVM_CAP_IRQ_ROUTING

This really should be squashed with the patch implementing
the hypercall.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
