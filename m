Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7C3382F19
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 12:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776772849; cv=none; b=fssuIU78Cart3fGGG3/2rOHvqc5XMDhyS8oEU2GhJXJuGk3KlMtL4HHs9jVZizydCAvBZTZkewpmPHzk/r8l9zEQ37cQ5jcFIvBJRD4x0jojHcirpsck+9Mh/7peQChJjgR5ZjOXKLrlhnqAxCADcBwu5Er2RxPx8fPv9idj2X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776772849; c=relaxed/simple;
	bh=jdTMyVKl7mqgrtZHznfktqjdt89bUnvAEZbCRVLGz5o=;
	h=Message-ID:Subject:From:To:Cc:In-Reply-To:References:Content-Type:
	 Date:MIME-Version; b=qp8I5TKSQ2Rx1U1J9GFQx0Pf7/imVgwAcwRGHkSXw5sorAOqJyrqZ6tZa0MT8yWg3cHxWTN1X8rDfpACJVrfCuVwPYPJD7r7eqPv4RT19iOEllo8B7aKWh4dJFVm+vwh+JcnId77JQkJOlv/X6SjIEzldhTvhDO2ptMiDBxfe+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=r+kr/x/t; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="r+kr/x/t"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KJgcsg2328269;
	Tue, 21 Apr 2026 12:00:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/7V9HP
	uIqnD85K2oDoEgBomydr4fK04ZND9W1sNTOgU=; b=r+kr/x/ti0V6c3IkKod/VB
	d7eNY+/P6ZmaGYqTCpbndu0U1exnGOAnuR9I3Ots3K3F0GsnACDionm9kTyezu4A
	jpt+WEQf0gd68pMpYy+36Y8gxHW50x6Nsrv0Ocgex+vp/BdF62yE4O6zK1mkqG7M
	LvmiuYsHgLbcF3tIpiNQKRLFSGnrlwmDLJuZTa1Mjd8DCriVvIs+BXYgxv7R4i2y
	3o2wHSZi2J6fmRWJvakd5mvvJJOJvAhRZEv7He+54DJ8sgx180v3RkOz21Aed0VC
	93IiY4uxqRyFPRvVGUX4s8BhjSaN1MbUx9e6e7IHm2cG9WLbBqFPfCcifrwAYI/w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2k0uc15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 12:00:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63LBoIr6028465;
	Tue, 21 Apr 2026 12:00:16 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmn9k0hsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 12:00:16 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63LC0FZJ24445552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 12:00:15 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB7CB58064;
	Tue, 21 Apr 2026 12:00:15 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A1B8958062;
	Tue, 21 Apr 2026 12:00:13 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.28.47])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Apr 2026 12:00:13 +0000 (GMT)
Message-ID: <a6a0e15286c983d720de227c6827adbe976c5b9b.camel@linux.ibm.com>
Subject: Re: [RFC PATCH 1/4] security: ima: move ima_init into
 late_initcall_sync
From: Mimi Zohar <zohar@linux.ibm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com,
        eric.snowberg@oracle.com, peterhuewe@gmx.de, jarkko@kernel.org,
        jgg@ziepe.ca, sudeep.holla@kernel.org, maz@kernel.org,
        oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
In-Reply-To: <20260417175759.3191279-2-yeoreum.yun@arm.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
	 <20260417175759.3191279-2-yeoreum.yun@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Apr 2026 08:00:13 -0400
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: lvh3OHjg1O_576NYFViCNKPWZGCSXB1N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDExNyBTYWx0ZWRfX7+yITLJGcICe
 Wy7Tl6qKVtdEs3wELScUUUtAg4HW3xSgBpBrBNg+HrHuWfxIGUqvc5dNfA7vZAJshlgqypmp9Ow
 l4NNlQUq2Odi+vbwGJjfpev9rJbVuWFIRhJm6Lq9P+Q79FOIetUYMbgt/aOBsYoZAvt9V+XNodc
 Yasn2zAY/i6QJGtaQAzrwWUtg4oUeNRJGLegroApJtZt6LA8yAsLiqr7Xap18QzMayV7bCBBLrQ
 C+VknHo0fG8aXmXa2MEXzzbQrW/RU5UQXWfjkhKt9gZnUPVITwTjIiX/2h5/RobjNZikJxfErlH
 DgLcgldsIDClsMJVV4TWIRTTanVtuVBMGyKXThvj2xRg5JT5CGjfP8v8Ckq5t/13DfeXcCHXj8o
 SCHK4xCOKDdB5svZOUsyR9vO53c0R2QoeLJIT1v/wpagsB35oWPfaQx60TFk+6RPCy2LVk4Lxph
 1t/77m/3qhulw3V2Dmg==
X-Authority-Analysis: v=2.4 cv=PtujqQM3 c=1 sm=1 tr=0 ts=69e766d1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=7CQSdrXTAAAA:8
 a=0cQYFyLwv25f5AwIjZYA:9 a=QEXdDO2ut3YA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: idKqLRdvVn5SfRlMsXj151u3ESLzKcl5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_02,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1011 spamscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210117

On Fri, 2026-04-17 at 18:57 +0100, Yeoreum Yun wrote:
> To generate the boot_aggregate log in the IMA subsystem with TPM PCR valu=
es,
> the TPM driver must be built as built-in and
> must be probed before the IMA subsystem is initialized.
>=20
> However, when the TPM device operates over the FF-A protocol using
> the CRB interface, probing fails and returns -EPROBE_DEFER if
> the tpm_crb_ffa device =E2=80=94 an FF-A device that provides the communi=
cation
> interface to the tpm_crb driver =E2=80=94 has not yet been probed.
>=20
> To ensure the TPM device operating over the FF-A protocol with
> the CRB interface is probed before IMA initialization,
> the following conditions must be met:
>=20
>    1. The corresponding ffa_device must be registered,
>       which is done via ffa_init().
>=20
>    2. The tpm_crb_driver must successfully probe this device via
>       tpm_crb_ffa_init().
>=20
>    3. The tpm_crb driver using CRB over FF-A can then
>       be probed successfully. (See crb_acpi_add() and
>       tpm_crb_ffa_init() for reference.)
>=20
> Unfortunately, ffa_init(), tpm_crb_ffa_init(), and crb_acpi_driver_init()=
 are
> all registered with device_initcall, which means crb_acpi_driver_init() m=
ay
> be invoked before ffa_init() and tpm_crb_ffa_init() are completed.
>=20
> When this occurs, probing the TPM device is deferred.
> However, the deferred probe can happen after the IMA subsystem
> has already been initialized, since IMA initialization is performed
> during late_initcall, and deferred_probe_initcall() is performed
> at the same level.
>=20
> To resolve this, move ima_init() into late_inicall_sync level
> so that let IMA not miss TPM PCR value when generating boot_aggregate
> log though TPM device presents in the system.
>=20
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

IMA should be initialized as early as possible. I'm really hesitant to defe=
r
ima_init() to late_initcall_sync() for systems that the TPM is currently
initialized in time. For these systems, continue initializing IMA at
late_initcall(). As a compromise for those systems that the TPM isn't prope=
rly
initialized in time, define and instantiate the late_initcall_sync().

ima_init() would need to differentiate between the late_initcall and
late_initcall_sync.  On late_initcall(), instead of saying "No TPM chip fou=
nd,
activating TPM-bypass!",  it should say "No TPM chip found, deferring to
late_initcall_sync" or something similar.

thanks,

Mimi

> ---
>  include/linux/lsm_hooks.h         |  2 ++
>  security/integrity/ima/ima_main.c |  2 +-
>  security/lsm_init.c               | 13 +++++++++++--
>  3 files changed, 14 insertions(+), 3 deletions(-)
>=20
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index d48bf0ad26f4..88fe105b7f00 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -166,6 +166,7 @@ enum lsm_order {
>   * @initcall_fs: LSM callback for fs_initcall setup, optional
>   * @initcall_device: LSM callback for device_initcall() setup, optional
>   * @initcall_late: LSM callback for late_initcall() setup, optional
> + * @initcall_late_sync: LSM callback for late_initcall_sync() setup, opt=
ional
>   */
>  struct lsm_info {
>  	const struct lsm_id *id;
> @@ -181,6 +182,7 @@ struct lsm_info {
>  	int (*initcall_fs)(void);
>  	int (*initcall_device)(void);
>  	int (*initcall_late)(void);
> +	int (*initcall_late_sync)(void);
>  };
>=20
>  #define DEFINE_LSM(lsm)							\
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/i=
ma_main.c
> index 1d6229b156fb..ace280fa3212 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -1320,5 +1320,5 @@ DEFINE_LSM(ima) =3D {
>  	.order =3D LSM_ORDER_LAST,
>  	.blobs =3D &ima_blob_sizes,
>  	/* Start IMA after the TPM is available */
> -	.initcall_late =3D init_ima,
> +	.initcall_late_sync =3D init_ima,
>  };
> diff --git a/security/lsm_init.c b/security/lsm_init.c
> index 573e2a7250c4..4e5c59beb82a 100644
> --- a/security/lsm_init.c
> +++ b/security/lsm_init.c
> @@ -547,13 +547,22 @@ device_initcall(security_initcall_device);
>   * security_initcall_late - Run the LSM late initcalls
>   */
>  static int __init security_initcall_late(void)
> +{
> +	return lsm_initcall(late);
> +}
> +late_initcall(security_initcall_late);
> +
> +/**
> + * security_initcall_late_sync - Run the LSM late initcalls sync
> + */
> +static int __init security_initcall_late_sync(void)
>  {
>  	int rc;
>=20
> -	rc =3D lsm_initcall(late);
> +	rc =3D lsm_initcall(late_sync);
>  	lsm_pr_dbg("all enabled LSMs fully activated\n");
>  	call_blocking_lsm_notifier(LSM_STARTED_ALL, NULL);
>=20
>  	return rc;
>  }
> -late_initcall(security_initcall_late);
> +late_initcall_sync(security_initcall_late_sync);
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>=20
