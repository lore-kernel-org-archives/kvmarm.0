From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v6 11/13] arm64: add ptrace regsets for ptrauth key
 management
Date: Wed, 12 Dec 2018 15:23:47 +0000
Message-ID: <20181212152347.GY3505@e103592.cambridge.arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-12-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181207183931.4285-12-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Adam Wallis <awallis@codeaurora.org>, Richard Henderson <richard.henderson@linaro.org>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 07, 2018 at 06:39:29PM +0000, Kristina Martsenko wrote:
> Add two new ptrace regsets, which can be used to request and change the
> pointer authentication keys of a thread. NT_ARM_PACA_KEYS gives access
> to the instruction/data address keys, and NT_ARM_PACG_KEYS to the
> generic authentication key.
> 
> The regsets are only exposed if the kernel is compiled with
> CONFIG_CHECKPOINT_RESTORE=y, as the intended use case is checkpointing
> and restoring processes that are using pointer authentication. Normally
> applications or debuggers should not need to know the keys (and exposing
> the keys is a security risk), so the regsets are not exposed by default.

If CONFIG_CHECKPOINT_RESTORE is a useful feature, it will be =y on a
wide variety of systems.  So I think making the ptrace interface depend
on it may just add potentially untested config variations with little
real security benefit.

If there is perceived to be a security issue here, we would need some
mechanism therefore to control ptrace visibiliy of the keys on a finer
grained basis, and then #ifdeffing the regsets out becomes pointless.


There are alreads mechanisms to restrict ptrace at runtime though --
are those not sufficient for us?

(For example, without CAP_PTRACE_ATTACH, other users' or setuid
processes are not accessible via ptrace.  Some security modules, Yama
for example, add additional, runtime controllable restrictions, such
as forbidding a process from tracing a task that it not one of its
children.)

In my opinion if a process is ptraceable at all then the tracer can
compromise it trivially in a wide variety of ways, even in the presence
of ptrauth.

So we should keep things simple and expose the keys unconditionally.

(Others' views might differ of course, but I can't see a convincing
counterargument right now.  I haven't looked at historical posts, so
maybe there was discussion already...)

> 
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> ---
>  arch/arm64/include/uapi/asm/ptrace.h | 18 +++++++++
>  arch/arm64/kernel/ptrace.c           | 72 ++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/elf.h             |  2 +
>  3 files changed, 92 insertions(+)
> 
> diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
> index c2f249bcd829..fafa7f6decf9 100644
> --- a/arch/arm64/include/uapi/asm/ptrace.h
> +++ b/arch/arm64/include/uapi/asm/ptrace.h
> @@ -236,6 +236,24 @@ struct user_pac_mask {
>  	__u64		insn_mask;
>  };
>  
> +/* pointer authentication keys (NT_ARM_PACA_KEYS, NT_ARM_PACG_KEYS) */
> +
> +struct user_pac_address_keys {
> +	__u64		apiakey_lo;
> +	__u64		apiakey_hi;
> +	__u64		apibkey_lo;
> +	__u64		apibkey_hi;
> +	__u64		apdakey_lo;
> +	__u64		apdakey_hi;
> +	__u64		apdbkey_lo;
> +	__u64		apdbkey_hi;
> +};
> +
> +struct user_pac_generic_keys {
> +	__u64		apgakey_lo;
> +	__u64		apgakey_hi;
> +};
> +

Are these intentionally different from the kernel's struct ptrauth_keys?

>  #endif /* __ASSEMBLY__ */
>  
>  #endif /* _UAPI__ASM_PTRACE_H */
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index 6c1f63cb6c4e..f18f14c64d1e 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -979,6 +979,56 @@ static int pac_mask_get(struct task_struct *target,
>  
>  	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, &uregs, 0, -1);
>  }
> +
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +static int pac_address_keys_get(struct task_struct *target,
> +				const struct user_regset *regset,
> +				unsigned int pos, unsigned int count,
> +				void *kbuf, void __user *ubuf)
> +{
> +	if (!system_supports_address_auth())
> +		return -EINVAL;
> +
> +	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +			&target->thread_info.keys_user, 0, -1);

How does this interact with CONFIG_HARDENED_USERCOPY?
(I haven't really played with this myself, but the issue was reported
by someone else when I was working on the SVE regset implementation.)

Because thread_info is in task_struct for arm64, I think it will be
subject to the arch_thread_struct_whitelist() (see <asm/processor.h>.)
This may cause failures reading/writing the ptrauth regsets when this
option is enabled.  (It seems =n in our defconfig today.)

The usercopy hardening code seems to cope with a contiguous whitelisted
region only, so it probably couldn't easily include the ptrauth keys.

(Possibly this is a non-issue for reasone I'm not seeing -- I haven't
tried this configuration recently.)


If we cannot avoid the use of incompatible types for the user and kernel
views of the ptrauth keys, then it may be more straightforward to simply
declare a local struct user_pac_address_keys here and populate it field
by field from thread_info, then do the _copyout on that.

I'm not too keen on the type mismatch and the "-1" here.  That means we
rely on regset->n and regset->size being set correctly elsewhere in
order to guard against buffer overruns in thread_info, but in this
case the regset size and the sizeof keys_user are not even the same.

This is a potential pitfall for future maintenance that it would be
preferable to avoid: if the regset definition and kernel structures
go out of sync in some way in the future, we could be vulnerable to
kernel buffer overruns, rather than just userspace seeing wrong
behaviour.

> +}
> +
> +static int pac_address_keys_set(struct task_struct *target,
> +				const struct user_regset *regset,
> +				unsigned int pos, unsigned int count,
> +				const void *kbuf, const void __user *ubuf)
> +{
> +	if (!system_supports_address_auth())
> +		return -EINVAL;
> +
> +	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +			&target->thread_info.keys_user, 0, -1);

The same comments apply here.

Note, if using a local struct, you need to be careful to avoid leaking
uninitialised kernel stack into the regset, so the struct must be fully
initialised and must not have any implicit tail-padding or padding
between fields.  (user_pac_address_keys and user_pac_generic_keys look
OK on this point.)

The most straightforward way to do this is to populate your struct from
thread_info, do the _copyin(), then transfer the fields of the modified
local struct back to thread_info.

You'll have to do these copies in a couple of places, so if you go
down this route it may be worth wrapping them in helpers.

> +}
> +
> +static int pac_generic_keys_get(struct task_struct *target,
> +				const struct user_regset *regset,
> +				unsigned int pos, unsigned int count,
> +				void *kbuf, void __user *ubuf)
> +{
> +	if (!system_supports_generic_auth())
> +		return -EINVAL;
> +
> +	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +			&target->thread_info.keys_user.apga, 0, -1);
> +}
> +
> +static int pac_generic_keys_set(struct task_struct *target,
> +				const struct user_regset *regset,
> +				unsigned int pos, unsigned int count,
> +				const void *kbuf, const void __user *ubuf)
> +{
> +	if (!system_supports_generic_auth())
> +		return -EINVAL;
> +
> +	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +			&target->thread_info.keys_user.apga, 0, -1);
> +}
> +#endif /* CONFIG_CHECKPOINT_RESTORE */
>  #endif /* CONFIG_ARM64_PTR_AUTH */

[...]

Cheers
---Dave
