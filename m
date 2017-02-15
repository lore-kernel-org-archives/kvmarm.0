From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: race-free exit from KVM_RUN without POSIX signals
Date: Wed, 15 Feb 2017 16:56:42 +0100
Message-ID: <1359d10f-1bee-e295-912d-8cdc5bf7a98c@redhat.com>
References: <1487169821-14806-1-git-send-email-pbonzini@redhat.com>
 <2f9cd5cd-1bb5-0d9e-cb84-26615b211523@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D50F40B5B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Feb 2017 10:55:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VCVi+Ct2Oo3V for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Feb 2017 10:55:55 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DF65405DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Feb 2017 10:55:54 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id c85so8901483wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Feb 2017 07:56:41 -0800 (PST)
In-Reply-To: <2f9cd5cd-1bb5-0d9e-cb84-26615b211523@de.ibm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christian Borntraeger <borntraeger@de.ibm.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: james.hogan@imgtec.com, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, paulus@samba.org, cornelia.huck@de.ibm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 15/02/2017 16:24, Christian Borntraeger wrote:
> On 02/15/2017 03:43 PM, Paolo Bonzini wrote:
>> The purpose of the KVM_SET_SIGNAL_MASK API is to let userspace "kick"
>> a VCPU out of KVM_RUN through a POSIX signal.  A signal is attached
>> to a dummy signal handler; by blocking the signal outside KVM_RUN and
>> unblocking it inside, this possible race is closed:
>>
>>           VCPU thread                     service thread
>>    --------------------------------------------------------------
>>         check flag
>>                                           set flag
>>                                           raise signal
>>         (signal handler does nothing)
>>         KVM_RUN
>>
>> However, one issue with KVM_SET_SIGNAL_MASK is that it has to take
>> tsk->sighand->siglock on every KVM_RUN.  This lock is often on a
>> remote NUMA node, because it is on the node of a thread's creator.
>> Taking this lock can be very expensive if there are many userspace
>> exits (as is the case for SMP Windows VMs without Hyper-V reference
>> time counter).
>>
>> As an alternative, we can put the flag directly in kvm_run so that
>> KVM can see it:
>>
>>           VCPU thread                     service thread
>>    --------------------------------------------------------------
>>                                           raise signal
>>         signal handler
>>           set run->immediate_exit
>>         KVM_RUN
>>           check run->immediate_exit
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> 
> Generic parts, the concept and the s390 parts looks good. (not tested yet, though)

Note that this series doesn't work (due to David's suggestion) with the
patches I posted last week.

Paolo
