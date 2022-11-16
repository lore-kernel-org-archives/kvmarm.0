Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B58290D
	for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 09:48:02 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id r3so20315762yba.5
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 01:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie-ntu-edu-tw.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mTORVN+vb4ThEpVx7AxMit72NMXnsKSRAUOh1o/a8os=;
        b=iu183/XFyyYXhzOM/zCv5oVLc0dNPc63N8nAumxBq/E9DEFMaXcMVFjPQ8RwSk95QN
         qPwzLXSSx8g02xKSE2HH+0qsqSQCjwfSCzXWlPyjEt/GMuVRrUs4M66m6Cu0X5AQXy4f
         grx1TUGxOlGHdm36mCX0F436ljRJmlrugQFJE/7SgB9QyklFPlaZwbUq3IlCTAOCpwd/
         F26ekdEMZKT7QmX+J3Gkt/LyfFZI6fOtWtkqbWHCQT2Kj2v9bB/AlCunfzrwmdXqAIg4
         Mej0KEH0pinOfwJGOzYHS5tFfxdnFPQchC2uhzzBaANzkXA5ZF/2zY6zPgpj5XzyFdX0
         cc7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mTORVN+vb4ThEpVx7AxMit72NMXnsKSRAUOh1o/a8os=;
        b=J39kc1Q5o7d8d163WWQUSE5t8qA6olAiY1FdAhkIwgXtBYouiOdUaqXjllzye9+d9B
         9WMDnBXyA3JLXoBr9ZMCp/kKuyLUVEjugfarJA2hkxWYGTeHKrP0f7sFATuKLTxVrCg2
         rnQga1CboQ9zIC7MzzysXSQt7jbkwmt/mlmojQkQDn4Bbc6dNnW/2TalvP4WcUFpsipk
         oq5crBHe4Q1kkDlL89WSaLkwwwnEyXD759ZKu2CxRv1EGsNASs5g5Mii4+oEsHVZMv6o
         QpR3zyvgALxN/+NuuGrAQj25aMTiqjbADUzlYEQkxRh3pfjohixo1Asd5lXR/SnvOl8Y
         g/xw==
X-Gm-Message-State: ANoB5pkZKGvKEN9PatGCXp5FcAYd10cTLnDS96f4eRswWR59XYmy8daH
	M8KN3vHp6jKqCherstVIcGHZ7ymhM6J5wG6Yu1YglNNWXTwU9JHyUToAGpncesmsBVaBUaVgmMK
	uK33F8BSA+0lE8PHFbI+f8T+Q7jeZasKs07X+MXKCr1N0WU2AQH6rVwiCKa3FSq2NpJ/6+Zz8sV
	JrrOebBikBF6WFbZ7rreXXiBpJVuPaI15ztUQ=
X-Google-Smtp-Source: AA0mqf5LPJHOIlXR/n5HkFhpXmP9htXFS+/vEYllOxnCYgoAQzNsF/+mL8haFdY/qJv+WVKacahqx8L+Nyvl6l+bD2g=
X-Received: by 2002:a25:7757:0:b0:6dd:ff71:f26c with SMTP id
 s84-20020a257757000000b006ddff71f26cmr20724110ybc.120.1668592081122; Wed, 16
 Nov 2022 01:48:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221103053228.961591-1-r09922117@csie.ntu.edu.tw> <86fseppiqt.wl-maz@kernel.org>
In-Reply-To: <86fseppiqt.wl-maz@kernel.org>
From: =?UTF-8?B?56ug55GL6bqf?= <r09922117@csie.ntu.edu.tw>
Date: Wed, 16 Nov 2022 17:48:00 +0800
Message-ID: <CAM+=qvOKDeXcaxBUh9aAGbcQaLiiur=jui_EgwNzksopik_LzA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Update comment of create_hyp_mappings
To: Marc Zyngier <maz@kernel.org>
Cc: james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Sat, Nov 12, 2022 at 12:18 AM Marc Zyngier <maz@kernel.org> wrote:
> My problem with this comment is that neither va_mask, tag_val, nor
> tag_lsb mean anything in this context. All this is purely internal to
> kvm_compute_layout(), and is unnecessary here.
>
> I'd rather you have something along the lines of:
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 60ee3d9f01f8..6d04818a1a5b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -460,7 +460,7 @@ void kvm_unshare_hyp(void *from, void *to)
>   * @prot:      The protection to be applied to this range
>   *
>   * The same virtual address as the kernel virtual address is also used
> - * in Hyp-mode mapping (modulo HYP_PAGE_OFFSET) to the same underlying
> + * in Hyp-mode mapping (modulo a random offset) to the same underlying
>   * physical pages.
>   */
>  int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
>
> Whoever is interested in understanding the generation of the offset
> can follow kern_hyp_va().

Yes I agree, thanks for the advice.
I'll update the patch.

Wei-Lin Chang
