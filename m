Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2FEAD42
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 22:40:27 +0000 (UTC)
Received: by mail-il1-f202.google.com with SMTP id h12-20020a92c08c000000b00316f82f1d98so2797444ile.7
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 14:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H7DW1E7YDz23DUtDKapMOgWWzaxvMLvR5mEfkeUQPGk=;
        b=Jhluh9+e5VRpjYu5+kcBiTA94nGVEILdRx7wwIvaiTJjLwaZFO2mOl/BrEnLr+dySN
         vUJMjDh79tOham1v5ryHa+M00dxh7b4tY1Xz/O+ncjzzyxKxLKyHJHua1HOXENJk7FaN
         +QXXyFuWQfJl7bafhkPoK/8Eom7tvtF05PwOTRpbnlIzgM6vJ1nqhtwoCcP2zhCXS47H
         Cc7EatoGy3sYeGUCierAqMzFWXu0KHeDUzFxyiIMcf6QwGK8aDBC9ZECLrDg9xsvVVQ/
         nKC9izGs4oVvgbaazrUnqT3uuX9GLMRs7vyWEQ8TID9KkhUIPVsjn/pTCAJYnB18IoNe
         8dPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H7DW1E7YDz23DUtDKapMOgWWzaxvMLvR5mEfkeUQPGk=;
        b=VsxB3VABPPfzVUoN2pXxlnC5riuKQBPLPFGk8+aeOuUJRIwbWrcEyfLui2rbfpdAxE
         JEveBMmLgclgIs6+niuUOIAy1aXS64fAwcbM9H9CHhWVbP8Dful10AUqNjMQDussA/9r
         I5YkxSsUoz/oSrqDS/DdjVePts1dD2H0RgPx5Ese4EUpZHWyMmEba2gTIiFXFrERVN3q
         cp83TEyHqaJy5sZTb7GNUB4X/enmjY1O2LqxjJjlj3f4cJGqhZf/3o4zW4ahCR2CbPRs
         otI2GAP2vWyuXgiD+dI+o2cefcDumsA70JnhQgt+54lWmIKT1Y06BAFa4+NA37cJ66Ha
         oXAQ==
X-Gm-Message-State: AO0yUKXn6Z1lltxENl7bV03JK5lSGRVZOcTR4fKiHONfRjUiVhT4ryB8
	7M7KlqdlCKcR8eq9hHDzJ5fqQImJDefveCgiaQ==
X-Google-Smtp-Source: AK7set9wg+5HcHPYkzP9dXHsc+T600jg65CBBFaIxpNQfWNqODZyyLry6GpHALNx1bvDDiS0OqkdfbWH0jUWpKBqUA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:ee1:b0:30e:e796:23c1 with
 SMTP id j1-20020a056e020ee100b0030ee79623c1mr3693592ilk.1.1677192026614; Thu,
 23 Feb 2023 14:40:26 -0800 (PST)
Date: Thu, 23 Feb 2023 22:40:25 +0000
In-Reply-To: <20230216142123.2638675-8-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:14 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnty1oo80py.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 07/16] KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes


Marc Zyngier <maz@kernel.org> writes:

> +/* If _pred is true, set bit in _set, otherwise set it in _clr */
> +#define assign_clear_set_bit(_pred, _bit, _clr, _set)			\
> +	do {								\
> +		if (_pred)						\
> +			(_set) |= (_bit);				\
> +		else							\
> +			(_clr) |= (_bit);				\
> +	} while (0)
> +

I don't think the do-while wrapper is necessary. Is there any reason
besides style guide conformance?

> +	/*
> +	 * We have two possibility to deal with a physical offset:
> +	 *
> +	 * - Either we have CNTPOFF (yay!) or the offset is 0:
> +	 *   we let the guest freely access the HW
> +	 *
> +	 * - or neither of these condition apply:
> +	 *   we trap accesses to the HW, but still use it
> +	 *   after correcting the physical offset
> +	 */
> +	if (!has_cntpoff() && timer_get_offset(map->direct_ptimer))
> +		tpt = tpc = true;

If there are only two possibilites, then two different booleans makes
things more complicated than it has to be.

> +	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
> +	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);

Might be good to name the 10 something like VHE_SHIFT so people know why
it is applied.

> +
> +
> +	timer_set_traps(vcpu, &map);
>   }

>   bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
> @@ -1293,27 +1363,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>   }

>   /*
> - * On VHE system, we only need to configure the EL2 timer trap register  
> once,
> - * not for every world switch.
> - * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
> - * and this makes those bits have no effect for the host kernel  
> execution.
> + * If we have CNTPOFF, permanently set ECV to enable it.
>    */
>   void kvm_timer_init_vhe(void)
>   {
> -	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
> -	u32 cnthctl_shift = 10;
> -	u64 val;
> -
> -	/*
> -	 * VHE systems allow the guest direct access to the EL1 physical
> -	 * timer/counter.
> -	 */
> -	val = read_sysreg(cnthctl_el2);
> -	val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
> -	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
>   	if (cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF))
> -		val |= CNTHCTL_ECV;
> -	write_sysreg(val, cnthctl_el2);
> +		sysreg_clear_set(cntkctl_el1, 0, CNTHCTL_ECV);
>   }

What is the reason for moving these register writes from initialization
to vcpu load time? This contradicts the comment that says this is only
needed once and not at every world switch. Seems like doing more work
for no reason.
