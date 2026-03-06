Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B033C30EF65
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 15:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772811924; cv=pass; b=AAJJ/fzmzMZC9lUDhvHuAh/4WGcjmayMHMgB3ATrf3y19s9NH4YG1tZav7KshF/YAeKVf4oOZ/I0EaTKIBX3P/FhOmFUuAkMLTmK+YKgYYjq1q+5EEDqGNPfy2jtMBL9kkPzo6FCUQysKIyGG2ene4RV42OhBlvF22Pg7rVml+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772811924; c=relaxed/simple;
	bh=hsriqer5Wp7EhxGKavjbKgHNP6RubiuMiTVAUlMf2cc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B7u5YcRj8596eLVkqffPVtWw41lHv87liPDUSRzbAschMlhktIRT5MxL6ByEDdAHV0nEj3O272LyQUUw/Xk/TMqMUe6kcowA1JPWcMSc9RzqpnJCQtI9HXmCHSIRQIXtQGXL+wYa1CHSu8cdPolIRF1UEfDUy91tbaLAdf4Qx0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3gAakK0G; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3gAakK0G"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5069a785ed2so439451cf.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 07:45:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772811922; cv=none;
        d=google.com; s=arc-20240605;
        b=h6xXqWwDMtxP7UPpnCFjlO9fdIObfEbpyttnO9XYRnv6NSVgDnmqID877bCDj2MyI1
         +IQ6iZMvSqTWpoN4jgTVJXXX/5BwQjtqDGynovQpAmwpL89TK1yHgtJH7MIxsTc7K0Sx
         RGqfIX+TbPS8zg27isDv6Qj+WNMEK6wa2iqFLXLcdmzgwjtrgr8W9xxItx74hXAxt/ac
         HQSTsoHslBP2Q29QLzCk7wWrihEphloFXUXKoUZk6MyKS7k8fJadw4EGjtXVsfOWorFo
         Eohot/WmTx9jpr1+JfP2Yf8DfN3XR1w817l/hG2hl+a6xvbGsOQ2uOjrNurmi/trd3DH
         8PFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=unhg1T2qCPKxpfY/PSePUJ4/CJHWOdFGonXXRJegCXU=;
        fh=r35nXO34ckQkreQSZm7PGABGrVloDMECuLYvrO9w5bk=;
        b=dbKvf+gmIuXWIHTWjj9flAaBk61xsiMiZi7u+4KTdrstv+7UK5V3YimVEWddrTJYTi
         yQWuKndZ1OrM1jZCQiL5+rhLcKvuOhEgTY81TvsvH7bvfxVR4723RTUHfO+QhYEOkT8D
         +CDfCNsN3Kn0Kqp3LEJQBOixyFU7QJs8cwQb4HYYe8mAHeRMIuc3DRoBz16JrPsmGvDr
         YxJ6HG/rDzHdsPTO1CH6v60avya08wabdPyPdQRYKeG6WjMh8SYGzhuiGfBO9eqHdoRE
         Cll5xGUIovvxYvZiJjDjM0WR3mZT+Rg/0lSYOeIJEeouwJ4obQa1dCEiJmm57ZL0ysqt
         O2DA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772811922; x=1773416722; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=unhg1T2qCPKxpfY/PSePUJ4/CJHWOdFGonXXRJegCXU=;
        b=3gAakK0GXlpI7sPVk+MyAk0TkLO1j8A1hk4kiWBoVsBVMns3H68fTPxjCR3kyeZTmY
         t+LBzRGhbRCDGul8/aRPu0SIWyDZmIavCmpABRt2YhqF2Mnisaz+I+Mp9S54kuxHHjMo
         1z6eCKFPG8zK+UO867P4E8tflk2ECGlKPkltERBLvMjTdv9yPQCUK4DleyFaZVFqk+Ic
         BmGQRCG9DcChfDfDyeSFlfSLwGnGsWYtcU4Strms/DNBSFDftUKGeiVkj+lHpfi3n+mU
         Gub/Iru/wrt4qsf4tIzYUJ1fgD5n/rNftvjNJCri95VuijSAqbslRKCVY+cjm1SzYpRR
         srMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772811922; x=1773416722;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=unhg1T2qCPKxpfY/PSePUJ4/CJHWOdFGonXXRJegCXU=;
        b=ONh4CvIWbqO+/UR2Qslg/oITj8cagt0S3SRFk+2U5b12RLvmZwev0EC3KxrfWFubsP
         1W7xHOPPaoprwxXdI0A4yCdtjjidUr69HzJz4TZOFdw5r9VTVTNsRr3nN1FeEUfloV/k
         JNabOc0IQylGnlwKf7wxArttUa84O3ZhsL7CFOpReu8lBOnblohTBrylRWsN2oGbXaml
         UUOYGbX5NWFN/jIUCsfeIlcxB5A/goHIIt/Se9p77hg9MlYgOGuh8OUYDVWfYdX5gbrt
         7W8nCvSgSvsWsYaMmCQQzdZ/58wkjpVh//WXcIiFYeWTmUzzn2XKu2r5Bt6xEQUL908K
         l6ag==
X-Forwarded-Encrypted: i=1; AJvYcCVYDfBJWS72FTp+wvIrH3CJk140NpyzC36s1q3JlHUHCo8QzFKlVfsbiaubWxrR7KsNdDlj8O4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPRU1QPzRnnxvhCVI02KZ0s3sEybexmMAXznV/Jvz+GesOfGV1
	UAwvKs2UBHwBeEATWAKOYLgtiQWfWIUYrizszeLOjm6UiQJqJ+2hsxzL0FPzb0JDQvmad8Vj9S4
	boZ95NumX8rQZmL3NolDcVVEOFExkuITGXXTp/mkn
X-Gm-Gg: ATEYQzz/lWF7LlobAbeevdEe91O4Nyj3iy5JMVk9Izco7K3a4971P+AkQfM8MXHfnZB
	BbfiT859+7wiINab6CxapW6aRs1piEjgnQfS7B/M88w7BNua5DybqlAdNSLwojgJfjIVkUSIShH
	ezCxx2t4Dc364L5wmi0ZlAd4HfoQiIIzZvs01Vn84kfykUXPq7qIh4NW5U1rhXEJsf1SdK8Dhm4
	VqHoUY/KfeaPb+qPfMLwbL5GK+WqmTcMvpldTXH9/MdaVaiHZRztIveFFyERwLH38QTw55ARpbC
	9em6k/Nu
X-Received: by 2002:a05:622a:1825:b0:501:5180:3c90 with SMTP id
 d75a77b69052e-508fa666c57mr3491241cf.15.1772811920943; Fri, 06 Mar 2026
 07:45:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com> <86ikb96kg8.wl-maz@kernel.org>
In-Reply-To: <86ikb96kg8.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Mar 2026 15:44:44 +0000
X-Gm-Features: AaiRm52XLBmqNfW9v8Obow2Zg0ILvEXXBAF6YDgU2FBbzIjxzMdGtwXjVc2CnoU
Message-ID: <CA+EHjTzenq_xFwe8K_g1KFbETqndS3FnxPiwBRKrMvrxH4Z1qg@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] KVM: arm64: Refactor user_mem_abort() into a
 state-object model
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Mar 2026 at 15:34, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Fri, 06 Mar 2026 14:02:19 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > As promised in my recent patch series fixing a couple of urgent bugs in
> > user_mem_abort() [1], here is the actual refactoring to finally clean up this
> > monolith.
> >
> > If you look through the Fixes: history of user_mem_abort(), you will start to
> > see a very clear pattern of whack-a-mole caused by the sheer size and
> > complexity of the function. For example:
> > - We keep leaking struct page references on early error returns because the
> >   cleanup logic is hard to track (e.g., 5f9466b50c1b and the atomic fault leak
> >   I just fixed in the previous series).
> > - We have had uninitialized memcache pointers (157dbc4a321f) because the
> >   initialization flow jumps around unpredictably.
> > - We have had subtle TOCTOU and locking boundary bugs (like 13ec9308a857 and
> >   f587661f21eb) because we drop the mmap_read_lock midway through the function
> >   but leave the vma pointer and mmu_seq floating around in the same lexical
> >   scope, tempting people to use them.
> >
> > The bulk of the work is in the first 6 patches, which perform a strict,
> > no-logic-change structural refactoring of user_mem_abort() into a clean,
> > sequential dispatcher.
> >
> > We introduce a state object, struct kvm_s2_fault, which encapsulates
> > both the input parameters and the intermediate state. Then,
> > user_mem_abort() is broken down into focused, standalone helpers:
> > - kvm_s2_resolve_vma_size(): Determines the VMA shift and page size.
> > - kvm_s2_fault_pin_pfn(): Handles faulting in the physical page.
> >   - kvm_s2_fault_get_vma_info(): A tightly-scoped sub-helper that isolates the
> >     mmap_read_lock, VMA lookup, and metadata snapshotting.
> > - kvm_s2_fault_compute_prot(): Computes stage-2 protections and evaluates
> >   permission/execution constraints.
> > - kvm_s2_fault_map(): Manages the KVM MMU lock, mmu_seq retry loops, MTE, and
> >   the final stage-2 mapping.
> >
> > This structural change makes the "danger zone" foolproof. By isolating
> > the mmap_read_lock region inside a tightly-scoped sub-helper
> > (kvm_s2_fault_get_vma_info), the vma pointer is confined. It snapshots
> > the required metadata into the kvm_s2_fault structure before dropping
> > the lock. Because the pointers scope ends when the sub-helper returns,
> > accessing a stale VMA in the mapping phase is not possible by design.
> >
> > The remaining patches in are localized cleanup patches. With the logic
> > finally extracted into digestible helpers, these patches take the
> > opportunity to streamline struct initialization, drop redundant struct
> > variables, simplify nested math, and hoist validation checks (like MTE)
> > out of the lock-heavy mapping phase.
> >
> > I think that there are still more opportunities to tidy things up some
> > more, but I'll stop here to see what you think.
>
> Thanks a lot for going through this, this looks like a very valuable
> starting point. From a high-level perspective, the end result is even
> more shocking:
>
> <quote>
> static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                           struct kvm_s2_trans *nested,
>                           struct kvm_memory_slot *memslot, unsigned long hva,
>                           bool fault_is_perm)
> {
>         bool write_fault = kvm_is_write_fault(vcpu);
>         bool logging_active = memslot_is_logging(memslot);
>         struct kvm_s2_fault fault = {
>                 .vcpu = vcpu,
>                 .fault_ipa = fault_ipa,
>                 .nested = nested,
>                 .memslot = memslot,
>                 .hva = hva,
>                 .fault_is_perm = fault_is_perm,
>                 .ipa = fault_ipa,
>                 .logging_active = logging_active,
>                 .force_pte = logging_active,
>                 .prot = KVM_PGTABLE_PROT_R,
>                 .fault_granule = fault_is_perm ? kvm_vcpu_trap_get_perm_fault_granule(vcpu) : 0,
>                 .write_fault = write_fault,
>                 .exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu),
>                 .topup_memcache = !fault_is_perm || (logging_active && write_fault),
>         };
> </quote>
>
> This kvm_s2_fault structure is a mess of architectural state (the
> fault itself), hypervisor context (logging_active, force_pte...), and
> implementation details (topup_memcache...). Effectively, that's the
> container for *everything* that was a variable in u_m_a() is now part
> of the structure that is passed around.
>
> The task at hand is now to completely nuke this monster. The
> architectural fault information should be further split, and directly
> passed as a parameter to user_mem_abort(). We have a lot of redundant
> state that is computed, recomputed, derived, and that should probably
> moved into the exact place where it matters.

Thanks Marc! Like I said, I stopped after 13 patches to see what you
think, and if this is the right approach. But yes, more can be done
here.

>
> I'll have a play with it,

Sounds good, and if you'd like me to tackle any particular part of
this, let me know.

I have to admit, breaking this down into pieces and seeing how much
tidier and easier to understand it became felt oddly satisfying.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
