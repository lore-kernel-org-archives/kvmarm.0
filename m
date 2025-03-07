Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C201E18DB3A
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 08:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741335896; cv=none; b=mVGNXXaEckMy+vK+x4joysoEg8OF9U9GQadI7ckQmm6JaL+jhjz5FtQUFn4kJmnaFRH8BDeXf0pdhbsI7S/o/HH3liBCO/lJ5bwHYCiGwwJxnT9uAraAGWStxcj+X3QHsBOQ2cbFTgTRMwxdulmC3lwsH+2DfJIn8JWZZGAz3hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741335896; c=relaxed/simple;
	bh=6mjS5yQebpQ5bSAnkStr/MkvqM0th7SFwJYG1WmRS4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KafZTrMAELM+6F1/kwS6a32HpiYnBEvI+GmHst0gC1znRWiKVGnMVU0WRdm5vpYp9N/0mbPxWR6yn60udx8z/HVNyznvNh7nHjsRVdApQQZ/X4YTrqAbMPvqE4C6crXvDkt0gRBWEeKmeGBQbq5/OFxIUypZTUUpSqC+2K6h/Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FsXowl8C; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FsXowl8C"
Date: Fri, 7 Mar 2025 09:24:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741335890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B9IW04+xVhOV76FQqtRVCmHc2y3iHBjGwJE4RbCE8FY=;
	b=FsXowl8C56ycNfZmLd9pMKmj+imFhcAzOq/biJKfuec57W0U4vsBFzRfnLLhsCgixvorh4
	wxVqT/UwlMV3wIPKQvGIefbH4n0ORXpUWjgONT59vVEOdfInMtnBIe07nrzNdq1h7Ct7WP
	s/Sh33cNaYMKZuOX5vagF4gf/B71mQ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.linux.dev, 
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH v4] arm64: Add basic MTE test
Message-ID: <20250307-1c14700ea8fffa172525395d@orel>
References: <20250227152240.118721-1-vladimir.murzin@arm.com>
 <20250306-e90b77df70c0a9be913a4e08@orel>
 <Z8nXOBGxEGS5il3N@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8nXOBGxEGS5il3N@raptor>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 06, 2025 at 05:11:20PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Thu, Mar 06, 2025 at 04:45:06PM +0100, Andrew Jones wrote:
> > On Thu, Feb 27, 2025 at 03:22:40PM +0000, Vladimir Murzin wrote:
> > > Test tag storage access and tag mismatch for different MTE modes.
> > > 
> > > Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> > > ---
> > >  arm/Makefile.arm64            |   8 +
> > >  arm/cstart64.S                |   4 +-
> > >  arm/mte.c                     | 313 ++++++++++++++++++++++++++++++++++
> > >  arm/unittests.cfg             |  19 +++
> > >  lib/arm64/asm/mmu.h           |   1 +
> > >  lib/arm64/asm/pgtable-hwdef.h |   3 +
> > >  lib/arm64/asm/sysreg.h        |  14 ++
> > >  7 files changed, 361 insertions(+), 1 deletion(-)
> > >  create mode 100644 arm/mte.c
> > >
> > 
> > Unfortunately this is failing builds with clang.
> > 
> > arm/mte.c:65:18: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
> >    65 |                       : "=&r" (r)
> >       |                                ^
> > arm/mte.c:63:21: note: use constraint modifier "w"
> >    63 |         asm volatile ("ldr %0,[%1]\n"
> >       |                            ^~
> >       |                            %w0
> > arm/mte.c:65:18: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
> >    65 |                       : "=&r" (r)
> >       |                                ^
> > arm/mte.c:64:14: note: use constraint modifier "w"
> >    64 |                       "str %0,[%2]\n"
> >       |                            ^~
> >       |                            %w0
> > arm/mte.c:75:16: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
> >    75 |                       : "r" (val), "r" (addr)
> >       |                              ^
> > arm/mte.c:72:21: note: use constraint modifier "w"
> >    72 |         asm volatile ("str %0,[%1]\n"
> >       |                            ^~
> >       |                            %w0
> > 
> > Thanks,
> > drew
> > 
> 
> That's unfortunate, I think it's because %0 specifies a 64bit register, but
> the variable is declared as an unsigned int, which is 32 bits.
> 
> Can you give this a go:
> 
> diff --git a/arm/mte.c b/arm/mte.c
> index f32203ce275a..9c266fcced5f 100644
> --- a/arm/mte.c
> +++ b/arm/mte.c
> @@ -60,8 +60,8 @@ static inline void mem_read(unsigned int *addr, unsigned int *res)
>  {
>         unsigned int r;
> 
> -       asm volatile ("ldr %0,[%1]\n"
> -                     "str %0,[%2]\n"
> +       asm volatile ("ldr %w0,[%1]\n"
> +                     "str %w0,[%2]\n"
>                       : "=&r" (r)
>                       : "r" (addr), "r" (res) : "memory");
>  }
> @@ -69,7 +69,7 @@ static inline void mem_read(unsigned int *addr, unsigned int *res)
>  static inline void mem_write(unsigned int *addr, unsigned int val)
>  {
>         /* The NOP allows the same exception handler as mem_read() to be used. */
> -       asm volatile ("str %0,[%1]\n"
> +       asm volatile ("str %w0,[%1]\n"
>                       "nop\n"
>                       :
>                       : "r" (val), "r" (addr)
> 
> It compiles and works with gcc; with clang it compiles,

Yup, works.

> but I cannot run
> the test because kvm-unit-tests doesn't detect MTE support in the compiler.
> 
> $ ./configure --arch=arm64 --cc=clang --cross-prefix=aarch64-linux-gnu- --cflags='--target=aarch64-linux -march=armv8.5-a+memtag'
> $ make -j32 clean && make -j32
> $ ./run_tests.sh -g mte
> config.mak: line 13: -march=armv8.5-a+memtag: command not found
> config.mak: line 13: -march=armv8.5-a+memtag: command not found
> SKIP mte-sync (1 tests, 1 skipped)
> SKIP mte-async (1 tests, 1 skipped)
> SKIP mte-asymm (1 tests, 1 skipped)
> 
> (the error I suppose it's because configure doesn't wrap CFLAGS in quotes
> when writing config.mak).

We shouldn't need to add -march=armv8.5-a+memtag to --cflags, since this
patch adds the cc-option check in arm/Makefile.arm64. Also, I see that
--target=aarch64-linux, as opposed to just --target=aarch64 that we have
in .gitlab-ci.yml, fails to build arm/spinlock-test.c (at least for me),
so I don't think we want to change that either.

> 
> Do you have any hints about enabling MTE in clang?

We need to change cc-option to also specify CFLAGS, like below, then
everything works for me.

diff --git a/Makefile b/Makefile
index 78352fced9d4..9dc5d2234e2a 100644
--- a/Makefile
+++ b/Makefile
@@ -21,7 +21,7 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/

 # cc-option
 # Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
-cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
+cc-option = $(shell if $(CC) $(CFLAGS) -Werror $(1) -S -o /dev/null -xc /dev/null \
               > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)

 libcflat := lib/libcflat.a


Thanks,
drew
