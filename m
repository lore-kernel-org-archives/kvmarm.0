Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013041.outbound.protection.outlook.com [40.107.162.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB013EBF02
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522887; cv=fail; b=d0WSJ+2cdPEkI0DnB8kAYzPJDTPG0ZjY2WxYURv0GOqHhPvO3M4TxYjtuzJdNBQaLqP/mHh9BSf7SFqbrFqYxHwJqBd6jwdRObF0RcNyUBc4TP7xOp/gPPO9z6JSfIOgqZh6otdfOMgj6yDo1+D1q1hC1yarz6yky86pNXEGOWA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522887; c=relaxed/simple;
	bh=Q6cd4eBb2LZmDb5T8/kQ6NyIWXTmy/Lkd5OBy2iHVwo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I4f2wqRo7LxOm2gvBnN/sxAgT4U2x/Bsk6z3nVKMu2TBThoTN/hdaVMSgLkGwAg0pZC7Rh1YQInuYQd7sgAssP9VxFWsgIwabLnzjE2oeDyzYwmqhup24IKv+Hw4x51mvDBCPCfWMRaFTpcZKe68YlDBZvz1fsEk5sDyFd+zuJc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=P2ZmPPFy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=P2ZmPPFy; arc=fail smtp.client-ip=40.107.162.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="P2ZmPPFy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="P2ZmPPFy"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NG0XEWGd2AOHnGE9Se7MceHnoEv2uPTyxcYMciAn7ZXSiwsTnPq67VjBnYI/71MfmVUW9vj0KXhbn6JYc4MvTiAHEp6WMWCvsszixngDr5F4AdufhP5vb2gehpjj0H7wAoOlrJkotd0QIJwhVZZK36oYZAAN7kVxlMIKzDzEUTpm5p87He94Iq7uYR8fjTHBo/njbQ8q0nTVzPzah5entoJjJIa18XaTDfGb/f9fJ3uvvoOVRABDzWlxL5xOd6R/olMeGOwWaZTXQe/aJqWbolO95YsAQ4S8UnVHxuJSpkcNzuIJLvDdbNjfSORfW78llC5pMgSaMaN1tqFOcJ93wQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cp0ytMLoywlse2jdbqO0/+rLlOm2FlIJQWRZoFwgjZ0=;
 b=lX15spG0pY9wKwkRxVOrOnijhVTlpLn0HgL+NSzSGeZwz41fhNywQoAIKexqpAMfUSCQoSrvF058BNaW77+tOtgGcyPB61s3Vi/AU6RxefIKHIi0BViLB7+Vr14VcuDHQjH7OBJTIwkTPsI+OcCj64mFZqu5UTwAWBK9Kaan8PVW8RNmFwTvA/EQiR14fJ1a7z0zcIdXCCAqZmcrRZ4aJLHz6VgBmqalItkLUX1cxQw2kAfeVTdv1vSwrfZuIpLkEkf2ron+GQzJjjJ/y3treamIHf5Q/Hml1gHaxMz/CCEPUdd9bCA0csCMkIFInNa7cyVUgPQYuG1Os39ykeHm/Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cp0ytMLoywlse2jdbqO0/+rLlOm2FlIJQWRZoFwgjZ0=;
 b=P2ZmPPFyKpML5Jt6qkMlQ6gcnqzKnNJskmGsqSyviwmY7FnmFMRrEr3AhjJdINHTomil3ifOYnMuyPXcxdCmSZjh1o+rLJ+lEzdZiuPoMrQIHEjjkw/RCCC3MHkJmksETjJ6HQvtaKcjZRxg+/ppOJxEMYm48ASHRY5UERyXPjM=
Received: from DB8PR04CA0017.eurprd04.prod.outlook.com (2603:10a6:10:110::27)
 by DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:54:39 +0000
Received: from DB1PEPF000509E8.eurprd03.prod.outlook.com
 (2603:10a6:10:110:cafe::12) by DB8PR04CA0017.outlook.office365.com
 (2603:10a6:10:110::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:54:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E8.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Fri, 4 Sep 2026 11:54:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C4etg/ddIQMT1Q5LY3HmaxvPnWlQF58HmvCiVUPL6+wMHaThuOtezTkMPNb0hl01Mn5ZT0KBYr9sz//B1RZcHcWw51387XeUrb+wPv5/8ocwngtuhMc1emRejHAwx2bJWPE7NfwvxXQAEgSjV69EQlWdesqT0AOYqMdLjjrn48PAXqVIDUSUn8qrPswy02mF+CxVBQuNN5Nc/EKI5IiAII5Zpf4TONzBz112qrq8CzJGA3kO9QX1bcBryOfURxp0cvgajQbLtAi4T11kVgTGJq1i9375eLVUkuGfsEhzYBJ0hIws1pHVK/wpWxkSTDwqP718eHFHceZ6kr07BzYtjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cp0ytMLoywlse2jdbqO0/+rLlOm2FlIJQWRZoFwgjZ0=;
 b=rpUcwYTSF58vgvFQ+eAVV+OlpjtEgo5/xHno29HCNGSiIf2QTGvaFXp8zWvmbSnZH7vuXt1MkuptTAGKKV9CLjdY3OiEG6OG1Apv819U0rDQQAsD3TOpjAPcfRPWPfQZWRe+/GHUdOpcq21VASiieBpEBrA95Xf1guJboqqCvi/5WvjJg/GIcS/qn3z6jllCj4lOz4SCkiWp5wBjmWy1aHZ119SXykWdddTM31i7O/zgjOl7VSwZefyHZlZxvMtG5Yy0c7RV3pFgGR0ZtDWBqdDVRmij1ivKUoNNPEI0+A3xrgKg+BUt/hf3xKUxi4GXKP+oyBz4mMkN7JzAqCVMXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cp0ytMLoywlse2jdbqO0/+rLlOm2FlIJQWRZoFwgjZ0=;
 b=P2ZmPPFyKpML5Jt6qkMlQ6gcnqzKnNJskmGsqSyviwmY7FnmFMRrEr3AhjJdINHTomil3ifOYnMuyPXcxdCmSZjh1o+rLJ+lEzdZiuPoMrQIHEjjkw/RCCC3MHkJmksETjJ6HQvtaKcjZRxg+/ppOJxEMYm48ASHRY5UERyXPjM=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS2PR08MB10207.eurprd08.prod.outlook.com (2603:10a6:20b:647::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:54:05 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:54:05 +0000
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
Subject: [PATCH v6 39/49] Documentation: KVM: Add the VGICv5 IRS save/restore
 sequences
Thread-Topic: [PATCH v6 39/49] Documentation: KVM: Add the VGICv5 IRS
 save/restore sequences
Thread-Index: AQHdPGQVtmTiREyG9EeahDvGNrDP/Q==
Date: Fri, 4 Sep 2026 11:54:05 +0000
Message-ID: <20260904113404.4051341-40-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS2PR08MB10207:EE_|DB1PEPF000509E8:EE_|DU4PR08MB11769:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c643b3c-8e94-431b-bc1a-08df0a7b4c8f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|22082099003|11063799006|56012099006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 /b2bJYPaU8UDID7NSY6/1nC44Owgs9KYvX+zpeh/6bmHrN6XGcl7+z7S5TstwbElJiHIJJ5KjNT69Ls9k8ZQs276tBN+wufk5kuH7cFpaRLSOPAG0sh8vxme9Pj1je2+lt3XZUd7xl96mqe+HFklCIZOrqq+6c5UohuIzqanyfDF2EAOSjLI12f5wP41QeBl2ceOgej46v3NcMbogea4rSokG7oqFgyCaE6dOmR7rMCSYLB/OVCc+zFrMZcwj7SsiBV0H4Wpi8wspNLOXTt5lpFwpSIq0EbeAQA7mcfurHZyHsCcI9421Ap3nUb9g9Wfl/ePZW1GLk2tOIXUeIWZYu4mIhozjyYal6xW32rA44NvYawCxA3NXq3cj3GTYBw89ZFD4jmDHoybtvyNRkuSGDWoCFg13S0COJ7IUhZq6uKmpZ93ExFJgwfphk9CPX/HOeuDs6v1IoO1/22QUl+t9zvcWk+prTZN0TE4/ttBCmmV5QdXyhDRicNPVDyxGJT76X4hs0SmkoS2mfgRQHybDlbq9JjcoTlykeqOrwRpLwz0ZzXicSLOrG1u7Odrkx2zUfPoPixcHIIDfpn8oJWaL7zjSnf6ZWgnuUOkCAxtu/4uaIsd2OsdPqxoU+t+ySInwH3EY/lJlJ+9uLFQlZTgoYX5Y1JwxcU/yFSMiPeRilz73H7iS6cnDxgHnOxenlo+/m6m5LyB5fM6VQC8y2ZvMTUbcpoqK5DnbtqiTfCaVKU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(22082099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 aizNQphSP640ntMR9Kifr20Kw1RFbG2tFKzks4g+eUl5lColm/b+/4SK+982wHD55wm3y3NNk2xpQ5U9wWa4+9xvj6n0O4Ae2Ax7cTN3yFtCzzjyPZBFnuZ+S5oXRR7sKaI8f8XV9X2NKx8w8xMIu9PGPQXSw4Wzl0+6q25/P1JMN4qkrhvMUHtDZEph2nbq0W0Pez6ybaSdhfoKhzKplycT/tcoxaCSVx1XFADmt1md4hd4fJX+qCmy3B3/lOPqoP5vJxmby1q2I6WenmNmeNGC518armYSMIZBu1KdNB4KbQ63pAtzWx3CuGGvZvVUjEt7urth9A+goPGddJrOag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10207
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dfa3c1a3-d69c-471e-dbe3-08df0a7b3877
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|35042699022|23010399003|82310400026|36860700016|376014|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JmjatvQ6BHlTju5RB5HhCU6C6YyEYlFMfmHKA5cFRy/esZTzvmHt/F2UivZXWxm+nqkC6QY/g8bLfxd2iJgM6+pLnPM6ksRuvY1lxb5sWFEgeA87UZN92xTJaGWTn/lhNv5pDqMvktba5HF+YW+C5w5asVgPMrMG5TBunb8InwK+xqBSpfDouDSBNDxMrmf4AHk7JOYWv02cbFffVOJotN6jM1R3nyCiM4Zb/RtYBiXxQdMYhLVNly+8pMJkxKD8BDEX+XimZZGznQGoFWMjnhdR+2wiCHuJxPbZc6Hw8jtSfVxhXGws/vmwgcyVEVF4SwSaSErdZJcPZFpDiAhU37xB4C2bOaEEi5q38avhiOb7kHmt5rM+LVWptKwnTsowf4CVunp2U8fKszZjQW/XHqzfXAgnHqmfxjhH82L9kCjXei7PRhycgfbLMCRP5bgem4cVciwockyI2DNfo9UUhzSnlBvAUJT2yOoc3+kEcKCvKWcKgqVs0FjJZjpjcnVaH4ztPwy7rJK5O+tme0WAOGg1+nHVSp0fZFmo7XCb6/6BDGDJw2cenaTvNHSpr8THW33kFNR+DrFkJN1q7kWVBE07OvJqlMp67N5stK1V60Ismx5KLfx5xqZvNZen3HTLYie6HjQra38IYqzIFedB/pY4nWd4k4V5yC+dl+gaju4=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(35042699022)(23010399003)(82310400026)(36860700016)(376014)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hugqQKMQ/Tq6v9onomgpZ2TVPRm3IBAxzS9Gt9TCwa5VbavNr3iRsV/bDXIUHalIMOBVYWpcBFJjm3IGmDS5+XvJXlppGqTspKwge45L6h7BC+/UuMfjl/8RYDfwf20grG8/Oi4BnQUkZOtWjSUKZ4M+qLzgj//QQJkyLn2eTgHTnpmI/ucMwRopsmCr7DabLoKDFeXp7pV6NmptQPpvUJp9nmc9yk8RJhpWkF/Hg2EsYs34FfNXFWQD2eBB/2S2y38KnSb2GLDyDaQfObv9mvV3i66M/XQBKGKYdUNVfaTW9DDJkK76xUTQxbd/3TePNACm4sHhy68Bc56g4MDeRbbrDRKJ70JW8qE1PMOFfw5w/iBLMbAetQstYRcK/iXa+q5cgHDArlyRf9Erz+yydi3SUf00Ag9jvm5HGq7M6+h3UAnQPrSTfI0fyx/Larqf
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:54:39.0608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c643b3c-8e94-431b-bc1a-08df0a7b4c8f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11769

Document the ordering requirements for saving and restoring the GICv5
IRS state.

The IST state is exposed through KVM_DEV_ARM_VGIC_GRP_IST and is
copied to or from userspace-provided buffers. Saving the ISTs
therefore does not update guest memory, so userspace does not need to
serialize guest memory after saving the IST state.

On restore, userspace must create the vCPUs, configure the IRS
address, restore the number of SPIs, and initialize the VGIC before
restoring IRS state. The IRS MMIO registers may be restored in any
order, but the final IRS_IDR* state and the IRS_IST_CFGR/IRS_IST_BASER
state that describes any LPI IST must be restored before
KVM_DEV_ARM_VGIC_GRP_IST.  KVM uses that state to validate the
userspace IST buffers and allocate any host LPI IST.

The IRS_*_STATUSR registers are observational state in KVM. Userspace
may save them for validation or debugging, but they are not required
as restore input and do not need to be replayed.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 61db2f93373cb..8a691c8938b62 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -262,3 +262,52 @@ Groups:
                    or tracking pending interrupts
       -ETIMEDOUT   An IRS save/VM operation timed out
       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+IRS Save Sequence:
+------------------
+
+The following operations are required when saving the virtual GICv5 IRS:
+
+a) Save the ISTs by issuing KVM_GET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IS=
T.
+b) Save the IRS MMIO register state by issuing KVM_GET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IRS_REGS.
+
+These two steps may be performed in either order. Saving the ISTs writes a=
ll
+IST state to userspace-provided buffers and does not update guest memory.
+
+IRS Restore Sequence:
+---------------------
+
+The following ordering must be followed when restoring the virtual GICv5 a=
nd
+IRS:
+
+a) Create vCPUs.
+b) Provide the IRS base address by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_ADDR
+c) Restore the number of SPIs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
+d) Initialise the GIC - this sets up the default state and creates the SPI
+   IST - by issuing KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_CTRL with
+   KVM_DEV_ARM_VGIC_CTRL_INIT
+e) Restore the IRS MMIO register state by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IRS_REGS. The IRS registers may be restored in any
+   order, but any IRS_IDR* state and the IRS_IST_CFGR/IRS_IST_BASER state
+   describing an LPI IST must be restored before restoring the ISTs. KVM u=
ses
+   the restored IRS_IST_CFGR and IRS_IST_BASER state to allocate the LPI I=
ST
+   during the following step.
+f) Restore the ISTs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IST.
+
+The number of SPIs must be restored before VGIC initialization because
+initialization allocates the SPI state and fixes the SPI range exposed by =
the
+IRS ID registers.
+
+The IRS's MMIO registers must be restored prior to restoring the ISTs as t=
hese
+are used to convey the number of LPIs the guest has configured to KVM.
+
+The various ``*_STATUSR`` registers are observational state in the current=
 KVM
+implementation. Userspace may save them for validation or debugging purpos=
es,
+but they are not required as restore input and do not need to be replayed =
during
+restore.
+
+Then vCPUs can be started.
--=20
2.34.1
