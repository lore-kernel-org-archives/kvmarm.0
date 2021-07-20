Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A604C07E95
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 11:13:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C59F611F2
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 11:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C59F611F2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9EAA4A193;
	Tue, 20 Jul 2021 07:13:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qr2u8cd-CX7b; Tue, 20 Jul 2021 07:13:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A4E4B0C0;
	Tue, 20 Jul 2021 07:13:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 188BF4A193
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:13:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JgvgvyCaWrXe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 07:13:25 -0400 (EDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC69C40808
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:13:24 -0400 (EDT)
Received: by mail-wr1-f50.google.com with SMTP id d12so25525610wre.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 04:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rssW9MvuSrY18dvpw7amkf+MYjvhgV8BCmj8r2D+edQ=;
 b=K7vq3dVJv9e19grP2qCy6RAOZY+bX+Abe2GwleQgCAThD/Ktphh7T6Hk8e+U7dOn5Q
 ymRWUaww5B0nvzeT//Q1p6BowVr0oYbwsyreIyOlK5N8DlZfrIu1zZ9o2opKWlKnBrnk
 LUCsiCUbO1X92FsH9QqgOFn2KjjXTQLsmYrpMUzxGFAZ/jOUz4jDfZzKO9QRDCm+1dEQ
 GVPLQBeAySBxe19MQruR5u16/OFBNBl8de3UVr0Z42Ef1FQxlvPify25KeQg4iRdsigB
 Lo4yVb2io4tvTVln2XGFG39wJoQ/PpjT9OhOUm+uJojX6OCXNmOmMF/3IjDmn6neevRp
 om0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rssW9MvuSrY18dvpw7amkf+MYjvhgV8BCmj8r2D+edQ=;
 b=ePGbOl4En0rFnvbrZ2gsvKZhEUVggCXWOnFTtYMi2HP6gYnloeaPqWLvkM18ECLVQV
 9y51fG/SC9i6OAN+SF8RoAeCfcezh0gPgBsw8HdLPjDaKymh5E4IrOoQ8sePHd6/TXze
 ebaOC3HUPTaeAfoP2IutSKaQaOZzpLmDbT8qClPnyjMrErk8TD4V+eE1vFfw+E9G9iLe
 ULVLCNJNakR2FJAWA+jbDhRtrJyGv9970yXXEzY4cgoX04S96tQLj1Uy6U4XaHG9ci1Z
 TmIWtpo6l9uPw5nfyhrBgdvpSutmhTtMp5jYycJjI+euZpTKJcJrAdJTYCphI4YNZ1l9
 Aclw==
X-Gm-Message-State: AOAM532oXpxqUVrf2fzlXbQJuXWymgSpddscDb61ohP6Ng4ODRb1xfZW
 4RChqVabnJQ4+ZOc2B+cBuEwlw==
X-Google-Smtp-Source: ABdhPJxucLoq3tJ6ywks6cNiyi6pYtOe5W3MkGbCfwenZlNTGXHtenBEwmkjoTj+HN+TgHpbImyIYQ==
X-Received: by 2002:adf:f74f:: with SMTP id z15mr35360657wrp.54.1626779603785; 
 Tue, 20 Jul 2021 04:13:23 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
 by smtp.gmail.com with ESMTPSA id y3sm23651964wrh.16.2021.07.20.04.13.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 04:13:23 -0700 (PDT)
Date: Tue, 20 Jul 2021 12:13:20 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <YPav0Hye5Dat/yoL@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-5-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thursday 15 Jul 2021 at 17:31:47 (+0100), Marc Zyngier wrote:
> +struct s2_walk_data {
> +	kvm_pte_t	pteval;
> +	u32		level;
> +};
> +
> +static int s2_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +		     enum kvm_pgtable_walk_flags flag, void * const arg)
> +{
> +	struct s2_walk_data *data = arg;
> +
> +	data->level = level;
> +	data->pteval = *ptep;
> +	return 0;
> +}
> +
> +/* Assumes mmu_lock taken */
> +static bool __check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	struct s2_walk_data data;
> +	struct kvm_pgtable_walker walker = {
> +		.cb             = s2_walker,
> +		.flags          = KVM_PGTABLE_WALK_LEAF,
> +		.arg            = &data,
> +	};
> +
> +	kvm_pgtable_walk(vcpu->arch.hw_mmu->pgt, ALIGN_DOWN(ipa, PAGE_SIZE),
> +			 PAGE_SIZE, &walker);
> +
> +	/* Must be a PAGE_SIZE mapping with our annotation */
> +	return (BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(data.level)) == PAGE_SIZE &&
> +		data.pteval == MMIO_NOTE);

Nit: you could do this check in the walker directly and check the return
value of kvm_pgtable_walk() instead. That would allow to get rid of
struct s2_walk_data.

Also, though the compiler might be able to optimize, maybe simplify the
level check to level == (KVM_PGTABLE_MAX_LEVELS - 1)?

Thanks,
Quentin

> +}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
