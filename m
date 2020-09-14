Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71408C433E2
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 13:09:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C700121D41
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 13:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJEzeySp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C700121D41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C1F4B555;
	Mon, 14 Sep 2020 09:09:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id asGDLm3CN4Fz; Mon, 14 Sep 2020 09:09:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E09E74B54D;
	Mon, 14 Sep 2020 09:09:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 863764B562
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 09:09:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Cq1pXHa+I4t for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 09:09:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 261F94B487
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 09:09:45 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7AF03206B2;
 Mon, 14 Sep 2020 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600088984;
 bh=enr+iyTv6u2XzskZFJ5qT83Kq/MSJgsJ+u1/0SVC2DE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=HJEzeySpEP9Li+pydqi15kb1u831aaAa+xIym6H9E2N3vCvslGr2iwd+P8M1q2/KV
 oSZObq1fkwLf0vFtUgCRsKaEc92nsIxzoi2BG5AQAEfuEj1PR858lINKG6gctQ6lsa
 BjSmPK+oikK1hmXW8zjoRAQ2wZdbtaPoD7suvK/g=
Date: Mon, 14 Sep 2020 14:09:38 +0100
From: Will Deacon <will@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v2 02/10] kvm: arm64: Partially link nVHE hyp code,
 simplify HYPCOPY
Message-ID: <20200914130937.GC24441@willie-the-truck>
References: <20200903091712.46456-1-dbrazdil@google.com>
 <20200903091712.46456-3-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200903091712.46456-3-dbrazdil@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Sep 03, 2020 at 11:17:04AM +0200, David Brazdil wrote:
> Previous series introduced custom build rules for nVHE hyp code, using
> objcopy to prefix ELF section and symbol names to separate nVHE code
> into its own "namespace". This approach was limited by the expressiveness
> of objcopy's command line interface, eg. missing support for wildcards.

nit: "Previous series" isn't a lot of use here or in the git log. You can
just say something like:

  "Relying on objcopy to prefix the ELF section names of the nVHE hyp code
   is brittle and prevents us from using wildcards to match specific
   section names."

and then go on to explain what the change is doing (see
Documentation/process/submitting-patches.rst for more help here)

Also, given that this is independent of the other patches, please can you
move it right to the start of the series? I'm a bit worried about the
potential for regressions given the changes to the way in which we link,
so the sooner we can get this patch some more exposure, the better.

> Improve the build rules by partially linking all '.hyp.o' files and
> prefixing their ELF section names using a linker script. Continue using
> objcopy for prefixing ELF symbol names.
> 
> One immediate advantage of this approach is that all subsections
> matching a pattern can be merged into a single prefixed section, eg.
> .text and .text.* can be linked into a single '.hyp.text'. This removes
> the need for -fno-reorder-functions on GCC and will be useful in the
> future too: LTO builds use .text subsections, compilers routinely
> generate .rodata subsections, etc.
> 
> Partially linking all hyp code into a single object file also makes it
> easier to analyze.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/Makefile  | 56 ++++++++++++++++---------------
>  arch/arm64/kvm/hyp/nvhe/hyp.lds.S | 14 ++++++++
>  2 files changed, 43 insertions(+), 27 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp.lds.S
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index aef76487edc2..1b2fbb19f3e8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -10,40 +10,42 @@ obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o
>  
> -obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
> -extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
> +##
> +## Build rules for compiling nVHE hyp code
> +## Output of this folder is `hyp.o`, a partially linked object file containing
> +## all nVHE hyp code and data.
> +##
>  
> -$(obj)/%.hyp.tmp.o: $(src)/%.c FORCE
> +hyp-obj := $(patsubst %.o,%.hyp.o,$(obj-y))
> +obj-y := hyp.o
> +extra-y := $(hyp-obj) hyp.tmp.o hyp.lds
> +
> +# 1) Compile all source files to `.hyp.o` object files. The file extension
> +#    avoids file name clashes for files shared with VHE.
> +$(obj)/%.hyp.o: $(src)/%.c FORCE
>  	$(call if_changed_rule,cc_o_c)
> -$(obj)/%.hyp.tmp.o: $(src)/%.S FORCE
> +$(obj)/%.hyp.o: $(src)/%.S FORCE
>  	$(call if_changed_rule,as_o_S)
> -$(obj)/%.hyp.o: $(obj)/%.hyp.tmp.o FORCE
> -	$(call if_changed,hypcopy)
>  
> -# Disable reordering functions by GCC (enabled at -O2).
> -# This pass puts functions into '.text.*' sections to aid the linker
> -# in optimizing ELF layout. See HYPCOPY comment below for more info.
> -ccflags-y += $(call cc-option,-fno-reorder-functions)
> +# 2) Compile linker script.
> +$(obj)/hyp.lds: $(src)/hyp.lds.S FORCE
> +	$(call if_changed_dep,cpp_lds_S)

Why is it not sufficient just to list the linker script as a target, like
we do for vmlinux.lds in extra-y?

> +# 3) Partially link all '.hyp.o' files and apply the linker script.
> +#    Prefixes names of ELF sections with '.hyp', eg. '.hyp.text'.
> +LDFLAGS_hyp.tmp.o := -r -T $(obj)/hyp.lds
> +$(obj)/hyp.tmp.o: $(addprefix $(obj)/,$(hyp-obj)) $(obj)/hyp.lds FORCE
> +	$(call if_changed,ld)
> +
> +# 4) Produce the final 'hyp.o', ready to be linked into 'vmlinux'.
> +#    Prefixes names of ELF symbols with '__kvm_nvhe_'.
> +$(obj)/hyp.o: $(obj)/hyp.tmp.o FORCE
> +	$(call if_changed,hypcopy)
>  
>  # The HYPCOPY command uses `objcopy` to prefix all ELF symbol names
> -# and relevant ELF section names to avoid clashes with VHE code/data.
> -#
> -# Hyp code is assumed to be in the '.text' section of the input object
> -# files (with the exception of specialized sections such as
> -# '.hyp.idmap.text'). This assumption may be broken by a compiler that
> -# divides code into sections like '.text.unlikely' so as to optimize
> -# ELF layout. HYPCOPY checks that no such sections exist in the input
> -# using `objdump`, otherwise they would be linked together with other
> -# kernel code and not memory-mapped correctly at runtime.
> +# to avoid clashes with VHE code/data.
>  quiet_cmd_hypcopy = HYPCOPY $@
> -      cmd_hypcopy =							\
> -	if $(OBJDUMP) -h $< | grep -F '.text.'; then			\
> -		echo "$@: function reordering not supported in nVHE hyp code" >&2; \
> -		/bin/false;						\
> -	fi;								\
> -	$(OBJCOPY) --prefix-symbols=__kvm_nvhe_				\
> -		   --rename-section=.text=.hyp.text			\
> -		   $< $@
> +      cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__kvm_nvhe_ $< $@
>  
>  # Remove ftrace and Shadow Call Stack CFLAGS.
>  # This is equivalent to the 'notrace' and '__noscs' annotations.
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
> new file mode 100644
> index 000000000000..aaa0ce133a32
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Linker script used during partial linking of nVHE EL2 object files.
> + * Written by David Brazdil <dbrazdil@google.com>
> + */
> +
> +/*
> + * Defines an ELF hyp section from input section @NAME and its subsections.
> + */
> +#define HYP_SECTION(NAME) .hyp##NAME : { *(NAME NAME##.[0-9a-zA-Z_]*) }

Is 'NAME##.*' likely to cause a problem here?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
