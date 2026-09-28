Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871A548C8B9
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790587223; cv=none; b=Jtqf38dpDyS9jJ7qvUvPGzAp0TKQowLz25WDr6WpZ/ZaaguVOxCXNIlxh5qdKeiW0r9snGm7fTavKh3GnrBbbryfp+pxMbcUxGO8mpgPGRNIkQBzTBdUrRs4ec7T8MZu1Ztf5k8GDbUnLuIQ7Pw4tY9uml2htQ+2KbS+iPsCmUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790587223; c=relaxed/simple;
	bh=uasoGoYoPVbK+iktKB40nZwLV0x6mFQqIZDqKhweGPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJ48qDYKgh9veXBEw9fx8zsnxKEUQJ77ovAHR/t0c+9/dzXG8e+6whduakivlu99C+2d8ZUZXO3jn2JSy+Ed7KwQ9A5mK5O74N5vQeZb1uEsmt25MN1ZcEdNDgAjiSR6Ih8keidRYr6mM9wa2PdAO1PxvorwXTmzpPO8sZ+Zo8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mFxrWkle; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=X8tzT56k; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mFxrWkle";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="X8tzT56k"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9JiVr949359
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6APy/FJPv3eP8lr9ePw0W/ywIKRGll5HV1Kv9F7Oq8U=; b=mFxrWkleKWSscBQa
	NxAP7ie9s61riB4pD3SG265YM4HgyiP5NsPM/+SDClSqxRkg/bP9avwMVPqpxqC9
	60/zLsUOFmX3Gq+4WG5yt3gAZd7T+C048G+B3nhrUIjxf94lFRn6yypexJe5ylkX
	xg8FZJMNy67HBarUF0it6IlEcxi8tOHGJa0f5RMuIaTdxBfCiVb2vNeyz8L4TspF
	WvfPkmkfawlsnhaX8wYfvRYSHTe9nLIHm6EngMx3hfsDAZkpq30V3QBhb7e/7i6X
	WsU+aXWb1OHtGShNJd3Kd3RLhTgOt0hJ2F7H0cjM+1WU+vX7pW/mDWJupbxbgP/3
	QZJdKg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gynbc01ha-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:20:20 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2df375fb9b2so30502685ad.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 02:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790587219; x=1791192019; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6APy/FJPv3eP8lr9ePw0W/ywIKRGll5HV1Kv9F7Oq8U=;
        b=X8tzT56k0NNunAe3qzonAMZamvE1ih5cSI4iGJ1sPeyFc2fOSkDXUSNIr2lefHxVyK
         uH9uTDLYPanuAVqLQEM27O7lzQyhGdKw3rUqBXAP0oEkwADG7kttffzSHe985pjGiHyO
         D3g2MpzdKHCVBfh0xmuZDHagVkdT2/4Z9qELXVU5NfVLGbv22xW4+w9M5I3+ks/RFESP
         z15OU8URUiddO7OWdoUnPVvw2bSaav4sW9QRd89ewg2sF8RVRA6OdyyiZ9voPTX1JRo4
         V7RB8HVg3WiTUs05dWpUJ997NE4kIUezw0HzKzMe1AFrodNaS4t/ALCRz83QzRO/20NB
         N/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790587219; x=1791192019;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6APy/FJPv3eP8lr9ePw0W/ywIKRGll5HV1Kv9F7Oq8U=;
        b=VNUhOPLVQMAGK10x4nOQyZ170rXKvsAO9QnJON/wXd5Y56wuNBzfhdEIDJpfRglURj
         Mg8Sa62efBS657MS2P02FuPSdod0hOTtRZXxG/DN7ClRimF+GV1q6Z3j2R1IDgLZeplG
         jP3yXUfkuD3IReylpY/UOkUclK+d9UyzBMCdOSxkmzBjWxqQXE4zwYVgCOdV6/GQVyji
         6J1C6F3wJz8J87ZlxR0F8KJ7ExArH8iOtqq8Jq/BBu6hexjQZCQ7+hFGYljZQylQhdLI
         quMtpOvq4lEDnCzGGEm/ODNLWLKtSBjfs7dgdki/U6rQyKrBFRvzrSi6AIrXGOu3dqRy
         McFQ==
X-Forwarded-Encrypted: i=1; AKwUvBxNyyzitXQVdMLGrR2jatM3xPNXTPH6ECKZgDJpaaG/mqyKRRXeQYwqsr2CIEqfbwXy0k2wxzs=@lists.linux.dev
X-Gm-Message-State: AFq9FYK7BfT0k+TeMOTQ3HPrlNxGVThRed2NInRAJZ5IXoiIoMnwxbz5
	DgvZp1zEJTajhc81SR3fsB/EfkSPMd+pry3LTiv8hKbOL8ZwjPqqbacWj+2DOPhcowHc0bBeAsN
	WHRNXXKcBOuMgFuuHyrXD90wFWc2Hhg6RiL4e4R9KvGaEU2jxMWQ5MmMClL8=
X-Gm-Gg: AYBFou2/+v5wft+ZDy9dfk02YweYV7c6y8HkiiDsLHwvRKluazJzxIgq9wpG6yiut/p
	2Sfr2wtVrO99Z+oL55dJgixU1f2BSUJ410CBxGh5MQ/KowxkgRiuQvrvyxFnVf6NAA2HINNBPNf
	MsEPHgAPxS3dye7DMk+NOshCysiIVpu0lYGIW6e0Ya6GAEV0hG976nfpaUJQ5dIVeO+cE2Pl1cU
	DBDmWUgOs/8unzLUccBeH99KjA1bQtCjsUF7+ULkqOFUFfHBqznuDzcW+elc+GBNLH6pWb+qVS5
	FROVZHOEYeLjCqqPtT2D/P/EY9q9IuWj/avdqg1xDXXQssayG4rA784pvmGafaeKQdyXykeEndH
	an7lrEDZZF036CdWf+pny+pFCG1lSZklGOdk2XbrM+V4nvBM3W+b90ZhO270DrKR5D8Rwr5o2u9
	HlxXTysLxHWtrgkNNrTsQ=
X-Received: by 2002:a17:902:c40e:b0:2dd:c0ff:e72e with SMTP id d9443c01a7336-2df7e0069ecmr90039085ad.64.1790587219051;
        Mon, 28 Sep 2026 02:20:19 -0700 (PDT)
X-Received: by 2002:a17:902:c40e:b0:2dd:c0ff:e72e with SMTP id d9443c01a7336-2df7e0069ecmr90038865ad.64.1790587218449;
        Mon, 28 Sep 2026 02:20:18 -0700 (PDT)
Received: from [10.79.116.56] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df91461d43sm37574575ad.75.2026.09.28.02.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 02:20:18 -0700 (PDT)
Message-ID: <4095827e-dbbb-4ab9-8610-1bc317aa096f@oss.qualcomm.com>
Date: Mon, 28 Sep 2026 14:50:11 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] KVM: arm64: selftests: Check a feature hidden in
 an ID register is UNDEF
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose
 <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Wei-Lin Chang <weilin.chang@arm.com>, Fuad Tabba <tabba@google.com>,
        linux-kernel@vger.kernel.org
References: <20260928064643.3265087-1-fuad.tabba@linux.dev>
 <20260928064643.3265087-5-fuad.tabba@linux.dev>
Content-Language: en-US
From: Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>
In-Reply-To: <20260928064643.3265087-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Sq4Fe/O0 c=1 sm=1 tr=0 ts=6aba3154 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=396Fl0Eq_38yRDxh:21 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=AnUhwBZesh3cMlnU-2sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: EpP_Qo5sOFNpa5j6faGVdjuLwJ5H3612
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDAzNyBTYWx0ZWRfX+Zv6wYxJANlv
 tkurShJ1wWjNS4zV9fMWto41TBBhw8j6ZVN+WXIjbu7xT+QjpoPbA0xQXh+F9bBxRaZTvuJw66k
 mwmnrDA4tQIZkoPGLHpmoc3RI49nGorV8hjNxXyyorykHC+q7IekX9p7NFZzmXYy1BdCm350QcB
 aLPl7yZDx4yI9M5oF0LzXkKTU9o4cDyNsT0STfh7fAii44r+4eCE9SmC2xLKo4kCfT41vYrGwWC
 qBqeXRZVHvrRb1R9NXGJZL3XKveayNQvegsTqut/dmKK4zm0dCYb1+L036qas6lFXfaNh9uCMxj
 iKoxfNli1i6wt8dNTLaq3D2IfNSWRlZRXuAwTuE7eoTyw5dWDCkiOjxPoBLtvSEcXwCG8CybJaQ
 yI7zG0WvRLhMCq7Ti7QWDqs+cUSoUltPLvG7R5OKeBcHOS6qH/pfMxN6a45v5R51Wuw0ycib/HY
 baw3QGaEffZp8jYmH2Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDAzNyBTYWx0ZWRfX0zVj0BSnzCss
 uVDO68MkI2fiHuUPjA/nLRzhgOrK95jBEMbjRLOKpK+f4RPf6y8TNZt3O1m9FuefkQ1HFhFkOlK
 2jTA5EcOxv2iPWB6r8udEHbRs/nsyM4=
X-Proofpoint-ORIG-GUID: EpP_Qo5sOFNpa5j6faGVdjuLwJ5H3612
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280037


On 28-09-2026 12:16 pm, Fuad Tabba wrote:
> Userspace can hide a feature from a guest by clearing its field in a
> writable ID register, and KVM then makes the feature's instructions
> UNDEFINED in the guest by trapping or disabling them. No selftest checks
> that.
>
> Add a test that runs the instruction of each of TLBI OS, MOPS, TCR2_EL1
> and FPMR once with its field as advertised and once with it cleared, and
> expects an UNDEF only when cleared. A feature the vCPU doesn't advertise
> is skipped, as is hidden TLBI OS on a CPU with neither FGT nor
> FEAT_EVT2, where KVM can't trap it.
>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>   tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>   .../selftests/kvm/arm64/hidden_features.c     | 184 ++++++++++++++++++
>   2 files changed, 185 insertions(+)
>   create mode 100644 tools/testing/selftests/kvm/arm64/hidden_features.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 96bab7002d39e..864fdca7f362e 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -194,6 +194,7 @@ TEST_GEN_PROGS_arm64 += arm64/vgic_v5
>   TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
>   TEST_GEN_PROGS_arm64 += arm64/no-vgic
>   TEST_GEN_PROGS_arm64 += arm64/idreg-idst
> +TEST_GEN_PROGS_arm64 += arm64/hidden_features
>   TEST_GEN_PROGS_arm64 += arm64/kvm-uuid
>   TEST_GEN_PROGS_arm64 += access_tracking_perf_test
>   TEST_GEN_PROGS_arm64 += arch_timer
> diff --git a/tools/testing/selftests/kvm/arm64/hidden_features.c b/tools/testing/selftests/kvm/arm64/hidden_features.c
> new file mode 100644
> index 0000000000000..194d746e7605e
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/hidden_features.c
> @@ -0,0 +1,184 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * hidden_features - Check that a feature's instruction runs in the guest when
> + * its ID register field is advertised, and is UNDEFINED when userspace clears
> + * the field.
> + *
> + * Copyright (c) 2026 Google LLC
> + * Author: Fuad Tabba <fuad.tabba@linux.dev>
> + */
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +
> +static volatile bool undef;
> +
> +static void guest_tlbi_os(void)
> +{
> +	/* tlbi vmalle1os */
> +	asm volatile("sys #0, c8, c1, #0\n\tdsb ish\n\tisb" ::: "memory");
> +}
> +
> +static void guest_mops(void)
> +{
> +	register u64 *d asm("x0");
> +	register u64 n asm("x1");
> +	register u64 s asm("x2");
> +	u64 buf[8];
> +
> +	d = buf;
> +	n = sizeof(buf);
> +	s = 0;
> +	/* setp [x0]!, x1!, x2; setm; sete */
> +	asm volatile(".inst 0x19c20420\n\t.inst 0x19c24420\n\t.inst 0x19c28420"
> +		     : "+r"(d), "+r"(n) : "r"(s) : "cc", "memory");
> +}
> +
> +static void guest_tcr2(void)
> +{
> +	read_sysreg_s(SYS_TCR2_EL1);
> +}
> +
> +static void guest_fpmr(void)
> +{
> +	read_sysreg_s(SYS_FPMR);
> +}
> +
> +struct feature {
> +	const char *name;
> +	u64 id_reg;
> +	u64 mask;
> +	u8 shift;
> +	u64 min;
> +	void (*insn)(void);
> +	bool (*trappable)(struct kvm_vcpu *vcpu);
> +};
> +
> +/* Without FGT, KVM traps a hidden TLBI OS only through HCR_EL2.TTLBOS (FEAT_EVT2). */
> +static bool tlbi_os_trappable(struct kvm_vcpu *vcpu)
> +{
> +	u64 mmfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1));
> +	u64 mmfr2 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR2_EL1));
> +
> +	return SYS_FIELD_GET(ID_AA64MMFR0_EL1, FGT, mmfr0) >= ID_AA64MMFR0_EL1_FGT_IMP ||
> +	       SYS_FIELD_GET(ID_AA64MMFR2_EL1, EVT, mmfr2) >= ID_AA64MMFR2_EL1_EVT_TTLBxS;
> +}
> +
> +#define FEATURE(n, reg, field, min_val, fn, trap)		\
> +{								\
> +	.name		= n,					\
> +	.id_reg		= SYS_##reg,				\
> +	.mask		= reg##_##field##_MASK,			\
> +	.shift		= reg##_##field##_SHIFT,		\
> +	.min		= reg##_##field##_##min_val,		\
> +	.insn		= fn,					\
> +	.trappable	= trap,					\
> +}
> +
> +static const struct feature features[] = {
> +	FEATURE("TLBI OS", ID_AA64ISAR0_EL1, TLB, OS, guest_tlbi_os, tlbi_os_trappable),
> +	FEATURE("MOPS", ID_AA64ISAR2_EL1, MOPS, IMP, guest_mops, NULL),
> +	FEATURE("TCR2_EL1", ID_AA64MMFR3_EL1, TCRX, IMP, guest_tcr2, NULL),
> +	FEATURE("FPMR", ID_AA64PFR2_EL1, FPMR, IMP, guest_fpmr, NULL),
> +};
> +
> +static void guest_code(const struct feature *feat)
> +{
> +	undef = false;
> +	feat->insn();
> +	GUEST_SYNC(undef);
> +	GUEST_DONE();
> +}
> +
> +static void guest_undef_handler(struct ex_regs *regs)
> +{
> +	undef = true;
> +	regs->pc += 4;
> +}
> +
> +static bool run(const struct feature *feat, bool hide)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +	bool got = false;
> +	u64 val;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, (void *)guest_code);
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vcpu);
> +	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ESR_ELx_EC_UNKNOWN, guest_undef_handler);
> +	vcpu_args_set(vcpu, 1, feat);
> +
> +	if (hide) {
> +		val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(feat->id_reg));
> +		vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(feat->id_reg), val & ~feat->mask);
> +	}
> +
> +	for (;;) {
> +		vcpu_run(vcpu);
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			got = uc.args[1];
> +			break;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			break;
> +		case UCALL_DONE:
> +			kvm_vm_free(vm);
> +			return got;
> +		default:
> +			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +		}
> +	}
     Return missing?
> +}
> +
> +static void probe_feature(const struct feature *feat, bool *present, bool *trappable)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	u64 val;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, NULL);
> +	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(feat->id_reg));
> +	*present = ((val & feat->mask) >> feat->shift) >= feat->min;
> +	*trappable = !feat->trappable || feat->trappable(vcpu);
> +	kvm_vm_free(vm);
> +}
> +
> +int main(void)
> +{
> +	const struct feature *feat;
> +	bool present, trappable;
> +	int i;
> +
> +	test_disable_default_vgic();
> +
> +	ksft_print_header();
> +	ksft_set_plan(ARRAY_SIZE(features) * 2);
> +
> +	for (i = 0; i < ARRAY_SIZE(features); i++) {
> +		feat = &features[i];
> +
> +		probe_feature(feat, &present, &trappable);
> +		if (!present) {
> +			ksft_test_result_skip("%s advertised, not supported\n", feat->name);
> +			ksft_test_result_skip("%s hidden, not supported\n", feat->name);
> +			continue;
> +		}
> +
> +		if (run(feat, false))
> +			ksft_test_result_fail("%s advertised, UNDEF\n", feat->name);
> +		else
> +			ksft_test_result_pass("%s advertised\n", feat->name);
> +
> +		if (!trappable)
> +			ksft_test_result_skip("%s hidden, not trappable\n", feat->name);
> +		else if (run(feat, true))
> +			ksft_test_result_pass("%s hidden\n", feat->name);
> +		else
> +			ksft_test_result_fail("%s hidden, no UNDEF\n", feat->name);
> +	}
> +
> +	ksft_finished();
> +}
