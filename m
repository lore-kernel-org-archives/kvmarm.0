Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011017.outbound.protection.outlook.com [40.107.130.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B8F423E96
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890179; cv=fail; b=Cyg21SQnZITOm90M8o3CTxSA39gBiTEtzyzjJQR9ZgdzTOAsrhl2KPTA/28qz4/M3c07lo6W+tlbRGstqQc7OWzCgJ/G+TjTaoiY9ykB3EKG1syLJR0reLlfH48et+kbNnlIcOriptXOao2tvSyRIgGH2ct4IGVg/LogTNeszXw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890179; c=relaxed/simple;
	bh=+4aw3gMlEYbsKKqB6F+/MYX4XGCFRvGDUH2Oo24KXgs=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=dkPSUsHsCOzmVqFev8NwAyhYfJyekHzAks91Fvk0Fu0/jlS9LkFrjkQC1lFercv0pBk27ZHOxCh1nMEDJ2OWJE/fx+LOWfs7iYsE/jave24FR5xAmBK2UKNbWJsRNCfXd25KhZmvGfjOIQJ4/9R8L08lCKAJKYgRhZeuJZkOy2c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=olC6SdHo; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=olC6SdHo; arc=fail smtp.client-ip=40.107.130.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="olC6SdHo";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="olC6SdHo"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jQh2taVFd4uZRGDnYHo7Qmf+J1NKvcmhrVARvPuuA5oaFnbSU9RgslbJ8eHi3ifozzal33HHr7Ym0gajji9H2e8o0+7t6Ltpodg61Kcf51OjHhPLPYZJS9Ga2+D+wffU282MvB9nUW7EF9f/sU92iB+5T6vM5X8Otd3dTs4i8RFvGavkn7EOE4PmsSzwFHRJ4IrKrhH6VvP/sIUY0VxtKnx6mSIL8Wn+E08+AB29JsUrLgl35jL9sKaKPv38xsYH6CgM3/DI09sGKnCi5XirOoUS6mNSbup4dW+slZuLlZftYL/aLXB2uHPcF7hVD5WCSU5B8L1T75mvjIgMrEhpEA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIB05gEb3OB76ageA+NQUeM+aXlE9uj7lE936GrplhM=;
 b=htjXUSsCEBRzO2ukzpf5+Q0vZPT3HW8jjZP7WbguN/DrU1+LUd+bC35PNVp1MET2SiZTjePKkYnJDrz5MkBbI/1frq9hz3YqHpJLa6s5MpWEhW1XfEYz6SLWS9gYdYzyHgNU08ynVXCZhBDm/zFR79jiMjJoEO60821a6JmpM6F/CJ6Pi4tQE8dZsJEBQLKzzNRsstsg8ITVGMVacI/PG9wX3hqlRRZ43yMkoREKFGtMjxC02g2UMAWWGj+ogYrz3ey9iW7tpW0y9FUI5uwG1syThDkllvmxcrw7gEDl/jOn0MsKfm9PHtbMy4+BCk9A9lqP3hRc8zQKGAUPU8mGoA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIB05gEb3OB76ageA+NQUeM+aXlE9uj7lE936GrplhM=;
 b=olC6SdHoEPqW3dh6ZBfEE1JHX8e4gXtgZo3utVlRLOGjqWAkqNt8CpO8Q1s/veNhU6yYicUaTpFajqA6QQDc0JmAfxEBa+mXPvszx3r7bw9ncrErfRjaEsaYbzVz9SvOCl7bdlCnzVIOhz9igMd+DONd2Pejhdl/oQlcnjCwdzk=
Received: from DU7P190CA0001.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:550::27)
 by AMDPR08MB11411.eurprd08.prod.outlook.com (2603:10a6:20b:717::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:49:28 +0000
Received: from DB3PEPF0000885D.eurprd02.prod.outlook.com
 (2603:10a6:10:550:cafe::9f) by DU7P190CA0001.outlook.office365.com
 (2603:10a6:10:550::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:49:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885D.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:49:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o9kmEcIf7SEh+h/rPiq5hiYPNgdJTG7kGWUsmqjBY8+7KRfDmS5ZdknSDRHxp9hzk0YFXmiL6IptxqOxTKqn3eLslGRmEBagcAESIVAF6uHK3Lpd6G9CJWfvJ5BjZTVrgVU48RQ5yaBYNIfJVHQxSeY7JdxacbFe7WAPa8dt1EKC3eBKoZX38rqi7Q2sMokzJRF1dILlyC0oBUKuzh2MgcOyd0yJGyAeVorREkDVmNRVklOwCgu5lprTY/n0gkineEDrDhjgA7lxE8bBQjPxhDTHZhy8xvDYUcIsgVmCzR+q3arHFNQVG3PzzON//09OvkVdbpdi/6+y/x4Vld4Pww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIB05gEb3OB76ageA+NQUeM+aXlE9uj7lE936GrplhM=;
 b=FW9h6CyXu7bWgl1+55ustuqpGUVsaqmAJoa2K+/GoXVu8GPt5HE84tHxKxMl6Bb2CPYl60xEzzKqAlA2kI724QK1CbyNWEQAp4wpXwEuZx+aI0VSJ+bAPk6a4Fj/mxGGZGVj4D5DY1S5KQWbAvfw9/x5Qlr9no0SOQDHeitxQdjPXy9aQp4hSJa0VX/ABL41kq9ZDxfqBLTk4bbu0WfBrSRg7uGcJmmDRS6WKq9yciVmcNEgWv18jT03DWD0VM6y74zN/SakTZYZbvg7PkuQHteWkqTOLzhq86fbDO8RRejSqCKeEyoNEVmTXu8+LCuLzvVu5yLLIn12xYczEAm25Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIB05gEb3OB76ageA+NQUeM+aXlE9uj7lE936GrplhM=;
 b=olC6SdHoEPqW3dh6ZBfEE1JHX8e4gXtgZo3utVlRLOGjqWAkqNt8CpO8Q1s/veNhU6yYicUaTpFajqA6QQDc0JmAfxEBa+mXPvszx3r7bw9ncrErfRjaEsaYbzVz9SvOCl7bdlCnzVIOhz9igMd+DONd2Pejhdl/oQlcnjCwdzk=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA4PR08MB6127.eurprd08.prod.outlook.com (2603:10a6:102:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:48:25 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:48:25 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v4 00/48] KVM: arm64: Add GICv5 IRS support
Thread-Topic: [PATCH v4 00/48] KVM: arm64: Add GICv5 IRS support
Thread-Index: AQHdG1n0TnBshfzPZ0WC4SFxbIju+g==
Date: Fri, 24 Jul 2026 10:48:25 +0000
Message-ID: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PA4PR08MB6127:EE_|DB3PEPF0000885D:EE_|AMDPR08MB11411:EE_
X-MS-Office365-Filtering-Correlation-Id: fa8ba62e-6dbd-44c0-7131-08dee9713c6e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|56012099006|11063799006|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 C/QmDFG5OmnPgKV0NwzKgK+lslJJ2fBhFLzPUtrmXGRIwdi3AD+bmLoh8jce4Kvma+u7qm+ouJpzDk9E99z4XrRZmYJMECmJXD9pMyQZbsrGZqQhv54FN0Dq4QnY0Kp9RMAHqhVxcbti02b7LucSnSTsxyLBgd9f+QWbTHzVPUwN5NzdAWF845/GFJol+uCQ4eFqxxbDG6SSxOXks2hdNTQj/s3zCNcYxsUI0WlB+UPIklaeX5OdEXgcyJ7uh3Z3HZqOR3nnE/gaLsRWt2ZXJ7Rj4U9USOkiSQscDYF1k46cXzzg8J2fR02R1aMWyrgPQodAio8UJjwuzd3ML7WUxR20HB3Nt29bPfvAWeAbfBDJnalLlpxV35gFoit564L70FCd817qK6ICem8XmrzGzTam75MuC+OpaA6kwyp5zYwBDXf7Fhyxz3htIJft4BwRRv2dTri+PQOJ0nszJaGtsC7j3XqfaniaLZJoMguRhTK/9CaoHuvt1X+VDbtEd2h6kCfXb/Hm0O4Lj2o/hSk2wCEesdY092PKKGIN8EkgDef/mUaWCzvHaAeUhpUsrwbvZuy++mp6/VjYvtoSApSMk5+Z+h3F/H4TJkZkIPvVKjmtXuNnPxr9jZf6AvQb3ycWKIxWmEQdGePWMDJ8uaAAvXzhye9awmy8lqpcAnPq7oA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(11063799006)(18002099003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Hyl1SoyRk5BG7ROZUcRG2I59Jk+exijBmbm9SroXsgwMNzrDPKOZdLixZn1GjYVV9yB7AO8JrHChsdtFIXX6FujDloHe5oYmdr5ox4vRiTqqYBGX9SPbDbPEa9BWAsXtT7gbmkuw/Rx7BB7B9bYI0/fMg/ck/9KUpa0C2og2IQ7bQ+U2jjVMSiH9she2laufDwyHdPzlP/wuiRUccggGWfb9sollj1dJJ3r2efNfnhT+YjK7HgyvMMqc0+bbsNjR9SO5wd0L0i9XYJN874CsloNYEJNS+LECfmixH6QE61G37YY8y9q/hfAqDJ+jMo9z6BoUTiNzaXG6q0d6RXa1tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6127
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d72d2c2a-e458-4b55-f4da-08dee9711693
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|23010399003|376014|14060799003|82310400026|35042699022|10067099003|56012099006|11063799006|6133799003|13003099007|18002099003;
X-Microsoft-Antispam-Message-Info:
	FxhHNdW3oYGY5vSdel0Bad9D2eAawoS89kXE45OmuJulEPDMS8cG694ktQHrmxpmnb+nuhX7RqLKIpF1vz1Rres6MUsQqt5AlNlam87yTRqStbf4aJvnHGwsFa2dT67suzX+WL9zLFNmnsdZ8P8n/eKrMCathDDNW3fEut8Y0dpj7fFHrH4g5prAF0TvMBSv8LgwZfvT4aTMc276nJmJyU0Hq1UtlsKFd0UOLk6ENYKy7RA207qxrv0NyplIvp6LylAfHFjqWE5tYB3aOT/nQrli9RQHIe5/ZrqgNBspbBuvNkM1JQpRGx4LKAlZcNlOK8inZr+so5qv4TWYKsTrteU4pCcDGQv4sGMfK55qhHqSGqIF6m5WEQlrHWpAMdbOEaODh0MTiHpMs9M5NaVpzlc0RQGnBbLx3GGHfV1r85YyHCMHSUl0wcdCN+94QnEss+5v/+9z3wY7Iz4oJa8dhFQxOJpa4j0wlUSO1ib7dH/nEpZVkB9DN639bWom742zAaqfOaKqnB5S6lbPU/X3S6QKOuEvV7Lr53+OdG0vkniAcjZTBUtrk80O8rk0CnW3zwGcl2YMJy15Sr+m8B83GH72VFvQnaNzxvNK3OQLCud0Aw7YOdgbcpVSFE31ulkdjEeXW1ZqgZKbL5JlVyA7kg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(23010399003)(376014)(14060799003)(82310400026)(35042699022)(10067099003)(56012099006)(11063799006)(6133799003)(13003099007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tImc4YPfkvUoPYoWyz+LgtonUsVpFhDICMne0Whk0HXaNBrLhTTzDDog8/IL6uJjhaPH6VmduYQIdBV6QTPD8WVUb+Tpz0ElvDE0dR3XmmJKJiA5fHQlIBL7/6l+LWCzO/bOEokkxmDGbjyeiF8o9CG+YDVihLarILeUtfY0F9eaP24RQdorGdxbDRKJP8zimc4/kAkFMuV7FedxeakEutxY4Pjnq9fECxQBKxYTQM+CDWVr9d75rsr+ZaOthGyAvV+vztfpoiypvwfnrB5lJr/gTSPRvBJnX1DqwSZBJ+FdQ46/UwvTSyL7e1B8xyhTuYCjzYrvOYmr6VVVbDx84OUP9654ajztiE2MfkrKcaWcrJI4jPmN6BKj+k28lLNLL8ZfVSn5WnjPtnQ48ulhdb3/JhSzZtlu4sXBGytvMyBiGXBh3CQRV1ldodHNPBzS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:49:28.6479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8ba62e-6dbd-44c0-7131-08dee9713c6e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11411

Hi all,

This series builds on the initial vGICv5 support [1] and adds support
for the GICv5 IRS, as described by the GICv5 (EAC0) specification [2].
With this, a GICv5 guest is no longer restricted to PPIs, and can make
use of SPIs and LPIs as well.

With SPIs and LPIs available, this series makes it possible to boot a
full Linux guest on the Arm FVP model [3], using the setup described in
Lorenzo's GICv5 Linux software enablement guide [4]. In addition, GICv5
IPIs are typically implemented as LPIs, so LPI support is what makes
guests with more than one vCPU possible.

The corresponding kvmtool changes are available separately [5]. With
these changes, `--irqchip=3Dgicv5` works now. The `--irqchip=3Dgicv5-its`
configuration does not work with this series, as ITS/MSI support is not
included here.

The IRS is created as part of the vgic-v5 device, and is not a separate
KVM device. This is because implementing the CPU interface alone would
limit a guest to a single vCPU and PPIs only. Hence, the IRS is bundled
into the VGIC, much like the distributor for GICv3.

The series adds the host-side plumbing needed for KVM to interact with
the physical IRS, including VM and VPE table management, VPE residency,
and VPE doorbells. It also adds an emulated IRS MMIO interface for the
guest, together with the UAPI needed for userspace to configure the IRS
address and to save/restore the IRS and IST state.

The main pieces are:

* Host IRS capability discovery and configuration frame plumbing.

* Allocation and management of the GICv5 VM table, VPE table, VMTEs,
  VPEs, and host-backed guest IST storage.

* VPE residency and doorbell handling, allowing the IRS to select SPIs
  and LPIs for resident VPEs and wake non-resident VPEs when required.

* Emulation of the GICv5 IRS MMIO CONFIG_FRAME for guests.
  Virtualisation, MPAM, MEC, and SWERR are not supported and are RAZ/WI.

* SPI injection support using GIC VDPEND. Once injected, the GICv5
  hardware manages the SPI lifecycle.

* Save/restore support for GICv5 EL1 system registers, IRS MMIO state,
  and guest ISTs. SPI and LPI IST state is transferred through
  userspace-owned buffers using KVM_DEV_ARM_VGIC_GRP_IST.

* Documentation for the new VGICv5 IRS userspace interfaces and the
  required save/restore ordering.

* Selftests for the UAPI components, the PPI, SPI, and LPI support, and
  save/restore.

This series keeps SPI, LPI, and save/restore support together
intentionally. SPI and LPI support are needed to run realistic guests,
while the save/restore interface is included at the same time so that the
new userspace ABI is complete from the point it is exposed: userspace
should not be able to create VGICv5 state that it cannot also migrate.

The IST migration selftest restores state into a separate VM, re-saves
the SPI and LPI IST images before the destination runs, and compares
them byte-for-byte with the source images. It also validates restored IRS
MMIO state through SPI/LPI delivery, priority, enable, and affinity
behavior.

LPIs are explicitly driven by the guest through the IRS/IST state. This
series does not add direct LPI injection support, MSI support, or GICv5
ITS emulation.

These changes are based on v7.2-rc4. I've pushed the full set of changes
to a branch at [6].

Changes since v3 [7]:

* Addressed the Sashiko AI reviews [8] for the core implementation, UAPI,
  and documentation.

* Dropped the software SPI AP list and in-flight SPI lifecycle tracking.
  GICv5 SPI state is now left to the hardware after injection. This will be
  revisited in the future.

* Dropped GIC VDRCFG support, including its sysreg encoding and EL2
  hypercall. GIC VDPEND remains as the mechanism used to inject SPI and LPI
  pending state.

* Reworked IST migration so that both SPI and LPI IST state is transferred
  through userspace-owned buffers, exposed through
  KVM_DEV_ARM_VGIC_GRP_IST and struct kvm_vgic_v5_ist.

* Updated the IST save/restore implementation and documentation for the
  buffer-based interface, including clarified restore ordering and
  validation requirements.

* Hardened IRS/VMTE teardown and IRS enable handling, including avoiding
  VM-ID reuse after unsuccessful hardware teardown and reloading GICv5
  state when the guest changes IRS enablement.

* Expanded VGICv5 device-attribute documentation, including the GICv5
  semantics and validation of the NR_IRQS attribute.

* Added KVM selftests for IRS address, NR_IRQS, IRS registers, IST
  attributes, userspace PPIs, CPU sysregs, SPI injection, LPI delivery,
  and end-to-end IST save/restore.

Thanks for taking the time to look at these changes!

Thanks,
Sascha

[1] https://lore.kernel.org/all/20260319154937.3619520-1-sascha.bischoff@ar=
m.com/
[2] https://developer.arm.com/documentation/aes0070/latest
[3] https://developer.arm.com/documentation/108086/latest
[4] https://linaro.atlassian.net/wiki/x/CQAF-wY
[5] https://lore.kernel.org/all/20260116182606.61856-1-sascha.bischoff@arm.=
com/
[6] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_kvm_irs_support_=
v4
[7] https://lore.kernel.org/all/20260703154811.3355680-1-sascha.bischoff@ar=
m.com/
[8] https://sashiko.dev/#/patchset/20260703154811.3355680-1-sascha.bischoff=
@arm.com

Sascha Bischoff (48):
  irqchip/gic-v5: Allow KVM setup without a maintenance IRQ
  irqchip/gic-v5: Provide OF IRS config frame attrs to KVM
  irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
  KVM: arm64: gic-v5: Define remaining IRS MMIO registers
  arm64/sysreg: Add GICv5 GIC VDPEND encoding
  arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields
  KVM: arm64: gic-v5: Extract host IRS caps from IRS config frame
  KVM: arm64: gic-v5: Add VPE doorbell domain
  KVM: arm64: gic-v5: Create and manage VM and VPE tables
  KVM: arm64: gic-v5: Introduce guest IST alloc and management
  KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
  KVM: arm64: gic-v5: Keep GICv5 vCPU limit model-specific
  KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
  KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
  KVM: arm64: gic-v5: Add resident/non-resident hyp calls
  KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI
  KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and IRS base address
  KVM: arm64: gic-v5: Add IRS IODEV support to MMIO handlers
  KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
  KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
  KVM: arm64: gic-v5: Initialise per-VM IRS state
  KVM: arm64: gic-v5: Register the IRS IODEV
  KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state
  KVM: arm64: selftests: Update vGICv5 selftest to set IRS address
  KVM: arm64: gic-v5: Add GIC VDPEND hyp call
  KVM: arm64: gic: Introduce set_pending_state() to irq_op
  KVM: arm64: gic-v5: Support SPI injection
  Documentation: KVM: Extend VGICv5 device attribute docs
  KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
  KVM: arm64: gic-v5: Mask per-vcpu PPI state in
    vgic_v5_finalize_ppi_state()
  KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors
  KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
  KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
  KVM: arm64: gic-v5: Add VGICv5 IST save/restore UAPI
  KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs
  Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for
    VGICv5
  Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
  Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
  Documentation: KVM: Add the VGICv5 IRS save/restore sequences
  KVM: selftests: Add VGICv5 IRS address attribute tests
  KVM: selftests: Add VGICv5 NR_IRQS attribute tests
  KVM: selftests: Add VGICv5 IRS_REGS attribute tests
  KVM: selftests: Add VGICv5 IST attribute tests
  KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
  KVM: selftests: Add VGICv5 CPU sysreg attribute tests
  KVM: selftests: Add VGICv5 SPI injection tests
  KVM: selftests: Add VGICv5 LPI delivery tests
  KVM: selftests: Add VGICv5 IST save/restore coverage

 .../virt/kvm/devices/arm-vgic-v5.rst          |  264 ++-
 arch/arm64/include/asm/kvm_asm.h              |    3 +
 arch/arm64/include/asm/kvm_host.h             |    1 +
 arch/arm64/include/asm/kvm_hyp.h              |    3 +
 arch/arm64/include/asm/sysreg.h               |   13 +-
 arch/arm64/include/uapi/asm/kvm.h             |    7 +
 arch/arm64/kvm/Makefile                       |    3 +-
 arch/arm64/kvm/arm.c                          |   10 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   26 +
 arch/arm64/kvm/hyp/vgic-v5-sr.c               |   45 +
 arch/arm64/kvm/sys_regs.c                     |    6 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c              |  519 +++++
 arch/arm64/kvm/vgic/vgic-init.c               |  111 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c              |   11 +-
 arch/arm64/kvm/vgic/vgic-irs-v5.c             | 1136 +++++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  270 ++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |    6 +
 arch/arm64/kvm/vgic/vgic-mmio.h               |    2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c          | 1795 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h          |  116 ++
 arch/arm64/kvm/vgic/vgic-v5.c                 | 1142 ++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    |   37 +-
 arch/arm64/kvm/vgic/vgic.h                    |   21 +
 arch/arm64/tools/sysreg                       |    4 +-
 drivers/irqchip/irq-gic-v5-irs.c              |   19 +-
 drivers/irqchip/irq-gic-v5.c                  |  117 +-
 include/kvm/arm_vgic.h                        |  152 +-
 include/linux/irqchip/arm-gic-v5.h            |  256 ++-
 include/linux/irqchip/arm-vgic-info.h         |    5 +
 include/uapi/linux/kvm.h                      |    7 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |    7 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 1801 ++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  105 +
 33 files changed, 7826 insertions(+), 194 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

--=20
2.34.1=
