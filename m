Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7E04189BA;
	Tue, 22 Sep 2026 09:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068987; cv=none; b=PGUZnEiCYQRKfjkIHeKIoDE41dxsXvrcCk54A7JxNzi4NwHrs9+UYsBxZDWcBMV5/nHwY5y/6zwn38LiSBq1jr3cVUvDJX8sXBReqseTdUMbOa4Nyoov8ZrFtyZRnuK4Z8F+qNUoCgVAtoeZxsVrd5LOHWy5ODCVkwEBC7y7vuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068987; c=relaxed/simple;
	bh=FtBsQVszZToNZFo4FDYyz6W2EQJ6IchG7TUR9qBW2W0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JJy+3FoeHWY3S22Up8DdyF9QJZcwXDhY8AbPSFqWKL2UOo9mEQdkh1rRcqVNfuV622XQb7Tzc6k8Be38LJz0C1A74cquHwbEVTa3plyWwW7YGWZO/JQMKmW6aWJQzim0fmf6loOyZzOTgTSDaRWVIG3/Ef+yhcCQ0oqVA06Ibxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxe2mLJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxe2mLJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A6E1F000FF;
	Tue, 22 Sep 2026 09:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790068986;
	bh=NutOSYDLx4tH7KuShcZDI2ZCU5oaHMNdqUgaoku7+KE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dxe2mLJ1DOdNhNV3xzN1UWDf+WAxUJqwBE4m6EJ8NqGqMYw2Un9GqdAuGdl+aORRK
	 OOuly+6n/2Smj6x6nJ/bOPD3LPqGVwEgru3T9Vb+N85YpEQzsVx7tkk452Eeek4d/v
	 X2tCmChMlWALczUB/ok3OKDy5Pkriv+suNvrO/+iJyW8AH3cGofJxfWC9J78D8d7Y1
	 hlBIEb3Pyp1cOg9/cbPJRDn08GOTBEbkvDNtthfYmxt2g83xX9j2cEdBLyAulmkStx
	 hP52w+r2XFU8Qifn8Fz2BbYPQ8i2S5lOEPECaC6ZD6f2/BSRfM/DG0E3+4HtLwkf4u
	 9Rucyt3uOjauA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	oupton@kernel.org, gshan@redhat.com, joey.gouly@arm.com,
	tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com,
	fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18 00/23] KVM: arm64: CCA: Add basic plumbing for Realms
In-Reply-To: <aqrsmUTxDVbKJn8k@p14s>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <aqrsmUTxDVbKJn8k@p14s>
Date: Tue, 22 Sep 2026 14:52:56 +0530
Message-ID: <yq5aecel3aj3.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Mathieu Poirier <mathieu.poirier@linaro.org> writes:

> Hi Suzuki,
>
> On Tue, Sep 15, 2026 at 05:01:18PM +0100, Suzuki K Poulose wrote:

 [ ... 42 lines skipped ... ] 

>> 
>> [0] Arm CCA KVM Support v16 : https://lore.kernel.org/all/20260803134403.80630-1-steven.price@arm.com
>> [1] Linux firmware RMI https://lore.kernel.org/all/20260912083611.2513845-1-suzuki.poulose@arm.com
>> [2] Linux GPF Host https://lore.kernel.org/all/20260913070459.2547407-1-suzuki.poulose@arm.com
>> [3] https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/kvm-v18/integration
>> [4] https://support.arm.com/documentation/den0137/2-0bet3/
>
> When testing on the FVP model with the above baselines, I get the following
> error messagaes in a loop, preventing the system from reaching the command line:
>
> [    3.112577] Freeing unused kernel memory: 3520K
> [    3.115398] Run /sbin/init as init process
> [    3.142926] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> total 512 (slots), used 511 (slots)
> [    3.150111] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> total 512 (slots), used 511 (slots)
> [    3.177190] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> total 512 (slots), used 511 (slots)
> [    3.197194] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> total 512 (slots), used 511 (slots)
> [    3.217188] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> total 512 (slots), used 511 (slots)
> [    3.237194] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> total 512 (slots), used 511 (slots)
> [    3.257181] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> total 512 (slots), used 511 (slots)
> [    3.277189] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> total 512 (slots), used 511 (slots)
> [    3.297193] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> total 512 (slots), used 511 (slots)
> [    3.317188] virtio-pci 0000:00:02.0: swiotlb buffer is full (sz: 4096 bytes),
> total 512 (slots), used 511 (slots)
> [    8.157185] swiotlb_tbl_map_single: 241 callbacks suppressed
>
> I get the same result with v17.  Have you seen this before?  Perhaps a kernel
> option that needs to be adjusted?
>

This is due to a change in the swiotlb setup.

https://lore.kernel.org/all/yq5azeyxyfol.fsf@kernel.org

You can increase the swiotlb size using the swiotlb= kernel command-line
option. I also have a patch series in progress to address this issue:

https://lore.kernel.org/all/20260921063628.362078-1-aneesh.kumar@kernel.org

-aneesh

