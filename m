Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190901D318B
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 20:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736801289; cv=none; b=WZ2FKrFGgI8t/xOAvPzKubN2oZ7bmHSOLe39zkOi6ZlKyE27n/HqcagDWsYTLMh4VR060Sb2mX1HuYea2GGszBoSLwVCCvEorZeH17FyeVwo3nkY/a9JwEhePTzzPHEOraRt9F4DwLizcIOO5DkmPGm8ErU9KcxMH62uj5b3GwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736801289; c=relaxed/simple;
	bh=Y3coRwO2DtTxhh4XfUfkwSXhxRyzgnRjylok44BCaAk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l1XwZib/D+x4FrIk8oCcz6vAaG/WHSegoUiXMrUCYToyQSJixS7qHOEcA7OcUDM5yCRJC1w5FInqzhdyaTpIzGJh7lJIAj2y/RM3H/631JrlLha7ggmHnWHHilbCk7IOrGK12PjbJCLSkQgPviyL4eBRBE2I4OEtMFKm5yD5MWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k51LLgJN; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k51LLgJN"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d9f0ab2313so1993a12.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 12:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736801286; x=1737406086; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lfn+cvLcuo2+8PMQ2pEe08Zdvwxhoz9ADZwuC0pV8LY=;
        b=k51LLgJNFxqy7MILSXRnlZ4dRp2SYjJNZj49rBX4oFkBlCfL+pBzD06TGoLDtGL2FO
         Kat6z5A/L6DKvVuF9KV+ihpe982+eR5BCU/SA2HAB9hztpp4M/rQHXXxvjuoXhN/TINt
         S4DMEhs1T2MzcHGvuo1CkyFPC+0ovQbhYF0yliL16S+nOsfDybXFJes/jcUHqCCJucht
         5SuC1a4V/myIY37j4casg50r8023blUMGEuuD1kSuF4vwFIFqHueFUL2rvkUji0Qx9Fc
         9YuoPBwBQUBzrWumoBE54DKkwPBRMJsPxyBuKCLjjLMeN1PTPkTEtJNT1plYCN2uPNpb
         gl7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736801286; x=1737406086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lfn+cvLcuo2+8PMQ2pEe08Zdvwxhoz9ADZwuC0pV8LY=;
        b=HR1G7B/ARZjcyenOQdd10fcPuMoNEVs3vQl/VEGDGeDnMhwQAGAIbe9g2zI/CQlLU/
         7AYXa2/XKuYMGW7eem+X4YOTN1i//BYZbCvJ+3eRR1aSxtiEtSSHE/rSQLzOi2jXWf6r
         rEOu0NTodWneMciGi/hc5l1jnxSyakP8GonPI7sTuAfQTho0fXxKHd5RQ4MsoBS3gsOY
         RN5D5cKwJhD5vkGxdYjugNLBsJNWyLb1S1a3dVcWY82W98GYFza0aqpf6nZEV0LvjvUb
         +Uq4bjkKDlctH/2B0EtUEJ7hDFE3EO/uPPUgKf3A9R3VRfYdKLXd7gZjUREP2Mj/BCMH
         e2rg==
X-Forwarded-Encrypted: i=1; AJvYcCVx/C9SmvShd7/T6hthKyEPb71O+jep6YY/TzG2mApKB+IQJNndZRhMP5hT4xUH5lL077OEB1g=@lists.linux.dev
X-Gm-Message-State: AOJu0YyA3Sc22CY4EmbMwUvSkgDkxtyIBsw3l3jXClMmoSiUf4Xmgmra
	1d9rUubf3XXDJHEaUiMwWAfZwoBZMcRY3h5hBu9xEZejOKPWNnY39miKnq2Liv+79kslMWHWALu
	Q+WLz9/KFO+Wytnj/z7pQYCDZrz788GsnfbTz
X-Gm-Gg: ASbGncuDyvp9HXunFruPHsNek9qR52/cjnW672KbkkVOpfC/MNUstjLz9bVbUEhGxlN
	vYMYqDegjFDLIsD8T5Nbjt2VTSZ8CWcgQG3hBHZA=
X-Google-Smtp-Source: AGHT+IGDjMK+xCaZiz4na3kjUNgqUb+ERX7RVjtWKGSTA7bjfWQk5Kqr4iYGaho77kNGjfWYma759hCeMwaFShvNC1E=
X-Received: by 2002:a05:6402:1213:b0:5d0:d7ca:7bf4 with SMTP id
 4fb4d7f45d1cf-5d9f5e6332fmr20182a12.0.1736801286447; Mon, 13 Jan 2025
 12:48:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-6-aneesh.kumar@kernel.org> <Z4Fk58k8YptDkVgm@arm.com>
 <yq5amsfxtrlw.fsf@kernel.org> <Z4Vk5gTnd8o7VKWL@arm.com>
In-Reply-To: <Z4Vk5gTnd8o7VKWL@arm.com>
From: Peter Collingbourne <pcc@google.com>
Date: Mon, 13 Jan 2025 12:47:54 -0800
X-Gm-Features: AbW1kvYWxIU1dFGSmkykoAkcDmgqCqq-9XdXuQzSMRHTH9jIGVye6w4pEqFRlP4
Message-ID: <CAMn1gO4huP4D_1mFdC8FsmvHkaQn+hC02ULcfBuS30VDM9=9gA@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] KVM: arm64: MTE: Use stage-2 NoTagAccess memory
 attribute if supported
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Suzuki K Poulose <Suzuki.Poulose@arm.com>, Steven Price <steven.price@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2025 at 11:09=E2=80=AFAM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> On Sat, Jan 11, 2025 at 06:49:55PM +0530, Aneesh Kumar K.V wrote:
> > Catalin Marinas <catalin.marinas@arm.com> writes:
> > > On Fri, Jan 10, 2025 at 04:30:21PM +0530, Aneesh Kumar K.V (Arm) wrot=
e:
> > >> Currently, the kernel won't start a guest if the MTE feature is enab=
led
> >
> > ...
> >
> > >> @@ -2152,7 +2162,8 @@ int kvm_arch_prepare_memory_region(struct kvm =
*kvm,
> > >>            if (!vma)
> > >>                    break;
> > >>
> > >> -          if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
> > >> +          if (kvm_has_mte(kvm) &&
> > >> +              !kvm_has_mte_perm(kvm) && !kvm_vma_mte_allowed(vma)) =
{
> > >>                    ret =3D -EINVAL;
> > >>                    break;
> > >>            }
> > >
> > > I don't think we should change this, or at least not how it's done ab=
ove
> > > (Suzuki raised a related issue internally relaxing this for VM_PFNMAP=
).
> > >
> > > For standard memory slots, we want to reject them upfront rather than
> > > deferring to the fault handler. An example here is file mmap() passed=
 as
> > > standard RAM to the VM. It's an unnecessary change in behaviour IMHO.
> > > I'd only relax this for VM_PFNMAP mappings further down in this
> > > function (and move the VM_PFNMAP check above; see Suzuki's internal
> > > patch, unless he posted it publicly already).
> >
> > But we want to handle memslots backed by pagecache pages for virtio-shm
> > here (virtiofs dax use case).
>
> Ah, I forgot about this use case. So with virtiofs DAX, does a host page
> cache page (host VMM mmap()) get mapped directly into the guest as a
> separate memory slot? In this case, the host vma would not have
> VM_MTE_ALLOWED set.
>
> > With MTE_PERM, we can essentially skip the
> > kvm_vma_mte_allowed(vma) check because we handle all types in the fault
> > handler.
>
> This was pretty much the early behaviour when we added KVM support for
> MTE, allow !VM_MTE_ALLOWED and trap them later. However, we disallowed
> VM_SHARED because of some non-trivial race. Commit d89585fbb308 ("KVM:
> arm64: unify the tests for VMAs in memslots when MTE is enabled")
> changed this behaviour and the VM_MTE_ALLOWED check happens upfront. A
> subsequent commit removed the VM_SHARED check.
>
> It's a minor ABI change but I'm trying to figure out why we needed this
> upfront check rather than simply dropping the VM_SHARED check. Adding
> Peter in case he remembers. I can't see any race if we simply skipped
> this check altogether, irrespective of FEAT_MTE_PERM.

I don't see a problem with removing the upfront check. The reason I
kept the check was IIRC just that there was already a check there and
its logic needed to be adjusted for my VM_SHARED changes.

Peter
