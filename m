From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 0/7] Add support for monitoring guest TLB operations
Date: Wed, 17 Aug 2016 17:58:44 +0200
Message-ID: <ed9ce98d-67d2-f01b-6bb0-5c5c842129a5@redhat.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B06410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 11:51:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6MCHapYCYs39 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 11:51:18 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C11C40C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 11:51:18 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id i138so25445990wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 08:58:47 -0700 (PDT)
In-Reply-To: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 16/08/2016 12:45, Punit Agrawal wrote:
> Hi,
> 
> ARMv8 supports trapping guest TLB maintenance operations to the
> hypervisor. This trapping mechanism can be used to monitor the use of
> guest TLB instructions.
> 
> As taking a trap for every TLB operation can have significant
> overhead, trapping should only be enabled -
> 
> * on user request
> * for the VM of interest
> 
> This patchset adds support to listen to perf trace event state change
> notifications. The notifications and associated context are then used
> to enable trapping of guest TLB operations when requested by the
> user. The trap handling generates trace events (kvm_tlb_invalidate)
> which can already be counted using existing perf trace
> functionality.
> 
> Trapping of guest TLB operations is disabled when not being monitored
> (reducing profiling overhead).
> 
> I would appreciate feedback on the approach to tie the control of TLB
> monitoring with perf trace events (Patch 1) especially if there are
> any suggestions on avoiding (or reducing) the overhead of "perf trace"
> notifications.
> 
> I looked at using regfunc/unregfunc tracepoint hooks but they don't
> include the event context. But the bigger problem was that the
> callbacks are only called on the first instance of simultaneously
> executing perf stat invocations.
> 
> The patchset is based on v4.8-rc2 and adds support for monitoring
> guest TLB operations on 64bit hosts. If the approach taken in the
> patches is acceptable, I'll add 32bit host support as well.
> 
> With this patchset, 'perf' tool when attached to a VM process can be
> used to monitor the TLB operations. E.g., to monitor a VM with process
> id 4166 -
> 
> # perf stat -e "kvm:kvm_tlb_invalidate" -p 4166
> 
> Perform some operations in VM (running 'make -j 7' on the kernel
> sources in this instance). Breaking out of perf shows -
> 
> Performance counter stats for process id '4166':
> 
>          7,471,974      kvm:kvm_tlb_invalidate
> 
>      374.235405282 seconds time elapsed
> 
> All feedback welcome.

Can you explain what this is used for?  In other words, why would this
be used instead of just running perf in the guest?

Thanks,

Paolo
