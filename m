From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 01/28] regset: Add support for dynamically sized
 regsets
Date: Wed, 11 Oct 2017 15:14:10 +0100
Message-ID: <20171011141410.tu53u2ugvs6n7uem@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-2-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-2-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:18PM +0100, Dave P Martin wrote:
> Currently the regset API doesn't allow for the possibility that
> regsets (or at least, the amount of meaningful data in a regset)
> may change in size.
> 
> In particular, this results in useless padding being added to
> coredumps in a regset's current size is smaller than its
> theoretical maximum size.
> 
> This patch adds a get_size() function to struct user_regset.
> Individual regset implementations can implement this function to
> return the current size of the regset data.  A regset_size()
> function is added to provide callers with an abstract interface for
> determining the size of a regset without needing to know whether
> the regset is dynamically sized or not.
> 
> The only affected user of this interface is the ELF coredump code:
> This patch ports ELF coredump to dump regsets with their actual
> size in the coredump.  This has no effect except for new regsets
> that are dynamically sized and provide a get_size() implementation.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  fs/binfmt_elf.c        |  6 ++---
>  include/linux/regset.h | 67 ++++++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 63 insertions(+), 10 deletions(-)

The patch looks fine to me:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

However, you'd probably need an ack from the filesystem maintainers
(cc'ed; patch below for reference).

> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 73b01e4..35aa03f 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1699,7 +1699,7 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
>  				 long signr, size_t *total)
>  {
>  	unsigned int i;
> -	unsigned int regset_size = view->regsets[0].n * view->regsets[0].size;
> +	unsigned int size = regset_size(t->task, &view->regsets[0]);
>  
>  	/*
>  	 * NT_PRSTATUS is the one special case, because the regset data
> @@ -1708,7 +1708,7 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
>  	 * We assume that regset 0 is NT_PRSTATUS.
>  	 */
>  	fill_prstatus(&t->prstatus, t->task, signr);
> -	(void) view->regsets[0].get(t->task, &view->regsets[0], 0, regset_size,
> +	(void) view->regsets[0].get(t->task, &view->regsets[0], 0, size,
>  				    &t->prstatus.pr_reg, NULL);
>  
>  	fill_note(&t->notes[0], "CORE", NT_PRSTATUS,
> @@ -1728,7 +1728,7 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
>  		if (regset->core_note_type && regset->get &&
>  		    (!regset->active || regset->active(t->task, regset))) {
>  			int ret;
> -			size_t size = regset->n * regset->size;
> +			size_t size = regset_size(t->task, regset);
>  			void *data = kmalloc(size, GFP_KERNEL);
>  			if (unlikely(!data))
>  				return 0;
> diff --git a/include/linux/regset.h b/include/linux/regset.h
> index 8e0c9fe..494ceda 100644
> --- a/include/linux/regset.h
> +++ b/include/linux/regset.h
> @@ -107,6 +107,28 @@ typedef int user_regset_writeback_fn(struct task_struct *target,
>  				     int immediate);
>  
>  /**
> + * user_regset_get_size_fn - type of @get_size function in &struct user_regset
> + * @target:	thread being examined
> + * @regset:	regset being examined
> + *
> + * This call is optional; usually the pointer is %NULL.
> + *
> + * When provided, this function must return the current size of regset
> + * data, as observed by the @get function in &struct user_regset.  The
> + * value returned must be a multiple of @size.  The returned size is
> + * required to be valid only until the next time (if any) @regset is
> + * modified for @target.
> + *
> + * This function is intended for dynamically sized regsets.  A regset
> + * that is statically sized does not need to implement it.
> + *
> + * This function should not be called directly: instead, callers should
> + * call regset_size() to determine the current size of a regset.
> + */
> +typedef unsigned int user_regset_get_size_fn(struct task_struct *target,
> +					     const struct user_regset *regset);
> +
> +/**
>   * struct user_regset - accessible thread CPU state
>   * @n:			Number of slots (registers).
>   * @size:		Size in bytes of a slot (register).
> @@ -117,19 +139,33 @@ typedef int user_regset_writeback_fn(struct task_struct *target,
>   * @set:		Function to store values.
>   * @active:		Function to report if regset is active, or %NULL.
>   * @writeback:		Function to write data back to user memory, or %NULL.
> + * @get_size:		Function to return the regset's size, or %NULL.
>   *
>   * This data structure describes a machine resource we call a register set.
>   * This is part of the state of an individual thread, not necessarily
>   * actual CPU registers per se.  A register set consists of a number of
>   * similar slots, given by @n.  Each slot is @size bytes, and aligned to
> - * @align bytes (which is at least @size).
> + * @align bytes (which is at least @size).  For dynamically-sized
> + * regsets, @n must contain the maximum possible number of slots for the
> + * regset, and @get_size must point to a function that returns the
> + * current regset size.
>   *
> - * These functions must be called only on the current thread or on a
> - * thread that is in %TASK_STOPPED or %TASK_TRACED state, that we are
> - * guaranteed will not be woken up and return to user mode, and that we
> - * have called wait_task_inactive() on.  (The target thread always might
> - * wake up for SIGKILL while these functions are working, in which case
> - * that thread's user_regset state might be scrambled.)
> + * Callers that need to know only the current size of the regset and do
> + * not care about its internal structure should call regset_size()
> + * instead of inspecting @n or calling @get_size.
> + *
> + * For backward compatibility, the @get and @set methods must pad to, or
> + * accept, @n * @size bytes, even if the current regset size is smaller.
> + * The precise semantics of these operations depend on the regset being
> + * accessed.
> + *
> + * The functions to which &struct user_regset members point must be
> + * called only on the current thread or on a thread that is in
> + * %TASK_STOPPED or %TASK_TRACED state, that we are guaranteed will not
> + * be woken up and return to user mode, and that we have called
> + * wait_task_inactive() on.  (The target thread always might wake up for
> + * SIGKILL while these functions are working, in which case that
> + * thread's user_regset state might be scrambled.)
>   *
>   * The @pos argument must be aligned according to @align; the @count
>   * argument must be a multiple of @size.  These functions are not
> @@ -156,6 +192,7 @@ struct user_regset {
>  	user_regset_set_fn		*set;
>  	user_regset_active_fn		*active;
>  	user_regset_writeback_fn	*writeback;
> +	user_regset_get_size_fn		*get_size;
>  	unsigned int			n;
>  	unsigned int 			size;
>  	unsigned int 			align;
> @@ -371,5 +408,21 @@ static inline int copy_regset_from_user(struct task_struct *target,
>  	return regset->set(target, regset, offset, size, NULL, data);
>  }
>  
> +/**
> + * regset_size - determine the current size of a regset
> + * @target:	thread to be examined
> + * @regset:	regset to be examined
> + *
> + * Note that the returned size is valid only until the next time
> + * (if any) @regset is modified for @target.
> + */
> +static inline unsigned int regset_size(struct task_struct *target,
> +				       const struct user_regset *regset)
> +{
> +	if (!regset->get_size)
> +		return regset->n * regset->size;
> +	else
> +		return regset->get_size(target, regset);
> +}
>  
>  #endif	/* <linux/regset.h> */
> -- 
> 2.1.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
