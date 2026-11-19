Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107773;
	b=i8k4y1ckT3it763LupVmF4s8Mc0dA7HitZ+AUsu8MjhuxSn9avbgFSF9tJMHCSVPeTbM
	 cCvDzE71xWftyFtCYf5FzE2HoI6Ba7SDRQ3EQy5NcHUOTejup7Nq20waoMVOa7Jn3i7yQ
	 QAWxNDMqLiKz5yVt64G7kzft/9pl66MTc5he4dtzYqn7jcZpTJ0+yh/xlLLr5aJ/AoLcX
	 oCzNwZpnvrDRMFM3rzFe5QY3eTwUNJ7sZQdS+GBJptdGz15YwUQTzfYEj4TSNAGD6FVYd
	 FGGH6kLQ3LxitHCFquGjTt8LlSWH9CngnABvE7nlLlNLJPAAzsgPStcNibqtPdwgsiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107773;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=tuaICnb7sTsU3uMtAf1IdzJMLdxwJHMKKBVbfNsG8e0=;
	b=C0BxPgAXJ3GCZ7qq4GMR1pfIYrueiMavNiSKZn/jkJLq5XFjGVGUH1bSdrnjKd6Cj+z3
	 ++kXSdK/RUprvsMl+JWCAbqO7jhB8MckXDgrKvcL/BFc93R9IfKoujGHoB6rEbmLTZHjM
	 PTQo2VGSfDKFYAvMXqzPnmc1xwTgwiVnq/WrSclS+V5VWssndHPlz1Obg9jklmG6aPXkb
	 WISBkomLq+2BPKwdY85WEceJek7pIxnRf9X4SEWwZwDwkIguglHg0x/zpiVe8yIMQLFfm
	 Ew6DMzhMzYziZjsMy3aUCgmVEFfq0rrN99EFNP211ETQmyl6ZRLhcXxIVdGb8fVuaBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ICYGkKDh;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC20C606A324
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 17:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC20C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ICYGkKDh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795107771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tuaICnb7sTsU3uMtAf1IdzJMLdxwJHMKKBVbfNsG8e0=;
	b=ICYGkKDh04Lulop5yJc7OBezrOoW7weJu90F0CpPqCvjzhoAYGsB+PUuUURpqZgxgjkvFy
	30OMS3bjkSbJqFZm0f1k6oskKp10RdVNEfCm+eODbuLd6JFPufXCuEY4BuPa/DSyZG29/c
	8H3boQ7lkWBruUL1jB9ucFN9ajIXqek=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-ngZT-CSgNUyAEsHWSr941g-1; Thu, 19 Nov 2026 12:02:49 -0500
X-MC-Unique: ngZT-CSgNUyAEsHWSr941g-1
X-Mimecast-MFC-AGG-ID: ngZT-CSgNUyAEsHWSr941g_1795107768
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cdaf2073b0cso568a12.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 09:02:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107768; x=1795712568;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tuaICnb7sTsU3uMtAf1IdzJMLdxwJHMKKBVbfNsG8e0=;
        b=ooGFkJ3FUFM2MVTcmz4+Xinf+6V7AeoBOPB1BI2v10u2Wmt7e3f7lcEeso7hA9o4q4
         af4K2862ZatiCDgIbvWFqao1/1nWakB8lPU4DKsRi5OHfNb6PE44gJ7ctwtcxvJKtpUx
         xkppqon7CfwRIftLgHvBwXeGX7avnDP1WX9g5nxIT85MxLYhs9E490DAlgxDzTb5jrfc
         QwcwJbD1auyqUQqy45CqFK04u2QZsxT+4DHW37669naKtToQNbeV4jclFs1dlxwzxKG7
         uAcoBAf5hPEjoBM9y87kxe3coI79h17UjvtTqOdS+smNEQtv+10iEflbymP0EaXMHnwq
         UzYw==
X-Forwarded-Encrypted: i=1; AL+hErHOpxtE32s4GHGmEkK7LLSRKl0RXkad90Ih6209kga3ZgytSLCt51ZQrNzBbXYsuG0Aa6ICIi4=@lists.linux.dev
X-Gm-Message-State: APuU4Z8y7H99Pi4e5r/4N58Ef8RS5kd6uWHtsxJsqDCMgjJASTBKhbBP
	NopvlBrrgXpMkIyaAw9uesO5403+lLimRwWKBN5jsMUZO7hKDl0XlXh/0jISD6Ha44nys2uKZXF
	254WeBFfHZdFpiOmhUU6iKWxv9WtvVKphwEhb4EdB0qoYc9o/o67a70nrG6VxHO3bj9OmH/Vly1
	0HiofoDELp6NvAcRPRloL+FlWhBe9u26bd
X-Gm-Gg: AZFdTZdHDi+JEuOwLXgNEmPXkdgTJVroglmfbxCXbBYoddnjJZZ65M9j7cbWOonbtrq
	DUUVNqQ/iTqnfqsUGUX8i93wtRv4i83wKobt0irRHnoTJkY/CAA5lWy+3mHMPBlyXcAjeq1TMYi
	PZCelttk5uMhr7dKqqdAkHr74yW7nOOLlGEKzTHVLDxh/sH1bQaFFN8U5fzdLPvtrkX9MGnxcJe
	DQQ6klqf2OMsqdpXPo3nVMkwQSMQFTErVmotifhi9JLZpUhPkVmj2aQy3Az
X-Received: by 2002:a17:903:1c9:b0:2e9:6352:6c61 with SMTP id d9443c01a7336-2f03f15511fmr4875125ad.19.1795107767401;
        Thu, 19 Nov 2026 09:02:47 -0800 (PST)
X-Received: by 2002:a17:903:1c9:b0:2e9:6352:6c61 with SMTP id
 d9443c01a7336-2f03f15511fmr4874595ad.19.1795107766796; Thu, 19 Nov 2026
 09:02:46 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261119125608.3939330-1-maz@kernel.org>
In-Reply-To: <20261119125608.3939330-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 19 Nov 2026 18:02:34 +0100
X-Gm-Features: AclHuK9gLqjDXNyNzrRYpnTsqE3NQnqKer4SP-4ZAj4I36D5tykUXBkj1PxU_-4
Message-ID: <CABgObfaXpZsZ32L7gkW1EhuYwt0mkwTueyW9=BDBpZr71NCmuw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.4, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Colton Lewis <coltonlewis@google.com>, 
	Dan Carpenter <dan@pereq.eu>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Michael Reeves <michael.reeves077@gmail.com>, Mostafa Saleh <smostafa@google.com>, 
	Myria Sarvay <myrialsarvay@gmail.com>, Oliver Upton <oupton@kernel.org>, 
	Vincent Donnefort <vdonnefort@google.com>, Will Deacon <will@kernel.org>, 
	Xuheng Li <xuheng@cs.columbia.edu>, Yureka Lilian <yureka@cyberchaos.dev>, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XO3Pje2wUuXGn9_If0au-hdz2aVM0dZ3qkboPXWeOq0_1795107768
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 1:56=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> As promissed in my previous missive, I'm back with a few more
> presents...
>
> This round of fixes is mostly a Dan Carpenter special, as they seem to
> have hit the jackpot with some new formal analysis tool, and found a
> number of issues in NV. I am very surprised (/s).
>
> The rest is a bunch of pKVM fixes and workarounds for ugly hardware.

Pulled, thanks.

> I will be back next week same time for more of the same!

I can't wait for it!

Paolo

> Please pull,
>
>         M.
>
> The following changes since commit 181a701fc14d3d468c603b5ecfb9f12115c5fb=
72:
>
>   Merge branch kvm-arm64/misc-7.4-1 into kvmarm-master/fixes (2026-11-03 =
18:14:37 +0000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.4-3
>
> for you to fetch changes up to 3385a832525527801012f5993d1f6a7a3d23092c:
>
>   Merge branch kvm-arm64/mmu-fixes-7.4-2 into kvmarm-master/fixes (2026-1=
1-19 11:16:29 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.4, take #3
>
> * MMU fixes:
>
>   - Fix arbitrary truncation to 32bit when dealing with pool size
>
>   - Correctly order page pin refconting
>
>   - Prevent a HYP block mapping from being replaced with a table
>
>   - Fix NV Range invalidation by extending the boundaries to the
>     next block mapping
>
>   - Make sure the correct hw_mmu gets picked on the first run,
>     should userspace restore a nested context between init and
>     the first vcpu_load().
>
>   - Reject TLBI IPAS2E1 that fall outside of the S2 range
>
> * System register fixes:
>
>   - Correctly forward POE/PIE/TVAL EL2 register traps
>
>   - Add a sanity check for missing trap forwarding
>
>   - Correctly hide generic PAuth for pKVM protected guests when
>     the feature PAuth has been exluced from the feature set
>
>   - Make sure that HCR_EL2.NV1 is always RES0
>
> * Misc fixes:
>
>   - Flag Apple M3, M4 and M6 CPUs as having a broken vgic and
>     a wonky PMUv3 emulation.
>
>   - Correctly handle 64bit offsets into an MMIO region from
>     userspace
>
>   - Ensure that a vcpu is loaded when injecting an event
>
> ----------------------------------------------------------------
> Colton Lewis (2):
>       KVM: arm64: Force HCR_EL2.NV1 to RES0 unconditionally
>       KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0 when E2H0 is NI_N=
V1
>
> Dan Carpenter (9):
>       KVM: arm64: nv: Invalidate whole L1 blocks on TLBI RIPAS2E1
>       KVM: arm64: vgic: Don't truncate offsets in vgic_find_mmio_region()
>       KVM: arm64: nv: Initialize hw_mmu to NULL for nested vCPUs
>       KVM: arm64: nv: Forward PIR_EL2, PIRE0_EL2 and POR_EL2 traps
>       KVM: arm64: nv: Forward CNTP_TVAL_EL02 and CNTV_TVAL_EL02 traps
>       KVM: arm64: nv: Report EL2 registers with no trap forwarding
>       KVM: arm64: Load the vcpu in KVM_SET_VCPU_EVENTS
>       KVM: arm64: nv: Fix NULL dereference in kvm_pmu_nested_transition()
>       KVM: arm64: nv: Ignore TLBI IPAS2E1 above the IPA limit
>
> Fuad Tabba (1):
>       KVM: arm64: Hide generic ptrauth from protected VMs without ptrauth
>
> Marc Zyngier (3):
>       Merge branch kvm-arm64/misc-7.4-2 into kvmarm-master/fixes
>       Merge branch kvm-arm64/sysreg-fixes-7.4-2 into kvmarm-master/fixes
>       Merge branch kvm-arm64/mmu-fixes-7.4-2 into kvmarm-master/fixes
>
> Michael Reeves (1):
>       arm64: Apply existing Apple Silicon CPU workarounds to newer CPUs
>
> Mostafa Saleh (1):
>       KVM: arm64: Use consistent type for pool size
>
> Myria Sarvay (1):
>       arm64: Add CPU part numbers for newer Apple Silicon CPUs
>
> Xuheng Li (2):
>       KVM: arm64: Don't replace a valid hyp block mapping with a table
>       KVM: arm64: Order a later pinner's accesses after the hyp mapping
>
>  arch/arm64/include/asm/cputype.h              | 28 +++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h             |  2 +-
>  arch/arm64/include/asm/kvm_pgtable.h          |  2 +-
>  arch/arm64/kernel/cpu_errata.c                | 12 +++++++++
>  arch/arm64/kernel/cpufeature.c                | 12 +++++++++
>  arch/arm64/kvm/arm.c                          |  8 ++++--
>  arch/arm64/kvm/config.c                       |  7 +----
>  arch/arm64/kvm/emulate-nested.c               | 10 ++++++-
>  arch/arm64/kvm/hyp/include/nvhe/early_alloc.h |  2 +-
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h         |  4 +--
>  arch/arm64/kvm/hyp/nvhe/early_alloc.c         |  2 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  8 ++++++
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  6 ++---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  4 +--
>  arch/arm64/kvm/hyp/pgtable.c                  | 10 ++++++-
>  arch/arm64/kvm/nested.c                       |  8 ++++++
>  arch/arm64/kvm/pmu-emul.c                     |  3 +++
>  arch/arm64/kvm/sys_regs.c                     | 39 +++++++++++++++++++++=
+++---
>  arch/arm64/kvm/vgic/vgic-mmio.c               |  4 +--
>  arch/arm64/kvm/vgic/vgic-mmio.h               |  2 +-
>  tools/testing/selftests/kvm/arm64/hello_el2.c | 15 +++++++++++
>  21 files changed, 161 insertions(+), 27 deletions(-)
>

