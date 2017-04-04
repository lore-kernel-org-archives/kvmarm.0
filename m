From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 20:59:16 +0200
Message-ID: <3fc1cc66-89f3-f495-b64c-c9ec4f26e74c@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com> <20170404160417.GN11752@cbox>
 <06b2a225-192c-9c96-c092-6e0575dd9410@redhat.com>
 <20170404171953.GP11752@cbox>
 <e3977a97-a240-58a6-288d-09f3c12de56c@redhat.com>
 <20170404181829.ipzlym4tm2r5s2fm@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C3AF40BDE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 14:57:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 09QRlZEgNvFM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 14:57:08 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 574D340948
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 14:57:08 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id x124so7459104wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 11:59:20 -0700 (PDT)
In-Reply-To: <20170404181829.ipzlym4tm2r5s2fm@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 04/04/2017 20:18, Andrew Jones wrote:
>> My understanding is that KVM-ARM is using KVM_REQ_VCPU_EXIT simply to
>> reuse the smp_call_function_many code in kvm_make_all_cpus_request.
>> Once you add EXITING_GUEST_MODE, ARM can just add a new function
>> kvm_kick_all_cpus and use it for both pause and power_off.
>
> I was wondering about the justification of
> 'if (vcpu->mode == EXITING_GUEST_MODE)' in the x86 code, as it seemed
> redundant to me with the requests.  I'll have another think on it to see
> if request-less kicks can be satisfied in all cases by this, as long as we
> have the mode setting, barrier, mode checking order ensured in vcpu run.

Yes, this is the justification.  You should add that to
kvm_arch_vcpu_ioctl_run to close the race window (as well as the
kvm_request_pending, just for good measure).  These two are not really
optional, they are part of how kvm_vcpu_exiting_guest_mode and requests
are supposed to work.  kvm_vcpu_exiting_guest_mode is optional, but ARM
is using it and it's a pity to undo it.

Once you have done this, you can choose whether to use requests or not
for pause and poweroff, but I think it will not be necessary.

Paolo
