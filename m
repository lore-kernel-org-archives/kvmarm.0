Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D9BC43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 10:57:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7DE84D521;
	Mon, 18 Jul 2022 06:57:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rbt62uPZEJHk; Mon, 18 Jul 2022 06:57:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C38084D51F;
	Mon, 18 Jul 2022 06:57:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7ED54D371
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 06:54:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2VgD85f1WzS8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 06:54:29 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBAB54D316
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 06:54:29 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id e15so11191129wro.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 03:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=EnNyVXrZhTsXbUVxkr3n4VsUhRgF1qEMC8DKDk1V3bg=;
 b=rA1jEp0LpZP1+P6mDlvjxu6wXht3l3c85gezvxbNTLmGEt+mwhGqy8ciWXMPEiQhsV
 Py0iFtckCil7igYZcFp6sDt9mXipN8SxsYKXB5MT84MHrGLgoU3DpAvT4AD37DSgCo41
 O2wryFz75Kg83wzds9RuyLwCZeqZc7MgLh7CfbywkTH7Ra8ougAgyYpb/Yl90sKTdEFV
 9X6BfYNDnl6+npLtohqcJirL2eijkmdGaL+ShhNBfVUdkzqXuAlyfZMAB0qlmZ5JYBc3
 HFpTXa1MudIGNW7loLT1zL2/chxy33iqWg5/mSXStWMV3XpVFqIWy2xSLd3ZT3tBeNR5
 RBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=EnNyVXrZhTsXbUVxkr3n4VsUhRgF1qEMC8DKDk1V3bg=;
 b=vE34cMGgxrEANJPLSqVy3BiTqo0wpCXoEpotQTLv8InpUUN9m6FH2vLZGTpVMCxct8
 /cV/1Iz9kuMwP9vnunc/WW0Ae0+uMxKet82x7oJrgJdFpnSrHbSebxRU1yIFyO95RrAk
 vpZs/lhtRNhlP01mdVsDHwgBhi/7sWZ4VYyhSM0cOLi3JVz+UhHsPNUgX83RBOeWE6x6
 ujcpT9b9m7X/t6OfNkUIwN6VmGz+TU+IpeWMaunNnKUth2WvGMNaWcXL4CP0ljE+31Bc
 Mj9++Li3NMuw7iiDHyzFNMZ5PR5AhItwcVgWN0+AR6e2L8csfD7hOA2Iio2HhZXkjKcc
 lwJg==
X-Gm-Message-State: AJIora9stHUoH01hT5wNxBKGygPTRXAaaoijADaS6HmFCQSn3nAlB03L
 bTXVESJVPpErJNOvz76OXBJ7Zg==
X-Google-Smtp-Source: AGRyM1s++fQ9NM06ad06/mDC5sdqkaLBhNndHCSSldelrOBvrP9ZoL8WSbkS9NkWyl/ehH7BaNd77Q==
X-Received: by 2002:adf:d20e:0:b0:21d:7654:729b with SMTP id
 j14-20020adfd20e000000b0021d7654729bmr22523907wrh.239.1658141668639; 
 Mon, 18 Jul 2022 03:54:28 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com.
 [35.187.36.109]) by smtp.gmail.com with ESMTPSA id
 o42-20020a05600c512a00b0039c457cea21sm15087975wms.34.2022.07.18.03.54.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jul 2022 03:54:28 -0700 (PDT)
Date: Mon, 18 Jul 2022 11:54:24 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/24] KVM: arm64: Add flags to struct hyp_page
Message-ID: <YtU74D9fcLCpHHwc@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-4-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-4-will@kernel.org>
X-Mailman-Approved-At: Mon, 18 Jul 2022 06:57:23 -0400
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, Andy Lutomirski <luto@amacapital.net>,
 linux-arm-kernel@lists.infradead.org, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 30, 2022 at 02:57:26PM +0100, Will Deacon wrote:
> From: Quentin Perret <qperret@google.com>
> 
> Add a 'flags' field to struct hyp_page, and reduce the size of the order
> field to u8 to avoid growing the struct size.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  6 +++---
>  arch/arm64/kvm/hyp/include/nvhe/memory.h |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 14 +++++++-------
>  3 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> index 0a048dc06a7d..9330b13075f8 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> @@ -7,7 +7,7 @@
>  #include <nvhe/memory.h>
>  #include <nvhe/spinlock.h>
>  
> -#define HYP_NO_ORDER	USHRT_MAX
> +#define HYP_NO_ORDER	0xff

BUG_ON in hyp_page_ref_inc() might now need to test for 0xff/HYP_NO_ORDER
instead of USHRT_MAX.

[...]
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
