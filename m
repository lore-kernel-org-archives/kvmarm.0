From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Tue, 3 Mar 2015 18:32:28 +0000
Message-ID: <20150303183228.GR28951@e104818-lin.cambridge.arm.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: lersek@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, agraf@suse.de
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 19, 2015 at 10:54:43AM +0000, Ard Biesheuvel wrote:
> This is a 0th order approximation of how we could potentially force the guest
> to avoid uncached mappings, at least from the moment the MMU is on. (Before
> that, all of memory is implicitly classified as Device-nGnRnE)

That's just for data accesses. IIRC instructions are cacheable on ARMv8
(though I think without allocation in the unified caches).

> The idea (patch #2) is to trap writes to MAIR_EL1, and replace uncached mappings
> with cached ones. This way, there is no need to mangle any guest page tables.

There is another big downside to this - breaking the guest assumptions
about the (non-)cacheability of its mappings. It also only works for
guests that use MAIR_EL1 (LPAE).

We have two main cases where the guest and host cacheability do not
match:

1. During boot, as you said, when the MMU is off. What we have done in
   the guest kernel is to invalidate the data ranges that it writes with
   the MMU off in case there were any speculatively loaded cache lines
   via the cacheable mappings (in the host). We don't have any nice
   solution in the host here and MAIR_EL1 tweaking does not work

2. Guest explicitly creating a non-cacheable mapping (MMU enabled). Here
   we have two sub-cases:
   a) guest-only accesses to such mapping. The guest would need to
      perform cache maintenance as required if it ever accesses such
      memory via cacheable mappings (we do this already, see the
      streaming DMA API)
   b) memory shared with the host: e.g Qemu emulating DMA (frame buffer
      etc.)

This 2.b case is not any different than the OS dealing with a
(non-)coherent DMA-capable device. If the device is coherent, the
DMA buffer in the guest must be coherent as well, otherwise
non-coherent. Imagine a real VGA device that always snoops CPU caches.
You would not create a non-cacheable frame buffer mapping since the
device cannot see the updates and only read stale cache entries.

We don't (can't) have a safe set of DMA ops that would work in both
cases. So if Qemu cannot use a non-cacheable mapping or cannot perform
cache maintenance, the only solution is to tell the guest that such
virtual device is cache _coherent_. This also gives you better
performance overall anyway.

-- 
Catalin
