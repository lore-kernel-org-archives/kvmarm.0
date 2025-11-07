Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61602D9EC7
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 18:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762541876; cv=none; b=SiDd+CEeb5sqLX7ojnMn5V55MNXNJwTA5CFF5AcYIkaR5UJTQXfZIpQPqkLMtUI9s1Mc1NNMzTmJwZjz1QGtyHXq+F/UCx6k0vOSmlib5OcGZu3MdN8lZQKXOE9pOkbXmPIyrt2JQPoE6ECgf0YZ2LZR+ekhTGwrvbKgBYz95tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762541876; c=relaxed/simple;
	bh=awyUGs0rpGKlK7qoN/xReG7QUF+ghsD5p1upAxbLLfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YxVHFE69tK9WhXxueCnN7AIgO2dIeuKLjrcHnwlauYMdnFVh6OEDGy1/gEg3NVsE99qrME1AvTOMPbADq4BGd+3q8/L4/gMf9HF5miJu+F8d7lHPWKLU5F4gJvaogmC0Qz3ftHOAtc3FgJh9gK2i964lb9JUHes2GVLFGqXuNRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niFj0L83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niFj0L83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F21C4CEF7;
	Fri,  7 Nov 2025 18:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762541876;
	bh=awyUGs0rpGKlK7qoN/xReG7QUF+ghsD5p1upAxbLLfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=niFj0L834blAvhm55fQPakks8soCRt7CHIzJIc542uN43IJeRL454mVe5C+CZJepI
	 7tAN/u4arc4YprsEUil1ybJGs99xRtr/syqXiAzuw/0l34OTTHWOATCNtQghR2djAN
	 CDZNx/ByneMMyxPcAN1s2vKIn+A1x0ToQ6DlGmP8PYJnlQ/TjSvGJ6MWkQTqAME3eS
	 LvJqFIHS4aDvw79At5RlkbtzdnXBBIVjzz2wYtro3LSSTADp/084X4ys+0cJFjds5u
	 t7DwcSBllmJ4tLjrav9C5vU8iyx+Yw9lE0N5FTTeIf4C8sgnWu0pKWRhAtwD8joFLW
	 tdQowzW7c58Tg==
Date: Fri, 7 Nov 2025 10:57:54 -0800
From: Oliver Upton <oupton@kernel.org>
To: Zhou Wang <wangzhou1@hisilicon.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	yangyccccc@gmail.com, prime.zeng@hisilicon.com, xuwei5@huawei.com
Subject: Re: [PATCH v7 0/7] Add support for FEAT_{LS64, LS64_V} and related
 tests
Message-ID: <aQ5BMo8FuQQGEM43@kernel.org>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107072127.448953-1-wangzhou1@hisilicon.com>

On Fri, Nov 07, 2025 at 03:21:20PM +0800, Zhou Wang wrote:
> Armv8.7 introduces single-copy atomic 64-byte loads and stores
> instructions and its variants named under FEAT_{LS64, LS64_V}.
> Add support for Armv8.7 FEAT_{LS64, LS64_V}:
> - Add identifying and enabling in the cpufeature list
> - Expose the support of these features to userspace through HWCAP3 and cpuinfo
> - Add related hwcap test
> - Handle the trap of unsupported memory (normal/uncacheable) access in a VM
> 
> A real scenario for this feature is that the userspace driver can make use of
> this to implement direct WQE (workqueue entry) - a mechanism to fill WQE
> directly into the hardware.
> 
> Picked Marc's 2 patches form [1] for handling the LS64 trap in a VM on emulated
> MMIO and the introduce of KVM_EXIT_ARM_LDST64B.

Besides the ordering issue the KVM bits of this look fine to me. If
these patches go through the kvmarm tree then I'd be happy to fix that
up when applying.

Will / Catalin, any preferences on which tree this goes in? If you guys
take it:

Acked-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver 
