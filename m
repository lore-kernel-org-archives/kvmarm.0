Received: from out-23.mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF9A4C67
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 07:36:39 +0000 (UTC)
Date: Fri, 9 Jun 2023 09:36:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686296196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9jyuL0O1SbrNhDjfR+6vAmwAiSIZPDBUJ1ZLZU19qvc=;
	b=do/Vsrno4Nfga0OfFgjrDjsAl5E98LOtyJRzfSBNYnGA6cLA0CTgmBCWZJ5fW6Mba0cNTG
	y5UATzD4V3wgZ/yBVQTOYsr/WYp/+T2tcL4pDN3T+sYV8hBBeTsnMshwAqH1fpqy8fNo1w
	OpCTe0TyZjyxK1K7x4L/2aiBrLgjpl4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com, 
	ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 28/32] arm64: Add support for efi in
 Makefile
Message-ID: <20230609-2c01e3ece17d5c6b3005ee4e@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-29-nikos.nikoleris@arm.com>
 <197A5432-65EA-49A7-AD6D-1AFCB58D30D0@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <197A5432-65EA-49A7-AD6D-1AFCB58D30D0@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 08, 2023 at 01:41:58PM -0700, Nadav Amit wrote:
...
> > +%.efi: %.so
> > + $(call arch_elf_check, $^)
> > + $(OBJCOPY) \
> > + -j .text -j .sdata -j .data -j .dynamic -j .dynsym \
> > + -j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
> > + -j .reloc \
> > + -O binary $^ $@
> 
> I really appreciate your work Nikos, and I might be late since I see Drew
> already applied it to his queue.

It's not too late. arm/queue isn't stable so we can apply fixes while it
bakes there.

> So consider this email, my previous one, and
> others that might follow more as grievances that can easily be addressed later.
> 
> So: It would’ve been nice to keep the symbols and debug information in a
> separate file. Something like:
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index d60cf8c..f904702 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -69,7 +69,7 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
>  ifeq ($(CONFIG_EFI),y)
>  %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
>  %.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
> -       $(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
> +       $(CC) $(CFLAGS) -c -g -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
>                 -DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
>         $(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
>                 $(filter %.o, $^) $(FLATLIBS) $(@:.so=.aux.o) \
> @@ -78,6 +78,9 @@ ifeq ($(CONFIG_EFI),y)
>    %.efi: %.so
>         $(call arch_elf_check, $^)
> +       $(OBJCOPY) --only-keep-debug $^ $@.debug
> +       $(OBJCOPY) --strip-debug $^
> +       $(OBJCOPY) --add-gnu-debuglink=$@.debug $^
>         $(OBJCOPY) \
>                 -j .text -j .sdata -j .data -j .dynamic -j .dynsym \
>                 -j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \

This is nice, but I think it can wait and be posted later.

Thanks,
drew
