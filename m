Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D7821CA02
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 01:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789867997; cv=none; b=CaLSSY6/+TOGxmZEU5BEPICjcVpARIDGdoD3yRRtiRE8UbR5oFf2gdrp0LDOJLFrV2h3JdOHs53nsM3JgFPlE/oSKbP0KqITuZ0xKapYNAkPPoFJfHp/Pz0uHYMeTxJgYZOJC7ZilXNeGzXEDYGBL6AQwoqR8J4UAqeZ4Y3MPT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789867997; c=relaxed/simple;
	bh=5zpZpGxLh4Xc825xkk+RerisAKufOfgMDCrJS5lXFnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mqMbx2P5w6gnvgi798WVi1RFvb0e4czw08CfETlWNktIEusLLEBM2qz89r66i/Ox0tkI2MnMIjkDfWi63tO3HDqDZZEKVk7O9MCYAcaRbgMWZDS3r+ZP6rTt2//wakF5e3sld2mMnNzBKNDKK1fiXoFh+cnnPqPVrr5Fi90ZL7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SOZeGbHp; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SOZeGbHp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789867992; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WpODz2I1SYGcsUWYzvIvLHX+tQtY3cfA1JpYBgPLg5s=;
	b=SOZeGbHpm68jLD+ehQ8WyUrD46mlNedg+OR9Hgil7RRHYN6evDofWk6YrvqfVfU7ZWMuvZ4oll6nILe+F8nmFV/M3MxiyMU5oKbNVl1ilrqJwi2JTG4HKiujeX6lAt0QwsyaSIRhToNr9bVxFJ4ZbCsNgDrTho47aIBNotEyNNw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XBEinmW_1789867989;
Received: from 30.246.177.75(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0XBEinmW_1789867989 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 20 Sep 2026 09:33:10 +0800
Message-ID: <b3da18cc-78b2-45cf-9ea8-ce867c631834@linux.alibaba.com>
Date: Sun, 20 Sep 2026 09:33:08 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/7] KVM: arm64: nv: Implement nested stage-2 reverse
 map
To: Wei-Lin Chang <weilin.chang@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Itaru Kitayama <itaru.kitayama@fujitsu.com>,
 Wang Han <wanghan@linux.alibaba.com>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260915154305.3852871-1-weilin.chang@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/15/26 11:42 PM, Wei-Lin Chang wrote:
> Hi,
> 
> This is v6 of optimizing the shadow s2 mmu unmapping during MMU
> notifiers.
> 
> This version fixes a few issues, and adds Marc's space optimization
> for kvm_guest_s2_mapping [1]. Please see the changelog for the details.
> 
> Tested by booting L3, and running in-kernel targetted tests described
> in [2]. v5 got some tested-by's from Itaru and Wang (thanks), I didn't
> carry them over since some bugs fixed in v6 are non-obvious. Some
> retest would be much appreciated!
> 
> Series based on v7.3-rc3 + Marc's nested mmu lifecycle fixes [3].
>

Hi Wei-Lin,

Thanks for the updated series.

I tested all seven patches on top of v7.3-rc3 with Marc's two
nested MMU lifetime fixes, using the L1 boot workload that previously
triggered soft lockups during host NUMA migration.

The setup was:
   - ARM64 host with nested virtualization enabled
   - Automatic NUMA balancing enabled, with numad running
   - QEMU 10.2.3, virtualization=on
   - Ubuntu 26.04 L1 guest, 8 vCPUs and 32 GiB RAM

Each trial used a fresh overlay backed by the same read-only golden
image. I ran 15 boot trials, observing each for at least 600 seconds.

   Result                         Count
   -----------------------------  -----
   Trials reaching guest login    15/15
   Trials with guest soft lockups   0/15
   Guest RCU stalls                   0
   Host hung-task reports             0
   Host soft lockups                  0

Tracing confirmed that host page migration and the reverse-map
recording path were exercised. I did not reproduce the original
soft lockup in this batch.

For the series:

Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>

Thanks,
Shuai
