Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AC5C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 15:16:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5D8E64FEE
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 15:16:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5D8E64FEE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 336594B518;
	Fri, 12 Mar 2021 10:16:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i4JbK1TUYecr; Fri, 12 Mar 2021 10:16:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 161B94B4E0;
	Fri, 12 Mar 2021 10:16:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 183564B4D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 10:16:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id utW53gEpog+T for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 10:16:14 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2C24B4C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 10:16:14 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615562174;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=A5J2rJulblbgqoqRb92cPCJCQqD7ZFSeC+TL1fUNNCA=;
 b=RzXVRvlYOHCKoU4AXf0FGL29zkarTvd/5onYKvJPaABSk3S/65+i/un2I5r9ePk70IgSWL
 S6aIFzwGOzB9nW/c1gghnb7LPTpEiERtjjAcbgBSwjtkDJ53Wezrw6v2XGvRI/ovYYr7S/
 D9Ds365daPLun+bvAWbd1JNvgWi/ejY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-9H0tOIyEP7qpkoGZnRSVqg-1; Fri, 12 Mar 2021 10:16:12 -0500
X-MC-Unique: 9H0tOIyEP7qpkoGZnRSVqg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2078A107ACCD;
 Fri, 12 Mar 2021 15:16:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.104])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8589619704;
 Fri, 12 Mar 2021 15:16:09 +0000 (UTC)
Date: Fri, 12 Mar 2021 16:16:06 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] configure: arm/arm64: Add --earlycon
 option to set UART type and address
Message-ID: <20210312151606.qkfp7evsrpbw2wtq@kamzik.brq.redhat.com>
References: <20210219163718.109101-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210219163718.109101-1-alexandru.elisei@arm.com>
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

On Fri, Feb 19, 2021 at 04:37:18PM +0000, Alexandru Elisei wrote:
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
> name. Specifying this option will overwrite the UART address set by --vmm.
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

s/be on of/be one of/

> +	                           sensitive):
> +	               uart[8250],mmio,ADDR
> +	                           Specify an 8250 compatible UART at address ADDR. Supported
> +	                           register stride is 8 bit only.
> +	               pl011,mmio,ADDR
> +	                           Specify a PL011 compatible UART at address ADDR. Supported
> +	                           register stride is 8 bit only.
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
> -- 
> 2.30.1
>

Otherwise,
 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
