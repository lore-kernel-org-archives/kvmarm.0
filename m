Received: from mta0.migadu.com (out-245.mta0.migadu.com [91.218.175.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D6D495038
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789051658; cv=none; b=Wr9RJkoACdKfvOXmjerxnJ3ExjQLGEUxLznOH2hC/vQKgUGOnEgBQgpFIDXeqfEJd3uggwkCWgIMas66pQIkvxvJJGTFKf5qFcC6JyoVX61qoJme2BrAdGSgkwBDWm2dR70Nl/oMKN6pLin1nHiyfXmdFTCycefyG1EU8m7AeZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789051658; c=relaxed/simple;
	bh=ntAolI/OA7Z9WQW3bybNLUTDyMwEX6yK+A8WCHOuLy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NTfb7lrEKfxWAOAUSTd7pYkaMdZTN/9D/mvdTf3c8zzVptBhIxoLN7p6MkzpQEAZxzLOagxCdRwFgqS7lGAoQgLr4+FzLcaw9Iq3eu1qdSZvOeOibh91XuBP39vRaKQ1Xr3FwKWAZKNU1t5mV69kRHAOfmPc2iWsiPTZKC8DeG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZIzROk8H; arc=none smtp.client-ip=91.218.175.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZIzROk8H"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ntAolI/OA7Z9WQW3bybNLUTDyMwEX6yK+A8WCHOuLy4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789051653; v=1; x=1789656453;
 b=ZIzROk8H7B2z/ktYGaEa8PeNVB4JD9/YhF7eY7TeK8JMr/zfP9jBD6oqImeK5OG+X7oQ3M6Y
 7gvx0IZ82Je8Pa28rWujLev9ZwNinPPqRqOrrCG2oR0jO1Va5hJh08PlrYYXhz9Jby1BxhDbp68
 MCWTJC3kfikK2M0o6nTqVsTs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 14f15b9498be62c2;
	Thu, 10 Sep 2026 14:47:33 +0000
X-Mizu-Trace-ID: 14f15b9498be62c2
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so6725e87.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 07:47:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBycO+A4/wbH397PS9rDWdK0pgqO1S77zOBNuqMU8/55BmDoJREkffzDs+lxNlChlIVSeYq8WEE=@lists.linux.dev
X-Gm-Message-State: AFuF++kVkPcUj9xzRwsGL5b/EpdaAiy/Vys3ksCCGGuQyPSXz+E4g9kt
	0a3DgNlUv3NGMn6/rjAnYxcnczKkqwtRgcOR2AJ+6nlXpqlMx9DyAq0FRuothC+ZWpUvxx6Ew5+
	X6k1QAZhHNETm0Wz7vf6s2Xmu+H/PlH7Q48URl9nG
X-Received: by 2002:ac2:4e10:0:b0:5b6:4ad:d6ba with SMTP id
 2adb3069b0e04-5b89af5179fmr118268e87.15.1789051651809; Thu, 10 Sep 2026
 07:47:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com> <20260807164322.2970811-5-sebastianene@google.com>
In-Reply-To: <20260807164322.2970811-5-sebastianene@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 10 Sep 2026 15:46:55 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz0jJ1+n2emZg1E7Gvzqgj8OzR5PDjsVHWz=L6CyX4W6Q@mail.gmail.com>
X-Gm-Features: AcwNN1XDpd22jFdnDXPjIgJ7hGk7rymiE-YpHTGhy-VaFZD3HQl71sh9cUV8gas
Message-ID: <CA+EHjTz0jJ1+n2emZg1E7Gvzqgj8OzR5PDjsVHWz=L6CyX4W6Q@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] KVM: arm64: Support host MMIO trap handlers for
 unmapped devices
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com, 
	maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org, 
	kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, seiden@linux.ibm.com, 
	smostafa@google.com, tglx@kernel.org, vdonnefort@google.com, 
	vladimir.murzin@arm.com, yuzenghui@huawei.com, zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Seb,

On Fri, 7 Aug 2026 at 17:43, Sebastian Ene <sebastianene@google.com> wrote:
>
> Hook a handler to the host mem abort so that the hypervisor can
> intercept host accesses to unmapped memory regions.
> When a Stage-2 fault occurs on a registered device region, the
> hypervisor will look if there is any registered function that
> can handle the access. On the back of this, mediate host accesses
> to devices and emulate them in pKVM.
>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Signed-off-by: Bart=C5=82omiej Grzesik <bgrzesik@google.com>

Is this co-authored by Bart=C5=82omiej, or a stray tag?

> ---
>  arch/arm64/include/asm/kvm_arm.h      |  2 ++
>  arch/arm64/include/asm/kvm_pkvm.h     |  4 +++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 49 +++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c       |  3 ++
>  4 files changed, 58 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kv=
m_arm.h
> index 3f9233b5a130..6360c90f9855 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -304,6 +304,8 @@
>
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK     (~UL(0xf))
> +#define FAR_MASK       GENMASK_ULL(11, 0)

FAR_TO_FIPA_OFFSET() a few lines further down is the same mask, and
mem_protect.c already uses it.

> +
>  /*
>   * We have
>   *     PAR     [PA_Shift - 1   : 12] =3D PA      [PA_Shift - 1 : 12]
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/k=
vm_pkvm.h
> index ab26bec079d6..0a471564be00 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -20,9 +20,13 @@
>  /* The maximum number of hypervisor protected regions from the host */
>  #define PKVM_PROTECTED_REGS_NUM        8
>
> +struct pkvm_protected_reg;
> +typedef void(pkvm_emulate_handler)(struct pkvm_protected_reg *region, u6=
4 offset,
> +                                  bool write, u64 *reg, u8 reg_size);
>  struct pkvm_protected_reg {
>         u64 pfn;
>         u64 nr_pages;
> +       pkvm_emulate_handler *cb;
>  };
>
>  extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index 500c18c2fd48..7e978e0c44b9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -14,6 +14,7 @@
>  #include <asm/stage2_pgtable.h>
>
>  #include <hyp/fault.h>
> +#include <hyp/adjust_pc.h>
>
>  #include <nvhe/arm-smccc.h>
>  #include <nvhe/gfp.h>
> @@ -752,6 +753,50 @@ static void host_inject_mem_abort(struct kvm_cpu_con=
text *host_ctxt)
>         inject_host_exception(esr);
>  }
>
> +static bool handle_host_mmio_trap(struct kvm_cpu_context *host_ctxt, u64=
 esr, u64 addr)
> +{
> +       u64 offset, reg_value =3D 0, start, end;
> +       u8 reg_size, reg_index;
> +       bool write;
> +       int i;
> +
> +       for (i =3D 0; i < num_protected_reg; i++) {
> +               if (!pkvm_protected_regs[i].pfn || !pkvm_protected_regs[i=
].nr_pages ||
> +                   !pkvm_protected_regs[i].cb)
> +                       continue;
> +
> +               start =3D PFN_PHYS(pkvm_protected_regs[i].pfn);
> +               end =3D start + PFN_PHYS(pkvm_protected_regs[i].nr_pages)=
;
> +               reg_size =3D BIT((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT=
);
> +
> +               if (start > addr || addr + reg_size > end)
> +                       continue;
> +
> +               reg_index =3D (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHI=
FT;
> +               write =3D (esr & ESR_ELx_WNR) =3D=3D ESR_ELx_WNR;
> +               offset =3D addr - start;
> +
> +               if (write && reg_index !=3D 31)
> +                       reg_value =3D host_ctxt->regs.regs[reg_index];
> +
> +               pkvm_protected_regs[i].cb(&pkvm_protected_regs[i], offset=
, write,
> +                                         &reg_value, reg_size);
> +
> +               if (!write && reg_index !=3D 31)
> +                       host_ctxt->regs.regs[reg_index] =3D reg_value;
> +
> +               kvm_skip_host_instr();
> +               return true;

The callback returns void, so a rejection can't reach this code, and
both of the lines below it run anyway. On a read the host gets
reg_value, still the 0 it was initialised to, and the instruction is
skipped either way.

The later patches use the same callback, and their rejections are bare
returns: cwriter_write() drops a command that process_cmd() rejects,
ctlr_write() drops a GITS_CTLR enable, baser_write() drops a layout
change. That's invisible to the host, and to a test.

Could the callback return bool, and this return false on a rejection?
handle_host_mem_abort() then falls into host_stage2_idmap(), which
returns -EPERM for a donated page, so the case there already injects
the abort.

Cheers,
/fuad

> +       }
> +
> +       return false;
> +}
> +
> +static bool is_dabt(u64 esr)
> +{
> +       return (ESR_ELx_EC(esr) =3D=3D ESR_ELx_EC_DABT_LOW) && (esr & ESR=
_ELx_ISV);
> +}
> +
>  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>  {
>         struct kvm_vcpu_fault_info fault;
> @@ -774,6 +819,10 @@ void handle_host_mem_abort(struct kvm_cpu_context *h=
ost_ctxt)
>         BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
>         addr =3D FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
>
> +       if (is_dabt(esr) && !addr_is_memory(addr) &&
> +           handle_host_mmio_trap(host_ctxt, esr, addr | (fault.far_el2 &=
 FAR_MASK)))
> +               return;
> +
>         switch (host_stage2_idmap(addr)) {
>         case -EPERM:
>                 host_inject_mem_abort(host_ctxt);
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/se=
tup.c
> index 64c0290da888..4395595b7f7e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -294,6 +294,9 @@ static int donate_protected_mmio_regions(void)
>                                                   pkvm_protected_regs[i].=
nr_pages << PAGE_SHIFT);
>                 if (ret)
>                         goto err_setup;
> +
> +               if (pkvm_protected_regs[i].cb)
> +                       pkvm_protected_regs[i].cb =3D kern_hyp_va(pkvm_pr=
otected_regs[i].cb);
>         }
>
>         return 0;
> --
> 2.55.0.654.g21b8a5bc05-goog
>
