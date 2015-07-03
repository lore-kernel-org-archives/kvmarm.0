From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] arm/arm64: spinlocks: fix memory barriers
Date: Fri, 3 Jul 2015 19:42:38 +0200
Message-ID: <5596C98E.3020906@redhat.com>
References: <1435248739-25425-1-git-send-email-drjones@redhat.com>
 <1435248739-25425-2-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1435248739-25425-2-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 25/06/2015 18:12, Andrew Jones wrote:
> It shouldn't be necessary to use a barrier on the way into
> spin_lock. We'll be focused on a single address until we get
> it (exclusively) set, and then we'll do a barrier on the way
> out. Also, it does make sense to do a barrier on the way in
> to spin_unlock, i.e. ensure what we did in the critical section
> is ordered wrt to what we do outside it, before we announce that
> we're outside.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/arm/spinlock.c   | 8 ++++----
>  lib/arm64/spinlock.c | 5 ++---
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/arm/spinlock.c b/lib/arm/spinlock.c
> index 3b023ceaebf71..116ea5d7db930 100644
> --- a/lib/arm/spinlock.c
> +++ b/lib/arm/spinlock.c
> @@ -7,10 +7,9 @@ void spin_lock(struct spinlock *lock)
>  {
>  	u32 val, fail;
>  
> -	dmb();
> -
>  	if (!mmu_enabled()) {
>  		lock->v = 1;
> +		smp_mb();
>  		return;
>  	}
>  
> @@ -25,11 +24,12 @@ void spin_lock(struct spinlock *lock)
>  		: "r" (&lock->v)
>  		: "cc" );
>  	} while (fail);
> -	dmb();
> +
> +	smp_mb();
>  }
>  
>  void spin_unlock(struct spinlock *lock)
>  {
> +	smp_mb();
>  	lock->v = 0;
> -	dmb();
>  }
> diff --git a/lib/arm64/spinlock.c b/lib/arm64/spinlock.c
> index 68b68b75ba60d..a3907f03cacda 100644
> --- a/lib/arm64/spinlock.c
> +++ b/lib/arm64/spinlock.c
> @@ -13,10 +13,9 @@ void spin_lock(struct spinlock *lock)
>  {
>  	u32 val, fail;
>  
> -	smp_mb();
> -
>  	if (!mmu_enabled()) {
>  		lock->v = 1;
> +		smp_mb();
>  		return;
>  	}
>  
> @@ -35,9 +34,9 @@ void spin_lock(struct spinlock *lock)
>  
>  void spin_unlock(struct spinlock *lock)
>  {
> +	smp_mb();
>  	if (mmu_enabled())
>  		asm volatile("stlrh wzr, [%0]" :: "r" (&lock->v));
>  	else
>  		lock->v = 0;
> -	smp_mb();
>  }
> 

Applied, thanks.

Paolo
