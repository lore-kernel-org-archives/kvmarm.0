Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BC9262FDB
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 09:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749635299; cv=fail; b=Yrrvpz5aodKIlThv/tFsfbJutmDjjgmFneYsJXDAh2HcG9CA5YA0r2l9kQPan3pS7n4k8P0ooRphtWeoadzhIA7vtDRuicLkRNCaG4FYoSmKhpTiIAMOUTY+5YcR8cBqANpl88ikfxdcVyBaHPSdyIBm9x3lfp2yqfFbbqUql7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749635299; c=relaxed/simple;
	bh=tKQzz8eY9eAx7eGPqrzidYI2K2IUwlbJsRwqMANcPgo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ox6+L2A5ExtzWjaAEUd121ZfLVNth3/4BXwBbhl6+PiGW9iQsJtNa7+p3LfW9aZtJAv4kI2aj/sBXkF/EViEl+uBN1o08XAKBXEO+lDvQwwqxjjcDRQalxpxeEnQJVEY18ZMT4WZcIuzc4RyjPjlDLloDwmcKVF88GzcLe8CXQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LbHOXmhi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=W+GaX5Fb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LbHOXmhi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="W+GaX5Fb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55B1BrFV024209;
	Wed, 11 Jun 2025 09:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ehXAj+yUQBmshdAcMQF7y2FDbz4z+MvSSTl6vYnuE84=; b=
	LbHOXmhiUbMhPg6RzyoNbhPRBNugXZbEFxXa+ilxih0EItxEasSayAZG5l/sb5d6
	NJn3yRUK19+3KMrU0epNMyJ/j2oPJLi4ujz3/0rfryJ3TihlgwoGqp+/e/Y5dXDQ
	2Z5zgd+QSrcAkXCz8RopQDOjQkX1UD9uZZ0rC3KxSg6CsTgTI4o/Bvn3qtv4cxvT
	F3BwFZNYgI0L8Yp37MowtEvDZv+1IRvUO+Yat/ZFpLtHE5TyhF47ugXPKF6pIlfA
	qF7+RFF4ZqAxBsQu6qYL9/28d4Yy9rTTvqk/0DY7R3zhShdwPiq8mNr9s2RXz3lH
	9A5qJSrLevGsMeMtu6bUzA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474d1v5wg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 09:47:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55B9O0PK020397;
	Wed, 11 Jun 2025 09:47:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvg5fxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 09:47:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVcSOCCC0z/lu4qe46rHVRiJJfe8i74jGHRT5QbP8lgqVZPzkt+RCTefzPJxB8xzzWsC2eZNTVGsA3V0gtIvjtt322J2PghI0MEb+aP2TaFDMyt0xUmPZyo+5xYsNohNmYOij9OrfekWC2kY5FD0HyhEOVHZjBXLdsg45P/S2dUMDkMjFE+bd5flPUuYSRR3Gq/p6Resg+9gtzy4E9Iuqzri0CnUNfe3KAPEJJNt6NgaBW1N38TyxdLNlvsOuXZyatLXv4iEWBI1hZ1teHiukUrdgfO3iTMGi0m1m0a8/GfmdsPsUfX4/MNmGwz5PmVxZ+1QnRxnBZfw7odjyqQUnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehXAj+yUQBmshdAcMQF7y2FDbz4z+MvSSTl6vYnuE84=;
 b=QuJ0damHbJdKmlTa7O4yLRsoXXyV4FlntUAi94WODsI3SvYotbR8K0p9B/oyYo0W2uuDWemkY4ydQ5i47+j0LTSbe/GaiR1vix6ncami3OfAaMCD8xmQQ5pn+OKge/J5nyy3Zqziz2bKx5qUhFxuEh8PoC60zf2KxYUS3AMxv6X9T+p93DC6G3bmY06+DTORlFAW9WKFypRgzNNnz/1989UKmWHbF8ALmoVLnWOLWRW2reBv8lHNMVMDNn73a/1uqGzb7GjgslxgXaLRtx3kZSBxm4PX6KYbtAqmU6LbskHv4G2govv56bUzjvNalA+K5QYLyzIf3KIsOHChU6W1tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehXAj+yUQBmshdAcMQF7y2FDbz4z+MvSSTl6vYnuE84=;
 b=W+GaX5FbJgjZfJ/Hkz6T3MmkZ52QODC1+XeXwjp/UTocWQmb40t2c6G8w9TZx8NyOQzpGv4v4gADIS9Nu92WNCt4Y/ptJnNyMZBDYu0o6yy7IBW3gjYnoUmuKAZw2DUTOjE7WswpLFpt5KFYyvMgolbsMuJNe7hHslfJXqydkqg=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SA2PR10MB4444.namprd10.prod.outlook.com (2603:10b6:806:11f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Wed, 11 Jun
 2025 09:47:44 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%7]) with mapi id 15.20.8835.018; Wed, 11 Jun 2025
 09:47:44 +0000
From: Miguel Luis <miguel.luis@oracle.com>
To: Zenghui Yu <yuzenghui@huawei.com>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "joey.gouly@arm.com"
	<joey.gouly@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Close the GIC FD in
 arch_timer_edge_cases
Thread-Topic: [PATCH] KVM: arm64: selftests: Close the GIC FD in
 arch_timer_edge_cases
Thread-Index: AQHb2Fu7cV7hmWwe90aMWHJ1bMeusrP9uv8A
Date: Wed, 11 Jun 2025 09:47:44 +0000
Message-ID: <ED8F673D-D858-4E84-8480-80554A0DDA9B@oracle.com>
References: <20250608095402.1131-1-yuzenghui@huawei.com>
In-Reply-To: <20250608095402.1131-1-yuzenghui@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|SA2PR10MB4444:EE_
x-ms-office365-filtering-correlation-id: fd4aa8ef-7eb9-44e1-4b45-08dda8cd042b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?1wW/gg7penpVMLQN1E6XOvMuEfuVDgwb7jQzyo7VBExxC7wNI72t7YkNBgT3?=
 =?us-ascii?Q?ATv8BXMOTvqqix8LkHrZNZnXuH+nL2v5vrjTlqoUUB7NWYwDpznAPAhYG0qc?=
 =?us-ascii?Q?+3kOEMbn6HqmoYNDtctY6yN71NBEJDWYfgJ/MTg3hQoMd1TY5wV3sbO6maOQ?=
 =?us-ascii?Q?HSNY5ozPtF65lQXPfdBilgtpAVdyJ6eX+zNpHkmHru+MPS9y0ooGihbHvnCg?=
 =?us-ascii?Q?As8+pP9M77sxLQ842PygSimmEXSPimR17Qky00LPSoHlP6vyTDsZkLw/Cszk?=
 =?us-ascii?Q?d6ej3q7PB4eKbv3kP3W0guVMuMXACDGKvhbNOJQJksYbhFhQlJ0jXWSPJqEW?=
 =?us-ascii?Q?JBfw+6ZlG5aGV1sT8NO/Q8xY1MiEEl+oGxoAre9cFNrJOJIMXPaqE5+KPt7X?=
 =?us-ascii?Q?Jsa5jtT0UjwfHr0LI3gwPGOKvQiVTOQacOk80mhqfCabks5IGuPruMN0Yml4?=
 =?us-ascii?Q?tOlwwDBI3C6ViV2mOFvrKuFU2pUQVRGWSiBNSVZxI7rBqnWEmNeHAthN0ilv?=
 =?us-ascii?Q?+YKytO7olI3PVCbzlPRhs1oCcRmZI/OdmJEMDVTloIWsdqESLizHM2V9Q7q8?=
 =?us-ascii?Q?mfBhzgLL07kngiddNSCJluNbySiym1EKpj4FXTPh+NSFJb9Rd4wWYy6IkSds?=
 =?us-ascii?Q?9H5q8tCIrLf/jjWUI+qj8+8VIXP+E6PzoxPGBqAApGVh9nivvA5SMdXiAPuY?=
 =?us-ascii?Q?ciO2o9SF7DolZ23p3AO+ZSJ9wCoT2hz3wMe93H0gRgP4tIOFANBaHHmLMy57?=
 =?us-ascii?Q?TiF5MEqdSoqmNE98wEHivOnbl9jwK1XEKdvF1ZU2kDHsQ3HLMfvGrDfLE5XB?=
 =?us-ascii?Q?PgM2xJtJHUOjYjNL/4c4Up2ho2rT4HDV09IOjveZU/haS8uZtaWOzRSG+07h?=
 =?us-ascii?Q?4sHeh682r/GnI79XtwVv+4pSjMbfXdDuAiGYVwK3G1LEFa3dF4riFZOuH9/V?=
 =?us-ascii?Q?8CO3oNEtIFsJANVFlUj42swcDQdMftxSexNpJUR8VNy3w4F9Jl2Q8DhDvy8h?=
 =?us-ascii?Q?WXBjCGfLjx0xv1JaUtb9w69przpcPwQEcDyyzS2N4kOxoIHlkBf+rkf76RLz?=
 =?us-ascii?Q?eU305TvUgbQxL4hTYRGykHNOgk2baDj8q8lIHXyP5Gkr44jVa+6IQcPB+0ak?=
 =?us-ascii?Q?bqe/MC146Pt6nZLR/KwB31aw5fETEZ+jMbJwnzpxWti+LXMeC7TLu8Sz5Spq?=
 =?us-ascii?Q?ZRSLAApNvhhAp/YoOgREmOzIarXzKnvd7O3h7UWHHj4nRMm2r6DwD5+qv0r4?=
 =?us-ascii?Q?DqStCDQ9LJihogkJvA2NZ1shUDZIvA95M1QfW/rgq3T/mKyR4rk8A7vyvOew?=
 =?us-ascii?Q?RW/U5VpV1zTY1m+fmp+fMHI9qOszuGHqB+NJgFv07zVz5fNxy4tjJKFryN6q?=
 =?us-ascii?Q?Tj/4e9p8Ivc8f/TnOWkrp35syAJF5v0aWXkj1RKc5KFZv5f1RlsaFnqiE8ux?=
 =?us-ascii?Q?wg3RueQVErxPmK6OiOFTQH3iQD4Sq7uF0NWCTU/rpSL97549i7p+7zIa1lzV?=
 =?us-ascii?Q?5CL5XcbKVS9OUCE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?GngAIFJGTPI8hFMzeAjbqfOB10x+/FhX9yTEox4uDmcncub9/7H87PeKrt6/?=
 =?us-ascii?Q?vw7iBgHW52GDIgUnFCQ+9IIMn5E7/RBm/+mXfarrz/GLIwlRqLnlWy+oHk+H?=
 =?us-ascii?Q?FrD5TZJ7vGMzZFlTa61Z99lBeK3TKSQKsg1DMoG0T+kHhSd7/wuG9Lbg98vU?=
 =?us-ascii?Q?ierlhj8ooI4ZvYb9AowEiL5eUL/sa7cBcs2ZPkK1xTp5BNavS7kzew83cVgy?=
 =?us-ascii?Q?S9NYVyTmWsrrp/KtQ22FcAYRppP8Zn9FEotaVH0WanTglqGZALpet+dj9x/c?=
 =?us-ascii?Q?YsaE4pjLEH4DsAOdsS1UkQ1FUrUdcqtLUDd8JU/gA45mvhfm4/7T8EUiKwj8?=
 =?us-ascii?Q?A91PXD4eq4mx5qSGD9S679Uh5+lJdebiRh25db/IM32TN+iWtlwY2dLi1srl?=
 =?us-ascii?Q?xYbTWu6ScNm5LoPkZ+eQPOY42YtnQA8RG7b6NYb2J8FUeMWbCRPqBJBuJNW1?=
 =?us-ascii?Q?BJ7XkyCU1Uho4nG/fhuem+wCrvZ8NbEfaTHoTxsXHYEK3mQ31HDrqEYVRmOs?=
 =?us-ascii?Q?4n0nPYMqHoPrGyBXZpE6DbhtX/ReaespRTkOd90l+Rewnwpz+QS7xzvJG1sS?=
 =?us-ascii?Q?PbvqHeHAzCLv+QOh9/VflT1rghQfflbvO+r8wbbblfgkqW/7rmeJ1dap0znt?=
 =?us-ascii?Q?4qbTA/Q3sx3EahyRQZevDxKYENlTvBydRpYKE3wvl5JbQekj13vXu2G/t6Nd?=
 =?us-ascii?Q?UzGLvlGIynZ4H5a9nyryP+WP4LxDO17akxBvLYKTPeBff1wqqqEAWxiHvMQB?=
 =?us-ascii?Q?64BXnl0DhzIgc8W6WK70H2VOX6BhdqUq8SLApSGoYd+w9QnHDuHa0c/+/8oX?=
 =?us-ascii?Q?gdLchHGiEfuq0Lfe2giZQHIR36KDxl/ttuYky/8tBEbW18QDJjVSPa9sSEpa?=
 =?us-ascii?Q?WqI20kO3q8zZpvnUt6p8bQrscF4B8M9ZL0cmq7Fbu6tDUQM73M8k+/5E5owd?=
 =?us-ascii?Q?lgPPV1/gncC+e4aWNDBbaPWW/dhtDBreBVqaCinVY0BfhGFAQZmvIP3ZGp/n?=
 =?us-ascii?Q?itZVHqGJ0fOnX2bp9WEoUK6mowqQON2Q3uoi0hwsUpF2zqB6gQilYLcoSGJO?=
 =?us-ascii?Q?4SeHu/hK48lUZD2AkNMUrHumIb6prImUbceiI4I3CukmdAlOw6jKTp3oie/g?=
 =?us-ascii?Q?eFwCea1FkuHzrs3xK+8xxs7pdcg5TXwqXMYq1Shc37ZRk1m9IDoKKhxKFqTu?=
 =?us-ascii?Q?b+2lml+02s/CpV25gCpg7skvQE3vAfaHu628ZBKl+1kNfkSpmlwpw3zDEwP7?=
 =?us-ascii?Q?DzTIE8mkJ+eLfe0lpwNe6jd6h7l7pV8W5KpvlGZGua4qiecXUP/Ex/CfZ3Jc?=
 =?us-ascii?Q?DPffxKMc4rMxjJtG4jZo0QY3zo4CFn7W+ZorwfHPtGTSKP1GI/Zn/eFqTfmH?=
 =?us-ascii?Q?W+sXjl+MGJS28IC1UkTfnfwas4NyAVnlF6Fyhs4oTfv8k6qkI5fQrk/vxoF6?=
 =?us-ascii?Q?QHJdpm7hocf8Qcwy9yAgOdAVRgbWUHiieiMFUMGdOH/Icj8H1iJhOfakycOG?=
 =?us-ascii?Q?GasIieNiqO0kk1Q4lPBFUpiPdb8KO4+SzA6cAjD1dTP3uN6fUuPsacnppy3S?=
 =?us-ascii?Q?89gCeoyRsngd84bM59PqRNoZMuc/G3seiIYIHp29A4xtBkxl86KzFj2C1Wlc?=
 =?us-ascii?Q?Mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F9828A309EBE83469689DE30B3182F24@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/yG6O+QOiUVNOiM2sKYGZPjeGkqmX92I0Np/YN+RS1S95Ar8wFDvYgtzF6vy/0TNi+jdLV8ou+SocuV0G2EQWATL8PgHZtoAvTtb2Cu0nSJACB599k4BqbFpvRCh3T4vkVlKjPIx9nhNnjvSFNM1zKOoU6H2tY/I12G4a0L9UEL7I9+6QYMsCss0OIw4PW7UvVLqoag6LbW5NaVoh/9Oc1+2JODeRe/sJZ1gTq68tBvSfzOt6psXVenCNpetD3tTLvRMPkS+6oGFPS16hEqLTt65vrW2SaR6XZTZ+UNYMobpkJCPpW12Lc1469GV5ceVUnwwnKJrww28Rrz7rIfy/1i5CgcN4zmbhlo5D9S0XFBu0qa5yrsnU8PpJBw3n92GOrovsPGx8/uz5Z7ohmCZG8+YcuTEhM345DlLo1VxVW3+WNhD3W3YfxdfNb6v3HaVtzrFb8duI0tRVlSaM2h9H0xbM4vbbKmeLsV2lFIlc2v5949/C1oxhS6uBEQ39FzycoBVmtvJsLG8eXYXln3lvDo8z9owCq0sHj465dE+XYugY/41mMybwq7rasQL48VLamP6SQ3Tb1BIw5jXwG8yTF6xg9oNbHPaFo3MJkrOYR8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4aa8ef-7eb9-44e1-4b45-08dda8cd042b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 09:47:44.7933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f2K9AVhhTu/AJ7F6xCK2lrDIaU8Y4b+BIRB6wkwLBkpSiYh3dJEa/b1ckoOcWGGQ25lCbSeT6foYePbN7pkyIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4444
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_04,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506110083
X-Proofpoint-GUID: nIf0h3aTuN81HRtg9IGyyJhRfImJRmRF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDA4NCBTYWx0ZWRfXy69b4vUxDeAL ciOG83vE1zmP4LBHUpKsFyOza1HA9rU0IrbjInTLT2WnWgW5z1cKVAqvgiGnI1unUZ8INnIjPIz pfHInYcYF6BflvC5i3tuLQPfWSFzO8CyXmuiR1+mbkpyBDOSMQaAf6Rhpe5lhKQCKf5Fqmo7hmY
 RCk0U2pzs9yxIJluVIbRwEHJw0ocON0azrq42mV+4xDirTEZIIhnIuZLfD7XeKmFwpdGaqk+jfY 1FWYBzaLoTMRajUmcl0jX91hUsfZgdrguHY7cK7BRKfjmnTnp8l9/3uwhNwMgA1Gac36QxTOtX/ I2j3VQReQSpeU2cIVhJG65fJPhhOwCWyYMyPRg92E+rrGpaFrd3VSx5Z4Ei39ALtyAhMBA8Zsg0
 YGAYesp+JthDjfc0R7/dauJcH67/kbeNPmFkfkplKQzHCoafg3yZhuLLRmaRchJ+63hHfB8e
X-Proofpoint-ORIG-GUID: nIf0h3aTuN81HRtg9IGyyJhRfImJRmRF
X-Authority-Analysis: v=2.4 cv=d731yQjE c=1 sm=1 tr=0 ts=684950cf b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=ocv_ZMxW3qFwQwy0XVYA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13207

Hi Zenghui,

> On 8 Jun 2025, at 09:54, Zenghui Yu <yuzenghui@huawei.com> wrote:
>=20
> Close the GIC FD to free the reference it holds to the VM so that we can
> correctly clean up the VM. This also gets rid of the
>=20
> "KVM: debugfs: duplicate directory 395722-4"
>=20
> warning when running arch_timer_edge_cases.
>=20
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks!
Miguel

> ---
> .../selftests/kvm/arm64/arch_timer_edge_cases.c  | 16 +++++++++++++---
> 1 file changed, 13 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/=
tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
> index ad882ec8ff7b..b75e506324ce 100644
> --- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
> +++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
> @@ -954,6 +954,8 @@ static void test_init_timer_irq(struct kvm_vm *vm, st=
ruct kvm_vcpu *vcpu)
> pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
> }
>=20
> +static int gic_fd;
> +
> static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
>   enum arch_timer timer)
> {
> @@ -968,12 +970,20 @@ static void test_vm_create(struct kvm_vm **vm, stru=
ct kvm_vcpu **vcpu,
> vcpu_args_set(*vcpu, 1, timer);
>=20
> test_init_timer_irq(*vm, *vcpu);
> - vgic_v3_setup(*vm, 1, 64);
> + gic_fd =3D vgic_v3_setup(*vm, 1, 64);
> + __TEST_REQUIRE(gic_fd >=3D 0, "Failed to create vgic-v3");
> +
> sync_global_to_guest(*vm, test_args);
> sync_global_to_guest(*vm, CVAL_MAX);
> sync_global_to_guest(*vm, DEF_CNT);
> }
>=20
> +static void test_vm_cleanup(struct kvm_vm *vm)
> +{
> + close(gic_fd);
> + kvm_vm_free(vm);
> +}
> +
> static void test_print_help(char *name)
> {
> pr_info("Usage: %s [-h] [-b] [-i iterations] [-l long_wait_ms] [-p] [-v]\=
n"
> @@ -1060,13 +1070,13 @@ int main(int argc, char *argv[])
> if (test_args.test_virtual) {
> test_vm_create(&vm, &vcpu, VIRTUAL);
> test_run(vm, vcpu);
> - kvm_vm_free(vm);
> + test_vm_cleanup(vm);
> }
>=20
> if (test_args.test_physical) {
> test_vm_create(&vm, &vcpu, PHYSICAL);
> test_run(vm, vcpu);
> - kvm_vm_free(vm);
> + test_vm_cleanup(vm);
> }
>=20
> return 0;
> --=20
> 2.33.0
>=20
>=20

