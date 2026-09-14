Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2A549C4D7
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 18:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789409562; cv=none; b=qahH16G32GK+Uhcmj0O6/m78pM7mj/pJ8ScSBtLEmPQGI9SWoUl+nUxc8gogp9FTL111Vg2Xhdd2KnSvCC53RoT7jeNZr1OzKvTnPxKPjCS2471oxHxUxYaWCqYhENGFbp25gFh2gn6mzJUou9zEtZNZAwhh9Hn0LBjbNobgAhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789409562; c=relaxed/simple;
	bh=hyfxBdy3OjG5YpYUeDDBzwGynwe4d62FEiIOMYVlhwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AuByOVitGOI5OuOudhhvweYglYk26e6w6chd+7siwF4EWwmKMzTgvomlI7QIvtpqMFYXuwoJcuDDWJ0lEz8UHxJdTMATOWiYpzMlqqIvs++Sn2dbzRnBPXW469FRsKPHmKbz1ygjhkx7U60umLynXuPCCJIV76EUSVvcVKf7g74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Alt4ce8L; arc=none smtp.client-ip=91.218.175.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Alt4ce8L"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=hyfxBdy3OjG5YpYUeDDBzwGynwe4d62FEiIOMYVlhwE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789409556; v=1; x=1790014356;
 b=Alt4ce8LeK9kZVbuw3lEmyzZkq41REja81pnR6qO+Bn7KPds0KOQU5QisIHyi4wYtJHHf6wU
 FY0VkdZdnxp2CHlfDB4RR4uDPGhO3j4oiOfoESANEJIjmN5ZSF21lJXqyKU939EsCJFXXjXlQcs
 S4Dah2cx5jXQxCwRBYNMTz5s=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4eab190d5cc4f243;
	Mon, 14 Sep 2026 18:12:36 +0000
X-Mizu-Trace-ID: 4eab190d5cc4f243
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so11156e87.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:12:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwFPcVhm/KhYoRQlrYxaWAQWPfrB8RxX4AQk47L1JNTzE1x8xaxcgWQhPILAoMxtWZptmal0W4=@lists.linux.dev
X-Gm-Message-State: AFuF++ktdTckwileoqxWxqzkYdpYNGc1bk54VNPfSyZxxdECkF/JmXp6
	quQnuGFTmK6NCAFEOLCCu9qIFhKbaoV+ILGrb8/CG+oISnYNJj3FNOwNJyUVjBTFCoWk7JP+4tn
	VGsnIWZltMs3dtqaUdFAu46309zFmZ9s0qeHgB9gA
X-Received: by 2002:a05:6512:1595:b0:5b6:4ad:d6bb with SMTP id
 2adb3069b0e04-5b8b2d4fbc9mr14863e87.16.1789409555616; Mon, 14 Sep 2026
 11:12:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914174521.832575-1-fuad.tabba@linux.dev> <20260914175832.2A2D91F000FF@smtp.kernel.org>
In-Reply-To: <20260914175832.2A2D91F000FF@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 19:11:59 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwfY++rZNMmWvAAzHMLbGGy9NpBjAPaMLD_n02Vabx63w@mail.gmail.com>
X-Gm-Features: AcwNN1VDuXzIFAxU2JP-AJgVJDeNayVdctVdg6EJ3aLm09WSanwCKKM_HnhYcYk
Message-ID: <CA+EHjTwfY++rZNMmWvAAzHMLbGGy9NpBjAPaMLD_n02Vabx63w@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Reject the stage-2 MMU pointer hypercalls
 under pKVM
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Sept 2026 at 18:58, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] Hypercall handlers `handle___kvm_adjust_pc`, `handle___vgic_=
v5_save_apr`, and `handle___vgic_v5_restore_vmcr_apr` dereference host-prov=
ided pointers via `kern_hyp_va()` without validation, allowing a malicious =
host to corrupt EL2-private memory under pKVM.

All three are correct, and all three are already being fixed.
handle___kvm_adjust_pc in [1], the GICv5 handlers in [2], and the rest
in this patch.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260914065136.3418404-1-fuad.tabba@linux.d=
ev/
[2] https://lore.kernel.org/all/20260817103228.1203140-1-fuad.tabba@linux.d=
ev/


> --
>
> commit 6af3790e411879ef8c99b26ae2afdc619730e489
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Reject the stage-2 MMU pointer hypercalls under pKVM
>
> This patch updates five stage-2 MMU pointer hypercalls to reject executio=
n when
> pKVM is enabled. It adds an is_protected_kvm_enabled() check to prevent
> invalid execution paths.
>
> Link: https://lore.kernel.org/all/20260914130152.F0D5F1F000FF@smtp.kernel=
.org/
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 9a3b92e626adb..4b0d00e55e2ea 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_adjust_pc() {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
>
>         __kvm_adjust_pc(kern_hyp_va(vcpu));
> }
>
> [Severity: Critical]
> This is a pre-existing issue, but does this code allow a malicious host t=
o
> corrupt EL2-private memory?
>
> The unvalidated host pointer vcpu is passed directly to __kvm_adjust_pc
> which mutates it. An untrusted host could invoke the
> __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc hypercall with a crafted pointer (e=
.g.,
> an EL2 private-memory pointer which is idempotent under kern_hyp_va()). T=
he
> handler handle___kvm_adjust_pc directly passes this unvalidated pointer t=
o the
> underlying function, which dereferences it. This could allow the host to
> overwrite arbitrary EL2 memory or leak its contents into system registers=
.
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_save_apr() {
>         DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
>
>         __vgic_v5_save_apr(kern_hyp_va(cpu_if));
> }
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_restore_vmcr_apr() {
>         DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
>
>         __vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
> }
>
> [Severity: Critical]
> This is a pre-existing issue, but can these handlers corrupt EL2 memory u=
nder
> pKVM?
>
> Similar to the above, the unvalidated host pointer cpu_if is dereferenced=
 and
> written to by __vgic_v5_save_apr and __vgic_v5_restore_vmcr_apr. An
> untrusted host could invoke the corresponding hypercalls with a crafted p=
ointer,
> allowing a malicious host to corrupt EL2-private memory.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914174521.83=
2575-1-fuad.tabba@linux.dev?part=3D1
