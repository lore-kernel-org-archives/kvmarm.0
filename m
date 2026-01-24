Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF54D2E414
	for <kvmarm@lists.linux.dev>; Sat, 24 Jan 2026 07:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769240831; cv=none; b=mCfWVeFmHN+9oPqExCM9TGV8bbmQ5JEewi1To6pA2pUonX7nBA5nsylLZfEqxKEGE9463rwoCzxNbLe5DvebMUfBye4xmnO5w/Sv3HKIb83FvEMw3l1l62Q8JL2KXEYJDARXkBgRHJm4727S4/MBLaRmi/p9MXt/b2wd+y33380=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769240831; c=relaxed/simple;
	bh=VMonpPDORVBzWWGlFxv6VqjO55xg9Co8gEtHsEjtK3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PnqpzcU8Y2FIwth8BhSJ8w/3tsbMNbt9WWIZJuIJlKqaR3Y6vHKyTF9n/nIarTdzXCjTUDn51EIuKCKfksODBRKokBwrsYETWOCieRqdIrYjpn4MOwJSNHn4ZyNVDDGagAvAUYx+drNJvO5lw24FE/iXODHN7g/56jEcrkXHGx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PaWDtq1t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PaWDtq1t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769240828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4v/ARzgQrLTE+mBIPvWEGmSWVJQf1rVB4tDf1RFfnKA=;
	b=PaWDtq1tiRcFPPzI1QkjCMHmmn1oHeky64Tc8SDMZyshRzlI2cSJRFrmToyRZmM+at/od1
	et7xSDp7KrKtgLqQmVNHV5VBtrfsuDVzdO7r3cdUvj5NfBwqZ4Uul/orFOR6T8u17Fxb7V
	C/6WuVOyI1scPDBlrONhyQXXgnYgAJM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-BWc_pnrsPl-4YEtajbOfyw-1; Sat, 24 Jan 2026 02:47:07 -0500
X-MC-Unique: BWc_pnrsPl-4YEtajbOfyw-1
X-Mimecast-MFC-AGG-ID: BWc_pnrsPl-4YEtajbOfyw_1769240826
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-432c05971c6so2187327f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 23:47:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769240825; x=1769845625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4v/ARzgQrLTE+mBIPvWEGmSWVJQf1rVB4tDf1RFfnKA=;
        b=BD5H4uEU8WO/zRSWme8Zow898tVTPMD+fOjqfncz2g+2hu79UidOhrRK3pLUHGjUTZ
         zmrC4TKrie4UVtOfvPzLIUvb/7LGFESOVdXyAaQePBtiWpfA87ikC+TU4xsD1u/48Idi
         YczKNVNLSoJxFppiWmQ6A7EJ4tTVruzvIymZPXmdmp2rI80RdDh/08JkvPF46boK676i
         iqGih4SqGGH6Bf6BuO9o9Kg91rwlBlD9l2NAzh8Pk8eWzFivn+jes0a4jmqzIydJt78Y
         BDiNUrcJlRtaEnDmgeSl2/nBreDCvITuWCBHyO2L+vK0pRoL8DzDunyOMtjODoJFr+8D
         eSrg==
X-Forwarded-Encrypted: i=1; AJvYcCX3BE5pFLx2AsLXPJp9mBU5GeLq1A4rk76yXT4Xlkig8yQr/hsss2C67EM0f3oR2DTCU5O4F0s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXgaf91AK1Hnan51lIjgIptvmyAVR04cCxHyylplsJ0fhZGnng
	6sw5/oVZ+NghcX2zuiDL5QTG8NPRY4VY925bnxzYdNF1DQAaJKOJ06cqA5y/3Sp7UmoKyO9l193
	IqaMeC4tSTvQ40pkE4u/y+BgNwC9wN2RkRojJlXrzhJd/uCV1nJCauQ9+xXunClhP0ce0HPWIyp
	Xiz7mKrVyIn9C4KFPYgGHB84AGGP3uHSq5wy5RR2C+
X-Gm-Gg: AZuq6aJ3k9h3oHRce7nzdd4mCp5Ynn2Jq8pN5MAW91z3YV9R6cZkHobpAFO36s3ZFa4
	ezLiDKUDLyak6Yz1kyB3OKm3i3+vWPO0QWI5N2PpazHmclGsKSEbMSTBIZ37jquUE4dhc+KSoQx
	g7Gmmy7wlKCXo/2bpV+74pBjPWeENy0NnCBRQH4C6sQ+QjNpK0mB7G1EnrJIPMHewrItRs09ewD
	ixzdD/ZCqeASzdI74fWKatWCJdHt3vH3LqE4SBuSg4/FtA74EpJX0JQrgSZeF7t/Qbrkg==
X-Received: by 2002:a5d:64e7:0:b0:430:f736:7cc with SMTP id ffacd0b85a97d-435b1ab83f6mr8611684f8f.1.1769240825315;
        Fri, 23 Jan 2026 23:47:05 -0800 (PST)
X-Received: by 2002:a5d:64e7:0:b0:430:f736:7cc with SMTP id
 ffacd0b85a97d-435b1ab83f6mr8611661f8f.1.1769240824848; Fri, 23 Jan 2026
 23:47:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aWizsSzD3fRWMsAc@kernel.org>
In-Reply-To: <aWizsSzD3fRWMsAc@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 24 Jan 2026 08:46:53 +0100
X-Gm-Features: AZwV_Qin5BW9ER_Rro9iMC2v0VFsd8G87ICtOoRCsPXIgFxX4oq4YSVsDFm_Yo8
Message-ID: <CABgObfYb7yK7CCq5iEXjfa+=DnYBUG7YnKxR-wjK0mY=nB47Dg@mail.gmail.com>
Subject: Re: KVM/arm64 fixes for 6.19
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7Tvk5sxk2A5eBLrxpjMrGvdDmaAEQx69GNEFe8fmht0_1769240826
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 10:30=E2=80=AFAM Oliver Upton <oupton@kernel.org> w=
rote:
>
> Hi Paolo,
>
> Here is the first (and likely only) set of fixes for 6.19. Small batch
> of changes fixing issues in non-standard configurations like pKVM, hVHE,
> and nested.
>
> Details are in the tag, please pull.

Pulled, thanks - I waited to see if anything else came around from
other architectures, but it seems like things are calm.

Paolo

> Thanks,
> Oliver
>
> The following changes since commit f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1=
da:
>
>   Linux 6.19-rc3 (2025-12-28 13:24:26 -0800)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.19-1
>
> for you to fetch changes up to 19cffd16ed6489770272ba383ff3aaec077e01ed:
>
>   KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers (2=
026-01-10 02:19:52 -0800)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.19
>
>  - Ensure early return semantics are preserved for pKVM fault handlers
>
>  - Fix case where the kernel runs with the guest's PAN value when
>    CONFIG_ARM64_PAN is not set
>
>  - Make stage-1 walks to set the access flag respect the access
>    permission of the underlying stage-2, when enabled
>
>  - Propagate computed FGT values to the pKVM view of the vCPU at
>    vcpu_load()
>
>  - Correctly program PXN and UXN privilege bits for hVHE's stage-1 page
>    tables
>
>  - Check that the VM is actually using VGICv3 before accessing the GICv3
>    CPU interface
>
>  - Delete some unused code
>
> ----------------------------------------------------------------
> Alexandru Elisei (4):
>       KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
>       KVM: arm64: Inject UNDEF for a register trap without accessor
>       KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_h=
yp()
>       KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()
>
> Dongxu Sun (1):
>       KVM: arm64: Remove unused vcpu_{clear,set}_wfx_traps()
>
> Marc Zyngier (2):
>       KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
>       KVM: arm64: Don't blindly set set PSTATE.PAN on guest exit
>
> Oliver Upton (1):
>       KVM: arm64: nv: Respect stage-2 write permssion when setting stage-=
1 AF
>
> Sascha Bischoff (1):
>       KVM: arm64: gic: Check for vGICv3 when clearing TWI
>
> Will Deacon (1):
>       KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walker=
s
>
>  arch/arm64/include/asm/kvm_asm.h        |  2 ++
>  arch/arm64/include/asm/kvm_emulate.h    | 16 ----------------
>  arch/arm64/include/asm/kvm_pgtable.h    | 16 ++++++++++++----
>  arch/arm64/include/asm/sysreg.h         |  3 ++-
>  arch/arm64/kernel/image-vars.h          |  1 +
>  arch/arm64/kvm/arm.c                    |  1 +
>  arch/arm64/kvm/at.c                     |  8 ++++++--
>  arch/arm64/kvm/hyp/entry.S              |  4 +++-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  3 +++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c          |  1 -
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
>  arch/arm64/kvm/hyp/pgtable.c            |  5 +++--
>  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
>  arch/arm64/kvm/mmu.c                    | 12 +++++-------
>  arch/arm64/kvm/sys_regs.c               |  5 ++++-
>  arch/arm64/kvm/va_layout.c              | 28 +++++++++++++++++++++++++++=
+
>  17 files changed, 73 insertions(+), 38 deletions(-)
>

