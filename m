Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010029.outbound.protection.outlook.com [52.101.69.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47422DE702
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.29
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375102; cv=fail; b=e7Jz/nQnp3acjW9ZkxNMRrs0Je+2lT1z5ssDQ5g06e4ugABB/Fn2009HXBFi6a8QUEL7rk+fn6H5o7jWQKUudFXY/tJNB+0i63dgauIv1FmdUr/pRcZ3cz/fj0n847x6bWwtdkT23P+OIZYdDsO12P5gKdpalLVYQ9oKlIBv0LI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375102; c=relaxed/simple;
	bh=teSwJAEk4UHsS7UR5m/m08s187t9WibKFEusNkteu3c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=inqwf0FUa/0FvR8mbWNJq+CiaTSDA+OVXvjXe8/9oZPEeuBt4v8y27gapNX2Yjfd3DoOjQv2MYWF8fH8t2SHx/3anrUWJih4NhGkW962DptdFE9UVAdWszQ01E4IXA+ZZRRtZZvROEhjzCelTcWP/dmp0W1J37ajm5ck7Ur8M6M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pBxZqaJc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pBxZqaJc; arc=fail smtp.client-ip=52.101.69.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pBxZqaJc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pBxZqaJc"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=dYGbmp6mhG/5EiTHqU96ig9tusc5CrFm1UYsO8XNDGuiBpzIdk2TofPgrnuYV5hXh5ycRcF/ELH4/NmqXu6R4bX1K4ajC3SajjS3MXJcqY3V/mzaXocHvPrN3a5ETw523VJA8xr5GRXVy/RM7RIgCJP+/2TZuwRJvAsRU7mynIZl6PRcVCEzh941KK110y0PBSuulyxqq5iln+Gp/0puK0OQYA52LwUcUvCQlS7YduJgQ57R1cEd2VfuKDK5qKmYOKFNRD/EVngm4J1QKfXIrgEB5IWAs8g2REO/ZqBYE54o2RIi1RqDM0TStGYP9uenvDblxhjEyABh78vvPLqkLA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3WmTums8o0DZOJW/In+ivP7f+UFQ4wrPWpGr9gKGRI=;
 b=nbcQW38etNgp3rIg5QXwOV3UJWJXhW1WrVp/hhu/cz1eD9bpUGNsUw58XoZ+3QUgZ09lFfmmNnJJAfxAx8hOvJcItFcCh2ZDejjRhrXniy5jep960JBuFKLZKbDgsKF/SPLdooIukFRsRG6/p2t3uF7KA5QIsGlDkSOHYTQAqgzahWcAGgCHESHrW6xJO1AtcmM6swPFouV37DpS4D9tnx0xtA52D+qvAeIEIUxGL+dQi6IDNyPEo9PiJI7ThHSWM9ElB2eh95PkzgAdPthxRlsgSWKEv5ZtobeHcGHRiA9ADnnPwLCYk9ly+DJo+E3hoNPYPabXND6NlFzTsAMdPA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3WmTums8o0DZOJW/In+ivP7f+UFQ4wrPWpGr9gKGRI=;
 b=pBxZqaJcyHVewV4tc3oU5Otdl69L7IIAQj8OYfq/VlXSRbSfuZ+h8NpYfY0XLCsYMQcIrhg+RGjbrmpoWPlPQt11Xd0z59cCIeTBTDS7h4W5YF/LGuwtc4jJGVUc7D/khVgVkKY652zBYyWvVAjy4Pbfy4okaOVVQCxyDQ0USe4=
Received: from CWLP123CA0226.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19f::11)
 by VE1PR08MB5821.eurprd08.prod.outlook.com (2603:10a6:800:1b2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:51:33 +0000
Received: from AM1PEPF000252DA.eurprd07.prod.outlook.com
 (2603:10a6:400:19f:cafe::b1) by CWLP123CA0226.outlook.office365.com
 (2603:10a6:400:19f::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:51:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DA.mail.protection.outlook.com (10.167.16.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:51:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KqI9sjwQqD1N3r/ItShQgGCTXhbM77VRIBGOvtE4dszWlNhN41y9U6iZwvxl9oijyngzeBQTXW2ACGPQhXaRVzvrC+2USG60JuxX7mpBzuKaN6dTclKYhT93BxUIjxQgS4GMoa6aHf52QaZ4QYwYC7V1WbIWoLtHvBcikNYoJ7t98E1MjoEfNmKgKWWzD2HhXTO/Exj0BdhuiRZaFOYecySYDgPyXki9RsROzy8wvb4kKiX15nFMHdABXQjd10nKEdvnPtJdOy2I166qzIg7xFjX38138zLc+aAu+xjaJf2YGx+NBgWNhAobwfaGEzt5nRU1X4BwOpZ8nEvde0STRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3WmTums8o0DZOJW/In+ivP7f+UFQ4wrPWpGr9gKGRI=;
 b=KrmS5GvtFQoxc20VxsiEyFZgCjtHJYI6WDucfrPczPTjvRwJWYbaQOmgJIO6GzHhuQe8sdzl1Wrd2lchGSXbm0uA8a6pR/S+X/t0Axi3u6A6N3S3cXEVYAkKMLus/1hE4pQLFRnZrAExTMJkT2ZGggG6M5OV2V5uFGfJPg7YZ8SdFYXHA88OOYonHrQUOSpD8xgqUcJXgHaikNmoLSmhOigdiGfyDTY9VbZ2tbBgpTaGmIrF1nT94faljIiY3EGbo32Jrf6Y1y8+j2bZYsmHMceSr9oqaRbyf/AjxwSEvedFKBh3wzLL4I6veZen+uZUajdOfv/RXMPbPnuk42nC/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3WmTums8o0DZOJW/In+ivP7f+UFQ4wrPWpGr9gKGRI=;
 b=pBxZqaJcyHVewV4tc3oU5Otdl69L7IIAQj8OYfq/VlXSRbSfuZ+h8NpYfY0XLCsYMQcIrhg+RGjbrmpoWPlPQt11Xd0z59cCIeTBTDS7h4W5YF/LGuwtc4jJGVUc7D/khVgVkKY652zBYyWvVAjy4Pbfy4okaOVVQCxyDQ0USe4=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:50:30 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:50:30 +0000
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
Subject: [PATCH v2 04/39] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Topic: [PATCH v2 04/39] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Index: AQHc6TErRpwchzHHF0yB6ffnJ9eqsw==
Date: Thu, 21 May 2026 14:50:30 +0000
Message-ID: <20260521144846.1899475-5-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|AM1PEPF000252DA:EE_|VE1PR08MB5821:EE_
X-MS-Office365-Filtering-Correlation-Id: fd960487-2dbb-4946-1d98-08deb7487326
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 6wd/6zCa/2b/+GHiM+XJBVT7RNTuSqcVbW20ooPFatlSJBkfMTMXHHymVNrPkgwVde97WxLGnBVdxMl8QUUqyd7qoyrqGRFK5q7Bl1IlRVQMwzcrZrm2izM/mg0KgMQsyPjdAl0i7JUwPoQD03LTee8UHiqI5HCZ91YJ+ZYiI+F7RXg6Xvjj43ueuhpLExfj0ft7EA38obUE08zt4Tna9nCQ8ujz5c0YOr6xJX03dV7QUGY9ZWkWfOF7u0EyMvMFJWzspVJQBBdDWmHI3oS3HlaS8+RQK4efT/78zWgSG8U0ShxK3AQCxlzbjou6GoUrpc0oxDmj3nXbpXb+FcG6mnDxZhU5qiaxqxdgsvz2X25enDOIUBPMm/5X4nz4rFknVHklUGdzrRHnFsN/ClYY0hDESYSpGn38tT+ujx/a8jStKK0OBI1iQ2eKul/KScXsJXkhsWkHcBJiBuxMoyruMyyxQbVmzyGszBB998tVLZKrU9xHCPBvMzlSP6alHptTwxXwNllgZ05brPfv6gotaQ3QN/XJ2d/iKz+VjHZzNwhPyqe6U2CPhdbQIMl4lHL3vDRjCpsUyxFkGrSKe+m8U0RuI0L9BvcYBAa46+lmGZP3y/VclXLw/1eQNQTNXyB6GuncnytlCcxhkqZACeBrr5WDpYL2My7AUcvqY8nFOnsh001AIoHG89Da4AUxYf1S1PCi91xk9YVgMBOjaViRouB5fTCrybnMDC5O4GWeI5sONgUoSSuRdumgC5zXxHQJ
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 lt4/GwjphoS9zttRkZNKzJK2VR0OWgy9U6G2GhgIGyJyA606ntoOuSzyCt1tshi1ZWjft4vyZlgMns4Yw3Tu5TJm+TepGRJ9bJygvQUG3AicNVF63HijciAOGmnSRze3xC4PL0IEWVkTrqi00re+NM1mFGnrnhqVHW2BjjR5VvbkcvTeJdhdoq7c/HIh5RueYsN/SRaRUyq2U1DX0sB/5mTDrb3BaochD1RFnaElzxWHMipY7Vpouer5f+lG/enNKIlilArdVcrb/4pKFeFC+fcERXTEIzXz1XvJy23t2hXCObz1rpVSdi5xEgnotirOeZS+P8ABx/b3mul0NKLp8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DA.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2ae98c51-f2ce-48cc-7d1f-08deb7484da2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|35042699022|376014|36860700016|14060799003|56012099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	ex3w+cq0B7lSrWBw4hsXAVHrSSDH/2usmMfhe8yAG00jsR9FeWfl7DfUMkzgaAUc8GkGMD+GGUmDyaooO2/NsMZxdCcwr8XqphegsgLxgjvxWIpinzDV+jiCGVoyGgnxAFMMnVi+GYKM6GDZMJoqg51oxYP49S/X+9mc5fEkRWYMx9YPH1lI4JaOjlxPkxAS0KOl9vf5NROn2MmWBfRxSN2HpKllGQGJoSLuwEyyGj10ypFiaWVxJHxCgCEAiIg78AlbftJC/BUJvZOjT06KcWDyQe7Pl4l5jSHXru9GaMiXUg6OYzrmgvJc3GtVCzVMpnsLEdjMjz4lJgN45brOVrqLvIssU1iqoGqlnMDsoDZdWAbhNS+LQRutQZsG5z/4mSnK/ExnHAR/jr3T6n63R0iVtNK8vnjGoohz2J+SvcdHnxRqS6TCacsH43TMcxClzlHJnWJ4wXkobDLUkhYxBYOGItbzHmwP27UJK6CdOKPO9gkHVZunEEMAy5J51B85ilDAvLS9W8O7y/cmemEf4AcqYuFbjtbj3dhTj9uI25QSmwHKQcRkGHJpQheTpOSyt9tTOhrKQ+CaoFcbn9b8g8Jy//8BGhvjoQTOXegT7NiSZDPi7ypXg6WEcGqm1RLkS9n27mpRJap7apdENR2Y02BXvxyuoKjnFALKV52viLJYrIlgc2gxuC6qGLnsMRDvdQ7mIZ3v96jquRnBpgwPFt35LuNDtF5/JuinQP11sbo=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(35042699022)(376014)(36860700016)(14060799003)(56012099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	p5i5tK+C0tp/JLpJjzIIyop3I4lSIiGHF8zGET4AXqkw/ORwbMcBGOvL5AjIi1YefX24AjG8EhYP0Q5qjPQmtHDnbqp1x6+B+XJFQq5xW/lO0IdRe14k3Ws2cSA5gvaeoGKTHkbzvIuZEgbMfz8KHS3gNCCapcs05a8faa8w9Lfz7UGqNt8ik1DI74jAC5LnwYoSDNYuepqXt2mkKoh3s+NIn9H1nLSkRq1U+i9mTYjg32ukNz2n269p1EIgPH42cp3/HX+RpESlODRDwrztGHrbxK21jgNzahsmARoouexd/lKsPBYok0hdYulULEo8aVmb39uctiaYHDouf71byJ3eefmRUcDhiXryHv57Mgxwlx4XvSU0qhpUcV2UblVYgtBjrgqIkMJRaZyLeGSlWPYMnuJYDX2LxSST8zfooYbg3LJZXO0VpZHfqmTpKCWV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:51:32.9648
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd960487-2dbb-4946-1d98-08deb7487326
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DA.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5821

Complete the set of defined IRS MMIO registers in the GICv5 header
file. Up until now, the set of defined IRS MMIO registers has been
driven by code requirements. However, in order to properly emulate the
IRS MMIO interface in KVM, the full set of IRS MMIO registers needs to
be added.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/linux/irqchip/arm-gic-v5.h | 203 +++++++++++++++++++++++++++--
 1 file changed, 194 insertions(+), 9 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 681c5c51207d6..dd7da568ee8b8 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -62,20 +62,34 @@
 #define GICV5_OUTER_SHARE		0b10
 #define GICV5_INNER_SHARE		0b11
=20
+#define GICV5_AIDR_COMPONENT_IRS	0b00
+#define GICV5_AIDR_COMPONENT_ITS	0b01
+#define GICV5_AIDR_COMPONENT_IWB	0b10
+
+#define GICV5_AIDR_ARCH_MAJ_REV_V5	0
+#define GICV5_AIDR_ARCH_MIN_REV_V0	0
+
 /*
  * IRS registers and tables structures
  */
 #define GICV5_IRS_IDR0			0x0000
 #define GICV5_IRS_IDR1			0x0004
 #define GICV5_IRS_IDR2			0x0008
+#define GICV5_IRS_IDR3			0x000c
+#define GICV5_IRS_IDR4			0x0010
 #define GICV5_IRS_IDR5			0x0014
 #define GICV5_IRS_IDR6			0x0018
 #define GICV5_IRS_IDR7			0x001c
+#define GICV5_IRS_IIDR			0x0040
+#define GICV5_IRS_AIDR			0x0044
 #define GICV5_IRS_CR0			0x0080
 #define GICV5_IRS_CR1			0x0084
 #define GICV5_IRS_SYNCR			0x00c0
 #define GICV5_IRS_SYNC_STATUSR		0x00c4
+#define GICV5_IRS_SPI_VMR		0x0100
 #define GICV5_IRS_SPI_SELR		0x0108
+#define GICV5_IRS_SPI_DOMAINR		0x010c
+#define GICV5_IRS_SPI_RESAMPLER		0x0110
 #define GICV5_IRS_SPI_CFGR		0x0114
 #define GICV5_IRS_SPI_STATUSR		0x0118
 #define GICV5_IRS_PE_SELR		0x0140
@@ -85,11 +99,51 @@
 #define GICV5_IRS_IST_CFGR		0x0190
 #define GICV5_IRS_IST_STATUSR		0x0194
 #define GICV5_IRS_MAP_L2_ISTR		0x01c0
-
+#define GICV5_IRS_VMT_BASER		0x0200
+#define GICV5_IRS_VMT_CFGR		0x0210
+#define GICV5_IRS_VMT_STATUSR		0x0214
+#define GICV5_IRS_VPE_SELR		0x0240
+#define GICV5_IRS_VPE_DBR		0x0248
+#define GICV5_IRS_VPE_HPPIR		0x0250
+#define GICV5_IRS_VPE_CR0		0x0258
+#define GICV5_IRS_VPE_STATUSR		0x025c
+#define GICV5_IRS_VM_DBR		0x0280
+#define GICV5_IRS_VM_SELR		0x0288
+#define GICV5_IRS_VM_STATUSR		0x028c
+#define GICV5_IRS_VMAP_L2_VMTR		0x02c0
+#define GICV5_IRS_VMAP_VMR		0x02c8
+#define GICV5_IRS_VMAP_VISTR		0x02d0
+#define GICV5_IRS_VMAP_L2_VISTR		0x02d8
+#define GICV5_IRS_VMAP_VPER		0x02e0
+#define GICV5_IRS_SAVE_VMR		0x0300
+#define GICV5_IRS_SAVE_VM_STATUSR	0x0308
+#define GICV5_IRS_MEC_IDR		0x0340
+#define GICV5_IRS_MEC_MECID_R		0x0344
+#define GICV5_IRS_MPAM_IDR		0x0380
+#define GICV5_IRS_MPAM_PARTID_R		0x0384
+#define GICV5_IRS_SWERR_STATUSR		0x03c0
+#define GICV5_IRS_SWERR_SYNDROMER0	0x03c8
+#define GICV5_IRS_SWERR_SYNDROMER1	0x03d0
+
+#define GICV5_IRS_IDR0_IRSID		GENMASK(31, 16)
+#define GICV5_IRS_IDR0_SWE		BIT(12)
+#define GICV5_IRS_IDR0_MPAM		BIT(11)
+#define GICV5_IRS_IDR0_MEC		BIT(10)
+#define GICV5_IRS_IDR0_SETLPI		BIT(9)
+#define GICV5_IRS_IDR0_VIRT_ONE_N	BIT(8)
+#define GICV5_IRS_IDR0_ONE_N		BIT(7)
 #define GICV5_IRS_IDR0_VIRT		BIT(6)
+#define GICV5_IRS_IDR0_PA_RANGE		GENMASK(5, 2)
+#define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
+
+#define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
+#define GICV5_IRS_IDR0_INT_DOM_NON_SECURE	0b01
+#define GICV5_IRS_IDR0_INT_DOM_EL3		0b10
+#define GICV5_IRS_IDR0_INT_DOM_REALM		0b11
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
 #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
+#define GICV5_IRS_IDR1_PE_CNT		GENMASK(15, 0)
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS_1BITS	0b000
 #define GICV5_IRS_IDR1_PRIORITY_BITS_2BITS	0b001
@@ -105,13 +159,30 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
+#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+
+#define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
+#define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
+#define GICV5_IRS_IDR3_VMD_SZ		GENMASK(4, 1)
+#define GICV5_IRS_IDR3_VMD		BIT(0)
+
+#define GICV5_IRS_IDR4_VPE_ID_BITS	GENMASK(9, 6)
+#define GICV5_IRS_IDR4_VPED_SZ		GENMASK(5, 0)
+
 #define GICV5_IRS_IDR5_SPI_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR6_SPI_IRS_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR7_SPI_BASE		GENMASK(23, 0)
=20
-#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+#define GICV5_IRS_IIDR_PRODUCT_ID	GENMASK(31, 20)
+#define GICV5_IRS_IIDR_VARIANT		GENMASK(19, 16)
+#define GICV5_IRS_IIDR_REVISION		GENMASK(15, 12)
+#define GICV5_IRS_IIDR_IMPLEMENTER	GENMASK(11, 0)
+
+#define GICV5_IRS_AIDR_COMPONENT	GENMASK(11, 8)
+#define GICV5_IRS_AIDR_ARCHMAJORREV	GENMASK(7, 4)
+#define GICV5_IRS_AIDR_ARCHMINORREV	GENMASK(3, 0)
=20
 #define GICV5_IRS_CR0_IDLE		BIT(1)
 #define GICV5_IRS_CR0_IRSEN		BIT(0)
@@ -134,21 +205,39 @@
=20
 #define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
=20
-#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
-#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SPI_VMR_VIRT		BIT_ULL(63)
+#define GICV5_IRS_SPI_VMR_VM_ID		GENMASK_ULL(15, 0)
=20
 #define GICV5_IRS_SPI_SELR_ID		GENMASK(23, 0)
=20
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN	GENMASK(1, 0)
+
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_SECURE	0b00
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE	0b01
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_EL3	0b10
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_REALM	0b11
+
+#define GICV5_IRS_SPI_RESAMPLER_ID	GENMASK(23, 0)
+
 #define GICV5_IRS_SPI_CFGR_TM		BIT(0)
=20
+#define GICV5_IRS_SPI_CFGR_TM_EDGE	0b0
+#define GICV5_IRS_SPI_CFGR_TM_LEVEL	0b1
+
+#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
+#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+
 #define GICV5_IRS_PE_SELR_IAFFID	GENMASK(15, 0)
=20
+#define GICV5_IRS_PE_STATUSR_ONLINE	BIT(2)
 #define GICV5_IRS_PE_STATUSR_V		BIT(1)
 #define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_PE_CR0_DPS		BIT(0)
=20
-#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
+#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
=20
 #define GICV5_IRS_IST_CFGR_STRUCTURE	BIT(16)
 #define GICV5_IRS_IST_CFGR_ISTSZ	GENMASK(8, 7)
@@ -166,15 +255,111 @@
 #define GICV5_IRS_IST_CFGR_L2SZ_16K	0b01
 #define GICV5_IRS_IST_CFGR_L2SZ_64K	0b10
=20
-#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
-#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_MAP_L2_ISTR_ID	GENMASK(23, 0)
=20
+#define GICV5_IRS_VMT_BASER_ADDR	GENMASK_ULL(55, 3)
+#define GICV5_IRS_VMT_BASER_ADDR_SHIFT	3ULL
+#define GICV5_IRS_VMT_BASER_VALID	BIT_ULL(0)
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL	0b1
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_LINEAR	0b0
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE	BIT(16)
+#define GICV5_IRS_VMT_CFGR_VM_ID_BITS	GENMASK(4, 0)
+
+#define GICV5_IRS_VMT_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VPE_SELR_S		BIT_ULL(63)
+#define GICV5_IRS_VPE_SELR_VPE_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VPE_SELR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VPE_DBR_DBV		BIT_ULL(63)
+#define GICV5_IRS_VPE_DBR_REQ_DB	BIT_ULL(62)
+#define GICV5_IRS_VPE_DBR_DBPM		GENMASK_ULL(36, 32)
+#define GICV5_IRS_VPE_DBR_INTID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_HPPIR_HPPIV	BIT_ULL(32)
+#define GICV5_IRS_VPE_HPPIR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VPE_HPPIR_ID		GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_CR0_DPS		BIT(0)
+
+#define GICV5_IRS_VPE_STATUSR_V		BIT(1)
+#define GICV5_IRS_VPE_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VM_DBR_EN		BIT_ULL(63)
+#define GICV5_IRS_VM_DBR_VPE_ID		GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VM_SELR_VM_ID		GENMASK(15, 0)
+
+#define GICV5_IRS_VM_STATUSR_V		BIT(1)
+#define GICV5_IRS_VM_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VMAP_L2_VMTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VMTR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VMR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VMR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VMR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VISTR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VISTR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VISTR_TYPE	GENMASK_ULL(31, 29)
+
+#define GICV5_IRS_VMAP_L2_VISTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_L2_VISTR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VMAP_L2_VISTR_ID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VMAP_VPER_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VPER_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VPER_VPE_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_SAVE_VMR_VM_ID	GENMASK_ULL(15, 0)
+#define GICV5_IRS_SAVE_VMR_Q		BIT_ULL(62)
+#define GICV5_IRS_SAVE_VMR_S		BIT_ULL(63)
+
+#define GICV5_IRS_SAVE_VM_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SAVE_VM_STATUSR_Q	BIT(1)
+
+#define GICV5_IRS_MEC_IDR_MECIDSIZE	GENMASK(3, 0)
+
+#define GICV5_IRS_MEC_MECID_R_MECID	GENMASK(15, 0)
+
+#define GICV5_IRS_MPAM_IDR_HAS_MPAM_SP	BIT(24)
+#define GICV5_IRS_MPAM_IDR_PMG_MAX	GENMASK(23, 16)
+#define GICV5_IRS_MPAM_IDR_PARTID_MAX	GENMASK(15, 0)
+
+#define GICV5_IRS_MPAM_PARTID_R_IDLE	BIT(31)
+#define GICV5_IRS_MPAM_PARTID_R_MPAM_SP	GENMASK(25, 24)
+#define GICV5_IRS_MPAM_PARTID_R_PMG	GENMASK(23, 16)
+#define GICV5_IRS_MPAM_PARTID_R_PARTID	GENMASK(15, 0)
+
+#define GICV5_IRS_SWERR_STATUSR_IMP_EC	GENMASK_ULL(31, 24)
+#define GICV5_IRS_SWERR_STATUSR_EC	GENMASK_ULL(23, 16)
+#define GICV5_IRS_SWERR_STATUSR_OF	BIT_ULL(3)
+#define GICV5_IRS_SWERR_STATUSR_S1V	BIT_ULL(2)
+#define GICV5_IRS_SWERR_STATUSR_S0V	BIT_ULL(1)
+#define GICV5_IRS_SWERR_STATUSR_V	BIT_ULL(0)
+
+#define GICV5_IRS_SWERR_SYNDROMER0_VIRTUAL	BIT_ULL(63)
+#define GICV5_IRS_SWERR_SYNDROMER0_TYPE		GENMASK_ULL(62, 60)
+#define GICV5_IRS_SWERR_SYNDROMER0_ID		GENMASK_ULL(55, 32)
+#define GICV5_IRS_SWERR_SYNDROMER0_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_SWERR_SYNDROMER1_ADDR	GENMASK_ULL(55, 3)
+
 #define GICV5_ISTL1E_VALID		BIT_ULL(0)
+#define GICV5_IRS_ISTL1E_SIZE		8UL
=20
 #define GICV5_ISTL1E_L2_ADDR_MASK	GENMASK_ULL(55, 12)
=20
+#define GICV5_IRS_SETLPIR		0x0000
+#define GICV5_IRS_SETLPIR_ID		GENMASK(23, 0)
+
 /*
  * ITS registers and tables structures
  */
--=20
2.34.1
