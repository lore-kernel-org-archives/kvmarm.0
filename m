Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DBA3F8881;
	Fri, 17 Jul 2026 12:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784292266; cv=none; b=sarz4R/7YEgjTT1eGrrTmXoSDjRhDFSJP/Uig6BMNs8dkNy5PvTkD3vSjNgjNFgrsWVTmYssz68dBebjWoU2lgDf3ms7/ocoeBWjI6T8hhBBDLooA+gOySu5GwCggAU0GyTC8mnBM1DWe3zo1lV2Tr6Z6lb3HGhP0wyEr9iqAtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784292266; c=relaxed/simple;
	bh=gz6iJAdUDQ+ZO/Wkp4qDUTE0fFHFse5ZsMzhQkZAwgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYBbKnB6YmBYsoOThwtcC6aSO+thoQu6Qgrn+RnRj1EtEYHnXNnM04MyG1JWDlp4AwnaKRa0CQfWc3gW+h4DgugDJRGkzqT8UiNaw/dzWK+/YgWJkjtPFJ4LyKx3Q3EoPoeO1yPVJnbumzDuyLpzCLs4HLdQHj5k+ZskPqZCTqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dl+bmZWk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dl+bmZWk"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HCg1WT2033767;
	Fri, 17 Jul 2026 12:44:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=bA5GdHKtXn2db8UxsUpNgEhioPfin7
	FEKnKBdzMLZ6I=; b=Dl+bmZWkguo25WfWEXP99Dg/dMDXr0jAng7swVS08Xko1E
	+A7uFAxDjUN4YeD0TfFAFmIzDgPanUPonMepnMqkoh5gZShbtqfNA9dUJC+wXXEG
	9CA0ZZeZhZvInle3llfYtUKDejmrVUBYekkxdIeX7oIIOxDgJ6nX+r+6o2wDiJ3H
	GvlfJ8kQGeYsJO3RrcEAfJZzTSdIZXeqDM9/J95QP45gr1N2VP77tAkh5mvSRdqV
	Yi/wQt5oiHwW3GIqtTlX5fzIvl5McmD9t9DuMYbWWRMTS95lc8i4fFYe5l7o20pM
	BPctzR9cyiBnUiClG8Rs3BH9lBp122w65CqK/2GQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbegc5ejw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 12:44:03 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66HCYcvc028989;
	Fri, 17 Jul 2026 12:44:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc15k9n2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 12:44:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66HCi0bI50594156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jul 2026 12:44:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D817D20043;
	Fri, 17 Jul 2026 12:44:00 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E98220040;
	Fri, 17 Jul 2026 12:44:00 +0000 (GMT)
Received: from osiris (unknown [9.87.159.133])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 17 Jul 2026 12:44:00 +0000 (GMT)
Date: Fri, 17 Jul 2026 14:43:59 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Quentin Perret <qperret@google.com>,
        Sebastian Ene <sebastianene@google.com>,
        Hyunwoo Kim <imv4bel@gmail.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v6 3/8] KVM: arm64: Factor out reusable vCPU reset helpers
Message-ID: <20260717124359.319936-B-seiden@linux.ibm.com>
References: <20260715081238.1891918-1-fuad.tabba@linux.dev>
 <20260715081238.1891918-4-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715081238.1891918-4-fuad.tabba@linux.dev>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=fOcJG5ae c=1 sm=1 tr=0 ts=6a5a2394 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=1XWaLZrsAAAA:8 a=9jmm95dLNYizn0WUGbMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDEyOSBTYWx0ZWRfX42+OWfiGSYcu
 2AIsK+wqk6Pu+8v4/XGlNIOqhLGHziw3ozwp8jOFE313yIxf8zdA7dEa8foau5VvD7gy+Ea+NPW
 f3gBHLZyiwZjy9xIQq+w86BHb3BIj443w6qft6G01suJfn4p29WiuZAp4rIyeZVfp+Vl28E4WhT
 h7LMlSggLpDjvj60WWy40nAkEdnoJJA9755S5Ovw0+F0qeYiqNJAEH9eVIax536CbSZ5reGy7Ad
 CYvXRLZ8aySTXiH1iK4Y58b7BjK8E6NXFalURv+t25/OWT+IWuRALjrnsBcvYf8BFhtB5cb1VxA
 H/NWldFof/qz+I/t5+1GsD1UH0lcOd5npyXgVGmpnrYHzbZjAhfe+HTQSMlmef+8bRiUyZrxCto
 RsW6EgIqKoyRo78fzDAiatglD0MjykstldIv19w5fcAUScNrZXku64kdtyT+m7FMciLl86TILfi
 WZoUlRqRMOLNhgEkQew==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDEyOSBTYWx0ZWRfX8a9XsghjmHVe
 /p3/ZRjHA6aRtYHm1I9uBG+qTFAXi2u4wLuTATv0pdb+PgAuVyqcY924j/fb0t+Z+Vhte5t9UHT
 wDbuO+Ae0JHOWvOrp6Tt6Uc/hB1m5mg=
X-Proofpoint-GUID: AAio97567cpyKve32dZnzaYQ0va_67NX
X-Proofpoint-ORIG-GUID: d6stTD7YvT3wK5FeKvDrUou5uCOAnElc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_03,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1011 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607170129

On Wed, Jul 15, 2026 at 09:12:33AM +0100, Fuad Tabba wrote:
> Pull the reusable pieces out of kvm_reset_vcpu(): expose the reset
> PSTATE values in kvm_arm.h, and split the core register reset and the
> PSCI-driven reset into kvm_reset_vcpu_core() and kvm_reset_vcpu_psci().
> A follow-up series reuses these to reset protected vCPUs at EL2.
> 
> No functional change intended.
> 
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

That looks good. There is another usecase for this. I did a very similar
thing in [1] to reuse the reset functionality for arm64 on s390. I  just
did not the move the code to a different file.

FWIW: 

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

[1] https://lore.kernel.org/all/20260706085229.979525-11-seiden@linux.ibm.com/


	Steffen

