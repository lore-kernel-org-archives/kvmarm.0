Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB3546AF08
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 07:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788248348; cv=none; b=eJeiM2FzyNYkHqNLO1LUmRb7vv49K+zW6L3qqx/aqwU6xBii2rJdpw7yaQhy/fOfz78amUAMKl0qDLfOMmG9AFzFix4mpRqtFJXK15wfrevrtnzBkQJ9SdDg8cyNcQETHfaVo9lOSy80qF6XbwND+Mqis0oPjwDIV3geZUiS8lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788248348; c=relaxed/simple;
	bh=5dZXMTuVIB4/rqwu6qguosRA2gdca0Wy/7vnL6NSoxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j28u2U+sZX4IKkbcKf4IHWvU6rnNgAOlIWyovH2YbS8rGrh4UtARnzOGc/bfstNDfjo3NQMyOmnx1rdAme6+7p2o4WrpngqaqB+fD6MREQYAMNM7e4SImmI9pzCmtzJndqNzIilxjtf3NkeTw6BGxh6mP8bVjYDdPZah2TYue0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VtE2Iu6v; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VtE2Iu6v"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6817VmxK458568;
	Tue, 1 Sep 2026 07:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=8fY/Dl2/758QW1rxNPqXXC5GnM3C1m
	V2NhcBW5N/hzY=; b=VtE2Iu6vRlD48u8PHjVDsTvgegEBr/79jCKiybkRPJe7UN
	HPVFeHIADAUPsnAIBXkfDFkK25itwdH477EP6Db8l4IVanDDZxPkBZ7PCLYDF7MB
	ZOMcIljS5r5HKDJWRjEh8VXVaNos15k2cgXKefjBcj4rRdwPkE0yoezdBPIQjcw0
	JpJSVUESF7fhvHDH91Pss94yKVAadhvE+jQp5yd62iIiS1QwDQRAJGIApP71EFTf
	wELUrzuebzD+gYbjXDHXw6LOOnCnEYI19o39+SisAobiAY9xkpiqeYLG3EY/CSBn
	sXmz5WtDwZpY0/r2TS2SyJBHz/Zkc5jf0ktSU6WQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbmuhpeew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 07:38:52 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6817QH1c000869;
	Tue, 1 Sep 2026 07:38:51 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcark2f88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 07:38:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6817cnE342140150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Sep 2026 07:38:49 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3CBD020043;
	Tue,  1 Sep 2026 07:38:49 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0204420040;
	Tue,  1 Sep 2026 07:38:49 +0000 (GMT)
Received: from osiris (unknown [9.224.76.185])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  1 Sep 2026 07:38:48 +0000 (GMT)
Date: Tue, 1 Sep 2026 09:38:59 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        kvmarm@lists.linux.dev, Fuad Tabba <fuad.tabba@linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Return -EINVAL for an empty SMCCC filter
 range at base 0
Message-ID: <20260901073859.185345-A-seiden@linux.ibm.com>
References: <20260829054856.70549-1-kmehltretter@gmail.com>
 <20260829054856.70549-2-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829054856.70549-2-kmehltretter@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: ZCbQ-ZklX7stda1AuCkPQ0Djjt_a0WKY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA2NiBTYWx0ZWRfX4h+TXCOEI7wH
 6eMfhCl9yIVObK3BCrNHD8Dq3qA3ZMS/VYvCRHiJftV4ivux8cMKSQfM92VTBM9XfXw3PmxqFNh
 9OTN9SgrFiyzSNKVKBmZQwyaJEU1aJmlrNpYpjbcYTC+RtkDGKeVc9YQb9alJ3jlq/OhHgov1uV
 JX30A0+5iKSHW0PB6rGEkJGZTI/7vGzNAVe3pr31cENAs+mjp9eQ6qUEJ9EV3ezAHEB79sQ58Y9
 nJ5YwZGiqaGAWTxYGyWT6R9F6OKuMB9e0fnyZMIEbtUjBbV8UoTAPDcecO6siPiNJ9gBLHbFoDs
 O7vd0JCz9y8jF5x+LHatF7wO03UuBCd2SnD7m6JEV5zYZD82drlk8SZD8sPtMcGJteuByBxvocw
 vIArUz59EW6PIbbEWkY4nWUN6wdufOT1SrLKPZWhZx1odnRqyito0KZSb+SkDigDpDaCZsUgAYX
 WMfgJ6x3bko8mOt7fuw==
X-Authority-Analysis: v=2.4 cv=Osl/DS/t c=1 sm=1 tr=0 ts=6a96810c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=sTVcf0stEawvOQYPuTgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA2NiBTYWx0ZWRfXy4lZ/J7YpckL
 K0SY6MkUpi5sUw7oztTXtF2gTI3R/neK7rxtxiz60RLfyOvT9Nf0r+CbEwZfrLb399CxCRuQ3Y3
 sM+IqxmBNeFFM3kYX5eDNYok2nAILFA=
X-Proofpoint-ORIG-GUID: GL9tonZEYnwAQvDdc17GjcJN60W2-KOG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010066

On Sat, Aug 29, 2026 at 07:48:55AM +0200, Karl Mehltretter wrote:
> kvm_smccc_set_filter() only rejects a range if its inclusive end,
> base + nr_functions - 1, is below base. That catches an empty range
> (nr_functions == 0) at every nonzero base, but at base 0 the end wraps
> to U32_MAX and KVM tries to insert [0, U32_MAX], which overlaps the
> reserved Arm Architecture Calls ranges. KVM_ARM_VM_SMCCC_FILTER then
> returns -EEXIST instead of the -EINVAL that the smccc_filter selftest
> expects for an empty range.
> 
> Reject a zero function count explicitly.
> 
> Tested with a userspace reproducer on an arm64 VHE host under QEMU TCG:
> EEXIST before, EINVAL after.
> 
> Fixes: 821d935c87bc ("KVM: arm64: Introduce support for userspace SMCCC filtering")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Good catch.

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

FWIW: Tested it on my downstream version of arm-on-s390 with hypercalls
already implemented. 
