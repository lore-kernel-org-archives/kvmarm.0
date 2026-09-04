Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013067.outbound.protection.outlook.com [52.101.72.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F4C423E98
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522673; cv=fail; b=m6Zins0ywGJXy2pjK/sfVAQ0+JKPl8yhKnffy2yRUUjdtxp1sSdryLUXn9l2Qhm67bFPMui8fzBqDSNUOb2Gmq2lItMvviQPLgI9NzKTLKgt5nUU85s2xCuziQLYa13NwfTg9YLlj5A+5LHvr0xwPuuPgg0MVJACKENWkodqPUc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522673; c=relaxed/simple;
	bh=2dekrsC8B4/GpEf7DQiYtj/IPYpZiEGu0cWUPM1IMu4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZBzgqTALNEQga7QYGFX6GDUI+3xMeeX81Jc32qc42r1am1gLEGvVt+1TrixoDNkH8AC0AU1sy20qUXDWYG/0KDPTMtFOP4P079bnAAhbU5n/Q96ax0dKfenvj5VbBVkFcrsQVkNPlDKTFePnx3dVRLagDCIxllzJP8PZGxAzT2U=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YO+brKWP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YO+brKWP; arc=fail smtp.client-ip=52.101.72.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YO+brKWP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YO+brKWP"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FD83pLuphzvnPRW1ZNXzGYL3x1pODqoLQypm7s7T+8gLJEXGaB6sDQRcfY1oRE2P643tgdCTtQBGnVPnzgemgf0M9rlWnSnuzVs3YDLloRYVjuoP0YWs6BmFFWGeoG5JdsHen5OEiBzog30e+yS44nCBwnx2QSxGJRanv8dURVIaOqAfXHYvEnwE58cpY2UT4UHB9WT0rk97lUYXMi9/2E5StEerirvnCSzUOTtePK383RALfr5jlRBzCsxbLNXDYlhM0LN0csGuT9iPblCi/9xxc9Owz1KlVNME9ysF3m2qeR84QJbFwnguDePWTtRcYbYquJ5QACqQJg7Pc6WwrQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLLCT4dwFRy7LJUMUyXn91OVPcir524dmdpPovZ564I=;
 b=Nms/QxghNWIRrKq2XXxooccFzoEs5sKSdlRq18Xgr2cb9IpVd5SWkeZkZCmeuhWIV4t0xQcKFCx8hXOQVawfNc4/52VwppuFhfotuccxHXKpC78iaIlSRkRskRxx4YlGPg+8eMKez2Ozv0YI0+EvDXIcaqzfkzbdWu6AQeXTP5VJQWANFQD/O7n2GxNYH1l5Vb02tMvAXBWAn8OkqhKyaDLvf7TYx1gj6FUUd4RqAxsWvlm4aZMatD4ALJShPdZ/flOzup5PSf0Y1AEMDwVsksOzJKzakY2qCNAztD5WJkcZXJt8XChdMAGPSAa4F7xyuYb65AR0fy/oIp7jo+Q0kA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLLCT4dwFRy7LJUMUyXn91OVPcir524dmdpPovZ564I=;
 b=YO+brKWPsq5R4FSWXIO1CDAfCjPD95cnqlOnx+NGNJ+LkBRTqSzlbEHZkle14GhTAD1jcmznlzmrc13GLFhSgKkEtDSJSYsNoXm5M05W9LvN7AYjM/iDEZKFc/zUl4oEzRGXmywpBIHMkf4DfBh8sM1xXxsl8W9g6c5ezhSrXbA=
Received: from PAZP264CA0257.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:239::21)
 by VI0PR08MB11550.eurprd08.prod.outlook.com (2603:10a6:800:301::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:51:05 +0000
Received: from MI3PEPF00008491.eurprd03.prod.outlook.com
 (2603:10a6:102:239:cafe::82) by PAZP264CA0257.outlook.office365.com
 (2603:10a6:102:239::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Fri, 4
 Sep 2026 11:51:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008491.mail.protection.outlook.com (10.167.240.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:51:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iSBYItMs4awLZROJ+6RWZkTAwerkVuTHmzA2FeanDyxBfrILx8/SpDZy62zwfzE/2VFoKUMzyLtO8lCoS4OnjHn1hteBqwFAINLbRPGJChCUfertaJlWPrU7AGgAuRwdxzt43uEEq/z/lRg+sMMvzisSOIsUrLqH1eP3cbRPsHd71jD+icrWb8rMEcolFTWX3hnIuW6zOL+e8vgTF6QKDLMq9eqZN5XuorgPJgvHaMp+W32nIeBfRhfvK5xdy1W2pyKz3LkNMK85mek2F2mjhl5SJZYJ2offc6NlB8bhoyHUz+OiWqkqXlLoDlSzSYnafSh2hl+d9iaunj/tjRx5Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLLCT4dwFRy7LJUMUyXn91OVPcir524dmdpPovZ564I=;
 b=kDoJ42uAnK2YaiAa3wTNo+5SOusEaonIdhBsvhwY6T5jxlF+JBLQ6CA/W5tFjFXpKMAvWp56jH4S4ntNB+H09m9x0dXbgibgnNvXsZu1YTaI9Xxp/iY6WSKRBxm05bk1jHx3BaomgXh/vK1ChIjrw5Sb6sNBOlyfntk6gmoONo4rAZJGXAem1dbIbWJcZRjM72DWV4Dcicsfigbpq38CrleeOhd5r8MMqdMWh0J7msO05SUbFd9Z2MdPHohIhMUt9Z76R1vOQrWfNGu7WslKSZ6QRjjZEHrx1fiT3ZzEyOWZdGTi5qf6Tno2hG3UuEVlaxsEQa4oynbJilrGCWEueQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLLCT4dwFRy7LJUMUyXn91OVPcir524dmdpPovZ564I=;
 b=YO+brKWPsq5R4FSWXIO1CDAfCjPD95cnqlOnx+NGNJ+LkBRTqSzlbEHZkle14GhTAD1jcmznlzmrc13GLFhSgKkEtDSJSYsNoXm5M05W9LvN7AYjM/iDEZKFc/zUl4oEzRGXmywpBIHMkf4DfBh8sM1xXxsl8W9g6c5ezhSrXbA=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AMCPR08MB999887.eurprd08.prod.outlook.com (2603:10a6:20b:784::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:50:32 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:50:32 +0000
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
Subject: [PATCH v6 32/49] KVM: arm64: gic-v5: Handle userspace accesses to IRS
 MMIO region
Thread-Topic: [PATCH v6 32/49] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Thread-Index: AQHdPGOXDUddesPKbkad6hyW+8kcQA==
Date: Fri, 4 Sep 2026 11:50:32 +0000
Message-ID: <20260904113404.4051341-33-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|AMCPR08MB999887:EE_|MI3PEPF00008491:EE_|VI0PR08MB11550:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fdb21cf-ec55-4707-f8cd-08df0a7accfb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|38070700021|3023799007|6133799003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 hmHih8fAplUk7v1x9JE0cppWXvzHx6UB/nfJAyqhid+Te1dRRo5n+Gh6LWmGTxLWip+eLRSvK6hm8+0Z2r08gBBwGcbYSU+aqDiWNpIiz4DPYI2BmSsKnleEGuG8aF6Bn3fN8Sa6ljVzI9VtaA+KcQVdZP18SregmtIgz/ba5AiTyJDWzk2gypLvkVXFAZB4SR8B3LIoPJNYIZbpo7EyYRPtngvft2sg5voXNs+93vcvqsy4SdLNETJD4deJgd/jnv4+I5pNyphuUD1xH1BQfZy9Am/7N3nV2GNvqKs8t5Xf9h1mfGLj33pouHJFNHo/gy2CF3nsIeYxC/kvpTsURBLVdHs+4i9jkcvVrGyGwssJ88whpFY0UcQgCP7uU2ilwbrQK8zutzh0lum00kVjO+TSIOrR9QHIUguxiVjA7VM5yUhxw8L3/Rcxc0Gxc+qL28roMdW8JDEfkIyvF/9M8mHcfafaFbH+B3WZwsl7h0JHL++bNtJ+WkWRKrdH2DwzahJwsOEZMnZJoG58lCvetaSG5KV+A4TTfGhRQZqH2olggLnUWasVBxEwg/F2IzoigdK3NpQ0Nkuqz1WqNevo3d4DD/+9P9d9eXMpDCHVJaxBKfpLBXmROA7+szSahGYu9FjlrlWp91Azs6jxUzC7DgrZPrbpMXt3dQii+u0UMSGpo14IQtQx/PkQeSDX03ktI2IOhvXsgLslqr7QIDD4BzUer7nj2xXSiGsQSMeVQqg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(38070700021)(3023799007)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 l6xOvurzBAcNpa9sBMO+EeOGtiQElJm14VjCuQHAqnAzLgeY7UziJKEDpjrdhiCauHWTICJIPziuz8ZtgcmhKJdEh331HToxwteCFgq2ccTjqyVn/wn9hWMx85rfVOkrx/VFjH/Iho7xbzOuGw+DR68WhjGuEhE+p2qNhF/dJf8xYVzSEVrR6YIw8rEQq6zDo0uBCjef7jlDkQSrCtbwHQXsciejrjJwA8c4741rXYfEANZe+mR+NIXoFoYqxkYbckMcA0mVgf3MkdSDxTwILK8O3KaULxDQfXK2LCxi+hr+XLAaOkESu6xe9Oo2hPbvOhXZVYKLk9lkVCKeRKPKDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB999887
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008491.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f35f76c7-7144-44df-f76e-08df0a7ab9ab
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|35042699022|1800799024|14060799003|6133799003|56012099006|10067099003|11063799006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TdTwQgmJ04VoaCx3EAFjKhR81e4hV4OI+XFp/pXrpql+6i1BTPiGj5Jcokqr7Qt0+W/TA+67lFpqMGYD0/TRki9jNEfu2GCBCq+cvdUfkEj4xtwFTZVKouloCd6GzHiAcX2Nv9gmD7Y2rEYsbm5rzsZrhjNajmvisxq5VqhUbzpjX8BbumJOLudi/HmyrbxvL6RN0luBg0+5wX27f03hysEofHiXkpyPA1GP1j4vHQY4s6WWvImrhcT6HGkl69xJL5906pRUXxvJ/lTpitlJIzmiG4133xvmjLef4d+VVrJYKHT0tRJsZlQvGBPFt+BbbIu26IhZDrUlXqMZ0axROjgmDoxLlv1nFZhbZ5IlXdZmmhqQtMy5cvY2GQqS6rVnRVKA7ayg8nXC9HE5LByIb8M9/GNyBGX8NCxrtxFwqcWfIOnzKvWRMUUbAwonzdjA3XV8uJ75m/Zex9PzJHHISTN1+I8H+bf0spbt9cv7NIHIYrcVdKzT0egjq8Tvytv2nTVNZCZIniVWG8/au/WEuDIUgVS1c7eMw+0Mq1+8ce7bk13IfK+/g8Ilh69vxE6Kzh+FdgxLPqM8qjWY+nBdjwCNmKdFP/nypuMbU7cCqXZGC0uprldPiiUA1iJYa0vcvLJtbaFre9pcaslGeVbXuDbJ8kbDvbfyhs8GDq96LQA=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(35042699022)(1800799024)(14060799003)(6133799003)(56012099006)(10067099003)(11063799006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OWm32pSQtK+Ab8gEZCyHPmK/mSOK9yKNKDCfSMz4vZQGLtODD+Sqw+3jAqyKawBhC/4NEZd4IFrQjd5RI2Uoe4tcRXA9vM6vGPHSm8jNU+Vqs3c/iQYBGG8UpZzcBJxtdL4wznGga5W5o3uv2vyGTu1fNz5s8FCvpl935K0DEc1E/R09sKaxXcZZQO9+uNuwfwbnyp4Ua1Xk68xND1YuMUM53CCOv+CsMTyxQwH9khuynaqAKxlnNe40W35EUZjgt/gz+juFrDvu8qCWKdf37s10x9gIeVNjcddsuFbvO+X4d5i9K7E4O4A3CU/4qKEwPKdDihnpAV6LXyhRwfS1UWwfdc+pQaKQevUEKH4NvY/xHdLRzHHADtIrJElOQWnxWy0ezDb4iCArOStOOgdQ88Wcb7gdGArt4Hgp1B7kabABrQiF+i9663YhxlUb/Oca
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:51:04.9215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fdb21cf-ec55-4707-f8cd-08df0a7accfb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008491.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11550

As part of saving and restoring the state of a GICv5-based system,
userspace must save and restore the IRS MMIO registers. These include
important information such as the guest IST configuration, and KVM
must present consistent state to the guest after migration.

Introduce KVM_DEV_ARM_VGIC_GRP_IRS_REGS and provide accessors to read
and write the virtual IRS register state. This is modelled on the
GICv3 ITS register interface, as the migration requirements are
broadly the same.

Reuse the guest MMIO handlers where userspace and guest accesses have
the same semantics. Add userspace-specific handling where restoring a
register image must not trigger the operation associated with a guest
MMIO write.

Validate restored ID register fields against the capabilities KVM and
the host can support. Restore the emulated IST configuration without
allocating or freeing a host IST, and report operation status
registers as idle. Accept writes to IRS_SPI_CFGR, IRS_IIDR, and
IRS_AIDR without changing their state, allowing userspace to replay
the values it previously read.

Restoring IRS_IST_BASER.Valid recreates the guest-visible
configuration, but the host LPI IST cannot be allocated until
userspace supplies its contents. Track this as a pending LPI IST
restore and reject guest entry until userspace restores the IST
through KVM_DEV_ARM_VGIC_GRP_IST.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       |   1 +
 arch/arm64/kvm/vgic/vgic-irs-v5.c       | 460 ++++++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-kvm-device.c   |  55 ++-
 arch/arm64/kvm/vgic/vgic-v5.c           |   2 +
 arch/arm64/kvm/vgic/vgic.h              |   4 +
 include/kvm/arm_vgic.h                  |   3 +
 tools/arch/arm64/include/uapi/asm/kvm.h |   1 +
 7 files changed, 437 insertions(+), 89 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 00cafa118a733..8a023ab54bff9 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -423,6 +423,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 06d2deb770a6d..9e9853b88ce2a 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -410,12 +410,70 @@ static unsigned long vgic_v5_mmio_read_irs_ist(struct=
 kvm_vcpu *vcpu,
 	return value;
 }
=20
+static bool vgic_v5_ist_baser_matches(const struct vgic_v5_irs *irs,
+				      unsigned long val)
+{
+	u64 addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+		   << GICV5_IRS_IST_BASER_ADDR_SHIFT;
+	bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+
+	return irs->ist_baser.addr =3D=3D addr && irs->ist_baser.valid =3D=3D val=
id;
+}
+
+static void vgic_v5_update_irs_ist_baser(struct vgic_v5_irs *irs,
+					 unsigned long val)
+{
+	irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+	irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+		<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+}
+
+static int vgic_v5_write_irs_ist_baser(struct kvm_vcpu *vcpu, unsigned lon=
g val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
+	bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+	int rc;
+
+	/* The address cannot be changed while the IST is valid. */
+	if (irs->ist_baser.valid && valid)
+		return 0;
+
+	/* Valid -> Invalid */
+	if (irs->ist_baser.valid && !valid) {
+		/* Make the LPI IST invalid and then ... */
+		rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd);
+		if (rc)
+			return rc;
+
+		vgic_v5_update_irs_ist_baser(irs, val);
+
+		/*
+		 * ... reflect that in the emulated BASER before freeing the
+		 * host IST. If the free fails, the guest-visible valid bit
+		 * still matches the hardware state.
+		 */
+		return vgic_v5_lpi_ist_free(vcpu->kvm);
+	} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+		if (!vgic_v5_ist_cfgr_valid(irs))
+			return -EINVAL;
+
+		rc =3D vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits);
+		if (rc)
+			return rc;
+	}
+
+	/* Now that we've handled the edges, update the valid bit and addr */
+	vgic_v5_update_irs_ist_baser(irs, val);
+
+	return 0;
+}
+
 static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
 				       unsigned int len, unsigned long val)
 {
 	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
 	const size_t offset =3D addr & (SZ_64K - 1);
-	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
=20
 	switch (offset) {
 	case GICV5_IRS_IST_CFGR:
@@ -431,90 +489,231 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vc=
pu *vcpu, gpa_t addr,
 		return;
 	case GICV5_IRS_IST_BASER:
 	case GICV5_IRS_IST_BASER + 4: {
-		u64 baser;
-		bool valid;
+		scoped_guard(mutex, &vcpu->kvm->arch.config_lock) {
+			u64 baser;
=20
-		guard(mutex)(&vcpu->kvm->arch.config_lock);
+			baser =3D update_64bit_reg(vgic_v5_read_irs_ist_baser(irs),
+						 offset & 4, len, val);
+			vgic_v5_write_irs_ist_baser(vcpu, baser);
+		}
+		return;
+	}
+	default:
+		return;
+	}
+}
=20
-		baser =3D update_64bit_reg(vgic_v5_read_irs_ist_baser(irs),
-					 offset & 4, len, val);
-		valid =3D !!(baser & GICV5_IRS_IST_BASER_VALID);
+static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu =
*vcpu,
+							  gpa_t addr,
+							  unsigned int len)
+{
+	const size_t offset =3D addr & (SZ_64K - 1);
=20
-		/* The address cannot be changed while the IST is valid. */
-		if (irs->ist_baser.valid && valid)
-			return;
+	switch (offset) {
+	case GICV5_IRS_SYNC_STATUSR:
+		return GICV5_IRS_SYNC_STATUSR_IDLE;
+	case GICV5_IRS_SPI_STATUSR:
+		return GICV5_IRS_SPI_STATUSR_IDLE;
+	case GICV5_IRS_PE_STATUSR:
+		return GICV5_IRS_PE_STATUSR_IDLE;
+	case GICV5_IRS_IST_STATUSR:
+		return GICV5_IRS_IST_STATUSR_IDLE;
+	default:
+		return 0;
+	}
+}
=20
-		/* Valid -> Invalid */
-		if (irs->ist_baser.valid && !valid) {
-			/* Make the LPI IST invalid and then ... */
-			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
-				break;
+static int vgic_v5_mmio_uaccess_write_irs(struct kvm_vcpu *vcpu, gpa_t add=
r,
+					  unsigned int len, unsigned long val)
+{
+	struct vgic_dist *vgic =3D &vcpu->kvm->arch.vgic;
+	struct vgic_v5_irs *irs_data =3D vgic->vgic_v5_irs_data;
+	size_t offset =3D addr & (SZ_64K - 1);
=20
-			/*
-			 * ... free the host IST if we successfully marked the
-			 * IST as invalid. Frankly, if we failed to make the
-			 * guest's IST as invalid, we're cooked because it means
-			 * that the IRS may still be using the memory that we
-			 * want to free. Hence, we leave it allocated and skip
-			 * the clearing of valid bit in the baser.
-			 */
-			vgic_v5_lpi_ist_free(vcpu->kvm);
-		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
-			if (!vgic_v5_ist_cfgr_valid(irs))
-				break;
+	/*
+	 * The following registers are ONLY settable via uaccesses. The guest
+	 * cannot write them!
+	 */
=20
-			if (vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits))
-				break;
-		}
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		if (FIELD_GET(GICV5_IRS_IDR0_INT_DOM, val) !=3D
+		    GICV5_IRS_IDR0_INT_DOM_NON_SECURE)
+			return -EINVAL;
+
+		if ((val & GICV5_IRS_IDR0_VIRT) ||
+		    (val & GICV5_IRS_IDR0_ONE_N) ||
+		    (val & GICV5_IRS_IDR0_VIRT_ONE_N) ||
+		    (val & GICV5_IRS_IDR0_SETLPI) ||
+		    (val & GICV5_IRS_IDR0_MEC) ||
+		    (val & GICV5_IRS_IDR0_MPAM) ||
+		    (val & GICV5_IRS_IDR0_SWE))
+			return -EINVAL;
+
+		irs_data->idr0.domain =3D FIELD_GET(GICV5_IRS_IDR0_INT_DOM, val);
+		irs_data->idr0.pa_range =3D FIELD_GET(GICV5_IRS_IDR0_PA_RANGE, val);
+		irs_data->idr0.virt =3D !!(val & GICV5_IRS_IDR0_VIRT);
+		irs_data->idr0.setlpi =3D !!(val & GICV5_IRS_IDR0_SETLPI);
+		irs_data->idr0.mec =3D !!(val & GICV5_IRS_IDR0_MEC);
+		irs_data->idr0.mpam =3D !!(val & GICV5_IRS_IDR0_MPAM);
+		irs_data->idr0.swe =3D !!(val & GICV5_IRS_IDR0_SWE);
+		irs_data->idr0.irs_id =3D FIELD_GET(GICV5_IRS_IDR0_IRSID, val);
+		break;
+	case GICV5_IRS_IDR1: {
+		unsigned int iaffid_bits, priority_bits;
+		u8 vpe_id_bits;
=20
-		/* Now that we've handled the edges, update the valid bit and addr */
-		irs->ist_baser.valid =3D valid;
-		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, baser)
-			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+		/* Ignore writes to PE_CNT as this is populated from num vcpus */
+		iaffid_bits =3D FIELD_GET(GICV5_IRS_IDR1_IAFFID_BITS, val);
+		priority_bits =3D FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS, val);
=20
-		return;
+		/* IAFFID_BITS is derived from the VMTE and encoded as N - 1. */
+		vpe_id_bits =3D vgic_v5_vmte_vpe_id_bits(vcpu);
+		if (iaffid_bits !=3D vpe_id_bits - 1)
+			return -EINVAL;
+
+		if (priority_bits > gicv5_global_data.irs_pri_bits - 1)
+			return -EINVAL;
+
+		irs_data->idr1.priority_bits =3D priority_bits;
+		break;
 	}
+	case GICV5_IRS_IDR2:
+		/* We always support LPIs */
+		if (!(val & GICV5_IRS_IDR2_LPI))
+			return -EINVAL;
+
+		/* We only support LPIs with linear, non-metadata guest ISTs */
+		if (val & GICV5_IRS_IDR2_IST_LEVELS)
+			return -EINVAL;
+
+		if ((val & GICV5_IRS_IDR2_ISTMD) ||
+		    FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val))
+			return -EINVAL;
+
+		/* We can't present more bits than we have support for in HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val) >
+		    vgic_v5_irs_ist_id_bits(&irs_caps))
+			return -EINVAL;
+
+		/* Min LPI ID bits must be greater than or equal to the HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) <
+		    vgic_v5_irs_min_lpi_id_bits(&irs_caps))
+			return -EINVAL;
+
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) >
+		    FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val))
+			return -EINVAL;
+
+		irs_data->idr2.istmd_sz =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val);
+		irs_data->idr2.istmd =3D !!(val & GICV5_IRS_IDR2_ISTMD);
+		irs_data->idr2.ist_l2sz =3D FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, val);
+		irs_data->idr2.ist_levels =3D !!(val & GICV5_IRS_IDR2_IST_LEVELS);
+		irs_data->idr2.min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_B=
ITS, val);
+		irs_data->idr2.id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val);
+		break;
+	case GICV5_IRS_IDR5:
+		if (FIELD_GET(GICV5_IRS_IDR5_SPI_RANGE, val) !=3D irs_data->idr5.spi_ran=
ge)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR6:
+		if (FIELD_GET(GICV5_IRS_IDR6_SPI_IRS_RANGE, val) !=3D irs_data->idr6.spi=
_irs_range)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR7:
+		if (FIELD_GET(GICV5_IRS_IDR7_SPI_BASE, val) !=3D irs_data->idr7.spi_base=
)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IST_BASER:
+		if (irs_data->ist_baser.valid &&
+		    !vgic_v5_ist_baser_matches(irs_data, val))
+			return -EINVAL;
+
+		if (!irs_data->ist_baser.valid &&
+		    (val & GICV5_IRS_IST_BASER_VALID))
+			irs_data->lpi_ist_restore_pending =3D true;
+
+		vgic_v5_update_irs_ist_baser(irs_data, val);
+		break;
+	case GICV5_IRS_IST_CFGR:
+		irs_data->ist_cfgr.lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_B=
ITS, val);
+		irs_data->ist_cfgr.l2sz =3D FIELD_GET(GICV5_IRS_IST_CFGR_L2SZ, val);
+		irs_data->ist_cfgr.istsz =3D FIELD_GET(GICV5_IRS_IST_CFGR_ISTSZ, val);
+		irs_data->ist_cfgr.structure =3D !!(val & GICV5_IRS_IST_CFGR_STRUCTURE);
+		break;
+	case GICV5_IRS_CR0:
+		vgic->enabled =3D !!(val & GICV5_IRS_CR0_IRSEN);
+		break;
+	case GICV5_IRS_SPI_CFGR:
+		break;
+	case GICV5_IRS_IIDR:
+		fallthrough;
+	case GICV5_IRS_AIDR:
+		break;
 	default:
-		return;
+		return -EINVAL;
 	}
+
+	return 0;
 }
=20
 static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
 	/*
 	 * This is the IRS_CONFIG_FRAME.
 	 */
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_v5_mmio_write_irs_misc, 4,
-				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_CR0,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_v5_mmio_write_irs_misc, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR1, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNCR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNC_STATUSR,
-				  vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SYNC_STATUSR,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_VMR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
@@ -522,35 +721,50 @@ static const struct vgic_register_region vgic_v5_irs_=
registers[] =3D {
 				  vgic_v5_mmio_write_irs_spi, 4,
 				  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_sp=
i,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
-				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
-				  4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_CFGR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_v5_mmio_write_irs_spi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_STATUSR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR,
+				  vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
-				  vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_PE_STATUSR,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
-				  vgic_v5_mmio_write_irs_ist, 8,
-				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
-				  vgic_v5_mmio_write_irs_ist, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_STATUSR,
-				  vgic_v5_mmio_read_irs_ist, vgic_mmio_write_wi,
-				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_BASER,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_v5_mmio_write_irs_ist, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 8,
+					  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_CFGR,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_v5_mmio_write_irs_ist, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_STATUSR,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MAP_L2_ISTR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
=20
@@ -789,6 +1003,94 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned in=
t nr_spis)
=20
 	irs->ist_baser.valid =3D 0;
 	irs->ist_baser.addr =3D 0;
+	irs->lpi_ist_restore_pending =3D false;
=20
 	return 0;
 }
+
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr)
+{
+	const struct vgic_register_region *region;
+	struct vgic_reg_attr reg_attr;
+	struct kvm_vcpu *vcpu;
+	gpa_t addr, offset;
+	int ret, align;
+
+	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu =3D reg_attr.vcpu;
+	addr =3D reg_attr.addr;
+
+	if (attr->group =3D=3D KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS)
+		return vgic_v5_has_cpu_sysregs_attr(vcpu, attr);
+
+	offset =3D attr->attr;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	if (offset & align)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Access the IRS MMIO Regs. Relevant locks have been taken by the calling=
 code.
+ */
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write)
+{
+	const struct vgic_register_region *region;
+	gpa_t addr, offset;
+	unsigned int len;
+	int align, ret =3D 0;
+
+	offset =3D attr->attr;
+
+	if (IS_VGIC_ADDR_UNDEF(dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_=
base))
+		return -ENXIO;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	/*
+	 * Although the spec supports upper/lower 32-bit accesses to
+	 * 64-bit IRS registers, the userspace ABI requires 64-bit
+	 * accesses to all 64-bit wide registers. We therefore only
+	 * support 32-bit accesses to 32-bit-wide registers.
+	 */
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	len =3D region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
+
+	if (offset & align)
+		return -EINVAL;
+
+	addr =3D dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base + offset;
+
+	if (is_write) {
+		if (region->uaccess_write)
+			ret =3D region->uaccess_write(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len, *reg);
+		else
+			region->write(kvm_get_vcpu(dev->kvm, 0), addr, len, *reg);
+	} else {
+		if (region->uaccess_read)
+			*reg =3D region->uaccess_read(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len);
+		else
+			*reg =3D region->read(kvm_get_vcpu(dev->kvm, 0), addr, len);
+	}
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 599ab4efc1db5..f1f1fcb08161f 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -786,6 +786,9 @@ int vgic_v5_parse_attr(struct kvm_device *dev, struct k=
vm_device_attr *attr,
 		mpidr_reg =3D VGIC_TO_MPIDR(vgic_mpidr);
 		reg_attr->vcpu =3D kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		reg_attr->vcpu =3D kvm_get_vcpu(dev->kvm, 0);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -831,8 +834,11 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
 				    struct kvm_device_attr *attr,
 				    bool is_write)
 {
+	u64 __user *uaddr =3D (u64 __user *)(unsigned long)attr->addr;
 	struct vgic_reg_attr reg_attr;
 	struct kvm_vcpu *vcpu;
+	bool uaccess;
+	u64 val;
 	int ret;
=20
 	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
@@ -841,6 +847,22 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
=20
 	vcpu =3D reg_attr.vcpu;
=20
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		/* Sysregs uaccess is performed by the sysreg handling code */
+		uaccess =3D false;
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	default:
+		uaccess =3D true;
+	}
+
+	if (uaccess && is_write) {
+		if (get_user(val, uaddr))
+			return -EFAULT;
+	}
+
 	mutex_lock(&dev->kvm->lock);
=20
 	if (kvm_trylock_all_vcpus(dev->kvm)) {
@@ -864,6 +886,18 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		ret =3D vgic_v5_cpu_sysregs_uaccess(vcpu, attr, is_write);
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		/*
+		 * The IRS registers are a mixture of 32-bit and 64-bit
+		 * registers. Internally, we always perform the correctly sized
+		 * access, but the UAPI is defined in such a way that we are
+		 * always provided a __u64 by userspace. When userspace writes,
+		 * the upper 32-bits are ignored for 32-bit accesses, and on a
+		 * read any 32-bit accesses are written back to user memory
+		 * using the full 64-bits.
+		 */
+		ret =3D vgic_v5_irs_attr_regs_access(dev, attr, &val, is_write);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
@@ -874,6 +908,9 @@ static int vgic_v5_attr_regs_access(struct kvm_device *=
dev,
 	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
=20
+	if (!ret && uaccess && !is_write)
+		ret =3D put_user(val, uaddr);
+
 	return ret;
 }
=20
@@ -883,6 +920,8 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v5_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
@@ -909,6 +948,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v5_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
@@ -940,16 +981,10 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		return -ENXIO;
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		struct vgic_reg_attr reg_attr;
-		int ret;
-
-		ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
-		if (ret)
-			return ret;
-
-		return vgic_v5_has_cpu_sysregs_attr(reg_attr.vcpu, attr);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		return vgic_v5_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index b940f7beeaa56..1552ca2da3506 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -773,6 +773,8 @@ int vgic_v5_map_resources(struct kvm *kvm)
 {
 	if (!vgic_initialized(kvm))
 		return -EBUSY;
+	if (kvm->arch.vgic.vgic_v5_irs_data->lpi_ist_restore_pending)
+		return -EINVAL;
=20
 	return 0;
 }
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index d5e041e1ad755..76d90558273a8 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -406,6 +406,10 @@ int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
 const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write);
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fd8d938f46500..7be81b936bf10 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -491,6 +491,9 @@ struct vgic_v5_irs {
 		bool valid;
 		u64 addr;
 	} ist_baser;
+
+	/* A valid userspace-restored BASER still needs its host LPI IST. */
+	bool lpi_ist_restore_pending;
 };
=20
 struct vgic_dist {
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index d1b2ca317f586..710a0d267347d 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -422,6 +422,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
--=20
2.34.1
