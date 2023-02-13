Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DED68F5F
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 15:36:57 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id w5so13848778plg.8
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 07:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b6CbHZgVu581b1kpbiWv3nRa+aQ1/ZXT+MQVUlqtRFg=;
        b=pEH4a2cNcp+iU0rZP+xPv6deo4b/2AIkO0DLOBo0ZLFyrYsyMt4C3A1kCYsiwS+YQE
         62VVo10wQW9iH02plX08czAlafCzRsNyRdBI+2kZSoa9AxYrWF9tURFi019LNtyBNByw
         0orb8j6cueSHwxygMEDtVZVnzh91IEdRKbv22kmtywCxuJ83EdUV7ghG2gA8QFgQ7gDs
         tcLnKRAA5Cq5cZ11IcmhZ04iEw5Vqp6Y3mJQSRc1zEt62CbLAdNzT09W0VapHLBwtIE6
         SFcVuFmm0JoLrifqo/tuwbRawC9RbRg2HIGIOz7iMLZ4RUEG/gz/qLdoMZpH+Mbm1YEN
         bgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6CbHZgVu581b1kpbiWv3nRa+aQ1/ZXT+MQVUlqtRFg=;
        b=0HmT+dge2AYzSphSxs6P/Qn56307G5hNJOgx1Bth1Q8jjGV81tVrKK4A4R8qwY44ax
         q8j5CrS04AwYV517oCb18baWXeAZTREtFSr8duHfT5JnZQiNL0+/JNXInw7GMGGW3DhZ
         dbatBQ/ARny2l96ixW96AFC/w2r9AoG+Jvg0BRxgGxyF7iu0NBchMCZfzOfCgRXoDMFY
         stpA0Hxp0mDsyIrVelh+n1RhmqOB1Lsparh+FwoISwXUKrvCI+RxzcT06cMHqf5xmqIg
         VUU7A59Of6vtq6fYsXuTh8QehV/bm1xXr9UCBr5nEQ27Hb8zmnzwPu11fPZhdX2z/7TA
         ag4w==
X-Gm-Message-State: AO0yUKVpB6O4+EuceNUtuNT5kp3xmO7bxFZGipTM+Z3oKaJk9E7i/6r2
	si+BEWd7KRu0m4nl2f3UISh54Q==
X-Google-Smtp-Source: AK7set8dKx5P9Hgy5FMcBhM5YT9HLmTmVXFXC6zApAbnhBc+IHN95yI1sjydVL/fWr6sZFUiQqTBGQ==
X-Received: by 2002:a17:903:4094:b0:198:af50:e4e3 with SMTP id z20-20020a170903409400b00198af50e4e3mr421077plc.9.1676302616875;
        Mon, 13 Feb 2023 07:36:56 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902784900b00198f9fa23a3sm8301318pln.287.2023.02.13.07.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 07:36:56 -0800 (PST)
Date: Mon, 13 Feb 2023 15:36:52 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [RFC PATCH v2 1/6] KVM: arm64: Add a helper to check if a VM has
 ran once
Message-ID: <Y+pZFOmOSrH+G2Rf@google.com>
References: <20230211013759.3556016-1-oliver.upton@linux.dev>
 <20230211013759.3556016-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211013759.3556016-2-oliver.upton@linux.dev>

On Sat, Feb 11, 2023, Oliver Upton wrote:
> The test_bit(...) pattern is quite a lot of keystrokes. Replace
> existing callsites with a helper.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_host.h | 3 +++
>  arch/arm64/kvm/pmu-emul.c         | 4 ++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 35a159d131b5..012e94bc9e4a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1019,6 +1019,9 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  	(system_supports_32bit_el0() &&				\
>  	 !static_branch_unlikely(&arm64_mismatched_32bit_el0))
>  
> +#define kvm_vm_has_ran_once(kvm)					\

From the peanut gallery...

The ONCE part of the flag+API is unnecessary and flawed from a pendatic point of
view, e.g. if a VM has ran twice...

What about kvm_vm_has_run() to align with a similar proposed x86 API for individual
vCPUs[*], if either one ever gets moved to common code?

[*] https://lore.kernel.org/all/20230210003148.2646712-3-seanjc@google.com
