Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013015.outbound.protection.outlook.com [52.101.83.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DFC42F718
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890769; cv=fail; b=H856jNJXMpXASHdwGBxq/AwWs37MZv8NtFW2T7FJJUosi+tCxgAzuqJRdSuEYBDZYhBdrKMlwmWCafEGcwk8FxDwYpuy4ZDjy6ll6P5K8nyIQbk37qGPzyN7QCeWZSzpw4DrARQYG4+JhinwBNMjErupodDvbQtG+VXeInqmOTo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890769; c=relaxed/simple;
	bh=/HiQFRa2wsxxumVGDvAAVRvjfMFY7wbx1dc+Vf+E3uA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RONytLO09UPO+XNNJqrI75ahWTquICn4CUB66CGRPOa8I8AYzbZpU7y2ojr6IDvSs6nAe1HGIrKSEg/Xz4xpir6bt1Vi9UT5lSHSMPs710FSDQcOffdXIWWhHwE0PgdNtYeFYYu6Yn9HBihIT4hK07j158hFWeAwtGqkZAiAK2U=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WsCK+Zsv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WsCK+Zsv; arc=fail smtp.client-ip=52.101.83.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WsCK+Zsv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WsCK+Zsv"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZXyGWDlhmhTfD3hWMMmpTORW+y+7tstB8ruj9xt8h4lfpc2P6Vg4SOAZbdk3f5gQ/0rPUvTjkq0jClkEHd5xFwMHke4LuDurWptLJCqu5eTOxCx6P62aLzo3EH2bwH8nldjNfzwhK650dZeDUmohwDT5hkyyLV3y3rZ8IMq8w38ZVrzlZSg2CW5TaOlvV2uVBqST8I4Bg0c1m4xhfPf+HpYZ1iYVx5YAyTriKknBaZdsKpu6ToHxQ4sh1OgAWRCfhkduL0fREWMEzTeUv2LlwJWFDQX0hHKhtdgxt9u5JSQj1AOauvgsWpEDjOvRkZK4RdSm74TZOFZLW1zTWIgwLQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyjd07jYzGxe/maBmMGla61m8wolJ8EX5OqIbYOyKDY=;
 b=HWe2ckKSZdszGDaqJ2GpCkn6r9JRkwcTLSYoUStCD4DXtaDHUVniASE2mXEsF8F/m91oRie2lADvdqQ4SiP0ndU5TbPFfdihjfWDVBIxcztnyIi0B7Gd4R8+Q5FFkvALwhtOHQg2T247754EvyqNs2ll19Q5xVFY7QJGYXkEoZZ7GXCs+Ow/1ZYP75ruPEk6J6Asb9Fv9uZObXt+NQvhK0PL3P5dEvkSGeCmLEwbb7706/CNQXrmdtEUZIp6+PtMon01LYyk8Rg7t53SdMNi24ysQIAqWMdmjVj1b759U4RtSshiAuzVA7VVoi3WntmLlyTgiYEtI6wVQvkCzyCx6Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyjd07jYzGxe/maBmMGla61m8wolJ8EX5OqIbYOyKDY=;
 b=WsCK+Zsvp9uqltEk1f5rMriKRoA7fdYqbIfe0V2QAkHnf8Tma+U5+jgJMdKbrbIk9qhY1ZdK7PjFvanpP9eG0TRkzBu+iwlNn+yxaUeRUGu+IDFljYCteYFncUx5KNfjLkeq+oTLccR4tkLB6nEjHNJX/cpzg6ZWLzrhb320UGo=
Received: from AM8P191CA0008.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::13)
 by PAWPR08MB9493.eurprd08.prod.outlook.com (2603:10a6:102:2e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:59:18 +0000
Received: from AM3PEPF0000A78E.eurprd04.prod.outlook.com
 (2603:10a6:20b:21a:cafe::4c) by AM8P191CA0008.outlook.office365.com
 (2603:10a6:20b:21a::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:59:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78E.mail.protection.outlook.com (10.167.16.117) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:59:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AHAaLF6nqZUsO05EgoNhgEMRAAh9wXnf2IUK+YmkcZBGdFBiog5+xSSwTcJ05jFHE752BGOfiMXGaaGy/C5cD2Z04HUqSApLmL4xNGaUXe8X8bF6s3NsEJB+FiVAVYgBZo+nOozqMVgpCPDSwrWbczVjS/Nsk+fyWdNfb1XKzKQ4F2BwMbZT3G/RFysE71pgwZEnkUOheTF+mIYTseTFtnphBqwEGHFdInJsB7K+U+k5PWn1L1h1OaJFizcMUy4xXpfh+8TEtHke10NNEMOfT2CbwhhbVzE4PvDfROwB3d5lM/JF03Fs4Fy/+k2QxOGeso5mvHFRZdyGgWult8k3Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyjd07jYzGxe/maBmMGla61m8wolJ8EX5OqIbYOyKDY=;
 b=XUJLygDs9SgyQYAf34iIjasNcDLgwDjkCnxPGJaVDIQ5ddi/dSSgGsTjEiCHDpcowMv+fTQ0mZKEzOPBKiqJOpLjyJIMhR34kOofo4ebZ6yj3mbfwVv2l1KT5vA9L9Sw1wZNtwdJSWZJM1WNfVMtP7zT+xM7hdMQzR02ef/wWx8IyntjcFonzSZprBDyCPUY3l1dufTamYJIIjs563dT0k4HPkNEWbJnHA8Y7mTTGiSDvhv7Jtrf+u4ML09MK2ivFnQ8Gd/aOb/v4FcE7QCaH4Uy8zosvwI/fG4bEYuEX3lyuychzzQHXLNEGjaKLUNscyH26Ud9LCFmltmDKyZMUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyjd07jYzGxe/maBmMGla61m8wolJ8EX5OqIbYOyKDY=;
 b=WsCK+Zsvp9uqltEk1f5rMriKRoA7fdYqbIfe0V2QAkHnf8Tma+U5+jgJMdKbrbIk9qhY1ZdK7PjFvanpP9eG0TRkzBu+iwlNn+yxaUeRUGu+IDFljYCteYFncUx5KNfjLkeq+oTLccR4tkLB6nEjHNJX/cpzg6ZWLzrhb320UGo=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:58:12 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:58:12 +0000
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
Subject: [PATCH v4 38/48] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Topic: [PATCH v4 38/48] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Index: AQHdG1tSr9NcrFmlv0WxIv2o24r6vw==
Date: Fri, 24 Jul 2026 10:58:12 +0000
Message-ID: <20260724104819.1296803-39-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|AM3PEPF0000A78E:EE_|PAWPR08MB9493:EE_
X-MS-Office365-Filtering-Correlation-Id: 466c231b-056a-4e53-6fe5-08dee9729a1b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 f7A9966tkRMGkHQH1wtpq/EqhDDdwa81P/YOqyYALJSjhN5fsNz8ud29ku8GnqDkqFmYAEER0ulA09TBiPWEJuROdCYg/GlGDXx47ueMAJan5SZLMulG0aXI/+f6wyr/itHPCVRqma1Uzc6GTfygrvWKgJuYmuBGbcG388YvmE7DK+HbGCpeJDe5hRCCctdCaCuqudqzkSvEaKGUtIZUt+JaxArFrNdqbXTUbA5YucmtTiSeL81HtOCS9RLeH88B0ST330l3tYm1Cf3ZlPuSi9ikZtEOEZFAIxVOut+bsMJxzIqUHR2kTPbcXTJODBHFNGXy7lgi8/KCP+ZfzUYBdExcu7zxaZZI/w4BQO1r46VmPKXjBwBQiovq3DBwcJNXDwexVQG84PnPm010QKAgWv3fQPcXDPyjEk79ie1XAmt6JQdIe78OtUjWHX98jpYVGUNPv3NssOKwKjKyGQQLhGTH1347GL4Bkl9nCAInlHsWHJ21rPQs90t2QQtK/7cS6RFQlOJ/ZyLZoIVWJOqakqjywddyivUTcmLYRILee9J3VG9BabEGO9JbBguGc+q4qO0h4N2mg4jSb5579PM5BJVwM3zizGo3SCeCR/GSSb3QyeFUeM7/5grPLLVgxb+z2UNN3qmzohLvMjt6DQzUj30vMbtu3hkWK9SElJy7fq1ympMeDFFM8c3dwYuh2h4VTD3KkLmCepyOKSdg3CuiIZu0rv00LwJG9PF7fftdbwk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 OoPAHA2qzIetO2xSxybHxXVVMgMBkFRi70Yfvf/sIZWLKbAdzanMGpGnqzrxwcaCph4Ngf5/SnGLqtmnR+BtiMSoPE4p3OAQIQknGQaiExuu1l2w3aT18I3zHYwaZAz7EcQmYwijO8kuYaHhroVGKp/LVZJUokpcRzYSBc2uDdf34ED0DcDdjhQOiOgpnt/QpsJ20krRYD6yaZNWDdlzvdDaIlxctPg6TU8NwD8oqIEzmDqM+yHS3E9fI3zNtYxf8Cy8tLc9kzx3RVdzZzzcrgE7bLAvNI9QXimbJlrqBXI2uy+QSrt0GQR5G5U1GZZp9iZAripIvDKjXMfswFRdcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c7bbefec-3283-43d4-c543-08dee97274cf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|35042699022|376014|23010399003|14060799003|11063799006|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hu6w5XkJ458SADbDT4F5eDy3KGt5aoAfqFjQ7ltRRp9GuXiVcpXXNXFEOuLt7u4Wa6z5XWR6ZDvWF8u5ZtO8JQRHFCk73QvzB+7Q0DGRRY90t76jU/UoB/o4eC2/aMnp0wSD47xNbv2d2OrBssh1YTiAVTr8QFRlmfkHBtBMYdVtOojj2QLrWmuKyJTwPmB19gxJPE83Ygk2mcfDN/fXufllF0dt6tAEXa6rVjmOGyRtEjyrvlBxaMelNvbkcgJNng8Nbv1RCoOfADmVg68Kit7VBlpl4XAQh6MALEkgCeh1tBOuc8fcFbf8lYhk1NmD7inykhAMi1Fhm8xfzKayz53xADjEXpbFxco5QBaUT/fwvEs5J+QyfA9eSqnktoLmpjOD5ftJe+HSUaC4y9IrjAtsI+kJ1bOcK1OCHQJNzAgTN/fPvby8L1fnLW5fIpENoN8fqnsYwty6a/IQW/jpCdVgkJXXljBX1Q80vItjhVeV0/DHMGAzKvY4/T9Oqmm7hKGmf/vt33XA9NP4dWiiWVQvj6U+hyMhFyHf1HXGiI9oiGScYG1zXgmAn8E8G2GVn1kjUszhmRH3WVAToCkxo1dlT4dmCaPL1PN1/4pJbfy8FHhW0FtLrc1VIW+aj/N4oC4ixAzIVwskq7TvfWGsDRyzbS2nx8SaCQnW+VjXim8GZpDMy5vqkU8JVEHVaAz0f4y9xACfje2C4wt+PPZ40g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(35042699022)(376014)(23010399003)(14060799003)(11063799006)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	K7Yzp5EGWEF8fBt+ElLLlSgoJWh1M1OvOSas7Wm1UnKLMR1ggJ99W3BgP4AjL5/3vZgqYOVkluUGK8LCA9XMhUFXG+EAaf7xZ0KMdP6IQXcOrYAWllpVwJt1LOZoRBMQJt4grK8h1JoSQtLnZLb9OR5E0Qo7NYRr6jLCnyr4ZV24QvYapmvgKHSBj1QMD3gQ3v1MLAAxxyDU5QlarRIu+DRXENebzFMCntW7tktUAbvB2tBU18Cn37NiSFeWKnhc2a6GlD9y3+GkO+UUDDoW3VbFWpMJbMQR/H7uvskXtCNHlBSz+hc1nB71NIxqzgfwi9KJFo5ojFhKZ/NvGTNAH5UxbINao/ZX3ax45lHpk49EueQQAk7aeJA5mbVkdG/iOMHMhsHE24UtnMzj3XstzPsZdHB7G0LTuM2qjwWBWiNBl/EvOfv+/+V7TJwZkh1d
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:59:15.3331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 466c231b-056a-4e53-6fe5-08dee9729a1b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9493

Document the IST save/restore userspace interface for the VGICv5
device, KVM_DEV_ARM_VGIC_GRP_IST.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index c411d2195c6a0..318d9033ddb4f 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -187,3 +187,71 @@ KVM_DEV_ARM_VGIC_GRP_IRS_REGS
              value is not compatible with the configured VGICv5 IRS state
     -EBUSY   VGIC is not initialized, or one or more VCPUs are running
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_IST
+    Attributes:
+      This interface is used to either save the state of the IRS's Interru=
pt
+      State Tables (ISTs), or to restore them. A get operation saves IST s=
tate,
+      and a set operation restores IST state. kvm_device_attr.attr is rese=
rved
+      and must be zero.
+
+      The VGIC must be initialized before using this interface. Restore mu=
st be
+      performed before the VM has run. For restore, userspace must have al=
ready
+      restored the IRS state needed to describe any guest LPI IST.
+
+      Saving first asks the IRS to save and quiesce the VM so that interru=
pt
+      state has been written back to the ISTs. KVM checks that the VM rema=
ins
+      quiesced while copying out the SPI and LPI IST state.
+
+      kvm_device_attr.addr points to a struct kvm_vgic_v5_ist::
+
+        struct kvm_vgic_v5_ist {
+                __u64   spi_ist_addr;
+                __u64   spi_ist_size;
+                __u64   lpi_ist_addr;
+                __u64   lpi_ist_size;
+        };
+
+      The SPI and LPI IST buffers contain one little-endian 32-bit IST ent=
ry per
+      interrupt, in interrupt number order. Only the architected 32-bit IS=
TE
+      state is exposed to userspace; host IST layout and metadata are priv=
ate to
+      KVM.
+
+      The SPI IST buffer is required and its size must be:
+
+        nr_spis * sizeof(__u32)
+
+      where nr_spis is the value returned by KVM_DEV_ARM_VGIC_GRP_NR_IRQS =
for
+      the VGICv5 device. For VGICv5 this value is the number of SPIs, not =
the
+      total number of interrupts.
+
+      The LPI IST buffer is required if the guest's IRS_IST_CFGR and
+      IRS_IST_BASER state describes a valid LPI IST, and its size must be:
+
+        BIT(lpi_id_bits) * sizeof(__u32)
+
+      where lpi_id_bits is the LPI ID width configured in IRS_IST_CFGR. If=
 no
+      LPI IST is configured, lpi_ist_addr and lpi_ist_size must both be ze=
ro.
+
+    Errors:
+
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+      -EBUSY       One or more VCPUs are running, the VGIC is not initiali=
zed,
+                   restore was requested after the VM has run, an LPI IST
+                   already exists, or the save operation completed but the=
 VM
+                   did not remain quiesced
+      -EINVAL      attr->addr is NULL, the userspace IST descriptor is mis=
sing
+                   a required buffer, supplies a non-zero LPI buffer when =
no
+                   LPI IST is configured, has a buffer size that does not =
match
+                   the configured VGICv5 IST state, or an internal VM tabl=
e
+                   operation rejected the VM state
+      -ENOENT      A userspace SPI IST buffer was supplied, but there is n=
o SPI
+                   IST to serialise/unserialise
+      -EFAULT      Invalid user pointer for attr->addr, spi_ist_addr, or
+                   lpi_ist_addr
+      -ENXIO       Required per-VM VGICv5/IST backing state is missing or
+                   inconsistent
+      -ENOMEM      Restoring IST state failed while allocating the host LP=
I IST
+                   or tracking pending interrupts
+      -ETIMEDOUT   An IRS save/VM operation timed out
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
