Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010004.outbound.protection.outlook.com [52.101.69.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4242FFDEA
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306324; cv=fail; b=kPhYd3DkPq79U/I/l/igkfHzicMt9mvmhbZqm/n/Q8KIxxO+2WoQVoEp/WsBUqIqyOBQ1YZAw5DN2R2Uk/+vXDv77BTUmQVUcylr+C7mP4hnDi+i7wSMAanes2yeFDbfOgEuO6kUhlxSQ/UQ5LdxqQjoClgGFiMy0HqIjf8IGZg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306324; c=relaxed/simple;
	bh=EGXstzfQRt//KsELZcIKxgEngP1s8KY5E7tRmR3m0w8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tyH7KMk1NiP9lNGFPwAalD+VJRfCxv95cXj+ilf3MAhHke8KPuPDuOpogEhj1H6SpGIucjdbKnv3pvdWji3x5VuUoc9wgCdb/GgrYh4GBX9rVe3AioD0Jb0FIsNRISsC+oHJJCB+9Ci8CB1AVgpNv/lZbkc1d0Gn3LH62LFkMik=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sKb/7muI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sKb/7muI; arc=fail smtp.client-ip=52.101.69.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sKb/7muI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sKb/7muI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BJksMDNyKTscr7C+HZxdSZGeOK7J28qWnzzZpfDsROZ8+2Gwi0+FXk9140Oq2sAr4N2ZcozRwUsBKC7/K/kZB8dUZtYljgbY2nC3+omLzI7sm3h8ZyyMZBUfI5Dh87xFgmxpy/jsxQU4BUnTY5jCM9VejAe3rsMqfkhPjzrjaoVsSnY3Rz5ECG0zpWQWe5HtklrWsTw5Hc7hZkl0LJ7ZQl9fEDwnb9Rn+bW+05K7FedXbWM7DkGgUOnX83zxckJqcveyoMd99DDHqf1I6U6u86GV90WlJ2dUKCGOzdUOab8oIWY9oLvvtHybyoek73/dRM/nqqytv0s3KIq8yfq8jw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhj3/o4HL0nkB7j6TOgI76nNifia5vpVTVS85WcKG08=;
 b=dznUQk3spwul6+fGR/G5y9Cvj8LN8Mlq9KiCR9od1sFBXmCbXFLHycs4g9Yx/vPhcdYX8o73CdHSs7PKNW+kpM9Vx8nmw30A4XrS4XjhRUS6k/elStUWKzL44Au7Qe5ACIlJK2NCSmIwBHg8hS6IuOzmEH65zsprDyrF6upTv9LL5rkv36lwArYMlOBJdHZ0rCDD+djRXCPN4Mpwk0QOoNogLxz/fk1Z5dlnC4EP/MpHIwuJubs6owBrMsFJqEH9fj/SPujbcrgkKebllEjLvsdjey2k0sVSfveQdK4zuMP7LqLsuCtqg9el9d0eAx37FPqoyYAkIQ14LyFQelbYTw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhj3/o4HL0nkB7j6TOgI76nNifia5vpVTVS85WcKG08=;
 b=sKb/7muIojhvrhkEjouLG30DuOS8viNEVRcnjdRH5zwRgynqfkI8c6QOQgiRSHEl7M4rMZ6s9KsP9wLNS9BmNhbsD7PBi7EPP3lt33kzbBCA4T+sD8i5pF/XTeEpA1CIGhaGilBFpUpNwypFFYIS4TZENQrkgz0O5xWt6aRlmtc=
Received: from DU2PR04CA0023.eurprd04.prod.outlook.com (2603:10a6:10:3b::28)
 by PAVPR08MB9700.eurprd08.prod.outlook.com (2603:10a6:102:31f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.22; Mon, 27 Apr
 2026 16:11:55 +0000
Received: from DB1PEPF0003922D.eurprd03.prod.outlook.com
 (2603:10a6:10:3b:cafe::5e) by DU2PR04CA0023.outlook.office365.com
 (2603:10a6:10:3b::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:11:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922D.mail.protection.outlook.com (10.167.8.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A/1GUVwvd2vuA8Ucg/ykemEonVT5LQzSEB6qDTM2hJVKL9pC60uIeNstpf8ggZs8KpFbAquXS2oZUg+W96LBCMQ/87ZpcacxdEpiCZgTFdI57XryTXSVGH394m5OlNP7g40y2Ir82xM5PmR6hVAuuBaT8bKYg89WbSAdUSu2m1wXvr63tcMaolCt1mz7qkyGpaBoMP3GJlXkZryJGLdXsXoSNB7s2ex9ZbaIIabtmo/rNNI5GDQwp0dpJvnNNFX2do1ri1wBgOcHMHU3bKv2oUM5TLhLarOblR7KcBkZTkjCkM2uyN2JhjKibMiJvqANxI3f8Ocdi+BWkXwB72xCTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhj3/o4HL0nkB7j6TOgI76nNifia5vpVTVS85WcKG08=;
 b=KpzwQoGAlyWNV0FUT3tVzC10vgQVabU3szdlQgWxmRErNIWweUBIwWP17uluXR5ymTjOfxktZ3noG8BohFM2rLQ12n64vX1jKCdKQ4+AcpRB/68LdORn8T973mtnnD7Hnm8/Z1o/sucKmmr+orzDfUEZPby6OVzN5a0zZJ09LndbYGVdSEo0xlAegREwjd2uhOW6Rcyq+UZBpKte2OK5LFY2QzeYGng+LG7e5UgBd5aFy7YwibyjKe2mMqfG+gg8frYObTZhsUlfeopRPnGIEqTr9/8DPvC+/EJwO3HjnhNEl4kjtuO8HuVYxq1MdQk7qm79O6VwgpapMHolpssN2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhj3/o4HL0nkB7j6TOgI76nNifia5vpVTVS85WcKG08=;
 b=sKb/7muIojhvrhkEjouLG30DuOS8viNEVRcnjdRH5zwRgynqfkI8c6QOQgiRSHEl7M4rMZ6s9KsP9wLNS9BmNhbsD7PBi7EPP3lt33kzbBCA4T+sD8i5pF/XTeEpA1CIGhaGilBFpUpNwypFFYIS4TZENQrkgz0O5xWt6aRlmtc=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:10:49 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:10:49 +0000
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
Subject: [PATCH 14/43] KVM: arm64: gic-v5: Request VPE doorbells when going
 non-resident
Thread-Topic: [PATCH 14/43] KVM: arm64: gic-v5: Request VPE doorbells when
 going non-resident
Thread-Index: AQHc1mBp+fmgF+oM0EKjmOFNVlTr8w==
Date: Mon, 27 Apr 2026 16:10:49 +0000
Message-ID: <20260427160547.3129448-15-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|DB1PEPF0003922D:EE_|PAVPR08MB9700:EE_
X-MS-Office365-Filtering-Correlation-Id: 734ea029-4ea2-4eec-1189-08dea477b215
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 CLlG+D2DHmWcHCkYsAdN2dEemKbXL6/SliXGdLOncMgbqojqP9mcQ2DVDjaiTVYvuQgdzR3xJULHEnFlonD65X2UiKhQIbI60sR3T0b3xgC16yTeO/Sn0yyDLdXR7Hqn7f1JxVgnUvbfZvbnoKSpKmRoMpFvFdwnnUTGzweCm6GqVETRglou83lLb2GySVN3EqEfXPwaTcXpWQWrPzji4vZEMQ4hxcz90r02hjPjOK0/CyULmi7yMJnXNRPCClqUONPJiRO7arWkGX0Zr2EolGG3+Z8oinYBGijdqoAzO7vHZIKp47V4by/Kt3TatD+xLyYXXaMQIWrEgUJG458IYXgpjaaKCxWYTLHOCH9Nmt1NfTFDORk7eQdt4KihdwaakfD/oEUdNjxzfp2T7F/8lriwp9dqvUhWXzGhwRB5jQ09SHuwaG5VK/0aGtURu4+e4GmcspLB7YAHuMtoaNKAESpRMjXviPOyV5RvFVWuBLl8Xk/VZGwDXwsXSOr6Gvm+6du+mbrGeiTtm7iTCXB9xB2VIY8JpJ5PYPFeZ0QI5THFz6Mq5C73Gaag6r5fxthDZWa9dSNAs63fZjXKmpLFh91kMqcP45rxPAuBj8frBfcJGpOZPOjIGs1iDUXPROuATAnvOriKbITIrjxkWmahh9sA9N+hZJoV8d/xDSFRxPK4Yle4PgEptp8c7S+kRwHISoT30KL9F7hOUberZfjTzcLlDmOxxBpcPQOmZWnQjztqET6l7/wW2W3LduBEY6Nh6BgefWG6vTIjpg72FgswBPM361kvn+mojAEMnn9FoLE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Txys6Aq1eV7LVvPeaRVA1EIy6O7whA8UOR32tbO1oncnhjkFCZ3yvH+dD33/e9IkgSyCIPZN7APERiGgyZAxEe2/ltY8i/Xx/RMe1k9bD410cgzDsunXZ43hpL8B8PJI5iFe8BWALt20TK3kjGPBEik3OzKhLUmm4ouv5YNWr9VL4veouPRPqA5mNUva1UpLOyuiCuT9U6JvRTMpyo5c8ju1yrkYx1EO7iiOBIXOfWo74sGoh97dXgJyH5XCZbt4Y75bbVqjP1LmBOXeKjsbnEOswqEsxZhDhAoGXiMoTJH7Ch9iKtD9iKkN4IPxCYEbE+mQ96Ix/jLBz+TrKhy1UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922D.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ef36f9be-2f40-4630-6d51-08dea4778c2a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|36860700016|35042699022|376014|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	MIZibAQNYHAdoTxl4KdNWhpJajxFTJniQXTEUmKWp5hQj1zt0ARy0WlcKEe5Sgv5Mve70jrTfMkMRkbNAZ/DNpb/hHVR6oZQl6f35u3N7t0surZZAIgHTTsrCW4Yht9zpOvwY6NV7c9XStrzb7z5vBu3gNCAqYAAasA43iSc5Eu0b03MXZAwoqt++tbEHLlRC/kPTWNFyrg0/j7KdDnJbVmqmVUfNeQSNUhrkWIPvv3faXvAxmNT+8v6/EbAEp8D3xtDjUrKG9roOuq/Ksja0XXhZYegA3ZSzcwo7IBJUdaJC/ICuyWzTpgbD5wbtzjNgaakCoO8D9mlew9bDAP5RGP5YDJOdGo7dugezO+gW8Mbz9pEMneLkN1hgGTVUbSmTs/l22QcXu+XxsZQ5mf3ug5sl/j+KwZU+nxVKK1lf86EXPB13ZiBgnQ6X21cqkpsxurhaW7FG44T+WUGvRMqft4+aEm3WJq99r29nVPeS32cgwPcDF6XPdL0ZEtT9+L31lIKjsFQ6pwcmjTWShPYX+HSMbxvQq9YiQBQxg9Q4McAtvnmsRG4La3uOtSu/RKmezNSjSKJzZVApoj0mPAXrLmJqv0ioyZtaOH5C4V3COvlE6efMustKr8/Y81CPrvi5rEQ1fPW6szhjsFACM1ObaTbKqlRCf8X+lfEcMexUMNDDXlzZlKufvfxzb/YcGDWrqtanP2wp4R+AYPbLqSaaq36x61afGXFLz01nXfCy+WNBGvd7pkckWpnV5es7CaoDs2hDqPYyljDonOWWyVN4Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(36860700016)(35042699022)(376014)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	m6Vcop/9NEgbevZtpn/BP6mcP2Dzc1HSaSoJjgomJeWdCeEoFj0iEIq1765oIIrd14XDj+CMszadP/VF8eb8obhVDsFV4wh60xML7noJRUoVpR6wdS0uF5lVpnCJH6Y+/jqnY+7hpQRFCx3YNdU6WfUfITHryCIO94RH9R/IA9ALIccaOdBjrEr9tbnFK6UdF9AeZXi8TeZdVaAS6BLkqi98xfWTnyqL54LyJ6OaoiOTYbjPS1ui6+d3a0OiRnmKWPBK0lc7VSSa2chOtvRWJOr89878mLbKWuDMZTxoty69DqXiFtBx5rg0J6svnyWF1TLQbQEXM72eAgK+6h7F7OfFE9gh2Y81qovVcSZFCAbHCSOSQOSLCcEe96JOQcyjrjQOWYKsrHiVtMvn7Lq509dS62txEJuBDtNVOCB0IhmH4kwE5o4xGfw5VI4sFGSH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:11:52.7985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 734ea029-4ea2-4eec-1189-08dea477b215
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922D.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9700

When a VPE is made non-resident and is entering WFI, a doorbell should
be requested for the VPE. This allows the VPE to be easily woken once
an SPI/LPI interrupt is pending for it. This is tracked by the IRS,
which will signal the specific VPE doorbell for the VPE once such an
interrupt arrives.

Requesting a doorbell involves calculating the DBPM - DoorBell
Priority Mask - which ensures that the DB is only signalled by the
hardware if the pending interrupt is of sufficient priority. This
avoids waking a VPE that can't process the incoming interrupt.

Doorbells are NOT requested if a VPE is not entering WFI as we expect
to enter again imminently.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 11a1a491b7e0a..2fc6fa4df034f 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1077,6 +1077,9 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
 void vgic_v5_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	bool req_db =3D !!vcpu_get_flag(vcpu, IN_WFI);
+	u32 priority_mask;
+	int dbpm;
=20
 	/*
 	 * Do nothing if we're not resident. This can happen in the WFI path
@@ -1090,6 +1093,31 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D 0;
+	if (req_db) {
+		/*
+		 * Find the virtual running priority and use this to calculate
+		 * the doorbell priority mask. We combine the highest active
+		 * priority and the CPU's priority mask. The guest can't handle
+		 * interrupts with priorities less than or equal to the virtual
+		 * running priority, so there's literally no point in waking the
+		 * guest for these.
+		 *
+		 * The priority needs to be higher than the mask to signal, so
+		 * pick the next higher priority (subtract 1).
+		 */
+		priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
+
+		/* Don't request a doorbell if the max priority is masked */
+		if (priority_mask) {
+			dbpm =3D priority_mask - 1;
+			cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_DB, 1) |
+						FIELD_PREP(ICH_CONTEXTR_EL2_DBPM, dbpm);
+		}
+
+		/* Make the doorbell affine to this CPU */
+		WARN_ON(irq_set_affinity(vgic_v5_vpe_db(vcpu),
+					 cpumask_of(smp_processor_id())));
+	}
=20
 	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
--=20
2.34.1
