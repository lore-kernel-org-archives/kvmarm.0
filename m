Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.76
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792758590;
	b=f2kYu+6bZAyFYgdo3xLeGNzKu0Z7H8YEQNBkLMdx9lIufxRfrDP6/vkQaPUvyRZqI972
	 bogEGR2uG3OcJyrJ2YzHnoH85K6Hjl1m2O9azvH9fsu7SflyG/3Ryn/pomKYA6O3BBr0P
	 i2t12TJrC63oz/gwi7x4FhvoDrhB0rC511rtHB6gTm6DzFKL9Ub+BH2+BDiSAUnJbD0g1
	 TPk99HHNlJlEAewkRrfLjFqGtj1NwKQeeuihQxMSf/m3AMY1CcDJPDKIFuZ1DbNV33mlQ
	 MffQwokOqHvgg3K7CTZO8H4Qye4JX/KIAMbwITHNz85pJaMNmc3/rcMsT9s1gXcZldA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792758590;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=YpJoqFudutFLGEsXKoFfWlOWQ18XnvPfGoZCVowy++8=;
	b=m2PnJ2zWRv2S6jjCyNSEkghEstBHFmMaRZjdjJ0X5kJk+fDP5ZAA9LPiCrvEfTS63N49
	 vd1A04CHeBdw7IqAk9hQMlErzF6CvWQUY6VCSNyb9WwiPxYAVEHAc+4HtmWg4q2qu/8Ec
	 lSYIXiC4jvsXxr5HmadezzhVcgFsvCjg2LYDvgdrFOum0dqYwliYOHte3IrsBZo0KQOuN
	 RDCOIChGw+byt9EsRx5swECVBpt5m+O25xh87B8SqC1H6g5nvvLLoPD7oToZP4YH4W6xG
	 /vvRlO2SSqKPktvfTdBuVeT9i9SVfRkZORPw+j4y9mvqCcIGqQnipYZm0xvJ1LqT3sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bjyvkKfa;
	arc=none smtp.remote-ip=95.215.58.76
Received: from mta1.migadu.com (out-76.mta1.migadu.com [95.215.58.76])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25F7606A322
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 12:29:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C25F7606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bjyvkKfa
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=YpJoqFudutFLGEsXKoFfWlOWQ18XnvPfGoZCVowy++8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792758581; v=1; x=1793363381;
 b=bjyvkKfaNQmmaR7VbdPgJGbH4tyFQzLtGd0gCfAMvLu8phf5zLp1iP3t/ZR4R0mb/u6mOPgy
 zDiUxCyyGmabEvkmV/Tf98c50h4ol9C3A1wtVJaa40C7p85riBAN+Yhe6Nwgv49WAFZmc0kM6Mc
 5vWvdmcMiy61xEFLRZ260R88=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 08d346243c6856ea;
	Fri, 23 Oct 2026 12:29:41 +0000
X-Mizu-Trace-ID: 08d346243c6856ea
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5be58ad9600so7887e87.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 05:29:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBycWzlt/QsF6fecVyNiwEiFHkye3NpXiOJm2ig2DdX/C1Gs4YlFipRmIogFKWpico0Xj1MqdYk=@lists.linux.dev
X-Gm-Message-State: AFq9FYIjmW64berdyRmIqLkdA1HuCDRaIDILwBSxvAcrgKY3ph68qHGJ
	7PraG5tVaOSJkBKGhudrjohb6dLgEX+wGnim500+0pOG+A+XJNRutBHLHmgQiRccUH/12ossUfs
	MtsMOVpGtFMqWtg3ixm8DJZ/ShxEYKCJCyVO+Uhq/
X-Received: by 2002:a05:6512:124d:b0:5be:b32e:c309 with SMTP id
 2adb3069b0e04-5bfb06c344amr122219e87.13.1792758580452; Fri, 23 Oct 2026
 05:29:40 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261023092007.3918848-1-vdonnefort@google.com>
In-Reply-To: <20261023092007.3918848-1-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 23 Oct 2026 13:29:04 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwNOJCphq8YNxK4nUZFj0Xrw31Okx1fiFAS=sHY1Z3cnA@mail.gmail.com>
X-Gm-Features: AclHuK-K2YjKCXeXFgvD-ClRx7h0B7uTh_qx33F7Uf1HBgI4b2DbgsZxKFDYIow
Message-ID: <CA+EHjTwNOJCphq8YNxK4nUZFj0Xrw31Okx1fiFAS=sHY1Z3cnA@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: Use the host kvm_host_data for nr_event_counters
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 23 Oct 2026 10:20:07 +0100, Vincent Donnefort
<vdonnefort@google.com> wrote:
[...]
> So kvm_init_host_debug_data() initialises nr_event_counters in the
> hypervisor's kvm_host_data, while kvm_arm_setup_mdcr_el2() reads the
> host copy which is 0. With a HPMN of 0, this stops programmable event
> counters from counting a non-protected guest.

I tested this in pKVM with a non-protected guest counting with
perf_event_open(). On its own the patch doesn't change what the guest
sees: every counter, the cycle counter included, still reads 0. That's
a separate bug: flush_hyp_vcpu() never copies vcpu->arch.pmu.events to
the hyp vCPU, so the guest's events are never enabled on entry. I'll
send a fix for that shortly.

With that fix applied, the cycle counter counts without your patch but
a programmable counter still reads 0, and with your patch both count.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
