Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68A4224B12;
	Mon, 17 Mar 2025 09:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742203676; cv=none; b=e3zJlDd6pl/ZZ1wkE5Kp2/FO2/Wjys6TC9QBXyAontNDl2NTEBBWuL0OfMmH0H56p/PYNLD5909Kh7UkumfeccROmyqvTtJ4azisl53pRZQvrZdUorLf4yRiCqDLulHuyZoY/SoWxPyo2aXBv/SzRMwrBOaGymGXGPs59p09LRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742203676; c=relaxed/simple;
	bh=xX7lHGFYnpplLSbCZnNB6JktC5keaB3sAg4LSZJ5VdQ=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sqAsDeAKkXM2t3AylZaQWtf8RGszJyoyJgE42Tdaismegc8xnhF6Mnc5/ovQyoj3hLO/Z2VTN3A/qxzyAnjercu3Z5H5NFE77VbRISTETpgdV5T+9dt7UX2sMnqM6DRKZ3Q1fa2ziG5OKN+ucnL7SLWVNtcBM/NgM403ht3rT/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJYt/3k0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJYt/3k0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A58C4CEE3;
	Mon, 17 Mar 2025 09:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742203676;
	bh=xX7lHGFYnpplLSbCZnNB6JktC5keaB3sAg4LSZJ5VdQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dJYt/3k016lB/8vi06XSanBCTpSfH2BWqga6pTd50rbE2MU/A6PFw/OCqXO4lpLe8
	 glDrZnSBuQ7f4tIJoORMWwOjJqPk/rQefvmcAjcR/+b3UDzghnaBl4sCTkwIF14InH
	 6hFHFDdDxPBm8D/YkpWbkhI9jgLdrhpFdqfIVTs7JoJ9mAV0xBjHHRyHm/ozfSICup
	 KR5ykY+MrvkMnTLvNnn/qVQRTDbLRSDVFxGPOiba9ESYDDuN7dT/VCgWY50IG93ITl
	 PibJq52FsdT0KMmRpkGFWFFPf1wWFVFwRzlwyDBECGzwY7/1SvO8XCkk7BK/3udQn/
	 yQuGUeiSEUOVA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tu6lE-00EDv5-WB;
	Mon, 17 Mar 2025 09:27:53 +0000
Date: Mon, 17 Mar 2025 09:27:52 +0000
Message-ID: <8634fcnh0n.wl-maz@kernel.org>
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
In-Reply-To: <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250310103008.3471-1-ankita@nvidia.com>
	<20250310103008.3471-2-ankita@nvidia.com>
	<861pv5p0c3.wl-maz@kernel.org>
	<SA1PR12MB7199DD985C45943A663E7003B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
	<86r033olwv.wl-maz@kernel.org>
	<SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
	<87tt7y7j6r.wl-maz@kernel.org>
	<SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.4
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ankita@nvidia.com, jgg@nvidia.com, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com, shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com, aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com, alex.williamson@redhat.com, sebastianene@google.com, coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org, ddutile@redhat.com, tabba@google.com, qperret@google.com, seanjc@google.com, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 17 Mar 2025 05:55:55 +0000,
Ankit Agrawal <ankita@nvidia.com> wrote:
> 
> >> For my education, what is an accepted way to communicate this? Please let
> >> me know if there are any relevant examples that you may be aware of.
> >
> > A KVM capability is what is usually needed.
> 
> I see. If IIUC, this would involve a corresponding Qemu (usermode) change
> to fetch the new KVM cap. Then it could fail in case the FWB is not
> supported with some additional conditions (so that the currently supported
> configs with !FWB won't break on usermode). 
> 
> The proposed code change is to map in S2 as NORMAL when vma flags
> has VM_PFNMAP. However, Qemu cannot know that driver is mapping
> with PFNMAP or not. So how may Qemu decide whether it is okay to
> fail for !FWB or not?

This is not about FWB as far as userspace is concerned. This is about
PFNMAP as non-device memory. If the host doesn't have FWB, then the
"PFNMAP as non-device memory" capability doesn't exist, and userspace
fails early.

Userspace must also have some knowledge of what device it obtains the
mapping from, and whether that device requires some extra host
capability to be assigned to the guest.

You can then check whether the VMA associated with the memslot is
PFNMAP or not, if the memslot has been enabled for PFNMAP mappings
(either globally or on a per-memslot basis, I don't really care).

	M.

-- 
Without deviation from the norm, progress is not possible.
