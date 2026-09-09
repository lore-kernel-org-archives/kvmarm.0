Received: from mta1.migadu.com (out-146.mta1.migadu.com [95.215.58.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB6A3822A6
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 07:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788939443; cv=none; b=DxSfiU3pVGwyao0A3S1apETtQBmqHu8YVwOgO7mcJfl8CDdrHAVPv1Y7mZ34Kk9ti1QE/YiiEtOhyA5Yy/wqwzLUDEuDk5ArPNOZhFwGLGOqX4wIkeTRSSctnyHOJ4PriyzdWC7b4S0D3pER8CnkqKcfPJW4jxauELPCZ0POGOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788939443; c=relaxed/simple;
	bh=W3MflD4KvxfjlYvuaglkAbbfr+JQGM3DGNPD2OgqTvE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TskPxkyDb3Lz7kogj9SfmvYXmEUJmVwoeC2K0VnQmdnzMgbR7ttEg2QepxZH+zZrk7h9shsTfruaVWw8w2jmTXtsSbwX3DxX27QjhgTyWXUbet2xvw8buK01Rzthwnk9Q0KTbMK0R/Kd7BWODeltakuh9CmYvR3tSjkItIgE1mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SDZYU/Ec; arc=none smtp.client-ip=95.215.58.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SDZYU/Ec"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=W3MflD4KvxfjlYvuaglkAbbfr+JQGM3DGNPD2OgqTvE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788939438; v=1; x=1789544238;
 b=SDZYU/Ec3V5iIZ/wn6MiFBPF3I5zErZxrcAMMv8ENdNDPH6BH1HwJFjuZ+UR11IGTsdBjZFX
 WTLjvF6w30kSSYs7uZ2kqIO3yyeTX5J1yOoEgMftrhp2xCdUjbwxw9G1R6u3QnTnJ4Mgc8dZECA
 ljLcYd3EMwJ93pDpJUi4kqx8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cce488203a215758;
	Wed, 09 Sep 2026 07:37:18 +0000
X-Mizu-Trace-ID: cce488203a215758
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so4640e87.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 00:37:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx+LgmrqleAi3YzwUC2DHBXqvnnoG+ffWlAOAKRBqU54kj+HEFaxcnqb5dvaz2fHfzqYrBCXIA=@lists.linux.dev
X-Gm-Message-State: AFuF++l4PFQ07U3gMIfqV+B5ZBLkOwUffXa+CYqg8vW3vhl/KrC50GXL
	W40lm0PXVQRY2Ow2rnaqb+AtqvVhZpKweTvZaVc4Nnem11rmP8RZ4fTh7RFRWVV6sqdDHO1j5+3
	58+H2ecsoVGGJFKsHbQSfMB5MOaFP6XTBmwN6fDoZ
X-Received: by 2002:a05:6512:288:b0:5b7:78bc:ec07 with SMTP id
 2adb3069b0e04-5b778bcee15mr17247e87.14.1788939437032; Wed, 09 Sep 2026
 00:37:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260909063156.89636-1-kmehltretter@gmail.com>
In-Reply-To: <20260909063156.89636-1-kmehltretter@gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 9 Sep 2026 08:36:40 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx3fmj_fkD_ybPANyTrEApMUyBscfP4JtP-F_MRL-L=2w@mail.gmail.com>
X-Gm-Features: AcwNN1X7nBSrvOxVUlaJ6opTCQ7kc3b4t69IqzHQ2RwkJ6z5rM4K_pY4NvS2qiE
Message-ID: <CA+EHjTx3fmj_fkD_ybPANyTrEApMUyBscfP4JtP-F_MRL-L=2w@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix kvm_get_vtcr() kernel-doc
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Quentin Perret <qperret@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Karl,

...

Good catch, I'm a fan of documentation fixes :)

While you're on that line, the description is also inaccurate, so you
could fix both in one go and save a follow-up touching the same line:

> - * @phys_shfit:        Value to set in VTCR_EL2.T0SZ.
> + * @phys_shift:        Value to set in VTCR_EL2.T0SZ.

kvm_get_vtcr() sets T0SZ to 64 - phys_shift, so phys_shift isn't the
value written to the field, it's the IPA size in bits. Something like:

     * @phys_shift:    IPA size, in bits.

Cheers,
/fuad

>
> base-commit: 893e11787f78e43b534e252249ac3fff4d1333f8
> --
> 2.53.0
