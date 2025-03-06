Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0032B2566F3
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741281106; cv=none; b=b5cQBlee7loVhbtm84pZ9Kk9JiNYBLGGm5rk1csCISh7FPgvvZieB0qwG+JgdsngRcetSopB/Wp773SAGgctRVOAsIV5KrtiCfAMzcpY1Wn/B25LO0BFnUs403iisKm5ZBflgF7Dg9mi5Smg54zTxxMqjvrUS305nwiG2wFg9JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741281106; c=relaxed/simple;
	bh=kGCpOEGL3Tirr//OuqVzApvuKlaut62A5BIUyFPKU1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKDWSSPZjlz4TiZP2nvFH+mNluieXAikAX3TWUnRESTlkNM+XvB+t3sEKNE3uYqgOnX/LoCUSGh0mzi6412ib23mKP9XMMTc1KvpHXku2EWyETC5TpiWPy9XzofYd4kRNmrXrB+LzDf5cbvmzDIpIhr4gnqwiPpnZa8L5ZTGvjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23BB11007;
	Thu,  6 Mar 2025 09:11:52 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16AF03F5A1;
	Thu,  6 Mar 2025 09:11:33 -0800 (PST)
Date: Thu, 6 Mar 2025 17:11:20 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.linux.dev,
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH v4] arm64: Add basic MTE test
Message-ID: <Z8nXOBGxEGS5il3N@raptor>
References: <20250227152240.118721-1-vladimir.murzin@arm.com>
 <20250306-e90b77df70c0a9be913a4e08@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306-e90b77df70c0a9be913a4e08@orel>

Hi Drew,

On Thu, Mar 06, 2025 at 04:45:06PM +0100, Andrew Jones wrote:
> On Thu, Feb 27, 2025 at 03:22:40PM +0000, Vladimir Murzin wrote:
> > Test tag storage access and tag mismatch for different MTE modes.
> > 
> > Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> > ---
> >  arm/Makefile.arm64            |   8 +
> >  arm/cstart64.S                |   4 +-
> >  arm/mte.c                     | 313 ++++++++++++++++++++++++++++++++++
> >  arm/unittests.cfg             |  19 +++
> >  lib/arm64/asm/mmu.h           |   1 +
> >  lib/arm64/asm/pgtable-hwdef.h |   3 +
> >  lib/arm64/asm/sysreg.h        |  14 ++
> >  7 files changed, 361 insertions(+), 1 deletion(-)
> >  create mode 100644 arm/mte.c
> >
> 
> Unfortunately this is failing builds with clang.
> 
> arm/mte.c:65:18: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>    65 |                       : "=&r" (r)
>       |                                ^
> arm/mte.c:63:21: note: use constraint modifier "w"
>    63 |         asm volatile ("ldr %0,[%1]\n"
>       |                            ^~
>       |                            %w0
> arm/mte.c:65:18: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>    65 |                       : "=&r" (r)
>       |                                ^
> arm/mte.c:64:14: note: use constraint modifier "w"
>    64 |                       "str %0,[%2]\n"
>       |                            ^~
>       |                            %w0
> arm/mte.c:75:16: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
>    75 |                       : "r" (val), "r" (addr)
>       |                              ^
> arm/mte.c:72:21: note: use constraint modifier "w"
>    72 |         asm volatile ("str %0,[%1]\n"
>       |                            ^~
>       |                            %w0
> 
> Thanks,
> drew
> 

That's unfortunate, I think it's because %0 specifies a 64bit register, but
the variable is declared as an unsigned int, which is 32 bits.

Can you give this a go:

diff --git a/arm/mte.c b/arm/mte.c
index f32203ce275a..9c266fcced5f 100644
--- a/arm/mte.c
+++ b/arm/mte.c
@@ -60,8 +60,8 @@ static inline void mem_read(unsigned int *addr, unsigned int *res)
 {
        unsigned int r;

-       asm volatile ("ldr %0,[%1]\n"
-                     "str %0,[%2]\n"
+       asm volatile ("ldr %w0,[%1]\n"
+                     "str %w0,[%2]\n"
                      : "=&r" (r)
                      : "r" (addr), "r" (res) : "memory");
 }
@@ -69,7 +69,7 @@ static inline void mem_read(unsigned int *addr, unsigned int *res)
 static inline void mem_write(unsigned int *addr, unsigned int val)
 {
        /* The NOP allows the same exception handler as mem_read() to be used. */
-       asm volatile ("str %0,[%1]\n"
+       asm volatile ("str %w0,[%1]\n"
                      "nop\n"
                      :
                      : "r" (val), "r" (addr)

It compiles and works with gcc; with clang it compiles, but I cannot run
the test because kvm-unit-tests doesn't detect MTE support in the compiler.

$ ./configure --arch=arm64 --cc=clang --cross-prefix=aarch64-linux-gnu- --cflags='--target=aarch64-linux -march=armv8.5-a+memtag'
$ make -j32 clean && make -j32
$ ./run_tests.sh -g mte
config.mak: line 13: -march=armv8.5-a+memtag: command not found
config.mak: line 13: -march=armv8.5-a+memtag: command not found
SKIP mte-sync (1 tests, 1 skipped)
SKIP mte-async (1 tests, 1 skipped)
SKIP mte-asymm (1 tests, 1 skipped)

(the error I suppose it's because configure doesn't wrap CFLAGS in quotes
when writing config.mak).

Do you have any hints about enabling MTE in clang?

Thanks,
Alex

