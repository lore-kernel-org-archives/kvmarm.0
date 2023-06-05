Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAB210FB
	for <kvmarm@lists.linux.dev>; Mon,  5 Jun 2023 14:36:06 +0000 (UTC)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5147f32df82so688591a12.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Jun 2023 07:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685975764; x=1688567764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/nEIx2pKx8MANmuUD53PuQCkyn4NP8umHBPTpshdhtE=;
        b=X4pOGtiEGzl58GIFHbyV096t93IrJzELqcypLc4QMyHeBwAan/aALSMopAZ+lqPIs/
         PZNtR1f+KboWQSY8gUKV8bP6VLPOPyLj9X+PcDBik6Rb1GkoW1dQzGRxs/VB+cefUAHk
         oqOoq9ZzN1ix9J54M/O922WWDlAgpQE5AKeuQY1UWV5aftGRdFXROUT/wO25J2bq7tvJ
         ntDFTIewi2nWrpz4P99jP9etHFIKzZEQQ2s93Ttnro2HDYWUBGQU+f9mpHNbRQ5IlJbB
         1OEzF7yvggyK3Clsj7G1B3wcFoRHXo6xJ+JId++mQ9eGPjlFHkVYB7SLL19lfxy+iJ6r
         HQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685975764; x=1688567764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/nEIx2pKx8MANmuUD53PuQCkyn4NP8umHBPTpshdhtE=;
        b=XAceIgxRh8PzEd8kAKGctmQYD+jLERUlQgtYzlbuyLTJfIbtsXqVkRIA8xIF3GO+LB
         pOIwI8X8je7JA4U5KmWHlsqr79aI6SUChhQnCD1IHRMppOq7BJMiEPbVgu7U1b3AOCzw
         YWj+DkSwH6WHxlTV4idJiW6Ip8tgstLROOF/GcK07Dv4aNogk7yX1rcsCuiNwYHw6H0p
         Fufl3coUgZHQpTGRNkuLth/TSgNIhuywB8kFXm9GBRW6+HE8VY6CdiGpymabbUKltjDV
         K39RuhDu22Y3Tzeeq+bpmXURtiKlBzw0ZnEcFk+x4HkmnANjgIx6Vt0fP/D8XjNDkvsw
         ctnw==
X-Gm-Message-State: AC+VfDyQXAeXwoy0uSX8HOj4RpdeKWo8TWGeGuL8IgjKY2Yp4SkGVHm8
	5hcdpOqb8wdNhFLNteV9h8M=
X-Google-Smtp-Source: ACHHUZ64cK7Y08p9XC1fThPd/qyz85iOAi9xrRj76BmDStiQbKH5iM+XYS3Sd25RTQiQg9fupo3QbA==
X-Received: by 2002:a17:906:7a17:b0:974:56cb:9dfc with SMTP id d23-20020a1709067a1700b0097456cb9dfcmr9788715ejo.1.1685975764343;
        Mon, 05 Jun 2023 07:36:04 -0700 (PDT)
Received: from localhost ([134.191.220.83])
        by smtp.gmail.com with ESMTPSA id i21-20020a170906851500b00965e9a23f2bsm4364473ejx.134.2023.06.05.07.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:36:04 -0700 (PDT)
Date: Mon, 5 Jun 2023 22:35:20 +0800
From: Zhi Wang <zhi.wang.linux@gmail.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
 tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
 ricarkol@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/16] KVM: arm64: Document the page table walker
 actions based on the callback's return value
Message-ID: <20230605223520.00007fbd.zhi.wang.linux@gmail.com>
In-Reply-To: <20230602160914.4011728-10-vipinsh@google.com>
References: <20230602160914.4011728-1-vipinsh@google.com>
	<20230602160914.4011728-10-vipinsh@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  2 Jun 2023 09:09:07 -0700
Vipin Sharma <vipinsh@google.com> wrote:

> Document what the page table walker do when walker callback function returns
> a value.
> 
> Current documentation is not correct as negative error of -EAGAIN on a
> non-shared page table walker doesn't terminate the walker and continues
> to the next step.
> 
> There might be a better place to keep this information, for now this
> documentation will work as a reference guide until a better way is
> found.
>

After reading the whole patch series, I was thinking it might be a good
time to improve the way how the visitor function and page table walker
talk to each other. The error code is good enough before, but its meaning
seems limited and vague when the visitor function wants to express more about
what exactly happens inside. I am not sure if it is a good idea to continue
that way: 1. found a new situation. 2. choosing a error code for visitor
function. 3. walker translates the error code into the situation to
handle. 4. document the error code and its actual meaning.

Eventually I am afraid that we are going to abuse the error code.

What about introducing a set of flags for the visitor function to express
what happened and simplify the existing error code?

> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 8ef7e8f3f054..957bc20dab00 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -711,8 +711,19 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   * after invoking the walker callback, allowing the walker to descend into
>   * a newly installed table.
>   *
> - * Returning a negative error code from the walker callback function will
> - * terminate the walk immediately with the same error code.
> + * Depending on the return value from the walker callback function, the page
> + * table walk will continue or exit the walk. This is also dependent on the
> + * type of the walker, i.e. shared walker (vCPU fault handlers) or non-shared
> + * walker.
> + *
> + * Walker Type  | Callback         | Walker action
> + * -------------|------------------|--------------
> + * Non-Shared   | 0                | Continue
> + * Non-Shared   | -EAGAIN          | Continue
> + * Non-Shared   | Any other        | Exit
> + * -------------|------------------|--------------
> + * Shared       | 0                | Continue
> + * Shared       | Any other        | Exit
>   *
>   * Return: 0 on success, negative error code on failure.
>   */

