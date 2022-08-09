Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF7FC19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 13:24:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 361674CAE4;
	Tue,  9 Aug 2022 09:24:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RZ8a7UfM6oRJ; Tue,  9 Aug 2022 09:23:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E61F64C965;
	Tue,  9 Aug 2022 09:23:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB9654CEF8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 08:36:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id foKPAN9BQGRW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 08:36:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 790164CEE3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 08:36:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A97FA23A;
 Tue,  9 Aug 2022 05:36:20 -0700 (PDT)
Received: from [192.168.12.23] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5861A3F5A1;
 Tue,  9 Aug 2022 05:36:18 -0700 (PDT)
Message-ID: <6d3498f8-80f7-be78-fbdf-643014828c54@arm.com>
Date: Tue, 9 Aug 2022 13:36:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests RFC PATCH 01/19] Makefile: Define __ASSEMBLY__
 for assembly files
Content-Language: en-GB
To: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
 thuth@redhat.com, andrew.jones@linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-2-alexandru.elisei@arm.com>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20220809091558.14379-2-alexandru.elisei@arm.com>
X-Mailman-Approved-At: Tue, 09 Aug 2022 09:23:58 -0400
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/08/2022 10:15, Alexandru Elisei wrote:
> There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
> with functionality relies on the __ASSEMBLY__ prepocessor constant being
> correctly defined to work correctly. So far, kvm-unit-tests has relied on
> the assembly files to define the constant before including any header
> files which depend on it.
> 
> Let's make sure that nobody gets this wrong and define it as a compiler
> constant when compiling assembly files. __ASSEMBLY__ is now defined for all
> .S files, even those that didn't set it explicitely before.
> 

This is a great idea.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   Makefile           | 5 ++++-
>   arm/cstart.S       | 1 -
>   arm/cstart64.S     | 1 -
>   powerpc/cstart64.S | 1 -
>   4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6ed5deaccb41..42c61aa45d50 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -94,6 +94,9 @@ CFLAGS += $(wmissing_parameter_type)
>   CFLAGS += $(wold_style_declaration)
>   CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>   
> +AFLAGS  = $(CFLAGS)
> +AFLAGS += -D__ASSEMBLY__
> +
>   autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
>   
>   LDFLAGS += $(CFLAGS)
> @@ -117,7 +120,7 @@ directories:
>   	@mkdir -p $(OBJDIRS)
>   
>   %.o: %.S
> -	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> +	$(CC) $(AFLAGS) -c -nostdlib -o $@ $<
>   
>   -include */.*.d */*/.*.d
>   
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 7036e67fc0d8..39260e0fa470 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -5,7 +5,6 @@
>    *
>    * This work is licensed under the terms of the GNU LGPL, version 2.
>    */
> -#define __ASSEMBLY__
>   #include <auxinfo.h>
>   #include <asm/assembler.h>
>   #include <asm/thread_info.h>
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index e4ab7d06251e..d62360cf3859 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -5,7 +5,6 @@
>    *
>    * This work is licensed under the terms of the GNU GPL, version 2.
>    */
> -#define __ASSEMBLY__
>   #include <auxinfo.h>
>   #include <asm/asm-offsets.h>
>   #include <asm/assembler.h>
> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> index 972851f9ed65..1a823385fd0f 100644
> --- a/powerpc/cstart64.S
> +++ b/powerpc/cstart64.S
> @@ -5,7 +5,6 @@
>    *
>    * This work is licensed under the terms of the GNU LGPL, version 2.
>    */
> -#define __ASSEMBLY__
>   #include <asm/hcall.h>
>   #include <asm/ppc_asm.h>
>   #include <asm/rtas.h>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
