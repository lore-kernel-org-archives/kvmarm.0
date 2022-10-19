Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFB87E
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 15:52:15 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id q19so25902326edd.10
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 08:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D+geK99fBWdp7S2zDM4C3VUidei1SsKnOz1jjdUkhRw=;
        b=dEWV1sDV4kXLHev/Hf0F6/5EgNkXk+jSP5MubJFT1mtMEzrd0Su4L67vw2Cu3FelbA
         7JmGBptdA8n2GhuqqwsT+tOLg5EgVgcAOGWmObLcsrHzKtFDkcKCWl/FITqP53I2kx78
         V8/ZR1YpLgWj+N1ehWQQxqhOAZm4k9knX4TyFTeq3qO52XO5fnUjnaWt1U4TmMijI0uW
         sumVPG5JW5pMYkXeZvOWn7acri4szVe4PDz+ky/QjGRxpy4p+lgLcQcsPtFoI0urf1KU
         OMsJt0D9Cy0S4J+l0z/P3cNydADbJIVuFRhvlzvuFVEwFkZ9stQrrOent6f6qfFNAIfF
         jsPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+geK99fBWdp7S2zDM4C3VUidei1SsKnOz1jjdUkhRw=;
        b=CiFYalXnLdsZXdoJ+JugDHh5t2lVB9SBIi7N+rCS8AhZsO7OcNNbjbd//aYVAaxI4X
         6rjxGQBdkpS+LN+lBv8l82iCzhQdtXc6g65GXbQwLXG+5G19LOdED8Du1Bmgpfbj0giv
         Jqyw79tWcRR6yVe28maGuBpHfnzQGR3GxjSnUA76JmRO6NiRVGVkznnEwNjcueCsZkUM
         JHIQrdlXjy8f+ZDRUQWJWR8bhORSwe7A3d6J4pAcm2+TsWwDmvfc/dEkxax56XjWBiaZ
         BlpMVFfg5ol0yHYG0XvkExoOz9BAwHKLXs/yJImaY6z1o5RaIGPLc2Gjzt1SiBvYGFf0
         V5Jw==
X-Gm-Message-State: ACrzQf1TrUVuCkibutSaaBh9L4VM7w+r6CYwuuhTl4as2WJhpyisG8/x
	uiUz6oDun/kXZvB30dNLqJgKzw==
X-Google-Smtp-Source: AMsMyM5mBhT44kMTTWFESMD5g2Ta35xFYhiWJ7bOcxwEInRQ0foBv9qN42gqGXbQVduas/FNl/oLJA==
X-Received: by 2002:a05:6402:c7:b0:457:cd5d:d777 with SMTP id i7-20020a05640200c700b00457cd5dd777mr7922898edu.245.1666194733534;
        Wed, 19 Oct 2022 08:52:13 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id v2-20020a1709067d8200b007815c3e95f6sm9274435ejo.146.2022.10.19.08.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 08:52:13 -0700 (PDT)
Date: Wed, 19 Oct 2022 15:52:10 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 20/25] KVM: arm64: Return guest memory from EL2 via
 dedicated teardown memcache
Message-ID: <Y1AdKgqANCzlv/7Q@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-21-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-21-will@kernel.org>

On Monday 17 Oct 2022 at 12:52:04 (+0100), Will Deacon wrote:
>  struct kvm_protected_vm {
>  	pkvm_handle_t handle;
>  	struct mutex vm_lock;
> -
> -	struct {
> -		void *pgd;
> -		void *vm;
> -		void *vcpus[KVM_MAX_VCPUS];
> -	} hyp_donations;
> +	struct kvm_hyp_memcache teardown_mc;
>  };

Argh, I guess that somewhat invalidates my previous comment. Oh well :-)
