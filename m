Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4D6538D69
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790694602; cv=none; b=nAbOGj/3VWHPmr3IU9IJ1Ese+mhDo+aO8OT8wcj52EdL62wK9mKH05olm9EfP4JdD06unNDT8OiTgwENLoAS6aPRwXGlZC7iWMg+NM9qRYHvZQBmLMGuv/knh6d26FWiU81SVSsSnr8jgxLYnvbat9JCiPqZsLHPDqFO2DfLyb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790694602; c=relaxed/simple;
	bh=Rh/9antMkcYoFO8O3anqAxCW+eN5HzJkU4x/8Z1e0Eo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UBHsMrsTlEenj+Jed/9F4PxeiuU76ePiH9iNRqOF5EVkULCJOL5KnA/SpimSPJJSJYvp8aUcj/vJfpcRLQLHAEL5cMPPyqZ0vXhJ6PmG1rr210mcwjArxyegQGAr0FLGrarJE/0sYA77Mm8sntAYdnfa6/PKgDG/TYBcJkBonbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HT6fuh8p; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Yh7gzHLd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HT6fuh8p";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Yh7gzHLd"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TCqel8204923
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	moocI9VTXpBxcu2t/jSPPRstrE/Cls/u13QN2JVpoI8=; b=HT6fuh8pnO2x3v20
	ei4Qiz/Ove6QjEI3P7r1lv91Z7fjaKbO2yl7t/+imRNTPxXGKqvGVlbk7V4lBgxb
	XmagVvE3vCuN8xIdXjK8IUk04EOQpSoCQHJWaTG8D97WTTGKFUKCfOHrPFpCNXI7
	nTpxdN4WGAUnmXFxktheuRyemoESQhomZkFbmyOgCPr99Pf87jnDhEANHaXOkx9o
	2Atiix5TsLTBock9oxIncgpqtiBH8vxio/xYo0NqWwoMxLpJVjLo7tFqEJOcGb/K
	8Ix8Vnwfkam2ANc26KPrHBf+QckXwKrZc9RYCgtzuFyTraaMeuqTnr8cPHc4C137
	hzXpFQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h0144unxa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:09:41 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93c5e9c2ec1so184566185a.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 08:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790694581; x=1791299381; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=moocI9VTXpBxcu2t/jSPPRstrE/Cls/u13QN2JVpoI8=;
        b=Yh7gzHLdqcJ3QD1lUtIxiS68lFPzlz2oCJfmyJXFzAjI6VDNSR3aP1iSBZxIpPyHXF
         uzLjqe0jwlUBF2PHjIP3UGUqWLrefnQHujtFeRFjmYXFsssrq1eGRWp4QupKvVvZYehw
         guMtSSdoUl6BSFIZx5P5ww7XsW/oSd9f35A3SWYYh0kMTEyd2870F3HVx6dKFu8K/t5X
         Ev4pQ/+vK+LpP/Zmd8ddMT7uC2Xkz0DDDxstBDJbtmlAyB5lKVfzYSloBSbmHBVt1hy9
         y2kDqmT8I2XIf/+EJRpYjlILyKMNykUbXBABvsL53EVWX0AshdazEPMrfR3oZuyr+G02
         gNwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790694581; x=1791299381;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=moocI9VTXpBxcu2t/jSPPRstrE/Cls/u13QN2JVpoI8=;
        b=yZZzDOlYBW0uBR4/KpzUFWOkFq9B41tgKKpsRHu71tkkl21XpcS4dhYtdkidGv82s0
         I9PMytEBHQ2BzpX64Il+BQJytac6XRdv/xel47Pb+gqj2zuNXpQIdvECRCTDA5gtGXPb
         vCZMIRvuRy20XBpc5K4Cd9FyerBxni3Woz5U8OtdIcZvvvM9hhoJ/maqyDBZRvvka7bi
         23l77yBSbfekcdU5LE+H3Pzt9cjBC7p5sYnxcnKRciNkcXjHO/eVlrqU9soWc1LOyiS9
         TVxPUEDxbRYbhxgPb7nhCXZdik8BaNrrOFQ1c433aqBSdMt53A109uAfmltw71h3h43n
         zuNQ==
X-Forwarded-Encrypted: i=1; AKwUvBxkQLOnIcHdYbX5nlnXvhMTEEfYunWM3shQnE382HZb7VLFskIc9/+1LpuzVmaq6Nss19ygzGo=@lists.linux.dev
X-Gm-Message-State: AFuF++n4BTBmHWI8ya4RzyJs2fNXWqZSSMzISZ1ugW2DeWmQj8VzNWJr
	P5bgIDpngKxHzqrJHp0PqsojDLn91EXdqhVnh2jNLRCM553ZNRTSDJcXz7VH/qCXIV22r17VP6c
	l9h6FYibwbJa9tuP6xhckwI02HMy2b2JeDneO70FQSSvsz+VcPSeORw/9vzc=
X-Gm-Gg: AYBFou3ZXxEaEsbNnpf1Hq2++ehYFQWiOFRG7C2GWT+mIolQ2SF7Ggu7M5DMGmwfOPK
	FUtL++nFqySmpMQAg9eU5N3PkJGLjWu8Q1rxubbu2qDfFwzEg3wquQW9UI1pnoJrI8U+yg6LPTM
	H5toPOQrit8fPdDabtbDfPmLcbji6NBAsVsCB042XdYLB2I5709KukSFWOAhdXWPPTam1wflIVn
	1WMcVXJ1yOrusg1r5sq8rwGOOPTC9hRtkDtxyiDoEwwaNVIXqqRM+/2Z9MF9nDAdG1H18v/l45g
	oHEewJcqCPXM2ZFCpii8QY2CcRU65AV/Q5LNI6qibU7lUsn9zVi59EZ+S9NTd3fNQvOZx8UYHFr
	vtWZFV/ygIdPySV4/ABOtXyllqi/oH5e1Zg==
X-Received: by 2002:a05:620a:6407:b0:93a:ea:b00e with SMTP id af79cd13be357-93c8bf7ccf4mr505793985a.30.1790694580368;
        Tue, 29 Sep 2026 08:09:40 -0700 (PDT)
X-Received: by 2002:a05:620a:6407:b0:93a:ea:b00e with SMTP id af79cd13be357-93c8bf7ccf4mr505782785a.30.1790694579628;
        Tue, 29 Sep 2026 08:09:39 -0700 (PDT)
Received: from [192.168.69.225] (pmd666.hd.free.fr. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af50a3c49sm4793136f8f.34.2026.09.29.08.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 08:09:38 -0700 (PDT)
Message-ID: <365d64a9-416c-46fd-b9af-4023b112a164@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 17:09:37 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 00/25] named CPU models for Arm64 on KVM
Content-Language: en-US
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, kvmarm@lists.linux.dev, eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, ping@khushitshah.com,
        sandesh.patel@nutanix.com, Mohamed Mediouni <mohamed@unpredictable.fr>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>
In-Reply-To: <20260921123249.1708067-1-khushit.shah@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA2MCBTYWx0ZWRfX/atZytCF5BuE
 u+NQA7lv8VRhFSsme0cGni979ki/uqCh+5GV1nFKAcwWo9jxHSZ33KX/gYIutY3ZtKTJW9zMY1M
 JblKOYxUuB+aqwIDqJO2wxXb1Vvpfy9eZoaYc+A0Kbq+CgQLPNhFsag37pqP86Rr3kGJTWSiKwr
 Ce98wkrvWsZ7v2Q5fgHlB05uedYIKSIXTFx3ab8x5qQew+NyCB0h14BeoVbWpKMFpczpmx1bnT2
 HtGlIsLw4DSO5vPwsJm7jFkx7N9/Q0R0kqEYXpx5u6lFN/4kgHk85h2JZdE+FWPK7v4dO7jJC0H
 Q65ynx/4XXMH2a2dnPSDdjCGkzz4exYlh94nnbgLzR/wqqm4iCfWrKiQVByVTHuXpCkcrPshEXB
 dS+Gz0spj7+Aw70eFX7RErjwg17XYtV0+2kK6DFbXKJdtO3pxTo8e1wFgUPgrAHw1Q8YrVKyxk6
 Q+oGw6q4HmJj5/B2SJA==
X-Authority-Analysis: v=2.4 cv=FJSOVOos c=1 sm=1 tr=0 ts=6abbd4b5 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=4s3hRJSeHn4rkQlkrse1kQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=4azYNZDdmMagUpTqU9wA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: wtlq_njJxvSw6-6EjJkpEA7VqH2MC8vV
X-Proofpoint-GUID: wtlq_njJxvSw6-6EjJkpEA7VqH2MC8vV
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA2MCBTYWx0ZWRfXxh0wVc4kditJ
 QRkeSlX0sDuI5EoIwYtED4Ph8qSXgjVU1TZ11/DhsUB4dnguitO14mPiRlhGTj0IV8q4kPiY9Jg
 gFcL51GLq9XJLOnBPAdVgabg9kIWmyY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1011 malwarescore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290060

Hi,

On 21/9/26 14:32, Khushit Shah wrote:
> Hi All,
> 
> Here is v4 of the RFC for named CPU models on Arm64/KVM.
> 
> Background:
> =============================================================
> Currently QEMU only supports -cpu host/max for KVM on Arm64. This blocks
> live migration of VMs between hosts that differ in CPU features.
> 
> This RFC proposes hierarchical named models for Arm64 under KVM. A named
> model is a strict contract of the CPU features exposed to the guest, so
> the same model resolves to the same guest-visible ID registers on any
> capable host. Models can be customized further by overriding individual
> ID-register fields (e.g. SYSREG_ID_AA64ISAR0_EL1_SHA1=0).
> 
> On top of the models, this series adds the QMP introspection support on
> Arm that the management layer already depends on for x86:
> `query-cpu-definitions` lists the models a host can run and reports
> blockers for the ones it cannot, `query-cpu-model-expansion` resolves a
> model to its full set of properties, and the new `query-cpu-props-info`
> reports the values the host supports for each property. The aim is feature
> parity with x86 so existing tooling can consume Arm named models with
> little change.
> 
> TL;DR examples:
> =============================================================
>    # Boot a named model
>    qemu-system-aarch64 -cpu grace-v1 -machine virt,accel=kvm ...
> 
>    # Named model with ID-register field override
>    qemu-system-aarch64 -cpu grace-v1,SYSREG_ID_AA64ISAR0_EL1_SHA1=0 ...
> 
>    # -cpu host with ID-register field override
>    qemu-system-aarch64 -cpu host,SYSREG_ID_AA64ISAR0_EL1_AES=1 ...
> 
>    # query-cpu-model-expansion
>          "model": {
>              "name": "graviton4-v1",
>              "props": {
>                  "SYSREG_ID_AA64ISAR0_EL1_AES": 2,
>                  "SYSREG_ID_AA64ISAR0_EL1_SHA1": 1,
>                  "SYSREG_ID_AA64ISAR0_EL1_SHA2": 2,
>                  "SYSREG_ID_AA64ISAR1_EL1_APA": 3,
>                  "SYSREG_ID_AA64PFR0_EL1_SVE": 1,
>                  "sve": true,
>                  "sve128": true,
>                  ...
>              }
>          }

> Khushit Shah (25):
>    target/arm: expose SYSREG_ props for REVIDR_EL1 and AIDR_EL1
>    target/arm: expose all non-res ID reg fields as properties
>    target/arm: move SYSREG_ prop infra to cpu64.c
>    target/arm/kvm: enable writable implementation ID registers
>    target/arm/kvm: read all ID registers from KVM
>    target/arm/kvm: handle special ID registers when reading from KVM
>    target/arm/kvm: process ID register writeback per field
>    target/arm/kvm: handle writeback for special ID register fields

While the first part of this series do KVM specific calls to get
usable ID registers, the rest doesn't seem KVM specific. IOW, what
would restrict named CPU models to be used with HVF or WHPX? IIUC
as long as we can validate the CPU features with the host we are
good. If so, some handlers should be moved to the accelerator layer;
but of couse this can be done later.

>    target/arm: introduce named CPU model infrastructure
>    target/arm: fix SVE and PAuth finalize for named CPU models
>    target/arm: disable PMU support for named CPU models
>    target/arm: add arm-v9.0-a-v1 named CPU model
>    target/arm: add neoverse-v2-v1 named CPU model
>    target/arm: add neoverse-v2-v2 named CPU model
>    target/arm: add graviton4-v1 named CPU model
>    target/arm: add grace-v1 named CPU model
>    target/arm: fail named CPU models on unknown non-zero feature ID regs
>    target/arm: add cpu-models-stub.c
>    target/arm/qmp: allow named CPU models on cpu-model-expansion
>    target/arm/kvm: compute host-supported values for ID register fields
>    target/arm: report 0 as supported for ID fields gated by vCPU init
>      flags
>    target/arm/kvm: add kvm_arm_get_host_isar helper
>    qmp: add query-cpu-props-info command
>    target/arm/qmp: implement query-cpu-props-info for KVM
>    target/arm/qmp: hook blockers in query-cpu-definitions

