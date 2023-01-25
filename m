Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E936EC3
	for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 00:47:04 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id z31so9308193pfw.4
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 16:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ghxIETXzFs7vJZ8k07wa7GlexKAzC+rzARYUkXCHQHs=;
        b=LvjZfwXCe3mA6H4AGCqGyzVKFBo5GWM8FdhLXaayHykpzPCuRAjaElAT5Hk2ey/F40
         Bh0dvjNSUfqTGb2iuj7q1O/PTP7W4gatjaXfhcEVTR9wjA0tLBMoJ0VwCZFubj/cVP55
         Ivatyfw6YQ7PGbADo/BVU9RK987h/uMS90RV4WjpCsfklzdPKAdTHudb41fHEoV/AC4t
         QA+JdfzzdjDGfYBlxMFkykCYVfgF1+Lcr4tMwizCyX8BReSbwOSOFa9HKtzdOfc+/Z4x
         VkMk2QpFyvQFvDavS06hVgLrLbNgjoiC6/78xM6uAk2D8AhY1zohmPXNMphYinnluuYY
         oCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghxIETXzFs7vJZ8k07wa7GlexKAzC+rzARYUkXCHQHs=;
        b=7q9PpQ/I/cUSV68nntdaowVDEG14PkHYaJH1DXSfcsmYXnru/qNuCYJd4akGK3f0Q2
         yRwsDbYNKlr7VPuN+qjWmTgTDhfA6r71jV4AImGPau/aQBcjaxmL5luVIuDFzxBMj5Zt
         f3K6vAOjzYZrtwLzlKsryyR1jp0DvcTMipi2np7pRVHxJO/7noBgKO4gHaPvVb7U3hrM
         zEMych4A6Wj4JHV8r/vAugszyr3LQlFwI7MEvlwCW3CRUyGPU3737P2sB7G74mQ6gGl1
         yTxhS1jOeruZK5mJxDNj6gAQPgN6/ARHmBdU/1N3VZHb1IA4Con1Rbuh2cnGRMS5LTfm
         oc5A==
X-Gm-Message-State: AO0yUKXr3YgXfVlVOjI06dSEjvu2QSUcFqI9qMvra+PPEj3XDDvklMY1
	N9Dou4VNuG7YNRozU4/nLoMhkA==
X-Google-Smtp-Source: AK7set9F5NYwCkfGKD1bo/mJyqFfAsir2nkFX4eO7dXf2tZvBxGZyFTFZ2Lda5ZK6A3xZU2rNxPYBg==
X-Received: by 2002:a62:7988:0:b0:58b:cb1b:978f with SMTP id u130-20020a627988000000b0058bcb1b978fmr382182pfc.1.1674607623688;
        Tue, 24 Jan 2023 16:47:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z6-20020aa791c6000000b005884d68d54fsm2242952pfa.1.2023.01.24.16.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 16:47:03 -0800 (PST)
Date: Wed, 25 Jan 2023 00:46:59 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH 0/7] KVM: Add a common API for range-based TLB
 invalidation
Message-ID: <Y9B8A+/FSPCrAANT@google.com>
References: <20230119173559.2517103-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119173559.2517103-1-dmatlack@google.com>

On Thu, Jan 19, 2023, David Matlack wrote:
> This series introduces a common API for performing range-based TLB
> invalidation. This is then used to supplant
> kvm_arch_flush_remote_tlbs_memslot() and pave the way for two other
> patch series:
> 
> 1. https://lore.kernel.org/kvm/20230109215347.3119271-1-rananta@google.com/
> 
>   Adds ARM support for range-based TLB invalidation and needs a
>   mechanism to invoke it from common code. This series provides such a
>   mechanism via kvm_arch_flush_remote_tlbs_range().
> 
> 2. https://lore.kernel.org/kvm/20221208193857.4090582-1-dmatlack@google.com/
> 
>   Refactors the TDP MMU into common code, which requires an API for
>   range-based TLB invaliation.
> 
> This series is based on patches 29-33 from (2.), but I made some further
> cleanups after looking at it a second time.
> 
> Tested on x86_64 and ARM64 using KVM selftests.

Did a quick read through, didn't see anything I disagree with.

Is there any urgency to getting this merged?  If not, due to the dependencies
with x86 stuff queued for 6.3, and because of the cross-architecture changes, it
might be easiest to plan on landing this in 6.4.  That would allow Paolo to create
an immutable topic branch fairly early on.
