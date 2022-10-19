Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365267E
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 15:46:43 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id t16so6645113edd.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 08:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9QpxLQA9XPUewEHX/45h//HdR2yIq/tEj/1YezYLDX0=;
        b=OWfE59Lm25mCNlUki8tYQIpUSzerqalC7O2lwMJbqbJNcMshIS0djoedpTUK3TZSk5
         vjtbeWT1tsd30RniseB4tzfWIOdzRkhXri/Wn8EkdKlObaRi32pCsC5okls3TNRRZ6AY
         D6TjFM3rivU1wrjwvfpg5wwk1aJoE0AR5fKN+FZsbFhQgBiGqBfZcPVGw3ATORhJPFKo
         KmTOY9vsP8q1F3KG1iaxKlnX086MmeaF/+96jCElljjEUU8MZ2Wn0thjnPKz/d3+Lytd
         SQkcVPoAXkb0N0WsnuXEtW7sar/4IfozdyR1MBF3TUR2WoXft7UPyzke5wzbYTuvrbtV
         cwaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9QpxLQA9XPUewEHX/45h//HdR2yIq/tEj/1YezYLDX0=;
        b=TN2Pr52NYYXRJ9rqPX6b77IMb5ZiL3sNPlOajv5lE0uuHnc+r/bbm89amXJyRLgSoM
         PsW2hktHKPGG5cu8LwZ1i0b6gOmF2OgqcjE/Stsw6a2PSN2ArKiCNh/8L1g0tTyHQoju
         0ETU3Puogs71Q/2MeFpMLFGZsRfnQRmcey+p+HP66DI57itFnI3u3vFdDrD7Z5VHoKH6
         wDXg6B1K+GzfJFLlvEmUjs3AD0hShincrjG08AUci6ETnfem7aQGdHW22+8vErtxImwg
         zb+BpgXVcRXbm8D2f6L/S8OKycHnhG+eK8Q5AbHodqhndL+HPD0n9+sdJ131F/vZqUX1
         5YJA==
X-Gm-Message-State: ACrzQf1gRG61ATWMGdGaVZNeU4lprAdwoFK20dl6qFB3WtgQbt7HyLJc
	MtUr4gUadr5rkS4zTQa7hgvK0Q==
X-Google-Smtp-Source: AMsMyM6AYcdOgw2iQ49E1qfbw3hHt9myuk+HR8W4QyF6ds15StyGev6O3Li7L6vCvN9o9x7j74tUgg==
X-Received: by 2002:a05:6402:2989:b0:44e:90d0:b9ff with SMTP id eq9-20020a056402298900b0044e90d0b9ffmr8039042edb.110.1666194401367;
        Wed, 19 Oct 2022 08:46:41 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id p5-20020a170906498500b0078b83968ad4sm9075070eju.24.2022.10.19.08.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 08:46:40 -0700 (PDT)
Date: Wed, 19 Oct 2022 15:46:37 +0000
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
Subject: Re: [PATCH v4 13/25] KVM: arm64: Instantiate pKVM hypervisor VM and
 vCPU structures from EL1
Message-ID: <Y1Ab3cxaVtqTBBo7@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-14-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-14-will@kernel.org>

On Monday 17 Oct 2022 at 12:51:57 (+0100), Will Deacon wrote:
> +struct kvm_protected_vm {
> +	pkvm_handle_t handle;
> +	struct mutex vm_lock;
> +
> +	struct {
> +		void *pgd;
> +		void *vm;
> +		void *vcpus[KVM_MAX_VCPUS];

That's memory that's 'wasted' for everyone :/

> +	} hyp_donations;
> +};
> +
>  struct kvm_arch {
>  	struct kvm_s2_mmu mmu;
>  
> @@ -170,10 +181,10 @@ struct kvm_arch {
>  	struct kvm_smccc_features smccc_feat;
>  
>  	/*
> -	 * For an untrusted host VM, 'pkvm_handle' is used to lookup
> +	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
>  	 * the associated pKVM instance in the hypervisor.
>  	 */
> -	pkvm_handle_t pkvm_handle;
> +	struct kvm_protected_vm pkvm;

Maybe make this a pointer that will be !NULL only when pKVM is enabled?

>  };
