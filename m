Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA2C2D9796
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773746495; cv=pass; b=Xx7KLD1k41fmLb5GCHi43riawzDUWjsWIoq33ewgkQeItNBKqAU1PLGehLYyfW4L1b+XLhSBVyzMN4+SoLY/dKHVWSncrzNrA/KJE00ugGbduF+5djzC9twQ3k04lMGzcXQ3kOeiRukDl2t5cGA41oEgkiJ7gvA0PF/e20gkjFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773746495; c=relaxed/simple;
	bh=20HYXWm2pRCezep+GdRTcpfi7wuAa+e6uTWebUv8qNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Co5GBG8AbGSRoQ11wQ0vd9o0C6m0rOMqOTT26z0GVSDIYrUF5Gs5UjL66/hJB0+xT+9xN9vYtM+dqejpMOKFSXQuxhSjsweXG4amskFgQjV2sbxpJN4dOmz0bPnXR+wAxXeoEikkUXeY3XBB0v/iNJzmYCWoViZanC9JDKQV/GQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ykc7cuN1; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ykc7cuN1"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-509062d829dso433561cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 04:21:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773746493; cv=none;
        d=google.com; s=arc-20240605;
        b=HArYVrIjXQyEkmRrKJvWLDMK4Ox7xc6kBviQThFWBgi+QQv75qTqNsCQCFcUTkLmCG
         IEReKYpRzDj9yFrvVuoNPgD92H1rpgSkDOTTICDUggVrplEDRY0gRDONhWT+SCgjACYI
         KhNM67ap26flCqQI4Ummj03EQ94oqvzlveCephiSMHYdVoeG64tOX5jQIaNZaD9iQLKj
         0tYApnssuyvgcXqMfOvAw3TcEP0Pbf+ro1Q0/keBYhADhJ1ypcmadlAHU9Yip2gAzWJF
         ScxbNemfLvuMg+9bWhrbUxqCFmwxebW/YR13aLA7cbbX85fK61GEzlFDoRvvx4zIMcWO
         omPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IIinQPgAdcS1WMa58LwQX+0utCWCpOx/mVW8onE7nR4=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=PnwADW8aQDNkWqH3EeP3LAjeUDqVa62uiaTkjULniebLcnLQ4gr1Dg5QIGwd/P7i4i
         hwCOgc2wz4kOvXUra2ryMsD8ZYxoJJefwyfzhH01OX1FZd+tMDCwQjraSNOQ93eaz9Pr
         z7eaaqSiIknqsnKZu/+IiW9/cRbP7vREEf1TpCAQpk3rn2gho/2ow6W/0QyfOHqPLyp2
         8Oz4mhrWpix4f36honYGDDnUZlp0Uc/o6aH0eO+/N5SVQuoN1KPKXSszZPv46TR2s2cf
         NxhxQXnZemh2PiPLPaXnCid5bpDKvgJe+K8PB72dG6dAPzqIqJeOETA8UvAcwhyjYroV
         BNiA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773746493; x=1774351293; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IIinQPgAdcS1WMa58LwQX+0utCWCpOx/mVW8onE7nR4=;
        b=Ykc7cuN1au08aLhFbmFO5iNLWxxyBBUdnrN/paDUUzKOmxJzrx9b+CKkUQoOMLOcTs
         ZbWLthVTWVh/S1syw3mO8TqykL9d1WGOKZW0MR1hS4xmdpCYT/b5NmD66f9GrT2wFcz9
         eWIxEFD1PE3z39goGTI1h1lmGh1qJIkMwMDEny5/+pAdvnQdpYNb5+DJgPhIpgUVyRFP
         tw4Uses6oiOH4xOZnZVJQVTWqpEMOD9sSWvDq4rOV+j+eSqpOaMyl47uOP6JbQ8T9TgG
         4WJaBFc6Uvp6YnPWFZqIcfroFIO8LFOSTwx93Pn2r3Q49Ab9bPhAJTuKcFUJE2JziKf+
         NNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773746493; x=1774351293;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIinQPgAdcS1WMa58LwQX+0utCWCpOx/mVW8onE7nR4=;
        b=V1NmTTCQqVRdy0asGUhxXwkBLsTP6AScPrA9qP7cSjsFkUFb95Qk2T6kI7SAL7/Xf+
         eMIZWLxLXzTHF9+rH9Ek+bW5dkNNs7ORfmaLqCOJH9uwyODMMm+GmpLXhy5ihjtpIt4e
         r2TsTIqQmJWMP5hpt3/JHhfbCOMxt6ddKi1qBmKpcze3zACZLdPJb2P4qSS4vIPAxoix
         Dp9N1XydSV4w3mTfM7Ws7jXVTwWXeaf7Sy4gulPw4nmq9YAjeiRhCHhY5hCiqsBLXRHn
         XHdJmrZ/EvTGKWSdMX+HwGFQYehhF92ryGadHkJa26Ctf4q5BYMTJyooEGSSs1OKxbub
         lLiA==
X-Gm-Message-State: AOJu0YzKsaFpS+v5kInt317hzOI+Ypl/cqNswKoG1wJjpd2Qh49nIqv1
	ubQBIxDLcP+Fsk59w98a7Evu1IkH3dr+RBph1yftUkSUx1NmtnKg+B3GAFvkpM2FDsYD4sUquxJ
	tPWxardvUHdLw9rhaCQ9HXd84KDCWjIPaNWtu7TzX
X-Gm-Gg: ATEYQzywZPw0vkcfvHaX5t1W57v79DgpHBTsd1hjPy4TFJlh12R721bBWYve1Nxp6E3
	8uGFOOxaRxaqioMPes61tbZxfSFAU0WbB39HrXpQ+4r7XlR8IxZCPH0boNmQxX10Me3D1QU6hT2
	5ZvEFu9MJsVXVoYJH9hRu7rPSGoVuUixDSInAscHjBcw1Ilqdr1926hfMoXBALv+ssre3IhzBPT
	IziVGc2wQBYWSyR8A9cNFjVMUaGtAndk3OVuDFVD1gXDzi9EMZzyahANS7o3qqc9DAV8UkNpXSo
	ykFnTfaOyo0JPdOOqwC8qfDgRU2NLbl7ps07C3S8NDaZl6w=
X-Received: by 2002:a05:622a:3cb:b0:509:2cd4:b705 with SMTP id
 d75a77b69052e-50998c18cb5mr14530571cf.4.1773746493105; Tue, 17 Mar 2026
 04:21:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-7-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-7-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 11:20:56 +0000
X-Gm-Features: AaiRm53-qbf4XI9ulNB_-iuJQm1ePeG7PGYgglAHC_yoHQxA9dWx5fdfSL94zik
Message-ID: <CA+EHjTzeqdkn9wawGRo7pT6px8nmjByxYVcvawCFhC=LWm8nOQ@mail.gmail.com>
Subject: Re: [PATCH 06/17] KVM: arm64: Kill write_fault from kvm_s2_fault
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> We already have kvm_is_write_fault() as a predicate indicating
> a S2 fault on a write, and we're better off just using that instead
> of duplicating the state.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 12c2f0aeaae4c..86950acbd7e6b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1711,7 +1711,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>  }
>
>  struct kvm_s2_fault {
> -       bool write_fault;
>         bool exec_fault;
>         bool writable;
>         bool topup_memcache;
> @@ -1799,7 +1798,7 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
>                 return ret;
>
>         fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, fault),
> -                                      fault->write_fault ? FOLL_WRITE : 0,
> +                                      kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
>                                        &fault->writable, &fault->page);
>         if (unlikely(is_error_noslot_pfn(fault->pfn))) {
>                 if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> @@ -1850,7 +1849,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                          */
>                         fault->s2_force_noncacheable = true;
>                 }
> -       } else if (fault->logging_active && !fault->write_fault) {
> +       } else if (fault->logging_active && !kvm_is_write_fault(s2fd->vcpu)) {
>                 /*
>                  * Only actually map the page as writable if this was a write
>                  * fault.
> @@ -1980,21 +1979,17 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  {
>         bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
> -       bool write_fault = kvm_is_write_fault(s2fd->vcpu);
>         bool logging_active = memslot_is_logging(s2fd->memslot);
>         struct kvm_s2_fault fault = {
>                 .logging_active = logging_active,
>                 .force_pte = logging_active,
>                 .prot = KVM_PGTABLE_PROT_R,
> -               .write_fault = write_fault,
>                 .exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
> -               .topup_memcache = !perm_fault || (logging_active && write_fault),
> +               .topup_memcache = !perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu)),
>         };
>         void *memcache;
>         int ret;
>
> -       VM_WARN_ON_ONCE(fault.write_fault && fault.exec_fault);
> -

We can't hit this warning anyway.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>         /*
>          * Permission faults just need to update the existing leaf entry,
>          * and so normally don't require allocations from the memcache. The
> --
> 2.47.3
>
