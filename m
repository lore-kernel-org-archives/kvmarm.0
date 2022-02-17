Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640A3C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 16:10:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDC76401AF;
	Thu, 17 Feb 2022 11:10:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uBhPx5PB-FIo; Thu, 17 Feb 2022 11:10:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38F9040256;
	Thu, 17 Feb 2022 11:10:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF31549E42
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 11:10:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hC2M5VlYqafd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 11:10:30 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D1F849E39
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 11:10:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1645114230;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=KCilBuq9NLr3A/KqmUevjyQMMZifNiNCO4lvtgHn2dk=;
 b=RzGSodow88diGNoJ3qeR5fXj25JlprNPyxW1yim3QZMesxrDNfUf/fL6Zo3fzj+ixyz04u
 WCLHQgB+T2QuMgCUDtxmsEfnB5rdjxfB2OTUes/5DgrUMpIoaT/vA1FwTV4f96HANzHUKl
 OLhdFqCXK+e7K3H0f7ccL7HdXIW6S1E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-wpTZZAyVNnCjxNu2Wg_Y5Q-1; Thu, 17 Feb 2022 11:10:27 -0500
X-MC-Unique: wpTZZAyVNnCjxNu2Wg_Y5Q-1
Received: by mail-wm1-f70.google.com with SMTP id
 p24-20020a05600c1d9800b0037be98d03a1so4482671wms.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 08:10:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KCilBuq9NLr3A/KqmUevjyQMMZifNiNCO4lvtgHn2dk=;
 b=UDTI8FQ9rj1EBxz/aTY1BI580UwajV1T8NDOn6Y0VqW2EYJwc+uFWEmfSGuxTuJ8+e
 Exs4TdlHLrzrtjPbTvMLFccq4LApx8g7ZuOCl0wuxAvgVCmhx7zJQaz2kf2mFMKFeP/j
 rF85nlxlhieyG/f3pVBCmmEUtI3jNPIfvT5iDKL9mP+lsBWSw4mC4uGQUAWrqj8QuRlJ
 HqkQpjkz4rQG8F0NdZ8RQ96xnVs80BNtkI10AoyZeC2FmewbSWOJeHQC/8HRGvRLxUxI
 ANtSomhvVb7FLE5HKTW/7bvYw3soXsSCOemdN593iG0qkYn7XyA622OEe5J2bJhLMkbO
 igEw==
X-Gm-Message-State: AOAM532hwASMEPoQJoAAiEw5FA3CX08eQG3Rh6Hfb6BOkiTdc/ERFTwH
 4sJ2IeIaWZe49eWSc7yjcvte2yiOPuFm66QvUFfsYiKqUQlLTyIn7xB2TwuU+BNcT3wcCzFeOtI
 ayDxCisjOdI4U84wvo0cdHYam
X-Received: by 2002:adf:912e:0:b0:1e3:d88:bb46 with SMTP id
 j43-20020adf912e000000b001e30d88bb46mr2830362wrj.27.1645114225752; 
 Thu, 17 Feb 2022 08:10:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbQN5AdES0GxnQJugmFvBObJzZ+H0Qui96yhuMVknj224TdFRUkCkuk52o2dsoZehckyo38g==
X-Received: by 2002:adf:912e:0:b0:1e3:d88:bb46 with SMTP id
 j43-20020adf912e000000b001e30d88bb46mr2830344wrj.27.1645114225478; 
 Thu, 17 Feb 2022 08:10:25 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id l11sm29837357wry.77.2022.02.17.08.10.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Feb 2022 08:10:24 -0800 (PST)
Date: Thu, 17 Feb 2022 17:10:22 +0100
From: Andrew Jones <drjones@redhat.com>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [kvm-unit-tests PATCH] configure: arm: Fixes to build and run
 tests on Apple Silicon
Message-ID: <20220217161022.krzj2g37natxrj6x@gator>
References: <20220217102806.28749-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
In-Reply-To: <20220217102806.28749-1-nikos.nikoleris@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: pbonzini@redhat.com, thuth@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, jade.alglave@arm.com
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

On Thu, Feb 17, 2022 at 10:28:06AM +0000, Nikos Nikoleris wrote:
> On MacOS:
> 
> $> uname -m
> 
> returns:
> 
> arm64
> 
> To unify how we handle the achitecture detection across different
> systems, sed it to aarch64 which is what's typically reported on

Was "sed" a typo or a new verb for "sedding" stuff :-)

> Linux.
> 
> In addition, when HVF is the acceleration method on aarch64, make sure
> we select the right processor when invoking qemu.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  arm/run   | 3 +++
>  configure | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/run b/arm/run
> index 2153bd3..0629b69 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -27,6 +27,9 @@ if [ "$ACCEL" = "kvm" ]; then
>  	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
>  		M+=',gic-version=host'
>  	fi
> +fi
> +
> +if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
>  	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
>  		processor="host"
>  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> diff --git a/configure b/configure
> index 2d9c3e0..ff840c1 100755
> --- a/configure
> +++ b/configure
> @@ -14,7 +14,7 @@ objcopy=objcopy
>  objdump=objdump
>  ar=ar
>  addr2line=addr2line
> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> +arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>  host=$arch
>  cross_prefix=
>  endian=""
> -- 
> 2.32.0 (Apple Git-132)
>

So, with this, we've got kvm-unit-tests running on HVF now?

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
