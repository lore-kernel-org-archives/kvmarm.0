Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DC7C43334
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 14:06:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AFDD4B2CD;
	Wed, 22 Jun 2022 10:06:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jcVYgkhP7MjK; Wed, 22 Jun 2022 10:06:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3191D4B2A6;
	Wed, 22 Jun 2022 10:06:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E8CD4B285
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 10:06:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yqAl6Y5BJ9AO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 10:06:34 -0400 (EDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com
 [209.85.218.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C4A549ED8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 10:06:34 -0400 (EDT)
Received: by mail-ej1-f42.google.com with SMTP id g25so34462210ejh.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 07:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=WxeHFPlfiSptfkzXY60BBTFs27kl7bS4qonpRA5K3SA=;
 b=T7qphS0ZRa134v/8ItGchQB9bogGth9+5pDqC2hUX7s6C0zH7zYuoVDdPuoEZvVhok
 sE8TcoXHH1m3cDpGrhMwP5aPbvry5T1tenDhgg6s+00ccl+qec9fmsQa3VSHCv85tuUV
 u7Zp9VqC5uvnf5aKFHSQONUqA2SWHhdZc0262grRx6E1iriI55QPfee4SZ9dxFO2hZZX
 NgDmhyM8bS8CvOev8gERKMIpNzrz0dTI+6GxQ7Ds972NKNw2Yia7OrPQkBu6LMBfQVBM
 HBwMWb4dD1DaGqEUDyoDX5Q6LBV8Ni+U5Uc+mtzdqRdJn+mz9XkbrYFYjC1ZQfs3CF/+
 2pYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=WxeHFPlfiSptfkzXY60BBTFs27kl7bS4qonpRA5K3SA=;
 b=P07pERHGgq0y2szqbrws6llErPGO0UwoTJA76xJM6Z3bbcwypXO+Dm7GQ56fbjUJNC
 btzjKWHDHP1H14KUXG2HjzQDjd50phMPXPQbeFPmfXEiYQIVd0yeDq4GSYqgTDACxM3E
 910wl9fQ8mxcJm4HD61uiWudtvmpkT9/i2xh4Xh9xxH5N/mFayH0olXHOts3PaQ4cTcf
 gp+F0b4+TRXA4RcQ9o9tpMinMa2toK2+UeoZbNzmjXzG9reJ2JahglPId1/4XvOVP52w
 AfsDx5ZlCLUGaIvlF6zJ5gd3dLh6Qp4QWc+JqaCz2u5sDw5Eky6KakntmdeeRz1bIowk
 2yvA==
X-Gm-Message-State: AJIora8EoqC1c+sp+bOVSmtWomaAPmDeW4yq4CkMb44+Va8poE1HALce
 8IwpQT7tWIdsbNiCgT+B8Xs=
X-Google-Smtp-Source: AGRyM1sD+9xzrrmv7BOEV1UN/1LyYHfkX2LTy6aXPGG/mcNyWY8NiWtb+z+dGzKS5l7haVgtNNE0zQ==
X-Received: by 2002:a17:906:9f26:b0:722:f998:7b2b with SMTP id
 fy38-20020a1709069f2600b00722f9987b2bmr1312998ejc.144.1655906793025; 
 Wed, 22 Jun 2022 07:06:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 eg40-20020a05640228a800b004356d82b129sm10908572edb.80.2022.06.22.07.06.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Jun 2022 07:06:32 -0700 (PDT)
Message-ID: <bb22c823-f12f-90d8-e8d6-0cddba95f60a@redhat.com>
Date: Wed, 22 Jun 2022 16:06:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 03/22] KVM: x86/mmu: Stop passing @direct to
 mmu_alloc_root()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-4-dmatlack@google.com> <Yqt6rBPMxfwAPjp1@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yqt6rBPMxfwAPjp1@google.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 6/16/22 20:47, Sean Christopherson wrote:
>> The argument @direct is vcpu->arch.mmu->root_role.direct, so just use
>> that.
> It's worth calling out that, unlike non-root page tables, it's impossible to have
> a direct root in an indirect MMU.  I.e. provide a hint as to why there's a need to
> pass @direct in the first place.
> 

I suppose there's *no* need to pass direct?  Also, there's the trivial 
(but less interesting) justification that kvm_mmu_load does

         if (vcpu->arch.mmu->root_role.direct)
                 r = mmu_alloc_direct_roots(vcpu);
         else
                 r = mmu_alloc_shadow_roots(vcpu);

and those are the only callers of mmu_alloc_root.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
