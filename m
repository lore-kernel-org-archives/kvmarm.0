Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.61.253
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795513665;
	b=y40psJPmtJIQnZ1JCvmxLcW51/+GCa5+uColCBV8BPXPthRkK5yTjqO68d29XMkJlI04
	 lj5UpPiizljp5Pt/nEnRUWeeUqiZB5CLyK+X+PdCOLBbKnAS9bb6YEYaVofLDcrDCTlcE
	 +6BtE90KPKqIr9e3PSthkKoe12DTnhyopzp4L+ew1lgJxqxhJTz6dMGXy6t8yA7zYEjb3
	 XtLMqbMukJoMKsPlPWj9iYiWtDZvW42vrULS5zJLRXH/9n6Hfyht1Ez/nyXrFrZO7wp3J
	 Bwa5kBIah71hPsBP905HmrzHuDMo8J2bM2zPGNvCIABATb2cw6yKs4XytLN+PWsFdLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795513665;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=mCdvX3DKxNd4ufd5SveU6bheHpcm5WlWjpwmAB6yI/I=;
	b=tSH2JeMQGZcN2pLdBlvhxyz6HDLRNAVoEjuxviORm4TkItDrfO0MAdgxEHiGQw5TG6Rc
	 AHqWAuyDaJSfrvs9iEBx5GWd6I/Z6x8Fmpp+dILPYEXpr1xHaPWtpIH23ZM8zhr93LUP/
	 E2kJMwybT/GuGt+v77Od7hGxfxR6ooIZb1/BFiS8nezQQpz17rgn3/I7vbcOYyB5sXuxx
	 vxI3XlG5xivVQ2AEceo5s9QkzlOHu/jv71E0/58g4D5RBDa9BV+/tG1LaF5d/KyuPzlOe
	 aMsBMsL11kUcyD8VQLhW0tmUtdv4LQdC2Rs626MbT6UUykMl6N5knUD88L++mH0DWqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=QIRBOzhl;
	arc=none smtp.remote-ip=139.138.61.253
Received: from esa8.hc1455-7.c3s2.iphmx.com (esa8.hc1455-7.c3s2.iphmx.com [139.138.61.253])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FFA606A87A;
	Tue, 24 Nov 2026 09:47:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71FFA606A87A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=QIRBOzhl
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795513660; x=1827049660;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M5NqBozgTmQWYS9D9HJSCp5Du4EFXSk47fr9zjJkO3M=;
  b=QIRBOzhlGFqjmQkw86iKR6QcbxzUuAO997/h3zS/1jiqQ+dKy5m7DMDq
   MiX7gmx90c/SC7XqYkInVX9IzMP2gBxkSipmUKqbFzJ8U2+1ynD8VgHpN
   It37lWqTffN4BIP1HeiHRRTL2FbrAxq2yxNu/XJI2nRYNkJ2CUXDyb9Vb
   0fvfqCnHQbrzeeR7nnQVnMomxGeIUYjMvdJ/3eCsHhxmdDwRG4VwIqNAM
   D1buiHbM5Ht8vHlmuoAANi5cVm+Ez51KGn/nZCL0JPB39zfhBiZgdjdtb
   q7PzkIGhsp3FzitkNDxXRusS997Pnyzt7ll55NLmKqKqkXHtvad99WIa2
   w==;
X-CSE-ConnectionGUID: Kxt87SasQr2zj2SrCRZA/g==
X-CSE-MsgGUID: O+CkK1/nSX2R7aqnKx7Plg==
X-IronPort-AV: E=McAfee;i="6800,10657,11975"; a="250865861"
X-IronPort-AV: E=Sophos;i="6.27,230,1786978800"; 
   d="scan'208";a="250865861"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 18:47:33 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 5465AC05C53;
	Tue, 24 Nov 2026 09:47:33 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 081191800277;
	Tue, 24 Nov 2026 09:47:33 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.1.165])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with SMTP id C668B1800528;
	Tue, 24 Nov 2026 09:47:23 +0000 (UTC)
Date: Tue, 24 Nov 2026 18:47:22 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: arm64: CCA: Prepare Realm memory management
Message-ID: <awVZ0UrEKN9gLHIZ@FCCLS0092175.localdomain>
References: <20261123104233.95710-1-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261123104233.95710-1-steven.price@arm.com>

On 11/23 10:42, Steven Price wrote:
> This series adds the memory management plumbing for CCA, building on the
> basic RMM support [1]. Thanks to everyone who reviewed and tested the
> earlier versions.
> 
> The patches introduce internal Realm VM state, prepare Realm stage-2
> setup and teardown, and provide RTT mapping and invalidation helpers.
> Realm memslots are restricted to the lower half of the IPA space because
> the protected and shared halves alias each other. The final patch
> connects the helpers to KVM's stage-2 MMU operations.
> 
> This is the memory management portion of the larger Realm host series.
> Realm descriptor creation, REC entry and exit, activation, and the new
> uAPI follow in the integration stack. This series alone does not enable
> Realm creation.
> 
> The integration branch [2] includes Realm creation, REC entry and exit,
> and the remaining host support on top of this series. The MM branch [3]
> contains just this series.

Hi Steve,

I tested the v4 integration branch in the same way as described in the
following thread, and I haven't seen any issues so far:
  https://lore.kernel.org/all/avV-P2_fOkFWQVnM@FCCLS0092175.localdomain/

For the series:
Tested-by: Kohei Enju <enju.kohei@fujitsu.com>

Thanks,
Kohei
