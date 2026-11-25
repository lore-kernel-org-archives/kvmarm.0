Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620668;
	b=1Vi45iHkGENivlQtyTGEsmQEt4PxwrfBI5F7pdysStck68v3R6ernZ5f2e5BBpKA/Tva
	 wzLWLpgm2rGb4USgUGG1r/t9NzwUhGcHka7YeFbzJfSDEghv4bXAw3QuBpufzi7hKQUIj
	 OvmpCk272/IhfETYkz5BxSaQyzfJ20FbqJiJ6ccqnP3SXnahzBNej9V4TE6qPajmteWzs
	 Nix8iyvaIdjQqvptjeCr4DGRO0aroWLRViMF2qnJXO4nj/bBRhVUY/pr9THyX8e1mYohT
	 XLYLbaQiwli/Eii6jl/q9zUIvURgHljtl/VDQHWh9zBWd1F/OZkz9AL0iQAibGfdIJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620668;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=zUZyVE+QjYtPIt3BxSr54WBueSqcfOwFowJbKlqWTGU=;
	b=hhIeXpREDCTYelbn5zvhJKQgHCougjFiyFWT0WGgE4pVYVW5YAy2ZYY0jnB7mKWrLlpi
	 9TvG9SDayhpv3Jkq+fgxqqRkV5jFpmxfIMJzjaWSV1KSen6WgqDl/iKzYZcGYc40Peakx
	 T72Xyi6E8J+T5e0KUINLG57acGIAtBqX7IaLq+j3wYyEdlRWsILssgZL3I3+1OcLN1pgG
	 gJXNva8oRBG+b9hVV8xNpbp/8GcOI2yx8c2vVWdKoH4/It8LCHiXll1YtUn7dJgX1jWV4
	 HT+dkDCjs5DsfMtW6nVN9hOvvEXbR0tWM1S7WP2EPuL/QdPIB8VRVQd1BSyjn4/YIbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="D18L/7Ug";
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EBA606A31E
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:31:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9EBA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=D18L/7Ug
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6APEYbHD1607612;
	Wed, 25 Nov 2026 15:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=zUZyVE+QjYtPIt3BxSr54WBueSqcfO
	wFowJbKlqWTGU=; b=D18L/7Ug7f4bfwBgZ5meV3YQMG4mWB8x33OAEAXoZ3z/oc
	tXUNyfJ3YWGgV8oJLU88CNGd0vip0jm1arbKBQpZjdo3Vg8tZ8rSk5iQH3Cpj5C/
	GOb1l5EPsakhoejGHjJz+XN281o41Y+eRcQLKuII7BFhBt71JdYTciQcTytb8ah6
	qGRAUnWZgLerbRRJhyaaQopziJLWI8FFE8nQLZa+Fh9DumWjkl4gOjA3A+QwpATd
	WwlRxhgVi7ireTq6oWChg3FNRkoFKtr8IfucZibazgp+MT2tsZDD+yHl6DUhorv6
	o2RJ+APS2LZ3pX/U5ulco5OWpcJxu/hxc3Ltv7Qw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g1cncw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Nov 2026 15:30:34 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6APEKZDO918882;
	Wed, 25 Nov 2026 15:30:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j5dcuuuvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Nov 2026 15:30:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6APFUTdM53084564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Nov 2026 15:30:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D20520040;
	Wed, 25 Nov 2026 15:30:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F4862004E;
	Wed, 25 Nov 2026 15:30:29 +0000 (GMT)
Received: from osiris (unknown [9.68.29.29])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 25 Nov 2026 15:30:29 +0000 (GMT)
Date: Wed, 25 Nov 2026 16:30:27 +0100
From: Steffen Eiden <seiden@linux.ibm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Fuad Tabba <fuad.tabba@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Andreas Grapentin <gra@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Friedrich Welter <fritz@linux.ibm.com>,
        Gautam Gala <ggala@linux.ibm.com>,
        Hariharan Mari <hari55@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 02/23] KVM: arm64: Extract number of sys_reg_desc into
 a constant
Message-ID: <20261125153027.117976-A-seiden@linux.ibm.com>
References: <20261106-sysreg-v3-0-75e95980fb10@linux.ibm.com>
 <20261106-sysreg-v3-2-75e95980fb10@linux.ibm.com>
 <awbw3NyDifa0WjhZ@e143914.arm.com>
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
In-Reply-To: <awbw3NyDifa0WjhZ@e143914.arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AV9dufpHQOAcCszHCzsGcP_PgK8iy-CT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDA2MCBTYWx0ZWRfX9sXFgl6CWlVW
 oD08l1dCaLsrG/W1ZVLQb5bvvKWAnWSVQN4ExZ5FozQ6eCX8Bwaum80t6PmL3m5EAo7VfYKI90/
 j2XiRj0PTCKdJMNDvMJYkvvmy0UnWOM=
X-Proofpoint-GUID: AV9dufpHQOAcCszHCzsGcP_PgK8iy-CT
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b06ff1a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=7CQSdrXTAAAA:8 a=y-atdSe32WjmkHD_2CIA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDA2MCBTYWx0ZWRfX+W0viPvNBaUX
 JdQKRuvaMglM2QqPyjJEyW2Y24b4OwViyQQhgg956yD189wZJMZTh5zyeCKwkYBmp5boebWacJe
 NNKVKqp9Zlp9hjIbzmKOHbwMIG+WNCGoGZuiCJcR/zvJV/Z1pGoXuT6I41cIHLBv5IEazIGy4vV
 mKHbWi1/tWD5pRICYfj7VqjaujSBzJx3q12WQ3GMA5bVshJHZXtGu1SNhH4wIibWqppUEuOZ+Oi
 a6HCHT9KfkucjWyb2POBBccnWR02Nx7oEsl0Zagqy/NkKffUuJjFeVUH5DIDCmxs6akUQpLh+Uq
 yKTgu7DSdUBeY6P8YtX1Ui0Tltk31FDxuctVlTCshg2gvhZovP+Q6LRDMYNpnEH4J/W3+gXlqCC
 WTnq6RWEzqCuWGeiuUucxDT4zn3bE3jEMgVT9KSHQfmSYiRXW3iCjaeiaZK3cKUDxDF1IiVxujx
 UVjPoOGgAqEVbcI6S+A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-25_04,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611250060

On Wed, Nov 25, 2026 at 02:29:48PM +0000, Joey Gouly wrote:
> On Fri, Nov 06, 2026 at 05:07:35PM +0100, Steffen Eiden wrote:
> > Define the constant `num_sys_reg_descs` which stores the number of
> > elements in the sys_reg_descs array. Replace all occurrences of
> > ARRAY_SIZE(sys_reg_descs) with the new constant.
> > 
> > This refactoring eases the integration of handling system registers for
> > arm on s390. s390 needs code from the shared code to define the
> > sys_reg_descs. But also the shared code needs the definition of the
> > sys_reg_array and we cannot forward declare arrays and use their size
> > before it is properly defined. This patch solves this chicken or egg
> > problem. For the time being s390 cannot process the full arm64 defined
> > sys_reg_descs array.
> > 
> > No functional changes.
> > 
> > Co-developed-by: Andreas Grapentin <gra@linux.ibm.com>
> > Signed-off-by: Andreas Grapentin <gra@linux.ibm.com>
> > Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> 
> I see later in the series, the include of sys_regs.c into s390 is done
> before the s390 sys_reg_descs array is defined.
>

Are you referring to [PATCH v3 08/23] KVM: arm64: Share system register code with s390 

There, the sharing is done from the arm64 side.

As this is a new file for s390 the sharing only gets effective with
[PATCH v3 16/23] KVM: s390: arm64: Implement arm sysreg managing infrastructure

There, in arch/s390/kvm/arm64/Makefile.gen I add the sys_reg.c as shared
file. Before it will not be processed (nor included) by s390.

And there in our sys_regs.c I'll define that array.

Or did I miss something?

> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> 
> Thanks,
> Joey
>

Thank you!

	Steffen

