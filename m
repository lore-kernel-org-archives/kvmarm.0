Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012040.outbound.protection.outlook.com [52.101.66.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C433AEF2C
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.40
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748183; cv=fail; b=lNSiH94/2k5OTvR0CuWeeKa0VF/1MYtxq/hYDpvmsuz2zUpGx/rTiOOdphaoN/9Jl6VK/F0R8KPtyhlTFLr9xGOSgQZPba/5PVIOn5b9mWknGh81TA8wArtSOGXTjCJUUh7V5s0rFEOE78eJW3JVLpwOckv8+58j4K2Wb2G2EkU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748183; c=relaxed/simple;
	bh=MArmME/U96AovsSxZA/+7j12jz7jlzH2mQOzhQaScX0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u9ZDLsJ60WCTkixp0WzLCkh8HEVcJy97FwmEDMpvMbUaZolhPqO/Cf/7pZN1xH0syJaEw323CfFanKp34W4fhfX+4SoO/EBrlFhFiDxcmHvEusGPba+QEZ/T5C1fv05Rbx89r2Ru7xA8eLwEEySAIQon6hArYTOKCi+XOnQNUHM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D4eVi5Z6; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D4eVi5Z6; arc=fail smtp.client-ip=52.101.66.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D4eVi5Z6";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D4eVi5Z6"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rUKzzzz4Z7RCLX8g1bJMKC60Zzbkf7ReSlkc03AKmvf2oXOXxJ+uGN67XCMuHrCniId7V0SlIL3ZpbIapcsDtFn3IctYcKcpn8gzuvqG9eIVf6Es8L3VFXUten5BSkbb6Xs/9o3zyZSZFscjwWp7Dbv9As7fgsBPZWZY6zF4ZI8yN1VFI06v58cb7jjJ1gnk/eOeFHket9Lxcm88UWj+cG5XD3O3/UQlIsMMBGd+vLmrQckKCWGXIs+5fN/1FPQBoKLNga0khCw0LxJyLlc53y2us5X8/0GSK2DJW5l3lGabOG5mp0jZsgJAfsSx/0zcdagBNoO57k6ouf814r0tiQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LITXEriWhPB/sKaD0binpiSMXKTArtqIvU/i8E6f80A=;
 b=fqab/0YvkqjNSoIFbht3YiBlQjz/0lPR3mbrQrzzWQsMOfgACJo3W5Q544F0fkdns2SuGC2bFnTHBW8A6+nCnRCu4VB9wEPzVg9ShwtmxCtTe8rzS1LlQTB05axgljlZ2cLywqj8Fv6PJGVR52FE/zc1XweSmnVJaR8K1n6LWtocCoXVAGQ+ytNo/9RciOSrZXlmUUr5CO7vngyVoIZTDkDHQYPtxunMHG/PRR4l2o18ouCwqMW3BFW5fQK6EMqsqHJ3f2zwtdUUzysslbXk9JiaZMJ+PxoRiy6Pe5WQGDUR/LMZe/p6QU/l9ba9qUcmb00aRk+ZVTilTHpsyivGWw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LITXEriWhPB/sKaD0binpiSMXKTArtqIvU/i8E6f80A=;
 b=D4eVi5Z6908oNbtAlquvv1/aOMnYVC2DwJO1Fch9bgf020iVRUXkR1FtpSaapVBra2WI3+x5fv1xgqZq/cNFcVxOopH0bq+7gcf6YLhjs2ruJ6NBJs+n9+DE8l7uoOK+uhjWo3zRzBfR+kmblM21DSW5bgnWS2Jt5C3zwgfDJmo=
Received: from AS4P195CA0038.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:65a::21)
 by AM8PR08MB5746.eurprd08.prod.outlook.com (2603:10a6:20b:1d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:49:35 +0000
Received: from AM3PEPF0000A79C.eurprd04.prod.outlook.com
 (2603:10a6:20b:65a:cafe::b8) by AS4P195CA0038.outlook.office365.com
 (2603:10a6:20b:65a::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.25 via Frontend Transport; Tue,
 17 Mar 2026 11:49:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79C.mail.protection.outlook.com (10.167.16.107) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:49:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a89lTtbj3cyqFmObII080FPyIkh6ag9NtxQ5hIgA4rETs7xi6bNWi18HFsh/FHmcqo71MwemSDrjokHijzYiV0AkOkZBVRRWs7YEgl3vsKwJotEq/qP24AtCpbYEp1GFOPMoPIBFhGyN1GFhNAQBIqTG3dJ43xGBARjwyX06oyegLmGXfyLqh6oDFx7PoQvZs3hlVvbtQ/k9oMGE+Uti1v4nh+SU2pHE+6tsbAte4YvmE9N/xblKcSEXHrPTVlCluy37i9GTnbyJ6EOhe9lffkDiRbOTR9TB4ixMzuVsQty7sYOeBLEfYLOD66mjW4bU/vxhApVWJbywkUd/xIegJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LITXEriWhPB/sKaD0binpiSMXKTArtqIvU/i8E6f80A=;
 b=F7W3cL6myIkMm9iRR17hwjh5tPo5AYiFy4e5M8NXX3Neq7pPg3+doCvlg2UkHp9EeeEGV+clCGET+PZq0lRTpQKQZpLl4S28Chh7NhmSfdH+cGVV7AlU4n0qXaLovjfn3Raq3d7w6B2dX5lLfSSkPTx6bYvgYq6e1+eSJB1qVDJHjgJB/xOdTlbpSIdAmwNGaFIpNWlJUsRtzk2TrdCtKzMqzAKmEfRE26AOtPI4pkk1ktv8lUGA+MSOMkY9T/XADID2OILwR9w7khJ0LQumAHXFG7SFzUPs+VOR+tTC/dOud26qLHnJfUmV9B+DvuIqE8m6kMIk8ldWZHDgKblu2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LITXEriWhPB/sKaD0binpiSMXKTArtqIvU/i8E6f80A=;
 b=D4eVi5Z6908oNbtAlquvv1/aOMnYVC2DwJO1Fch9bgf020iVRUXkR1FtpSaapVBra2WI3+x5fv1xgqZq/cNFcVxOopH0bq+7gcf6YLhjs2ruJ6NBJs+n9+DE8l7uoOK+uhjWo3zRzBfR+kmblM21DSW5bgnWS2Jt5C3zwgfDJmo=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:48:31 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:48:31 +0000
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
Subject: [PATCH v6 33/39] KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops
 and register them
Thread-Topic: [PATCH v6 33/39] KVM: arm64: gic-v5: Introduce
 kvm_arm_vgic_v5_ops and register them
Thread-Index: AQHctgP64apHCQPqXUm951EpXj4fFw==
Date: Tue, 17 Mar 2026 11:48:31 +0000
Message-ID: <20260317113949.2548118-34-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|AM3PEPF0000A79C:EE_|AM8PR08MB5746:EE_
X-MS-Office365-Filtering-Correlation-Id: f9826b90-25d1-4b2d-d44e-08de841b42cd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 HjPR4t8+wIG7B+ygBcj8r+FFBL0Qb/9WnJktDpPfwDo7sIYhs1t5YfhCF1B8xAI3prwXcB7lXGl3klurxMVZFyBgAhQrREqaFHHRrRFgz0UKQYTm5hN1sC+CpQvsPTuxhbXTMe6EA1Enp9FTx4bpg6V8ZzsZfFZphG/pplYLvClNttvQGQIh3yARTZiq4fzvNRld1eM4RYl3kKSjBrIh2qZGizLvwe0cRsas6KXU4bMjCjcN9sBUc5hSuctMU47QGu9wxesHVhjW5kPkYikQO8i5sSktwtPWmcxDd/yUvnEXPEoJ98Rx9rLlxgTXJUTMlb1XCkP72LmCr9rc+6zBEplRQNmz7UD2PDdci6vlodSF89BBO1x5CknB4kGYeEJjxFOHjdjURflkeBT14pTGWlgNA37k/86dDYQatVfWRYXd0NZ3dQJN9LNOXxl3sdB/ZOSUdK3CGAiFrURdhFIf/IJYyOGNvuBfDcZ3EWZADARNz5igVwFyawClosxRCPRLHj6ttKP+Ii7A+e0yMgCp3UoSEkYNXQmwy0q+gN/rywmsv5FuAdaKlaU1iCmRLLBJWuRrRGm15544jpImNhB1Uqbi7bpaMy04WVEcgmdnRF5SvHMMLOkV4OiFtD3g8i2qjdSNsd/cBip6fKd+11E8tN9tNwUFYqShHwyG8K/S2qx4zMbgJdXrN1EXZjaHkwN+SE0hYmgd2Mj0LDHSo0rY7/0cjrGoGNvEYHD2egCR0THrIXUMS5izef3HSI43oio2kikKJjMO7qeB5U9sQ4zachsvn4+4qHyjv+NFujP2G1c=
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
 I/d1QEQ1pCVE7ekaU7rVg2PZuIoxuyvNJtH/rWbz5qTuogTIP1p+STxBUMXYdHReP30vLdHhCo4OYSSr+ijYrqTLuMe7U8NAixaTd1cxNq+nPtfV74gmWoGdmAb7zDQGFpB6PrKJYxVg4g12A5bDntix1MEOUg6gpQrzNSyhJDJtV98DNuf3r9Jm+Jnm5mr+M7jdPjXWJFApxjXphdk0/d0jGdbtHTo4euJcbjRDlU8OpZIWv9EQDPjcKXJpUP3NO4md77QftjO1PUif/V1HYvVp8EZMzOzn/YhgMjOHk46f+pi/kZShOWV9RsglXTS7wCN0aP0btPArMlWiRQmrzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f85ed5a9-d626-4b57-0bc0-08de841b1ccf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|36860700016|82310400026|35042699022|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4AbxgExEa9nMx0yStEgwihBLCf0fPou/NPzTJylx81WktL3CaM39UYHnYeqcV6FbM+ofajjFoYUqmmfbfxHCQDPOpk+EmwQjWABfPUqAFN8AS4I1w+Uh2mKQKgoNrmh+1NyJnjGvSPeoOTsaR+rlufS16NmVajihjdwJlpXCxk6uCu2d7cEORU8u6To67ANuYTQganaWXGyeiDt4iW7vfajXgHt9w4iLFyaokSCLCVBgjdN5rPZqKoyxHTfKhvMy9FQJl8AXfFQB+Ss1sRE7V3NSj9s0FQ4lSiWetTAVYZLkHokMxnwS5aOFpyH4mmuqbSLgfjpgzDlIJ38+7UWPwFkUhY3NESKNXa+bBjxfrfeLNq0Jy5xv+z+hwaPx/Yry7rddywof311pyxcZEAeS+qTHNF1Zr7/PYNmMKGxZNbFSNfScIWytXNE9QcWMpLiVC88NYkiYumwOWrgG/pViNzjtTfrucQDJj2trhAH6SxVpBy9XdH9kuUAbaXEIeAui0Dpqd+DCPyFWkL8cnFgUe9giax+I1ObsEKBfx8RspVKwMEGkCenhhDg5yqgkVVQ9ft0Q3Rb9nznnF9zO6pVlcUURMBApYZOGROssYrgpROyFuSlVJ7fxhUzlZucWX1Qg7cElarj4iNzzXz/p/M/YRmBAmeu7nQXf1SKTBV44sfrT9i2jDcAVYz5oPNqCttrASKw8E1yIwsoZ+tjTaMOXVPmJru5t1aEUxoxIZpbh4cClvPx3PkOdSJkwcOzxv4yXF+jWiISYp5bF9rbLSHKEWA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(36860700016)(82310400026)(35042699022)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OzIO1XqFKAmNEi8Ld/5lMkJvpiaQQ2vDQ3Jv9g7ifSJ+947G43Pl7DLSkIDewVBzMUrTxMCG6mhMtsrscvffqb7/y5ubGFK4ZxLyiXRsiG6dOSleuAIpKi+XioIhUw2CG4E6pvNTJK5261tXPOzYTjWbn7M1DoQA9SMyEgYQCawyso0dtas4aKiG8O4hG7n7gjE2LzkgV6MCTgiJ+gT9ifkwrNF8fQMUQgiMzK5nDFHfUxMW9y4NGA3ov9LbQFrKCiCfwaUaAWuuSH7sFI2ASAqjNLTjqK17yc7Kosw40Rv8gbcFxiA4xQ6noflA0shRF33XOiHTM6lIf3mdQvuH+BowdVRhk3w9Z7jNzHkcAPp1ClDewOe82pfIsgjviP37rMvWa8izLUqn4OPEXpJ1n+BYn8WPWg3In2gP0m0nl/WSS+3DzLd1V9KmCSuFKsrp
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:49:35.1877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9826b90-25d1-4b2d-d44e-08de841b42cd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5746

Only the KVM_DEV_ARM_VGIC_GRP_CTRL->KVM_DEV_ARM_VGIC_CTRL_INIT op is
currently supported. All other ops are stubbed out.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 74 +++++++++++++++++++++++++++
 include/linux/kvm_host.h              |  1 +
 2 files changed, 75 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index b12ba99a423e5..772da54c1518b 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -336,6 +336,10 @@ int kvm_register_vgic_device(unsigned long type)
 			break;
 		ret =3D kvm_vgic_register_its_device();
 		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		ret =3D kvm_register_device_ops(&kvm_arm_vgic_v5_ops,
+					      KVM_DEV_TYPE_ARM_VGIC_V5);
+		break;
 	}
=20
 	return ret;
@@ -715,3 +719,73 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.get_attr =3D vgic_v3_get_attr,
 	.has_attr =3D vgic_v3_has_attr,
 };
+
+static int vgic_v5_set_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_set_common_attr(dev, attr);
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+
+}
+
+static int vgic_v5_get_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_get_common_attr(dev, attr);
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+}
+
+static int vgic_v5_has_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return 0;
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+}
+
+struct kvm_device_ops kvm_arm_vgic_v5_ops =3D {
+	.name =3D "kvm-arm-vgic-v5",
+	.create =3D vgic_create,
+	.destroy =3D vgic_destroy,
+	.set_attr =3D vgic_v5_set_attr,
+	.get_attr =3D vgic_v5_get_attr,
+	.has_attr =3D vgic_v5_has_attr,
+};
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6b76e7a6f4c22..779d9ed85cbfd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2366,6 +2366,7 @@ void kvm_unregister_device_ops(u32 type);
 extern struct kvm_device_ops kvm_mpic_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
+extern struct kvm_device_ops kvm_arm_vgic_v5_ops;
=20
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
=20
--=20
2.34.1
