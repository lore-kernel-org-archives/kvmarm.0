Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795713371;
	b=W851NOoY7IB2cfH310fHtNs6ab7JsLFfwdxW2faQIzgjVeaSSwluPgY7o6ijDu7u+3OB
	 SJPiENET65xSLWTs2bFnwxJUMM03etbXTIuTFOPM1v5m3cLUTD2duZNMtls2rVcVVKBJF
	 jDSVa2jW3A63uwyWfCJG/nL7lVhmTiFVOcr2mDComwquPFpYBinsTxXI7Uj4KU+9qr1EU
	 V/uGSUZtL4NShtEU578g6dpzhnNRs6nS8fUZNbBFco22ZRFMpDVkUk2OT83i62G/dG+Mj
	 13PcLiv94LhCrDz+bbsa3DUZZBJYkopC1hM3vPijz1xM9OQfq67inBJsCrPQmLfwP+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795713371;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=G2SxOXFbti58OftIcIbEyeaQ/Bh9y3GZ/JtSGGzDuco=;
	b=M6AfAxucGGCPduaXouFwXJ2VTK8jmtMx7FO0lPl1pm6pqDLJrfgpfuUuTfREwFq+H5RM
	 gUVEUUZ81okHck6s2anDYNXi0erpo2VUPS07YtSETDr0M1ZnpvLM1HPWU6p77GC6Mn0jf
	 OheLJmnBgTSDmDiC9GQYRTxGayYMExa3mLNOyKYdEx6KQ/+N+hAu+AVaeF2CIB4pS3/Cq
	 7MSgQZT0hg7fZ2SwRTjWzYqpDvQ9TQayOZarF2mFa6sX2FshZvIiOkwbou1R310w7KIU9
	 RuHT1jRwr/TKOjRrSbE1QUdGw/Z/qiT5rJjmKALezrQ1krzrh1ixvMvRYaWrHlO49tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G2WWxMJ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB54606A31C;
	Thu, 26 Nov 2026 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G2WWxMJ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E9B1F000C0;
	Thu, 26 Nov 2026 17:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795713371;
	bh=G2SxOXFbti58OftIcIbEyeaQ/Bh9y3GZ/JtSGGzDuco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G2WWxMJ5d7ASDJW69+3Vrl5OHwhhvN55/kJ0DFRPOPOmf+E+3q3QT966bZ0z3mjR0
	 iTTNWy8KYETTUrbVMU5YR7j7p7l3v0kWsV22JgNsIa2QkqZEhslVLIUj1OUhx4rfe+
	 YrXHdNe76Ef+m3ulZEvL/bSdrhRrAI6P8xc5KuPpucLZUyLaveaYPdsDXeC2FRooAx
	 20U/nS/ark9kPgtsApHGaAokl80brROtnapQ6J5Wmer1329PWsJyTcVEHasIr4unW3
	 IS9vyM69p29TjQ+9DhZqRnGvu3gufakns0IzhBTeMpHLfypGcgyMi8SYt3n53QbWNL
	 6v1a53QFqBMbg==
Date: Thu, 26 Nov 2026 17:16:06 +0000
From: Will Deacon <will@kernel.org>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Sascha Bischoff <sascha.bischoff@arm.com>,
	julien.thierry.kdev@gmail.com, maz@kernel.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH kvmtool v6 00/23] arm64: Support GICv5-based guests
Message-ID: <awhpViXFw-mts2ck@willie-the-truck>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
 <1aa97f61-b740-4044-9065-f3ccfcb709fd@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aa97f61-b740-4044-9065-f3ccfcb709fd@arm.com>

On Thu, Nov 26, 2026 at 10:22:56AM +0000, Vladimir Murzin wrote:
> I reviewed and tested the patches for GICv5 IRS support (01-18). They
> do what they promise - allow booting a GICv5-enabled guest. In my
> opinion, patches are in good shape, so could you please have a look and
> consider merging GICv5 IRS support (patches 01-18)?

I just hoovered up the pile of kvmtool patches sitting on the list, so
this doesn't apply any more. Please can you send a v7?

Cheers,

Will
