Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8950528C03E
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746637213; cv=none; b=YAG3nB3/23AgXNHw0G9g2WrQ5e5pNvWiRXLeOpK7oG44smlk9nHb8az1s+2vOgOEGAq0YgltfAlKOjkbWzhhdqipqR9cQQnJ5sO7FAJxB06FHbCqQmOmvwllB6SnT1j9iY3Bix3/rKgDnzSe1VFMv1Yx3G2F0vuw5CzEwUqLvng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746637213; c=relaxed/simple;
	bh=2dSCKPDvn3TGxSFURsKuX/M/EoIw4BFzv7JwOPbxv3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMkMhTPAguBZTDIY3gNpVUGnPTWBU6I1QdAPdNQt7ko0nc+4/wgEWB5PNhOTY1VGTXg9Me0O9WtuvpmiGjRXShMtpqZ4DXORrTYINmDMjJiuUrWwmXQOftoGRMVQkqYi4/EbZMNd9qU5tjb9OYKZGe07bJsyPzyvd8hVfZ9z8/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iPQgkEJ+; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iPQgkEJ+"
Date: Wed, 7 May 2025 18:59:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746637199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W7RbClqZDTLPIsrG1S6Ef3Cx9TH5IxacJLeHcWQor0Q=;
	b=iPQgkEJ+LZyyl/HYCCjGx+TlqTyj6+oXTCTr2iCCajrejVHdrHtoSUQVkfrZVnDUIOQHug
	4GyuA2SK4xRhYb5L+TI1iB+OvEMac6eC/bhzcaI40imZ2TaCvfZ6j1ie7uTbqZXV4Rlg+R
	AWMOBZDFdZBSB15+VhsrVqDGy7MjiKQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 16/16] scripts: Enable kvmtool
Message-ID: <20250507-41058efcb1f4f05fd98d8deb@orel>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-17-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507151256.167769-17-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 07, 2025 at 04:12:56PM +0100, Alexandru Elisei wrote:
> Everything is in place to run the tests using kvmtool:
> 
> $ ./configure --target=kvmtool
> $ make clean && make
> $ KVMTOOL=<path/to/kvmtool> ./run_tests.sh
> 
> so enable it, and remove ERRATA_FORCE=y when configuring for kvmtool,
> because the runner will generate and pass the correct environment to
> kvmtool.
> 
> Missing is support for EFI tests. That's because distros don't ship a
> EDK2 binary compiled for kvmtool, and on top of that kvm-unit-tests as
> an EFI app hasn't been tested to work with kvmtool.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  README.md        | 18 +++++++++++++++++-
>  arm/efi/run      |  5 +++++
>  configure        |  1 -
>  scripts/vmm.bash |  2 +-
>  4 files changed, 23 insertions(+), 3 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
