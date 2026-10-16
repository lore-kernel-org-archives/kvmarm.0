Received: from mta1.migadu.com (out-143.mta1.migadu.com [95.215.58.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DC336F8EB
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 07:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136976; cv=none; b=IMN3gXP6Naas4nvlN/o3Ybmdb0DMwTVqqiIfliFK6vJRZzjwmmlon1zGrF7V/itytof6f3LQOzEuCOWaQgevhRzWPOG3aXSq7n7KmUueQKoMk/6nT7bPcZ/5sgg+vRD688D7xCi8oNKPjN4cNXq1i9BSq5qV2uWIaZv/IQIFvyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136976; c=relaxed/simple;
	bh=WZU0ITcIU0RDlLux+WU+QTQ4pBSZPCHTEfxzBG0C718=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jHSA1R7PvFfZrbWmO0qEMTmeAsb2afWqHtPbbuWr9fvybQeJVnL48cvi2Ib4VasLGGJwqYGwGMEjafdMj/hGvXXeMyUJ8mUhX3relMOtB/Z4sYULdqgZIZVAmAt5oLj0y7Vx1Y9EcDJDKlOb+TtIns7q2Z9asFf1PBlQXEM0tqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Eh8/ivjq; arc=none smtp.client-ip=95.215.58.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Eh8/ivjq"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=WZU0ITcIU0RDlLux+WU+QTQ4pBSZPCHTEfxzBG0C718=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792136972; v=1; x=1792741772;
 b=Eh8/ivjq8kb8BMwi1vj3K8S0nIwgXnO449Oum+tqLRTztwME2ILUhxI8/s1TGXjIm2arz7Aa
 pAaNSYbQkZzb7/maJXH8TWl+YequgiyD6UR+1f3+ZencgQdVJzeBvGOCLoJLjtQORMbPzAKT1CP
 BYe8zFADwj2/rRf/h/eJxLb8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7e2a2fcf4185b171;
	Fri, 16 Oct 2026 07:49:32 +0000
X-Mizu-Trace-ID: 7e2a2fcf4185b171
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso3310e87.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 00:49:30 -0700 (PDT)
X-Gm-Message-State: AFq9FYKX/jyJDRZGVj8psl4c7bEj6EEaENLeXgPbbS9wrHqP4DN5+hmx
	SzT/mZMkIf3AaJFJICmlyeMrj1dBWlqxf+bq4RCIX+RagiJLUecsaCo1f9ji1NdBMTIfKDcIpuy
	EXFLkrQP01EAwUCSgAgkwIhOhxjqtJw1Tal6nOAoQ
X-Received: by 2002:a05:6512:b95:b0:5bc:b2ec:eaee with SMTP id
 2adb3069b0e04-5be493c4cb3mr93309e87.11.1792136969950; Fri, 16 Oct 2026
 00:49:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261015173605.1072963-1-maz@kernel.org>
In-Reply-To: <20261015173605.1072963-1-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 16 Oct 2026 08:48:53 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzdN53MvWmvk+KcD2XEthjpgSivGkYAsc7r8JpEb=02LQ@mail.gmail.com>
X-Gm-Features: AclHuK8kpSMVjBqTkfq4Ie2CF_wEvKZrjX3oALmxM5tl73nYKwHuhkhXFGvtnPw
Message-ID: <CA+EHjTzdN53MvWmvk+KcD2XEthjpgSivGkYAsc7r8JpEb=02LQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Cleanup the HCR_xyz macros
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, 15 Oct 2026 18:36:03 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> Patches on top of kvmarm-7.4.

On kvmarm-7.4, every object under arch/arm64/kvm and arch/arm64/kernel
builds to the same code and data with and without the series (debug
info aside). Protected and non-protected guests boot in pKVM.

While testing it I found an older bug on a line patch 1 converts:
HCR_BSU_IS has been the unshifted enum value since the HCR_EL2 sysreg
layout went in, so guests run with BSU at 0b00. I'll send a fix
separately.

For the series:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
