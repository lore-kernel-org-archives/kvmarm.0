Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24B42D9EDC
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779896313; cv=fail; b=sVXRNwe4uPZvKe5LspkU5/X80VaaatwGQ4rHWqroxPRTPP9WJ8LRIS0RL2gOUA0qSH9l96y1YJHD/NGBgcbeEsrI9yICSKbdw7vnWRJoBpWfmM0HRVOBjGCqWYJigl+PgrJlvCAkcsZ/d9H1PdwdHmdNi4wVeVMy8akO+gIRax4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779896313; c=relaxed/simple;
	bh=g+s5CGktZq/GseaI3ktG37ASmWXULu16Vj8aA+cvQbs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C7QVWdqVafc0zTEQD7r1SpVfjkBl3dGqndm02QtRXaFaLzCAnRfZ1WpLl9Abw6Eo7bWsGvq/6vxfJkPTqFIkBunowvWPRBntASwTkvHujpV+raXOctIHz8RlantlhcHtx43O02vwWwNfThav8a0TbHx/t3yMH5ZByZMeL0+90nc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=z2jguky5; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=UYe6GXAM; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="z2jguky5";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="UYe6GXAM"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCrg3n2567227;
	Wed, 27 May 2026 08:33:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=YoxdfuTXrh4urPkIzjE/ZPIc5HsHQALxJZPV0XM4y
	Ic=; b=z2jguky5AG+RYcPgOIJpLWYhdlRCyzdIHHgkrALSWgpbMlhD3qwDGmVzV
	7AAySnK+0sG+itl4KZNGCVOTrGZ+mHoq6+eTUya6HiTSs68xY28FCoDchjqRTP/z
	Seef2jVBQIogh2ZB0dhiLA2HBG0VmVg1S9zi9DzN5rou5Cj6J/l08VUBQ6cTRNTl
	sQ1bKpXhsSRCccMJUVHymOIIjdF2D5JKELR81R9G37EAp1ihsURo1Y4pGfJ0NrUM
	G7vRvuaVOO9EJAGpynfr7UhVbs8N4z23emvg9Wh/KaVlk8y74x4JNMfJLY1a6F6/
	d9p1u70wuC9/W4YVLAutYvuJrFmig==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11020110.outbound.protection.outlook.com [40.93.198.110])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4edg592nwv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 08:33:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AhwLsF9D4xg+vn0/+KAoYrPODuHcy7ZJe/DusBtoGgar4RWg/eAfyAguSpOjkYk/0EqiBNOxKFAin8etr8B9oYa5rhOARKbP5GknHBS2fNGGlJfTfSlG6asnHWsNTjU4y24ubYRtEvrMzPX+N/jUVCYdTq0IGGgXQ9fPe/IBF+UzEnrJO/9Q6y3FmQ/Bxm4/SFSBJwv/dH4o7wVqoAciD/pMKTu6R4rQ5j+242iv0nEVHWy0+RBXjSp3YPFSOI878dwnj11XqTomxizbM4xImkF/X9SmBi3ucXkCkILmNqEh9rGNHf/Ahc66RR1i/6vd5CC14n8QYf6hXkSpgrOhOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoxdfuTXrh4urPkIzjE/ZPIc5HsHQALxJZPV0XM4yIc=;
 b=DJACHArn3uYukbRTedbo2dLgbXGaWqWZI6Ik5TbwszUVnhUNDCQfX2f1pzqC1m2P80bAtggd+t8/fPE53LDMt3Qteo6YNoUu2s8xR39SPjelam9X/14kgK8iVx1IJiW3seMZAeUQCtYrV6Yv9fFtqAYR+jgfsQsbgmvpJvGvDdd3acbnhR6wyix2UOkaO8OL25k9bwsVy82aL1w9mc5onUd76j8Tox63U9rYtgERnDWw2j/OSCHv50UATwjAN70gloYo6zhCl09FWtrfuLOd907+XknCv2cxFPJdyL29fZFeHmGGYiUoiqkA/1V5n+mhlj8lEMLlt7uoKww2X5gURg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoxdfuTXrh4urPkIzjE/ZPIc5HsHQALxJZPV0XM4yIc=;
 b=UYe6GXAM3aqOB3Z+P4oWAiLcsR5YqLUJ9743Gg5XYihQy+RX8NNTvd709EgIiZWGjGhMelXo0y7FseBzStXOCaubBqzQiy6+0ziiksqKEnlwQZD//6GFLQ6efK5ipTHuTldvjmBwzfVw8c0eAYWmGaoD4xosgPV1+lYmjei/GHIR2HVZtj0sIPINyV9Y33iFjTeYpoE1Kk4aXOB1q7mZku78sx6mUTvzWZLpBt8dn6HqBREkC/44pzB0lBciTONJBSspLRP6c1llN/dKfPQQ/Zp8mW1L4xWPB8jDbTlGPANrMqeGvGYS7N7XGwippkrROx26btwO72gUf1uTJ7S0og==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB8660.namprd02.prod.outlook.com (2603:10b6:a03:3f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.20; Wed, 27 May
 2026 15:33:10 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 15:33:09 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Eric Auger <eric.auger@redhat.com>
CC: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v5 12/18] arm/kvm: write back modified ID regs to KVM
Thread-Topic: [PATCH v5 12/18] arm/kvm: write back modified ID regs to KVM
Thread-Index: AQHc55O3Z83/o4B/sUidnhGgkCnOE7Yh/r8AgAAM4ICAAAFrgA==
Date: Wed, 27 May 2026 15:33:09 +0000
Message-ID: <AE682297-5095-4C06-ABB9-92F44F44A5C6@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-13-eric.auger@redhat.com>
 <A29EDF01-278F-4975-9659-44359311204D@nutanix.com>
 <5B64C821-01F8-48E2-8F68-95000AC9DF4F@nutanix.com>
In-Reply-To: <5B64C821-01F8-48E2-8F68-95000AC9DF4F@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SJ0PR02MB8660:EE_
x-ms-office365-filtering-correlation-id: 2af73c5c-4c91-44df-c57b-08debc0541db
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|3023799007|22082099003|18002099003|4143699003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 FgC1tix/6q8bQzTKseC0qghf9Z9naf1SG2jXyXaJhkrDeuotqqaRJ44ExYl8AH0HaZhwiDEonXmGoQjEzeidDKGKA1kGSTSO5vRvTF4MYcDZHbFV80Op0t3s+hF0rKRJQu/FxOwGPS/ckkuSaLIJCATSs3e7UyVODQYcxOL+GMaJh0z6yyx3YtIf+dNbnib21SIjTYX6Ann2A5eXB+j1XNLcfCQfDP7Yi21pxpPLG8ZBz7Uctx+70ff+jTZV2luqNJi3bRWsWLGEZTYcFnPoNPr67+eJtBxuD7JZN4/7jCR8S5w5ECzwZKOx0TpvkLCKJTKEH1iWGGWKFFVQadusbSnsegmbo7x/ovgf3vfeZSeZm6jbwifWIihi3GGaM1MdNSYozjIZHadpcNSFNVjj3Wv4IQJTAEdUwTjibYczXV5EqaYgSVfuJU2eGnnwh+Cp7Dfl5nwkH14aceyt9uUGscS+3ieM2fNOPjb+mBrmaVozXEbpbBwtazD4kVjYE1O4Hy49ICgqmMXerkElahIM/j26aIcw1GxiYAFd3cRYZC/YAA8SL1/rPKrN7QXT6XnlQATEoyjUiKGgj55JHzuNlUjVG2VgNA+x3NwlXv+oGMf7ZoE2CBaRzbmmhYQPST+10RScNoH5K8BkZeDnCDdxd+2KIZVttEJmN0VlQBYjW6i7vXFZ/O3fXWQuMqvXJhsBsB5NVn2Ic5OD2tPQyX6hEvEaBeMEx2WHF2BN+fpH1QmpFpSKoJmhYS76WdfOleMs
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(3023799007)(22082099003)(18002099003)(4143699003)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?5hiUNZgU13qDLdREB/rHzFMvHeeNp5FDpYM4sgueGhfIymYWGrvnWSnwMkCt?=
 =?us-ascii?Q?UReYuVWO7Y5b1sr2S4ggXQPGa+bho1B+N/LinRxMcuQVaKouREp+4S6W8s3I?=
 =?us-ascii?Q?BkH6UO3d2kC2rS49SKTqPGIjW4pLy4FA4Qam4OMFpl+xRz0FTB3hj2/MfDbA?=
 =?us-ascii?Q?FfPhlOoFyT+wGy01lmDxI6XJc3SnhZmxa2h9P4uE11Amnysmt6SlFXgVoZwT?=
 =?us-ascii?Q?XA3hKJe0kbaTarsobHrlkkRd8yLDiWJY0dgi8OFWUG8fbcBZ2Li0k9gcBYk9?=
 =?us-ascii?Q?01RrO5QgI0/ndkuSDu1c0WdEleOZ/LfA/gv6s4WKKBtT36aToButNtra8S64?=
 =?us-ascii?Q?zLV5R2Ys4JYqpSJBbUiMIbN8mZQZjHnGu7gdo1P1neD0wcAHV8bigINlIiD4?=
 =?us-ascii?Q?uDeAtY7DLmsPkqLa+oALCmYMQZiwQu2Ii9UeLYjhrnygUS6gj2CwoVclHveX?=
 =?us-ascii?Q?gKnBAMTS26WtlcSc5D+8VnSWvoHnFvGcAHxmr2Q9sl0QoK6fxB0OwDtep1t+?=
 =?us-ascii?Q?EUFzAD0p+T5tixLMA4rSSQgHXDG/vItHskPu5adVPijMIzOyb5Qcp1XGII6J?=
 =?us-ascii?Q?ue82hiEYZjZz3p86uoqKpCfnu/p+I0BISzZIfAlelxiPWjoW0cgGZwQtxQ2E?=
 =?us-ascii?Q?SbJVPlz9Cj74Fr0s6uEZ9kKaieJhHPjjwlrD+GRafojVl+64teToOVFY5RiV?=
 =?us-ascii?Q?OW3lM/YCcYhd3n15KZb0nr1CcjwfVKLTSBAj19O9doSbETMLfPuiPJ+8OvnG?=
 =?us-ascii?Q?GtLodPPdeI3uOv2kVIE7y4dkQGshDrKy7uneaBVCNwyNILwmGHAab7SP0wq5?=
 =?us-ascii?Q?RS04HLAcwMEW7g9hA/ABktlPUxB9K9WJu9hzB6AhMIr/RsZstnVvNkjK33Pm?=
 =?us-ascii?Q?KKwQ+M68rFNRyklbJwjQ3N2MTkI6cbqpU2wQqt+gKilOWScmhhl3yAkY0i6t?=
 =?us-ascii?Q?NpHdIkqqitjMwNW3DRjg/GJWADPJ1vWt66JD3lliU4CMR8PSWEfyq7yafRBz?=
 =?us-ascii?Q?kepTwQJGeIhcfwPf56O8Ap1vEOCKOVto+BN2mTmpS/UhjUKY5Mi+7S9diLs7?=
 =?us-ascii?Q?LroyYhpqNr1i7WtLJxmupZJwQna0fHT9vezqRrur/m8Csv4PwHqWBpwVCKzO?=
 =?us-ascii?Q?8BzQUK9SB5O3o68vatZVYkJf58HSEJD0TKc6tk0Ir4FTgiTNgYybGHRwmFs8?=
 =?us-ascii?Q?SXKtd80Jg8frLqioZEiuAJ4h8sbmdSUXTEEnJAbhufFIDaeHRGhVEt3Aemu9?=
 =?us-ascii?Q?beIO2/XQ5Iq6HroHdciS2bD4tcj9UEP1qOXxphgNdVIddVUk6MdkO2TDWzWE?=
 =?us-ascii?Q?tBmhHJtsq52AGBRf+mBhBOA9dK+PKGOTgpf0fEay53d65g5TBWsXr0fybNCB?=
 =?us-ascii?Q?dG1bJnv5v5u3exCFDqbOtm+aF33W2IHQgNNwyAHeQ44Y3RkbAvdqvsyB2oyo?=
 =?us-ascii?Q?dW4wIKO1FA5EAK0g8Q5ZFi7k2P0UHCzuPyG0SvDh1wFGgKGYmjhmhn2k1IO5?=
 =?us-ascii?Q?WYc3P5uLLWkq2NUXdZ/3WFGHWwmuB4v3CqMqaZxtgdwwcnA6CQ8ehZQJy1c7?=
 =?us-ascii?Q?+k/GCQ3nJ+F7eVQz4L5h6mKqLuI5/usIajI7vX887ku3myOorNe7VaMkIWxy?=
 =?us-ascii?Q?KPeara+YpdkzgJDNv3O6o4hxN9GxSfYjWPCIEG70qrlZ/vpWvR+Aoll4tAl8?=
 =?us-ascii?Q?7Kaaz05rpHp1h0d0dfFx8oIXkkTPUWv1tq4qvgUzDqiLY2Cnp6KbNEsm7GRI?=
 =?us-ascii?Q?Vi0EndBaAP/HL+XApwy3Kn8Nk0n63yo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E70B9AEDE29A65479ABFA0105B9FD786@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	feBVfraDkJ0KdvAqAg9Y/pUmSAjCaGRPBk5wChwapMvApymeVV2sDagfFhiNmIzF2mciXDnmRVpUYHTfpOyxKraMURD+Eb5MUmD14vxoxKqR3o8vPx4zEH3YBEOvyi8MVuA+2iA7tJ9DHamggFT41JsBSC5jk8s6ON87tXzY2RHaSxxp9ncv5hsC+1GuBzMpG0nqEntzf99IN5bcZ6ZfAQWD4BIatYowIoDndhV9Ef9insOxGu6VLILBLrsrReESzUQng/AnHIz44IjlH/ZG1hAvKeypozWYQ622/1imiA79VAIkcRsaVoREF8ULIsNwN8d83Emf/ixAXEyU+YqwrA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2af73c5c-4c91-44df-c57b-08debc0541db
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 15:33:09.8080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sKMoR4t014upGNTwck1GAy+ylkECzEEgnCrQ4VpAtjk5XqV8ev8L534AAbYnJgW5Lnvz0ksSTCcTzH0u6vSCdv895Kl0mh4dvn2MA+9L9Y0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8660
X-Proofpoint-ORIG-GUID: gn16lBo5VLcrPqiU1MFia4aFGK5pEWNJ
X-Proofpoint-GUID: gn16lBo5VLcrPqiU1MFia4aFGK5pEWNJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE1NCBTYWx0ZWRfXybwwiyu6UwWW
 oAJ/pkzdSuGebgaEAahkclKqAUihkJN8vMl2sr9e6aXd1HLKIoN8MnoV7Pm5hN6seNcpxDFHIz4
 +dYjmg6y5lqZH9p5Vu6g0MkxfESzf8Hy0iRdLrV86xLZKPeECgeeH1SGUdww72188J+EjTXLXVB
 uoIzgopIWeju2uZ/C4bHmU+MDqmkBUnzOwU7Wohuzf5eedjQjONJhSnyUieRieRQCPZF2uHcdC7
 GkpLKGd9XNSlbF59LxYBll5uXu12SAQpKmHQz9G5awmX9WMIHGbPjuEVnPtnmNbLNbhuMG5Y5K0
 AMTJQzLYei7hjKMeNmbfMMFesCVMvRx0WVWBbLCph3JwZH4fLZu1BopNWUdjyGufPrkfk7U5I1E
 +h2iBxU9v3agD8OosH0K+QIge8+1rdEMZQLrKtFffkyVybpFh7a6id2n+4aQe6KyCWJHgpD7HHG
 7AJvK3D0EjzGvHZeAQA==
X-Authority-Analysis: v=2.4 cv=aNnAb79m c=1 sm=1 tr=0 ts=6a170eba cx=c_pps
 a=hCP4nzqXrcc9mCxPAALvyA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22 a=64Cc0HZtAAAA:8
 a=AJfA1h-VrdeEmcoCXs0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From 842f2adb6e4c64d285863f582d5c91862126e1fe Mon Sep 17 00:00:00 2001
From: Khushit Shah <khushit.shah@nutanix.com>
Date: Mon, 25 May 2026 17:52:40 +0530
Subject: [PATCH] target/arm/kvm: rebase -cpu host idregs to the EL2-off
 host view

When the host kernel supports nested virtualization, the scratch vCPU
used to seed cpu->isar for -cpu host is created with
KVM_ARM_VCPU_HAS_EL2. limit_nv_id_reg() then forces several ID
register fields on that scratch (e.g. ID_AA64MMFR4_EL1.NV_frac, parts
of ID_AA64DFR0_EL1) to values that match KVM's nested-virt emulation
rather than the raw host capability.

If the actual -cpu host vCPU is later created without EL2 (for example
under -machine virt,virtualization=3Doff) limit_nv_id_reg() does not run on
it. cpu->isar still intialized on top of the scratch vCPU with EL2. This is
obivously wrong and leads to error while writeback.

To solve this rebase the idregs fields of cpu->isar.idregs[]
on top of the scratch vCPU isar without EL2. If the field
in cpu->isar.idregs[] is unchanged, it get's set to the
scratch vCPU's field value without EL2.

Named models are unaffected: their cpu->isar is rebuilt by
arm_idregs_reset_to_defaults() which resets the idregs view.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
And then this.

There is also another way to do this, We can track which properties
are set by user/model and then try to enforce those on top of the new_isar.
This is more concrete than rebasing but did not get into that complexity
for v2. I think this is good enough for now.
---
 target/arm/kvm.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index c26ed485a3..26d20799b4 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2207,6 +2207,52 @@ bool kvm_arm_mte_supported(void)
     return kvm_check_extension(kvm_state, KVM_CAP_ARM_MTE);
 }
=20
+/*
+ * Rebase cpu->isar.idregs[] on top of new_isar->isar.
+ *
+ * For fields in cpu->isar.idregs[] that are same as initial_isar->isar, u=
pdate the
+ * field with the new_isar->isar values.
+ *
+ * cpu->isar.idregs[] is initialized with initial_isar->isar, CPU props
+ * changes fields values on top of that.
+ *
+ * But, initial_isar->isar always enables all the features that are suppor=
ted
+ * by host, -cpu host might not enable the same (for example, virtualizati=
on/has_el2)
+ * So the idregs[] view for the actual -cpu host vCPU differs from initial=
_isar->isar
+ * This function rebases cpu->isar.idregs[] on top of new_isar->isar.
+ */
+static void kvm_arm_rebase_host_idregs(ARMCPU *cpu,
+                                       const ARMISARegisters *new_isar,
+                                       const ARMISARegisters *initial_isar=
)
+{
+    for (int i =3D 0; i < NUM_ID_IDX; i++) {
+        ArmIdReg *idreg =3D &arm_idregs[i];
+
+        for (int j =3D 0; j < idreg->fields_count; j++) {
+            ArmIdRegField *field =3D &idreg->fields[j];
+            uint64_t idreg_val;
+            uint64_t initial_val;
+            uint64_t new_val;
+
+            arm_idreg_field_read(&cpu->isar, field->idx, &idreg_val);
+            arm_idreg_field_read(initial_isar, field->idx, &initial_val);
+            arm_idreg_field_read(new_isar, field->idx, &new_val);
+
+            if (idreg_val =3D=3D initial_val && new_val !=3D idreg_val) {
+                /* The cpu->isar.idregs[]'s field val is same as
+                 * ahcf->isar.idregs[]'s field val, which was used to
+                 * initialise it.
+                 * Hence, override it with the cpregs[] value.
+                 */
+                arm_idreg_field_write(cpu, field->idx, new_val, &error_abo=
rt);
+               =20
+                warn_report("KVM ID %s.%s value changed from 0x%016" PRIx6=
4 " to 0x%016" PRIx64,
+                            idreg->name,field->name, idreg_val, new_val);
+            }
+        }
+    }
+}
+
 QEMU_BUILD_BUG_ON(KVM_ARM64_SVE_VQ_MIN !=3D 1);
=20
 static int kvm_arm_sve_set_vls(ARMCPU *cpu)
@@ -2337,6 +2383,15 @@ int kvm_arch_init_vcpu(CPUState *cs)
                 arm_host_cpu_features[cpu->has_el2].isar.idregs[_i]);
     }
=20
+    /* For -cpu host/max, rebase the idregs[] on top of new_isar->isar */
+    if ((object_dynamic_cast(OBJECT(cpu), TYPE_ARM_HOST_CPU)
+        || object_dynamic_cast(OBJECT(cpu), TYPE_ARM_MAX_CPU))
+        && !cpu->has_el2=20
+        && kvm_arm_el2_supported()) {
+        /* scratch vCPU is created with EL2-enabled for -cpu host */
+        kvm_arm_rebase_host_idregs(cpu, kvm_arm_get_host_isar(false), kvm_=
arm_get_host_isar(true));
+    }
+
     /* validate the cpu->isar.idregs[] against the ahcf->isar.idregs[], se=
lect ahcf based on the cpu->has_el2 */
     if (!arm_idregs_validate_safe_rule(cpu, &arm_host_cpu_features[cpu->ha=
s_el2].isar, &err)) {
         error_report_err(err);
--=20
2.52.0

