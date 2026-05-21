Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013029.outbound.protection.outlook.com [52.101.72.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7807737207F
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.29
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375042; cv=fail; b=nTuc+gbarum21EcwTR7mmQHcSDjsORn7UnXK6eWEOfo5Ni6WaEJED/OZ/h4gZYjBoEU2GsOQAfilWzFHsIuG5s2K4r6c3RqSh/Eht//6fLlDOxNsawwy8VJHGmFJbZ+Bqbia36aTLyRKbv9oLNLOMEYlSXv+WSEA5MCWhwzquE0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375042; c=relaxed/simple;
	bh=gRMtJJ9UD+2AvEV+NJoH0+PX/LBbR14BH7VnhJajCcg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g/ZNzXqmJzgySOUnrbMubgG11K27RA0dzc3DePonyyhmGvzev4d9L3kdGzyq58FRm94tMb8EVfeCnwK60Dlk1F8mdiIu9rRx1QIlJghen/nTKdDI2rt2G8jChzZl2U9fsY1yFF1KerwgQdozYR6JNkh71zAmPzJEpLGtwH/PlRM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=awiYRRji; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=awiYRRji; arc=fail smtp.client-ip=52.101.72.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="awiYRRji";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="awiYRRji"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=iQlYAKJu95Th6s4+WcZbfrQP/3KRa2H0riipjnrsDogHvu/H9jZbDoAMk7lD1k35UUa6ktZvKFfyofqZUSEmCEcn9X03LHjiOFZwI9A9JcsunMWCQLAs1FuGlzY0PpHd6hQvlqsA5OiX54WuWzJtj+82/yiJ0otCw8txBxFRPuBOLgt6H0bDMgGF7YNMYc4+Ilp+63StLRvuz+H+t2223LNz5SvNxN6TJpLtRW3elBu7YAbOx1gZwBgzrerHJoWt3m42hu6f2E/ApGM2DlqhbRJ9SymCBQlQ9C/rmeLQdgZeVxMuO9FjF4G0HAT3nlvm31+NJvhK6GW/8InZNFUH8A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYy/FAMb8xaLedMpazeUsqD61rCuEuA3GW0xEQ9dd70=;
 b=VxYPa8deOMjiVMKlkmbClYU6qNh/5oC/Knllg1v9EiZ8KkWz5rtPidwxnCRbAWOiu6Y0wF2hJy/Z71QOWPLeY/9blpnOpF31sQggSjto82Ch3mBy1zC3lEOT75+xbAwE+hVslkDUaocY/d0zOHa1W8gAXwkozSCmVmLJjzexzaEJbv8CEaMA6pGW37JJpOktg2RtPGT4ukxVvOAajHo3hXwLux7HV3E2cyk9tlbtjhzzVTVaH1mx5LA3olxSBrxUc0pQFEpUdjGMFlURsYjXZUBNiByETw+wkL7s40e6UiFTfZvhrfl3vo5i8XtBDK/Oaan3rcPZe6+43wwCCJLZww==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYy/FAMb8xaLedMpazeUsqD61rCuEuA3GW0xEQ9dd70=;
 b=awiYRRjit6Vy6Nz+V9ISOuHFjkP8m0itbYArIZ7UdeDoQ7DL3SgVZoHPQJmU14mvOhhZjBjv11ry4xCrOjoR0pzMthINjJrxbKqC2VThRUnPHm0hLmPPV25bQGkFicGSN4msCG6unUibHd8fow99tVLbL/sfXKaxZseCRmK0MTE=
Received: from DB9PR06CA0019.eurprd06.prod.outlook.com (2603:10a6:10:1db::24)
 by AS8PR08MB9838.eurprd08.prod.outlook.com (2603:10a6:20b:615::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:50:31 +0000
Received: from DB5PEPF00014B88.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::64) by DB9PR06CA0019.outlook.office365.com
 (2603:10a6:10:1db::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:50:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B88.mail.protection.outlook.com (10.167.8.196) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:50:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IZRSJghKjlFs79FndHlRNLZMERy6Qes8Z3A0ICBeji+beMWz5WRA/NC5NejKuiOZAVIveU6gflFAYcYKb/dLRxNs4w22kTn+fRN1c57B4hzAicnPyQD0XUANp16d2T8D3bxoQVSYOF8nrmJjOg7cqxNgfjrxNHwqPuVf6AeNX5XM2qP0i5E7cDjr7ravy0KkEPFtUf8YndioivktwgXoMA/r2WA9NqTfroMyUY+jDWxlxdP/EOM+WcvaodNKwqwmZwzv9cUV8/4lASG9+WpquYi5t82Gj5MR6D73v1ItmTOWrB80bnTt9P+7ZXhLpsD5BH4NuceziCsh5BbyH2vvog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYy/FAMb8xaLedMpazeUsqD61rCuEuA3GW0xEQ9dd70=;
 b=GDpiIOq+xf7erYm+lsJmQkiFMVHpZ7UTHFEb8SiQdmJIWOydDs5Q+KBqi57B7nEUL950LqStjdiJs94RcaiZQpsVndVe4mn5rMsYmwqts0I/WrxIFIqkihBf+TUKvRjICiZL59vulCwC+EuVzPPNT5GNRFA2lGHpki3saKsjrtdbMuUTPDNZjm8CXopcNJXzCvpOfi3wbk6BOd5M1de9k8HWMZq8i9fESdmYr5ndss8tKnNK++N7M1XULa+fet7GUl6HSAP3IzXfv7DFHdcWSGzfa90p47dwhYQtNzG0F8WyGFgnrImir7Zd/WluGztIfQUFJ4M/6RDrzmvDyzJLjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYy/FAMb8xaLedMpazeUsqD61rCuEuA3GW0xEQ9dd70=;
 b=awiYRRjit6Vy6Nz+V9ISOuHFjkP8m0itbYArIZ7UdeDoQ7DL3SgVZoHPQJmU14mvOhhZjBjv11ry4xCrOjoR0pzMthINjJrxbKqC2VThRUnPHm0hLmPPV25bQGkFicGSN4msCG6unUibHd8fow99tVLbL/sfXKaxZseCRmK0MTE=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by AS8PR08MB6599.eurprd08.prod.outlook.com (2603:10a6:20b:332::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:49:27 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:49:27 +0000
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
Subject: [PATCH v2 01/39] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Topic: [PATCH v2 01/39] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Index: AQHc6TEG3LEmKJAwQkuXT6YN23Dr9A==
Date: Thu, 21 May 2026 14:49:27 +0000
Message-ID: <20260521144846.1899475-2-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|AS8PR08MB6599:EE_|DB5PEPF00014B88:EE_|AS8PR08MB9838:EE_
X-MS-Office365-Filtering-Correlation-Id: e60c2b84-df3d-41a2-1244-08deb7484dee
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|18002099003|22082099003|56012099003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 m5lbZi6i0pWc/maAyxoAfYkQ0DNPnI+ra135OGYIZBxSbnBAgAS3NSBK4xzSxS299sT5sESaeVADNXa5DgzlnrNv9o0s3NkxFHjXAJDzZObimRtlX8VFmcE0NR9DX6FlP/GGXmNZG+mf5aNcRoywZ5nLnUDlyEdTkWuEPnGhoDe8OXM90zqWkyhzJXU0IxotRIXXer6XMzRpzds680rvHx0Rma7wRufBVJhQlvuWEujVaDuib/8OfMQtXUiXUxUIlqFYeOQ+fzs13R/5Llw0IPGfqgdKAbqRvZxoV/ALIwXe8o002B9YTcRCOGKSRy4fRZvKpxRr7pyvVAKRbf2ibi0Zm15eEzzT3pDtGXGpMLfNo7hF7lMI7AOFB//qrCFtJRHnrgWvcDGpcZmm5xvpI+93iGR27lvNmO8XNSawE/FBtHpNr9k3URmNBKWtw0DS8CucUJ0E8Q2a6MM+LHxBRyZPIpiubbZrryCbsjKfYHFPWVv4+olFz5jM6pnfIGUUADj0/rIxKgZR+0bvNdhTFI5oGzsBCY1CjbjgmvwHw9OWPnyyrg7UGvR8Zvzs/V/bOtbtCmHVzS70taSKAVzuKJvja0weOMbmL5sZvWmqRNY1kB//jIK5nfyu/nUB01iK344OcvDTzgWSSIBvOiuulh/nze/M/vHEvhPtjvchxB/Z3gm1y209p6K1FbPQ2IEmweQrdW+vHyLoXerFGdveZj4Gk8To9UPXrW875mG9TcZIwbTuO5nAIvY8xiyLhoOU
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(18002099003)(22082099003)(56012099003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 I+Jk3I9MRyxhjQZ9SkoFUIyNbjJoMhF8oW92y1wMpNvPU5jkuoDCxPPVJPiNdckhmpsGYe98F5z+AlrTtp4/fN1ZP41E5b6pBve+/73nluxB8wvF32LXHVOOzWC5FpeBiepywBLK31+y1lGzjiGiQMzk+V6DYe24g2+ad21u+ftvpI6zoxcbNHAfywDV1nyYV8rRnHLOkyjeQfyOXfIYmgXwztBYogHt72QI/VoR+nbwK6WAGAC/cyOs2YWJeCKB1MfGUCKY7+m8OgTZvWKbdJUCZ5ASKMeq+YZkD5KTyNBvt3q0cLJzMALuw7rIVBTBbRO5XIdIdKr35EN19ibzUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6599
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B88.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	05cb843f-e6d9-4b70-6e73-08deb7482887
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|35042699022|14060799003|1800799024|5023799004|56012099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	rD0HkdGvp9RMStH7DuIpqghH2ezGWnbU+h3jgFDJxT53g+Rz4eUiSw99gEwiQ7SGZrAxYAo6KCD31ssH33zgorCAQNNYM3b1+r3XMcpwzABGTCx4ZpPhAJMh4tNg3T5c9keBsKO3P8CnZaIAbau7Py7a5ZxcOoRgO69K+OiZ83QV3vyzShsZYIwP8ClY6UD09HstOttwFmT1G8vlozHr+bEzsT5Bh0Cfzl2iRW9fjxoSpp663sSXS6NuoqHjRTh1nsDORdhcFvByqduQEaCFToS2K4vqjnmAXnAXvdFspu5TrgZI+tUTEZV1ag/TjUUVl/sbF8spHl2rMoHH46DJLl4Xx8TrkbucTIcRPvdE6RKJv8AEMWk5A/0gn3xFFAzV1XawWvGHTmw73h/RAC4kyNZ3wLY7RemYWdem9DMPSwXAAW7Mg5Vx5vKSQX0cPvxEZY1oywZ7fSoQ4IT27DyH96pBskA/hGBWbug7BuCbnmBeJZihM1+tHVqm4MZoeJB4vuBuz4u1hkAHMTU9ZDJu/UKe4EgKTtB4Ld3A4W5q2GHiTCwLAm8Cj7CIzO/jIUAHw958XGWK4LFsnkQ1DoXRPuLCfNYRpfSA2/lyJ/tPZFXk34UUbzArmWZHP+Ojf8h7A1tn2/BKgJvGmS1apatqEJjEkbSDe6Db2esbIeO28uWCT+LxFanVCMLmLqYcDGPVOKRrE7eqBvJDXGvwKEZIsElhqygYGlj6i0XBOz4Zdao=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(35042699022)(14060799003)(1800799024)(5023799004)(56012099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bz2CSYK3mGTqEQ4Y9xc+Wq443clZEgR9AcCNrV8eQ75bOH1/wo3F7JG4+jU+qrZFbpiKmDOo3I60SvVOI08r6SHsCZ9MNo1DRCCOWMXC7S0oRiZr3vt1SXNX/IXVmpqk3av75o4yMdAYkAtTaPyEMKJzpWYFJkQUfzU1djFJtBcGCx9EJveF+IsPAQzgcTsSj9S+qgKw6F2XtwkCPq0KAiEdn9iZHAWCdYDxp/dAdS1UapggPBeZvPiAbPB1edOmGqmF3cRb4melt3v473R/D4clnsigJJ/E0igBH4gFW1uY8V8iWR6HsraF/TafNWKBZnNvSEpjEOQlWZlxLX8Y85TExFind9PoNUQBMgdSG6QmjAhs8RhpL8ztbhE6u+29X/+TQyQdawesi9EMSOcLekPrnJal9aBoWAK/is7v536V+z/WJgu+yQLDGfo1ER0k
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:50:30.5156
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e60c2b84-df3d-41a2-1244-08deb7484dee
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B88.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9838

GICv5 does not require a virtual CPU interface maintenance interrupt
for native GCIE operation. The interrupt is only needed when
FEAT_GCIE_LEGACY is present, as the legacy GICv3 interface still
relies on maintenance IRQ delivery.

Stop rejecting KVM setup solely because the maintenance interrupt is
absent. Parse the interrupt if present, but if none is described and
the system does not advertise FEAT_GCIE_LEGACY, tell KVM that no
maintenance interrupt is required.

This lets native GICv5 KVM support be registered on systems that do
not provide a maintenance interrupt, while requiring a maintenance
interrupt for GICv3-capable systems.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index e9d1795235a66..600726b5c0a46 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1141,12 +1141,19 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 	gic_v5_kvm_info.type =3D GIC_V5;
=20
 	/* GIC Virtual CPU interface maintenance interrupt */
-	gic_v5_kvm_info.no_maint_irq_mask =3D false;
 	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
-	if (!gic_v5_kvm_info.maint_irq) {
-		pr_warn("cannot find GICv5 virtual CPU interface maintenance interrupt\n=
");
-		return;
-	}
+
+	/*
+	 * We require an MI if we have legacy support, but don't, otherwise.
+	 * Given that there's an existing flag to convey that an MI isn't
+	 * needed, we (ab)use it to tell KVM that the MI isn't needed if we
+	 * don't support legacy.
+	 *
+	 * The check for ARM64_HAS_GICV5_LEGACY explicitly doesn't use
+	 * cpus_have_final_cap() here as we run too early.
+	 */
+	if (!cpus_have_cap(ARM64_HAS_GICV5_LEGACY) && !gic_v5_kvm_info.maint_irq)
+		gic_v5_kvm_info.no_maint_irq_mask =3D true;
=20
 	vgic_set_kvm_info(&gic_v5_kvm_info);
 }
--=20
2.34.1
