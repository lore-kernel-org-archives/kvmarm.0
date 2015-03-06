From: Andrew Jones <drjones@redhat.com>
Subject: the arm cache coherency cluster
Date: Fri,  6 Mar 2015 13:49:40 -0500
Message-ID: <1425667780-3449-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9A8447FB0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:43:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jmNcZ5Mo32dY for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:43:43 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DFB647FAC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:43:43 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

In reply to this message I'll send two series' one for KVM and
one for QEMU. The two series' are their respective component
complements, and attempt to implement cache coherency for arm
guests using emulated devices, where the emulator (qemu) uses
cached memory for the device memory, but the guest uses
uncached - as device memory is generally used. Right now I've
just focused on VGA vram.

This approach starts as the "add a new memslot flag" approach,
and then turns into the "make qemu do some cache maintenance"
approach with the final patch of each series (6/6). It stops
short of the "add syscalls..." approach. Below is a summary of
all the approaches discussed so far, to my knowledge.

"MAIR manipulating"
Posted[1] by Ard. Works. No performance degradation. Potential
issues with device assignment and the guest getting confused.

"add a new memslot flag"
This posting (not counting patches 6/6). Works. Huge performance
degradation.

"make qemu do some cache maintenance"
This posting (patches 6/6). We can only do so much in qemu
without syscalls. This series does what it can. Almost works,
probably could work, after playing 'find the missing flush'.
This approach still requires the new memslot flag, as userspace
can't invalidate the cache, only clean, or clean+invalidate.
No noticeable performance degradation.

"add syscalls to make qemu do all cache maintenance"
Variant 1: implement as kvm ioctls - to avoid trying to get
           syscalls into the general kernel
Variant 2: add real syscalls, or maybe just ARM private SWIs
           like __ARM_NR_cacheflush
This approach should work, and if we add an invalidate syscall,
then we shouldn't need any kvm changes at all, i.e. no need for
the memslot flag. I haven't experimented with this yet, but I'm
starting to like the idea of variant 2, with a private SWI, so
will try to pull something together soon for that.

"describe the problematic memory as cached to the guest"
Not an ideal solution for virt. Could maybe be workable as a
quirk for a specific device though.

re: $SUBJECT; Here 'cluster' is defined by the urban dictionary.

[1] http://thread.gmane.org/gmane.comp.emulators.kvm.arm.devel/34/
