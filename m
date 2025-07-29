Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44544F507;
	Tue, 29 Jul 2025 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753803963; cv=none; b=rRJWTJj9uDYb0F6GGqaB3q2nYcnyFILaZrBFpM5SGgaJlSiTqt3T3hCR6W6KLAjfRNNnyKqKb6bnkUIIflTWGV3MMTZliihRYTdlNaGlCAsfqMIozUrecLb239VUFrCSqf2SIDWkiNdD4HxZwj2mpf1VRuLUwJUB+6O7vmLypzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753803963; c=relaxed/simple;
	bh=4YBP7bjTmcEyufPY9qHcuguK4GFCavlwRWIMbl06Fws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iEY5iKapK5q/GeSwlmY/9MkLLY66Ry6MS4cw7YHMLbFp4jrgGw9Izc0NABfURdN3t8narUgzN+Ak9z3lO41pj/GaYsrxqwhhSncDW+2ciOC8THQ549XMAjwZMyiL86y7IwQzdnRoHtoXZvaRaqtUU0Sq8boZCedqnNPVtITRt3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YhtoCGBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YhtoCGBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8581C4CEEF;
	Tue, 29 Jul 2025 15:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753803962;
	bh=4YBP7bjTmcEyufPY9qHcuguK4GFCavlwRWIMbl06Fws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YhtoCGBap7n8cNG4zP6qLlRI20uQk5TgWxoGGHrnY5t4jncdHWAnQhas2rIbNv2fI
	 /qTDwZWbw7Y1C22F4eJX8mx1Zl6dGXY3TbCEy4cNgEkrsQIztDR/tUdHt4bGyfhXWp
	 oS3DhCkMamKECE3hWtgNzznDphfwhoFls/h+BOeeO/lptpwkx8nTjJzqJ7uIiqNWec
	 E5CssrhjQeOLeBS8p+HApEEZ4nutWdGXIiUgpAduDD/m0xIMJ1yp0LR2RqccN2rgye
	 tJh7IGVHqcTfs5soP4Gb9Sp/HyMLfWF4nvpWgfs9/RfRrEHn06XvZdDnC/MN5kGjnJ
	 MITaUJ7vPj0OQ==
Date: Tue, 29 Jul 2025 16:45:56 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ahomescu@google.com,
	armellel@google.com, arve@android.com, ayrton@google.com,
	qperret@google.com, sebastianene@google.com, qwandor@google.com
Subject: Re: [PATCH v8 4/7] KVM: arm64: Mark optional FF-A 1.2 interfaces as
 unsupported
Message-ID: <aIjstHFfEoSqEy0F@willie-the-truck>
References: <20250719-virtio-msg-ffa-v8-0-03e8e8dbe856@google.com>
 <20250719-virtio-msg-ffa-v8-4-03e8e8dbe856@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250719-virtio-msg-ffa-v8-4-03e8e8dbe856@google.com>

On Sat, Jul 19, 2025 at 02:11:26AM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> Update ffa_call_supported to mark FF-A 1.2 interfaces as unsupported
> lest they get forwarded. FFA_MSG_SEND_DIRECT_REQ2 is not marked as
> unsupported because a later patch in this series adds support.

Please add it as unsupported as well. Then the subsequent patch which
adds support can remove it again, that way the series is bisectable and
if (for some reason) only this patch gets backported then it won't
cause any problems.

Will
