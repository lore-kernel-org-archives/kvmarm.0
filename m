Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010040.outbound.protection.outlook.com [52.101.69.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3839D2C0268
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.40
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306666; cv=fail; b=cfCaRRRxZkVgtL1/5F7Zk1qPL5CJOhHuG82Mb5rqjDc7zQU8GAZ5SjnxYehdeVXvWvNJXrWGbI1hk+cuy9DZWqx0ZhZAknfF8tEJuMfe5tSfvGFMYDGZXzF58LPKWUJP44LkZoXZSmg8zKeeTvTivp2u9pXEzFZ3RokkbD+/qcQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306666; c=relaxed/simple;
	bh=Ya0Tw/TbNQIaFp9A7hS88B6Xzka0Cpzs7wwphk6Kj4w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iOIIgVfaIXloO8fVnYxxH+kGWRdVvKiXJ1Ksp/y1nrCPnwmGy/TyjrfTGaspr00Mgn9Ce4iAclUZiajD2aOLBYqaf2BJyFMnekWfvcoXUFxHYeEq/xeYbCsh/WEGdAxDwFUXMr3VFJ+Ruza+UIMs3rz2rRFbJAgbvCcijMaL4c4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AbtU6AEq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AbtU6AEq; arc=fail smtp.client-ip=52.101.69.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AbtU6AEq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AbtU6AEq"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UiMvmojuNCU+2SareEni5SjoxKVTAPqBjiMoR2HRBcYGJgOS2xE6fnhHnGnIv2eEHspaenyAVcDC11ML+L7yX7lwU0SE6FBsIOjg1H/94c48dnylfcW+iOgN5KafyuyVkRRrs0FhdK0W5CExjgR6jrKeXjtwf5/4tOEIcvmeV/i7Lq/pqctuPXGlyd2BX0ZDZE9SQVlaCA58FHFAUcCWaoov4VUOxPppKXPzFuPY9BBMrOaEUEMrp4KWRzFgnuhcsGQpU80rI2QN3Ck/phgxqhO3BhnBNmgzsDaIGsqqfpSl2HhFUuWA9rGmPwgiZpufM2PuwVlkEvpfLMQ7j8JYIA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NO2z13kuZ24mEI98Y9mf/Y76tk6w4DDvc+oDrAjtZxs=;
 b=WScxsyvV22LL/5XXNdwJV2vMr//Ux16ftqGexfiTwCvmkaV/PwjSdoNShmyCxXWaJUvmauF0uF+wzmTvpGgH0l2gDZ0m2yoo84M8ZahriPANMA3bcA2arU7+zwgb2lwpiFkBLUxr3kurSvasRMzU4q+iu2SppnwAWqUVoMULfqRlFPbfG+NoamtIh7y1paaQl1xp2tsYphQ2fMfVvTJreGoGofCGSZDnfjPvRHIla8kGirnp7CYxcWoPVlGwzO3y1kEw9M8doO/RWrz2QNPS+EXybhKSSsKzOdOSxSnkpm3Y94mTl0amGKAujF09CcOz5C8z8RBJHiTlV4K3kwa+mA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO2z13kuZ24mEI98Y9mf/Y76tk6w4DDvc+oDrAjtZxs=;
 b=AbtU6AEq/jP9ZqldU4b07q8VxbPwFt210EndDQuDbVK5xCZm+n/+17lfhZvssL6WerHcu8yWJMXKqIb+H0N3yKto16QM4vTZQEqP5xpaQuriwXpWEBL/tFkndzL8D4DBEk4+p2XflLrJRYZdE61D7lHWf/ckoZQ1G5UYNhXXt6A=
Received: from AM6P192CA0067.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::44)
 by PA4PR08MB6080.eurprd08.prod.outlook.com (2603:10a6:102:ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:17:40 +0000
Received: from AMS0EPF00000196.eurprd05.prod.outlook.com
 (2603:10a6:209:82:cafe::9a) by AM6P192CA0067.outlook.office365.com
 (2603:10a6:209:82::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:17:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000196.mail.protection.outlook.com (10.167.16.217) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:17:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EWFofhNZKCM1kNJuk1GXbNiMiwr084y5Aw8dOxH779np186uvd/20ZgXbUoZTPVfF1wXm3AWHXClspcQxcTi6PU+EKYngB+A5fci+kkRXsp8SXG4eCuICc3J8OJEWxLHxIk/MD5VHV39uAIQ/T+J7B4IWOdugHpLvriztWcFuihpxfSJYW7n1IOwFu1p2eanVFjy/ktdRcG3rv7r78Q4B1pyST5pty1BJzPY0pFLvUsRDBK7S8UHwp1DGqxU2oh2Z1nofNv2hpxUVBBw/TY4VA25cVqg2qVRQar/AlWKDEagz8wehZuYCqhaO6agxd8Ci3jGZxfgpTiH2amHgu1zAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NO2z13kuZ24mEI98Y9mf/Y76tk6w4DDvc+oDrAjtZxs=;
 b=rwrq6avFzLcT/LOVS8D7muxjuumM7dhP+ZkxOkdkN9x2v0KyPT5zs0tEECy+VN+COB/5/bMX5MVYFGocuBJxCfzaTIYrjBo7PlkIm1AfJs1/n8xBld5IHdBObGatf3R94eifG3KtzBuR1m6+/NbEssnlmQiBHTfT0lTNcQI1wmVGg5OlzNMNaj7WWs+23no/XjDIf3qFND06ljbL7eNqOZkPHQxTOXw6fnDFoy6oZA4XShMR7FkoNSMjw+RmusN3ZwYptz9uQ4bCyOfSDEfJWf8yePqQzU8iQKQzF0NiTWpBexHGlM390C7lI599CcwasauuZ4xhORHORvcg+MyQgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO2z13kuZ24mEI98Y9mf/Y76tk6w4DDvc+oDrAjtZxs=;
 b=AbtU6AEq/jP9ZqldU4b07q8VxbPwFt210EndDQuDbVK5xCZm+n/+17lfhZvssL6WerHcu8yWJMXKqIb+H0N3yKto16QM4vTZQEqP5xpaQuriwXpWEBL/tFkndzL8D4DBEk4+p2XflLrJRYZdE61D7lHWf/ckoZQ1G5UYNhXXt6A=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:16:37 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:16:37 +0000
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
Subject: [PATCH 31/43] KVM: arm64: gic: Introduce set_pending_state() to
 irq_op
Thread-Topic: [PATCH 31/43] KVM: arm64: gic: Introduce set_pending_state() to
 irq_op
Thread-Index: AQHc1mE5iQw0HLXVckiU8RVYbOpyjA==
Date: Mon, 27 Apr 2026 16:16:37 +0000
Message-ID: <20260427160547.3129448-32-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|AMS0EPF00000196:EE_|PA4PR08MB6080:EE_
X-MS-Office365-Filtering-Correlation-Id: 284d1e76-4fe0-4032-ffff-08dea4788110
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 rAUOACWJUdF5g/OvuvOW4L6avqOPOS9cr5petTArx26mtWwWEq90Vb6S1NnGaauGnPUDxqW3B0KEnAD6WT9VxoRB9c8rrTmGXnAxsc5OPyUsA5iG0s8mgiCq9W5W9Xb+iNCcg2LKU/40Es7ePu05F2KbQ4Is+HRbdyTw45lRGqhLw9eS4ti74ZvYTeQa8cvI+6FJaRjmA6wbNRxG20Gc7ys2YebBU8Y2oOHqh16KPWnjoQwgYFInoQp9KYTrfDy13Ly3/fxCKgMBtPbz4WY+ZQo5MyDe5IkrpThdLeNo+vQBNKpec4hjIzYclt2KRBwOwpwvU5Tt6rCdzhqAeMMCMxC2W4ln0/nVP+8UXv4xBcIpSZyP/8F4IjIXRKY0j4JVNXEQ+QJmxmEsYhLMvdHvm/bvPGMO0hSBPN3om40PlkxFYI+nPCtkX+fZQ1cG4IVrj/ZkkaD1Wg0+h+3Q2oAgIRObFTGjWnbaPj5nGOKkX0h4tvCrtAQLccM1+enwsHjTGbMFLpYp5fRsyfyrpjqw+LOl9Qj7GZXp+VXTwI8x3kztFy6AY3K67qZdh/UqjWEJ8csnDBRSgWw8U74aePdgCsoLvWdgDRXU+EYwL11HPiwEU4nLuJIheNlvwLzJK/HT1u56atCziert3t1T0luy5uwnrN7qcOVyGQ24oHLIH3PASgvUuXyb3e4WnfchMGkhhc0vteeiCg/UbEvDhx863pN05iqQmHM6udOr6qf3ekga3luJwFgE+tMesBMcK3jlxMRvXdmnZV+XzuZ5DlLeGz6bP4yadWNTaQBzDw4OTn0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 p8O/6Qja84rtuRUM3T+Xorccf7XQqoHnhEGpUpSWE3out7Whb5jhnOsjjG3iwB8fHU7pt/3ApshluRNkVeWi/jQgFn0CA1XpXn9xziz0hF7tkeN5Pg+KyQPSIWZDYuf6THAW7myY5p46d+3/ZhZV151k9AO4MFgAhhqGKXYY3oY70/N1FCde24AY+W4tDnDoH5ZOI1U3/iXn+UTVrs+qXSJvlex7A4QIMTxl4R4L2zUmedWEQ5jBCo0SxTgIUp4qfv46oXPMhKBdPZmOI6ehQMMnuR9eTO9mNSLusfo0/wdstfIIuUdWEHKSS07RNxCPYbzH1Kjku6ZNAwOZivymSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2fbb0fbc-5a03-43c4-c0bd-08dea4785bdb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|36860700016|14060799003|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	TOW/E30pEUJstmHwO2ZTPKpEw/YZkuELtWz6l2tlibStNOMmHLJCctAxswWm4VefzPTTOhCO+beeA1fcHv6lU0oZZxOlHWv4dRlXp440wHI8uPMYu53vDHQNtxDibvE3jo1dzz5+wX1B1ELhZ8UE3lyYYgt2zwEPYlYVFGrHwxQ82mVPadnDjY04CV+qAb7Q5AtOEn8du3t6PQ/xjG690k6MFkDs6t7sHPGuxqziTEnWP7Anps2gut+zmkP33EpRYCEAcJ5fWr/7ABI2uEeU8nqMuEvpX96OYMAxobehY2koM07GCRkyRf2dLk2CFkq66fo2lM+mz0SPI/32pYI5pDljdLZ82AKfJkkd2v8IAMsG5WbI7RTgtF4M9JoJlhKjtig4mJxle5kdPj5h1amIJ4BCPsqRM0yX8m/9AfHzpEArjfnuDBOdQJ3Wsl67b07UKtWFr5a1jzsC7s7UXxF8rsuRyJxmHpedskEgAzOWyzgO5w+GiXb81VFYU68NIrHImI4KLtPvjD34l9VK6ZGjPtjJi/DY60zV31DZ9DlsQlF4vGof7CpozNFWsPXALh8qJOWqUY6w2df8IqNHaXEaspjp8kwFmMbmJEfwD+LB5s57wxMirESnXylQ7BON6pcegDzRmPVdtdJL8Oy+pip0cRLYfTniuC8DuhWlFX7ohl236G79eFvA6AX+YOr2TEtspKRIquycBN25BJDARM6DRnrwRoZxOpt4o0unj4BAsdpXVR3Py7ah5VVJipLib0By6x87H/62x3jNMcyBHShi2A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(36860700016)(14060799003)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oHRVoGzWUhJBwXco1L35JrCYGflXyoKJ+HKbtWIdnSLTrUaY0SApjAGp3lGnZsRf0F78UE4L3pbK6QqfLgHrZ9jad0Ut7qvKvJW1TMUGbtDsBANL5EsJ6faczmZGPJn/JOgsp0hZYr8oASPjzvG+FvDKy7eLMuERs75pUiCm9ERpjmTmrIKWmHkSa7+Nj1tygHVB9EkQbBHrC0RD6zL+X8PZK0yq3+KCDJ1M/rYIQloa2IFsK4tp5K6r6sfTGXj6XQv1Yi/3h1s75Q7ia5XREvOGfs+SP7NROpWsMZ3eTdVhcLPMKKEtt0s57V0MeUSReL9AOlTyEqTzLfiwDS6ezopze1UWgwlGbCE4lKwUoANcHUm+7hNLq28xzKHpQwOFHmGCrAiJu3FF8t7WynpU+IZyslMpPAYB6haVApN3JxSSVBemibe8iuJifn+yG5ve
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:17:40.0699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 284d1e76-4fe0-4032-ffff-08dea4788110
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6080

There are times, such as with GICv5 SPIs and LPIs, where the hardware
itself handles the interrupt lifecycle. This means that interrupt
state can be directly communicated to the hardware, and no AP lists or
similar are required to do so. This means that such interrupts don't
fit into the existing flows.

In order to accommodate cases where the hardware handles pending state
directly, a new function is added via a function pointer:
set_pending_state(). The intent is for this to be used to directly set
the pending state in hardware, and can be used when the hardware
itself is able to handle the lifecycle of an interrupt (for example,
for GICv5's SPIs).

This new function is plumbed into kvm_vgic_inject_irq(), and is only
called if irq_ops are provided and this function pointer is explicitly
set. In the general case, this has no effect.

This is part of preparatory work for GICv5 SPI support in KVM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 include/kvm/arm_vgic.h     | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d628eea4cfa4e..b35833a4e2bf9 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -565,6 +565,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcp=
u *vcpu,
 	else
 		irq->pending_latch =3D true;
=20
+	if (irq->ops && irq->ops->set_pending_state)
+		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
+
 	vgic_queue_irq_unlock(kvm, irq, flags);
 	vgic_put_irq(kvm, irq);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 812ad325b01be..a47e5c742aac8 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -217,6 +217,12 @@ struct irq_ops {
 	 */
 	bool (*get_input_level)(int vintid);
=20
+	/*
+	 * Function pointer to directly set the pending state for interrupts
+	 * that don't need to be enqueued on AP lists (for example, GICv5 PPIs).
+	 */
+	bool (*set_pending_state)(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
+
 	/*
 	 * Function pointer to override the queuing of an IRQ.
 	 */
--=20
2.34.1
