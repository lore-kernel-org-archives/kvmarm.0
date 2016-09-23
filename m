From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 23 Sep 2016 14:11:41 +0200
Message-ID: <dd9267b6-2323-2d74-0553-71a89d05a654@redhat.com>
References: <1474628854-69945-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C87949B5B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 08:02:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LwFjP4WBhUvq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2016 08:02:32 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C12DC49B44
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 08:02:32 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id l132so2488960wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:11:44 -0700 (PDT)
In-Reply-To: <1474628854-69945-1-git-send-email-agraf@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 23/09/2016 13:07, Alexander Graf wrote:
> +		timer_ret = kvm_timer_sync_hwstate(vcpu);
>  
>  		kvm_vgic_sync_hwstate(vcpu);
>  
>  		preempt_enable();
>  
>  		ret = handle_exit(vcpu, run, ret);
> +
> +		if ((ret == 1) && timer_ret) {
> +			/*
> +			 * We have to exit straight away to ensure that we only
> +			 * ever notify user space once about a level change
> +			 */

Is this really a requirement?  It complicates the logic noticeably.

Paolo

> +			ret = -EINTR;
> +			run->exit_reason = KVM_EXIT_INTR;
> +		}
>  	}
