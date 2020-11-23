Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C1AC2D0E4
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 13:22:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A89D720773
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 13:22:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="rTTjlgTI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A89D720773
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E19174BB34;
	Mon, 23 Nov 2020 08:22:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zjilMfmQoKTn; Mon, 23 Nov 2020 08:22:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB9D14BB16;
	Mon, 23 Nov 2020 08:22:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D8B94BAD4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 08:22:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tux7khC3S8GI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 08:22:28 -0500 (EST)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5FA64BAC1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 08:22:28 -0500 (EST)
Received: by mail-oi1-f193.google.com with SMTP id l206so19558521oif.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 05:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/kdqFZeAVjbR1EcrIlFEOxJOMeoTF+Ogzz6G56OSu8M=;
 b=rTTjlgTIUFSWUW/IC4OxUfYnSqKXdJJ9kqYLU/ZqrJAAi87J+7NiREj6ube4ANvu1g
 LsHbqdqUqsv1WvcxkWTewmx3DHXB3cakd8AOodJlcSbrVphhStsCFNaDA0bWkye3lKjm
 AcQllA7rtoChNr8xdo732cLNI+Hy+0pe5oXbIrBYCjn3BPQmXgi82/O1h35cWJqz9T2/
 edQbz0xLSKOG16+/9MKx49RjIACs+K8INOB7JtBQwPP8geXDKG9gyx9eckuCQ6gpNpdk
 Y9AZ333KWpIZr4Kza7TJAOnmVPkXgStofyfEhZK7IKJCMoly0/9ynQdr/CGbnQIOU6mh
 C0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/kdqFZeAVjbR1EcrIlFEOxJOMeoTF+Ogzz6G56OSu8M=;
 b=GXOY82UxkTtPixAVQT/pxK63EQyW9XOetw8hSrgEcKFWy7OsOkhqi/k8ss34ewtjZ2
 gbUfgFkWuR88ZvR1EEYqe17uD76KHXmRLarn/nWeJQ3Y4tAGTWbdRDUaNs1jpoHIEkpZ
 MIOpIQDsNJUKDqbEhhTUWMizvoKGZzS5Xt9S1pK7C56P88Hba8IQgQgsY5xEvX9uH9BO
 t9Cymh8FVO2RCltBNT0VMjNa74+/0C6F66+nkm6izYKf7gcoJ2ph8kGYToGHD//Cp13r
 k5Wil6Xvu7bP59LW7WlGrzd/28hmvY9rpLNXKaYbpOCmIbAx8H/1caBpgWe57abNi3ww
 WPiQ==
X-Gm-Message-State: AOAM532LYKJnMOisScmn1uJpRtzZChzlI3+i//VaF3D2zxRlCy2cqvpu
 KPS5sJRjVIORfjwEvME6bo84uQ==
X-Google-Smtp-Source: ABdhPJzEhLvMoLTH89tN1wdaa8/gjQDGQFbkETdg1TT2tpDZ6ILozNTF3nqBtpBt76eWvVSRF6fAZg==
X-Received: by 2002:a05:6808:301:: with SMTP id
 i1mr15073703oie.49.1606137747765; 
 Mon, 23 Nov 2020 05:22:27 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:acac:b2ef:c7d:fd8a])
 by smtp.gmail.com with ESMTPSA id s185sm7344774oia.18.2020.11.23.05.22.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Nov 2020 05:22:26 -0800 (PST)
Date: Mon, 23 Nov 2020 13:22:23 +0000
From: David Brazdil <dbrazdil@google.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH 13/27] KVM: arm64: Enable access to sanitized CPU
 features at EL2
Message-ID: <20201123132223.oohevce4izuoaqi3@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-14-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201117181607.1761516-14-qperret@google.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

> +int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst)
> +{
> +	struct arm64_ftr_reg *regp = get_arm64_ftr_reg(id);
> +
> +	if (!regp)
> +		return -EINVAL;
> +
> +	memcpy(dst, regp, sizeof(*regp));
> +
> +	return 0;
> +}
> +
>  #define read_sysreg_case(r)	\
>  	case r:		return read_sysreg_s(r)
>  
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index dd8ccc9efb6a..c35d768672eb 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -116,6 +116,8 @@ __kvm_nvhe___memcpy			= __kvm_nvhe___pi_memcpy;
>  __kvm_nvhe___memset			= __kvm_nvhe___pi_memset;
>  #endif
>  
> +_kvm_nvhe___flush_dcache_area		= __kvm_nvhe___pi___flush_dcache_area;
> +

Could you help my understand why we need this?
* Why do we need PI routines in the first place? Would my series that fixes
  relocations in hyp code remove the need?
* You added these aliases for the string routines because you were worried
  somebody would change the implementation in arch/arm64/lib, right? But this
  cache flush function is defined in hyp/nvhe. So why do we need to point to
  the PI alias if we control the implementation?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
