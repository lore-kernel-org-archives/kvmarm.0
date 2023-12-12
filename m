Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602B180047
	for <kvmarm@lists.linux.dev>; Tue, 12 Dec 2023 19:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Exi1mWdP"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-5d7346442d4so59303707b3.2
        for <kvmarm@lists.linux.dev>; Tue, 12 Dec 2023 11:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702408642; x=1703013442; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXh6bur6LRnADXulivu2P72dN6ifPaK1xY/cKiFFTNI=;
        b=Exi1mWdP6txuPYsld7O9agl8dgENrRaQeQNjzlVE5LCx0w9mk0UCFfTbF06gr4q8So
         yVSak8XxDHw8P02IW3a8GMUjelqdc3vyiys0t/mfWidlEZaegGs/5b3+wOP3N3XqUJVZ
         uF13QK00vEj0/ta9GRp6HkfMyah2B1ijO3F61/3z2aq0nEnClPuJkzhXTGeD1lxd+Jbi
         Vt4BlQ//49jxGPFrm2x9EV/bA9CsgljN6cPSMsaTmrb4ffn5aOymLMzlAYvkQ1KVN+Gk
         GMzQEqvybfmkWtwRxcXORIaPRQgiirHYTDLd5w8q+lWWw+ig9GjRG+A32HiRLPj65yXd
         knDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702408642; x=1703013442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXh6bur6LRnADXulivu2P72dN6ifPaK1xY/cKiFFTNI=;
        b=GJoUY0ypOAuB9VlAvU/asg+SchWbdXTcJl0ap2o0zPUvPamd8zY27uukgCkAUUG8TI
         DVVAPl5+exxdhMjm/cbWQ3fYpxhLG/wLuB1KCnMyP4QX9ckx15gDYmE0H596hTZTtT+G
         MDlT17CEmLcuqaZpla7B1pyfmLjQ5w5CkqI3aGLzaigICOb/z8iJn7ssBu1Hb0bBFSFb
         BIXTFxeyJrN0wToAQMpjNFd5sBNJKxtWeAioMPRPmjABlnuekENhbyO407I3e8aIP6FT
         LXQVm842xeBB/AQpNrc0zIdrk8nsrcuxQqyRESDAPJOYQM0D7EwRTYERrJ9UwgDh6gHN
         tNZQ==
X-Gm-Message-State: AOJu0YwnZtuibQxUe0KX75Pyc6te5Euw7EEcCvfeJZN/soyppmEGCWEL
	u7g0OLGlL46RCpl8uvFFCKBky7WUX317yNi0qYyYCg==
X-Google-Smtp-Source: AGHT+IEg7PrE51WetYNV2TXBUh16oGjCgjaHBUbmLH/Y9ejNibFsuQg1ft+g8k/hUJRIzvj4zJlXYzVe6GRAoz3cE6E=
X-Received: by 2002:a25:244b:0:b0:dbc:c4f2:612f with SMTP id
 k72-20020a25244b000000b00dbcc4f2612fmr698912ybk.34.1702408642045; Tue, 12 Dec
 2023 11:17:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231122-arm64-gcs-v7-0-201c483bd775@kernel.org> <20231122-arm64-gcs-v7-2-201c483bd775@kernel.org>
In-Reply-To: <20231122-arm64-gcs-v7-2-201c483bd775@kernel.org>
From: Deepak Gupta <debug@rivosinc.com>
Date: Tue, 12 Dec 2023 11:17:11 -0800
Message-ID: <CAKC1njSC5cC_fXnyNAPt=WU6cD-OjLKFxo90oVPmsLJbuWf4nw@mail.gmail.com>
Subject: Re: [PATCH v7 02/39] prctl: arch-agnostic prctl for shadow stack
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
	Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, 
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Szabolcs Nagy <Szabolcs.Nagy@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Florian Weimer <fweimer@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Thiago Jung Bauermann <thiago.bauermann@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 22, 2023 at 1:43=E2=80=AFAM Mark Brown <broonie@kernel.org> wro=
te:
>
> Three architectures (x86, aarch64, riscv) have announced support for
> shadow stacks with fairly similar functionality.  While x86 is using
> arch_prctl() to control the functionality neither arm64 nor riscv uses
> that interface so this patch adds arch-agnostic prctl() support to
> get and set status of shadow stacks and lock the current configuation to
> prevent further changes, with support for turning on and off individual
> subfeatures so applications can limit their exposure to features that
> they do not need.  The features are:
>
>   - PR_SHADOW_STACK_ENABLE: Tracking and enforcement of shadow stacks,
>     including allocation of a shadow stack if one is not already
>     allocated.
>   - PR_SHADOW_STACK_WRITE: Writes to specific addresses in the shadow
>     stack.
>   - PR_SHADOW_STACK_PUSH: Push additional values onto the shadow stack.
>
> These features are expected to be inherited by new threads and cleared
> on exec(), unknown features should be rejected for enable but accepted
> for locking (in order to allow for future proofing).
>
> This is based on a patch originally written by Deepak Gupta but modified
> fairly heavily, support for indirect landing pads is removed, additional
> modes added and the locking interface reworked.  The set status prctl()
> is also reworked to just set flags, if setting/reading the shadow stack
> pointer is required this could be a separate prctl.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  include/linux/mm.h         |  4 ++++
>  include/uapi/linux/prctl.h | 22 ++++++++++++++++++++++
>  kernel/sys.c               | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 56 insertions(+)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 10462f354614..8b28483b4afa 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4143,4 +4143,8 @@ static inline bool pfn_is_unaccepted_memory(unsigne=
d long pfn)
>         return range_contains_unaccepted_memory(paddr, paddr + PAGE_SIZE)=
;
>  }
>
> +int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __=
user *status);
> +int arch_set_shadow_stack_status(struct task_struct *t, unsigned long st=
atus);
> +int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long s=
tatus);
> +
>  #endif /* _LINUX_MM_H */
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index 370ed14b1ae0..3c66ed8f46d8 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -306,4 +306,26 @@ struct prctl_mm_map {
>  # define PR_RISCV_V_VSTATE_CTRL_NEXT_MASK      0xc
>  # define PR_RISCV_V_VSTATE_CTRL_MASK           0x1f
>
> +/*
> + * Get the current shadow stack configuration for the current thread,
> + * this will be the value configured via PR_SET_SHADOW_STACK_STATUS.
> + */
> +#define PR_GET_SHADOW_STACK_STATUS      71
> +
> +/*
> + * Set the current shadow stack configuration.  Enabling the shadow
> + * stack will cause a shadow stack to be allocated for the thread.
> + */
> +#define PR_SET_SHADOW_STACK_STATUS      72
> +# define PR_SHADOW_STACK_ENABLE         (1UL << 0)

Other architecture may require disabling shadow stack if glibc
tunables is set to permissive mode.
In permissive mode, if glibc encounters `dlopen` on an object which
doesn't support shadow stack,
glibc should be able to issue PR_SHADOW_STACK_DISABLE.

Architectures can choose to implement or not but I think arch agnostic
code should enumerate this.

> +# define PR_SHADOW_STACK_WRITE         (1UL << 1)
> +# define PR_SHADOW_STACK_PUSH          (1UL << 2)
> +
> +/*
> + * Prevent further changes to the specified shadow stack
> + * configuration.  All bits may be locked via this call, including
> + * undefined bits.
> + */
