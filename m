Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007161;
	b=gV3FhrbPV9T1CFo4VY9ho0HXdh56DHCNdmxEGtQsZU6kzA1LYzkVF5F4JVqgHKnk7dzh
	 r3JVXaW4U9e9n8JgXSN/0VbjAu0fLWePhBj9tTRVBS0/AWREFmx7wKywGHkAAb+ZWd4wY
	 kj91/96U3ADkei5NvSq7nX1OKSbXyeV3zIhiI8DD8ilPiFu0PFg36ChJ4bETbtRxltkyj
	 Ax6iCcoK5jEfMiEKb/A9fYkvSpv4N/1JssF9NlsyOzMTIM84c7xqtnm9YTp5I32nkbldN
	 8nIS4r5oCH+KlFJXkH1BiEQleNd9m/7msTBZjHcHBxKP8TEIUx7nTT0OtpSsNbHebng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007161;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=OKPy0Il+wJ56FOWGfFGGjchypiWTwMVJH42Ujm6j6NQ=;
	b=vhdJ7TvEBcnYcpGIocJJMvnh0WF6eymIlLvGXZBbXKTFLDN1ZD14pC5D/TTqdle3U96+
	 KfIXssUvzimq0FbjN50KkF4Ot0PGNdxPNGSL0UEc0eOtNoHLNTRBHvs2IhPPt4QIWdfNb
	 VJaiOuUBq6TEpUZVZJQoBRQNnc8O98fs++3WZmSFfW9WgtZgofeDWjblFv27LF78e/rrC
	 lgYWxcIaXBMY3jlBfueWYUmuIZNebi+vo4tDVtZADfYTYwlhiZfVoO+1zfnBeTrmrN70N
	 abvenFaoJ/Aiz0iKQjge+boynLwmH8ocW2+IAjLTMVt+bN+m/0NJ+aErWz6Nh5cYnbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=VNpmbdBU;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F0160A2628
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 13:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9F0160A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=VNpmbdBU
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so799416f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 05:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795007158; x=1795611958; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OKPy0Il+wJ56FOWGfFGGjchypiWTwMVJH42Ujm6j6NQ=;
        b=VNpmbdBUYQNevC1JymEO0mrouNQ7L+sua4Ro4VToI/JxmiaDBp8hKmqHwsCgVmQijz
         rc8CsL84sC42kvnjuhNJykOtlULBC4EaLV28iXYWcCI65C/VilCZHFXTd91uliNIkOv+
         q+xIzOKFL6kQ9E5KpUEqkHr67cZNpBEAVoB5/RalhbPatZGdivcC8p1pmR0S6rxrMEmf
         koOueHNze1I8Ck0EeKo11tE8/Tv03KErzgjJIow0omql50vfhqbUgmyGRth/AKOJ3OCA
         rZuHN0wC+MPtsgXhDwj5IyNzpVWxXgDm6w4dTxhiuWrTeP32TiRjJePdXw1+J/un+mWC
         O/Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795007158; x=1795611958;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OKPy0Il+wJ56FOWGfFGGjchypiWTwMVJH42Ujm6j6NQ=;
        b=dt/kGC7zhtOp0Kozb2Y6EI3ok6MbDiU2ve1fYY44sOiU9c/ZLEUEp0xxOQNqOTmrHV
         lfbRZ437IkEfA4QNvhpH4etO2A9cl3SSgUbKBOrpa2PBCIDkyEoEh1kAToKk0kowaeaJ
         ChJW5fBkRyAB+YseD6lgahwpMFIoq4l9+4lMpWIvuqdwImhaK84SXHPyZ9Zm/gg6W1wx
         SQ4XqddSkHfU6HGk27pgKCYZ0hlB3JbZ4aSU404rbS0uJmNtAnJQHENzHEisUgJKUt6S
         PBFz7Oaq55GJimgoWWbKMDF7I3wX5GPYchvinT9/T8DsI++DMh6bl3oK7dTcDQTUIDeE
         1zHA==
X-Forwarded-Encrypted: i=1; AL+hErEGcqkFsQGeKMhKZybXEQwJ/86JV7w4CnAEpwr1MxF4tVNweEylWMWmOTsX498qeG25w6Gi0Ac=@lists.linux.dev
X-Gm-Message-State: APuU4Z+DPFRU3YVcpT7hyKBTYN5EmXijhjbKqIl5mvvewmF/BRKC/sxI
	ITqz1n85TfyLXFn+iOQVj+gLW6tvJx5as6Zw+NT9ax+9S0Nf3qJhVKSNfW57V7TlV2Q=
X-Gm-Gg: AZFdTZcFWB4GCZZBURYoEvLHggTjH3XYiZoyWFm0rfQqwGfIe9Uhr6MmGWUN026Pa/R
	HigRJ/YMk7V4PYeAZwtXJgsbqar4U9pyXFZzVst+x3u/SVmT0J+2KnggNCcgnudilPDjnemaMCe
	JbIM//onv1ZmbBQoEHqEFw0c+DgXx1YZ0uPp1mDBP18++4G4zc9OuLgcGA9ASie5FCVR9nbpOjK
	yngSGTNm5nae3/YKpRWaBWfDOospLQhYzJCsBOTDC7E9n5MyfxZO9Y9BQ6K2ksbIsFD2em6Oggn
	8MZ2uF++9iYRchGUYOCYckJifz1pZsvMsFduyP9O2kqBauGBg1f5E29oOLSMpBB6Fchn1XWK7mq
	Bm3+F2+SVRIglndFlqplVY98mi3VrGEdo/mhSligj5EuKpLuNBo7Y4JCx4HwspaB8DBhTH7wv/S
	Ond2WBQtJkJrrF+BVaWVuM3UPLFHJNPdlmV2EGyyvkisXswVEnN1xzpoPqnCEX9aKidzQ9r6a8z
	Q/Hx0nCsvPfUIj2dTc/ecF0QzKtQGCpWcmEN0H9DS2qof7bzDTR4gAw4D+gID0XT9V4pfe5tbjC
	uRdmypaxS/iUZ7Z5UB4=
X-Received: by 2002:a05:6000:3cf:b0:4a6:5a2a:f4c4 with SMTP id ffacd0b85a97d-4a65a2af4e3mr5264577f8f.37.1795007158296;
        Wed, 18 Nov 2026 05:05:58 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656c11f1csm5156596f8f.53.2026.11.18.05.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 05:05:57 -0800 (PST)
Date: Wed, 18 Nov 2026 16:05:54 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Congkai Tan <congkai@amazon.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Haris Okanovic <harisokn@amazon.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH v2 2/2] KVM: arm64: nv: Fix NULL dereference in
 kvm_pmu_nested_transition()
Message-ID: <0f35f6e21bec19774e23c991370488fa99fb37da.1795006659.git.dan@pereq.eu>
References: <cover.1795006659.git.dan@pereq.eu>
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
In-Reply-To: <cover.1795006659.git.dan@pereq.eu>

With the KVM_ARM_VCPU_PMU_V3_STRICT feature, kvm->arch.arm_pmu stays
NULL until userspace selects a PMU with the KVM_ARM_VCPU_PMU_V3_SET_PMU
attribute.  The KVM_SET_VCPU_EVENTS ioctl can inject an SError or
external abort before that which leads to a NULL pointer dereference.

Unable to handle kernel NULL pointer dereference at virtual address 00000000000001e8
  kvm_pmu_create_perf_event (arch/arm64/kvm/pmu-emul.c:710) (P)
  kvm_pmu_nested_transition (arch/arm64/kvm/pmu-emul.c:1357)
  kvm_inject_nested (arch/arm64/kvm/emulate-nested.c:2927)
  kvm_inject_nested_serror (arch/arm64/kvm/emulate-nested.c:2979)
  kvm_inject_serror_esr (arch/arm64/kvm/inject_fault.c:365)
  __kvm_arm_vcpu_set_events (arch/arm64/kvm/guest.c:827)
  kvm_arch_vcpu_ioctl (arch/arm64/kvm/arm.c:2161)
  kvm_vcpu_ioctl (arch/arm64/kvm/../../../virt/kvm/kvm_main.c:4772)

Return early if the PMU hasn't been initialized to fix this.  After all,
we can't transition a PMU that doesn't exist.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-217134@kernel.org/
Fixes: ad220e275c39 ("KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v2: This is a new patch.

 arch/arm64/kvm/pmu-emul.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e2b28dbc0451..388a6244e7b2 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1342,6 +1342,9 @@ void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu)
 	unsigned long mask;
 	int i;
 
+	if (!vcpu->arch.pmu.created)
+		return;
+
 	mask = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 	for_each_set_bit(i, &mask, 32) {
 		struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
-- 
2.53.0

