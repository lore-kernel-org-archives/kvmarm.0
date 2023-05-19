Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFC6125D5
	for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684518121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IPvHfXA4AeF8oU0t2aOUngrckD2YwBip/YH9aUYlKr0=;
	b=DKSzM0n+RFua+Pg8LKSkOEItXvQNnFQ6YiP/r7BO5wPX8HjFNRvdarNkhoY+yfGlXq6Y+K
	ojfDnk/YK97qRXCokBmJKmJl+wH/Sci5X4g+TT4OZOVQPrpR2Uq29JxB7dolDX2U4psXEB
	P/f+abFtt7Jsu8vPAHfCietRdGo2L8E=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-G7iiKUoTPWy76jHNmgpFcA-1; Fri, 19 May 2023 13:42:00 -0400
X-MC-Unique: G7iiKUoTPWy76jHNmgpFcA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-96f4f1bb838so170008666b.3
        for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 10:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684518119; x=1687110119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IPvHfXA4AeF8oU0t2aOUngrckD2YwBip/YH9aUYlKr0=;
        b=XPE0BVnljxrlkvhhu2k2g4TqDBQvdHmIZD8Cc1kbSWayd/0d2UkA67Uhu+K6pBFmk4
         93SfgJuKUYNg6ta28Fp8VjVyDvSs93XsJ9ZROz2L4F3g8hEU9ADiybTq/LhdOVOCU5kb
         JxFIo5nJ3tkyh/je5n4r9i/mkkJkd3aTEv2hJTJzIK5QkhsK6CCCaZz9nIds3a/BfF9S
         7GjCd4rir1ImclF8wtjocke35GPYSKLJeRWzoogV4Vuye9inyQJTnwmi+ycZ8R3dYhh7
         sbM+cV9Z/qmZ/zYORqzum5711o+iRmpRYt2eHDVDwLlfPdLbvotLJhV5JhBbBhB6rcEq
         QsVg==
X-Gm-Message-State: AC+VfDzvdElxYqJOfKQNcTK4u31gAoGicHKnlJR12G+vlYcA0DXfnoOr
	C5HXU30P0tKgqgy6s4BifA6NgulqRdfzzKTMC0ULMydrY27wB/fbWNvR7jEOryn/84BJKbm5y2T
	Sl6Hg47NIaYK/SE8e
X-Received: by 2002:a17:907:7f26:b0:966:4e84:d82d with SMTP id qf38-20020a1709077f2600b009664e84d82dmr2635898ejc.3.1684518119338;
        Fri, 19 May 2023 10:41:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4OyOatoK1f1B3VZIVP533ki2ItaPx3mIwrd17+o/dg6ejlgF+lc7kz4qMM3KmEXtzZ1sXGew==
X-Received: by 2002:a17:907:7f26:b0:966:4e84:d82d with SMTP id qf38-20020a1709077f2600b009664e84d82dmr2635866ejc.3.1684518119017;
        Fri, 19 May 2023 10:41:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id p16-20020a170906a01000b00965e68b8df5sm2530428ejy.76.2023.05.19.10.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 10:41:58 -0700 (PDT)
Message-ID: <c4d8e54e-28da-f788-5569-e5274b19c34e@redhat.com>
Date: Fri, 19 May 2023 19:41:57 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 0/2] KVM: Fix race between reboot and hardware enabling
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 kvmarm@lists.linux.dev, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 kvm-riscv@lists.infradead.org
References: <20230512233127.804012-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230512233127.804012-1-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/23 01:31, Sean Christopherson wrote:
> Fix a bug where enabling hardware virtualization can race with a forced
> reboot, e.g. `reboot -f`, and result in virt hardware being enabled when
> the reboot is attempted, and thus hanging the reboot.
> 
> Found by inspection, confirmed by hacking the reboot flow to wait until
> KVM loads (the problematic window is ridiculously small).
> 
> Fully tested only on x86, compile tested on other architectures.
> 
> v2:
>   - Rename KVM's callback to kvm_shutdown() to match the hook. [Marc]
>   - Don't add a spurious newline. [Marc]
> 
> v1: https://lore.kernel.org/all/20230310221414.811690-1-seanjc@google.com
> 
> Sean Christopherson (2):
>    KVM: Use syscore_ops instead of reboot_notifier to hook
>      restart/shutdown
>    KVM: Don't enable hardware after a restart/shutdown is initiated
> 
>   virt/kvm/kvm_main.c | 43 +++++++++++++++++++++++++++----------------
>   1 file changed, 27 insertions(+), 16 deletions(-)
> 
> 
> base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac

Queued, thanks.

Paolo

