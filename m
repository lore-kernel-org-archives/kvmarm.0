From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 03/16] brlock: fix build with KVM_BRLOCK_DEBUG
Date: Thu, 4 Apr 2019 14:43:40 +0100
Message-ID: <20190404144340.78c81d9c@donnerap.cambridge.arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
 <1551947777-13044-4-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 653D14A475
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 09:43:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MyG6MoXrdWEK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 09:43:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D03464A449
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 09:43:45 -0400 (EDT)
In-Reply-To: <1551947777-13044-4-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Sami.Mujawar@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 7 Mar 2019 08:36:04 +0000
Julien Thierry <julien.thierry@arm.com> wrote:

> Build breaks when using KVM_BRLOCK_DEBUG because the header was seamingly
> conceived to be included in a single .c file...
> 
> Fix this by moving the definition of the read/write lock into the kvm
> struct.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  include/kvm/brlock.h | 10 ++++------
>  include/kvm/kvm.h    |  4 ++++
>  kvm.c                |  4 ++++
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/include/kvm/brlock.h b/include/kvm/brlock.h
> index 29f72e0..1862210 100644
> --- a/include/kvm/brlock.h
> +++ b/include/kvm/brlock.h
> @@ -21,13 +21,11 @@
>  
>  #include "kvm/rwsem.h"
>  
> -DECLARE_RWSEM(brlock_sem);
> +#define br_read_lock(kvm)	down_read(&(kvm)->brlock_sem);
> +#define br_read_unlock(kvm)	up_read(&(kvm)->brlock_sem);
>  
> -#define br_read_lock(kvm)	down_read(&brlock_sem);
> -#define br_read_unlock(kvm)	up_read(&brlock_sem);
> -
> -#define br_write_lock(kvm)	down_write(&brlock_sem);
> -#define br_write_unlock(kvm)	up_write(&brlock_sem);
> +#define br_write_lock(kvm)	down_write(&(kvm)->brlock_sem);
> +#define br_write_unlock(kvm)	up_write(&(kvm)->brlock_sem);
>  
>  #else
>  
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 1edacfd..7a73818 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -81,6 +81,10 @@ struct kvm {
>  	int                     nr_disks;
>  
>  	int			vm_state;
> +
> +#ifdef KVM_BRLOCK_DEBUG
> +	pthread_rwlock_t	brlock_sem;
> +#endif
>  };
>  
>  void kvm__set_dir(const char *fmt, ...);
> diff --git a/kvm.c b/kvm.c
> index d5249a0..57c4ff9 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -160,6 +160,10 @@ struct kvm *kvm__new(void)
>  	kvm->sys_fd = -1;
>  	kvm->vm_fd = -1;
>  
> +#ifdef KVM_BRLOCK_DEBUG
> +	kvm->brlock_sem = (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
> +#endif
> +
>  	return kvm;
>  }
>  
