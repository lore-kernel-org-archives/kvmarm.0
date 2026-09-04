Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010024.outbound.protection.outlook.com [52.101.69.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5778C372B27
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522705; cv=fail; b=P2Ocgk4O54NLFHLnF7UJoKZcy6KS/Y6G5Af3EkXin202IhGzkBjZzmOf4cG8ne/gj6j/DZ4T0F+ePxAUzhFW0cvmLJANqUvwnmblb5qwWiYvyTyhWkYJIaAcED/3wmlsKvF9GU4dmrH8jfzTWxba4DfsGQQWrIQaTa12gwU8DHY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522705; c=relaxed/simple;
	bh=LXGB5pRXngVPlu5K/qUGQpUjaSqMA+ZkkMNsh7klv4M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LpQx0YASl/icIheK/kpC4yWy5vjV8FXn2VR+FjKYA3IVQGlOrs6Ty1lpCIcQ/WZ5mTA+lSMgt2llU37soP3K1luE8iLi8Y08aSeDKTpOHF+7ixFQsspqtMWk5zvdT3ujwxUj5MO8gf7antEzV/NVTFrrkmNPTMtklEqREv7pJJw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Imxvh89E; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Imxvh89E; arc=fail smtp.client-ip=52.101.69.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Imxvh89E";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Imxvh89E"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UeS32G90lipEq5B82nfybiZj/QBSpB0PMYczw0B6XdEAZXIu8mDnt9obKdEisrJaRAO9+WktDfPqXVkp/XddsMdAk3JdJmiGXhuTLCide53Hw3iEa10GEr8UQEo80k8O3VoqL42K7CtbuLoMBPEa/BZtTcFbGU1rrVn/mZrCSQlcCTp9RnDWueJgvshlU9PrX5dyDcn4KEG++7AG5M5X8xWW3uck9EihCJLM0h+yUPHm/qJT7ZItxn2DzAe718nCy42/AWqc9rYSlaDvAfni1yAGR1UghxjG6ia6R3I+dqQ82g3t15zRoRj+wGEn51Qc5oGBdb4/UyusVEpRf6GyOg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brIatGOvLpJ8KqxhD59PLRjUmMEGlJQ4Ce9dIpX/dZ8=;
 b=oKYNV9Vh1FRXw2xoQVx+uwjhVYtqunxYWCOKcNu/U6CastiGIXAUO674gO6MR9jraZ5UTSaDw7pV/SJpFcY9FUuoa3BoQKfBOEtfNpRcaLesMqpKKV63JjLpniVvjYMNF9XoWaw2kGV7qP9fcKLJXRXH+3CGGvhNDtj9LL/mYoBDapwVHsrqTKt5J1d9Sp9qz/c7te1tfvV2bx7k3flKnrk6VKD4K4AGmhmPSlB4DP45XP5QlDO2dVfYzhgP8BdvesNupC7dnFQPQfHpX60YoR4jms0LGmbNW71stxHAskiVMDfR9+A53YPTuKZb7gwOP8Cj39AX8BntqjHnR4ZIdg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brIatGOvLpJ8KqxhD59PLRjUmMEGlJQ4Ce9dIpX/dZ8=;
 b=Imxvh89ERfXRdBhRteDnk2l07360sURm+x6j3QaYtizqNgWhtWhQe717lTq15XyfyEu+G3b1gYVXOD7ooBnAIFGwTZZ/dXNs5xPHZWuVBFiBm7tvFyk+IaFP1H/dxHGZyUaB0rbEAPrnTcwlvACgzP/0NG7YF5mkwEWHjdqI8dQ=
Received: from DUZPR01CA0014.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::7) by DB3PR08MB8892.eurprd08.prod.outlook.com
 (2603:10a6:10:43d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:51:36 +0000
Received: from MAD0EPF000008A9.eurprd04.prod.outlook.com
 (2603:10a6:10:3c3:cafe::6e) by DUZPR01CA0014.outlook.office365.com
 (2603:10a6:10:3c3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:51:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MAD0EPF000008A9.mail.protection.outlook.com (10.167.241.181) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:51:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VJni+UgPivpCRcZYEPBoHlqygQgAZPaXzUgCO5v35WgiRKKpIUN+XTZpvw9yOqEV8rkitUekQ3b1+vbZa4RxV+N9tGZhJItDGuNHqMIG9QEGoUoLqKdNFEqYicyGIv7U43vKauZ2ioxUPnMXEMw26JBgOPoEUgph5kjN84KYvvAkeRVAtFwKj4q7nL3ZeABS5o91RCBJ+u2JDJ4eaKMSJ1Rc3ZFWsS5dpGQJzihU7S42ubZ+smPiC5Yt485I4SJc8pKeDsuwXKNY8nVbnFTN5OWZXfZm6kkPyr9SirFfj1jhrA6+E90wJoiPx0mHjNRTSMEJpX6s/p2YawoFhWFYwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brIatGOvLpJ8KqxhD59PLRjUmMEGlJQ4Ce9dIpX/dZ8=;
 b=yaISuPOjf8yGoaOZiexZ0bCs663B+6VcWzq9O5Q07XRUvALUoxImfYM7yJwLTBxls/f8RGTX5SezeXJlSqU8guoINd6jBGa26czJh2APQiEXyNGWzd5SAakRWxwLhLbw2e2Vp4w56r01BHYaJei9AG+hWjub/4xAUI5gsBJbf0aeI0mUf1NMbap8nPwfJALOvSciTq2myqFC8sDU7A7JZy/iKQu/ku0R7OqZX/1VsQPDjJ88QUXg3ljj6BOaFIL/n8PFkdHbXF6mHNozjy3BPBsBu3VS6SqV6HoLq3JKDH8qCxW+xecMr77P4xGDuaQtJszpgEAYb+SRM7xaqOzfbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brIatGOvLpJ8KqxhD59PLRjUmMEGlJQ4Ce9dIpX/dZ8=;
 b=Imxvh89ERfXRdBhRteDnk2l07360sURm+x6j3QaYtizqNgWhtWhQe717lTq15XyfyEu+G3b1gYVXOD7ooBnAIFGwTZZ/dXNs5xPHZWuVBFiBm7tvFyk+IaFP1H/dxHGZyUaB0rbEAPrnTcwlvACgzP/0NG7YF5mkwEWHjdqI8dQ=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AMCPR08MB999887.eurprd08.prod.outlook.com (2603:10a6:20b:784::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:51:03 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:51:03 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v6 33/49] KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
Thread-Topic: [PATCH v6 33/49] KVM: arm64: gic-v5: Add CoreSight MMIO regs to
 IRS
Thread-Index: AQHdPGOpVdSfoVK/6UOkSocp32H+Gw==
Date: Fri, 4 Sep 2026 11:51:03 +0000
Message-ID: <20260904113404.4051341-34-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AMCPR08MB999887:EE_|MAD0EPF000008A9:EE_|DB3PR08MB8892:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aab45eb-555f-448c-9c59-08df0a7adf6e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|38070700021|6133799003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 OYPcMS2rgzFGJc3GcKkozwKt+BGpeY+KG67oAwQRGJda3Ym5bjls6GLiV9aLFNSi0SIocW8JfDRXbjyPmueqZ3WBDlnRtJb5iPO384/aD5zsnYqbV1+OjTiVWUhbOP8dVSART6W/MRlIqsDGCZqMe5CYsCv5yh4F0MgPEW43tZdB0D26S4rofwBLCimvAVwml0zJfD/zAXc38zs6Sky58mM/oeVO8pmfuxtvHKItno9aH9L+SOyP9QqoU3rZLOOs45pAEBo/3XxijyL9o/XOh6UoDgdCe7ekPkdO3wpK/JxuapAWpKdmsIvPZGsbLUCrAVYKBNLXcs1SAWzDz0IUdhEH2JVak895uptm09CN6dw1G4fkijrUb7byc4pihrwp1iiNhR2vXuKd2zV1/OGj5oDT2ZfDGOpl9ZU2ExjK4iTPSQdqy/PspSg2ARsaEOL8xe62ecPxOtYGQPVyU1ZhpWfFXHTNelFzZw4HjH7rjfRCHPxXv3koWCLWzUHZ7M0gRzFJoPH73LHfiHISpLNsxgkNbSC0ECnRO6RWcFMqC2hp4Qzj+K+V33GKuUcneLgtyk7UEvAvsGrgRZuuHfy3f8XVk0qBIq3e4y+aEdt4AO09MiyuB37BHoox23UBjFmZlHf1dcg83+34C1x8E5cJMKVHUGrVgpk7syZg39fzd4wTcJk5b+pV7BLcbHBJi0Cya/u+OaMFb4gpI0tMPAnL9n7WoAnYOkKzeRveSM29o/U=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(38070700021)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 uZLSDROC9bQxR16+oMLpHOQFW4kYSH/7QznKuJSKAKnAChzsJ8/3nlaw8AX/FgD8TiJYzkrLw8AjQTk1mzlnlFCQ8ZRNlXuNT7dT4D1ABR1UXNLwKG8raFgPWlRf6GGR5uLfjjQY6U2n+iVLQVe/GPXR/KmYPJm2Y5hxRLOyqMeAQEdIDCNvlrI+wH9nLJA16AGwhXmyEYdnofNRpP9GGpOLP8xvpgxc4i2pCjFQeg34H1G0xR/GYW0A2zAzZYDCHs0vakrE9yCStYPBC5Bkg5aW+7ySUaEZO7ryV1rMh/WY+H72XJjglRAnU514x+jD7XS4azykQGcg7lxZj7im9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB999887
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MAD0EPF000008A9.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	98c974b6-ea1d-4baf-31aa-08df0a7acbc3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|36860700016|23010399003|1800799024|376014|10067099003|6133799003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cF9h24YozWTel+eC/FZrJxgvtj1+V4Cs4aeof+eCoDMoplSdyZHRKR5Zu+fT18MnSHoVYSOfh1hNa6b1hfBCO9Z4jbSuu0U42jE2JobczTN6YWMGxrU6KN9lX47M/xDtjj3oIjXxQ+AOHVfL8MdvNVlQBO5jkL33roSKN0gPOEGmAS65U32aoFpxzwpMECEVWQtNDMeSKUxE4hiqGn7d3Wtuc81O4El2QV5ODJqB6DvbOT4WaqzoOEJyocQ0ndULFZffigKdHMSjNXnBQGa5YgsbBxOO+oRU9PgPGmlVy6qVDCOMqzLDnJYv5srp2Osdm2d1tttUZ7qFZTYzubTi1FW5hVZvwiKhfICK50MzVJs8gncEyuj/5WsAGgWKgENyE90pXG2nb+m7S5sPcgPsF7YKVVwTci0+47thCFRbgPUl1yKCfYgiD50WCOmQqRxyAvNk4HioGUrJoWO8K0T4B2NXR45X0E2eo4EzrpnfWqe2OViImaX+mrkpkU92C/rQ09cVuP2QZ9FM2Vky0wpxnpNq9S7we8OHnAlFd7RlTiNtyi0bZ6iPCdVJWyRLj8zc0LlcXHVxiSxXRMWpzDb8l83CKswFoKDfIIhGlbRa5dSntne+P4CdAO0yuMODxnzIQTLy+Np4/9s5tcJu6TbEwG9R2HDIuxVT2ucKqIO+MNw=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(36860700016)(23010399003)(1800799024)(376014)(10067099003)(6133799003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	k5LcsJirWjlW8aSCFSymjEU/sdt9zZNzfqafx6zM3TuP1ixlVCPnT/8JGiKl1tuBz1kpWBrm198QbByBGiRd8zMXjlNpfaqEWurQk2edAHkqAZFVG6Ry0yjtqnZWZFou2b8f9jZkmq6/DQ5y0suOO1zL0nhmNqQV1fWCRCbVBlsbJ/QgjqtwScqH9nzaI+PbvjSZyDg8wcacrBBmnBXzX3r/NYL0Fin7O9aVS35zgd7VZjR879A5UB4RsSBO8vbijGqiDimcWloz5N52SJQfMTwxztPeD3Xh6a/43NbTXmE5mlZHIjbtu0Ptr89cWr2vsP8G2E8pQnW8t4oJO8fwEnKObqc+mGm4u30GoIrUFlvCcXBxPp9NUX0kSDIFqPrUasaS4Kal2wGh5G3WMASA6ZwAczWK419Stl5xZ932bP8wVlrRRY6O1JCMPQW4Ivnm
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:51:35.9095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aab45eb-555f-448c-9c59-08df0a7adf6e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MAD0EPF000008A9.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8892

Expose the CoreSight identification registers in the emulated GICv5
IRS MMIO region. These registers are read-only from the guest's point
of view, so return the architectural identification values and ignore
writes.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c | 78 +++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 9e9853b88ce2a..2de03bbf0762d 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -503,6 +503,43 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu=
 *vcpu, gpa_t addr,
 	}
 }
=20
+static unsigned long vgic_v5_coresight_read(struct kvm_vcpu *vcpu,
+					    gpa_t addr, unsigned int len)
+{
+	const size_t offset =3D addr & (SZ_64K - 1);
+
+	switch (offset) {
+	case GICV5_CORESIGHT_DEVARCH:
+		return GICV5_CORESIGHT_DEVARCH_VAL;
+	case GICV5_CORESIGHT_PIDR4:
+		return GICV5_CORESIGHT_PIDR4_JEP106_CONT;
+	case GICV5_CORESIGHT_PIDR5:
+		return GICV5_CORESIGHT_PIDR5_RES0;
+	case GICV5_CORESIGHT_PIDR6:
+		return GICV5_CORESIGHT_PIDR6_RES0;
+	case GICV5_CORESIGHT_PIDR7:
+		return GICV5_CORESIGHT_PIDR7_RES0;
+	case GICV5_CORESIGHT_PIDR0:
+		return GICV5_CORESIGHT_PIDR0_PART_0;
+	case GICV5_CORESIGHT_PIDR1:
+		return GICV5_CORESIGHT_PIDR1_DES_0_PART_1;
+	case GICV5_CORESIGHT_PIDR2:
+		return GICV5_CORESIGHT_PIDR2_DES_1;
+	case GICV5_CORESIGHT_PIDR3:
+		return GICV5_CORESIGHT_PIDR3_REVAND_CMOD;
+	case GICV5_CORESIGHT_CIDR0:
+		return GICV5_CORESIGHT_CIDR0_VAL;
+	case GICV5_CORESIGHT_CIDR1:
+		return GICV5_CORESIGHT_CIDR1_VAL;
+	case GICV5_CORESIGHT_CIDR2:
+		return GICV5_CORESIGHT_CIDR2_VAL;
+	case GICV5_CORESIGHT_CIDR3:
+		return GICV5_CORESIGHT_CIDR3_VAL;
+	default:
+		return 0;
+	}
+}
+
 static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu =
*vcpu,
 							  gpa_t addr,
 							  unsigned int len)
@@ -840,6 +877,47 @@ static const struct vgic_register_region vgic_v5_irs_r=
egisters[] =3D {
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER1,
 				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+
+	/* CoreSight identification registers */
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_DEVARCH,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR4,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR5,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR6,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR7,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR0,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR1,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR2,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR3,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR0,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR1,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR2,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR3,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
 };
=20
 unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev)
--=20
2.34.1
