Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011071.outbound.protection.outlook.com [52.101.65.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6249D2C21D8
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.71
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094666; cv=fail; b=F7hgc/IBwKwhM/+pa8oS0I7FyXfBJjqSyLU/rGh+nMQUa4AxTDjHHd1TsELiZnAw+tzFBB2ZzLz9QA7gI/UBFaO3H8BxqCF0F3IpYcuuAR2qflK+zqmzjRuIVQoE3esMhpYrXxoAInd28XXmUa6xB7Du9zTXAG7aqUulX6ogeDA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094666; c=relaxed/simple;
	bh=6GIe2zDDgz65lfedBgm7YzB2ALOVNDQTOpkyvsvmdo0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=naSFl4Cu+71a7UxcomvAs5bp4SocrVWGoiRaTW1bCzadxwVADRUM5gxIkUJM2KxsjUS63O/KX9bmwrL67uQMV7SC99hGNS0QVxnD+ECNDPHn0UWxggeoJJl64msYcRPlX6WGyaYccnqjfZBfPGj3qsj1/E8c+Z75RED3fnGwm34=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ANyJ479+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ANyJ479+; arc=fail smtp.client-ip=52.101.65.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ANyJ479+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ANyJ479+"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TQMZQqnDmezgcU3mDF5kOsJKt8Aq8X5V0zepZ39UWML7SvZCYILAWF2dJ+qcl7gTLXJTm50RBU/hQyxKbDWVlCvDhIWmdL+LMOpBR5d5FBBg7eppcXHghldvq4uPTX0dzkNr8TK9aqNKCdqjlx1Fozn4Nb6Gs6V9O6d/NCla7vDg/G5FrBUK+HhXqnnxoVM6cGrmvs602IF4/b1fVT5nCE4cCl05cEpPoiz7sXts5aA6g+g7tVDCQO+ls4wJ60105Jrpu7wXi06r0sZonBd5MArV5orZzcpSSTyzSH4qnfTz/5fKg1Shl+M8ME92ehnk3skcLyrxB+9fFrKfaCBljg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFzYrrUZ0fQFZE/Z+mvhF3LHQI0hOnuKAzjHJGOshzo=;
 b=Ry2sgrSzTTvfEGKysr61e5puco98vcRKbhOU/5r00e5gJmRy0YC9WOYzrrB96yzi7Pj4gCBpJh4rM3NPdnGlWqYC2GAYtEPrqOFMraHFOiS/gP2dhU4/oDbrPNFRgG57V307t44yzgRW5ajCnZ5KnOI2sk3H4st1i+TCoyxQj1Xsqy3R65T7DkFe5//8TBjZZ50uB01FMmR6tX5GV84SmCLLFbA0aZ27McTIKscfzbDHNHhMRtyLHXioE7f9elaLdHQTqvVxUQ2oONiAJKHmgx8yNIytRfQgP5vRT51ygzCT41w8H/JKU/xNa/vEc+7I5aDCbCBnpoA8LCz1Jy0Bsw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFzYrrUZ0fQFZE/Z+mvhF3LHQI0hOnuKAzjHJGOshzo=;
 b=ANyJ479+wqidA8uShXNXxCyz79QCFyVOdbjf4RRBxyFxQURYpy8LW1FXXBgmStqWuGfKH9FbQ1D5kAd2nTllA9Rb6YKzhYKcDrWG9zbkwnFiwjZSMojRysIznCECYUNUUwFGVpglW3COMzNTtyKqSLSoy7mNx05SGtnMtb3mixg=
Received: from DU2P251CA0002.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::11)
 by AM8PR08MB6339.eurprd08.prod.outlook.com (2603:10a6:20b:317::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:04:19 +0000
Received: from DB1PEPF0003922E.eurprd03.prod.outlook.com
 (2603:10a6:10:230:cafe::85) by DU2P251CA0002.outlook.office365.com
 (2603:10a6:10:230::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Fri, 3
 Jul 2026 16:04:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922E.mail.protection.outlook.com (10.167.8.101) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:04:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LXFbUimodXyLjCMxqCqAXmZL6yZyM9xyV1YrKFAR05GVJ97qCsmbYFwmfs/3DrkYcKS2QPIjFYGtS04Mk7AUT7MPxKk52JD4fbE31wxpu30F2F/cB6xZi6TfSTyw0YvSNaIF2LjXMxpMy0CsTVBjaT7tLsgAhJXQzVNtt5rNjATLiVZUekG4nGuD9Jp9VAx7PX66gznpG3MAyzUd/ynJb6a6N2eLiVVYklJF9R0Mz6ZunGUh2r6uiKg7lkAv0XVasYdY/k1K/7rco0HFBX78lSMIJ/woobCoW6hqgjyew6xOjAqaPFWtfTAP99cCVmW1A4ZnvEj0LsWwZHzUAKfORg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFzYrrUZ0fQFZE/Z+mvhF3LHQI0hOnuKAzjHJGOshzo=;
 b=x3Q/EAzLk9qRbAsbKKldTUVZwTLlKCf5V9/ui/yexD4Bc0Hmcv+hxeliB8aIZwu9B5eYX7lhCTYNK70U9QGs1IiD1MlmCRSl9Een1ZMXLohlTRLD7LgH0EkF1uOkUV88jiOquW9RRzvMgezm6pLVLU2U6Tp1p+j9HDHJHt4tBNkAy9NRDcP5kMkC+PfofWPvmGLWf9km7AhAXdW9M9a3OqsrPEXOn43S/rTG0cS5ow5WHF2c0kBZ0OXelzm9fQUhLmNc8UnSVd4zWxBh32x4KID3R9UuPhR00QHZXkuxfSUXzrWihHXkFMAM2vHJJybrdxhrz0ahfaYvaxFtZT4dsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFzYrrUZ0fQFZE/Z+mvhF3LHQI0hOnuKAzjHJGOshzo=;
 b=ANyJ479+wqidA8uShXNXxCyz79QCFyVOdbjf4RRBxyFxQURYpy8LW1FXXBgmStqWuGfKH9FbQ1D5kAd2nTllA9Rb6YKzhYKcDrWG9zbkwnFiwjZSMojRysIznCECYUNUUwFGVpglW3COMzNTtyKqSLSoy7mNx05SGtnMtb3mixg=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:03:16 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:03:16 +0000
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
Subject: [PATCH v3 25/40] KVM: arm64: gic-v5: Introduce SPI AP list
Thread-Topic: [PATCH v3 25/40] KVM: arm64: gic-v5: Introduce SPI AP list
Thread-Index: AQHdCwV1jCBxcJqD70iStJ9hkubLCg==
Date: Fri, 3 Jul 2026 16:03:15 +0000
Message-ID: <20260703154811.3355680-26-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|DB1PEPF0003922E:EE_|AM8PR08MB6339:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d315e73-cb9b-4b58-ce5e-08ded91cbd07
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|3023799007|18002099003|22082099003|6133799003|56012099006|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 hanW5cMzlQtqyySj7m34cXllL3O2lH3NBl+CqvLeX6ELDP18BluZCvcMD/N4oycYNN4L+BworgiKdu9kiBfJ3U1salQ9WBv5Tbuz+QhoE/bloI1oheQofK7cT0pcLbKOcEJ6dRvAzg5yUaowXFwcKSkgtovfmTevVHawbhVvcxow2kn2X6nKz6tBxkSlMxNCyU12WMUNvRCqKG3ptPRnvEfYmP7ohSDDMplaMqE+YOOMLZFQDYouo/gFB5IUf8Rdo3GPHNwfiGTzxhTZYx/hsgB9aNEDZ0a3x/CK1oFTysl+jJkyiwp6N9mOAh4Jln6926hhhvVVrcpp0rQUow04XCKJJDRrnRAP0q4EHVijFs2ZzUvjpq4R3yCMqFUSL3r5gHyJmRa1mL/O18rQWoNAQ+s3lFWuXa5kfGhwBznKzn0eHkCqd63Jf8uWZQNJWd103kK8emTISsMYCaXHDiGwDXC7KgyClYRVQ4asdI0jUtZwWod58BWoD1x2tlii2PUNXjWd2cA7lkPxD+VpysbqvG+kewOGy+BHO7xPl/wBFwilQ7GmH1d9fCAicZoaU/3kvsG9QWU5wTnvDxP1D/SibW8WKohQ+VxpLBoMPivgsmzxcKfTHp4G+dnhu6SzDfnVVDikYwjtIiklv0HR+SL6vhZ0hl4ffTd8xh/g6AyziOyT5rw6YYHjGSm9hfeLU/e0RAlUobptsnp8EgSSxbzMJjmteR0lrTkErzZvdQuf82M=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(3023799007)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 MVGp8OC+NgHLKtmAiL0fo1TDTfDPAwVVw5598ITJ8Gx35XLkV6kJ5dQUneL1B0YivN/LoaJCiWuhifIulXcRvqqlc9KWLZdUv7QBVXOeO98f0cAlRg2YO8B+zqLyLqDg/PQJGZZq1FNo7QORDbNjVttLLYrpO3nqkUThPoU4v+o1oAVhOQWpH74tdycXdkF5+586OO5FyBTL4MZtuWcgp7C3oS6DfPLZPo6pkuKm/j54FFX/b6hhmQ02Pp+STM9KwXqTXBfieEiEJ+HJy9Fe/tld4BQ2mv/hrFEQnKKfgtZ7XnWJrh55yjn5kWFP0o8PDMz1oj/ZeclkkofDGiNCdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922E.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	daf77f89-2bee-4b2a-f0e6-08ded91c97a4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|36860700016|1800799024|376014|23010399003|14060799003|18002099003|22082099003|56012099006|11063799006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	K8hg3NcMgQwSIkNE6VSjuvCr7qxTuEgn1HY2DGg/PXNSd8291NfaMPhVrfQ7OeIx0bKejb4iw6ppEl9UsDS8P0VoMfLzsOYw4Pbb5UsqYXsg60JJaSTc77TproSTVOLCipdWh21wHjycMd59FEo0q1jR0Da0/SeNXIJXEXn+LIFGi7nIl1+rqJjp1Ro42hAg7GRB3Q4kPPMshhWULwNPOiB39gLVCuUcTc8YQTiuXtjYivnexPI38/dZY8Dl0g89P1o5vMGTsh80IdsD0L32/BP5c5EgH05AvxqDn5xVn7ADGsjYm8HBfGhv2qintB53bRw5fdFIuCd7Jwkq1+pqBYgvpsofZsExVjssKDg9Ct5++g4IONUyfRnDE9q58R0P96i6beeklLF1hXyiYVn4wh98NfV/9MpCDGV9SZzzRudcG1QcGroZK396eX6w7hTmNQ7ul2WNbqcFctgDTs6n3vy3H6GpOfi+HAhwapFg9C6Y49v8xFA5SX8VVw8VykqYjpJRX7okmKvavgSwOkPerRdFkp+2NHW/lJ9Imb7JrDGeUdBYtDpfPE9M+6AoEfTdHXioSGNRud7VEMLrjEJ07VnG8SY1H2j7XsSzzpb1mXFyeOUqK57MhBbwtU2efK6tmLQyatBcVTaRup76lNc9nSXNnucQ5mYynpwzXY7fCVM6V5y91IJ1yPVGWLFe4vKnYnSyd8hPnbuOPrcVVf8Blw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(36860700016)(1800799024)(376014)(23010399003)(14060799003)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WHe/qaOCPaKceYiIrbTDpFqKDdZKpitgdOIGzP58l6xWpJKzT/xGXh1CnsnHtcNOymc/f5Y4jhvpjwx3KNwI/c8dKv5ThYo6fkU++bFpAG/Hkla6xJTxcXhr2WhU9sh91C16WbgxszHQxkwzyjipLhi4+0qzw1vgbj2fCGQfz1K1xOQJ221gc6ntu5xuw2T8y0T7QsMkCAJNXvMwOu6GgvSZqJXdiFISCmGU5Zu7McfQdfyeHeny9Im03IyVIRo7+JGWskHkE0indGtQiDSfxTJqGVgZkIjQ0NtzhCAGzAkb8eBsGg+FeNJ77BkT7AAuPAQeU3I0xLh/GpQP1uhvFEBttt+GEgvAg4ATey+HoNLdN2W5XGgC/2ytNLfQiirzfZweaJN/F534DoetTyTLK83xhp6dabZANtVU2sU3/0k9mKfD3q4JnweGT4XNHGS7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:04:18.5908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d315e73-cb9b-4b58-ce5e-08ded91cbd07
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922E.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6339

As a general rule, GICv5 works a bit differently to previous
generation GICs. When it comes to virtual interrupts, as much as
possible is handled directly by the hardware and requires minimal
software interaction.

So far, the GICv5 support has been limited to PPIs. These are handled
via a set of ICH_PPI_*_EL2 registers, which are used by the hypervisor
to manage the PPI state exposed to the guest. They effectively take
the role of the ICH_LR*_EL2 registers found in earlier GICs, but do so
for EVERY PPI in parallel. For this reason, the GICv5 PPI support
doesn't use AP lists at all - all PPI state is always presented to the
guest.

The lifecycle of a virtual SPI is largely handled by the hardware with
GICv5. GICv5 itself provides a set of system instructions that act
upon the virtual domain. One of these, GIC VDPEND, can be used to make
a specified interrupt pending for a guest. The state of guest
interrupts is tracked by ISTs, which are allocated by the hypervisor
and provided directly by the hardware. The enable state for SPIs and
LPIs is driven directly by the guest (using the GIC CDEN/CDDIS system
instructions). Priority, affinity are also driven by the guest.

All of the above means that it is in theory possible to handle virtual
SPIs from KVM by just executing GIC VDPEND whenever new state is to be
injected into the guest. Of course, reality is a little bit more
complicated.

KVM itself provides an interface to register a notifier on interrupt
deactivation - specifically intended for use with SPIs on Arm-based
systems. This notifier requires KVM to track when an interrupt has
been consumed by the guest, so that the notifier can be called.

SPIs are not per-vcpu - they are effectively global to the VM (even if
they are affine to a specific VCPU, KVM doesn't need to know this
information). Therefore, this change introduces a per-VM AP list
specifically for tracking SPIs for a GICv5 guest. The intent is that
while an SPI is in-flight (pending/active) it remains on this list,
such that KVM knows to track the state of said SPI. Once the interrupt
has been consumed by the guest, it can be popped off the list.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c |  3 +++
 include/kvm/arm_vgic.h            | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 20c13c582f710..5f5f5efa8c955 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -633,6 +633,9 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis)
 	u64 mmfr0;
 	int ret, i;
=20
+	INIT_LIST_HEAD(&dist->vgic_v5_spi_ap_list_head);
+	raw_spin_lock_init(&dist->vgic_v5_spi_ap_list_lock);
+
 	/*
 	 * We (KVM) allocate an Interrupt State Table (IST) for SPIs. The
 	 * hardware mandates that lower 6 bits of the address are 0. Each ISTE
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 143e75743da86..d4b0e7e3edf26 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -574,6 +574,20 @@ struct vgic_dist {
 	 * GICv5 IRS data. Dynamically allocated due to the size.
 	 */
 	struct vgic_v5_irs	*vgic_v5_irs_data;
+
+	/*
+	 * The GICv5 SPI AP list is global to the VM. This spinlock ensures that
+	 * we don't do anything untoward!
+	 */
+	raw_spinlock_t		vgic_v5_spi_ap_list_lock;
+
+	/*
+	 * List of global (non-private) IRQs that must be tracked because they
+	 * are either Active or Pending (hence the name; AP list). This list
+	 * will only ever contain SPIs. All private IRQs must go into a specific
+	 * vcpu's AP list.
+	 */
+	struct list_head	vgic_v5_spi_ap_list_head;
 };
=20
 struct vgic_v2_cpu_if {
--=20
2.34.1
