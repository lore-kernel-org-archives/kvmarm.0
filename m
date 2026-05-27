Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CBB42847C
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779894200; cv=fail; b=PxZl5/HeTcbfJknldS6jzPKofqgbbwSo7daUW4TMW8hFiZBhAiRPQd1JL3Rh4rF4HDeIEEo4kBE9VR613kzAvicjm620BDSrtYRk8BHHZ8lSwEpoPx3CbwKiJ/tYfZRQMZ2pduQTYnsdw3dIMaSJOHkuzzY1R7cQzvMvcWvVZpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779894200; c=relaxed/simple;
	bh=X+Liqe28qT9CUyT/L9wvAmAI6CvdeCzm0XfTCwfwupk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OvtWS/+Zd70rm03CK9d2hcCHPZyOGJhUMkkbFIpUtX3VM2hFoP0MdPa3dgY+RK4zdw6p6t6blYheFOooJxWhvty2rWdXKxcaQVYjbl2UXR6SS9XOabc2T7KkTRaluBycd+12nDhIP32qhQceqKHywSfZfSmmQr/ZjZJfd83pOLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=h+5E+eUc; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=X9GDu62B; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="h+5E+eUc";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="X9GDu62B"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCs3Kr2619687;
	Wed, 27 May 2026 08:02:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=X+Liqe28qT9CUyT/L9wvAmAI6CvdeCzm0XfTCwfwu
	pk=; b=h+5E+eUcerdWkVBvkRpP0LTgytojnMAwK0FHM7nSFFFsURH/ll8v4bzkp
	uCzUKbro/tRhrms70YoWp/7Kz++qtkDe0P3e026VJrDZ3YE0McV1MiXoLROhE64a
	BhPKy+nqyCRFC7r4Of4mMSjAMDle0Xyu/GmJuwy2rayeQufAdoUsK5kvLFa2Dtuy
	956fxWa2wLPz6M8sDG8XZ9bt2on3R3a8I6pLWqR7wKQ5IZOWvoRYxuITatxoHf3o
	d5N7m3nF7Q8cjIHKyGbPwA+xaJlOj/PxKj7LgzF+93F8OJj+a2hdExlovcSdodfh
	9WNfx1ip8hmwLiBJUeXK5V7Z9rriQ==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021095.outbound.protection.outlook.com [40.93.194.95])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4edhy3t9vh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 08:02:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vhGJfA0ym5IWXe9rWb0tt3qOv5mEbcRtHov0ohrvPVuoOOKkozN2E8/l2DRKLlrCOTPm/DLRLzWvmFcb6HqszKFYHEC5bkPTWZgPL6ispeD2ktAgeDW/hfZjCXOfDw4zfmz9XrtQ7/hLxSvFp+4RkEC9d7EnlwW+0rMZGkOV+kFlCe0rrzK/yNCO5I5gpBDYHd+Hjn6OqNemHjxy24oFTpxRP3NGtuVDmUbhbweNaDJLcleZr8GW9ePh04Np8QTmXu6F8S0SlO9sV6z45CHPytIHLV020m1WrEQZzw09KDoHLGqavePSvH6OS3AmDIYvo/u4xXfwqD1RQITSolhGBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+Liqe28qT9CUyT/L9wvAmAI6CvdeCzm0XfTCwfwupk=;
 b=MBOgRYhUk7s6Zc4DYHJpYU+JzXjOCUidIwDGNMiqPedn/9vaU2O6uGwANLjTUaxcHC/wzxgni6qGhWMxfIsnsPzEBizcr4LLnNFKAcPy6Mx/T9hVY0pww33zP9tGxMGydDwuJ8DiYTha+KATctEqlGbJw25YONI4ttr5XtWQjGPpccA/Q2ZX3fq+bmodIdgxDxNiHY5rmpsffs2E1HdMYIhEy3M6mS+lzAKvxsFU5jLGAKXjFp3gNEiKlFgl29Nhc0AnvmY40+po2qgd019bYaMNdog3aeR1VNJbk1AvmIxCj934c4FYwfjQRKWkvn0rfR+VeGj3jhagXN6K7DUR+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+Liqe28qT9CUyT/L9wvAmAI6CvdeCzm0XfTCwfwupk=;
 b=X9GDu62B0XpQjZgftWVzJMQcf9sn0Ar2vE/BRil02oC2MYqRXQHfq+skApcg19SPKYECGXd94/gKcXGU1gf3blX64pFIMi8yZOAjGRPWeb51Xem7AukMCxJ28zoImhuTofoNWVkp9oMIo3frz3kYZCEA9hAehOBIodhGrG42JQSACnIXL86p05ekk+HCG1P5klKR3HF0f8tzWu2G+yL9hS09huzg/i5n1hb3cfA4Bps9XM6ILxzeke3L/JRs6UZFMRf54P9yN42NTpSEXkpqwVczN8Tau4zkJVMZ2vMMi/e09c0+cdLXx2M8czKRoor6BHBYmkzoWmERKx0fqJk/gQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH2PR02MB6507.namprd02.prod.outlook.com (2603:10b6:610:67::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 15:02:51 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 15:02:51 +0000
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
Subject: Re: [PATCH v5 11/18] arm/kvm: Initialize all writable ID registers
 from host
Thread-Topic: [PATCH v5 11/18] arm/kvm: Initialize all writable ID registers
 from host
Thread-Index: AQHc55Ox2kQFuoj5L0ivQAn7M78eg7YiBJEA
Date: Wed, 27 May 2026 15:02:50 +0000
Message-ID: <7CF06975-A0CB-43CD-9B3D-FF74DBF55AB9@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-12-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-12-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH2PR02MB6507:EE_
x-ms-office365-filtering-correlation-id: b58ed9dd-2b69-4e37-a82f-08debc0105ac
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|3023799007|22082099003|18002099003|6133799003|56012099006|4143699003;
x-microsoft-antispam-message-info:
 bkU98Ufgri+Wfrw6Mx1IbApXwpO3qhxITBRJF6Y7ujLnwVThU02IsSLZxbVXQJucCT74luXWKfWLyeyGol6IAuKiz6UWaXcsjQcfQJtBTm7l9efXxJUsQGRzpZzVRoxyqtrulB313aR39eWsdAmquyMAJ4hU8qCPdUZXgkZMLjudBEtFSqY2KDIdeP1BWSUvXNkUEBPB3+cfYCaNPnIEELtpxSWjt9ZTNmrP7jgE0TCR0/It9+XG+PIPrJ4cJcMUf4nqMNffimQII+6JIBqpV0L43OFT2Ouzy0pAizctX54BpY1HG2QKeRsjUg1jnvdAqTEO93m12iCab4HKgmZ3SEKzdMEDb6inxP8kSIggDqL9nBCqIZgrp1utNnwalRfe1Idn9GmfjZjL4f5OVjzqSRorP4plHNeCHFmicK5OKgXRH2wawCjYyxxUUQT1s1g+aX+wuk+3iEi56ozMsDyZ+GvoFh8pSdLlonIiTUpY2c2CJ1wl0Wpv760SG2Taqeaa+Rg1ck9DgqVJnDt33STLHe9JWFPKRQPqx9ui5BsfwcgsPUVuesuYf7zgSN+T1e9MspIod6hA0YYZBuDjb5BE+XjK8T1OWUXzXiKvYz3d+Ovc7zdf1UKX6Oa7EiNDB7pHt8PTU7DwK89dmkTLGJFnfgfX58hA7s4IRMyNinp/Nd1snYwyr5Mv3ZnhdTXzljEWp0JASxwWLNbf5PHy5OwebgFw7k4U7M7oZUyGqsKQtj8p4cKm7047iRZ6oNUUrw7e
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(3023799007)(22082099003)(18002099003)(6133799003)(56012099006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Ui9iUEpIOXdmNmF3Wms2dE1GRnBSNjFoTFFRTVhENHNWVTBqRkNKMERjRmpO?=
 =?utf-8?B?V2E4REpuYjc3N3dRV0hBVlJtbnF0MnNiM1RaeG1tVTVrUExpUVNnaGtSNFk2?=
 =?utf-8?B?OWM3RFNLbjY3UG9HVHVvRXZodFJTWlRocVBYczNmQnZKT2V6WWN2SC9VSEpM?=
 =?utf-8?B?OXd4V2NYUG5LamFIcXgzZ3ZleEJ3b3hicnZ0Q2JFMGtEWGpOTldWc2hiNnc0?=
 =?utf-8?B?Wlo3Smdta283S0s1NzkzSXY1Q3R5Zm5iQ2FyMnFqZnprSWh5OFczR1kraXMy?=
 =?utf-8?B?Yy9KRzZaWVVkWVZUSHpLUzJhelN4STd0UzNic0hBOVV0ZDEwU2RDbWVwblhP?=
 =?utf-8?B?R1NFWlcwbC94MzhKbllkbmV0b1dpSG9NWnlyWVM2WjVIalJpQzgrSzlDWXZl?=
 =?utf-8?B?Q0o0bU5EaUluQ2dxY1JQNG1CVHJOOEJweG56QVZSSkJKNHI0N1FvUmEyTGdw?=
 =?utf-8?B?em9yakNic1FxR2NFMUtEalN1TEtOcEVVa2xnYjNKWG1iWHlMVUtVSSswdWlt?=
 =?utf-8?B?Q1ZORUQxNFh5U0ZVQ1JHQWxQdGJkd1NsZTV4NUFMS2JhQmlYREVGS1pOWjVp?=
 =?utf-8?B?a2JhQWI2TDZ4TmpLTjdBNjNHektoWnpLbkZiZFhROG1YZ2Jna0k1R0s5SUxI?=
 =?utf-8?B?UVppQzh1SFlDYThXa3dSQndZSEJoc0R2cEJTS1FoOWI2ZHdxcHBnSGsvdmF3?=
 =?utf-8?B?Y1Y5SlFEQlNEOWRZK2dmTXBMcWltM011VUl5MHZKa2xHNHl6SUg2TGVXeDZm?=
 =?utf-8?B?WnRNblpuemMzTy9LR3BFWFlWTHhTNVpHMFJlQXFETGxNNktNVWl0WW4vMVlG?=
 =?utf-8?B?OUxRa3ZueEM1MEJ3NUZpbDBMNjlUQVRtZFp3Q2N2U2dNRTdyN3dLQVRZQnht?=
 =?utf-8?B?aEdiSnNXZDY2OEZ1OGR3RFFHZXFDRTBUL3FEcDdPZENqUmlTQVZ3ZTVxRGpV?=
 =?utf-8?B?OEtXUEtINzJsSEhWakI2aUlObFVEYVJHeXY1VFYxME5Oc01vR01vZ3JFT25Y?=
 =?utf-8?B?eWxTdDU0Q0dJUnY3V1lBbk9hV3V0L1VlWmZVVGY1RkJ6VzVyejduaE1nWE1j?=
 =?utf-8?B?VkZnMWxNcEVINlVlejM2YnpXOHFXR0pISUdJVElnNWlPUG5aT0s3UFd1dlM4?=
 =?utf-8?B?ZzNUbm5BL3JhREdKRXR3ckM1eW16K21LNzcxVlhSdURBY2V0VXFDdTFidTAx?=
 =?utf-8?B?cythOUljM1lTREN4Y2txOVc4MXpYT1V3eHI1bDdXTm8xb3QwMkc5aC8rVXhr?=
 =?utf-8?B?NTVrM3o3TzlCclhsNVhmQnR6UjhBRHVTWTJ3SmJGZkdHN1BvcFVJc1pTSnBE?=
 =?utf-8?B?U1RUSnNuQnhyZVZSS3pSMlA5bkQ5SlQrTHlKSWg2TWhLOEE3M0ZPQ2NQQ1Y5?=
 =?utf-8?B?SUk0U1ZKaWNranJCTVBodEEwUStvL1pXSGQrd1VOTWFBakNNbElaQzZyRksv?=
 =?utf-8?B?bWt0cjJwNlpmM0pqdXN3ajZ6NUpHcGFHWFU2OUJXUm1BZWh6alE4L3dpR0xz?=
 =?utf-8?B?OCtYeWRGVTdTb1RtQWlOWWVrR2pOSGFELzMwa2tPb0E1NzQ2UkdzYWVhZnVj?=
 =?utf-8?B?L1U4ck9tWTlURFU2UUNSczdXMnJaOWQ1Kzd6U0tJNFc1TjZiOTI3VkhGNEVZ?=
 =?utf-8?B?UTlyT2ptQWpjM3ByY0MvOFkwQzV3TW43ODFCTWRSQ3gyYlBNWkVjMUVDL25B?=
 =?utf-8?B?QzNVU2h0MDEvM000ZUsxcVRweUlkY2RyYUFQb3R1cU53ekNmdDFGODA2VXFY?=
 =?utf-8?B?M08wWGRER3ZwTWtRQVBhSHRVTjhMbi8zUGNyRi9iaitUaXpHdkt5Y2JJazJG?=
 =?utf-8?B?eWxSNFFpNWs2Qi9NL3NkRzFKRGR0M2U2N0xLRkx6QzhhSDBrbjNUWVo3c2ln?=
 =?utf-8?B?OVEvMnViMG9NaFNNcHVCZEQ4RnorZ3hIc25aS0tDUm8xYjd5MHBxTEovWTEx?=
 =?utf-8?B?Qlk4c1hOazhKN1RPUHpSZkhQTjR0V0dIVVFBZ0Vwa3NBNm5jK1JVRnRPWW1J?=
 =?utf-8?B?bzBMYjQ2OFplSXAxTlhjR0dKTk0yYjVvcVRZVmJmUnk3T3BCY0piS0czb0Y1?=
 =?utf-8?B?dkkwRllFbFI5S0J3cnpGK3ZySnBjdGJGam43NzJWb01KTEYwYi9LSVNlODdn?=
 =?utf-8?B?eEZQQlBPQ2tscFFsWHo4NDZxY0J4Um4ydTNoeEI3bklUZGdlVm1HVDlGR0NY?=
 =?utf-8?B?TEZpZVVKa2o2eThDaDljaWVrWERYWGQrd09HZUlTN1NXbWV4YUpvWEYvS3J1?=
 =?utf-8?B?Mi9SaG9EKzBGVFJiUFp5M2VtaHEvZEE0SXZ1RXZFc0JXYTRRWFNlRlhGNGFz?=
 =?utf-8?B?cHRQR1JIdkowQ1NZdHY5K1pPdmhCZjI3UEpEam9VSEVBaWw3dWdoNWV2Z1Fv?=
 =?utf-8?Q?xWaIA2Nvth/9qC30=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <450906ED39DA774396550B20239A3F6C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	rvdE3bVXyQ4h5NFkDJtXi5qYuXpi59gmDSBfAtWDEKWmVyLYQVNeOXu9hCnURrROf2tIF88H6MrFwBMY3cbJTKV1eW1n4uEuxNqQK+C/EXMVpjBIm6JoHlmcKzkTdU4mEP+8hcIDZUkpEzfJ20z+OXjgmYw7FZMT5/gd/XUZ9ivH6X9kuv/XBUZAv5x9s0WjvdlRbItJ0o8Te9yF9axoMAf/e9oypvbv4j9Rt+bwGQxwmsLsOJfHssyiZWnuGEYZZictYxDqe/qdvJLX1LI/yNn9iz8pnFm4Oa/xXrjRIU+X5j3Hp6dCE8SIm8JnO329w5sgz0YZt5a2R3ga6Kmn9w==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b58ed9dd-2b69-4e37-a82f-08debc0105ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 15:02:50.8809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Of7/UeD5lcSkrQIdaGgnK5aEX10DTCGiMggxY/YKmSMz5yCu1LfaY6kz/lSMQBBzIHQnFx0gHBlShzgsLHuqCFVfsx5yarcKqDKGEqmlxeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6507
X-Proofpoint-ORIG-GUID: RFRgasd_DCzGbrNIoV45FCd7xlIJz8zu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE0OCBTYWx0ZWRfX6uzET3O+twE6
 5cpt83HrtncouuwmNQqhaVXqsMwyzDcSRrWIMIpOkBR+uen9d38Qn2VsLYQxIUpqDXpGxMPoIKO
 NFnPaKMXBH5pJqLAflT2ULgDrTxudO3TYSlUNkhnoz81SVSiVbaM5QaB8mW8E/IJm2xAjPRCjBk
 KGNbtRKvH9H3KiKTh2Fv7RbrkSRXexj+YLgYosi5cE/p6UKIpqhOYFjYFEQpK+9hkqCZdT2lFjN
 ix+afvjzkIg5aKbj8K7Khkw6l3SfZxp5BTi2ezEF1OIdBXReOFp7kDm06jNHt5LSL4fFEqPDrFR
 mIJnSNDEXAjiQtpkiwNPywlWlQUZ7RwWiM/JxtgOZlsRPilrurFfhzD8CYQZ9Zu+VdobN/3+9fZ
 vsA3qaGugpYvPjlIwbKK0lV3fiGiF4MjoDoFYa5Oc1K2XLkEYPSmAwxmvG8ElUXWadFFJ36KBQM
 M7+bkLhY6thN808Nx2Q==
X-Proofpoint-GUID: RFRgasd_DCzGbrNIoV45FCd7xlIJz8zu
X-Authority-Analysis: v=2.4 cv=f7l4wuyM c=1 sm=1 tr=0 ts=6a17079e cx=c_pps
 a=KKEi/m33+wCRTXJOHCufbA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=BCQ71Y6UH9PdGioOhYkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTkgTWF5IDIwMjYsIGF0IDY6NTfigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gV2Ugd2FudCB0byBhbGxvdyBv
dmVyd3JpdGluZyB3cml0YWJsZSBmaWVsZHMgb2Ygc29tZSBJRCByZWdpc3RlcnMuDQo+IEhvd2V2
ZXIgY3VycmVudGx5IHNvbWUgb2YgdGhlbSBhcmUgbmV2ZXIgdG91Y2hlZCwgbmVpdGhlciByZWFk
IG5vcg0KPiB3LiBFeGFtcGxlcyBhcmUgQ0xJRFJfRUwxLCBDVFJfRUwwLCBSRVZJRFJfRUwxLCBN
SURSX0VMMS4NCj4gDQo+IFdlIHdhbnQgdG8gaW5pdGlhbGl6ZSB0aGVtIGZyb20gdGhlIGhvc3Qg
dmFsdWUsIGFsbG93IG92ZXJ3cml0ZQ0KPiBhbmQgd3JpdGUgYmFjayBmb3Iga3ZtIGFmdGVyd2Fy
ZHMuIFRoaXMgcGF0Y2ggaW1wbGVtZW50cyB0aGUNCj4gaW5pdGlhbGl6YXRpb24uDQo+IA0KPiBJ
bnRyb2R1Y2UgYSBuZXcgZ2V0X2hvc3RfY3B1X2lkcmVncygpIGhlbHBlciB0aGF0IGdldHMgdGhl
IGhvc3QNCj4gdmFsdWVzIGZvciBhbGwgd3JpdGFibGUgSUQgcmVncyBhbmQgc3RvcmUgdGhlbSBp
biBpc2FyLmlkcmVnc1tdLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5h
dWdlckByZWRoYXQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBDb3JuZWxpYSBIdWNrIDxjb2h1Y2tA
cmVkaGF0LmNvbT4NCj4gDQo+IC0tLQ0KPiAtLS0NCj4gdGFyZ2V0L2FybS9rdm0uYyAgICAgICAg
fCA3MiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiB0YXJnZXQv
YXJtL3RyYWNlLWV2ZW50cyB8ICAxICsNCj4gMiBmaWxlcyBjaGFuZ2VkLCA3MSBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0va3ZtLmMg
Yi90YXJnZXQvYXJtL2t2bS5jDQo+IGluZGV4IDRhZGZkMjAwNTAuLjkyMjE5ZWU2MmUgMTAwNjQ0
DQo+IC0tLSBhL3RhcmdldC9hcm0va3ZtLmMNCj4gKysrIGIvdGFyZ2V0L2FybS9rdm0uYw0KPiBA
QCAtNDIsNiArNDIsNyBAQA0KPiAjaW5jbHVkZSAiaHcvYWNwaS9naGVzLmgiDQo+ICNpbmNsdWRl
ICJ0YXJnZXQvYXJtL2d0aW1lci5oIg0KPiAjaW5jbHVkZSAibWlncmF0aW9uL2Jsb2NrZXIuaCIN
Cj4gKyNpbmNsdWRlICJjcHUtaWRyZWdzLmgiDQo+IA0KPiBjb25zdCBLVk1DYXBhYmlsaXR5SW5m
byBrdm1fYXJjaF9yZXF1aXJlZF9jYXBhYmlsaXRpZXNbXSA9IHsNCj4gICAgIEtWTV9DQVBfSU5G
TyhERVZJQ0VfQ1RSTCksDQo+IEBAIC0yNzMsNyArMjc0LDYyIEBAIHN0YXRpYyB1aW50MzJfdCBr
dm1fYXJtX3N2ZV9nZXRfdmxzKGludCBmZCkNCj4gICAgIHJldHVybiB2bHNbMF0gJiBNQUtFXzY0
QklUX01BU0soMCwgQVJNX01BWF9WUSk7DQo+IH0NCj4gDQo+IC1zdGF0aWMgdm9pZCBrdm1fYXJt
X2dldF9ob3N0X2NwdV9mZWF0dXJlcyhBUk1Ib3N0Q1BVRmVhdHVyZXMgKmFoY2YpDQo+ICtzdGF0
aWMgaW50IGlkcmVnc19pZHhfdG9fa3ZtX2ZlYXR1cmVfaWR4KEFSTUlEUmVnaXN0ZXJJZHggaWR4
KQ0KPiArew0KPiArICAgIEFSTVN5c1JlZ3Mgc3lzcmVnID0gaWRfcmVnaXN0ZXJfc3lzcmVnW2lk
eF07DQo+ICsNCj4gKyAgICByZXR1cm4gS1ZNX0FSTV9GRUFUVVJFX0lEX1JBTkdFX0lEWCgoc3lz
cmVnICYgQ1BfUkVHX0FSTTY0X1NZU1JFR19PUDBfTUFTSykNCj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgPj4gQ1BfUkVHX0FSTTY0X1NZU1JFR19PUDBfU0hJ
RlQsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKHN5c3JlZyAm
IENQX1JFR19BUk02NF9TWVNSRUdfT1AxX01BU0spDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgID4+IENQX1JFR19BUk02NF9TWVNSRUdfT1AxX1NISUZULA0K
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIChzeXNyZWcgJiBDUF9S
RUdfQVJNNjRfU1lTUkVHX0NSTl9NQVNLKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICA+PiBDUF9SRUdfQVJNNjRfU1lTUkVHX0NSTl9TSElGVCwNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAoc3lzcmVnICYgQ1BfUkVHX0FS
TTY0X1NZU1JFR19DUk1fTUFTSykNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgPj4gQ1BfUkVHX0FSTTY0X1NZU1JFR19DUk1fU0hJRlQsDQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKHN5c3JlZyAmIENQX1JFR19BUk02NF9T
WVNSRUdfT1AyX01BU0spDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgID4+IENQX1JFR19BUk02NF9TWVNSRUdfT1AyX1NISUZUKTsNCj4gK30NCj4gKw0KPiAr
LyoNCj4gKyAqIGdldF9ob3N0X2NwdV9pZHJlZ3M6IFJlYWQgYWxsIHRoZSB3cml0YWJsZSBJRCBy
ZWcgaG9zdCB2YWx1ZXMNCj4gKyAqDQo+ICsgKiBOZWVkIHRvIGJlIGNhbGxlZCBvbmNlIHRoZSB3
cml0YWJsZSBtYXNrIGhhcyBiZWVuIHBvcHVsYXRlZA0KPiArICogTm90ZSB3ZSBtYXkgd2FudCB0
byByZWFkIGFsbCB0aGUga25vd24gaWQgcmVncyBidXQgc29tZSBvZiB0aGVtIGFyZSBub3QNCj4g
KyAqIHdyaXRhYmxlIGFuZCByZXR1cm4gYW4gZXJyb3IsIGhlbmNlIHRoZSBjaG9pY2Ugb2YgcmVh
ZGluZyBvbmx5IHRob3NlIHdoaWNoDQo+ICsgKiBhcmUgd3JpdGFibGUuIFRob3NlIGFyZSBhbHNv
IHJlYWRhYmxlIQ0KPiArICovDQo+ICtzdGF0aWMgaW50IGdldF9ob3N0X2NwdV9pZHJlZ3MoQVJN
Q1BVICpjcHUsIGludCBmZCwgQVJNSG9zdENQVUZlYXR1cmVzICphaGNmKQ0KPiArew0KPiArICAg
IGludCBlcnIgPSAwOw0KPiArICAgIGludCBpOw0KPiArDQo+ICsgICAgZm9yIChpID0gMDsgaSA8
IE5VTV9JRF9JRFg7IGkrKykgew0KPiArICAgICAgICBBUk02NFN5c1JlZyAqc3lzcmVnZGVzYyA9
ICZhcm02NF9pZF9yZWdzW2ldOw0KPiArICAgICAgICBBUk1TeXNSZWdzIHN5c3JlZyA9IGlkX3Jl
Z2lzdGVyX3N5c3JlZ1tpXTsNCj4gKyAgICAgICAgdWludDY0X3Qgd3JpdGFibGVfbWFzayA9DQo+
ICsgICAgICAgICAgICAgY3B1LT53cml0YWJsZV9tYXBbaWRyZWdzX2lkeF90b19rdm1fZmVhdHVy
ZV9pZHgoaSldOw0KPiArICAgICAgICB1aW50NjRfdCAqcmVnOw0KPiArICAgICAgICBpbnQgcmV0
Ow0KPiArDQo+ICsgICAgICAgIGlmICghd3JpdGFibGVfbWFzaykgew0KPiArICAgICAgICAgICAg
Y29udGludWU7DQo+ICsgICAgICAgIH0NCj4gKw0KPiArICAgICAgICByZWcgPSAmYWhjZi0+aXNh
ci5pZHJlZ3NbaV07DQo+ICsgICAgICAgIHJldCA9IHJlYWRfc3lzX3JlZzY0KGZkLCByZWcsIGlk
cmVnc19zeXNyZWdfdG9fa3ZtX3JlZyhzeXNyZWcpKTsNCj4gKyAgICAgICAgdHJhY2VfZ2V0X2hv
c3RfY3B1X2lkcmVncyhzeXNyZWdkZXNjLT5uYW1lLCAqcmVnKTsNCj4gKyAgICAgICAgaWYgKHJl
dCkgew0KPiArICAgICAgICAgICAgZXJyb3JfcmVwb3J0KCIlcyBlcnJvciByZWFkaW5nIHZhbHVl
IG9mIGhvc3QgJXMgcmVnaXN0ZXIgKCVtKSIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
X19mdW5jX18sIHN5c3JlZ2Rlc2MtPm5hbWUpOw0KPiArDQo+ICsgICAgICAgICAgICBlcnIgPSBy
ZXQ7DQo+ICsgICAgICAgIH0NCj4gKyAgICB9DQo+ICsgICAgcmV0dXJuIGVycjsNCj4gK30NCj4g
Kw0KPiArc3RhdGljIHZvaWQNCj4gK2t2bV9hcm1fZ2V0X2hvc3RfY3B1X2ZlYXR1cmVzKEFSTUNQ
VSAqY3B1LCBBUk1Ib3N0Q1BVRmVhdHVyZXMgKmFoY2YpDQo+IHsNCj4gICAgIC8qIElkZW50aWZ5
IHRoZSBmZWF0dXJlIGJpdHMgY29ycmVzcG9uZGluZyB0byB0aGUgaG9zdCBDUFUsIGFuZA0KPiAg
ICAgICogZmlsbCBvdXQgdGhlIEFSTUhvc3RDUFVDbGFzcyBmaWVsZHMgYWNjb3JkaW5nbHkuIFRv
IGRvIHRoaXMNCj4gQEAgLTM1OSw2ICs0MTUsMTggQEAgc3RhdGljIHZvaWQga3ZtX2FybV9nZXRf
aG9zdF9jcHVfZmVhdHVyZXMoQVJNSG9zdENQVUZlYXR1cmVzICphaGNmKQ0KPiAgICAgICAgIFNF
VF9JRFJFRygmYWhjZi0+aXNhciwgSURfQUE2NFBGUjAsIDB4MDAwMDAwMTEpOyAvKiBFTDEmMCwg
QUFyY2g2NCBvbmx5ICovDQo+ICAgICAgICAgZXJyID0gMDsNCj4gICAgIH0gZWxzZSB7DQo+ICsg
ICAgICAgIC8qIE1ha2Ugc3VyZSBhbGwgd3JpdGFibGUgSUQgcmVnIHZhbHVlcyBhcmUgaW5pdGlh
bGl6ZWQgKi8NCj4gKyAgICAgICAgaWYgKGNwdS0+d3JpdGFibGVfbWFwKSB7DQo+ICsgICAgICAg
ICAgICBlcnIgfD0gZ2V0X2hvc3RfY3B1X2lkcmVncyhjcHUsIGZkLCBhaGNmKTsNCj4gKyAgICAg
ICAgfQ0KDQpBZ2FpbiwgSSBkbyBub3QgbGlrZSB3cml0YWJsZV9tYXAgYmVpbmcgaW4gQVJNQ1BV
Lg0KDQpXaHkgc2hvdWxkIGt2bV9hcm1fZ2V0X2hvc3RfY3B1X2ZlYXR1cmVzIGNhcmUgaWYgd3Jp
dGFibGUNCm1hcCBpcyBwb3B1bGF0ZWQgb3Igbm90Pw0KDQo+ICsgICAgICAgIC8qDQo+ICsgICAg
ICAgICAqIHRlbXBvcmFyaWx5IG92ZXJyaWRlIHRoZSBDTElEUl9FTDEgdmFsdWUgc2luY2Ugc29t
ZSBob3N0IHZhbHVlcw0KPiArICAgICAgICAgKiB0cmlnZ2VyICJVbmlmaWVkIHR5cGUgaXMgbm90
IGltcGxlbWVudGVkIGF0IGxldmVsIG4iIGVycm9yIGluDQo+ICsgICAgICAgICAqIGZkdF9hZGRf
Y3B1X25vZGVzKCkNCj4gKyAgICAgICAgICovDQo+ICsgICAgICAgIFNFVF9JRFJFRygmYWhjZi0+
aXNhciwgQ0xJRFIsIDB4MCk7DQo+ICsNCg0KVGhpcyBpcyBiZWNhdXNlIGJ5IGRlZmF1bHQgS1ZN
IGV4cG9zZXMgYSAxIGxldmVsIHVuaWZpZWQsIDEgd2F5IDEgc2V0IHNpbXBsZQ0KY2FjaGUsIHRv
IGVmZmljaWVudGx5IGhhbmRsZSBzZXQvd2F5IGJhc2VkIGNhY2hlIG9wZXJhdGlvbnMuDQoNClRC
SCB0aGlzIGlzIHNsaWdodGx5IHVnbHkuIFNob3VsZCBtYWtlIHRoZSB2aXJ0IG1hY2hpbmUgY29k
ZSB0byBub3QgZXhwb3NlDQpjYWNoZSBmZHQgbm9kZXMgaWYgdXNpbmcgS1ZNLg0KDQpGb3Igb3Vy
IHYyIChXSVApLCB3ZSBoYXZlIGhhbmRsZWQgdGhpcyBieSBhIG5ldyBwcm9wZXJ0eSDigJhleHBv
c2UtY2FjaGXigJkgZm9yDQpuYW1lZCBjcHUgbW9kZWxzIHdoaWNoIGlzIHVzZWQgdG8gc2V0IENM
SURSIGFuZCBDQ1NJRFIgYmFua3MgYmFzZWQNCm9uIHZhbHVlcyBwcm92aWRlZCBieSB0aGUgbW9k
ZWwgYW5kIG9ubHkgY3JlYXRpbmcgZmR0IG5vZGVzIGlmIHRob3NlDQp2YWx1ZXMgYXJlIHByb3Zp
ZGVkLg0KDQo+ICAgICAgICAgZXJyIHw9IGdldF9ob3N0X2NwdV9yZWcoZmQsIGFoY2YsIElEX0FB
NjRQRlIxX0VMMV9JRFgpOw0KPiAgICAgICAgIGVyciB8PSBnZXRfaG9zdF9jcHVfcmVnKGZkLCBh
aGNmLCBJRF9BQTY0UEZSMl9FTDFfSURYKTsNCj4gICAgICAgICBlcnIgfD0gZ2V0X2hvc3RfY3B1
X3JlZyhmZCwgYWhjZiwgSURfQUE2NFNNRlIwX0VMMV9JRFgpOw0KPiBAQCAtNDg1LDcgKzU1Myw3
IEBAIHZvaWQga3ZtX2FybV9zZXRfY3B1X2ZlYXR1cmVzX2Zyb21faG9zdChBUk1DUFUgKmNwdSkN
Cj4gICAgIENQVUFSTVN0YXRlICplbnYgPSAmY3B1LT5lbnY7DQo+IA0KPiAgICAgaWYgKCFhcm1f
aG9zdF9jcHVfZmVhdHVyZXMuZHRiX2NvbXBhdGlibGUpIHsNCj4gLSAgICAgICAga3ZtX2FybV9n
ZXRfaG9zdF9jcHVfZmVhdHVyZXMoJmFybV9ob3N0X2NwdV9mZWF0dXJlcyk7DQo+ICsgICAgICAg
IGt2bV9hcm1fZ2V0X2hvc3RfY3B1X2ZlYXR1cmVzKGNwdSwgJmFybV9ob3N0X2NwdV9mZWF0dXJl
cyk7DQo+ICAgICB9DQo+IA0KPiAgICAgY3B1LT5rdm1fdGFyZ2V0ID0gYXJtX2hvc3RfY3B1X2Zl
YXR1cmVzLnRhcmdldDsNCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0vdHJhY2UtZXZlbnRzIGIv
dGFyZ2V0L2FybS90cmFjZS1ldmVudHMNCj4gaW5kZXggODUwMmZiMzI2NS4uOGM3ZmFmNTdjNyAx
MDA2NDQNCj4gLS0tIGEvdGFyZ2V0L2FybS90cmFjZS1ldmVudHMNCj4gKysrIGIvdGFyZ2V0L2Fy
bS90cmFjZS1ldmVudHMNCj4gQEAgLTEzLDYgKzEzLDcgQEAgYXJtX2d0X3VwZGF0ZV9pcnEoaW50
IHRpbWVyLCBpbnQgaXJxc3RhdGUpICJndF91cGRhdGVfaXJxOiB0aW1lciAlZCBpcnFzdGF0ZSAl
ZCINCj4gDQo+ICMga3ZtLmMNCj4ga3ZtX2FybV9maXh1cF9tc2lfcm91dGUodWludDY0X3QgaW92
YSwgdWludDY0X3QgZ3BhKSAiTVNJIGlvdmEgPSAweCUiUFJJeDY0IiBpcyB0cmFuc2xhdGVkIGlu
dG8gMHglIlBSSXg2NA0KPiArZ2V0X2hvc3RfY3B1X2lkcmVncyhjb25zdCBjaGFyICpuYW1lLCB1
aW50NjRfdCB2YWx1ZSkgInNjcmF0Y2ggdmNwdSBob3N0IHZhbHVlIGZvciAlcyBpcyAweCUiUFJJ
eDY0DQo+IA0KPiAjIGNwdS5jDQo+IGFybV9jcHVfcmVzZXQodWludDY0X3QgbXBfYWZmKSAiY3B1
ICUiIFBSSXU2NA0KPiAtLSANCj4gMi41My4wDQo+IA0KDQoNCldhcm0gUmVnYXJkcywNCktodXNo
aXQNCg0K
