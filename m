Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E3742B73F;
	Thu,  6 Aug 2026 09:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008344; cv=none; b=Or95DhcEkJ7Je+S2m6YzC2WB3jQU93LgLVbGZUHWTGLB+TnkQywj+0yS2/P/Ig5IsuqVSpUY2EiQp5qKL7TSG5lQNIr8IJfbFd0Y41azqKSjsS+BWvmD4lvzyzdLHR2TQVPeD1D+LqT8Iyx7lJm9LgICOPTTk2j6BNw5LIrHqAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008344; c=relaxed/simple;
	bh=x/faUpGjhreXQ0XaWHmItwC1H1016elxmM4+0LnrXU4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rJgHuweaPqLvJ4prMEE2iNRbl6i8FhHzXe9zgwskFZrK23hXWlqjRnwxSa+tr6aGYEisDYKplP/83aG1VNgZPh82+2tqXY535Rc/ngHyEmCH3Z6ZmLi+vIPoaFqIhy29BITnEz5t1ip3rVngfEYQLpslgYKECVF2v6Naw4+7n/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WInvRPdK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WInvRPdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501541F000E9;
	Thu,  6 Aug 2026 09:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786008340;
	bh=+YjwbuOF2c91J+zhM5v4BG9JCOvAs5h0xWhJPFIEqQ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WInvRPdKYQ8V8QAQfxZwSxqCJFU4vJI/fbxyUXF4o3wuX+EmDG1ejZ+8v/uxxmcIX
	 Q0JxtzVARiwANMLXLpThdh5ChOiVQWQkLqtKntKMxZ76ihmFIdATw1bg9iQtdAaz9Z
	 Ss+uShL0Hk1NUhLCJ6Bm0u13MxYEdiBlM4CVtx5sZQTnNCCJJRkP4fOZsG1HP1X+6j
	 aZeJ+dY5FomMdv4ZADzo2Q/fXE8IxrelwSNybJWPBzwZEFAMyACeGeJdHmcxsoAqhd
	 oD/D34vc3n7hmJjHyQiy6ETmsZhxZeaaWmJPRI+3LBlw1ViIMxWNPGo8V9vvEgxvZ8
	 MKrJEv24qrDew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/8] KVM: arm64: Handle VNCR TLB invalidation race
 with vcpu_put() VNCR unmapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260806091026.620700-6-maz@kernel.org>
References: <20260806091026.620700-1-maz@kernel.org>
 <20260806091026.620700-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 09:25:39 +0000
Message-Id: <20260806092540.501541F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Acquiring `mmu_lock` with preemption disabled causes a sleep-in-at=
omic bug on PREEMPT_RT kernels.
--

--- Patch [5]: [PATCH v2 5/8] KVM: arm64: Handle VNCR TLB invalidation race=
 with vcpu_put() VNCR unmapping ---
commit 7a7c469ac4158e77c3548a526ab62a924ed75161
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Handle VNCR TLB invalidation race with vcpu_put() VNCR unmapping

This patch addresses a race condition between VNCR TLB invalidation and VNCR
unmapping during vcpu_put(). It introduces an atomic exchange for resetting
the cpu tracking field and a common function for unmapping, ensuring these
operations happen atomically. This closes the TOCTOU race and prevents
concurrent mapping faults.

Link: https://lore.kernel.org/r/20260801130237.0FD8F1F00ACA@smtp.kernel.org

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 67cc5b6d80705..05f0e7e89e982 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

> @@ -1584,8 +1607,6 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)

[Severity: High]
This is a pre-existing issue, but does acquiring mmu_lock inside a
preemption-disabled region here cause a sleep-in-atomic bug on RT kernels?

Looking at kvm_map_l1_vncr() from the context, it starts with:

static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
{
        struct vncr_tlb *vt =3D vcpu->arch.vncr_tlb;
        pgprot_t prot;

        guard(preempt)();
        guard(read_lock)(&vcpu->kvm->mmu_lock);

Since read_lock() is implemented as an RT-mutex on PREEMPT_RT and can block,
could this sequence trigger a scheduling-while-atomic panic if the lock is
contended?

>  	if (vt->wr.nG && get_asid_by_regime(vcpu, TR_EL20) !=3D vt->wr.asid)
>  		return;
> =20
> -	vt->cpu =3D smp_processor_id();
> -
>  	if (vt->hpa_writable && vt->wr.pw && vt->wr.pr)
>  		prot =3D PAGE_KERNEL;
>  	else if (vt->wr.pr)

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806091026.6207=
00-1-maz@kernel.org?part=3D5
