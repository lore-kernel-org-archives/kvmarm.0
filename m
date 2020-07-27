Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91E2C433E3
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 12:30:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7545920663
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 12:30:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VY2a6xdk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7545920663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA3074B87F;
	Mon, 27 Jul 2020 08:30:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2rKVVH82yKFd; Mon, 27 Jul 2020 08:30:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8864E4B942;
	Mon, 27 Jul 2020 08:30:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FDEA4B87F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 08:30:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cJlLHk5EQQVg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 08:30:48 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B3084B851
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 08:30:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1595853047;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UVUej6X+c4TWQYmf5gq8Pn4J8FgrNFbkuWE9l3XB+bI=;
 b=VY2a6xdkK8GTjXbOszThKoHpF/Q/Oq3cICukEOyc3bGgI1yUlFpSk3yYYZavV/q0hKcxI2
 oiHLLINaEhbS/8hja4cVxoJ2Z2cIVWhdNoYb8rirUk87YFT0tyO8IagZ21hz4VmRkX4Z0R
 8GnbxGBbuqrWwP0fsIIKegXf9IukT5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-kGucxkxtMd6HjzDXhJ_-1Q-1; Mon, 27 Jul 2020 08:30:37 -0400
X-MC-Unique: kGucxkxtMd6HjzDXhJ_-1Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40FC580572E;
 Mon, 27 Jul 2020 12:30:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.132])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CC3111992D;
 Mon, 27 Jul 2020 12:30:34 +0000 (UTC)
Date: Mon, 27 Jul 2020 14:30:31 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: Compile with -mno-outline-atomics
 for GCC >= 10
Message-ID: <20200727123031.7v52lu23mmhailar@kamzik.brq.redhat.com>
References: <20200717164727.75580-1-alexandru.elisei@arm.com>
 <20200718091145.zheu46pfjwsntr3a@kamzik.brq.redhat.com>
 <202d475d-95df-2350-a8e9-9264144993ac@arm.com>
 <1bf2eab6-c6df-8b4c-b365-7216e7b9a9d7@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1bf2eab6-c6df-8b4c-b365-7216e7b9a9d7@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Mon, Jul 27, 2020 at 01:21:03PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 7/18/20 2:50 PM, Alexandru Elisei wrote:
> > Hi,
> >
> > On 7/18/20 10:11 AM, Andrew Jones wrote:
> >> On Fri, Jul 17, 2020 at 05:47:27PM +0100, Alexandru Elisei wrote:
> >>> GCC 10.1.0 introduced the -m{,no-}outline-atomics flags which, according to
> >>> man 1 gcc:
> >>>
> >>> "Enable or disable calls to out-of-line helpers to implement atomic
> >>> operations.  These helpers will, at runtime, determine if the LSE
> >>> instructions from ARMv8.1-A can be used; if not, they will use the
> >>> load/store-exclusive instructions that are present in the base ARMv8.0 ISA.
> >>> [..] This option is on by default."
> >>>
> >>> Unfortunately the option causes the following error at compile time:
> >>>
> >>> aarch64-linux-gnu-ld -nostdlib -pie -n -o arm/spinlock-test.elf -T /path/to/kvm-unit-tests/arm/flat.lds \
> >>> 	arm/spinlock-test.o arm/cstart64.o lib/libcflat.a lib/libfdt/libfdt.a /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a lib/arm/libeabi.a arm/spinlock-test.aux.o
> >>> aarch64-linux-gnu-ld: /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a(lse-init.o): in function `init_have_lse_atomics':
> >>> lse-init.c:(.text.startup+0xc): undefined reference to `__getauxval'
> >>>
> >>> This is happening because we are linking against our own libcflat which
> >>> doesn't implement the function __getauxval().
> >>>
> >>> Disable the use of the out-of-line functions by compiling with
> >>> -mno-outline-atomics if we detect a GCC version greater than 10.
> >>>
> >>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >>> ---
> >>>
> >>> Tested with gcc versions 10.1.0 and 5.4.0 (cross-compilation), 9.3.0
> >>> (native).
> >>>
> >>> I've been able to suss out the reason for the build failure from this
> >>> rejected gcc patch [1].
> >>>
> >>> [1] https://patches.openembedded.org/patch/172460/
> >>>
> >>>  arm/Makefile.arm64 | 6 ++++++
> >>>  1 file changed, 6 insertions(+)
> >>>
> >>> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> >>> index dfd0c56fe8fb..3223cb966789 100644
> >>> --- a/arm/Makefile.arm64
> >>> +++ b/arm/Makefile.arm64
> >>> @@ -9,6 +9,12 @@ ldarch = elf64-littleaarch64
> >>>  arch_LDFLAGS = -pie -n
> >>>  CFLAGS += -mstrict-align
> >>>  
> >>> +# The -mno-outline-atomics flag is only valid for GCC versions 10 and greater.
> >>> +GCC_MAJOR_VERSION=$(shell $(CC) -dumpversion 2> /dev/null | cut -f1 -d.)
> >>> +ifeq ($(shell expr "$(GCC_MAJOR_VERSION)" ">=" "10"), 1)
> >>> +CFLAGS += -mno-outline-atomics
> >>> +endif
> >> How about this patch instead?
> >>
> >> diff --git a/Makefile b/Makefile
> >> index 3ff2f91600f6..0e21a49096ba 100644
> >> --- a/Makefile
> >> +++ b/Makefile
> >> @@ -17,6 +17,11 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
> >>  
> >>  .PHONY: arch_clean clean distclean cscope
> >>  
> >> +# cc-option
> >> +# Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> >> +cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> >> +              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> >> +
> >>  #make sure env CFLAGS variable is not used
> >>  CFLAGS =
> >>  
> >> @@ -43,12 +48,6 @@ OBJDIRS += $(LIBFDT_objdir)
> >>  #include architecture specific make rules
> >>  include $(SRCDIR)/$(TEST_DIR)/Makefile
> >>  
> >> -# cc-option
> >> -# Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> >> -
> >> -cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> >> -              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> >> -
> >>  COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
> >>  COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
> >>  COMMON_CFLAGS += -Wignored-qualifiers -Werror
> >> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> >> index dfd0c56fe8fb..dbc7524d3070 100644
> >> --- a/arm/Makefile.arm64
> >> +++ b/arm/Makefile.arm64
> >> @@ -9,6 +9,9 @@ ldarch = elf64-littleaarch64
> >>  arch_LDFLAGS = -pie -n
> >>  CFLAGS += -mstrict-align
> >>  
> >> +mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
> >> +CFLAGS += $(mno_outline_atomics)
> >> +
> >>  define arch_elf_check =
> >>  	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
> >>  		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
> >>
> >>
> >> Thanks,
> >> drew
> > Looks much better than my version. Do you want me to spin a v2 or do you want to
> > send it as a separate patch? If that's the case, I tested the same way I did my
> > patch (gcc 10.1.0 and 5.4.0 for cross-compiling, 9.3.0 native):
> >
> > Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Gentle ping regarding this.
>

Hi Alexandru,

I was on vacation all last week and have been digging myself out of email
today. I'll send this as a proper patch with your T-b later today or
tomorrow.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
