Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011044.outbound.protection.outlook.com [40.107.130.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558CB3DDDCB;
	Fri,  4 Sep 2026 08:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788510197; cv=fail; b=tDbqCQpjh0ZNnnGDty6jCpI98dE/VIsZqYaLT2OD6lKEHShq/ZAYyi7flNuP8lRbrTN32k6FGh2yDXplOpW6jqbCWrFfE1LhnMbQjFmsjZyh+cY2FCoZe7zXTPBfYxFp4Hdb9EGpbj2OKOR5z6L5VUMYkjVDodSIpQFxNdM8C5k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788510197; c=relaxed/simple;
	bh=qpNZxwCWT26QoHCaWMFcsjwNi3ESnbGvcsCwGX6AXAk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SVpJtr7WZXSsKm9t9w0/+375Jv+mT0PrixK8yQGWsE13mwJxO4k+vU78XwlcvbrmiYgbUfcz6pvUs2cKafjda14JKhhNPn1Em+O6n99fDjPLGDIK61fPS3cuyDPz/o1Pchgh35SvJDtug91EUMTKNcZrBUjHeNeMG+Y++12grTY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iSdhCfdZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iSdhCfdZ; arc=fail smtp.client-ip=40.107.130.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iSdhCfdZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iSdhCfdZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=L32nfwWVUZcaELkXJmYMPxcM3E/WjqWz7zCFep4phuxrVxQ3f6HN5wIpTN7NjZCO82BlazJajmkYDyXLcFXP+PxIyaBF+6FAj/a7ubaKQcU5xHJRLpGRPWogTiHQUSsWHNdNJJD1ZCK5RjJvMCEWl3uf0nVsg2YK2W+F7wrXtJp+KCkXgbeOs5jylU/PFnjmBnEX+5v1jf4RD0BnAMS1gUrc3dXxFSGTsn9Sud/6O7VvP7OiKIU88it/fDyXp06mjXTGBSeN2kbOKMAS1v/hgZWEHt/GeStZ5+kZ8f1x2Pu7E84EahAQw7oeicv+q/6r8QZjVPQD1JuyUfhcT8tbpg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpNZxwCWT26QoHCaWMFcsjwNi3ESnbGvcsCwGX6AXAk=;
 b=hcJwdXZYS1cHuSPZVfxgdsPzCenYVC4bmZsBCK0Ros49IJMP+SLH9koUVyqrmdViC2MDWFL9bRFLWZgNM3371oUJJt4usy643fzhaPxPNY3XWV0XkGtFIA36moD/98ssYFaEJiCp9wLSHbUkhOElkhcECJH+EdBq/JRBoUx1Om0+NKdO0JM3MiL1Zr+7BAOWOm/Qo6YMOUCk9xtZKI5oIw1UJrL1DfBuvI8MAWlHQBohe9Wjh14V84zDbItC9lvB2CQVjqxk1+nbgduaLBLCBKFLqnxP/mP8+/f5EhXo3JB8nbLOwlK2Ccp7o4LELSilMXlf7QSHaIiLHmRL73giEA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpNZxwCWT26QoHCaWMFcsjwNi3ESnbGvcsCwGX6AXAk=;
 b=iSdhCfdZ5XQIsgMuiaICu3H47YkThacrq8s1xBNSg1EawtPvJZ0+s8y7ZUVFxW2PJv/uhqdTAyNGjwRwD/DkRs/O2nalLUlsjOwJu9ZPBSWekVc0Z1RF5Lzvo+CQsT+gpIuh0QxTRcdsx6VOvIdwUspPifCtvZ9Z0lnInCAQleU=
Received: from DUZP191CA0062.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4fa::25)
 by AS2PR08MB9593.eurprd08.prod.outlook.com (2603:10a6:20b:60b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:23:03 +0000
Received: from MAD0EPF000008BA.eurprd04.prod.outlook.com
 (2603:10a6:10:4fa:cafe::1c) by DUZP191CA0062.outlook.office365.com
 (2603:10a6:10:4fa::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 08:23:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MAD0EPF000008BA.mail.protection.outlook.com (10.167.241.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 08:23:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rzTbvmKgXBRgf5jYHlcfjfCY44Qit+PPUicgUsoXA656vqeCLfRPvfiPlBfJ0bnrn2m0l/QjFZgp8ObY7NSSj5mmfuMUrG43zxzZQADOB5c5yko1aGYpo2dPKVZq/jvkjxrQU/siUKVWgSMiCOj2+Z/C+i4HngDGheE6VNM4kcdkM1hj2pyE3CDEMDYxzC9mjnHua8f7Y7FoXy6HkLTtST2IeLvJHcw17yTYZd8sOHje/iv2sbIjTml0PRewGjYTdgD5MkO71IulBWb5sOAXpq5ypR79PEC9Vo5A1Z1g+0/+08c9SxAyuxsq97Y/3fwUqdO5bYnMEoZzwVNtFWDJDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpNZxwCWT26QoHCaWMFcsjwNi3ESnbGvcsCwGX6AXAk=;
 b=Ez6HT/ZNT5747R9cftyBEQYefnqigWwBzDBhWtrG9jJwQACT1eewcGUt0sIqZpPsS/J9PTqxtdUNSyOrOZnID3Gyb3i3dohvA98ena0gO7j2dagFAlueZ2DGPDJHGLcRsd4pTcmks4HCS2kFRiZPJbadmkZBkaX7eKvKgfQkn8axDTgeeTwftUYzfvI8ztXPMVTXe6FHLIz/Q8Szyj/xF9Mr5t8wYlnmBAAxnqYoYBx2bazfM1gRmdXICYco1s/dRz3mjsLy4cL96Q7rWAd8VLGmpK2UF68Zgq5zVQ0J/DLLHi0u5TU/nRlIkJUgVBqdW6DpYafCeSkrWsgg8BvPbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpNZxwCWT26QoHCaWMFcsjwNi3ESnbGvcsCwGX6AXAk=;
 b=iSdhCfdZ5XQIsgMuiaICu3H47YkThacrq8s1xBNSg1EawtPvJZ0+s8y7ZUVFxW2PJv/uhqdTAyNGjwRwD/DkRs/O2nalLUlsjOwJu9ZPBSWekVc0Z1RF5Lzvo+CQsT+gpIuh0QxTRcdsx6VOvIdwUspPifCtvZ9Z0lnInCAQleU=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GV1PR08MB10931.eurprd08.prod.outlook.com (2603:10a6:150:1f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:22:28 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 08:22:28 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 14/49] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Topic: [PATCH v5 14/49] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Index: AQHdJl6lx9MNaBreRUOkFnaJF1gqlLaSmGuAgCun4YA=
Date: Fri, 4 Sep 2026 08:22:28 +0000
Message-ID: <74e669ef58b36584574f14d941858f18c211197f.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-15-sascha.bischoff@arm.com>
	 <20260807134226.3CABB1F00A3A@smtp.kernel.org>
In-Reply-To: <20260807134226.3CABB1F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GV1PR08MB10931:EE_|MAD0EPF000008BA:EE_|AS2PR08MB9593:EE_
X-MS-Office365-Filtering-Correlation-Id: 05f6e612-b2fb-43f6-faf8-08df0a5dbc4e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|10067099003|56012099006|5023799004|11063799006|4143699003|6133799003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 u/EqSDfWtV7lqPbWgeXSc3OIM/Y8BhTZT4j7/PayPRoLjq8MND+aqL+wwSHRUoTDgoI7epe6szS2OCEvHqmf6V3k30KOMShmMB5tunTBhpncilga1RTdpqXHugMDKNxeLy4+R3IrTza2bfDMGCcwducF3FgCDNU7vSbyyWU9haKPsI5ZEbqifRoW8Fwnrm5s5s45QVWUBT8qHUQgzXcbG2rl2T6qwp8h3MkfdblZ50Onu7Xi+SstBkD5o+Li+/TOIiZ138eMDvATdkMyMWk9/+gt59khgcIS6cK6L4Xri8WYVSRKBoBzSVWiJPgPqScA1yVT1H1okDZRfiQ4gGS6mS/s6zx8VszbyEfE9NAG1xH8EahNbpqCBvwgH7xrfrunvbmkwf5HeibSgbdSmujekZaq6339sGjSZztMyO41zFgtDEEpO/p6cO70dWrgIimld1C4pmcTgD9Gl4iVD0ayPpdOHGFSjUHuj1O0yWt8WmQ7+xJ2rmwu0ZU7WYmtzt82GFczNfDbjlnp4LPtMiawyNtJ/IrokkQDnzCv0nULMTkpwzNWkJw/hs+T6mip8KuRz6ML4blCS6QRWTyxSzY9x5mB/RKMwdeu8EHRbElHnd/FdVHVWCeMoz9LJ7ejh7i/Rww/X1KLx2jM1wgt1APYFYLc+IBACBrzIaAdfO1TKCmPHwLY0o6HezgbsWdnqkePZ3taw3CmpCO6rzM05S3F2RpxBNufcDdGn57PN7T/qM8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(6133799003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F7B06A62EE32A46B6563E98A414E0C1@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 D5AhzY8L+kggsEBdsxmIHhtt1ipUO/TAPFVL6h1444WT1mASPnUv7QOvtMbeBUgCJV/nt7AXhQfQlEe/h5TdOPDXUiCDc+pRpEQU0JTuQLD9yUHpRxjTD3zRAeFizmwhD8C5X0+mX4hQsPx7rJ9nKFq3e8HyFQwYD5gY5+W1j4AHBKdL7pYU0YJbVIeYGRn6j8/DW5VCZvI6+otml+/nfFDGS51qXLa1zQR6EzNM1DIWAyCIriCw594XPvawm859K+fvTc1LcpzXFaQyKnaqZJIMazn2yW32y0lC7g9JgrH1pWYqivN7MojLRxk2S6duYQ6mf2ENG5m9l7JrwV4O9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10931
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MAD0EPF000008BA.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a3dfb41d-bbdc-41b0-819e-08df0a5da8a5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|35042699022|30052699003|36860700016|14060799003|4143699003|6133799003|18002099003|22082099003|56012099006|5023799004|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	oyrSQ3ZKpZqi2xYHGA9pVfzyVcW9ZG8+0njVfJz8lbK0oVFlF0WUsglxa2oglZkuDjN377ohn/N7BVp1eFSGtBS3krgA3aNPyfLhc+wIjxYEnoGikjemyMyxuoJgUb5z3aRJiuqScavZAewdHrBLBop/oUWMcnkxYoTjtxXidiLXpZe6E4wk3kJ590n2o11zamNZmIdtcnzlwbj3bfR4OS2VjPK/KRLoG6BpEPga9NN5/EqStAsTHdRQgCG7jmbE3OdITAftJlzS87bjFclSvHi2lSw3Zq2okm7eOVPYn0TmlMYNVkfK+CBwYW05bOU1gTu6bH8UznRCVhvTLeID6nOaJqFtwlAb5Qmrrcrm8hGh7S+UaGfRUYi26aVEXafWFcocPJX4lRsDzbi8rFAyQ1WlGW2yRZ4Lgu/Zk9jCwEZi+SpaBsHSf+y9RpYCVt/9SYeVakpHowpW5/Tiv1fAjdl1/Xy4YAEW1oTgilXjoQGdM4co99SxwO2waKavNGL35HwRaN0m8TpBqFs4CnQyiSG1DkdW+TWKkfvk65k2vx+6i2ppNID6qYWq8+Te1ooipdL0bPVvBRQx0GDMmUmdcCOWA4FlhHiA4EXoV2ftl99gFr+peWcEw+a52UnCPLG6S4SAQcSUx4pR2Ulwk0p5d984J0TsOqYKSY77nzxjoD8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(35042699022)(30052699003)(36860700016)(14060799003)(4143699003)(6133799003)(18002099003)(22082099003)(56012099006)(5023799004)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GQAs20tITESZHJbX1aFLxtn9YZ3nZWvmsFwa6h/LwUW7ynGoA+sLOrc5LYe+qbGRsM04m5onSW8I5eMxeliAP8tJJYAGK+Mx/R9tqi3yyWCmxd2kTjx+CIzdAoVOcItMq2LvZH93ieWiy4Uw1/PN8GtXqRANs3cHHO25lNWN/d1F2F/efEHgbLCY8Objz5uzECFUxz3vB+vQA0Am98LuFwtoWbOLcZX5yuFdc582t6eXK77yExWdPHLT7Kea0gagOVmuZ47kFsVgS6E+8TkJVOteDIsEUMePSFiPRbOWJ8i2OVPZsI3Uozj8sCmQuyQ3epFfZAfGoPEm7tHuTj6aXpkFrEQRp+qlDzUmdO7afDlEY8VBdwizyyiKmHPc+n6Zen9HI3pQ42rFI/QPlWwgNNU5WlIwTHPO+BlWtFx2qEjgxyElFTZnwpfrBbN24KQJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 08:23:01.5565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f6e612-b2fb-43f6-faf8-08df0a5dbc4e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MAD0EPF000008BA.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9593

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDEzOjQyICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gRG91YmxlLXRlYXJkb3duIHZ1bG5lcmFiaWxpdHkgYWxsb3dzIGNvcnJ1cHRlZCBWTVRFIHNs
b3RzIHRvDQo+IGJlIHJldXNlZCwgc3VidmVydGluZyB0aGUgZXhwbGljaXQgVk0gSUQgbGVhayBt
ZWNoYW5pc20uDQo+IC0gW01lZGl1bV0gdmdpY192NV9jcmVhdGVfcGVyX3ZtX2RvbWFpbiB1c2Vz
IHRhc2tfcGlkX25yKGN1cnJlbnQpIGZvcg0KPiB0aGUgZndub2RlIG5hbWUsIGNhdXNpbmcgZGVi
dWdmcyBjb2xsaXNpb25zIGZvciBtdWx0aXBsZSBWTXMgaW4gdGhlDQo+IHNhbWUgcHJvY2Vzcy4N
Cj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbMTRdOiBbUEFUQ0ggdjUgMTQvNDldIEtWTTogYXJtNjQ6
IGdpYy12NTogU2V0IHVwIFZNVEVzIGFuZA0KPiBWUEUgZG9vcmJlbGxzIC0tLQ0KPiBjb21taXQg
N2U4NTk5MDg3NDMyNDEzZGE5MWYyYjM3ZTUwM2EzYmE3ZTc0OTY4NA0KPiBBdXRob3I6IFNhc2No
YSBCaXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBLVk06IGFybTY0OiBn
aWMtdjU6IFNldCB1cCBWTVRFcyBhbmQgVlBFIGRvb3JiZWxscw0KPiANCj4gQSBHSUN2NSBWTSBu
ZWVkcyBhIFZNIHRhYmxlIGVudHJ5IGJlZm9yZSBpdCBjYW4gdXNlIFNQSXMgYW5kIExQSXMsDQo+
IHdoaWNoIGFyZSBiYWNrZWQgYnkgdGhlIGhvc3QgSVJTLiBUaGUgVk0gdGFibGUgaXRzZWxmIGlz
IGNyZWF0ZWQgYXQNCj4gcHJvYmUgdGltZSwgYnV0IGVhY2ggVk0gc3RpbGwgbmVlZHMgdG8gY2xh
aW0gYW5kIHBvcHVsYXRlIG9uZSBWTVRFDQo+IGJlZm9yZSBpdCBjYW4gdXNlIHRob3NlIGludGVy
cnVwdHMuIEFsbG9jYXRlIGEgVk0gSUQgZHVyaW5nDQo+IHZnaWNfdjVfaW5pdCgpIGFuZCBjcmVh
dGUgYSBwZXItVk0gVlBFIGRvb3JiZWxsIGlycSBkb21haW4uDQo+IA0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXY1LmMNCj4gPiBpbmRleCAyMTIxZjY3ZDNiNTljLi5mMTVhODMwOWQ3YTkzIDEwMDY0
NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gKysrIGIvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gWyAuLi4gXQ0KPiA+IEBAIC00OTEsMjAgKzUy
NCwxMCBAQCBzdGF0aWMgaW50DQo+ID4gdmdpY192NV9jcmVhdGVfcGVyX3ZtX2RvbWFpbihzdHJ1
Y3Qga3ZtICprdm0pDQo+ID4gwqAJaW50IGlkID0gdGFza19waWRfbnIoY3VycmVudCk7DQo+ID4g
wqAJaW50IHJldCwgZGJfdmlycSA9IDA7DQo+ID4gwqANCj4gPiAtCWlmICghZ2ljdjVfZ2xvYmFs
X2RhdGEubHBpX2RvbWFpbikgew0KPiA+IC0JCWt2bV9lcnIoIkxQSSBkb21haW4gdW5pbml0aWFs
aXplZCwgY2FuJ3Qgc2V0IHVwDQo+ID4gS1ZNIERvb3JiZWxsc1xuIik7DQo+ID4gLQkJcmV0dXJu
IC1FTk9ERVY7DQo+ID4gLQl9DQo+ID4gLQ0KPiA+IMKgCXZtLT5md25vZGUgPSBpcnFfZG9tYWlu
X2FsbG9jX25hbWVkX2lkX2Z3bm9kZSgiR0lDdjUtdnBlLQ0KPiA+IGRiIiwgaWQpOw0KPiANCj4g
W1NldmVyaXR5OiBNZWRpdW1dDQo+IERvZXMgdXNpbmcgdGFza19waWRfbnIoKSBoZXJlIGNhdXNl
IGRlYnVnZnMgY29sbGlzaW9ucyBpZiBhIHNpbmdsZQ0KPiBwcm9jZXNzDQo+IGNyZWF0ZXMgbXVs
dGlwbGUgVk1zPw0KDQpZZXMsIGl0IHdvdWxkLCBidXQgdGhpcyBpcyB0aGUgc2FtZSBhcyBpcyBk
b25lIGZvciBHSUN2NC4gSWYgYW55dGhpbmcsDQp0aGlzIG5lZWRzIHRvIGJlIGFkZHJlc3NlZCBm
b3IgYm90aCBHSUN2NCBhbmQgR0lDdjUgaWYgdGhpcyBpcyBpbmRlZWQNCmFuIGlzc3VlLiBGV0lX
LCBpdCBpcyBub3QgY29tbW9uIHRvIGNyZWF0ZSB0d28gVk1zIGZyb20gYSBzaW5nbGUNCnRocmVh
ZC4NCg0KPiANCj4gSWYgdXNlcnNwYWNlIGluc3RhbnRpYXRlcyBtdWx0aXBsZSBHSUN2NSBWTXMg
d2l0aGluIHRoZSBzYW1lIHByb2Nlc3MsDQo+IHRoZXkNCj4gd2lsbCBzaGFyZSB0aGUgc2FtZSBQ
SUQuIFRoZSBpcnFfZG9tYWluX2FsbG9jX25hbWVkX2lkX2Z3bm9kZSgpIGNhbGwNCj4gd291bGQN
Cj4gdGhlbiBjcmVhdGUgYSBmd25vZGUgYmFzZWQgb24gdGhlIFBJRCBpbnN0ZWFkIG9mIGEgdW5p
cXVlIGlkZW50aWZpZXINCj4gbGlrZQ0KPiB0aGUgVk0gSUQuDQo+IA0KPiBEZXN0cm95aW5nIHRo
ZSBmaXJzdCBWTSByZW1vdmVzIHRoZSBzaGFyZWQgZGlyZWN0b3J5LCBicmVha2luZyBpdCBmb3IN
Cj4gdGhlDQo+IHJlbWFpbmluZyBWTXMuDQo+IA0KPiBbIC4uLiBdDQo+ID4gK3ZvaWQgdmdpY192
NV90ZWFyZG93bihzdHJ1Y3Qga3ZtICprdm0pDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB2Z2ljX2Rp
c3QgKmRpc3QgPSAma3ZtLT5hcmNoLnZnaWM7DQo+ID4gKwlzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUs
ICp2Y3B1MDsNCj4gPiArCWJvb2wgcmVsZWFzZV92bV9pZCA9IHRydWU7DQo+ID4gKwl1bnNpZ25l
ZCBsb25nIGk7DQo+ID4gKwlpbnQgcmM7DQo+ID4gKw0KPiA+ICsJbG9ja2RlcF9hc3NlcnRfaGVs
ZCgma3ZtLT5hcmNoLmNvbmZpZ19sb2NrKTsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogSWYg
dGhlIFZNJ3MgSUQgaXNuJ3QgdmFsaWQsIHRoZW4gd2UgZWl0aGVyIGZhaWxlZCBpbml0DQo+ID4g
dmVyeSBlYXJseSBvcg0KPiA+ICsJICogd2UndmUgYmVlbiBjYWxsZWQgYSBzZWNvbmQgdGltZS4g
Tm90aGluZyB0byBkbyBoZXJlIGluDQo+ID4gZWl0aGVyIGNhc2UuDQo+ID4gKwkgKi8NCj4gPiAr
CWlmIChrdm0tPmFyY2gudmdpYy5naWN2NV92bS52bV9pZCA9PSBWR0lDX1Y1X1ZNX0lEX0lOVkFM
KQ0KPiA+ICsJCXJldHVybjsNCj4gPiArDQo+ID4gKwlpZiAoa3ZtLT5hcmNoLnZnaWMuZ2ljdjVf
dm0udm10ZV9hbGxvY2F0ZWQpIHsNCj4gPiArCQkvKiBNYWtlIHRoZSBWTSBpbnZhbGlkwqAgKi8N
Cj4gPiArCQl2Y3B1MCA9IGt2bV9nZXRfdmNwdShrdm0sIDApOw0KPiA+ICsJCXJjID0gdmdpY192
NV9zZW5kX2NvbW1hbmQodmNwdTAsDQo+ID4gVk1URV9NQUtFX0lOVkFMSUQpOw0KPiA+ICsJCWlm
IChyYykgew0KPiA+ICsJCQlrdm1fZXJyKCJjb3VsZCBub3QgbWFrZSBWTVRFIGludmFsaWRcbiIp
Ow0KPiA+ICsJCQlyZWxlYXNlX3ZtX2lkID0gZmFsc2U7DQo+ID4gKwkJCWdvdG8gb3V0X2ZyZWVf
ZG9vcmJlbGxzOw0KPiA+ICsJCX0NCj4gPiArDQo+ID4gKwkJa3ZtX2Zvcl9lYWNoX3ZjcHUoaSwg
dmNwdSwga3ZtKSB7DQo+ID4gKwkJCWlmICh2Z2ljX3Y1X3ZtdGVfZnJlZV92cGUodmNwdSkpIHsN
Cj4gPiArCQkJCWt2bV9lcnIoIkZhaWxlZCB0byBmcmVlIFZQRVxuIik7DQo+ID4gKwkJCQlyZWxl
YXNlX3ZtX2lkID0gZmFsc2U7DQo+ID4gKwkJCX0NCj4gPiArCQl9DQo+ID4gKw0KPiA+ICsJCWlm
ICh2Z2ljX3Y1X3ZtdGVfcmVsZWFzZShrdm0pKSB7DQo+ID4gKwkJCWt2bV9lcnIoIkZhaWxlZCB0
byByZWxlYXNlIFZNIDB4JXhcbiIsDQo+ID4gZGlzdC0+Z2ljdjVfdm0udm1faWQpOw0KPiA+ICsJ
CQlyZWxlYXNlX3ZtX2lkID0gZmFsc2U7DQo+ID4gKwkJfQ0KPiA+ICsJfQ0KPiANCj4gW1NldmVy
aXR5OiBIaWdoXQ0KPiBDb3VsZCBhIGRvdWJsZS10ZWFyZG93biBpbmNvcnJlY3RseSByZWxlYXNl
IHRoZSBWTSBJRCBkZXNwaXRlIGENCj4gcHJldmlvdXMNCj4gZmFpbHVyZSBoZXJlLCBhbGxvd2lu
ZyBjb3JydXB0ZWQgVk1URSBzbG90cyB0byBiZSByZXVzZWQ/DQoNClRoZSBjb2RlIHdhcyBtaXNz
aW5nIGEgZ290byBvdXRfZnJlZV9kb29yYmVsbHMgaW4gdGhlIGNhc2UgdGhhdCB0aGUgVlBFDQp0
ZWFyZG93biBmYWlsZWQuIEkndmUgYWRkZWQgaXQuDQoNCj4gDQo+IER1cmluZyB0aGUgZmlyc3Qg
cnVuIG9mIHZnaWNfdjVfdGVhcmRvd24oKSwgaWYNCj4gdmdpY192NV92bXRlX2ZyZWVfdnBlKCkg
ZmFpbHMsDQo+IHJlbGVhc2Vfdm1faWQgaXMgc2V0IHRvIGZhbHNlIHRvIGxlYWsgdGhlIFZNIElE
IGFuZCBwcmV2ZW50IHJldXNlLg0KPiBIb3dldmVyLA0KPiBpZiB2Z2ljX3Y1X3ZtdGVfcmVsZWFz
ZSgpIHRoZW4gc3VjY2VlZHMsIGl0IHdpbGwgY2xlYXINCj4gdm10ZV9hbGxvY2F0ZWQuDQo+IA0K
PiA+ICsNCj4gPiArb3V0X2ZyZWVfZG9vcmJlbGxzOg0KPiA+ICsJdmdpY192NV9mcmVlX2Rvb3Ji
ZWxscyhrdm0sIGF0b21pY19yZWFkKCZrdm0tDQo+ID4gPm9ubGluZV92Y3B1cykpOw0KPiA+ICsJ
dmdpY192NV90ZWFyZG93bl9wZXJfdm1fZG9tYWluKCZrdm0tPmFyY2gudmdpYy5naWN2NV92bSk7
DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIFdlIG9ubHkgcmVsZWFzZSB0aGUgVk0gSUQgaXRz
ZWxmIGlmIHdlIGRpZG4ndCBmYWlsDQo+ID4gZWFybGllci4gSXQgZG9lcw0KPiA+ICsJICogbWVh
biB0aGF0IHdlIG1pZ2h0IGxvc2UgdGhlIFZNIElEIChhbmQgYXNzb2NpYXRlZCBWTVRFLA0KPiA+
IGV0YyksIGJ1dA0KPiA+ICsJICogZ2l2ZW4gdGhhdCB3ZSd2ZSBmYWlsZWQgdG8gdGVhciB0aGVt
IGRvd24gY29ycmVjdGx5DQo+ID4gdGhlcmUncyBubyB3YXkgdG8NCj4gPiArCSAqIHNhZmVseSBy
ZXVzZSB0aGVtLiBUaGUgVk0gSUQgYWxsb2NhdGluZyBJREEgd2lsbCBtYWtlDQo+ID4gc3VyZSB3
ZSBkb24ndA0KPiA+ICsJICogYWNjaWRlbnRhbGx5IHJldXNlIHRoaXMgcGFydGlhbGx5IHRvcm4g
ZG93biBzdGF0ZS4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKHJlbGVhc2Vfdm1faWQpDQo+ID4gKwkJ
dmdpY192NV9yZWxlYXNlX3ZtX2lkKGt2bSk7DQo+ID4gK30NCj4gDQo+IFdoZW4gdmdpY192NV90
ZWFyZG93bigpIGlzIGNhbGxlZCBhIHNlY29uZCB0aW1lIChlLmcuLCBvbiBWTQ0KPiBkZXN0cnVj
dGlvbg0KPiBhZnRlciBhbiBpbml0aWFsIGZhaWx1cmUpLCB2bV9pZCBpcyBzdGlsbCB2YWxpZCwg
YnV0IHZtdGVfYWxsb2NhdGVkDQo+IGlzIG5vdw0KPiBmYWxzZS4gVGhpcyBjYXVzZXMgaXQgdG8g
YnlwYXNzIHRoZSBibG9jayB0aGF0IHNldHMgcmVsZWFzZV92bV9pZCB0bw0KPiBmYWxzZQ0KPiBv
biBlcnJvcnMuDQo+IA0KPiBCZWNhdXNlIHJlbGVhc2Vfdm1faWQgZGVmYXVsdHMgdG8gdHJ1ZSBh
dCB0aGUgdG9wIG9mIHRoZSBmdW5jdGlvbiwgaXQNCj4gdGhlbg0KPiBwcm9jZWVkcyB0byB1bmNv
bmRpdGlvbmFsbHkgcmVsZWFzZSB0aGUgVk0gSUQsIHN1YnZlcnRpbmcgdGhlIHNhZmV0eQ0KPiBt
ZWNoYW5pc20gYW5kIHBvdGVudGlhbGx5IGxlYWRpbmcgdG8gaGFyZHdhcmUgc3RhdGUgY29ycnVw
dGlvbi4NCj4gDQoNClRoaXMgaGFzIGJlZW4gYWRkcmVzc2VkIGJ5IHNraXBwaW5nIHRoZSBWTVRF
IHJlbGVhc2UgaWYgdGhlIGZyZWVpbmcgb2YNCmEgVlBFIGZhaWxlZC4gVGhpcyBrZWVwcyB0aGUg
YmVoYXZpb3VyIGNvbnNpc3RlbnQgYWNyb3NzIGF0dGVtcHRzLg0KDQpUaGFua3MsDQpTYXNjaGEN
Cg0K
