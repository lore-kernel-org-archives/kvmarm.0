Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795441983;
	b=vKrL0iM5D9709hIMd86GwMn/kjU2+CL2bvHGSL3ZgHPMCeNnu7WueBnPM+1q67S1CE9S
	 pCf/7mq0AkoidTqCqjqcMSWJ5zBf6fe7/OlF45FVyq8PajS1TONFhmF9hkals3vrzA2zg
	 hBGmapje3/HywILsSOFhqxa0FFF1CtZnY//Vid1rZsoluUPlMzer6FdVKf4UVP4SQpoif
	 GD+4CMtDOEVtYJraqATJTgZX1vQCM4vx0Nrk25L5PqHDgU0TalISStPySDDKA/djAbEfX
	 saQEJDpHyFjX3G8rcbTX+4wfs+qBrTK4VqNOvd5OVBsEMwRk9ylxgbjQmD07ge6hg3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795441983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type;
	bh=w7l6GOVj1ta19VMv5L9sRcj+U6VdIqUJoDJrYzcoSww=;
	b=rH13m4SBBf4Hn4AuL2mkJJzlL9amwJYnSFbGaRjy0xSXsgfnTWeATYBDwFjdVWsovK6T
	 5LsGcLwoywgiP/FLF+E81VkRHr1qlc4rsc/BGmFC4NTXHCP6Cb2WnNkHYBg90trl51p4h
	 9ZOm8q1fcUP4xCwy4j/bosIf0bKjx+66Sio/cdfm2JErtQ81c/RXAthgoDWGdEikphe9r
	 yO+GaaFwMxe3xRaS3iZXWC1Ynzl9j7ie1rbzODhS9kPkFIau7MAlK4fTuTMC7NLNnwtso
	 MOuev/TvlDYKig2Fg3OIwGMlCKHFheJT3SMajxiHjQaE7dFjqiREO6n18KBgFsAtLzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvgjBJDe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C033E606A321;
	Mon, 23 Nov 2026 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvgjBJDe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0C11F000C6;
	Mon, 23 Nov 2026 13:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795441983;
	bh=w7l6GOVj1ta19VMv5L9sRcj+U6VdIqUJoDJrYzcoSww=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=YvgjBJDeY6bRVM//Ef/CR3wqhigSAXRBKPMQZnFSl5rRLTYBReyZxGh4KYDN8PZjg
	 e1+q37zjOWNa/zW6PenUUWn4c+VSxL3VGzz/+YMEB6zdCxuNSRKkYB0fP4i+Q14BwT
	 C/JymHhoTW1bVfQOv01xOXfAgeEuNJ0kuGBFXXQmTrpRqNPhoqIr3HHlAdhY+r4bUD
	 O/4WA+RiRgRRCs1i/0nEIMC5nXuVPNWyHrrDqCwNAZDqOsUYPVCgi46EHQtaywgH7d
	 t/KS4bMveDBrIxMGKCwvWZuMAhNU1gWeMuXMmM73wRDtKsvO63AyJoLgR4ttgh5g7b
	 E3/6pDDp/TlTQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  robin.murphy@arm.com,  maz@kernel.org,
  will@kernel.org,  David Matlack <dmatlack@google.com>,  Alexander Graf
 <graf@amazon.com>,  seanjc@google.com,  jgg@nvidia.com,
  loganodell@google.com,  arnd@arndb.de,  dwmw2@infradead.org,
  baolu.lu@linux.intel.com,  Bjorn Helgaas <bhelgaas@google.com>,
  oupton@kernel.org,  alex@shazbot.org,  gle.com@google.com,
  pbonzini@redhat.com,  Andrew Morton <akpm@linux-foundation.org>,
  kevin.tian@intel.com,  joro@8bytes.org,  kvmarm@lists.linux.dev,
  linux-pci@vger.kernel.org,  Pratyush Yadav <pratyush@kernel.org>,
  kexec@lists.infradead.org,  kvm@vger.kernel.org,  iommu@lists.linux.dev,
  linux-arm-kernel@lists.infradead.org,  skhawaja@google.com,
  sagis@google.com,  linux-arch@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 04/19] liveupdate: Reference struct luo_file_set_ser
 via serialized pointer
In-Reply-To: <20261110050202.529473-5-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 10 Nov 2026 05:01:47 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-5-tarunsahu@google.com>
Date: Mon, 23 Nov 2026 13:52:55 +0000
Message-ID: <2vxzwlq3zmbs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Nov 10 2026, Tarun Sahu wrote:

> struct luo_session_ser currently embeds struct luo_file_set_ser directly
> by value. Embedding struct luo_file_set_ser couples the session layout's
> size and field offsets to struct luo_file_set_ser, preventing either
> structure from appending fields independently across kexec.
>
> Convert struct luo_session_ser to hold a DECLARE_KHOSER_PTR pointer to
> struct luo_file_set_ser instead of embedding it by value. Reserve space
> for both structures in each session block-set entry, placing struct
> luo_file_set_ser immediately after struct luo_session_ser, and bump
> LUO_ABI_COMPATIBLE from luo-v5 to luo-v6.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Apart from the static asserts,

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav
