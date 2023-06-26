Received: from out-9.mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A14BEC5
	for <kvmarm@lists.linux.dev>; Mon, 26 Jun 2023 06:03:56 +0000 (UTC)
Date: Mon, 26 Jun 2023 08:03:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687759433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8yAaHpgjJ540eL7EbnjdHAnG61C7smgo4IQybrL2Pn8=;
	b=E+VhC5qztSMMn0PRXFNskOEGEd2rTd0rVFxz5JgWOU2SxYz7JWfAEsCSjt3ImLKaC2wtRx
	XroLvTWhW5q9DYshYgWB0KTr82LC1SmQJueQvQvxodAIFUYlEfh3RRKOZ5P9jgA69cHiYS
	NKxaE76rZbmRfrkfOAe0KIeGuGE4WcU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/6] lib/stack: print base addresses on
 efi
Message-ID: <20230626-96c5e2101071fcb6f3ddc550@orel>
References: <20230625230716.2922-1-namit@vmware.com>
 <20230625230716.2922-3-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230625230716.2922-3-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 25, 2023 at 11:07:12PM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Making sense from dumped stacks when running EFI tests is very hard due
> to the relocation. Fix it by adjusting the address back to the original
> address.
> 
> Introduce CONFIG_RELOC, which would be set on arm64 and on EFI configs.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> 
> ---
> 
> v1->v2: Introduce CONFIG_RELOC to support ARM64 [Andrew]
> ---
>  configure   |  3 +++
>  lib/stack.c | 31 +++++++++++++++++++++++++++++--
>  2 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/configure b/configure
> index b665f7d..8a3c8fe 100755
> --- a/configure
> +++ b/configure
> @@ -416,6 +416,9 @@ EOF
>  if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>      echo "TARGET=$target" >> config.mak
>  fi
> +if [ "$efi" = "y" ] || [ "$arch" = "arm64" ]; then
> +    echo "CONFIG_RELOC=y" >> config.mak

This won't work, because, unlike CONFIG_EFI, nothing is defining
CONFIG_RELOC in the build. We need CONFIG_RELOC in lib/config.h
or to append -DCONFIG_RELOC to CFLAGS in a makefile when some
config.mak variable is set. I think my preference would be
something like

diff --git a/Makefile b/Makefile
index 307bc291844a..ae79059e7e6f 100644
--- a/Makefile
+++ b/Makefile
@@ -40,7 +40,7 @@ OBJDIRS += $(LIBFDT_objdir)

 # EFI App
 ifeq ($(CONFIG_EFI),y)
-EFI_CFLAGS := -DCONFIG_EFI
+EFI_CFLAGS := -DCONFIG_EFI -DCONFIG_RELOC
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
 #   - GNU-EFI/apps/Makefile
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 60385e2d2b2b..960880f1c09f 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -12,6 +12,7 @@ CFLAGS += -mstrict-align

 mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
 CFLAGS += $(mno_outline_atomics)
+CFLAGS += -DCONFIG_RELOC

 define arch_elf_check =
        $(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 8ce00340b6be..c2e976e41f20 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -24,6 +24,7 @@ CFLAGS += -ffreestanding
 CFLAGS += -O2 -msoft-float -mno-altivec $(mabi_no_altivec)
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 CFLAGS += -Wa,-mregnames
+CFLAGS += -DCONFIG_RELOC

 # We want to keep intermediate files
 .PRECIOUS: %.o


(I also threw in ppc64 since it also relocates.)

Thanks,
drew
