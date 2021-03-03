Return-Path: <SRS0=lGHe=IB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F6CC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 14:19:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D8CB64ED7
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 14:19:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D8CB64ED7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9FBA4B256;
	Wed,  3 Mar 2021 09:18:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DnN99MFhq5tr; Wed,  3 Mar 2021 09:18:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BCF74B21F;
	Wed,  3 Mar 2021 09:18:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46F164B21F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 09:18:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yuEpMQ0jJ0jF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Mar 2021 09:18:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE1624B21E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 09:18:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4ABB631B;
 Wed,  3 Mar 2021 06:18:55 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C4E73F766;
 Wed,  3 Mar 2021 06:18:54 -0800 (PST)
Date: Wed, 3 Mar 2021 14:18:46 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] configure: arm/arm64: Add --earlycon
 option to set UART type and address
Message-ID: <20210303141846.0bcc0d2c@slackpad.fritz.box>
In-Reply-To: <20210219163718.109101-1-alexandru.elisei@arm.com>
References: <20210219163718.109101-1-alexandru.elisei@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
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

On Fri, 19 Feb 2021 16:37:18 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Currently, the UART early address is set indirectly with the --vmm option
> and there are only two possible values: if the VMM is qemu (the default),
> then the UART address is set to 0x09000000; if the VMM is kvmtool, then the
> UART address is set to 0x3f8.
> 
> There several efforts under way to change the kvmtool UART address, and
> kvm-unit-tests so far hasn't had mechanism to let the user set a specific
> address, which means that the early UART won't be available.
> 
> This situation will only become worse as kvm-unit-tests gains support to
> run as an EFI app, as each platform will have their own UART type and
> address.
> 
> To address both issues, a new configure option is added, --earlycon. The
> syntax and semantics are identical to the kernel parameter with the same
> name.

Nice one! I like that reusing of an existing scheme.

> Specifying this option will overwrite the UART address set by --vmm.
> 
> At the moment, the UART type and register width parameters are ignored
> since both qemu's and kvmtool's UART emulation use the same offset for the
> TX register and no other registers are used by kvm-unit-tests, but the
> parameters will become relevant once EFI support is added.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> The kvmtool patches I was referring to are the patches to unify ioport and
> MMIO emulation [1] and to allow the user to specify a custom memory layout
> for the VM [2] (these patches are very old, but I plan to revive them after
> the ioport and MMIO unification series are merged).
> 
> [1] https://lore.kernel.org/kvm/20201210142908.169597-1-andre.przywara@arm.com/T/#t
> [2] https://lore.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/
> 
>  configure | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/configure b/configure
> index cdcd34e94030..d94b92255088 100755
> --- a/configure
> +++ b/configure
> @@ -26,6 +26,7 @@ errata_force=0
>  erratatxt="$srcdir/errata.txt"
>  host_key_document=
>  page_size=
> +earlycon=
>  
>  usage() {
>      cat <<-EOF
> @@ -54,6 +55,17 @@ usage() {
>  	    --page-size=PAGE_SIZE
>  	                           Specify the page size (translation granule) (4k, 16k or
>  	                           64k, default is 64k, arm64 only)
> +	    --earlycon=EARLYCON
> +	                           Specify the UART name, type and address (optional, arm and
> +	                           arm64 only). The specified address will overwrite the UART
> +	                           address set by the --vmm option. EARLYCON can be on of (case
> +	                           sensitive):
> +	               uart[8250],mmio,ADDR
> +	                           Specify an 8250 compatible UART at address ADDR. Supported
> +	                           register stride is 8 bit only.
> +	               pl011,mmio,ADDR
> +	                           Specify a PL011 compatible UART at address ADDR. Supported
> +	                           register stride is 8 bit only.

I think the PL011 only ever specified 32-bit register accesses? I just
see that we actually do a writeb() for puts, that is not guaranteed to
work on a hardware PL011, AFAIK. I guess QEMU just doesn't care ...
Looks like we should fix this, maybe we get mmio32 for uart8250 for
free, then.

The kernel specifies "pl011,mmio32,ADDR" or "pl011,ADDR", so I think we
should keep it compatible. "mmio[32]" is pretty much redundant on the
PL011 (no port I/O), I think it's just for consistency with the 8250.
Can you tweak the routine below to make this optional, and also accept
mmio32?

Cheers,
Andre

>  EOF
>      exit 1
>  }
> @@ -112,6 +124,9 @@ while [[ "$1" = -* ]]; do
>  	--page-size)
>  	    page_size="$arg"
>  	    ;;
> +	--earlycon)
> +	    earlycon="$arg"
> +	    ;;
>  	--help)
>  	    usage
>  	    ;;
> @@ -170,6 +185,26 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>          echo '--vmm must be one of "qemu" or "kvmtool"!'
>          usage
>      fi
> +
> +    if [ "$earlycon" ]; then
> +        name=$(echo $earlycon|cut -d',' -f1)
> +        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
> +                [ "$name" != "pl011" ]; then
> +            echo "unknown earlycon name: $name"
> +            usage
> +        fi
> +        type=$(echo $earlycon|cut -d',' -f2)
> +        if [ "$type" != "mmio" ]; then
> +            echo "unknown earlycon type: $type"
> +            usage
> +        fi
> +        addr=$(echo $earlycon|cut -d',' -f3)
> +        if [ -z "$addr" ]; then
> +            echo "missing earlycon address"
> +            usage
> +        fi
> +        arm_uart_early_addr=$addr
> +    fi
>  elif [ "$arch" = "ppc64" ]; then
>      testdir=powerpc
>      firmware="$testdir/boot_rom.bin"

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
