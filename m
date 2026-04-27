Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011025.outbound.protection.outlook.com [40.107.130.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EF73469F4
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.25
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306687; cv=fail; b=a59ipVptSo1H2Kocj54yOKEHoDZkAWcaoMIc6y+EhG04WQOGpErJUHylYmVLvGn5Hjjqj5m/E2bud0LvOBZhTWq+hcuR/OLJ9VkSz/GKXNuOu+rRFa/7w0/GLwoCuEwKkKEzgAMMF3NY9Y3nIkNSIKLyw5gq9Ypm4fLGffXHRjQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306687; c=relaxed/simple;
	bh=Y1x4HX744GkvV/uDYjy7pMBP7IWVAOYT2CJqj2D4FCI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BBUq62v+Zw4Uk8gjc/Iv+FNRFV6TvbiM1FUgsmQhX6ydPdSmzwLmq+p+QyKvqz3q/9ONORl6jKNlAFUemPUcDo0LimUUK/7R1R4dIV32Gxs0C6LBse8qaevHU+iBxsG0To8doqdvOC67rOnZWEVVlEsC1KOqT39DxeqtGVmvmAw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IBvNQxhp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IBvNQxhp; arc=fail smtp.client-ip=40.107.130.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IBvNQxhp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IBvNQxhp"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZwXPNLLioYKeS/glMDJl7WbyRm4CfhJorDgPs7kszKxpCXBMuqNrL53xSEh6FBlraekIl2lx90wOEZyb+Jw8vpSWeuvF6eDiUIN6h3B/hrhVwCyCETHIoQLkR6YIlEXt26XrL6e0Mt1Iialcz3IgtZVtCJm9g3qVLwKm6rP5pQ2ni7lNKnUuWnRhCtHZ6Kl/hY3GZJ7Nw3APbRJPzJ1Y/Yu3TL9L4AlhZvucSsARIVVJd0OpTg/fmK8dkRE8yjMIO++AcqWXoBHnvGLyniZ+TDm7pO2LTVsEPb6/jEr7azPko1H5Clpa/0+ZnNkM5MWd4h9Wh6ZhZZS4yHYsFmpMIw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+srgrSnEMcG+naPFHZ8O5b4QPSQnwOJTFfSu6YFJPKk=;
 b=fgq3s6zyPt2lFjnqJHAr4Q0JzMkRLgYgP2RnjAkauhoPIPjMN9rzWIRwk44Qvr8WV/fvtB8ciDSmOMFtAMEwkeWxc/oaqo52D9ejIHIGfKkgssrSUI2ioBcV6c1hPa0NjTcoP17Rw/saCmfKbQTSqoFcsJDZP66ZfPuq/+CtS1F39P+4UP4WwC8byxqBHTl8N9hqOlEckA2EEjxOVir0zADbKu+Om3EDQhld5ayYttQapMg5GRWmUNJCu8s64wDN1lshW+zXgMfj1UOEz0LWZuWG7et4/JbrkgxjeoYW3LrV6p6A/6C4QCn5iXizZLGCFNbGsuFK+QeYTiGcKeJgqw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+srgrSnEMcG+naPFHZ8O5b4QPSQnwOJTFfSu6YFJPKk=;
 b=IBvNQxhprwEjP/V9bjc8Yk1P1Iy9P78UoJZ+6tLXX3iyAQQbpM2Nq09v4KsrBMBe8UFEkOv7uh9GXgs7KKLcmN/7F7o8DVF6+oaSi6KQNcafFP4xmvwu/1Nbb9uoS9WBrccxP2vKhm1bxVYZQ9a9iyXLh0OE7OB1ly71QH/5lUI=
Received: from AM6PR0502CA0055.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::32) by AMDPR08MB11411.eurprd08.prod.outlook.com
 (2603:10a6:20b:717::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:18:01 +0000
Received: from AM4PEPF00027A6A.eurprd04.prod.outlook.com
 (2603:10a6:20b:56:cafe::fa) by AM6PR0502CA0055.outlook.office365.com
 (2603:10a6:20b:56::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:18:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6A.mail.protection.outlook.com (10.167.16.88) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:18:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bFzfANu0bxMqsru7Py8xpFsrtqKIQrQvksj+S2IdIvxoThNeyB3HQjdpQZSeIGjLX1aubcrCJDQzvcUmpV85RdI5iom3Tdc8izE4BVIuvHGaVFuNOPJyoybx8TMe1dowVc6f4b/9V+oALGPR45StNdCa5glQZPh2vXL8c+jddqFTjGYF9kQqZoc6XwUgZik+SN1XUSZf1CbOPj036XLWPgLG4kiF0vEAs+7IGbhN0KO5Qox7lVbMnqNEKOjyD8GOXZ/dZQoHv+dQASZcxMkHzNhtOLh+ywJE14jqNhPCJL47xvvAa0cdwESBsHWTzbhHXZr+vTYGtKvWmjQMYbjqAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+srgrSnEMcG+naPFHZ8O5b4QPSQnwOJTFfSu6YFJPKk=;
 b=dXxL5ub3pJzieJckQAqfSTToH5SR3mEw6uZw34g8JoDFXxfiMZ2eLTUMO6zouy2vwYtLZgnuX76l+2eA9WNTCtvp/Xv4sJaeMDSoCn/n5xtZUSEqezzsNLKCs+HA936r4Zz0o+gYSOsqkqWEBUiW8RS/eTVoTMON+HGCJzCsgKicGjkA6XloCmR/kvl/lZp/nW1Ai+RPa4P0py2a5IlrZ5E1GtsuddE0GUSQ4dSHpxQIHngVWZlOgweou7j+lxlHITAAaza0nKsqi43c4ZSuZkD23TAoGABWkvXiXCtX1Kh2FVBGhZAJ1ppeGB8WFA4a+jyx3KbBQRE3aAkX82BdZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+srgrSnEMcG+naPFHZ8O5b4QPSQnwOJTFfSu6YFJPKk=;
 b=IBvNQxhprwEjP/V9bjc8Yk1P1Iy9P78UoJZ+6tLXX3iyAQQbpM2Nq09v4KsrBMBe8UFEkOv7uh9GXgs7KKLcmN/7F7o8DVF6+oaSi6KQNcafFP4xmvwu/1Nbb9uoS9WBrccxP2vKhm1bxVYZQ9a9iyXLh0OE7OB1ly71QH/5lUI=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:16:58 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:16:58 +0000
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
Subject: [PATCH 32/43] KVM: arm64: gic-v5: Support SPI injection
Thread-Topic: [PATCH 32/43] KVM: arm64: gic-v5: Support SPI injection
Thread-Index: AQHc1mFFW9vwpgWs3UKNGEXuCTp+QQ==
Date: Mon, 27 Apr 2026 16:16:58 +0000
Message-ID: <20260427160547.3129448-33-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|AM4PEPF00027A6A:EE_|AMDPR08MB11411:EE_
X-MS-Office365-Filtering-Correlation-Id: bf3a3b62-e3b8-4daa-4f2a-08dea4788dab
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 wPLmgOObhySEsoZgyHuQvrGGQBmgJas2S3SxYHQQyTMywB8T7YweVwBdSZtmN81lo6m4Bazqq48gYS6L5m0IoTCYSQRFm4gp3ren6AGKDfMH5ijWFvaWJNVcssVrNG/tyuFtF9MYL5+/8MiK/rzIu6i7BWohnA/1CXhP5u/0jFbK9B4+CsuY9HYuyMlisgB1OgzUPiwqt5ctiqfqm2XD+bRM4/YklLiEK5GrxfTvJiNIBcEWRkdzMQSpVcPKH5St7aj9mIosd9j/zfKeEpmddFKjJ4HeJAReIWcjbUyZue0UrZwg2OgB+EinCR7iQ0Jv+H2vnykpiYthqiH+MDaKtvpyqBuc5v68RRGQ7P3IZWhX8KQaIy3YB4eJqJHjEd7PIu/EVOYJqICiSnrgE0YvLXgsvz4esQwDsJ+k+zQniN4+/0x21+PAUio2pJdYBCJEDyImBshklPLnLr8Y2q7lA2T/yxWxgjWEu/XI3NxaXEuWq4KNjWpMNFOEzVadTw4AcjEkHwaG1/KgaUSLJW5zIW16qiKsE8xkKbGjkvVUBetQHPt0k1i8ZPTJkvt6AkhL8TQZGZpVPJG42NMp0s0o1GiwEFzRNk3bcFUiqsQ5HdBZ2+asXeiTnv+Q4SOxLKpu1UyqyQSVfoG6qf/uPQFGeLdvNcL314SVsNWjFH1yOcqrC4TssHRSfS+/0IZqF01AzarlEDd0OH1g9SgxjIIVCgDsE1tDYXm0Z7BGcRvnCD/sX5aSkNhm98g3etWDaZob52KGw0hBEOC2nZYYDvbkPxZiOgw0Bh0WFPRodJODWko=
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
 hHGEBWAqsm2SC7wBU+tL4JjCZOsBh7gq5uL0slb5O5sj/Kjfl0z9J+/4b/htovW8L+8hy6mv/gmRpWrgc+XZ0TiDevCWMO069KiDkZI+EfnE2n7Tvgo1lpG/O7jk+LarNyNVTz3D/b3SWDmU/2DOr9FSvQlQBKI+vhUQYPw6qUSURiI1/4WXMwRL11Z8D7VtkP7JPmAb3xYqYxRuPwgXKb/NoaTjWzqzIA5h0s7J2zPkwmbTf8ghDUYpLgJeL6L0XkBhtm8wvfr+O+YAFmIC4Dp59g5fy52LxNN7BYhYTwrt2FvMOGblBBoaqEi67uDzdrn7EUdgMW7J5GU+LCt7eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8ea74314-ffb4-4000-5c26-08dea4786814
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|35042699022|376014|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	YPvvNIsYVIryevEH8kLNkOqgF0Ehm1yaQ7kcV+3kV1Gjbf8ofnRrOGciNaAh48N+Axunf0RVZSX/GQUJkpckFCNoesjQAnmB4GjKrdE7wDNwsDpEjr2s1qgGBZrGwue2toSmJc34uykzjnwZB74lwEX1xUsx61vPRDWRTYmEsvw1M1hIT5mH8sq+KbGf6ThYBVA2OsAplIBG7rGvfumegEg9WKIBYNDvLJcOq6nbG5ykOccI/lpFicFOLRhXSLQYkwF0iGHSyjk0/pqx9NK056ej6YGqC/xAZtx8B7JGqerEMbpAmwTx7rMOJnTV97JCNXoIaGb9jr6ERkKSUH5OVtmtUxo8ocnyRlVBxlW57JpQKYSusKiwCIwXHzR1XlsCm1Rws/+neopwoUqGeEOzKOMoLXEWCQxSfWCnaOQ4GpPFVRHF1dxZHMsAmtwhThjcJvqFZbpXTBCDd9NSBcWFbFDsgsZYch3FlZTLj3C7lR+Wokc0S/39c7VNA7/F4mVaQDjXHtQkc+MJrOcdNwDsz6jMvXh/+yoxwoItJ8B+Aa8l19Xp4Q8SPbQ1JUBtTnY6l4YsJ61ipf+uNHRyBoDhxVDq8FHvb04BIgc3NRicy5Ct/LMEaP9vyVoPlMo6H8Itv/lUHfaRIci5sQb3uRGv3TlhxlihHoqs86cmo9GbO5MRGQAM2j/uePxyVZcfDFORnfPEZwaT5yDmr4QmYdcNfoYV2YMDHrymW43hpdll0tnCQjQ2/DCDW4AaerLN8rr4M4SSnZD96vKWTClScM0rZw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(35042699022)(376014)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	T0wD/W0nK0JHr0eGQbOW8Gpc1TdkCYMQeEY/TRyY9xZRBjzck4su63vEDpXAJxJHOxPrlobQnZ3XWO46ATaZfStxWrazevWMd0R7xyCJ2rBkeT7V4f0KCUXjzhNL4+4Qd2EMr8uI5k72JWxnNZIl5EwMI+Vk4u/iCdI8MUwREtL3O+xqAyld0s7lh9f0yp6VCcF3rKX+uc7+g4JAeH7Ylh626WEtZUk+rEpvzVtktp+hz9yQR7kDP4R92we4WkYu030SG04D19O9ywHKnzinDiJuNVqScVDouDF84nkHHgMbo8jubA0ajC3RcpH0WOmoP/8p8+i5XYDQ0kIEnWe6tv6QN4f1IZeSda1AyuYBYCzgslEVaey7r7IzKonPm6SXfwVtozJnZRu8JjgQl7olk5k25ydR+Jcr8xZpGQRdJuqdLfMRFOfWqUJf/vbqdF0P
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:18:01.2051
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3a3b62-e3b8-4daa-4f2a-08dea4788dab
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11411

GICv5 SPI lifecycle is handled by the GICv5 hardware once the pending
state has been injected.

This change adds support for injecting and managing SPIs to the core
VGIC code and GICv5 code. First of all, allow GICv5 SPIs to be looked
up by ID via vgic_get_irq(). Previously, only PPIs were supported.

Two irq_ops are used to inject the SPI pending state into the
hardware, and to append the SPI to the VM's global SPI AP list.  The
set_pending_state() irq_op is used to inject the SPI's pending state
into the guest. The queue_irq_unlock irq_op is used to append the SPI
to the SPI AP list - they are not added to a per-VCPU AP list as they
are global to the VM. Also, this would require KVM to track the
affinity of individual interrupts, which would negate much of the
benefit of their lifecycle's being hardware managed.

While the SPIs are on the global AP list, their state is checked on
every vcpu exit, and once they've been consumed they are removed from
the AP list again.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c |  1 +
 arch/arm64/kvm/vgic/vgic-v5.c     | 91 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c        | 14 +++--
 arch/arm64/kvm/vgic/vgic.h        |  2 +
 4 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 8e69b624194d5..3a2539bf99d0d 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -724,6 +724,7 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis)
 			 * view it is always enabled.
 			 */
 			irq->enabled =3D 1;
+			vgic_v5_set_spi_ops(irq);
 		}
=20
 		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f36d37c694d71..38e37a03ac951 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1274,6 +1274,97 @@ void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu)
 	}
 }
=20
+static bool vgic_v5_set_spi_pending_state(struct kvm_vcpu *vcpu,
+					  struct vgic_irq *irq)
+{
+	vgic_v5_set_irq_pend(irq->target_vcpu, irq);
+	return true;
+}
+
+/*
+ * Put the SPI on the SPI AP list. No need to kick the VCPU. If it is runn=
ing,
+ * the interrupt will signal at some point, and if not, then a VPE doorbel=
l will
+ * fire (based on the IAFFID the guest has configured).
+ */
+static bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
+					struct vgic_irq *irq,
+					unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	struct vgic_dist *vgic_dist =3D &kvm->arch.vgic;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	if (WARN_ON(!__irq_is_spi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		return false;
+
+retry:
+	/*
+	 * We're already on the AP list or don't need to be on
+	 * one; nothing more to do.
+	 */
+	if (irq->vcpu) {
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		return true;
+	}
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* someone can do stuff here, which we re-check below */
+	raw_spin_lock_irqsave(&vgic_dist->vgic_v5_spi_ap_list_lock, flags);
+	raw_spin_lock(&irq->irq_lock);
+
+	/*
+	 * We've lost the race; and have already been queued. Unlock
+	 * global AP list, relock IRQ, and retry.
+	 */
+	if (unlikely(irq->vcpu)) {
+		raw_spin_unlock(&irq->irq_lock);
+		raw_spin_unlock_irqrestore(&vgic_dist->vgic_v5_spi_ap_list_lock, flags);
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+		goto retry;
+	}
+
+	list_add_tail(&irq->ap_list, &vgic_dist->vgic_v5_spi_ap_list_head);
+
+	/*
+	 * Use the VCPU we've been given as the target VCPU to track
+	 * that we're on an AP list. We're not queued on that VCPU's AP
+	 * list, but in lieu of an AP flag, this will do.
+	 */
+	irq->vcpu =3D irq->target_vcpu;
+
+	raw_spin_unlock(&irq->irq_lock);
+	raw_spin_unlock_irqrestore(&vgic_dist->vgic_v5_spi_ap_list_lock, flags);
+
+	return true;
+}
+
+static struct irq_ops vgic_v5_spi_irq_ops =3D {
+	.set_pending_state =3D vgic_v5_set_spi_pending_state,
+	.queue_irq_unlock =3D vgic_v5_spi_queue_irq_unlock,
+};
+
+void vgic_v5_set_spi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq) || WARN_ON(irq->ops))
+		return;
+
+	irq->ops =3D &vgic_v5_spi_irq_ops;
+}
+
+/* Set the pending state for GICv5 SPIs and LPIs */
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
+	if (WARN_ON(__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		return;
+
+	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, irq_is_pending(irq),
+		     vcpu->kvm->arch.vgic.gicv5_vm.vm_id);
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	bool irichppidis =3D !vcpu->kvm->arch.vgic.vgic_v5_irs_data->enabled;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index b35833a4e2bf9..3c8655aee8bbf 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,12 +86,16 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u=
32 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
-	/* Non-private IRQs are not yet implemented for GICv5 */
-	if (vgic_is_v5(kvm))
-		return NULL;
-
 	/* SPIs */
-	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
+	if (vgic_is_v5(kvm) && __irq_is_spi(KVM_DEV_TYPE_ARM_VGIC_V5, intid)) {
+		u32 int_num =3D FIELD_GET(GICV5_HWIRQ_ID, intid);
+
+		if (int_num >=3D kvm->arch.vgic.nr_spis)
+			return NULL;
+
+		int_num =3D array_index_nospec(int_num, kvm->arch.vgic.nr_spis);
+		return &kvm->arch.vgic.spis[int_num];
+	} else if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
 	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
 		intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_PRI=
VATE_IRQS);
 		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 7eef8ece52dde..b5036170430dd 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -370,6 +370,8 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
+void vgic_v5_set_spi_ops(struct vgic_irq *irq);
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu);
--=20
2.34.1
