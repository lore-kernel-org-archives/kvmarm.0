Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A908A3CBE9E
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 18:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777661699; cv=none; b=WuVZ651ImXlP5AiJECJebL4q8mpQ/V4K6efZjnDhCoDCFQwvU+ycn42Ivc6u/BWZhk7IFayibdMr+dg5wW4mfQ39TZDFuezgFbWXuRdrQU0HMIZEpPVTWGovgZI4fkp7dy+mKS3P9Y0PyUNJl6aTXoCMvT0Q615LA0Qpmdx6OIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777661699; c=relaxed/simple;
	bh=dcheq2gtdulc2g0JlS68aZSwyoZSfE7RjnC9DAk/F0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KvDreo7njza2G6QelOoLxGaCALnN+JNgeA/7dV1Enw8MY4usSL7AkIZY26CVwQ0ajPnom6pqp46SJVgxKx/+otCAACNxv77TKsQ1sct3SFG/KhLZNIdtiO6V2tUmm4vHY+D4jAEYFk7py9bCbe4eOiN+JINjHXPRN2nYV9dIWoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aNxXli3g; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aNxXli3g"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58E4043CD;
	Fri,  1 May 2026 11:54:51 -0700 (PDT)
Received: from [10.57.66.223] (unknown [10.57.66.223])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E07813F763;
	Fri,  1 May 2026 11:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777661696; bh=dcheq2gtdulc2g0JlS68aZSwyoZSfE7RjnC9DAk/F0w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aNxXli3g5wTSmB68mouLOemRqZ7r9XmhaJ3vpcb1cXd/NR2ZYumUCRzs56bjdHl9m
	 NhJ+RRJXPMaQWsL7IvWopUh0VTZgks4+TmLAZn7H3YIzYwRf8ktqgJnzqK6xW53g+Q
	 5UyVe2BtQt5J7i2tPw1lglNRCuITeLN91QFNi+Gs=
Message-ID: <187900ec-4585-42d9-946c-e6de3111552d@arm.com>
Date: Fri, 1 May 2026 19:54:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 36/43] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
To: Sascha Bischoff <Sascha.Bischoff@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
 Timothy Hayes <Timothy.Hayes@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
 <20260427160547.3129448-37-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260427160547.3129448-37-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sascha,

On 4/27/26 17:18, Sascha Bischoff wrote:
> +	tmp = le64_to_cpu(READ_ONCE(vmte->val[3]));
> +	host_id_bits = FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);
> +	host_istsz = FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, tmp);
> +	host_l2sz = FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, tmp);
> +
> +	/* We always use a Linear SPI IST on the host */
> +	for (int i = 0; i < BIT(host_id_bits); ++i) {

IIUC here we iterate over host's SPIs and save them into buffer provided
by the user. One thing I noticed is that if user set number of SPIs via
KVM_DEV_ARM_VGIC_GRP_NR_IRQS bellow 16, say 1 (btw, it seems there is no
way to set SPIs to 0...), it would be rounded up to 16 in 
kvm_vgic_v5_irs_init(). So from user perspective it needs to save just
single SPI, thus it could provide buffer just for that single entry. With such
setup we can end up corrupting user's memory. We can argue that it is user's
problem... perhaps we need to spell explicitly requirements for the buffer or
provide interface to the user to query required size or respect nr_spis set
by user or some combinations of all :)

Cheers
Vladimir
