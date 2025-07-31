Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362F8E55B
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 08:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949352; cv=none; b=l9OWkqogsIVfUo0U3bl3C7nSWXypq2bUI5XkZyNYDN/rZEsBD/R4vhx8cmQPEY7D3ZbeDEXvXfIbQqdqq6mss4PzQUhsYu/PIIetJCIvEvhZD+/bFQrcOB79A6mnAdg0S37c0pnxhTP+MBFTs78v5kLuFEjrRmxhtYucuQpym84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949352; c=relaxed/simple;
	bh=3qhIHJybqYLHwwYanOWTSTzOJk3WZo3sjmIfTKSzZ/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=apJ6Hxs51YBEBdv/XOUDnt42Tgks0voz6/dwdbV96it8moHDCZLG1PiLzLyCLnP87pm+V3Bq9ptKcSrNKK4ME3lRobc7OCWv/NeFJc4ueHdM02v5VJXeHwOyw/Xrqv7OHqPq1LB3kGff2tr7wMxzLL8+U7lRbzFuT6tJofXtOys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yHit1Dbr; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yHit1Dbr"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso274561cf.0
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 01:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949350; x=1754554150; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sVpT/rCjQeAh5KIDPEhyQ+wKLpTK8xJK+YrwTKpUU6g=;
        b=yHit1DbrVg4wlBRPbML9frPUXpB9TB6g084U63HbtTiWsMTaGybqwtDq8HSmat1Y1A
         GYDYsVY+Gn6W0f7/bRvTvCmDWfHLJArxOpLVo5ijRcfmCK0j8rxV1oVRmwxAppFN6JHo
         r/uNXEdDwqcdPRDNXwpeui3W4ZXJgAjnlvHYIIPVqjAN7k67maNFsfZ7/zNuyMX6+LqC
         GyNpewUllBWoU20vYwND0un+XqIPFjzhl5pK5v20yR8MPi3OvkeqY1Qz6feQfqtEG9qH
         nzR7Bat9DQARLgcQmbdHzFODM3Ohws7jhV5byC6jOLUaAMUmnZ9++4Etm3/ThTi2s7IZ
         WvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949350; x=1754554150;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sVpT/rCjQeAh5KIDPEhyQ+wKLpTK8xJK+YrwTKpUU6g=;
        b=BA3WHSV6pjONjaMEPzsq0y4fKIuK5Bo9qDqm+PkQhvTZpeInoRDemLvcjLHw10s4Y7
         Ex/tYUNjuxjsbbydDPBZEaFe46Pb2z4w0bGrLHFKkoSWxt2dJpWHlLbSlyPVg5JRzB4i
         35Q6cQoTuNToMmb8U3eZUOiYJBZmYGQ9Sypa4/tkdNSqs//dSD9y3i+JGL3MjPeLTpLL
         hvXNqI3eVo77dq4jBBc5K+m72QpHQq1QDlfzfXkiOyMcpTaDWbSu9Z0GRvxtyAzSQOR2
         wSgvQflFWGrrX565ckop+DXCBkd2ho59yHDR2JGz9Z7i/FVFiagqAvELcgGMS7nnQWVw
         mjKw==
X-Forwarded-Encrypted: i=1; AJvYcCVbP2zc5d4HdfiOlQghGriuphJeqSwUew6gOhICuJJpPUxqHKugvIdYcT1un/PUG0/E5osAVAM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOrfWuJGYXf6iDjepLcgolP6hSvPYZruM5RCa3+0AWKbjZ3UnK
	/fCa98kN0+s3ZwlB6JXz5+FZAea6H1s9stfk8TUzhS+yLx7xdMv2IYJw+JU3rCPHq6Ta+yCI4Re
	8k1VIGU4ZaSDSvABeWScbSeRcwh6cluqWtIIoILqK
X-Gm-Gg: ASbGncupDqiuUEi2M4/Og6s28KNcwXThzKmr3pNZzt95/BTfXgJm47lIIC+5R/gsnpQ
	J2ZiPJm6Z1rbaIGz0WB8z4u5dm5pcLlTBiMSzR/Ajg/Udj6XIxL6kwXTPaucSa9WbAxQwhnhsrQ
	jXu+QBf3d2aqnq9F5Y2zjsbJT7iKfzn0Wh//0QJq99Niz2+ncuGGTZDnvS3Wc/jwf4jO33rCqJW
	PpQQ3s=
X-Google-Smtp-Source: AGHT+IGrOVcMpMBT75FdKmxNn0PIJ5gM9b3irx1KceuhF9jVkzaF5hxH8j7i6+oG0xfsaxYdfsfyN79teagnN0ObxVs=
X-Received: by 2002:ac8:5a0b:0:b0:4aa:c3f9:99a7 with SMTP id
 d75a77b69052e-4aeeff4d635mr2252941cf.20.1753949349819; Thu, 31 Jul 2025
 01:09:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-3-seanjc@google.com>
In-Reply-To: <20250729225455.670324-3-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:08:33 +0100
X-Gm-Features: Ac12FXzXuU8fZ8KWH4QzSncdpqMTYPr50tdZb-JZxmCnm--xfHOVid80C_5YEog
Message-ID: <CA+EHjTx7OF2i4MvviAXQq0v6+a7T4SMU0PGsObDBo98Y6zvrBQ@mail.gmail.com>
Subject: Re: [PATCH v17 02/24] KVM: x86: Have all vendor neutral sub-configs
 depend on KVM_X86, not just KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>
> Make all vendor neutral KVM x86 configs depend on KVM_X86, not just KVM,
> i.e. gate them on at least one vendor module being enabled and thus on
> kvm.ko actually being built.  Depending on just KVM allows the user to
> select the configs even though they won't actually take effect, and more
> importantly, makes it all too easy to create unmet dependencies.  E.g.
> KVM_GENERIC_PRIVATE_MEM can't be selected by KVM_SW_PROTECTED_VM, because
> the KVM_GENERIC_MMU_NOTIFIER dependency is select by KVM_X86.
>
> Hiding all sub-configs when neither KVM_AMD nor KVM_INTEL is selected also
> helps communicate to the user that nothing "interesting" is going on, e.g.
>
>   --- Virtualization
>   <M>   Kernel-based Virtual Machine (KVM) support
>   < >   KVM for Intel (and compatible) processors support
>   < >   KVM for AMD processors support
>
> Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---


Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/kvm/Kconfig | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 2c86673155c9..9895fc3cd901 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -74,7 +74,7 @@ config KVM_WERROR
>         # FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
>         # Building KVM with -Werror and KASAN is still doable via enabling
>         # the kernel-wide WERROR=y.
> -       depends on KVM && ((EXPERT && !KASAN) || WERROR)
> +       depends on KVM_X86 && ((EXPERT && !KASAN) || WERROR)
>         help
>           Add -Werror to the build flags for KVM.
>
> @@ -83,7 +83,7 @@ config KVM_WERROR
>  config KVM_SW_PROTECTED_VM
>         bool "Enable support for KVM software-protected VMs"
>         depends on EXPERT
> -       depends on KVM && X86_64
> +       depends on KVM_X86 && X86_64
>         help
>           Enable support for KVM software-protected VMs.  Currently, software-
>           protected VMs are purely a development and testing vehicle for
> @@ -169,7 +169,7 @@ config KVM_AMD_SEV
>  config KVM_IOAPIC
>         bool "I/O APIC, PIC, and PIT emulation"
>         default y
> -       depends on KVM
> +       depends on KVM_X86
>         help
>           Provides support for KVM to emulate an I/O APIC, PIC, and PIT, i.e.
>           for full in-kernel APIC emulation.
> @@ -179,7 +179,7 @@ config KVM_IOAPIC
>  config KVM_SMM
>         bool "System Management Mode emulation"
>         default y
> -       depends on KVM
> +       depends on KVM_X86
>         help
>           Provides support for KVM to emulate System Management Mode (SMM)
>           in virtual machines.  This can be used by the virtual machine
> @@ -189,7 +189,7 @@ config KVM_SMM
>
>  config KVM_HYPERV
>         bool "Support for Microsoft Hyper-V emulation"
> -       depends on KVM
> +       depends on KVM_X86
>         default y
>         help
>           Provides KVM support for emulating Microsoft Hyper-V.  This allows KVM
> @@ -203,7 +203,7 @@ config KVM_HYPERV
>
>  config KVM_XEN
>         bool "Support for Xen hypercall interface"
> -       depends on KVM
> +       depends on KVM_X86
>         help
>           Provides KVM support for the hosting Xen HVM guests and
>           passing Xen hypercalls to userspace.
> @@ -213,7 +213,7 @@ config KVM_XEN
>  config KVM_PROVE_MMU
>         bool "Prove KVM MMU correctness"
>         depends on DEBUG_KERNEL
> -       depends on KVM
> +       depends on KVM_X86
>         depends on EXPERT
>         help
>           Enables runtime assertions in KVM's MMU that are too costly to enable
> @@ -228,7 +228,7 @@ config KVM_EXTERNAL_WRITE_TRACKING
>
>  config KVM_MAX_NR_VCPUS
>         int "Maximum number of vCPUs per KVM guest"
> -       depends on KVM
> +       depends on KVM_X86
>         range 1024 4096
>         default 4096 if MAXSMP
>         default 1024
> --
> 2.50.1.552.g942d659e1b-goog
>
