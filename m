Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011016.outbound.protection.outlook.com [52.101.70.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F2826FA60
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375661; cv=fail; b=pwu/5H/noTwafWkvaBD5UFUCSeDll9/eZG62kotnm6un1L/RRugrKTkeanOIbkUiRgWs8P6DLrYCfCl/2KjKGu/yVGZ+CgCggNVv3LsP84ZDMx3ALfXrM/DcUGANR/8Nvs/AS0xSCk3Y6t3Tds8J6KE8oIoA7/26ZQz9VFFrExg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375661; c=relaxed/simple;
	bh=OJ/8yXYycPJs/bx/FiRheWElE4q++4HjDE/EYEI4MUQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pV+EFqRD/e8wzJjZohNGTtKBwNtqBq7N00wVoZiwpRZufQFTaBxRfcJlnJwjlEAMAqe2dkQAjReSWqdRok+AL6OFj79KD8t71EBEJpozHRbGsymMEFCAUuweKJQT8Q5Gs0b3fmMeIrAbpDu6hSm+W+eNmiHTrEakoP9EEHCVTuU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H40qZ6f2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H40qZ6f2; arc=fail smtp.client-ip=52.101.70.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H40qZ6f2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H40qZ6f2"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=eyAXDORVPUKdaxFxPAYWvLr6wv/uWi8Rw9gb1Kk+OoNDL1K3haidaB9Ky3Bagfl0hONe4JxDu6T2q9c/5/i6h4WIjIGP4QM7FIoSYOYkCVLzeeBRfQV3zrFNW7Rd742t3v5LfQlhRkJAw574DUBo6Yyvkvml04tB7qciOJXJPGRz09T3lDQTKkOTHzCyTHM3S+gY02IeRMALdZ/1OBg2FS3iy25SgXfDmCcEaMMxrYiJaHKwba2KivTq/ag7v/XTPE9IhDGb/4/w76NuCkpxur8353psvDB9ZS5znkVLZ716qgTK7oNqKbPnCovcaAwbM3Yq6sauIuIj5MFp97WylA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D3/nXZJHOhdtFkDdl/hoJ6iMxUqIwCWfkDVAbB6ulq4=;
 b=Qo+Mk7CIlYLL1l/xHp7Zf4X06tP3LcAqIkDNDpGfd+F5sHUkEy3CCQqaaqsHJd6KD+rHWLTwHRpaxfaupz4rtesNngAfbYMw529t/xL3rnE7Ke7IJfn5c9icUF52gZnL9CqOkumeiWyfB1KcL8nJjMtTZ7RGJw+fBvXhk51EmXta1NRaWThNUMfUpw3JzWpzE8a0N/WlpM0SRAd+yGKbaeelBpTfA7EcbGwbxb8KKwcV2YSwUKENUucLe1NfmBAkParv7joIQimBPLuSWOqkfWs2nLHnO2bPnu0Z9jsR3oukvn2HtbxfNpGNvFVT7p8QZnBtDNpNPtRxsjPZ8zpk4w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3/nXZJHOhdtFkDdl/hoJ6iMxUqIwCWfkDVAbB6ulq4=;
 b=H40qZ6f2/Vq71PYyb7udCX3ZgFIYWuDbQqqdixieo/+U5FudtNNNkmF171JooO/u11UGm6JOr314+nhh8PbodV8s6T0Iw+3LzmKWELnilaRLOHbuNXHjiIY7AYfbNKrDj3fOBtE4A/OTBSknUis3qdCfztmjte42J4TW8+E+pvo=
Received: from CWLP265CA0301.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:5d::25)
 by AS8PR08MB6262.eurprd08.prod.outlook.com (2603:10a6:20b:23e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.16; Thu, 21 May
 2026 15:00:54 +0000
Received: from AMS1EPF0000004A.eurprd04.prod.outlook.com
 (2603:10a6:401:5d:cafe::1c) by CWLP265CA0301.outlook.office365.com
 (2603:10a6:401:5d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 15:00:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004A.mail.protection.outlook.com (10.167.16.134) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 15:00:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sy0uSt87JmOiFORP6jl4kogv1KTb6Cm3K7dwYLieNIcM7EMPAHPQZj50ItEYvhVXB1Dsg1xVNxc0bzfYk6t99gZrO0OdivR/hshHbDn/aYtFwcWXzmppXSLti8LqTH9FFXapYtmYLd9Sl7BKSH9+S8+OUMf43ucs9NGlLmYtEc0vBYbL/MImTSzbxnDvYftMDQtA+IfQqBlzoG4qEfS0gN0rl6o2W6i3Iu9eDogL3UcXKQMyWLeDH44IrI5VjyYkIMoYDt31/F/enmVlV5TRkSEjtTow3SLFu1A0PYR9wXnnHEcZ6tIMcJ5dF4zzC96dzB7fk57+dbg8K+wO2mZRtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D3/nXZJHOhdtFkDdl/hoJ6iMxUqIwCWfkDVAbB6ulq4=;
 b=l2PT8bXYoAQgdQd35r/n4+DW4uFzTWeGgdCzhuIatV5pMq89blm9qi1hkJVLF3keqq5vZs80PWlbQ2VwF22T7l6A5qFNdAxvYmT1aWPgspbrfs03jgJTsef/VjfdrGcMml6mK4iuOFQPfF9BXxU3kKZcuP9UDDmStykX5zMpwlebBxadApy5K2TZKdUiSI2jtN5OSBA/L3Pfo+PbGhoZe+9lDRFneTnXHBw1NwSYqMwxBKYpDv0YA28csVCzspmgR+HNsWBkN/WYJk/qtFDYiuGUcvgS6gFMkv775BUvsWt0qSxGUxF86FJjD+Aky9y/eUseriZLqez3AGojeNm1uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3/nXZJHOhdtFkDdl/hoJ6iMxUqIwCWfkDVAbB6ulq4=;
 b=H40qZ6f2/Vq71PYyb7udCX3ZgFIYWuDbQqqdixieo/+U5FudtNNNkmF171JooO/u11UGm6JOr314+nhh8PbodV8s6T0Iw+3LzmKWELnilaRLOHbuNXHjiIY7AYfbNKrDj3fOBtE4A/OTBSknUis3qdCfztmjte42J4TW8+E+pvo=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DBBPR08MB6204.eurprd08.prod.outlook.com (2603:10a6:10:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:59:49 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:59:48 +0000
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
Subject: [PATCH v2 31/39] KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
Thread-Topic: [PATCH v2 31/39] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Index: AQHc6TJ4JhswotLp+U2ZLzpvdLtgvQ==
Date: Thu, 21 May 2026 14:59:48 +0000
Message-ID: <20260521144846.1899475-32-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DBBPR08MB6204:EE_|AMS1EPF0000004A:EE_|AS8PR08MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: e6d8298c-7218-479b-34a6-08deb749c1dc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 3mlLuM7jBEHLVkLWEwcH9Q7lHfAegNxsFVsKXu15yuNEEpWLhKhOQqftueMLE5aTSPugyZf/2dn4qfQ/N8CSt0driUnGcZH583mH8qNevbywwMgzDanmrHQar1AU+JtCEyay/RTuiIAaaEi4FUFJMeLpPHvE/Yy6iPSMwo+QUs/8NuyAG5MVVs9Juh815EaR1tZj3qqSNsHYK9wROrJzomvuj7s5/UfTAKmyi/Yk4y9QiA1WIEf+YPtTppQIWHMSvN6GGrQ0ObYbVYhSxAcSlX0zgKO/UCWRJvafATbTGVvkIU4HwOz47P2CxmCrUiWO4ACRR1KG49+DdKSogiN/0+mFAyYBkP22Z6zvUYfymFdWRlPjeBFp4j2MAmx6x+UYmiTS8gnvYNzUrP52DjxOaRchh4HMjyttz8V6WBHnlN1GCycVlRQtKCIKZJpef0UM0AOLTCkQI0CoK0Q8DJQMlWXDGUO6G6A5biJngTsuqoNPIhF+G5EzQIJLkOkJpd0eXWpXtKzHYN2nGLndX0gd3ZNhEIDRuyTuB+5KJOoGQm3NoyvYUuql/n5yg2ccoYWjk40Rht36qFvTtZEmm5phKU8YnzMvV2MRc49/BlZqII2BzOYwZumgr+TCwx1jp3YeDfnZWo/6A47qKPz16WreUDosq7V5VEH1HfwPLTxkSqfWzSSvBJhfVfmhX6Egn57nkw8dA+ulV4d8DlMA5EBDIC52Gfp01z4IcVWjQU0t8oE+Is1uSomFvoJJKsG3eS1O
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 QmUtx6/84u6iKkpzCVXvuhHjWTVkTHseU6KLq9wbHASus+Walk7tY4LI85FH5HTk4Mui2IBApW/Ez7ky5ibrrkcIqoFrGNn8ux2R0HkB8SxS6pBbPUtxQHcA9NG9gxZqDBQhgcwQe0m4dA3KRQneqGbwYwJFkC/9uYgCPbjomDsggApCDcgYnQqK3WFu/mrj19xJp6JjKXsg1QKYGIVf38sIiqyBI5m4BhGpTZxm6TEN+WCS7KX4vgki2TvLTuthgbJPZNT8bfpeHg8pe0kJ0kxgBADaxsQweZE36IhiHgP06rC1Rf/GKzSGaSx/iBRzZBxtT+aiQ5RfFwNEUGocoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6204
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	53c2ad01-5ff7-4d3e-fffb-08deb7499ab1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|82310400026|376014|14060799003|36860700016|18002099003|56012099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	jb9yexcoYoQ0aDXLjQfgnHNuozaTHYYM39Wie/fgglPjRNFj0kXlf7k8CGHghKdLexe0CxFUudGIxL9CjillyzX5XIclVyYaY3uBr68l3TmncjUYvySsraoDeq9ILRigPUDidoP/ksMYi7SCDAOCA67ZhUJ4S7sIVuJ4AceflZ0fH+deXCFMVuh9+RjZnApQtImFVyS4IoygirS2+nZNjATD4bkLrskI90EEvumViwnBWFHnnJ8Qk4uLOt9hJgI26FlDFMSbiljvpe0U563VHSP0ae1ypwUU3M8nOeMfGJUvDFfFivvB56NMXDIQEPAC1UvuPmdhj7WaMZE4R2psPO4yWyqrJdkx2n44uZnvex0H26wK5YeNsMrY93OpEovJd8V4Fqu/NTgBvIudo8xC+6/Yf3LSjgbEDFNhUP35STdKK5i8aX3LUxbnOPL7P40qIGgJ4zUIeEu4pm19MZIRXZKg4sLsZc9rErXwSSWh1vchlXSLqj/cALJZIYneG5rj/YDjYnYGPTa71VAYhN3XP5kpxv/ThogEm9GZPGsOPgtWtbPB0XLmlwCQlfwV3vXa49M9UmzGx2GrBy0Ryos3X2HVejF5q37nYKSRSxFWZGiiTp0xll20IEvBB18sQywMyHS47eUYkR4u7U+OVwHmlA3ieGqEYKb3pEre8wsdpOaCyvBVZX1btxVW0y8IpNdaiXKt9JV1Ag6fWAsVqf94N0qTGgF79yqHbt+4tXsFqz0=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(82310400026)(376014)(14060799003)(36860700016)(18002099003)(56012099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CYYHIlRSp0s9JiDMXvqjowa4fMdxupq3m8JbdkZTO3l38ngZ7ekJnO3tHKe+ZdEsZSUbMuwzwZfHPLMivBIsJWa1kAiB6uybLbfJ4ycSxAKX3IJnMaMvPDMxCDQPk+d+0z0QRggn0+wDZyzc5cqQ9Wuj/r7XS4UkqRvXKZ4ZnJps9vTF2OIim0R1Iavm59U/vMwYtygMAUjPvtApO54bLemU9qznDRPZ5s8YzqTLPEUgonOv6WGdkAq+qO5H0i+U2M8kVBehwB3hWKNz97eNK/UAjeKOVN++RQVBi7Hzi0PYD2Lox1v66i33FERPEw32YMsvXN4H5u54aK7d1/nTKuMd99epJ8H1RQTT3+p0XLXB/OnqqxXHlsazh3ialvqdYWGYTx72JkEeMaqSmPVQEknsYV40RdyK7U5gXeucp2DV3X7t1h4NdffVA1ys/FQS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 15:00:54.5252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d8298c-7218-479b-34a6-08deb749c1dc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6262

Now that there is support for GICv5 SPIs in KVM, update
vgic_irqfd_set_irq() to translate irqchip pins into GICv5 SPI IntIDs
before injecting them.

Also adjust IRQCHIP route validation for GICv5: use the configured SPI
count, fall back to the default SPI count before VGIC init, and cap
the accepted pin range to the generic irq routing table size.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-ir=
qfd.c
index b9b86e3a6c862..3644516811214 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -19,7 +19,12 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_rout=
ing_entry *e,
 			struct kvm *kvm, int irq_source_id,
 			int level, bool line_status)
 {
-	unsigned int spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+	unsigned int spi_id;
+
+	if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		spi_id =3D vgic_v5_make_spi(e->irqchip.pin);
+	else
+		spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
=20
 	if (!vgic_valid_spi(kvm, spi_id))
 		return -EINVAL;
@@ -39,15 +44,24 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
 {
+	unsigned int nr_pins =3D KVM_IRQCHIP_NUM_PINS;
 	int r =3D -EINVAL;
=20
+	if (vgic_is_v5(kvm)) {
+		nr_pins =3D kvm->arch.vgic.nr_spis;
+		if (!nr_pins)
+			nr_pins =3D VGIC_V5_DEFAULT_NR_SPIS;
+
+		nr_pins =3D min(nr_pins, KVM_IRQCHIP_NUM_PINS);
+	}
+
 	switch (ue->type) {
 	case KVM_IRQ_ROUTING_IRQCHIP:
 		e->set =3D vgic_irqfd_set_irq;
 		e->irqchip.irqchip =3D ue->u.irqchip.irqchip;
 		e->irqchip.pin =3D ue->u.irqchip.pin;
-		if ((e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS) ||
-		    (e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS))
+		if (e->irqchip.pin >=3D nr_pins ||
+		    e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS)
 			goto out;
 		break;
 	case KVM_IRQ_ROUTING_MSI:
--=20
2.34.1
