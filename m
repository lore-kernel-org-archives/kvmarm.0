Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013005.outbound.protection.outlook.com [40.107.162.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E001A3EB7F4
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.5
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935719; cv=fail; b=a+Uf6vpbRoqRH8ESs/pzRHpwIbBSZ/reZ775scf2p59Fw4Lmnxq+oo0lcirjp/dweXqWiDKkvKAcocKaJLUrNNIYviJi8fsU0ZId+jSAEuI/6lO9SZT2exPHmINyDvEXwEfL1lmZIELM3Nc8cxZfEGMIF6j+6hgdPA4LGgvLJ4A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935719; c=relaxed/simple;
	bh=DVoGNyzBVHv8WkavTKsgHFUGDwWRn2TRvIQU7OjlHhI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XkaAyZMUp36QK4ZquriAYyXhf4mggVkdSvj3oxcHAh4MORRzCDHrCuyJoLA46rlb2Dy+7wqWOn/KH2fyb4k5uPG2fgHiLp676IVA9cotCpEEtW86K7oFLX4koao/daTSLFEH1udBvfjmJksnhly7XaylL9nofbud9KBBTD2Gn9Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RQg7aA2i; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RQg7aA2i; arc=fail smtp.client-ip=40.107.162.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RQg7aA2i";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RQg7aA2i"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kvxjA7rZKPoIXGT+eWmeRj1XEtmwsWxmjEKKe8j5tWtZardsBqZZsI1gQ/i6uNaTsfZITvfli60QAlb3ZKDWWF/8dyZ5uTB+XQbrgSXO1dLZ1eA+FlH6dPRlbanLScetg82+KcCweAC5cS4Wq1q1mNLlQpTJlZETXnV9mOLqAVvZejQjkUcBpSja032a+jti7ZSuOAMOpATuY/NcrTzhav4GJz9KpA+3FPrHjW7Q2SBlp7JiVBkmUnUndGxvmFNzjfsCF12umI60d5xrUj2fQs72j60adoJIQsW67o5U7qvpjRbWbg4u9rJFXv2aL2SInUQRHnK9Ddfu9j/PE90qjg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cal4dZchKhvCKJoaOCde+IxwcS4NxforTIF5ZJLvQ5w=;
 b=D6XKHigwEezXv5//LTGaJZrUFr3+tmWlnR5QGjWsUrTptwi/l0/7Fr5t7Y1ZEk1miKG1mrGthjsFs/s1eb1u3RQDOGD4DrnPljqN9bvbrYyA9IDWprlSUBHACt1eAeZ92ixH5ktzkVFR1PzVmH+GqRBCG0xKEXya4+QqDXDQ3SYyTOtpVKdOwYHx5NbOh+vFfjQLNwKX/tptU7zfope78ix9xU4t/ClalPjPEhmWDr1dw0ENUGvQZ2hqKoKWNIjEpFfysXZRmAd1DioI1zFK+xmPkQVIZNiDuAwgWrOFDXD1tsllCiDOokCx1JXT+sUmsHXNSDchHfayRog6pKT8VQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cal4dZchKhvCKJoaOCde+IxwcS4NxforTIF5ZJLvQ5w=;
 b=RQg7aA2iQp503lbL6BveQcHzZqsakGv70iTEX6X7Jyq11ioVONC8lnVZzcgyYis8CiR9VylctW+zbsbqeK+eDAopxC5oF9SvTs9hrwzWrcAMuLdenahilcFl3WISTbBZzyOnp3xiyVkCLQkT2j9zhjWht5ounmo7ItGY1RFjQsk=
Received: from AS8PR04CA0152.eurprd04.prod.outlook.com (2603:10a6:20b:331::7)
 by PAXPR08MB6526.eurprd08.prod.outlook.com (2603:10a6:102:df::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:55:11 +0000
Received: from AMS1EPF00000049.eurprd04.prod.outlook.com
 (2603:10a6:20b:331:cafe::4f) by AS8PR04CA0152.outlook.office365.com
 (2603:10a6:20b:331::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:55:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000049.mail.protection.outlook.com (10.167.16.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:55:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vUw9EpGIZxneOD8qLZpedj3qHFImDYrE/4IZJA3QG4DCeuKzKkaFcETu2hG262FvoAKuh02bMnTpkzD/uBjXcng8daYh5jnBZCCjR3V7JVUmduL6HdfsVbT+eYo0joUQMMQ6I9pKYCjONrru3scZ3fdHqxTmtPXfel1jChiQhW+SS5IG0F/Zurby1LEjB/WlGwU99LBDz+b+Gu3bg+VBctBHWNQbmuEBbixO+kyfkBNhpvTo6cOeADc0kExVioU4FmDQXpqhpo0yVYPn7X7ZwUBvJuyV9YeZhm5FsLlHJyQq3fsGshDzH2Uv87gCrSm7TTWf3GKb87Xxefq9wNsvqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cal4dZchKhvCKJoaOCde+IxwcS4NxforTIF5ZJLvQ5w=;
 b=zHF3oNqay80Uvo1G3rGrtHsMfods2mY8rB9Cm0KF3psPwSvqrCgwRJssQflB5LkNa8xBCOkgH7gbVDtimL8N4hoRlixYrdk15rBbK7zvYITNRTSf+qmbH0EJ/5OftpQONGxw5Q1e6FjVgBfVvPLXGcleEScRoTU4o0wK5HQzY5U9qfakpT6O9Z4U9mS2Nm5065+vfL/O+kR9UH83h9ZHCpnLUEIRIxNp8X3tHqTe+hrm+TsvozxE5mwSul0qHy///531bSOoc6BJFlOWa9VXnggYIxMn9F5jPhBfJrdI1hlIRBjtej0WYmi2SUUmhwDilj37YH44JpREj8WidS/H3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cal4dZchKhvCKJoaOCde+IxwcS4NxforTIF5ZJLvQ5w=;
 b=RQg7aA2iQp503lbL6BveQcHzZqsakGv70iTEX6X7Jyq11ioVONC8lnVZzcgyYis8CiR9VylctW+zbsbqeK+eDAopxC5oF9SvTs9hrwzWrcAMuLdenahilcFl3WISTbBZzyOnp3xiyVkCLQkT2j9zhjWht5ounmo7ItGY1RFjQsk=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB6191.eurprd08.prod.outlook.com (2603:10a6:102:f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:54:08 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:54:08 +0000
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
Subject: [PATCH v7 17/41] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Topic: [PATCH v7 17/41] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Thread-Index: AQHct7ifnht9GoSHuEuHfXuDnmAuBQ==
Date: Thu, 19 Mar 2026 15:54:08 +0000
Message-ID: <20260319154937.3619520-18-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA4PR08MB6191:EE_|AMS1EPF00000049:EE_|PAXPR08MB6526:EE_
X-MS-Office365-Filtering-Correlation-Id: c7637592-2a6d-44c7-7bca-08de85cfe6e0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 JYq54PdKKDivXuv131vXKKmlkzQfurRvXEdcPMaSvby8pbpJ9crACz0VrldEGiXuIpnZKl5ttQRp57xyU5z8XcpKIB7MLVUSyGAsnSAO1I66JjJdtd4jqD4MPuYXr9bhGJO5aaKNPEIhCR4JNJG3yiR36SS0br4M3WWC0eZW+HzVEwx49RY9NsFh5DF6aJdZ4UiSml0k2wLe8oe3xbz5WZ1giLBr0h+LEyttcCo2OqlguA9kI9NJibIilSbWBcZFYniIIvlyhgYGjLndzScliANbWhPv14FZev/8CNx7I+TGzZ+qx2iyFV+bh7lzsQZSnSQgMAHtkP9r+LonWTMuJzaiFiOOC8hlaivkuCDG10J3rIOSMLv3qGSt0T8DlNfsWXE7nVSlqTTFj5ofkql8TiNEP8/JyPtw0RfFNG05zK4NGq+pBoORUgxG2xdmaLk28PVSC/W5UPs0yAxbxfhqjW1fJXm/L7+U4TydIpE09h5A1N4h22MjP+yddqrXMcih1zKEtBViI7Rwt6FSV7uqYN0lqadwp6oNGyASqGcgVPeRJ7RJJ6CpKqcn379IJ2F1i95oCcSs1n9LmiZeSIlhGkSgbTdnwnjiVZ8/onK5gb6/YvHKJiI5wBv4VMgDAHiQhthmDrioqpN1SBk0q/4LZufZ6oJhO06rjXV5AmTAlD6NH4JvBgSbGeAt3KUPSMezrvvXx5YSvZ7ggqmFz89p9cNsxpdfNzrut1PvnQyuXYcbcRVsvjfLp5nW3m4G/LOBkMLiNZL+FeYEN0TucLHOyGL1DJ56pzJ8MlP5EwzSzD0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 iLoGoXXN6l/DohQrOkmY3PH5UsadRnky2Jc59JfF4SWC2hKvFBo73WK2N1gtaKLcldUiqu7VQduGab9QFTUiLJNVMgXaKo7pl9pIpeQkbxoCYrC7YW9Diufw7iV+O/ozkQr+03RZ0vocGVSgpQEKS6iudBZE9pt/bMtxw+x6lcAGcvzKYE6J4g4SrOkR+OijfetLEpBbdm4iepoBZM/xm3SGwh/d+Op4ftKSiNb9BAK9R4VKR+jRMH77d+hMwCSpJ7Jv8cCDNu32YIgcsH4Xym3zdC3obClFbGV3AqEiJ9lV3tTTgMKfTFX5++kwLNm3LdUxX5hEE8wbapGTZ8S6lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6191
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	43b420ed-14bd-4c8d-9535-08de85cfc189
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|14060799003|35042699022|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	91sOPYARXR3x45iQy6Qpe+GGVIIhFyNG+1QFELF/aSFz06J7qqV6XbyQv8+Kcp73nISLp+94zaWjp+ZJMdP922eUjojFGL+Wwqr80v4LxSwudHfyOZGz9OpIYMvRHwROxV+cOs3j6fKxVvgi9H3y4709KgflP761FXe8zw+SwVzHrOPp6czIzlHgIPvoO2OMV4iFQR3Vg3BZX+FVspvaOoKwpRl4C100k1YKJM6KgVcbwapDU1TtJDq2CtOBRPh9l0NisPlmcaEoLofvSKMnubAihNUbdcVE302dBaxsOcl+7DXkVUhtGEXRukkUYkev1rywh2oilwclat1UHRlprCb0tw7Mrz2BLZG+6TOOBK9kWBgJswtXazbKF+qcsjA5xpaa6Vj546XzsLv3rV2uvSZZWcY5Xi0ojO0wPyLukeXTqUPQb2UFly37ENRRD3FdWyiRgQUtiRS8AqfE5nUMHayB5VQ1wjLZqu7H+DClKZf45ju1mHH1in6ROp69Rp0cVCif9vYk1dgoxvVWWrybJbSiy+cH7bWyV70G7VWBpUWl/XVxrDGkwZx+5/WfoKaw12LxCJj1Pl4WKZKpgdXdz//vM6W11BBEfWnGk6WrIXaqxy5Yr9zYGUFRZMpaSvd/KIOQWkW4wUgRBb/o+s/5wMbXr7a1YOOcC4BBvIGLVaMOCka/r3xyy3h2cSqnoyFnIK1GwUFeNzfvGS5vf9NFzqRgOTpczKmfA/fuY1Jucjkn2IBp1bW9sHWe1NxB/V3YRdm/sOnn+L7J7yFexNGW8g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(14060799003)(35042699022)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cprYK+bBCGADI0scwzBVjQMtnq+cBWR0HrXpQpxjVfQZLZpdNL9xSg/jQ9xrmKZyRSFaHlRMfonwNyYlOS5xPmvNzWfwxAzD1O8hpn+wePuW7PY7VaeI9TtSCEX77VIRL3U2Lt9kFyKNUICfLhucUsxNN5nVOSHB/CtdP/axoLFAaBPzyOwvZDOBI2SckG4haQpFdum3sZVJImwwx+BV7Bqp9oQn11H90RUk/mf3lGhO4H+WyV9sz9ABCMdJrc4FRoohLaie/UuP0Z1i3iPzkqg5mk/r47wes7CjvPac1QukoWD5UQ46NP7/j9Wjh7RXyrXQL7G8G5WmhEgXa31Rlv0cmPUz+eqB5/zI/NKW63kUQqMmUg02jOJSTizMw7Msf3tkOhRi9xQqo5q5oguot7e42rxCzCBfD+yZ4MSVERjgP3BRdN8AzSyzOoMTd6pf
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:55:11.0297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7637592-2a6d-44c7-7bca-08de85cfe6e0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6526

This change introduces GICv5 load/put. Additionally, it plumbs in
save/restore for:

* PPIs (ICH_PPI_x_EL2 regs)
* ICH_VMCR_EL2
* ICH_APR_EL2
* ICC_ICSR_EL1

A GICv5-specific enable bit is added to struct vgic_vmcr as this
differs from previous GICs. On GICv5-native systems, the VMCR only
contains the enable bit (driven by the guest via ICC_CR0_EL1.EN) and
the priority mask (PCR).

A struct gicv5_vpe is also introduced. This currently only contains a
single field - bool resident - which is used to track if a VPE is
currently running or not, and is used to avoid a case of double load
or double put on the WFI path for a vCPU. This struct will be extended
as additional GICv5 support is merged, specifically for VPE doorbells.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c   | 12 +++++
 arch/arm64/kvm/vgic/vgic-mmio.c    | 40 +++++++++++++---
 arch/arm64/kvm/vgic/vgic-v5.c      | 74 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c         | 74 ++++++++++++++++++++++++------
 arch/arm64/kvm/vgic/vgic.h         |  7 +++
 include/kvm/arm_vgic.h             |  2 +
 include/linux/irqchip/arm-gic-v5.h |  5 ++
 7 files changed, 193 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index b41485ce295ab..a88da302b6d08 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -113,6 +113,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
+	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
+		__vgic_v5_save_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_save_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -122,6 +128,12 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcp=
u)
 /* Restore VGICv3 state on non-VHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
+	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
+		__vgic_v5_restore_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_restore_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmi=
o.c
index a573b1f0c6cbe..74d76dec97304 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -842,18 +842,46 @@ vgic_find_mmio_region(const struct vgic_register_regi=
on *regions,
=20
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_set_vmcr(vcpu, vmcr);
-	else
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_set_vmcr(vcpu, vmcr);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		vgic_v3_set_vmcr(vcpu, vmcr);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			vgic_v3_set_vmcr(vcpu, vmcr);
+		else
+			vgic_v2_set_vmcr(vcpu, vmcr);
+		break;
+	default:
+		BUG();
+	}
 }
=20
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_get_vmcr(vcpu, vmcr);
-	else
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_get_vmcr(vcpu, vmcr);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		vgic_v3_get_vmcr(vcpu, vmcr);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			vgic_v3_get_vmcr(vcpu, vmcr);
+		else
+			vgic_v2_get_vmcr(vcpu, vmcr);
+		break;
+	default:
+		BUG();
+	}
 }
=20
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index cf8382a954bbc..41317e1d94a2f 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -86,3 +86,77 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
=20
 	return 0;
 }
+
+void vgic_v5_load(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * On the WFI path, vgic_load is called a second time. The first is when
+	 * scheduling in the vcpu thread again, and the second is when leaving
+	 * WFI. Skip the second instance as it serves no purpose and just
+	 * restores the same state again.
+	 */
+	if (cpu_if->gicv5_vpe.resident)
+		return;
+
+	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
+
+	cpu_if->gicv5_vpe.resident =3D true;
+}
+
+void vgic_v5_put(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * Do nothing if we're not resident. This can happen in the WFI path
+	 * where we do a vgic_put in the WFI path and again later when
+	 * descheduling the thread. We risk losing VMCR state if we sync it
+	 * twice, so instead return early in this case.
+	 */
+	if (!cpu_if->gicv5_vpe.resident)
+		return;
+
+	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
+
+	cpu_if->gicv5_vpe.resident =3D false;
+}
+
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr =3D cpu_if->vgic_vmcr;
+
+	vmcrp->en =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcr);
+	vmcrp->pmr =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcr);
+}
+
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr;
+
+	vmcr =3D FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcrp->pmr) |
+	       FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcrp->en);
+
+	cpu_if->vgic_vmcr =3D vmcr;
+}
+
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_restore_state(cpu_if);
+	__vgic_v5_restore_ppi_state(cpu_if);
+	dsb(sy);
+}
+
+void vgic_v5_save_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_save_state(cpu_if);
+	__vgic_v5_save_ppi_state(cpu_if);
+	dsb(sy);
+}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 2f3f892cbddc2..84199d2df80af 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1017,7 +1017,10 @@ static inline bool can_access_vgic_from_kernel(void)
=20
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	/* No switch statement here. See comment in vgic_restore_state() */
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_save_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
 	else
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1026,14 +1029,16 @@ static inline void vgic_save_state(struct kvm_vcpu =
*vcpu)
 /* Sync back the hardware VGIC state into our emulation after a guest's ru=
n. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	/* If nesting, emulate the HW effect from L0 to L1 */
-	if (vgic_state_is_nested(vcpu)) {
-		vgic_v3_sync_nested(vcpu);
-		return;
-	}
+	if (vgic_is_v3(vcpu->kvm)) {
+		/* If nesting, emulate the HW effect from L0 to L1 */
+		if (vgic_state_is_nested(vcpu)) {
+			vgic_v3_sync_nested(vcpu);
+			return;
+		}
=20
-	if (vcpu_has_nv(vcpu))
-		vgic_v3_nested_update_mi(vcpu);
+		if (vcpu_has_nv(vcpu))
+			vgic_v3_nested_update_mi(vcpu);
+	}
=20
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
@@ -1055,7 +1060,18 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *=
vcpu)
=20
 static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	/*
+	 * As nice as it would be to restructure this code into a switch
+	 * statement as can be found elsewhere, the logic quickly gets ugly.
+	 *
+	 * __vgic_v3_restore_state() is doing a lot of heavy lifting here. It is
+	 * required for GICv3-on-GICv3, GICv2-on-GICv3, GICv3-on-GICv5, and the
+	 * no-in-kernel-irqchip case on GICv3 hardware. Hence, adding a switch
+	 * here results in much more complex code.
+	 */
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_restore_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
 	else
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1109,30 +1125,58 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
=20
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
 {
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
 	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm=
))) {
 		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpu=
if))
 			__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
-		vgic_v2_load(vcpu);
-	else
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_load(vcpu);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		vgic_v3_load(vcpu);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			vgic_v3_load(vcpu);
+		else
+			vgic_v2_load(vcpu);
+		break;
+	default:
+		BUG();
+	}
 }
=20
 void kvm_vgic_put(struct kvm_vcpu *vcpu)
 {
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
 	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm=
))) {
 		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpu=
if))
 			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
-		vgic_v2_put(vcpu);
-	else
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_put(vcpu);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		vgic_v3_put(vcpu);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			vgic_v3_put(vcpu);
+		else
+			vgic_v2_put(vcpu);
+		break;
+	default:
+		BUG();
+	}
 }
=20
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 7b7eed69d7973..cc487a69d0389 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -187,6 +187,7 @@ static inline u64 vgic_ich_hcr_trap_bits(void)
  * registers regardless of the hardware backed GIC used.
  */
 struct vgic_vmcr {
+	u32	en; /* GICv5-specific */
 	u32	grpen0;
 	u32	grpen1;
=20
@@ -363,6 +364,12 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_load(struct kvm_vcpu *vcpu);
+void vgic_v5_put(struct kvm_vcpu *vcpu);
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
+void vgic_v5_save_state(struct kvm_vcpu *vcpu);
=20
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 07e394690dccb..b27bfc463a311 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -447,6 +447,8 @@ struct vgic_v5_cpu_if {
 	 * it is the hyp's responsibility to keep the state constistent.
 	 */
 	u64	vgic_icsr;
+
+	struct gicv5_vpe gicv5_vpe;
 };
=20
 /* What PPI capabilities does a GICv5 host have */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index b1566a7c93ecb..40d2fce682940 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -387,6 +387,11 @@ int gicv5_spi_irq_set_type(struct irq_data *d, unsigne=
d int type);
 int gicv5_irs_iste_alloc(u32 lpi);
 void gicv5_irs_syncr(void);
=20
+/* Embedded in kvm.arch */
+struct gicv5_vpe {
+	bool			resident;
+};
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
--=20
2.34.1
