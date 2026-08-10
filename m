Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011044.outbound.protection.outlook.com [40.107.130.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A05B3B9933
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 10:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786357667; cv=fail; b=uWhQnCtUCsxaJowAqpr7lXxSvyEt37AvIHOO8d+gOjNuOumfNRdmt8YBI6LnCeriQwimP8lxUe1Pe8bnveWZcJV8fyfO02irPNr7yBWcqaVTLD2qNO8HiSMU6ggxcrMz5s/xIWN0in1X1SeZvO4qcrzmPYD/XCEj/Rk982X+NqQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786357667; c=relaxed/simple;
	bh=6p/GdUDO+Ui0yq5EOf4t/krP1dmUdRI0G2R30lYvrXU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=KOo4IYgF5SuanROBzWlFZUJr5HNJU2+F50qlJ++vIubhTwVLHlWVcWYLamvtVfDHJ+Q6IQd5D6hRVcNwkC32FbN3QRvFhMC5lVaFQdBjCuH0t/uQ5uaLTIrDWV05v2yUCR75axgk/9f/rAmQCXELNmtdG4fKJWbV8YKw16tsfZk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F8NVMJj9; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F8NVMJj9; arc=fail smtp.client-ip=40.107.130.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F8NVMJj9";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F8NVMJj9"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GZd+l96/l3m6dQI1YHqEbfsBwXGIZL37Xurnc/fqyOPlVnW9Wk0UkQ6RWUsx4GSNswxt7wUsWJiUStWpFX4gUmqm0ES8wg43hteNcoFb8hVoTOqtI2GRk0XEEUDxQ5cO7MDfkxpLjqO6aHEokruhERHs6UaYVm0eJqNhNA7Zwqt0IwA218Py9s5nyWlL3GEINUBYiLE2ksqp1t6PXi5tURcFsHNXpPh6OpWoBSYAoRgnMJ4wwr8IogWw//DTIIAfVN29iQ4ztUdWWOSxbXUnK1DxnhsR+IeHOSqWiXQi2LYnT0CLm12yhaKUlsr375ttPFGDqBXBu9QxFsyChCEClQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skPa5OJO3c5bBNOAwIOqNsojPpbzeRMLRcM+mvpjSVc=;
 b=SBem2NTA8FSZ+XBhdjreNAuiLaSJmCtJ3plcujoGIlwB4ppezVsngBulci+nCmo/FcLMstH7P3UZLnU066jyhEN0HPBqqRWaQKD2Y5ZvPQBK61oA4GA2reZuZvm0D6e6StH6i9tHParDlRopU6kWcisX3JPhz8CQjVl5mf6ywQoBmQ6WPy4JCW6CUns4Rp4dj5ZWHJQ8QOsxfC/eVZjtTwkOWTWjNsYo3MBZdmRLefZijHiCoWbxmqsGtFYVzuF+aGZjBjeb17s1I9OmRMfVgRQc3stqZDdzwnaC8KeIXQ70jaFVthAFKkpmcuw9lkDis4pA2oxDRbF5e5OXRNdnhg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skPa5OJO3c5bBNOAwIOqNsojPpbzeRMLRcM+mvpjSVc=;
 b=F8NVMJj9AOnRFkFcUzr9nXVy5vMhu3BvTPUp+yxcR0eF0n2jMJUjymHhlnCrz09fZ6MC4wij4PVcW3wy+6JXTWdJUUxjRj7Ly3imsh9R7lwZnXS3rQAdA3H0yTCs8FYk/5M3YH9eYDoMRjNZph8bDvTjV9VmzU5d1f4W88l46pU=
Received: from AS9P194CA0006.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::6)
 by GVXPR08MB11815.eurprd08.prod.outlook.com (2603:10a6:150:317::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:27:40 +0000
Received: from AM1PEPF000252E0.eurprd07.prod.outlook.com
 (2603:10a6:20b:46d:cafe::7e) by AS9P194CA0006.outlook.office365.com
 (2603:10a6:20b:46d::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 10:27:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E0.mail.protection.outlook.com (10.167.16.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Mon, 10 Aug 2026 10:27:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HwUMaps/Uw4Hy3tlCsZoDrUGAPAJka/X0EHkm1ZNQTk7Teo+a51UdaQnUgbbBKWZAlKSR4zZxjgEPVj4/wDMapE1UvZZ1v7sKklsQijWpvf4lO00awJKcTBIl51HcK0fbVDAc6HLa3wWa5WC/wXDzDG4I/YEn6kafGLgryQWuoqCxGepYBdS4UFo5J7ecSmrV1UyPHwXdE6gA90JJUrX4OmfKLW5E6RiK7KYYpeiNUYp3NubrU4K8uynr7+18cAv5jvqqW3Snj/LHId9FeuDrStiTzd9V16Ek6dlY84m+pP4JovzPTfTwA1HMvODpPo7sYAQw9bDJaSSEsAP/mImXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skPa5OJO3c5bBNOAwIOqNsojPpbzeRMLRcM+mvpjSVc=;
 b=AgVTMlhhQ4e9Ba58yjt1STgql0aplMeX7NY9YkPamj0+oUWDyXZ8nmR1y6wACKJc/roQg3A2C66PapZfXn3b1xKC8pYsqj2jtqi+mCrfbBnPI3JwU6Ukbfz8jXgSsCGwl9P5d6dA2TZz1mmMj2QTVATVaAoo0FZDur5YXbiUhsET48b/n6m63DH0O+PofGh/h+mTcEwSguPfETDpisQ9El6UkutVq6hoV1P+SK+v0O73EW/UhPesdsO/ezx56NUYIYi3kjQEtlzpWXfKH888dZzmgO0cRfSM6vO1f121Mf0eIpV9sFeHu96gCTZbqk0KKD6uSdm9fndERC04jyVx1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skPa5OJO3c5bBNOAwIOqNsojPpbzeRMLRcM+mvpjSVc=;
 b=F8NVMJj9AOnRFkFcUzr9nXVy5vMhu3BvTPUp+yxcR0eF0n2jMJUjymHhlnCrz09fZ6MC4wij4PVcW3wy+6JXTWdJUUxjRj7Ly3imsh9R7lwZnXS3rQAdA3H0yTCs8FYk/5M3YH9eYDoMRjNZph8bDvTjV9VmzU5d1f4W88l46pU=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM9PR08MB6179.eurprd08.prod.outlook.com (2603:10a6:20b:2da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:27:07 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 10:27:06 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: [PATCH 0/5] arm64: gic-v5: Fixes from GICv5 KVM IRS review
Thread-Topic: [PATCH 0/5] arm64: gic-v5: Fixes from GICv5 KVM IRS review
Thread-Index: AQHdKLLKuPPLbubnkkmBWQAQnKyASA==
Date: Mon, 10 Aug 2026 10:27:06 +0000
Message-ID: <20260810102652.758719-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM9PR08MB6179:EE_|AM1PEPF000252E0:EE_|GVXPR08MB11815:EE_
X-MS-Office365-Filtering-Correlation-Id: 58ee6324-5c11-4445-4e9e-08def6ca00d6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|18002099003|10067099003|56012099006|11063799006|6133799003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 cy3s5diwL3dZYebR73k4Rzhi0hqQaFZDTWWkiQwc8EFfwdeQ38tR58J7QfDh7o4xQ/yED4prNjzrUAc27wuYpnfzcakEPZ01TrR4eZb2oMUaNx3k6Q+Ln57y4WGV83fl4FRHtxIXpwCTJvIgEWqQp9pOdVUGHYllo3byEr2uZVfhJL4kUBbw04Y+lBDRO+u89JOWxczNaUaN2BTZaIt/1l0njeRyomKV/cn66wwP68/2bOa/NNCTWrKoUzHV1pqOYtKSVlC1QNP9TlSTz/I0icvl+92Uy2H60ED9aXoFP0SDs9RUED994mAmdUIirs8ifgLizOhMvNwOJqpg5J3jGcrKAQRXJHk6wePWoYVC+ZfuxM3rSAMqEWJEv98ctV9Z2Q4StcKJb4ZCNDjjx5c0ZiPZ57rIkbELUNSeWR2TADXQIR4n28jVIBfj42n0NCYBfUP37MPpAOp97Vr+W1sPzTHDiN192J7NZx5eZZveQJE5QhxCmBHpgH05EGk/InlfS0LsEYVFq2SFzYacoz5z3xK29VtddU3aXTPYFj8G8X06nL8SaCq+e621WAyBAOJcKmHypj6AZBUaTeutBswwlY12VRhXfp/3vtM7T9QY0spoIAxwC4oFB07oZX5E+b2e7V+XE6BcAY1ox3xn/rez58xmFxN5YpgggNsF30kU0vQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(18002099003)(10067099003)(56012099006)(11063799006)(6133799003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 tQTo+QxZrovQ/TU/L52/o7VhCLTS1qKXAGg/bZ/TPWwR7tMqMe+K0r7neA99GkMjU5yzDbG53+RoPjYa1gb+sfPfvcjKShSrtICXvNxSmSqzNVwpOT8tvn3L1XqP6hh1FhkP6hut7S/SeYkCzNGaglxDweq4LwerH1A1LUJyXRgMyA1yCO4GkFi5f+3YxXCV9JJIVUAFYPQn6iaixq3vRrUXZ1l5aKVid3rNrSy5KJKVSVSnFnnXK2iA0B7Epdl49HbI8ap156u8TaI2MTROsl1pKhg2ii+KXvdaNt8ETT/m+Gwt12A0QsnCcGwarL0qf3TiaVbBV5u3SceV2XhVgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6179
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252E0.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6c27432b-7344-4c85-ae33-08def6c9ed41
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|35042699022|1800799024|23010399003|82310400026|36860700016|13003099007|6133799003|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	C+UaMCnws4Znavn0+YHhpFjpSqp0eTYX/2Z5jDUBxBYwhGBy0BIqAIXuHy4e13urjh93uqPoxg7qhl2coS95+oZqAH3vfaKVNZcqAh2LWFSKP9KQOzL23gwapn8TFddI+cOLD8LZSj79NOqhvJRazpeEMWoULmzVa+o90Mn4gP5YD5DmAyLwef0FTWAFEJpch2f7g46ViDctFYag262wD1jr0GFD3EHFEBjR0SXai/KF1d+6e4sGsca6e4c1ENKJ79SqfiutriUrUm3sebZtn6vKVtASuzJsCUSKU00JDEpIrvDpLuPh/qxx5fqqvSuNcML8nU/LIkZ1lBxFwOEYkm/hJRmW9Y23dQQ3GGBZvnWKtTXCVTqhNVOAYUhGP0zTTibyKO1Qk+PEdflPnYyU/QMKV+fZ1vLBuqZuyfX0tjXALOmYn96iKh7PjOGDn/UXkNPA9AEeC2xdI4aqXiEgIIbzPAyZh174dA3EFMzZU3HDvOkQPPwhFMfBFF2YH9UGdPARvQf8Rx64oWuX+KKSP2Tsvos+SObEI73vH3AjGuTXv2mbhIqEJoTy2EBMJNHZCkIk/Mkd/Rhm8ZDrNdLEJdsZAS7U2JaLxdv3aQeJBYMXXSNMzGM+5K4e0/n4JI6uRt+Qeo2U01QCRLfkaQoK1g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(35042699022)(1800799024)(23010399003)(82310400026)(36860700016)(13003099007)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	G5kexwfMAjBVn1Kq90cxKgbn36fHdUmf4Z8+e1IZAESli5yjBL6bvBPraIPUjToftO9lAqCY/UeIV9eKbxBcrEsugRi8/4+6JKaSaI+o5UGyiWBX8MQzVHK52pEqY8haCU4gJy9OHgNL41WvartX012alxR/CJs3bYQzXyUs8zwaI2AChz3EX1y/k33T7q2x7cGMwofeaGdqM8vbCJC1r1O1RYYjxd4n1AtfD7/uqyc5T74mKv/dBOiwumMw2ZcDk12A3NditZIt8qETqPbw8y1eWh7ZzWg25o14l65u4E8T/ZXFuRG4MUBgq9vy9tV+dwuRtiMjWOkxizWqvNBuiHJnU/wqythRr+ecTOXH+GQw7WEigRyr3bOrJCB+dbQzUYa7CaIuz/VJrcWg0RV5b7Wu8DdZYJb/p9mby4+YYU3Y9CGfkvoABzquesv0YOLd
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 10:27:39.0154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ee6324-5c11-4445-4e9e-08def6ca00d6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E0.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11815

Hi all,

While reviewing v4 of the KVM GICv5 IRS series [1], Sashiko [2]
identified a number of issues in GICv5 and vGIC code that has already
been merged. This series contains the fixes for these issues.

The fixes are:

* Free gic_kvm_info when vGIC initialisation fails because the
  maintenance interrupt is not provided but is required. This routes
  the failure through the existing cleanup path to free gic_kvm_info
  again.

* Clear the per-CPU IRS pointer and IAFFID state when host IRS
  initialisation fails or an IRS is removed. This prevents the per-CPU
  state from retaining a pointer to freed IRS data, thereby avoiding a
  potential deference of a stale pointer later on.

* Add an isb() after disabling the GICv5 CPU interface. This ensures
  that interrupts are disabled before the helper returns.

* Fix speculative accesses in the common vGIC SPI lookup which could
  previously underflow. The SPI index is now made relative to the SPI
  array before array_index_nospec() constrains it rather than
  afterwards.

* Reject GICv5 PPIs outside KVM's supported private IRQ range. These
  were previously clamped to zero, and hence would alias private IRQ 0
  for an out-of-range PPI ID.

These changes are based on v7.2-rc7.

Thanks,
Sascha

[1] https://lore.kernel.org/all/20260724104819.1296803-1-sascha.bischoff@ar=
m.com/
[2] https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischoff=
%40arm.com

Sascha Bischoff (5):
  KVM: arm64: vgic: Free gic_kvm_info on initialization failure
  irqchip/gic-v5: Clear per-CPU IRS data on teardown
  irqchip/gic-v5: Synchronize CPU interface disable
  KVM: arm64: vgic: Prevent speculative SPI array underflow
  KVM: arm64: vgic: Reject out-of-range GICv5 PPI IDs

 arch/arm64/kvm/vgic/vgic-init.c  |  4 +++-
 arch/arm64/kvm/vgic/vgic.c       |  7 +++++--
 drivers/irqchip/irq-gic-v5-irs.c | 16 ++++++++++++++++
 drivers/irqchip/irq-gic-v5.c     |  1 +
 4 files changed, 25 insertions(+), 3 deletions(-)

--=20
2.34.1=
