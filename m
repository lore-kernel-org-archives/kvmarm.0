Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013052.outbound.protection.outlook.com [52.101.72.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E53D2C0303
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 08:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773909452; cv=fail; b=EVRG/3HJflndyRrPdkN/zkhJ1tHGfbEKTcKXyTVuqp1whVlV3HBvNW6Exx94ggB4lCE6frzi6IO2s0/KAMFIA15GvpyDxtIkrbxyNrv9EdKXAptRE8Jc7UC4ZJPOxUMUMJzL4fP4S4A+7EEA6OIBBOIVVt5xru8bzc9xBjL8OQw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773909452; c=relaxed/simple;
	bh=fU5rxqsu878Ze3DOly7dZhiyLQm6wRDRvvDAkvP2c2I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kEvWLaJQhFkpIz46RosH3D5+wu5sWov5n4ozsXMh/igQwgG4ftTyBQfijRhU6uWqqCfI/z5Z9IzmrHVx8n/QIVI7V2i9QJUefvILJQPxOCv2MZ3DiOBsQNd7bhV2cd6k31UjWXndNg91FfHPX/mwiCq22fHkjaQotrSX6ApCp3g=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jd4271EG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jd4271EG; arc=fail smtp.client-ip=52.101.72.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jd4271EG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jd4271EG"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XLEkFwWZcqygdXNAT1huMvSdy+bPyTVCgQ3PnYd3dnFK9iHEYIWBvuBTOhqaKGyUt1Eaqy7tMURpjqZihskEqIGX/hTdxOg6Qx7FvKoBe/6c70anjDFJX/+J/ppopg2EG7i3U8CjCeXp+TGhVTviA+6R5daY9p97RZ9SJ0oymg1aRug5PYeoiD9E998GdzUsav3oTtwD1dN/ZhBoeWGu9G+54iVKAYMyragBzLOER2H+VQR1C91zlmX9cikpa6OruN+TNJQ0uWJZ3FCP1TPMs7kYFyacrUa98fO4PQtS5KP5vM3mMP7ETK/PAdewW7vIlsusmQIBdvBz2KayA3n7hg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fU5rxqsu878Ze3DOly7dZhiyLQm6wRDRvvDAkvP2c2I=;
 b=DLhgEvA3vjMqVOuHfHnILaStG68NuSKgrMjPjqVsCpscRi79pEBrB/ZJ7IT8pdgQ/MeSoLphdaky4lb2agZhQxLHoL1W0EwjikIsphya8iz2QXXdGYWshA3TrY3J4PKUodFwcJnstgL+sBFJK6FX1SgAt81Uiyg5r5ViOeWmEKqlsQqKtYVR2skt/t3Zj4vUawzOYO8Yj0EUVQmN9NxMzjeoHPqQB4zAEOvEahVniNu1sajt/dzZ1PvotW4SzSfibHsrqNTdbhpHCtEvRDhypYzEA/W8DETWeEMy9bgyJH2N6ojvDUWszytuoI6Q67bJO/sNMFHm02FRdTAhqXKt2w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fU5rxqsu878Ze3DOly7dZhiyLQm6wRDRvvDAkvP2c2I=;
 b=jd4271EGl5F0P3w7cb/zNlO/JnODib637/DQR+sK7EnqxZAbXk9Fx2l7X2MAlFzCTr/hXjhi6ZRfzFTjaUTlzKoiOiOfXcHRJE9+a3MsV/WRqEpWBNdsiV233fHAF62LcsKNF9rDfjhWoEVhkyKqQ7zlR1oMA4aAZgQitWV4Jmg=
Received: from DB8PR04CA0026.eurprd04.prod.outlook.com (2603:10a6:10:110::36)
 by DU2PR08MB10013.eurprd08.prod.outlook.com (2603:10a6:10:49c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 08:37:24 +0000
Received: from DB1PEPF000509EF.eurprd03.prod.outlook.com
 (2603:10a6:10:110:cafe::2f) by DB8PR04CA0026.outlook.office365.com
 (2603:10a6:10:110::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 08:37:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EF.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 08:37:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W/fzCidiBNWadGs07PCS/5tfI4jRn8y36EKQTeX5jQI/RQpsIpbS3eD3AYKy+LQLY9u/LXfyNN+UNW6tlkbEnuKY2hZegm0xqi7kCA2aRJbDEMI27chJ8pDr2mMzcQFWzZnH42DTiDq0p0fXhjbgS+9K+idFl67Rw6PaUEj8E5PMU6Ks+gXEVuTVo1NHj+xHAkteZZMPZmDm5TtZYLaKjkgFWgc0c8uzmCdEh6z3jYWJyS69UsAmCHp+8NXnV/XxvSGJOPqszj5Hi+8gx3rd6gp6E3gt7hij8qbji62H8PdaDXFYBIF61x4GdWwR6bblXaNPwmXm/E/mIU7EjQPJCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fU5rxqsu878Ze3DOly7dZhiyLQm6wRDRvvDAkvP2c2I=;
 b=Sov0rXJXhDrlrvwUh9qSwuN/Xq4qsNxpQNmGascE9Xh5v1/eJ/dH029fHZtrtXCStVMzwIJy4km/F8XbCyLP2t683gAZ/bCnu9DV7TAm50m+YJ7dy8JnawXOs+HzqZDRpQIifcksYPjskcLRxn/31cPJEqduNj7AVu/dLjYnRZDXrwDQ03AFNoQqD211DB0CECbN8nNZX8v/EHoxnBYwBxozNfR4D/KENuB6W1n3q9TGKThUD3OeYPjJEgwekyenx3lcaQz9iQyEtknWO6L41le6snHMRuEetE/y5Wliv8nW7HwznPO5qFLZDtDM2XhqovG4hqAW/RWeaVJ0PWxpNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fU5rxqsu878Ze3DOly7dZhiyLQm6wRDRvvDAkvP2c2I=;
 b=jd4271EGl5F0P3w7cb/zNlO/JnODib637/DQR+sK7EnqxZAbXk9Fx2l7X2MAlFzCTr/hXjhi6ZRfzFTjaUTlzKoiOiOfXcHRJE9+a3MsV/WRqEpWBNdsiV233fHAF62LcsKNF9rDfjhWoEVhkyKqQ7zlR1oMA4aAZgQitWV4Jmg=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB6364.eurprd08.prod.outlook.com (2603:10a6:10:253::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 08:36:20 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 08:36:20 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Joey Gouly <Joey.Gouly@arm.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v6 35/39] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Topic: [PATCH v6 35/39] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Index: AQHctgQMU1XsUkkLfEiCTuaLTwOOFLW0bWYAgAEdfIA=
Date: Thu, 19 Mar 2026 08:36:20 +0000
Message-ID: <fb038b50b5e9d5608274312581d393315c50a0d6.camel@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
	 <20260317113949.2548118-36-sascha.bischoff@arm.com>
	 <20260318153432.GA3939846@e124191.cambridge.arm.com>
In-Reply-To: <20260318153432.GA3939846@e124191.cambridge.arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB6364:EE_|DB1PEPF000509EF:EE_|DU2PR08MB10013:EE_
X-MS-Office365-Filtering-Correlation-Id: 3270f1a2-5959-48a5-1486-08de8592be68
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 +bVcV2JzpY738WKuv21mwIamv6DcuwB7V6uTwuySiPYJPqeAQhq5UfwQAAE6//aunrL93BUAlS2kcZNnyW8Jme/aHBAfwHkts7BaLAyatGDFnMKc95x72m2rsLXMh0eJVm3XxTxekSNbwtp1yoE4TD5q7sDkHVB9yPi5OAeRuMDW6ltcqG/r3ZKdr36td09u55bEYaa8Ed1Txt88NLxnuVYK10vqDz9STbl6T6oFRzkAYGJwCTCZZGQS8izW26YbcadKbkdj1ieH+n//mf35YSKjrVVHWDpH9Iyb3x+Gi2Bzc8bESBRzkqE6TlwioFKmXldoeFM8S0AkyCMugpzY4yrtip4X1GI3qFZXgBDnvyNQKYu5acK8313CuU1dYDmGzVuJGYHXeQuaacfe9dr6LLD0kzLYIGyJaBYKa95j5aRBprHIxHR+lSyMSj37XBSH+IPIZsLmS+sO7eRnKnyC8oeyyDBOC6w+DlpMSHNyg6piNfaKigIgNIUrOZ12kwv93mntNI5mqyjlKGa7ajP0KRFhuQkbX64rUuEYKcPdhfTIXui78qUvCDannrkRKwFSIpnX+YhBG/f9pldSfheo7A8Re6KEfZ/zlGlwg9mnZiyKwT/irps1IwnW2AdfUFbufCvoagVplNR+xWNy5x4lLmfjxThJyI1t4QPsTpZ5SEWahr3/gYTZBoUOhkY2mPW2jTgaMLN+wTF3XP+f2wHdf+wY7JYB3EaTsNCBTn9uEa7jOdOzEoACoDsU9lsHO3o/0lxleGtNHdcODmcj66rI9yvFgwaYPxQHFU0r/ozs18g=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <46E6357C9FF5E94198DB77CE2C189722@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 GEa26NQyclMP4ueJV61Z8aCihwkDojKyD8dGxyyPXqQgXpP1ynWN61JaaRGTKR44fF1M60NQTVH2ivrnVJa8y8yTz+PPW5fUR8Wa3RqZGDy/mmPHLDJNHu3N0V3QQkROCqdog+IuY8jveI3VjsQnESCRtRp0+kZMtbYssIPuEPyYotW8UNt7NpU1VpbsRtZQRJUfc7zbUuHUGGJd87JaJuG48zYZvWkcw2JwZtOoa6Ar+jQXYC9ol767ox4Eo+3EE5YuQXEt2uT5qwtVZtRl0BBvRNFyN0wrfAYHx2bzUIYaL5fRcT2UsV8LFLDN5GmqjmV3L7x0whzkaOMSjI3RKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6364
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c58615c8-cfb2-49d7-3aff-08de859298ac
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|35042699022|36860700016|14060799003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	86pGLirHHsmHH3rZJZ5UuXyjeib70k0sAPW+GllhIjOv/1tyPwf0JdxYxSz7dvAhdb9b6tt+sPkdtIz4R9LkcjYrHtxYYzJBUUAftnKLT4HjPhZtdRfWOp23s2tXlHcJGmEE6aF5ejE4q5RgJHCvhC+eKst49V6iw6Fy/VZ0Xikua3dx1tcvvgsuIIQw9LaYzA5t6j85/+IEK6JLO/Wbj8b9P/Vk11bM9lVBQFCZu92eDioIsJZB+3bNUDUwk5ZO/JwQmCmwNQRgsVFtWtadXYkrVB+umrGkmopWiVwZUASi+CBhF9DCC0OVpje2uigEWJ6utjanDb9OoKnzBzIM6aHscLxagZ4GHTQZIBGpWhjqkwRZWy6qf+/IQRiYmxMGJGhzyoOdItZ5AaHV0JKstczLPKxZ3xPSqf8xiAQaDmW8ggvZyWRcEJaFKbUX0xVkgqmmGo23m4L7w3Oj8T/ANRN408Os+1IkKxCelgZFDCUVJQ+4GqqXQwIQNEVTgdwf5umvRW7BblpCASJlIDjV8jdvnlmSL0lidzagUkeAx8B8sO3qhwcwMZANkNWq683MT2vTNRtcyornIC+wCOYu0TRaqnZ5t87nLkFXtXrQ4m3X0KjNVMTD4YpqF9zYjmgtlqOj4LCa1RahVD6X3VR8L/QjksWqLj8Zf8y8RihKjdMPWo0oL9JB0CVBPlrcSTPfZ0LMZJiqpICk9D//1aIBMr1IMydftfeThiZUMDTj+DRIqUF81xXp2nfQ7JX0EJDXmFNoU2BKxeR+JyGGa6aLFw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(35042699022)(36860700016)(14060799003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EmVKQfOEqguAaZcUyQm/tHpBcBPPfd97cc5Sv3E3odktFwKnkR4AYIhkqhsiFwj2wADWKQxf/nyajgGYcw4Tcu4cCMejSA+t3EEeyPy1KAVONRdUgtP1So2Y85+PmLwvzbmoISwbzNRLo1B7D+dnxZqEf2LhxoOW13FEbEimWZmZvqV3bIs07sEMJxhGDLp4UG/J03XQJvlTs7nrVSUrHw1y0b9QFGVUSDRP54LUwpnKtYZtxr6gZeC6OknjiBHS/uAlwtdU9dKB1dM7pJE/uv1Mw6hGlV7ecfiyjp3HHnyC5dn2BAvfaA3PRs3xOwPQ6Yge14b14ImY09OVi2EWZcaXFwLcBUPU3Dr91XN4k1IslEz0ujwAAbl7nsC/+ZLpxucBwqUnmKGc7O9QgxXod7N2ZdUSUzaBvcwuaeZLETnVDvb4wNn9MpHIRmMjrNxB
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 08:37:23.8297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3270f1a2-5959-48a5-1486-08de8592be68
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10013

T24gV2VkLCAyMDI2LTAzLTE4IGF0IDE1OjM0ICswMDAwLCBKb2V5IEdvdWx5IHdyb3RlOg0KPiBP
biBUdWUsIE1hciAxNywgMjAyNiBhdCAxMTo0OTowMkFNICswMDAwLCBTYXNjaGEgQmlzY2hvZmYg
d3JvdGU6DQo+ID4gVGhlIGJhc2ljIEdJQ3Y1IFBQSSBzdXBwb3J0IGlzIG5vdyBjb21wbGV0ZS4g
QWxsb3cgcHJvYmluZyBmb3IgYQ0KPiA+IG5hdGl2ZSBHSUN2NSByYXRoZXIgdGhhbiBqdXN0IHRo
ZSBsZWdhY3kgc3VwcG9ydC4NCj4gPiANCj4gPiBUaGUgaW1wbGVtZW50YXRpb24gZG9lc24ndCBz
dXBwb3J0IHByb3RlY3RlZCBWTXMgd2l0aCBHSUN2NSBhdCB0aGlzDQo+ID4gdGltZS4gVGhlcmVm
b3JlLCBpZiBLVk0gaGFzIHByb3RlY3RlZCBtb2RlIGVuYWJsZWQgdGhlIG5hdGl2ZSBHSUN2NQ0K
PiA+IGluaXQgaXMgc2tpcHBlZCwgYnV0IGxlZ2FjeSBWTXMgYXJlIGFsbG93ZWQgaWYgdGhlIGhh
cmR3YXJlDQo+ID4gc3VwcG9ydHMNCj4gPiBpdC4NCj4gPiANCj4gPiBBdCB0aGlzIHN0YWdlIHRo
ZSBHSUN2NSBLVk0gaW1wbGVtZW50YXRpb24gb25seSBzdXBwb3J0cyBQUElzLCBhbmQNCj4gPiBk
b2Vzbid0IGludGVyYWN0IHdpdGggdGhlIGhvc3QgSVJTIGF0IGFsbC4gVGhpcyBtZWFucyB0aGF0
IHRoZXJlIGlzDQo+ID4gbm8NCj4gPiBuZWVkIHRvIGNoZWNrIGhvdyBtYW55IGNvbmN1cnJlbnQg
Vk1zIG9yIHZDUFVzIHBlciBWTSBhcmUgc3VwcG9ydGVkDQo+ID4gYnkNCj4gPiB0aGUgSVJTIC0g
dGhlIFBQSSBzdXBwb3J0IG9ubHkgcmVxdWlyZXMgdGhlIENQVUlGLiBUaGUgc3VwcG9ydCBpcw0K
PiA+IGFydGlmaWNpYWxseSBsaW1pdGVkIHRvIFZHSUNfVjVfTUFYX0NQVVMsIGkuZS4gNTEyLCB2
Q1BVcyBwZXIgVk0uDQo+ID4gDQo+ID4gV2l0aCB0aGlzIGNoYW5nZSBpdCBiZWNvbWVzIHBvc3Np
YmxlIHRvIHJ1biBiYXNpYyBHSUN2NS1iYXNlZCBWTXMsDQo+ID4gcHJvdmlkZWQgdGhhdCB0aGV5
IG9ubHkgdXNlIFBQSXMuDQo+ID4gDQo+ID4gQ28tYXV0aG9yZWQtYnk6IFRpbW90aHkgSGF5ZXMg
PHRpbW90aHkuaGF5ZXNAYXJtLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBUaW1vdGh5IEhheWVz
IDx0aW1vdGh5LmhheWVzQGFybS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzY2hhIEJpc2No
b2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogSm9uYXRoYW4g
Q2FtZXJvbiA8am9uYXRoYW4uY2FtZXJvbkBodWF3ZWkuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBK
b2V5IEdvdWx5IDxqb2V5LmdvdWx5QGFybS5jb20+DQo+ID4gLS0tDQo+ID4gwqBhcmNoL2FybTY0
L2t2bS92Z2ljL3ZnaWMtdjUuYyB8IDQzICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0N
Cj4gPiAtLS0tDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMzIgaW5zZXJ0aW9ucygrKSwgMTEgZGVs
ZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGluZGV4IDMy
NTY1YmZiZDEwNTEuLmU0OTFhZTBlNGY1NmUgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXY1LmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUu
Yw0KPiA+IEBAIC0zOSwyNCArMzksMTMgQEAgc3RhdGljIHZvaWQgdmdpY192NV9nZXRfaW1wbGVt
ZW50ZWRfcHBpcyh2b2lkKQ0KPiA+IMKgDQo+ID4gwqAvKg0KPiA+IMKgICogUHJvYmUgZm9yIGEg
dkdJQ3Y1IGNvbXBhdGlibGUgaW50ZXJydXB0IGNvbnRyb2xsZXIsIHJldHVybmluZyAwDQo+ID4g
b24gc3VjY2Vzcy4NCj4gPiAtICogQ3VycmVudGx5IG9ubHkgc3VwcG9ydHMgR0lDdjMtYmFzZWQg
Vk1zIG9uIGEgR0lDdjUgaG9zdCwgYW5kDQo+ID4gaGVuY2Ugb25seQ0KPiA+IC0gKiByZWdpc3Rl
cnMgYSBWR0lDX1YzIGRldmljZS4NCj4gPiDCoCAqLw0KPiA+IMKgaW50IHZnaWNfdjVfcHJvYmUo
Y29uc3Qgc3RydWN0IGdpY19rdm1faW5mbyAqaW5mbykNCj4gPiDCoHsNCj4gPiDCoAl1NjQgaWNo
X3Z0cl9lbDI7DQo+ID4gwqAJaW50IHJldDsNCj4gPiDCoA0KPiA+IC0JdmdpY192NV9nZXRfaW1w
bGVtZW50ZWRfcHBpcygpOw0KPiA+IC0NCj4gPiAtCWlmICghY3B1c19oYXZlX2ZpbmFsX2NhcChB
Uk02NF9IQVNfR0lDVjVfTEVHQUNZKSkNCj4gPiAtCQlyZXR1cm4gLUVOT0RFVjsNCj4gPiAtDQo+
ID4gwqAJa3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLnR5cGUgPSBWR0lDX1Y1Ow0KPiA+IC0Ja3ZtX3Zn
aWNfZ2xvYmFsX3N0YXRlLmhhc19nY2llX3YzX2NvbXBhdCA9IHRydWU7DQo+ID4gLQ0KPiA+IC0J
LyogV2Ugb25seSBzdXBwb3J0IHYzIGNvbXBhdCBtb2RlIC0gdXNlIHZHSUN2MyBsaW1pdHMgKi8N
Cj4gPiAtCWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5tYXhfZ2ljX3ZjcHVzID0gVkdJQ19WM19NQVhf
Q1BVUzsNCj4gPiDCoA0KPiA+IMKgCWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS52Y3B1X2Jhc2UgPSAw
Ow0KPiA+IMKgCWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS52Y3RybF9iYXNlID0gTlVMTDsNCj4gPiBA
QCAtNjQsNiArNTMsMzQgQEAgaW50IHZnaWNfdjVfcHJvYmUoY29uc3Qgc3RydWN0IGdpY19rdm1f
aW5mbw0KPiA+ICppbmZvKQ0KPiA+IMKgCWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5oYXNfZ2ljdjQg
PSBmYWxzZTsNCj4gPiDCoAlrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0XzEgPSBmYWxz
ZTsNCj4gPiDCoA0KPiA+ICsJLyoNCj4gPiArCSAqIEdJQ3Y1IGlzIGN1cnJlbnRseSBub3Qgc3Vw
cG9ydGVkIGluIFByb3RlY3RlZCBtb2RlLg0KPiA+IFNraXAgdGhlDQo+ID4gKwkgKiByZWdpc3Ry
YXRpb24gb2YgR0lDdjUgY29tcGxldGVseSB0byBtYWtlIHN1cmUgbm8gZ3Vlc3RzDQo+ID4gY2Fu
IGNyZWF0ZSBhDQo+ID4gKwkgKiBHSUN2NS1iYXNlZCBndWVzdC4NCj4gPiArCSAqLw0KPiA+ICsJ
aWYgKGlzX3Byb3RlY3RlZF9rdm1fZW5hYmxlZCgpKSB7DQo+ID4gKwkJa3ZtX2luZm8oIkdJQ3Y1
LWJhc2VkIGd1ZXN0cyBhcmUgbm90IHN1cHBvcnRlZA0KPiA+IHdpdGggcEtWTVxuIik7DQo+ID4g
KwkJZ290byBza2lwX3Y1Ow0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCWt2bV92Z2ljX2dsb2JhbF9z
dGF0ZS5tYXhfZ2ljX3ZjcHVzID0gVkdJQ19WNV9NQVhfQ1BVUzsNCj4gPiArDQo+ID4gKwl2Z2lj
X3Y1X2dldF9pbXBsZW1lbnRlZF9wcGlzKCk7DQo+ID4gKw0KPiA+ICsJcmV0ID0ga3ZtX3JlZ2lz
dGVyX3ZnaWNfZGV2aWNlKEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WNSk7DQo+ID4gKwlpZiAocmV0
KSB7DQo+ID4gKwkJa3ZtX2VycigiQ2Fubm90IHJlZ2lzdGVyIEdJQ3Y1IEtWTSBkZXZpY2UuXG4i
KTsNCj4gPiArCQlnb3RvIHNraXBfdjU7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJa3ZtX2luZm8o
IkdDSUUgc3lzdGVtIHJlZ2lzdGVyIENQVSBpbnRlcmZhY2VcbiIpOw0KPiA+ICsNCj4gPiArc2tp
cF92NToNCj4gPiArCS8qIElmIHdlIGRvbid0IHN1cHBvcnQgdGhlIEdJQ3YzIGNvbXBhdCBtb2Rl
IHdlJ3JlIGRvbmUuDQo+ID4gKi8NCj4gPiArCWlmICghY3B1c19oYXZlX2ZpbmFsX2NhcChBUk02
NF9IQVNfR0lDVjVfTEVHQUNZKSkNCj4gDQo+IElmIHdlIGp1bXAgdG8gc2tpcF92NSBiZWNhdXNl
IHdlJ3JlIGluIHBLVk0sIGJ1dCBkb24ndCBoYXZlDQo+IEFSTTY0X0hBU19HSUNWNV9MRUdBQ1ks
IHRoaXMgcmV0dXJucyAwIGJ1dCBzaG91bGQgcHJvYmFibHkgYmUgLQ0KPiBFTk9ERVY/DQo+IA0K
PiBUaGFua3MsDQo+IEpvZXkNCg0KWWVhaCwgSSB0aGluayB5b3UncmUgcHJvYmFibHkgcmlnaHQg
dGhhdCB3ZSB3YW50IHRvIGNhdGNoIHRoYXQgY2FzZSwNCmFsdGhvdWdoIGJ5IHZpcnR1ZSBvZiBk
b2luZyB0aGlzIGl0IHdvdWxkIGJsb2NrIGRvaW5nIGEgdXNlcnNwYWNlDQppcnFjaGlwIG9uIEdJ
Q3Y1IGhvc3RzIHVuZGVyIHBLVk0gb3Igd2hlbiBHSUN2NSBpc24ndCByZWdpc3RlcmVkIGZvcg0K
d2hhdGV2ZXIgcmVhc29uLiBJJ20gZG91YnRmdWwgdGhhdCB0aGlzIGlzIGFuIGlzc3VlLCBob3dl
dmVyLg0KDQpTb21ldGhpbmcgbGlrZSB0aGlzIEkgdGhpbmsgd291bGQgc29sdmUgaXQ6DQoNCmRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYyBiL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy0NCnY1LmMNCmluZGV4IGVhMmZiYzY2NzQ5MDMuLjBkNjllZDkwYmM0ZTAgMTAw
NjQ0DQotLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KKysrIGIvYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLXY1LmMNCkBAIC00Miw2ICs0Miw3IEBAIHN0YXRpYyB2b2lkIHZnaWNf
djVfZ2V0X2ltcGxlbWVudGVkX3BwaXModm9pZCkNCiAgKi8NCiBpbnQgdmdpY192NV9wcm9iZShj
b25zdCBzdHJ1Y3QgZ2ljX2t2bV9pbmZvICppbmZvKQ0KIHsNCisgICAgICAgYm9vbCB2NV9yZWdp
c3RlcmVkID0gZmFsc2U7DQogICAgICAgIHU2NCBpY2hfdnRyX2VsMjsNCiAgICAgICAgaW50IHJl
dDsNCiANCkBAIC03MywxMiArNzQsMTYgQEAgaW50IHZnaWNfdjVfcHJvYmUoY29uc3Qgc3RydWN0
IGdpY19rdm1faW5mbyAqaW5mbykNCiAgICAgICAgICAgICAgICBnb3RvIHNraXBfdjU7DQogICAg
ICAgIH0NCiANCisgICAgICAgdjVfcmVnaXN0ZXJlZCA9IHRydWU7DQogICAgICAgIGt2bV9pbmZv
KCJHQ0lFIHN5c3RlbSByZWdpc3RlciBDUFUgaW50ZXJmYWNlXG4iKTsNCiANCiBza2lwX3Y1Og0K
ICAgICAgICAvKiBJZiB3ZSBkb24ndCBzdXBwb3J0IHRoZSBHSUN2MyBjb21wYXQgbW9kZSB3ZSdy
ZSBkb25lLiAqLw0KLSAgICAgICBpZiAoIWNwdXNfaGF2ZV9maW5hbF9jYXAoQVJNNjRfSEFTX0dJ
Q1Y1X0xFR0FDWSkpDQorICAgICAgIGlmICghY3B1c19oYXZlX2ZpbmFsX2NhcChBUk02NF9IQVNf
R0lDVjVfTEVHQUNZKSkgew0KKyAgICAgICAgICAgICAgIGlmICghdjVfcmVnaXN0ZXJlZCkNCisg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRU5PREVWOw0KICAgICAgICAgICAgICAgIHJl
dHVybiAwOw0KKyAgICAgICB9DQogDQogICAgICAgIGt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5oYXNf
Z2NpZV92M19jb21wYXQgPSB0cnVlOw0KICAgICAgICBpY2hfdnRyX2VsMiA9ICBrdm1fY2FsbF9o
eXBfcmV0KF9fdmdpY192M19nZXRfZ2ljX2NvbmZpZyk7DQoNClRoYW5rcywNClNhc2NoYQ0KDQo+
IA0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsNCj4gPiArCWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5o
YXNfZ2NpZV92M19jb21wYXQgPSB0cnVlOw0KPiA+IMKgCWljaF92dHJfZWwyID3CoCBrdm1fY2Fs
bF9oeXBfcmV0KF9fdmdpY192M19nZXRfZ2ljX2NvbmZpZyk7DQo+ID4gwqAJa3ZtX3ZnaWNfZ2xv
YmFsX3N0YXRlLmljaF92dHJfZWwyID0gKHUzMilpY2hfdnRyX2VsMjsNCj4gPiDCoA0KPiA+IEBA
IC03OSw2ICs5NiwxMCBAQCBpbnQgdmdpY192NV9wcm9iZShjb25zdCBzdHJ1Y3QgZ2ljX2t2bV9p
bmZvDQo+ID4gKmluZm8pDQo+ID4gwqAJCXJldHVybiByZXQ7DQo+ID4gwqAJfQ0KPiA+IMKgDQo+
ID4gKwkvKiBXZSBwb3RlbnRpYWxseSBsaW1pdCB0aGUgbWF4IFZDUFVzIGZ1cnRoZXIgdGhhbiB3
ZSBuZWVkDQo+ID4gdG8gaGVyZSAqLw0KPiA+ICsJa3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLm1heF9n
aWNfdmNwdXMgPQ0KPiA+IG1pbihWR0lDX1YzX01BWF9DUFVTLA0KPiA+ICsJCQkJCQnCoA0KPiA+
IFZHSUNfVjVfTUFYX0NQVVMpOw0KPiA+ICsNCj4gPiDCoAlzdGF0aWNfYnJhbmNoX2VuYWJsZSgm
a3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLmdpY3YzX2NwdWlmKTsNCj4gPiDCoAlrdm1faW5mbygiR0NJ
RSBsZWdhY3kgc3lzdGVtIHJlZ2lzdGVyIENQVSBpbnRlcmZhY2VcbiIpOw0KPiA+IMKgDQo+ID4g
LS0gDQo+ID4gMi4zNC4xDQoNCg==
