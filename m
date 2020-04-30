Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076A0C8300B
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 10:36:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C89320838
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 10:36:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C89320838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 098DE4B51B;
	Thu, 30 Apr 2020 06:36:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r2okyvFXL09e; Thu, 30 Apr 2020 06:36:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCB644B4E8;
	Thu, 30 Apr 2020 06:36:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E5B04B4B1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 06:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfTjbSJPKeLm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 06:36:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E374B4AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 06:36:54 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B27C61063;
 Thu, 30 Apr 2020 03:36:53 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A03223F68F;
 Thu, 30 Apr 2020 03:36:49 -0700 (PDT)
Date: Thu, 30 Apr 2020 11:36:46 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Message-ID: <20200430103646.GB39784@C02TD0UTHF1T.local>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-6-jianyong.wu@arm.com>
 <20200421095736.GB16306@C02TD0UTHF1T.local>
 <ab629714-c08c-2155-dd13-ad25e7f60b39@arm.com>
 <20200424103953.GD1167@C02TD0UTHF1T.local>
 <b53b0a47-1fe6-ad92-05f4-80d50980c587@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b53b0a47-1fe6-ad92-05f4-80d50980c587@arm.com>
Cc: "maz@kernel.org" <maz@kernel.org>, Justin He <Justin.He@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Steven Price <Steven.Price@arm.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, nd <nd@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Tue, Apr 28, 2020 at 07:14:52AM +0100, Jianyong Wu wrote:
> On 2020/4/24 6:39 PM, Mark Rutland wrote:
> > On Fri, Apr 24, 2020 at 03:50:22AM +0100, Jianyong Wu wrote:
> >> On 2020/4/21 5:57 PM, Mark Rutland wrote:
> >>> On Tue, Apr 21, 2020 at 11:23:00AM +0800, Jianyong Wu wrote:
> >>>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> >>>> index 550dfa3e53cd..a5309c28d4dc 100644
> >>>> --- a/virt/kvm/arm/hypercalls.c
> >>>> +++ b/virt/kvm/arm/hypercalls.c
> >>>> @@ -62,6 +66,44 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >>>>    if (gpa != GPA_INVALID)
> >>>>    val = gpa;
> >>>>    break;
> >>>> +/*
> >>>> + * This serves virtual kvm_ptp.
> >>>> + * Four values will be passed back.
> >>>> + * reg0 stores high 32-bit host ktime;
> >>>> + * reg1 stores low 32-bit host ktime;
> >>>> + * reg2 stores high 32-bit difference of host cycles and cntvoff;
> >>>> + * reg3 stores low 32-bit difference of host cycles and cntvoff.
> >>>> + */
> >>>> +case ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
> >>> Shouldn't the host opt-in to providing this to the guest, as with other
> >>> features?
> >> er, do you mean that "ARM_SMCCC_HV_PV_TIME_XXX" as "opt-in"? if so, I
> >> think this
> >>
> >> kvm_ptp doesn't need a buddy. the driver in guest will call this service
> >> in a definite way.
> > I mean that when creating the VM, userspace should be able to choose
> > whether the PTP service is provided to the guest. The host shouldn't
> > always provide it as there may be cases where doing so is undesireable.
> >
> I think I have implemented in patch 9/9 that userspace can get the info
> that if the host offers the kvm_ptp service. But for now, the host
> kernel will always offer the kvm_ptp capability in the current
> implementation. I think x86 follow the same behavior (see [1]). so I
> have not considered when and how to disable this kvm_ptp service in
> host. Do you think we should offer this opt-in?

I think taht should be opt-in, yes.

[...]

> > It's also not clear to me what notion of host time is being exposed to
> > the guest (and consequently how this would interact with time changes on
> > the host, time namespaces, etc). Having some description of that would
> > be very helpful.
> 
> sorry to have not made it clear.
> 
> Time will not change in host and only time in guest will change to sync
> with host. host time is the target that time in guest want to adjust to.
> guest need to get the host time then compute the different of the time
> in guest and host, so the guest can adjust the time base on the difference.

I understood that host time wouldn't change here, but what was not clear
is which notion of host time is being exposed to the guest.

e.g. is that a raw monotonic clock, or one subject to periodic adjument,
or wall time in the host? What is the epoch of the host time?

> I will add the base principle of time sync service in guest using
> kvm_ptp in commit message.

That would be great; thanks!

Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
