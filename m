Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011054.outbound.protection.outlook.com [52.101.70.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3492372049
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544175; cv=fail; b=MKhCdLQktcMb38owBeKGhqYAsJM+MuXNULVzJaIhuKQOW1VOMN9xVj/fsJwfWFaU95iUbF+at855wwB3BYSnifdolsEIvLTN+GPDdtsybTlQY1rFq9+IzqUu8UaZwzIa17rB+GhRouRbErZvKpELWuQZDEjoaAerip/YQKHFfpE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544175; c=relaxed/simple;
	bh=nvNu7NdpPcs7ESfyjHxtr/PDs91dVIrychKgeGhJzsM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=b92JOGVPJCxQ6NSLT1rXWcvMTCPNBEbTgXCdyg5fRhYsNmzTs+tYqnORtzKYW0ymPiWnTxORS141Pal4Q0vP3wf7TDHdVE7kJRzdgoBQntUv4IXIjKJlrbkv4uDOEV0YLfAzhYaeCHpqSHVzQEcmV4CnORmiOf91re0c6U7sCDQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gKVEuc7i; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gKVEuc7i; arc=fail smtp.client-ip=52.101.70.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gKVEuc7i";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gKVEuc7i"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ksJr5jhQwVmlLFLoCqM6e1cvg8NWJ40ClvvaCw3Z4gWUuN9gOndsk2uTsY7VOdzNR6VbYr6ATJREDxuX1rpSHw+QVBYGHBkL2Do+wmH6tinzVr0y+Ndg1E4Ufb/0ZTGXtTb1HCeJwuLJvrnTbj+5eq8/JTP27CDOPnqwFSF1gI+OR/JverHEgrYrC5WeREe5FfjXUMn9UpsVcBkkt4qpohtr8xS7v+P2446XERr2jSDT70+G0kvC1ngjikz/REY717vORdcXYgT2gOzxIUdR4oj2OGbIk7Wo+0rS+xxNjh22QL9Mn/QNAz+i0EJwL8ASLhpT9YdiAwoll+w1wjMzOg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HH4kfAwcaA3V4WN0y0cEo68znoT+qEICGi0bl3grr6E=;
 b=NiTd8V3KV7HDrGjrCbf3cag09eR7ZoM5kBN5SPpJ44JIptYnaTLIhbxuhVJR3yGt7iKuw7WqF/Na5WMf/+esPT2+v5WVzr4k4M8Wfja8hp7c+WNinv4amC7uZ6zquHcG5wHyyvvBBb9FqVk04fdxc08Cc1mxUGGtkO8vZW1JZKHo515htRCECkonalGXpzR/PokczWVF6fMUNBv2thP862HZcJqY5OBi+q0SKn8DMYu1vjn1copj29+EB0kFaWuSJRAmAS+9vn5MqYssBe347gLbnD6S8N1rtPXVMZAVdNvKnrENLxog6MLE3QAMasfmkoWBdkngOEJA+V0nb6JOTw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HH4kfAwcaA3V4WN0y0cEo68znoT+qEICGi0bl3grr6E=;
 b=gKVEuc7iJlLFdxcVTKKhxZFCdFQTqWtN4l2nCgnesolC47HYEL/10Me8PyF1OGSwE1+Ut4V70OSWR6GvqTNe/qYMM9Mi7xDA7pu89v9vq32JqpCvkY2oB7c8p3Y2oCv9BKvRZfjppeTpmr93VQC0BMA1MeaP7n+m3tRJkMCVuaM=
Received: from DB9PR05CA0014.eurprd05.prod.outlook.com (2603:10a6:10:1da::19)
 by AS8PR08MB5976.eurprd08.prod.outlook.com (2603:10a6:20b:299::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 17:49:28 +0000
Received: from DU2PEPF00028CFE.eurprd03.prod.outlook.com
 (2603:10a6:10:1da:cafe::56) by DB9PR05CA0014.outlook.office365.com
 (2603:10a6:10:1da::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 17:49:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFE.mail.protection.outlook.com (10.167.242.182) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Fri, 4 Sep 2026 17:49:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DZ8dBW4nUUN0FM5NECnQQisJqX0lMD0+TBDbJ2Gb+iz+6oqBCNyc21+wo/2cSfAUCDFgJW8GC4ihGYolaXdJ/Cvfszz7QaXpSi+DLKZ7uZjxQDlidHl0AvCba+7yExe8GqYNGgItVJOrJTj2iGtcfdwJ+gi8U2l1Ar7XsaQHAS6dqbEAm/tWBl4/Jjqlsto8qFFPVDTfXWHsSX1de4FNYYAr1HKXmzQUp1639HgQI8xNjXX07Uq6uwoPJCLRJt/oXrjacBFz8ilG+Fb6MCOQObRgiEaYI+2A8IxkHL+Rf0wu9mK/LQfmz//VBmy9oFja3EL5iywRELCP/bpk8QGe0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HH4kfAwcaA3V4WN0y0cEo68znoT+qEICGi0bl3grr6E=;
 b=pxOZnCQrqW/v2xsCik+zheFFrMLyYqTbWVZGGo5X2cbiFB1ZkhKL3ulGjv7uTLpJk7vNK8YhcZzWCkyDOKeWCqez5Gjx0175deeup1EK4fUTK+MDs4xZziE0Np1QBH+iOq9VervxV/8N2MnenfxWUWfkq39C3kCAly9vEvOAoULFhAJOah4TrpTC0kAzFS0A9b46HuwhN25W9KRGSkjIRoyd1vW1MCd+K8z6f7S4eSeeNNQzFSRy+7HjIVIoepkU65Ap/WVsG4zaJKPUTN5zE96U7iE9/VWzZ/Ea51KsSVRt42RP85AVqsXIO1iWHNOHnGtsZO2LqT+S7Fi2V5Q8Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HH4kfAwcaA3V4WN0y0cEo68znoT+qEICGi0bl3grr6E=;
 b=gKVEuc7iJlLFdxcVTKKhxZFCdFQTqWtN4l2nCgnesolC47HYEL/10Me8PyF1OGSwE1+Ut4V70OSWR6GvqTNe/qYMM9Mi7xDA7pu89v9vq32JqpCvkY2oB7c8p3Y2oCv9BKvRZfjppeTpmr93VQC0BMA1MeaP7n+m3tRJkMCVuaM=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS1PR08MB7633.eurprd08.prod.outlook.com (2603:10a6:20b:475::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 17:48:55 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 17:48:55 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: nd <nd@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "maz@kernel.org"
	<maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: [PATCH 0/2] arm64: Make write_sysreg_s() select XZR reliably
Thread-Topic: [PATCH 0/2] arm64: Make write_sysreg_s() select XZR reliably
Thread-Index: AQHdPJWnLjPKJ8+Ny0+6joNGOjMPGQ==
Date: Fri, 4 Sep 2026 17:48:55 +0000
Message-ID: <20260904174855.76185-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS1PR08MB7633:EE_|DU2PEPF00028CFE:EE_|AS8PR08MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a9ff038-fb2e-42c7-5035-08df0aacde01
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|10067099003|56012099006|11063799006|6133799003|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 zYYOkUqd+APP6hdvJr7NOiPnqoYJWTw7kN5DFhX+GJ//jsiBmsE6nz6Wo+l7yymap+NPmANX1xvNH/voYtW1S7H6YO9d+boInEWZH7lX1NQQrOHm+KCOWbPVJOfAIN3pKu3ZbUYzmcw2hBmjemzAhmmyiVK+I/k79P9VBK+wA70otIxPjapuYPNh8wSepD8a0KliXWFNDggVQryjqfi0VAoi6nmNL1eHlkEgKR6Aeet0yxKD4wK2RVF1h6UZ61lV4Py51iXX0TsigBkYd0g8bARhRpn+rz0dzg8fuVkJ8BYPthxt9iQmSXuCRzk5xgAaV3GA74BsCiXrzkRoncx0oGqAAfTB5dwOv2GT3YxEM69/3sUeTnMBAINyMUJRiydI3jVck0HOwgE9VvvzpJDntH+Ztkdufih/Atan6Q83fDhED1thTZNYYY3d9yDOpleD+qSryR1FSMBnLXTlC8nVKVnF2d/t0EUTOs2Iu+XE2YArJK47nwyW2OeOuPlYLy6DraNHUrqhVRMxTIQ731W+WuAQy/BvSZU5guaOSIGnHzSROdQmwuvaKly3qtM9G+Jo8w2mom3qq/sZ5dZSJYf2+8Jg3DMEwUKw/rmXD/tWu1DBhu9HxoUCOHN7+XxjBrGGCnx4K2CmSXZzX6hVWLEnx9BmhAJubIWC8vYwQX4vEkGPOBLBsjuI16hgLgrSCio3jgrqXCbQZziAFoqutDiORHgMz+BN1+oOMIjUkLtZEGc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(10067099003)(56012099006)(11063799006)(6133799003)(3023799007)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YgsbpbORys+AHRi9Rzua1EBJ3g6CpiCWe4NK4xp4utDdgu3Te43vkmP4ngp1yVH/iy1UdqP0FVt59s2t7sLh7yM/Uww15jgreN4LwXQQh6ex0MNxp/NYdbte903vot2SSOu1ntFC55n4zdLA0Ct4Ey9HwerYc6jru6FDsvoxwqQMu4vi3Jf2YuMqZluWndnZkBO2TTK8p8fSZUSNeXvge70sfMbxg6GHzSitJzXnqgKUl71csZVBOxGGAkw4SHskPQ1HAH8B11pFz2nDBmU4lOiCRB/xEJtNBpVQiAoejs6Qc9ZTr0RFM5Z7A+PRjWEu3ZHvIGHQWnR9y0YVmopUXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7633
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	edf5882e-9b3e-4fee-125a-08df0aacca5b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|23010399003|1800799024|36860700016|376014|3023799007|10067099003|56012099006|18002099003|6133799003|11063799006|13003099007;
X-Microsoft-Antispam-Message-Info:
	UCcIr1aynv9wpgezuziZt1y0wnSHP5FdwlrCsVGvJJH9sR87CWmFSUy9OqjS+X0yv2EjqdpR844yzSkUFQKdtiGY0KhfSx+J68jXDfZAPC99MGYR0sEfRezu8c2sc7/atYTt248SXXWa2WYe8JsOz/cUY5hFtrZFUk/5zYDO+ewn443UNto5OiiPXj8/d+YLk0y1BbM+EvY8x5iuCNQyytAHoHMnzq8SI2c1d96K6R4OFql5Y34tA3yNs5AdRnxo0iwxCR7lHS4d+McNVW2Ez0GhURJZJ9ls7u7gT+f/8NQ9h9BobRljrJoSyj6Ipsoqb/dAEMvKeR4G+BO+aGc10/iWwRhpoP1zWaVU9eZYGtgoIfjzNnySki41m+u5vxgPhfc1/Wt5t52iDnERvqDL+XJVyOLfVIkFUJVNu36ilwFl+vbnPemW3qOddAN4YVHbbWVbAxoeNTzdwIhHjX651EK3fzzWJ9sZon8GPkH9gRdNokp71Bufpp5RvOdLkpAYfz0Hlr8i9YR8vXbHnsjvvk84NwLDL6bWwZrXfq+wlk/dkoGgsy6ue/+ltwog/p71bBuT1h90NLHfZ+Gn+of2Ztf3IM5OqOJPxNljdvVVpxGrgr3vkgecSvQi15bekz7HEzjEYdtge2ARH9TBdBR/56OyNqwruhHirNhiBkQci+Q=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(23010399003)(1800799024)(36860700016)(376014)(3023799007)(10067099003)(56012099006)(18002099003)(6133799003)(11063799006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JpMcOJV/PN/OS/IeY+H6JPJ1rB3Iz3LTH6vMrhSncMF6TMBUOw8qeumFpuAZNpmoI4xwtI71GDl3P0nhd5CzyTFWyy4rCHhg2G4fVDxzJpqP51XPoHCPOyS63pk5oszip0y5zA2hnZxSuCo6MN6WGeT4GkiOjDQFFfHNGy6NyWAs8e0uQnBMRcrJpeu1V/rMsOeT/cYfgbNFNvteFdrY5kZqQwyJ/YCbSwcyo4DbwkJpGFoNYZnwxWn1UmvRtsb4jieRS1Xezrt/cmM1XkhbLiztGh3KrS/EJy6xIEt9Rmcg5EitEXpeUZ5yb6QfiHQb/BYvf2p320wXUuKBGMSmVrlw1jk7/5r8b5yfaO2UzrOU/KJch9+DNuV42a+7hsMlXcyJJRATfNCeg25L9bwK4Hao8EicIsUIdoAx6UUoTzJD2bP0DkLOUBTrWQlFPorz
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 17:49:28.4208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a9ff038-fb2e-42c7-5035-08df0aacde01
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5976

Hi all,

Sashiko spotted the original tools-side CDEOI encoding issue while
reviewing the GICv5 KVM IRS series [1]. While updating the tools copy to
match the kernel header, I noticed that the existing kernel workaround
relies on constant propagation to recognise that its local value was
initialised with zero. With optimisation disabled, compilers instead
select an arbitrary general-purpose register.

Compiling the kernel or tools without optimisation is uncommon, but the
fix is small and removes this dependency entirely.

This matters for instructions such as GIC CDEOI, where Rt must select
XZR rather than a register containing zero. Patch 1 removes the
reliance on constant propagation and instead tests the macro argument
directly. Patch 2 mirrors the change in the tools copy, fixing the
GICv5 KVM selftest.

After these changes, both GCC and LLVM emit the correct encoding when
using -O0.

[1] https://lore.kernel.org/r/20260807173928.3F6731F000E9@smtp.kernel.org

Thanks,
Sascha

Sascha Bischoff (2):
  arm64: sysreg: Make write_sysreg_s() select XZR without optimisation
  arm64: tools: Fix GIC CDEOI instruction encoding

 arch/arm64/include/asm/sysreg.h       |  2 +-
 tools/arch/arm64/include/asm/sysreg.h | 11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

--=20
2.34.1=
