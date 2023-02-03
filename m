Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6795B1FB9
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 10:22:05 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id bx22so1666466pjb.3
        for <kvmarm@lists.linux.dev>; Fri, 03 Feb 2023 02:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BC26glmyLYvqdRj/s/s6MK4qi5hy8JZOEYo3ZDI0Vnw=;
        b=iGcWrv4W143DbiJRKR8Be2u+UuFLvv+TMD04aaKkE8FyPZW/j/42Togzc26Of4xCHk
         L4O+J9J3KGooZvCPheaHtCVvhd+8yD7F+6cwfgRaYM7XlcjMHxjcBj+d00IuGOnZoxua
         p47HghzIR0V5V9BHB1MOTBO58vuNmWhvqwqTKzCWyKZoGTbMh0eeUZEg1LCG1i8w6yr+
         rGoonbhjlDDP0EM8BSTnSmM8hJ6sGKjQQ8ZQlho2AVRiZ9i9GSJGVG8WpNzZ88bsOJib
         p3nxwmBfaPRdS2D7OrOB+MkhuKe20M4wZIzbxooQQ7YLHch4yOj2EJIoaSWTjBZnOEHA
         LYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BC26glmyLYvqdRj/s/s6MK4qi5hy8JZOEYo3ZDI0Vnw=;
        b=wxI2OIzqXaJVobVo2R5JF+ZY4aUkTQqcc/xTZZEj4Njucqu6q1Ks7dpUMPbADjjeup
         hdWXj/V9mpHxa6Yzth4W8l8pcPMyzAGPgnIa3w0XAUyJBxJGnrIIKRqbcJGQgXET/Mdb
         8xxl+3GtF7mApgDhqzXolJizRwhrAVXu1ON1w84tsXPutqQPKlMllTgU7zaAUMC01Y4R
         4uGoGD7MnbBnMQC8ebGLudn4bzAgWFh+98wfvmW/RbedN2vpExMQs3Shpm1vPS3+kso3
         5K25HBjiXVjLkSuXnCQWjlJ8kKwg+m3T+Zc/R/zgE/E+WNfUk9RfVoS5zXUzxXmUYmTO
         1ksg==
X-Gm-Message-State: AO0yUKXgGkJWqxzSp+8K6Ifl9zcNk7CiXkO3NYCCFJgmB0bWjjPX+55r
	cUQoC4kaYIatsoO9kPEQ6fM=
X-Google-Smtp-Source: AK7set+WpN/kIwzQ9KpDMGx5dpl4PBMS/21AHFGf650c2cUKaoV8+4j20Irc5p0mFaig/53VJ2J67w==
X-Received: by 2002:a05:6a20:a002:b0:bb:aabe:7a56 with SMTP id p2-20020a056a20a00200b000bbaabe7a56mr12482709pzj.58.1675419724901;
        Fri, 03 Feb 2023 02:22:04 -0800 (PST)
Received: from localhost (193-116-117-77.tpgi.com.au. [193.116.117.77])
        by smtp.gmail.com with ESMTPSA id l6-20020a639846000000b004768b74f208sm1233813pgo.4.2023.02.03.02.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:22:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Feb 2023 20:21:55 +1000
Message-Id: <CQ8UPZX0BERP.2TFM4914IGJZF@bobo>
Cc: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, "Janosch Frank"
 <frankja@linux.ibm.com>, "Suzuki K Poulose" <suzuki.poulose@arm.com>, "Marc
 Zyngier" <maz@kernel.org>, "David Hildenbrand" <david@redhat.com>,
 <linux-kernel@vger.kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Zenghui Yu" <yuzenghui@huawei.com>, "James Morse" <james.morse@arm.com>,
 <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 4/7] KVM: PPC: Standardize on "int" return types in the
 powerpc KVM code
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>, "Paolo Bonzini"
 <pbonzini@redhat.com>, "Sean Christopherson" <seanjc@google.com>
X-Mailer: aerc 0.13.0
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-5-thuth@redhat.com>
In-Reply-To: <20230203094230.266952-5-thuth@redhat.com>

On Fri Feb 3, 2023 at 7:42 PM AEST, Thomas Huth wrote:
> Most functions that are related to kvm_arch_vm_ioctl() already use
> "int" as return type to pass error values back to the caller. Some
> outlier functions use "long" instead for no good reason (they do not
> really require long values here). Let's standardize on "int" here to
> avoid casting the values back and forth between the two types.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Thanks for the patch. It looks fine to me, it should be okay to
go via Paolo's tree if he's going to take the series.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  arch/powerpc/include/asm/kvm_ppc.h  | 14 +++++++-------
>  arch/powerpc/kvm/book3s_64_mmu_hv.c | 14 +++++++-------
>  arch/powerpc/kvm/book3s_64_vio.c    |  4 ++--
>  arch/powerpc/kvm/book3s_hv.c        |  6 +++---
>  arch/powerpc/kvm/book3s_pr.c        |  4 ++--
>  5 files changed, 21 insertions(+), 21 deletions(-)
