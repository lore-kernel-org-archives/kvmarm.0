Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250A8C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 15:56:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0FBF207D8
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 15:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="jUCcan+N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0FBF207D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16E0E4B151;
	Mon, 18 May 2020 11:56:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b1x1dgzZCo16; Mon, 18 May 2020 11:56:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 155B44B12E;
	Mon, 18 May 2020 11:56:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E6A4B10F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 11:56:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dq91BYZsbpMZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 11:56:00 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF9594B0ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 11:55:59 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id s8so12477812wrt.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 08:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=PtEh/eqO/jcM1mnHH6fVjI/HimaXnKzbvkPLBE0BPVI=;
 b=jUCcan+Nms1s70qgGIq39zMEO6T5qEC+yiZdoFL9PBCRCkQs5AUHTbRiAcAhI0lZ5y
 2+Xqnr+pY68Sd5tq2onYhMA4ykp8LFiKYIRuP62Tjcyht8aAEHNMnfZpwNkyY8DQ/ZaM
 8E2Tp0Xk9TIV1TBt455W9oAIvkpV7TtDj0yaluNRAygGidNh5suWfslpRiEe2ie6rdqw
 pPWH5//rz9ABUSurZU0iRUWSSwBn6VuDmMOOLPgzRndHHNsX1Ea7lwYtnxR3ZDqKdEBc
 PRz+Yvvizttbarx8SUIfvLvxYIyB29jqXPparoMQreul88KBAGoPE/XtONTIkm0DNYj0
 lFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PtEh/eqO/jcM1mnHH6fVjI/HimaXnKzbvkPLBE0BPVI=;
 b=UL4rzZT6pyNcwGmxHpyKbJBGu3A6n8wvn32kNS+iByoWg2Fr6hBGD5KkIPZMAhWaGO
 gNF8tmIfGj3ux1GhYNK/CGlYFv9RdvzqFNWUXv9ygmdLvJmtMwH1XHm/Y3mbyVIiqUAB
 OV152HBjd/OAgqFnfI0+snQv9PUG42aG2Ieo5Lu14+i2zQQPRlDECTtAj0vqOvvX0co1
 qYlACfgPuPEHYH38WeM3OKOsq4+2nnEG4tYTPXSASGPTI+Xf65lJ39RsUPO+DrhgFw+c
 bEBTlicDWtXtR03Ydu2LyCZBCTwp0irQlJ6Hobh5OmuR/eiKMAY6/4ip55grc1qajc63
 /S6w==
X-Gm-Message-State: AOAM532Lv3aT1oLKAnOi9SmUfBnE7mWE2ekYnxo2AUYhU7Tysq4fCL7D
 bfoT7XkQuX1QAW2iU0ptCuxruA==
X-Google-Smtp-Source: ABdhPJxt1Zaz2JVaB0TU+GicXYJwo+95dXbld8dQov8mZpcW9twBDQrd3PgWr5SfeOkk5/wD0DEL0A==
X-Received: by 2002:adf:cd88:: with SMTP id q8mr20999524wrj.67.1589817358531; 
 Mon, 18 May 2020 08:55:58 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id v126sm13452wmb.4.2020.05.18.08.55.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 May 2020 08:55:57 -0700 (PDT)
Date: Mon, 18 May 2020 16:55:53 +0100
From: Andrew Scull <ascull@google.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v2 04/14] arm64: kvm: Add build rules for separate nVHE
 object files
Message-ID: <20200518155553.GB147668@google.com>
References: <20200515105841.73532-1-dbrazdil@google.com>
 <20200515105841.73532-5-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200515105841.73532-5-dbrazdil@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Fri, May 15, 2020 at 11:58:31AM +0100, David Brazdil wrote:
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 7f06ad93fc95..13850134fc28 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -51,4 +51,16 @@ __efistub__ctype		= _ctype;
>  
>  #endif
>  
> +#ifdef CONFIG_KVM
> +
> +/*
> + * KVM nVHE code has its own symbol namespace prefixed by __hyp_text_, to
> + * isolate it from the kernel proper. The following symbols are legally
> + * accessed by it, therefore provide aliases to make them linkable.
> + * Do not include symbols which may not be safely accessed under hypervisor
> + * memory mappings.
> + */

nit: the prefix is not '__kvm_nvhe_' rather than '__hyp_text_'
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
