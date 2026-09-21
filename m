Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C49248820E;
	Mon, 21 Sep 2026 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790004411; cv=none; b=uD2dwOyeiaHtfLqUju87Vv026QPpQynknMp5yDLUPnfHzZtYNDlppVeBlDfMNpwQADLfgL1sPBSUsRXIvNY/nTCQJfaw4+ix/ZuO1m2eGljsev/cRmA6XLBEeHZmY9KvsnubQN/JYymd4wsskv04SiObXhly9JyJlzYmiOzAJt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790004411; c=relaxed/simple;
	bh=crAu+rO/8jjpMeszBXQph4x7yIoYqyBep9PV7qmQuK8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hAJWDQK9ezaRTUdod/q3/ZhRt5RHfHJ/yASD+Ic5SuW1aWqw3ouBIPKk0eoduiGyQRZcmNffydfzbdjB85N4OdqdbvKu8jsn0qwXPFXEQpeHami0ZPrLZe851iY5CMIm15ziHAvt+g7AvmjvNa4sUQh7cSlA7NMl6WU5h15KNJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXOCMPeO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXOCMPeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B931F000FF;
	Mon, 21 Sep 2026 15:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790004409;
	bh=crAu+rO/8jjpMeszBXQph4x7yIoYqyBep9PV7qmQuK8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kXOCMPeOABC3WIWc0m2aMa53Wy1vci2Ph1we34tBe20fflS/kwx9hhp/Bh2Uo+id5
	 e6dy3zdJ14+pNdpep6sBKlIMjn3Khyu9Fehxt5yHD/bXdzQ+/hUEwmutBQ88ho5LXl
	 9OPClu0cxwjagvWcavMP05o/JjEt3lVfuRCHGM0taw3BZXgz/On7tIzHebY2HeJ9q+
	 EMbKmUEBXIWCO++8CrCDYqtnvfwS9etcFOBXWgmLW2TFA3sVnOSVHEy/Oxl26bbs9y
	 A4Jxo92CBcSprJG84NCdVoSDEbokDxtFGJwV4uc7ucTkSfhbPPRtSbgjRca+9MgtQY
	 qJVNPaTSiDWrw==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"T.J. Mercier" <tjmercier@google.com>
Subject: Re: [PATCH v6 7/9] dma-buf: system_heap: Enforce shared-granule
 alignment for cc-shared buffers
In-Reply-To: <20260921123725.GN11599@ziepe.ca>
References: <aq1V3oeDdvXobt8J@arm.com>
 <97c30fce-9bda-4c61-b1b9-10297b89c8d9@amd.com>
 <20260918153642.GD11599@ziepe.ca>
 <d8123f21-d5ce-415b-a05a-392d97b8b57d@amd.com>
 <20260918165315.GF11599@ziepe.ca>
 <6115eaf7-21bc-49ce-8a74-08fd37a1e2c9@amd.com>
 <20260921115141.GJ11599@ziepe.ca>
 <45dd7a2f-8474-4388-b383-2dee3ee62206@amd.com>
 <20260921121739.GM11599@ziepe.ca>
 <cd2b32dc-5a80-4ef5-82bc-dd41ea96dc01@amd.com>
 <20260921123725.GN11599@ziepe.ca>
Date: Mon, 21 Sep 2026 20:56:41 +0530
Message-ID: <yq5a1pam4ocu.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Mon, Sep 21, 2026 at 02:24:21PM +0200, Christian K=C3=B6nig wrote:
>
>> I also don't see where mem_cc_shared_granule_size is added?
>
> Patch 1:
>
> https://lore.kernel.org/all/20260904103452.1197239-2-aneesh.kumar@kernel.=
org/
>
> Aneesh, please be sure to use get_maintainers on series like this so
> everyone gets cc'd.
>

For v7, I included only the maintainer entries because the recipient
list was getting too long, but I added the mailing lists.

-aneesh
