Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010050.outbound.protection.outlook.com [52.101.69.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAB6379EFE
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748152; cv=fail; b=nZ0MqC4cMRZN89+TlfsZNglhbsFYu+Z1qOVCLVXcwo35aUN4uRpnUbN0gEVBl3aMKuuZ7OURkAnzT0pyl/kbV7/OlLXrnHRFOWvFDohoNjN+9DfIDmipZCO96gmd0P9sngpdpjlpllR51v5rtVHRNCDskPC2Cy1zV/N2dCyyAeg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748152; c=relaxed/simple;
	bh=71DV52yrspbxFDwFtBlkfZ0F3sQetXgS4O+fFWr2euA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kyZ3O1jEPHRrCgHBeZF805tas/lOE/6xRCMkJ07S4e9KNvWDpQupbxpc1+3CXTawbSqSmMyUYsttsgvaC5v1VOz0ZoxFkWUloGypdOAEmX+Rgoc09z/l4HUTX3CwpdCL6Pj2WJbg+4vYUIIGMgUGuivzTndqP9havgJI3JdE/MA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GMeMNjwN; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GMeMNjwN; arc=fail smtp.client-ip=52.101.69.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GMeMNjwN";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GMeMNjwN"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aQav/rwuwEt94zM1ZKTlut3uFYpFU0Tn7H2bC0efEuDqLcFfLgqXnnMR61DBPisTP4Y+alQjEPbGJvuCCHkq013d9YZA5/NNi+MXs3DJHgXWz6HIRBRxCs8qkRc6/HdfjdkkzZbV4+UOvhSEHqVMtZerduCee9mL/gMQArmihQzf9/kODw/aSeJ50Tzc8p2qhApblpclwRE20yQ8xeflAToXvF7zaWDx4GOYtyGCV6QYQsxSmLLKfPjXvusSViE3Y1sMbuaHGUe4Q5wAM4I9mjISJDyA+lfsfurvm4HnfgOw1jcU8mVlx2+3HxAceWbRtu7xx/eTU6ugPxD4cPZLhA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPJZaJh9H8cLJ4Ip/JeZEp6MP4aeTnR/HpM/bvnmwZQ=;
 b=vUYbK1ewXykzFDUHBzJIIq+g40Vj4xO61CCsRWNculRGWf7rA81h4Ihd/QaylRAPEGMfTLxWld9nzWcAwfAYwuc24QPEctulp7rQU2WsIOoLz+RE6wg/WD7E8MNKub6hE3y9Fc3HnMGdL52WF86H0SPqd1dMBaXcXIkAgCZllIL0WdX2GD1IXRDEcJ3kYOSMxRAobF+aoANnC883Lbh2jxxB6xuBJUp4G1iqfoIZ7/CDUSBkYszYiE3fCsUdVLftvJuRD8yvXcb1td0tmrQBjEJyhOWJezghD0d553ePaHOXh7mmIjdaWI+AWU8SM5I6gzovSGDvjJedeoUUQY1mbw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPJZaJh9H8cLJ4Ip/JeZEp6MP4aeTnR/HpM/bvnmwZQ=;
 b=GMeMNjwN0vTRj7E9yGKYKlszgp6OnUwOkNmjs67aDSCz6EqvEY12ngfpQPWyqPtiGyPttUqC3oduf8gkLXfaG3arnf7zPH0IEA30u9JLpn4hA6zdb1sY1UgG84FIfMiY7dvrXU/jvNbN2LMKdUZ7UB+v0TeHxSR8ImS81A6bGlg=
Received: from AM9P250CA0012.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::17)
 by DU0PR08MB9321.eurprd08.prod.outlook.com (2603:10a6:10:41c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:49:03 +0000
Received: from AM3PEPF00009BA0.eurprd04.prod.outlook.com
 (2603:10a6:20b:21c:cafe::9a) by AM9P250CA0012.outlook.office365.com
 (2603:10a6:20b:21c::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:48:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA0.mail.protection.outlook.com (10.167.16.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:49:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kcf89p18EOP3ZORCOd+6Jsy+bbrXHKG2e42R6SqRVjzvjoGAeMbtI78+z4HrZWrdhyfz+/6fXfrHsQgLVseKASSm2hq9rlTLErU370sQjF0OOdlb226eMn9QuqWUdtVIOVPEK1NHd2pxTi4AzlTyifU65M/cxXqTADJhsv9gRC7z1K1FXUAH0epz1yikeELI+khi98OMu8H+ITd4ZWsALVzAueKdiLxS/UN3iNITK1GPqSh7El129gmz83N0I4D6PqcBXej1JW0eh9f+qKt65poknu7b+qtEkkhBB+ZquIWaL10ke50P9p5QUJ9VrP3VOPA+6bZUcBVqBz22d5Gthw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPJZaJh9H8cLJ4Ip/JeZEp6MP4aeTnR/HpM/bvnmwZQ=;
 b=w0zNLSONaAiP7uVSyvwnag8njK4Yz8brBV6TtWp8gTqr8JSb/BYxBppEGbelD7TL85CWvqzByatcESsucV1WL1hIZT43agtpqjJx9mI1FxlkJXIZTgIBnit6RobR+YxcD44qXuXDz2kHYNXgitcEJxDubz0zxdMO3HArUBAkqE/i4dJ8PoT82hDL8hvVu6kvYPZ0WCvpx6LGEqw//lLgoB7JTgiv/kPXI0FU/Uoo64Kf1i55Bw/lVGuQ/P26y5BFVXvibovKoVRI079p+iAFbquC8SaGqfqJVv2PfL9t5+Gd1tEPemy7VgzV2ItHW4Lgtf0j4rrpsMB2mR2yspTIWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPJZaJh9H8cLJ4Ip/JeZEp6MP4aeTnR/HpM/bvnmwZQ=;
 b=GMeMNjwN0vTRj7E9yGKYKlszgp6OnUwOkNmjs67aDSCz6EqvEY12ngfpQPWyqPtiGyPttUqC3oduf8gkLXfaG3arnf7zPH0IEA30u9JLpn4hA6zdb1sY1UgG84FIfMiY7dvrXU/jvNbN2LMKdUZ7UB+v0TeHxSR8ImS81A6bGlg=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:48:00 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:48:00 +0000
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
Subject: [PATCH v6 31/39] KVM: arm64: gic: Hide GICv5 for protected guests
Thread-Topic: [PATCH v6 31/39] KVM: arm64: gic: Hide GICv5 for protected
 guests
Thread-Index: AQHctgPnHH+OQqN54k28VR0S59TvWQ==
Date: Tue, 17 Mar 2026 11:48:00 +0000
Message-ID: <20260317113949.2548118-32-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|AM3PEPF00009BA0:EE_|DU0PR08MB9321:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d41a24-3792-4772-edee-08de841b2fb2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 w6fQowio8PT/Drt/amLJho9i3O9DgR/wgq+whOkR5D2IHAfOm/o6nIe9S6NVZ0mC57X1Sj7n1bMEsClcXuX5UEZYKEsNWcD5/mf7OoiZmCzE9UoiEJQJE3rmWkdmnTmWuIhnuU9A3PvHSU94WabfMAzjmLn9eYJW69TFqyX+Ohus0N1VFE58Ny+bBrpFChd6UGpiC53rNERKbG7nj1eV9eEw+AJGlIItIjeImLgqM3v9m3Zjga/njlu6VdeXLgaE6lZvHC2GajUBgngvNKi5heeCnzGTTTQ1LH4uxoyu4xtw7LIjtT3dKkFl2fRQ3oajfm6DAbQZl75+5lc5zsuVOhjJUB9SDWhTk2alICdXcTM3g42dfSIXI08a0yeCH7F3n/kTwTMGlEXuL3B4zuH3r+G9iHrHue6DmbadTOCmxFabnE69ovDQP0z17G7uglhT0EHbe9tA+cZs7yEt+bVgTMYogxvASXpp0zoTEaBDrMjduAY/RAg66+DIdfeeVOW/PdbBUVluVw3h0h1p4S6YvPgah6rfc1zA472EB+vWQyr1M8eUNDpzM5rghgn0YnBm3xA9pf+NG51+Rb/qCCsUmBQ394te71QIElHr8QDVZi+VzqfyzAwnj2JyHXDky8f9Gg+6PKhCzRsIZJePHQa03Xzbtvt5lKmDOg9NxYZbb/cWfDgFapbkSHfL3uphpLmf2/L0p/odEpora1hWfpcI4w18tfPrypsdOTDmsaWuIP+b5ZVmaaQeneJ/73VvpO0X/EhDlk9t6vGxdC4VQ0jbOzBQWWzMHiOrjzMxkXrN//Q=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 D+7Zll3AI4iqTdZmzL5AkIcN/lTvZEZ891GPK+7ubhBENkqUuNybbl1IRNbkpe4Yj6njOw5d4uAEqbVn0+UR4MdQSpfLx8bkXqjc97zImeTHhA4XBEukZmqwJ9KdQeAAYzHSZJDPStYMAq7XRcR+8K4kWCLUc/KOSaiJYGWYVhJpdQ8jB1LVlojrlRluwJxUACTSsOYDVPtmvva97d0SD3hpH9jZ3hqG8U+UK4x9j7QN28YcLDhtQze0coleSEMh8llPc9ytVQIlpfOvF+RrrDinQekx1+Faw2Q9D/CRHQP4CLy9HIQ9f0QkSWizs+KSvXfmHkPQwbZ28UThz+/xrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA0.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	519f499c-a23c-4e2e-36f8-08de841b0a69
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|14060799003|36860700016|35042699022|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	YxK058Dq/lINy2XzpBv0q8CFOdGwBDkt1Ge3YpVCkVVgqOCZOqSc4XRlaDeeEFXuauZhypCuseKtRVSoa7MjtQZUhgC+VT8jMyv3GFfwWnXEW0ZeEXPA74ZM+b8fc5ucmlZ3JyTzGd6CUQ7UaQwESLnhyIULx2li7j/nLAPDwY5FYe7naSTu/U7mdHAlvDF3C3NjysaSC2ElLTXJnkvv9xT8JbtafPIeaaiNqbHMKNdqEySwxeZyWPYrplR8icerL513JlhQUFwKyf0JA8j2XQ6/xccduXemSfdMAN/IMt4fCcdvvleU+BOEWvXI6awhTqnVni2HvBpq8frXT78603WlWTCxnWC2eVQ6j6xjQcHL8x3kYCiCE+tymRdCskk7t+HnjgqPaM/A+DGN+CQmhRbAwifIvxETCsPUVjydj9TGLHdcPtX3x2hoDohXnttexEMew+p70Gnb+VpWrxnBBjRsfNRXQpCpNNZo9fToVuI5CMsbmwjUqL50l3BwMMu9CEp9gQ0ZQs6/qoM1IJS7DpcqRxkGIMUmDnnKkOlp0oLD/j3A4C/m4vEYm39D/JODBLS/iYYT1edgetrJQWFfhhxWjFDUbZfelQImvs65kiPQ82J/36IxvzV5DtC3Ig6P/csh3j3/q9SEidaDOSYlxYp61mNEFwjZ+oIkm4yKo/lzoiifuiwxmGMubwHrTb7bim+4HeofwJ75aAgsWI9y79TaQld860B9sSib35om89B43xcP3z2euHqCq6D6Cdds7gw0QB/IJ2sRWswbLM/eZA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(14060799003)(36860700016)(35042699022)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qb9dL6htCmfuemR1ZSxRvGrlcl/OK2l6ZPuEWhgZTk6s58Y2eV2AQF+xvx69+mGI3Dyz9Vrsb/DyqE5DCSfOQq+zFUh4qKERwItY2vT1iXyAeeDPdvFboUZxHaB67IZOhVF+cbMQjT+cziG2k2zQxYe/deeR7gHibSs6nSOu1NScWQY3SRMbTSPu85AlP6aZqpVKuGIIjkceK7B/1ihhedJH4JVT0b/MB74MBr7dmXvXa1JRIVj0DwP40vVZOhfmVvslK7XJnLUdgYhsIZe88ARROK7S3kG8V6bOx6I8pADRsZ3kMFC7vloV8xzIFuxMi3UWN9ZrLEfXkJ9ibIOPijKEzYVDHDlY/oRTwffpgYx6pd97TyO1gzZUdodOSmM6U3hNLNgWL2fMHeU1Hir1cXxFZ/n9Ry05lEHzVG11UCq3HykCo76uy/LQo/axW3Nu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:49:03.1462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d41a24-3792-4772-edee-08de841b2fb2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA0.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9321

We don't support running protected guest with GICv5 at the moment.
Therefore, be sure that we don't expose it to the guest at all by
actively hiding it when running a protected guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 +
 arch/arm64/kvm/arm.c               | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 2d8dfd534bd9d..5648e8d9ff625 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -145,6 +145,7 @@ void __noreturn __host_enter(struct kvm_cpu_context *ho=
st_ctxt);
=20
 extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64pfr2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8577d7dd4d1ef..cb22bed9c85de 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2530,6 +2530,7 @@ static void kvm_hyp_init_symbols(void)
 {
 	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) =3D get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR1_EL1);
+	kvm_nvhe_sym(id_aa64pfr2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR2_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR1_EL1);
 	kvm_nvhe_sym(id_aa64isar2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR2_EL1);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/s=
ys_regs.c
index 06d28621722ee..b40fd01ebf329 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -20,6 +20,7 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64pfr2_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
 u64 id_aa64isar2_el1_sys_val;
@@ -108,6 +109,11 @@ static const struct pvm_ftr_bits pvmid_aa64pfr1[] =3D =
{
 	FEAT_END
 };
=20
+static const struct pvm_ftr_bits pvmid_aa64pfr2[] =3D {
+	MAX_FEAT(ID_AA64PFR2_EL1, GCIE, NI),
+	FEAT_END
+};
+
 static const struct pvm_ftr_bits pvmid_aa64mmfr0[] =3D {
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),
@@ -221,6 +227,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu,=
 u32 id)
 		return get_restricted_features(vcpu, id_aa64pfr0_el1_sys_val, pvmid_aa64=
pfr0);
 	case SYS_ID_AA64PFR1_EL1:
 		return get_restricted_features(vcpu, id_aa64pfr1_el1_sys_val, pvmid_aa64=
pfr1);
+	case SYS_ID_AA64PFR2_EL1:
+		return get_restricted_features(vcpu, id_aa64pfr2_el1_sys_val, pvmid_aa64=
pfr2);
 	case SYS_ID_AA64ISAR0_EL1:
 		return id_aa64isar0_el1_sys_val;
 	case SYS_ID_AA64ISAR1_EL1:
--=20
2.34.1
