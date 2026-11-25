Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.70.34
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795590596;
	b=Zz2Mywo1o8V1NhUrYzgUK4RPTLqioWfOjQgxFu1BbayMdMHfW4JnsQ4Jjqqd6V2cCoyS
	 VRC3IM+5dW/zkUeYKtzaKwghxsq8bK2MFjyi7FMO0G5Z9VUWTfR/vhUyKlKs+jiYKBYV8
	 FyaIeuO4k2yLnslNTNkvbM6sDoZWjvucejLp/N2FzKDDjaw7newqKYK56jpsbQn6OGkL5
	 OnASZP54Z8deFtoLtMdhRkyExcN+fmcaOZdh1ki+ctA7nX2rFO258m9yIltl0Qyv0qLZV
	 Bpu+EmtUM3kYOd3z8r4ISpxNaWxE66VhTFTh6iokEQ1mfJfT+xz6kJAQvdQlw4V07mw==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590596;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 Authentication-Results-Original:x-ms-traffictypediagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:x-checkrecipientrouted:
	 nodisclaimer:X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam-Untrusted:
	 X-Microsoft-Antispam-Message-Info-Original:
	 X-Forefront-Antispam-Report-Untrusted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-EOPAttributedMessage:
	 X-MS-Exchange-Transport-CrossTenantHeadersStripped:
	 X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id-Prvs:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=50GDC4FSy9XlsClsNLd9sLurs0KR5rks/5mg1y9v3/g=;
	b=fGKqb6sNhr7yaz8+CSZ+HBvxb9tw/2Ydu6qvTnALPNg/OPIRNMQLwK02FYdbEkKhvbpK
	 ftv8+fKuIKjIxKa0hdYa5yXUOEexyFF6Is0CWw8cXdIcxPqRlNMCZ8P7Cqb4FAqg0Zn0I
	 YWyTTfTJ1kqULqJLDDxuLenXW6oZwJcuNwrjMZLPOTEwrkxOWpR+oCyuE0qYQLWwnBjTG
	 pQZcWrHGsWWZeoFix7rzCgLKW9P/1mwxiV6FznJmIjVd8mb/A75JcXD5ExOFvMkTJNgfx
	 rQAyxRSWXsJfDeRYEJxhQ3PKUqKmzCyjxmjXTqNXebqandEbXIVhAlic6AmLNvzMvcg==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Z94WmbQn;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Z94WmbQn;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.70.34
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011034.outbound.protection.outlook.com [52.101.70.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFD0606A685;
	Wed, 25 Nov 2026 07:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFFD0606A685
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Z94WmbQn;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Z94WmbQn
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ld8rlKgPI9BRh/9ICEA0vxklwjlgz6XkRXMhCZ6zsYYlrk/AoDgNjQ+kFWXkDTj0V60877tEoxI56csC2g2XnaX2quajSbQZGEZT0ZQ1Wc3sTLb+YNGNfduuc4UzTlb7XI8mas1f/x0gIvyVZK2OWs5cjOSZHokawEc/vfERZJWc6G07crQVcPdCD420AdZNVo3LYW3jDYNG/GMWZoGYWQqzHBwLSuHvaV+DTRHXxuO2KPV7LbGZrxDrIy+VIUvLOLUXdSK+LhFSslJ1qyryydAYG9pYQW6fMFzohgDDTXdWbf0zXz5Cxb0xp6clL38LIU6R/LrrBtBgQuLPOP8rSw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50GDC4FSy9XlsClsNLd9sLurs0KR5rks/5mg1y9v3/g=;
 b=MNxNPMeKxQi6+qw5r70U+CJcrwhcMVnzzv3sZp4AbdI9MIEvCbfNN0ybZ2GgAwNMkIImYNbtdWjqtSxEiACJCv7K/qN4MsxDdR+gfH2Qr6dgHaJMS0EhFhyQULIigqonHGIQNa3J89Eg9QFElRa66tRM6DN6MMAOKiAtIsjr2k6YhY5//+Jfm1PVLd8Wob+e6kpWRDJ7giGbJjlPnV4RGjuIglBvzMn12EqZE+KREkWx6z3JtVFIwuFeqxrIG2rjbUgttAOV5byfgp94t8EZyjDCuL/YnMl6wrSkTyPYYvmPBnBZJBZ93haVNK4xeci6d/IieExOEByirxErlY0qWw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50GDC4FSy9XlsClsNLd9sLurs0KR5rks/5mg1y9v3/g=;
 b=Z94WmbQnyhIxD6savG0BoBBOHDaCyCbDD91U7VcjLziW8+tljLegxrJzFx97cWbrDo2ZSIK2vi+j223gtVfRBL3p7MSoAik62hgAnY1JwolBzmK7+D7o2HfsK3gPOU2GdTb1I5BrZoLvo3zlm28xWot0T4mMsfAsb5vfj5+7RMo=
Received: from AS4P195CA0052.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:65a::12)
 by AM6PPF8AD022ABC.eurprd08.prod.outlook.com (2603:10a6:20f:fff1::b0e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.5; Wed, 25 Nov
 2026 07:09:45 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:20b:65a:cafe::42) by AS4P195CA0052.outlook.office365.com
 (2603:10a6:20b:65a::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Wed, 25
 Nov 2026 07:09:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.5
 via Frontend Transport; Wed, 25 Nov 2026 07:09:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BoPORB0Jy9PHrOV/EMzXyX+ppFov4xMYTViyhhDx80Ql6/aOKAXxYzJ+BCG2xrfTMeyP10CRI0ysA70SU7MLMa1qKFQiiBhC+gewoOZRF67ICQFwE6L5+YKyw511HIdvOGRMD8mSPWB/EVIoSZ2Wi14HDv1s6OnzJm07+o5VDBFSHoGr3qGvwTNKhkBv/zZwgPTwSYbkZEPq9kXO9VbbkYodIuOk7pBUpo2bSi69rHBeaw7s2iG/wKNWda+FYXI1JZoKSlTr+aKANjYbiclMu2+0iZcitUoZ7zLMSU8lS4Yp205pylMG6H3FGnOVZhev5TihL50cvyZgffYGCR4dQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50GDC4FSy9XlsClsNLd9sLurs0KR5rks/5mg1y9v3/g=;
 b=GX1+7a1jEg3kInXUTAxwAMDQNmUWmAGuPBHZZiTiBxq1XjlR+loBhTEpruYWQ9fQXV7sc3yk/crhLoaSOGtiSlobHFtsR+gmTf4/L2+ove4QFFl+oe1MwIQXYXWQ1AIuYP7IsqJrG3RMGFN4mdGr97GDvvar+xU8XcGuFzy3HoqDGXcREp3jIdLwGx2Ac2Sh00x2HNV975PKmVxxiZ/mMWiwVx5MDwh84cwHDAtEk8oM203sVlFsHIvaqfEmk5RqPegGfcnQOUyl4WXV4drieA/CZjKjh9dRwmRrTIHNY34bhR0+1GtZ3iFe3/4cyKPmoP0a77IyBrCHEuN+s0HgKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50GDC4FSy9XlsClsNLd9sLurs0KR5rks/5mg1y9v3/g=;
 b=Z94WmbQnyhIxD6savG0BoBBOHDaCyCbDD91U7VcjLziW8+tljLegxrJzFx97cWbrDo2ZSIK2vi+j223gtVfRBL3p7MSoAik62hgAnY1JwolBzmK7+D7o2HfsK3gPOU2GdTb1I5BrZoLvo3zlm28xWot0T4mMsfAsb5vfj5+7RMo=
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com (2603:10a6:20b:605::22)
 by PA6PR08MB10471.eurprd08.prod.outlook.com (2603:10a6:102:3d0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 07:09:09 +0000
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155]) by AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155%6]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 07:09:07 +0000
From: Justin He <Justin.He@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Oliver Upton <oupton@kernel.org>, Marc Zyngier
	<maz@kernel.org>
Subject: RE: [PATCH v2 2/3] KVM: arm64: selftests: Add a test for VNCR_EL2
 translation faults
Thread-Topic: [PATCH v2 2/3] KVM: arm64: selftests: Add a test for VNCR_EL2
 translation faults
Thread-Index: AQHdfIb6swgtKAJLfU6t9NO6eNiTDbc+Gc8AgABERFA=
Date: Wed, 25 Nov 2026 07:09:07 +0000
Message-ID:
 <AS2PR08MB9786DD4C272B3E371B3FCD78F7432@AS2PR08MB9786.eurprd08.prod.outlook.com>
References: <20261125024426.3464050-1-justin.he@arm.com>
 <20261125024426.3464050-3-justin.he@arm.com>
 <sashiko-outbox-232440@kernel.org>
In-Reply-To: <sashiko-outbox-232440@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS2PR08MB9786:EE_|PA6PR08MB10471:EE_|DB1PEPF000509ED:EE_|AM6PPF8AD022ABC:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a2ed9ce-a4d8-4199-f058-08df4ac3154e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|6133799003|18002099003|22082099003|56012099006|4143699003|261102123227099003|11063799006|261028144727099003|261022075727099003|261026140227099003|261021135927099003|261026135527099003|261021121427099003|261026121527099003|261021130227099003|261021133027099003|261022113327099003|261026130827099003|261022105027099003|261022115727099003|261009223027099003|261021123027099003|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 C4ltINluTeU54Sz5w1flikEOfV5HKtuu+sAb7PQ0SB3omvLD4F2Y/QhEASplKfn1BIRLaaX38VHnpx9CdyGTlL3Ynhje6gEOWAl1nxiGOr31H5f4RevW8alCNIapAHZ0QMcKa+RnB9QsEw2r7ojyAsM6FAu81FQH2tclTTl9dfG4ZqgIjKjajVvG77L35ktIkNJgPl13mMZTyR6EI9sXh8AN9kkSgpJxJaGG/F5twrbmNN4kBOLFvn9fDn/4+n47Lskq4VF9NS6dc81Sv1UIf6oZi4OHLCfsjZCjn+3jEXxAZ4bEQEnpY12yImReCDCIGCYqNP/FeqQXhENjho/cI0+hscxX/gN/ix4aNzQRZB8YAatiFz6GVCqrscct7YfLfHm3TzxyPRE04AxoxTPGN84GVtkphwn4+SaW2BlGXqxzFPQqwMS+ri8JElzxVmA4tBn7B9iAHpK+XZxuzQ6n3Cem1MHwaUxRCmkxx9Io7YfoZt4O86itVd5euO3ILq2H/gd2OtYY41WH5Xiczn8oUH3ClbfuP+MJeZDjsHcX/uZ91UiwDIyhw93QYyW2pJAdjYtkp9Xee0h7/erb8gmEt8JvqsJhQt+xRmgamd/NYNMTU8m/zK3X+RWQn9D6+Eak83UP5FiHLs5yJp+d40M3rQ3muTik4ED09718Wf0q0hrJiAMkFtg55YvJv9bhTtuQSllMPjZRqe23rP4rbv2T5Uqf44akSi7e3/RQHJCzq54=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003)(261102123227099003)(11063799006)(261028144727099003)(261022075727099003)(261026140227099003)(261021135927099003)(261026135527099003)(261021121427099003)(261026121527099003)(261021130227099003)(261021133027099003)(261022113327099003)(261026130827099003)(261022105027099003)(261022115727099003)(261009223027099003)(261021123027099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 N0gzbkjLE9O7byXZZ7jXd7OUJj1aneGB2Bsf/ZBe246MSiSlaHR81cD0YALQtLOZP+Wc3WPiufK1sfd4hG81mY/o4FuOb53ukTF3e97fG3dJUd4/td6G24uhRvE1xOXMec3IYaTq2zZroPzbeQRBxvOV6X8vqI87V19GeHAd2smmWArXFB2rAA5B9PRByevf4SOithVOp6QkDymMdwvWGiUod1nPIOBEzekgqViWKmV92xMwWe+8miSBKj2ZDc/4WGJxEvpsuCDtbZrkypFRd12tkAkPtPwCVp7JB4BIO/xjf/LmVvRlO8W7oWTwYC0xADLrPQAGx7m2A+09UtgAvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10471
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	43460d97-19cb-4d9b-f0b4-08df4ac2ff3b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|35042699022|14060799003|6133799003|261009223027099003|18002099003|22082099003|56012099006|4143699003|11063799006|261028144727099003|261102123227099003|261026140227099003|261021133027099003|261026121527099003|261026135527099003|261026130827099003|261021135927099003|261021123027099003|261022115727099003|261021130227099003|261022075727099003|261021121427099003|261022113327099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	KRcHxgTtFZ+VLJBqj61U8WnVC+pB3oOZ88rwxpws2G/HA+pwWlinPq+R6fcGZZzACOeVJzh8QyiI2UAcEVKYGr47d/j+gffM1j5g+dL8z87iHr5NBQOW+nqD69A28NRbOnUiSs3ZysgYwhxKJdPwbLuVsWpudV9m+ErPKvrPDKnpoeGniVJ70y93Vdq2LP61dcy8Y3en554JH0ZhBhZtlU9En5kq93LREvKii2YrHOGYXhqAzcQBbmiWfmN3UBGK0JIktpDesaSbyUsIeB/E3dsAkW7BxUhU7sje2tpx2iMUWdnN3/6WISAEyXtbkers3FWeWzRsw+eBpM4bP/MphdbisDGcV/IvKUFnJrnViyChYLsGfLPrM1MSZHsrg4sZIl69rF16p5k7m87P59uoC9Qs8HvXqs8Yal0IhPskQ0p3PsOyQCf5bh0pERFLOqt+VVaeJfYhjyR/LTKABTDPooKGY6fjpwGXJ1GHnlvDIjO+ecTJpH1zNRJ9g93msfRyNNDXx91Q6JYvlaDOkkjPfPkisPTpQAc6fMXweco2nXHbkoN0R1rdbJ58QDHVyT1aNxVl91LADhll1kpwkpQhi/nyo2220+czIhnYKWJ/8rckfDBubbuGu8glNtax93YU80DwpefQu17nSZZ0sDfub+QTmaq0jCzEt8cE+pTiD9PDXro3pSjT2nYuMsrWcWvGAko/evOSspUKlER1kwwn8A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(35042699022)(14060799003)(6133799003)(261009223027099003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(261028144727099003)(261102123227099003)(261026140227099003)(261021133027099003)(261026121527099003)(261026135527099003)(261026130827099003)(261021135927099003)(261021123027099003)(261022115727099003)(261021130227099003)(261022075727099003)(261021121427099003)(261022113327099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8mACVI0EcC0M5GcLvdceqtuu72JAObstu2vB5DpJKdgskYxX7e7AK3ZRgRjOcWyuH6EoqKwmSBDQSiPNNNVAFkx8f+/35wnXA7zEjuqhvv4p0gboE7k5xnou0/e5I3FA+WRoEmyRzM3TKgQooA+W2wLocBtZfrCbEl7EQYO5ijGIJOgOHsNDfF8+RaHcqM1N3NT/DeSD2cM0QDPolk0RpUtaXMzXESQ2oNBCWG8BawK189sNzf0/z/8xEYULU/0n4PMIs2BG2UAnG7nSVO8EGDX1hzZbYs9UiaDiIIrfMfrw05ipoLVLcRLR6yi24GZK6+8FeAmUsrVbbf5LBGBSa3KUi3Ulbd7Mxn/YVU+/PTY5zFRyt719HFd9RKCUTvToU9goITINg3sNkM/qUjlAfrwSXw5boxw+M/V6/MbTswh/KxOfd7Q4o5WiUdPsp9vo
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 07:09:44.5349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2ed9ce-a4d8-4199-f058-08df4ac3154e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PPF8AD022ABC

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogc2FzaGlrby1ib3RAa2Vy
bmVsLm9yZyA8c2FzaGlrby1ib3RAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBOb3Zl
bWJlciAyNSwgMjAyNiAxMTowMyBBTQ0KPiBUbzogSnVzdGluIEhlIDxKdXN0aW4uSGVAYXJtLmNv
bT4NCj4gQ2M6IGt2bWFybUBsaXN0cy5saW51eC5kZXY7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IE9s
aXZlciBVcHRvbg0KPiA8b3VwdG9uQGtlcm5lbC5vcmc+OyBNYXJjIFp5bmdpZXIgPG1hekBrZXJu
ZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDIvM10gS1ZNOiBhcm02NDogc2VsZnRl
c3RzOiBBZGQgYSB0ZXN0IGZvciBWTkNSX0VMMg0KPiB0cmFuc2xhdGlvbiBmYXVsdHMNCj4NCj4g
VGhhbmsgeW91IGZvciB5b3VyIGNvbnRyaWJ1dGlvbiEgU2FzaGlrbyBBSSByZXZpZXcgZm91bmQg
MSBwb3RlbnRpYWwNCj4gaXNzdWUgdG8gY29uc2lkZXI6DQo+IC0gW01lZGl1bV0gS1ZNOiBhcm02
NDogc2VsZnRlc3RzOiBudl92bmNyX2Fib3J0IGZhaWxzIG9uIDE2SyBhbmQgNjRLDQo+ICAgaG9z
dCBwYWdlIHNpemVzDQo+IC0tDQo+DQo+IGNvbW1pdCA3NzExNzNmMDQ4YmZiZmY0ZDFhZmRlOWJj
NmQ5Mzc0ZDQ4MzAyYWYxDQo+IEF1dGhvcjogSmlhIEhlIDxqdXN0aW4uaGVAYXJtLmNvbT4NCj4N
Cj4gS1ZNOiBhcm02NDogc2VsZnRlc3RzOiBBZGQgYSB0ZXN0IGZvciBWTkNSX0VMMiB0cmFuc2xh
dGlvbiBmYXVsdHMNCj4NCj4gVGhpcyBjb21taXQgYWRkcyBhbiBhcm02NCBLVk0gc2VsZnRlc3Qg
Zm9yIFZOQ1JfRUwyIHN0YWdlLTEgdHJhbnNsYXRpb24NCj4gZmF1bHRzIGFuZCBoYXJkd2FyZSBh
Y2Nlc3MgZmxhZyB1cGRhdGVzIHdoZW4gdGhlIGxhc3QtbGV2ZWwgcGFnZSB0YWJsZSBpcyBpbg0K
PiBhIHJlYWQtb25seSBvciB3cml0YWJsZSBtZW1zbG90Lg0KPg0KPiA+IGRpZmYgLS1naXQgYS90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYXJtNjQvbnZfdm5jcl9hYm9ydC5jDQo+IGIvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L252X3ZuY3JfYWJvcnQuYw0KPiA+IG5ldyBm
aWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwMC4uZDIwNTJiMTUyNjExMQ0K
PiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0v
YXJtNjQvbnZfdm5jcl9hYm9ydC5jDQo+IFsgLi4uIF0NCj4gPiArc3RhdGljIHZvaWQgc2V0dXBf
dm5jcl9wYWdlKHN0cnVjdCBrdm1fdm0gKnZtLCBlbnVtIHRlc3RfbW9kZSBtb2RlKQ0KPiA+ICt7
DQo+ID4gKyAgIHU2NCBvYV9tYXNrID0gR0VOTUFTS19VTEwoNDcsIDEyKTsNCj4gPiArICAgZ3Bh
X3QgZGF0YV9ncGEsIHRhYmxlX2dwYTsNCj4gPiArICAgdTY0ICpsMmUsICp0YWJsZTsNCj4gPiAr
ICAgaW50IGlkeCA9IChWTkNSX1ZBID4+IDEyKSAmIDUxMTsNCj4gPiArDQo+ID4gKyAgIGRhdGFf
Z3BhID0gdm1fcGh5X3BhZ2VfYWxsb2Modm0sIE1FTV9SRUdJT05fREFUQSk7DQo+ID4gKyAgIHZp
cnRfcGdfbWFwKHZtLCBWTkNSX1ZBLCBkYXRhX2dwYSk7DQo+ID4gKyAgICoodTY0ICopKGFkZHJf
Z3BhMmh2YSh2bSwgZGF0YV9ncGEpICsgVk5DUl9WVFRCUl9FTDIpID0NCj4gVk5DUl9NQUdJQzsN
Cj4gPiArDQo+ID4gKyAgIGwyZSA9IHZpcnRfZ2V0X3B0ZV9odmFfYXRfbGV2ZWwodm0sIFZOQ1Jf
VkEsIDIpOw0KPiA+ICsgICBURVNUX0FTU0VSVCgoKmwyZSAmIDMpID09IDMsICJsZXZlbCAyIGVu
dHJ5IGlzIG5vdCBhIHRhYmxlOiAlbHgiLCAqbDJlKTsNCj4gPiArICAgdGFibGVfZ3BhID0gKmwy
ZSAmIG9hX21hc2s7DQo+ID4gKyAgIHRhYmxlID0gYWRkcl9ncGEyaHZhKHZtLCB0YWJsZV9ncGEp
Ow0KPiA+ICsNCj4gPiArICAgaWYgKG1vZGUgPT0gUldfUFRfQUZfQ0xFQVIpIHsNCj4gPiArICAg
ICAgICAgICB0YWJsZVtpZHhdICY9IH5QVEVfQUY7DQo+ID4gKyAgICAgICAgICAgcmV0dXJuOw0K
PiA+ICsgICB9DQo+ID4gKw0KPiA+ICsgICB2bV91c2Vyc3BhY2VfbWVtX3JlZ2lvbl9hZGQodm0s
IFZNX01FTV9TUkNfQU5PTllNT1VTLA0KPiBST19QVF9HUEEsDQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBST19QVF9TTE9ULCAxLCBLVk1fTUVNX1JFQURPTkxZKTsNCj4gPiAr
ICAgbWVtY3B5KGFkZHJfZ3BhMmh2YSh2bSwgUk9fUFRfR1BBKSwgdGFibGUsIHZtLT5wYWdlX3Np
emUpOw0KPiA+ICsgICBpZiAobW9kZSA9PSBST19QVF9BRl9DTEVBUikNCj4gPiArICAgICAgICAg
ICAoKHU2NCAqKWFkZHJfZ3BhMmh2YSh2bSwgUk9fUFRfR1BBKSlbaWR4XSAmPSB+UFRFX0FGOw0K
PiA+ICsNCj4gPiArICAgKmwyZSA9ICgqbDJlICYgfm9hX21hc2spIHwgUk9fUFRfR1BBOw0KPiA+
ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBzaWdhbHJtX2hhbmRsZXIoaW50IHNpZykNCj4g
PiArew0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBydW5fdGVzdChlbnVtIHRlc3Rf
bW9kZSBtb2RlKQ0KPiA+ICt7DQo+ID4gKyAgIHN0cnVjdCBrdm1fdmNwdV9pbml0IGluaXQ7DQo+
ID4gKyAgIHN0cnVjdCBrdm1fdmNwdSAqdmNwdTsNCj4gPiArICAgc3RydWN0IGt2bV92bSAqdm07
DQo+ID4gKyAgIHN0cnVjdCB1Y2FsbCB1YzsNCj4gPiArICAgdTY0IG1tZnIxOw0KPiA+ICsgICBp
bnQgcmV0Ow0KPiA+ICsNCj4gPiArICAgdm0gPSB2bV9jcmVhdGUoMSk7DQo+ID4gKyAgIGt2bV9n
ZXRfZGVmYXVsdF92Y3B1X3RhcmdldCh2bSwgJmluaXQpOw0KPiA+ICsgICBpbml0LmZlYXR1cmVz
WzBdIHw9IEJJVChLVk1fQVJNX1ZDUFVfSEFTX0VMMik7DQo+ID4gKyAgIHZjcHUgPSBhYXJjaDY0
X3ZjcHVfYWRkKHZtLCAwLCAmaW5pdCwgZ3Vlc3RfY29kZSk7DQo+ID4gKyAgIGt2bV9hcmNoX3Zt
X2ZpbmFsaXplX3ZjcHVzKHZtKTsNCj4gPiArDQo+ID4gKyAgIG1tZnIxID0gdmNwdV9nZXRfcmVn
KHZjcHUsDQo+IEtWTV9BUk02NF9TWVNfUkVHKFNZU19JRF9BQTY0TU1GUjFfRUwxKSk7DQo+ID4g
KyAgIF9fVEVTVF9SRVFVSVJFKFNZU19GSUVMRF9HRVQoSURfQUE2NE1NRlIxX0VMMSwgSEFGREJT
LA0KPiBtbWZyMSksDQo+ID4gKyAgICAgICAgICAgICAgICAgICJIYXJkd2FyZSBBRiBtYW5hZ2Vt
ZW50IG5vdCBzdXBwb3J0ZWQiKTsNCj4gPiArICAgVEVTVF9SRVFVSVJFKHZtLT5wYWdlX3NpemUg
PT0gNDA5Nik7DQo+DQo+IFtTZXZlcml0eTogTWVkaXVtXQ0KPiBXaWxsIHRoaXMgdGVzdCBmYWls
IG9uIDE2SyBhbmQgNjRLIGhvc3Qga2VybmVscyB3aGVuIHRoZSBDUFUgc3VwcG9ydHMgYSA0Sw0K
PiBzdGFnZS0xIHRyYW5zbGF0aW9uIGdyYW51bGU/DQo+DQo+IGd1ZXN0X21vZGVzX2FwcGVuZF9k
ZWZhdWx0KCkgc2VsZWN0cyBWTV9NT0RFX1A0MFY0OF80SyB3aGVuZXZlciB0aGUNCj4gQ1BVDQo+
IHN1cHBvcnRzIGEgNEsgZ3JhbnVsZSByZWdhcmRsZXNzIG9mIHRoZSBob3N0IHBhZ2Ugc2l6ZSwg
c28gdm0tPnBhZ2Vfc2l6ZSBpcw0KPiA0MDk2IGFuZCBURVNUX1JFUVVJUkUodm0tPnBhZ2Vfc2l6
ZSA9PSA0MDk2KSBkb2VzIG5vdCBza2lwIG9uIDE2SyBvciA2NEsNCj4gaG9zdHMuDQo+DQo+IFBh
c3NpbmcgbnBhZ2VzID0gMSB0byB2bV91c2Vyc3BhY2VfbWVtX3JlZ2lvbl9hZGQoKSBpbiBzZXR1
cF92bmNyX3BhZ2UoKQ0KPiB0aGVuDQo+IGhpdHMgdGhlIGFzc2VydGlvbiBpbiB2bV9tZW1fYWRk
KCkgcmVxdWlyaW5nIG5wYWdlcyB0byBjb3ZlciBhdCBsZWFzdCBvbmUNCj4gaG9zdCBwYWdlOg0K
Pg0KPiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbGliL2t2bV91dGlsLmM6dm1fbWVtX2Fk
ZCgpIHsNCj4gICAgIC4uLg0KPiAgICAgICBURVNUX0FTU0VSVCh2bV9hZGp1c3RfbnVtX2d1ZXN0
X3BhZ2VzKHZtLT5tb2RlLCBucGFnZXMpID09DQo+IG5wYWdlcywNCj4gICAgICAgICAgICAgICAi
TnVtYmVyIG9mIGd1ZXN0IHBhZ2VzIGlzIG5vdCBjb21wYXRpYmxlIHdpdGggdGhlIGhvc3QuICIN
Cj4gICAgICAgICAgICAgICAiVHJ5IG5wYWdlcz0lZCIsIHZtX2FkanVzdF9udW1fZ3Vlc3RfcGFn
ZXModm0tPm1vZGUsDQo+IG5wYWdlcykpOw0KPiAgICAgLi4uDQo+IH0NCj4NCj4gQWxzbywgaW4g
UldfUFRfQUZfQ0xFQVIgbW9kZSwgdm1fcGh5X3BhZ2VfYWxsb2MoKSByZXR1cm5zIGEgNEstYWxp
Z25lZA0KPiBkYXRhX2dwYSB0aGF0IGlzIG5vdCBhbGlnbmVkIHRvIGEgMTZLIG9yIDY0SyBob3N0
IHBhZ2UsIHdoaWxlIEtWTSBtYXBzIHRoZQ0KPiBjb250YWluaW5nIGhvc3QgcGZuIGF0IHRoZSBW
TkNSIGZpeG1hcCBhbmQgdGFrZXMgdGhlIHBhZ2Ugb2Zmc2V0IGZyb20NCj4gVk5DUl9WQSAmIChQ
QUdFX1NJWkUgLSAxKSAod2hpY2ggaXMgMCksIHJlYWRpbmcgZnJvbSB0aGUgc3RhcnQgb2YgdGhl
IGhvc3QNCj4gcGFnZSBpbnN0ZWFkIG9mIGRhdGFfZ3BhLg0KPg0KPiBTaG91bGQgcnVuX3Rlc3Qo
KSBjaGVjayBURVNUX1JFUVVJUkUoZ2V0cGFnZXNpemUoKSA9PSA0MDk2KSwgb3Igc2l6ZQ0KPiBS
T19QVF9TTE9UIHdpdGggdm1fYWRqdXN0X251bV9ndWVzdF9wYWdlcygpIGFuZCBhbGlnbiBkYXRh
X2dwYSB0byB0aGUNCj4gaG9zdA0KPiBwYWdlIHNpemU/DQo+DQpSaWdodCwgdGhhdCB0aGUgdGVz
dCBmYWlscyBvbiAxNksgYW5kIDY0SyBob3N0cy4gVGhlIHJlYWQtb25seQ0KbWVtc2xvdCBoYXMg
dG8gY292ZXIgYSB3aG9sZSBob3N0IHBhZ2UsIHNvIEknbGwgc2l6ZSBpdCB3aXRoDQp2bV9hZGp1
c3RfbnVtX2d1ZXN0X3BhZ2VzKCkuDQoNClRoZSBsYXN0IHBhcnQgaXMgYSBLVk0gYnVnIHJhdGhl
ciB0aGFuIGEgdGVzdCBidWcsIHRob3VnaC4gVk5DUl9FTDIgb25seQ0KbmVlZHMgdG8gYmUgNEsg
YWxpZ25lZCwgYW5kIGEgZ3Vlc3QgaHlwZXJ2aXNvciB1c2luZyBhIDRLIHN0YWdlLTENCmdyYW51
bGUgY2FuIG1hcCBpdCBhdCBhbnkgNEstYWxpZ25lZCBQQS4gT24gYSAxNksgb3IgNjRLIGhvc3Qs
IEtWTSBtYXBzDQp0aGUgaG9zdCBwYWdlIHRoYXQgY29udGFpbnMgdGhlIFZOQ1IgcGFnZSwgYnV0
IHRha2VzIGJpdHMNCltQQUdFX1NISUZULTE6MTJdIG9mIHRoZSBoYXJkd2FyZSBWTkNSX0VMMiBm
cm9tIHRoZSBndWVzdCdzIFZBLg0KDQpJJ2xsIGZpeCBpdCBpbiBLVk0gYW5kIG1ha2UgdGhlIHRl
c3QgY292ZXIgaXQgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KDQpfX18NCkJlc3QgUmVnYXJkcywN
CkppYSBIZSAoSnVzdGluKQ0KDQpJTVBPUlRBTlQgTk9USUNFOiBUaGUgY29udGVudHMgb2YgdGhp
cyBlbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBjb25maWRlbnRpYWwgYW5kIG1heSBhbHNv
IGJlIHByaXZpbGVnZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIHBs
ZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBhbmQgZG8gbm90IGRpc2Nsb3NlIHRo
ZSBjb250ZW50cyB0byBhbnkgb3RoZXIgcGVyc29uLCB1c2UgaXQgZm9yIGFueSBwdXJwb3NlLCBv
ciBzdG9yZSBvciBjb3B5IHRoZSBpbmZvcm1hdGlvbiBpbiBhbnkgbWVkaXVtLiBUaGFuayB5b3Uu
DQo=
