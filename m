Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA37279355
	for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 14:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778770472; cv=none; b=EZ+8oHm6Zg0CqSFYemH8Dw+aKB3MEJMufZm3CysRQzKPItrLhFGAHxV0ZxUnDeg45DT3BQPN9L5skFpDnEstORLYLugT5XnVRyqcuOEtgjc2h3kP+2CQ1VsytgjSbbPmV6WeAcPKQJSbdcyYOmxjfCvF+1/ukRJSWxqwtGSdkAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778770472; c=relaxed/simple;
	bh=6iO+GUcpore21n/vm8B3UhhRwq0E/MgLRwHmZOsDgzo=;
	h=Message-ID:Subject:From:To:Cc:In-Reply-To:References:Content-Type:
	 Date:MIME-Version; b=rVddWm0Yz+88C+tgjHYppcG8BOHSVvqg0K24NlBUzUx3qXvZ8VoiyE+16ziBmw3UJY681PcSsd5j1c1aSEYz8PH16KlbfiDL91yG0K/JTYNMu7WvP4rMUI24QRMDcQATq1KXecms6FPxpJDtVDgrKdhkGrHJWChppC9gDY7aqbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jWXwzDGj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jWXwzDGj"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64E7VpDb2760524;
	Thu, 14 May 2026 14:53:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Nr+zBI
	eb6oLWpscVXrY7yWl4bLme2s90+7/quaFrDWE=; b=jWXwzDGjAfIJIefV3yAbfE
	vGBac6v7Dq5RtDeKLlebT3s/LOqOGbzieFCEFssJwbZADSQxydqIfZoZ8NADXdlW
	PkEEO7um/Cvt1qN7P0PaVfBiObnwVIoLFb1G4AG3yumrpKvjUZOA9osI3YEizckq
	Ys3OGo9pUWWG3JFCV6zl7dYju+rEgMsufmSC+DPeomKtp0zVL9d5UMeReO9Z+Xb6
	7WdTKcPVyNu2loG5HiiizxnWrYWE3mU+hirrnM7Uiafmlt2utZ5WDfTNkekKrTaM
	pFRTl8qrMqxNn/KXnrXSgBpgxL20qpGM15GpeQ/nLL95lJa+YAMvqNfbVOCYp48g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e3nv6ve25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 May 2026 14:53:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64EEdSLo011549;
	Thu, 14 May 2026 14:53:47 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e3nfgvu0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 May 2026 14:53:47 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64EErkQA30802460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 May 2026 14:53:47 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C78E95804E;
	Thu, 14 May 2026 14:53:46 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 472DA58054;
	Thu, 14 May 2026 14:53:44 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.132.198])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 14 May 2026 14:53:44 +0000 (GMT)
Message-ID: <484268465668bbe64bebb651ec1a5ba1cb3a8078.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: debugging late_initcall_sync measurements
From: Mimi Zohar <zohar@linux.ibm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: David Safford <david.safford@gmail.com>,
        Jonathan McDowell	
 <noodles@earth.li>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com,
        eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca,
        sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org,
        joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
        sebastianene@google.com
In-Reply-To: <agXDQhREKIpN7mKX@e129823.arm.com>
References: <aftIuPwNeuzc9nY1@e129823.arm.com>
	 <9d1af933ef218b159762884357d127e3644dfe2c.camel@linux.ibm.com>
	 <afwoDgaJxmKwOhXp@e129823.arm.com>
	 <f19081f1eda19d6d1ae133d8ec93e779ab1a25e5.camel@linux.ibm.com>
	 <afyIbW5cljh5ZvTL@e129823.arm.com> <afzwJn+5r15jFxrB@e129823.arm.com>
	 <77ad49cca1acf707f4152ed3e2066b2f24c90c16.camel@linux.ibm.com>
	 <af2nhZyyNaP7LM3w@e129823.arm.com>
	 <2b3782398cc17ce9d355490a0c42ebce9120a9ae.camel@linux.ibm.com>
	 <af3oFfdSMUglZVHa@e129823.arm.com> <agXDQhREKIpN7mKX@e129823.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 10:53:43 -0400
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: RNQ8oePVP3OcTEWXWuN-MJCpoZ8GUua7
X-Proofpoint-GUID: Ja8W_i6HjqlbNZYeJV5EqFaHW6PTf-0C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDE0NyBTYWx0ZWRfX6mjC1By9XssU
 5ODyxnAoEdhYwBFP+F9G+Ms1k3rq0TeQSj6UOdvoQKpspC8LJSRvIhQK4Yuh5wEOPXCj0cF5V6S
 BJ5A4qC1wq/BHEPBR0TNJVo1YCDQmxcwrq7zM8MyVrRIlFNPlzAe5Dq+9U1RGa3pEZp6Dbl5Cyd
 us/1Fu1apgg996aaNfPB6iAI7iUfSig8dXQKTAWBbf/WKto+Cy2xCJVieFHOq613bGbkezjE27b
 3OPv5kKldb7v5SXC/mlJY+ugMqrLZTqv0CYrkK0xW+omsnRULy69QhI3zvbOML1LyfDV5gHqO9o
 pud0GQ9E6dINqjtahzlvP0wR5EdyEaYP0QJEtxL+Onk+IXKuPqGUsRNuw1+YUVXzemzGn/cdbgY
 e7O63UsooHdIy4Y3aI/hwz2p+GJ6qLf6382nriXFbuxS4MPBC8ScstHwv5H7+0H6saC9bHnWbaQ
 eyiq4os6kCPETF15nSg==
X-Authority-Analysis: v=2.4 cv=P8UKQCAu c=1 sm=1 tr=0 ts=6a05e1fd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=ffCD1m_AeV4Uy92bQHgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_03,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605140147

On Thu, 2026-05-14 at 13:42 +0100, Yeoreum Yun wrote:
>=20
> I wonder what's going on for discussion to resolve these problem:
>   1) measurement event (via file operation)  before IMA initialisation.
>   2) deferred TPM device initailisation and IMA.
>=20
> Might someone could think it wouldn't be a problem since initrd is
> measuared in PCR9 by boot loader (e.x) grub, but it still has a problem
> for the case uses root=3D boot option where it doesn't use initrd
> but use specified block dev with a filesystem.
>=20
> I think soluation would be determined whether IMA neglects the
> measurement event before its initialisation or not in current state:
>=20
>   a) Case for neglecting measurement event before IMA initailisation.
>=20
>     In this case, As you suggeested, IMA initialisation should be
>     determined by build config whether it initialises at late_initcall
>     or late_initcall_sync so that make user can choice upto their
>     platform.
>=20
>   b) Case for considering measurement event event before IMA
>      initialisation.
>=20
>     I couldn't image any other solution except queuing those event
>     and extend them after generating boot_aggregate log and if those
>     event can be queued, it wouldn't a problem to move IMA initialisation
>     to late_initcall_sync.
>=20
> But you mention there are some thoughts from Roberto, might there was
> some discussion with him. If you don't mind, would you let me know
> how the discussion is going on and your thought to fix this all?

Adding support for "missing early IMA measurements" would be considered a n=
ew
feature.  Queueing early measurements before IMA is enabled, as previously
mentioned, breaks the "measure before use" principle and could therefore be
exploited to bypass it.

One alternative being considered is denying access to anything that would b=
e
measured/appraised based on a builtin IMA policy, though it remains unclear
whether this approach would break boot on existing systems.

Mimi
