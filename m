Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B012F2A
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 17:34:55 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-536bbaeceeaso138936017b3.11
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 09:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4HvtD+IMg3vyDXGpZcS0GeFnM8gx7HgAcp0Q62lmtW4=;
        b=fvEBJKNTVgASaDjc9Q0VXXTAIHEeqbLAf/33eHK5qtIch5pppRvvtww/N2ViF2gpdq
         VCAiByWM0l/uNFtxN6iV9hK9EY1uZL/NFtqzu8+sHL4tj8XGIV3zT+VWHXk8cqOcs76m
         313IP1Iu0V/gvoPT+akxf2tRfrtOogk7Aohae/b/Aowp4hWjO+AiMIwooblfNsZUhyiu
         U4MrCMNErtTs5EP+Mg3bg1pBjkaTPY96RUHhEDGrAVECxaGcvdLPa0vW0CY9T5AOps78
         5vvq/sVqQVqjMo9ETUdGV8sO5IdO/RVjAtFU/I637xYFOPP6pd7vWPL3FWBwSWirJEqB
         rtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4HvtD+IMg3vyDXGpZcS0GeFnM8gx7HgAcp0Q62lmtW4=;
        b=XXjJlSZi49NKIsL+5/Ivqg7gOwjoSQJ8ijNoHSxn+A2NXKCUsZU0G785xyPDLoxzz4
         nUZ6669xFfnld4ra+5NWJh6LDWk/ERMBfTbZ/Anfl1R9g4nYFpwH+G5V4WQOkGJTXfcF
         ztmR8RYA7Lz/ZHKcAXvD0xA8gOczqq88z6npRwWtATvfunU4dCx5eoiEIGoC3AQVE6sy
         BHeWvEs352pQZhRbq5b2LBCXLGmKY7rc4Dcg9OpZH0LniccVsMJEPeT2L9PcqOEKtd+6
         NDfbB0rNjxOD3d6XKu9I2Q0hDv+vv1tGnrK/rkbB5h0FSyDBqCAv+c74Jz8f25o2FZua
         MXqA==
X-Gm-Message-State: AO0yUKVL5gZ7OdWBkmX5F9xIluwFeTyhPOSbTHRS8fCtFSBJZqckpzxk
	tRvKXzlmBy4Sg9C/lygFIsT7MffkAkg=
X-Google-Smtp-Source: AK7set9qM18OCmCtNF4MtwIz5dX/Eaw8z+NF94C05s0wfxF7vpTFz86wUpljUQl+IzVT57C5nxDYcFR2baU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:524e:0:b0:534:7482:b73 with SMTP id
 g75-20020a81524e000000b0053474820b73mr788300ywb.153.1677173694654; Thu, 23
 Feb 2023 09:34:54 -0800 (PST)
Date: Thu, 23 Feb 2023 09:34:52 -0800
In-Reply-To: <20230217041230.2417228-2-yuzhao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-2-yuzhao@google.com>
Message-ID: <Y/ejvISuDQyOvrG8@google.com>
Subject: Re: [PATCH mm-unstable v1 1/5] mm/kvm: add mmu_notifier_test_clear_young()
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-mm@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 16, 2023, Yu Zhao wrote:
> +static bool kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn, struct mm_struct *mm,
> +					      unsigned long start, unsigned long end,
> +					      unsigned long *bitmap)
> +{
> +	if (kvm_arch_has_test_clear_young())
> +		return kvm_test_clear_young(mmu_notifier_to_kvm(mn), start, end, bitmap);
> +
> +	return false;
> +}
> +
>  static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
>  				       struct mm_struct *mm,
>  				       unsigned long address)
> @@ -903,6 +960,7 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
>  	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,
>  	.clear_young		= kvm_mmu_notifier_clear_young,
>  	.test_young		= kvm_mmu_notifier_test_young,
> +	.test_clear_young	= kvm_mmu_notifier_test_clear_young,

I am strongly opposed to adding yet another "young" mmu_notifier hook for this.
I would much rather we extend (and rename) mmu_notifier_clear_young() to take the
bitmap as an optional parameter, and then have KVM hide the details of whether or
not it supports lockless processing of the range/bitmap.

I also think for KVM x86 in particular, this series should first convert to a
lockless walk for aging ranges, and then add the batching.  It might also make
sense to land x86 first and then follow-up with ARM and PPC.  I haven't looked at
the ARM or PPC patches in too much depth, but on the x86 side of things KVM already
has the pieces in place to support a fully lockless walk, i.e. the x86 specific
changes aren't all that contentious, the only thing we need to figure out is what
to do about nested VMs.
