Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010047.outbound.protection.outlook.com [52.101.84.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9743E92AB
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.47
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935770; cv=fail; b=lU6uH2HadjKyK4Xe4Uevzt1HakDzerJqFXl4Aq+BTqr966ueH9tIR0VwRsHTbCKWFJanLwoCypo2cKVaXfx73sX0yW/BY1JFo4FEnss2CxW82kqA4j7fSSbcECyrt0CF3CuJ7Lt5/uIeFobTNgXliVPJNa42NIXF1EhFmtz5dso=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935770; c=relaxed/simple;
	bh=dzOSELkY6+Q7p2vjguobcvB1fGcAH97qR71RMnyCr3I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ndn9ATxzgcc4qvIyANH3jLYQl03X6MiqQ2BueHTsM9wIZo9LHV+cNW6SoXvIQFt+1cDT3+HwFIGOBHgXth0Bka1T/uhhEVXAQIWOIeg588a/W1ab9rzYhCyKpN2mN4vRub3rDSNN4p1i9LWiuvS2Yj2DNauyunbxoN8PcvnbwEE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dodx6m5Q; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dodx6m5Q; arc=fail smtp.client-ip=52.101.84.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dodx6m5Q";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dodx6m5Q"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WvqqP0YAi4LxfI74p0BNTLc+AXl+MI6th9aEgEfu0DJ+EgvXFQKBkXiDgdqkOELUGDWAYWsppWq2P0OGcJFZR5kQuE63xq5Efx05d2rKGFWews+JNjhtU3eosSzeR+RUBjiakbDAJ7f+Mikdh0tSv8oPeELZdY68IwAn7sonnld7Gt7rXzV/+/RZDNsRvY25TtrJhl80VnqgMKzRy+wQvxGs3Uz8w0tgSUEjGNFKqodra0H5Hop1sCzHHDbtSKdRsqt6VP3xhUbQ/O/gf1LdfoDo45CmQvXF1IFfR0jdJjhbNV4VwZxZFt0jX669Wg1bNC5QidaLx/POOFHDNr5d8w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKmi8xWbB7DmM9rWkO8kRmNZ5mczT2e0wIU+iYfNgbw=;
 b=ctEuyaSCQ1l7qtPMmcbZ4WpJrdwsIX2msnvb71eW8QyT2+IkxzsE9aCV055Q/dWJNki0glqb245Jt4h1q1krlUxhXOljPCoGWOmydqyRRNXn8yUb/DXd852BFSqgqX5jyXPgPB4UnNQ543NsugHy15Dfv20WYQasb0Ry/A44+fah8C985SvWu2amp0UaKDkwGwPxOdGD2ow2posxyPCEx/eF9AFc9X4MAtYAquZyOkqkN/mbg7ANCeRtm/8YSKgpr8Dyud+d1AGNhirh3qcfr8u7592tdkMoj/Wx3+w0v2/G8oD1eZba7QBFvtOolpsP6S+jkJzu71A6zLz65f5bng==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKmi8xWbB7DmM9rWkO8kRmNZ5mczT2e0wIU+iYfNgbw=;
 b=dodx6m5Q7MqaNEzSS/hZ7pepkk9oC37J9zELcLqp1GOobUQj6vM4sWAk0yJVzYUPpfFC0VflvQIljigs/eBLWEE6bxlbj+fYZ5NOJZwMICNiGWGZT42xse/1Ez2Ac2r9qTS4oNko6Rvi402edSDh6/ZOKN1EeNdAIA+DMky5Q+g=
Received: from AS4PR09CA0019.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::10)
 by DU5PR08MB10398.eurprd08.prod.outlook.com (2603:10a6:10:51f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:56:02 +0000
Received: from AM4PEPF00027A68.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::44) by AS4PR09CA0019.outlook.office365.com
 (2603:10a6:20b:5d4::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.20 via Frontend Transport; Thu,
 19 Mar 2026 15:56:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A68.mail.protection.outlook.com (10.167.16.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:56:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tfXZqj6ZjqkCdH0SfK8/p9eJceBGr8Gh56Sejx0OlD+otYNEKXe6FR7fwcs+t9l1AYIxX7t/YhKo2VXZkqtUbd67Zkzq+GNBZ6NQB8Vg6vQseZIjllGADlsdW5RSEt8o0x4e94+c8pj77L5wKld71QD9gGXPhWR++3JIUbNpmuWRD+VOm4W97NaL+Doe03fWk97MFwFr4iAd4PGcYvQhtZALk4+/lA2sNWNw2tg1k8H0ErNJLpx4MHoSYfIb0e6jgfZ2bm2SXTVMqs6hnSrL983rh424FE3zLQEcdt9Mr9y4z3MUxHudbiEfGgEOehecwiPsU4b5FRIkBJmuEl+Gog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKmi8xWbB7DmM9rWkO8kRmNZ5mczT2e0wIU+iYfNgbw=;
 b=M+3tliE6iQenra6ro6nVZiZpvDnxepC6eId33VneYBsqjEhv+/aOshtLbXZqaQEjCtA+xERv02RGJFkdvtbe97ZpSi61XO9DqPGfrzkJBgL6EPV88Dbtv5tM5xQUEptLsPYOjBPRvnLSJ5aMWGcl8KmARhM7KDe25JgbXk7b9+Scall76lkd+o/U1qTIGtmQLPGPrO61jd6PvI6k64TTZLO7cSwTxCtNihLUgzuhn+prQp6AqjD1+thT96pflD2ZL02DaOSyaV1EgeKDBU4NwtcQtwX84q49JvxpcjcVJlz6dey41Tqavh6UUQNoHMKc3HBlzW66tUZh8zMA2olJjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKmi8xWbB7DmM9rWkO8kRmNZ5mczT2e0wIU+iYfNgbw=;
 b=dodx6m5Q7MqaNEzSS/hZ7pepkk9oC37J9zELcLqp1GOobUQj6vM4sWAk0yJVzYUPpfFC0VflvQIljigs/eBLWEE6bxlbj+fYZ5NOJZwMICNiGWGZT42xse/1Ez2Ac2r9qTS4oNko6Rvi402edSDh6/ZOKN1EeNdAIA+DMky5Q+g=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB6191.eurprd08.prod.outlook.com (2603:10a6:102:f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:54:55 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:54:55 +0000
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
Subject: [PATCH v7 20/41] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Topic: [PATCH v7 20/41] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Index: AQHct7i6UEklPwAddUqSrKmgus8TQg==
Date: Thu, 19 Mar 2026 15:54:55 +0000
Message-ID: <20260319154937.3619520-21-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA4PR08MB6191:EE_|AM4PEPF00027A68:EE_|DU5PR08MB10398:EE_
X-MS-Office365-Filtering-Correlation-Id: f4cf0447-32b9-45e0-762d-08de85d004c8
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 TCMTJKQGgEmpPPLBh6kU/GyFT2Y0IOmdCCJN8G+YARDVmaKYVKC06tqX6U2dpZ+Y6F2PN9tNg3YI/EocOoKTloZT21ij9TTdOOR1EJFivtp6HWLWXLqE4+KxFXI+h8QFAHSaL3t2rNvKgNFK5Z7BfDE5r0YaiSd7MNdVarVcQLecdh3xuygAGyIJfMI74jyWehDaoiVjBmNUkcGNIYm5MltE09+/jfWYMIE49YISOI0kMM8St1eZ+13C8z1M3tf5vRqdQn2zHGR1JiSFESCzP3W4cRAh+KTF3c1iZIaeHssWxNM+rvcwU4QWqrjGm50fg/UQH3r076MOxwGC8Op5ycm9mG8IaWRMe05cCer+TxHIH1uo5m82qa7pJRSLtWR4b22ORZflQU1Fw87+N3R7BeCg0FQTSxyDtALNjSMWvfcXc9RgY8O/gqrlc9AjBbJg8VcyOz0Z09rMRP21HHTSNV6ppelI4q1uTFjDqX51b+uUPWEw0oQixv1m+vHGrSY8fJfwN3sDvLnvJXJSl1wXDKBShAAeXT1TjCRiX2NCJPJDr/OAgVmUpAxOJ78azQLjDsvLiidDcvcLrolQYEAjIhx5YhZfrvHZftV5R12sTLvdHTaf0n0SsTmVx6/2J0x4qZqqxmAd1/zkNC/lwkMXeviv5vMD1ebvOjFKHTPakQg=
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
 OF/KXmHxRGCUMHqCFWv4AwfsLbq9oIGBUCitEzXQ1mUnK5Yh+KeZdT1s0shnEzkGjKgj83E62pVq5Dd3MGGNTLD1mR8HIcupmsHw6niU/uLQiv2vDjp5Fb65d3NvuL+97iNORSWasFUiX8+k56HItoYksXJpfFa6JUpnBTToiIHBxZUGy0s4VucoSW+F9m5A22uDESVMg832HJy55ZZ41x3/bl7rNXAxBtXljuM0MN0u4y4ds2vsnNr3nFSULFN5aF55qpqsjRJnWg4lR2YVrXyWmUZPucKZZpq7xe4cw93nFMpYBuS2Qn8AEgvZZEZp2n2gV9nEvPLzikLkHkJQhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6191
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	247b1e62-c6bf-4df5-782c-08de85cfdd4f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|1800799024|376014|36860700016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	JXV+AqacJjB4i/JYpLVEW0L20D1MOqAiS2aQvpMLUXP6If2dspPk6mEGuKIM99c3OG06xa/Xfbf1r4hFXf/LJkwrUBOlnfFg+bkXyqgiZuy4yrdHY/CMlaht+7gbpJJ5okRgI4BzT6AhjaJddZvg+FZKnN8ObhdaPt77qATQpHMFxb8xLsZlfD8szvahkfjbMmvMLv0HznQm3U+G41Mc/NmLde5RRt3Qo/0EpwwiSkFCtkE0PBd1g4KZWvx5C9K59SkN3T/wQsCjcE8y5HEkpyIwn+dV4C01Wvu3TVTFjynrFhQZMTb2GAxY4K1941LpQSCZCMIF5vy21X77moM2exGVFgj7zDwI2QjiGgkFeO7mpcKbYS7gtXG0gkY7CYwpEBgtxJpGMGQbDj3oDLa1FsGfuQCwrD/wb44vgYi6URpJ3/1CY7jhKCQvN/wS8iveROku2NpUrFeiq1bLw21h0cT4gUzcZl3BrUCsyodNqDujZlC/mWC0Fo6I5mNcddNREPQVt5Y1fAM+wNzPw5Kc5f9BX0tiGGTQ0ltD6hDiAjSmhPubOL5pf7eq3OL0uFW+z3lWrM9UQXPTX6uR9og1YJhQgjUykbm2RN4NerWyEtXn/aHAeavyrmZMRkQl1q8Z0au7KbeatpsndSItiKxRj/gW9NvfSXbWer42eShVmiHyvJRxwD5imW/C9jAvfB9YyR4rfhLHDRBFH72mGJWQuEVjKaSoix3V/5W5RbSOb2TApNnGptC4cbnFaNDh3n46fGyyJ6YvW7wwx1spbyPraQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(1800799024)(376014)(36860700016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	a8SZQMnLOL2o2jlqaw0L8qYVN8zFE/2r1G7WyjKv2Fs1dPxXc1Kx6RKuy6tbIglk/nE0FPeWFMUQmwG5yEWLqB7EkYMw6RDBc/SnDIWPNWDVFQlzkRNj8fEL2WdVq0nZStXPk1qoG+Ps8gnux1QpbmHMfmSybp2PhZvgIEHe1YJWjPE7QXAGNUvH/7p3ifGM+BjFW5ScMXVZ5QvzsqpSdgpaJn2SXTZuAgcmWsnTMaM/ph7gslYYgl5zzqWbH3f6atBIOH71evUrxcjTQRsSbqqDb1C/8/ozwIm9BYWRw+jqhowhoZ0k68/W7o5ipQfV+NS1PIDmMy4x5UlcHpnAhUU4xZsKivPGU2YG/lItD6cUF6lKJQU9GpvZs5uapKT86/LwEjufMcYqupUHB4fePLGtKm0WKKG4+plcus7I2zkmmnPvhfhd6lAsShbKgUSz
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:56:01.2039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4cf0447-32b9-45e0-762d-08de85d004c8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10398

This change introduces interrupt injection for PPIs for GICv5-based
guests.

The lifecycle of PPIs is largely managed by the hardware for a GICv5
system. The hypervisor injects pending state into the guest by using
the ICH_PPI_PENDRx_EL2 registers. These are used by the hardware to
pick a Highest Priority Pending Interrupt (HPPI) for the guest based
on the enable state of each individual interrupt. The enable state and
priority for each interrupt are provided by the guest itself (through
writes to the PPI registers).

When Direct Virtual Interrupt (DVI) is set for a particular PPI, the
hypervisor is even able to skip the injection of the pending state
altogether - it all happens in hardware.

The result of the above is that no AP lists are required for GICv5,
unlike for older GICs. Instead, for PPIs the ICH_PPI_* registers
fulfil the same purpose for all 128 PPIs. Hence, as long as the
ICH_PPI_* registers are populated prior to guest entry, and merged
back into the KVM shadow state on exit, the PPI state is preserved,
and interrupts can be injected.

When injecting the state of a PPI the state is merged into the
PPI-specific vgic_irq structure. The PPIs are made pending via the
ICH_PPI_PENDRx_EL2 registers, the value of which is generated from the
vgic_irq structures for each PPI exposed on guest entry. The
queue_irq_unlock() irq_op is required to kick the vCPU to ensure that
it seems the new state. The result is that no AP lists are used for
private interrupts on GICv5.

Prior to entering the guest, vgic_v5_flush_ppi_state() is called from
kvm_vgic_flush_hwstate(). This generates the pending state to inject
into the guest, and snapshots it (twice - an entry and an exit copy)
in order to track any changes. These changes can come from a guest
consuming an interrupt or from a guest making an Edge-triggered
interrupt pending.

When returning from running a guest, the guest's PPI state is merged
back into KVM's vgic_irq state in vgic_v5_merge_ppi_state() from
kvm_vgic_sync_hwstate(). The Enable and Active state is synced back for
all PPIs, and the pending state is synced back for Edge PPIs (Level is
driven directly by the devices generating said levels). The incoming
pending state from the guest is merged with KVM's shadow state to
avoid losing any incoming interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 137 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |  41 ++++++++--
 arch/arm64/kvm/vgic/vgic.h    |  25 ++++---
 3 files changed, 188 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 07f416fbc4bc8..014d6fc1d44ac 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -122,6 +122,143 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	return 0;
 }
=20
+/*
+ * For GICv5, the PPIs are mostly directly managed by the hardware. We (th=
e
+ * hypervisor) handle the pending, active, enable state save/restore, but =
don't
+ * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity che=
ck the
+ * state, unlock, and return.
+ */
+static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	struct kvm_vcpu *vcpu;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	if (WARN_ON_ONCE(!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		goto out_unlock_fail;
+
+	vcpu =3D irq->target_vcpu;
+	if (WARN_ON_ONCE(!vcpu))
+		goto out_unlock_fail;
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* Directly kick the target VCPU to make sure it sees the IRQ */
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return true;
+
+out_unlock_fail:
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	return false;
+}
+
+static struct irq_ops vgic_v5_ppi_irq_ops =3D {
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
+void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid)
+{
+	kvm_vgic_set_irq_ops(vcpu, vintid, &vgic_v5_ppi_irq_ops);
+}
+
+/*
+ * Detect any PPIs state changes, and propagate the state with KVM's
+ * shadow structures.
+ */
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	DECLARE_BITMAP(changed_active, VGIC_V5_NR_PRIVATE_IRQS);
+	DECLARE_BITMAP(changed_pending, VGIC_V5_NR_PRIVATE_IRQS);
+	DECLARE_BITMAP(changed_bits, VGIC_V5_NR_PRIVATE_IRQS);
+	unsigned long *activer, *pendr_entry, *pendr;
+	int i;
+
+	activer =3D host_data_ptr(vgic_v5_ppi_state)->activer_exit;
+	pendr_entry =3D host_data_ptr(vgic_v5_ppi_state)->pendr_entry;
+	pendr =3D host_data_ptr(vgic_v5_ppi_state)->pendr_exit;
+
+	bitmap_xor(changed_active, cpu_if->vgic_ppi_activer, activer,
+		   VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_xor(changed_pending, pendr_entry, pendr,
+		   VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_or(changed_bits, changed_active, changed_pending,
+		  VGIC_V5_NR_PRIVATE_IRQS);
+
+	for_each_set_bit(i, changed_bits, VGIC_V5_NR_PRIVATE_IRQS) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			irq->active =3D test_bit(i, activer);
+
+			/* This is an OR to avoid losing incoming edges! */
+			if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+				irq->pending_latch |=3D test_bit(i, pendr);
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	/*
+	 * Re-inject the exit state as entry state next time!
+	 *
+	 * Note that the write of the Enable state is trapped, and hence there
+	 * is nothing to explcitly sync back here as we already have the latest
+	 * copy by definition.
+	 */
+	bitmap_copy(cpu_if->vgic_ppi_activer, activer, VGIC_V5_NR_PRIVATE_IRQS);
+}
+
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
+{
+	DECLARE_BITMAP(pendr, VGIC_V5_NR_PRIVATE_IRQS);
+	int i;
+
+	/*
+	 * Time to enter the guest - we first need to build the guest's
+	 * ICC_PPI_PENDRx_EL1, however.
+	 */
+	bitmap_zero(pendr, VGIC_V5_NR_PRIVATE_IRQS);
+	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
+			 VGIC_V5_NR_PRIVATE_IRQS) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			__assign_bit(i, pendr, irq_is_pending(irq));
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	/*
+	 * Copy the shadow state to the pending reg that will be written to the
+	 * ICH_PPI_PENDRx_EL2 regs. While the guest is running we track any
+	 * incoming changes to the pending state in the vgic_irq structures. The
+	 * incoming changes are merged with the outgoing changes on the return
+	 * path.
+	 */
+	bitmap_copy(host_data_ptr(vgic_v5_ppi_state)->pendr_entry, pendr,
+		    VGIC_V5_NR_PRIVATE_IRQS);
+
+	/*
+	 * Make sure that we can correctly detect "edges" in the PPI
+	 * state. There's a path where we never actually enter the guest, and
+	 * failure to do this risks losing pending state
+	 */
+	bitmap_copy(host_data_ptr(vgic_v5_ppi_state)->pendr_exit, pendr,
+		    VGIC_V5_NR_PRIVATE_IRQS);
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index c46c0e1db436e..485a9a3fab8dc 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -105,6 +105,18 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vc=
pu, u32 intid)
 	if (WARN_ON(!vcpu))
 		return NULL;
=20
+	if (vgic_is_v5(vcpu->kvm)) {
+		u32 int_num, hwirq_id;
+
+		if (!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, intid))
+			return NULL;
+
+		hwirq_id =3D FIELD_GET(GICV5_HWIRQ_ID, intid);
+		int_num =3D array_index_nospec(hwirq_id, VGIC_V5_NR_PRIVATE_IRQS);
+
+		return &vcpu->arch.vgic_cpu.private_irqs[int_num];
+	}
+
 	/* SGIs and PPIs */
 	if (intid < VGIC_NR_PRIVATE_IRQS) {
 		intid =3D array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
@@ -830,8 +842,13 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		vgic_release_deleted_lpis(vcpu->kvm);
 }
=20
-static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
+static void vgic_fold_state(struct kvm_vcpu *vcpu)
 {
+	if (vgic_is_v5(vcpu->kvm)) {
+		vgic_v5_fold_ppi_state(vcpu);
+		return;
+	}
+
 	if (!*host_data_ptr(last_lr_irq))
 		return;
=20
@@ -1046,8 +1063,10 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
=20
-	vgic_fold_lr_state(vcpu);
-	vgic_prune_ap_list(vcpu);
+	vgic_fold_state(vcpu);
+
+	if (!vgic_is_v5(vcpu->kvm))
+		vgic_prune_ap_list(vcpu);
 }
=20
 /* Sync interrupts that were deactivated through a DIR trap */
@@ -1080,6 +1099,17 @@ static inline void vgic_restore_state(struct kvm_vcp=
u *vcpu)
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
=20
+static void vgic_flush_state(struct kvm_vcpu *vcpu)
+{
+	if (vgic_is_v5(vcpu->kvm)) {
+		vgic_v5_flush_ppi_state(vcpu);
+		return;
+	}
+
+	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
+		vgic_flush_lr_state(vcpu);
+}
+
 /* Flush our emulation state into the GIC hardware before entering the gue=
st. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
@@ -1116,13 +1146,12 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
=20
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
=20
-	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
-		vgic_flush_lr_state(vcpu);
+	vgic_flush_state(vcpu);
=20
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
=20
-	if (vgic_supports_direct_irqs(vcpu->kvm))
+	if (vgic_supports_direct_irqs(vcpu->kvm) && kvm_vgic_global_state.has_gic=
v4)
 		vgic_v4_commit(vcpu);
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index cc487a69d0389..d90af676d5d06 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,9 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
@@ -432,15 +435,6 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm);
 int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
=20
-bool system_supports_direct_sgis(void);
-bool vgic_supports_direct_msis(struct kvm *kvm);
-bool vgic_supports_direct_sgis(struct kvm *kvm);
-
-static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
-{
-	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
-}
-
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
@@ -481,6 +475,19 @@ static inline bool vgic_host_has_gicv5(void)
 	return kvm_vgic_global_state.type =3D=3D VGIC_V5;
 }
=20
+bool system_supports_direct_sgis(void);
+bool vgic_supports_direct_msis(struct kvm *kvm);
+bool vgic_supports_direct_sgis(struct kvm *kvm);
+
+static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
+{
+	/* GICv5 always supports direct IRQs */
+	if (vgic_is_v5(kvm))
+		return true;
+
+	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+}
+
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
=20
--=20
2.34.1
