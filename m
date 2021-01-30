Return-Path: <SRS0=LYeO=HB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1D1C433DB
	for <kvmarm@archiver.kernel.org>; Sat, 30 Jan 2021 16:11:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F2B1264E0C
	for <kvmarm@archiver.kernel.org>; Sat, 30 Jan 2021 16:11:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2B1264E0C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31CCE4B309;
	Sat, 30 Jan 2021 11:11:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ia5ywH8ZFqeA; Sat, 30 Jan 2021 11:11:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABB374B312;
	Sat, 30 Jan 2021 11:11:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1DAC4B303
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Jan 2021 11:11:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m8TpxX3ne4LH for <kvmarm@lists.cs.columbia.edu>;
 Sat, 30 Jan 2021 11:11:07 -0500 (EST)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com
 [209.85.167.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AF1D4B1CE
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Jan 2021 11:11:07 -0500 (EST)
Received: by mail-oi1-f171.google.com with SMTP id w8so13616482oie.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Jan 2021 08:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=Gn8JQM9rxFt1jehHVZFiwudTpKcicixU/7LhLVD8hTM=;
 b=p0t1zVoTzQpNQcGOQhSgRnfQC5g+eCbd/y5w86yIVnjTgkTNiNkomeCwToCEz9LVen
 xxL05o+sZOIvbltmx+twwNouaKZtUydf1O0bbN7tuM8GNSjdQwOOIIgGPp00royDFX1p
 TzJU5Tz9bHyxRDmpnyxiJqvS2jUYZUwv4LoHlT+0sqS7MPNVbJ0rfoh16GOds/XxAGjA
 csBvjaG5iJpiD+Sk6KmUlFUj+PoCNDMSsgnn/3UihHL+yoYO2ith9mDU3SAUAIA6C81g
 h1+p1bkGCS4/kXxkoPjvHV3ANcSVPr/0uGgpMXQbsxcqn0+vcrTadnn/AGjf4NGtTFBn
 FJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
 :references:mime-version:content-disposition:in-reply-to:user-agent;
 bh=Gn8JQM9rxFt1jehHVZFiwudTpKcicixU/7LhLVD8hTM=;
 b=M9geGGcm57ifAnV+hqziQvSlQGNa7KZPQa1UgC8Wu1bo14IAC1vnSoLNcJhZEFLL6q
 SW2YmAwNrhQVIcwohF6i28FveEdW5fEMcowcLD48tE04SEbKa9WRVQQQ6FKcarZ2qRaE
 D8LrpAKF8Pg2r20PDHk2gOcswD9EjS+9pH+fm4nQcHIid/KTwOgE2tX/a7t9mVyo2gjZ
 4WDlskW5gtol7iKH/PSmZYtM9rT77ieP0+PYw70Z3uMY+vJDKLM4apw55sBAs4OkCg0Y
 PVGpyYolDgPFeox3yVTN0hmFaRqvlN7Kk4HNE4XaNrW4OOQ6zwDAZv8wEZ7iYRYtfqPl
 PIZA==
X-Gm-Message-State: AOAM533ttcWBdPW8akxLNRuep4CFjT3RUqwBbWC6syCrfmm5eGoi0xCm
 vUr7HaU+nCEgQdrefWWeKvM=
X-Google-Smtp-Source: ABdhPJy4gygxZdmnRcne5jpw0tvqJDEIqSAXJYGpJfRHVzB77wvtvRT6qNEjn0tH0cUXVRe9OazIyw==
X-Received: by 2002:aca:1c07:: with SMTP id c7mr5731256oic.38.1612023066648;
 Sat, 30 Jan 2021 08:11:06 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id s26sm2906009otp.54.2021.01.30.08.11.05
 (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
 Sat, 30 Jan 2021 08:11:05 -0800 (PST)
Date: Sat, 30 Jan 2021 08:11:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/8] KVM: arm64: Generate hyp relocation data
Message-ID: <20210130161104.GA77773@roeck-us.net>
References: <20210105180541.65031-1-dbrazdil@google.com>
 <20210105180541.65031-5-dbrazdil@google.com>
 <20210129214325.GA195322@roeck-us.net>
 <87r1m2lets.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87r1m2lets.wl-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Sat, Jan 30, 2021 at 01:44:15PM +0000, Marc Zyngier wrote:
> On Fri, 29 Jan 2021 21:43:25 +0000,
> Guenter Roeck <linux@roeck-us.net> wrote:
> > 
> > Hi,
> > 
> > On Tue, Jan 05, 2021 at 06:05:37PM +0000, David Brazdil wrote:
> > > Add a post-processing step to compilation of KVM nVHE hyp code which
> > > calls a custom host tool (gen-hyprel) on the partially linked object
> > > file (hyp sections' names prefixed).
> > > 
> > > The tool lists all R_AARCH64_ABS64 data relocations targeting hyp
> > > sections and generates an assembly file that will form a new section
> > > .hyp.reloc in the kernel binary. The new section contains an array of
> > > 32-bit offsets to the positions targeted by these relocations.
> > > 
> > > Since these addresses of those positions will not be determined until
> > > linking of `vmlinux`, each 32-bit entry carries a R_AARCH64_PREL32
> > > relocation with addend <section_base_sym> + <r_offset>. The linker of
> > > `vmlinux` will therefore fill the slot accordingly.
> > > 
> > > This relocation data will be used at runtime to convert the kernel VAs
> > > at those positions to hyp VAs.
> > > 
> > > Signed-off-by: David Brazdil <dbrazdil@google.com>
> > 
> > This patch results in the following error for me.
> > 
> > error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: assertion elf.ehdr->e_ident[5] == 1 failed (lhs=2, rhs=1, line=250)
> > 
> > The problem is seen when trying to build aarch64 images in big endian
> > mode.
> > 
> > Te script used to reproduce the problem as well as bisect results are
> > attached.
> 
> I came up with the following patch, which allows the kernel to link
> and boot. I don't have any BE userspace, so I didn't verify that I
> could boot a guest (the hypervisor does correctly initialise though).
> 
> It's not exactly pretty, but it does the job...
> 
> Thanks,
> 
> 	M.
> 
> From d80ca05b2ed90fc30d328041692fa80f525c8d12 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Sat, 30 Jan 2021 13:07:51 +0000
> Subject: [PATCH] KVM: arm64: Make gen-hyprel endianness agnostic
> 
> gen-hyprel is, for better or worse, a native-endian program:
> it assumes that the ELF data structures are in the host's
> endianness, and even assumes that the compiled kernel is
> little-endian in one particular case.
> 
> None of these assumptions hold true though: people actually build
> (use?) BE arm64 kernels, and seem to avoid doing so on BE hosts.
> Madness!
> 
> In order to solve this, wrap each access to the ELF data structures
> with the required byte-swapping magic. This requires to obtain
> the kernel data structure, and provide per-endianess wrappers.
> 
> This result in a kernel that links and even boots in a model.
> 
> Fixes: 8c49b5d43d4c ("KVM: arm64: Generate hyp relocation data")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Tested-by: Guenter Roeck <linux@roeck-us.net>

Compiles and boots both big- and little-endian systems in qemu.

Guenter

> ---
>  arch/arm64/kvm/hyp/nvhe/Makefile     |  1 +
>  arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 57 ++++++++++++++++++++--------
>  2 files changed, 42 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 268be1376f74..09d04dd50eb8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -7,6 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__
>  
>  hostprogs := gen-hyprel
> +HOST_EXTRACFLAGS += -I$(srctree)/include
>  
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
>  	 hyp-main.o hyp-smp.o psci-relay.o
> diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
> index 58fe31fdba8e..ead02c6a7628 100644
> --- a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
> +++ b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
> @@ -25,6 +25,7 @@
>   */
>  
>  #include <elf.h>
> +#include <endian.h>
>  #include <errno.h>
>  #include <fcntl.h>
>  #include <stdbool.h>
> @@ -36,6 +37,8 @@
>  #include <sys/stat.h>
>  #include <unistd.h>
>  
> +#include <generated/autoconf.h>
> +
>  #define HYP_SECTION_PREFIX		".hyp"
>  #define HYP_RELOC_SECTION		".hyp.reloc"
>  #define HYP_SECTION_SYMBOL_PREFIX	"__hyp_section_"
> @@ -121,6 +124,28 @@ static struct {
>  	const char	*sh_string;
>  } elf;
>  
> +#if defined(CONFIG_CPU_LITTLE_ENDIAN)
> +
> +#define elf16toh(x)	le16toh(x)
> +#define elf32toh(x)	le32toh(x)
> +#define elf64toh(x)	le64toh(x)
> +
> +#define ELFENDIAN	ELFDATA2LSB
> +
> +#elif defined(CONFIG_CPU_BIG_ENDIAN)
> +
> +#define elf16toh(x)	be16toh(x)
> +#define elf32toh(x)	be32toh(x)
> +#define elf64toh(x)	be64toh(x)
> +
> +#define ELFENDIAN	ELFDATA2MSB
> +
> +#else
> +
> +#error PDP-endian sadly unsupported...
> +
> +#endif
> +
>  #define fatal_error(fmt, ...)						\
>  	({								\
>  		fprintf(stderr, "error: %s: " fmt "\n",			\
> @@ -162,12 +187,12 @@ static struct {
>  
>  /* Iterate over all sections in the ELF. */
>  #define for_each_section(var) \
> -	for (var = elf.sh_table; var < elf.sh_table + elf.ehdr->e_shnum; ++var)
> +	for (var = elf.sh_table; var < elf.sh_table + elf16toh(elf.ehdr->e_shnum); ++var)
>  
>  /* Iterate over all Elf64_Rela relocations in a given section. */
>  #define for_each_rela(shdr, var)					\
> -	for (var = elf_ptr(Elf64_Rela, shdr->sh_offset);		\
> -	     var < elf_ptr(Elf64_Rela, shdr->sh_offset + shdr->sh_size); var++)
> +	for (var = elf_ptr(Elf64_Rela, elf64toh(shdr->sh_offset));	\
> +	     var < elf_ptr(Elf64_Rela, elf64toh(shdr->sh_offset) + elf64toh(shdr->sh_size)); var++)
>  
>  /* True if a string starts with a given prefix. */
>  static inline bool starts_with(const char *str, const char *prefix)
> @@ -178,13 +203,13 @@ static inline bool starts_with(const char *str, const char *prefix)
>  /* Returns a string containing the name of a given section. */
>  static inline const char *section_name(Elf64_Shdr *shdr)
>  {
> -	return elf.sh_string + shdr->sh_name;
> +	return elf.sh_string + elf32toh(shdr->sh_name);
>  }
>  
>  /* Returns a pointer to the first byte of section data. */
>  static inline const char *section_begin(Elf64_Shdr *shdr)
>  {
> -	return elf_ptr(char, shdr->sh_offset);
> +	return elf_ptr(char, elf64toh(shdr->sh_offset));
>  }
>  
>  /* Find a section by its offset from the beginning of the file. */
> @@ -247,13 +272,13 @@ static void init_elf(const char *path)
>  
>  	/* Sanity check that this is an ELF64 relocatable object for AArch64. */
>  	assert_eq(elf.ehdr->e_ident[EI_CLASS], ELFCLASS64, "%u");
> -	assert_eq(elf.ehdr->e_ident[EI_DATA], ELFDATA2LSB, "%u");
> -	assert_eq(elf.ehdr->e_type, ET_REL, "%u");
> -	assert_eq(elf.ehdr->e_machine, EM_AARCH64, "%u");
> +	assert_eq(elf.ehdr->e_ident[EI_DATA], ELFENDIAN, "%u");
> +	assert_eq(elf16toh(elf.ehdr->e_type), ET_REL, "%u");
> +	assert_eq(elf16toh(elf.ehdr->e_machine), EM_AARCH64, "%u");
>  
>  	/* Populate fields of the global struct. */
> -	elf.sh_table = section_by_off(elf.ehdr->e_shoff);
> -	elf.sh_string = section_begin(section_by_idx(elf.ehdr->e_shstrndx));
> +	elf.sh_table = section_by_off(elf64toh(elf.ehdr->e_shoff));
> +	elf.sh_string = section_begin(section_by_idx(elf16toh(elf.ehdr->e_shstrndx)));
>  }
>  
>  /* Print the prologue of the output ASM file. */
> @@ -301,8 +326,8 @@ static void emit_rela_abs64(Elf64_Rela *rela, const char *sh_orig_name)
>  	 * is `rela->r_offset`.
>  	 */
>  	printf(".reloc %lu, R_AARCH64_PREL32, %s%s + 0x%lx\n",
> -		reloc_offset, HYP_SECTION_SYMBOL_PREFIX, sh_orig_name,
> -		rela->r_offset);
> +	       reloc_offset, HYP_SECTION_SYMBOL_PREFIX, sh_orig_name,
> +	       elf64toh(rela->r_offset));
>  
>  	reloc_offset += 4;
>  }
> @@ -322,7 +347,7 @@ static void emit_epilogue(void)
>   */
>  static void emit_rela_section(Elf64_Shdr *sh_rela)
>  {
> -	Elf64_Shdr *sh_orig = &elf.sh_table[sh_rela->sh_info];
> +	Elf64_Shdr *sh_orig = &elf.sh_table[elf32toh(sh_rela->sh_info)];
>  	const char *sh_orig_name = section_name(sh_orig);
>  	Elf64_Rela *rela;
>  
> @@ -333,10 +358,10 @@ static void emit_rela_section(Elf64_Shdr *sh_rela)
>  	emit_section_prologue(sh_orig_name);
>  
>  	for_each_rela(sh_rela, rela) {
> -		uint32_t type = (uint32_t)rela->r_info;
> +		uint32_t type = (uint32_t)elf64toh(rela->r_info);
>  
>  		/* Check that rela points inside the relocated section. */
> -		assert_lt(rela->r_offset, sh_orig->sh_size, "0x%lx");
> +		assert_lt(elf64toh(rela->r_offset), elf64toh(sh_orig->sh_size), "0x%lx");
>  
>  		switch (type) {
>  		/*
> @@ -385,7 +410,7 @@ static void emit_all_relocs(void)
>  	Elf64_Shdr *shdr;
>  
>  	for_each_section(shdr) {
> -		switch (shdr->sh_type) {
> +		switch (elf32toh(shdr->sh_type)) {
>  		case SHT_REL:
>  			fatal_error("Unexpected SHT_REL section \"%s\"",
>  				section_name(shdr));
> -- 
> 2.29.2
> 
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
