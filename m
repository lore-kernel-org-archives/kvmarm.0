Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010013.outbound.protection.outlook.com [52.101.69.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECA04963CB
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 17:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544209; cv=fail; b=bA3Hd+ymMo2o00rD02wpl6Qy2zG202+YbcCYanJ3S4dX+o84MgeVC9o8aHjob2dToFSul4usSwdibiMrab10NeaETaIeejdzdbdWZ1GP5sST77AkyvGPijGrTbHQoCKUNnxcXRdrKX1T2bml6ZC8s7LhWDDVWTC+8gzHslm52G8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544209; c=relaxed/simple;
	bh=++AfllE9Se4+GAZ0fEHc+WWJn49SiArk0GI2LQZ2jRg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QjTPWRZUVFV1Odi+Ql9Wu90gYP9YI+w0XzkhKDVVMiy2j/ofrtnjvEqpllBbslrRDj0W1Qo4tncgDkap51S7NaoDk+tE1BbOBt9t3daUvF068jKm771cmBYxvjq7NJtc314Vhp7XSrXfenMF6xOQZQ3MOWI5m59ymQZDUHTaUKs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H/GTTB30; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H/GTTB30; arc=fail smtp.client-ip=52.101.69.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H/GTTB30";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H/GTTB30"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qJ5SXGm5iYxE6Wwwk4UL611V5Kkq7pZsYG/SjxY6vSVNn6ryfDTA2h8Vwe5sgAp6wJsLZbd05kTDKz/rCelrbq+1teA5AwIhlMR8xKgK7i8roMqayDeTjf0DlAZKjqhuCZfXFfFd7UDs3ebYySIl9TyRyp4Io03KwMVsnzK3sI449qU+i8OoNznN/d0MeRPLAO6XHdLYy/4QrtJDXe7AmTqEXt3x3KDVyD8cppwMEeFBDAJk/sQkMLKNOkImj0ZkHYe5tkWyoYpd7GxcDhvlD51rElUk4JMb4NHFiCVLjXXubnGNldF6EgGmwsg0WaZ9FwjuHNUuWt0jO0+htTszcQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mj98DHg39Jfg5UGlMajc/Mo74fKX/ru6LzZsdfR+fEk=;
 b=MWd6+c4sCI+1ZUDGWsV+9XrUUz7BdRP3DRUKDw3Io9FdRa68qZAWygSAilu5Mf48J2e+VHv3/KxzDe3Y3uevgTyYULlON0v4hPdh2NnvKSPjJUvWGy+lCs7U0I6pQ98rIsRE15hj2fw+hZdCKKjCgO4hRoRrN+OW7biKt888aAeEhsW6iIqVNLERhZWUUzz6KkFsCsDMzKF5bexE1oc/AJ48tZtTttG4MMyjNHIExIVfr/D31a6vrmE8ZMv6c3EuM/KUZlZR0hZ2oRejyIKSBZnK38QTY8SCoHICQ415SSOczRJBRKzZRueK18DWMFHrB3HiTsL4moBwqImLj1Qfvg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mj98DHg39Jfg5UGlMajc/Mo74fKX/ru6LzZsdfR+fEk=;
 b=H/GTTB30+zirNYYUtDsjT9pE1Uuem4YfG19WOCN9dOASUxCqtwXQhQCoRCDbzgKsU46Y0fwVe54Injn1vP8ySV6HyPpFRjo8ure9ZouQrKmxUup0oj15IZC5u/A7LhKUeTWwcg5hfc/0iFneO99LWgyzIK1RVgurvY7uxnhlehw=
Received: from AM0P309CA0002.EURP309.PROD.OUTLOOK.COM (2603:10a6:20b:28f::28)
 by GV2PR08MB11369.eurprd08.prod.outlook.com (2603:10a6:150:2a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 17:50:03 +0000
Received: from DU6PEPF00009527.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f:cafe::66) by AM0P309CA0002.outlook.office365.com
 (2603:10a6:20b:28f::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.4 via Frontend Transport; Fri, 4
 Sep 2026 17:50:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009527.mail.protection.outlook.com (10.167.8.8) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8 via
 Frontend Transport; Fri, 4 Sep 2026 17:50:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=meNtIMlVFRieFtKXru+qM/xD3p3bJFESP1l8NIytWXa7hJNWazWNJtssINM1ScKtEPgXIPPEecyPLNgD81KWMBxCeWq8bdMI0Esq6IuDRFmPOriB7KY0Zq2lUmQe0HBtvi7+5jPXgOIUPLMbH/VRFKIVVV3SNaEbUKYcm2m+l5ExepPZK+ACEQib0WIDUEA49/DK6tM4CgxVACb/hCcTaAnjwadR6Bq0nYvye8SJZ1/Jm6XdgdB+PDkWWA9a4JT2yg6Bh59trHkye2+E8RnsmDz84hFChzLa1Adn7m4jwsQ1f/HG/Akk2e0mxt6UL3m/vgr4fxJjw8V9XAw03FagjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mj98DHg39Jfg5UGlMajc/Mo74fKX/ru6LzZsdfR+fEk=;
 b=AzIAMmJwaJHRh7f+wDcuiHpO1WBuxGB6u1bPY5PGqhynkNfi5keCzuULPfk6auAW0E7qYKn/VeZehR80AeUv64mpJyAevipcd7cYaniQkmf4FfEQNJ/zq4wcFKJBVxApkK4nPTNwhWk/Ghi3FmTS5XFKoJS/hksIQ+y3gcLaN/TZImC1tnHfN7CfMqDbwo+sE9Qv2plNeYSobldJMI+LcDH6kkBwUCLaMmZqUbKlX6SAzKJwP+pfdBTQmzY7UIEOfP7YuCTQmSxl1NV4mPzID8jfiyqUPa9FOb6R5a3Ii8SVIuzVmuu+R5UmfFPyRCX1vK+VUDv7oNlvTxonpgkDog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mj98DHg39Jfg5UGlMajc/Mo74fKX/ru6LzZsdfR+fEk=;
 b=H/GTTB30+zirNYYUtDsjT9pE1Uuem4YfG19WOCN9dOASUxCqtwXQhQCoRCDbzgKsU46Y0fwVe54Injn1vP8ySV6HyPpFRjo8ure9ZouQrKmxUup0oj15IZC5u/A7LhKUeTWwcg5hfc/0iFneO99LWgyzIK1RVgurvY7uxnhlehw=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS1PR08MB7633.eurprd08.prod.outlook.com (2603:10a6:20b:475::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 17:49:25 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 17:49:25 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: nd <nd@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "maz@kernel.org"
	<maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: [PATCH 1/2] arm64: sysreg: Make write_sysreg_s() select XZR without
 optimisation
Thread-Topic: [PATCH 1/2] arm64: sysreg: Make write_sysreg_s() select XZR
 without optimisation
Thread-Index: AQHdPJW50kSTzPVnUECqFDkURSz0tw==
Date: Fri, 4 Sep 2026 17:49:25 +0000
Message-ID: <20260904174855.76185-2-sascha.bischoff@arm.com>
References: <20260904174855.76185-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904174855.76185-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS1PR08MB7633:EE_|DU6PEPF00009527:EE_|GV2PR08MB11369:EE_
X-MS-Office365-Filtering-Correlation-Id: f589c89c-304e-479a-b585-08df0aacf26d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|10067099003|22082099003|56012099006|11063799006|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 lrpqGTzCK6gNxnqDTkrpXEtGTb5h3J33o4lKOqv0rh46vWD0XZgKpYqXXwCmoLTmh4BddoSLlnTd80kiG7im674WBsTo8sLeJiltXMvxIvmdoU/OQEPlTNUWyaLaL6lD28UgBy99CcxSr3ByYf8o5pwkw1FF0khusmF5VfLhkGRiA276p9mCGk064AYy5avhSWlhWOakeDaj6xDBzrnY8aWI10b7oi58JQqLcqL07l/mjwdoPWZpSSlMgOAoz0jCyIZVQOFtQw/av1zjec01MjLCvtIJS7b8o5cm42zokP81xv+zd9zm1slo83/YckLHpmTRrG/yeW3EXv32oTWKbsQl6IPHnQwtikoPb2PXGQJXWnjvK09MywabcM3ovBIoy/JztCsyAzXxRiNXZGeoA6oANAzmn1nXG8RjO7et/xML7bP02j0cNvBDxig160hUMzXiHaOsM9Y6SGI2JcnOsYvxURU7ANGHp4gD8PHryLsa8QCL7ToQt5D2AXvr9m5on8wK4e0oJRUKtmLrgaOAzGgoPo8YRQlzPA7oehDoGZxlqB5qZ16NXjBxfWQimrbBDb98Vq0+jVcgyrpq5BC0YwjanC3MaG3y3/nn/JpGEvwwZtLubLOlqRZMTMOKJlezWE7WGNdlWKJ+xPgiv/FQkFxfacIyYgbIcOFftZKQW6SWkSSIw+qvMT9EIxfgm+DpXPRVnm4wV2jBLdw32f1j9LLQawAxp6eRa69kkY3WiR0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(10067099003)(22082099003)(56012099006)(11063799006)(3023799007)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 K3s6Jl/5NDw6AQKvVh6G/dBXDhMJV4iz9D9lAHDDdV9ZiNUR8l4XVGmkBVw/iMVT+/T5pRtWaS6QkxqPGta8KEnfPyEmDzekcSGEi7AT3K0RNl2HViCydQW9w+ytXpAE2PgRb1sYtJNo/oDeLtTLoe0/WwLLK0aChIx6a5lm++HzPw8LBIW0Sr9v7eWnt57b+yXk8D2yZrJd64Tz51Vc5WHLpz7LRrmk/1GYA4WROxbRm4HQeguqyCtNlxrcKK2LhJYsGUXC4TOQ1d1JjDSfrO+jOuHsJLktCb7knvfEaIRYEKk3i3+0obZY+ZplCU99gCFqsru8lQjjNk+W23R9jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7633
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009527.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3383c122-9558-4c26-7df8-08df0aacdc6d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|14060799003|1800799024|23010399003|35042699022|376014|3023799007|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	t8bP4BLeGQGy7ttHgXelGn/gL6sP3OHtfJNNzyWJyUF4gGMcCB6F69CDwRuiyKHi3nFVM5KOdfMWWh1xXncHzUCrxPX4/HYUD2OcQCWOKTrHYYlmSmQOBAqvQfsfxyUt2/DRPgqwXp0VJlg+8GGCO72rnvjVZNH6c6YewyHTsmerVppWLfeHtsc+fym9JLyOjtiCbmq40oMRD8vu3GgALaglNtbIEGy78JHGwTMI9LhCd+q0HVjlF9iewuXJL4gRGrJmhz+VeFnBbnwCWImTwdg1zGW3JjVJK+/Bz6cqP9SJ0h+vFL7J3QWqCWV5foeydj52FOaI7C06sgINaDI6YBxtu26KI2Eq0mNIUgai6Hb4IUlg0uzJVQ8gIayiaqtwk9SATx2JrvcvbQ8fylRnl5qll4KvJg4Pi98+G88wg46fkxJLL8ZJ5cND1SflEj58YyH4upMU4KaBfwfp5q6FH0NlNqUvrdkUliE4Z87sTOtrkAKOC8KotTMEGaxFaSZbIGdm8EQozSlPd6V4W0s4q4PfK9u1Y9d7FnFwvxYrxpsN0pByYxu6ZJazSicFdIVixxOSH1V94WAOFrI40IglzrTWbKfMrMVeu+VSUXnObMVCxx4NZKu1wZketMFcKO0JYxYhfC9Zqsel01U/SMLI66yStj/b8ZdQibs01yvnfnE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(14060799003)(1800799024)(23010399003)(35042699022)(376014)(3023799007)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GR1yiNlrfOmxIo7/3kgE5k3wFrBxuenWEi9abRMPWDgMXTGcxk1As10lhymvR2oDWIE6+wyhGH3TjCZX4hCQ/CgFnFGuyXNq9t/Pwnk/pVYx2+PTsKU0ojgaDjlmiEbhBFDPb7BOZdvwanck5XtOfi2tjxZv6mHLCJyamX9i+rhHp+zO82Z1SAs4pqkx7XDP2pprmFFS9HO3EX0GSBoJne1iH5WS1oDvdhatsPC6rQVVAX60uhEpbzryi+eLjuO1j/9MVVh0nV31GtpcfSPjPc+9aS1ntvaVT1Bmda4Em47UquUFIDsLseti8NNjl6PVLUl3LGYG8Dz8C1ngT+HQVFiOLoncXNQJBbWR3I5ePPg+DgFJqcA4NVwWWdqAhZ7SzPpo9/fW8kpAxjdIeMaiqpLGeQof0s5KzdlahIsKb6etgrSP8IQ/mrOoDUdNDNDR
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 17:50:02.6686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f589c89c-304e-479a-b585-08df0aacf26d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11369

write_sysreg_s() tests whether its local __val variable is constant when
deciding whether to use XZR. Compilers only recognise that __val was
initialised with a constant zero after constant propagation.

With optimisation disabled, the fallback path therefore selects an
arbitrary general-purpose register. This is incorrect for instructions
such as GIC CDEOI, where Rt must be XZR rather than a register containing
zero.

Test the macro argument directly so that constant zero selects XZR
regardless of the optimisation level.

Fixes: e9ad390a4812 ("arm64/sysreg: Fix GIC CDEOI instruction encoding")
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index 7aa08d59d4944..a80bede50f865 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1204,7 +1204,7 @@
 #define write_sysreg_s(v, r) do {					\
 	u64 __val =3D (u64)(v);						\
 	u32 __maybe_unused __check_r =3D (u32)(r);			\
-	if (__builtin_constant_p(__val) && __val =3D=3D 0)			\
+	if (__builtin_constant_p(v) && (u64)(v) =3D=3D 0)			\
 		asm volatile(__msr_s(r, "xzr"));			\
 	else								\
 		asm volatile(__msr_s(r, "%x0") : : "r" (__val));	\
--=20
2.34.1
