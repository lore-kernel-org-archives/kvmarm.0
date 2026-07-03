Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013005.outbound.protection.outlook.com [52.101.72.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27082E1722
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.5
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783093939; cv=fail; b=dW5ZCpOxj3mX1p/nFvKVO/3IbP6AkqQwdhsIQhCIm2njaAx4qyBpPyY+x1/6uxdZ56d9hHg29L8lsIU4RF9EvNd6cOjptqLQYOZ27+K7TxlvAC+0R69+wdIX/j2jeRLwX6l661nNk8QadQFXErwAxDgfzrVcbqJvx/LQKwbXP44=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783093939; c=relaxed/simple;
	bh=V9MNNa7cvJCEXOoD1vnyxSmHmBRsM43aXmQv/hryv84=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r9wQe2pg0kNs7Nb3Fty5/AgzN4lvIrqafYfIbipoOkMGxBrS0a0IPMzgwxpQJIRu9dXXJER6xYL6lp10W0p+idBHdOX1O4mfhh8VoSwtHbrRWZcrcldC9UTsN1cIyt5jT6dgI/74i+Mpwex+/wI+qoDCta4/Uh23lSJcqE3s6nc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lsLlTw1/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lsLlTw1/; arc=fail smtp.client-ip=52.101.72.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lsLlTw1/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lsLlTw1/"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XMld08bMrj/5BxIhUdTXXFeeU81HqtDvJUn7evivW0Tzc3Aj6rmuJbURFCCGMOjszYoG2BLKW3xlklNRclktjNO9Sk8X8Wt2RfwaXJqEbvqKuQNWXUvgnPG3lozZESQJRJAgBVophTF//FlhsfgmxLk+/02lpfDkKz1iieVbkGaTC1g9+xEgEEaUuKVRZA8atZzolrKLNNCMlmgZfvE3eTzT8rcmClBDj6/JFQFDkX95xJKIFJyxUdIvEEgO58/tNG7FcipUhKr6om2lxGsnJTwsoIYab2/pFmM8Jew7odR8Kggdy0h1OEgNcshTFuywl2t5k0CCInJAtyom97Pk/A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=eNlPyiL9hPecRC6q+x4nfL1Csbo/CSx+8unNnIJRA/o5rYXUPy17rcSRGQSfYgqsWtn/qfWYh07qtUKcCGYKjrZDSXvp2FDKONTvqjh9a5+dhHzkIiSoGFDoz6PeiOThUvjB675C783dI/g8mlJ2i415q0WtTUV7MteAEXMrpxHmJGg2HeTqVSRb0GI96Qz2Q7IZHMjpVcdqQq/zR4CEWxywOIawa+CQlniFtUmfzNza56ubMg+x1pTvY5LjWvHjQsfqeHMe3HCf87kevROS5s7rM0MjB2Xq+n6SyuJGkVpTRJ5uewVMVEZDlxaKOsy4Ec7TXlnfkjztAURHRpZzJQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=lsLlTw1/SO6XMCISmytXtFmDfyH6wxBw5XdYHzbwb0lLyZbkQgTN5KeBJM7UY7fiU7ed3+hqIRIf4kGNUfazrgSDySW2DPlo7HGlzQhqobhHxEBcKQQovP6hL5vTFvSnZ4OgB1yLXBxV/Jx2mZem9HCpXEKxG0AONioSRULjB3w=
Received: from DUZPR01CA0112.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::11) by GV2PR08MB8365.eurprd08.prod.outlook.com
 (2603:10a6:150:bd::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 15:52:08 +0000
Received: from DU6PEPF0000B622.eurprd02.prod.outlook.com
 (2603:10a6:10:4bb:cafe::1b) by DUZPR01CA0112.outlook.office365.com
 (2603:10a6:10:4bb::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:52:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B622.mail.protection.outlook.com (10.167.8.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:52:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HW5YcArX9oh4b0d2s62UJJCDH6T1J5woT9Wq97cauo96tywOQj0de8CjmoJOMcpdvs8Hjq4FmfgiM7rAT28cWupMV49tAMhiotS1lwUi2XOrd5My6Rhx8C8mo2oAUn3RS/M6L4AKfBumEh+H9FeR5BkMAD/TrIaEh+eAaLheEmN8ynFSzwGAUHk4NB7m4VI9eydZLtGutu7h/ufxy2aAIMlpPlWmZwufz9oeMZemFGz3mgUxIVsBUSyZV+SiVY/yQHrEvzq0d9bTOF+38GNlfrzBlB1Jq6slzAsU6r8Gc2gOtjcKcqF758EyiqbY5p5bvmomoUxQTaWyQmwdgHoybQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=ek8J65YPqEsF1rZ1umH5zmEj2FafikeGD8O6lQ38StZCetg198J3ZUwbhbLSgYp6wzurfPkDLWcpzbVZjnhyErEFw5p5dfqDM9uyFTPcEP4LFfpI/Y9Vum8GtoJlqxE85lpQKzK/GiXhiuHfoO+bM2617RUZE2RSqfYS8/yACiOHMl6JAw+mC07Q5LZE3TiBxV/1oombUi6+GFodlsFX38pvK4D8qn52fLVwL6ESZ9R953WhFDfRG/qVj7znPwLBrzdJmeHcC7Pi9RuXjGJmzhTl8lisq6XTO3BkZg3D1joj97+nnt7wqqxp3FAgqjV6dc/CHdy2y7TSCfI3QRbTNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=lsLlTw1/SO6XMCISmytXtFmDfyH6wxBw5XdYHzbwb0lLyZbkQgTN5KeBJM7UY7fiU7ed3+hqIRIf4kGNUfazrgSDySW2DPlo7HGlzQhqobhHxEBcKQQovP6hL5vTFvSnZ4OgB1yLXBxV/Jx2mZem9HCpXEKxG0AONioSRULjB3w=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by DB4PR08MB8055.eurprd08.prod.outlook.com (2603:10a6:10:388::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 15:51:03 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:51:03 +0000
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
Subject: [PATCH v3 01/40] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Topic: [PATCH v3 01/40] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Index: AQHdCwPAaXwuP3H1AUGZkiZkxLYj6A==
Date: Fri, 3 Jul 2026 15:51:03 +0000
Message-ID: <20260703154811.3355680-2-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|DB4PR08MB8055:EE_|DU6PEPF0000B622:EE_|GV2PR08MB8365:EE_
X-MS-Office365-Filtering-Correlation-Id: 168395ea-84bf-4284-1276-08ded91b0976
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|18002099003|5023799004|56012099006|22082099003|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 HURtmarANXk5G/nnoMYsyHA/2df3XiOlrUTaQY1/UJ+adr+rn5v3F+V+e/PgtFsG6K4zBJw2wbXL0JRCzl5Z3BdrnjZ0ZK1X9Vggf+nVVQFifBzgE3m6uqICUrWsVnBVRSpPzBqula51le7QEb8IIJwYQLoCGoeVHKG0nBdZwympiZptHHuC6BJKNM9gTbmrpdVTsNkIGxhj6Pxnn6PLd9/yUs/cIa/4zQCunEyCveCyi9a5iw6NDCzfgHjnLEf1RvT7QZt9pC9h4MRco1LBiy1u1hQuG/CMCBril6zo2L429MW47+L46iuZU6papaF5Z2axJ5cxW3cLz2kwNq1mWhbHVNhlx1QYkYhLHSMLA9N+F0qQWC3lWPWhNTBIsKkNtXkj+GhPr44zKvtKxlUOZ8R2ePlyQxYIrBmMMWaZhQVRwA58B57HMqL01th7voZFlCmZdmlnbydGAOTib/UNPpIliwyEmKUzLBgD0Ia2lm41OV2eDaHS9orDw7kjjUW1oLLeMeUEIHzi0Wgk0ARXE7Kfgqopi+/Cqx7PCbLhzC/i1NtwvqCyMG8uxNUEC1kt90LMm6O234wKAt9zLHBWEjq9cZ7vwDq/OtTwMEfAvGIyk5MixPY8riNJNXwCkw7l3m0SrUXlfaFnwSa7sWzEydRFgXTJvjg/lMLQde7zAU8BTnPfDO271g3s0zrb2qhycUEL1ZoZAO5XfllJeZoc4BCg1cz8j0KABC4gwue937Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(18002099003)(5023799004)(56012099006)(22082099003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 WgjpwU8jkfUMTt+QpheuKdrVLGlpRk8k8ipV2RwZ1L+ygUJD8uTkoeNN5oHfcBa/1zSoatBkhxn9LNesNY7P5T2k5Ms4lNB50tGobQfyCGZi55L1YN0UEEoX90WUbpq8+Zbq9OztLSxxeopsObjJNF+QqcSA0+dQy4123zUAcujAAAfF1J2tf+pJp0xAYLXuzkvwIWpml2U0mJJkSlXejxLl2RkPkswcUD9nDFr0D8cre0qc22ibG0oRd1xEUhPEsVB3sgn6iRnH5m2RqvM7PWGTd88evJ750RXQD2g3eu/uZeh8Ukmb5Xi8iUpkSzZnaXl0PaRdS3E5NTFQ8/wSVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8055
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B622.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c5b9a844-1188-450c-4331-08ded91ae30c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|35042699022|14060799003|23010399003|376014|11063799006|56012099006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XpfJwPKqqrGdeGPsFrDIOG/sQq4nm5jcSpFK1nRLjL3acbHPFcfpCK4obeSPkDfaO2GLQsN/ynW/crXxW/62Enm5zw22ValXoBGmGCr4+1Q+sjswebewNU/FiDlKm1MrjB8Pb5Z9qNysB695uE+fXfbyCrPSX36rQpMYWhWw5qVW8vpQfsu9IsAV6ZVZq/AXlphRPSute+UG4y2olXAExk7D/KMbcqxsTLDsJNUJdEwHNDANVSUU/5yi/NCNf5qZ+t6bH8PZ1qmqsbNSn+gh0GH+SXoD6oDrJZFGdJu7rwdNOzz0XhoNXOBxnvKTHJEioBg6MGEfJ6WHT7nyyAHxy1dEXGNZ+gB85HoJU50Zoobbdp5qh8U1vcCGzWzkxHoUl6wfIFGXCk5om9MEQIEPq8kF6ZapFvBvT2/gG1/5cbVuIVZZPkj/9ypH8/Wey2zIqLoh9/tV8XagMfa/Fl43bBQEchyLTr4osI3zRTzbE7HOWUJLIJm2lPhoai0QP2x/gaXErAlheQDe/SUdExkxxK4cP6L+wwBnC6bJj9ziS/pi6mi24zw8ES4BdcprbG5t3BkU1oPcTiy1bQGiONq6K72GHGPsoCvjdXUJexPwn49TaKEjTFHAPIz4T6ymiH1XGhp4SPDMTq5JdpCQ1gyWKKU+xXh9uprExbwYOQXF9Ea8QHiXAenkQuMp3AAwJUNZYQwulvSaN91JbLR/u3KLgQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(35042699022)(14060799003)(23010399003)(376014)(11063799006)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MVa/UVjY1tAorvfsAD84Ve/UdZQbYMFDCGVD/AsETBGdvo94h5vM+cXAsCC19h1aa6CHmyV72tuVMoKyGxgjpCihHT/9inGT+fpVzYtAtfHW/Qs/635EptwhSxusXIE/bzDUc727yhrfj3+8MOFzuY4VtFDSUZc1o4FQrCXxvDXAQm4fnSs6uSKnj5UufFHjgmiWmCmXiK5N4Pm0SvjmOOqolyhaknumYNn9JFbeodbK+/QaCKP4B9gwAIfoExf6QVuLxwVjP/v0oCB0uYUVlS3mIyHg1apSVFLQaPUNEXfZPbRAU0MQ0eEDWmzNejKj2ui08a5TBHc++Fp6Del4aOyKui86qmZIu/hu7xBF/ihzvuJi3xM0wdE/yYyE8OR3LF5KEd6/x8917SthYHdfS7BAygJja+KnEDBkQ+//BK5UHD6YbWnsZxLrPlUprYZh
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:52:07.8286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 168395ea-84bf-4284-1276-08ded91b0976
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B622.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8365

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
 drivers/irqchip/irq-gic-v5.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index e9d1795235a66..c04523a438cee 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1143,10 +1143,18 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
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
