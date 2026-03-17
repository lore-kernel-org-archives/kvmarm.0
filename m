Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012034.outbound.protection.outlook.com [52.101.66.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554F43A4500
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747767; cv=fail; b=L5zPvrenLBBvCzCUmgH8XVfMM5RmefBF/Dloi69J+P6yq92us7L9hp1npTi12DGNsyKoU8y4vJZVphjBTWloJ11xbQmZu+SFeH8iXBPk469J7OOtor58CNmL2/WWVecuWbNWR1fLJQ0/U9FxPEhLP+o5GHWGNYgSv5X8j7aN880=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747767; c=relaxed/simple;
	bh=Enbd6Bg1uupBrfSkHszZ1FDAgJ3U1res4IvsiQEYfbQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ldd9qVFIbksX4FKWjJ9fXoH8e5SLJFNbphZ24Rjh+pRdSsjjmT2L5i9nsrGkLDI/FFWvrEWrg8gqWhVjpYBkVeALfWrwmfO6j7lrqpy3CO1QRrU9/LGCip7Aq8Pj1maKtO2KHh7+JpJ6IfkLTEDIIOPN24FLd2SvtNuvcoOEtxM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Mk4goVav; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Mk4goVav; arc=fail smtp.client-ip=52.101.66.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Mk4goVav";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Mk4goVav"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=fhy9aXNa0K2lkeIRcKi/aFW8FpVDy7YwB8ZBxgap6pNwiuAj61BJf3WXX8ehARhnPDhmNBkp8/hgU5X7gMwaUdZq1ScnRJ9NnVSf5DZkKFyk5bdEcVCPYX+gKOqZWzo6HtSZb1KupAGdnCcoX16rtCEGuVSv9RwN3LUvNH75k6p6PMp4EaDnXPx7tbAIg+i5hmAx0uVRt7L08c5Y3za5DDmCtbkIohrI5Fv+ugv6W96sZQC+sit28sUw9LL+m2bRqJvU1yMKmXjVaIKD3q1wl+iDjz89n8C6lFNaGzn8BjYa0DcMYnYb2ib7g6RcODg2BfOZUgwhMeGgKZU5NTer2w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKNWO+D6LougmMDJQeNfvDIf8BCxjGGHi0JLlrlZsR4=;
 b=mCyNoimaWKR3Er3/wy/JnBtpczJYENH49NGHYfFqwVD9/MJF8AKtA9jfzPC/f06dee//oLab52RhzzdQVHG8cVY0yNR9LXnRSO059RAZUh+7K9NnwRsWSh0S7dQanSH/iiEX0oyxr2eQbZ5+Q6zvFvosBmJawAO5sqAz8JqkOfH9p82ll/tRK6OMdfqGmqEVX6/5aOP1M5kNEyZ5hZDYnwy8UUPiDpPDAGQDcYB+LQ7zIp09cafyyFZegXcAekv0DCyw+R8a5/vQoaChUWxJubzyzaugGG4GofgeeifXVyV/wOW7mokVlCJc2FV5ANBEYNY3fgylnUrepnlAFpXrPw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKNWO+D6LougmMDJQeNfvDIf8BCxjGGHi0JLlrlZsR4=;
 b=Mk4goVavLkZHEosJ99JKttZDVZL3wdj2AVtALE/UecheaFZOOZvkFpsJWnR3fuIvULvoC/lAKn6TyJ6SrYflegAjoL/LlKNZ9lSwjLHhVPvzXfEMrThzO14tytBMxxKyvA0j5LTVhXNjSQCXrWGRFx4C7D6QBXWIRKY8BGqlXMI=
Received: from AS8PR07CA0053.eurprd07.prod.outlook.com (2603:10a6:20b:459::20)
 by AS8PR08MB7324.eurprd08.prod.outlook.com (2603:10a6:20b:443::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:42:37 +0000
Received: from AM4PEPF00025F95.EURPRD83.prod.outlook.com
 (2603:10a6:20b:459:cafe::29) by AS8PR07CA0053.outlook.office365.com
 (2603:10a6:20b:459::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.22 via Frontend Transport; Tue,
 17 Mar 2026 11:42:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F95.mail.protection.outlook.com (10.167.16.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.0 via
 Frontend Transport; Tue, 17 Mar 2026 11:42:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VATCmunqgCwUHjGwA7JZkAHdv2S87ISiYn37Y9BzOi8pMAtfTcx7cU7kIYWVIzyYxPjOzv9jLMcxbCwuc95Ur7Yz4QdzgT0yaF3tujBwS9TVFvbSsgfwrTqD411guFvi4pIFfVo8fPlGMnYqO76aW5IaJsQD+k6zCr0yhdVnRNf/nKkTxyq+W0ieTeaOOADZK6Px5dJKC+jHJQdSbhIasET5Jr+T+WB15YRCiQjRtXRgKTrxk0wiSF+zLnel00czLaC+BNRBN4gEOGFSVqOMd4Hl5OKezZ8TFXkPgTka11nUroyeUlCibVEBvuaWn0YpYBnt6g0IDt2KMqPqLnvupg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKNWO+D6LougmMDJQeNfvDIf8BCxjGGHi0JLlrlZsR4=;
 b=ToV7uegaQknNYs2H0E2cIOlcXcbUJnezC2/eXi0fLV9sHK5GrNmY4/Q3QkDg7wAMgDfRG08GKk7xxprje0RVt1c8M3xklaKJLNPq7yZc+AScJdBz9RpgSF5xXBvVfrSj1S7xBhFtMqaD/L9ehToTLeJ7/sXvL2lugMKTx8ElKsNRXJDvcckcPv334cerQZ60Iiyft5s46YUZFj/f5JsIMZ+hpDJFCdB7SLYg0eYOnJcrJfwbOyezXpUtaCy7aM3hpTfS/0xXQDvojIPLxSE+TBtxoWA5daBxN48JPsJkrUYbTz54GZuUXtL1a6shV+jG0gUvZQJJnvPiAKsp3TDpRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKNWO+D6LougmMDJQeNfvDIf8BCxjGGHi0JLlrlZsR4=;
 b=Mk4goVavLkZHEosJ99JKttZDVZL3wdj2AVtALE/UecheaFZOOZvkFpsJWnR3fuIvULvoC/lAKn6TyJ6SrYflegAjoL/LlKNZ9lSwjLHhVPvzXfEMrThzO14tytBMxxKyvA0j5LTVhXNjSQCXrWGRFx4C7D6QBXWIRKY8BGqlXMI=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI1PR08MB10122.eurprd08.prod.outlook.com (2603:10a6:800:1c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:40:59 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:40:59 +0000
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
Subject: [PATCH v6 04/39] KVM: arm64: vgic: Split out mapping IRQs and setting
 irq_ops
Thread-Topic: [PATCH v6 04/39] KVM: arm64: vgic: Split out mapping IRQs and
 setting irq_ops
Thread-Index: AQHctgLsKb0ahtEcF0iWZkW15dw4Rg==
Date: Tue, 17 Mar 2026 11:40:59 +0000
Message-ID: <20260317113949.2548118-5-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|VI1PR08MB10122:EE_|AM4PEPF00025F95:EE_|AS8PR08MB7324:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f6e1278-53e9-4bd5-a03f-08de841a49e0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 aXG3PfM0B/K3dQ1yE/oXWnIDM51zNatLOvd7k3JY/Hv4EsfedyQCTyWIsOdPYE0cQydGNPICaDjooUNFWTupc5zWUvqBo2hSQRmsMv5ASJvJUTCyrB0TsZrRtmZjfqhglb7IGMn50CKv2iRHNhQ0qKBTo836+yanxK2EXdZpA5tTRKbRKGZW36Z5UGW5hrLdu3Nj6kIPFmlOAyqzBrNkWhdKB82UjufkqUJjD+LUr7z0930BV+cIqRbsSHhi1HUJ4CiQoZD87WlOkmdDOwDe8QYzDnl1L6xrNsF3MQ39MqiGcWi9MH7xRBwA7cKaEBkSB3itcVZkMFEpk+4R756E8kB/K8bp6e0piK0BjIrbpqiUPNzBkXt/F18TTU2WWZSDZvg8ICNAy1ViEGBNvxHQbJtm9EdBLg9hY6as/EPv0uUSnvKZG1+uHZGehhxIK9kOAJ2ekQYguslyeTEhZcVXZ2GHKzfiqucQk0fle3znD6vV1Lrs3+o5vmi38ZrekKuUyDhm5DwgPeRhIH/Zv06oCj1ivOTkacf3hL+Nzu6Ly8Tex2GsEO/KKDGVs00CGo9fYjmFR9uHHHGmOi5El/FHPRylvEMJMBeMIyiV1Q/Z9lPqjYZykduLArHDgqBBQJTfzntsKbRd73ztiio26XoDl88R8IR0MRgA6rYB2BjfZPY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Y+EtxwpHwOvBxcaEap33P3jqRmp6I5cTocb8LaGPbcy2nvlaSZ/9AouYY2u7F82RZNgAzd1lASQB4teQg6Zo7uwImNQ4zyoGEcd4VOLtfLfbuRj2w3yD88dp0bxHx1EntlQTJ/JgobkobAuSxx0jxhxDIqLDgLA5IIM6V/i5GppSVLbSxR+fN6ZAksrTRvNvOvVjhlrTETLh8GkLX4mqQayriTC0Dn1QhJXaB3mdS4u0gK6+Wcn492uVnEadGRwIFSlQKpV9mdjJ28dvTHB+Vua2NCCUn4sJqIE8RaGK9ReCN6bN+69sulHCo5vbFlIGnbs4wLbX5aOl2Ja0hxtFdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10122
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	403c0ba3-eb9a-44ad-a567-08de841a0f70
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|1800799024|376014|82310400026|14060799003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vsdukcdBnU6bjbT9CP0HiavQL/UfeRfWLhVdz9A1xZrGGzKK5XGwQTfI9+KqKNMojlcKdqtYPotMlRaegxPxEsaa3NXhrpqWdpq6r51wo8RURYMC8TesgfjKjjpH3I9+a53mwP5sV0R05WzCwGligLU9H6jKAd/JqrzZt8T1dgGCei7pJBciKrRLzzsrhn1KZUwnr1ntxF6q0JTv+HK/tAfn5jThz+/KZh4DlkylcW8Dv8LAEltb7K/xtK52sOfoYLb9GktIRk0tfZKKD3SRpq8aG+bgbFJ9HvV32hHKdp5oihmzNiAb+dZ8xJG5dk0DhKpP1l7GMfTWGLJtzUP4c1cmfuoQBUpvcwrA3pXwa9fOuPU56H3hNs4Aq1Qa1pdGuoN+3ARgaLkqsNb+FcpB1DB7nqmRW9MxMUVvRaVJU7inKaI6SgBijA4TAxo+RXbCbI1DpiYUjzEa7dizblLM2oubLxQACnjgp6tFCHmQzpkTana9nYyD3xGKGJ3KYypV51GYJHtbeOzxQ5MoGMYl+E6auzy4t9bGHhIFsJZmKgUUVniu72OPDd4wFOOBYrmUwmGK25b8laAs94lNnJPIBUdH+fdIChJ5MsMwTar0ykwZ1Yibi+jt5txdctkAXdbv6CW3YET8ZBPjFEWUL60MXWiAHgivPcA5Wrh3oEHV6Nndg9klyClqj2Xsq6A29vAfI49SMY54Fl6eMH2uXJycs/V1bGANBBVMO46UWDx8+jFdKUHWU741s7Q2BPdMCr30XJyFzPONQc44nWZ+xOt+ag==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(1800799024)(376014)(82310400026)(14060799003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	j125a7FzwEhg/OYGQ5GhkugR6YgZ4wjqhJvN7nQoEElbwr0irNxNkEfkMfG3R/dSC6I1ePhkQkn8Jcr+Lc5YF8izN0Eube6WZdQaXOu7vch9gY++hJGQBgRYmIIHmplAETVdOePIHpT6vfb51peJhm74PO1uphhmfbLthtM77RCte8Xato179m19to9zYEBuKZQjvcs2nXmmRgAWCmi7RcqUVYH2Q0goBHFjunkc9nK/RyMBBNhx9xGxm2brV3RpbmG0eFm8kDU+TIpp7ebES4J3bt0fd+bS/ikB/ALbUcz8UCeecPEQHIJD2t4KAJMcRIJJ6bwJAlV2HIkPvvGp90gn0p2VAOnLBEzksPKUn97/GQ4NWIq+aP3PB3CWmGgWKlGwaGp6omnKJPBzcegZLS9HsdHRrt7oexrhgEpU5S6sD9rlndVPb+2sNAQ7FuxI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:42:37.5564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6e1278-53e9-4bd5-a03f-08de841a49e0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7324

Prior to this change, the act of mapping a virtual IRQ to a physical
one also set the irq_ops. Unmapping then reset the irq_ops to NULL. So
far, this has been fine and hasn't caused any major issues.

Now, however, as GICv5 support is being added to KVM, it has become
apparent that conflating mapping/unmapping IRQs and setting/clearing
irq_ops can cause issues. The reason is that the upcoming GICv5
support introduces a set of default irq_ops for PPIs, and removing
this when unmapping will cause things to break rather horribly.

Split out the mapping/unmapping of IRQs from the setting/clearing of
irq_ops. The arch timer code is updated to set the irq_ops following a
successful map. The irq_ops are intentionally not removed again on an
unmap as the only irq_op introduced by the arch timer only takes
effect if the hw bit in struct vgic_irq is set. Therefore, it is safe
to leave this in place, and it avoids additional complexity when GICv5
support is introduced.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arch_timer.c | 32 ++++++++++++++++++-------------
 arch/arm64/kvm/vgic/vgic.c  | 38 +++++++++++++++++++++++++++++++------
 include/kvm/arm_vgic.h      |  5 ++++-
 3 files changed, 55 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 600f250753b45..1f536dd5978d4 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -740,14 +740,17 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
=20
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_vtimer->host_timer_irq,
-					    timer_irq(map->direct_vtimer),
-					    &arch_timer_irq_ops);
-		WARN_ON_ONCE(ret);
+					    timer_irq(map->direct_vtimer));
+		if (!WARN_ON_ONCE(ret))
+			kvm_vgic_set_irq_ops(vcpu, timer_irq(map->direct_vtimer),
+					     &arch_timer_irq_ops);
+
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_ptimer->host_timer_irq,
-					    timer_irq(map->direct_ptimer),
-					    &arch_timer_irq_ops);
-		WARN_ON_ONCE(ret);
+					    timer_irq(map->direct_ptimer));
+		if (!WARN_ON_ONCE(ret))
+			kvm_vgic_set_irq_ops(vcpu, timer_irq(map->direct_ptimer),
+					     &arch_timer_irq_ops);
 	}
 }
=20
@@ -1565,20 +1568,23 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
=20
 	ret =3D kvm_vgic_map_phys_irq(vcpu,
 				    map.direct_vtimer->host_timer_irq,
-				    timer_irq(map.direct_vtimer),
-				    &arch_timer_irq_ops);
+				    timer_irq(map.direct_vtimer));
 	if (ret)
 		return ret;
=20
+	kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_vtimer),
+			     &arch_timer_irq_ops);
+
 	if (map.direct_ptimer) {
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
-					    timer_irq(map.direct_ptimer),
-					    &arch_timer_irq_ops);
-	}
+					    timer_irq(map.direct_ptimer));
+		if (ret)
+			return ret;
=20
-	if (ret)
-		return ret;
+		kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_ptimer),
+				     &arch_timer_irq_ops);
+	}
=20
 no_vgic:
 	timer->enabled =3D 1;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index e22b79cfff965..e37c640d74bcf 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -553,10 +553,38 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
 	return 0;
 }
=20
+void kvm_vgic_set_irq_ops(struct kvm_vcpu *vcpu, u32 vintid,
+			 struct irq_ops *ops)
+{
+	struct vgic_irq *irq =3D vgic_get_vcpu_irq(vcpu, vintid);
+
+	BUG_ON(!irq);
+
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+	{
+		irq->ops =3D ops;
+	}
+
+	vgic_put_irq(vcpu->kvm, irq);
+}
+
+void kvm_vgic_clear_irq_ops(struct kvm_vcpu *vcpu, u32 vintid)
+{
+	struct vgic_irq *irq =3D vgic_get_vcpu_irq(vcpu, vintid);
+
+	BUG_ON(!irq);
+
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+	{
+		irq->ops =3D NULL;
+	}
+
+	vgic_put_irq(vcpu->kvm, irq);
+}
+
 /* @irq->irq_lock must be held */
 static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-			    unsigned int host_irq,
-			    struct irq_ops *ops)
+			    unsigned int host_irq)
 {
 	struct irq_desc *desc;
 	struct irq_data *data;
@@ -576,7 +604,6 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, stru=
ct vgic_irq *irq,
 	irq->hw =3D true;
 	irq->host_irq =3D host_irq;
 	irq->hwintid =3D data->hwirq;
-	irq->ops =3D ops;
 	return 0;
 }
=20
@@ -585,11 +612,10 @@ static inline void kvm_vgic_unmap_irq(struct vgic_irq=
 *irq)
 {
 	irq->hw =3D false;
 	irq->hwintid =3D 0;
-	irq->ops =3D NULL;
 }
=20
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid, struct irq_ops *ops)
+			  u32 vintid)
 {
 	struct vgic_irq *irq =3D vgic_get_vcpu_irq(vcpu, vintid);
 	unsigned long flags;
@@ -598,7 +624,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsign=
ed int host_irq,
 	BUG_ON(!irq);
=20
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
-	ret =3D kvm_vgic_map_irq(vcpu, irq, host_irq, ops);
+	ret =3D kvm_vgic_map_irq(vcpu, irq, host_irq);
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f2eafc65bbf4c..46262d1433bca 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -397,8 +397,11 @@ void kvm_vgic_init_cpu_hardware(void);
=20
 int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			unsigned int intid, bool level, void *owner);
+void kvm_vgic_set_irq_ops(struct kvm_vcpu *vcpu, u32 vintid,
+			  struct irq_ops *ops);
+void kvm_vgic_clear_irq_ops(struct kvm_vcpu *vcpu, u32 vintid);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid, struct irq_ops *ops);
+			  u32 vintid);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
 int kvm_vgic_get_map(struct kvm_vcpu *vcpu, unsigned int vintid);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
--=20
2.34.1
