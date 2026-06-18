Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CBB3E1CEF
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781775664; cv=pass; b=pSsUzE5qYKOqmlrWVDwV36AodA8BWgXNppSvuEVVLNql9R48IWr3r+O6vdO4lZnzU5Cper6yL8nY0HXvQsOOvyQMztXuywJKcsDwGmack1OAhQm08nY2xi5p0xSPRLJTBalnflg2rqmusL+cXCBu6O/xNJkVnAdetOThYODaXfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781775664; c=relaxed/simple;
	bh=muaRs4souuC9L6Um52i9Edo0YD1J/DTF6k3Hdh3bmBk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g0581x4/+sbHKKFksv7hKQUHuSSO9QQ6jdXwc4nMJvY7zDhN5JdihbeTgunrhcGfzXouktpPVjGCaDZaL1VyX9J6jljVrelEAIBEZOhYW+Prja7G+lQy+FfYgUGMOCLVmC6SMk50CGy013w20RqyihdkzvXb0Kz7fb88W80Mpwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I92GxlNN; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I92GxlNN"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ad4c101545so6410e87.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 02:40:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781775657; cv=none;
        d=google.com; s=arc-20260327;
        b=Ha0EmPDCLvqc/y9L5bkVbtKqhBOO0UWBppvJ5vg7Ybuxa4zbuQxOQ/GqPiiW0jzXTL
         iSI7sPSLGKjrQKxiJWrMUJ+64GKAYG9/oA7ndkC3nQKuQu4bjL4U8AE74Qpm6EGqXw3W
         H591vXt6TPkMYqhXciG+MyxWmp1XZvvUOIad4KlVq2R6mhIVoJfL/nsS+gGCa87nTFsf
         5O7VPv536gLkRWziFvhjZbbz0iCLvA9Q8+8OFU0hFTB2zGa5jhPcDo3y0tPixjuIeKX6
         pdAIpkDuQvp/O+qDh/ezNu8h1pOiVycZX410QBbQhYltY/ZZH+7tFtNHP14XbWNzxxia
         T3Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NCuMGqE9qyjuURJEKx/Q1SDggmAHo1iFvRp0M1Zowyc=;
        fh=0M7ymQNAkogJh8kSGTcWhV2I4s7lD+wXP8NqsAIcq5k=;
        b=BL5POEUwH4kFL4JEkw/cTaq0wstgCqqlSv0RQLqUaaXSrAfKHGPBKOX+HjlHAM+P4l
         VCFAddLMXCviQK3q/j3bqSQKb2GMhUxL85RCD95bMXu5xlZfjXuENssQajuyk28sCgWI
         CnuhrTa7dIqF5hosqwmVDfRug4v/gDQfiGlxbc5JZNiq7JbLujK7v8eW7Z0cbtBT5JS3
         +GcF8q93daR2Q17t0RRkzhb2lPBg43hpio63LIify6QhvsfHhnlbBpE1xADhfVnw241q
         CTlhyJeKYAqfQGoCaERR5/4BTZ5GFuvUzzzyViPHV/PJWVdZ3m/aybPwOGa07OoG2esF
         SWbQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781775657; x=1782380457; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NCuMGqE9qyjuURJEKx/Q1SDggmAHo1iFvRp0M1Zowyc=;
        b=I92GxlNNrEzxPk5xc0gjTuE1IX2pXrcIA/uPkJpxtdCTk3gCitgfAkF0dS7KMh//4V
         VUSBF87vpvToMbHFt4wX4X8BFfO0kIvkiXLr8vmxSvjoM/q6lO/oAfLbQ9LBjETAyCTT
         6rPhWXMQs1RRcNy0f4Se5ii4dBLOVAA1pl3GIRkWJyuP+OLDTuDWUnLddAZmWia8OLWm
         5nRomgGOqvyk7YdLyHKOYJ+H0tmaMCkTM28qVKYcszBuA64vSVZt1HUkHE/F8gg11ppG
         RXs668i1HYBJUb82qeCiMd/0LZyLDVezwUsWtyCNMstY2pghYO2k3ZBBB6N6F6BBanOe
         BhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781775657; x=1782380457;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NCuMGqE9qyjuURJEKx/Q1SDggmAHo1iFvRp0M1Zowyc=;
        b=n/sZCAauOgp/aCnGXzfn66s5b+Q/DmDSxX42zblayTQ+PjmL6+i/Kh97R2wos4dGBt
         IgwNMbdD13sqXEFTy/uIJscbEfHvVLZ9HAFI+SFW3W+Bktzic5c8SR8R7XPmSatt3Txh
         vUnA8I69AjGR09UKWwKX1YqEyoR4swwyjF3AGa4t4zQREhYUt/WYGmgUgOCz9vqlPwN/
         5l9OSQxNK2yGhGLo/5raQaFDUSHm52oE0mOKFdbOO6gn7TD17WvT4VkAvo3swjulEk+2
         +687uuO3WToDL3OkFAwUbcZkIVAj0Ecxs9LNaMA8bXhsgmoUgYMl7OsLxnfLYO5LuHXZ
         QWAg==
X-Forwarded-Encrypted: i=1; AFNElJ9HruvlmHjK3tM5EEtykiyoAEiDSPQb2WUi1yUT3N1/twqf98XMAvCoIrM6VS72CwnFZPl9UYc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz69DS9rE702sarrryj/eol1iy5a/pjOB3rP37YgBGWfrbiYLLS
	L45pNFtM15+99YEPKq8lz6bAfk0xZTa1EfEa/Vpa2zNE9oAlTnxO5AG3dHtfOjH0ZuZlMvrwB4t
	FNDbOHA/0v+xyZ921sub8l1S3hV3DHhn5F9BKzEvGQpDLHqPbvr8OZ+VMwZE=
X-Gm-Gg: AfdE7cmdD8PPOeZ3YJc7OnZkL9bjeh8sM9MZCbI0GPB6dSCErXdP2/dWKLtlKmtNOLG
	NWkf4uHaRB0qCAjSUE8qK+XoL7VBw1Lo/lJwIhbgu5HN/b4WkqPrFyeLwOSHKlbXzx2qtazBoeI
	xSqyeobdsXZCu7oNFMKDn0QscnEjoUUPY4x9xxLHFGQ9Ug70CAfY7zN+IfXHmVlxHTiKMWaJ9J/
	3JLwHwZdGV8Qz8yOOCcNWuszIFhsH/KBzFLk0LDXKenDn4/ZPHLMp04erxPPCnrB4KBlaz0LlGA
	8MUlzo/9
X-Received: by 2002:a05:6512:3e24:b0:5a8:6646:d7b4 with SMTP id
 2adb3069b0e04-5ad4ee75f16mr99922e87.1.1781775656442; Thu, 18 Jun 2026
 02:40:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260618090128.3913688-1-tabba@google.com> <20260618090128.3913688-4-tabba@google.com>
 <20260618092223.45D231F00A3A@smtp.kernel.org>
In-Reply-To: <20260618092223.45D231F00A3A@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 10:40:17 +0100
X-Gm-Features: AVVi8CdwpCZOAk7Uhts5s_1DWseHRrjXQYyhpm67bkeDIKRKDsz96YtE297TLEU
Message-ID: <CA+EHjTxwco3D3FNg_XtkjGY3R6eb+EirTKJPyrjc+nSjYRuhmA@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Drop redundant READ_ONCE() in pkvm_hyp_vm_is_created()
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jun 2026 at 10:22, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Teardown sequence inversion in `kvm_arch_destroy_vm()` causes me=
mory leak of protected guest pages.
> --
>
> commit 3c4352fb45fd315836f7f7aa2ad63af580a902d7
> Author: Fuad Tabba <tabba@google.com>
>
> KVM: arm64: Drop redundant READ_ONCE() in pkvm_hyp_vm_is_created()
>
> This patch removes an unnecessary READ_ONCE() around the read of
> kvm->arch.pkvm.is_created. The read is already serialised against concurr=
ent
> writers by either config_lock, slots_lock, or the teardown VM lifecycle.
>
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 67b90a58fbea2..008766273912e 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -185,7 +185,11 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
> >
> >  bool pkvm_hyp_vm_is_created(struct kvm *kvm)
> >  {
> > -     return READ_ONCE(kvm->arch.pkvm.is_created);
> > +     /*
> > +      * Serialised by config_lock/slots_lock, or by VM lifecycle at
> > +      * teardown, so a plain read suffices.
> > +      */
>
> [Severity: High]
> This isn't a bug introduced by this patch, but since the comment mentions=
 the
> teardown lifecycle, is there a teardown sequence inversion in
> kvm_arch_destroy_vm() that leaks protected guest pages?
>
> Looking at kvm_arch_destroy_vm() in arch/arm64/kvm/arm.c, it calls
> pkvm_destroy_hyp_vm() before kvm_uninit_stage2_mmu().
>
> Because kvm_uninit_stage2_mmu() hasn't run yet, __pkvm_start_teardown_vm(=
)
> is not invoked. This causes the __pkvm_finalize_teardown_vm hypercall ins=
ide
> pkvm_destroy_hyp_vm() to be rejected by the hypervisor, and the host clea=
rs
> the handle via __pkvm_destroy_hyp_vm():
>
> arch/arm64/kvm/pkvm.c:__pkvm_destroy_hyp_vm() {
>     ...
>     kvm->arch.pkvm.handle =3D 0;
> }
>
> Subsequently, when kvm_uninit_stage2_mmu() does run, it eventually calls
> pkvm_pgtable_stage2_destroy_range(), which returns early due to the clear=
ed
> handle:
>
> arch/arm64/kvm/pkvm.c:pkvm_pgtable_stage2_destroy_range() {
>     if (!handle)
>         return;
>     ...
> }
>
> Does this sequence skip page reclamation and unsharing, permanently leaki=
ng
> all memory donated to the protected guest?

Not a leak. The reclaim runs before kvm_arch_destroy_vm(), not after it.

kvm_destroy_vm() unregisters the mmu-notifier before calling
kvm_arch_destroy_vm(). That release path (kvm_flush_shadow_all ->
kvm_arch_flush_shadow_all(), nested.c) calls kvm_uninit_stage2_mmu()
-> pkvm_pgtable_stage2_destroy_range() while the handle is still
valid, so __pkvm_start_teardown_vm() sets is_dying and the guest pages
are reclaimed there.

By the time kvm_arch_destroy_vm() runs pkvm_destroy_hyp_vm(),
__pkvm_finalize_teardown_vm() therefore succeeds (is_dying already
set, no WARN), and the kvm_uninit_stage2_mmu() that follows is a
second pass that returns early on the now-cleared handle. A pVM
teardown is WARN-free in practice, which wouldn't hold if finalize
were being rejected as described.

Cheers,
/fuad

>
> > +     return kvm->arch.pkvm.is_created;
> >  }
> >
> >  int pkvm_create_hyp_vm(struct kvm *kvm)
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618090128.39=
13688-1-tabba@google.com?part=3D3
