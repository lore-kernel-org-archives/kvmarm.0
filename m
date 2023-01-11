Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31D1BD33
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 22:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673477543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1vvFOlgZcmbBXel/bkUj30X9nLvjQk+79xN6sEwmowg=;
	b=holkbhl3EX8cUpINkTS57m2VvfZQlJeO0e1mw5OJ08oIqUeZTLNg0FizLdc/JtsKGJIzWn
	h6KR61RYNALg1/n9w3iZsiF3yJ2DK557F9KrTPufgKVyrVrx7hXR2f5/RimN1ZtM9tKZSv
	iHNrxRruI/xSQ47SzQaIVGMwaoqPWP0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-173-GTEKgwbqP_qAvxgD8gOtAA-1; Wed, 11 Jan 2023 17:52:20 -0500
X-MC-Unique: GTEKgwbqP_qAvxgD8gOtAA-1
Received: by mail-wm1-f69.google.com with SMTP id f20-20020a7bc8d4000000b003d1cda5bd6fso3809489wml.9
        for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 14:52:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1vvFOlgZcmbBXel/bkUj30X9nLvjQk+79xN6sEwmowg=;
        b=rU9pAc6V+8R1Nb6K41eaTaQYtpxQNz63eV7o7vhBVc3ToHOQF6k0UjzqcWx5u3qdgX
         OysDqe5pq6F0bLJR+JYS/xd6zGAp6x2AXaksJm886yLrEnccXCGG3UntM2kWrd05Uapc
         xBuV7g1vKSFM4jgM0fBsCNiZE6e514SDh5KEXYQ0jvrqKhoGrPaV1nXnB5E1hxvk1uLs
         iDTKU9seqhY+NfeeTzTMjNZ3BDYt0OdJWArXSGqMrsvq3rlqxFJPWtDrTXNPkA4w+AJt
         nf2UTxRp32XMPk+RR8Dburv5mf8IMm1/4Pvomu7Y7YwXPyDkDzqugi38usgx1fmFT8nW
         Fgfw==
X-Gm-Message-State: AFqh2kqlulVbHaPsXM4Af2WOudNC8RTHTs3HJN/9sxkfc15xSz0VJ25R
	stibQJkyZ4sBsooPR2Ech2rWbTnAm7ngwdMVqssz7MwEKPbGUInc/SAPoc51hv/TkOTKvkvj9H1
	Bfa0SH3vZm5pPToCP
X-Received: by 2002:a05:600c:a51:b0:3d3:513c:240b with SMTP id c17-20020a05600c0a5100b003d3513c240bmr53612351wmq.7.1673477539346;
        Wed, 11 Jan 2023 14:52:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtmGyt8JKlWBfzQGmhaL765SxJvgXCn4igxgfJhH5h0b9S1PIkRIsbexrIgfCr7o9RQxEZJ1g==
X-Received: by 2002:a05:600c:a51:b0:3d3:513c:240b with SMTP id c17-20020a05600c0a5100b003d3513c240bmr53612337wmq.7.1673477539106;
        Wed, 11 Jan 2023 14:52:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id m17-20020a05600c3b1100b003cfbbd54178sm7547260wms.2.2023.01.11.14.52.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 14:52:18 -0800 (PST)
Message-ID: <24954c55-84c0-2d06-22b7-5345fd4e0731@redhat.com>
Date: Wed, 11 Jan 2023 23:52:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.2, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, James Clark <james.clark@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, kvmarm@lists.cs.columbia.edu,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
References: <20230105154250.660145-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230105154250.660145-1-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/5/23 16:42, Marc Zyngier wrote:
> Hi Paolo,
> 
> Happy new year!
> 
> Here's the first batch of fixes for KVM/arm64 for 6.2. We have two
> important fixes this time around, one for the PMU emulation, and the
> other for guest page table walks in read-only memslots, something that
> EFI has started doing...
> 
> The rest is mostly documentation updates, cleanups, and an update to
> the list of reviewers (Alexandru stepping down, and Zenghui joining
> the fun).
> 
> Please pull,

Pulled (though not pushed yet because I still have some x86 tests 
running), thanks.

Paolo

> 	M.
> 
> 
> The following changes since commit 88603b6dc419445847923fcb7fe5080067a30f98:
> 
>    Linux 6.2-rc2 (2023-01-01 13:53:16 -0800)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.2-1
> 
> for you to fetch changes up to de535c0234dd2dbd9c790790f2ca1c4ec8a52d2b:
> 
>    Merge branch kvm-arm64/MAINTAINERS into kvmarm-master/fixes (2023-01-05 15:26:53 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.2, take #1
> 
> - Fix the PMCR_EL0 reset value after the PMU rework
> 
> - Correctly handle S2 fault triggered by a S1 page table walk
>    by not always classifying it as a write, as this breaks on
>    R/O memslots
> 
> - Document why we cannot exit with KVM_EXIT_MMIO when taking
>    a write fault from a S1 PTW on a R/O memslot
> 
> - Put the Apple M2 on the naughty step for not being able to
>    correctly implement the vgic SEIS feature, just liek the M1
>    before it
> 
> - Reviewer updates: Alex is stepping down, replaced by Zenghui
> 
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>        MAINTAINERS: Remove myself as a KVM/arm64 reviewer
> 
> James Clark (1):
>        KVM: arm64: PMU: Fix PMCR_EL0 reset value
> 
> Marc Zyngier (8):
>        KVM: arm64: Fix S1PTW handling on RO memslots
>        KVM: arm64: Document the behaviour of S1PTW faults on RO memslots
>        KVM: arm64: Convert FSC_* over to ESR_ELx_FSC_*
>        KVM: arm64: vgic: Add Apple M2 cpus to the list of broken SEIS implementations
>        Merge branch kvm-arm64/pmu-fixes-6.2 into kvmarm-master/fixes
>        Merge branch kvm-arm64/s1ptw-write-fault into kvmarm-master/fixes
>        MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
>        Merge branch kvm-arm64/MAINTAINERS into kvmarm-master/fixes
> 
>   Documentation/virt/kvm/api.rst          |  8 +++++++
>   MAINTAINERS                             |  2 +-
>   arch/arm64/include/asm/cputype.h        |  4 ++++
>   arch/arm64/include/asm/esr.h            |  9 +++++++
>   arch/arm64/include/asm/kvm_arm.h        | 15 ------------
>   arch/arm64/include/asm/kvm_emulate.h    | 42 +++++++++++++++++++++++----------
>   arch/arm64/kvm/hyp/include/hyp/fault.h  |  2 +-
>   arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
>   arch/arm64/kvm/mmu.c                    | 21 ++++++++++-------
>   arch/arm64/kvm/sys_regs.c               |  2 +-
>   arch/arm64/kvm/vgic/vgic-v3.c           |  2 ++
>   11 files changed, 69 insertions(+), 40 deletions(-)
	````````

