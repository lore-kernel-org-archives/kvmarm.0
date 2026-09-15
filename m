Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8CC4078D3
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487781; cv=none; b=d5dZvn/4YeBjCeONa22dqanN0TfI87Jy6cPqK8K1Ntk0pdX7za4qyPE4P1KBFhvOuj0zlSGrxlURwiuSXy4NdSRL4BqwnzcutwAV3gojGfAwwuOGrdAJ0Ypf6HHmGQdKAf85/8KaBfv3bg8om3V9MI8skOrBLdnvxvj6f3ogmFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487781; c=relaxed/simple;
	bh=hhnl9J25vhWtjndIDpRn+fChbPLcG8O6KBl9AaJuEss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6kF0hQsgNbOxvXw1Si1a2XExIDsRqtDpF1Jnw4JywsfjBrUwI33MXko+xgMdwoaR8pXvSTjDtb9iOtkkMqgn4R5uFfvJZsePNxigTFev6/nszW470c1nGFoN+9gPTutUMAEdeKKDhwAqGGzjXZyJ/JZNDKPI3Ge2f4LruCaImA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=E9kjYKDL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E9kjYKDL"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FFVVU91231597;
	Tue, 15 Sep 2026 15:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=BxPHWNTD4L6hnARkU6EXSH4kWdMAVf
	IaMl336Sudec4=; b=E9kjYKDLqa8Q+ZrT0cPcL1qYV/gnwiw+sxKC49wqewEvhH
	tIADKnBC+dls2N51zMbDqePuAYDevMoXKHla6vFDD8JoWOv96RL1jj6HJPXY9odG
	JycOY+BiKY/H7iElmqDltBiOUlasXOq8PQLA0kq5OKgttSeCwFYsATOXT5fmWSNk
	3UtsJSJYHtaZYUUI1qAAJ4doLYIRSy1Iv6OBvnBRvtKV5q82PaUbMZ3bWUxo8INZ
	qFbmqcEH6ml3syFE7jWxl8OSJiea34IxLnNV2O+fvzHqipjjTZKYNhQVmslJOv+m
	unhB2F/cUhFrMg5fRMiEbuwvStjIdz8Kayh7V29g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcuyn9w-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 15:55:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68FFAb9O4140789;
	Tue, 15 Sep 2026 15:55:57 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gq03bt272-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 15:55:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68FFtrIB49742122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Sep 2026 15:55:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 075C420040;
	Tue, 15 Sep 2026 15:55:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FF5720049;
	Tue, 15 Sep 2026 15:55:49 +0000 (GMT)
Received: from fedora (unknown [9.5.7.39])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Sep 2026 15:55:49 +0000 (GMT)
Date: Tue, 15 Sep 2026 21:33:35 +0530
From: Amit Machhiwal <amachhiw@linux.ibm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Will Deacon <will@kernel.org>,
        Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S HV: Fix comment naming a
 non-existent KVM_VCPU_RUN ioctl
Message-ID: <20260915213132.36dc8e16-c4-amachhiw@linux.ibm.com>
Mail-Followup-To: Fuad Tabba <fuad.tabba@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260915084441.3846947-1-fuad.tabba@linux.dev>
 <20260915084441.3846947-4-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915084441.3846947-4-fuad.tabba@linux.dev>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDIyNyBTYWx0ZWRfXzIn1dK9Rs4+u
 1ZEQ/kXTnyAJedfW8z4wkUc+E/d/fluIN3zAK/YxHn7TBgfGnVk8JCl1Vo4xL/psXanz4tD0KHN
 Qk8+rU03trQthHv6QNcjQwVMiXf22AE=
X-Proofpoint-ORIG-GUID: 91WZ0m3lDBs7CXxyV9apPpYw-pvyJRYH
X-Proofpoint-GUID: gJPvzoGNYexcjx6bjMrZBuLr-2VMHt02
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDIyNyBTYWx0ZWRfX2lI7grsp7nJ1
 cuAIeOKMuz8GpYcvBYKxSINyr/44QJ0DukUXFCTX9jVSMoNPc8e2hL04yKEFu6QZkdb+59nh0Jd
 ccDYNy+6xXy7HYfPOCdM84EIZwhQZrY9ZZQ02ekC92bGNvoUW2mhzmoGZOjXO5Ei3Hl061hrfbu
 0NJ9HKjIEBmau5r4ovHptHj2vsuFpFnFVRAWe4fscsP3kI5RMn/X9VVRMv8yEumnqvg2Vf+Qo3z
 wT5KDwRX02eFMCZzPVbh0PJlqdntI1LRqViiypazFF5+zw4LbY+pn0mW8soX6sVr3xuQKrdhn3B
 nDc/Wus556R+i80gYYiOpRWubLPVyZsIAsWVgUpEqnQ7+sXqX4wTIv55rmUsRV8XdEp/1LbjVgH
 wOZVpU/TMkhz0n63NDtHhGFIu1TZDWH1VLvk13Qk7+yktxo9jecZGj/frjCTs4QdRN68mKHxqoU
 UfMVdIj4nAQR3WNm6+w==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aa96a8e cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=e7Yo3nX338CflZNYmVUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_04,2026-09-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1011 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150227

On 2026/09/15 09:44 AM, Fuad Tabba wrote:
> There is no KVM_VCPU_RUN ioctl. The one that enters the guest is
> KVM_RUN, so refer to it by that name.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index dbac3573b2c89..db090f4c5e95b 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -269,7 +269,7 @@ static void kvmppc_fast_vcpu_kick_hv(struct kvm_vcpu *vcpu)
>   * stolen time for a vcore when it is inactive, or for a vcpu
>   * when it is in state RUNNING or NOTREADY.  NOTREADY is a bit of
>   * a misnomer; it means that the vcpu task is not executing in
> - * the KVM_VCPU_RUN ioctl, i.e. it is in userspace or elsewhere in
> + * the KVM_RUN ioctl, i.e. it is in userspace or elsewhere in

The erroneous name was introduced by commit c7b676709c16 ("KVM: PPC: Book3S HV:
Fix accounting of stolen time") and has sat untouched since.  KVM_VCPU_RUN was
never a real ioctl; KVM_RUN is correct.

Reviewed-by: Amit Machhiwal <amachhiw@linux.ibm.com>

Thanks,
Amit
