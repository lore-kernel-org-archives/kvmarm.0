Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDA97B
	for <kvmarm@lists.linux.dev>; Sun,  5 Feb 2023 08:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675585705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UO1EdFuMkkVyfac3fwD45cLw5uizYsR9A5gP2egekTM=;
	b=Lls9GBzXUjlwN2P59THSuGw3Rmi+MwkiORMoVNn7ApJ+vdna9j9qI0BTbekfH0FQNYRuF1
	Ow0NnnTRGKkgmHVfe0DUZ36L0dkggrG9IfH+urieAzzSL77woRWTZ6BaLbU+OQWkDFJtzl
	ehByqnHLDTqQYL4wvbZChsPYRc9zV9o=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-423-Dr_tDXujNDmJ-gbeI5P3xg-1; Sun, 05 Feb 2023 03:28:23 -0500
X-MC-Unique: Dr_tDXujNDmJ-gbeI5P3xg-1
Received: by mail-ua1-f70.google.com with SMTP id z42-20020ab0492d000000b00423b333ff7dso4019920uac.22
        for <kvmarm@lists.linux.dev>; Sun, 05 Feb 2023 00:28:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UO1EdFuMkkVyfac3fwD45cLw5uizYsR9A5gP2egekTM=;
        b=hBiUjliRqgpDXGyIAqwd7Sql8qHGq5Yb848c2KvypTlrTMyf72FRiV7FVbiTfFy4Kh
         rUr5bs9oB/3oBDgYDfM+z7afTyv/T8tL9ZeEAXAFjOTSHVycnSpQ4wMzisF9DzpmZNAQ
         KC9wbb7mhMK74yylLfg0NXPEOgJHo6CMz1U1JLagSg2ffVo2uj2PlRLbWM0kdAcQeRLb
         DmTVO9XFq1313JCLmlnWDS9XNlqKkMJvVuWbHFST3G2MFzyuilaH9x/OKz3KLJa2ZZsj
         wQippY2g+6lqWmd670ean4KWRi84FVj84t9R2abexQ4ZlweaxNUDohH3Z6WBFRVEk4j1
         JUlQ==
X-Gm-Message-State: AO0yUKWytqgVmPHfVnHtieE7pkNfd0g1WbtnmuE8LZc4M6LlqJKhhNye
	zVer/7ZL0Ur65hkWGCv1ulp7stmLQG5S/mXK4q/4EaO8P5mbYTlVNPiVlWDXAbVaYtYJsJiY212
	oXLeqwzXKdW1JSfhU78a88fN1P+4hCASo
X-Received: by 2002:a05:6122:2ba:b0:3dd:f386:1bca with SMTP id 26-20020a05612202ba00b003ddf3861bcamr2447221vkq.33.1675585702930;
        Sun, 05 Feb 2023 00:28:22 -0800 (PST)
X-Google-Smtp-Source: AK7set832lmgFJb3yUv2cp0W6x43Si9vq2XdDLN1vzJ5ohOPqMdf2reOo+DXHos/4J9Y9xTmZ3nf0MRQvstms53rCJA=
X-Received: by 2002:a05:6122:2ba:b0:3dd:f386:1bca with SMTP id
 26-20020a05612202ba00b003ddf3861bcamr2447215vkq.33.1675585702650; Sun, 05 Feb
 2023 00:28:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230129190142.2481354-1-maz@kernel.org>
In-Reply-To: <20230129190142.2481354-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 5 Feb 2023 09:28:11 +0100
Message-ID: <CABgObfa=++RCcf=5A2DW5YqEq40VfeGoewZ2LXKk+3gS=x-VpQ@mail.gmail.com>
Subject: Re: [GIT PULL] kvm/arm64 fixes for 6.2, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Pulled, thanks.

Paolo

On Sun, Jan 29, 2023 at 8:02 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's the (hopefully) last batch of fixes for KVM/arm64 on 6.2. The
> really important one addresses yet another non-CPU access to the vgic
> memory, which needs to be suitably identified to avoid generating a
> scary warning. The second half of the series fixes a bunch of
> page-table walk tests after the kernel fix that went in earlier in
> 6.2.
>
> Please pull,
>
>         M.
>
> The following changes since commit ef3691683d7bfd0a2acf48812e4ffe894f10bfa8:
>
>   KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation (2023-01-21 11:02:19 +0000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.2-3
>
> for you to fetch changes up to 08ddbbdf0b55839ca93a12677a30a1ef24634969:
>
>   KVM: selftests: aarch64: Test read-only PT memory regions (2023-01-29 18:49:08 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.2, take #3
>
> - Yet another fix for non-CPU accesses to the memory backing
>   the VGICv3 subsystem
>
> - A set of fixes for the setlftest checking for the S1PTW
>   behaviour after the fix that went in ealier in the cycle
>
> ----------------------------------------------------------------
> Gavin Shan (3):
>       KVM: arm64: Add helper vgic_write_guest_lock()
>       KVM: arm64: Allow no running vcpu on restoring vgic3 LPI pending status
>       KVM: arm64: Allow no running vcpu on saving vgic3 pending table
>
> Ricardo Koller (4):
>       KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
>       KVM: selftests: aarch64: Do not default to dirty PTE pages on all S1PTWs
>       KVM: selftests: aarch64: Fix check of dirty log PT write
>       KVM: selftests: aarch64: Test read-only PT memory regions
>
>  Documentation/virt/kvm/api.rst                     |  10 +-
>  arch/arm64/kvm/vgic/vgic-its.c                     |  13 +-
>  arch/arm64/kvm/vgic/vgic-v3.c                      |   4 +-
>  arch/arm64/kvm/vgic/vgic.h                         |  14 ++
>  include/kvm/arm_vgic.h                             |   2 +-
>  .../selftests/kvm/aarch64/page_fault_test.c        | 187 ++++++++++++---------
>  6 files changed, 132 insertions(+), 98 deletions(-)
>

