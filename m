Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011035.outbound.protection.outlook.com [52.101.70.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B4C42BC25
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101868; cv=fail; b=LgvLuVkthA4bc1wodXjCcavaluA2jP+0HY9oniU8I1z5mwtYF7Ly5Z58qLYRHdBP2YjY3JGsLYMTNj+yDDeV72bz5O2MPn/UGlVuJLCegA4QOERObpU0EuCJMjfkvhCwmNYnkIWmPUgnJXO+N94TbMGDLoVyPoUuPRPkhH/qbtw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101868; c=relaxed/simple;
	bh=7C3QiW5ft26OIhKq1Z+bH0R4p2X23n3Xwjaee1Ra4/Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ab1adixZDLKHSd927gUUgegOo0YznBjRdGPpRsx6pQf5ZpJ2f2Juu+4qb+e0iONlKlZDJVKIWLtEQzkwY1XpIVBe6O4vkK+BOe3m9RoD3Fl0zEv9M3wATlfiZhJOpvC/JqIIUA4RcF81xylv/R8nwW6ZdsPiEw+RYq1fC01LorE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cj3LvCnb; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cj3LvCnb; arc=fail smtp.client-ip=52.101.70.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cj3LvCnb";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cj3LvCnb"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qbnxKnQJIvjpYlctlLBgk/Spc+WjTEr4lS0QkZGc+335ZgHj86zFN1klCEUllyxMuRydlLqtyZe6ywD0zLwlL5evt+ytLvN/6r0QzgRcvWledQDUo0qF4RpBs5IPPyXa5zyD8Bs2B6kXd1ayoC9ciDE07S/q6B4PipqQC35qwOeu/WUw+tFR/Kk9nK7YRd/gTWzNkXtKvysKgMAVQh9HFcKkhzWHmQq2Zsq6Cw7fkZcVW729BuUBRwr06tr605eRBopLImPbu3DI8KryQXcDu2/Po5ciyMHv9yimEYE7csXujlofkktDHMN9hzxNWqHmMBkKp2jR702ctC8Cmhqxzw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=551PLcAiacabJ6vbDM68btDkoEdZqARbMQaguQ753mI=;
 b=wuknd8X2e11KLJKOlqQPMhh30IAVEm0HxQT0yoFXwT3fOWwNQSN5WCTkqsoXTmn3wNELsEfYdlPPto03ZDujzFbXyoCjnfAPjeMdVzT82l8cni27QHmK0iobOLfPMrbI79T0KmM6siEP74qmAosIFPh/BVDvY4bh4aov57WRyXVBswg8Hisg3vdRH35HHO+3BSj7Ojk3e+SzUlzcI/p66RJG+gDPyRscs3tR+ZiPwBeT1x7kxLM+pcNZ46/8CFUQVCnPEHQ8RMBEzO9PW3vksvzYEyyadoqyaortWOQq3vwb2Ftm04g4zgG/v4cu922f8lRGxljuGB4hpMM9gcEd2w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=551PLcAiacabJ6vbDM68btDkoEdZqARbMQaguQ753mI=;
 b=cj3LvCnbG5oDfqr26UOOSnuzDYdYiaUZU6nb2lwrkPfPEAhbaK9cf9VWS7RKT0InNj0O8LY9uZcdMOn7WP+pU81RQGx0F4Fd/LYLrUup50nG39iIynWkUdkIfztPq2dqEBpg/bAwKgxnMZmIRnpfn+zYXMRLbkgnvUL2mHUZHds=
Received: from AS4PR09CA0030.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::20)
 by AM7PR08MB5432.eurprd08.prod.outlook.com (2603:10a6:20b:10b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:24:21 +0000
Received: from DU6PEPF0000B61D.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::99) by AS4PR09CA0030.outlook.office365.com
 (2603:10a6:20b:5d4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:24:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61D.mail.protection.outlook.com (10.167.8.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:24:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AanDGSYQgoAOIPWfTU0ISMrM9js205z87suN2viiXf1AqWrObMpwq6THBZSAkLcwP2oGb3j6ce8vFHmp306ECTiePXTqyWLfTnc6k3lvgyPPItwkf2BF3w9rB8rc9QAp1wOYxBhBmRUHgSDzefGiOPHKAO1j/QZPgeSq0wCYoo7OS08w6A0wgSNTUK1sAopUyzUeFznZkRI0r/MvbWmtkf8jT1M4wVAF1yzwR9xw0bZqbvXCr89GyU/DGrHldz1f7f4UTLEhmbx55RzWrws2trFVQECiDmXrnbAEsKq53sM2YPGzej+xljVWs9Fj1fT+ipZzTJbFukzMyv87yFGDCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=551PLcAiacabJ6vbDM68btDkoEdZqARbMQaguQ753mI=;
 b=AYWGcC0J5dI7bvbMoyXelkQJ5REQnrwTGm7IbetnYzusdMuS8ip5uw2UY5pv8fLvba/ksREOujouV19E8yT19TlpcMmHHWo47a9MsxX9Eul/7GcnC5rVk1Zl/igLAld+BY2nAxeM07IavGx/AWaLDpde3gtm83fWcklkSWiLLUjUEhidAHRMZWve5e8+v+ViFMq8610IsH+EoLfKCGfaNvJYSNqbJcGp7dcZ5/B+5dfSAnZFfWOZRFr275w+d4psz4iopT5hgJIRK2yANBNXSRmZjA4U83KxLXFg6zwMJVjtNvRmuV34rIAFZoYqPw3rqGCE1hIZlH394jB3XTpXSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=551PLcAiacabJ6vbDM68btDkoEdZqARbMQaguQ753mI=;
 b=cj3LvCnbG5oDfqr26UOOSnuzDYdYiaUZU6nb2lwrkPfPEAhbaK9cf9VWS7RKT0InNj0O8LY9uZcdMOn7WP+pU81RQGx0F4Fd/LYLrUup50nG39iIynWkUdkIfztPq2dqEBpg/bAwKgxnMZmIRnpfn+zYXMRLbkgnvUL2mHUZHds=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DB9PR08MB6729.eurprd08.prod.outlook.com (2603:10a6:10:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:23:48 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:23:48 +0000
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
Subject: [PATCH v5 22/49] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Topic: [PATCH v5 22/49] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Index: AQHdJl83UrdzY5MOAku2Jdqg9Jixpg==
Date: Fri, 7 Aug 2026 11:23:48 +0000
Message-ID: <20260807111159.429128-23-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|DB9PR08MB6729:EE_|DU6PEPF0000B61D:EE_|AM7PR08MB5432:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d13843c-e529-46f5-37cb-08def4766d4e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|18002099003|22082099003|38070700021|6133799003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 OEE5fJb46a987tC3zlEz9rM/vqtgwA9FbT0ZIRa/fPtTLwqusFqp8FcyzsSLOoVTQto7dQ/pYIUSKoFE6aO7ypN2uLlboQ3soAFmKy7sQDCnk8hdBcQWaB7e3fQzxCcImpiRyPWOM5oOe50bQPN4rGohBoxo7YlUmNQb1xp0itbAWwVloX+OfWmo3iDsMqihbo5bVRxct6Wg6t7/aUFvkJyetgkBtru3dgw1jMOKaYuTWGKQWh+kU1DpLkxFVCw6N7dav4KeQjbH8Olx7gvqB6A9iUyPw2YSSwwbjpdTHQM3bhS2KJ6xFAdPcX2D7iQrOgKnTvLfvoyQxZIE84N/SMgtGYDk3y2HXDsuR55r3b7J9HANnMtg/ps8mRdZ1TprlDOuWEt1pbsvo9zGYI03PQvnXOqfkQkLmk58wHv6HAyeS2Ym14yukaTGZqj5LxFKRCguTXY7MFdaxd1a5qVLeV21FGV5iqlldHAXMPeJYbotvXGEK7tAO1BkvBPSAvS8AZkShk3uCWgk+TH/2GCj0+b//UQcmapu4DqXoWqnJa5IT8ycF/qd9jAfhyBwe8CrCBZBAIXaSMB4r2pbUQZxwrEQu0VTYUUyZkBh+n9SYzlXYHNBvluUa3koCDBPE4WCiL5ORNOLc1QJlovY+vBDjCGMrduQK++mn0/z5R1v0zP++fqJiCMvx+AqBoUsxZ4/KmBXfe15VQeWz9OW2vAjZK+QZt1s78HVf1OPSTP/m3U=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(18002099003)(22082099003)(38070700021)(6133799003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 C5fTnmwtQdJS0SUNmqK1MradFbgnxaRqtnRRxowmeoYJe21uEe0eScc1sQG9uTLhGeoUHi+vlHBz7XjI19jnTayI6LOR3/wgGGhJzp9yqDrwgJ9AvXq9E8+AH4+XM3/g47eAqhuzxd6GUSpdidFVdQwP/4dYLm8SUA63ZFkM3dvoHG+an5mZs7U/NFSYXMja2bIxvA0ktKKf0Tb8qCtpWDlXM5Yb95OyT1R7aWTwmSD6o7DM857XNxYj9WhFn5tyT1D0kB1qtsh0OUX4rTESWac2euMjcjiRelsJMgYwNTXzWPWSppuBoPjU6mavxEqGWxeqxXiwFfLXqwhq4EqirQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6729
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1ab6fbe7-61b6-4fff-30b7-08def47659b7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|14060799003|23010399003|1800799024|82310400026|376014|56012099006|11063799006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FJjQnnqnL0Q0B1zgex4dW0A2NUI2QQ724q9NXnR9/M1mNcVhCRqWkX4QZOnlPEdNWDwh9hjq76HaGw2JT3Nk4RI+foA+A/NEZCGlXaQn5poT9MvzUzClNENOtX0L8AL11w9DT9uT0Hy0kaZvLGITFUjz9c91pxqx5gcIhHIviYu7WYo3Mn5W4PwGF9deT5iK7Wv7m1y86sX5MCTWQGGkokBNDC+diS8mkjXaKdCT97kCytXZxJqzN74ayqWYu/SRjViTJVcuzQU4B3czkZ/J+KSWqHymxFv8wjaEt2MESdBZMDiOUCOJQuvPXoIJEqglhixwb2wSljZLjwT9yGoEfCjF/JiS2UctHF8VZBDQWRucO5xnyhYOyCzl2aqz+mEG+H8Y/HWsjFZkFZiNBn0/ouhcCiobPgs3Qabhb5qgbVqZxE21rYh4BdxIXRFjubFzgCwpbxf4U1w2sMZS2Uxb/kPuwylvo92IJ89ElztjWUQKUKybsaJRBXgJ3VPVX5DvdIp9GWvUKJ8Yr+uq2rkp7pf3qDlQZU69MbOqQaAr0ZWEBNI4wHCVyVgs5P0sQouZ2zve317dXX/7XSN3a7ygEMgj0iJqj6V3sH8+/H9vmH9lccImUdO51tA0NH5KY28Jc6tpSoSPFDMDuM+VLF3ylUwtSuBKWkFp03HOCL/0/iKDJizUQHnU69hx99+SpEbQm22TiuQ9HnM9c5BhOqHoow==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(14060799003)(23010399003)(1800799024)(82310400026)(376014)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CUdVZf0rDrG50/We4SZBNiE8zJo4SYRwhQt9DosSq3rezt0fRw3qSIJe7zRukodPIJkVnQk/ZJmYL4DNnaEDWxr8NZVmXhPfEwE4rT1ljagoB0IT0F7EOY65E2T8wPoWXSHEYGkrznn8AzdDDRIhQYvSHjwkhLclj1J5ICU7WEs2V9XPFHo4nUyS2Anb5dkt5fMhayEO7G1wibEB5UrQUFyRVuAtSNLcUQTi6hyWsBAeEg3aVZb16K9inh3YV4N19Ocdt8tApHAEelABa3S2F8/DZusbrnqMvxdpxUq8qF91FOPOOoN3TSIsly7FrtGs6C+Nc3gBM6vfnMsbpOvNre8eqKq+ZfwbA7wkhVUcJDtd8LL2lH0uUNFprIhzuyRcKu5h2LpgdAh8MTt5kIH8LeFIc1LucHhdwtwgfB/qPYXYPKCmtIBSnvg1/Gd6yFu6
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:24:20.9227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d13843c-e529-46f5-37cb-08def4766d4e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5432

Now that we have an emulated IRS, it needs to be registered, which
ensures that guest accesses to the MMIO regions handled by the device
are handled appropriately in KVM. Therefore, as part of
vgic_map_resources, the GICv5 IRS IODEV is registered. If the address
for the IRS is not provided, bail out reporting an error - this is not
a supported config.

As part of this change, expose setting the address of the emulated IRS
via KVM_VGIC_V5_ADDR_TYPE_IRS to userspace. Also allow userspace to
set the number of SPIs handled by the emulated GICv5 implementation,
using a GICv5-specific SPI count rather than the legacy total
interrupt count.

Limit the configurable range to 32 through 1024 SPIs, in multiples of
32. KVM keeps one struct vgic_irq per SPI in a physically contiguous
allocation, and allowing the full 16-bit KVM_IRQ_LINE SPI namespace
would make that allocation exceed KMALLOC_MAX_SIZE on common arm64
configurations.

The default routing has one IRQCHIP route per configured SPI, so size
the common IRQ routing table for the largest GICv5 configuration. The
model-specific routing validation retains the 988-pin limit for GICv2
and GICv3.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c       |  18 ++++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 106 ++++++++++++++++++--------
 include/kvm/arm_vgic.h                |   8 +-
 3 files changed, 97 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 698bca671ffae..5b5d8a4da988d 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -686,9 +686,8 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist =3D &kvm->arch.vgic;
-	bool needs_dist =3D true;
 	enum vgic_type type;
-	gpa_t dist_base;
+	gpa_t dist_base, irs_base;
 	int ret =3D 0;
=20
 	if (likely(smp_load_acquire(&dist->ready)))
@@ -711,13 +710,12 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	} else {
 		ret =3D vgic_v5_map_resources(kvm);
 		type =3D VGIC_V5;
-		needs_dist =3D false;
 	}
=20
 	if (ret)
 		goto out;
=20
-	if (needs_dist) {
+	if (type !=3D VGIC_V5) {
 		dist_base =3D dist->vgic_dist_base;
 		mutex_unlock(&kvm->arch.config_lock);
=20
@@ -727,7 +725,19 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 			goto out_slots;
 		}
 	} else {
+		irs_base =3D dist->vgic_v5_irs_data->vgic_v5_irs_base;
 		mutex_unlock(&kvm->arch.config_lock);
+
+		if (IS_VGIC_ADDR_UNDEF(irs_base)) {
+			ret =3D -ENXIO;
+			goto out_slots;
+		}
+
+		ret =3D vgic_v5_register_irs_iodev(kvm, irs_base);
+		if (ret) {
+			kvm_err("Unable to register VGIC IRS MMIO regions\n");
+			goto out_slots;
+		}
 	}
=20
 	smp_store_release(&dist->ready, true);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 90be99443df3b..8c2c6886af4e3 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -181,6 +181,14 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_d=
evice_attr *attr, bool wri
 		addr |=3D (u64)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
 		goto out;
 	}
+	case KVM_VGIC_V5_ADDR_TYPE_IRS:
+		r =3D vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V5);
+		if (r)
+			break;
+		addr_ptr =3D &vgic->vgic_v5_irs_data->vgic_v5_irs_base;
+		alignment =3D SZ_64K;
+		size =3D KVM_VGIC_V5_IRS_SIZE;
+		break;
 	default:
 		r =3D -ENODEV;
 	}
@@ -224,31 +232,48 @@ static int vgic_set_common_attr(struct kvm_device *de=
v,
 		if (get_user(val, uaddr))
 			return -EFAULT;
=20
-		/*
-		 * We require:
-		 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
-		 * - at most 1024 interrupts
-		 * - a multiple of 32 interrupts
-		 */
-		if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
-		    val > VGIC_MAX_RESERVED ||
-		    (val & 31))
-			return -EINVAL;
+		if (!vgic_is_v5(dev->kvm)) {
+			/*
+			 * We require:
+			 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
+			 * - at most 1024 interrupts
+			 * - a multiple of 32 interrupts
+			 */
+			if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
+			    val > VGIC_MAX_RESERVED || (val & 31))
+				return -EINVAL;
=20
-		mutex_lock(&dev->kvm->arch.config_lock);
+			mutex_lock(&dev->kvm->arch.config_lock);
=20
-		/*
-		 * Either userspace has already configured NR_IRQS or
-		 * the vgic has already been initialized and vgic_init()
-		 * supplied a default amount of SPIs.
-		 */
-		if (dev->kvm->arch.vgic.nr_spis)
-			ret =3D -EBUSY;
-		else
-			dev->kvm->arch.vgic.nr_spis =3D
-				val - VGIC_NR_PRIVATE_IRQS;
+			/*
+			 * Either userspace has already configured NR_IRQS or
+			 * the vgic has already been initialized and vgic_init()
+			 * supplied a default amount of SPIs.
+			 */
+			if (dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D
+					val - VGIC_NR_PRIVATE_IRQS;
=20
-		mutex_unlock(&dev->kvm->arch.config_lock);
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		} else {
+			/*
+			 * GICv5 reports a number of SPIs, not a total number of
+			 * interrupts. Require a multiple of 32 SPIs.
+			 */
+			if (val < VGIC_V5_DEFAULT_NR_SPIS ||
+			    val > VGIC_V5_MAX_NR_SPIS ||
+			    (val & 31))
+				return -EINVAL;
+
+			mutex_lock(&dev->kvm->arch.config_lock);
+			if (vgic_initialized(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D val;
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		}
=20
 		return ret;
 	}
@@ -299,9 +324,14 @@ static int vgic_get_common_attr(struct kvm_device *dev=
,
 		return (r =3D=3D -ENODEV) ? -ENXIO : r;
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr =3D (u32 __user *)(long)attr->addr;
-
-		r =3D put_user(dev->kvm->arch.vgic.nr_spis +
-			     VGIC_NR_PRIVATE_IRQS, uaddr);
+		/* Older GICs */
+		if (!vgic_is_v5(dev->kvm)) {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis +
+					     VGIC_NR_PRIVATE_IRQS,
+				     uaddr);
+		} else {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis, uaddr);
+		}
 		break;
 	}
 	}
@@ -748,21 +778,25 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_set_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
=20
+	return vgic_set_common_attr(dev, attr);
 }
=20
 static int vgic_v5_get_attr(struct kvm_device *dev,
@@ -770,21 +804,26 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_get_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
+
+	return vgic_get_common_attr(dev, attr);
 }
=20
 static int vgic_v5_has_attr(struct kvm_device *dev,
@@ -792,15 +831,22 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		switch (attr->attr) {
+		case KVM_VGIC_V5_ADDR_TYPE_IRS:
+			return 0;
+		}
+		return -ENXIO;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return 0;
+		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 		default:
 			return -ENXIO;
 		}
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 81a1f33b051a2..2c7f1274dcc2c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -31,7 +31,12 @@
 #define VGIC_MAX_SPI		1019
 #define VGIC_MAX_RESERVED	1023
 #define VGIC_MIN_LPI		8192
-#define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
+
+/*
+ * The common IRQ routing table must accommodate all GIC types. GICv2 and
+ * GICv3 need 988 pins, while GICv5 needs 1024 pins.
+ */
+#define KVM_IRQCHIP_NUM_PINS	1024
=20
 /*
  * GICv5 supports 128 PPIs, but only the first 64 are architected. We only
@@ -41,6 +46,7 @@
  */
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
+#define VGIC_V5_MAX_NR_SPIS	BIT(10)
=20
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
--=20
2.34.1
