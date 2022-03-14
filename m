Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE4CC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 20:02:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6588349EFC;
	Mon, 14 Mar 2022 16:02:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HbpSMZH1VVDP; Mon, 14 Mar 2022 16:02:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C2CF49EE9;
	Mon, 14 Mar 2022 16:02:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57A9149EE9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:02:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w271j4SAKJQ6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 16:02:47 -0400 (EDT)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com
 [209.85.166.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9F1D49EFC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:02:46 -0400 (EDT)
Received: by mail-io1-f42.google.com with SMTP id x4so19690262iop.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 13:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=5f2/HoIwu4j9nQu9qTBXrIZ6NMk6olPlLIzOEbYSwZw=;
 b=YSdWC5rvFf1g8ioBrwOR3I4g6iXlWuZTXYZmkB/YQq1F1LrcUaSd/IQL+JvtW6ihSp
 oQaeInLjTzG/E53npJN0joUHNTo51L0lUAbybFrGGy5h1XilJkR03a6LOeR1W6M85NDw
 P7mQ1C/yLXctxm7ySS07JsZcTqIrLfPQo031NqWsuNEIjJHqw9V4GydqW30p1Zya0c1K
 ZwDP19hMy8Qj4hekRHBCFttQRHyES8t1BcI1ERp2y6JBS5pxUC1EbIe4MEMkoI0rpq90
 NUTTKj2kIS88DkRO7tkBQ/gT5XSv4rVJd4VuWAIIiRZQFiudmldpM26HeG4gPWGw4D1b
 lyFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5f2/HoIwu4j9nQu9qTBXrIZ6NMk6olPlLIzOEbYSwZw=;
 b=Iph/ccP1BjxyUaT8OMyEUwcaYrSr/0mbYogwd7E0cvTWYUZjTeuaEbdrIJGQ27isn2
 CJgn91Y8PGG4pVnTAhX/ialzW2gavb8oazL94/q8RHSG6U8OZL/l0q/3wkdnXvCx+VXQ
 AFCGqeGeMry95us/l8wCSH1D3NArt1pT+04AVIYWQaaX67WQ0sVwu096cmZaAktKdjoF
 y7HCFmCEiQu3utRC7mqPjje4Ex2MG/i0+p07vjGJILyU+rF81qAGmeCkm/RM/0kaTr6b
 WpM34EMu3b958olauKBAbjtJT/thubUa/3gQcUKOixbia/p+KEuvonq47aBs1/M/yQdk
 KhQQ==
X-Gm-Message-State: AOAM532fSGkCWkeAI9bEkiiXQGXGMCMKdqyaG0+g/UyTorBZTdF0fNLG
 akP1pibQ4hpf6IUYNIf1Mq+uog==
X-Google-Smtp-Source: ABdhPJzeQC03D9/rf02Bht8goOg45eN2rPjgNoqhJu/PvxB2PzO/F0nX9G85uS1FXW19T23DPBCxaw==
X-Received: by 2002:a05:6638:16c5:b0:319:e32b:98e3 with SMTP id
 g5-20020a05663816c500b00319e32b98e3mr12201874jat.123.1647288165969; 
 Mon, 14 Mar 2022 13:02:45 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 x14-20020a056e021bce00b002c7ada1bec5sm943788ilv.88.2022.03.14.13.02.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Mar 2022 13:02:45 -0700 (PDT)
Date: Mon, 14 Mar 2022 20:02:42 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 13/13] selftests: KVM: aarch64: Add the bitmap
 firmware registers to get-reg-list
Message-ID: <Yi+fYt3MhMoZbN+T@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-14-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220224172559.4170192-14-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Feb 24, 2022 at 05:25:59PM +0000, Raghavendra Rao Ananta wrote:
> Add the psuedo-firmware registers KVM_REG_ARM_STD_BMAP,
> KVM_REG_ARM_STD_HYP_BMAP, and KVM_REG_ARM_VENDOR_HYP_BMAP to
> the base_regs[] list.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index f769fc6cd927..42e613a7bb6a 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -686,6 +686,9 @@ static __u64 base_regs[] = {
>  	KVM_REG_ARM_FW_REG(0),
>  	KVM_REG_ARM_FW_REG(1),
>  	KVM_REG_ARM_FW_REG(2),
> +	KVM_REG_ARM_FW_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
> +	KVM_REG_ARM_FW_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
> +	KVM_REG_ARM_FW_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
>  	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
>  	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
>  	ARM64_SYS_REG(3, 3, 14, 0, 2),
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
