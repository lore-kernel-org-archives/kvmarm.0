Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011038.outbound.protection.outlook.com [52.101.65.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F2E288530
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748126; cv=fail; b=k2XWwCbiXKN9bRtHLrPVae7c6wLDXV8ZHnwu265nrPgdBuJfN51J4pxBzvllGtrBbNbXaS5mHvzZwMp3v5zW0+kV409KuoIiXMX6X4//ghWbFZvxBx9Qimq/8pPLEs8DL/9c2OsTo2WQR/eDWVYzWnpSAZuIPicDVXmN0yBMUtg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748126; c=relaxed/simple;
	bh=cz5nrz+1RDyQM4L/GTFQSieZSICR6CjRYL6hL2z25ko=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fggu1xsLMWl8oUcXdC7if2VIVxsGiX+qfm7Dhev0xbxJF4z1/MphCToLGJxgD0Jq0rWTfwXdooA4EUTawzALtkznUFneosCyMwU+XTgNGInggmv3iQaGREebxDNzUQn6UhN9aFugIITsm3+j2ZSYfG7zeE5YRB4YyxbEVrR9f7w=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ymrg2uk5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ymrg2uk5; arc=fail smtp.client-ip=52.101.65.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ymrg2uk5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ymrg2uk5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=L8v3rpT2hEo5lpZo4xHfMfqjr3hcnQLjxPzz4EcotguFH1xLzhRx+3i/xIyuvo5/G8LL0ip15GUuzMcw+uNGU8kfkHO4/HhkU7iE6q7g/lRoZe7e9Zy4gnqzoEtMqZIor2+nX/8WdvnCGK3d5Z+Kwgu71b7x8gGvrTNqCN7CEUXc2q8BgfZ7TQ1Ov3bJnchuLzxIWW0urHMpzIC9DECkgJzQtRkfxJHgn2if+mq9voRCPfJOTWgE9qEK1vfs0+woiPK5HWYkqswA2qeDmLlaRmex0AIFaHS2zxstnBHsPguoziuJ0vlJ6PAqEXsKV4MgdHgEfhG18fR0fvCCT81E/Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEv3LR/o9GNUpZIxddRsaVyZz1GZEPkSZoLfumsw3a8=;
 b=uXvjjuEkOyZzb9O8tSpZe7Y/Q2PsnjW2JxIy4LRzkbfpzD/0DSbVNhugtwunzJo5irCQ+10mNtqS/f4g3QaoO1KmdIPIevwbWbGnyd7VjxoKXq55eG3uhCy/GbPDe9N5MvZY9I/TX4efpypXCfDyHz4g3rkBQS1cDmCSNF3w0V3Dp0GdG7CeSbUeAACn2P8jZpzTIEz8WN8KHq8bEsZ8L3g+KxpzckwplVI3p9oQvJiy13bRpOd2JHJghqkuUk77QduehjOj+7nymKWpOhqM+5CrCLikjy5R7JODSnspmUqEefNrDhDzlN8Y7E87rXRND1X0QIDoAMadFl9mlvmfBA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEv3LR/o9GNUpZIxddRsaVyZz1GZEPkSZoLfumsw3a8=;
 b=Ymrg2uk5a6iBLpE4Y/W/stmdVzWoCk4jNBmzUCN6K2x5bIjDeZ0RNyvGIzGdnki0XWdCXKEvVfHdTx0L8szeh2kJ8H9aPWI80C8kBWRgq/QxCwuWO73Xp+3/s8r0pqI2mKia17ST0gwexWlPBuAZVimGsUwaP1eY+sRpkEYaPHI=
Received: from DUZP191CA0005.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4f9::19)
 by AS8PR08MB8634.eurprd08.prod.outlook.com (2603:10a6:20b:564::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 11:48:36 +0000
Received: from DU2PEPF0001E9BF.eurprd03.prod.outlook.com
 (2603:10a6:10:4f9:cafe::95) by DUZP191CA0005.outlook.office365.com
 (2603:10a6:10:4f9::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:48:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9BF.mail.protection.outlook.com (10.167.8.68) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18 via
 Frontend Transport; Tue, 17 Mar 2026 11:48:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=npIMIjZOqBerkEChLQWdpSCN82p4AUEBnjUU8CwTj2XbX6U/o5seKLjqzBEMJ5UQeqwtLxHSZQ1XZlZKZ/5LxTx5V8+pbTo8D0mepVPl8fHl89/kBwfh6Sqbdgefmi+iDyFlALWCO3Dbebcv54NeSIhnPvpTz6A3kF4WlZIq+hnQhwZ0D72OGeCtL9guMtLFeJn9EXxHV5ITyHF2WX+ikpGsrnp2e0qxon9+BGakpl2ja4yddEx44dnQlCzoWb2sKsYWRKGzPC67zyylrDkEMhgFDgZzscFsmjBoG6T/ujN45DSnlR3K0C1FQBFZx6xofVzrAfJF/kBSeH0WVZMgEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEv3LR/o9GNUpZIxddRsaVyZz1GZEPkSZoLfumsw3a8=;
 b=mFd5d2OtnCsEgYvSx6Oqkt33H41y7bEgH8UBiai1rNPVz8I/DdimAKE5PdhKmnQEk32VxODICzO+Ycx3URLNgnDr4+xaE6rpBrvZt9UpmpyfAJjO8yg4BmVX6o8xVeqvMhiUa4Jtn1JXKbo7R/dvY4Ct9/n2ytkaXzcjssYfqRB2bEyi4pJ8ay2EldDjdYwAd4fx1/cRrC4aAu/LsyJ/jSUDFA8c45OH3D0p9xBNUzasylQuqqz/jC7avrZXXJu0zcKg76OY7Po5merOktaBoK6aTiavdco41Sr5q3IV2W62tgZiOUcoNa1cw9NhWemsrVhrmxRlMUqX9ysJHjOJDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEv3LR/o9GNUpZIxddRsaVyZz1GZEPkSZoLfumsw3a8=;
 b=Ymrg2uk5a6iBLpE4Y/W/stmdVzWoCk4jNBmzUCN6K2x5bIjDeZ0RNyvGIzGdnki0XWdCXKEvVfHdTx0L8szeh2kJ8H9aPWI80C8kBWRgq/QxCwuWO73Xp+3/s8r0pqI2mKia17ST0gwexWlPBuAZVimGsUwaP1eY+sRpkEYaPHI=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:47:32 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:47:29 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v6 29/39] KVM: arm64: gic-v5: Enlighten arch timer for GICv5
Thread-Topic: [PATCH v6 29/39] KVM: arm64: gic-v5: Enlighten arch timer for
 GICv5
Thread-Index: AQHctgPVCoQ4/gjAk0a4pX1wcelGjA==
Date: Tue, 17 Mar 2026 11:47:29 +0000
Message-ID: <20260317113949.2548118-30-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|DU2PEPF0001E9BF:EE_|AS8PR08MB8634:EE_
X-MS-Office365-Filtering-Correlation-Id: dca26e88-c491-43c1-1fc2-08de841b1fbb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 FQ1RIq/57kUqmx0mkn6V/vMclHvEh8laNX0RYsPxTopzY3CzyHKex5ejRi/E0hB9vKsAQ2ItVroy1dooyaAW9VIM8JW/+eV/CEbfA4yOrbGcrTiJiEfNdLiB+1+DR6LfNFP2jsyYAJNKtw28M7XIz9kRixaHWKzuAKN+t40aOpFsxjbB37lcfRn2Y5Edoo9NXkfnJShwAnvJiyIOxdGJI5pO79OUqeYWp3XLoc3SDzYlTbSkQOBGfVUDq38rXl5ubGAJgGWIKiuTchT7T6h2hLobhssG911YDf7MDayrx0CKwPl8hP6vxbsN+3XZGMwKOViukkAKuA4ryTCdFZWUmewEYbOM2r9KpJbrBZmSCAPIsxSy8/4gjAUtL6I/o2NR7FUox1NYeQaXgfy29YQC8BTDVixcIh6j0w8VGFbdAuxoZL+/BHZGgxtBkZeToRAGmKwErGqn97D/NI4qXSaTGolkhEeN5VgsnzrdEsnBCK887tXUiS7BgGXJHXg5LzFP9qHjuYW3zs1aktaqBgglFcGjAkB6cHjiOy90IuRC+BPATt02hJQjMzUQMqXCA8nWsvJ4A/4KoL0vCWJik/hFlpCjnzYr789hp9sQcTTZOvDIxSric5QBIkRCjJRTtUx/1p1kpjAHLFxuTmOwj+PhlCMfDb2bnWHzOVrOLunshqkH7+MDfGM7juOtFVr5j4VL47bk7RAIcko/LfuSN2E5YiDt/8NNIrV4Bbfc9rZmpJTht7jFCF9OkeVKoh4ctDzEmpa4gng6lO3t19r+9MSxcwY+eaBnqiMGzrlCD5nPGXI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 pzmuYxUbSoFGmlwaMK85uScTHhY6Y7ej6PkwSKmadBl5Za/516ki5bsjRhW8oFKy8vaBOPJq/8sUglXkkPVbLiuK+ampydqHXbzvsbYErzMU8a8H1aVVnXZxSKm+IpA5UrGzcqfC5VStaJvVsjKQipZQVzxYqR1zqUPEvM1ZyTsQHSpRtBZAXMrwMYAJKNUFn8eGedwtAYMPeKWA4/XnSrwODOuoxVV2BnN20G8kv8MA6BBCjte2yOIS+Yww2rv6k6d8aE/XnOsdOVIOp/C6FR0LhVZHg/ptb3jI0cUQcLo7QPvGc2HjK0Fe/IN9BGqF0Lwli6PBBLJ7xALW3YqAaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9BF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	049635e5-7e79-4d51-a1be-08de841af7fe
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|82310400026|1800799024|14060799003|36860700016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0v40M1Z3HxH/rVIuBGUeeSQtM0y46/hKWsK/BUe9hxXSktgD2yMOa0COraNz2PeuXyHa9W3aMFO+bp2vszStIu5gZs+aCT+MJXOrw76RwDJNbpoIytO1uToevTCRsEaiLtaseotInPeZPOddehwHmWvLx1Hgd25mlLIncqPcO03OLSwWDeVe6OWW1tLLyRZS0TdxvIfLk/BhewQMLDETuy9Z7CClnCdVGJ8OaTTOWhFifaMFSjXE3nLPxM0JlHlI26GBLJJICJTP2/Sd+DSmyp9jNuko7luIgYEVbzfleHzisrh8Z5VKlstWMEOW4QhmbO3ZGoiIYB6qiVBlOJmEjlKkayyEDv0nC5MHHp+jlGPHjaiDlGeWSDezxapruXMPNtPVxAb10/fLguzgSSNnTKJTstuxzU1i4xIhXP36L03dsXGY+PcdNah0KrI6qMK9T/S4wuHhL2UgcLPFcp5sU1dcmAPYplmdD/sRKCP8mwR1ZoD16QAC3mPzSfPfxQqL3Lc/tIaCRXP4hRpDl1s23CTs2hiEgzcKCwlSJh+zg8h/2a89hUPaH7lEphzjlo235yUNyMNdDipYJx5PlHDjwlHuclN8yIcIRGOA+tFpvg8v3bqkAEccyXzS/n8i2VKQQsvT2QL3YvsUq+1qMqFHQSW9gQsILfNABjsCu237F+Jy91OXk5o6EH7H8fJXgjHPxl9itu3kMPDjhw7HnYpRB2Jv+nds9kYN5W9XX7Xle/XgYxLFE/rMsRXA6nUqcLoW7k/5P2ZveH9Jus/+JP7bEw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(82310400026)(1800799024)(14060799003)(36860700016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	n/bSRhyBrXvEtikLYzao8ZYV383TefK4/4tDPlOAgCkhOA62+bvDcly3I8HqeQPG+1GbM4QL086nu96OW8sI24ji9GIiwiyUROEGQnH35yKhlZjfCdeZMHMC6leuxjszkdeB/nlZCZWevXQECDJgogJH8CSFNnjDVj04bGEj5P+kdfJVf+hVcvyo5jWVP2BDMav5+a4OXjgopXdmcX33FbsO86pf8TWSoQmPQ0KQuzmFioYsFM2cCsZWCrUvtOvj64nrHdvH0efFvWCMfneOvyEAJl/m/Mg8LrOK0CroKS5m1VOpWuAc8VK78RTX5a9fh935tFH5jKdYuSQnh8ZCemQD1CKsG4oK5rh6yTBR9foo3PdAjc/ZDQoYufkWQbbDzXQ3JWC27K+CdPaX0KqW9Pf0X+DwMnzjKgoO3r0Is/otJ1OXtlMC+8aueZhFTXZb
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:48:36.3384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dca26e88-c491-43c1-1fc2-08de841b1fbb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9BF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8634

Now that GICv5 has arrived, the arch timer requires some TLC to
address some of the key differences introduced with GICv5.

For PPIs on GICv5, the queue_irq_unlock irq_op is used as AP lists are
not required at all for GICv5. The arch timer also introduces an
irq_op - get_input_level. Extend the arch-timer-provided irq_ops to
include the PPI op for vgic_v5 guests.

When possible, DVI (Direct Virtual Interrupt) is set for PPIs when
using a vgic_v5, which directly inject the pending state into the
guest. This means that the host never sees the interrupt for the guest
for these interrupts. This has three impacts.

* First of all, the kvm_cpu_has_pending_timer check is updated to
  explicitly check if the timers are expected to fire.

* Secondly, for mapped timers (which use DVI) they must be masked on
  the host prior to entering a GICv5 guest, and unmasked on the return
  path. This is handled in set_timer_irq_phys_masked.

* Thirdly, it makes zero sense to attempt to inject state for a DVI'd
  interrupt. Track which timers are direct, and skip the call to
  kvm_vgic_inject_irq() for these.

The final, but rather important, change is that the architected PPIs
for the timers are made mandatory for a GICv5 guest. Attempts to set
them to anything else are actively rejected. Once a vgic_v5 is
initialised, the arch timer PPIs are also explicitly reinitialised to
ensure the correct GICv5-compatible PPIs are used - this also adds in
the GICv5 PPI type to the intid.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arch_timer.c     | 110 ++++++++++++++++++++++++++------
 arch/arm64/kvm/vgic/vgic-init.c |   9 +++
 arch/arm64/kvm/vgic/vgic-v5.c   |   7 +-
 include/kvm/arm_arch_timer.h    |  11 +++-
 include/kvm/arm_vgic.h          |   3 +
 5 files changed, 115 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 53312b88c342d..4575c36cae537 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -56,6 +56,12 @@ static struct irq_ops arch_timer_irq_ops =3D {
 	.get_input_level =3D kvm_arch_timer_get_input_level,
 };
=20
+static struct irq_ops arch_timer_irq_ops_vgic_v5 =3D {
+	.get_input_level =3D kvm_arch_timer_get_input_level,
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+	.set_direct_injection =3D vgic_v5_set_ppi_dvi,
+};
+
 static int nr_timers(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_has_nv(vcpu))
@@ -177,6 +183,10 @@ void get_timer_map(struct kvm_vcpu *vcpu, struct timer=
_map *map)
 		map->emul_ptimer =3D vcpu_ptimer(vcpu);
 	}
=20
+	map->direct_vtimer->direct =3D true;
+	if (map->direct_ptimer)
+		map->direct_ptimer->direct =3D true;
+
 	trace_kvm_get_timer_map(vcpu->vcpu_id, map);
 }
=20
@@ -396,7 +406,11 @@ static bool kvm_timer_should_fire(struct arch_timer_co=
ntext *timer_ctx)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0;
+	struct arch_timer_context *vtimer =3D vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer =3D vcpu_ptimer(vcpu);
+
+	return kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer) ||
+	       (vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0);
 }
=20
 /*
@@ -447,6 +461,10 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu=
, bool new_level,
 	if (userspace_irqchip(vcpu->kvm))
 		return;
=20
+	/* Skip injecting on GICv5 for directly injected (DVI'd) timers */
+	if (vgic_is_v5(vcpu->kvm) && timer_ctx->direct)
+		return;
+
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 			    timer_irq(timer_ctx),
 			    timer_ctx->irq.level,
@@ -657,6 +675,24 @@ static inline void set_timer_irq_phys_active(struct ar=
ch_timer_context *ctx, boo
 	WARN_ON(r);
 }
=20
+/*
+ * On GICv5 we use DVI for the arch timer PPIs. This is restored later
+ * on as part of vgic_load. Therefore, in order to avoid the guest's
+ * interrupt making it to the host we mask it before entering the
+ * guest and unmask it again when we return.
+ */
+static inline void set_timer_irq_phys_masked(struct arch_timer_context *ct=
x, bool masked)
+{
+	if (masked) {
+		disable_percpu_irq(ctx->host_timer_irq);
+	} else {
+		if (ctx->host_timer_irq =3D=3D host_vtimer_irq)
+			enable_percpu_irq(ctx->host_timer_irq, host_vtimer_irq_flags);
+		else
+			enable_percpu_irq(ctx->host_timer_irq, host_ptimer_irq_flags);
+	}
+}
+
 static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 {
 	struct kvm_vcpu *vcpu =3D timer_context_to_vcpu(ctx);
@@ -675,7 +711,10 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_=
context *ctx)
=20
 	phys_active |=3D ctx->irq.level;
=20
-	set_timer_irq_phys_active(ctx, phys_active);
+	if (!vgic_is_v5(vcpu->kvm))
+		set_timer_irq_phys_active(ctx, phys_active);
+	else
+		set_timer_irq_phys_masked(ctx, true);
 }
=20
 static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
@@ -719,10 +758,14 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 					      struct timer_map *map)
 {
 	int hw, ret;
+	struct irq_ops *ops;
=20
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return;
=20
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
 	/*
 	 * We only ever unmap the vtimer irq on a VHE system that runs nested
 	 * virtualization, in which case we have both a valid emul_vtimer,
@@ -743,14 +786,14 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 					    timer_irq(map->direct_vtimer));
 		if (!WARN_ON_ONCE(ret))
 			kvm_vgic_set_irq_ops(vcpu, timer_irq(map->direct_vtimer),
-					     &arch_timer_irq_ops);
+					     ops);
=20
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_ptimer->host_timer_irq,
 					    timer_irq(map->direct_ptimer));
 		if (!WARN_ON_ONCE(ret))
 			kvm_vgic_set_irq_ops(vcpu, timer_irq(map->direct_ptimer),
-					     &arch_timer_irq_ops);
+					     ops);
 	}
 }
=20
@@ -867,7 +910,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
=20
 	if (static_branch_likely(&has_gic_active_state)) {
-		if (vcpu_has_nv(vcpu))
+		/* We don't do NV on GICv5, yet */
+		if (vcpu_has_nv(vcpu) && !vgic_is_v5(vcpu->kvm))
 			kvm_timer_vcpu_load_nested_switch(vcpu, &map);
=20
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
@@ -937,6 +981,14 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
=20
 	if (kvm_vcpu_is_blocking(vcpu))
 		kvm_timer_blocking(vcpu);
+
+	/* Unmask again on GICV5 */
+	if (vgic_is_v5(vcpu->kvm)) {
+		set_timer_irq_phys_masked(map.direct_vtimer, false);
+
+		if (map.direct_ptimer)
+			set_timer_irq_phys_masked(map.direct_ptimer, false);
+	}
 }
=20
 void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
@@ -1100,10 +1152,19 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		      HRTIMER_MODE_ABS_HARD);
 }
=20
+/*
+ * This is always called during kvm_arch_init_vm, but will also be
+ * called from kvm_vgic_create if we have a vGICv5.
+ */
 void kvm_timer_init_vm(struct kvm *kvm)
 {
+	/*
+	 * Set up the default PPIs - note that we adjust them based on
+	 * the model of the GIC as GICv5 uses a different way to
+	 * describing interrupts.
+	 */
 	for (int i =3D 0; i < NR_KVM_TIMERS; i++)
-		kvm->arch.timer_data.ppi[i] =3D default_ppi[i];
+		kvm->arch.timer_data.ppi[i] =3D get_vgic_ppi(kvm, default_ppi[i]);
 }
=20
 void kvm_timer_cpu_up(void)
@@ -1355,6 +1416,7 @@ static int kvm_irq_init(struct arch_timer_kvm_info *i=
nfo)
 		}
=20
 		arch_timer_irq_ops.flags |=3D VGIC_IRQ_SW_RESAMPLE;
+		arch_timer_irq_ops_vgic_v5.flags |=3D VGIC_IRQ_SW_RESAMPLE;
 		WARN_ON(irq_domain_push_irq(domain, host_vtimer_irq,
 					    (void *)TIMER_VTIMER));
 	}
@@ -1505,10 +1567,13 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *v=
cpu)
 			break;
=20
 		/*
-		 * We know by construction that we only have PPIs, so
-		 * all values are less than 32.
+		 * We know by construction that we only have PPIs, so all values
+		 * are less than 32 for non-GICv5 VGICs. On GICv5, they are
+		 * architecturally defined to be under 32 too. However, we mask
+		 * off most of the bits as we might be presented with a GICv5
+		 * style PPI where the type is encoded in the top-bits.
 		 */
-		ppis |=3D BIT(irq);
+		ppis |=3D BIT(irq & 0x1f);
 	}
=20
 	valid =3D hweight32(ppis) =3D=3D nr_timers(vcpu);
@@ -1546,6 +1611,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer =3D vcpu_timer(vcpu);
 	struct timer_map map;
+	struct irq_ops *ops;
 	int ret;
=20
 	if (timer->enabled)
@@ -1564,6 +1630,9 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
=20
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
 	get_timer_map(vcpu, &map);
=20
 	ret =3D kvm_vgic_map_phys_irq(vcpu,
@@ -1572,8 +1641,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
=20
-	kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_vtimer),
-			     &arch_timer_irq_ops);
+	kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_vtimer), ops);
=20
 	if (map.direct_ptimer) {
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
@@ -1582,8 +1650,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		if (ret)
 			return ret;
=20
-		kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_ptimer),
-				     &arch_timer_irq_ops);
+		kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_ptimer), ops);
 	}
=20
 no_vgic:
@@ -1612,12 +1679,11 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
 	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
-	mutex_lock(&vcpu->kvm->arch.config_lock);
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
=20
 	if (test_bit(KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE,
 		     &vcpu->kvm->arch.flags)) {
-		ret =3D -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
=20
 	switch (attr->attr) {
@@ -1634,10 +1700,16 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
 		idx =3D TIMER_HPTIMER;
 		break;
 	default:
-		ret =3D -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
=20
+	/*
+	 * The PPIs for the Arch Timers are architecturally defined for
+	 * GICv5. Reject anything that changes them from the specified value.
+	 */
+	if (vgic_is_v5(vcpu->kvm) && vcpu->kvm->arch.timer_data.ppi[idx] !=3D irq=
)
+		return -EINVAL;
+
 	/*
 	 * We cannot validate the IRQ unicity before we run, so take it at
 	 * face value. The verdict will be given on first vcpu run, for each
@@ -1645,8 +1717,6 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	 */
 	vcpu->kvm->arch.timer_data.ppi[idx] =3D irq;
=20
-out:
-	mutex_unlock(&vcpu->kvm->arch.config_lock);
 	return ret;
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 497d4dc84913c..f2fbd701d4831 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -173,6 +173,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap =3D system_supports_direct_sgis();
=20
+	/*
+	 * We now know that we have a GICv5. The Arch Timer PPI interrupts may
+	 * have been initialised at this stage, but will have done so assuming
+	 * that we have an older GIC, meaning that the IntIDs won't be
+	 * correct. We init them again, and this time they will be correct.
+	 */
+	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		kvm_timer_init_vm(kvm);
+
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
 	kvm_unlock_all_vcpus(kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 95c5fc51d180c..32565bfbd1051 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -192,8 +192,8 @@ static u32 vgic_v5_get_effective_priority_mask(struct k=
vm_vcpu *vcpu)
  * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity che=
ck the
  * state, unlock, and return.
  */
-static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
-					 unsigned long flags)
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags)
 	__releases(&irq->irq_lock)
 {
 	struct kvm_vcpu *vcpu;
@@ -224,8 +224,7 @@ static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kv=
m, struct vgic_irq *irq,
 /*
  * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
  */
-static void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *ir=
q,
-				bool dvi)
+void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool=
 dvi)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	u32 ppi;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 7310841f45121..a7754e0a2ef41 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -10,6 +10,8 @@
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
=20
+#include <linux/irqchip/arm-gic-v5.h>
+
 enum kvm_arch_timers {
 	TIMER_PTIMER,
 	TIMER_VTIMER,
@@ -47,7 +49,7 @@ struct arch_timer_vm_data {
 	u64	poffset;
=20
 	/* The PPI for each timer, global to the VM */
-	u8	ppi[NR_KVM_TIMERS];
+	u32	ppi[NR_KVM_TIMERS];
 };
=20
 struct arch_timer_context {
@@ -74,6 +76,9 @@ struct arch_timer_context {
=20
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
+
+	/* Is this a direct timer? */
+	bool				direct;
 };
=20
 struct timer_map {
@@ -130,6 +135,10 @@ void kvm_timer_init_vhe(void);
 #define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer=
_data))
 #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx=
)])
=20
+#define get_vgic_ppi(k, i) (((k)->arch.vgic.vgic_model !=3D KVM_DEV_TYPE_A=
RM_VGIC_V5) ? \
+			    (i) : (FIELD_PREP(GICV5_HWIRQ_ID, i) |	\
+				   FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI)))
+
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
 			      enum kvm_arch_timer_regs treg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a5ddccf7ef3b0..8cc3a7b4d8152 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -627,6 +627,9 @@ void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
 int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags);
+void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool=
 dvi);
=20
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
--=20
2.34.1
