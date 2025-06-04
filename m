Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E618528E
	for <kvmarm@lists.linux.dev>; Wed,  4 Jun 2025 15:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749052409; cv=fail; b=doj9QROJ6KHI/wFe32afogPkvpss5w7niuGNnE7BpjC/of5Ebeuxb/GpiGQe5klMW9akklY8cziKNCtztPUI55a8vYlw7B+X+omk+EPjAJyw+stniYDDu7ibtAfy5nDnmaW2kO/g7QIk9gXGIVdKcqBrepMlzDh6y9iGepQUv+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749052409; c=relaxed/simple;
	bh=TrIqmJvvlCDbVwvKzPZZHU/pRqXi4iRVtaWsZBGijYU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uYo1VKvpVvDpHmGh9cEbp+E0Ikt/pf7aErQ6dMrMI0wa1+yDMvllS02rdAZKHs+NvjHcrrpV+3IewW7+yt/oUINfsYKnfsic6Vv8f0NC6C7Fln5xnrldFctqC+6Z7tGwwg/N4rQHTJ3aIvQO9F2bXwaL5aj77LQjnRLLAhHcUxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KpRKiAGd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=z+Tpwpqf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KpRKiAGd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="z+Tpwpqf"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 554Fdw8S008859;
	Wed, 4 Jun 2025 15:53:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TrIqmJvvlCDbVwvKzPZZHU/pRqXi4iRVtaWsZBGijYU=; b=
	KpRKiAGddt4VL8kPEhRJb5PMMh0stkBZJTbJaqlRz3pygr7oR8CuMQpTBfbAsCBJ
	wnbFrlUsXNtj0I30QHTtIinm9WXWWOqEOEznIpQKMjpbjqjJelWar9pJb0D1XeZX
	mgOLvnN2LrsN64al1oCSetYB9MQTWvrwGDtjGXtz3yIL9Es3qKTjBmP+4/M5BwKO
	Ckl2AC9mbcsSaOzl85yzWZStv4OPi7jktX5PnjTTkt7WUD/q4GEPxoktjd3QZP1o
	P+zCIZlZ1G6kkuy+wzbLdPmJI29RZXW7WPvVEj+DPXw3QxX79Mk1TlTCOhf5UV3t
	srwqrr8BNw+9BojXB2xVIw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8j4d1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 15:53:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 554F9YjG030830;
	Wed, 4 Jun 2025 15:53:04 GMT
Received: from cy4pr02cu008.outbound.protection.outlook.com (mail-westcentralusazon11011005.outbound.protection.outlook.com [40.93.199.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7axha2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 15:53:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zsgpk9WLkgpzOS28UM4o8R+aE8htBL6I/29BoigZramZTfVEQTAMRVK8pG8ZYawqmD8J7lQl3InLbcZkZKezDc934Hsksur1BzJDVGNuYCMpoM76lEW8I255RPzcETbh/jVOuv4YyAUb75dytdNPWEsO2Y20kAFiYv1wIC1krpyheFD6gaEHn5cdc8RwYIRJ4ir7NK0sgLxk86FI+VJ4FIvyTkVLRZ4A9mq/mh9URw1GDD/shlsIUwClWXEr+8mvTeedsmfnVBTsG8lek/nGX13kFQMjO/AsD0AbpyjD4b5gUoBCMl2h0Ky/c1/Ot+AXJeENpdUAO54yZknkB+7P8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TrIqmJvvlCDbVwvKzPZZHU/pRqXi4iRVtaWsZBGijYU=;
 b=VJW0FPb85mrDq97q1DHlVK+2DFgORAAZ+XKTA9qyChPOZ4722mQlvcCmgajdL0z2pjmXhPv7WpIwoivasqIwHMFGUlZ6CdJzvSz0AoZIEwZNQ75e/eO+RB7V1YNmGjwmfBuctBn0entLE32cgWhYYdvC6uOcQQT319/qLuBWsgdJHzRP3Dz59faPrMIth+esY9rWr0PbS53SCBWfMiuNTRO5fmuztCKkItjzy7tpRDVyprdzCDWNxQfIHFu92v9CWM+FodSwcAZNKbrUFmtsfXb0ELbIgCG0Z1tlPomw1D9ULFmGlaxBy57Rg6XpnFN2ExWheorEVg6dppXpgCoCPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrIqmJvvlCDbVwvKzPZZHU/pRqXi4iRVtaWsZBGijYU=;
 b=z+TpwpqfRcedghN2w1p1hpMkzrDgauCABODMWyDSLPSsg13CHz0cMug9WH3y1LZVQJr3iPXXaoMWYhOcH7B3Y2yFlifwTRQGhx7wK8tyBmlbHsgzPpRssij+RWj4PefS6lLhgnEfCV82Np1RLeurGA/cylK8df6kRmN328guHFk=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by IA3PR10MB8396.namprd10.prod.outlook.com (2603:10b6:208:583::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.21; Wed, 4 Jun
 2025 15:53:02 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%7]) with mapi id 15.20.8813.018; Wed, 4 Jun 2025
 15:53:02 +0000
From: Miguel Luis <miguel.luis@oracle.com>
To: Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton
	<oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: vcpu sysreg accessor rework
Thread-Topic: [PATCH v2 0/4] KVM: arm64: vcpu sysreg accessor rework
Thread-Index: AQHb1FZzymAUnIIEoUuFA1EqPZKnrrPy04qAgABLewCAAAnBgA==
Date: Wed, 4 Jun 2025 15:53:01 +0000
Message-ID: <AD26CFBA-FE32-4C7D-A75B-53729B70C591@oracle.com>
References: <20250603070824.1192795-1-maz@kernel.org>
 <2264D21F-C28B-4523-9132-A53EB8ABFCF0@oracle.com>
 <87bjr3edsr.wl-maz@kernel.org>
In-Reply-To: <87bjr3edsr.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|IA3PR10MB8396:EE_
x-ms-office365-filtering-correlation-id: d01a5c99-1419-445b-8213-08dda37fe2ee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bnlRR3QzZ01LZVFHODNqOE9QVVNpRFZIb0xDS1NJbkswUHR0RVg1WEhielVT?=
 =?utf-8?B?M3BJVTRveDlucGhSNUNHYm1pYmMyRXpheUlDRXlNaUFlQWdpcjhLdkIyNlha?=
 =?utf-8?B?aUlzRk4yQ3BCZ0lrWGU4VGhnQy9RWVNFOVRxVFkxV085ejAxYTExcjZiQlpx?=
 =?utf-8?B?Z0Y5Mmk1UUlHTytxeHdZNmlsQTdXdGFTbW00cjk5Y2IvYVFBYjl4T01pNHdw?=
 =?utf-8?B?NGtLY244alBYSnl1bmtRbFRaVFFoVVZtMmN5NlJYd0RFV25aMFQrMDYyQ210?=
 =?utf-8?B?d1FJSjRPL055SUxWZkRTV20vdlozaVVjZTVYc1hIYzNIMGMrNnd1cStGNWdP?=
 =?utf-8?B?dm82NnNrL3Y5enJQN2VJVmVGQ1ZXTGdZR0tQNGVuZC96Rkx5Y25Oby9Ddjh0?=
 =?utf-8?B?ZmJ1am8xQUZMc1pGeW13K0VQOW9jM0lhWFE0bXFEa0xkTEdjRSszQ0ZnQVpT?=
 =?utf-8?B?UDRmNjVlaDN6UFg5TkVOQkRQVkhHV3dTVW9EaHlCODZqTXJ3dldHMjAxZHFz?=
 =?utf-8?B?b3NIZHlMaEtJQXN0L2hORTl6SUJrTmtqV2tvdkFnNlFwdDZKSDU0RnN1T0xF?=
 =?utf-8?B?cy94KzM1RGx6aWVobnoweDR3dUhrTnRZSlVsTytvWUFJZVlnZTNUWmRNY1k5?=
 =?utf-8?B?M28vaDNzbTgzdis0YlEwYlZ0c3FHMlF0ZUE0N0dKZytHOURkcEhjR0N2djIr?=
 =?utf-8?B?UTJ0TmFwdmZKbGNrY1FJd3Zka0huQmg3U1M0ZmU4UDRocGxtaFYvV0srbWhu?=
 =?utf-8?B?WUFNQ3ZSdDhrNkxNWEx1MDN4dk9DNktHRVlIc29icUU4TkUrR2VGM2xXekhL?=
 =?utf-8?B?VFVqZGZnOHg0YjBuY25YZWFhZ0I1VGczUWNza1U2VE9WZjI2cklhZ3FlQjdy?=
 =?utf-8?B?eUZkUjRJYW1vNWRYYVR0dDBCS0JEMFBvL2h4S3BRQTJRd0JTT3haNzkweWxs?=
 =?utf-8?B?ejYyYzBuRElsa2V3cCthclNaTVhSZkFxeHd5UDFtTlpCQm9OaENwUGI3c0VB?=
 =?utf-8?B?dmxldVdEVWtTeUJkNmZmakt3WWxLajNlenJaazJaMFhCM3JUZnptRE9JSThE?=
 =?utf-8?B?NUFrZFZKN2JpRlQ1QlRDNmdKYkgzUzhyM01nNW9jZ2xtNmhBaGJzS2k3ekJs?=
 =?utf-8?B?Y2E4SG81czM0V3hYUjFpbVhhZHNJUnRGbEF6RnRzYjdxOENiVGpOZVJqQzdR?=
 =?utf-8?B?ZXcyVG12SVZsV0daWE5aZG92K2F3S3dNZC9tRlJvNDRoSEhVcHhIb084U1hY?=
 =?utf-8?B?SkJUYVEzeHBIR3VLbURlNU1WRVA4bkpSbHl5VXF6aS81UFpUU2Q0NVZkK0th?=
 =?utf-8?B?YWZEUDl0VzBPNGhvVG5MVFZuR2VGdXhpRi9PUGNCM1hYS0NmYVVNWjJ1aVR6?=
 =?utf-8?B?ang2eXhDQUhCU05lbTdoUS9Vd3MzNUw0SGU5ZFNldnNkbEgvWW1Rd2JBcDNE?=
 =?utf-8?B?c2VqT1Uyelp6aHU5LzRxcFNWRkw3RWNZR1F5cVpUZW1wZkc0eXpHaHJPc1Zq?=
 =?utf-8?B?c05zbk90c094UWk1Rm43d3F2N01WR21Ga0VFTkRDN3V4Sm9UaEprcm14Qnd0?=
 =?utf-8?B?aFROWjBGZExKb0p4em9FZk5KUVN5L3B1T21RTkZhQ1diWnBRTDErdmdvcGlY?=
 =?utf-8?B?cndTQmdHQVNmUXpIaW5UUUFjY1hURWU5MFJabDNON1RlMmtqbHBpZGdxeFN3?=
 =?utf-8?B?dHFpcXVuUThudGM2aEpDL3MxdThqcmpKTGxuVkZ0c282UGw2N08zYWIzdFR6?=
 =?utf-8?B?dkxJUnBWUStlWGJsZnEweU1VTWJqQm5MaW44MEdDaHVYUWl3UDZzTWxKOFRF?=
 =?utf-8?B?dThjK2xRN2kxbVVKOEV1RFlNM1ViazFNT1R5cncxeGZUcnQzejJSQ1FQNXd2?=
 =?utf-8?B?Nnp6Q3N4cVlXa1Y5MzdMSnZ1MkRZWDE4dkRBMElzbDlaWVhuK3dIMW8zb0JK?=
 =?utf-8?B?eWpGcjB2U0VXTjQvck5rVWd5bTNkQTIrWjZSVnJ1SFVYeWxwYTgvNEl5NjBN?=
 =?utf-8?B?NlJGMndwblpRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?blBwaDJlb3NZVXNxUm5FOGZzVTZCZUlkUXdsWDhxd0R2VS91bmM2L0NVbEZR?=
 =?utf-8?B?d3dETk9rSkJDUTVEa3p4VHd5SGtTQzNoem02TUFWZHNTcnNXTytTNUdUK1NO?=
 =?utf-8?B?OHR5ZTNrbUVZcWI0QlNCRFdqQmRDVnBpc3dYZGhFaFlEam1ib2srNWRSRnE0?=
 =?utf-8?B?RnhKM2dILzhaSkRkRkNyRkM1NFNIeE5ud1JFNWQzd0NaRUVMZUNoK0JScHhL?=
 =?utf-8?B?QlFtQUVUOHErdUtwRVRIdnhwajNCUVozczQ3aXk2R2phcUxuOEoydG1ndXB1?=
 =?utf-8?B?UUN5bzFwVjFObWhwWjYwMmF3Sld0OE52RXhZUHFiL1BzMGJ3cFRvMk16RVIv?=
 =?utf-8?B?aHpVRkxPSWc4Y1g0L0tSNElNNE1VcjZ6SmpBZERXYm5qV2FnZk5EVDMzVkhS?=
 =?utf-8?B?ZW9jUGhMY0ltWnNmNzdFbU9IOVdOZHdZRS9ybEFlRjRKdWFDdGVqUkdtQ2t3?=
 =?utf-8?B?cE5BRzJYUHc3aTY2TC9hcUdVb3Z5eHIrMjBtbnJ1QVdaTk95Q243STVhT1NX?=
 =?utf-8?B?NE9xT2JjWWtkVWlrQTZTU3ZveFBWTERsVGxPNjdJc210b3A3THlEeHlUTVRv?=
 =?utf-8?B?TENuMWZydk8vSnp4aHp3VEQ4RG01bHV6UDRQRUhaSXhtcGZxVm5PTnBtczR3?=
 =?utf-8?B?b0w1eXltd2RBckVDcVZwUmZFOEZVWGVFdGg2OVVTd0NaMEorYVphZitETmhC?=
 =?utf-8?B?TlhCNnFEY25La1JwcENnbzlCV3BTQmg3SW5jNjZ5MWZZL1NZMncxK25IbnA3?=
 =?utf-8?B?YnJoNnBQN2F0TDJnbm05cC92M0pQbEFiaGNDVTFCUkRoZ3R0OTBTNHdxQnNX?=
 =?utf-8?B?dFc0TGRGWllOVGVYODQyZDBQbC9aL2dSZ2s1bmR3RStvZ214VWM4OTRVd1hB?=
 =?utf-8?B?czlycnA2Z0h5d1ltOW53OGhTdExrZkhZQW1vZzNjTzEzMnJmVHUxalJ3RWxY?=
 =?utf-8?B?VXFKdlBPL2hELzRXRlNoc2g2UDhXVm1vS1VJeVdHcDNKSjNhcjhuc0M0NWFo?=
 =?utf-8?B?ZGUxNm9UeTFyOGRkYVE5UDE4ZXpHS1ZPZUFYM2hobVJ2a0dXbzFOSHRQZ01i?=
 =?utf-8?B?MWx1WTBhUjlsZUxjeDduckQ4R0tOM0gxakZyMllLZnVjV0JDUk9jaGl4Ky8z?=
 =?utf-8?B?SHNYNlJodU1wVGpjUGxPemJRakZrRjBvMGdMUGZDMjcyamxzclRVL0crVlVU?=
 =?utf-8?B?S0tJSyszdU1NcVA3WCs3dklKdG5FVE1lZWdaR0t4b3kwR2I5Rk5XWkdaVmdJ?=
 =?utf-8?B?c0ZPQXhJNVQrU3p3ZmFYL05aV0VaVkxQYXkxVk5OVVBiU01jVnE5UDZVdXpw?=
 =?utf-8?B?RlFlbXpzQzFrNmwvQWVnQ0FJL3V1cmZvcXJWaVVOV2VhY0w4aEU5b25CS0ZY?=
 =?utf-8?B?NCtmdmRReDVtS09DemVIZ1RFMlpQR01NSTlKMDJkbHpwOGFsSnVTMnVFQVFO?=
 =?utf-8?B?V2tVbzVRYkxBdkU1dEdrUUdnNGFiVUZpYW8vay80UWFGVjRPYmZINUE4VE1a?=
 =?utf-8?B?N0Q4ZTl5Y0RxQWVQYll1U0VNY1FONUVHaWlwVkpZVUdaYUR5Nk5ZL2ZHcS83?=
 =?utf-8?B?bU9HVENSVllKTW5Pbm03aS81c2E0ZkxnbVc2UGVNTGR5Z2hSVGFOcTB4Rk9Q?=
 =?utf-8?B?bkJXWVdXUHRndEZrUHlyL3ZkakVTSUpQK0xJVVR4ZjJlaEczK0N3SVUyNGt0?=
 =?utf-8?B?bnRJSnV2Qm5IZW95RUlraFRzcVJSeFpncjd2bVphTmNzVUF1RzNaY0J2WkYx?=
 =?utf-8?B?Y0dUQmJuYnVpVmlFcnJyakxKZXppbVJLWURtV1ZsNHdzbHFNczBsS0RCcWUv?=
 =?utf-8?B?Z004cnh4UC9Zbk5vTmFTbmlGcHRGN1FKOGJmcWhHT1FKcTQxNzFEZkZqQ3dI?=
 =?utf-8?B?VmNGdWtpaG80RkRtUSt2Z0JIQVduUFk4Y3I0dkVJdmdiaFZETUUzTERkMit4?=
 =?utf-8?B?Wi9uL2NGZDQyQUp2L1VDSjhuNlovMjhMaU9DTzh1a3VYYVo0ZHBUb0s4cUVy?=
 =?utf-8?B?NHYwd2FJdHF1WUc2T084ZWZQcC83R2M3UDVhemUvTXE3ZkpFTmFLTkJvMjV0?=
 =?utf-8?B?b2VSK2YwTmhTVCs2TWtpTU1GR0hyU1duSG56OHI4R1VCK3RSVnhXSVBMZ3Jn?=
 =?utf-8?B?YzUyMHZXQ3o5aDdkZm5ka1JXU0lRREQ1MXhmK2cxb3h1K2d6blRhMVhESEdR?=
 =?utf-8?B?dXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FD766C0A0B1334C937C3007CE95028A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4Z09er2yivd46jc9fp6kru6C6mMzzia4AM8wfoM0TPUvCBnSJfUn+WrpHUvqpObePAyv7c2mJtBlxqz9e8RScXdvgArJGxjMfT/tJn2N4WDtYIuCUlwfVzpAWf85cpVh5PueiPfRBt9ofyPENO+2WcGkaWaBLlRwfQnkaW7aEWFChyHsMVZDuKxp8/dRDHktfzA15j3KjgxlJtANyHc6NOF0nYVyntSQzCNznzYtavHOgC4oK94tSqGhU8/0gmMJdzcRxq0zcSo6ghXlqEwsPvt5M9vNPP9VGaTjKgHjr+L1+5XBZtVS5GLgsLZY4mqoNp+fYfC3yCAUSCoyZQhz85JwK42hCBZtp8mbISFWbUlHVPYamOofizT76NiKZt5fINtczzByL7TlhrshnySu0ZNPCe1ZpNr+6nqexQnpqUmLf7m67lC65TNvC1YqqAai8BpiZMhoQShqTjSdeQPVHWVb6oIl2Ftj4+EEU72o8/8qK091DXYKP4uHTAMy2xG6gBA3EP+6ktoCe+RUYXWGzYXeeCG7JRVfPgHkVlVXYSoot3+hsmVdxNSqAbS7pLvonyAAfFTgK9ycYrR9ruqm6o8/gGtQr1WXcLLx4Dp3pKY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d01a5c99-1419-445b-8213-08dda37fe2ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2025 15:53:01.9872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Hncw1gpKKTHPjaberfvTMyYmh4Y+1vlYX1p/TykT4XNGqWEcEZjTxWi8+ewQuIgPeQvL4Q2vs0Rj8Kk5m4fpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8396
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506040120
X-Proofpoint-GUID: 4OjjH0iHvUfRV2lbY75jksp7QjtgOWd1
X-Proofpoint-ORIG-GUID: 4OjjH0iHvUfRV2lbY75jksp7QjtgOWd1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDEyMSBTYWx0ZWRfXwDWyb8dmi5DQ ID4mXn19M2CXUoZIAkmatKnuflfGtFUSwMTeXDoPFaPA+f+yQIkjFunz6NPTKhrkliXGYq+P3OP FdNVG8f42lZ9/BEEo2nAbYRJ9ep4FXmGsLL61lz2Yw4pOgWja5eMilffbl5gL+t7ExUiGrLSN9p
 KhDCgAEaCaFMJgG8YlQwdcjMidQlpP4UkP9pHh483J5AdW3IKFaFLOp7BddLlibwThKobZISH2u ZE3Xwtrf91S6hGFeuqN4Xh3BmFSZ8Br3jcgYCG2xvD6E+7GZXBSzW2mfr3z99EVEa6hfSvWWA4y jZFfWnniZHNqi6ypTGMPfzlMhi2PPKcfbX5d1r8N5G7Ex1xq5r4OtECdnE0VyoRP5M2CgPB75AJ
 o/9yxNr66zW3DJcpWAcshhHTbSB2qbCyVp4Gz0rQxJOJc87lnbgNXWSRXwlEemygUgi/9neo
X-Authority-Analysis: v=2.4 cv=QI1oRhLL c=1 sm=1 tr=0 ts=68406be1 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=W7sqPqoSq3Keb7u5a-YA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714

DQoNCj4gT24gNCBKdW4gMjAyNSwgYXQgMTU6MTcsIE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5v
cmc+IHdyb3RlOg0KPiANCj4gT24gV2VkLCAwNCBKdW4gMjAyNSAxMTo0Nzo1NyArMDEwMCwNCj4g
TWlndWVsIEx1aXMgPG1pZ3VlbC5sdWlzQG9yYWNsZS5jb20+IHdyb3RlOg0KPj4gDQo+PiBIaSBN
YXJjLA0KPj4gDQo+Pj4gT24gMyBKdW4gMjAyNSwgYXQgMDc6MDgsIE1hcmMgWnluZ2llciA8bWF6
QGtlcm5lbC5vcmc+IHdyb3RlOg0KPj4+IA0KPj4+IFRoaXMgc2VyaWVzIHRyaWVzIHRvIGJyaW5n
IHNvbWUgc2FuaXR5IHRvIHRoZSB3YXkgdGhlIFJFU3ggbWFza3MNCj4+PiBhcmUgYXBwbGllZCB3
aGVuIGFjY2Vzc2luZyB0aGUgaW4tbWVtb3J5IHZpZXcgb2YgdGhlIGd1ZXN0J3MNCj4+PiBzeXN0
ZW0gcmVnaXN0ZXJzLg0KPj4+IA0KPj4+IEN1cnJlbnRseSwgd2UgaGF2ZSAqb25lKiBhY2Nlc3Nv
ciAoX192Y3B1X3N5c19yZWcoKSkgdGhhdCBjYW4gZWl0aGVyDQo+Pj4gYmUgdXNlZCBhcyBhIHJ2
YWx1ZSBvciBsdmFsdWUgd2hpbGUgdGhhdCBhcHBsaWVzIHRoZSBSRVN4IG1hc2tzIGJlaGluZA0K
Pj4+IHRoZSBzY2VuZXMuIFRoaXMgd29ya3MgZmluZSB3aGVuIHVzZWQgYXMgYSBydmFsdWUuDQo+
Pj4gDQo+Pj4gSG93ZXZlciwgd2hlbiB1c2VkIGFzIGEgbHZhbHVlLCBpdCBkb2VzIHRoZSB3cm9u
ZyB0aGluZywgYXMgaXQgb25seQ0KPj4+IHNhbml0aXNlcyB0aGUgdmFsdWUgd2UncmUgYWJvdXQg
dG8gb3ZlcndyaXRlLiBUaGlzIGlzIHBvaW50bGVzcyB3b3JrDQo+Pj4gYW5kIHBvdGVudGlhbGx5
IGhpZGVzIGJ1Z3MuDQo+Pj4gDQo+Pj4gSSBwcm9wb3NlIHRoYXQgd2UgbW92ZSB0byBhIHNldCBv
ZiBzdG9yZS1zcGVjaWZpYyBhY2Nlc3NvcnMgKGZvcg0KPj4+IGFzc2lnbm1lbnRzIGFuZCBSTVcp
IGluc3RlYWQgb2YgdGhlIGx2YWx1ZSBoYWNrLCBlbnN1cmluZyB0aGF0IHRoZQ0KPj4+IGFzc2ln
bmVkIHZhbHVlIGlzIHRoZSBvbmUgdGhhdCBnZXRzIHNhbml0aXNlZC4gVGhpcyB0aGVuIGFsbG93
cyB0aGUgDQo+Pj4gbGVnYWN5IGFjY2Vzc29yIHRvIGJlIGNvbnZlcnRlZCB0byBydmFsdWUtb25s
eS4NCj4+PiANCj4+PiBHaXZlbiB0aGUgbGV2ZWwgb2YgY2h1cm4gdGhpcyBpbnRyb2R1Y2VzLCBJ
J2QgbGlrZSB0aGlzIHRvIGxhbmQgdmVyeQ0KPj4+IGVhcmx5IGluIHRoZSBjeWNsZS4gRWl0aGVy
IGJlZm9yZSA2LjE2LXJjMiwgb3IgZWFybHkgaW4gNi4xNy4NCj4+PiANCj4+IA0KPj4gRm9yIHRo
ZSBzZXJpZXM6DQo+PiBSZXZpZXdlZC1ieTogTWlndWVsIEx1aXMgPG1pZ3VlbC5sdWlzQG9yYWNs
ZS5jb20+DQo+IA0KPiBUaGFua3MuDQo+IA0KPj4gDQo+PiBuaXQ6IHRoZSBybXcgYWNjZXNzb3Ig
aW1wbGllcyBhbiBpbXBsaWNpdCBhc3NpZ25tZW50IHdoaWNoIGNvdWxkIGJlIHNwZWNpZmllZA0K
Pj4gd2l0aGluIGl0cyBtYWNybyBpbnN0ZWFkIGJ1dCBpdCdzIGZpbmUgYnkgbWUuDQo+IA0KPiBJ
J20gbm90IHN1cmUgd2hhdCB5b3UgbWVhbi4gTG9va2luZyBhdCB0aGlzIG1hY3JvIGFnYWluLCB0
aGUgZWFybHkNCj4gd3JpdGViYWNrIHRvIHRoZSBzeXNyZWcgYXJyYXkgaXMgcHJldHR5IHVuZm9y
dHVuYXRlLCBhbmQgY291bGQgYmUNCj4gYXZvaWRlZC4NCj4gDQo+IERvZXMgdGhlIGZvbGxvd2lu
ZyBjaGFuZ2UgYWRkcmVzcyB5b3VyIGNvbmNlcm4/IElmIG5vdCwgcGxlYXNlIGNsZWFybHkNCj4g
cG9pbnQgb3V0IHdoYXQgeW91J3JlIGFmdGVyLg0KDQpJIGJlbGlldmUgdGhpcyBzaG91bGQgZ2l2
ZSBhIGNsZWFyZXIgaWRlYSB3aGlsZSBhdm9pZHMgcmVwZWF0aW5nIHRoZSBhc3NpZ25tZW50IGV2
ZXJ5d2hlcmUNCnRoZSBhY2Nlc3NvciBpcyB1c2VkLiBKdXN0IHJlcGxhY2Ug4oCYJj3igJggYW5k
IOKAmHw94oCYIGJ5IOKAmCbigJkgYW5kIOKAmHzigJkuDQoNCmRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9o
b3N0LmgNCmluZGV4IGI0YWMyZjUxNWY5NC4uYmRlMWUzMWI0ZGVlIDEwMDY0NA0KLS0tIGEvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQorKysgYi9hcmNoL2FybTY0L2luY2x1ZGUv
YXNtL2t2bV9ob3N0LmgNCkBAIC0xMTIxLDcgKzExMjEsNyBAQCB1NjQga3ZtX3ZjcHVfYXBwbHlf
cmVnX21hc2tzKGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqLCBlbnVtIHZjcHVfc3lzcmVnLCB1NjQp
Ow0KICNkZWZpbmUgX192Y3B1X3Jtd19zeXNfcmVnKHYsIHIsIG9wLCB2YWwpICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXA0KICAgICAgICBkbyB7ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KICAgICAgICAgICAgICAgIGNv
bnN0IHN0cnVjdCBrdm1fY3B1X2NvbnRleHQgKmN0eHQgPSAmKHYpLT5hcmNoLmN0eHQ7ICAgXA0K
LSAgICAgICAgICAgICAgIHU2NCBfX3YgPSBjdHh0X3N5c19yZWcoY3R4dCwgKHIpKSBvcCAodmFs
KTsgICAgICAgICAgICAgXA0KKyAgICAgICAgICAgICAgIHU2NCBfX3YgPSBjdHh0X3N5c19yZWco
Y3R4dCwgKHIpKSBvcCMjPSAodmFsKTsgICAgICAgICAgXA0KICAgICAgICAgICAgICAgIGlmICh2
Y3B1X2hhc19udigodikpICYmIChyKSA+PSBfX1NBTklUSVNFRF9SRUdfU1RBUlRfXykgXA0KICAg
ICAgICAgICAgICAgICAgICAgICAgX192ID0ga3ZtX3ZjcHVfYXBwbHlfcmVnX21hc2tzKCh2KSwg
KHIpLCBfX3YpOyAgXA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KTWlndWVsDQoNCj4gDQo+IE0uDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+IGluZGV4IGI0YWMyZjUxNWY5NC4uMzgyYjM4
MmQxNGRhIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgN
Cj4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+IEBAIC0xMTIxLDcg
KzExMjEsOCBAQCB1NjQga3ZtX3ZjcHVfYXBwbHlfcmVnX21hc2tzKGNvbnN0IHN0cnVjdCBrdm1f
dmNwdSAqLCBlbnVtIHZjcHVfc3lzcmVnLCB1NjQpOw0KPiAjZGVmaW5lIF9fdmNwdV9ybXdfc3lz
X3JlZyh2LCByLCBvcCwgdmFsKSBcDQo+IGRvIHsgXA0KPiBjb25zdCBzdHJ1Y3Qga3ZtX2NwdV9j
b250ZXh0ICpjdHh0ID0gJih2KS0+YXJjaC5jdHh0OyBcDQo+IC0gdTY0IF9fdiA9IGN0eHRfc3lz
X3JlZyhjdHh0LCAocikpIG9wICh2YWwpOyBcDQo+ICsgdTY0IF9fdiA9IGN0eHRfc3lzX3JlZyhj
dHh0LCAocikpOyBcDQo+ICsgX192IG9wICh2YWwpOyBcDQo+IGlmICh2Y3B1X2hhc19udigodikp
ICYmIChyKSA+PSBfX1NBTklUSVNFRF9SRUdfU1RBUlRfXykgXA0KPiBfX3YgPSBrdm1fdmNwdV9h
cHBseV9yZWdfbWFza3MoKHYpLCAociksIF9fdik7IFwNCj4gXA0KPiANCj4gLS0gDQo+IEphenog
aXNuJ3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuDQoNCg0K
