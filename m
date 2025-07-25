Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435221FC3;
	Fri, 25 Jul 2025 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753433889; cv=none; b=gm5tTyKSAw3uBd8k74hUliBulMhGd1l8mjU3ALj44OG39fyQsDdy7Nq9pn5l71vd/Y7KUjj2dXfmpwD/FkR3ueUdrYCDQTGG7liNz2c9XvpwmCweZMR2bCrPnvo4ZcH04ZI2ri9XUC6h+8ULNr6J5gkg5gXkfVpnIjxE1iymy4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753433889; c=relaxed/simple;
	bh=QtxpewwK7kkW/Bjl18jPOJCT95GV3NoscW3glHHVwjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLf9T3D0hBX1q2vihXa/r9lR2d5IDu2f+zTDpxOpkAByKH0Os8XhwuHUByGRnaBTLADsJ1rpttPdi9tJXSyLMeJyObj9kEINyk9iHOSZsl+ksveDgwIiLD4pIdd1FHYxBzvZVn/UzPQS9XlmZ6qzc84eaI8hXy2qmAnZKCirtqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gF2Elkoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gF2Elkoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF9AC4CEE7;
	Fri, 25 Jul 2025 08:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753433889;
	bh=QtxpewwK7kkW/Bjl18jPOJCT95GV3NoscW3glHHVwjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gF2Elkoq1uITtu2enh9+w6hxDy4ixmMCri32Tk+lYTGc55W+GA27U4uo/vrR58cEC
	 FTJGMvPiisjMIsM4NgIQn3h1mVx/YxhHsLdT/hYtj+mfSdhGujPxsBqUCi9KE0lMI/
	 I0a8fMmmfi0/EQu/DWdI9edrPnNJHECQDhgEAaJU=
Date: Fri, 25 Jul 2025 10:58:05 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>, Tom Rix <trix@redhat.com>,
	Christopher Covington <cov@codeaurora.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 6.1.y] KVM: arm64: silence -Wuninitialized-const-pointer
 warning
Message-ID: <2025072553-chevy-starter-565e@gregkh>
References: <20250724-b4-clidr-unint-const-ptr-v1-1-67c4d620b6b6@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724-b4-clidr-unint-const-ptr-v1-1-67c4d620b6b6@google.com>

On Thu, Jul 24, 2025 at 06:15:28PM -0700, Justin Stitt wrote:
> A new warning in Clang 22 [1] complains that @clidr passed to
> get_clidr_el1() is an uninitialized const pointer. get_clidr_el1()
> doesn't really care since it casts away the const-ness anyways.

Is clang-22 somehow now a supported kernel for the 6.1.y tree?  Last I
looked, Linus's tree doesn't even build properly for it, so why worry
about this one just yet?

> Silence the warning by initializing the struct.

Why not fix the compiler not to do this instead?  We hate doing foolish
work-arounds for broken compilers.

thanks,

greg k-h
