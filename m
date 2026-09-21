Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70B736F8EA
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974628; cv=none; b=nMudv7+D5IIb8A8AUpl0D1tA9s4FFQEZUsS5DUE4DY8Kc0LHhr36NSOdTd31Ym5767X5PRe3pGoDWHirL847cV5zGsqcwy3IGK8+CAJm8D8MGk6tW2XahV+aSno3nGmEAIJ3BKAcNE0D+YClACbF7IlFg4JJe6ZchgUCzKA2u0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974628; c=relaxed/simple;
	bh=yzvxLYq7Q38kB+6lHczvstjByWszec7SZd7Yaz6zm98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=blb5KTSyv4ADUp09JzWPrxGH1wcg6yhdUzP3Gw2LKiSbZpNEXWbvzkzGGQObwZ1BqzK/ApP0EILb+LqNtg/oTanYdvTAJLJ4jeFmjK24Vt5NKehW1S+XGczoIALpMBZyx1G5GJw5ITClhNX8baIUKfS+xezlWJoEMIPG8TRyano=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F+xjUXUI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F+xjUXUI"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L3ZelV265338;
	Mon, 21 Sep 2026 07:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=2jDaTfQ1fQ4DlIVjiX66DKYQF6xj2k
	7wY1jCgL7tfmI=; b=F+xjUXUIwqRMVB7yXuWbt2eaZjtJ+UlvswPhJ0q2+AueV0
	DL4/lI/QzOHFphUDudu6H0k/aJGKOdqcAtRj/FvVncrcFz3qq+XBxNnIvpx3GPHS
	VAQte9EjdURXb8IvG4PNJt7eNDyDENeFKLq5pkXDFDSjgc6NljchqGiM6sY1zPwT
	h2J/ZzUKQ5Zy4s+/BKPZD1WlbrgzfNxPjJo+ZVxmNj8w6b9aWE6Ka8WgcdrVa3v5
	XFwtMfVJA1vws8yzFNOOL3QlI1qUEFZgEmCVNiPmi29yNSaFZEv/7uNGJJgiaz8v
	ZaqlWK0L+X6QBZ8vqFDi/N6TFYHITWGiD4kS9NMQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskg277yr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 07:09:52 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68L3XW0U603397;
	Mon, 21 Sep 2026 07:09:51 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gt5qjm76t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 07:09:51 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68L79isK20841130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 07:09:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E24372004E;
	Mon, 21 Sep 2026 07:09:43 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA2FE20043;
	Mon, 21 Sep 2026 07:09:42 +0000 (GMT)
Received: from osiris (unknown [9.87.139.10])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 21 Sep 2026 07:09:42 +0000 (GMT)
Date: Mon, 21 Sep 2026 09:09:41 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Andreas Grapentin <gra@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Friedrich Welter <fritz@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
        Gautam Gala <ggala@linux.ibm.com>,
        Hariharan Mari <hari55@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>,
        Marc Zyngier <maz@kernel.org>, Nico Boehr <nrb@linux.ibm.com>,
        Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>,
        Oliver Upton <oupton@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v8 08/29] KVM: Move architecture capability Kconfigs to
 header defines
Message-ID: <20260921070941.26183-A-seiden@linux.ibm.com>
References: <20260918133107.1042730-1-seiden@linux.ibm.com>
 <20260918133107.1042730-9-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918133107.1042730-9-seiden@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 7EYIIW_HNcmiA61ZYYuqR3sWUZq2-y4v
X-Authority-Analysis: v=2.4 cv=I43w19gg c=1 sm=1 tr=0 ts=6ab0d840 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=znR89GDvB2Kr2Yv9AEAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEwMCBTYWx0ZWRfX9Uty2XCGxTxm
 aXV8bY+Ln9+c2NwzhfhIFto0HV+OPri9WUpW7zLxRt1JNrVxQltzMbLV0X2FdZtlVno7Tpzid0J
 t9fQZxqAYTDoo4qLOqrqtiY0UC4IRWaF7ClJk+iMIS8XwRxS6W8DM5jCLoyxCYPccSStHBH1JeY
 Tiggei9GYSRnB641pwdZckF1cPiv7zwYbRE5LTDh2e6uY3VhF/l5lXYSRHRnSoMAh7+CzRJUMc+
 wFx7HQIXttJpE0loZ0+rDAvAnYNyGi11GHKakXOit9CXlTTxRAxGDkzSM5XwJHKOp9WgdwEvdEO
 vSkK51XMyWj819bXSzJzU2d9ouNTZ5rCqsrc+QEBv2mpqGD6vo3XX8xNhKFAOkSRT0nhWcSH/nf
 5PEPfJEfdco+QChkAUqAPxwLRYidy1BsofsxEwaYIJvdYGhrJto/PT3kDYYNWjz1BZfxUUqtqDU
 JMEyb1LJ3kYhi/FEUcw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEwMCBTYWx0ZWRfX2KJQfC9W7wka
 2pl32WDd2oe7+bfdW7sSBoCuwiJ8UaVixP6aaeU6ObelSSX6Sy+k8z2Yz5ZtC1xO4cPjf5zfhJq
 cvzYm4V6PPirUgV8D2FBD0ftwG9yzuU=
X-Proofpoint-GUID: 8G8OYLaer2puvv6XowzcQg3HtiwZT2Y4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210100

On Fri, Sep 18, 2026 at 03:30:45PM +0200, Steffen Eiden wrote:
> Historically, KVM feature opt-ins and callbacks (e.g. read-only memory,
> MSI routing, generic pre-fault memory, lockless aging, halt-polling
> controls, and vcpu run PID changes) were configured globally via Kconfig
> symbols (CONFIG_HAVE_KVM_* and CONFIG_KVM_*).
> 
> With s390 hosting multiple independent KVM implementations within the
> same kernel build (native s390 KVM and arm64 on s390), global Kconfig
> selections force both implementations to inherit options that only apply
> to one of them. For instance, selecting KVM_GENERIC_PRE_FAULT_MEMORY for
> native s390 would force arm64 on s390 to provide unused dummy stubs.
> 
> Replace these global Kconfig options with architecture-specific opt-in
> defines in <asm/kvm_host.h> and standardize their naming by dropping the
> HAVE_ prefix:
>   - KVM_GENERIC_PRE_FAULT_MEMORY
>   - KVM_INVALID_WAKEUPS
>   - KVM_MSI               (formerly HAVE_KVM_MSI)
>   - KVM_NO_POLL           (formerly HAVE_KVM_NO_POLL)
>   - KVM_READONLY_MEM      (formerly HAVE_KVM_READONLY_MEM)
>   - KVM_VCPU_RUN_PID_CHANGE (formerly HAVE_KVM_VCPU_RUN_PID_CHANGE)
> 
> This allows each architecture and guest implementation to configure its
> supported capabilities independently in its kvm_host header and eliminates
> unnecessary fallback stubs across different KVM targets.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h     |  3 +++
>  arch/arm64/kvm/Kconfig                |  3 ---
>  arch/loongarch/include/asm/kvm_host.h |  2 ++
>  arch/loongarch/kvm/Kconfig            |  2 --
>  arch/mips/include/asm/kvm_host.h      |  1 +
>  arch/mips/kvm/Kconfig                 |  1 -
>  arch/powerpc/include/asm/kvm_host.h   |  3 +++
>  arch/powerpc/kvm/Kconfig              |  1 -
>  arch/riscv/include/asm/kvm_host.h     |  2 ++
>  arch/riscv/kvm/Kconfig                |  2 --
>  arch/s390/include/asm/kvm_host_s390.h |  4 ++++
>  arch/s390/kvm/Kconfig                 |  3 ---
>  arch/x86/include/asm/kvm_host.h       |  4 ++++
>  arch/x86/kvm/Kconfig                  |  4 ----
>  include/linux/kvm_host.h              | 20 ++++++++++++--------
>  virt/kvm/Kconfig                      | 20 +-------------------
>  virt/kvm/kvm_main.c                   |  8 ++++----
>  17 files changed, 36 insertions(+), 47 deletions(-)
> 

...

> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index c3c0ee253fc7..008b110ebdb7 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -9,7 +9,7 @@ config KVM_COMMON
>         select PREEMPT_NOTIFIERS
>  
>  config HAVE_KVM_PFNCACHE
> -       bool
> +       booCONFIG_ltt

Sorry, that must have sneaked in last minute.
Obviously, this is a mistake.

