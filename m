Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013009.outbound.protection.outlook.com [40.107.159.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101DB42E8FF;
	Fri, 31 Jul 2026 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785509731; cv=fail; b=q92f4y4jT18WpwW/FogzxZC5NJj0tj7aN45Cc2xy56piuMus4U80Gw2nyEM0VqKR4Ei1l5F5fmYDe6vRFrN2BTZqAPSyDwGp3MilniMKjkTLHO2jEaXOMU6SbNfN9GJY+zhqhq4xAOwagMFyC6a4ib0CBH0ZmZVDDo2rQk+KFnY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785509731; c=relaxed/simple;
	bh=uOLd+4Byw6+5GaF2PplNdT5bhx9qrFQqxLHhE6wgKPc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kjpsBlw2U8F8kYx/GmVxp7+04SDuaTe23Z0Zaxrz56EEj6pTUT0CiDVsq4xgFiHc4WIsD6/l1TK02/KqM8IhPqoUUqwaSzu4Dmays2QdiyBC8KHgyRMuZDir5eAX8KWCNhnMT97HCZgi7VSXlCKT/dab+o1Wq4B0/mY6/IC7D54=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TGE3YGM5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TGE3YGM5; arc=fail smtp.client-ip=40.107.159.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TGE3YGM5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TGE3YGM5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kt6NOyUI5xv4oge95XBMGSUnc9ZlEjVpCzP3YU3OphEoQf1ykHahWwS7w94huYQ2GtWEiX4O8cPezdMHoqXu3z9ZMNJYnJ6R5NmrPBjFJTiKO9OR22yvxjmET35L0HqE38xIFimFwCrHDl09XTAOVEEkna11jVELGRiw6vbnPqVl70NArtPpZ92G8uvfggm/nX5CZtWqkCXNaypdcUu1L6OOSo63f9riZ/bd7j5c3cdU9D41F269vWfwWoDpP9BdqbN97DY/gMDfxLrGqdT6wNhkQ/PmUdw8W0RE3DbV1uaxoyvo4La6OO2kxUuu+Xs2OD93Otwbemj8U3lbEeUHjQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOLd+4Byw6+5GaF2PplNdT5bhx9qrFQqxLHhE6wgKPc=;
 b=dN7yBPbOMQY2UGdRhFFF6jZJcL/oGUiXifoFMTnaCsBYQjQM55jIbqYK/K0tz22qGzwzdxFzmrdXt5Xd+WpO/FF9mY/CuxrVvtCCEEYs9c989ESTV6q7RdEmPWmaOYjewEGQGl+Ruslbk5/l4CE9tJ5QF1mMbMl+ws3AICc+12ksdcBTnqPp74AQ03kn6H7d6xMLY0aDniwsWUQzp6Qux2HcVvAiVjsSFVRiAI+ERJW4i+Whnuf9rJ/f5dteeJn9vgkVfltD5cngGa/TYZeLM4DFbcvupmUgh4NQbYR7GkX4AEw+J/HpSjkIgL4WrZKsIlakomKyz8g0E+OhOZD1xw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOLd+4Byw6+5GaF2PplNdT5bhx9qrFQqxLHhE6wgKPc=;
 b=TGE3YGM5jFGqzKYxBvc6K2f7gJOAhtS2O+lKJEg1Y3Og8vU7EOIsKA2xIBFtWwmo28r3UPHhmPygEz2mqIWf7/V3glmPL3sVeFx5vsbDEWXAy1kHIwEmEbNNz9rSx8y47aWCWp/dld0+C+/7l5YB7y4+2a9BBIvd4UD+JeIJOXs=
Received: from DUZPR01CA0109.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::28) by PA4PR08MB5966.eurprd08.prod.outlook.com
 (2603:10a6:102:ee::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 14:55:23 +0000
Received: from DU2PEPF00028D05.eurprd03.prod.outlook.com
 (2603:10a6:10:4bb:cafe::3) by DUZPR01CA0109.outlook.office365.com
 (2603:10a6:10:4bb::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 14:55:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D05.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 14:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U6jfsgxQZXC+ZkceyJ/H2ezNcclEr0zMvENVY5vEua8zptpa1bAYgeJaZf7jW2tTXH9vKuRaHvGEj7n3DhqMqIbv7Up4aJw2wFGMVu9dMfW+RqioItktKcZDzkCDtVJ7vuItEm/kYNw7TO0c22xpOz6RRNyECGNeWY+yvEF6L3fBae6M35WyBoKsTVJyy4YOV0dPm7cIkk9aVXFa1HW8ouP4PDdI32S1dPVenvlzTBbv7GAkNWV9vHYfu2s7/i0UR3AxU0jMgkhzzbw5dd2rtu3ENO0gmEUNFYs/disYjEOThuB1saXdK3UOi9BQSX13+lf2oYFHZFthL/uldFmvSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOLd+4Byw6+5GaF2PplNdT5bhx9qrFQqxLHhE6wgKPc=;
 b=O34HlAdk8m9R9yMK+XCsy37zsYSwXnoJ2OAjD0baEWDDyq3wbIMOm5QX45dCpo66z0qKG2qEAYszjzG+4Fv6s2oIwieWHu0/TndxQw/E14Tw622dAkUqugcqDM38oSCf1VfT85D6bvSGDJqwDHUngAe6E6UkzPxUI1+yuEhOVXDOitYMhOlMgBE6nM+ikObxW0UHipfM7jeywOjPzhG55bzAn0Z1hRTqosv4ctZULL5sTMMc6mrdX58jfRtVSANBOWf2aCHIkOKpCrBNYzJ4rCAhucuiLTZ/ExEJZkHWvTuDNSwRKYsZwnRJXXY4SqE9n3kUJPRmtNync1Nb6qpEvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOLd+4Byw6+5GaF2PplNdT5bhx9qrFQqxLHhE6wgKPc=;
 b=TGE3YGM5jFGqzKYxBvc6K2f7gJOAhtS2O+lKJEg1Y3Og8vU7EOIsKA2xIBFtWwmo28r3UPHhmPygEz2mqIWf7/V3glmPL3sVeFx5vsbDEWXAy1kHIwEmEbNNz9rSx8y47aWCWp/dld0+C+/7l5YB7y4+2a9BBIvd4UD+JeIJOXs=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV1PR08MB8036.eurprd08.prod.outlook.com (2603:10a6:150:97::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 14:54:20 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 14:54:20 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 46/48] KVM: selftests: Add VGICv5 SPI injection tests
Thread-Topic: [PATCH v4 46/48] KVM: selftests: Add VGICv5 SPI injection tests
Thread-Index: AQHdG1uc6R7Gov/4FkmMzX4dR4IH+bZ8lZYAgAssoIA=
Date: Fri, 31 Jul 2026 14:54:19 +0000
Message-ID: <b32fbfda34532beafd818073211fd5abb55ebeac.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-47-sascha.bischoff@arm.com>
	 <20260724121545.7B3811F000E9@smtp.kernel.org>
In-Reply-To: <20260724121545.7B3811F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV1PR08MB8036:EE_|DU2PEPF00028D05:EE_|PA4PR08MB5966:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f27171-8fd7-454e-fef4-08deef13bfc6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|38070700021|4143699003|11063799006|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 5gch0sJalhEuUCXHhNoNkmkTPFHIgXFeaPJgxYVoTmn+mll1hjnLyj8GxIXPJPdD+mmjyB8oVniHJ90a+mnlsoD8zB7ZBSUyBHJ5ZDdr/9VeTgzo86uH7VEEUieUsoL4xxUVQ5rHOaZrkP0/0Lsy3KWVas3K4Rta5+vlRcbt+lFfo3aAQ9bs2Q4vIRba4bquRL93Kmd+qTCpWmNbQGtgP9h0AW1eegZyhqFQNIpL/GZpx+ueQ2XYOjHzqyOlYM/dp4Bys73CZ4xg8jJ8GuSj3m1GpjR8TdPcabRmXSlkyRht1jHaD/NGPvyMgJXmt0utw0HF87wkBDQgRLyMP38FLVXILPNLVDon2pDuCC/3dlgpAJf7BIfToBJY/tqkjCqUTo6ODGsi8iMZzRkcMZhwrFZLTH+youOslqVenZNvZR8V77wCYKAoe6DITYp6hz6dTmJ6GZSVKZ2cA6QxjERHK7Y4C47m0CASZe7o1fdDpfnUQndt3hLtIBXHpc8XQ/oRqiABoZmpYVEG21bZ59MmOK/55bHX7lCWhUgHE07F+mP4CgH8PPhCpbBsvn5muLhf7nEDPrN2hubIlVnCYcOgraPQAdYamD/TPOlYAaySvfZqGI8mdYKWHbZdUdIBVvqH4ws2994Y1NudSg8RfodRkxAs6IQ2FDivRzCrl3H1G8vyOaooyv8fMj9KbkZDvUJh8vzRJywkrMrpyUKCfy7JkZkpQ7TLUNXgr6BsYMVlKzU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(38070700021)(4143699003)(11063799006)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E80BE3E0A395C4EA5EC642AE07321C3@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 B9Taa84GXKV09W6zteBIKANv2hExf1Jq6MfUXp/jhPGdS6vSS1AYN1g++HUaqnzmom+AHbOGPzMGKSPnspAg4PT9dEkHuy5FiMgHI5LrQANc8hRSnh1yeVU9IneCzTs0hHj1E5YM6+RX4yAJbmcfsLyOSoKOfNNligTQw+QrSMCIJD9U5Ae6R2cHsbRAN2whk+tj+xdcsp1sRieq4Z4JfWdiqaZWouSYNHhxMQE3x1kx9+Z7MbkNXkiY3/WrhOdRV4gpOua5zJBYX9+amC6G6tzNoxcqVF5Yo2A2s78bqVtKEflgK7aT6wM0+zVGvLuxUIe0JvImePX0YlPJy502Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8036
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D05.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7f749d4a-301f-4b39-9397-08deef1399f7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|82310400026|35042699022|36860700016|23010399003|376014|4143699003|11063799006|10067099003|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eYRIH1iKYHdOKOagLegR8qbTy+00UNeD1L+1LAD2oBgrqGG0oK6KaoJO0TJKmIvRwNXYjPUP6SJT1ycDI2sC9xfYb9H4zK8Lrq+JLmT8LVPKF4tMOp0lsxijShAPdjgY5dwcOC6grFFrGSpp91dZ4c5TVbzEAvRzp4EFoEEJlrkS/f6wJgY9NAOxm5wL9rGzPaDZON8qURunWLSyPx51RfIlua9x9mPIOjTnxzlkiZhgwM+9ySK1xD6wrHExPQwJb0/P+zy/8RFpmdDxqBQWO008JHNPs4y+7pUgyFT0stZby0x5zW3ATbI20tuNc6ybdq2SGaUEZLMtu2Vi/6J1xRvyDmMq7PQBF2GtJKXQ0/MXXLJXCl86hk+DFsvQYSMabCCsAAwxExfyfsF/UBh0V2Epu2dS8OwJgNpKdN3TAutkUPTpvlXEB5QCGF3lr48qgwK2F2wS9rFjWd+Ii+uUDS7O1NyJo+CmNv6uLzaAV9n47ctetVS8akj006ca+jLsV4x80KCFHs0br7ukrsnk7k8M7wV1xrWjBFsF5VL4CxeO3jVCw7dd/H3LRz67KY7AcyfNKgDSD9etIyzLsvSOKao+qbTE3NpO55uWGWUHGxbBAZXuSxZgD7ecZNLOV4PxTVZ4XTs5NQE7nur9Be38suAdcwjdeH6u4Gg5p7K673H4PBf/93lcbfP6cZq9A5MC1fCMjEdt2OKlymYPjrZC6Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(82310400026)(35042699022)(36860700016)(23010399003)(376014)(4143699003)(11063799006)(10067099003)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	d+hRJdAJsrx5fwnISGumT3DR7JPA8faamERRU5iuuxE+K916BmPeXqRIjfO9EhyxljDbptaDjKihcuP5Qw88/0NpQH/oQlAVrs5Z1oK3K5Gq+Fgni/sDQKiiHjkGgB4n1VpxKe3Wd7wmnBZeE24zUqZjFDLFHm1bDx5vxbHe5U/+paMU2zQcwGIMp3JPHUMj/HlL4xbVONcYXTvyncPrPILZnFjt85zcbMZbLtHxDbH+IEuTbA6CJ6HZhFldk1h3R74so1QvNRy+irUduIxQ/VixBZ76lmerGKwWzTt2UzW/74uj2OJZuYRcCpi6tz4IwcgyS5YFgv6hInswnO+AWrNZ7taBfItqjmnxhEDCveqfM05lLN3g2N0i8dRWx7kuko9L9e0vOHUoRqh0g0GFrLLcLzjJbcplrEwFrdXRdjiSlkwJFS1CmOXjr4i4xNB/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 14:55:23.3076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f27171-8fd7-454e-fef4-08deef13bfc6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D05.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5966

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDEyOjE1ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBXcml0ZXMgdG8gR0lDdjUgY29udHJvbC1wbGFuZSBzeXN0ZW0gcmVnaXN0ZXJzIGFyZSBt
aXNzaW5nDQo+IHRoZSBtYW5kYXRvcnkgaW1tZWRpYXRlIGlzYigpIHN5bmNocm9uaXphdGlvbi4N
Cj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbNDZdOiBbUEFUQ0ggdjQgNDYvNDhdIEtWTTogc2VsZnRl
c3RzOiBBZGQgVkdJQ3Y1IFNQSQ0KPiBpbmplY3Rpb24gdGVzdHMgLS0tDQo+IGNvbW1pdCAxOTQ2
NThiOTI3NzdjMGU3NmU4MjVmMDQwNjliM2U1MDZlZTE2NGYzDQo+IEF1dGhvcjogU2FzY2hhIEJp
c2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtWTTogc2VsZnRlc3RzOiBB
ZGQgVkdJQ3Y1IFNQSSBpbmplY3Rpb24gdGVzdHMNCj4gDQo+IEFkZCBWR0lDdjUgU1BJIGRlbGl2
ZXJ5IGNvdmVyYWdlIHRocm91Z2ggS1ZNX0lSUV9MSU5FLiBTUElzIGFyZQ0KPiBjb25maWd1cmVk
IHRocm91Z2ggdGhlIHZpcnR1YWwgSVJTIGFuZCBkZWxpdmVyZWQgdGhyb3VnaCB0aGUgR0lDdjUN
Cj4gQ1BVDQo+IGludGVyZmFjZSwgc28gdGhlIHRlc3QgbmVlZHMgdG8gZXhlcmNpc2UgYm90aCB0
aGUgdXNlcnNwYWNlIGluamVjdGlvbg0KPiBwYXRoIGFuZCB0aGUgZ3Vlc3Qtc2lkZSBJUlMgcHJv
Z3JhbW1pbmcgcGF0aC4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2t2bS9hcm02NC92Z2ljX3Y1LmMNCj4gPiBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2
bS9hcm02NC92Z2ljX3Y1LmMNCj4gPiBpbmRleCAyMmFlNzI2YjE3YmU4Li5jZWM5OTRhNzdjOTkz
IDEwMDY0NA0KPiA+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hcm02NC92Z2lj
X3Y1LmMNCj4gPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYXJtNjQvdmdpY192
NS5jDQo+IFsgLi4uIF0NCj4gPiBAQCAtNDEsNyArNDQsNzEgQEAgc3RhdGljIHN0cnVjdCBrdm1f
dmdpY192NV9pc3QNCj4gPiB2Z2ljX3Y1X2lzdF9hdHRyKHZvaWQgKnNwaV9pc3QsIHNpemVfdCBz
cGlfc2l6ZSwNCj4gPiDCoAl9Ow0KPiA+IMKgfQ0KPiA+IMKgDQo+ID4gK3N0YXRpYyB2b2lkIGdp
Y3Y1X3NldHVwX2FuZF9lbmFibGVfaHdpcnEodTY0IGh3aXJxLCB1MzINCj4gPiB0YXJnZXRfdnBl
KQ0KPiA+ICt7DQo+ID4gKwl1NjQgdmFsOw0KPiA+ICsNCj4gPiArCXZhbCA9IGh3aXJxIHwgRklF
TERfUFJFUChHSUNWNV9HSUNfQ0RQUklfUFJJT1JJVFlfTUFTSywNCj4gPiArCQkJCSBHSUNWNV9J
UlFfREVGQVVMVF9QUkkpOw0KPiA+ICsJZ2ljX2luc24odmFsLCBDRFBSSSk7DQo+ID4gKw0KPiA+
ICsJdmFsID0gaHdpcnEgfCBGSUVMRF9QUkVQKEdJQ1Y1X0dJQ19DREFGRl9JQUZGSURfTUFTSywN
Cj4gPiB0YXJnZXRfdnBlKTsNCj4gPiArCWdpY19pbnNuKHZhbCwgQ0RBRkYpOw0KPiA+ICsNCj4g
PiArCWdpY19pbnNuKGh3aXJxLCBDREVOKTsNCj4gDQo+IFtTZXZlcml0eTogTWVkaXVtXQ0KPiBB
cmUgaXNiKCkgYmFycmllcnMgcmVxdWlyZWQgYWZ0ZXIgdGhlc2UgY29udHJvbC1wbGFuZSBzeXN0
ZW0gcmVnaXN0ZXINCj4gd3JpdGVzPw0KPiANCg0KTm8uDQoNCj4gVW5sZXNzIHRoZXNlIHNwZWNp
ZmljIEdJQ3Y1IENEIHJlZ2lzdGVycyBhcmUgYXJjaGl0ZWN0dXJhbGx5IGRlZmluZWQNCj4gYXMN
Cj4gc2VsZi1zeW5jaHJvbml6aW5nLCBBUk02NCByZXF1aXJlcyBhbiBpbW1lZGlhdGUgaXNiKCkg
YWZ0ZXIgZXZlcnkNCj4gY29udHJvbC1wbGFuZSBzeXN0ZW0gcmVnaXN0ZXIgd3JpdGUgdG8gZW5z
dXJlIHRoZSBDUFUgcGlwZWxpbmUNCj4gb2JzZXJ2ZXMNCj4gdGhlIG5ldyBjb25maWd1cmF0aW9u
IHN0YXRlLg0KDQpUaGVzZSBhcmUgYWxsIG9wZXJhdGluZyBvbiB0aGUgc2FtZSBpbnRlcnJ1cHQg
dG8gY2hhbmdlIHRoZSBzdGF0ZSBvZg0KaXQuIFRoaXMgZG9lcyBub3QgbmVlZCBleHBsaWNpdCBz
eW5jaHJvbmlzYXRpb24uDQoNCj4gDQo+ID4gK30NCj4gWyAuLi4gXQ0KPiA+ICtzdGF0aWMgdm9p
ZCBndWVzdF9zcGlfaXJxX2hhbmRsZXIoc3RydWN0IGV4X3JlZ3MgKnJlZ3MpDQo+ID4gK3sNCj4g
PiArCWJvb2wgdmFsaWQ7DQo+ID4gKwl1MzIgaHdpcnE7DQo+ID4gKwl1NjQgaWE7DQo+ID4gKw0K
PiA+ICsJaWEgPSBnaWNyX2luc24oQ0RJQSk7DQo+ID4gKwl2YWxpZCA9IEdJQ1Y1X0dJQ1JfQ0RJ
QV9WQUxJRChpYSk7DQo+ID4gKw0KPiA+ICsJaWYgKCF2YWxpZCkNCj4gPiArCQlyZXR1cm47DQo+
ID4gKw0KPiA+ICsJZ3NiX2FjaygpOw0KPiA+ICsJaXNiKCk7DQo+ID4gKw0KPiA+ICsJaHdpcnEg
PSBGSUVMRF9HRVQoR0lDVjVfR0lDUl9DRElBX0lOVElELCBpYSk7DQo+ID4gKw0KPiA+ICsJR1VF
U1RfQVNTRVJUX0VRKGh3aXJxLA0KPiA+IGdpY3Y1X3NwaV9od2lycShSRUFEX09OQ0Uoc3BpX2xp
bmVfZXhwZWN0ZWQpKSk7DQo+ID4gKw0KPiA+ICsJZ2ljX2luc24oaHdpcnEsIENEREkpOw0KPiA+
ICsJZ2ljX2luc24oMCwgQ0RFT0kpOw0KPiANCj4gW1NldmVyaXR5OiBNZWRpdW1dDQo+IFNob3Vs
ZCB0aGVzZSBzeXN0ZW0gcmVnaXN0ZXIgd3JpdGVzIGFsc28gYmUgZm9sbG93ZWQgYnkgaXNiKCkN
Cj4gYmFycmllcnM/DQo+IA0KPiBTaW1pbGFyIHRvIHRoZSBhYm92ZSwgd2l0aG91dCBleHBsaWNp
dCBzeW5jaHJvbml6YXRpb24sIHRoZSBwaXBlbGluZQ0KPiBtaWdodCBub3QgaW1tZWRpYXRlbHkg
b2JzZXJ2ZSB0aGUgdXBkYXRlZCBzdGF0ZSBiZWZvcmUgdGhlIGV4Y2VwdGlvbg0KPiBoYW5kbGVy
IGNvbXBsZXRlcy4NCg0KVGhlIHBhcnQgdGhhdCBuZWVkcyBzeW5jaHJvbmlzYXRpb24gaXMgdGhl
IENESUEsIGFuZCB3ZSBoYXZlIHRoYXQgaW4NCnRoZSBmb3JtIG9mIGEgZ3NiX2FjaygpIGFuZCBp
c2IoKS4gVGhlIHJlc3QgZG9lcyBub3QuDQoNCj4gDQo+ID4gKw0KPiA+ICsJR1VFU1RfRE9ORSgp
Ow0KPiA+ICt9DQo+IA0KDQo=
