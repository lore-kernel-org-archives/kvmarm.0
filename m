Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793019811;
	b=mWkiU4u/20aDYGFRFVjnQ54xKuseA7YzO1b0TrZ9eaxD9zNMGDBPPE8foQlQN8k8wxBv
	 bQ1l8Y/H9OEGzCHNUAIDd1YI7vR/LbmFqVL1PWnxKiwCFS/ti/4HlXNndmIgYLW1wBVQq
	 cs88X5xvf2ZKfuu8XGgo7DskplxQLs43tNBKqZeHD039aWcQ2UKTK8wyzZIj5ZS09BKMN
	 3V2aNTTY7MU+rNDjIOhVzxwnmmHBhE1P0FRLGJ5DVor5xjQwSnWbBAINDIqoLTyl2iB3S
	 MoP/RBy9rVdbzNtLggTVPG4nmVHWLfFSWIQ53WYCVfL88j35UQIQ9NLTYcJ3HzDDmMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793019811;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=1PjUtycGouJlBVw7CED+koNg02erEJR7qDh14L+3Vtc=;
	b=1KIa2m0upZijnYXKlhlndK7sY474cjp+s6aKrO+IZQC34c5sWOE/MHf0xfEGLhP6fkkp
	 p/MZAfWvgIoYXfTW1flazs8JMvZJ5iDXk3czlOA6mh+n/5j/ZFw1056WL8TQTy1cVU6lY
	 4gd6gudgUS6spBH+yCafTq7ADRjRHjo1hlQEYsul5E/SXukz9wq62fSe+v7DGrwox+RUU
	 digyZkyzkBl1VApiXbjUlAyR4+cTWBoz+fB5bvs9kAnHu+PaaLy5ScIGVTZsvHAE15C0B
	 7vIfCzOFu9nCNYyZAfBuMLF4ypliYCFSwWoK2t6eAg6Ze2oOMwliMlYH/ZyxmlkdEDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VBJcpTwq;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC63A606A325
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 13:03:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC63A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VBJcpTwq
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF42E25DF;
	Mon, 26 Oct 2026 06:03:26 -0700 (PDT)
Received: from [10.0.152.204] (e121487-lin.cambridge.arm.com [10.0.152.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6D893F59E;
	Mon, 26 Oct 2026 06:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793019810; bh=1PjUtycGouJlBVw7CED+koNg02erEJR7qDh14L+3Vtc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VBJcpTwqMayv1hZhvTkY9XGKP5YY+XnQV/u0h7obPU2K8slTEiLLEQEUf7ptPdyMO
	 zQuto3ERS2OaaXzvQ8ESDyTOnIPnwrz7twS/kavBwhgjhwPzahb+F3jdR+1xuznHWW
	 dgl1uxdDzv5UaaOF/NXySQpFzAW7AXn85KXDCjno=
Message-ID: <412dc63b-df1f-4748-8235-542ecfc23894@arm.com>
Date: Mon, 26 Oct 2026 13:03:27 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v3 13/21] arm64: Describe the GICv5 IRS in the DT
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-14-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016153939.913764-14-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/26 16:39, Sascha Bischoff wrote:
> Describe the IRS CONFIG and SETLPI frames and associate each CPU
> phandle with its IAFFID. This lets the guest discover and configure
> the IRS for shared interrupts.

Out of curiosity why do we expose SETLPI frame to a guest?

Thanks
Vladimir
