From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 7/11] KVM: Remove redundant check in the
 kvm_get_dirty_log_protect()
Date: Mon, 7 Jan 2019 17:20:30 +0100
Message-ID: <dad62bfb-e4c0-266f-ff36-8344d3952ba0@redhat.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
 <20190104085405.40356-8-Tianyu.Lan@microsoft.com>
 <20190104155036.GA11288@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B4824A376
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jan 2019 11:20:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fXMY3DJKfD7T for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jan 2019 11:20:38 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AE634A36B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jan 2019 11:20:38 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id c14so1064638wrr.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Jan 2019 08:20:38 -0800 (PST)
In-Reply-To: <20190104155036.GA11288@linux.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sean Christopherson <sean.j.christopherson@intel.com>, lantianyu1986@gmail.com
Cc: kvm@vger.kernel.org, benh@kernel.crashing.org, will.deacon@arm.com, linux-mips@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, catalin.marinas@arm.com, jhogan@kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/01/19 16:50, Sean Christopherson wrote:
> Tangentially related, does mmu_lock actually need to be held while we
> walk dirty_bitmap in kvm_{clear,get}_dirty_log_protect()?  The bitmap
> itself is protected by slots_lock (a lockdep assertion would be nice
> too), e.g. can we grab the lock iff dirty_bitmap[i] != 0?

Yes, we could avoid grabbing it as long as the bitmap is zero.  However,
without kvm->manual_dirty_log_protect, the granularity of
kvm_get_dirty_log_protect() is too coarse so it won't happen in
practice.  Instead, with the new manual clear,
kvm_get_dirty_log_protect() does not take the lock and a well-written
userspace is not going to call the clear ioctl unless some bits are set.

Paolo
