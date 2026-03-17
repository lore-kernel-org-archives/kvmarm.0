Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010024.outbound.protection.outlook.com [52.101.69.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0980EACE
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748105; cv=fail; b=WxkzRPKzg+XGMja2Ihl5yUROechQIf4yJ8ggKTkh6OSC6vXD/3mugcu7DvvY6j3EuZoLCtbHPCJoTKvuNdKS+1d6jkaqvhZM1Kq4Z7VyAblPgDgqpS6yB88XMzEK0hd+F3icVydE7EaOZjmGqYW6pLI2Vp+w4MEc0MQVBfWo4MM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748105; c=relaxed/simple;
	bh=EQ0btclJIpffX1FLeLTndWXj8LUX5ou5p/qFNoWHnj8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KgoXa9YUBn4vdqnbDSUCf2W1w8zN4FUjrHyEltRJ6eySiTAgUwjmHg1DUZ/YecQ3Vlalssv4qxNm8GKIXF3LbXhmjdDaY+KF5eabdAwH3lCbaDg3TcjhY3MWP2/uiaTCf3zDT7mPE1Q9zJrTQa3/ZLArZDM3lgE4fGe5wper9Vs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FFkv6rSG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FFkv6rSG; arc=fail smtp.client-ip=52.101.69.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FFkv6rSG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FFkv6rSG"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kob+buJQ9plXi6eZGEBxIDHim/MvdNvh0npZfXwQ0UrbJvM6tuGBIN3oHACYcDzUvle90p4Din3PZJb8C9Ap1wVLGguCmOn3TFb/uET2c4sjx6zV2riIu6n0TpNnvzhDJQ/QZWv8WEbmfbyXY4ExNJz4oi8bN9N5VFqYQqGjy44zTTzo4pDqJlRq/TXhPA2XQXT+hEJXV/6N1/FNL3azq05wrm2dtCloE7bduiCndi0AADGc6t14GB595LSEGOl0gdZSDA+3vqRyDIE+9+TdqH4O1NiETBH5RQ2TxykcSx+xIX5P3A9pam2KLMJNR/Ol5cNX5KVqQDP8Bd7ncbPi0w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ShYpamEds4EOR0AKBmjYpa+zsnjghcg0DuRJqT/q8Y=;
 b=UE6Yx4tEe2A+DIWE+k/e09ydadbcXlUMTnDptbdJBaJLa0Fskyz7ENGMlmPycGVS5hv7n7DyfDUrZT9aejpY+R2LW9FTlpyubsTYHWZ8GddvpbbkvTx8wHDvjQHjaRB7jnfDaONLDMIICACIwCDZ0sXIfiekAkn9LLWE4DZEX6aGWTgHcfPQrt7EcL2IMmMLI/NW/ylWNzBxuOS9IBMNbFt+wT7jeJCZaGmJXjf9n8pTs6xUdn3WJNiwqjttliQqEoqODLClgB5Ly/+GOiQ7whlrLCtQzZBjv0oz2N3gp8Q9RPNGupuRPAWfA9Ok4rjudzJABZmxgZZ11EnTnVlhvw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ShYpamEds4EOR0AKBmjYpa+zsnjghcg0DuRJqT/q8Y=;
 b=FFkv6rSGm8FNXZ1pVT53x4/9JuPkewYQG1wK4rO2vIzoF0TGvnJf4cgQ4P02byKK7/SXx6RafV6Sqx+ArP0yvRCcD0/yLtrA+u+er7UtK7xCMYj5bR+STilZnTExwD77rnBClfN7HV6nOPexT8qNUse9dFbIjfuEMHCbUl5yCTM=
Received: from PR1P264CA0039.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:2cb::15)
 by DB9PR08MB11894.eurprd08.prod.outlook.com (2603:10a6:10:609::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:48:18 +0000
Received: from AM4PEPF00025F97.EURPRD83.prod.outlook.com
 (2603:10a6:102:2cb:cafe::9b) by PR1P264CA0039.outlook.office365.com
 (2603:10a6:102:2cb::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:48:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F97.mail.protection.outlook.com (10.167.16.6) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.0 via
 Frontend Transport; Tue, 17 Mar 2026 11:48:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CHjY985ruZOjXAj6s0WRBgvBmMi3yshqfObhggMgtluh0Ch1Ax0NTm+5wVwus8Bi54vT/F81JO/9DqpP2ISWl4SuYEKbnqG9aBlAFKBsZYSEEpuBbbR1Xj4IGetM8Z8HVrA76PTmLN00lQtSmM9NFV8Gt7JnEG3/qxtKFx5ZN7pUdFujVyXr7h7qjESyMFMTblUYIlTodDjE/a4Xyat5K5WzyI9l3nXF5v95SFbIG0NZZ8qf8J1BWQ2v08JKt4ax5ZXhr4utFh09MtON455juy1iGsWHxvwR4t9rWjwr3cAv6G3PBmkckFgl/IEpFGcVm43mSGaVHEYq6DjztyZCjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ShYpamEds4EOR0AKBmjYpa+zsnjghcg0DuRJqT/q8Y=;
 b=Ye84Y7j+8QtXI6TOHkTUKpaDPTWJRg4PFYFueT86MRVQdtB1uovbhE0i1H3lVqftzSYvzCAIJnQIqyOMk/mzfNxRkXcK6QOrl2Y9LwPg7MPlpomjNGY2wFvRcZOPmokipSxtOiZEXyRBr8zi/NzW5cobeyRikydrjCQtiSMOxsIkkYRm/1Ht5KGnivwyAqs3jBtP74zZXCJU0Mo2w3fDtJvwRXr83wuTv0knMBb5HIkuD9zikHnm4XTJwJroGziQQNiTMJulF5vqaJ1fi3XmcaFqYcK9Y2OlteuFNRTsCllGjtI/MgvNfVSMfbYTMk8g7OiyoHEuxoG7j0lD9dKVdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ShYpamEds4EOR0AKBmjYpa+zsnjghcg0DuRJqT/q8Y=;
 b=FFkv6rSGm8FNXZ1pVT53x4/9JuPkewYQG1wK4rO2vIzoF0TGvnJf4cgQ4P02byKK7/SXx6RafV6Sqx+ArP0yvRCcD0/yLtrA+u+er7UtK7xCMYj5bR+STilZnTExwD77rnBClfN7HV6nOPexT8qNUse9dFbIjfuEMHCbUl5yCTM=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:47:14 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:47:14 +0000
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
Subject: [PATCH v6 28/39] KVM: arm64: gic-v5: Initialise ID and priority bits
 when resetting vcpu
Thread-Topic: [PATCH v6 28/39] KVM: arm64: gic-v5: Initialise ID and priority
 bits when resetting vcpu
Thread-Index: AQHctgPM5/wckHkzp0K99mE9LxRdLA==
Date: Tue, 17 Mar 2026 11:47:14 +0000
Message-ID: <20260317113949.2548118-29-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|AM4PEPF00025F97:EE_|DB9PR08MB11894:EE_
X-MS-Office365-Filtering-Correlation-Id: 719492c3-3d4a-468b-3c84-08de841b1447
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 KEP153m/rNlAOF3Qb8kPxHRvdQQ0s2PiTrv6P5TLTggc/pPPwWYMmdNrF6T8YBbmk0krMSwMtNxauHx3xGpvDtfewSR84lABOc+CZ3lYN+J0ENHJBdfOtY7YAJu33TQqON4fIdoFdPlij3diUdafTiS5av8KmyJFfFIaQsX6Hgs4UU8k64EQGVvSJ2zlIqLLrD3wDKvvvQL0L/rihe84w5Y4CnDzwmWwcireB1WuCjYIc4A+UWqmAYMYa4fOSsqoTqE+Hijjo5z7J6+XPBaQ0TVMWZbtkGM1Mcl6PHMc+YUOYxGwFcOJPLpDKHcdSof7gtf2+2LyJykffcrjRZJZgY9zoknEkeee5r0nYeN5mj7dTgtcaRDSsPTZlkeSteuq+UUUJUFPZNg+yBfeXWRv1RMHmUV4w24Pcjml14aJ9mS0Da2RjLyfh2OcD6OIoK7n1UOCwVlJiB+sJD73XcCce4cAP1By6NR5W3g5bTVoitD3hXlgzzFAB2eQXIppN04x3LUzEWwOFKCm59gkRQ1Om7wmtNoE5E5VGj/FDtkt3gEoLmw9zNCw9NO3IegC6s1YA9QlRe0Rrxi2gW9GE+uXT8unNcxnnSX6OSG4RU1nmuLUCa2wbxtzCpF7KymrZRzvaU0AlF9ZZv//jtVOG2rfCi9MCtrzx2qTLlxBXoMnXFkbL+EevmgPOI7jzGTPrIz8BA2uOIa6/IcjvUjslm5zoJlKXv/fA2c1yYzhwd/rlqMuhs32hdYPDSRgUAQUNapUH45eE3rfj8pFZeIgwpEGFhkQ3vDfamaxKxLlDI1n9jg=
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
 h9eLiP37Y9kUQpzGz9V6N8D9quwgDgmz77P9TSp9OPC16ebXEk4k2Js23YjcrG70gFH0es4juGPoasXpu+I/GW8aTZTYcFIXNo6tcmjKr9qZkrzoNi+ore5YOvOUpcgtY8g0n23OlC1U97gVh3GHeb3pjovxX2jX/wgH0DaPnMBVYcZHL97l3vYfYB5klQFBerpsAXtHDw3nI2jPXmQn/izAJLUa8uax5y0FQN7/2nr+fSV3sefDyUGSjvV/R9xuhD3Pb/5Lz63wF5HXKX6J608AF8dXvr6mWzHWdzyvw+AJ+YkufixPU9BX9ds7HKMGQgSASgOaye65e1KHelhMYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8a362974-b195-41e5-aa1e-08de841aeeb7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|82310400026|36860700016|1800799024|14060799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	P5oBDpkJ4KXL6rRFi/xDnJI0yKBhcPAtuXZvcPtEH4SjMk9dJZRIaGEXpefnnBta9rrGpYqIQQ93gn97IJJZaeHyCkU0wSRKtzejbvKJriU1f8ls1iDC3nuhvN7UgdTqi6U1urAgyQELpcbbwy3hQXQ9WwhFKd5yhD3+BgOi5ekbXUHn8MSohAdAbk25EYe8mrIw7dho3y11G0SK//7GX09lGRRsaKf3hqhCku3G2x8Lj77hSNHy/CMgMiRgLBgKmIIN/uAiHPU+D84MJ02ijFG32lKOpguJSnlrfVBHkFvDKeCCdaRxHckBaf67fJ5iJjqcHUYqLc992pW9C7VXqbxpJNG1nIRqxfAlbY12wwyBHYD51hnDmLM4ZP3HP6xzh2jQoGvxV5xTV1Ymv166Ih2bmMw7M62ANfH0aZkEjuJsEklRKj3XGU/m9wVXEysbPwIK9//NctW5qthomGdNvHPU0FVA0YOmrhaY6b+F0IH8nZXuPrIF+46fnH9y7xiFA9b4684m40VqMRjorha8cgMQRkfma60kSo6o1AsYDkQM/gU/gsgvQrjtLjImRNsH92rN4CgLW1AtYG76rtqRrFDD2YR9wMbp77paf/6yVEf+jK0WXTQAuYkDh/XCUiCki5m1s3cDHvvMyK+dbvchLhmtV2N94pwsjrKrhwo7F5VvPhBxIzMy7Q4l49EIf3kogxavvj1d5giScWQ5ksEdH/urbT4WfTcfoFg5ApY0Mckr71YnYkZPMhbFvqKW0qxNxwVc01fZ8gWzs7XlXpNMfA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(82310400026)(36860700016)(1800799024)(14060799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DN/UkNAHZ1QSGnpKgkR2isI2J8GaJV4zTACo5Qqg9UTxEpl31qKHq3922Fsp6lNhIO1if0IAPCQxXtBTBudZnEczsx9hKfkcTG5lGEBGiAuM3MwfgQWSg2eAcmvdgLO5uayFuHpSwyMiovtdOFLSxO2v5S2adFvdg442CU/n6dXhCQMkA0Wqty/rIPZyv5VRKflsCBGfIDVLPiPRimDI7mY/mjjM0UhrIiT0znjYGTyJUknBeTL0IVVXdEZdQWa2F5TrnS5XVVSCBhcVMMSqu7ZQ1ocHuHR4flIhk9uv+hzRrMLsdW6IQowZLXcU7pl0lRlIq9Yt/kbrS+UKQyPojgJU80PUXCE2C5kNxnp0yIM1Io/rbzrUVyCvYEgNwK3JhrcD0scj44TMF/TytT6HgInSHmC67m8wK9v9OvklOhJ58gJcJMGYZnV10yqXOuC5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:48:17.1387
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 719492c3-3d4a-468b-3c84-08de841b1447
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11894

Determine the number of priority bits and ID bits exposed to the guest
as part of resetting the vcpu state. These values are presented to the
guest by trapping and emulating reads from ICC_IDR0_EL1.

GICv5 supports either 16- or 24-bits of ID space (for SPIs and
LPIs). It is expected that 2^16 IDs is more than enough, and therefore
this value is chosen irrespective of the hardware supporting more or
not.

The GICv5 architecture only supports 5 bits of priority in the CPU
interface (but potentially fewer in the IRS). Therefore, this is the
default value chosen for the number of priority bits in the CPU
IF.

Note: We replicate the way that GICv3 uses the num_id_bits and
num_pri_bits variables. That is, num_id_bits stores the value of the
hardware field verbatim (0 means 16-bits, 1 would mean 24-bits for
GICv5), and num_pri_bits stores the actual number of priority bits;
the field value + 1.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c |  6 +++++-
 arch/arm64/kvm/vgic/vgic-v5.c   | 15 +++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 13d085bf01a97..497d4dc84913c 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -397,7 +397,11 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
=20
 static void kvm_vgic_vcpu_reset(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		vgic_v5_reset(vcpu);
+	else if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
 		vgic_v2_reset(vcpu);
 	else
 		vgic_v3_reset(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 0482282d59830..95c5fc51d180c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -87,6 +87,21 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+void vgic_v5_reset(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * We always present 16-bits of ID space to the guest, irrespective of
+	 * the host allowing more.
+	 */
+	vcpu->arch.vgic_cpu.num_id_bits =3D ICC_IDR0_EL1_ID_BITS_16BITS;
+
+	/*
+	 * The GICv5 architeture only supports 5-bits of priority in the
+	 * CPUIF (but potentially fewer in the IRS).
+	 */
+	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+}
+
 int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 9f1ddf9f4016c..103913528450b 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,7 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
--=20
2.34.1
