Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013002.outbound.protection.outlook.com [40.107.162.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95462C21C4
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094396; cv=fail; b=mvemNAo5OiqhUVX2PD7WWU/UOrP8wqmNe2IAXluAPvN6TNj0uePcEbGYQEk1b2b/Wug5WSHut5/1EnO5xoJFfQFmhqWk3r4PCg8MGT2jtPH41P+Sr+O3Z3SvzfwxRFA9Ce8uWn9FlhhZMfIAmQ0HIsIKzYLsBllL2gBCjwYrSHQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094396; c=relaxed/simple;
	bh=RBadla5Lr4GWGA1vQiJ6AVGd8xH0lkwmEXlSkl+vlQI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bBKR0aZ2INb/IzAAjSgtuSRI6re9tmOI8efq1wenPZ1PB9N09pGAKAg9/IGAN0BtAkTUHvGc3t3V8pWHxjTZ2QlProbAOCoBBWxBIuHk5vnfe/sh7ilLRqTzIRlaD2O4ZKj+OaN1S9zAfA5O9i3le+wbEbuh4D7dED4DyKQWTNA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QZWATwA8; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QZWATwA8; arc=fail smtp.client-ip=40.107.162.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QZWATwA8";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QZWATwA8"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=R/A0FCn0umMS17qBOESXqwfpkd6eo6iDozLWnkLcJ7qGwZ0aAbsL0CYFV/OK3nSKmshWfoAWc2GP4PL6CZFrLgfaVFHggOFhFRUI6ervPCU6dxWDk/aW6PUfhYy8SQFfV+50IPqpvAErdiKvW700g2KrmTtG6G+XGtPbiGqjhyHuj3jVluPuvyV0ie6jaPf2CjMxXnvygWjPHEYMH9C+QFtD8+AnnPBTqz2FyKq/JFwe2hQ7JJAllejptW9nSO390LvdX4SnsnUH7eK26+nqxRnJnP36jovMSecrTCfjZXmWlqpjbrjPom1fiCbO7fhPyo7w5dhI7oB+ug6Ea1NKqQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3hrb0scpwiNopyy8IM5Kv3KQmExNfZnhbG19vpJ+Jo=;
 b=BREYTD3t1xzVTJDxfmhlVkSRdpKvpuTZJYISyTgU2ASEC8or7okyQ2fCZ5qlzCvsZEJXgPhpLAd2Ktzf+5+Zd/rX6v1R7E+aL3OWAHP5jr2a/AkPV9qeBBoe5A8hrryTUqR7EgMDQlcq4JZ7+o8+/OQneYatIwm6+/EtGouGwQdgPrx1AubNsJGQSVID8MIsM1242FyOsFZLfYFOjsuVOizGo+3CWuuFU+qgUDSKxEr68waG9mIdFOyeS1DKZUJBuse/ESLH1T5CBWFsqrWg10SxgbXqx+G2ICcNPAABejx+wPKef+xRESd8PgmklPH1G8Ma/0UGM4denQEW2jGgjA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3hrb0scpwiNopyy8IM5Kv3KQmExNfZnhbG19vpJ+Jo=;
 b=QZWATwA8SguqSQ3Hibx7E3cPUS3o3ukR4ImOjClAkCxnGOO1LjNMM4fRgxmg9lqs02jHqz5dxCZk7B77pbWlttYLdVStttJdkdpfGw4tBh/Zt9ZSxdyO33YLPRaeL+hFuuKgkKdBrpg+f622Qpyh7gvUOPzJ1KbW8VdU/2GwiwA=
Received: from DUZPR01CA0024.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::11) by AS2PR08MB9047.eurprd08.prod.outlook.com
 (2603:10a6:20b:5ff::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:59:46 +0000
Received: from DU2PEPF00028D0D.eurprd03.prod.outlook.com
 (2603:10a6:10:46b:cafe::85) by DUZPR01CA0024.outlook.office365.com
 (2603:10a6:10:46b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:59:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0D.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:59:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vyh7CFBhF/5GtBvRMmtwfyXcRfDKDDnSf8iIAuuxYO6CwybnHX7KDRCb88jRUOz4zNG0vKhh1lPf54kcwNF2MuFxdHEdpePDzIsEFVt3CVwq08eZRugev2G4zoAriOsxKdgRy6dLMWLA5lGWU+LORi6QQVfnLz3CRh9wn5rgHvs8dvVpQkwt1y/NRyfuI+/wJwHMMmsNp5zhdS7aCjJjhWOo51VqYT1ReJvPMpKsLmyQeTnpBD7xwaUy/A54eR557soKh/hCP12wFxeuUZKn5wbFSSwNoxuuTzR9UELpcgUmA5RPalrl/bUNQa/mmfhPSMZZvXRhbCwhigQz0uQcVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3hrb0scpwiNopyy8IM5Kv3KQmExNfZnhbG19vpJ+Jo=;
 b=XCRYs/asL16AnE43sEGX5y+AsFoRnwS/FawuqMJ3ZQbB1cvsXTD4azr+D91sSzlsWY3Yc1agYDhfnYmGmT74RRa2GCPZw26dashETAxP1rAyUvciGHGDUqwaG611BF+iUp4/mrQYCeKdZ+AIbZdyWBUmtuW+ahVWCVStmXZlf4J2qYBFymuxALA1CEC5JB0WW21D2M28x2EnDf5JV8kh+CZ888BCIVc/Ibzf0KoyGAde5avJFG5FZ1qtx6fJszvuGaaNrbaGwioZHwrvUStMfXaELGqSOC/dxo2NRniOnw39qOX2V0FOA8ONW/NSnZ8M21EPCCDIm5LmtnLY6IVwaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3hrb0scpwiNopyy8IM5Kv3KQmExNfZnhbG19vpJ+Jo=;
 b=QZWATwA8SguqSQ3Hibx7E3cPUS3o3ukR4ImOjClAkCxnGOO1LjNMM4fRgxmg9lqs02jHqz5dxCZk7B77pbWlttYLdVStttJdkdpfGw4tBh/Zt9ZSxdyO33YLPRaeL+hFuuKgkKdBrpg+f622Qpyh7gvUOPzJ1KbW8VdU/2GwiwA=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:58:41 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:58:41 +0000
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
Subject: [PATCH v3 16/40] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Topic: [PATCH v3 16/40] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Index: AQHdCwTRbiDaMUH2wEOmPJ4pBCPjFg==
Date: Fri, 3 Jul 2026 15:58:41 +0000
Message-ID: <20260703154811.3355680-17-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|DU2PEPF00028D0D:EE_|AS2PR08MB9047:EE_
X-MS-Office365-Filtering-Correlation-Id: ae4944a7-df07-4662-897b-08ded91c1ada
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|18002099003|3023799007|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 fCr8rMoiNTLXQANaUE5Q8puFQ4P5nwE5oEBhWLOQ589cBxlF0JEnR5/KD7b7PsxivlNepO/WonQjW8FylWU8/DsO+4UZMrNaCXMMkvWZ4k/ibzcpgF8Ma2/nTowLBalvg/Y/EWI2webSTBavsp7/Ty9Q/oGY62GafjS+IvW4ZcDvevj46eN7Jq3Dn0yFiHuEwlLMSGs0Nq0HeVWk9VOiHT3QRHt3yjUrXi0OnL7o0SPp/6YVNvwZgSSnT8Y7kpnYAIo2ScgxbiOwatTk1HpEfVp6JrMILI3L1uVBJiJWjJ7/7kfw65xktrGWJHv9D9Cf1W2gn7QbZvOeABWrcL3fRrUQWeTkc0HhpB6LgkaE2qtBb5oaKjU2fDtZOtDeDT0whajFijG2yQXuz9zvIkaI7iHepw3M7VPv9M7QOgLWD+++qP5fY+S5MK1eOmWdFePQsotHEYd7gj8noKfR2x7mj95vXCQqTNQKaw3r81RTYdKQgbxtoD6gnXEdzJLdA284zLjw422x9qanHZzRvnhgmEcM5PWYKTVyrqUx3XDUOGSGFkCgMteGtTQYYyxw/KJSr9eGHniF/Fadl2uLRQ3uMHhRriCuInZYcWm/h+F9eADzSDp8/LnKUv1bw6oXT7Qh4kGbLQMut57MRWAUcKlpXn1ZwhXO95huT+z4XPcqmPaheqMOsvBS0g/uQRX2TLps0ThHDsh11CryICwi05awEsYZIQF4lhx6Nc/T4on9PEA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(18002099003)(3023799007)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 d5Z6GsVcqccdzq4XVhiTSdENpFFvE/HKQx3e9veEgWxT+QU7IBst2AuuXc1F/jcZeTV1tLe7LRHps6a+CLGFMMMSqcwr2kPNnPw0tXxBuw4uw14Rtraeb8T783+GDniQJeYUjd6gLYISXWwLClKtC5m0EIL9ATSxEZtbFv7bcW8GgOlReyfqXSDlidtlMivDXf3JpcDX5IXGKsL4/azvGp7MWDa0eHDQo8zaJmrTDf/Qki9cGofIykIxLRJX95edWFWdjApRMynJQgelwsSAvrlViuPL1I5gEGXeBRDVtOWiZqJFAyzoXWUEZ7VAmIkX56e3bwx8/bOJ/p4Z02OTdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	01ad818f-c30c-47e6-71a4-08ded91bf410
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|376014|82310400026|23010399003|14060799003|1800799024|56012099006|11063799006|22082099003|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info:
	Y+FqHYUFxF+8RrjcURnY8T+ZxSmofxmfiKJIUXgACdbYggD0oR/5Ve5dfC+0WUXNhAyDNrAWiOyz8Le/2ubzgz9BtlL0fR6sCx0mZFW8HlIAdWraxhr517kf2chvK4bhUP5UgJWQJK72jhjfssJJrfSCUPrxTBwXWQNzmpU67E3t3QGMGdo/eSyAKDg6wHgF4gRsioSTvPC7DRXvvrFZPrwCYrv0ymhHvXD7jl9ROUXEx0FCuZyXtD0sS1lNZ/GX4dOMcHzfh52hk752yjAqX4bi7XV7+OvJCD4HhNpKfOLhgv8GC14GM4zLFqpyfKTTqAsa8osK1x65Ab/gmopQDuIQNp25FP7axOASECZoZ1adF4IttyWknP1GmmrTNSmuqn4F3IcOzBArsJqUXwcsGfSLJAixss5eoZoXfV9lRBEc1cET3NJmMv5FzKoLmdNHDQu96YCOLSbkTR80jGG2cgPX2LkrBolM86y+dSi8ChUC6u6Fe23jgc+mpevSGyl7zm/G4N25czJMdHxX6VKzCH24CydiYDGhEz0qtgQ4oUNfqJ2IjYIwt7xO4kF2R/jAe/SivbNZO7Qn2gkXid2lg25VEaXqeVB+eRK+VyFbbDR7Qvx5neR8UCbfYj/fBR6ZDKt+ssQs1SIp3gQQERxWZEPDiuZOt3S8nniaMYbwoCuThtSoBX4pYfjN5YyeFb6GYDshhOASSy7S0ZdT99NbDA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(376014)(82310400026)(23010399003)(14060799003)(1800799024)(56012099006)(11063799006)(22082099003)(3023799007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YWlOSfTc/vRqP4OD4+BieOeIJl6ywOSPOXTzZoBA54Z+DefgslGjfeKRCaT/I+8lCPHuf+0leCcyQ/My5Mds8s+UUClnNACIHwFKZ89OWSyBo0HGQxq+8DWjS+UZoiGDvE14WO/tny8ReSWja/Bhdo9DidsjMH5/t0MBGSuoILzoHNDZdzuu98ueLCPc5XW6i/tomjOs9OIZF+jyybwnnl89NmJ3x8uemAMCRARzrTjHUmDhQQ75E5ly3LwWPhAqdZ+BSFpOuQf/Y4Oh8uAt8TW5svKrng6YPvy+5TovWpl4BdHrlWRv+3RT4DFXXc6UQA4dMv93oQHHYm/0Ds3FhCsW7PXuUbF8BL2wqlDOihMOjM7/04JCsKcUBI/0USPkvIzBa5FTIuIFOCvdevsckJTiVPMS0m928sjiV755pA1BYaQ01zdal9d0mIjvuC8j
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:59:46.4935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4944a7-df07-4662-897b-08ded91c1ada
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9047

When a GICv5 VPE is made non-resident as part of the vcpu entering
WFI, request a VPE doorbell so that KVM can be notified when a
suitable SPI or LPI becomes pending for that VPE.

Program the doorbell priority mask, DBPM, from the effective virtual
priority mask before making the VPE non-resident. DBPM is the priority
threshold used by the GICv5 hardware to decide whether a pending SPI
or LPI is allowed to signal the VPE doorbell. This allows hardware to
signal the doorbell only for interrupts that the vcpu can actually
take, and avoids waking it for interrupts masked by the guest priority
state. If no interrupt can be signalled to the vcpu, leave the
doorbell request clear.

Make the doorbell interrupt affine to the current CPU before
requesting it. This nudges the wakeup back towards the CPU that last
ran the vcpu, where the relevant state is more likely to be cache-hot,
while also spreading doorbell interrupts across host PEs as different
vcpus enter WFI on different CPUs.

Clear stale db_fired state before making the VPE non-resident. Any
previous doorbell notification has already been consumed by this
point, and clearing it before the non-resident transition ensures that
a newly fired doorbell is observed.

Finally, teach kvm_vgic_vcpu_pending_irq() to report pending work for
a GICv5 vcpu when its VPE doorbell has fired, in addition to the
existing pending-PPI check.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v5-sr.c |  9 ++++++++
 arch/arm64/kvm/vgic/vgic-v5.c   | 40 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c      |  6 ++++-
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index f064045a31aee..46992a6c2cacb 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -22,6 +22,15 @@ void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_=
if)
=20
 void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
 {
+	/*
+	 * Clear the db_fired state to ensure that we're ready for the next
+	 * doorbell when it is requested. If a doorbell firing caused us to
+	 * enter the guest, then we've already consumed that state at this
+	 * point, so this is safe to clear. Use WRITE_ONCE() to ensure we're not
+	 * racing with the doorbell firing and setting the state true again.
+	 */
+	WRITE_ONCE(cpu_if->gicv5_vpe.db_fired, false);
+
 	/*
 	 * Make as non-resident before actually making non-resident. Avoids race
 	 * with doorbell arriving.
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 9c383b6864270..6e976162ec3c2 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1094,6 +1094,46 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D 0;
+	if (vcpu_get_flag(vcpu, IN_WFI)) {
+		u32 priority_mask;
+		int dbpm;
+
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
+		/*
+		 * Request a doorbell *unless* the priority is 0, indicating
+		 * that no interrupt can wake the CPU up.
+		 */
+		if (priority_mask) {
+			int db_irq =3D vgic_v5_vpe_db(vcpu);
+			struct irq_data *d =3D irq_get_irq_data(db_irq);
+			const struct cpumask *aff =3D irq_data_get_effective_affinity_mask(d);
+			int cpu =3D smp_processor_id();
+
+			dbpm =3D priority_mask - 1;
+			cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_DB, 1) |
+						FIELD_PREP(ICH_CONTEXTR_EL2_DBPM, dbpm);
+
+			/*
+			 * Make the doorbell affine to this CPU, if it isn't
+			 * already. Actively check the cpumask first as it is
+			 * cheaper than changing the affinity every time.
+			 */
+			if (!cpumask_test_cpu(cpu, aff))
+				WARN_ON(irq_set_affinity(db_irq, cpumask_of(cpu)));
+		}
+	}
=20
 	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5a4768d8cd4f3..169a8664322d0 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1227,8 +1227,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
-	if (vgic_is_v5(vcpu->kvm))
+	if (vgic_is_v5(vcpu->kvm)) {
+		if (READ_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired))
+			return true;
+
 		return vgic_v5_has_pending_ppi(vcpu);
+	}
=20
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
--=20
2.34.1
