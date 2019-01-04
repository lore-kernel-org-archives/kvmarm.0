From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 7/11] KVM: Remove redundant check in the
 kvm_get_dirty_log_protect()
Date: Fri, 4 Jan 2019 07:50:36 -0800
Message-ID: <20190104155036.GA11288@linux.intel.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
 <20190104085405.40356-8-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190104085405.40356-8-Tianyu.Lan@microsoft.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: lantianyu1986@gmail.com
Cc: kvm@vger.kernel.org, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, ralf@linux-mips.org, paul.burton@mips.com, pbonzini@redhat.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 04, 2019 at 04:54:01PM +0800, lantianyu1986@gmail.com wrote:
> From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> 
> The dirty bits have already been checked in the previous check of
> "dirty_bitmap" and mask must be non-zero value at this point.
> 
> Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
> ---
>  virt/kvm/kvm_main.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf7cc0554094..e75dbb15fd09 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1206,11 +1206,9 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
>  			mask = xchg(&dirty_bitmap[i], 0);
>  			dirty_bitmap_buffer[i] = mask;
>  
> -			if (mask) {
> -				offset = i * BITS_PER_LONG;
> -				kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
> -									offset, mask);
> -			}
> +			offset = i * BITS_PER_LONG;
> +			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
> +								offset, mask);

Hmm, the check against mask was explicitly added by commit 58d2930f4ee3
("KVM: Eliminate extra function calls in kvm_get_dirty_log_protect()").
AFAIK KVM only *sets* bits in dirty_bitmap without holding slots_lock
and/or mmu_lock, so I agree that checking mask is redundant, but it'd be
nice to elaborate a bit more in the changelog.

At the very least this needs a Fixes tag for the aforementioned commit.


Tangentially related, does mmu_lock actually need to be held while we
walk dirty_bitmap in kvm_{clear,get}_dirty_log_protect()?  The bitmap
itself is protected by slots_lock (a lockdep assertion would be nice
too), e.g. can we grab the lock iff dirty_bitmap[i] != 0?

>  		}
>  		spin_unlock(&kvm->mmu_lock);
>  	}
> -- 
> 2.14.4
> 
