Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013063.outbound.protection.outlook.com [40.107.162.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708133ECBDD
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935747; cv=fail; b=TpEpZbQ3y0DNLZxAEdsXquvVhD9EK6YcMzsUMvbhUDMPVsnB2/HbHOWqzccS9EMg5t2qAzVu5VscltcQJIvmkeiZUamx6gwhDTGofFPjGCwzRGH5OtZPwIcAqcXFJx/cOP2xHxTDKhi2hi12Ei+7xHJqkZ/H7lKd3tsMk4ZS/oQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935747; c=relaxed/simple;
	bh=S2uT7fOG3Luc7dHvCZPuUHL2hjn5WyCXe2y7LwJa/xA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iQJlB7u1NOduB/IYEoeDQTqO3QBkt7F0XW/0c4ikHVrnsX0dpZ/FlNDPxVyUTjkTl8MbNH7erKHcliOBhsqL6C8mXMUW6OBT1U3m4fFlrMASbyAPwAJCO8UATSzi3v/VAfvau900srmi6tdsT3jpzWMvv4k2uDVOkjeig0CwtBQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hZCTt5tW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hZCTt5tW; arc=fail smtp.client-ip=40.107.162.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hZCTt5tW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hZCTt5tW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bmIZbYlO2m7aJ8QCJhWupPUaeZJJnKvpDZOoQpzcFBsIytadf18RxOMgDnIqpfv/AppJCAI9XyhHZs3CyH8A4CcPq8CJjI6lJZqlEP+UBKH1DGmXvHGQveWEbT1uTiSMXhy2HqzWBVd+EuTFrqdzfmFnN0+m16KsunuIIOhrVfhFoh85qsgcuJ5UU8CpZ7uii5+6LGe9hB8wjjvZ2d1m3e3b4WkP4xC1WtSb16kSmtzArjCGIufWYubfrsxkgP8CamNlB7xQCw4m8s5+RkE5CpWMJE21KrZuwy0BJj023CkkukPDsuh+Vc4rwj+YFdWTPRKtfVOBS2B8/okdFT9ZUA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImNYMxICVItv33m4fS27gNzXXo3pzCAH/XeDMjRWedg=;
 b=AlUbbbHCfP0giyDU3i+E60/j4qr8G17BbF1A3E+kuz7yFXOyEGntKezmTtddOoQl6g4LCMxGsut7rFB9GNCK8Uj4n+ND6ZAM40t6jJ6h0xhKEIlEshcCBM6COfMf58vjpqEN/sd25mjZOE5i3NQ1PuORCdcXWsziUHqLsh1XQkTDR+0qVzLTPaLe5S+WHTK0S/DscmQTdN6Hvy/nDPsaLtT/uy1mS+E0K5rjLa9TMZs3OAQNMUpT7sqBIv1P6tx80a4+LFKansvL/LWQ45c6UXdqPKcNfGv2lAUeT1SDR4+lWPbNCYIWRc1/A+v/BKOEej8yZ2AquuDUsvmm0G+TDA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImNYMxICVItv33m4fS27gNzXXo3pzCAH/XeDMjRWedg=;
 b=hZCTt5tWQHbf42rUjlggZe/6mz0QDdSpgvXl88A6D5+5kxrrwTb1CdgfaaW9MWF6RQF3IeV94DRYTzcBqm4R8/A9GXskxE2b08UKN0epkVqBZaqC2Vg4Cz8cEUguSQMwJmeLD+LCaWq4BbF6h0x7rdfjizSWQ82tw3A8uL4N6FA=
Received: from DUZPR01CA0060.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::18) by DBBPR08MB10796.eurprd08.prod.outlook.com
 (2603:10a6:10:530::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:55:41 +0000
Received: from DB5PEPF00014B9B.eurprd02.prod.outlook.com
 (2603:10a6:10:469:cafe::91) by DUZPR01CA0060.outlook.office365.com
 (2603:10a6:10:469::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:55:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9B.mail.protection.outlook.com (10.167.8.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:55:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GKCd27wCNaOSnDzMD4j6kesDBV2RI+LfKGGwbEoMqhTYeEKrOq+B77LEMiS6NXRtYBXQAxkFleG6edQwxdsJ8xvUoVSe6o5+VOVHQ6OrzyfQUtetEBCL7jqDDuaHcmxXA05MOszdsxusB0RzCZywhwNNDPTsiELbviG5cXDWq5vgb/ebqHpUUcDtzddVsjZeIPOco1uQ+WEsjCuIuRrf4NhSDg+5LALx1bs6V4XcExSGNFhFrV2P9Na/ztCKEIiOqgB8vU+1qGIIQYyJSpVGN1Gj7/9p0dknyYXGlePjN9GzMNdeD2//d+DzzbMPMfwMyHMq3wfeSheQRIB1kaw4zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImNYMxICVItv33m4fS27gNzXXo3pzCAH/XeDMjRWedg=;
 b=Nlcshe4Bu/1gF4a8enp23MxiYhtUq3mNMh85BIblNNQtp57v9ZtSRBJWRlO05i4YmYBTMFCgdunfPZGGoc6NA0aAc0Dp/7EdXESfAYZwQvtE+xbkMI9sqok8VfaZS325tIHqi7UUGzJdtIieBu25v8uATc6ZxnOXSfu/UOey8MyeEBRXLhdhGWDhTFioUGYMwzbJVyUy7ui/iZQvn7S4wXzO3t6e1eHkTDppWPvm3jjawPljJF/u0D+Lyg4w1fc2C8EiMRWVrT19sTh8WZk9WjuVK8JMIGn/LdfXzVBPUl+QSQzmvUcPoq4WV0ZGuiuofomwQNrqmzdhhoNxz+neRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImNYMxICVItv33m4fS27gNzXXo3pzCAH/XeDMjRWedg=;
 b=hZCTt5tWQHbf42rUjlggZe/6mz0QDdSpgvXl88A6D5+5kxrrwTb1CdgfaaW9MWF6RQF3IeV94DRYTzcBqm4R8/A9GXskxE2b08UKN0epkVqBZaqC2Vg4Cz8cEUguSQMwJmeLD+LCaWq4BbF6h0x7rdfjizSWQ82tw3A8uL4N6FA=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB6191.eurprd08.prod.outlook.com (2603:10a6:102:f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:54:39 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:54:39 +0000
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
Subject: [PATCH v7 19/41] KVM: arm64: gic: Introduce queue_irq_unlock to
 irq_ops
Thread-Topic: [PATCH v7 19/41] KVM: arm64: gic: Introduce queue_irq_unlock to
 irq_ops
Thread-Index: AQHct7ix4y5/kgjjdka8EkOBIaGuUA==
Date: Thu, 19 Mar 2026 15:54:39 +0000
Message-ID: <20260319154937.3619520-20-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA4PR08MB6191:EE_|DB5PEPF00014B9B:EE_|DBBPR08MB10796:EE_
X-MS-Office365-Filtering-Correlation-Id: 98d7b416-2c8e-47cb-4f07-08de85cff922
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 0Pd6xQlL5MnOvqYLJDcbbRGGMcTAJwuqPvGc0Ai2SPDTNQ3O8FrzNoRUeNK9rbQ+i9Rh1reqICWDtmQ6N5t8pV9ouf8feEgmFkLM1ERPepbdDGmhpk3DDjb7aXLZUhJUB4yggWKgnVB/Em0uE7ugxNfy2aQBf1KO+PJ4r2ISEClW3k5tl3jW56poDrrv3UKdmGSNeNSTuLAzW9vd0P7iAcXqizWxQiiZr6WNpochOwkws52ERTduev1NEIAC0FTmj6+lt39g8xg6OX63B/Xojra6u4sAnfYpnjwV1sTiew3sP0W44UfKAL3xW698vEPyBHpIDLWJ0xUarxq9YkOe4hRMTX4fcVu7UQH9+l3jEL7sSrYZ1h/rYb2tiNy65g+kf8jhJI9zGV9DAIko4tTDeo1q9IdCZptYtjDug/y2ExR2CoNN9hSqcKGyPg834ajziNwik/hdYn13QW2l1qf0aQV90z73CQIz3YZ/G8vYJFNORafcZ876unEmQuGjLPC1jFLugKh85N7xBy6Hn9//SyVMy7I+oUz8/QvNa3JUkdRfEtqrY3SXIvbjMsb5xFIbkw+hXV2orwLb4z774FODiaSWU1bDdd9eqbWVISTdTd7drRoi9AN5QO7kOS+Sgv4YlwC2VAwtH1FVNZu0vcrmLdIVRihB/ageWosEIFiBhl8+fAatuSJXhgD36oeWCmGdO+ZbZagfQxtDps89GbOwn67pTwq8ksecUOLE9t1j0v0I9OqglkXLE4X+cqIakb/ZfVJaBkTJweEewoB56hjSD2P1FJoz0yN24w98a3VEOvs=
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
 GCv1ZfAkOJ2HuoYS/UkgmgjBukLgI3Jf3LaQPc1xWthP6Q7SBZxlMA8zyj7dBkuDIkg1F5ogmynIYKxYlgcGfqBOH3FC493mKDo1q/23oc+7auqqOsq09lGTX/PSKIPaJ5X2mNdSpSAmF2RndRVK9yuZL777ss2cNmnZRebzSKm06rL+Ho6bTs3xJ4mhPrNfWBepnEb/8gCQCR9TnoNG/wJ+JLR/49Iea3fDKfhYiQ09oDkGGpe7p8mGNObFp5AtystnOCy7CMAA6d2vBx0tb3XsvqHagFN/96aBQ1oB8nYdanJ5TvZtEp8CIN1ixDjXP8dQXIYovBBxrmf3oyJwPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6191
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c410dab9-9e10-45fd-7068-08de85cfd40f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|1800799024|82310400026|14060799003|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7bEIQFHCyk1HzC6ftDt4Irp7OxQ9c/QA2s86Ty6dKnpWplkLK3jv9ZjY27l3FC3+JZOT8rzYTkfmUJJiwRGUwmQayoMrS7ulriF6fnaimyx0AvYDhXeWAMHprQ0oWwTtTXQazGFNgUGRib+79Ixa7N5uDbqcFij9reiNpM+hxaS0ilb+UeglZO6cRn+0diVstzETwRO8x5PNFQxU0knPbVzhTDi1HIM8Nc8KbxtNeS6Yk6ppaFKpc1KZ7l5u83T1uQp3u6HS6umTX67dzO6t8PqAUkNVcjR1KKztk4UnQhEsXIy19u13ZTmlNGq7R3BsgCLW41Qt0XiCHgx4pPSd7P87QFHry29jVP8D9WU8qIuTJxY42R/28BSyUFdB581fhH04lwp//jKv7fptQ69kcsYI+qMGgYNU0RzeGW+ossAAsyfRrvzX1YZh2y9a49GWey/JXACuWxq3Q9vjlT0iawvS0lAOmrAf1gsO4g+jmLsaXFhPJhnewcxHigjPWmR39XkL8qsPt3OV4FNhUrWXizdFzYziT1LQEW53QwNvfOFtLol3LRy46HktHDasPfWNVqCi3sJy6B4jo5EBEayc5cDOzZF8O2tXbYK4UUUKbAKNrXo2+hcN897ZCEY5faeosO+YryPGxkUu4g0hMpTD1lgl+eC3eUTroXTDXVC7T958yv+ENrNLX4nL1X3IKVB7rW5WU/8TuR7WTEGrxTjN14KjwI6nfjLAOFu2QpHTClwVjYbS/07KRzxoI449DtGkVzlqbphPgnKvoa/nIWAu4w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(1800799024)(82310400026)(14060799003)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lMhhhQnvcOIx3M13nlcMZ0seeRQkXnifBC49NMBx0XJlQH1r0+1kM+tHoH9A0XGFNoDfzaYklIbGLSruv+9bvRT31bVQy1UEhHtIEDRQfbvysvc151qxoZ2cz7G+tQUrHnHeEpbrwojupWGeFwqUjot1oPedqnQM+ppLaPx/l0hhg4ExzEnKIxlWXz9B6cfcAzlru7G0XOZrt0vF5Oj2TVHITyRqymk5kTgqMBwg584bO9IwJRFVvTMlxbJqb71BK1hwd27qTW3y8sVHINWJjxA0G9HBLmZJwTqZR41bsbndTNesbjZ+uH10h1aXaQoZuZhuAyvEjG8nof6oamvrpVi7rsWT7MLLC5Y3uUmWBVqu2/4ePl+PJRcxZiB8lJCbeC0AvckQSG54/K6M6YGt6wrU05H8j6YIkQvEvFYh+vnSMgElTeB4EMoukDkQUxUM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:55:41.6668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d7b416-2c8e-47cb-4f07-08de85cff922
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10796

There are times when the default behaviour of vgic_queue_irq_unlock()
is undesirable. This is because some GICs, such a GICv5 which is the
main driver for this change, handle the majority of the interrupt
lifecycle in hardware. In this case, there is no need for a per-VCPU
AP list as the interrupt can be made pending directly. This is done
either via the ICH_PPI_x_EL2 registers for PPIs, or with the VDPEND
system instruction for SPIs and LPIs.

The vgic_queue_irq_unlock() function is made overridable using a new
function pointer in struct irq_ops. vgic_queue_irq_unlock() is
overridden if the function pointer is non-null.

This new irq_op is unused in this change - it is purely providing the
infrastructure itself. The subsequent PPI injection changes provide a
demonstration of the usage of the queue_irq_unlock irq_op.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 include/kvm/arm_vgic.h     | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 84199d2df80af..c46c0e1db436e 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -404,6 +404,9 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic=
_irq *irq,
=20
 	lockdep_assert_held(&irq->irq_lock);
=20
+	if (irq->ops && irq->ops->queue_irq_unlock)
+		return irq->ops->queue_irq_unlock(kvm, irq, flags);
+
 retry:
 	vcpu =3D vgic_target_oracle(irq);
 	if (irq->vcpu || !vcpu) {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fdad0263499ba..e9797c5dbbf0c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -189,6 +189,8 @@ enum vgic_irq_config {
 	VGIC_CONFIG_LEVEL
 };
=20
+struct vgic_irq;
+
 /*
  * Per-irq ops overriding some common behavious.
  *
@@ -207,6 +209,12 @@ struct irq_ops {
 	 * peaking into the physical GIC.
 	 */
 	bool (*get_input_level)(int vintid);
+
+	/*
+	 * Function pointer to override the queuing of an IRQ.
+	 */
+	bool (*queue_irq_unlock)(struct kvm *kvm, struct vgic_irq *irq,
+				unsigned long flags) __releases(&irq->irq_lock);
 };
=20
 struct vgic_irq {
--=20
2.34.1
