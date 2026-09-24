Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDE046AA8B
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244137; cv=fail; b=UwkKRGX156ke+OYA+hi6vpXpglVzsMQ+o7xwzyMe1InI2KpfgU55slaOh4zMm0V5pO2wWxhRAQGnxIh6lr+CyP123BZMt01ovI8pdFecPB8NXTmqRXUVzl1ZiCNqM7bfZ30d4UA8soFiqem0jCxLMA6PGghiaijf+15b3soNAB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244137; c=relaxed/simple;
	bh=T9DigomHq33cBIKnOaLxWs3pX2AggHsxN+0nZYVMd3g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DF+ljRtQo7wV1KQd0AJVfGzIAOgmiqPMX+ZXduSmarfi/wFQ3J2j5cKlLdzhjbd0g2WtYM4Y77iUUCsAVI9X/HNeMWjCkwf0I0IOAcn7FpB1INTCSBtaC/QEcqUCzXlLJP37V60sWxPLsXmiknWGu8GyNf+o8Nqn0PjXHwgHoyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NUilPyF5; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gAYZKUjc; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NUilPyF5";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gAYZKUjc"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5cKO61007163;
	Thu, 24 Sep 2026 03:01:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=T9DigomHq33cBIKnOaLxWs3pX2AggHsxN+0nZYVMd
	3g=; b=NUilPyF5khVKk/gpRW9KHXzO+bpjtgyRYLz8OqMPEfnwxHtn0OwFjzjuj
	gRlI71cp+o2e+1o1HswErPW6rqcR5WPi9aVuGUtpYRbrs3rPLGg2w1cawEgxZIDr
	mn/t1oiEIIuLw4lC2DLl8ZsqkeNU0WpKdJmCF82mG2sfsPXG22/y3p1QexfKrV0s
	YZoRuieVJLdoQhtAintU93F+oxYACGc/MViBTVDlj2jXI5REVFqDWXNlAkxzLKWt
	mAWPk6RtyxGSjaLdIwfFMfmd/OzQPXJnAMSxm1gmRRNkeAGkZLp/o5NPhpx7OLzP
	V2WdMSXYTjovyi8mt7C0Zgr2QGEIQ==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020090.outbound.protection.outlook.com [52.101.193.90])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gvgpmaq0e-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 03:01:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JiwdunnVQoUKyyDZWAAJQnFW1WZC5BbcsJbpJtVsZj7Nk8axi06c9GMtJZ8WyjWbNLaetd/aboldk3HYHhgfCQqqQpCo9Lr7spGdduiHod1NgfZ5c05CCi50gOqAglmKSrZRbcpZsMo7ExliOPPaXmcGsunZN/Q81FAJ+YXCubHp1uDUKC7UFHGFCeO/25kjhmjaZjTVKGQEWi7ri3yUWlZw5do459onpPFOGmGxc3f9gRjqlc91OzXR7TMuQKwRRK+3mxsxVYg4S8O69coIScS+QPY3bD9PKGswcZCwVj3WLL4nwbX0yD9bWe0KD7vQP/QWjpKMexEYragkUcJckw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9DigomHq33cBIKnOaLxWs3pX2AggHsxN+0nZYVMd3g=;
 b=rkdDvGfmm1jDgHlzHW564pJ8bUleYzm0AUm3Gr2rxiOZ5z1zwtA3x+MupbdlWKHks60O1wHb3WqzazBNDjVf6i3Ozp6Vjzz64MOvtUxhzaKbq12/zEbHUFkciqKFNoyZk6omPDJOZuWEI2nqZprFWsdkhF7Gx7llW4lk29ygim5smvojGvE+VPq6RD6WDgu8Ag2Ipqazil42h1sKM+gMJCAUqwyGSdEMWUIE5529jaqTJFk+RO0g4lT0cI8UX00Vvd14ngcGDopPrBMP9pgitwVG7MD/cglC02IH3Vl1/DY3gDnp4sS4hIUty5gRkLOirMLUy+UR/UOw9ceYHOi9XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9DigomHq33cBIKnOaLxWs3pX2AggHsxN+0nZYVMd3g=;
 b=gAYZKUjcYTLet/DR+t4QaAR8ysARbFoe6Q5p5ea/6dP3I9+984sXT0l8MfYK+/fKxD+vcLCz+IyrCr32jzkHHsJWaAJ13ohPoZPFgnca+GTFu7OnuV6CpQwZytIP4xulXYn4XJ/oaNEY8/keK2ygksx5WhcQIoEK2r5vZpxDBK5MYTUYLZJkbzMst+/xjIFgKGG1gQvvGu3+fTNphgAqiFeoE+EnchaxRk1Qd61Qnv25b0gZGVNa37jiHyibScVMjS5RjuHYUjBLbYwcSmuN7GKgnGUmGWzEP1mvEGcpmYdYxl54+CttfxigrYZCogYl85J1Ga8FloAV9mBCpEtNpw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS4PR02MB11166.namprd02.prod.outlook.com (2603:10b6:8:2e9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 10:01:31 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 10:01:31 +0000
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
        "philmd@oss.qualcomm.com"
	<philmd@oss.qualcomm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com"
	<abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v9 04/26] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Topic: [PATCH v9 04/26] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Index: AQHdTAus+AsTPeXSC0GJMjMyKNu12w==
Date: Thu, 24 Sep 2026 10:01:31 +0000
Message-ID: <7EE7FE2F-E085-46B6-9AEF-746E97BB58ED@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-5-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-5-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS4PR02MB11166:EE_
x-ms-office365-filtering-correlation-id: 26d6fa9c-9e0f-4eb3-0147-08df1a22cf2b
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|4143699003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 ANZ8DMwPPCnIssAYoadDESINXTwSnePbwqN/iiLR4MDH5bZW6WkW+EcE09NiiEWUSORIyiweby5V+YGNm+kGC/XpbRPO5Al3IHAhSjZVmMQOXpvJ3zhwCinG1DK1xpKjtzUX0Z1YxSOWnu5VzvXilXkG6RpNAA7Ik1oDL6wJV2J3kyG+vSwxokFhu9C5Gdaoang3A/nyLWET+DuWzL1YYhojpvgWQJ3NUlnamMjPrIC2VU8OooYzPss8V391f699rEYl0X3cedLqTl0U4hQxIWzxVSusODpVgSWBW2gmQgMQ51AqwIMksUY3XD6viAUPIBicjHv7sSZvLfTm79rAUKwyE/9JUCvKRtdRDncluEcvE+EVRzv4N7ATbLQMfrhY9qv8xr+nGLChKVT1rP5nn0RHpun0WtNMOFQ0aTO4uPY/AQD4CeVMtviaKh9r3vC1h8Ysa/C+f/2zhEJ+LwDf7KmtK4h1aUfHd8RGQ2yS0EzuZBel1Ursul1GSk444PdxudRCkjlpOI4Eh+BQF2WteBEGugEkLV0RLQoq1w1PLeKr+8nPTQFtTPgR158x3VyOg0KBZGB8SEySGzQuNXhmLzyubafl4PfF6XpskqZ1/beNftxa+xLpkkxNeb08aLUrEIf/Qa+WwZB2K2hQjgIO5giKQGAmF6jBc8C8SuF/ecnPdpgLcXWlBmdYFt7xYyCePZuW2JeMAq1gBSB8EW9j2UOt2SrsZIS47ZGUZkTxyqg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?US9JS3QxZVR2UjZUY1ArbWRKNXUwY3J6a3VBOCtFb1NtVFVNSkUzTnV3SUU3?=
 =?utf-8?B?bVhycGRNTVczUUJ3YmNUOTA3UXFNeFNxQm95cEhtV3FlaFBLU0RWYW56YWpu?=
 =?utf-8?B?U3M2LzExZjBGZlpmT1U5UW80R0tlY0IzdjB5RFlLdCt6Ylp5dy9rZWE3UkZy?=
 =?utf-8?B?TmpvUVdQRVIzcmtZRkNCNFcyQ2hJdEFkRHRsT3NHNDdYQ3FxVVNvWG9OdTVw?=
 =?utf-8?B?OFAyaDNxRWZpcjZ4TkplUU5PWEdSWkxCRWR0WDRJUHdOMzYzUS9Bb0k1NEd3?=
 =?utf-8?B?QjFJWFFyZU9WK0NacUhFOU4vYUFiTjluN2xhd3l3SE1IdVkwbGpyZ1VMQjVX?=
 =?utf-8?B?Z3JXL2xvbzBIVHlpTXM5dkNCVk01ckU0SXlyQzRKTFNoWVpOWEpENFh5WWox?=
 =?utf-8?B?bE1QVkxvaWJ4ZTV0dUwrVGgvaFhLOE4vRWlZVUloZFpBRE9WU1dPMmlRQ1Bn?=
 =?utf-8?B?UlB5WVVCWmF4aHZvSVlwT3lNS3MyN1JobDdqdFBYdmh6enBYckNHK0IxV2xm?=
 =?utf-8?B?Lyt1SnMyTnFBallSZmp4ektkOU9XSlhRb0t0SDBzalVBOW5Cc0ZkZ0tzZzNL?=
 =?utf-8?B?bEdVS0hOa0dQY2RBdkM2UUxEUHV5bHRpVU9PUnpoekpXS3c2ZWUzbEVZNzR3?=
 =?utf-8?B?OTg3WkQrM1RXVjhVVWs4TmVod0NjdlBzTmRXWjJ5MDR2N2dMZGoxRDFvanJi?=
 =?utf-8?B?T3g0bDU1UFRhSU9ValVrVE5BUnoyZi9MSGEzb0RWN3ZkMjVuc0lidzgvMG9E?=
 =?utf-8?B?QzlYODVMT1hFVTlUeC81emRNZm9xSWtUM1RaU0xEWnB3aVdhSTdBbktKK3N2?=
 =?utf-8?B?Q0ZzK1h5aG5za0NoNEw1dzRoR2M4bkRBeTdlZ01Nck1tMGFtWnJra2pSNEYy?=
 =?utf-8?B?MFJDN3lBVUpSd2tWZVF6cVY1c1B4TmE3eW1mR3llL2ZpZkJnM20wVDg1TlpJ?=
 =?utf-8?B?eUphUzlMK0V6bFVxRElycHpwcDE5eUc5WTdwKzhQS09QRk9yeEVrRkZFamhL?=
 =?utf-8?B?WTVuWlB2akhLbWhoS2JvRlhlUWNOSnFRMlhrSStkOXMrQUpMOXBCQnFuVm40?=
 =?utf-8?B?UGFvZ1F0OFFxTHVHZFNtOExLY1liUG1jNzRKSkNzeWlMN1oyTjUwNzRENVpz?=
 =?utf-8?B?b1k4ODRVQXJQWmpIL3pTR0VaS0oraURWQmVWN0oyTytyVmZmT09mSS9aVVM4?=
 =?utf-8?B?OUh0Qy9OVnV4TlJHVTZQT0VpT2pQUDFMUGNBQnJ0Y2J5SnJKWlFlR1hrQjNI?=
 =?utf-8?B?YjRaNXF3WnZRZGcvRUJjbUZVYTVjOGx2M2VOUEJzOW1UYjM2SXVodURlL1p0?=
 =?utf-8?B?bG16eDZNOWlhQWM0Qnl2VDlVTnVmdW5Pa2UvTUJKVkphaDkyMkxYNDN5ZWNE?=
 =?utf-8?B?TjliVTdRVHlLK2tnS0RVSktvNGNNTVRvOXY1NndyWjZGdEQvbUtBVXdyRlM3?=
 =?utf-8?B?clBkQzI3S2hWNzRlNHJ5L3NrTngyb01FOE5MNElrOVBwc2c2bVJ0YWJNMW91?=
 =?utf-8?B?ZkxBZHFKQWZzMmNxckl3Z2U0amQrSzRYWkUyZU1EbksxMmJ5L2RKd3hwWGkv?=
 =?utf-8?B?blVRVUdWeXRpbWpoWnd4SmI3ZGJIVVNpaS9xWW9hMW50MEo2UkIxYkVxVFA0?=
 =?utf-8?B?eEIzUzZuRzhXVVh2MDc0ck1HUGdjRmdhRE5hZjF0ZjNOUUdZckFoN1pLcDdy?=
 =?utf-8?B?eEljVWk3R0ltZHg2cnZzM2p5d1UvandzL2hsam9pODYrRlVoQ0w2UnJIdUQ5?=
 =?utf-8?B?UTNqSS9zcWtmUXhzT2hQTTlGRldWNS9MV2YzSWQ5SzhtNStZRURYY01HcFhy?=
 =?utf-8?B?MlhZMjVtT2owR1JsamxiSE9MR091K1lnWmNZRXVuZjFMWGcxMi9pVkVTYjJ1?=
 =?utf-8?B?dWVRYWtHUUNGWVNtMFJzWGl3Wlk1TVZsZzhaVmluMEIrRnhyR05lTFZwcVFY?=
 =?utf-8?B?N0t6Z0c4RlJaZVJndWhoZUVnaEtqUTVtNHpvNko0Sm04b3FJMzc2b1BvNHVK?=
 =?utf-8?B?SEc1QStveVBjZUgrdGVlbDFqRkVmUml4b3h5Qk8xaDNKTGxuajZ1dVF5cDhL?=
 =?utf-8?B?QkxrK1REdDFEYXVPV284RnV6UlRRa0xIbU1KU1llMlBHZFVFenZSYkdTK2lQ?=
 =?utf-8?B?Ykc3cFk1SE9Fb2tDK3ZQUHlQY21kcU1ZZkIzSFRCcUxDR24reUw1amV6VFdX?=
 =?utf-8?B?b1QwU3p4NzBNVDVwUGpTNzlyN2Npcit4b09tVURLNFY2bFVjV245M3ZhcDNG?=
 =?utf-8?B?MmdvdGQzM3BLa1pSenlFUFppWlM3b1lsRHc2WWV5Nm9TSEpGdE1TRitkaDBm?=
 =?utf-8?B?Qnc3ZittWmlTUkwxN1I4bjNKaGlTTkpUSVZNc1ZQWnZvcFc2MnROV0dveUw1?=
 =?utf-8?Q?c2SZt/0jTTA5INQo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8BDC23F659FB44EA7415598830E76E8@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	O1+eqOLIELA9Gadfk+6V0LII1JHt7k9wP9RqW6SH+dPbyaNK7pNrSm5tQjxUM8dmlTJ/4VFwQBBWUrMWx3luNGDAhf7ejKic/wxHohX99ipy2RdS/IkqR22y8ZRGsC/jnISd+Am5nGBlH7I3T5BfOjMsG9hrU1ejRgzjK4lhzxCFCpie8IoLtX26WAdpDUhZ7GMQdtTRnNgW37l0SdD+vH0GfOQfkUUkRBLgV4jescCVryFMXoOBjy4HRGrP9kJMbVdL5YTGwle79CSUiVyuyK3cDEYuyKVgfAf8N4FQl/AZ0rSRvwimTgwIqdE/ongK0+iNoMhizudqQEM59pNdbQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26d6fa9c-9e0f-4eb3-0147-08df1a22cf2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2026 10:01:31.6752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 763O0Zb8b4WPCk2ZRhUo5laMu9gZohS+CpfY0Cg0gDSrT1vhVwN2KRWRse9Ue/KIY51KbE2LvGcMEnr5Pv3HdQ46A+6a2Q+p7BTukuhxWtI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR02MB11166
X-Proofpoint-GUID: blTbHBFi9qKsAzJt-12xJq-psZwC4Vm0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA0MSBTYWx0ZWRfX+hnXMgIKrbx1
 9pJCep+5HXG9SyJNvGjAt8ArLglVU+QEFggu2yMWG4LzTlR9kjm5I4dpAyKaNPKc01f98bsGbx8
 pF5+EkpDfA7SnH1p4OxiLIP0gJeQNMwmh1V9THdyDXUMNZM2Qn+KK/wl7ehftZkaTPiquWl24IN
 8a2kOoclW2XdEP1n+uZBfm1iumhI8+rVxypfB19vB/T2/o/oyEcBntgZECJ0m69LmN8hJUxpFMm
 PcTV6JiJD6bJIf9DsKFycc0EoKH9jO+YVPEbH1KVnQqEro4euF+zHfqrQLPfM9IkPBJ4zLOYCiP
 EAdhUkKuGqkuOxeupt9sOs5JmkdkWiayzfBqi3Z2OBBreTTAqWUTxyWhFUTs4GMVmoO6u/4npXP
 3taChLhh4E6MgUD5zM5hrW8UHPXLpxHlWwjPKumy1oe9njcrLutmT4af2HctpJglwIVQm09EJD4
 q8Zcti0XkaBmbU/BpuA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA0MSBTYWx0ZWRfX+FoCpGNiu3x/
 nm8TxH07kT/PcMQQdAQV6gTx6Cv8kJwk1H7YI5g1Hr1hL/l0fVroFEnRpV8zek23sO4RIiAF4LJ
 zQhVhUZlTENTMIdHEhTFkocSyxpMuHQ=
X-Proofpoint-ORIG-GUID: blTbHBFi9qKsAzJt-12xJq-psZwC4Vm0
X-Authority-Analysis: v=2.4 cv=VJVIDNPX c=1 sm=1 tr=0 ts=6ab4f4fe cx=c_pps
 a=hTY5Tzxx0J6bc07E+BihHw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=IeoBwqUTUBJDZVoYmu0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQpKdXN0IGZldyBuaXRzLg0KDQo+IE9uIDE2IFNlcCAyMDI2LCBhdCA4OjE14oCvUE0sIEVyaWMg
QXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwN
Cj4gIENBVVRJT046IEV4dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IElu
dHJvZHVjZSBhbiBpbmZyYXN0cnVjdHVyZSB0byBzdG9yZSB0aGUgZGVmaW5pdGlvbiBvZiBhbGwg
SUQgcmVnczoNCj4gVGhpcyBpbmNsdWRlIHRoZWlyIG5hbWUsIGluZGV4IGFuZCBhcnJheSBvZiBu
YW1lZCBmaWVsZHMuDQrigKYsIGFuZCBlbnVtIHZhbHVlcyBpZiBhbnkuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IENvcm5lbGlhIEh1Y2sgPGNvaHVja0ByZWRoYXQuY29tPg0KPiBDby1hdXRob3JlZC1ieTog
S2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPg0KPiANCj4gLS0tDQo+IHY3
IC0+IHY4Og0KPiAtIHJlbW92ZSB0eXBlZGVmIHN0cnVjdCBBcm1JZFJlZ0FyY2hWYWwNCj4gDQo+
IHY1IC0+IHY2Og0KPiAtIGFkZCBBcm1JZFJlZ0FyY2hWYWwNCj4gLS0tDQo+IHRhcmdldC9hcm0v
Y3B1LWlkcmVncy5oIHwgMzYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+
IDEgZmlsZSBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspDQo+IGNyZWF0ZSBtb2RlIDEwMDY0NCB0
YXJnZXQvYXJtL2NwdS1pZHJlZ3MuaA0KPiANCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0vY3B1
LWlkcmVncy5oIGIvdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmgNCj4gbmV3IGZpbGUgbW9kZSAxMDA2
NDQNCj4gaW5kZXggMDAwMDAwMDAwMC4uOThjN2E3NTE4Zg0KPiAtLS0gL2Rldi9udWxsDQo+ICsr
KyBiL3RhcmdldC9hcm0vY3B1LWlkcmVncy5oDQo+IEBAIC0wLDAgKzEsMzYgQEANCj4gKy8qDQo+
ICsgKiBoYW5kbGUgSUQgcmVnaXN0ZXJzIGFuZCB0aGVpciBmaWVsZHMNCk1heWJlOiBJRCByZWdp
c3RlcnMgYW5kIHRoZWlyIGZpZWxkIGRlZmluaXRpb25zPyBPciB0aGlzIGlzIGZpbmUgYWxzby4N
Cg0KV2FybSBSZWdhcmRzLA0KS2h1c2hpdA0KPiArICoNCj4gKyAqIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiBHUEwtMi4wLW9yLWxhdGVyDQo+ICsgKi8NCj4gKyNpZm5kZWYgVEFSR0VUX0FSTV9D
UFVfSURSRUdTX0gNCj4gKyNkZWZpbmUgVEFSR0VUX0FSTV9DUFVfSURSRUdTX0gNCj4gKw0KPiAr
I2luY2x1ZGUgInFlbXUvb3NkZXAuaCINCj4gKyNpbmNsdWRlICJxZW11L2Vycm9yLXJlcG9ydC5o
Ig0KPiArI2luY2x1ZGUgImNwdS5oIg0KPiArI2luY2x1ZGUgImNwdS1zeXNyZWdzLmgiDQo+ICsN
Cj4gK3R5cGVkZWYgc3RydWN0IEFSTTY0U3lzUmVnRmllbGQgew0KPiArICAgIGNvbnN0IGNoYXIg
Km5hbWU7IC8qIG5hbWUgb2YgdGhlIGZpZWxkLCBmb3IgaW5zdGFuY2UgQ1RSX0VMMF9JREMgKi8N
Cj4gKyAgICBBUk1JRFJlZ2lzdGVySWR4IGluZGV4OyAvKiBwYXJlbnQgcmVnaXN0ZXIsIGUuZy4g
Q1RSX0VMMF9JRFggKi8NCj4gKyAgICBpbnQgc2hpZnQ7IC8qIGxzYiBvZiB0aGUgZmllbGQgaW4g
dGhlIHJlZ2lzdGVyICovDQo+ICsgICAgaW50IGxlbmd0aDsgLyogaGlnaGVzdCBiaXQgbnVtYmVy
ICovDQo+ICsgICAgdWludDY0X3QgKmFyY2hfdmFsczsNCj4gKyAgICB1aW50MzJfdCBhcmNoX3Zh
bHNfY291bnQ7DQo+ICt9IEFSTTY0U3lzUmVnRmllbGQ7DQo+ICsNCj4gK3R5cGVkZWYgc3RydWN0
IEFSTTY0U3lzUmVnIHsNCj4gKyAgICBjb25zdCBjaGFyICpuYW1lOyAgIC8qIG5hbWUgb2YgdGhl
IHN5c3JlZywgZm9yIGluc3RhbmNlIENUUl9FTDAgKi8NCj4gKyAgICBBUk1JRFJlZ2lzdGVySWR4
IGluZGV4OyAvKiByZWdpc3RlciBpbmRleCwgZS5nLiBDVFJfRUwwX0lEWCAqLw0KPiArICAgIHN0
cnVjdCBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZHM7DQo+ICsgICAgdWludDMyX3QgZmllbGRzX2Nv
dW50Ow0KPiArICAgIHVpbnQ2NF90IHdyaXRhYmxlX21hc2s7DQo+ICt9IEFSTTY0U3lzUmVnOw0K
PiArDQo+ICsvKg0KPiArICogTGlzdCBvZiBleHBvc2VkIElEIHJlZ3MgKGF1dG9tYXRpY2FsbHkg
cG9wdWxhdGVkIGZyb20gQUFSQ0hNUlMgUmVnaXN0ZXJzLmpzb24pDQo+ICsgKi8NCj4gK2V4dGVy
biBBUk02NFN5c1JlZyBhcm02NF9pZF9yZWdzW05VTV9JRF9JRFhdOw0KPiArDQo+ICsjZW5kaWYN
Cj4gLS0gDQo+IDIuNTMuMA0KPiANCg0K
