Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C326B2CE
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784038459; cv=none; b=MGbzrO0YSpxhwsqdVE7y6Njv5NxSpvm5cAPcdo4F5cIBY4W326NTj9Oyo5WcJmiotqCXupb459gNBI0yYPFbFnzolWS87VR6b2gIZnwmh8QHZ6gLUbW9PJAicrEdSW2khWiA78wrVaV47mO0pf/sCer2Zy9ZIn7gcUrAJ7+7Vec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784038459; c=relaxed/simple;
	bh=BPIRB9Dd4cOslVY5PESm6bOvGNSOObw9pvt/3Q1F9Uw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lP/xEJyLSeYimrGerx1xyrQrkSePNSk5sQTWgOwoz0GG9eravBiETM1976YdbZSJM2IXE7WtLcc96Qss8NF4Y0Y3FyercYhwr1Pek/e/JCWwynCUwgsRAp3jLAMESxrgFZoyuveun/NLhE/kfw7wufSiU8l+x9xvs+q3p/kN3n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I/WC/u25; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I/WC/u25"
X-Forwarded-Encrypted: i=1; AHgh+Rr9KPqRPHV0OQ3XG4KqUbjyRogS5jpKbhuujseajfuStbXbkyIsRneqHIOZ2erw1lR3062owlk=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784038454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BPIRB9Dd4cOslVY5PESm6bOvGNSOObw9pvt/3Q1F9Uw=;
	b=I/WC/u253jc6TWHGnfW2Y25C3g5KpesjV5mp+JUwvWuan41t2ACRGjaYEXoBLpfyaqhoyZ
	EXZ8hUlhqwCDdJ9Zce8QuwthqfXZjjbwHWWZ+yo8MIX6TuzvqykWdwMZOyihdhHzDQ1/HU
	AAD7QtTluVK5cExSPZldGKhvDddfpBM=
X-Gm-Message-State: AOJu0YyayAThFmsxOb3F6QBHYeHrWcjXx25QLN1eUiLUZqcp0+24eDDq
	xQzMLEu45xp2tULU7dCdLLSyJgA3VxZUtIR6XNugQFcZf3QyrwqlE3G3amKk7JlNwSX7qF3w2U/
	tVSQ7nfEmOqadnSzssDu2ZG5OWEiMOJtVAxsgUcOs
X-Received: by 2002:a05:622a:11d1:b0:51a:72e5:9b2f with SMTP id
 d75a77b69052e-51d7bd89849mr13077231cf.20.1784038433589; Tue, 14 Jul 2026
 07:13:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260714110756.116950-1-alexandru.elisei@arm.com>
 <CA+EHjTxFAqO38zZNTM5oQ26X7eUcu3ggfhMY2gn2bB4sMbOxoQ@mail.gmail.com> <alY2e8bfsMDyI2QZ@raptor>
In-Reply-To: <alY2e8bfsMDyI2QZ@raptor>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 15:13:16 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwhYpC-fzXKr9J7015AwAtoHvnUqm31ockQMLjKM-fOoQ@mail.gmail.com>
X-Gm-Features: AUfX_mzpDe5iSeTUKNhFhM8dxY-CxssfUNHFcChEyJoMZ4XDmFgf8k8egb_tvdk
Message-ID: <CA+EHjTwhYpC-fzXKr9J7015AwAtoHvnUqm31ockQMLjKM-fOoQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Reject guest_memfd memslots when the VM has MTE
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	catalin.marinas@arm.com, will@kernel.org, steven.price@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 14 Jul 2026 at 14:15, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi Fuad,
>
> On Tue, Jul 14, 2026 at 12:44:57PM +0100, Fuad Tabba wrote:
> > Hi Alex,
> >
> > On Tue, 14 Jul 2026 at 12:08, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > >
> > > The user cannot use MTE on VMAs created by mapping a guest_memfd file,
> > > as arch_calc_vm_flag_bits() does not set VM_MTE_ALLOWED.
> > >
> > > When creating a guest_memfd backed memslot,
> > > kvm_arch_prepare_memory_region() rejects the memslot if MTE is enabled for
> > > the VM and if guest_memfd has been mapped in a VMA that intersects the
> > > memslot.
> > >
> > > However, the documentation for KVM_SET_USER_MEMORY_REGION2 explicitly
> >
> > nit: s/explicitely/explicitly/
>
> I think that's what I wrote :)

I fixed the quoted text (pressing enter right after the word)! :) The
original msg says `explicitely`

It's a nit anyway.

> >
> > > states that the only condition for userspace_addr is for it to be a legal
> > > userspace address, but the mapping is not required to be valid nor
> > > populated at memslot creation.
> > >
> > > If userspace sets userspace_addr to an address that hasn't been mapped, or
> > > if userspace_addr belongs to a VMA that isn't backed by the guest_memfd
> > > file, or if the VMA doesn't intersect the memslot, memslot creation is
> > > successful and KVM ends up with a VM with MTE and guest_memfd-backed
> > > memslots.
> > >
> > > Forbid guest_memfd memslots unconditionally when the VM has MTE to prevent
> > > this from happening.
> > >
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > Is this worth a Fixes: tag?
>
> Fixes: 32e200bd6e44 ("KVM: arm64: Enable support for guest_memfd backed memory")
> ?

Yes, the author of that patch should have known better...

<snip>

> I can iterate through all the memslots and check that none are backed by a
> guest_memfd file when userspace enables the MTE capability.

Sgtm.

Cheers,
/fuad

> Will wait for a day or two to send v2.
>
> Thanks,
> Alex
