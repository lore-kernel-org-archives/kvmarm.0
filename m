Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012063.outbound.protection.outlook.com [52.101.66.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1A93ED5CE
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935891; cv=fail; b=XxEJME9kHHeq7VaI/Zc8rLXSOiF6FG9njWjAB3pMsDE2QoGKRHSDgzf3cKOKLra6ocnMtOw5+vosm/PFWeDSuTIip6TIefmmuYgkzgY9bB61M3Kr5uNxy9ATT747xt92loCSeGwh5o3Ay20foXIo6/ebtl5CMMewB/7i4wYBhhk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935891; c=relaxed/simple;
	bh=weCe30CoWO3wFwtJxAeXpMVDPRpwYEYWA92nVhHiEEA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GBijdylo8ZFOPmxjjp28iilNUAoNcK0OjG+Lx+ruE0lLY/SZ9qJsy22Rqq0fCfigGvM9OOcPzLrMRVI2BKP5HPymXKx3Um6L/NgxdWXBSDGMNtLu18Ekw4iP/b8eUYUhgQlP4aIz58qsuaWeY36uhLVY+SR7UDujwXlqSWWNSlA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZsPa0L70; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZsPa0L70; arc=fail smtp.client-ip=52.101.66.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZsPa0L70";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZsPa0L70"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=LJeGJdIt/orCCTsRJTv6CMlqfsHcG2KF2EfcJHdT8A13maqU7jJJyxQowpqgFZRGVFN6eMOTgvirKpI0Dz2uEOYLi5dgvzAZQWWwikpmEl+QAlFZqRVUScHBmpy3UwiGtTmHRX/47xS0CkZbrRRXqnmCi/PIpI7cGulfSbOft2y71E+9SpCmXLahN6RZxuYvjW6uOggXd5ridfEfu8CKORFX4QejMVNSJDn10q3+ILAJdTWrfO3yGpGCjQyg288otS+EAa5qKlsEM6Kjcny61/XGbgnI8UbGXcJXkSG+KtoQKue2cBQfoBluR0h+K8nZkdi04w67RKM9iS48QG+TZw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Ps4NIyZvqBCjB3Ifmt0YlfRlRO5bSLx6pM3UFZ5vsM=;
 b=XUe1i/p0PCq6j6huGVb6pei3Eddc2BPWZfgaXPHj+oDHk1UnKYzo3/Azv50jnP6odStAijlj7LX5DwdcdgwJTm1X45Kp0v/frzD59sf+kkhH5anTyiR7igwYivSGIM/HeOdHN1gffzRoSGSviuVjd42IQHWOPwM0O4QLP8Hqk/EZoIqGwn9OVOZ3IzT2zf9+gFYmZRoVrYbgLmcxaMFTxQqZgAKrLQLvxIuEK9HO6aQOZLUR9+FsDQ1SbHXhd2iAIenRl0+WRIr7B6qXhYTjeC8rApfo2i4zuGiaOGD3ZFDw483+Xh7AnmN1qv3rD3EPGvqnl/O8GtYGftdMsuGKBg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ps4NIyZvqBCjB3Ifmt0YlfRlRO5bSLx6pM3UFZ5vsM=;
 b=ZsPa0L708UG+vxP5J1els+LIr4rX71Sg9LRrVjxLcUTYBcGdyBQNXurezBw+3tdZd81a0Tjy2T8SVxkVA1CrkXSYboJ1f6qizequOWPqsPBwAQsATZxomuCqNJqRXzXcRz1TADBcwc7Ke+rtTaBqpF6xHCNdpnsoq9Y3zYhyx6I=
Received: from AS4P251CA0025.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d3::12)
 by DB4PR08MB9214.eurprd08.prod.outlook.com (2603:10a6:10:3fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Thu, 19 Mar
 2026 15:58:04 +0000
Received: from AMS0EPF000001AB.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d3:cafe::12) by AS4P251CA0025.outlook.office365.com
 (2603:10a6:20b:5d3::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:58:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AB.mail.protection.outlook.com (10.167.16.151) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:58:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N39YydKT3XLpYFL8VE1qaqm7D+WZXgPdk7w2pjzX8ElRNloSwpfQL80NJhvHUXlRDB7s2/S1c+IosVdL22+w1q9AxzIg0v54UyD4cquxCVd4rUAmY/NEVbDVMXKdhuSwhjMnl5e0MgtPqQW/bsBtmE0k2B9HCFbmsxA+NKMNdTYFAXdZwxWX3c3qHYYuJGl3h9Kk1+ieySjNosYzSBYdiyYJVIF1uwCjtCN6hQelRHRrZqhc7AuG34jMwC62mJw+x2wDbKEHYhC881Nn/6azpaovT3G8j5+3izPM+UkFLpqKqEh9cOZgnDrvcsg1q2WJyq8RwqVKCMdWE76ChbOOPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Ps4NIyZvqBCjB3Ifmt0YlfRlRO5bSLx6pM3UFZ5vsM=;
 b=RyhIFQ12Zy11OmITW8vLmOpMZqrEzjIu42Y5UKyGOl/rS3VKVjfyvASJnhkOwdddyWQDgQKF+FtjM9kBong0z5j3/w15G5gcO9B9kM8JlG+lEf30dtitYglRadLg0kbYeEECduJlgrUSvBxZEGe25xptiF6ISsovs0xD5IEO+dW9omk/aOW6XvC911TFq2+NwVvwihj487P6UD0GPYtlKZ+4Qj0Qn4PFz56Cq1Hlfcyg1XrPGZwkOYWaeBcPAxUWn6N6KK46CRuk2DO4n/Mm8MOodFRGIe/o5BJChJd0wKiyw3X8aFJQFB7YrRg2D3xg2QK9NOSwpMaKfiFwVVl9oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ps4NIyZvqBCjB3Ifmt0YlfRlRO5bSLx6pM3UFZ5vsM=;
 b=ZsPa0L708UG+vxP5J1els+LIr4rX71Sg9LRrVjxLcUTYBcGdyBQNXurezBw+3tdZd81a0Tjy2T8SVxkVA1CrkXSYboJ1f6qizequOWPqsPBwAQsATZxomuCqNJqRXzXcRz1TADBcwc7Ke+rtTaBqpF6xHCNdpnsoq9Y3zYhyx6I=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:56:59 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:56:59 +0000
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
Subject: [PATCH v7 28/41] KVM: arm64: gic-v5: Create and initialise vgic_v5
Thread-Topic: [PATCH v7 28/41] KVM: arm64: gic-v5: Create and initialise
 vgic_v5
Thread-Index: AQHct7kES+ykPG/G+k27NovAxpeW/g==
Date: Thu, 19 Mar 2026 15:56:59 +0000
Message-ID: <20260319154937.3619520-29-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|AMS0EPF000001AB:EE_|DB4PR08MB9214:EE_
X-MS-Office365-Filtering-Correlation-Id: 49ba7288-6472-4d45-4dc5-08de85d04e3f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 fJNhrCE4aFC679hCpxgoU2HwiQE32UvpGAkP5S2ofvDwcL6dEahYY+a6ZDSVUB7PFJUT5sqhtqwe9W3u4hrgsP63F2pp2G6n/sUDLjVOWB3N5oe3E4joIt82vkRPT6CNcZO0+n6BCu1J+1p3L/+8rm7K5a0e9Uv3nRkGUoHYZWOjJ7k4+hENsYtem1Tl2s+1AEUkBstfyLKW8uC7pz/yW2i60ojjLJ+nFFUB6R6Xf38A8M/bWJ3/NCqCcK1zUJA518WuhLNhu4KVxigYw3H17nLdfssNVlUovtDm7JM54dfsjW/OdYHOMZzLCjxveokrfPO+GKQyYmLmTkun2AfO0kpyTym3Ol7lBKZcih/M4ETXHEpcZYYRidf9arMkbhtCldaKU1S4Sm6tY/udsKemnOoThDix0qXqMVekMFroXHXOnlfP8/1PWu2KK1UhcCZV6zgwYLKUIXIDNh0DbmpOh7QobDNbj49gsP2VhMK9oh64CUetbeDHRnxxww1SG0+I//QlGZ6qcJXJysoLZvpT2pgrxUIOaCt2jOeDaguw++PA0+Cf0ipL3E0fOvKmpLWP4WWOgsrOyFt/ceSwp3/Yuambh30ijwaBeLsXvUCcF604wfXKVQSrFE3r802+YlCzc4vNYaCUE5qAZupplsqvap3ByPLQD9xPZ/9GajINiF5m1E+/f11Ns8AHIyh9JZvBaOwNyJ7BSbQSDLBpucwrHi3PHMktPmIO4IKrUrJNeAyDOo/VGYgpzjh+mDLaxP0qGcavCl8RPLVEziw5Ro4MloVKKm3gZF78Z0BzLETYrIw=
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
 Kkxkr7gPY8XGBfatZVYYQpr+knzw2f5e+JVMfEIvrd2fW9nqOGh9RW432dCLav1LoWvaswftA4+g8kzhJxC/QK7vXRb5RbGfUd8hd7llf9WWxLxSurY+j9PHMR9Bbk+AUoBnxkbCdPuATs+/jIY4TqDiAKaUAkZDWPZox1OX+cUKSwhBVo7GptnzzaEFBaQzMmg6lH7dnDCte6fwGvjIMOAnVcJfXfFoo+fOz3N4B2sdvi4yan3lZ3l9hJAZQf3Qnf5U+bzhHiBlR4AbZnLpWFi49lgl/2QiT2p1ztlERBHx6JzhgMoq5GbC0EZhbwR1dgg42UnQKBVKfpSV9UVDag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AB.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	061ebc21-ee3d-4ca6-e492-08de85d02778
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|376014|1800799024|36860700016|14060799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+FOmPPvZTs8JaabDFMOosmdaUiMfwyfoBdlb92BlVIcq1vJBnm077Hcyr3JOaLXvcxisSwLpyt46X00okQAoUU35pVCc4cvPsOB3/xX3hXPEoyi+edQnbdNoMe8IK/fOE1jkn8QwFn5aRY5Bfa77SDpIN2iRImsUS35x/greTnGnfoqahik3/RsXj9xcWI+3s7VKYH3lfaycDNBZ2ldQVPolqpIlQiuVap30+lt/SHVM6UQXBWHwnQeP6t158+ggUXCsNNMxho4eHhfG480FKqi6iJekGDP9LxfGrV8857/HTdSxYn131WqXyCWeem8ovODD99mi02I8qNW1wep5gqTOaSOipMKIQ4DURXyxVeXFaIV+thU7Hga3QUYWItO+TdNQIvlsURcH1hlJ+NibQCPumWnqIycoqKffH2/VertH3YU3gtpLEhEpgoPKqthplEwKAk1dilVWqijlsYeRSH4MNUnJ1uxk4zhjoyGceK/ftUM/TFcc6zgH9P/0TptX3+Sx+ugm7sUn2tuDv+UooRrisS/iu1H4sqwZCm1eKUHDvLJLF95VGQuCDVTbS+A5Gr+J5/AGruGFxEFiaE7Z4PAakDiGJwiEuZgPR6IvC8wxzuUe9J+33xEIzDRIPG0wdC2d0NRBuradcZ6+puVPrfZburpJdP6sc3Mm+lymBuh358KcHCys9OelcC35eoBGRbPW+RYctbhdc9OxyxhEmqArJxD3tclLLv0zsdkQ5tK13G9/U1gU286HCiYMlkyzUzMR8qi1HoD+8s+10iiZxA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(376014)(1800799024)(36860700016)(14060799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dOz8Y5o7+F35L10bprIteO0b0yY+rElvU83Z44q8n+fJiSixE/+inE0XzSihaoEOxNoAQKbwDBEQyROuasq//wmFS+RGPOvBr2Ur4vJk73mfNzNOnMJ4Z6S0J2OLfzzswojtIV+h/vulwEe5gUZo2j0hgnLtaRwonPlLSsBRbX+hKUTKvsij1D6INkAb15lrxDIAKJ+mYRXaQDNiSDov6i9Z9XNiyfSlds0Fd2ZCNNWWAPYfnjXucx9hAaiNUxUQr/ayFoTrDAPjn5R36kaqCj6kZ/vUjPaJiu3zAgOByGb6qmjA+0zfjS1jilXo8+EuS3nAMmCWJa9K+Kc+MsBr/u3BHth71cAuaKhzmY6nAHUaxGQsDbZBZl701GNGRs+8cBfP7f7Mml9MSOP7bHzaMvFD8xmzkm5R5Vb1Ivc0Dd+P5DpBIBH61zJWnuGGFzbK
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:58:04.4576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ba7288-6472-4d45-4dc5-08de85d04e3f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AB.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9214

Update kvm_vgic_create to create a vgic_v5 device. When creating a
vgic, FEAT_GCIE in the ID_AA64PFR2 is only exposed to vgic_v5-based
guests, and is hidden otherwise. GIC in ~ID_AA64PFR0_EL1 is never
exposed for a vgic_v5 guest.

When initialising a vgic_v5, skip kvm_vgic_dist_init as GICv5 doesn't
support one. The current vgic_v5 implementation only supports PPIs, so
no SPIs are initialised either.

The current vgic_v5 support doesn't extend to nested guests. Therefore,
the init of vgic_v5 for a nested guest is failed in vgic_v5_init.

As the current vgic_v5 doesn't require any resources to be mapped,
vgic_v5_map_resources is simply used to check that the vgic has indeed
been initialised. Again, this will change as more GICv5 support is
merged in.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 54 +++++++++++++++++++++------------
 arch/arm64/kvm/vgic/vgic-v5.c   | 26 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  2 ++
 include/kvm/arm_vgic.h          |  1 +
 4 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index e0366e8c144d5..75185651ff64c 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -66,7 +66,7 @@ static int vgic_allocate_private_irqs_locked(struct kvm_v=
cpu *vcpu, u32 type);
  * or through the generic KVM_CREATE_DEVICE API ioctl.
  * irqchip_in_kernel() tells you if this function succeeded or not.
  * @kvm: kvm struct pointer
- * @type: KVM_DEV_TYPE_ARM_VGIC_V[23]
+ * @type: KVM_DEV_TYPE_ARM_VGIC_V[235]
  */
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
@@ -131,8 +131,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
 		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
-	else
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
+				     kvm_vgic_global_state.max_gic_vcpus);
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
@@ -426,22 +429,28 @@ int vgic_init(struct kvm *kvm)
 	if (kvm->created_vcpus !=3D atomic_read(&kvm->online_vcpus))
 		return -EBUSY;
=20
-	/* freeze the number of spis */
-	if (!dist->nr_spis)
-		dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
+	if (!vgic_is_v5(kvm)) {
+		/* freeze the number of spis */
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
=20
-	ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
-	if (ret)
-		goto out;
+		ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
+		if (ret)
+			return ret;
=20
-	/*
-	 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
-	 * vLPIs) is supported.
-	 */
-	if (vgic_supports_direct_irqs(kvm)) {
-		ret =3D vgic_v4_init(kvm);
+		/*
+		 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
+		 * vLPIs) is supported.
+		 */
+		if (vgic_supports_direct_irqs(kvm)) {
+			ret =3D vgic_v4_init(kvm);
+			if (ret)
+				return ret;
+		}
+	} else {
+		ret =3D vgic_v5_init(kvm);
 		if (ret)
-			goto out;
+			return ret;
 	}
=20
 	kvm_for_each_vcpu(idx, vcpu, kvm)
@@ -449,12 +458,12 @@ int vgic_init(struct kvm *kvm)
=20
 	ret =3D kvm_vgic_setup_default_irq_routing(kvm);
 	if (ret)
-		goto out;
+		return ret;
=20
 	vgic_debug_init(kvm);
 	dist->initialized =3D true;
-out:
-	return ret;
+
+	return 0;
 }
=20
 static void kvm_vgic_dist_destroy(struct kvm *kvm)
@@ -598,6 +607,7 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	bool needs_dist =3D true;
 	enum vgic_type type;
 	gpa_t dist_base;
 	int ret =3D 0;
@@ -616,12 +626,16 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		ret =3D vgic_v2_map_resources(kvm);
 		type =3D VGIC_V2;
-	} else {
+	} else if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
 		ret =3D vgic_v3_map_resources(kvm);
 		type =3D VGIC_V3;
+	} else {
+		ret =3D vgic_v5_map_resources(kvm);
+		type =3D VGIC_V5;
+		needs_dist =3D false;
 	}
=20
-	if (ret)
+	if (ret || !needs_dist)
 		goto out;
=20
 	dist_base =3D dist->vgic_dist_base;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index b84324f0a3114..14e1fad913f06 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -87,6 +87,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_init(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long idx;
+
+	if (vgic_initialized(kvm))
+		return 0;
+
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
+		if (vcpu_has_nv(vcpu)) {
+			kvm_err("Nested GICv5 VMs are currently unsupported\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int vgic_v5_map_resources(struct kvm *kvm)
+{
+	if (!vgic_initialized(kvm))
+		return -EBUSY;
+
+	return 0;
+}
+
 int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu0;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 8f15f7472458e..0f1986fcd7d0a 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,8 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+int vgic_v5_init(struct kvm *kvm);
+int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a28cf765f3eb5..a5ddccf7ef3b0 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -21,6 +21,7 @@
 #include <linux/irqchip/arm-gic-v4.h>
 #include <linux/irqchip/arm-gic-v5.h>
=20
+#define VGIC_V5_MAX_CPUS	512
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
 #define VGIC_NR_IRQS_LEGACY     256
--=20
2.34.1
