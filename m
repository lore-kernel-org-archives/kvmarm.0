Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB04C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jan 2022 14:59:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B9C34B1C6;
	Wed,  5 Jan 2022 09:59:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lRRPCS0l6WGN; Wed,  5 Jan 2022 09:59:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43DBD4B0DD;
	Wed,  5 Jan 2022 09:59:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5164B4A19A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 09:59:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L6mqxrh6VA0a for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 09:59:00 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3924740CE3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 09:59:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641394739;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xuDXDZaYk8pGsNJOMGUKMDNxo2JBtvsfuoGsrVtjpq0=;
 b=coxKXiYkTeRTnxc8KJv6tb5iL3La/PVAk11lntdPO5bwl3tdO91ZH+1z08bgPdhwM3Af0O
 ByBGHX6/W3ZIZ+wO+5/s44zJ+xCFF/VR+JtMpcRFqZrQ42ZmIA07Px9r5HbOG1oHgI0xZz
 T8VvF7Ebijhxq/ylEfO2fJhgTmU4zaE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-QHq-XWckNSCgLMpwVxwZpg-1; Wed, 05 Jan 2022 09:58:58 -0500
X-MC-Unique: QHq-XWckNSCgLMpwVxwZpg-1
Received: by mail-wr1-f71.google.com with SMTP id
 q16-20020adfbb90000000b001a4838099baso122281wrg.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 06:58:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xuDXDZaYk8pGsNJOMGUKMDNxo2JBtvsfuoGsrVtjpq0=;
 b=vOJ1eaUpFcrTJsqG5SrPSEQBnDNPJZvJvEsVXvwKsQrVBh3xDR53o542B1NzxzfKKB
 8t6T+xMF+gIIc0FYvwOn84SOhmZ2FMcvhlQCyTREcKqTHA/SEjDTmbmGaVpylKFz+dKn
 uHr9LHCRvZPPhN0L6hT2CS1m54AyffqQraKhDXHXsjm30DxKzImjI3G3xruJc8+HxuGR
 Cpv7Ny+i4YP+Ijg8ev1h5Esu/UtuwdxNmx9PYVldMN9Y7+Z0ioEgWEXk7RvtCQrHQMiY
 HFq5o1j0gcC46I5snJPtykJ38mJkd2GS2l1dlcpRUbyzkQesqVOaF7oq4ftLJ9EOpO1p
 m36Q==
X-Gm-Message-State: AOAM532XsNIu9G9KLS5NfW1zC2g6lQPcABr+PWP9Ca3bWYzfN9wrPgi2
 EbLqlMMySTuuiCQx29RO/vyB8pxOD2At3OHN1mAuitbi+P3s1nIYaf5gJ2GNYmYLv66XxbXhHzO
 w/ddcq3sRI+23S3p8TwYditBJ
X-Received: by 2002:a5d:564f:: with SMTP id j15mr45520964wrw.366.1641394737704; 
 Wed, 05 Jan 2022 06:58:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzAIE48Rt6oCWt/TrKYOLRuPR/0b02qx5CUgTR/XXf3h6OjcPtM0vEG7RamhYrEag2pLW40KA==
X-Received: by 2002:a5d:564f:: with SMTP id j15mr45520954wrw.366.1641394737546; 
 Wed, 05 Jan 2022 06:58:57 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id n9sm3237489wmq.37.2022.01.05.06.58.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Jan 2022 06:58:57 -0800 (PST)
Date: Wed, 5 Jan 2022 15:58:55 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
Message-ID: <20220105145855.ca7vxeu3ubytdkna@gator>
References: <20220103180507.2190429-1-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220103180507.2190429-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Richard Henderson <richard.henderson@linaro.org>,
 qemu-devel@nongnu.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jan 03, 2022 at 06:05:07PM +0000, Marc Zyngier wrote:
> Add basic support for Pointer Authentication when running a KVM
> guest and that the host supports it, loosely based on the SVE
> support.
> 
> Although the feature is enabled by default when the host advertises
> it, it is possible to disable it by setting the 'pauth=off' CPU
> property. The 'pauth' comment is removed from cpu-features.rst,
> as it is now common to both TCG and KVM.
> 
> Tested on an Apple M1 running 5.16-rc6.
> 
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> * From v1:
>   - Drop 'pauth' documentation
>   - Make the TCG path common to both TCG and KVM
>   - Some tidying up
> 
>  docs/system/arm/cpu-features.rst |  4 ----
>  target/arm/cpu.c                 | 14 ++++----------
>  target/arm/cpu.h                 |  1 +
>  target/arm/cpu64.c               | 33 ++++++++++++++++++++++++++++----
>  target/arm/kvm64.c               | 21 ++++++++++++++++++++
>  5 files changed, 55 insertions(+), 18 deletions(-)
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
