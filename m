From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 0/4] KVM: arm/arm64: guest synchronous halt/resume
Date: Thu, 15 Oct 2015 14:17:32 +0200
Message-ID: <20151015121732.GD21930@cbox>
References: <1443217277-13173-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F50A411E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 08:14:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rAxAa2vVEEkj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 08:14:50 -0400 (EDT)
Received: from mail-lb0-f169.google.com (mail-lb0-f169.google.com
 [209.85.217.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34DF341022
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 08:14:49 -0400 (EDT)
Received: by lbwr8 with SMTP id r8so67234178lbw.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 05:17:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1443217277-13173-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 25, 2015 at 11:41:13PM +0200, Eric Auger wrote:
> This series introduces the capability to synchronously exit the guest
> and prevent it from being re-entered. This modality will be used by
> IRQ forwarding series when changing the state of the IRQ.
> 
> Former pause flag used when starting the vcpu in KVM_ARM_VCPU_POWER_OFF
> state, in PSCI calls and in KVM_SET_MP_STATE ioctl is renamed into
> power_off. A new pause flag is introduced. Both now are checked in
> kvm_arch_vcpu_runnable and in the VCPU_RUN critical section, before
> entering the vcpu.
> 
Thanks - applied,
-Christoffer
