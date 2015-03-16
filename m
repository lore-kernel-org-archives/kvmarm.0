From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: "info cpus" issue
Date: Mon, 16 Mar 2015 19:01:46 +0100
Message-ID: <55071A8A.2060408@siemens.com>
References: <5506EA45.1060407@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0D5D48E5C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2015 13:55:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cV7xpYOig+6Y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Mar 2015 13:55:17 -0400 (EDT)
Received: from david.siemens.de (david.siemens.de [192.35.17.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7D1448E10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2015 13:55:17 -0400 (EDT)
In-Reply-To: <5506EA45.1060407@freescale.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Diana Craciun <diana.craciun@freescale.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 2015-03-16 15:35, Diana Craciun wrote:
> Hi,
> 
> I have played the last couple of days with info CPUs command in qemu and
> discovered two issues with it:
> 
> 1. One core is displayed as halted, but the core is actually running ok.
> 
> (qemu) info cpus
> * CPU #0: thread_id=400
>   CPU #1: (halted) thread_id=401
> 
> Looking a little bit into the qemu code, it seems to be relatively
> benign. qemu displays "halted" on info cpus command depending on the
> value of the halted variable, but this variable does not seem to be
> updated in case of qemu + KVM.
> 
> 2. When issuing "info cpus" while the guest is booting bad things
> happen. I saw 3 different behaviours:
> - the guest just freezes during boot
> - the guest crashes (see bellow the crash log)
> - the host/qemu is displaying this message and the guest freezes:
> 
> (qemu) [16777.503115] kvm [400]: load/store instruction decoding not
> implementd
> error: kvm run failed Function not implemented
> 
> I did not get the chance to dig into it, but wanted to let you know
> about this, perhaps is an already known issue?

Can't comment if it's known but, from x86 experiences, such a pattern is
usually related to inconsistency between "get kvm state" and "put kvm
state" in QEMU or the related kernel interfaces:

QEMU obtains the in-kernel CPU state when you issue "info cpus", marks
it as "dirty" (in case other QEMU functions will manipulate it - won't
happen in this case) and then writes it back to the kernel once the
guest is resumed on that vcpu. If the state you get is not fully
reflecting what you will write back, you corrupt the guest.

If you want to debug, follow qmp_query_cpus -> cpu_synchronize_state and
kvm_arch_get_registers (triggered by do_kvm_cpu_synchronize_state) vs.
kvm_arch_put_registers (triggered in kvm_cpu_exec).

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
