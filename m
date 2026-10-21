Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.183
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792565316;
	b=x+fNsdxkltahj4M6CoUmosZXS9nC6Yje74CvUBjvREpo51PJAJS7Iq8fyUKvrCE0tJ1V
	 8+AWv6s4iEsCfbVCRtPzizQ8xqbRJeXbS77KCLLWDZlErdPXPkIRvYR/68+WX38EqbtCA
	 wWeMVNiS6uQv26eNS/hHPgtR7rxv228Tpj0jM40VJ160plvQLH3xuU2Ke0JswHYjju0/b
	 bg6V8C9HPFuqfDPV5dE8MP/VCILzJ0zoH8Qus7Jnl/5c7dLLKpypUb4jR7/Ue3nWw+F2N
	 BxYxB9BsveY7eYczybP3x6iIejN14LJ9NqfG2fYaK7817/N/CcW6cMhjPmtAyNZip8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792565316;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=ERCu28HOlccXBiT0hxEnKDMxA84fNeRxo/vPze54s84=;
	b=jGQ/IaNAGbZROxHdru0vLMk6EDuu0LhC/flc3ItLtRgMbqpIEAT17zeKr0ZZ60ouiALJ
	 n9P3/pSDrTLNOoxnfMyFAQqG0RMOoQ8hdwgvNdivTH4NmGRuJ8SsNPN9h/yZNM0N3MjBc
	 cpGpcB2xsyWb7wcj69GteCaFgIZNjHUad4DcmTunAhF554axXAh5cK5IukTbJcpTieOWx
	 B5PYKjrXH1ea7YRbK2cIWgSRlhMRtQualqqJcZQAxk6NCQQdCf8W5I///lBj5D3GnY1z3
	 RQuTRACo68Xz3NUX3QXKQcXuSWwLYKuDqWJdFAOtTL2Iky+L25ti/GdOD5mPs9ZW23g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YY1SrEEK;
	arc=none smtp.remote-ip=91.218.175.183
Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A8A606A319
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 06:48:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04A8A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YY1SrEEK
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ERCu28HOlccXBiT0hxEnKDMxA84fNeRxo/vPze54s84=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792565314; v=1; x=1793170114;
 b=YY1SrEEKVxG1rbNuxk2iFzF/uIuESWD3c70ybER5CJ2q/ybKyGBIS0yZOS/f3sMtvkkO6jp8
 tncyTSf61wFK+fXYDmQyLNMML+6oxaV6sQ/JayHidLOKrE3ySnWbpTAj9nYXLPP0hx5A3rjDX6h
 R56r8MKH8Ox8OWDsa+qEl2+A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 82d5c25462d3d5d9;
	Wed, 21 Oct 2026 06:48:34 +0000
X-Mizu-Trace-ID: 82d5c25462d3d5d9
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so6511e87.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 23:48:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzCVkQYJDKbwkgCMWqpEUdXVwtg0Bxw/w3zBQO5k51v5WP5EEQBtvLEvAM+vjT3pfCPa+7aDtE=@lists.linux.dev
X-Gm-Message-State: AFq9FYKcbMLdkrPtzKcT6GDhWhkXeo+oYtCfYIHd/YaKBHwT25LX69Si
	7N9s9Sn2grCnTKc5VM+TefdPUu5xs3hMjY9ffZKqMpOwOIYwG5Sx3WEDDmAjoCV66XKqRaVF1eo
	spPGnjg9WybtBsyXj3tQq2oNchjDfVNiHrMKRl/gR
X-Received: by 2002:a05:6512:290b:b0:5bf:63a2:27fd with SMTP id
 2adb3069b0e04-5bf63a22a04mr171664e87.1.1792565308065; Tue, 20 Oct 2026
 23:48:28 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261020163923.1407856-1-sascha.bischoff@arm.com> <20261020163923.1407856-3-sascha.bischoff@arm.com>
In-Reply-To: <20261020163923.1407856-3-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 21 Oct 2026 07:47:51 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx5Gk2aBFUAzAP8pa_kggwPhoJOvkCT6YtLg0dbQEBSZQ@mail.gmail.com>
X-Gm-Features: AclHuK_-J6_HJSmrppsH8jrPBh30NkV5zsuQqfHdht3jCK3LseUqzQwdv9UJsgk
Message-ID: <CA+EHjTx5Gk2aBFUAzAP8pa_kggwPhoJOvkCT6YtLg0dbQEBSZQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 20 Oct 2026 at 17:39, Sascha Bischoff <sascha.bischoff@arm.com> wrote:
>
> Check that a GICv3 ITS and a GICv5 VGIC cannot be paired, regardless
> of which device is created first. Skip the check when the host does not
> expose a GICv3 ITS.
>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>


Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
