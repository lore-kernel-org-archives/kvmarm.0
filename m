Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012052.outbound.protection.outlook.com [52.101.66.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A6CEACE
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748048; cv=fail; b=JnJ1fma8HOS3r8pniwymsPtPvRsUZMDVgzIvaILxJMnh/BV1F6rjsppRbJdib7LYLy3lNV2Gj1OnV3W501Uzhy+xBITbvTtkz6tCNg8QVE4QTG2dG3NUaECam3nN9LsKurZ7dsSysjPE9VWxCKwY/CuMNZQCk54KWn7uM27qT3c=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748048; c=relaxed/simple;
	bh=hEHruG3xgtRXEjP91uq9Xh8zjIpTZRD+q3+vB0NdkdQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Eam3cFWDQxtvwqRN0kIx7W6mK6nG5Z1bddeUx7xHQc2fYFiFyr3QqfF86d1cHvyNQxcV/LbklgH6eEy9sAiKRusyUt8wS9aPDYQSJqZ2QUBhJ5cY4cSwgoXcKiiViBmqP8prZJjRz2u5GFsvqAACwjFnWykQFy4tsm21dUIa1xY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VVCBt5xA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VVCBt5xA; arc=fail smtp.client-ip=52.101.66.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VVCBt5xA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VVCBt5xA"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Y6LuRBbTy+0J9na7d4ApqQfIXdK+qdI0bh9hqd5fuduV9HAxynFwY2mq47iDJ5f6+NWYiWNifyonZK/4baurOdTqiyxq6XUQQzV9peP+z8ny6cyH4KLE6At5Pnz7Tx1h6rq5MDtW12i9YiqwkGnBxxGYmo1SOKZ8/yMQOekosHEYP6tNx5BNS/tJoDlZpzo5W2yarDNnX8MxGjuJYFmr2EGDqCWlgb0WMTx0v7PPV+3qaN20to7Y6eiGSn95ijS/BADbFGbxyBEYYKBW/hhmDFg4xt3E/t3xxgCh1TvzPzqQRUXRP17z8CRCxSHQrJ3nxG6eX/BF7zr7A7y+ZkWluw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yAjHvCGjnAM1FDaOa5lOZhB7hNWLtfYtwHstixoRQI=;
 b=U2Wibk2Z8+HDwAFwtBc9VXsqPJZpoLXc0SMAXkLxgkqK47BKAkPx3WEJa88p3mcPnqzSg1NzYAf3/7G1TxPGFa+GGTtbKbphTfjOejKicJLQyfH93zYfZGNx1T8t4lXnOIM71ZXQvWn6Pay5ByJAL0SO+YlJu4sGor2W5RcRlcBNxeiMaDRj7PfeBmUODhjf8tA+fUQ3ai8YgEev0+qxrcfWmDPqjUrGMnS560yR5/AOQ21l/6vpkrugjGg5Kf4/+GjVVBKTW7HC69JPwC0gMUFfQQQssVGdIidYJE6RpxPjTxhatXcIVVLODUd3wnZNoWYDVerKgnH4AXNxhjsCsQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yAjHvCGjnAM1FDaOa5lOZhB7hNWLtfYtwHstixoRQI=;
 b=VVCBt5xAAIsCg+Vg5TjulTubTfVe/NTJpLUa99eXeh7XaEFsyLJKZldqqPalyXNpyRPHWNIZNXSetc1bzfoMAFsauvgnlSXLMiCxV8/A1gAPt8FwicVkRBjwYGO7zkRb/QTh+xtcDTolxjDWhSs9T0Dksax+DeViN85Wb6MbV8g=
Received: from DB8PR04CA0011.eurprd04.prod.outlook.com (2603:10a6:10:110::21)
 by VI0PR08MB10972.eurprd08.prod.outlook.com (2603:10a6:800:251::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Tue, 17 Mar
 2026 11:47:18 +0000
Received: from DB5PEPF00014B98.eurprd02.prod.outlook.com
 (2603:10a6:10:110:cafe::4c) by DB8PR04CA0011.outlook.office365.com
 (2603:10a6:10:110::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.24 via Frontend Transport; Tue,
 17 Mar 2026 11:47:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B98.mail.protection.outlook.com (10.167.8.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:47:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DKzLoBsYVwinISy9VdCbVpFJRby8eTQV7QibNdxZWhEiv69NuzfEu3KzIGzrT8xdkFKR5yg0PgIC/nvvvhCTAqO2OFSPaSYvSoYNy8VGZjiu0sp4QDpd/cFKw3Q6yhs0bDr4DCaWSMv072eeK7cmXP1QoigA6V0lCz3PaQpqothiNp2MjaH6ChISMkE9kiy0B4FHKg5HWI/aIYEwDb+9G3IeD8f9qiCkRiLp4Cfqm4N/y6qHWFIJWowSbnwxWuQirHjyyuzhV48eL6KZO5ppIXJRzo/OHfgblfNmifoJwRclbOtfOo8MBjRhEdTeUAklpwcXuW8hNEEPrikwi6EYZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yAjHvCGjnAM1FDaOa5lOZhB7hNWLtfYtwHstixoRQI=;
 b=DSvQSzufNSDjKPAYZeGY0TRqL1zujYanU//t2VkhL9ie8gwG44+duSxmmpvA29ZflmqKsTG2ij7s9N1duTwgo0BgfvOE9dtP005+Bs8x4FdVyHOK2x1Qc6lhJalzP9NQPT6JqaUtBq0qx0xmoDp9PKTogFfTfn0sfA81dE6SXd2WTBRzcta676Es64oEJZmZJp7iAKROxiCJ1B9QtNUecv75IyPs/OXEGnwRuqB6MkKWLqILPCMfC0XJbzwA08QdLQ88Jldy6RctGYCzIkRW9SGnroVmeEq0X3kZAQ3FpIg+JtS586kRPQN45xgoitkkp4RDf99AYXau2ivbMlCQsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yAjHvCGjnAM1FDaOa5lOZhB7hNWLtfYtwHstixoRQI=;
 b=VVCBt5xAAIsCg+Vg5TjulTubTfVe/NTJpLUa99eXeh7XaEFsyLJKZldqqPalyXNpyRPHWNIZNXSetc1bzfoMAFsauvgnlSXLMiCxV8/A1gAPt8FwicVkRBjwYGO7zkRb/QTh+xtcDTolxjDWhSs9T0Dksax+DeViN85Wb6MbV8g=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:46:13 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:46:12 +0000
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
Subject: [PATCH v6 24/39] KVM: arm64: Introduce set_direct_injection irq_op
Thread-Topic: [PATCH v6 24/39] KVM: arm64: Introduce set_direct_injection
 irq_op
Thread-Index: AQHctgOnoibIZHY0XkOSDhmmk2mIzA==
Date: Tue, 17 Mar 2026 11:46:12 +0000
Message-ID: <20260317113949.2548118-25-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|DB5PEPF00014B98:EE_|VI0PR08MB10972:EE_
X-MS-Office365-Filtering-Correlation-Id: 65f1bcca-cb3b-4345-093d-08de841af11c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 yDKAUYcNnQYazlqktyg3Pg19ggThaYvZQeQeXVmQdtYa4uMTz3DTXtz9r4ajzuHpPWNPk+KFYZHlo169LA+t5ZSR2zAnX8Ps5NecFyHkLFttGgyx9+rj5H/XtTyNyXq9rT1fQItPRfDfjXbUYK5jiVWB5MYrL2z9cdVuYhS3F8SI75EbSa1KLYOiOh58UBZ3BMw3pUDL1E1AAz/KqzYfrLavTI8O81NwuaYyfsu0T75zFu0R0P6TQ68xkjIUxdVMcIGca/E3r48yqrS5UAQCTqFUhOnLFWrjs5N+yrEoOQwp6MnwEPpfNPQqTitErYo/S6GJXkiXtPgfZaqTrbqX1b6bp/xQmF2Hv3ZEMTAOl99TE1rh3ZMvziJamc9DmxhO6I8cdJzsj8LskBkW3J+nPv5x9fR0TyHGFAe1X7rGucLB77axoaUTJuBpCIv/aUB3uP4YeEcdNJUrOpXDZiEKxeM7mdUccdUPBT6jF5omf0H0zyHw1trMCvUz6ImxgKOH+G0QrbkorcJKlaSmPLMJKQHfdAQ0xShpLin16VpYzLAW88eZArfaIZkozhVEQ+niDl4B5mqpuu64FXptzGK+pMSL4CoIKz8bxs9okGHCF5TxQY7cxXpf50R77tjEwt0vj0WkTzmtNW0Y5+Jtd22csBShPtCEjpOuUwZzxg59ANq4Rw167/hGfT1NraAnxUl0oT8j/wyTiboyUoS6YNwTXE70L3HljwRWAvPgvySLe54HV/PGKyMI19M+eVWbWSoWSDjN1XBVZ9lGUcA3ZXCKnV7Agv6hZ5JjAnY4Peo4/jI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 phHsGE3hg0boLJ7vXlqOV0M5r6D7gyDv+WV/I18yqCYSrj1VR1fnYhg60askEHDgILxqR1lTHiSkjGZLm++IVsMyuf1zFILuhh/WWsIsoW4BRjw+BBzhdqjy6/BUnB+/NXePhJi9wXDLlYfBNWlrapWQNtzv4hM18mXujlxKJRB70F70FCCU8biQK5Vg1rF4FVh3XaxiKiw+EtC6BMNfTsEGvIOV8OXbzMxrW1khHAhjBg7P1YOTcqtu2qZEpJbLlpVzD5Es6fklMXatmk/ibKDF0rLhnPqRtA2pNOCj+Ynohp58Y44GV3DViHgW+sMsOnG0m+m7IGb8VOm1LRIlvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	07d265a1-2f56-455c-1826-08de841aca03
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|14060799003|35042699022|376014|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	y/qVBhawz0jCWZvm5Tnhse5Lu0bQeC+83SJZU0CE60kNjnQV5IIWKce2tqPgwJDakZt5cDcKpJwrdBZWSOxKaKePMT3vbpIrVpkt7ZjPhoeXQhaGdKfiVCtwlfCTL5tM4WtAYOWovVP0RlnNNBLS0vdeTPMpn8J6zEGg2G+aecZvNFT1zmPOvlLH5g+gTg+eQJ4aGS3NKX2PoXgIu43LBHBrIsl6XfO0ZHGnETNelcjAHer4l2sjzfjaceNjdqmJluNORfPH+oKXUIqFufyxU9vfKjQ2VWfAYAcvNgoZkqaJRrnm2l1I1a+BCzFTbYj4zJPq1OfyejTEzkGRkqDeSii6fDQD+oihiSeAgiS3HOLt8kkARqCz3xZxkq5QA8XJ4wY7jyD5LXXwwTNyMfhUIFSFWz7+pTRrmmAFykrALJ1CW4dUuA3Y7euX+NMz0AqdH4GC3gcYuoptaDSs23cdjY2aAOWuqOURKfuWmMVx7y/zsMhbSmFqVfh3aGY4mBxK0giQAnuAAGppDDOuavMP1hkcbeswONVt7hhpNB0gMgjvxpzPZCIvqXqDXJq50ImfVjKAcMW7/76tqKwX/EBiwrQ5TUhScbDmbDxIDhRJ9M5kahf+WciM36+QauacVAqFLdXMYIun98/aWDPfnBg8My+0ZULt6hUJ++sEGvglffFAVKuOoxfkawv3v0UJSoLZzIp5TlwhnTXkK/aNRoaCaf843UXwdhgzIEGoKC0EmGVDsiEIe2BmQjjAh5Nc1XiRqZyF41Cujl0SDfJV+5Td/g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(14060799003)(35042699022)(376014)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oiOYEhBVt9ifP9+svbSTPZ/Mq7rngyVn47Y9PDNCwu4mhkb46ixpkUYVfkoDXdXXK0ShCCpCGhy10QgGPwV0PZL0MTA7p7b8wDl9FkElACiPuQeRI0XQQ8+zMlhh1cGUBnsPqn1UkWPOZmkWc28raAl2KQDI3MDflY/gkVJWlNFGNNaqmnz1AP0lqjEag5eNv4vy1IuHW3537b5rrh38Z584OK9cQ2KlBsh7E+V8Uo9wyJ++c0A7byw6ChmQGubFBd2tKYv5rVgJZjCSeuqGDgsz414kxvzDJAyA0YJt5Z89UNQ68neZ0wvabW3PFD1vtpvmJLufCyITG+J5XbFmWZjMgLx5FIcJXIa7+JfHRzVWBtGLGYtOPrTbmmQpUxQB/tgE8bJrEbw9ZCJd14mzSBg3WhqkekboJmHIhcLK2OVLDJRvBFdMu7YPIKhfvWgE
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:47:18.1333
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f1bcca-cb3b-4345-093d-08de841af11c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10972

GICv5 adds support for directly injected PPIs. The mechanism for
setting this up is GICv5 specific, so rather than adding
GICv5-specific code to the common vgic code, we introduce a new
irq_op.

This new irq_op is intended to be used to enable or disable direct
injection for interrupts that support it. As it is an irq_op, it has
no effect unless explicitly populated in the irq_ops structure for a
particular interrupt.  The usage is demonstracted in the subsequent
change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c | 7 +++++++
 include/kvm/arm_vgic.h     | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d448205d80617..d7407337f9d26 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -619,12 +619,19 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, st=
ruct vgic_irq *irq,
 	irq->hw =3D true;
 	irq->host_irq =3D host_irq;
 	irq->hwintid =3D data->hwirq;
+
+	if (irq->ops && irq->ops->set_direct_injection)
+		irq->ops->set_direct_injection(vcpu, irq, true);
+
 	return 0;
 }
=20
 /* @irq->irq_lock must be held */
 static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 {
+	if (irq->ops && irq->ops->set_direct_injection)
+		irq->ops->set_direct_injection(irq->target_vcpu, irq, false);
+
 	irq->hw =3D false;
 	irq->hwintid =3D 0;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e9797c5dbbf0c..a28cf765f3eb5 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -215,6 +215,13 @@ struct irq_ops {
 	 */
 	bool (*queue_irq_unlock)(struct kvm *kvm, struct vgic_irq *irq,
 				unsigned long flags) __releases(&irq->irq_lock);
+
+	/*
+	 * Callback function pointer to either enable or disable direct
+	 * injection for a mapped interrupt.
+	 */
+	void (*set_direct_injection)(struct kvm_vcpu *vcpu,
+				     struct vgic_irq *irq, bool direct);
 };
=20
 struct vgic_irq {
--=20
2.34.1
