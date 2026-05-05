Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B8C48A2B1
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 21:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778015105; cv=none; b=j6uESINjfY0N+e90EPoDj/OlhzrMRARGq/TEXFzXK5G6Kczq/nvQPrO1StxwHH/WCzIPaBb02TuJcYs2GwKWFEK2spJuVMgkILwM4JQquWw0PqM6+oUZw6OqofXCad4+Gp/WL5ioNeVh5+WwSHPr1JW4sp8MAmwGUVI9fwPsyOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778015105; c=relaxed/simple;
	bh=K6Uw5PEm/3EwFirnqIR9nGAX6pBzs0Fd+iGhIH+Nu7A=;
	h=Message-ID:Subject:From:To:Cc:In-Reply-To:References:Content-Type:
	 Date:MIME-Version; b=WC5UmUn3VjGXhg82UN1GXENggw9bq+kCAHOAKTEjSYoKZTf3ZPTRM8DBCSUEGHCQFQZLhQeyliXHKvISvOsZoC4lHFOmzuYjO5NQdhftIR1bSQeJgzywNQQ5w6k5FUQCFrmWWtjLdc95pJTOIImj5vnU3+ZLk2HoFPseCbXFW8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HCj5CcPK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HCj5CcPK"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 645D7QTH2292989;
	Tue, 5 May 2026 21:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AUDjBR
	Uu42d69Q7ZuzQ4M1Lgt5adZxichyo28UabSBU=; b=HCj5CcPKYikI4EXqLFSR32
	RsCeyKYK4Ae9s5074Q4n81zDCeSOvl0+ryfg3AyxCOZmqOYSg6BuqB/BViaaKme3
	0juCObvzEaB0TW4ONzAU80XdlZkHveFtr8AhuUgeTz0v4vyIdNOy8oGoctm47+oa
	GaABYxL0I4pw+psOOyR1X6se4AXzElJrVaFkb1zYViaBaPUPgWuC+y3Yh6kTsz4B
	Ln7f0ThwNK2eYTCNs7TMvuuTVWcIGI/ixNHA9/rLDlsbf7qkZPENB6DJSW4efcZh
	uHr1Dx5WcmurhQdBMVUcxNMqYfeijAqqqv2AXZvBTi04nHPQyB1biICcpaJ90OLg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7dt8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 21:04:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645KsWcn012426;
	Tue, 5 May 2026 21:04:33 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwwtgb9nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 21:04:33 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645L4WDq26804876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 21:04:33 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 936445805C;
	Tue,  5 May 2026 21:04:32 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 517DC58059;
	Tue,  5 May 2026 21:04:30 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.111.233])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 21:04:30 +0000 (GMT)
Message-ID: <a9412fe10e70ce95dd70556ace19368bec5c188c.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: debugging late_initcall_sync measurements
From: Mimi Zohar <zohar@linux.ibm.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jonathan McDowell
 <noodles@earth.li>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, jmorris@namei.org, serge@hallyn.com,
        roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com,
        eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca,
        sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org,
        joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
        sebastianene@google.com
In-Reply-To: <CAHC9VhQY2TMkTvQq9P8oZteQWQSr7qq2utOuH+pdVx+8jWLBCw@mail.gmail.com>
References: <cover.1777036497.git.noodles@meta.com>
	 <7734099f5e7fda5480bca016a9e6707983325fbd.camel@linux.ibm.com>
	 <afMlgstqahnZg68h@e129823.arm.com>
	 <9f188536f09a2db30877d6bfbb84aeaf2565cccf.camel@linux.ibm.com>
	 <CAHC9VhRsnmPp2KmQAns5uq5qXX5EF2xQQzyfTgrPi4O9AXyPpg@mail.gmail.com>
	 <ba4bf28314b679474a6a8da6298e548e54b3754c.camel@linux.ibm.com>
	 <CAHC9VhRE2kRr1fdDf6xgQgpSrtvqtP8Vy9LVGJhDZFUbzLKGmQ@mail.gmail.com>
	 <ff28c6dcb60c357c752724927addaa8c4fd3bf2c.camel@linux.ibm.com>
	 <CAHC9VhQY2TMkTvQq9P8oZteQWQSr7qq2utOuH+pdVx+8jWLBCw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Tue, 05 May 2026 17:02:29 -0400
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDIwMCBTYWx0ZWRfX/jmQTDjhSyUW
 a6LYs6KgFw5yBnttZF55PGvDUHOVHG0/qGgWeitdnf84Bwm5tP1/EukNeStDDhrU+vnaff58Sdg
 uLUHji8keO2Ye8bXIe6XY9J9yz4z9nJ+hazK/O+EwWgR8+pyrPF+I72Dti2jfJFpss/FpSStdte
 f92YyKboWP4q9VNWxwkr3ntwRwWqd9nxbYkvejFSFh5Tgc/11KKCKB88XC/+F39BF2eZjXnieYs
 KNqPjJGNi8UBHeLye2eMh+xYQE32ZKBN0M6Y9X64ZcUcx1gLw8xPhTyfHsT7Zp0ShWeA3U/hdWn
 EB3j4DP82TCFb9t4txo5UFHx72aW74zAELoOjarM+8P/g5XrrVksOQcqHDLWKdH5OVWOViGlKPM
 a8GSWAN+I/sxj8krZgpCp6eX0E8tT3phzuOaNjnz3QbpJjR67DdlQlT8c8IqmVlY0npaVypitKC
 S1pb1mckg7MlFnKjKLw==
X-Proofpoint-GUID: doRHrXqCZk_91sNo7rZqapY8EXxNdxoN
X-Proofpoint-ORIG-GUID: uNiSJ9wA4y033nK2ypxCDn3HwXZEBPdK
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69fa5b62 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=w4bfxRt4CrPX03RNmT0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050200

On Mon, 2026-05-04 at 16:51 -0400, Paul Moore wrote:
> On Mon, May 4, 2026 at 8:03=E2=80=AFAM Mimi Zohar <zohar@linux.ibm.com> w=
rote:
> > On Sun, 2026-05-03 at 12:46 -0400, Paul Moore wrote:
> > > Regardless, assuming you always want IMA to leverage a TPMs when they
> > > exist, your reply suggests that using an initcall based IMA init
> > > scheme, even a late-sync initcall, may not be sufficient because
> > > deferred TPM initialization could happen later, yes?
> >=20
> > Well yeah.  The TPM could be configured as a module, but that scenario =
is not of
> > interest.  That's way too late.  The case being addressed in this patch=
 set is
> > when the TPM driver tries to initialize at device_initcall, returns
> > EPROBE_DEFER, and is retried at deferred_probe_initcall (late_initcall)=
.  Since
> > ordering within an initcall is not supported, this patch attempts to in=
itialize
> > IMA at late_initcall and similarly retries, in this case, at late_initc=
all_sync.
>=20
> Okay, so from a TPM initialization perspective you are satisfied with
> a late-sync IMA initialization, yes?

No. On some architectures moving IMA initialization from the late_initcall =
to
late_initcall_sync does not miss any measurement records. However, as previ=
ously
mentioned, Linux running in a PowerVM LPAR the move would drop ~30 measurem=
ent
records[1].  So no, only if the TPM is not initialized by late_initcall, sh=
ould
IMA retry at late_initcall_sync.

Mimi

[1]
https://lore.kernel.org/linux-integrity/201b9172ac47c6766443c1f2343cab3548f=
33c29.camel@linux.ibm.com/
