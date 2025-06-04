Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CE23FE4
	for <kvmarm@lists.linux.dev>; Wed,  4 Jun 2025 10:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749034100; cv=fail; b=R8Z7skd1XghDLGVmLodQoiAaPDwMsMWcxg66u/VVuDB0DXuk8ESyvEOfE8iWsknhLotZyGPvdNzRmJpDInz+8HBLx/ghJn7r9nwNppsTwV1dB0PKW4l/t0nbKuTJEBDUzzlFUYJw4kTRx+P7j1RBy65szggB7IFEd7V9y0LGa2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749034100; c=relaxed/simple;
	bh=7dbNuNWl58j5ymHp8pVAjZZ8yR9zeDQgG7/Jok9eHDk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OX/pRC+nz13ZIjEzubxs5xYBLKJPCssiB0Qb2Z50fSJv4z1x5oUJAUZpc5Nk7tQLGqrhkhTPeVuYWhUHfdaTgiyNjliCvhodOgL5o8q4xFG7pJ93mQ1dOdWGHXgfUsaWd35LotuKtUl1SOd7qx8N2D31B43Fo0II5kxUnJXTshQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H+hLvOfL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rSDOlu7c; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H+hLvOfL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rSDOlu7c"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5549Mbpi025539;
	Wed, 4 Jun 2025 10:48:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WZ3P5u20fS72yca7sUq187fDm2IUgmzBz66sSpGk1+c=; b=
	H+hLvOfLIYWDN4dG4HhO7jr2uMfPclEN9zhGmDQhgFuY/F5lMtdyfkb5kEynKcUU
	4jyRXInwBwowUYl9dklVDvA9ZsrLT/QvNL7u1GMcMOATYpRz7CSU3KRIu3/yb7ZX
	/Eno5HawVhOm+B4FnSla0htoDKObl43BhsnExsOsq/l2QOPIzIrJ34BEdtPZ5w0/
	nYGSlS0H6wnDDVfEIfjB68ZiOwqbk6/vhaPFeKsU4I7YpL+r21ugIuKsyeO7oSX5
	nPuvAtGjZzAffLvzfBMdilJshqhWSrJxssD6zUGj8E1gjrYcgKK4rOrh03YHBJ7m
	OmtmP6y2Jjk1uRiLfgp1Tg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gahbsmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 10:48:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5548l4pq033825;
	Wed, 4 Jun 2025 10:48:00 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7akjq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 10:48:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OutIUR0cr5VuWmalfrifN/hWhwNqCFjFzdDcVauKL1Td4txxVmg3Uk5QuD+c8lT6fpBNLijdl1vB6I1qbPaMDozPaASmY0EfCCrsDgz+VGTOVTpDIBvgi686r01y2QCo9T2OCCBOt4+CZWfrx80G6FusUmmHCrDnGtqspawaBksPfa8cpzBPq7ZrbbNCC3SD9/IU82mCYSYLUgDWWV0UNGpfu1+b6TYMc/R/kN9KgBzQZBAmhC7SOcBwWAsGo4POQ9OwA2ef4Q8c3ajeHMYbF1P8N+sB5SvDUXH8pgsANit5SqF7iCQbVWjJzNMoP5VZ3QuC/pJ42cqH1No8JSMGoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZ3P5u20fS72yca7sUq187fDm2IUgmzBz66sSpGk1+c=;
 b=Y28pam5EI/YBdwN00SO56M2yFNm6TKbeRLE8oTdNYHJX4U7a/dQSaMClmGQAxWgkZWPuCld5pnglqrG2nANnC5aqbY/MNe3IaxdYQvSrLiLeDd9Bx4HqiWJxc9Na7MvQw5jZwXdBy/BMwHkH5J0syq53blAty8bHnf9bv0zWlkxcqjcSp6b40F/nOivrn1h2kapCVQNVofjdtPMiGHdf6B03BmsxhWYfeAZUUKyLOb9McIjKMX/FCeXMRLbTw/O2nrQoct6/ziyRFB926QUpUS1bsSYoTomGDTxt6rZtJ0fqj/UWLKTtIhQgriie199r7bORn9ZA6xiUbv8xji8kxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZ3P5u20fS72yca7sUq187fDm2IUgmzBz66sSpGk1+c=;
 b=rSDOlu7cyktPQMehreNl5XHg3k2KQTEVQ2HGniAhPPcvaVwbkH2KpNtf7pg0NeGjOrFZpN2sBRoC4WUmOzbB8FAZMaKVKeiZML5TxeJvcfg6Bk4X4/ARxUGVMEcEFhgWiEiFkZVQtcJQmsD6wuylP3ce+/JvWL2Ey2vX5DaGEk4=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.40; Wed, 4 Jun
 2025 10:47:58 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%7]) with mapi id 15.20.8813.018; Wed, 4 Jun 2025
 10:47:57 +0000
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
Thread-Index: AQHb1FZzymAUnIIEoUuFA1EqPZKnrrPy04qA
Date: Wed, 4 Jun 2025 10:47:57 +0000
Message-ID: <2264D21F-C28B-4523-9132-A53EB8ABFCF0@oracle.com>
References: <20250603070824.1192795-1-maz@kernel.org>
In-Reply-To: <20250603070824.1192795-1-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|SA1PR10MB5784:EE_
x-ms-office365-filtering-correlation-id: 3d1fa57c-f421-41e1-7063-08dda35544de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700018|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?3LfS9LsEtvr1jc9Xke5eIghkfdYUuka9vNciPNfLZnSajbV+3fkYaTuQMZUZ?=
 =?us-ascii?Q?VHQyACsyPgCuLb3fTyUx7afGXHt/VJjZM52TtvDIzbhkzi3lSOUSROEGZ0WU?=
 =?us-ascii?Q?xLebN8WEhkSkHiJ8yP5MpkUvxsRkZ9mGG31yWOD+sxC6niZnGH3r4X1sO2Ff?=
 =?us-ascii?Q?dBlu6jR3t7SdePLPFRVjLlU9EL+g18ys2tPZw6Hte1FhmBUwADmjIbBhnFCp?=
 =?us-ascii?Q?uaKg/M8UinvjI5aOhPkDqb9Zh0DKhDHrJuDlCp/F4ApJoMb/TSRh73Y6kS9V?=
 =?us-ascii?Q?SEAEapD4IGBGYO7hmOfQjgNpLMvqpObX+W1+qH+josibB6XPZPjbuZ6pJJM9?=
 =?us-ascii?Q?dtTj5q1K8/nfzuWH89J5J8LB3nq2ggbvE84XTRylOopOWRtFj/MVcZ4hhQuy?=
 =?us-ascii?Q?x8gFU2NKQqMtpLkTMUWMmHfiQawV16hnmRbvLsPVuRNTLuUThclWrj5S3WP3?=
 =?us-ascii?Q?5s9bmsYuPku9O/SStryjaklzO3GbQS4gOsUYjeXoj7++LkdlAw5GoGyoOhkl?=
 =?us-ascii?Q?yxHZbXbXMT8vjzaUKmpRdwEZqRZq4X8vWIa8gPVQGXfz60C91eN51yVq8u/c?=
 =?us-ascii?Q?J0c0bLBfiyUmV2dcCfAM+3Jo+9c+tmqvS1c6itydfxKbxnBSl/zQR9I9NSrh?=
 =?us-ascii?Q?xqWNrld8DLFtlMygG0DR/4p6zzCg2YYqOhc/CM8Daq2tz+VxZS9QLrUT1edD?=
 =?us-ascii?Q?J7vwTBMlwn8TTPpsbN2/hR/pnh8XblI281InCYOtCkyZXaHkViBGk/MMZH8f?=
 =?us-ascii?Q?sU/aNAGJvZCZLqBjMxyGvs5/vswC4/Xa9mUwI9bE17AUDGUE8pR/jsgzspqT?=
 =?us-ascii?Q?ZEi/MxeOoOObwnZF5pgzaSpSV6hRHkAc6/yvuNbg3Fdn3dH0iXrazsKPvNCM?=
 =?us-ascii?Q?xC7vg6TKq5Bvm52syL8nq88K5c82D2g6usbEZkfoI/hnZqwgr+r/JzPdK4Cd?=
 =?us-ascii?Q?175K3a2A5QGXPbQdh430cpDQPnt9tpjWDLH0369MdxzAPHc7sFm9vJuorXgM?=
 =?us-ascii?Q?n/rZXnHcd08GplZTpna7yK+zyy89rNLjJxp6SaadLemam2E4oPBQ3PcKVHI/?=
 =?us-ascii?Q?hfU3EGnM4I+3HFunlv9KAptEW0YOYQK2y1OxC9BIBwjaMFkCraVwd6R8zNKm?=
 =?us-ascii?Q?El9ABANaxeKBO/3Ie/Hf9xf7wQHD1eFGssFPsLfSs1xV1Wnqfirtyb+0bq49?=
 =?us-ascii?Q?AeHAUPajjmhcFjzAKuC4Ww9Bfr2YvtFDi/1vsVD5LcpXQbdYPQRxjq9BpXvR?=
 =?us-ascii?Q?tlKsuZMw1MOjb8SfnN+ITvp/A13mXgD7a57grIGHb54fCN0STTNvGgdxio+v?=
 =?us-ascii?Q?BkNsg9ey1w8seR8GAB/Xd6OBza76pKJvtqBwNfrVb+3JUmR1Nz0aAYumi15r?=
 =?us-ascii?Q?v+kZqJTbR1p+GcAN592IyPaLDezQyWRcSoRQn6PeDTbbajpkrU9v5phzV/Ao?=
 =?us-ascii?Q?EWkPnUPklSwX01ESR4WGC9Wlye2v0OJPV7U9XXNF5doO+f1Y8Pwf1w=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YrH2bLv/ASeVhYdeHBmBOzc5pWFP/wNP5bubORk4C3dEfizgF+TFGB7gsy07?=
 =?us-ascii?Q?TcfekUeRJjIgitjuWowEMe3GfxCOzLPTrG3nKN+VZf4i/FHRXOMVZI21B505?=
 =?us-ascii?Q?jCzxdSqTrkiHw2n0jUbOq1XU3QxNhASMiymJFkPFUZDGpBCecykvybw3dSyh?=
 =?us-ascii?Q?Jv2928p+3fcgOI/VF/7vxYH/MGmg+Rppl1vjl246ly/MxQYyVByvrRmV4CXo?=
 =?us-ascii?Q?+ndsVZsZGKiOA4y7fwVWo9tK5eqgSVKh23Mu0JqHaJOo7xE0oWyaGzIp4VcU?=
 =?us-ascii?Q?33ooTEpjpoW4PBe1vLe2LENLDjwj+khBfVw6p0IkbJpQpte78DjKg3QcCeju?=
 =?us-ascii?Q?W7+OoDn7CE/XLoyRYBYu2c8TC2H3K5wEmv1OSuInPU1UpzKlpHf6ILMySO/+?=
 =?us-ascii?Q?FMdWZe/OtrU1XiqUBEpX03ZoihSYyxJ59zcDUSyMIStZ3047kSslzsvniX3H?=
 =?us-ascii?Q?S6oulAMDW48uv5s+QOusKZv59JEaMJL+ynDUphFF2eZQUYAF0aP0jW/5Qpu8?=
 =?us-ascii?Q?Mjf9kSq90dI58ChQpAEHJyT6STR361h1mJ8WJh+G9EUejcBzE+RTo0epmpHN?=
 =?us-ascii?Q?HJ7c62Xja5XD2nmGh1x9oMK0iVgxrWk0U6Spjpy92Yq3R6xxzAe603YLBMt/?=
 =?us-ascii?Q?URLP7K03/bPaTuZieT1zyLKCyrK3eAKggwGbiYkxApa2PfGYLZIXkIUWHwGs?=
 =?us-ascii?Q?LM5kQWwgXR4sLktC7qo+6yA+rfGwF74YeszHnLKDmGwFrdkQKwPURfL0daP8?=
 =?us-ascii?Q?ytZheYMgwP5pa1ZzLK2FQ6jjbXdfG6rnsn0NiCgnJHnMs0rSYLfkjaB4FunK?=
 =?us-ascii?Q?Up2UQWlRHEhE5c6UmBsvnqmXQuWLtZsxbx5oBHLyrPRvkjMA7TFvZayRdQzp?=
 =?us-ascii?Q?YxHNXQI9CjvhPR8STvbyT5F3TFa53BkA39+4i/VRPmSAgdzWkQ4hDRZd+ALC?=
 =?us-ascii?Q?livnVwZSLBEd2eWiPN+VAiCsyU7M70c3TpUqnhd7vZacSBuMlElvJ4TSsyJp?=
 =?us-ascii?Q?HmVuVFTpEw/+z7tk5W9XkwMDcX3imPvB6E1Pk8eVczEYHvsx/L5IKsyBcqxz?=
 =?us-ascii?Q?Gwet/odj0KaenW2q8fwubgGO+/5G5j4fbfJo9Tlry2VpPlt7PIdZ3cmjImUH?=
 =?us-ascii?Q?5gUCYm/adeR6N9nQnyawHm+5y4m3bP0y3fvmLmdyuHRCTh+2Ii50eeQf4gsn?=
 =?us-ascii?Q?1DlVVZh0ayZpfpnB41P9ARtUvTxlh1pE3a0iY0aaO/FlsPIw6m0etto6C6Va?=
 =?us-ascii?Q?ijj4nIJM3T2IHJSMJDQ2WhF4ENOBY6UYxDbtqsTkOXF6Xlc9C2losrAjgxjY?=
 =?us-ascii?Q?4wGndxVEKKAp/75Eo73GpgXvrnT87zeAVjwW97hkrUTJ4WOKPgetC3rBGqXb?=
 =?us-ascii?Q?Cex9ftAHh2Oe6pWoF0iM+lqLJlpg9A4tfrl1C0vH1eQ6a2j0k54USthtd/qL?=
 =?us-ascii?Q?PS5z9eRkOeA3UTejp4aSTueYxE+oD2mWnGG2i4+xs63zzzwX+FS2eA/YKxn7?=
 =?us-ascii?Q?2WqN2MTt/tBoL1hpGMk6trO6IXrLN48mA1dV4f+M9DCFJOmRWq83hlmgptMK?=
 =?us-ascii?Q?9bvcrgmPifnrcKJYgGSqT4KbFyYezXwS+agG4XEGedkRdf0gw1GKFEyvno4N?=
 =?us-ascii?Q?cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <046802A8BF2E074E8D6BD79718C5FB14@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6riq6s/sqpXKcm3AcToYoAmDGj+8oiHHEvLJNKJEej7Upr+QG3vfhV4wfiY09OZsaVzcASJEP+MvaTQkLKnhh/VpZijkulsL60QoNzt9BIErbn9s+/ZbjemwEdZMD2dkTYweMEA0I9gSZEEtMW4FjhBKQT+fiy9xJ0B1QCP0G1GCXdag3vn75Z/b9fQlqbWMQWZb/OEYk02ki3+CXHFASXFzKsC7ERhL1sbNqlDJmQavzUH3RSHGGtbSiUqbTMD7v6WeydmQjN3+Q1lyYw/8kc1E6bPnmgnEp5sbfz9G+jF+rUSxTQlFq49xuTgCFO48RUnWNf8bUzlcRuejR+UtZ+Uc4TKF3HOAgj9vwlaSSjpL6q13YYu1rqX3naiwCyTPk7/uwMk/H/RL1OEcLECOoH0+bCl2f3YLaBSnypOs6Xzm7WIagmn9UTOlgE8/6wMP4QqwjkShFGyg6XktCDlgs2Ab4XrF71TixQ2GG5h1kBqR6G+k8ySvBUc64mwEo8qrwPKjqH2CpBXhC8lGfWXwGppxpYwSF/n9bCtzJiyZbJJh5U7vr5iM/efp1tDYDURXVUmeTIHJldaMaB9MqIpDZuXq4YHn42zCQVnKb9AjZsQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1fa57c-f421-41e1-7063-08dda35544de
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2025 10:47:57.8885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Clb7y2HRNrl7kJHwp/zKmaUHK13UjHzP25SqiOn9B3f1H6LsHHbpx9NOg0yh6cDrNKSr3bCAR16kUAkPJ2oww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506040081
X-Authority-Analysis: v=2.4 cv=aqqyCTZV c=1 sm=1 tr=0 ts=68402461 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=fRXM2Ey1IjIONSgiO9EA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13207
X-Proofpoint-GUID: St8svMuAkJv0ywxo7iUfAC6H0eTD4fWU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDA4MiBTYWx0ZWRfX45sWsZTCQmXd 5G5tOaY3MrsBUTj6NcJg9LG/aNtKRI9YDyn3TFuK0X7zMf8yyNvlRZiOwdDDVxzUBaaCnQ68Rdi Y0sbW6Y+JGBgcZ+4byOwbZx+1Q71wfQAgLvi9AKPKMnHWq9gS3hi4IDq3lvnnNSUhkWqrXqCGeF
 YjCx4/k6ub02m1NHz2x07muwBzYH93IRn5DgUMmAGujR+g12fsg68NTL5SFtOhF2lHs5f12hllb laxcQd1f4QyKIPr/FK+CCDqHZJHnMajhrlDA+riDbXKdyAO4VepCP3WlCoKpc7EmTuTV5dfdRG7 dpdJZVyD/lYW0z+MFteOrcHrlE6FvtwDTV0Osim+p69a/H1ck3SfzJnOV9HPakSqMDREjRCQ7E0
 RVS58L0RiRAnfqfdGJVZpuwSqw0KepIueByyvOcXAi4jtpN8hevcXxSlaglCiO/m+6iXYkCY
X-Proofpoint-ORIG-GUID: St8svMuAkJv0ywxo7iUfAC6H0eTD4fWU

Hi Marc,

> On 3 Jun 2025, at 07:08, Marc Zyngier <maz@kernel.org> wrote:
>=20
> This series tries to bring some sanity to the way the RESx masks
> are applied when accessing the in-memory view of the guest's
> system registers.
>=20
> Currently, we have *one* accessor (__vcpu_sys_reg()) that can either
> be used as a rvalue or lvalue while that applies the RESx masks behind
> the scenes. This works fine when used as a rvalue.
>=20
> However, when used as a lvalue, it does the wrong thing, as it only
> sanitises the value we're about to overwrite. This is pointless work
> and potentially hides bugs.
>=20
> I propose that we move to a set of store-specific accessors (for
> assignments and RMW) instead of the lvalue hack, ensuring that the
> assigned value is the one that gets sanitised. This then allows the=20
> legacy accessor to be converted to rvalue-only.
>=20
> Given the level of churn this introduces, I'd like this to land very
> early in the cycle. Either before 6.16-rc2, or early in 6.17.
>=20

For the series:
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

nit: the rmw accessor implies an implicit assignment which could be specifi=
ed
within its macro instead but it's fine by me.

Thanks
Miguel

> * From v1 [1]
>=20
>  - rebased to kvmarm-fixes-6.16-1
>=20
> [1] https://lore.kernel.org/all/20250113183524.1378778-1-maz@kernel.org/
>=20
> Marc Zyngier (4):
>  KVM: arm64: Add assignment-specific sysreg accessor
>  KVM: arm64: Add RMW specific sysreg accessor
>  KVM: arm64: Don't use __vcpu_sys_reg() to get the address of a sysreg
>  KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand
>=20
> arch/arm64/include/asm/kvm_host.h          | 31 +++++++++--
> arch/arm64/kvm/arch_timer.c                | 18 +++----
> arch/arm64/kvm/debug.c                     |  4 +-
> arch/arm64/kvm/fpsimd.c                    |  4 +-
> arch/arm64/kvm/hyp/exception.c             |  4 +-
> arch/arm64/kvm/hyp/include/hyp/switch.h    |  4 +-
> arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  6 +--
> arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  4 +-
> arch/arm64/kvm/hyp/vhe/switch.c            |  4 +-
> arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 48 ++++++++---------
> arch/arm64/kvm/nested.c                    |  2 +-
> arch/arm64/kvm/pmu-emul.c                  | 24 ++++-----
> arch/arm64/kvm/sys_regs.c                  | 60 +++++++++++-----------
> arch/arm64/kvm/sys_regs.h                  |  4 +-
> arch/arm64/kvm/vgic/vgic-v3-nested.c       | 10 ++--
> 15 files changed, 125 insertions(+), 102 deletions(-)
>=20
> --=20
> 2.39.2
>=20
>=20

