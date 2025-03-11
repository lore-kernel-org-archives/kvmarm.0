Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51B529A1;
	Tue, 11 Mar 2025 11:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741691925; cv=none; b=JrRipWJXSK/KgpHNlMg6Nnopk4pCmlXprv/I8YL8bZdoZ4ukCK1A2m3noge9MPDBD5BPJP+Y7WLQU9n/OWWPxWRClnXV2e201EQbPn+01SUxVnl1XwElo0E/u9pzKmKDQIKlszrwlDzGJTe5itHxYKt0fn7Qdw/VqXZOSbc4Llk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741691925; c=relaxed/simple;
	bh=eV1Ot+6YRrZcBA7zWzuNDm7nIRQcDW2LUambjbhiAhs=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FRt5hCiCnAm8tAa5BtoCsO4nYaFgFWChOyYtK0xOyvuuqPmsqzqP9UTBpg7dh+INHyVo6BGOJ5LbYRP3BDd0WYcFlhdMsXK+7dIB1gEtcb3iiszwS7Hvyw4deDL0AalEggtY7z63bAkc6T5VrffWnzNtPbWPzdiFGJgMADZySAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aR5Xv+JX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aR5Xv+JX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC84C4CEE9;
	Tue, 11 Mar 2025 11:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741691925;
	bh=eV1Ot+6YRrZcBA7zWzuNDm7nIRQcDW2LUambjbhiAhs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aR5Xv+JXW/OGpjkpBu6OK786z2RKa6Uftin8rPAQP29jmSSBS7ZZSdyHN0j1A5RIO
	 KopJBmyosJTsEE8bck5mz6EKpGpxitwM6TLjkSfHGP2IjlPunbngwds6yIFPkNo9yq
	 b2+QqXvJ9g7mV+9ZnlLbH9O2pejE0Cj8b9Dt0n5lW9PthEqBPXTDQw1qNxha32mm4K
	 wexs1y1c72xFIlrENyFXdBemKuVmVPsM3pwtNn2+o/w5DK3zY11vswz+QFWG1yBRlb
	 NUfpjSoD8h+3WmMwAKrHJQoqLsaYfPlXMShejU/4CewkdungRFrJcRgIQbeRobBZVh
	 m+MFd1Dd7nYYQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trxdB-00CVMK-Ga;
	Tue, 11 Mar 2025 11:18:42 +0000
Date: Tue, 11 Mar 2025 11:18:40 +0000
Message-ID: <86r033olwv.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	"oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com"
	<yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com"
	<ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com"
	<david@redhat.com>,
	Aniket Agashe <aniketa@nvidia.com>,
	Neo Jia
	<cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta\
 (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>,
	Andy
 Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John
 Hubbard <jhubbard@nvidia.com>,
	Dan Williams <danw@nvidia.com>,
	Zhi Wang
	<zhiw@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke
	<udhoke@nvidia.com>,
	Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju
	<kjaju@nvidia.com>,
	"alex.williamson@redhat.com"
	<alex.williamson@redhat.com>,
	"sebastianene@google.com"
	<sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com"
	<yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com"
	<gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"tabba@google.com"
	<tabba@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
In-Reply-To: <SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250310103008.3471-1-ankita@nvidia.com>
	<20250310103008.3471-2-ankita@nvidia.com>
	<861pv5p0c3.wl-maz@kernel.org>
	<SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.4
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ankita@nvidia.com, jgg@nvidia.com, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com, shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com, aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com, alex.williamson@redhat.com, sebastianene@google.com, coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org, ddutile@redhat.com, tabba@google.com, qperret@google.com, seanjc@google.com, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 11 Mar 2025 03:42:23 +0000,
Ankit Agrawal <ankita@nvidia.com> wrote:
>=20
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=C2=A0 When FWB is unsupported KVM ne=
eds to do cache flushes
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=C2=A0 (via dcache_clean_inval_poc())=
 of the underlying memory. This is
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=C2=A0 only possible if the memory is=
 already mapped into the kernel map.
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=C2=A0 Outright reject as the cacheab=
le device memory is not present in
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=C2=A0 the kernel map and not suitabl=
e for cache management.
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 if (cacheable_devmem && !stage2_has_fwb(pgt)=
) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ret =3D -EINVAL;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 goto out_unlock;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 }
> >> +
> >
> > These new error reasons should at least be complemented by an
> > equivalent check at the point where the memslot is registered. It
>=20
> Understood. I can add such check in kvm_arch_prepare_memory_region().
>=20
>=20
> > maybe OK to blindly return an error at fault time (because userspace
> > has messed with the mapping behind our back), but there should at
> > least be something telling a well behaved userspace that there is a
> > bunch of combination we're unwilling to support.
>=20
> How about WARN_ON() or BUG() for the faulty situation?

Absolutely not. Do you really want any user to randomly crash the
kernel because they flip a mapping, which they can do anytime they
want?

The way KVM works is that we return to userspace for the VMM to fix
things. Either by emulating something we can't do in the kernel, or by
fixing things so that the kernel can replay the fault and sort it out.

Either way, this requires some form of fault syndrome so that usespace
has a chance of understanding WTF is going on.

> > Which brings me to the next point: FWB is not discoverable from
> > userspace. How do you expect a VMM to know what it can or cannot do?
>=20
> Good point. I am not sure if it can. I suppose you are concerned about er=
ror
> during fault handling when !FWB without VMM having any clear indications
> of the cause?

No, I'm concerned that a well established API (populating a memslot)
works in some case and doesn't work in another without a clear
indication of *why* we have this behaviour.

To me, this indicates that userspace needs to buy in this new
behaviour, and that behaviour needs to be advertised by a capability,
which is in turn conditional on FWB.

> Perhaps we can gracefully fall back to the default device mapping
> in such case? But that would cause VM to crash as soon as it makes some
> access violating DEVICE_nGnRE.

Which would now be a regression...

My take is that this cacheable PNFMAP contraption must only be exposed
to a guest if FWB is available. We can't prevent someone to do an
mmap() behind our back, but we can at least:

- tell userspace whether this is supported
- only handle the fault if userspace has bought in this mode
- report the fault to userspace for it to fix things otherwise

	M.

--=20
Without deviation from the norm, progress is not possible.
