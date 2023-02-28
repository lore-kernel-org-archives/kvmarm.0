Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DB2D506;
	Tue, 28 Feb 2023 23:35:17 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso2531pjv.0;
        Tue, 28 Feb 2023 15:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e4zYd/om/0vBkL4x55q7/7LukdZ/UT4v5ORbkIxAbcQ=;
        b=nNJQX9hYnw3FX8YKTaDXEAIS+z4fPv8Bw+B8qr6ckPjb8pFiYXJ7RiGVqtKr/keDNd
         GHwOhj9tlgJjLU/U20MXO8fQKHuOdeKGrg2eToL9nDAbiCvFdqud9l6fOuVKo0baxp7t
         5FVPg/CUTGadEIP2mUpz3gWuG6560mb6D/o5pIVzm6rRVozf7pBSd3DFDEuXckZBA1OR
         wnNpxgtjEvF/TswNsBSQ8hBWnHeKrYoekuzxHeICMr4siBBpNcT8MrJWADmUM92DmGVN
         zsKkZkGc1Ez+ceo4mMkEpvaZAfJIiM7PDPrPH2zOGLVkBHL4KoIYnCweaSc3laUK7hCX
         oIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e4zYd/om/0vBkL4x55q7/7LukdZ/UT4v5ORbkIxAbcQ=;
        b=GiCJcVLOkiOjNMODPscEGSXCBvJacBiB5ifl7K1R9juvSAREVgaLIzPGYoEp36jQR0
         lIHTgC1m+biYMXk4zmr4+o8vu3BhCfAgvGFG9uXhdE8tG8g2y0/2CMlatzBrBw4JiXBM
         6RZ4JOAYIB0fRxnUQzVGhet6OVXuzp1YWjIw7fNgsk++70EuqbecprUrC1V6a1dm2hCA
         zyItb7DkdBJoN7Q9ebBsMAFXZ0Wq6vXWKT3ebIb849TI1i85gp11vNqkZlFMZHtPcrv7
         ltOnlLUPgHNX6P1hha1RExu90djipxBc9uQDur7HDB4djK9UvDKdwBBdZOYc+GP2b10+
         BeqQ==
X-Gm-Message-State: AO0yUKWOv1zB9+kgUiVMp+sILvNbPl2rS/M9qKqBHw9emaiYwZGcY7Wa
	cTIlaXbEvwvWrWQvpzyAY4ho8h50jElEow19amQ=
X-Google-Smtp-Source: AK7set/h/6S+CfhMlSvBaTTgOBE4PVtAkXHS+ngdIcxOP2Zb8jQT9r+uwE43NbtTp5RsatSeptHrwizOBS6NcjndHi0=
X-Received: by 2002:a17:90a:ad8a:b0:234:1fac:f291 with SMTP id
 s10-20020a17090aad8a00b002341facf291mr1861292pjq.8.1677627316752; Tue, 28 Feb
 2023 15:35:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230127112248.136810-1-suzuki.poulose@arm.com> <Y9PtKJ3Wicc19JF1@myrica>
In-Reply-To: <Y9PtKJ3Wicc19JF1@myrica>
From: Itaru Kitayama <itaru.kitayama@gmail.com>
Date: Wed, 1 Mar 2023 08:35:05 +0900
Message-ID: <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, 
	James Morse <james.morse@arm.com>, Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Quentin Perret <qperret@google.com>, 
	Sean Christopherson <seanjc@google.com>, Steven Price <steven.price@arm.com>, Thomas Huth <thuth@redhat.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"

On Sat, Jan 28, 2023 at 12:30 AM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> On Fri, Jan 27, 2023 at 11:22:48AM +0000, Suzuki K Poulose wrote:
> > We are happy to announce the early RFC version of the Arm
> > Confidential Compute Architecture (CCA) support for the Linux
> > stack. The intention is to seek early feedback in the following areas:
> >  * KVM integration of the Arm CCA
> >  * KVM UABI for managing the Realms, seeking to generalise the operations
> >    wherever possible with other Confidential Compute solutions.
>
> A prototype for launching Realm VMs with QEMU is available at:
> https://lore.kernel.org/qemu-devel/20230127150727.612594-1-jean-philippe@linaro.org/
>
> Thanks,
> Jean

Hi Jean,
I've tried your series in Real on CCA Host, but the KVM arch init
emits an Invalid argument error and terminates.
I configure it with the aarch64-softmmu target only and built, any
other steps I should worry?

Itaru.

>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
