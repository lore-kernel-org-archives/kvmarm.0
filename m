Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013058.outbound.protection.outlook.com [40.107.159.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E002352C5B
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306647; cv=fail; b=p5Zz97sP77nq3L2m8TN0K2WUDII0fhiRB1ahMohB6Uft7S+kG5QGeqjdk89uA4otCcQgO7oIFav+qhC0ku5QKewn0QqkIul2R4NUkYV1z3yp/0r7b0b2u0kkqoNKA7zA1g0ekbEC1ZGIb0LKkW+OB9F3+E4kUQbtZQxRIDOC7ek=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306647; c=relaxed/simple;
	bh=2bJdFOvQgJn4UXA6YKg215wWU5TV5J/sD8PRBOmPmBc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H8fmQE4DTguycv1rAl3EJgYzhEhtcRzYtokLGTk9Tv30vz0OTKslzpfqCHIX8u8Cx1oNKu6SOccB75IbjYgh6GsRrOALa20ZB1yP0bZachPO0cCw37BVp6In6he1hoT9ItM3bYqNdGfxenyJr6tfjx+EdUEtgZHn7PFppj3TVAg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YHHU02NM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YHHU02NM; arc=fail smtp.client-ip=40.107.159.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YHHU02NM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YHHU02NM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=f2p/zZCGlWFfX0FqCUb2fREUUWTlrDpbp+cU8iRGt9ERiM7g+qVlnw2DP9ZZVovyZr9wgkUJE3Za0mh2qkKjlsjalz3pAhAL08OBSwA4jaYerX986rXuSdNDurZmiCJNxkeR0kUIPV+ph2lZBvhKX4DoV7WWf6i99hf8mmGqrbyXoUDoWEfCpDv4j6XRLw9v7daob+5KumZP600CI/SJkiG2E8sFpBnWOoIKr6Qze8bPft4nbReDCf7IOO3Vq6gxPew3W57fnsxxA1XQ1tn2f2liJW88Wvjj9Yw8F5fCfBzpNfhpQwIslUTaHoMSwuBZAatc7VFBisH0IfVc1wSBsg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8LH8CKobhIVzffP8vd6mCHaU4hAAzOlrJWp1Ok6F4w=;
 b=UDWZs7DMkOfnJRySGhRSXLF9UlhvN1UT9S/4+wtwlK4MnQ/j0s/zr79ilfM77DcSftygAcj6oIfSJ2LXeUtCg1IRbA9AlocRGcG8EW5MRLmEJPf3IHIwnYguqYCfMwb1KeFerrM9N5lvraw0oONAaN2qiKLla5lev7nqOKwzdQR65Y+TEJHw92IarJeR3lZfIcvHtND7zW4zfbYfCfqUaSg8f7gqwb3qCfcy7BlGAI/nMXgu0tMGv0ZyOtG1KBdF2ogNczKJR91mqzaYGiusVQP7uP6xbUgMg2hHNi60bKX1n9eyGGlN8Nkv6pEll24XPoKY6MLvM01R3q2DMX/ivA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8LH8CKobhIVzffP8vd6mCHaU4hAAzOlrJWp1Ok6F4w=;
 b=YHHU02NMphSbKeEMXK4fr+eLtfdWG9U0o2naaao7HmWQxvJ1aeSFTDkqahtiH2mbqyGsmBNbqEGN1QbOEXvrmgBlEXg1E+KjJ/J0nFWKWI11aF3vz+N3xzJWeaVviyN2uuVBjYLCosSJdG4wb6BEKEOwgLGRVfs4PqzE75GiecA=
Received: from CWLP265CA0514.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18c::15)
 by DBAPR08MB5862.eurprd08.prod.outlook.com (2603:10a6:10:1ac::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:17:20 +0000
Received: from DU6PEPF0000B61D.eurprd02.prod.outlook.com
 (2603:10a6:400:18c:cafe::ab) by CWLP265CA0514.outlook.office365.com
 (2603:10a6:400:18c::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:17:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61D.mail.protection.outlook.com (10.167.8.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:17:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D/x8IyJ75Bb6+7LsZTuKmInWGonmSK+6/urVNnKXn8Y9gUOdFRgWb9D7QzsUEGIfZH0s0RCCp9o6z1FqENgNAgnPvs3itxR9y17i1F+WFVzPG5449tHEUouqFxNBp3D/G1PDZK6vzVFhV6DuIy3ic5yxejZ6eLLLpEWVNfLf+D+Bnq6hywn09tHFDcdfbu2RHP1jdpPlAj6dWhNBhN5ZURlt0fLpZ1jNrU9070AmbVZffCgKzhTJdKl0QxWSZ2dJHzbbA0VL/5X596+xy8744Bbz0Csy7X6veLy/4QKH1n7ZfQOuJkx2tHfW5B8UAKSkDy/q1JKAUdMSUyzN/HEqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8LH8CKobhIVzffP8vd6mCHaU4hAAzOlrJWp1Ok6F4w=;
 b=slKTJoVCSA6cTkEfRTP4dJJnMXqRZNqNc8EZwAeEyk/52O7v77UR6RABC6hfaHHzvP4Opx9KlEs+gxMsRcrGApVn/uLPmHSk0EV5erjnNbCiNXdKkyBX8NJ5pd/ayvYMYRvqDkEno/uB7J9lBD4nzGnTIYcMaIVg34hwMvp+nvvrA+FG0M096/usvil1t/xDDSk7xn9mlbWD7v2vzGFNuO9tSRqZUJT75sT5FD7THS4kTHAf2mO6I64gmbgnPFD9t6De6A+1TBo7AQarg2YH/wTFtPVl+x41mtbZ89gWGbG6s/FTTom60mPWF7SvOmcqwS3eUkCGwpj4ZSx1sBNXtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8LH8CKobhIVzffP8vd6mCHaU4hAAzOlrJWp1Ok6F4w=;
 b=YHHU02NMphSbKeEMXK4fr+eLtfdWG9U0o2naaao7HmWQxvJ1aeSFTDkqahtiH2mbqyGsmBNbqEGN1QbOEXvrmgBlEXg1E+KjJ/J0nFWKWI11aF3vz+N3xzJWeaVviyN2uuVBjYLCosSJdG4wb6BEKEOwgLGRVfs4PqzE75GiecA=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:16:17 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:16:17 +0000
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
Subject: [PATCH 30/43] KVM: arm64: gic-v5: Track SPI state for in-flight SPIs
Thread-Topic: [PATCH 30/43] KVM: arm64: gic-v5: Track SPI state for in-flight
 SPIs
Thread-Index: AQHc1mEtkiGD1lMLV0mG+1ivcqVaRA==
Date: Mon, 27 Apr 2026 16:16:17 +0000
Message-ID: <20260427160547.3129448-31-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|DU6PEPF0000B61D:EE_|DBAPR08MB5862:EE_
X-MS-Office365-Filtering-Correlation-Id: ba66ea8a-fe10-47c8-3e75-08dea47874e7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 ZS6DVKglgtxKxS+KxD3pBc5XBIRcqlK2EfsgrmqgZMxeYIXvnmnD7V57/LzxcGZ+rkLIoH1beosNGhcwwSVIq/6hWh4lBR7JQl6O20L/vvuul/skCXCydK/t+/uTI01L0l7SYxi9AqX8sPmLZZ5+VNmQ806uqwpHEmx6Aq1lvHyGRdI+IMR9xKXahmv+F1YSfu8UcVO1AgBtb+ExkB+w1pvgBN879mafelesVqsuuT8WcTYhOg+wI7lgr91q05Ma97mwHnDcRPYXCqK26rp9Mg2PxnEnrBe1TpGszOOC+wv1KRU8BsmXN4k1+SVbCdwpASlZdZ3YwdVzq2oSaa6eVhiwlWyCzyrROj7nYSb7LkE9dqruVvSlrG6AK5Ug9WiC/w6+H5Vd5UL363KF2S8Rd4KWoCnIFyWJSOScwTE/Tfz4gY5Df58LptazeYEPDY8Ya8mdks9bnpFGsgjYmmZlwoZnQA6LPGMfJnmRPtazdkMNsxBpaEqXMaoFyt0dmZNdwUQOGjhCgiwi++O/EeYSseQNjW/+fvv+3wPb+GL7JRnZX4V6S00TJM/k/khph4ZHEBscITI1nZQT0YOBe5xP/z1aXBw+plxbi+WyqOlQNt4SsrfvDEj1wAuijfDNsXhmCf/w0yjkVPkY40ZaRR5dTC3ajq8H/JpmrSXePhBUwxdm4yT/78ygOshDXu3T8QqE50lqxtdED8pF8hRYJYdyspIXMSpOEfiBJkrJRvyH5MyPheVxwBMuld/8PcQoeB9T0FAo1gkI92/3x/mDXljdcyvolr+tjqbcdpamr5qIQwU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 F+fUa6ZhNASIQ3Cb/Nt4uggOumjAFQI4p5cd1G8+RaqbcEFGk7h/e2RxoIZ0U28zttjBjcQMnsEgmx1xQl7eeCIA6NEkSaXSEoxfavcimKjvMu+KvK8+2CvaJwkksBNHKzm/02zySVN5YjIVpXn7iQhHvZHHlcuzcie4Y0VYGcBJynCAPzm3LNSkiWxwjETCIb8nwYonf4X9U1SE3+EjDlcE0RaUoFQkhibkTCMKle/VO3/HZJAxRwtXS2r/gpvDOLVUH20N/8z2IO8e7P5melbZFZ+mt0iVgdWvSxAUYPyxzAX56SvvKevJDYabkg5FzS/jERBNNSpy4gHB0Det6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f113adb3-d60d-4542-80c7-08dea4784f98
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|36860700016|35042699022|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ykyt+7UvdaYAwlTr/VNAazkBG5l0b3DGOHw5b4xiU5mZ17vEo0XXItFFs5TbgMHkB6Xab+vywrZH5S7uwQqJJSZIia6RVK5CoOFGNtzBkdUpO/kgqpd3+jElDTKqOBSYMTB8zSpk8NVoIA0L+ub6e5b9/NAjETyvcCNJ5H9I2KCNethWfrY+xdesSzAyUvns3XmnNOnsVcECJgCiqz58h1gvM1qbDfKOgREVS91y0oznkHJlUBzsE/ckSmP0V1zQ0rYUOm3cuyBn4pT6b7SooRSYwKNSKVinlYBnxNHk1WagQDzP3w3WTVzmfkbH4q5qBCyrqZIb+C6ZOLlgGvhiYe2QOcnMJ77AHD2fQ8AQILRl36Hw7GjV/VWj9yeqGoJa9nr9Hs3Uq1FwPey7048SXdIHEj2KyQxefgZwHz4vT5JHmhy9hsqKHoM6fxYz46I2FK7DJA0ol8+In0CEAom6SYAbP8owJyDCiH1Qx8ovNGincWayUE5bjdx/jjaT2D4dCxHqtuGS0vk6DKxg+jBi6/aC1X3M0R4iF3rN5KuwouJGdo0HZstxLJjiSPlmNxAp9rqtZn3b2FnjGvAhtxROEDDZo5nWh1r/yHFILzGCAXrsm1A8dQHoD8gtU+WucUv04mKxCKGogd1NdizmyGdKHXjjOmLwFIjUcPNFz+wmR9ZM7cOAlKq/xgIUeCo63ZXuj47TJ3148PpXYYwRES7JD00DTaUd6T/x5FJfXXh8zg3uG+zzy3U+e2N6e83tsEE/ztmxiGYnuABXeR2UQr5/Kg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(36860700016)(35042699022)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hIuFynVGJASteqg2Q7FKSUZFyekd+lqBx0Hn76b8YNdBYqXIIZyfydre2R95QjO9u+/lz/Mpr+ckRuncW4PlY/2SscsuHbvwM9Q8xVLC8k9oq+LSsKUcnp8aGhIQCZHwf5K2HM7B02iobID2TKiVv4h7mVNJHTjjxN4Yj+tOE6Xu8ELW/PU5c74GksjrRygw+L+nv0MxTVvQA0W4AXcGtrkB5cQquLKoKg4JP5wLAt8iXgmNV3adU72Y5e1z+tiKtHHY409eqSfv7/+9iFKlHzWEqWTP72X9hX9HUSCaPM10swlw8YHpBc1BGTnfyN6g9V8CEwVuvyAjMoO54AYiWBGtwOfj8pg3INEZ5wRBS4eda05rvyYpC+4UEpaleBVHeTkGN0Rj2l48yYeaQCPuJvNUSVdK/y5mE1Jv+KGDDay2eXkGpJUOBdD8BJNDGBsf
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:17:19.6417
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba66ea8a-fe10-47c8-3e75-08dea47874e7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5862

GICv5 interrupt state is largely managed by the hardware
itself. However, it is possible to register a notifier for the
deactivation of an SPI, and hence KVM is required to track when such
an SPI has been consumed by the guest in order to trigger the
notifier. This allows the code that registered the notifier to be
informed when an SPI has been consumed and deactivated by a guest, and
that the guest is ready to receive the next interrupt, if required.

As part of folding interrupt state for GICv5, which until now just
included PPIs, check the SPI state.  For each in-flight SPI (an SPI
that is on the VM's SPI AP list), use GIC VDRCFG to retrieve the state
of the SPI, and track the active and pending states to determine when
the SPI has been deactivated by the guest. This needs to happen on
*every* vcpu exit for *all* vcpus belonging to the VM whenever any SPI
is in flight. When no SPIs are in flight, it is skipped altogether.

When an SPI deactivation is detected, kvm_notify_acked_irq() is called
which triggers and registered notifiers for the SPI (and is a NOP,
otherwise). Additionally, the SPI itself is popped off the AP list.

NOTE: there is currently no way to query if an SPI has a notification
requirement or not. This could be optimised by introducing that and
only tracking the state of SPIs that actually have notifiers attached.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 81 ++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c    |  2 +-
 arch/arm64/kvm/vgic/vgic.h    |  2 +-
 3 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 86cfc08c557ba..f36d37c694d71 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1123,7 +1123,7 @@ bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
  * Detect any PPIs state changes, and propagate the state with KVM's
  * shadow structures.
  */
-void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
+static void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	unsigned long *activer, *pendr;
@@ -1195,6 +1195,85 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 		    VGIC_V5_NR_PRIVATE_IRQS);
 }
=20
+struct vgic_v5_acked_irq {
+	struct list_head node;
+	u32 intid;
+};
+
+void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_dist *vgic_dist =3D &vcpu->kvm->arch.vgic;
+	struct vgic_v5_acked_irq *acked, *tmp_acked;
+	struct vgic_irq *irq, *tmp;
+	LIST_HEAD(acked_irqs);
+
+	/* Sync back the guest PPI state to the KVM shadow state */
+	vgic_v5_fold_ppi_state(vcpu);
+
+	/*
+	 * For SPIs, which are on the global AP list, we synchronise their state
+	 * with the hardware state. If they have been deactivated, immediately
+	 * pop them off the list and call the notifier.
+	 */
+	raw_spin_lock(&vgic_dist->vgic_v5_spi_ap_list_lock);
+	list_for_each_entry_safe(irq, tmp, &vgic_dist->vgic_v5_spi_ap_list_head, =
ap_list) {
+		bool pending, deactivated =3D false;
+		u64 icsr;
+
+		raw_spin_lock(&irq->irq_lock);
+
+		icsr =3D kvm_call_hyp_ret(__vgic_v5_vdrcfg, irq->intid);
+
+		irq->active =3D !!FIELD_GET(ICC_ICSR_EL1_Active, icsr);
+		pending =3D !!FIELD_GET(ICC_ICSR_EL1_Pending, icsr);
+
+		if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+			irq->pending_latch =3D pending;
+
+		if (irq->config =3D=3D VGIC_CONFIG_LEVEL && !(pending || irq->active))
+			irq->pending_latch =3D false;
+
+		/* Deactivated? */
+		if (!irq->active && !irq_is_pending(irq)) {
+			deactivated =3D true;
+
+			acked =3D kzalloc_obj(*acked, GFP_ATOMIC);
+			if (!acked) {
+				raw_spin_unlock(&irq->irq_lock);
+				raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
+
+				/* Notify what we have queued before returning */
+				goto out_notify_acked_irqs;
+			}
+
+			/* Use raw SPI index without type for the GSI */
+			acked->intid =3D FIELD_GET(GICV5_HWIRQ_ID, irq->intid);
+			list_add_tail(&acked->node, &acked_irqs);
+
+			/* And we're done with this SPI */
+			list_del(&irq->ap_list);
+			irq->vcpu =3D NULL;
+		}
+
+		raw_spin_unlock(&irq->irq_lock);
+
+		if (deactivated)
+			vgic_put_irq(vcpu->kvm, irq);
+	}
+	raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
+
+	/*
+	 * Call the notifiers for the deactivated SPIs without holding the SPI
+	 * AP List lock to avoid deadlocks!
+	 */
+out_notify_acked_irqs:
+	list_for_each_entry_safe(acked, tmp_acked, &acked_irqs, node) {
+		kvm_notify_acked_irq(vcpu->kvm, 0, acked->intid);
+		list_del(&acked->node);
+		kfree(acked);
+	}
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	bool irichppidis =3D !vcpu->kvm->arch.vgic.vgic_v5_irs_data->enabled;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d56e87a0d2acc..d628eea4cfa4e 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -855,7 +855,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 static void vgic_fold_state(struct kvm_vcpu *vcpu)
 {
 	if (vgic_is_v5(vcpu->kvm)) {
-		vgic_v5_fold_ppi_state(vcpu);
+		vgic_v5_fold_irq_state(vcpu);
 		return;
 	}
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 282278e4a6c19..7eef8ece52dde 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -372,7 +372,7 @@ int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
-void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
+void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
--=20
2.34.1
