From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 00/13] kvm: selftests: add aarch64 framework and dirty
Date: Mon, 29 Oct 2018 18:40:02 +0100
Message-ID: <20181029174002.GB12057@e113682-lin.lund.arm.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 011884A2B7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Oct 2018 13:40:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M46zPji0b1VS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Oct 2018 13:40:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 608AE4A236
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Oct 2018 13:40:05 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180918175436.19742-1-drjones@redhat.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On Tue, Sep 18, 2018 at 07:54:23PM +0200, Andrew Jones wrote:
> This series provides KVM selftests that test dirty log tracking on
> AArch64 for both 4K and 64K guest page sizes. Additionally the
> framework provides an easy way to test dirty log tracking with the
> recently posted dynamic IPA and 52bit IPA series[1].

I was trying to parse the commit text of patch 2, and I realized that I
don't understand the 'hypercall to userspace' thing at all, which
probably means I have no idea how the selftests work overall.

I then spent a while reading various bits of documentation in the kernel
tree, LWN, etc., only to realize that I don't understand how this test
framework actually works.

Are the selftests modules, userspace programs, or code that is compiled
with the kernel, and (somehow?) run from userspace.  I thought the
latter, partially based on your explanation at ELC, but then I don't
understand how the "compile and run" make target works.

Can you help me paint the overall picture, or point me to the piece of
documentation/presentation that explains the high-level picture, which I
must have obviously missed somehow?


Thanks!

    Christoffer

> 
> The series breaks down into parts as follows:
> 
>  01-02: generalize guest code to host userspace exit support by
>         introducing "ucalls" - hypercalls to userspace
>  03-05: prepare common code for a new architecture
>  06-07: add virtual memory setup support for AArch64
>     08: add vcpu setup support for AArch64
>     09: port the dirty log test to AArch64
>  10-11: add 64K guest page size support for the dirty log test
>  12-13: prepare the dirty log test to also test > 40-bit guest
>         physical address setups by allowing the test memory
>         region to be placed at the top of physical memory
> 
> [1] https://www.spinics.net/lists/arm-kernel/msg676819.html
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (13):
>   kvm: selftests: vcpu_setup: set cr4.osfxsr
>   kvm: selftests: introduce ucall
>   kvm: selftests: move arch-specific files to arch-specific locations
>   kvm: selftests: add cscope make target
>   kvm: selftests: tidy up kvm_util
>   kvm: selftests: add vm_phy_pages_alloc
>   kvm: selftests: add virt mem support for aarch64
>   kvm: selftests: add vcpu support for aarch64
>   kvm: selftests: port dirty_log_test to aarch64
>   kvm: selftests: introduce new VM mode for 64K pages
>   kvm: selftests: dirty_log_test: also test 64K pages on aarch64
>   kvm: selftests: stop lying to aarch64 tests about PA-bits
>   kvm: selftests: support high GPAs in dirty_log_test
> 
>  tools/testing/selftests/kvm/.gitignore        |  11 +-
>  tools/testing/selftests/kvm/Makefile          |  36 +-
>  tools/testing/selftests/kvm/dirty_log_test.c  | 374 +++++++++----
>  .../selftests/kvm/include/aarch64/processor.h |  55 ++
>  .../testing/selftests/kvm/include/kvm_util.h  | 166 +++---
>  .../testing/selftests/kvm/include/sparsebit.h |   6 +-
>  .../testing/selftests/kvm/include/test_util.h |   6 +-
>  .../kvm/include/{x86.h => x86_64/processor.h} |  24 +-
>  .../selftests/kvm/include/{ => x86_64}/vmx.h  |   6 +-
>  .../selftests/kvm/lib/aarch64/processor.c     | 311 +++++++++++
>  tools/testing/selftests/kvm/lib/assert.c      |   2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 499 +++++++-----------
>  .../selftests/kvm/lib/kvm_util_internal.h     |  33 +-
>  tools/testing/selftests/kvm/lib/ucall.c       | 144 +++++
>  .../kvm/lib/{x86.c => x86_64/processor.c}     | 197 ++++++-
>  .../selftests/kvm/lib/{ => x86_64}/vmx.c      |   4 +-
>  .../kvm/{ => x86_64}/cr4_cpuid_sync_test.c    |  14 +-
>  .../kvm/{ => x86_64}/set_sregs_test.c         |   2 +-
>  .../selftests/kvm/{ => x86_64}/state_test.c   |  25 +-
>  .../kvm/{ => x86_64}/sync_regs_test.c         |   2 +-
>  .../kvm/{ => x86_64}/vmx_tsc_adjust_test.c    |  23 +-
>  21 files changed, 1329 insertions(+), 611 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/processor.h
>  rename tools/testing/selftests/kvm/include/{x86.h => x86_64/processor.h} (98%)
>  rename tools/testing/selftests/kvm/include/{ => x86_64}/vmx.h (99%)
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/processor.c
>  create mode 100644 tools/testing/selftests/kvm/lib/ucall.c
>  rename tools/testing/selftests/kvm/lib/{x86.c => x86_64/processor.c} (85%)
>  rename tools/testing/selftests/kvm/lib/{ => x86_64}/vmx.c (99%)
>  rename tools/testing/selftests/kvm/{ => x86_64}/cr4_cpuid_sync_test.c (91%)
>  rename tools/testing/selftests/kvm/{ => x86_64}/set_sregs_test.c (98%)
>  rename tools/testing/selftests/kvm/{ => x86_64}/state_test.c (90%)
>  rename tools/testing/selftests/kvm/{ => x86_64}/sync_regs_test.c (99%)
>  rename tools/testing/selftests/kvm/{ => x86_64}/vmx_tsc_adjust_test.c (91%)
> 
> -- 
> 2.17.1
> 
