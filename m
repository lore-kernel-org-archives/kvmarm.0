Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D2F4E236B;
	Mon, 28 Sep 2026 15:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790610881; cv=none; b=WIA3iAIETy2vyZwRxCv/gsx/57pzsFHG/nftEhMetLNoZ3FQ8oBJwI8S+fA5fMHxqGL+0Ccqd1apcvdIVyvCkfZlIM3PrlYBGg+i+qSWvdBW0Z1uCtxTOP1Wn1vT7un619uKRRHrVmEoVrEKEve5ujSi5JDHw2NJP9lWA0nYj50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790610881; c=relaxed/simple;
	bh=AsS3VpKdMJIReZJdOEyUNKFQyUQXieCfXs3/1MIC+O4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIVevW+ioAGHNlacXNnh9O8MPLU9C5fzcM444/fclr0cb+CBteXHCFY037pCysqXRuETlxQVQhtvAQMUlKiSkGTS361FmJ0gqhGBmL/vq1fpuFrMLp9D+cF5jLJ+LOfUQKUqF9tfH7952iXHZarozTLDRJAo6O7GQcRO6erp8S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUzQVflN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUzQVflN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93281F00899;
	Mon, 28 Sep 2026 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790610877;
	bh=sQo85MG3wyU15nJBOnccgwY1g6/b71wSOeHZX0glVCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EUzQVflNxx2xlAMFvK9LtMnYf1JF6PHS0LxGgnNYv71HTDC912f5UeQTlMnHcfXm9
	 PIhsaN3KsOHCYuewbTYdbEwssXqESYM9dpZrbbFpJP6DQfW0CiTCqDbbt6Z0PNoQAG
	 8A+B+zmUb+9DOgbOi/0NFEh926QoQfEtMFWISDOeXvGgjvZ6J80VSIcAUtHGFzLlsU
	 EwjCeWs9Qrwrylo1O/AofcPiFLz8rRcmLjHEMLmP50TfQRi3I3NZuyxa7D9yrSGOrR
	 67SiLU5pvKHj0iTiSgAWbyUfMxQ3OwN2wp5yy5PMnFXgbYvMV6zguU2bWz3RGs1eU5
	 ZxvEgUzI/S3+w==
Date: Mon, 28 Sep 2026 08:54:35 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 01/10] KVM: arm64: Don't WARN on SMCCC filter reserved
 range allocation failure
Message-ID: <arqNu0rSxIz4-Mue@kernel.org>
References: <20260928152507.2116110-1-fuad.tabba@linux.dev>
 <20260928152507.2116110-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928152507.2116110-2-fuad.tabba@linux.dev>

Hi Fuad,

On Mon, Sep 28, 2026 at 04:24:58PM +0100, Fuad Tabba wrote:
> The first time userspace sets an SMCCC filter, kvm_smccc_set_filter()
> inserts the reserved architecture ranges into the maple tree and WARNs
> if that fails. The tree is empty and config_lock is held, so the only
> way it can fail is -ENOMEM. The allocation is GFP_KERNEL_ACCOUNT, so a
> memory cgroup limit is enough to hit the WARN from userspace.
> 
> The WARN goes back to when the ranges were inserted at VM creation and
> the error was dropped. Since commit d34b76489ea0c ("KVM: arm64: Only
> insert reserved ranges when SMCCC filter is used") the tree is emptied
> on failure and the error reaches userspace. Drop the WARN.

Eh, the warn is still useful. You could potentially add a check for
-ENOMEM but any other return value is a sign of something wrong in
KVM.

Thanks,
Oliver
