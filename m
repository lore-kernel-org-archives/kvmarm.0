Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013016.outbound.protection.outlook.com [52.101.83.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E49437FF78
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747676; cv=fail; b=kOoHsRkYBpJYEDaVE8IzHXldiQqdgUt1PIcKvPMv6GPNAUYVwFzsjcKh0oT9Dm5HSntkpz6duy9QIQrG9u+u02ALijuu6H0mrAn0UzrxiDYdvukugYTPf7P9OdvKJHa+HwRt2dmTajWV86nqZ/rLJ4sDyP4VGgu0mFzun2XXwSw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747676; c=relaxed/simple;
	bh=9LGFgc93Jlgv3ot0xPW1gytVAZgN16axiZFxvye2DMc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BO+ygKzggm4iJgdUCmW1C2+TtCw7hfvUsoVh+GBxn+KJvh6ATl/euut4/ME505MkwSuK09BfORXkMEvczhE6PfJEJDsdr0r71izg05oEFz+jK37/0lT7O5uLZsPhhzDydRhIVu6MCjcp//OyAnTeXnJ1f/tKCTPOs20eQZ9hYOQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y1wXzvEK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y1wXzvEK; arc=fail smtp.client-ip=52.101.83.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y1wXzvEK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y1wXzvEK"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=URBdLUSAxFBMur/zeFxMNp7mUROf5kcIQGC8/kcpK07FoBE9BYqBqjjQnCjKGIYrQ4OnSDcJUBUIk/zZbPnFOZjr5pSagNptjLxOvk2Rw4vBNDgoRmioAQSWhxBbXTF+KVNGhBYMv/4PgSiTlKFdT0jhMYkWuJWCEIVEN/S/OS6r0ci5r9r9+7rWQOkOTXxXhaUCEuXoWg7VwrzhKhu1YzkEzF4DvyN7Mg2/odUyt8RIA/0lLMuC/OKr2i9+96U+ay3TWlxa7IJ264ifzWEX4Y0DZMW8OkzPRidW7moYXhYrBFQJJuSaJRMFJ7hzH3mmSsLs2Mrvax8ExhNLbIlIUA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0TimWbsw0O+Q0dRh8Q+SJCVx0uh4WYielnYafU9GHs=;
 b=Q75z1k9K0nRRCLI26mBstBmBGGrvoBFT8u6OJwfrj6q7EaGGfsif5/4sZdt5fQXFy2pDk4kvBj5kquhB52tJv+l1LP7WQcXT4qtCFoABm3VJW5BgoctpYYJLrsqMM4gqhb1H79bwUtyMbm5FZwtpy0aOMdkZoANLEH1tHSlx5KewIBx20V8q27iOVB9ltOmizodSJuT76J5cRPAsriEioviLQaacYftaHVKbBGGHLo67MgFebcboz3NP68IaMNwuAye3o9pVN5LkQa3GmUd95/HhlRtKFXQXtO5KRm87Z5IS5/HqfjJ0wf5rtqpfRCSX9K+jo2bVH7ooh6Zd4O2MFw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0TimWbsw0O+Q0dRh8Q+SJCVx0uh4WYielnYafU9GHs=;
 b=Y1wXzvEKjNYdyt8sUnI41KWHXwIX/g6tbxFbOSplfT87/JU7O7rgdnwEnjkaqy8zLaXaVTkaLPJvJ3s60WxYbdQipMthtGaJ5FzRAI+NG7/k2XsvJH8XUpk3I/WJZ6A6cIbc5hml319/0WitvQW6s1S/2WjVTMa3LrRcnqULyRU=
Received: from DUZPR01CA0196.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::23) by AM8PR08MB5586.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 11:41:03 +0000
Received: from DB3PEPF0000885D.eurprd02.prod.outlook.com
 (2603:10a6:10:4b6:cafe::e6) by DUZPR01CA0196.outlook.office365.com
 (2603:10a6:10:4b6::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.25 via Frontend Transport; Tue,
 17 Mar 2026 11:41:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885D.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:41:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RoWpaNhxJcckhIFnvRKHb63olXDJhdj0l1SO4LOkZvke7DtIMuTWnLt7oudyhOTJvOW4MheZcZ3WaXcH6T7puXST3XsbRHjUfy1e76OWTMZYyzm2distoGAVMb7PePs0RgjtAvXGedSHBWT0IvDX1FjPuLOoeEmEP3/jChJkrWjUPGr4TAu882txSmiIZQtAgL0o0G2OYtdN+wR/0wWt8tIfQM6CLowClDqlrAO4Q/0vwswCwuWF8agoidalESpP8WsJaAz2aX62dPhKUvDsdTYoI1Fjjt8dNT/cD3YL17BSVCDII5aoM7luoSQvBbjpLkd1U6GOzdFaMVdaqbcgYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0TimWbsw0O+Q0dRh8Q+SJCVx0uh4WYielnYafU9GHs=;
 b=c4h4eOasdw1DaZWKvSqCS4f8i8nL3ZWn5WkdDtFVBuviUJCHLWTMHSgGSn02Kvc26IdW6wzT2lf9H1S2ax7m/9b7+PHDvAXtt+dpZ61q0oYUmIeHS2TAdJrFbchq489VU5OJfCPyU6tWNELTCyz1sbUFcr5X8gNnVoYs9kCgpHtO3VfwLMtLX0fiyF43ITbaeUBNO+RKuPw/gmj8Qmx+Rs0oDBIuTeLY9kJG0uwlMF4zAr+63yviNW3sA6LPyXuzo/YKJgS/3HhbiGNmmWA6GHVa/MzNQYx3Dl/8z5NHOOsK0pMr7cJ5pegJLWct8rfwq+2KmFlZCUjOjm091BcsyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0TimWbsw0O+Q0dRh8Q+SJCVx0uh4WYielnYafU9GHs=;
 b=Y1wXzvEKjNYdyt8sUnI41KWHXwIX/g6tbxFbOSplfT87/JU7O7rgdnwEnjkaqy8zLaXaVTkaLPJvJ3s60WxYbdQipMthtGaJ5FzRAI+NG7/k2XsvJH8XUpk3I/WJZ6A6cIbc5hml319/0WitvQW6s1S/2WjVTMa3LrRcnqULyRU=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by GVXPR08MB11211.eurprd08.prod.outlook.com (2603:10a6:150:1fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Tue, 17 Mar
 2026 11:39:58 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:39:57 +0000
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
Subject: [PATCH v6 00/39] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Topic: [PATCH v6 00/39] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Index: AQHctgLH5M8v2shrQU+L+XKYTc6GqA==
Date: Tue, 17 Mar 2026 11:39:57 +0000
Message-ID: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|GVXPR08MB11211:EE_|DB3PEPF0000885D:EE_|AM8PR08MB5586:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a0e196-fb9d-4767-7682-08de841a1174
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 atsMkjDvHgyFVLmFchoMlIvjDqOyC9N5YtiXUKGKUy/iVNBbtpIun8pd3Ic1FZScJC28i5wiDUlUMq3thoFuc3siZU9CE3sRVVXCRiobm9rOSmb/QZ6ENvOLO84p3J9IjllD1L7rWK4n8XxLYCIpRJcmnrk4miGuf4U/epJJcxBVy7HZGjpNQHwlRJbPPP4/4iL84Ev4uv6pw2wYwuF3+ML7C6T84ZbHFWPDJPUyiXmWQOsl3ZRvfNB3vfhHXcVFiX1pVav/eDkaNEdVQHRdh1d4f8AFraZbZ4YAe5lWWg2ebpwd+V5+01u6+FVT8E39HevDuBWHoKY4s2H4Se7Q8iL6TXBZugQiN2ghz4cee5lE+PJ91Bd6OyYAlrQ3EK5GqlRu5KVg+3YAmeB5fvn2T5Yu+GX20hPRomQL1rG3zJ/FmmIAxVbaVcy+bOUD4nv6hQaNfWGF553Q+dL9AaLO3YKGmUktREanK1SxJkI0UR71fkfZTKgNvdSxPWfiSScnhfTC4Vivbs7+kjkvsyxXRb8uh1Oxcnvxo9ljEfCXj6yUEcDqIBo3J/7p8KxQo/tCOakWn07/iPm9aS/IW4Z037R0wMCBH2ef6k4K6v3VHdDkud1Pq0X1GHBAX0Yj7lxaa6UDkJGHBfkWXgvLPZJ0qDJOADmNNLUTGv0607Gu6dUk+WvGmxw3eLv0dG4YtKzvm7PNIyGPy50swirPZAtEZZt6CXOV4NxM704NPHSIKA3SdeAP3hiz86D5D5geH3gvWDPo/BGSrjkFak6l5ywDN0mg8GLd+ylL2BNdLb5BH5QF9VTCISGP1ywkD7/1ncoN
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 wfs1TmwBnhZG88xRmj75x5Xx+zBhmG8+rXdKVzknWvF5XLiPVuMQD8wAnUOVT26fGmgoXPg8Y/hjPxt8RSp1DItSLyEVP47KSKcpz+rrLzv6mO67/IEA7Iw+Sq/9Jv3NK+pRYpVyetzUSVlsQY5wzSU7P6Evnia3T2LDHH7GwT9JWgjRKpMLRJUnOLNBB2mCsav1N6TskQ/Rik65ukW05mI5hQEw7YXjxvzXIH2JyvqGWKEC3hxts2s9qev/Cp0U0xgB6AiNyCC7EGA8dot+OGO5oiB0D/5QRMdK2Q06UOQBjVB22QZyxDa9ZzY3a7W+P13edAdK87O68PC4DUkx6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11211
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	feb4252e-dc4c-4642-f04e-08de8419ea7d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|14060799003|82310400026|35042699022|56012099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	LCwVS+Mo8+GgJUamoUNxtGZyiTxBva3JC4qolNH7yz5TcwKmuS6+4x+B51Xqd5d4no6cwvnVT1PQB/BwkaT26aNK04RUA1Sxi9rxoGbsJWSMePofwdhlG+qgLufXRuLm4JRqXvFSt4uvm3y884z3sHNGyxSF4moODAEaNJp7XVC9O15ZfSP7WwQ8CHJL5IoY+ozmzcbr+WxVHvSklryRPjVu8MZYobdH0raeG7KedepRU2qhef+fxx8ruZi3ZwfYCFSJmlMHeIBZo9KHR6DvmRD8BHp2u1C+bkjEkYPKWLxbwzQwdmXbpC1F6QTWVXWikrKkntorbGUjlj5rhMvfR4ik16P7q5SeS/6knFeJ425nQTX0SddO0SyTvgGKzK+TDWZXzeDMh3SFyCAYoAhEf+sTMXfpKyUvd66Cagbj7zc96YnLPWCv+fXYaYM1phd+bpWdudHOAsA2PHJYGwSTljo46VeTk3QaF4drKXh1D4Jc2VS9duDPwAAzov5vRueppfgCwljVlok+1a066OsqUra9jO84gLLdt0AuykB0nMH6mtDQxzWpI5Ph0JK/mNvdUtBQsFT0TeJSoiPflit80/bGUmq171/NUggTT9YX6gsoekoJytOtJdcCWE0ZHPKEqIIjsYc6tlGyoKT7PP/FAmr9s2bbnrmyI6hIjvMvVW5g9vsA7Qqx9Ol8RN0+U7zwgdl8Rclyrf1h6j8cWryxi7Zl1q5fxIDx56UFR70Zbkaak5s1Y5YsmYBnqx/hnMsbdlVFlIvxRK+3gx1sM5FLgx21nbxq0j31PmzZA6rw/FE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(14060799003)(82310400026)(35042699022)(56012099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	w9xNiuHuDrDqMqmG2w5Ir1C9DxrsMDANKLCQeDNiWHFvRQpLfisXDQjAzaecypenzVPYNeNMJSpGc2sblJvX8Bjn/Scc/fm4+deW/4lncxtvHXYw+TDJeQJ6Nd/2dfO+rf+Fq7PNrLN4b4lrA0jUcyLhM9vFWNKRQRGydz6AoOwD3HpDr2Wv32WYXkiWzjWNTKQZ+v0mw9WJMhDbdlm2mtAqhc6pTiYMYB+sR3ca1kMTl7YxbiLmC/gyX88igRVq8cR4ZtNBt6Z5LGg3h45o7ry2vvhgX8lQrZ/oDbcQNHSuqzAqjtS/eeM379MS1sDURkSMEGlzndiVDoy0CpHkp13a8M0lwRfWy3RD0yXiXrdhgOzygRLIjZHFSy/3VSb8fTTc1vjBp8wsmszh2oMFxN7xdwbJlBb8e6PZ5M+LoQe+7E77bU7dM1US73qIOBV6
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:41:02.8855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a0e196-fb9d-4767-7682-08de841a1174
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5586

This is v6 of the patch series to add the virtual GICv5 [1] device
(vgic_v5). Only PPIs are supported by this initial series, and the
vgic_v5 implementation is restricted to the CPU interface,
only. Further patch series are to follow in due course, and will add
support for SPIs, LPIs, the GICv5 IRS, and the GICv5 ITS.

v1, v2, v3, v4, and v5 of this series can be found at [2], [3], [4],
[5], [6], respectively.

Headline changes since v5:

* Reworked all of the PPI state manipulation (with the exception of
  PPI priorities) to use bitmaps rather than u64 arrays which were
  mapped onto registers. This allows us to manipulate the state much
  more elegantly. PPI priority state was not included in this as we
  have 8-bits per PPI, so using a bitmap is not helpful here.

* Reduced the number of supported PPIs in KVM from 128 to 64, meaning
  that we only support the architected set and not the impdef
  set. Given that we only expose the SW_PPI, PMUIRQ, and the timer
  PPIs to a guest we were handling a lot of state that never got
  used. If the impdef set of PPIs are required in the future, it is
  just a case of bumping the number of PPIs back up to 128 - the code
  is parameterised based on the value now that we use bitmaps.

* Updated the core vgic code to use switch statements rather than
  if-else constructs, where appropriate. This is more readable, and
  maintainable, if more verbose. vgic_restore_state() and
  vgic_save_state() are the exception as the logic becomes rather
  convoluted quickly, and comments have been included to explain
  why. In short, the __vgic_v3_*_state() functions need to be called
  in many different situations, resulting in a complex mess of nested
  switch and if-else statements.

* Introduced some vgic_v5_* helpers to manipulate IntIDs to either
  extract the ID and type, or to build a GICv5-style IntID. These have
  been worked into the appropriate places.

* Moved the vgic_is_v3() from vgic.h helper to live in arm_vgic.h,
  alongside the vgic_is_v5() one. Both are now implemented as macros,
  whereas previously one was a macro and the other was a static inline
  function.

* Separated mapping/unmapping of irqs from setting/clearing the
  irq_ops. We rely on some functions being overridden via irq_ops for
  GICv5, and previously the act of unmapping an irq was
  indiscriminately clearing them. While this is not an issue for
  non-nested operation as irqs are not dynamically unmapped, this
  would have gone very, very wrong with nested virt for GICv5. Now
  mapping/unmapping ONLY handles what the name suggests, and the
  setting/clearing of irq_ops is explicitly handled via
  kvm_vgic_set_irq_ops() and kvm_vgic_clear_irq_ops(). This results in
  some extra code, but avoids conflating the two mechanisms.

* Introduced a set_direct_injection() irq_op, and reimplemented the
  GICv5 PPI DVI mechanism to use this. This keeps the core vgic
  mapping/unmapping code free of special case handling for GICv5. As
  part of this, also dropped the directly_injected flag from struct
  vgic_irq as it was no longer used or useful.

* Dropped the hypercall for __vgic_v5_save_ppi_state() and
  __vgic_v5_restore_ppi_state() as these functions are only ever
  called directly by the relevant VHE/NVHE code, meaning that the
  hypercall itself was never used.

* General clean-up some some of the commit messages to more accurately
  document the commits.

These changes are based on v7.0-rc4. I have pushed these changes to a
branch that can be found at [7].

Thanks all for the feedback! As always, it is greatly appreciated.

Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://lore.kernel.org/all/20251212152215.675767-1-sascha.bischoff@arm=
.com/
[3] https://lore.kernel.org/all/20251219155222.1383109-1-sascha.bischoff@ar=
m.com/
[4] https://lore.kernel.org/all/20260109170400.1585048-1-sascha.bischoff@ar=
m.com/
[5] https://lore.kernel.org/all/20260128175919.3828384-1-sascha.bischoff@ar=
m.com/
[6] https://lore.kernel.org/all/20260226155515.1164292-1-sascha.bischoff@ar=
m.com/
[7] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_ppi_support_v6

Sascha Bischoff (39):
  KVM: arm64: vgic-v3: Drop userspace write sanitization for
    ID_AA64PFR0.GIC on GICv5
  KVM: arm64: vgic: Rework vgic_is_v3() and add vgic_host_has_gicvX()
  KVM: arm64: Return early from kvm_finalize_sys_regs() if guest has run
  KVM: arm64: vgic: Split out mapping IRQs and setting irq_ops
  arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support
  arm64/sysreg: Add GICR CDNMIA encoding
  KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM headers
  KVM: arm64: gic: Introduce interrupt type helpers
  KVM: arm64: gic-v5: Add Arm copyright header
  KVM: arm64: gic-v5: Detect implemented PPIs on boot
  KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
  KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
  KVM: arm64: gic-v5: Add emulation for ICC_IAFFIDR_EL1 accesses
  KVM: arm64: gic-v5: Trap and emulate ICC_IDR0_EL1 accesses
  KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface
  KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
  KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate mask
  KVM: arm64: gic: Introduce queue_irq_unlock to irq_ops
  KVM: arm64: gic-v5: Implement PPI interrupt injection
  KVM: arm64: gic-v5: Init Private IRQs (PPIs) for GICv5
  KVM: arm64: gic-v5: Clear TWI if single task running
  KVM: arm64: gic-v5: Check for pending PPIs
  KVM: arm64: gic-v5: Trap and mask guest ICC_PPI_ENABLERx_EL1 writes
  KVM: arm64: Introduce set_direct_injection irq_op
  KVM: arm64: gic-v5: Implement direct injection of PPIs
  KVM: arm64: gic-v5: Support GICv5 interrupts with KVM_IRQ_LINE
  KVM: arm64: gic-v5: Create and initialise vgic_v5
  KVM: arm64: gic-v5: Initialise ID and priority bits when resetting
    vcpu
  KVM: arm64: gic-v5: Enlighten arch timer for GICv5
  KVM: arm64: gic-v5: Mandate architected PPI for PMU emulation on GICv5
  KVM: arm64: gic: Hide GICv5 for protected guests
  KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5 guests
  KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops and register them
  KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
  KVM: arm64: gic-v5: Probe for GICv5 device
  Documentation: KVM: Introduce documentation for VGICv5
  KVM: arm64: gic-v5: Communicate userspace-driveable PPIs via a UAPI
  KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest
  KVM: arm64: selftests: Add no-vgic-v5 selftest

 Documentation/virt/kvm/api.rst                |   6 +-
 .../virt/kvm/devices/arm-vgic-v5.rst          |  50 ++
 Documentation/virt/kvm/devices/index.rst      |   1 +
 Documentation/virt/kvm/devices/vcpu.rst       |   5 +-
 arch/arm64/include/asm/el2_setup.h            |   2 +
 arch/arm64/include/asm/kvm_asm.h              |   2 +
 arch/arm64/include/asm/kvm_host.h             |  34 ++
 arch/arm64/include/asm/kvm_hyp.h              |  10 +
 arch/arm64/include/asm/sysreg.h               |   7 +
 arch/arm64/include/asm/vncr_mapping.h         |   3 +
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kvm/arch_timer.c                   | 132 ++++-
 arch/arm64/kvm/arm.c                          |  44 +-
 arch/arm64/kvm/config.c                       | 123 ++++-
 arch/arm64/kvm/emulate-nested.c               |  68 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  27 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  16 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  15 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
 arch/arm64/kvm/hyp/vgic-v5-sr.c               | 166 ++++++
 arch/arm64/kvm/hyp/vhe/Makefile               |   2 +-
 arch/arm64/kvm/nested.c                       |   5 +
 arch/arm64/kvm/pmu-emul.c                     |  20 +-
 arch/arm64/kvm/sys_regs.c                     | 176 ++++++-
 arch/arm64/kvm/vgic/vgic-init.c               | 213 +++++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 107 +++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |  40 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |   2 +-
 arch/arm64/kvm/vgic/vgic-v5.c                 | 492 +++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    | 184 +++++--
 arch/arm64/kvm/vgic/vgic.h                    |  53 +-
 arch/arm64/tools/sysreg                       | 480 +++++++++++++++++
 include/kvm/arm_arch_timer.h                  |  11 +-
 include/kvm/arm_pmu.h                         |   5 +-
 include/kvm/arm_vgic.h                        | 191 ++++++-
 include/linux/irqchip/arm-gic-v5.h            |  27 +
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   1 +
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   3 +-
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  | 177 -------
 tools/testing/selftests/kvm/arm64/no-vgic.c   | 297 +++++++++++
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 228 ++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 150 ++++++
 46 files changed, 3209 insertions(+), 382 deletions(-)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c
 delete mode 100644 tools/testing/selftests/kvm/arm64/no-vgic-v3.c
 create mode 100644 tools/testing/selftests/kvm/arm64/no-vgic.c
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

--=20
2.34.1
