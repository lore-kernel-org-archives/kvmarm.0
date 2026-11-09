Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245864;
	b=fkPjaX/lu0miHLfgOO25PJ7q8SARetHo6uUSQxaYUzgi2WsKB52SOGgOXYxGCK1hAIJt
	 Zfenzz6IKthpxS9QdJwmglmFgMYzjTHx0+oWfkOhqKDZXCb+P9WF0RBzWE6JARzp+QVj5
	 PZC7ySHkAP4D28yk7sDkyKDJR0IFI0FAfL26sI7A8f9BHak9Du8EtAUtFbY7MdtyQAQ+Q
	 HXklZKzU8qSzng/HESgHWJtwd9j8ZIog0vqbgUQSV3rWG1kxXQZRpamzPcEQuUZlKCijm
	 sBCAK9k37hL9/vEWtfKz/vnIs66fRiQVMIGruY/ueQ7eh3BfwyXuGu9KEw+LtBJIzBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245864;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qLl/PXvaSQ0W1AcaAdyopr9F3M61PHUlMh85ZFanJ74=;
	b=I7OOE5yBb/FeEvu7Ik8Biq2fJu2IGK0n15LEJqAQfyciWJ3GfXxKei+q2377G8fMvZ7V
	 kThP2ZPQlsqTH7vYM+5ME6TrMDd8yd+kCSJK0nO+2QZMybEYzo7kRV8OuFfeuakRxFKkP
	 W8/9P/BDSTfeKbPZDLlj86E97NK7ar7cDtoehNDsAWz/Ze4WJQElZk6PHClcNqj0hmiuM
	 8XMmRb7UqyXIfywo1Qm2ZsuZZAzNie6o052H/0FiTFEjkL68IEn/S3rwv8DqX48xFbefy
	 U7LCMUPP0Gz+30ZHAZDEjfjfbjdOMLLr2I9vZUrSuJ0Hvke3Fw2TbJd1sNEYfH8KnzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ErX/FssJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3918F606A31C;
	Mon,  9 Nov 2026 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ErX/FssJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9715A1F0089F;
	Mon,  9 Nov 2026 17:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794245863;
	bh=qLl/PXvaSQ0W1AcaAdyopr9F3M61PHUlMh85ZFanJ74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ErX/FssJnBXS5wQeLGGYXYl6DPfC3sxjFDR2F0jQLIiYpak3bhdvTYjOPn2ayGsc1
	 ugn9cwH9MNl4RzdtDcih21h8h+8ZTUV/quK4rSo4Wr+U+gjknIvzKSF6GNvHeWPfvi
	 h39Ahy27jF/wrqY/IHQF1kFAEVDe35RD/7MsE8xKaYW9AXwwDrd3J/WoVz3iQaR2EI
	 KEOLT2cSUTuIVTZTLJZKz0IhNbdQ1sH459C6DPvJMltWoHkTBsDeNIe7/+kd2ae+IK
	 +YPPmdWyCVczbVD+oXik8T7lbIqbha2J9aF6neZs56rtjpU42ugToIcbaMmrjpDD2/
	 3Y98nCdLQTgyA==
Date: Mon, 9 Nov 2026 09:37:42 -0800
From: Oliver Upton <oupton@kernel.org>
To: Haseeb Ashraf <haseebashraf091@gmail.com>
Cc: maz@kernel.org, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, fahad.arslan@siemens.com,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] KVM: arm64: nv: Skip empty spans when unmapping
 a shadow S2
Message-ID: <avIE5g2fUEqmmknA@kernel.org>
References: <20261109133431.185154-1-haseebashraf091@gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109133431.185154-1-haseebashraf091@gmail.com>

Hi,

On Mon, Nov 09, 2026 at 06:34:29PM +0500, Haseeb Ashraf wrote:
> Emulating TLBI VMALLS12E1IS, emulating TLBI ALLE1IS and recycling a
> shadow stage-2 all unmap the whole nested IPA space in chunks of the
> largest block size, even when the table is empty. With a 48-bit PARange
> and 4kB pages that is 262144 unmap calls per shadow MMU, each ending in a
> range TLBI when FEAT_TLBIRANGE and FWB are available.
> 
> Measured cost: one full-range unmap of a shadow MMU takes 0.87-1.06 s on
> AmpereOne (Xen on KVM, 4kB pages, function_graph). On Graviton4
> (Xen-on-KVM, 48-bit IPA) a single VMALLS12E1IS trap took 1.46-9.50 s over
> twelve samples (median 3.09 s), all of it in stage2_apply_range().
> 
> Patch 1 adds kvm_stage2_unmap_all(), which skips spans covered by a zero
> descriptor at least as large as an unmap chunk, keeps the tracked unmap
> for everything else, removes the guest stage-2 records of skipped spans,
> and ends with the VMID-wide TLBI that VMALLS12E1IS requires. It converts
> the VMALLS12E1IS handler. Patch 2 converts kvm_nested_s2_unmap() (ALLE1IS,
> whole-VM unmap) and the pending unmap of a recycled shadow MMU.
> 
> The series is based on master, which already has the guest stage-2
> tracking. It overlaps with the unmerged kvm-arm64/unmap-vmall work, which
> defines a kvm_stage2_unmap_all() with the same name and signature; if that
> lands first, patch 1 becomes "skip empty spans in kvm_stage2_unmap_all()".
> As far as I can tell, that WIP helper does not touch the guest stage-2
> tracking records, which this series does.

Basing your series on a random, out-of-date version of a patch series is
never OK.

The direction we're taking with that series is to have the inner walk
report the next IPA to visit to the outer loop, this should do the same.

https://lore.kernel.org/kvmarm/20261106133000.453240-2-fuad.tabba@linux.dev/

Thanks,
Oliver
