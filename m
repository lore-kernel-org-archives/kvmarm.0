Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B2A7E
	for <kvmarm@lists.linux.dev>; Wed, 23 Nov 2022 06:27:33 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id a1-20020a17090abe0100b00218a7df7789so1029091pjs.5
        for <kvmarm@lists.linux.dev>; Tue, 22 Nov 2022 22:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tit1GoRDHXxGIzZdw8RHtC91q2gw44B8zNxKS7z02AA=;
        b=fqnDNTMFJXL6XBTeO+kRQJFWvP7cvAJx1e8OAUaq01/iImdfKXDQth+CsyTAS02ErY
         gOASCuAizTdmqPf5oolegW2ktzaQxnmm8fsEurNaP3n2A5eGDsVdiCQk7omLcW2Fsf2S
         d6eM1CdGhpj3oVBsg76UpeggwkYA2ZpHdbx9ZOht42+LjzbynTlqPC1AJu+Ys1YbvfuN
         9DPIqYCqPnVcmaFMZmdhqecrwmSt0sebO8Q/c8q2Dl8+K61eAoRUDjFLkI32HrMvP5V+
         8/u19Bqkt8t5bZcwoRi9HlB3NbnkFH9T5nDQlYaRQUwJenxVBBuN2WUHHZ/QPb2FQGOV
         QB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tit1GoRDHXxGIzZdw8RHtC91q2gw44B8zNxKS7z02AA=;
        b=ovxNSihF2oIfcWKuS1XKLXNxsRyYfVpOIB+7n6IEzyyODIcRWfmZt4fQGxxHgM4aer
         42XTicK2F7BreH7Gl/x6gIElKWPBgKhOupdE690dUBCC4JAPNyJ529DnxAYg8XOhtAhD
         4IDwywDUVAxYn5z30glqAWIWQXAH8928PjsXYH5e34biV7RYzzK9z9TWtIJdghHu5+ot
         3IIQnvKhXasqNsXtmt7Ok5N4BxP7776VdvTwHioge5M994b3sF7sZdj3kQMdSIxA9TPl
         WJAgw6Dentje/JNGVISjpQ2fKLNHjP6KRFNScHuSZFJizQKKGpBLYUgakajbkMRWo5aV
         EW4Q==
X-Gm-Message-State: ANoB5pnWhR1sG4Iz2s1xt7qSzHdfPq/svJ2E3PCxm7F5IYQ6iiplSrbL
	HWnGNx3KeEJzdEVVTQsG0eReBTSDWfNoQBjDbmyu8A==
X-Google-Smtp-Source: AA0mqf5nlutVfDZV3mLPMpBH63zenw1aNZTS1OGEV25ZP+8iiz3jkhX4OVBoK3Ai4ysrDyk3GPfTAhlBrvQ5qYUgktI=
X-Received: by 2002:a17:902:9006:b0:172:d410:2a91 with SMTP id
 a6-20020a170902900600b00172d4102a91mr7622542plp.30.1669184853196; Tue, 22 Nov
 2022 22:27:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-16-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-16-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 22 Nov 2022 22:27:16 -0800
Message-ID: <CAAeT=Fz-zYX4qLt-RKvO6P0D5Si9vxxpsbALH1LPbON8efyEeg@mail.gmail.com>
Subject: Re: [PATCH v4 15/16] KVM: arm64: PMU: Simplify vcpu computation on
 perf overflow notification
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221123062716.LVodTF2ZMVVHegahJQsuCT01s1blqroSzQiz16EOjsg@z>

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The way we compute the target vcpu on getting an overflow is
> a bit odd, as we use the PMC array as an anchor for kvm_pmc_to_vcpu,
> while we could directly compute the correct address.
>
> Get rid of the intermediate step and directly compute the target
> vcpu.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
