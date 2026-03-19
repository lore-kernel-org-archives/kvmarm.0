Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013039.outbound.protection.outlook.com [52.101.72.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCEA3EDAA7
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935793; cv=fail; b=gXE2Xx9zXLClMGdT0UQd/otw0tdHTR/7DAdW0X+nO6qkPD/6mq5ibFmOOcAphCaXYm8KqwIFn9adkBfVPZE3a6tok5dgU5ZYkfCCvs3SipMsumeQr/+mkvStjfzPk/sFN2ZKaipXSANDxKwD4XzCQ+mHS32tDxVEDLxszX323Wk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935793; c=relaxed/simple;
	bh=ZLN6dUCMsnBK2ONLAPZhsSeyYq+CP764j5ZjLXQste0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=swQ40lrGYZxaiLjk6IlsilvX08dpoW1T3y9Kg4eLwnHoWCaMEe5JlSlD0g9wLMPpSWqJGXMCxZNG1YQCqc2KN1D9QLz9NJNp/aceNPcF7KYaohuXL9qvd/f7tDCnt6wY4XOjPCvvRZUmshk8XChjD5+wL0rUEHuagsbIEipuCkQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H/fXkifY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H/fXkifY; arc=fail smtp.client-ip=52.101.72.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H/fXkifY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H/fXkifY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lxYdfxJoFuIkICCN6QcFvpCLm2Yty12fLwwg20zmovXpKa2S1CiU1FuA1aHmD/ceWdmR/8btO+Y/zx5xJB7CckuMV1g0bB7AzbjlkmFyq7EcGUapGrM3vzIVy7jp9wGRdyaoyf0KXmhDRh+G6eA5fiERczpKRblVXBKMeszUumWbliHKj1Q1fZOcV5zmuVAk1Ylnl1Z2v0qTAAiMymQp+SDmqBmuUZSfpzkGpxKkRtIivYVfag/KRy+m25YRESoFt8nw79Bozv+ntZlcgXdaTSQ4wDSgfDezlARHumHz8H4EvBym73y9KiO04g9FVOCQynpdAstb/l/D/FxdAYhLtg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AidYvozz9IzgNA4Hfrn6OYNOwK7Yf+VtA1g6KpMl8vI=;
 b=bJvVmAQIdPSL9bQX20PmD/fAm3r9pDlKbCidV0GTx+kE8aO8Q/N4mHF6nbmkILIKsUWHAgJMLvVEWvSlEwEfmE2Sc8krFbPJEBRdvyAJJ9Cwew4UWAVdVOVXXkDGlPkgHk9PSeCgfGFR1+DUg/kOr2LhyH7RsKnQUdxIs95h630hLmDyGQetJB5jTVSfufc0zbebvPlAi8UWghvTqDtfihusTFxjwRrUp3dPaVORIVq4S8EJySrWdZZozWKPpXgYOAy8yzRt4MVcngKZTUEISfo4yg4QHYEcVRQEkyKDYRqc34RlM1Boqe7f819Odtb6lXKJ80zaM39aMJ25snKRKA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AidYvozz9IzgNA4Hfrn6OYNOwK7Yf+VtA1g6KpMl8vI=;
 b=H/fXkifYYaigcdKIKfFHLzzZCCoiVmqOLF/W575aaJSH/6Hvi5Hjgs7cZORxsuS6L/+99WMfh6gNbz4+hybFEGePfwMXMmqO+zNyBTgiAUMadYgOiMfyrlj+p4zlr6TPWHiBGRux/g9e+C5TdKUYxunVg4u1dzgEpku39oRDeko=
Received: from DUZPR01CA0235.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::19) by DU0PR08MB9369.eurprd08.prod.outlook.com
 (2603:10a6:10:41d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Thu, 19 Mar
 2026 15:56:28 +0000
Received: from DU2PEPF0001E9C5.eurprd03.prod.outlook.com
 (2603:10a6:10:4b5:cafe::86) by DUZPR01CA0235.outlook.office365.com
 (2603:10a6:10:4b5::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:56:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C5.mail.protection.outlook.com (10.167.8.74) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via
 Frontend Transport; Thu, 19 Mar 2026 15:56:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVbJV7LImSNR3jWFS49sS/LdjY4uUekO42LQWgDN1m6ZqkIwDPYlpY3Wv/x3E43//5N2huko5C2bZYJ6SjGVwg9nUb3jjxgl07LcBqpQ8aXP4NanbICE5qeaWXrFZEqMvSqoS0bO3tRCTpl8DhEpDax6gAG9lBoZGLV8e285MjiZlzV8Hs9dJZptRUczyDpV7/PJVM84w9YLFEV45JVgsXOuV2G9sF5mq1Zh3sBnQospifDYG3uT5zRt5fu1SEPZ78zOmY87HBn800nlJqiSE+3/OUqu0vxK99fHTNquhom7YYiePSDtesPwhqXzj7KgOjh9VAJNBZyPV1q9MJv5Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AidYvozz9IzgNA4Hfrn6OYNOwK7Yf+VtA1g6KpMl8vI=;
 b=HYAKKmylnKfP0oEj3U5y2BIXEgWW3WlNhBbRgJXKp8kxEGFMkfxHMJhSRtFkhu7gI6/1VDNnBmxc0AjfYblYNR1IGzZb2qsk2cSADetW1QH0FObcbE4Oalsv7Hn9BLslap2/uj8tV3ItCHWgNZlHzMPgvMAyXShD6+L7YsW7to6gfbyrQpg8dGzPumthu1vWdk81/NPMTkFnQqFOLR3tYfUjw9QnlS5cSItZna8joDQXMq36ytAYEeXB7PjLcnCxvdB1I1tl4A0jqj6wryGNH7ocA3RPpao7OGiUfg6iKmULCOJ26UmQI7nqDZjtSq2j6kGB0b8nRCTnfkPzteaomg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AidYvozz9IzgNA4Hfrn6OYNOwK7Yf+VtA1g6KpMl8vI=;
 b=H/fXkifYYaigcdKIKfFHLzzZCCoiVmqOLF/W575aaJSH/6Hvi5Hjgs7cZORxsuS6L/+99WMfh6gNbz4+hybFEGePfwMXMmqO+zNyBTgiAUMadYgOiMfyrlj+p4zlr6TPWHiBGRux/g9e+C5TdKUYxunVg4u1dzgEpku39oRDeko=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB6191.eurprd08.prod.outlook.com (2603:10a6:102:f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:55:26 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:55:26 +0000
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
Subject: [PATCH v7 22/41] KVM: arm64: gic-v5: Clear TWI if single task running
Thread-Topic: [PATCH v7 22/41] KVM: arm64: gic-v5: Clear TWI if single task
 running
Thread-Index: AQHct7jNTB6S2YwwUU+GNJ3/4Awl6Q==
Date: Thu, 19 Mar 2026 15:55:26 +0000
Message-ID: <20260319154937.3619520-23-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA4PR08MB6191:EE_|DU2PEPF0001E9C5:EE_|DU0PR08MB9369:EE_
X-MS-Office365-Filtering-Correlation-Id: 98a86406-3d90-4b96-9df9-08de85d0150d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 OkWlQy9+DlNgB+CrjKxXh0XJpvXEFvrgOMCBzfIz3VabNgDf15/B4xkVTHbeUdsugDdDAf3urApZb5x4PtHTOpVbNHWY4KuVIM0rajRhzzi8v3475nFJrZZ3q5RcZN+fjNzdxmfOR7yx0QQpeWDiJ7XuNL9A5Hi94LFwlxDtxNGF4mOshOp7aXi2EY7E7HV8XiSk/FTqAttgMPT81CKTAGeO5CopNA3Zg9OOXgriCHid4VJJmlY5jC8ZR0OFgdQHbX7qtPzZafAv8VJNK1MAmKnSVuuQySOUiszgj72UuVqT18YvAPk3r5dIp25UMHOif8fV8isj8oQTxzBDJQ2HA8XgLxoqGWv0/LbUH5EhO9OGkA3nH9m8rJnMoiuRxN9usOIgovw/a/DI9mxznD5oWjmVWtRM9IGpk5s2HY9cZWq926cc9czcrfvvVyjRpxhXeDrzz16RwQhyY/Jrvf/Bh77exwDB9sA9L4L2Yh8fEUDXsRrgCLFJ4kow4IiKKIJ/vckSolAPsa1KwJzU9NXQhy3RbPkCj986AAbQVLEvfdubVM8c9jrPXCW9GAwMilB0g9g93zcrxk3A5QzhGl48twacyJzMFIOUDrvcsA+kHwb4aNEuYb5GcUAYSBpEI22lPXYaYF08P0KuLAUzjT+dMkdGzoSt1WqtSc8FgqfxRNpmfNT7tRwfCukHlIfu9TXWNVo2ZtH0m15EVvQ8h4quqHfGZ53hgAkHLUMCaKQMnL/WWTfPG4RtbIDwI9bdMJEvKMCIkXP7R+f7WKlRpeu984zq/fby1H4SR5Nn+XE0d9k=
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
 suKeBX0r35br6qHFvynayPaIHUGFGqCoId42XOmJlTGjGaa3n+VAZutG6jBBxj1/3JFuRcWHifTOV2iVYjskeaB5fFjhACGXs3xzu/0CU1MOYXzD5wk1PbIKwyj0rtPNjWVPLFAZH2xEKoH1vSdjRKf3TKwOkePsGEuiwg8DJPSDQdWUoyKiLP6VSwxsL9VKxZcRzug5voePQ2ze9lgMLyfH5pyjVVTZi1YuMjz2eU6F3Luk+NTOwVr/E0eE8zuP2CqqQWBhchjdnrCdJgG+NhT3q0gL8dqf9rqqPqzarLfCjFq4AL2c6xuWXtu9bQIst6La3fWwAyApw2og0DCB1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6191
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C5.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6ebe168c-9284-4829-e7f5-08de85cfefe3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|36860700016|35042699022|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	DPQvw9I5mBOqNdVXeiMBc7u5bp2t462wOMzPiWH4b0RlMofQV3MbXOtUa/3miOB/GRi94DZzNzgcZce8DhoReQ8ka6mtcJgdM6GfRAgxQNYzo52UkbzHelFdKL4wPxfVlo8zG5w4YWuPfYYDQ4IkXL1RgaSvTl5ozYYMNp95G533PAuArp2Xd9LYTJHfGLPydCWHsXxrxeCKe/FRDZJoKiCwiNtxrst9rO4hIXFqMX/AtgtWcZTtnw0exEJNjLZ+nDa+bYy3XmPzPEdur7hH5F+TnHAg1ZsVEGq930Gm8EU27GNJNy386flq9aEDfQLQdrhMFunWfgwThRifx72z6Y6drS72OFBPUSbnwY5xJ+tM4KAK7cWT10JnjhidL+7Sk8NY2hhbWTTKHohBn3H4v1GLhmuQzIcZJgmDw/U9Z43oILe5RsEsSiu0QvnH/RrGBwJKP+BPkowg24hhfKsAgeoEbzHO1y8IW2WNRwRnAepLiHQZWhDMiSSdA9P7c4uz9bONlTJZhD1vZLL/11sRA4/gglvtb8348G5tBaqq0AyebV+R/egvORSRSEtDKOADiw3MUK+YVG+rU4FtNPpF9E+bVNLrEqhto1pienob2U7csumSx7Z+Z/aT217OdPEZlG0xgR4psno2eGZAUgR9IOnTZCP+8G56MibyXD/EdB8rSFbDJKYHwWwlKyUUcf+vTAugsEaPSYwxd8Z7SY4Llmvz9ZDnCwQGnZ4n8gyHPCQs35fs5CUzL9g3G1XR9FQY0m+ZsmOMWw2Wl2UhwXbasA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(36860700016)(35042699022)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6phikZ+gC1bsZPK+wWOJcvd+hOJr2RJuamWn5aqeCqIJ1qi3hvdG5bB++W7GdCfyicTVKwRTWZQg6cXwxOfY9ppWL5Mm4+PbbQPQvgrWMQkMA1+wphY/qnbpvfz1xZsLYsZHj1SCxt7OaKmQ4eVRv1uwZ0w07y5NAq0jS9DD+8QEOFwgceSF6PGeOajDl3dR9/N17ya9LYmnZ7mZ10Ef3AzaKJWwBPwTOk82CmYrIbXPddIiSL+/HDJx8agVqf9zQJDpWvryCcYUbhyAkcn3a2LNoNWHTxVqlDQOnFdlCtJ7REXftelc2+Ca3v/WtvIqjcGOMt9r8LknM1H4cPrMNUQyStucpgWDO0INMS+axzfrta4V+8iET44grz2eyxUv8+DyXjSBy+gzYyWBNJ0Tt1vEs+eEH9Uq35WI7dLGaazMza07H9tE+eMss6Lp+2tc
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:56:28.5112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a86406-3d90-4b96-9df9-08de85d0150d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C5.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9369

Handle GICv5 in kvm_vcpu_should_clear_twi(). Clear TWI if there is a
single task running, and enable it otherwise. This is a sane default
for GICv5 given the current level of support.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0e74e8da3e344..5514e0c4e5cfb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -613,6 +613,9 @@ static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *=
vcpu)
 	if (unlikely(kvm_wfi_trap_policy !=3D KVM_WFX_NOTRAP_SINGLE_TASK))
 		return kvm_wfi_trap_policy =3D=3D KVM_WFX_NOTRAP;
=20
+	if (vgic_is_v5(vcpu->kvm))
+		return single_task_running();
+
 	return single_task_running() &&
 	       vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3 &&
 	       (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
--=20
2.34.1
