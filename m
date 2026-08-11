Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6F53803E9
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 18:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786473902; cv=pass; b=qEiIoDzs5D/anRGaJAq9JUhv6CPARVbQX7wFGiLhS68n00P7JcuYTRmIfflsbeTnYqQrN/jORS6RyuIt2Wp8RDwTgAVisHw6hVfCLgkqzVSgr/iszWJQGJsw8DaCg6nfskYZ2YoqLZjsrqBtexEnjwwDUyJWI2ZXRfFFAr411d4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786473902; c=relaxed/simple;
	bh=qo63QJT3JYi8m1sI/zH2RY9o06wKvLfQ4pHi0tWe8Ro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y8yDmhNQ616FRXJADwIwFe4qi9XXJDP7asqFleeqwJg538d2wxX4M7kqpWwX4fZ87vs99J1Ao6V/fmFiGcnNOlK9pD/rovhGVmMSycYOgopxMPyEToXCTy2X2B4Z0J6SQE8j1j2YQZtReIlPtRgOlqO3TXpmjSYTCtw80lH7iAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bJf3aKYB; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bJf3aKYB"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-698b78c05b0so1569a12.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 11:45:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786473899; cv=none;
        d=google.com; s=arc-20260327;
        b=Tx3TgoKXJpAj1QS+ZodtN/x6cBPV3pmnO2HMzlvMYy2L574UAvdYScm23BCPEzyBeA
         N35LLM7cYnZLLVsx322Q9gHffbqptC4OVyu3rpMEWDWuT+9tJB0y529tjUhKvppUZwTU
         FKE5y7S51U6+oN8C5zSu6ep+UNNeL10yRiw1ehE01pLimd/HX+fdoq/pYd+QMiU+oGBn
         Lvkj4Pw+LZmjShU4ORsf2QXywxqRkW/pNkWgsYwRCRc5a6Lyxq317DmEymfHKrgSb/RT
         imEijKB5gwTyKrg1ZSndTgIozBy5Z+Rq51OYSSQUSmX7I+YK6MMVIMywz4q896Sgv5ad
         Gx2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O0Y8XFy4Cr5mSbO1ygPEQcGzY7wJ/bk+XYxgiT/LhLU=;
        fh=jHBjsCz/OMxcLhwK14MtTKQfX+k/fkzdDq6EjP7grdk=;
        b=UJQKJeu8RbP0KLdwnk1CPhYUiFGvYc6nldJHTVmhnFolHvX/tP/XhT/LE3noVCpbBA
         P5nlKEFLvujB/+Gz+el3/bkdQVJMn2InbZ1m/8MmLamcbLb4XXV9zHoJrCMu1ZvGiN4H
         z/ZvxGgQBPkdTeNcqgK4thkz9RmpWXE7JRf4mjz8t5P7FmmyQ/Hhw69aE28HkaYgga46
         XqYtvyUzLDAZUoc2+atxUVabwduUcxTcEAgNlACu40pYJHnf1IeItjjTvBiWhCGR70D+
         jDVdQsTaBS47UDn7Iu8N9+j4dvtp6mMtlb/BtOeGX680msEgkHBZm/1dcBKADHnIZj+w
         1Jcg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786473899; x=1787078699; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O0Y8XFy4Cr5mSbO1ygPEQcGzY7wJ/bk+XYxgiT/LhLU=;
        b=bJf3aKYBckePkl1rC6fwOOZ5sdcIKr12FUZD9fzet9kTI/++eT02bJaEL626um8yxe
         jC9qPdvMCjQqlHHFuRqA9Xh33r+6kcwlqxnkY2H5xDKgaf/rqL+mdXSr56S40z0f6Yrt
         rBsY1APTA+KXVc5q1ocncnalLB2oxihE+qwpM8iyHwhkHUHVjvHb/QlDM/lQpB9Y0YKH
         oQw22+9seQuvpWE7YE+VOB2exxsHLXrjsYVIQ89ht67rQFXSP0F+YmSlvl4DSxhXxHq1
         y0mn5juTdPBTR8Q3GNhuIz7pICbMTo83tI0wBrziuJsCOGoZB1dJpOzxAORTPG69hpH5
         UkEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786473899; x=1787078699;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O0Y8XFy4Cr5mSbO1ygPEQcGzY7wJ/bk+XYxgiT/LhLU=;
        b=DKzn6LWwVrnMFkzde++uRSk9bghw8bSQUVVl4yod9Z4ueeQoDIenRo56xwun76j1kY
         0yci18DW8YuysWVnIbZy22KZmOz3gpJKz4YzAz58GAd2wy+y2tous6cxQzu6sOWKZIvx
         2Udj+xMa6vjOCV3bgS4scry/U8lA9iqzm5pFLypfHwu2FKqW8VAl76mCaaRV8KsQ3cyi
         r2r/cv8r4ujnBy8FwYJBntWdUs5WKoTzm8XS77lsrhNyL4Xpr1q1Z9mu/IASDcw2/1Gd
         mSuBZMuHJUljOInas01PNp9vMEhJygqOurLXdSI80CQWFawy1ST0ZgBJ7zHXQ6Aa0OcV
         zEvg==
X-Forwarded-Encrypted: i=1; AHgh+RoiIeEHcGN1QME4SvcEJS7Ur8uGwGbcl5hb1TKPIRwt/nIHfnGYG9c5NBpeI/WS7EeisLrrEQY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyC1arQgCyXhwwgPNEYA1Z7QYZRdzjZLBMX0v8p9Vu0Xu58W7Ya
	++3LV8r2W88Rak1BGb89vHcMyX890Weil/sanfMg1GVSDNqsmhV0bs/FdjdE/rZa5+62QXLl1pC
	+zDjKKfrsys2iKHRXEtNNsv1kT0Eb1mWXQVnJ/Amo
X-Gm-Gg: AR+sD13LD14CYP1TfcaHO4lnIMwqnGUX8cV/PrShM2lt6Yp2gU9Nn8iPaepg6YCEQ/s
	4RbFpLCGHcj8eIEbd3zCjKuKRCV7st/TlYcgOZgB+rg1Xi+KJJNDJKJ+eMSP6WrXOq9mDzSWUP+
	Pd2I3VJZIHcnyicZaan3Q0hCXeJxUBtNSc0HLiKHtjuFh3sWmr6oiQ9UGZ1VPepEQcM5E4L4wIO
	D22Pa011O9QZwFBviV+x4E7kzRTQkKra/E9lXATW/4St2pupsI9qdneVToUz7IOEqeRRBvSUXT8
	ygSwPDOx046PX5FS8Ab2zXjIg/DQKc+ibAgJszhTWb6NREgxRuoQwvVHGOEHPAB13835mNs/e14
	=
X-Received: by 2002:a05:6402:5690:b0:6a0:6679:be47 with SMTP id
 4fb4d7f45d1cf-6a3720e98f1mr7838a12.1.1786473898473; Tue, 11 Aug 2026 11:44:58
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260808085824.732659-1-smostafa@google.com> <178621460524.381735.15023846552532101058.b4-ty@kernel.org>
 <CAFgf54qY8c9wO_RHQZpVSKUCTOgr+WWKCxetjb6BGf-G=5OTSA@mail.gmail.com>
 <86pkzo23u0.wl-maz@kernel.org> <antaNocfJp6mX-oV@google.com>
In-Reply-To: <antaNocfJp6mX-oV@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Tue, 11 Aug 2026 19:44:45 +0100
X-Gm-Features: AUfX_myPHMsxz7vu-KOTkZeD0CkvzolqvNKht92XUvhOAw-KTF5RzZ5iKSgzCiM
Message-ID: <CAFgf54rguaNDTDxtGfWG4rZEkFz3C_VoBw=Z8rVuWPLSfquVjg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fixes for timers and pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	yaoyuan@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 6:22=E2=80=AFPM Mostafa Saleh <smostafa@google.com>=
 wrote:
>
> On Tue, Aug 11, 2026 at 02:18:15PM +0100, Marc Zyngier wrote:
> > On Tue, 11 Aug 2026 13:17:25 +0100,
> > Mostafa Saleh <smostafa@google.com> wrote:
> > >
> > > On Sat, Aug 8, 2026 at 7:44=E2=80=AFPM Oliver Upton <oupton@kernel.or=
g> wrote:
> > > >
> > > > On Sat, 08 Aug 2026 08:58:21 +0000, Mostafa Saleh wrote:
> > > > > What started as a  small patch ended up as a 3 patch series thank=
s
> > > > > to Sashiko.
> > > > >
> > > > > First patch from Marc to consolidate the offset calculation,
> > > > > follow up patches fix issues with non-protected VM and timer
> > > > > offset and protected VM running with broken CNTVOFF_EL2.
> > > > >
> > > > > [...]
> > > >
> > > > Dropped the unintended SOB in patch 3 you mentioned.
> > > >
> > > > Applied to next, thanks!
> > > >
> > > > [1/3] KVM: arm64: Make timer_get_offset() work in all contexts
> > > >       https://git.kernel.org/kvmarm/kvmarm/c/2858600ecd01
> > > > [2/3] KVM: arm64: Fix timer offsets for non-protected VMs
> > > >       https://git.kernel.org/kvmarm/kvmarm/c/47d3eef780e3
> > > > [3/3] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
> > > >       https://git.kernel.org/kvmarm/kvmarm/c/2e813a6e8ebe
> > > >
> > >
> > > Thanks Oliver! I believe there is one more bug. I'm not sure where th=
e
> > > bug is or if it relates to the broken timers.
> > > Before those patches I could not boot a protected VM because of the
> > > panic, now after booting protected VMs, I sometimes get a system
> > > reset.
> >
> > On this quality HW, this is usually an indication that you are taking
> > an exception in a tight loop.
> >
>
> I tried to add a poor man exception storm detection in the kernel
> handlers (el1h_64_sync_handler and __gic_handle_irq), but it didn=E2=80=
=99t trigger
> before the reset.
>
> My hunch would be that there are some paths in protected VMs that takes
> too long that the watchdog fires. I saw the resets mostly at either
> userspace boot or VM teardown, otherwise the VM seems functional.
>
> I will collect timestamps from hypervisor entry/exit and check
> how large are those.
>

Max numbers I've seen doesn't exceed 2-3 ms, compared  to SMCs which
can take almost a second.
I'm not sure if the watchdog is the right conclusion, but without any
clue from the firmware logs, I am lost.

Also, correcting myself, I now see it happened with a single vCPU
although that took longer to reproduce.

Thanks,
Mostafa

> > > I confirmed that cntvoff_el2 does not get written to non-zero, I also
> > > removed the sysreg write completely (rely on xzr value at init) so my
> > > guess is that the HW might be allergic to more than just non-zero
> > > values in cntvoff_el2.
> >
> > Is that in hVHE mode? Can you trap the access and route it to the
> > existing handling code?
> >
>
> Yes, only hVHE. Protected nVHE works fine.
>
> One interesting observation is that when starting a VM with a single
> vcpu I don=E2=80=99t see the reset anymore compared to 4 cpus before.
>
> Enabling traps for timer unconditionally for protected VMs still has
> the same issue.
>
> > > I do not have issues with non-protected VMs anymore.
> >
> > Do these run with an offset or not?
>
> Yes, they have the offset set from kvm_timer_vcpu_init() with
> kvm_phys_timer_read().
>
> Thanks,
> Mostafa
>
> >
> >       M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
