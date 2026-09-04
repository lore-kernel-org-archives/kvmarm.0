Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010009.outbound.protection.outlook.com [52.101.69.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572F5481648;
	Fri,  4 Sep 2026 12:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524232; cv=fail; b=al5WO9Vw9WNIyyVaK4mjtWaaa1HVPIrsisTBATEPqa/PA1Rk4U+gRhsFtHlXUmWYJynz3v4xggQs8Nu32aMWg6SZwsW2+lksXphcIitz2CEZIgXcrlOmhqXI7Epoo3R8rlTkUjPO8F6yjVo9WdTuGRjrX48y1joWkHULs6TO3R4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524232; c=relaxed/simple;
	bh=AbuEkMv582qGg7Nret5sRG78eTX3iVpKLxisOulCm0c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V6lG8wPjmzLmjJphXjyuVT6TsbhNRgQ3ZoYPBkjEwtZtgWsju/xWnkqkVHQ0PGEq2ZSkwytCCdZClYxPOhLpyYDjEnCYGPBhNBXHyznMNUEHh0VRf1xzRoSuhxe73lpOvJ5jjjlnvReGDSGIISU60zb99pVM2iE+A/oeDvpajns=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AE02D3Jy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AE02D3Jy; arc=fail smtp.client-ip=52.101.69.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AE02D3Jy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AE02D3Jy"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=M3nKqzVNaav1LMdtA3C7nS40e8Ke4jLzbfwVz8AEdrvIJGud4QB6q3K0GAoZxZQ2XmHoMI2efvQIoEpPAsMvEVUw3lAM6nJu+19tSig/D5MT+Hr2ev6rA4ORtIaWDHFdZ4Adlvcnfc7/VvgeeFQ7YDTglMyoMbNcLgUGWTD+URPklJMOxq4Dx39iuimb1mPS4+V/PduegV3aqX0XzaLjc8NATGCrmPiTAD/VgRTkht7r+t0UEOjtZ1e3PLqnUsL/8u2uMwO01IWV5LHra+tkrALqFeoFKnoUkByKsT+Y0rVxC4N+MXQGgOWn86upPGavPLTo/s3Mh9JrITcTr15MyQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbuEkMv582qGg7Nret5sRG78eTX3iVpKLxisOulCm0c=;
 b=U0BmHfn2RWTf5DVTR2Tb+vCaSJ+Jkh+fgUdOq4oHqkZ1UeIbs6KmiZlJRQgNjgKhDG/PLBsTy8FhbGsGN8NZNNpQz389cWQoadXvY70Tn/TrywyCfT/xnlGTvd58SbJ0BPt3/JrF94Zr2WSjLBH1FOxXiKul8uekVl9ODnKX5swcXiRzLCYZXK3DnidLaji4etAjOvv/w+N4ZmyQtZH+96/kSJ+5imBN3kk4nTVKxQZ95JNBnXeimslersSP+TDW4D4dJxjpXWpKyNbWB5w87Hl+F/6HdzkLiNIe7QT2h7OIM80qk7Kcx3UbidQSG6F3q54nkPIVvpUpxVJnAmAp6w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbuEkMv582qGg7Nret5sRG78eTX3iVpKLxisOulCm0c=;
 b=AE02D3Jyh8I529MvDvy1nm0nTt43R5hyfnCVR7F/XgPZo8aMbNc5eISRtj1PhP81cCTocI8NKpfe3ut/tB6tK76oaUO8+eIay3qbHQndLTFwGLf2gQmB2JmDeGNY0CayIznWMWcWOI1ewhWGrZ4QYML5EQtwwygQNoETk5mEACY=
Received: from VIUP296CA0120.AUTP296.PROD.OUTLOOK.COM (2603:10a6:800:350::16)
 by DU0PR08MB8729.eurprd08.prod.outlook.com (2603:10a6:10:403::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 12:16:59 +0000
Received: from MI3PEPF00008550.eurprd05.prod.outlook.com
 (2603:10a6:800:350:cafe::81) by VIUP296CA0120.outlook.office365.com
 (2603:10a6:800:350::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 12:16:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008550.mail.protection.outlook.com (10.167.240.4) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 12:16:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kDWSmlMTq7EeVpmDj2ICdvST/sa4FdZCsH8d93ZX0dG+heEX0c9eg27nQr2ZhAGQdo+86O9nRiQeV7VYVoOrvmDy4vcWAlv35SIAnUFwcyp08Wim23DhyxwUauzfCHeNCbOA5f1Qwp5OE48sVhyH90wBxuYJp/0B6ACjtq92I8cer1fX8AobKXa1umbWcJ/3JSxsHbRUowBw0MXCdHgQLAToSAHBtzX8ptx35BgaFwIfR3QOv9iZUkZCcJKJBI/WM1wnSLLnDB4lEcvxpeDxO0q+evp2AwDq5vqE8l5CsRj7sT7mVOZDIeG5aljmQPBZbjlHzjrNsoQ5e4aslkK65Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbuEkMv582qGg7Nret5sRG78eTX3iVpKLxisOulCm0c=;
 b=jENGLGCqFLaZlLOztXmK8MjPucV+Cj4TZKj6nqYUYRMQ13eO7wy7Si8qMrqPl6HduujVE2JAQ7h50ugJ8J6srIDgXz25ZhQGOopw6+gXJrVKd4TnSLXv5+5Bbc2A/FPlfjGrWd+YGnAo+5TACqYaDAHV2yp004WQeL3/GA4PU8scY3uYbMyrFrb0hii0IgLjvG618sDCzxeH7lw/DnGOhxHKXWUW72TTzBlZKPrU3dH44rv7e3v/UZnP3Gp6G9AY/OqBoL55k0GzFSG3AcFvFfNwZcIu8Ds6iW3kWMRn6VZtxTHalrUtwSQo1UPsg5E4By0IrzA4ECgVDn2KIhOEVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbuEkMv582qGg7Nret5sRG78eTX3iVpKLxisOulCm0c=;
 b=AE02D3Jyh8I529MvDvy1nm0nTt43R5hyfnCVR7F/XgPZo8aMbNc5eISRtj1PhP81cCTocI8NKpfe3ut/tB6tK76oaUO8+eIay3qbHQndLTFwGLf2gQmB2JmDeGNY0CayIznWMWcWOI1ewhWGrZ4QYML5EQtwwygQNoETk5mEACY=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DB9PR08MB9492.eurprd08.prod.outlook.com (2603:10a6:10:459::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 12:16:24 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 12:16:24 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v6 04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Topic: [PATCH v6 04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Index: AQHdPGGaKRFdj+jhoUagR3mV+bN5Kba+U0OAgAACYIA=
Date: Fri, 4 Sep 2026 12:16:24 +0000
Message-ID: <7ed8d7eb429af3dd74b3f8db8da84b4cf93f0889.camel@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
	 <20260904113404.4051341-5-sascha.bischoff@arm.com>
	 <20260904120753.8BB231F00A3D@smtp.kernel.org>
In-Reply-To: <20260904120753.8BB231F00A3D@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DB9PR08MB9492:EE_|MI3PEPF00008550:EE_|DU0PR08MB8729:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e9c1c42-f59c-4bf7-4c31-08df0a7e6b3f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|4143699003|56012099006|11063799006|38070700021|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 JOpAmq4M9y4N7xfO7zV/Q6EeGz9WAyIU4g7cjbwaq7HIbREhqADzmgu2XyGFj6xgGax7Z415IAdgE/Ozsbp3+iOGytvLpAv+bi/346b+Ow/3l4c0yrIllV6nADcEugOxLimmVKnKS/f4s9KuxenX+KyD/Md8ipvnOgMvgDvgvlWIHqPWHn8/hYxEldBQ4QEIAfgQCFyt/lIbsRyTMk4onW3LpRBZ+T0UsOQcE0K7lQ7MCaRnobSosUoPiiucqiy7ST17ZAq8HYmm3g9Xc18Ln+XO9N8q7+druE5WSgvVFbagvbrJql8DR3s6C8F7clIkwpUVj3vTNTd21tu4Yga9ArX3BrqSiEarsV0Qekq22FfEF6oYx0UF5zkS+9cyFh/g+UFMOrLw/6tcKbnsYEY7jbBsHUtTTkCXcBkMJrtcoi6pyDOyaft/aaSsqTHW+MWx4ak5xpLmMasdqK8XeVH6GeroIMSoxRTIOzErmsbxIQ6vKa5l9OiQ4b4eFblCCKuafghx78iByCeCjxHKeNEbiZE25vztDyfIK1oyuF/9AVEIISROoeYjSoZl3gdhX45XiuOmRZPtZ39l1Q9Pjns647brG4HEj1aJ12V6xEGhRg/W4jzbWGb6wDxknrOL2bgb0fprIwwUtTeCcSYk0vYLOvOFLut6/ECL2rA/kfWT3kxcQ0HzDSH38fi9wGeF6P3igNuWhbz2iME8vgbYeoi43catTjrPLM5oDdhKoidkr1k=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(4143699003)(56012099006)(11063799006)(38070700021)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <102FEF2DB36AD1499E03DD87785D78DF@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TBYIjDg7eKrwtOS9dUUMn8+3XfhuI9LP8qhQjGZr1eWHfbxNEoAIQ1X20UJhMLzz2takvWD9hxNoVYFYNN1NGGePCwQGEaAeZqkUOsu8OGS5AWYj7ceduhY4qwl5OxbJQfGPD4xBg5ulxs68inPvh7cDHanp26p9fdi5ZInr/fxmXJfLShGU9YWys86/l+btQmC7EMarD+f5c9TVs6wbHsCjPK55zmqdpcJ+cpqL9GosljR239GafouZWVAks5vM9HITLv8juvYTMMLjnC/bA63vhubEdZ+K2u+4Xb/ZE+RCu1v8fmBRL5Jme+ekQIFZ79Rkno6kl+oK+iuM6g5E9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9492
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008550.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fcaec6c1-c28e-4d59-aba2-08df0a7e5681
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|14060799003|36860700016|1800799024|82310400026|35042699022|56012099006|10067099003|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	idizKpgdXfuezhCHyfkZJzaYcEdQBYKAKq1XeDDIWYHbMNgmdJdu+wk6EZmPzUifn5w9q22HMB/akltorYQI3eIQB0F57ek3BC+wXDUSRaEklPFxY3tF6n1/tUh0pzUEC6cA5KMn4BrGbfllJVQqsaE0YlGsq/XVy3t1spUEn44TndfYddJWLhcqqr8Pq/tMFoxmIGU1dm22afKbsOOQE2ee7RZDiVJVaS1q/nxt30Pk+iZscuNHaJdCEosjTbBhk4VnLEZYHlDaMENcz/NeLz61Okv03Kcr4P7DvJJCHuV1YpvH2ptN6eRELUbHt8tzfHgioF4PlaB0XtdnRCiln6+vs1KS4dmjndeXg78rlft+M/SEAlkbuY5492PZcQmM+TKEY9IwEydrzkslV9PDYWtR+HQ9qhfknDcbhBrrAYFbB6CDYvGV8yGBNeaWObQIZAvwCjy1SsDHljY34AuElshW6bWN6Rro2Mxq9l20/3CIzRzTeps+jzfyaMDR8lxQsEJ8qQ2QsY7vHBglM3X3nCsBrFFZTcbmF9yTaJYijxOzCIkVYVTm829TT+wLJ14CACcdUjYtIlBJ38JNuiPMQHlY+5s4tjxe0MtJkoC87XzH5AnBhhLXYZ58kcK5LmREhDxkPVB8AHY8drFOlhP+Tv+EifVxJQXX/AX3dUjU1RM=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(14060799003)(36860700016)(1800799024)(82310400026)(35042699022)(56012099006)(10067099003)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vtvv/3ubBLMOKM9Gj1pwlNOSJuIXzIc6arftAIABYOQIfHwV9MLD0uCbX+7cepZ46Rt3fvhhgrw/Yewbxe5mqZx5ZEW/w1dQdtSqWR4V2SoIsN25kdnPqZdYlOfMJzv0SMfAMVDTPULdbipsx2WfR84mLSHb6epIEBrNYLzha6S9fUBLB3nKjVcdxINuBsq87p/NbZJ89sPlbTbrD5m7bjuneICwzV8VsNxSAWxGlITYgB/NVNXGNC+xIH+ouMpXUo+Tf7cmRCBGysq8zuuHXFHAvPBP0eGHWZH4C6SCpc/Wj6PPi+m1jPKe91G8v+ppWYEfAELfzGxiMbjIBNHQiii+nsfKXsKeTZ2Cmj4hUyAbxF02pEUDxJ7l+oT+TXpmgjLrXDYoqqdTcR298PuBocCYoHT0EtK+sNzKneD2Lo0bXyZUfYeBfrXrVtNETqxH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 12:16:58.9574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e9c1c42-f59c-4bf7-4c31-08df0a7e6b3f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008550.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8729

T24gRnJpLCAyMDI2LTA5LTA0IGF0IDEyOjA3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTG93
XSBHSUNWNV9JUlNfU0VUTFBJUiBpcyBpbmNvcnJlY3RseSBkZWZpbmVkIGF0IG9mZnNldCAweDAw
MDAsDQo+IGNvbGxpZGluZyB3aXRoIEdJQ1Y1X0lSU19JRFIwLg0KPiAtLQ0KPiANCj4gY29tbWl0
IDliMzYyOGQzNTEyOTJjNzcwYjZmYzJhOTAyZWQ1MGU2MmQ5MDdkOGYNCj4gQXV0aG9yOiBTYXNj
aGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDog
Z2ljLXY1OiBEZWZpbmUgcmVtYWluaW5nIElSUyBNTUlPIHJlZ2lzdGVycw0KPiANCj4gVGhpcyBj
b21taXQgY29tcGxldGVzIHRoZSBzZXQgb2YgZGVmaW5lZCBJUlMgTU1JTyByZWdpc3RlcnMgaW4g
dGhlDQo+IEdJQ3Y1DQo+IGhlYWRlciBmaWxlIHRvIHN1cHBvcnQgZnVsbCBlbXVsYXRpb24gb2Yg
dGhlIElSUyBNTUlPIGludGVyZmFjZSBpbg0KPiBLVk0uDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L2lycWNoaXAvYXJtLWdpYy12NS5oDQo+ID4gYi9pbmNsdWRlL2xpbnV4L2ly
cWNoaXAvYXJtLWdpYy12NS5oDQo+ID4gaW5kZXggNTlhNTg3NTg1NDMxOS4uOGRjNTg0N2E2NDZl
YiAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2lycWNoaXAvYXJtLWdpYy12NS5oDQo+
ID4gKysrIGIvaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS1naWMtdjUuaA0KPiA+IEBAIC02Mywy
MCArNjMsMzQgQEANCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gwqAvKg0KPiA+IMKgICogSVJTIHJl
Z2lzdGVycyBhbmQgdGFibGVzIHN0cnVjdHVyZXMNCj4gPiDCoCAqLw0KPiA+IMKgI2RlZmluZSBH
SUNWNV9JUlNfSURSMAkJCTB4MDAwMA0KPiA+IMKgI2RlZmluZSBHSUNWNV9JUlNfSURSMQkJCTB4
MDAwNA0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiBAQCAtMTY3LDE1ICsyNTYsMTExIEBADQo+IA0K
PiBbIC4uLiBdDQo+IA0KPiA+ICsjZGVmaW5lIEdJQ1Y1X0lSU19TV0VSUl9TWU5EUk9NRVIxX0FE
RFIJR0VOTUFTS19VTEwoNTUsIDMpDQo+ID4gKw0KPiA+IMKgI2RlZmluZSBHSUNWNV9JU1RMMUVf
VkFMSUQJCUJJVF9VTEwoMCkNCj4gPiArI2RlZmluZSBHSUNWNV9JUlNfSVNUTDFFX1NJWkUJCThV
TA0KPiA+IMKgDQo+ID4gwqAjZGVmaW5lIEdJQ1Y1X0lTVEwxRV9MMl9BRERSX01BU0sJR0VOTUFT
S19VTEwoNTUsIDEyKQ0KPiA+IMKgDQo+ID4gKyNkZWZpbmUgR0lDVjVfSVJTX1NFVExQSVIJCTB4
MDAwMA0KPiA+ICsjZGVmaW5lIEdJQ1Y1X0lSU19TRVRMUElSX0lECQlHRU5NQVNLKDIzLCAwKQ0K
PiANCj4gW1NldmVyaXR5OiBMb3ddDQo+IERvZXMgdGhpcyBuZXcgbWFjcm8gaW5jb3JyZWN0bHkg
b3ZlcmxhcCB3aXRoIEdJQ1Y1X0lSU19JRFIwPw0KPiANCj4gQm90aCBHSUNWNV9JUlNfU0VUTFBJ
UiBhbmQgR0lDVjVfSVJTX0lEUjAgYXJlIGRlZmluZWQgYXQgdGhlIGV4YWN0DQo+IHNhbWUNCj4g
cmVnaXN0ZXIgb2Zmc2V0ICgweDAwMDApLiBXaGlsZSBHSUNWNV9JUlNfU0VUTFBJUiBjdXJyZW50
bHkgYXBwZWFycw0KPiB0byBiZQ0KPiB1bnVzZWQgaW4gdGhlIGNvZGViYXNlLCBkZWZpbmluZyBp
dCBhdCAweDAwMDAgcmF0aGVyIHRoYW4gaXRzIHByb3Blcg0KPiBhcmNoaXRlY3R1cmFsIGRvb3Ji
ZWxsIG9mZnNldCBjcmVhdGVzIGEgY29uZmxpY3Qgd2l0aCBHSUNWNV9JUlNfSURSMC4NCj4gDQoN
CkFzIGRpc2N1c3NlZCBsYXN0IHRpbWUsIHRoZSBvZmZzZXQgYXBwbGllcyB0byB0aGUgU0VUTFBJ
X0ZSQU1FIGFuZCBub3QNCnRvIHRoZSBDT05GSUdfRlJBTUUuIFRoZXJlZm9yZSwgdGhpcyBvZmZz
ZXQgaXMgcGVyZmVjdGx5IGNvcnJlY3QgYW5kIGlzDQpub3QgYW4gaXNzdWUuDQoNClRoYW5rcywN
ClNhc2NoYQ0K
