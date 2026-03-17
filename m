Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDF437DEBE
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 18:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773770517; cv=pass; b=TO5ud7tmmRa4sqbOrb5zsrcqnLWRnpu4bJtY82L77gNbJuzoehWlv8pPnZVX/Xa5h6QEIFdRNIj1J9dYQ/WuN0gcDRSspuYZC6pdRFHHXDyQjNkYe0CMLNZgiuPnt4GmoPNI0Ppbs2bwvtrbqYbWsz4pqe2cG4s6kjCz925DF0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773770517; c=relaxed/simple;
	bh=btI93VIfdRIIOn3aJCp2bjHj3jLELmWN9lEdzaaCIOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q8FkdkxUJu5CV0zuOocE8J8UBZ0NhsfhqsvR9JZXVhypLzPygpjx0o96OQiyLhUugP0d5swghwB+w6bf0d1rvae3eR04ZuAfE90h3L6MgXFsGOUrobJT3Q+KknrcGsc0mDghOubmVhSbdlrUty6eOOhctX3W5DbRVRvnBWtGUl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qntoIoKt; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qntoIoKt"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50906a98ffeso65991cf.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:01:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773770515; cv=none;
        d=google.com; s=arc-20240605;
        b=iwcksnIb/A0lXNPanOv/PINuqTZUWRvXLicpxS2Ege0IB5MpH9n2UJY5S2w+eRN/lA
         JyJSzSwnSO72fCZUup06RVyl8x3gQgIGFmDNeoi1M8GFFm2xJ5ruwALWelr/hSPUnynm
         G5dHgswm1tAnqx043pt/qDjWubwKx5p0ua0ueXqDM0yQcLNQU4Nqv3R+20PQ5f7/qUEH
         qvT6O59fyZU5Fw0Y3Zhe1fMcBRN+LcSLs7JCdqlvCxF4Qk9I4DnA0Dg52lIkqF72C78z
         riNOG2M8gSypt4km1bJnB3t+EtZnPd5kibVTy6WFGgPY2m66OscfnPSmburf98zc/GE1
         0VDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3njzSf0GHZnU+vfRoNiucsFc5a4L5o10JyQzwrcZWQ0=;
        fh=pgrYwAs0s/mclnjeShYKPspuriW1/hjTjUuD2vzoWXc=;
        b=Xmvk8XMfqpVgeJ42VxchSqP0ZmL1C7LP8UJmhyi0wHOnusdCPpzwUHMuvE+gW9bLed
         yl2mKLMHM3e7ZXVFpMy/7feKqth1Jb8MBi5aJwzLDBEuUS6nAjYA4pWj/sw5ccL96ub0
         UKeq74WVgdzLzz127JkARlHB8yFF3yBkw0cYBP1qdvAMjcsI5phqw0AZq+0Id8Ak+59d
         EL7mit1w0+gn6XgrZjE/3QzgBDot5q6TNBRHbggyu3uN9pGaH9aQ0+9ouYKdHWVmQ7jc
         IcrlY0oKxkE4dd7e/4YCzXvJbCVWkvpsVCoFg3oPxy9m4cdDGNUrGvL0imo0RIJ8/DZy
         hVfw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773770515; x=1774375315; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3njzSf0GHZnU+vfRoNiucsFc5a4L5o10JyQzwrcZWQ0=;
        b=qntoIoKtsuYtwkcnUKUaBiKJYl65+JcbN5vb52GCpZUGPwTb+Z3F9CwqeTKJIVc/63
         hdibdws5+CIXqgz15BFV76jBH+mYFby+vYnuoaIWhdLUDBpT8JfJozUvQJh4iILQNfzW
         YBV5t/++A3JXlvCoYsDVNSAFIuh5EGAF1Gs5wvRocKgewtVC0ZJeAxinZ/Bz12xWoX7v
         YcPIvTatx+pWI09dhfPw6QW4/a1ucPWqShBNF0BBJvn6M+IueCuXU3nSdGZqqNy4hq48
         VfrXKAX1g6CZu+bL6AlxhH/koNulRsUVCqBW+2rxavAllj6hJMjv6UJJBmJN7xnifHLb
         TQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773770515; x=1774375315;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3njzSf0GHZnU+vfRoNiucsFc5a4L5o10JyQzwrcZWQ0=;
        b=QRoSEHfzHQ+BMwbpwOLgRkJAIfO8DltshuC+m1KDEnlRHtsc5nQiSCOi5pV94VMEvK
         S9X5Wgx+QyoOb53FxC6afgz7V6MglvzrR8Zp1dTU6Zulutys/Fo/NnZTZlOsBdHKh0KU
         TgqXU2M48cKtyk8cRSBUAuGb5QFWdb1lLFbOtZZJqt1ZpRnKNC2SflvKA4tU0P7EpZK3
         VBW5UvUiIRaq3i2JcoSKAjSPwpkx6sGDYklvm7P8xS9SvKI0MaGs4wTipGwuauZzHQ4A
         hY/8Tm/jhyrczB8TRQPrs9oeEeYMLnGftrFN61NVl5z+y37oP0no54530MfHVu2t0vF3
         R9Rw==
X-Forwarded-Encrypted: i=1; AJvYcCVseBF0vZ245J2vViRWSMLkdQTxiipIP3yhT1aRozOrN1/l0QWZB6BKQ8Z3dJAtmc2cSYU7mJw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6lU/6QAs45UfL55eo7yn2yGOTVKqZOXVt5eSIg+0ik+rEFwjm
	zoKYF/VAI9wAJs8k86XPUBlelSupbOxdau3c9Tp9CtBVe1otzEN2sUd3u7gtKj0/GMestmhdbeN
	//9rRqkMm13mIaEQRQ4QkSp7G/jCC2ILD9rumGUKe
X-Gm-Gg: ATEYQzyUuV+NIonjmwZ+EqypoYTttXK9it0OfI0+h9goSyqvEzxPr+nt+MFLOq20cAR
	DNyYFrdULKbwuM+EeP9u+MF0o/gGW9HYaMGEeMwKsQENzwj63E7weQbNBLjNoC7PKo4Cd5TsIMI
	fgd/j5RQWdJjlm9hnc99LfBcEtXO4N9Rl61swrYujXHFW6nrD4bSaXQGaLywgqbd2LQF4EHyK+p
	DhvE0GNVfHmH5CqBVDeyKknLQdvr+WBtp2oc+mKMiI2BdsYdx14L0ySKrTT1sv4RTfvqEMKfMk+
	e+c7n4DG
X-Received: by 2002:ac8:5750:0:b0:509:21ff:cd49 with SMTP id
 d75a77b69052e-50b1470d02fmr1266501cf.4.1773770513528; Tue, 17 Mar 2026
 11:01:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
 <20260316-tabba-el2_guard-v1-3-456875a2c6db@google.com> <20260317174013.00007622@huawei.com>
In-Reply-To: <20260317174013.00007622@huawei.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 18:01:15 +0000
X-Gm-Features: AaiRm52Ar1iyiv4x-nvNKaVG0bbkheBEtDjmXY2f_mDcbzvUm2a4Jch_nfn93sc
Message-ID: <CA+EHjTwShV8cEtKdva5Ony0=oOhoaj6uQ3SP7tAia08P4pYkhA@mail.gmail.com>
Subject: Re: [PATCH 03/10] KVM: arm64: Use guard(hyp_spinlock) in ffa.c
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Jonathan,

On Tue, 17 Mar 2026 at 17:40, Jonathan Cameron
<jonathan.cameron@huawei.com> wrote:
>
> On Mon, 16 Mar 2026 17:35:24 +0000
> Fuad Tabba <tabba@google.com> wrote:
>
> > Migrate manual hyp_spin_lock() and hyp_spin_unlock() calls managing
> > host_buffers.lock and version_lock to use the guard(hyp_spinlock)
> > macro.
> >
> > This eliminates manual unlock calls on return paths and simplifies
> > error handling by replacing goto labels with direct returns.
> >
> > Change-Id: I52e31c0bed3d2772c800a535af8abdabd81a178b
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> See below and read the cleanup.h guidance notes on usage at the top.
> Specifically:
>
>  * Lastly, given that the benefit of cleanup helpers is removal of
>  * "goto", and that the "goto" statement can jump between scopes, the
>  * expectation is that usage of "goto" and cleanup helpers is never
>  * mixed in the same function. I.e. for a given routine, convert all
>  * resources that need a "goto" cleanup to scope-based cleanup, or
>  * convert none of them.
>
> Doing otherwise might mean an encounter with a grumpy Linus :)

I should have read the cleanup.h guidance more closely, thanks for
pointing this out.

> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 86 +++++++++++++++++++------------------------
> >  1 file changed, 38 insertions(+), 48 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 94161ea1cd60..0c772501c3ba 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -239,6 +239,8 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
> >       int ret = 0;
> >       void *rx_virt, *tx_virt;
> >
> > +     guard(hyp_spinlock)(&host_buffers.lock);
> > +
> >       if (npages != (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) / FFA_PAGE_SIZE) {
> >               ret = FFA_RET_INVALID_PARAMETERS;
> >               goto out;
> > @@ -249,10 +251,9 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
> >               goto out;
> >       }
> >
> > -     hyp_spin_lock(&host_buffers.lock);
> >       if (host_buffers.tx) {
> >               ret = FFA_RET_DENIED;
> > -             goto out_unlock;
> > +             goto out;
> Whilst it isn't a bug as such because you increased the scope to avoid it,
> there is some pretty strong guidance in cleanup.h about not using guard() or
> any of the other magic if a function that also contains gotos.  That came from
> some views Linus expressed pretty clearly about the dangers that brings (the
> problem is a goto that crosses a guard() being defined and the risk of
> refactors that happen to end up with that + general view that cleanup.h
> stuff is about removing gotos, so if you still have them, why bother!
>
> You can usually end up with the best of all worlds via some refactors
> to pull out helper functions, but that's a lot of churn.

If I respin this series (depending on whether the maintainers think
it's worth the hassle), I'll remove all changes that just add churn.

Thanks for having a look at this and the other ones.

Cheers,
/fuad


>
> Jonathan
>
>
> >       }
> >
> >       /*
> > @@ -261,7 +262,7 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
> >        */
> >       ret = ffa_map_hyp_buffers(npages);
> >       if (ret)
> > -             goto out_unlock;
> > +             goto out;
> >
> >       ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(tx));
> >       if (ret) {
> > @@ -292,8 +293,6 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
> >       host_buffers.tx = tx_virt;
> >       host_buffers.rx = rx_virt;
> >
> > -out_unlock:
> > -     hyp_spin_unlock(&host_buffers.lock);
> >  out:
> >       ffa_to_smccc_res(res, ret);
> >       return;
> > @@ -306,7 +305,7 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
> >       __pkvm_host_unshare_hyp(hyp_phys_to_pfn(tx));
> >  err_unmap:
> >       ffa_unmap_hyp_buffers();
> > -     goto out_unlock;
> > +     goto out;
> >  }
> >
>
