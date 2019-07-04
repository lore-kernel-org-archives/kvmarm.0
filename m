Return-Path: <SRS0=oQwk=VB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA30FC5B578
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 03:03:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C144218A4
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 03:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sIoi5eLA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C144218A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA5C34A52E;
	Wed,  3 Jul 2019 23:03:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mqgtj0PbLjKK; Wed,  3 Jul 2019 23:03:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7E404A512;
	Wed,  3 Jul 2019 23:03:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D79AF4A512
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 23:03:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6gm1Q9n4zfeA for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Jul 2019 23:02:58 -0400 (EDT)
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com
 [209.85.214.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E80C94A4C0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 23:02:57 -0400 (EDT)
Received: by mail-pl1-f195.google.com with SMTP id 9so2281507ple.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Jul 2019 20:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=sTyi3iR7jCQEvPxbK8BvR4ttAJnxbQR239LUB66iAhw=;
 b=sIoi5eLAtErLcyWaGKCZPpvRw6qDchu67+af937tNVrygSPa938aKBuPkQKCVhNKG2
 oPJWZO/yTItjz3HsIjSKgZos83+uXXtBay3X7cc+z2898g+oGx2s+A/oLso/adx8w3E2
 pa9khEXpvG+YnS4WPoQ/kvXewSRhQITwyOtqfv6G4JlwFwOqt7fC6BJVZEsRfbhmIBMP
 Z2DgYlFJMbg4E6px2lBu5mZ/BOdq0l9V+tIgqgo9xcHaYXC2ikm3sQfcfvXOaZMKDC2R
 VXyB6L9u/FMpv+QbnLdNkLcPE33UnR0DMkrOwYd4NUI2TXwldR4/TxEcGlsVivQTgNhg
 tJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=sTyi3iR7jCQEvPxbK8BvR4ttAJnxbQR239LUB66iAhw=;
 b=FvWGn7yd0lppNKtetsPPWRV/Jp1eu+V8m9qLSrMq9zZPZ9zw5msn4TZTW6G919hcfG
 w/tvuj2evRxYhACK0E0Ie9z0OCnrOPamRj/1J041L5yO3fgAEaj0tGprwgJ/kVyUyaKD
 BXL+HQ/VHMWOmgv9HbnGJhwFZKHYIDX0hSjsyxD7mwONXIuROG8fQZ+oQqmQECDPIOoJ
 nzys/JEZqhX7zL/2JjNbtb+Vh+S8+6D6yCi/bDtRKhGVy8dpelKo6ULbiVWzGyD0+fw+
 CqjsMaSEGIFgrdSIntkj5abqysGR0H2A+vW0MI5dYqftW1RjWIkF6K6hnjZy6JhIjCGN
 u9Kw==
X-Gm-Message-State: APjAAAXO/gENqMKL0502SO8c9FEXbARYQlGhXiMzmFsKtMTZ5jToZ7r5
 6N3KyIOR6ICJSYJTUARCuNaQQw==
X-Google-Smtp-Source: APXvYqzkj47IBLLAis02KF5EQOJCt0lQoi5aUBJqMTCt+0NdKbWEmwsRT4Wgfx80LGdiSNq0hlOBww==
X-Received: by 2002:a17:902:760a:: with SMTP id
 k10mr43054314pll.83.1562209376887; 
 Wed, 03 Jul 2019 20:02:56 -0700 (PDT)
Received: from localhost ([122.172.21.205])
 by smtp.gmail.com with ESMTPSA id i7sm3468537pjk.24.2019.07.03.20.02.54
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 03 Jul 2019 20:02:55 -0700 (PDT)
Date: Thu, 4 Jul 2019 08:32:52 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] KVM: arm64/sve: Fix vq_present() macro to yield a bool
Message-ID: <20190704030252.4gzvoh4rxdmmddu5@vireshk-i7>
References: <1562175770-10952-1-git-send-email-Dave.Martin@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1562175770-10952-1-git-send-email-Dave.Martin@arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On 03-07-19, 18:42, Dave Martin wrote:
> From: Zhang Lei <zhang.lei@jp.fujitsu.com>
> 
> The original implementation of vq_present() relied on aggressive
> inlining in order for the compiler to know that the code is
> correct, due to some const-casting issues.  This was causing sparse
> and clang to complain, while GCC compiled cleanly.
> 
> Commit 0c529ff789bc addressed this problem, but since vq_present()
> is no longer a function, there is now no implicit casting of the
> returned value to the return type (bool).
> 
> In set_sve_vls(), this uncast bit value is compared against a bool,
> and so may spuriously compare as unequal when both are nonzero.  As
> a result, KVM may reject valid SVE vector length configurations as
> invalid, and vice versa.
> 
> Fix it by forcing the returned value to a bool.
> 
> Signed-off-by: Zhang Lei <zhang.lei@jp.fujitsu.com>
> Fixes: 0c529ff789bc ("KVM: arm64: Implement vq_present() as a macro")
> Signed-off-by: Dave Martin <Dave.Martin@arm.com> [commit message rewrite]
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> 
> ---
> 
> Posting this under Zhang Lei's authorship, due to the need to turn this
> fix around quickly.  The fix is as per the original suggestion [1].
> 
> Originally observed with the QEMU KVM SVE support under review:
> https://lists.gnu.org/archive/html/qemu-devel/2019-06/msg04945.html
> 
> Bug reproduced and fix tested on the Arm Fast Model, with
> http://linux-arm.org/git?p=kvmtool-dm.git;a=shortlog;h=refs/heads/sve/v3/head
> (After rerunning util/update_headers.sh.)
> 
> (the --sve-vls command line argument was removed in v4 of the
> kvmtool patches).
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2019-July/664633.html
> ---
>  arch/arm64/kvm/guest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index c2afa79..dfd6264 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -208,7 +208,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  
>  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
>  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> -#define vq_present(vqs, vq) ((vqs)[vq_word(vq)] & vq_mask(vq))
> +#define vq_present(vqs, vq) (!!((vqs)[vq_word(vq)] & vq_mask(vq)))
>  
>  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {

It was a really nice bug :)

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
