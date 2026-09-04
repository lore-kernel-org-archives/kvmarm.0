Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011046.outbound.protection.outlook.com [52.101.65.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223BF513554
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788543902; cv=fail; b=KQ+uwYS8ixhwf3jpFLjzqqXyvjZ9yWtrtDu6PfNuTJd82V3K/C0lbgKa6mjfLQPiofyNnBYmOlpaTRybxBdJVBOE2rtmxuX7wVocKJy0o+9v7WlAFyJokYVB+bihtFcBIHsMqjeyrumwuiXPlCkB+C7an+juyjgl5Y4JQpl8L+Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788543902; c=relaxed/simple;
	bh=K13jn9ajls6AvZrHWSFo7gJc/VrJlTUbxOrGtcpGKI4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jjt0CcSPnL5he1oaFW8wl1PBdSh9FyFL4BUNlQqoFZeFVJ7uUNXOQB5FosTlPLCGZqC9yJJLcO/fZebzNZ8J2vznOefNPH+Xnk1mNmo6u9J2LGNMVvcJzB0B4GuKM4JEvye/CQ92VIT/CP4RKWQlm8+IPSjckxCqyvJpFET9NNs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ia1ZftWE; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ia1ZftWE; arc=fail smtp.client-ip=52.101.65.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ia1ZftWE";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ia1ZftWE"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jz5PMr//j0rB+bCLKP8wQOlu/w/yu+qrZy75RkGVsnWHBdOJdGdnQdXncwmExDgquF1mDAn15ZWTPyXSEsGiGuaoVtZfIRl+nvV9u80xv8BbNyiIos9vWqOdtdXne4zgA8YgcM9gVqeek9llc2CZLE4cnisGcs7jYziwKBYJRbKpi+oy5Nnf3eJIBOAR9ktJPmAnSd/V/w8mmBDuCNz9GGK4yd+QzvtJvVn1ejcAaow2x7IdYghnTUvekXk7RSgWxFVm2JCi1KB12qtiUt0bKVAqBITaeJRUf/TJW0hLQP4g3bZebdk7GWPozSzwZfzsvdDKm7gpx9vQe+WMj8HTFQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOYObNS0PAyZ3/TPx9Rj+JRLf+Qnfqq6SkPib1CQaL8=;
 b=PCyOoTStdu8uqFDhp+4vLRMjL5KvRGAVrHab1139xkgeF+yXcU0xpnZvzAchsvCANglLT62FzfjaEDb6YM/0EWxgS/7R9e61WWf+BKkXCd2O08Ibi1nnoVIPjXEMCMHMCrX20lVxosvsbAYH0rQx/Lfu3fvr3psXDMf0V6iGovAmfjuCKBuTqOvX1Lib56JUipKI7AYfWayOhnUTppgNmEE5206BvMzivDQ40D9gLnRQw6EP2ahWxwcZrxlpda932G5aABva+zkRIfamas0sG7ZWsKgSoEQCSW16+GstXSW/nBJ8vC7J3O7qU2MDslptIpQJsycmXlCoaIAn48RBTA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOYObNS0PAyZ3/TPx9Rj+JRLf+Qnfqq6SkPib1CQaL8=;
 b=Ia1ZftWEkxTLRBcygLjftV3uC2cklH+O/IJGed4dhz484oUE5NtNKSNIoWGWwHASif7skCNxvx6pBrveMq2E25GOqAHVal1XqXHzFdkawKef/uw490cqgQp+CAIssnqRpV9DlZtoIY4tnFVbdYJV9V5ODs1e/c3rXkIsSNOM25w=
Received: from AS4P192CA0007.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5da::19)
 by AS8PR08MB8489.eurprd08.prod.outlook.com (2603:10a6:20b:568::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 17:44:54 +0000
Received: from AM4PEPF00027A65.eurprd04.prod.outlook.com
 (2603:10a6:20b:5da:cafe::8a) by AS4P192CA0007.outlook.office365.com
 (2603:10a6:20b:5da::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 17:44:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A65.mail.protection.outlook.com (10.167.16.86) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 17:44:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yAkcf00rAvfMQeDNsPZWy7OZ7SoTjD6GNJNT2TjQ5t+Tso2KAhDMRsnVSTf7+um6mHbqkHnhKDbkn44KYjPxhRpYkGjV1TJEwRH0GKujCpmny5ISFReaeY4XtV75dbcPDyeMlX7ZHtUUelwZWCX8wBY02n254htPeIMI9QYshrxNu6q+tYVmG5FNOR8rvuonnWRROa7C+mUf3ezP9hNruKnfzOAURd6jPFGoVJmsrO9t3Rl+HX0duQxhya6uUMWcEYZipViWL0ANp9NUv9Ru52A0aP1xzLxdZYoiJL+dmdnhADX6jDfELteGBL9FhSFtQWiU8rR/NlpzbT1hepSohw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOYObNS0PAyZ3/TPx9Rj+JRLf+Qnfqq6SkPib1CQaL8=;
 b=XlRR6SdPe17NtJwfgDv5cC+qtPR0K75hwUYtdKsntHvekFVdBU5W7ACP0Z/G21NByLSTZ/ERKqHTwO7QsWaFfqcZr6GYQu50tSTmurWHTsXd7DypB1YsgjEzgDhbTQ7rLNxJqbo9tOfdI3irVsfJnQnrEfUzIOa63/2yjrjT+sSAl11Fv0hANQoJPyJWKPF06Tc2s+molAb20yB/Eq5TQWRkJEta6V4HiMVY+i4rDV8yFDk9JfjPDwOKoowN32FhGoKqORK6PKB5qAtDtVIBIFifPgiE5JJDlFiIq80PdPTHbyFo8bsvM4nSnn6NumFHx9yzqgk+tv6Ex1GpLDcgXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOYObNS0PAyZ3/TPx9Rj+JRLf+Qnfqq6SkPib1CQaL8=;
 b=Ia1ZftWEkxTLRBcygLjftV3uC2cklH+O/IJGed4dhz484oUE5NtNKSNIoWGWwHASif7skCNxvx6pBrveMq2E25GOqAHVal1XqXHzFdkawKef/uw490cqgQp+CAIssnqRpV9DlZtoIY4tnFVbdYJV9V5ODs1e/c3rXkIsSNOM25w=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS1PR08MB7633.eurprd08.prod.outlook.com (2603:10a6:20b:475::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 17:44:21 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 17:44:21 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>, Joey
 Gouly <Joey.Gouly@arm.com>, "seiden@linux.ibm.com" <seiden@linux.ibm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] KVM: arm64: vgic: Serialise CTRL_INIT against vCPU creation
Thread-Topic: [PATCH] KVM: arm64: vgic: Serialise CTRL_INIT against vCPU
 creation
Thread-Index: AQHdPJUEoX61INNB4k+aTdA+Ycbu0A==
Date: Fri, 4 Sep 2026 17:44:20 +0000
Message-ID: <20260904174419.76057-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS1PR08MB7633:EE_|AM4PEPF00027A65:EE_|AS8PR08MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ce901ac-232f-4b66-5a41-08df0aac3a67
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 VCw9lay9PN/s8zbdusXBWuohuPGcOdCqQhbEXWLMggpc0l42Xic+y7rx0k9v4XBKs7wSDgrZGIKC3D1jWB2w16VPDC//A/HkJBteV6PDcMHwp5UljT96dZ8QH9CpQk7xEPhLwqTwLLy/uGP+DzhF9GZUCadayDIgTs5IzRPqgZVqxKD0y3TafQlcmUZiq78PmaSjis/C658qnhEIbxxeSXG9wqQtGi77TeiDoPVeKiUnKLfbZ5R7czFKrOhPL0bPiPYUSd+xp017h1+ZsjW+EqytMYX2plZyF+J51UC86ckvxB8Qi34O8pdabTq+vlqp3vtBfX5ftwSqkTyNUUW8pjQp97xdibEnOuQFDG00i9SQvT1Qg0zMHtX1B2+v1CTCXytMziOSLjKfJf/g+Cm/4dJRF3P3xZFK22HKDdn1kM7+07wEsPC7Fg4+FrUEujnvrFP39pa/A8dsnohUH8JZdwtjS7WF+BJEGKNe5PGrbdHimduXkcbk8zcSLPe2xnmugU1VXqRITuN98lXfzaQeQNGBNdPPG6OIAUuTBarLF4nJGWxg2l7rSS0Knj3X+Yc068ZU/+0F091eKsGVdJe0/fnwLx6ElyDm5+gp0RdkHncMRofyQCFvSstWd6Q7OuNfitCHNucoYfMjLlTTy/7gXb58CvE8IJ1nSO5TUWa3OFCVjeoQAR4vGLtXeYTdYC6txPAPoOOMQxTxLSb0RFRn2fKVSw8egEkBx1QOU7gS9pQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 J5Ijia7cnAmDg4N/shYajddndZBv187/38BC+ubwmxNcqiWn9tQTHgO9SVt1yWLGSMCAZC1CNFEn8dYP2aDQk6D4s7YBBdSEr07R//oM7lFYRKvbu8NjfUoE60gHEvmH8du2wIbFslg8Q/T45h079zKsED/l4tKFJ5z7xQonzbGbFclQ9fp4oTqu/Q4VNV3da0UvrVzcM53GkjjR22YOOZ2lYKJ6peEVXdVBoO+k6VFhC4bpBXr9d+vLS9rj/az9GGwBR5EhHRXtQv2nWrRkxm+vT+EjBpFkMIqB3yhPuZxEj+P1kMRS4yZaLX/gzxqvhO/R+tt1cccObHQcjjVIdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7633
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6d269ae9-8331-4472-7c91-08df0aac26b7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|23010399003|1800799024|36860700016|82310400026|35042699022|376014|13003099007|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	7RXf49IBNJdshHKb3+3sWscSWNbvInLzaAHYR//E3rvZoz7p8I/npd4HiKITaDlncI6pcr4THs5C0stIB4DeRto+s/YDO6ttUD3ul5MAIZth0r5rlqh6hDAE1VSVAzSh6HOHM422GLhVa9Cs0wUw+annT5g+YKsPx/Gs8v/Bd/I6Q5cwdAYbgayCWT3grftaDaBPdbDQxKtnMyHPT3bUJR+rAkBZE+oxhf+Q4a25zXyt+/OmwKsGwBUN7MGVEdmFwgEwyy3ZYrUD54ZcxkSXw5HZz61j3aW8rzcH/7rPkIvaqgPwQggFVpMyTc8qOkCGhpGMuUmpm9tgLm1NZxg/u53VGQbVQ/GBAC/WXugjjZQsYn0ho1Gn/2YsDA7iOGPLUemXWZu+kP/cu7NM1X8V3ydBSpflO8T+mGCClGVzmYhR9Pc92WNIl4xJoW4zuy2Y4hD2r578g7nos6azOiBuENz5n78cJBWmCCMUURTnWZr3+CIJKG20Oo0PaNxNSlzx7W+nZjKZiDaPD93F3CE6LurfNyerBqs6klnu5CGGuRavCIsoZfxyXkvz59ly4O6ziBh8kuuHh7iAtt5WFATXBjp4yyBAvpQTmLsMORP3cP83eZMeZAlzA1eJHOCCERVrjby1rqdD/Tox1rmOPQlZ/Zpvj/WYvlR5yMN+2qqwJ2c=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(23010399003)(1800799024)(36860700016)(82310400026)(35042699022)(376014)(13003099007)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aew5ME4Bbhah0fC5QcUVjuoQEe+uWDq5qSsb2yonNfznzMgNoben66TxBEileknnNcNNpT00NsOpdgqnz8hxlJ3fpjWFSMPlSSxbhlNBrhUbrYiXgtOmctb6h/VWniQYTtvqOiOehiHtedtpDKgdRR0P5gFlPVs3mt6MFtZE/2p5C0wyOrUtEeMRDK95e7BhfdgKapacFEMNWlPYJThPA1DM3JeqbqCZ2IgyDxXhuPWp22Rxg5YKVWCrSyrKyelY2q0nxcVSqUj18mO/s9RwXymHOxvL0mzYHhpbkVr4HjnCKBREQXedgHKNrem2giQsCZG3Hjc5EWKiMQWNcOFRqAIWY3dScepSpmPIaf3UgaaFZrvWZywM6z7SCL+Easv58lynJc13oSOmMaXuBDxEL+Ug7yee60OVrhbE8rWi3snBpp4f/xrTMGKfy8eDDdCC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 17:44:53.9398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce901ac-232f-4b66-5a41-08df0aac3a67
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8489

vgic_init() compares created_vcpus with online_vcpus to detect a vCPU
being created. However, CTRL_INIT only holds config_lock, while
admission of new vCPUs and updates to created_vcpus are protected by
kvm->lock.

A concurrent KVM_CREATE_VCPU can therefore increment created_vcpus
after vgic_init() checks the counters, then block on config_lock before
publishing the new vCPU. For a GICv4 VM, vgic_v4_init() consequently
sizes its vPE array using a stale online_vcpus value, leaving no vPE
entry for the new vCPU once its creation completes. The upcoming GICv5
IRS support would hit the same issue when sizing its doorbell domain.

Hold kvm->lock around CTRL_INIT. The existing counter check detects a
vCPU creation already in progress, while the lock prevents a new one
from starting until initialisation has completed.

Fixes: f00327731131 ("KVM: arm64: Use config_lock to protect vgic state")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260807124506.ED85C1F000E9@smtp.kernel.org
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 90be99443df3b..219881915bf41 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -255,9 +255,11 @@ static int vgic_set_common_attr(struct kvm_device *dev=
,
 	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			mutex_lock(&dev->kvm->lock);
 			mutex_lock(&dev->kvm->arch.config_lock);
 			r =3D vgic_init(dev->kvm);
 			mutex_unlock(&dev->kvm->arch.config_lock);
+			mutex_unlock(&dev->kvm->lock);
 			return r;
 		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 			/*
--=20
2.34.1
