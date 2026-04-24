Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB98739A7F8;
	Fri, 24 Apr 2026 11:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777028890; cv=none; b=EcjnF/HGYzLIPIR3vfOqM/jvVx0RlxggqPrnaA5Jr+TB/+xKvMzfY6QZb3gYbU5KOE1gOseL+cpwrxbla7jG9vGpw3veCLVHUF0mQ7oZ+4giHME/fiS6ksiMRB1DP8aia/5yw7nSqGVV7DQzd4Ev+kibQVbMMSGN8/l+PZTKQdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777028890; c=relaxed/simple;
	bh=cmSla55ceuCbLiK30aqfSAllXwLZ2tM2r3ifRj5DUwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kswStqqz5xEwp4D0R7OFLGAoMsTWwwJXCbV78URmdbYTEqmznBdPoGvc0/xNfcoea0VPHNxuB5GJbjvB76ZI965pyOLL1sNrEp5a+tXa/lxcVCgw1jhkbqSEkgydHhKKjE9ur0bG7xcI0QRA23ypzZuBY6rzRjSTSxKrPNEtsdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBb/hNTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBb/hNTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4DBC2BCB6;
	Fri, 24 Apr 2026 11:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777028890;
	bh=cmSla55ceuCbLiK30aqfSAllXwLZ2tM2r3ifRj5DUwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBb/hNTAcd75sQn1Q24gofMGtsSOC2duEKWZgSdOuB8gWgI2gXbaQOc17YPe1fWlX
	 6lbv0d7o1Q5rpU8W0H04GkZ1bTwtfJf+MXj8uLQwBTb+nN6kdTUP6tgoCf/R59irTL
	 tzVNAxU7AwLJmRrKdd95N/wH1Z2GiVTFYObvCjVlSFK+uoQqNFfv7IjyIqTC9jXnbK
	 r8B3a2dV/LyTHYnr9FKcZMZmyJ4eO7Lxf0G+lJmxw7m+KsnZxmOgOMugvzY3ihGNmZ
	 x6pe2P3fhZcG2Pm8YPJTNcus3CDN+l7qQB2tFawDOp8UMlUGUxiFOnKjMD05xGchSC
	 vagYo7CTAgnsA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wGEOG-0000000ELuX-251e;
	Fri, 24 Apr 2026 11:08:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	android-kvm@google.com,
	Sebastian Ene <sebastianene@google.com>
Cc: joey.gouly@arm.com,
	korneld@google.com,
	mrigendra.chaubey@gmail.com,
	oupton@kernel.org,
	perlarsen@google.com,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Reject non compliant SMCCC function calls in pKVM
Date: Fri, 24 Apr 2026 12:08:05 +0100
Message-ID: <177702878144.537738.10946354960670336499.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260408114118.422604-1-sebastianene@google.com>
References: <20260408114118.422604-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, android-kvm@google.com, sebastianene@google.com, joey.gouly@arm.com, korneld@google.com, mrigendra.chaubey@gmail.com, oupton@kernel.org, perlarsen@google.com, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 08 Apr 2026 11:41:18 +0000, Sebastian Ene wrote:
> Prevent the propagation of a function-id that has the top bits set since
> this is not compliant with the SMCCC spec and can overlap with the
> already known function-id decoders. (eg. if we invoke an smc with
> 0xffffffffc4000012 it will be decoded as a PSCI reset call). Instead,
> make it clear that we don't support it and return an error.
> 
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Reject non compliant SMCCC function calls in pKVM
      commit: 480ea48cad873b49a1fabd07c0847c3cf1c32286

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


