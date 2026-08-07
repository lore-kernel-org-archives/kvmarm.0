Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010040.outbound.protection.outlook.com [52.101.69.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD708472797
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.40
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102273; cv=fail; b=SS2TIHFu/TRJ4D/s0ixU9iFEXQ4Q25PNMsFbxDGSlN/1nZUnfL9E6BfiRZHM9TyWd6FyP0DhNXZmJGmIvBr7BQKKwYU0DE7SmQrihJhq3yLSgUw1v4oNTXyfl/w+14Ni/b4AzHziqrWFo7BUwQZZ/BQTH58GJXV5e+ByXIVrT3Y=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102273; c=relaxed/simple;
	bh=3MzrYJvHjkPNUOv3t+s7Db75RoP5+3E7CKlQISyTh9M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Klu5PrM60enSjaLHrAvtZfCMMK3GTVgO0A5BcWRaBFZfQIR0QxrWzvq0OaVoNbCt8ilKzQwO3MbenBkfaZiyQtlDX2m7i9H+l5wj92ezylt519XhZW44fgnscjOlwcNIUp/Iq27XUA9i5xTcAvbdshHFXejF15Wgsj00asHPDP4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cgoCxZcx; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cgoCxZcx; arc=fail smtp.client-ip=52.101.69.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cgoCxZcx";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cgoCxZcx"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qDhBkvtFmmcA9mWefZO9EvIVqRNxLorGD3eBOLRE1y0L4IW0qPRhUDs3SHNioJCpHA2IlC3LaLpXO7SGlCuCJPbPoXyLCAZvBohKmVaiJGDNfCYFVOVMAea7ZQQPWC00Hk+D3TztYRUM9B24iyUoA0UcpH1awAovNFTclIdVmxZ8CvvxYRV1jAYkCDWA6d6dTcW/KR6CexcW1FSDGL93nNIhjuqn1p97KBGQFFcK7Ee8ql0tDpnusjCylbJ9XvHhv4hnqIN4tTrbpJv5e9XOh42YnB/gnSWDCy69RRyN4W4XsOST3yPRQ7noQgixgpekAqi9rE0+uPSaaH5k5Bwgdg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+o8yfTLoXvWbW25KfGoRq52AqhtIc9DQpQPlut3KobE=;
 b=dboKeAd3yAfcKqhLSlscSRmodc3SPS33MxR5ZXsJhXiBvG2L+LKS/1GQZde7tx6DLOC3MGbowtYwzgSfp9comP1mxtnE8d8W3jTJI55rr1esKndDdCt/2FUThqze2Zllef/eZrp4ULkhWCDpl9om9bfn5iOQO/h+u7ToUxlrXmwAmauPpxqV+NY+0SV6LJ+kkAv1rXyvNFwPhaNXHVom/8AEKI+/cDyT8JZ6Tc5r+DCizCFuJnpwsHJSAURMh2bhSvswW/OGDZxJJqR+4p9E8rDEPc2boy1uoVFvs5XXzdpHSD5DvffvGN+8lyd2u6j9LSpXkmzXEUtI18I4yXhzrw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+o8yfTLoXvWbW25KfGoRq52AqhtIc9DQpQPlut3KobE=;
 b=cgoCxZcxS1k8ORAt5O/zSjgjicl8xLty5Qxoeh3U1EhLMhSw+TeBUcF+dc+2K20lGrjlZ3oAQwwOFMGGHw23qpBypg3TtnVPNASc6hA1sXQl1N/L8ZKkru5pFPhebzSb++KQ0JqBtQLAMZMrImfsWrzKMVKV0qZGZmN3MVQ3miY=
Received: from AS4PR09CA0030.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::20)
 by PAWPR08MB10897.eurprd08.prod.outlook.com (2603:10a6:102:46a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:30:59 +0000
Received: from DB3PEPF0000885E.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::2e) by AS4PR09CA0030.outlook.office365.com
 (2603:10a6:20b:5d4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:30:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885E.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:30:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dhjm6wozpDjhdYoxa6WjZBlTp1HvqizF4vOkDAmqRpnEMFo61wBU2Npc1Yg48lLPd0SOLWq3d86aSmlagmHmC4kDLeCnoAnK46kbbaD4hABlhFSWYNL0ooFFhQrl6iafjdHMVp3KaNA3Y6v4OCBgkOvuKOtOpxUEE3dOOeuE7l6tvrv8n0d8B1nPOee4oUlwPhHevGD2g+1IX6niaUlfmAKq8zDdVhXjVm5EhOb59VmDBrndMn9aPVEhwaFkWE5vWgm3TRiAp3u9YrnCKtLcY+7Z+CcoHbyM8GFDQFULipnQ7K1XRqQy1351BylZVUaiJdwQg93K/0NMPtYVmLJ59g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+o8yfTLoXvWbW25KfGoRq52AqhtIc9DQpQPlut3KobE=;
 b=mg+3rc5hp/mMcVd/o8QO92lSq0om6avIg9ehYXiK55esobHI0jH0fpM0OkViS2P6NdJUoNHRQLnF/jchyXQ8jaU/1j+oDqikwzzt55EokfYaA53/VwVYIOGeRfDvmB72SOPFVjlf0Vd17cw5OWLXYIsmCAYq1cf9YK7qo/XdjWNlSX+RuVnrkLB6AM4oeB71u/VUMuguCHabrEOZI5nAnry/M+uZTEMldChwdK/7mZcyU6m0rt5KwthZ4rFF7CHuweKOaCd0GOGVL24vqiurVsVB7UnhCFB5X3Qpfa3mZ9o7Y/VVfsBxcSmdIy9pCrKn/AjuedeL/+73IqmHPUmekA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+o8yfTLoXvWbW25KfGoRq52AqhtIc9DQpQPlut3KobE=;
 b=cgoCxZcxS1k8ORAt5O/zSjgjicl8xLty5Qxoeh3U1EhLMhSw+TeBUcF+dc+2K20lGrjlZ3oAQwwOFMGGHw23qpBypg3TtnVPNASc6hA1sXQl1N/L8ZKkru5pFPhebzSb++KQ0JqBtQLAMZMrImfsWrzKMVKV0qZGZmN3MVQ3miY=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AS8PR08MB7308.eurprd08.prod.outlook.com (2603:10a6:20b:443::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:30:26 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:30:25 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v5 35/49] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Topic: [PATCH v5 35/49] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Index: AQHdJmAkIVEQ06D3K06pVJap7VmeFQ==
Date: Fri, 7 Aug 2026 11:30:25 +0000
Message-ID: <20260807111159.429128-36-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|AS8PR08MB7308:EE_|DB3PEPF0000885E:EE_|PAWPR08MB10897:EE_
X-MS-Office365-Filtering-Correlation-Id: 35fece48-0721-46db-cbba-08def4775a7d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|5023799004|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 ubCgLbPs6YL/NzORTpdS7vBYPoLEzbNLdT1A8pd1EZBUkRiGCjWA2OPgQT7lqs+ZyWFwj1b1M8NZSlnXEzg1owkiFNgEgDg92vre/+mTYPw61BOR2/rR8pFtkddKQwcqmmhNrsl6lhtMmJhmDf1mqoXyemTOKXxjPMiOuMDipdJkrC6TU9RWn9I0tocJMwyYijM977fwdlRPbQNYixvo9Mx5kN4Ywla8y4IiOzroUcK8Tw4ITs+Z0iEpriXuUY/6pBdIRtFqd1hh831jVcrurZo7eVS7sIqG8gv9VJPglE+mPMgp0tnvqwkNrX7ODfTPBeLflsCHjrcHxFCynp2q5A6fvEIYF/cKq3CGC4TZ37J1i+6zbPLnHExqKfRLYeQq/EekphV4DPBm+P48fMYNP0PGXbw8NI0U955GZJAKTwPoLHjsq0fxwdvs9cJKPhjWQaRXaC+TmZofJvC3sNRr96v5E05tgJv5NigPu3wv0LT/vJG1HKd6Xu6shXkHRb3MfYSPLlsxXl4IHKAHeBJUMbMGS5OfT1eRkkybcmruh2ilmKOy/rRJJ4uKNyfjJ81gYSbwBQ7WOXFTa+peD8AaMFucEYL6bV+B+TIZnNsoe/dl5WuNmbMkqmZG0jeBxTmAJxIqMbz0dKW1BBZbrx6bfv8xEcxfVR7P8NwDw28AL8MSmMM554fYGTsTc+xty0K/lw5cjeuLsdok2r0mLf/ElF2fyIihaLqUXXosZ5ikBNI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 FDelceBEI/GvDmgjsaBS6t8lcOzfDYi0XjuKaVRLJA77VRd2AIsBH+cmnKtSmII0rboviO1tcItdy44s++8D8ODAdEllnpfRAHUpxGibvqXImBh+ykM7KmV/0BRjF3emAjydZA6QRHCSKFoZM8sSzO9YFAzA8Fi/c2kR4RjdlBnXolJerrGB8PNS1+FiLu6WekKBmFQZYdn/6lP8XUmmi+2uErq/mYrIGgt0SiCT7ggkH1Kb3Jr3pVex/++yyTgINM/ze165hbjtAOyWhxE+sBJJjivTmgVg/ZwZFvbBvPVSfibe2iooNd4tf6u3rxzjX6LfYvxe2Qiw+ZFnGEDW6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7308
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	69119004-173e-419c-b6fa-08def47746b6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|376014|36860700016|23010399003|14060799003|82310400026|18002099003|22082099003|10067099003|5023799004|56012099006|6133799003|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info:
	95oFZ7wf3+UMLb+2qCyrLz40JazU1R+b4NZg3nv79TLyQYY3bxMsdy+e+Eb7jvRLDj2RZMLCu41dJiE0orgUjsdZaTHLNLXsiJXfIqeKPzxYbAMIjN6ciAvPKPSt1G2/SQ+CdFziTi9ThknUfqjsFi8eHjRg0z7C1dnvunrmYr7cRab+geT1po/pRG1nvmyOOTMu2KbcKfxKZMaJ1pSzS5QLA7pf0jV9uqI3SsdLBxhugSPxsArPmjnUQEmR8dOKtMUhlpNVyYRc/c7IfiPj0UnPAxWOsO6cWIZAzHPcMLtYnNmQY4uDsOCuiia88MekySlJllGQn2luVYi+nLxgksYzrPZH3Pz+6k2EHYdJp8Uqjg9b+Q9oMkdxsnyvFnlGrsNlMBHCdxCiNnPW1iag7FOY72PXMNpGqkZwlqLY+NvFOhne+oIVJEUFKipm/AYJXPO6SIktywzrkcWLBxJOzAPBQWJB3IIEeqFfb+xnyVn0sMnVwdAH5tgp/GfUlSaoStJEvl6Jauy3s9qG+6+ujQqfiDDEBPIqHhboOFYbr/BwSCRBNaNpLcJqVbKBVlXxsx8MhvWyiJvWQbIzDKNyVDrZy6vNfqFKxEwGyOvC0mc0euM+TMfG7fETjwgHjd4y6krDBjNP1lUCPiTxxoRxvLcn5X5wW9Hi4TULIzzRsF/xQNhiYamHYP1F0iCb3+qzfPz/A/FmFAoTeQiW+OK0SQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(376014)(36860700016)(23010399003)(14060799003)(82310400026)(18002099003)(22082099003)(10067099003)(5023799004)(56012099006)(6133799003)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3G5P54Nyimvrn1F2BpzNv4qunZOQfGxe+Tj5vbJodALMJoeRTcbtlPqTUPtJrogDHbh8i0s/9RYwS68tSoirR7JueNCeDHR6OHLzLGcAh8Hh+zZbCek3RNhmlcg9+JP7rY1g6UzrP7KMWVXkawPVnXnH5X1UZAD8jMYwqBzO+jMCQVgHL9cCxpne30/b8v0Zefc7SYEQWwVqADUUjbjnNPV2yQ8oRQGJmkragz1FUBd7Tmd9ADStEbsMmo3vIMFMdsrZBV+FYUBEOZ+JNp003y6g9jE/Vrg0LQ/rIYseN9zMOFvM0m9Klq7GxqSEeVSaG8ockNVmDfo2T1Y5WuDudZOe8PqUz1Xx4AFfr8mlCjU61f0KVgj51c3fKiEKASSlzwXLjmO1mNXekR6+FSH4yb+Gc2/hoLKFW4eFbUrMAUVYIMMyQIBnm+gjnsPmHKGe
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:30:58.8572
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35fece48-0721-46db-cbba-08def4775a7d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10897

When running a GICv5 VM, there are up to two ISTs that must be saved
or restored when migrating a VM.

The SPI IST is allocated by the hypervisor, as the guest presumes the
memory for the SPI state is allocated by the hardware. The LPI IST is
also shadowed in KVM when the guest enables LPIs, so the guest's LPI
IST memory is not used directly by the physical GICv5 hardware.

As both in-use ISTs are backed by host allocations, userspace provides
migration storage for both tables through KVM_DEV_ARM_VGIC_GRP_IST.
The userspace descriptor supplies separate SPI and LPI buffers, each
containing the architected 32-bit ISTE state for the corresponding
interrupt number space. If the guest has not configured an LPI IST,
userspace must omit the LPI buffer.

On save, acquire every vCPU mutex, returning -EBUSY if any vCPU is
already running. Holding these locks blocks KVM_RUN while the IST
state is exported. Use IRS_SAVE_VMR to write the IRS's internal state
back to the ISTs and check that the VM remained quiescent. After
copying each IST, issue a Q-only IRS_SAVE_VMR operation to update
IRS_SAVE_VM_STATUSR.Q and repeat the check. If the VM has not remained
quiescent since the save began, propagate an error to userspace so
that the save can be retried without losing incoming interrupt state.

On restore, reject the operation if any vCPU has already run. Validate
the userspace buffers and, if the restored IRS state describes an LPI
IST, allocate the shadow host IST while the VMTE is still valid. This
allows the IRS operation that assigns the IST to update the VMTE.
Then make the VMTE invalid before copying the SPI and LPI IST state
from the userspace-provided buffers, and make it valid again once the
copy is complete.

As part of restoring the ISTs, track pending interrupts and clear
their pending state from the restored host ISTs. Once the VM is valid
again, make those interrupts pending through the GIC VDPEND system
instruction.

Once a host LPI IST has been allocated, the guest-visible
IRS_IST_BASER and IRS_IST_CFGR state describes that allocation.
Userspace may replay values with the same defined fields, but KVM
rejects changes while the host IST exists. During save, also require
the VMTE IST_ID_BITS value to match IRS_IST_CFGR.LPI_ID_BITS so that
userspace buffer validation and the host IST walk use the same number
of entries.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c     |  47 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  13 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c  | 596 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h  |  16 +
 arch/arm64/kvm/vgic/vgic-v5.c         | 330 +++++++++++++-
 arch/arm64/kvm/vgic/vgic.h            |   5 +
 6 files changed, 1001 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 22f8ce3b7c83a..72eef5737c8c4 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -370,6 +370,20 @@ static bool vgic_v5_ist_cfgr_valid(struct vgic_v5_irs =
*irs)
 	return irs->ist_cfgr.l2sz =3D=3D irs->idr2.ist_l2sz;
 }
=20
+static bool vgic_v5_ist_cfgr_matches(const struct vgic_v5_irs *irs,
+				     unsigned long val)
+{
+	u8 lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_BITS, val);
+	u8 l2sz =3D FIELD_GET(GICV5_IRS_IST_CFGR_L2SZ, val);
+	u8 istsz =3D FIELD_GET(GICV5_IRS_IST_CFGR_ISTSZ, val);
+	bool structure =3D !!(val & GICV5_IRS_IST_CFGR_STRUCTURE);
+
+	return irs->ist_cfgr.lpi_id_bits =3D=3D lpi_id_bits &&
+	       irs->ist_cfgr.l2sz =3D=3D l2sz &&
+	       irs->ist_cfgr.istsz =3D=3D istsz &&
+	       irs->ist_cfgr.structure =3D=3D structure;
+}
+
 static unsigned long vgic_v5_mmio_read_irs_ist(struct kvm_vcpu *vcpu,
 					       gpa_t addr, unsigned int len)
 {
@@ -550,6 +564,7 @@ static int vgic_v5_mmio_uaccess_write_irs(struct kvm_vc=
pu *vcpu, gpa_t addr,
 	struct vgic_dist *vgic =3D &vcpu->kvm->arch.vgic;
 	struct vgic_v5_irs *irs_data =3D vgic->vgic_v5_irs_data;
 	size_t offset =3D addr & (SZ_64K - 1);
+	int ret;
=20
 	/*
 	 * The following registers are ONLY settable via uaccesses. The guest
@@ -646,13 +661,23 @@ static int vgic_v5_mmio_uaccess_write_irs(struct kvm_=
vcpu *vcpu, gpa_t addr,
 			return -EINVAL;
 		break;
 	case GICV5_IRS_IST_BASER:
-		if (irs_data->ist_baser.valid &&
-		    !vgic_v5_ist_baser_matches(irs_data, val))
+		ret =3D vgic_v5_lpi_ist_exists(vcpu->kvm);
+		if (ret < 0)
+			return ret;
+
+		if (ret && !vgic_v5_ist_baser_matches(irs_data, val))
 			return -EINVAL;
=20
 		vgic_v5_update_irs_ist_baser(irs_data, val);
 		break;
 	case GICV5_IRS_IST_CFGR:
+		ret =3D vgic_v5_lpi_ist_exists(vcpu->kvm);
+		if (ret < 0)
+			return ret;
+
+		if (ret && !vgic_v5_ist_cfgr_matches(irs_data, val))
+			return -EINVAL;
+
 		irs_data->ist_cfgr.lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_B=
ITS, val);
 		irs_data->ist_cfgr.l2sz =3D FIELD_GET(GICV5_IRS_IST_CFGR_L2SZ, val);
 		irs_data->ist_cfgr.istsz =3D FIELD_GET(GICV5_IRS_IST_CFGR_ISTSZ, val);
@@ -1053,6 +1078,24 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned i=
nt nr_spis)
 	return 0;
 }
=20
+int vgic_v5_irs_lpi_ist_id_bits(struct kvm *kvm, unsigned int *id_bits)
+{
+	struct vgic_v5_irs *irs =3D kvm->arch.vgic.vgic_v5_irs_data;
+
+	if (!irs)
+		return -ENXIO;
+
+	if (!irs->ist_baser.valid)
+		return 0;
+
+	if (!vgic_v5_ist_cfgr_valid(irs))
+		return -EINVAL;
+
+	*id_bits =3D irs->ist_cfgr.lpi_id_bits;
+
+	return 1;
+}
+
 int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr)
 {
 	const struct vgic_register_region *region;
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index f1f1fcb08161f..1c205cb1361fd 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -920,6 +920,11 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		if (attr->attr)
+			return -ENXIO;
+
+		return vgic_v5_irs_restore_ists(dev->kvm, attr);
 	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
 		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
@@ -948,6 +953,11 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		if (attr->attr)
+			return -ENXIO;
+
+		return vgic_v5_irs_save_ists(dev->kvm, attr);
 	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
 		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
@@ -997,6 +1007,9 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 		default:
 			return -ENXIO;
 		}
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		return attr->attr ? -ENXIO : 0;
 	default:
 		return -ENXIO;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index fa2ced036f7cd..201d2d5025dea 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -10,6 +10,7 @@
 #include <linux/mutex.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
 #include <linux/xarray.h>
 #include <asm/kvm_mmu.h>
=20
@@ -65,6 +66,20 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VPED_ADDR_SHIFT		3ULL
 #define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
=20
+/* L2 Interrupt State Table Entry */
+#define GICV5_ISTL2E_PENDING		BIT(0)
+#define GICV5_ISTL2E_ACTIVE		BIT(1)
+#define GICV5_ISTL2E_HM			BIT(2)
+#define GICV5_ISTL2E_ENABLE		BIT(3)
+#define GICV5_ISTL2E_IRM		BIT(4)
+#define GICV5_ISTL2E_HWU		GENMASK(10, 9)
+#define GICV5_ISTL2E_PRIORITY		GENMASK(15, 11)
+#define GICV5_ISTL2E_IAFFID		GENMASK(31, 16)
+
+#define GICV5_ISTE_SIZE(istsz)		BIT((istsz) + 2)
+#define GICV5_LINEAR_IST_SIZE(id_bits, istsz)	\
+	(BIT(id_bits) * GICV5_ISTE_SIZE(istsz))
+
 /*
  * The LPI and SPI configuration is stored in the 2nd and 3rd 64-bit chunk=
s of
  * the VMTE (0-based). We call this a section here in an attempt to simpli=
fy the
@@ -73,6 +88,26 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VMTEL2_LPI_SECTION	2
 #define GICV5_VMTEL2_SPI_SECTION	3
=20
+struct vgic_v5_ist_desc {
+	struct vgic_v5_vm_info	*vmi;
+	void			*base;
+	unsigned int		id_bits;
+	unsigned int		istsz;
+	unsigned int		l2sz;
+	size_t			iste_size;
+	bool			present;
+};
+
+struct vgic_v5_two_level_ist_shape {
+	size_t	l1_entries;
+	size_t	l2_entries;
+};
+
+struct vgic_v5_pending_irq {
+	u32			irq;
+	struct list_head	next;
+};
+
 static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
 				    unsigned int id_bits,
 				    unsigned int istsz);
@@ -106,6 +141,22 @@ static void vgic_v5_clean_inval(void *va, size_t size)
 		dcache_clean_inval_poc(base, base + size);
 }
=20
+static void vgic_v5_drain_pending_irqs(struct kvm *kvm,
+				       struct vgic_v5_vm_info *vmi,
+				       bool reinject)
+{
+	struct vgic_v5_pending_irq *pirq, *tmp;
+
+	list_for_each_entry_safe(pirq, tmp, &vmi->pending_irqs, next) {
+		if (reinject)
+			kvm_call_hyp(__vgic_v5_vdpend, pirq->irq, true,
+				     vgic_v5_vm_id(kvm));
+
+		list_del(&pirq->next);
+		kfree(pirq);
+	}
+}
+
 /*
  * Create a linear VM Table. Directly using the number of entries supplied=
 as
  * the size of an L2 VMTE (32 bytes) guarantees that our allocation is ali=
gned per
@@ -465,6 +516,13 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 		goto out_fail;
 	vmi_inserted =3D true;
=20
+	/*
+	 * If we are restoring the state of a guest, we need to re-inject any
+	 * IRQs that were pending when the state of the guest was originally
+	 * saved. We use the pending_irqs list for this.
+	 */
+	INIT_LIST_HEAD(&vmi->pending_irqs);
+
 	/* Allocate and assign the VM Descriptor, if required. */
 	if (vmt_info->vmd_size !=3D 0) {
 		vmd_alloc_size =3D round_up(vmt_info->vmd_size,
@@ -604,6 +662,9 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	if (!vmi)
 		goto no_vmi;
=20
+	/* Unlikely, but possible. Avoid leaking the memory. */
+	vgic_v5_drain_pending_irqs(kvm, vmi, false);
+
 	/* If we have an LPI IST, free it */
 	if (vmi->h_lpi_ist) {
 		ret =3D vgic_v5_lpi_ist_free(kvm);
@@ -1186,6 +1247,18 @@ static int vgic_v5_spi_ist_free(struct kvm *kvm)
 	return vgic_v5_linear_ist_free(kvm, true);
 }
=20
+int vgic_v5_lpi_ist_exists(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	return !!vmi->h_lpi_ist;
+}
+
 /*
  * Allocate an IST for LPIs.
  *
@@ -1262,3 +1335,526 @@ int vgic_v5_lpi_ist_free(struct kvm *kvm)
 	else
 		return vgic_v5_two_level_ist_free(kvm, false);
 }
+
+static struct vgic_v5_two_level_ist_shape
+vgic_v5_two_level_ist_shape(const struct vgic_v5_ist_desc *ist)
+{
+	struct vgic_v5_two_level_ist_shape shape;
+	size_t l2bits, n;
+
+	l2bits =3D (10 - ist->istsz) + (2 * ist->l2sz);
+	n =3D max(2, ist->id_bits - l2bits + 3 - 1);
+
+	shape.l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+	shape.l2_entries =3D BIT(l2bits);
+
+	return shape;
+}
+
+static int vgic_v5_read_vm_ist_desc(struct kvm *kvm, unsigned int section,
+				    struct vgic_v5_ist_desc *ist)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	u64 vmte_ist_section;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		vmte_ist_section =3D le64_to_cpu(READ_ONCE(vmte->val[section]));
+	}
+
+	ist->id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, vmte_ist_section);
+	ist->istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, vmte_ist_section);
+	ist->l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, vmte_ist_section);
+	ist->iste_size =3D GICV5_ISTE_SIZE(ist->istsz);
+
+	return !!(vmte_ist_section & GICV5_VMTEL2E_IST_VALID);
+}
+
+static int vgic_v5_get_spi_ist_desc(struct kvm *kvm,
+				    struct vgic_v5_ist_desc *ist)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	int ret;
+
+	memset(ist, 0, sizeof(*ist));
+
+	ist->vmi =3D xa_load(&vm_info, vm_id);
+	if (!ist->vmi)
+		return -ENXIO;
+
+	ret =3D vgic_v5_read_vm_ist_desc(kvm, GICV5_VMTEL2_SPI_SECTION, ist);
+	if (ret < 0)
+		return ret;
+
+	ist->base =3D ist->vmi->h_spi_ist;
+	if (!ret || !ist->base)
+		return -ENXIO;
+
+	ist->present =3D true;
+	return 0;
+}
+
+static int vgic_v5_get_lpi_ist_desc(struct kvm *kvm,
+				    struct vgic_v5_ist_desc *ist)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	bool guest_valid, host_valid;
+	int ret;
+
+	memset(ist, 0, sizeof(*ist));
+
+	ist->vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!ist->vmi))
+		return -ENXIO;
+
+	ret =3D vgic_v5_read_vm_ist_desc(kvm, GICV5_VMTEL2_LPI_SECTION, ist);
+	if (ret < 0)
+		return ret;
+
+	host_valid =3D ret;
+	guest_valid =3D kvm->arch.vgic.vgic_v5_irs_data->ist_baser.valid;
+	ist->base =3D ist->vmi->h_lpi_ist;
+
+	/* If there is no IST to save/restore, return without error. */
+	if (!guest_valid && !host_valid && !ist->base)
+		return 0;
+
+	/* Mismatched combination of valid state */
+	if (!guest_valid || !host_valid || !ist->base)
+		return -ENXIO;
+
+	if (ist->vmi->h_lpi_ist_structure && !ist->vmi->h_lpi_l2_ists)
+		return -ENXIO;
+
+	ist->present =3D true;
+	return 0;
+}
+
+/*
+ * Save a linear host IST to userspace memory.
+ *
+ * Only the architected 32-bit ISTE state is stored. Metadata is skipped w=
hen
+ * striding through the host IST.
+ */
+static int vgic_v5_save_linear_ist(const struct vgic_v5_ist_desc *ist,
+				   u32 __user *uaddr, size_t nr_entries)
+{
+	__le32 h_iste;
+	size_t index;
+	int ret;
+
+	vgic_v5_clean_inval(ist->base,
+			    GICV5_LINEAR_IST_SIZE(ist->id_bits, ist->istsz));
+
+	for (index =3D 0; index < nr_entries; index++) {
+		__le32 *h_iste_addr =3D ist->base + index * ist->iste_size;
+
+		h_iste =3D READ_ONCE(*h_iste_addr);
+		ret =3D put_user(h_iste, uaddr);
+		if (ret)
+			return ret;
+
+		uaddr++;
+	}
+
+	return 0;
+}
+
+/*
+ * Save a two-level host IST to userspace memory.
+ *
+ * Only the architected 32-bit ISTE state is stored. Metadata is skipped w=
hen
+ * striding through the host IST.
+ */
+static int vgic_v5_save_two_level_ist(const struct vgic_v5_ist_desc *ist,
+				      u32 __user *uaddr)
+{
+	struct vgic_v5_two_level_ist_shape shape;
+	size_t h_l1_index, h_l2_index;
+	void *h_l2_ist_base;
+	__le32 h_iste;
+	int ret;
+
+	shape =3D vgic_v5_two_level_ist_shape(ist);
+
+	vgic_v5_clean_inval(ist->base,
+			    shape.l1_entries * sizeof(*ist->vmi->h_lpi_ist));
+
+	for (h_l1_index =3D 0; h_l1_index < shape.l1_entries; h_l1_index++) {
+		u64 l1_iste;
+
+		/*
+		 * Host L2 ISTs are preallocated. Any invalid L1 entry means the
+		 * host IST state is inconsistent.
+		 */
+		l1_iste =3D le64_to_cpu(READ_ONCE(ist->vmi->h_lpi_ist[h_l1_index]));
+		if (!FIELD_GET(GICV5_ISTL1E_VALID, l1_iste))
+			return -ENXIO;
+
+		h_l2_ist_base =3D ist->vmi->h_lpi_l2_ists[h_l1_index];
+		if (!h_l2_ist_base)
+			return -ENXIO;
+
+		vgic_v5_clean_inval(h_l2_ist_base,
+				    shape.l2_entries * ist->iste_size);
+
+		for (h_l2_index =3D 0; h_l2_index < shape.l2_entries; h_l2_index++) {
+			h_iste =3D *(__le32 *)(h_l2_ist_base +
+					     h_l2_index * ist->iste_size);
+
+			ret =3D put_user(h_iste, uaddr);
+			if (ret)
+				return ret;
+
+			uaddr++;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Save the SPI IST to userspace-provided memory.
+ */
+int vgic_v5_save_spi_ist(struct kvm *kvm, struct kvm_vgic_v5_ist *ist_attr=
)
+{
+	struct vgic_v5_ist_desc ist;
+	u32 __user *uaddr;
+	int ret;
+
+	ret =3D vgic_v5_get_spi_ist_desc(kvm, &ist);
+	if (ret)
+		return ret;
+
+	uaddr =3D (u32 __user *)(unsigned long)ist_attr->spi_ist_addr;
+
+	/* The host SPI IST is always linear. */
+	return vgic_v5_save_linear_ist(&ist, uaddr,
+				       kvm->arch.vgic.nr_spis);
+}
+
+/*
+ * Save the LPI IST to userspace memory.
+ *
+ * The LPI IST may be linear or two-level, so host iteration depends on th=
e
+ * allocated host shape.
+ */
+int vgic_v5_save_lpi_ist(struct kvm *kvm, struct kvm_vgic_v5_ist *ist_attr=
)
+{
+	struct vgic_v5_ist_desc ist;
+	u32 __user *uaddr;
+	int ret;
+
+	ret =3D vgic_v5_get_lpi_ist_desc(kvm, &ist);
+	if (ret)
+		return ret;
+
+	if (!ist.present)
+		return 0;
+
+	/*
+	 * Userspace sized the buffer from the guest-visible configuration.
+	 * Refuse to walk a host IST with a different number of entries.
+	 */
+	if (ist.id_bits !=3D
+	    kvm->arch.vgic.vgic_v5_irs_data->ist_cfgr.lpi_id_bits)
+		return -EINVAL;
+
+	uaddr =3D (u32 __user *)(unsigned long)ist_attr->lpi_ist_addr;
+
+	if (!ist.vmi->h_lpi_ist_structure)
+		return vgic_v5_save_linear_ist(&ist, uaddr,
+					       BIT(ist.id_bits));
+
+	return vgic_v5_save_two_level_ist(&ist, uaddr);
+}
+
+/*
+ * Track any SPIs and LPIs that were marked as pending at the point where =
the
+ * IST was restored.
+ *
+ * Restored pending state is cleared from the host ISTE and replayed with =
VDPEND
+ * before the VM first runs.
+ */
+static int vgic_v5_track_pending_irq(struct list_head *pending_irqs, u32 i=
ntid,
+				     u32 type)
+{
+	struct vgic_v5_pending_irq *pirq;
+
+	pirq =3D kzalloc_obj(*pirq, GFP_KERNEL);
+	if (!pirq)
+		return -ENOMEM;
+
+	/* Encode the interrupt as a GICv5 IntID. */
+	pirq->irq =3D FIELD_PREP(GICV5_HWIRQ_TYPE, type) |
+		    FIELD_PREP(GICV5_HWIRQ_ID, intid);
+
+	INIT_LIST_HEAD(&pirq->next);
+	list_add_tail(&pirq->next, pending_irqs);
+
+	return 0;
+}
+
+/*
+ * Process and sanitise each restored ISTE.
+ *
+ * HWU is for hardware use and must not survive migration. Pending state i=
s
+ * tracked, cleared from the ISTE, and replayed before the VM first runs.
+ */
+static int vgic_v5_process_iste(__le32 *iste, struct list_head *pending_ir=
qs,
+				u32 intid, u32 type)
+{
+	u32 iste_data =3D le32_to_cpu(READ_ONCE(*iste));
+	int ret;
+
+	/* Pending state is replayed later with VDPEND. */
+	if (iste_data & GICV5_ISTL2E_PENDING) {
+		ret =3D vgic_v5_track_pending_irq(pending_irqs, intid, type);
+		if (ret)
+			return ret;
+	}
+
+	iste_data &=3D ~GICV5_ISTL2E_PENDING;
+	iste_data &=3D ~GICV5_ISTL2E_HWU;
+
+	WRITE_ONCE(*iste, cpu_to_le32(iste_data));
+
+	return 0;
+}
+
+static void vgic_v5_restore_spi_config(struct kvm *kvm, __le32 iste, u32 s=
pi)
+{
+	u32 iste_data =3D le32_to_cpu(iste);
+	bool pending =3D iste_data & GICV5_ISTL2E_PENDING;
+	struct vgic_irq *irq;
+	unsigned long flags;
+
+	irq =3D vgic_get_irq(kvm, vgic_v5_make_spi(spi));
+	if (WARN_ON_ONCE(!irq))
+		return;
+
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+	if (iste_data & GICV5_ISTL2E_HM)
+		irq->config =3D VGIC_CONFIG_LEVEL;
+	else
+		irq->config =3D VGIC_CONFIG_EDGE;
+
+	if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+		irq->pending_latch =3D pending;
+	else if (pending)
+		irq->pending_latch =3D true;
+	else if (!irq->active)
+		irq->pending_latch =3D false;
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	vgic_put_irq(kvm, irq);
+}
+
+static int vgic_v5_restore_ist_entry(struct kvm *kvm,
+				     const struct vgic_v5_ist_desc *ist,
+				     void *h_iste_addr, __le32 h_iste,
+				     u32 intid, u32 intid_type)
+{
+	__le32 raw_iste =3D h_iste;
+	int ret;
+
+	/*
+	 * Sanitise the IST, clearing HWU & pending fields. Pending state is
+	 * later replayed via GIC VDPEND.
+	 */
+	ret =3D vgic_v5_process_iste(&h_iste, &ist->vmi->pending_irqs,
+				   intid, intid_type);
+	if (ret)
+		return ret;
+
+	if (intid_type =3D=3D GICV5_HWIRQ_TYPE_SPI)
+		vgic_v5_restore_spi_config(kvm, raw_iste, intid);
+
+	/*
+	 * Zero the full ISTE (incl metadata), and write back the non-metadata
+	 * region, only.
+	 */
+	memset(h_iste_addr, 0, ist->iste_size);
+	WRITE_ONCE(*(__le32 *)h_iste_addr, h_iste);
+	vgic_v5_clean_inval(h_iste_addr, ist->iste_size);
+
+	return 0;
+}
+
+/*
+ * Restore a userspace IST image to a linear host IST.
+ *
+ * The userspace IST image is a linear array of 32-bit ISTEs.
+ */
+static int vgic_v5_restore_linear_ist(struct kvm *kvm,
+				      const struct vgic_v5_ist_desc *ist,
+				      u32 __user *uaddr, size_t nr_entries,
+				      u32 intid_type)
+{
+	__le32 h_iste;
+	size_t index;
+	int ret;
+
+	for (index =3D 0; index < nr_entries; index++) {
+		void *h_iste_addr =3D ist->base + index * ist->iste_size;
+
+		ret =3D get_user(h_iste, uaddr);
+		if (ret)
+			return ret;
+
+		ret =3D vgic_v5_restore_ist_entry(kvm, ist, h_iste_addr,
+					h_iste, index, intid_type);
+		if (ret)
+			return ret;
+
+		uaddr++;
+	}
+
+	return 0;
+}
+
+/*
+ * Restore a userspace IST image to a two-level host IST.
+ *
+ * The userspace IST image is a linear array of 32-bit ISTEs.
+ */
+static int vgic_v5_restore_two_level_ist(struct kvm *kvm,
+					 const struct vgic_v5_ist_desc *ist,
+					 u32 __user *uaddr, u32 intid_type)
+{
+	struct vgic_v5_two_level_ist_shape shape;
+	size_t h_l1_index, h_l2_index;
+	void *h_l2_ist_base;
+	__le32 h_iste;
+	int ret;
+
+	shape =3D vgic_v5_two_level_ist_shape(ist);
+
+	vgic_v5_clean_inval(ist->vmi->h_lpi_ist,
+			    shape.l1_entries * sizeof(*ist->vmi->h_lpi_ist));
+
+	for (h_l1_index =3D 0; h_l1_index < shape.l1_entries; ++h_l1_index) {
+		u64 l1_iste;
+
+		/*
+		 * Host L2 ISTs are preallocated. Any invalid L1 entry means the
+		 * host IST state is inconsistent.
+		 */
+		l1_iste =3D le64_to_cpu(READ_ONCE(ist->vmi->h_lpi_ist[h_l1_index]));
+		if (!FIELD_GET(GICV5_ISTL1E_VALID, l1_iste))
+			return -ENXIO;
+
+		h_l2_ist_base =3D ist->vmi->h_lpi_l2_ists[h_l1_index];
+		if (!h_l2_ist_base)
+			return -ENXIO;
+
+		for (h_l2_index =3D 0; h_l2_index < shape.l2_entries; h_l2_index++) {
+			void *h_iste_addr =3D h_l2_ist_base +
+					    h_l2_index * ist->iste_size;
+			u32 intid =3D h_l1_index * shape.l2_entries + h_l2_index;
+
+			ret =3D get_user(h_iste, uaddr);
+			if (ret)
+				return ret;
+
+			ret =3D vgic_v5_restore_ist_entry(kvm, ist, h_iste_addr,
+							h_iste, intid,
+							intid_type);
+			if (ret)
+				return ret;
+
+			uaddr++;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Restore the SPI IST from userspace-provided buffer to the host-allocate=
d IST.
+ */
+int vgic_v5_restore_spi_ist(struct kvm *kvm, struct kvm_vgic_v5_ist *ist_a=
ttr)
+{
+	u32 __user *uaddr;
+	struct vgic_v5_ist_desc ist;
+	int ret;
+
+	ret =3D vgic_v5_get_spi_ist_desc(kvm, &ist);
+	if (ret)
+		return ret;
+
+	uaddr =3D (u32 __user *)(unsigned long)ist_attr->spi_ist_addr;
+
+	/* The host SPI IST is always linear. */
+	return vgic_v5_restore_linear_ist(kvm, &ist, uaddr,
+					  kvm->arch.vgic.nr_spis,
+					  GICV5_HWIRQ_TYPE_SPI);
+}
+
+/*
+ * Restore the LPI IST from userspace memory to the host-allocated LPI IST=
.
+ *
+ * The host LPI IST may be linear or two-level, so host iteration depends =
on the
+ * host IST's shape.
+ */
+int vgic_v5_restore_lpi_ist(struct kvm *kvm, struct kvm_vgic_v5_ist *ist_a=
ttr)
+{
+	u32 __user *uaddr;
+	struct vgic_v5_ist_desc ist;
+	int ret;
+
+	ret =3D vgic_v5_get_lpi_ist_desc(kvm, &ist);
+	if (ret)
+		return ret;
+
+	if (!ist.present)
+		return 0;
+
+	uaddr =3D (u32 __user *)(unsigned long)ist_attr->lpi_ist_addr;
+
+	if (!ist.vmi->h_lpi_ist_structure)
+		return vgic_v5_restore_linear_ist(kvm, &ist, uaddr,
+						  BIT(ist.id_bits),
+						  GICV5_HWIRQ_TYPE_LPI);
+
+	return vgic_v5_restore_two_level_ist(kvm, &ist, uaddr,
+					     GICV5_HWIRQ_TYPE_LPI);
+}
+
+/*
+ * Process the pending IRQs removing them from the list and optionally inj=
ecting
+ * them.
+ */
+static int vgic_v5_process_pending_irqs(struct kvm *kvm, bool inject)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	vgic_v5_drain_pending_irqs(kvm, vmi, inject);
+
+	return 0;
+}
+
+/* Replay pending state that was cleared while restoring guest IST state. =
*/
+int vgic_v5_restore_pending_irqs(struct kvm *kvm)
+{
+	return vgic_v5_process_pending_irqs(kvm, true);
+}
+
+/* Drop pending state collected by a failed IST restore. */
+void vgic_v5_discard_pending_irqs(struct kvm *kvm)
+{
+	vgic_v5_process_pending_irqs(kvm, false);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index e28d39d59f7fb..b2ffbe68c05b4 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -9,6 +9,7 @@
 #include <linux/spinlock.h>
 #include <linux/idr.h>
 #include <linux/irqchip/arm-gic-v5.h>
+#include <linux/list.h>
=20
 /* Level 1 Virtual Machine Table Entry */
 typedef __le64 vmtl1_entry;
@@ -44,6 +45,9 @@ struct vgic_v5_vm_info {
 	__le64			*h_lpi_ist;
 	__le64			**h_lpi_l2_ists;
 	__le64			*h_spi_ist;
+
+	/* Tracking of pending interrupts as part of IST restore */
+	struct list_head	pending_irqs;
 };
=20
 struct vgic_v5_vmt {
@@ -118,7 +122,19 @@ int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
 int vgic_v5_spi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_exists(struct kvm *kvm);
 int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
 int vgic_v5_lpi_ist_free(struct kvm *kvm);
=20
+int vgic_v5_save_spi_ist(struct kvm *kvm,
+			 struct kvm_vgic_v5_ist *ist_attr);
+int vgic_v5_save_lpi_ist(struct kvm *kvm,
+			 struct kvm_vgic_v5_ist *ist_attr);
+int vgic_v5_restore_spi_ist(struct kvm *kvm,
+			    struct kvm_vgic_v5_ist *ist_attr);
+int vgic_v5_restore_lpi_ist(struct kvm *kvm,
+			    struct kvm_vgic_v5_ist *ist_attr);
+int vgic_v5_restore_pending_irqs(struct kvm *kvm);
+void vgic_v5_discard_pending_irqs(struct kvm *kvm);
+
 #endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index beabc5980b2c1..1d360a25639a7 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -5,10 +5,11 @@
=20
 #include <kvm/arm_vgic.h>
=20
-#include <linux/kvm_host.h>
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
 #include <linux/irqdomain.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
=20
 #include "vgic-v5-tables.h"
 #include "vgic.h"
@@ -221,6 +222,17 @@ static int vgic_v5_irs_wait_for_vpe_op(void)
 					NULL);
 }
=20
+/*
+ * Wait for a write to IRS_SAVE_VMR to complete.
+ */
+static int vgic_v5_irs_wait_for_save_vm_op(u32 *statusr)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_SAVE_VM_STATUSR,
+					GICV5_IRS_SAVE_VM_STATUSR_IDLE,
+					statusr);
+}
+
 static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
 {
 	int ret;
@@ -389,6 +401,27 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_i=
d,
 	return 0;
 }
=20
+static int vgic_v5_irs_save_vm_op(u16 vm_id, bool save, u32 *statusr)
+{
+	u64 save_vmr;
+	int ret;
+
+	save_vmr =3D FIELD_PREP(GICV5_IRS_SAVE_VMR_VM_ID, vm_id);
+	save_vmr |=3D GICV5_IRS_SAVE_VMR_Q;
+	save_vmr |=3D FIELD_PREP(GICV5_IRS_SAVE_VMR_S, save);
+
+	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
+
+	/* Make sure that we are idle to begin with. */
+	ret =3D vgic_v5_irs_wait_for_save_vm_op(NULL);
+	if (ret)
+		return ret;
+
+	irs_writeq_relaxed(save_vmr, GICV5_IRS_SAVE_VMR);
+
+	return vgic_v5_irs_wait_for_save_vm_op(statusr);
+}
+
 static irqreturn_t db_handler(int irq, void *data)
 {
 	struct kvm_vcpu *vcpu =3D data;
@@ -1099,9 +1132,9 @@ static bool vgic_v5_set_spi_pending_state(struct kvm_=
vcpu *vcpu,
 	return true;
 }
=20
-static bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
-					 struct vgic_irq *irq,
-					 unsigned long flags)
+bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
+				  struct vgic_irq *irq,
+				  unsigned long flags)
 	__releases(&irq->irq_lock)
 {
 	lockdep_assert_held(&irq->irq_lock);
@@ -1267,3 +1300,292 @@ void vgic_v5_save_state(struct kvm_vcpu *vcpu)
 	__vgic_v5_save_ppi_state(cpu_if);
 	dsb(sy);
 }
+
+static int vgic_v5_irs_status_is_quiesced(u32 statusr)
+{
+	if (statusr & GICV5_IRS_SAVE_VM_STATUSR_Q)
+		return 0;
+
+	return -EBUSY;
+}
+
+static int vgic_v5_irs_is_quiesced(u16 vm_id)
+{
+	u32 statusr;
+	int ret;
+
+	ret =3D vgic_v5_irs_save_vm_op(vm_id, false, &statusr);
+	if (ret)
+		return ret;
+
+	return vgic_v5_irs_status_is_quiesced(statusr);
+}
+
+static int vgic_v5_copy_ist_attr(struct kvm_device_attr *attr,
+				 struct kvm_vgic_v5_ist *ist_attr)
+{
+	void __user *uaddr =3D (void __user *)(unsigned long)attr->addr;
+
+	if (!uaddr)
+		return -EINVAL;
+
+	if (copy_from_user(ist_attr, uaddr, sizeof(*ist_attr)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int vgic_v5_validate_ist_user_buffer(__u64 addr, __u64 size,
+					    size_t expected)
+{
+	if (!addr || size !=3D expected)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vgic_v5_validate_ist_attr(struct kvm *kvm,
+				     const struct kvm_vgic_v5_ist *ist_attr)
+{
+	unsigned int id_bits;
+	int ret;
+
+	/* We always have SPIs to save */
+	ret =3D vgic_v5_validate_ist_user_buffer(ist_attr->spi_ist_addr,
+					ist_attr->spi_ist_size,
+					kvm->arch.vgic.nr_spis * sizeof(__u32));
+	if (ret)
+		return ret;
+
+	/* We don't always have LPIs to save */
+	ret =3D vgic_v5_irs_lpi_ist_id_bits(kvm, &id_bits);
+	if (ret < 0)
+		return ret;
+
+	/* No LPI IST */
+	if (!ret) {
+		if (ist_attr->lpi_ist_addr || ist_attr->lpi_ist_size)
+			return -EINVAL;
+
+		return 0;
+	}
+
+	return vgic_v5_validate_ist_user_buffer(ist_attr->lpi_ist_addr,
+					       ist_attr->lpi_ist_size,
+					       BIT(id_bits) * sizeof(__u32));
+}
+
+int vgic_v5_irs_save_ists(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_vgic_v5_ist ist_attr;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	u32 statusr;
+	int ret =3D 0;
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_trylock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (!vgic_initialized(kvm)) {
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	ret =3D vgic_v5_copy_ist_attr(attr, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_validate_ist_attr(kvm, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_irs_save_vm_op(vm_id, true, &statusr);
+	if (ret) {
+		kvm_err("Failed to save GICv5 IRS VM state: %d\n", ret);
+		goto out_unlock;
+	}
+
+	ret =3D vgic_v5_irs_status_is_quiesced(statusr);
+	if (ret)
+		goto out_unlock;
+
+	/* Save the SPI IST to the userspace buffer. */
+	ret =3D vgic_v5_save_spi_ist(kvm, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_irs_is_quiesced(vm_id);
+	if (ret)
+		goto out_unlock;
+
+	/* Save the LPI IST to the userspace buffer. */
+	ret =3D vgic_v5_save_lpi_ist(kvm, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_irs_is_quiesced(vm_id);
+	if (ret)
+		goto out_unlock;
+
+out_unlock:
+	mutex_unlock(&kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
+
+/* Allocate the LPI IST to restore into */
+static int vgic_v5_restore_lpi_ist_alloc(struct kvm *kvm, bool *allocated)
+{
+	unsigned int id_bits;
+	int ret;
+
+	*allocated =3D false;
+
+	ret =3D vgic_v5_irs_lpi_ist_id_bits(kvm, &id_bits);
+	if (ret <=3D 0)
+		return ret;
+
+	ret =3D vgic_v5_lpi_ist_alloc(kvm, id_bits);
+	if (ret)
+		return ret;
+
+	*allocated =3D true;
+
+	return 0;
+}
+
+/*
+ * Clean up the LPI IST if we allocated it, and restore the VMTE to the
+ * original, valid state.
+ */
+static void vgic_v5_restore_cleanup(struct kvm *kvm,
+				    struct kvm_vcpu *vcpu,
+				    bool lpi_ist_allocated)
+{
+	/*
+	 * We are on the restore failure path, so we do a best-effort
+	 * cleanup. These commands might fail, but at this stage this is the
+	 * best we can realistically do.
+	 */
+	if (lpi_ist_allocated) {
+		if (!vgic_v5_send_command(vcpu, VMTE_MAKE_INVALID))
+			vgic_v5_lpi_ist_free(kvm);
+	}
+
+	vgic_v5_send_command(vcpu, VMTE_MAKE_VALID);
+}
+
+int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr=
)
+{
+	bool lpi_ist_allocated =3D false, vmte_invalid =3D false;
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	struct kvm_vgic_v5_ist ist_attr;
+	int ret =3D 0;
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_trylock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (!vgic_initialized(kvm)) {
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	if (kvm_vm_has_ran_once(kvm)) {
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	ret =3D vgic_v5_copy_ist_attr(attr, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_validate_ist_attr(kvm, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_lpi_ist_exists(kvm);
+	if (ret) {
+		if (ret > 0)
+			ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	/*
+	 * If the guest has previously allocated an IST (which we check based on
+	 * the IRS_IST_BASER), extract the number of LPI ID bits from the
+	 * IRS_IST_CFGR. Else, do nothing.
+	 *
+	 * We do this before making the VMTE invalid as we rely on
+	 * IRS_VMAP_VISTR to mark the IST as valid in the VMTE. This can only
+	 * happen while the VMTE is valid.
+	 */
+	ret =3D vgic_v5_restore_lpi_ist_alloc(kvm, &lpi_ist_allocated);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Host ISTs are updated while the VMTE is invalid, so the GIC cannot
+	 * observe partially restored state.
+	 */
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
+	if (ret) {
+		/*
+		 * If invalidation fails, the restore cannot safely update host
+		 * IST state.
+		 */
+		goto out_unlock;
+	}
+	vmte_invalid =3D true;
+
+	/* Restore the SPI IST from the userspace buffer. */
+	ret =3D vgic_v5_restore_spi_ist(kvm, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	/* Restore the LPI IST from the userspace buffer. */
+	if (lpi_ist_allocated) {
+		ret =3D vgic_v5_restore_lpi_ist(kvm, &ist_attr);
+		if (ret)
+			goto out_unlock;
+	}
+
+	/* And make the VM Valid again */
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_VALID);
+	if (ret)
+		goto out_unlock;
+	vmte_invalid =3D false;
+
+	/*
+	 * As part of restoring the ISTs, and previously pending interrupts have
+	 * been tracked and made non-pending. Now that the ISTs have been
+	 * restored, and the VM is valid again, restore the pending interrupts.
+	 */
+	ret =3D vgic_v5_restore_pending_irqs(kvm);
+	if (ret)
+		goto out_unlock;
+
+out_unlock:
+	if (ret && (vmte_invalid || lpi_ist_allocated)) {
+		vgic_v5_discard_pending_irqs(kvm);
+		vgic_v5_restore_cleanup(kvm, vcpu0, lpi_ist_allocated);
+	}
+
+	mutex_unlock(&kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 7536e9a13086e..cb673da96ec55 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -373,6 +373,8 @@ void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
 void vgic_v5_set_spi_ops(struct vgic_irq *irq);
+bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags);
 void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
@@ -384,11 +386,14 @@ void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcr);
 void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
 int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
+int vgic_v5_irs_lpi_ist_id_bits(struct kvm *kvm, unsigned int *id_bits);
=20
 int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
 const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+int vgic_v5_irs_save_ists(struct kvm *kvm, struct kvm_device_attr *attr);
+int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr=
);
 int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
 				 struct kvm_device_attr *attr,
 				 u64 *reg, bool is_write);
--=20
2.34.1
