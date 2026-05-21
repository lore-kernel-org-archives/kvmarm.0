Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010032.outbound.protection.outlook.com [52.101.84.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39786318ED7
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375782; cv=fail; b=ZyC5bO7hclxtLmafJQUCHGAcqQ234MRz02ZavDACrCFW1x49lHWLNmDrFrOfoAdtOk1CyXAmt+ZOnYCElTBXrOeNkXVpJ0A0QOSv4NBoTYZn+GJ+OfyzCchjTJmRLa+j4csxteEnCP1odytcxmr+WNRrj/Eg+FZ3YhGkakHkZ7U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375782; c=relaxed/simple;
	bh=2GkoYPCterpwyyHlVUS8B9OPteiVcLbI8B0zY3tvaLk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tchkoEShBgGRAQ9MDbK+av6bUI3vDw3/IFXr6lWJ1DYJDwF9sDC5BrVLT+sVz7pqPY1T87qYqQnbOw+HNxWA0ssV+OevuEw53wL6yfLhcdXejyk66Qs+SAgAyRlW73icW7ijKYIe9psbV5iSgiLxZC8PeGTQA8FP6pHUDmOpqqQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ea9pSfyx; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ea9pSfyx; arc=fail smtp.client-ip=52.101.84.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ea9pSfyx";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ea9pSfyx"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=K4Aqs8YBk+wY9LMWW7PCN9Z0OofDz0CCWZh/IfUaQNtiQ1qkVufyRubUcw79MpnApu7Z3vdcrNCGGMM/v2bG6+nt58b/om+hv0fkMV47DUQ7I9eyUXxXavzJJIuBR3OWrCpuaX4S0SLqZ14EjbDsOmTRg5tYzbxFicnXLYLyyTfrMBuRqeU1QFoFPk8uubrPzlq19AOX9ciP+X83XelaZ72P/ufr0E8/SXQxdLlNI7gu5B2Yoo4IJrwhIzob6FoXVvYi9dBOtFuO/BSyI15iiYtejz99ODGvidXx/RA2GKib48y8QQhAzkcXGxmX8UdTFWBQznLl2XJLaiI2ytZCxg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xW9VIcCVrAqo9gPL8RFDiUmS/zAaa2ylwWwxXNSTokc=;
 b=LXzUlxug1szj3Jai97xjvp4LWcEzO1VU/Rpx2Qoi0yE9UMlVLhXQABsc3nGD/esLLGw3D8co5lj3yJ07PTMCbnj87mxEmZ+mtP+VBEjGse+qtJAuqHTJ2zGPiTe6RdW9+JKu1HYTejhXiaI9YZ7pmByXZeRX+ZCtj2YsCTe5E5rDm4KuEQl3dChLgHNypMtjglZftmyCJfdVUFySwPulNkXcJL0oxSlzKkjAttfj/CHK0AKILKuxUPzmUzGrPXzZiqLu0E0rAqRcMp51S9fD/eyJyCy22O9qm6RXeKSpcZ9NwCyhREicyz1qvbaEEJKAIq2h6ykbMJCRGaVgPN4sJg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xW9VIcCVrAqo9gPL8RFDiUmS/zAaa2ylwWwxXNSTokc=;
 b=ea9pSfyxVflJLt7nsR4WbNa8C//4IDS5kwrfwy7Lj/S8EHG0FwlT+WT7JewiX+mB3+0ft7zOjZ+MyW9Qaw9VO5b0VkSAtbzal20eWvNSxDhz5U48F7MFkACUMMZbW6oZK5RTviPGY84Gwqv1yWWApDJj2eoZrDJmR1a30u4e48k=
Received: from PR3P189CA0043.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::18)
 by AS8PR08MB10025.eurprd08.prod.outlook.com (2603:10a6:20b:630::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.16; Thu, 21 May
 2026 15:02:57 +0000
Received: from AM4PEPF00025F9B.EURPRD83.prod.outlook.com
 (2603:10a6:102:53:cafe::75) by PR3P189CA0043.outlook.office365.com
 (2603:10a6:102:53::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.16 via Frontend Transport; Thu, 21
 May 2026 15:02:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9B.mail.protection.outlook.com (10.167.16.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.0 via
 Frontend Transport; Thu, 21 May 2026 15:02:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sa/pgGzYc02zgDKwmqWkAmA12oWdLBcGdqjYh3dwL6udAQwdtX4+8awexQ2LbW7ZUnv+o/FruuJJ6rNKHIsetJlhFWvTiEHJsoIRjJzbiRP7K3Gzz2UQYbEkhxKQ29DULTSMzVXE36tRa2RZfrb9RJmhSYdZjHoBcurWhRGnbRqPuLY3bhj82S0OlC7TL7c2clCmFDW7DQP/rpGDMBK3ho7/EBfu3nyQDaNpIiBu6Jo+xCDu4GP91zNmGetTG1UfvEjYVqIoP7xtwXnUkKuvb9LupRofe54z6mA/E0FlSHIdCKmJhnG9d76Wd7/UUZh+rbGgIG3HxSmbuOvYsRfWeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xW9VIcCVrAqo9gPL8RFDiUmS/zAaa2ylwWwxXNSTokc=;
 b=D3Bul+MIPfWAyAarJGMeJxKDUbh/INARMnNQDbDu7bbShzzzrSTsscTMhjapIDyVzugcKM9/oQU0LWNSnSlstwUyoKfVeN+6d+noa6pkZygfrhLHksxcFev3qihiT+TOtX9c6DVGOhTTTzmmboFtlZKcbvWOnj2t9KH+SRAH13QD03RIFOkRhLldOw7iidxfTbVzSyY8gknewuqRHzEvBDfEifrp1BK6NcWDyE1J9AdXcCUizDMg14VP5ck+IVtJSDHK2yZaQV5IXKbNBw7fMpuO7NbgVi9vhcLXK0ZGjQ5I+GAfap9letWarAqYe5DqFh5AIBiLxbYIY7y61SsK7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xW9VIcCVrAqo9gPL8RFDiUmS/zAaa2ylwWwxXNSTokc=;
 b=ea9pSfyxVflJLt7nsR4WbNa8C//4IDS5kwrfwy7Lj/S8EHG0FwlT+WT7JewiX+mB3+0ft7zOjZ+MyW9Qaw9VO5b0VkSAtbzal20eWvNSxDhz5U48F7MFkACUMMZbW6oZK5RTviPGY84Gwqv1yWWApDJj2eoZrDJmR1a30u4e48k=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DBBPR08MB6204.eurprd08.prod.outlook.com (2603:10a6:10:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 15:01:53 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 15:01:53 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 37/39] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Topic: [PATCH v2 37/39] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Index: AQHc6TLCxj/Ef4YjZUiUw180VmQd6g==
Date: Thu, 21 May 2026 15:01:53 +0000
Message-ID: <20260521144846.1899475-38-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DBBPR08MB6204:EE_|AM4PEPF00025F9B:EE_|AS8PR08MB10025:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d90e06c-d8aa-4fe3-f3e7-08deb74a0b34
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 q4J2nVcYzZcjg3CnETw7o1adt543KYBP7/HH1bPXHEGXRcVRCDGlxIwz7ebpCR748xomKfDBdkXF06B9yql7rA31yuHLd71DOHlG35ZOuhXxo618SF9a8Kk5sjhHOV7H/pDX8QHe8Qh2pPVL9y8YQ9kZytWHcZyyv/teRAcqAum0VFt11XKuMuOCESBZMJC6ll/V+R1rCmhmEnpMpPbbQeXDNVyDQ2v4uo2XkAmFoUPs3R68HqPLFV5xlqVAqrN1Eh+OLA+orTjbsYJVRM8E5+dZLCk8i30rrMn57QVjEX7XL/eTXMPO74gqx6Kgz1mtH62fIf8uKiIRoVmDIQDXev9EUSjxYEJGLKfjuXCpLbvawmQN1jLK58tyDlY3wjjoeNwqGqvCdMb7skyaeQb6bSgBzp1hBDYcLiiyDEfVcEzKDhZNhGo4Ov4lpIDVGnW0V5R8KVBCKDPU7KohCe4Y+P24yy7LGyoRBVtWq2kmKmsCpKz5vtPu7/5RG4HvWyG61qcK56fwLjI6/IjXqgtZqhLT5jsKLZO2fiMQcFStKq1dobHmZxNv1HV2YhMlIhewyRhve9omCNF67TExN1jNG5beASTx4//ybngwtPq48yZzxjls9BleLkkN2yVMdXtws57Xlmc/kR5MLCFMrioYmKv0ZzzsCacLMTImow0fVFMj5AHlPZAPRiqwVTJfJiOsYKBXnfQyhzjcAktdsAvQ+prRqj0Pq+MjyPfVGzpItjVk7peaE51MDzGwBZy5Dfqy
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 eVScIsRc1mO7fRS2L4hwIXAkvcPWr98BaP8/Rw6f5i6NNLo6zZjBEYiTC97fasS3uqr1+nSkkVvm3SFW7gQvhPNT1YGWRPggIs2BcHpFfdjQGi/ReCzH48z9EqjuYSHbvVhfM5XneUpkdLm/VW0BxAxgNpvk1k/gGImIXdds5yQCLJn5Y/RhdbjRDnhPWRuQRV3rdZ/eJTLq1jin+HaqQRqfUoQKdnsp5ZRMpvGGaws06q3GqwADjpryPr2k3Q89Zb3SthFRSopnf9E1gHJYgcWRSS65KUjfxQjk5wvM4sGU3bO5AXjqFOOBPMqIsgmGbJTOC1RDdOATB8Bd3S1GCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6204
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9B.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7470eb4a-729e-438a-4ebd-08deb749e4b7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|14060799003|35042699022|82310400026|56012099003|22082099003|18002099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	4OTQSkO5xu0tXetTNWe1Of+3FzEIq2LDs5ic/hNd4i7dOr8Ft1LPeJ5bHh/nrY+S714rjYze6BQ6JzuMqiEZA6yvX/XsSjJKi4l+c/PTVKt9HFbCMXwsTmL32+2Qors6yU99rTGdCPrRRbyvOaTzwGg+X1rK/a3I/j9xsfBYmdWNhFcPIxGT3IZ68xNoVvgogR0U+rcHIO4doBm5PGYkrnt2XKqMJ8mVNRMGcT532cSw7BX8pb2wl7ut6fmBvuhqe6Cx0erynaCG5ESA6kuoW/MmNMqOJbJJZMVnsvjpq+aDATeSuxOy3F00UdRI7t9U/lVk7cZQTSNehzLjZuW1gEJk2fX1E+g5KYoy39OJl5hgXr0UhAsLAmv5wwKle8xfjBcwGrKArJBpeIJDvbfpvnV9QhxtlS2sDMlIYRaTEPvQSP8/8owada9KIr+rAkSxdlYSFMJCWInPzl/emI4lO1lU3nlspZIjlp+aFPkV+haNTgTWLMYa0cKJHVr8LIS09U1UgJlhQtKFfbKEutSg5QXqW7uGRyqWjdWUO4awyNSsxCrqJFVDFOUf/q+PRi0k87AHRJQ5iqFSoY/79LOtLYDiGqaFHjlcZhAEW1USbHHYzg+2FE/8fNTUEMmdQvvipo1VSgpFXWmqRIrLawsirGe4dZrp7O0aSKIMu8i+zak0nX/VVmXfmTFv5WOSYNGEIXRWBWJMW9ZnH4yR0NOCvq5P0FIiK57OXOO+KQMR42U=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(14060799003)(35042699022)(82310400026)(56012099003)(22082099003)(18002099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rVbShe/GBYNkbOrOo0ZO9cT7udHaqh/RWgzuuVjNLaBQkLgg+v8BfXWLX/tgmkCWUhfllo7Y5c4cHREje75yV4fgWkqByAXRS9nJxOYfhPNmmzJ4bIDDcsXZiv/NKAj3Po3Bd371Wk6hN255r50V+as3QTHDhzV3jHTnG1vL0nFu7GgljbcJ6DPz1ggXfpAaUEfYOTcuxVZ+P7kLpT433dEsS/BJdFSxYQzp17kwaevwx0ftk8/cJrkbW7QE9juVmQPs6TxcXEgZVXgab1gCtR5Yqci30WeL9vsWeVHYdkS+FolM+FF9VVN3Ne8FXdWcxvDBx8qlQGKRkWcJElZSZf0KlsKLgvj0+ZlWZ00IKJoWdfhShdMRFZqmt+pMKBAfrCsDScPkJZRXl7J2i6uzhX7RAQkc9m62nZJPySH/l77/L4sS44sdTwGCPbeDOvi0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 15:02:57.5682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d90e06c-d8aa-4fe3-f3e7-08deb74a0b34
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9B.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10025

Document the KVM_DEV_ARM_VGIC_GRP_IRS_REGS attribute group used to
read and write the virtual IRS's MMIO register state. This provides a
GICv5-specific interface for state that is conceptually similar to the
VGICv3 ITS register interface, but uses IRS terminology instead of ITS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index e2045b09f27d0..217a1ecfbdc5f 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -141,3 +141,39 @@ Groups:
     ICC_CR0_EL1
     ICC_PCR_EL1
     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_IRS_REGS
+    Attributes:
+      The attr field of kvm_device_attr encodes the offset of the IRS regi=
ster,
+      relative to the IRS CONFIG_FRAME base address. This is the address t=
hat
+      was provided via KVM_VGIC_V5_ADDR_TYPE_IRS when creating VGICv5 in t=
he
+      first place.
+
+      kvm_device_attr.addr points to a __u64 value whatever the width
+      of the addressed register (32/64 bits). 64 bit registers can only
+      be accessed with full length.
+
+      Writes to read-only registers are ignored by the kernel except for:
+
+      - IRS_IDR0 - IRS_IDR2 and IRS_IDR5 - IRS_IDR7: These are sanity chec=
ked to
+        ensure that they match a sane config.
+      - IRS_IDR3 and IRS_IDR4: These are RAZ/WI as nested virtualization i=
s not
+        supported.
+
+      For registers without dedicated userspace accessors, getting or sett=
ing a
+      register uses the same emulated MMIO handlers as guest reads/writes.
+      Dedicated userspace accessors may instead save or restore migration =
state
+      without triggering guest-visible side effects. For example, restorin=
g
+      IRS_IST_BASER only restores the emulated register state; any host LP=
I IST
+      allocation based on the restored IRS_IST_CFGR and IRS_IST_BASER stat=
e
+      happens when KVM_DEV_ARM_VGIC_GRP_IST is restored.
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   Offset does not correspond to any supported register
+    -EFAULT  Invalid user pointer for attr->addr
+    -EINVAL  Offset is not 32-bit aligned for 32-bit MMIO registers, or no=
t
+             64-bit aligned for 64-bit registers
+    -EBUSY   VGIC is not initialized, or one or more VCPUs are running
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
